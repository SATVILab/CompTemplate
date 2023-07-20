# Compendium of 23AppMpuFAUST

## Instructions for running

### Setting up `GH_TOKEN` environment variable

First, make sure that you have the environment variable `GH_TOKEN` set up to a GitHub token with `repo`, `user` and `workflow` scopes
from a GitHub account that has access to the following repositories:

- SATVILab/DataTidy23AppMpuFAUSTBCG

First, you need to create the token (Getting secret) and then you need to make it available in your environment (GitHub Codespaces, GitPod or HPC).

- Go to `https://github.com/settings/tokens`
  - Click `Generate new token`
  - Click `Generate new token (classic)`
  - Name the token something meaningful
  - Select the following scopes:
    - `repo`
    - `user`
    - `workflow`
  - Click `Generate token`
- Then, depending on where you plan on running the compendium, you need to make the `GH_TOKEN` environment variable available with the token above:
  - **GitHub Codespaces**: Set up `GH_TOKEN` in the Codespaces settings
    - Go to `https://github.com/settings/codespaces`
    - On the right of `Codespaces Secrets`, click `New secret`
    - Name the secret `GH_TOKEN`
    - Paste the token into the `Value` field
    - Make sure that this token is made available to the `SATVILab/Comp23AppMpuFAUST`.

- **GitPod**
    -

  - **Linux**
    - Add `GH_TOKEN=<token>` to `~/.bashrc`

### Setting up development environment

#### GitPod

- Open `https://gitpod.io/#https://github.com/SATVILab/Comp23AppMpuFAUST` in browser
  - Wait for set-up to complete (including post-image creation commands)
- Switch to VS Code instance:
  - Open a VS Code workspace:
    - Press `Ctrl + Shift + P`
    - Choose `File: Open Workspace from File...`
    - Open workspace with repos of interest:
      - `EntireProject.code-workspace`: Contains all repos

### GitHub Codespaces

- *Open Codespace*:
  - Go to `https://github.com/SATVILab/Comp23AppMpuFAUST`
  - Click green `Code` button
  - Click green `Create codespace on main` button
  - Wait for set-up
- Switch to VS Code instance:
  - Open a VS Code workspace:
    - Press `Ctrl + Shift + P`
    - Choose `File: Open Workspace from File...`
    - Open workspace with repos of interest:
      - `EntireProject.code-workspace`: Contains all repos

### HPC/local linux

- Open *terminal*: Open an interactive terminal on a compute node
- *Ensure that `apptainer` or `singularity` is available*
  - Run `apptainer --version` or `singularity --version` to check
    - If it's not, then you'll need to load it or install it.
    - If you do have administrator rights, then you can run `./scripts/ubuntu/install_apptainer.sh`. to install apptainer. Run `apptainer --version` to check that it is installed.
    - If you're on an HPC, or any PC where you do not have administrator rights, then you will either have to simply ensure apptainer/singularity is loaded (e.g. `module load apptainer` or `module load singularity`) or ask your system administrator to install it for you.
- *Clone this repository*:
  - Navigate to directory where you want to clone this repo and all other project repos.
    - Note that there are many project repos, so it would be good to do this in its own directory.
      - We create `Project23AppMpuFAUST` folder for this purpose.
    - Inside that folder, run `git clone https://github.com/SATVILab/Comp23AppMpuFAUST.git`
- *Open terminal inside repo*:
  - Run `cd <path/to/project_folder>`
- *Download and run VS Code in the container image*:
  - Using a terminal: Run `./run-vsc.sh`.
- *Switch to VS Code instance*:
  - Open a VS Code workspace:
    - Press `Ctrl + Shift + P`
    - Choose `File: Open Workspace from File...`
    - Open workspace with repos of interest:
      - `EntireProject.code-workspace`: Contains all repos

### Local (other)

In this case, this repository is only useful to you in defining all the repos that you need to clone, and creating a workspace file for you to open in VS Code.

So, do the following:

- Create a project folder to contain all the repos.
- Clone all the repos to that project folder. You can run the following code to do s:

```
git clone https://github.com/SATVILab/Comp23AppMpuFAUST.git
git clone https://github.com/SATVILab/DataTidy23AppMpuFAUSTBCG.git
git clone https://github.com/SATVILab/DataTidy23AppMpuFAUSTACS.git
```

- Open `Comp23AppMpuFAUST` in VS Code, and then open the workspace file `EntireProject.code-workspace`.
