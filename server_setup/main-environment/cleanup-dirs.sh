#!/bin/bash

# This script SHOULD NOT BE EXECUTED, unless you want to cleanup the environment.

if [ ! -d "user-data" ]; then
    echo "The working directory should be the one that contains the user-data folder."
    exit 1
fi

echo "Are you sure you want to cleanup ALL the experimental data? (y/N)"
read -r answer
[[ "${answer,,}" != y* ]] && exit 0

echo "Really, REALLY sure? (y/N)"
read -r answer
[[ "${answer,,}" != y* ]] && exit 0

for dir in user-data/*/; do
    sudo rm -r "${dir}home"
    sudo chown -R "$USER":"$USER" "${dir}"
    sudo chmod -R 775 "${dir}"
    echo "Deleted folder for ${dir}"
done
