#!/usr/bin/env bash
# Last modified: 2023 Nov 26

# This script is executed each time the container starts.
# 1. Clones all repositories in repos-to-clone.list.
# 2. Adds all repositories in repos-to-clone.list to the workspace file (EntireProject.code-workspace).

# clone all repos
echo "Cloning all repos in repos-to-clone.list"
"$project_root/.devcontainer/scripts/clone-repos.sh"

# add all repos to workspace
echo "Adding all repos in repos-to-clone.list to the workspace file (EntireProject.code-workspace)"
"$project_root/.devcontainer/scripts/add-repos.sh"
