# README

## Reproduction instructions

### GitHub Codespaces

- Ensure that the GitHub Codespace has access to the following environment variables:
  - `GITHUB_USERNAME`: your GitHub user name
  - `GITHUB_PAT`: PAT for GitHub
  - *If project uses XetHub*:
    - `XETHUB_USERNAME`: Username for XetHub
    - `XETHUB_EMAIL`: Email address for XetHub
    - `XETHUB_PAT`: PAT for XetHub
- Open GitHub Codespace
- Start `R`, and run `projr_build_dev` in the directory of the repo whose results you wish to reproduce.

### HPC/local Linux

Before running below, make sure of the following:

- Ensure apptainer/singularity is loaded (on the HPC) or installed (locally):
  - Run `apptainer --version` or `singularity --version` to check
  - If you can install it, then install apptainer using the following script:
```
set -e
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:apptainer/ppa
apt-get update
apt-get install -y apptainer
# as singularity mounts localtime
# source: https://carpentries-incubator.github.io/singularity-introduction/07-singularity-images-building/index.html#using-singularity-run-from-within-the-docker-container
apt-get install -y tzdata
cp /usr/share/zoneinfo/Europe/London /etc/localtime
```

- The following environmennt variables are set:
  - `GITHUB_USERNAME`: your GitHub user name
  - `GITHUB_PAT`: PAT for GitHub
  - *If project uses XetHub*:
    - `XETHUB_USERNAME`: Username for XetHub
    - `XETHUB_EMAIL`: Email address for XetHub
    - `XETHUB_PAT`: PAT for XetHub
- The libraries are set to an appropriate directory (on an HPC, often the home directory is restricted in terms of size), by adding something like this to `~/.bashrc`:

```bash
# R renv library
export RENV_PATHS_CACHE="/scratch/$USER/.local/R/lib/renv"
export RENV_PATHS_LIBRARY_ROOT="/scratch/$USER/.local/.cache/R/renv"
export RENV_PATHS_LIBRARY="/scratch/$USER/.local/.cache/R/renv"
export RENV_PREFIX_AUTO=TRUE

# R library
export R_LIBS="/scratch/$USER/.local/lib/R"
mkdir -p $R_LIBS
```

- The cache directory for singularity/apptainer is also set to a place you can have large/many files:

```bash
mkdir -p /scratch/$USER/.local/.cache/apptainer
export SINGULARITY_CACHEDIR=/scratch/$USER/.local/.cache/apptainer
export APPTAINER_CACHEDIR=/scratch/$USER/.local/.cache/apptainer
```

- Download all the code:

```
# download apptainer image (will work in singularity)
wget https://github.com/MiguelRodo/ApptainerBuildR/releases/download/r4.3.x/r43x.sif # 4.3.2
# run all commands in apptainer image
apptainer shell r43x.sif
# log into github
github-login
# clone comp repo
git clone https://github.com/SATVILab/CompACSCyTOFTCells.git
# clone other repos
cd CompACSCyTOFTCells
repos-clone-github
repos-clone-xethub
cd ..
```

- Start `R`, and run `projr_build_dev` in the directory of the repo whose results you wish to reproduce.
