#!/usr/bin/env bash
# Last modified: 2024 Jan 11

# 1. Installs `xet` cli
# 2. Authenticates to XetHub (if credentials are available)

echo " "
echo "==================="
echo "configure xet"
echo "-------------------"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" 

# install xet
"$project_root/.devcontainer/scripts/install-xet.sh"

# authenticate to xethub
"$project_root/.devcontainer/scripts/authenticate-xethub.sh"
