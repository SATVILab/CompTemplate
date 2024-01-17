#!/usr/bin/env bash
# Last modified: 2024 Jan 17

# This script is used to add repositories to a workspace JSON file,
# which can be used to open all repos in a multi-root VS Code workspace.
# It reads a list of repositories from "repos-to-clone.list"
# and adds them to the workspace JSON file.

# Get the absolute path of the current working directory
current_dir="$(pwd)"

# Define the path to the workspace JSON file
workspace_file="${current_dir}/EntireProject.code-workspace"

# Create the workspace file if it does not exist
if [ ! -f "$workspace_file" ]; then
  echo "Workspace file does not exist. Creating it now..."
  echo '{"folders": [{"path": "."}]}' > "$workspace_file"
fi

add_to_workspace() {

  # Read and process each line from the input file
  while IFS= read -r repo || [ -n "$repo" ]; do

    # Skip lines that are empty, contain only whitespace, or start with a hash
    if [[ -z "$repo" || "$repo" =~ ^[[:space:]]*# || "$repo" =~ ^[[:space:]]+$ ]]; then
      continue
    fi

    # Extract the repository name and create the path
    repo_name="${repo##*/}"
    repo_path="../$repo_name"

    # Check if the path is already in the workspace file
    if jq -e --arg path "$repo_path" '.folders[] | select(.path == $path) | length > 0' "$workspace_file" > /dev/null; then
      continue
    fi

    # Add the path to the workspace JSON file
    jq --arg path "$repo_path" '.folders += [{"path": $path}]' "$workspace_file" > temp.json && mv temp.json "$workspace_file"
  done < "$1"
}

# Attempt to add from these files if they exist
if [ -f "./repos-to-clone.list" ]; then
  add_to_workspace "./repos-to-clone.list"
fi

if [ -f "./repos-to-clone-xethub.list" ]; then
  add_to_workspace "./repos-to-clone-xethub.list"
fi
