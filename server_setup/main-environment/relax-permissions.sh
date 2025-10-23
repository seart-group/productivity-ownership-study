#!/bin/bash

# This script should be executed only when the Docker container is stopped.
# It will change the permissions of all user files to make them readable and
# writable from the host machine.

if [ ! -d "user-data" ]; then
    echo "The working directory should be the one that contains the user-data folder."
    exit 1
fi

read -r -p "Have you checked that the Docker containers are NOT running? (y/N) " answer
[[ "${answer,,}" != y* ]] && exit 0

read -r -p "Are you sure you want to change permissions for all user folders? (y/N) " answer
[[ "${answer,,}" != y* ]] && exit 0

for dir in user-data/*/; do
    sudo chown -R "$USER:$USER" "$dir"
    sudo chmod -R 775 "$dir"
    echo "Done for folder ${dir}"
done