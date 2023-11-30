#!/usr/bin/env bash
# Last modified: 2023 Nov 30

# This script is executed after the creation of the project's development container.
# It performs the following tasks:

if false; then
  echo " "
  echo "==================="
  echo "run post-create-command.sh"
  echo "-------------------"

  project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" 
fi

