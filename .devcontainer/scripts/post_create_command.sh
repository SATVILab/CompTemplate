#!/usr/bin/env bash
# ensure that `$HOME/.bashrc.d` files are sourced
echo "run post_create_command.sh"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" 

echo "set up bashrc_d"
"$project_root/.devcontainer/scripts/setup_bashrc_d.sh" || exit 1
echo "completed setting up bashrc_d"
echo "-------------------"

# add config_r.sh to be sourced if 
# it's not already present
echo "add config_r.sh to be sourced if it's not already present"
if ! [ -e "$HOME/.bashrc.d/config_r.sh" ]; then
  echo "config_r.sh not found, adding it"
  if ! [ -d "$HOME/.bashrc.d" ]; then mkdir -p "$HOME/.bashrc.d"; fi
  echo "copying config_r.sh to $HOME/.bashrc.d"
  cp "$project_root/.devcontainer/scripts/config_r.sh" "$HOME/.bashrc.d/" || exit 1
  chmod 755 "$HOME/.bashrc.d/config_r.sh"
fi
echo "completed adding config_r.sh to be sourced if it's not already present"
"$HOME/.bashrc.d/config_r.sh"
echo "Sourced config_r.sh"
echo "-------------------"

# adjust vs code r.libPaths setting
echo "adjust vs code r.libPaths setting"
"$project_root/.devcontainer/scripts/config_r_vscode.sh"
echo "completed adjusting vs code r.libPaths setting"

# clone all repos
"$project_root/clone-repos.sh"
