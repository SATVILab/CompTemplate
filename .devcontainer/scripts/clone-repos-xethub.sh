#!/usr/bin/env bash
# Last modified: 2024 Jan 17

# Clones all repos in repos-to-clone-xethub.list
# into the parent directory of the current
# working directory.

# Get the absolute path of the current working directory
current_dir="$(pwd)"

# Determine the parent directory of the current directory
parent_dir="$(cd "${current_dir}/.." && pwd)"

# Function to clone a repository
clone-repo() {
    cd "${parent_dir}"
    if [ ! -d "${1#*/}" ]; then
        git xet clone --lazy "xet://${XETHUB_USERNAME}/$1"
    else 
        echo "Already cloned $1"
    fi
}

# Check if the file repos-to-clone-xethub.list exists
if [ -f "${current_dir}/repos-to-clone-xethub.list" ]
then
    # The file exists, now check if it's empty or not
    if grep -qvE '^\s*(#|$)' "${current_dir}/repos-to-clone-xethub.list"
    then
      # The file is not empty, proceed with login
        # Check if the environment variables are set and not empty
       if [ -z "$XETHUB_USERNAME" ] || [ -z "$XETHUB_EMAIL" ] || [ -z "$XETHUB_PAT" ]
       then
           echo "Error: One or more environment variables are not set. Please set XETHUB_USERNAME, XETHUB_EMAIL, and XETHUB_PAT."
           exit 1
       else
           git xet login -u "$XETHUB_USERNAME" -e "$XETHUB_EMAIL" -p "$XETHUB_PAT"
       fi
    fi
fi

# If there is a list of repositories to clone, clone them
if [ -f "./repos-to-clone-xethub.list" ]; then
    while IFS= read -r repository || [ -n "$repository" ]; do
        # Skip lines that are empty or contain only whitespace
        if [[ -z "$repository" || "$repository" =~ ^[[:space:]]*$ || "$repository" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        clone-repo "$repository"
    done < "./repos-to-clone-xethub.list"
fi
