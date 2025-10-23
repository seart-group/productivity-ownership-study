import os
import subprocess
import requests
import pathlib
import shutil
from datetime import datetime


DIFF_CMD = "git diff --no-index"
PER_FILE_DIFF = "diff --git "
VSCODE_SETTINGS_FILE=os.path.expanduser("~/.vscode-server/data/Machine/settings.json")
VSCODE_EXTENSIONS_PATH = os.path.expanduser("~/.vscode-server/extensions/")
COPILOT_SETTINGS_1="*"
COPILOT_SETTINGS_2="github.copilot.editor.enableAutoCompletions"
SERVER_URL = "http://openaiapi:5000/response"


def disable_copilot():
    # Disable completions
    if os.path.exists(VSCODE_SETTINGS_FILE):
        settings = pathlib.Path(VSCODE_SETTINGS_FILE).read_text()
        if COPILOT_SETTINGS_1 in settings or COPILOT_SETTINGS_2 in settings:
            settings = settings.replace(f'"{COPILOT_SETTINGS_1}": true', f'"{COPILOT_SETTINGS_1}": false')
            settings = settings.replace(f'"{COPILOT_SETTINGS_2}": true', f'"{COPILOT_SETTINGS_2}": false')
            pathlib.Path(VSCODE_SETTINGS_FILE).write_text(settings)
            print("Copilot suggestions disabled.")
        else:
            print("Copilot suggestions not found in settings file.")
    else:
        print(f"Settings file {VSCODE_SETTINGS_FILE} not found.")

    # Remove extensions
    for item in os.listdir(VSCODE_EXTENSIONS_PATH):
        if item.startswith("github.copilot"):
            item_path = os.path.join(VSCODE_EXTENSIONS_PATH, item)
            if os.path.isdir(item_path):
                try:
                    shutil.rmtree(item_path)
                    print(f"Removed Copilot extension directory: {item_path}")
                except Exception as e:
                    print(f"Error removing {item_path}: {e}")
            else:
                print(f"Skipping non-directory item: {item_path}")


def collect_code(path_folder_files, language):
    code_file_names = collect_file_names(path_folder_files, language)
    code = ''
    for file in code_file_names:
        code += file + ':\n\n```\n'
        code += pathlib.Path(path_folder_files, file).read_text()
        code += '\n```\n\n'
    return code


def collect_code_diffs(path_folder_files, path_folder_original_files, language):
    result = subprocess.run(DIFF_CMD.split() + [path_folder_original_files, path_folder_files], capture_output=True, text=True)

    code_diff = result.stdout.strip()
    file_extensions = get_file_extensions(language)
    # Need to discard all diffs on files that are not code files. For this, we analyze the output of
    # the diff line by line. If a line starts with PER_FILE_DIFF, we know that a new file diff is
    # starting. If such line ends with ".<file_extension>", we know that the diff is for a code file,
    # so we add all lines until the next PER_FILE_DIFF. Otherwise, we keep discarding all lines until
    # the next PER_FILE_DIFF
    relevant_diff = ''
    is_relevant = False
    for diff_line in code_diff.split("\n"):
        if diff_line.startswith(PER_FILE_DIFF):
            if any(diff_line.endswith(ext) for ext in file_extensions):
                is_relevant = True
                relevant_diff += diff_line + "\n"
            else:
                is_relevant = False
        elif is_relevant:
            relevant_diff += diff_line + "\n"

    return relevant_diff


def collect_file_names(path_folder_files, language):
    file_extensions = get_file_extensions(language)
    code_file_names = []
    
    # Walk through directory tree recursively
    for root, _, files in os.walk(path_folder_files):
        for file in files:
            if any(file.endswith(ext) for ext in file_extensions):
                # Get relative path from the base directory
                rel_path = os.path.relpath(os.path.join(root, file), path_folder_files)
                code_file_names.append(rel_path)
    
    return code_file_names


def get_file_extensions(language):
    if language.lower() == 'java':
        file_extension = ['.java']
    elif language.lower() == 'python':
        file_extension = ['.py']
    elif language.lower() == 'c':
        file_extension = ['.c', '.h']
    return file_extension


def save_content_to_file(content, file):
    with open(file, "w") as f:
        f.write(content)


def make_request(code, diff, task, task_description, natural_language):
    user = os.getenv("USER", "default_user")
    data = {
        "code": code,
        "diff": diff,
        "natural_language": natural_language,
        "task": task,
        "task_description": task_description,
        "user": user
    }
    response = requests.post(SERVER_URL, json=data)
    return response


def save_questions(questions, questions_translated, questions_path, questions_translated_path):
    save_content_to_file(questions, questions_path)
    if questions_translated:
        save_content_to_file(questions_translated, questions_translated_path)


# Note: natural_language is also used to change the prompt used
def main(task, language, natural_language):
    # Check arguments
    if task not in ["development", "evolution"]:
        raise ValueError("Invalid task")
    if language not in ["Java", "Python", "C"]:
        raise ValueError("Invalid language")
    if natural_language and natural_language not in ["Spanish", "Italian", "Italian-all", "<Master-U2>"]:
        raise ValueError("Invalid natural language")
    
    # Check if current dir is /home or /{task}/modified
    current_dir = pathlib.Path.cwd().name
    if current_dir != "modified" and current_dir != "home":
        raise ValueError(f"This script should be run from the /home or /{task}/modified directory")
    current_dir_is_home = current_dir == "home"

    # Set variables
    if current_dir_is_home:
        path_prefix = f"./{task}"
    else:
        path_prefix = "."
    task_path = f"{path_prefix}/task.txt"
    questions_path = f"{path_prefix}/questions.txt"
    questions_translated_path = f"{path_prefix}/questions_translated.txt"
    task_description = pathlib.Path(task_path).read_text()

    # Main logic
    if not current_dir_is_home:
        original_code_path = "../original"
        modified_code_path = "."
        code_diff = collect_code_diffs(modified_code_path, original_code_path, language)
    elif task == "development":
        modified_code_path = f"./{task}"
        code_diff = None
    else:
        original_code_path = f"./{task}/original"
        modified_code_path = f"./{task}/modified"
        code_diff = collect_code_diffs(modified_code_path, original_code_path, language)
    code = collect_code(modified_code_path, language)
    response = make_request(code, code_diff, task, task_description, natural_language)
    if response.status_code != 200:
        raise ValueError("Error generating the questions. Probably you executed this script more than once. Error:\n" + response.text)
    response_data = response.json()
    questions = response_data["questions"]
    questions_translated = response_data["questions_translated"] if natural_language and natural_language not in ["Italian-all", "<Master-U2>"] else None
    save_questions(questions, questions_translated, questions_path, questions_translated_path)
    disable_copilot()
    print("Questions ready!")