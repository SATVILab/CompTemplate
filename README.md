# README

The purpose of this repository is to
`[briefly describe the compendium's goals and objectives]`

## Contact

For more information, please contact:
- `[Name]`, `[Email Address]`
- `[Name]`, `[Email Address]`

## Links

- `[URLs to data sources (e.g. OneDrive), GitHub repos, publications, etc.]`

## Details

### Setup

#### Multi-repository workspace

This repo can easily be used to set up a multi-repository workspace, on any operating system (Linux, macOS, Windows).

Firstly, specify the repositories you want to include in the workspace in the `repos-to-clone.list` file.
This file should be located in the root directory of this repository.
Instructions for how to set up the `repos-to-clone.list` file can be found in the header of that file.

Secondly, run `scripts/repos-clone.sh` to clone the repositories specified in the `repos-to-clone.list` file.
It will work on all platforms (Linux, macOS, Windows) as long as Git is installed.
If on Windows, run this using Git Bash (available if Git for Windows is installed).

Thirdly, if using VS Code, run `scripts/vscode-workspace-add.sh` to add the repos specified in the `repos-to-clone.list` file to a workspace file, `entire-project.code-workspace`.
This will work as long as Python (any version) or `jq` is installed.
Then open this repository inside VS Code, open the Command Palette (`Ctrl + Shift + P`), click on `File: Open Workspace from File...` and select `entire-project.code-workspace`.

#### R containers

Within the `.devcontainer` directory, a `devcontainer.json` file is provided to set up a development container for this repository.
It specifies a container image appropriate for `R` analyses on any Linux system, including GitHub Codespaces and Windows Subsystem for Linux (WSL).

##### Base image

By default, the container will be built upon `bioconductor/bioconductor_docker:RELEASE_3_20`, the current latest BioConductor image release.
The advantage of this is that it has pre-built binaries for many `BioConductor` packages, which can significantly speed up the installation process.
To use a different version of BioConductor, change the `image` field in the `devcontainer.json` file to the desired version (e.g. `bioconductor/bioconductor_docker:RELEASE_3_19`).

To use a non-BioConductor image, change the `FROM` line in the `Dockerfile` to the desired image, e.g. `FROM rocker/r-verse:4.4`.

##### Features

The `devcontainer.json` file uses `devcontainer` features to install additional tools and packages:

- `Quarto` (with `TinyTex`, by default).
- Various `Ubuntu` packages typically required.
- `radian`, a modern R console appropriate for VS Code.
- The `repos` feature, which automatically sets up the `repos-to-clone.list` file (does not depend on the `/scripts` folder) and authentication for private repositories to Git and HuggingFace that enables multi-repository authentication.
- The `config-r` feature, which installs all packages inside `.devcontainer/renv/<dir>/renv.lock` files into the global package cache during the container build package. Note that multiple `renv` directories can be specified (change `<dir>`). This speeds up set up of the container once built dramatically if `renv` is used in the repositories.

##### Building the container

A GitHub Action is included (`.github/workflows/devcontainer-build.yml`) to build the container on every push to the `main` branch.
By default, the container is stored in the `ghcr.io` registry, and is named `<repository_name>-<branch>`.
By default, the container is built upon each push to the `main` branch.
For public repositories, all builds and storing the packages are free, so we strongly recommend that this repo be made public (the repos specified in `repos-to-clone.list` can be private, so consider this an infrastructure repo and keep private code in other repos).
If this is treated as an infrastructure repo, then changes will be infrequent, and so builds on each push are acceptable.
However, this can be easily disabled by removing the `on.push` key from the `devcontainer-build.yml` file.

This GitHub Action also creates a `.devcontainer/prebuild/devcontainer.json` file, which uses the pre-built image on the `ghcr.io` registry.
So, if you are using VS Code to open this repository, then if the container image has been built rather use the `prebuild/devcontainer.json` file.
