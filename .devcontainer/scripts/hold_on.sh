  # add config_r_vscode.sh to be sourced if 
  # it's not already present
  echo "add config_r_vscode.sh to be sourced if it's not already present"
  if ! [ -e "$HOME/.bashrc.d/config_r_vscode.sh" ]; then
    echo "config_r_vscode.sh not found, adding it"
    if ! [ -d "$HOME/.bashrc.d" ]; then mkdir -p "$HOME/.bashrc.d"; fi
    echo "copying config_r_vscode.sh to $HOME/.bashrc.d"
    cp "$project_root/.devcontainer/scripts/config_r_vscode.sh" "$HOME/.bashrc.d/" || exit 1
    chmod 755 "$HOME/.bashrc.d/config_r_vscode.sh"
  fi
  echo "completed adding config_r_vscode.sh to be sourced if it's not already present"
  "$HOME/.bashrc.d/config_r_vscode.sh"
  echo "Sourced config_r_vscode.sh"
  echo "-------------------"