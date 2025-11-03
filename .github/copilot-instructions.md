# Copilot Instructions for CompTemplate

## Repository Overview

This is a template repository for setting up multi-repository R-based computational research projects with containerized development environments. It provides infrastructure for:

- Managing multiple related repositories as a unified workspace
- Running R/Bioconductor analyses in Docker containers
- Automated devcontainer builds via GitHub Actions
- VS Code workspace configuration across multiple repositories

## Key Technologies

- **Language**: Bash shell scripts, R (for analysis projects using this template)
- **Container**: Docker, VS Code devcontainers
- **Base Image**: Bioconductor Docker (`bioconductor/bioconductor_docker:RELEASE_3_20`)
- **Tools**: Quarto (with TinyTeX), radian (modern R console), renv (R package management)
- **CI/CD**: GitHub Actions for automated container builds

## Repository Structure

```
.
├── .devcontainer/           # Devcontainer configuration
│   ├── devcontainer.json   # VS Code devcontainer settings
│   ├── Dockerfile          # Container image definition
│   ├── prebuild/           # Pre-built image references
│   └── renv/               # R package lockfiles for pre-installation
├── .github/
│   └── workflows/          # GitHub Actions workflows
│       ├── devcontainer-build.yml    # Automated container builds
│       └── add-issues-to-project.yml # Issue management
├── scripts/                # Utility scripts for repository management
│   ├── clone-repos.sh      # Clone repositories listed in repos.list
│   ├── vscode-workspace-add.sh  # Generate VS Code workspace file
│   ├── codespaces-auth-add.sh   # Configure GitHub auth in Codespaces
│   ├── create-repos.sh     # Create new repositories
│   ├── install-r-deps.sh   # Install R dependencies
│   └── run-pipeline.sh     # Execute analysis pipeline
├── repos.list              # List of repositories to clone (format: owner/repo@branch)
├── entire-project.code-workspace  # VS Code multi-root workspace file
└── README.md               # Documentation
```

## Important Files

### `repos.list`
- Format: `owner/repo` or `owner/repo@branch`
- Specifies repositories to clone for the multi-repository workspace
- Used by `scripts/clone-repos.sh` and devcontainer features

### `.devcontainer/devcontainer.json`
- Configures the development container environment
- Includes custom features for repository cloning and R package pre-installation
- Pre-installs VS Code extensions including GitHub Copilot

### `scripts/clone-repos.sh`
- Clones all repositories specified in `repos.list`
- Works on Linux, macOS, and Windows (via Git Bash)

### `scripts/vscode-workspace-add.sh`
- Generates/updates `entire-project.code-workspace`
- Requires Python or `jq` utility

## Workflow

### Setting up a new project from this template:

1. **Edit `repos.list`**: Add repositories needed for the project
2. **Clone repositories**: Run `scripts/clone-repos.sh`
3. **Create workspace** (optional): Run `scripts/vscode-workspace-add.sh`
4. **Customize devcontainer**: Modify `.devcontainer/Dockerfile` if different base image or packages are needed
5. **Add R dependencies** (optional): Place `renv.lock` files in `.devcontainer/renv/<project>/` for pre-installation

### Container builds:
- Triggered automatically on push to `main` branch
- Can also be manually triggered via GitHub Actions
- Images pushed to GitHub Container Registry (ghcr.io)
- Pre-built image reference generated in `.devcontainer/prebuild/devcontainer.json`

## Coding Guidelines

### For Bash Scripts:
- Use `#!/usr/bin/env bash` shebang
- Make scripts executable (`chmod +x`)
- Support cross-platform execution where possible (Linux, macOS, Windows/Git Bash)
- Use proper error handling with `set -e` or explicit checks
- Include helpful usage messages and comments

### For Dockerfile/Devcontainer:
- Keep base image version explicit (e.g., `RELEASE_3_20`)
- Set `DEBIAN_FRONTEND=noninteractive` to avoid prompts
- Set appropriate permissions for copied files
- Document any custom configuration

### For R Projects (using this template):
- Use `renv` for package management
- Place lockfiles in `.devcontainer/renv/<project>/renv.lock` for faster container builds
- Use Quarto for reproducible reports

## Common Tasks

### To change the Bioconductor release:
Update the `FROM` line in `.devcontainer/Dockerfile`, e.g.:
```dockerfile
FROM bioconductor/bioconductor_docker:RELEASE_3_19
```

### To add new repositories to the workspace:
1. Add entries to `repos.list`
2. Run `scripts/clone-repos.sh`
3. Run `scripts/vscode-workspace-add.sh`

### To install additional system packages:
Add to the `apt-packages` feature in `.devcontainer/devcontainer.json`:
```json
"ghcr.io/rocker-org/devcontainer-features/apt-packages:1": {
  "packages": "xvfb,vim,libcurl4-openssl-dev,libsecret-1-dev,jq,your-package"
}
```

## Testing

This is an infrastructure/template repository. Testing typically involves:
- Verifying scripts run without errors on target platforms
- Confirming devcontainer builds successfully
- Validating generated workspace files are correctly formatted

There are no automated tests currently in this repository.

## Notes

- This repository serves as a template. Users should fork/copy it and customize for their specific project needs.
- GitHub token (`GH_TOKEN`) must be configured as a Codespaces secret for private repository cloning
- The `SATVILab/dotfiles` repository can be used for additional container configuration (especially for radian settings)
