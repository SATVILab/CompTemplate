#!/usr/bin/env bash
# ensure that `$HOME/.bashrc.d` files are sourced
./scripts/all/setup_bashrc_d.sh
# add config_r.sh to be sourced if 
# it's not already present
if ! [ -e "$HOME/.bashrc.d/config_r.sh" ]; then
  cp ./scripts/all/config_r.sh "$HOME/.bashrc.d/"
fi
#if [ -n "$(env | grep -E "^GITPOD")" ]; then
# install tools to run and download containers
./scripts/ubuntu/install_apptainer.sh
./scripts/ubuntu/install_gh.sh
#fi

sudo ./scripts/all/install_r.sh

sudo ./scripts/all/install_quarto.sh

# clone all repos
./clone-repos.sh
