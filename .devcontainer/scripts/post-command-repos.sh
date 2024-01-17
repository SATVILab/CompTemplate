#!/usr/bin/env bash
# Last modified: 2024 Jan 17

# 1. Clones all repositories in repos-to-clone.list.
# 2. Adds all repositories in repos-to-clone.list to the workspace file (EntireProject.code-workspace).

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" 

# clone all repos from GitHub
echo "Cloning all repos in repos-to-clone.list"
"$project_root/.devcontainer/scripts/clone-repos.sh"
echo "Cloned all repos in repos-to-clone.list"
echo "-------------------"

# lazily clone all repos from XetHub
echo "Cloning all repos in repos-to-clone-xethub.list"
"$project_root/.devcontainer/scripts/clone-repos-xethub.sh"
echo "Cloned all repos in repos-to-clone-xethub.list"
echo "-------------------"

# add all repos to workspace
echo "Adding all repos in repos-to-clone.list to the workspace file (EntireProject.code-workspace)"
"$project_root/.devcontainer/scripts/add-repos.sh"
echo "Added all repos"
echo "-------------------"
