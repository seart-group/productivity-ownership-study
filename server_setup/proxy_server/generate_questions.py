from openai import OpenAI
import pathlib
import random


OPENAI_KEY_FILE = "apikey.txt"
MODEL_O1 = "o1"
MODEL_GPT_4O_MINI = "gpt-4o-mini"
PROMPT_DEVELOPMENT_FILE = "prompts/prompt-gpt-development.txt"
PROMPT_DEVELOPMENT_FILE_ITALIAN = "prompts/prompt-gpt-development-italian.txt"
PROMPT_DEVELOPMENT_FILE_MASTER_<U2> = "prompts/prompt-gpt-development-master-<U2>.txt"
PROMPT_EVOLUTION_FILE = "prompts/prompt-gpt-evolution.txt"
PROMPT_EVOLUTION_FILE_ITALIAN = "prompts/prompt-gpt-evolution-italian.txt"
PROMPT_EVOLUTION_FILE_MASTER_<U2> = "prompts/prompt-gpt-evolution-master-<U2>.txt"
PROMPT_TRANSLATION_FILE = "prompts/prompt-gpt-translation.txt"
QUESTION_ANSWER_SEP = ["ANSWER TO THE QUESTION:", "RISPOSTA ALLA DOMANDA:"]


openai_key = ''.join([line.strip() for line in open(OPENAI_KEY_FILE)]).strip()
client = OpenAI(api_key=openai_key)


def ask_chatgpt_to_generate_questions(code, task_description, diff=None, natural_language=None):
    if diff:
        if natural_language == "Italian-all":
            prompt = pathlib.Path(PROMPT_EVOLUTION_FILE_ITALIAN).read_text()
        elif natural_language == "Master-<U2>":
            prompt = pathlib.Path(PROMPT_EVOLUTION_FILE_MASTER_<U2>).read_text()
        else:
            prompt = pathlib.Path(PROMPT_EVOLUTION_FILE).read_text()
        prompt = prompt.replace('{{diff}}', diff)
    else:
        if natural_language == "Italian-all":
            prompt = pathlib.Path(PROMPT_DEVELOPMENT_FILE_ITALIAN).read_text()
        elif natural_language == "Master-<U2>":
            prompt = pathlib.Path(PROMPT_DEVELOPMENT_FILE_MASTER_<U2>).read_text()
        else:
            prompt = pathlib.Path(PROMPT_DEVELOPMENT_FILE).read_text()
    prompt = prompt.replace('{{code}}', code).replace('{{task}}', task_description)

    response = client.chat.completions.create(
        model=MODEL_O1,
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt}
        ],
    )

    return response.choices[0].message.content


def process_chatgpt_reply(reply):
    reply_lines = reply.split("\n")
    line_questions = []
    open_questions = []
    for i in range(len(reply_lines)):
        line = reply_lines[i]
        line_sep = QUESTION_ANSWER_SEP[0]
        for sep in QUESTION_ANSWER_SEP:
            if sep in line:
                line_sep = sep
                break
        if line.startswith(("1.", "2.", "3.", "4.", "5.", "6.")):
            line_questions.append(line.split(line_sep)[0].strip())
        if line.startswith(("7.", "8.", "9.")):
            open_questions.append(line.split(line_sep)[0].strip())
    random.shuffle(line_questions)
    random.shuffle(open_questions)
    return update_numbering(line_questions + open_questions)


def update_numbering(questions):
    updated_questions = []
    for i, question in enumerate(questions):
        updated_questions.append(f"{i + 1}. {'.'.join(question.split('.')[1:]).strip()}")
    return updated_questions


def ask_chatgpt_to_translate_questions(questions, natural_language):
    prompt = pathlib.Path(PROMPT_TRANSLATION_FILE).read_text()
    prompt = prompt.replace('{{language}}', natural_language).replace('{{questions}}', '\n'.join(questions))

    response = client.chat.completions.create(
        model=MODEL_GPT_4O_MINI,
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt}
        ],
    )
    
    return response.choices[0].message.content


def process_translation(reply):
    reply_lines = [_ for _ in reply.split("\n") if _.strip() != '']
    translated_questions = []
    for line in reply_lines:
        if line.startswith(("1.", "2.", "3.", "4.", "5.", "6.", "7.", "8.", "9.")):
            translated_questions.append(line.strip())
    return translated_questions
