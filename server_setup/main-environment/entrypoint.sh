#!/bin/bash

trap 'echo "Error: $BASH_COMMAND at $BASH_SOURCE:$LINENO"; exit 1' ERR

update_permissions() {
    i=$1
    chown -R "user$i":"$ADMIN_GROUP" "$STUDY_DIR/user$i"
    chmod -R 770 "$STUDY_DIR/user$i"
    if [ -d "$STUDY_DIR/user$i/home/development" ] || [ -d "$STUDY_DIR/user$i/home/evolution" ]; then
        chmod 550 "$STUDY_DIR/user$i/home/get_questions.py"
        chmod 550 "$STUDY_DIR/user$i/home/get_questions_evolution"*
        chmod 550 "$STUDY_DIR/user$i/home/get_questions_development"*
        chmod 440 "$STUDY_DIR/user$i/home/development/task.txt"
        chmod 440 "$STUDY_DIR/user$i/home/evolution/task.txt"
        chmod -R 550 "$STUDY_DIR/user$i/home/evolution/original"
        # Needed for US Bachelor task:
        chmod 550 "$STUDY_DIR/user$i/home/development/modified/get_questions.py"
        chmod 550 "$STUDY_DIR/user$i/home/development/modified/get_questions_development.py"
        chmod 550 "$STUDY_DIR/user$i/home/evolution/modified/get_questions.py"
        chmod 550 "$STUDY_DIR/user$i/home/evolution/modified/get_questions_evolution.py"
        chmod -R 550 "$STUDY_DIR/user$i/home/development/original"
        chmod 440 "$STUDY_DIR/user$i/home/development/modified/task.txt"
        chmod 440 "$STUDY_DIR/user$i/home/evolution/modified/task.txt"

        # If the file 'questions.txt' exists under any task folder, it means
        # that task was already completed, so make folder read-only
        if [ -f "$STUDY_DIR/user$i/home/development/questions.txt" ]; then
            chmod -R 550 "$STUDY_DIR/user$i/home/development"
        fi
        if [ -f "$STUDY_DIR/user$i/home/evolution/questions.txt" ]; then
            chmod -R 550 "$STUDY_DIR/user$i/home/evolution"
        fi
    else
        echo "Notice: Task files missing for user$i!"
    fi
}

apply_template() {
    i=$1
    cp -r "$STUDY_DIR/template/.cache" "$STUDY_DIR/user$i/home"
    cp -r "$STUDY_DIR/template/.config" "$STUDY_DIR/user$i/home"
    cp -r "$STUDY_DIR/template/.dotnet" "$STUDY_DIR/user$i/home"
    cp -r "$STUDY_DIR/template/.vscode-server" "$STUDY_DIR/user$i/home"
    cp -r "$STUDY_DIR/template/.vscode" "$STUDY_DIR/user$i/home"
    cp -r "$STUDY_DIR/template/.bashrc" "$STUDY_DIR/user$i/home"
    cp -r "$STUDY_DIR/template/python-client-deps/"* "$STUDY_DIR/user$i/home/venv/lib/python3.12/site-packages/"

    # Need to update content of settings.json and extensions.json
    vscode_settings="$STUDY_DIR/user$i/home/.vscode-server/data/Machine/settings.json"
    vscode_extensions="$STUDY_DIR/user$i/home/.vscode-server/extensions/extensions.json"
    sed -i "s|$TO_CHANGE|/user$i/home/|g" $vscode_settings
    sed -i "s|$TO_CHANGE|/user$i/home/|g" $vscode_extensions
}

setup_user() {
    i=$1
    create_home=$2

    if [ $create_home = true ]; then
        useradd -m -d "$STUDY_DIR/user$i/home" -s /bin/bash user$i
    else
        useradd -d "$STUDY_DIR/user$i/home" -s /bin/bash user$i
    fi

    user_pwd=$(echo -n "user${i}icse26" | sha256sum | head -c 13)
    echo "user$i:$user_pwd" | chpasswd
    usermod -aG $COMMON_GROUP user$i
}

for i in $(seq 1 $N_USERS)
do
    if [ -d "$STUDY_DIR/user$i/home" ]; then
        if [ -f "$STUDY_DIR/user$i/home/setup-done" ]; then
            setup_user $i false

            echo "User $i already set-up. Keeping previously-existing folder and changing permissions..."

            update_permissions $i
            continue;
        else
            echo "Removing previously-existing home folder for user$i (probably, incomplete setup)"
            rm -rf "$STUDY_DIR/user$i/home"
        fi
    fi

    setup_user $i true
    python3.12 -m venv $STUDY_DIR/user$i/home/venv
    apply_template $i
    update_permissions $i
    echo "User user$i correctly created!"
    touch $STUDY_DIR/user$i/home/setup-done
done

chown -R root:$COMMON_GROUP "$COMMON_DIR"
chmod -R 770 "$COMMON_DIR"

echo "ICSE26 study server up and running!"
# Starts the SSH daemon
service ssh restart -D
