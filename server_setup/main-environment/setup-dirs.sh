#!/bin/bash

# This script does not need to be executed, it just sets the environment up.

for i in {1..50}; do
  dir="user-data/user$i"
  mkdir -p "$dir"
  echo "      - ./$dir:/home/user$i/"
  echo "home" > "$dir/.gitignore"
done