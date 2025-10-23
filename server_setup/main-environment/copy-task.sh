#!/bin/bash

# This script receives three arguments: the first is "development" or
# "evolution"; the second is the folder containing the tasks (development +
# evolution + other scripts) to copy and paste into user folders; the third
# is a file containing user names, one per line. The script will copy the task
# folder and scripts into each user home folder.
# Example usage:
# ./copy-task.sh development ../../tasks/bachelor-<U1>/ user-configs/users-bachelor-<U1>-a-1.txt

ROOT_DIR="user-data"
if [ ! -d "$ROOT_DIR" ]; then
    echo "Root directory not found"
    exit 1
fi

# Arguments checks
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <development/evolution> <task-folder> <user-list>"
    exit 1
fi
if [ "$1" != "development" ] && [ "$1" != "evolution" ]; then
    echo "First argument must be 'development' or 'evolution'"
    exit 1
fi
if [ ! -d "$2" ]; then
    echo "Task folder not found"
    exit 1
fi
if [ ! -f "$3" ]; then
    echo "User list not found"
    exit 1
fi
if [[ "$3" == *"-a-1.txt" ]] || [[ "$3" == *"-b-1.txt" ]] || [[ "$3" == *"-c-2.txt" ]] || [[ "$3" == *"-d-2.txt" ]]; then
    session_group="ai"
elif [[ "$3" == *"-a-2.txt" ]] || [[ "$3" == *"-b-2.txt" ]] || [[ "$3" == *"-c-1.txt" ]] || [[ "$3" == *"-d-1.txt" ]]; then
    session_group="no-ai"
else
    echo "ERROR: User list file name must end with '-a-1.txt', '-b-1.txt', '-a-2.txt', '-b-2.txt', '-c-1.txt', '-d-1.txt', '-c-2.txt', or '-d-2.txt'"
    exit 1
fi

TASK=$1
TASK_FOLDER=${2%/}
USER_LIST=$3

# Copy task folder and scripts into each user home folder
users=$(cat "$USER_LIST")
for user in $users; do
    if [ ! -d "$ROOT_DIR/$user/home" ]; then
        echo "User $user not found"
        continue
    fi

    cp -r "$TASK_FOLDER/$TASK" "$ROOT_DIR/$user/home"
    cp "$TASK_FOLDER/get_questions.py" "$ROOT_DIR/$user/home"
    cp "$TASK_FOLDER/get_questions_${TASK}"* "$ROOT_DIR/$user/home"

    # If session_group is "no-ai", remove Copilot-related plugins from .vscode-server/extensions/extensions.json
    EXT_FILE="$ROOT_DIR/$user/home/.vscode-server/extensions/extensions.json"
    if [ "$session_group" == "no-ai" ]; then
        if [ -f "$EXT_FILE" ]; then
            sed -i 's|github.copilot-|wrong-github.copilot-|g' "$EXT_FILE"
        else
            echo "Warning: Extensions file not found for user $user"
        fi
    fi
done