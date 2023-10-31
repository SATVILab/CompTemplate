#!/usr/bin/env bash
# ensure that `$HOME/.bashrc.d` files are sourced
echo "run post_create_command.sh"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)" 

echo "set up bashrc_d"
"$project_root/scripts/all/setup_bashrc_d.sh" || exit 1
echo "completed setting up bashrc_d"
echo "-------------------"

# add config_r.sh to be sourced if 
# it's not already present
echo "add config_r.sh to be sourced if it's not already present"
if ! [ -e "$HOME/.bashrc.d/config_r.sh" ]; then
  echo "config_r.sh not found, adding it"
  if ! [ -d "$HOME/.bashrc.d" ]; then mkdir -p "$HOME/.bashrc.d"; fi
  echo "copying config_r.sh to $HOME/.bashrc.d"
  cp "$project_root/scripts/all/config_r.sh" "$HOME/.bashrc.d/" || exit 1
  chmod 755 "$HOME/.bashrc.d/config_r.sh"
fi
echo "completed adding config_r.sh to be sourced if it's not already present"
echo "-------------------"

echo "installing apptainer packages"
"$project_root/scripts/ubuntu/install_apptainer.sh" || exit 1
echo "completed installing apptainer packages"
echo "-------------------"
echo "installing gh"
"$project_root/scripts/ubuntu/install_gh.sh" || exit 1
echo "completed installing gh"
echo "-------------------"
if [ -n "$(env | grep -E "^GITPOD")" ]; then
  echo "installing R on GitPod"
  sudo "$project_root/scripts/all/install_r.sh"
  echo "completed installing R on GitPod"
  echo "-------------------"
  echo "installing quarto on GitPod"
  sudo "$project_root/scripts/all/install_quarto.sh"
  echo "completed installing quarto on GitPod"
  echo "-------------------"
fi
echo "completed post_create_command"

# clone all repos
"$project_root/clone-repos.sh"
