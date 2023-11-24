#!/usr/bin/env bash

# Get the absolute path of the current working directory
current_dir="$(pwd)"

# Define the path to the workspace JSON file
workspace_file="${current_dir}/EntireProject.code-workspace"
echo $workspace_file
cat $workspace_file

# Create the workspace file if it does not exist
if [ ! -f "$workspace_file" ]; then
    echo "Workspace file does not exist. Creating it now..."
    echo '{"folders": [{"path": "."}]}' > "$workspace_file"
fi

# Read and process each line from repos-to-clone.list
while IFS= read -r repo || [ -n "$repo" ]; do
    echo $repo
    # Skip empty lines
    if [[ -z "$repo" || "$repo" =~ ^[[:space:]]*$ ]]; then
        continue
    fi


    # Extract the repository name and create the path
    repo_name="${repo##*/}"
    repo_path="../$repo_name"

    echo $repo_name
    echo $repo_path

    # Check if the path is already in the workspace file
    if jq -e --arg path "$repo_path" '.folders[] | select(.path == $path) | length > 0' "$workspace_file" > /dev/null; then
        continue
    fi

    # Add the path to the workspace JSON file
    jq --arg path "$repo_path" '.folders += [{"path": $path}]' "$workspace_file" > temp.json && mv temp.json "$workspace_file"
done < "./repos-to-clone.list"

