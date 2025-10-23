#!/bin/bash

VSCODE_PLUGINS=(
    "vscjava.vscode-java-pack"              # Java support
    "vmware.vscode-boot-dev-pack"           # Spring support
    "ms-python.python"                      # Python support
    "ms-vscode.cpptools-extension-pack"     # C/C++ support
    "github.copilot"                        # Copilot
    # "github.copilot-chat"                   # Copilot chat
    "codelounge.tako"                       # User tracking
    "n3rds-inc.time"                        # Time tracking
    "iceworks-team.iceworks-time-master"    # Time tracking
    "mathematic.vscode-pdf"                 # PDF viewer
)


cd $STUDY_DIR
useradd -m -d "$STUDY_DIR/template" -s /bin/bash template
{
    echo ""
    echo "# Setup for ICSE 2026 Study"
    echo "export JAVA_HOME=\"$JAVA_HOME\""
    echo "export MAVEN_HOME=\"$MAVEN_HOME\""
    echo "export M2_HOME=\$MAVEN_HOME"
    echo "export PATH=\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$PATH"
    echo "alias python=python3.12"
    echo "source ~/venv/bin/activate"
} >> $STUDY_DIR/template/.bashrc

# Install Visual Studio Code plugins. Unfortunately, VSC Server executable
# cannot be used from terminal, so we need to install regular VSC to
# install plugins and then move them to the VSC Server folder
cd $STUDY_DIR/template
su template -c "wget -nv -O code.tar.gz $VSCODE_URL"
su template -c "tar -xzf code.tar.gz"
su template -c "rm -f code.tar.gz"
for plugin in "${VSCODE_PLUGINS[@]}"
do
    su template -c "./VSCode-linux-x64/bin/code --install-extension $plugin"
done
su template -c "mkdir -p .vscode-server"
su template -c "mv .vscode/extensions .vscode-server" # Relocate plugins to VSC Server
su template -c "sed -i 's/\/.vscode\//\/.vscode-server\//g' .vscode-server/extensions/extensions.json" # Adapt extensions file to VSC Server
su template -c "rm -rf .vscode"
su template -c "rm -rf VSCode-linux-x64"

# Create custom settings.json for VSC Server with necessary settings:
vscode_settings_dir="$STUDY_DIR/template/.vscode-server/data/Machine"
su template -c "mkdir -p $vscode_settings_dir"
{
    echo "{"
    echo "    \"files.autoSave\": \"afterDelay\","                                              # Auto-save files
    echo "    \"files.autoSaveDelay\": 1000,"                                                   # Auto-save files
    echo "    \"python.defaultInterpreterPath\": \"$STUDY_DIR${TO_CHANGE}venv/bin/python\","    # Custom Python interpreter
    echo "    \"java.jdt.ls.java.home\": \"$JAVA_HOME\","                                       # Custom JDK
    echo "    \"java.server.launchMode\": \"Standard\","                                        # Java settings
    echo "    \"tako.dataRecordingConsent\": \"Enable\","                                       # Automatically enable Tako (doesn't seem to work)
    echo "    \"tako.minSessionSize\": 0,"                                                      # Tako: record everything
    echo "    \"github.copilot.editor.enableAutoCompletions\": true,"                           # Enable Copilot suggestions (old settings)
    echo "    \"github.copilot.enable\": {"
    echo "        \"*\": true,"
    echo "        \"plaintext\": false,"
    echo "    }"                                                                                # Enable Copilot suggestions except for plaintext
    echo "}"
} > $vscode_settings_dir/settings.json

# Create custom settings.json for the workspace to avoid Copilot completions for plaintext
vscode_workspace_dir="$STUDY_DIR/template/.vscode"
su template -c "mkdir -p $vscode_workspace_dir"
{
    echo "{"
    echo "    \"github.copilot.enable\": {"
    echo "        \"plaintext\": false"
    echo "    }"
    echo "}"
} > $vscode_workspace_dir/settings.json

# Download Python dependencies for later copy-pasting
su template -c "mkdir python-client-deps"
su template -c "pip install --target=python-client-deps -r /requirements-client.txt"

echo "Template created"
