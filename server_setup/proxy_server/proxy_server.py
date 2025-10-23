from flask import Flask, request, jsonify
from datetime import datetime
import json
import os
from generate_questions import *


SERVER_LOGS_DIR="data/server_logs"
OPENAI_LOGS_DIR="data/openai_logs"


if not os.path.exists(SERVER_LOGS_DIR):
    os.makedirs(SERVER_LOGS_DIR)
if not os.path.exists(OPENAI_LOGS_DIR):
    os.makedirs(OPENAI_LOGS_DIR)


app = Flask(__name__)

# Simple daily request tracker: {(user, task, date): True}
daily_requests = {}

required_fields = ["code", "task", "task_description", "user"]
valid_natural_languages = ["Spanish", "Italian", "Italian-all", "Master-<U2>"]
valid_tasks = ["development", "evolution"]
def validate_fields(data):
    # Validate required fields
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    # Validate enum fields
    if "natural_language" in data and data["natural_language"] != None and data["natural_language"] not in valid_natural_languages:
        return jsonify({"error": f"Invalid natural language: {data['natural_language']}. Valid options: {', '.join(valid_natural_languages)}"}), 400
    if data["task"] not in valid_tasks:
        return jsonify({"error": f"Invalid task: {data['task']}. Valid options: {', '.join(valid_tasks)}"}), 400

    return None

@app.route("/response", methods=["POST"])
def handle_response():
    """Expected JSON input:
    {
        "code": "string",
        "diff": "string" | null, # Optional
        "natural_language": ["Spanish", "Italian", "Italian-all", "Master-<U2>"] | null, # Optional
        "task": ["development", "evolution"],
        "task_description": "string",
        "user": "string"
    }
    """
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON"}), 400

    # Validate fields
    validation_error = validate_fields(data)
    if validation_error:
        return validation_error
    
    # Extract data
    code = data["code"]
    diff = data.get("diff", None)
    natural_language = data.get("natural_language", None)
    task = data["task"]
    task_description = data["task_description"]
    user = data["user"]

    # Enforce per-day request limit
    now = datetime.now()
    now_str = now.strftime("%Y-%m-%dT%H-%M-%S-%f")
    today_str = now.strftime("%Y-%m-%d")
    key = (user, task, today_str)
    if key in daily_requests:
        return jsonify({"error": "Error"}), 429 # Purposely vague to avoid leaking information
    daily_requests[key] = True

    # Log the request
    save_content_to_file(json.dumps(data, indent=4, ensure_ascii=False), f"{SERVER_LOGS_DIR}/{user}-{task}-{now_str}.log")

    # Call OpenAI API
    questions_response = ask_chatgpt_to_generate_questions(code, task_description, diff, natural_language)
    save_content_to_file(questions_response, f"{OPENAI_LOGS_DIR}/{user}-{task}-{now_str}.log")
    questions = process_chatgpt_reply(questions_response)
    if natural_language and natural_language not in ["Italian-all", "Master-<U2>"]:
        questions_translated_response = ask_chatgpt_to_translate_questions(questions, natural_language)
        questions_translated = process_translation(questions_translated_response)

    # Return response
    response = {
        "questions": '\n'.join(questions),
        "questions_translated": '\n'.join(questions_translated) if natural_language and natural_language not in ["Italian-all", "Master-<U2>"] else None
    }
    return jsonify(response), 200


def save_content_to_file(content, file):
    with open(file, "w") as f:
        f.write(content)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
