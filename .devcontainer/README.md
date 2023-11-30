# README

To add these settings to a pre-existing project, copy and paste the following into a bash shell, and then delete:

```bash
echo "Update .devcontainer folder and .gitpod.yml file to latest MiguelRodo/CompTemplate settings"
echo "Note: it overwrites any files MiguelRodo/CompTemplate has, but does not delete files MiguelRodo/CompTemplate doesn't"

# Define paths
TEMPLATE_REPO_PATH="/tmp/update_template_settings/CompTemplate"
TARGET_REPO_PATH="$(pwd)" 

# Clone or update the template repository
if [ ! -d "$TEMPLATE_REPO_PATH" ]; then
    git clone https://github.com/MiguelRodo/CompTemplate.git "$TEMPLATE_REPO_PATH"
else
    git -C "$TEMPLATE_REPO_PATH" pull
fi

# Function to copy and set permissions
copy_and_set_755_permissions() {
    src=$1
    dest=$2
    # Copy file or directory
    cp -R "$src" "$dest"
    # Set executable permissions for everyone and write permission only for the user
    chmod -R u+rwX,go+rX,go-w "$dest"
}

copy_and_set_644_permissions() {
    src=$1
    dest=$2
    # Copy file or directory
    cp -R "$src" "$dest"
    # Set executable permissions for everyone and write permission only for the user
    chmod -R u+rw,go+r,go-w "$dest"
}

# Update .devcontainer with scripts
copy_and_set_755_permissions "$TEMPLATE_REPO_PATH/.devcontainer/scripts" "$TARGET_REPO_PATH/.devcontainer"

# Update .devcontainer/devcontainer.json
copy_and_set_644_permissions "$TEMPLATE_REPO_PATH/.devcontainer/devcontainer.json" "$TARGET_REPO_PATH/.devcontainer"

# Update .gitpod.yml
copy_and_set_644_permissions "$TEMPLATE_REPO_PATH/.gitpod.yml" "$TARGET_REPO_PATH"

echo "Update complete."
```

If you want to add .Rbuildignore, EntireProject.code-workspace and `repos-to-clone.list` as well, then run the following, too:

```bash
# Update .Rbuildignore
copy_and_set_644_permissions "$TEMPLATE_REPO_PATH/.Rbuildignore" "$TARGET_REPO_PATH"
# Update EntireProject.code-workspace
copy_and_set_644_permissions "$TEMPLATE_REPO_PATH/EntireProject.code-workspace" "$TARGET_REPO_PATH"
# Update repos-to-clone.list
copy_and_set_644_permissions "$TEMPLATE_REPO_PATH/repos-to-clone.list" "$TARGET_REPO_PATH"
```