#!/bin/bash
# get the Comp directory's full name.
# needed as Comp* is not always expanded when 
# needed beloww
comp_dir=$(ls .. | grep -e "^Comp")
test -e ../"$comp_dir"/sif/r423.sif || ../"$comp_dir"/scripts/ubuntu/download_apptainer.sh
# set R_LIBS if not set as otherwise
# it is by default set to a non-writeable 
# directory in the image
R_LIBS=${R_LIBS:=$HOME/.local/.cache/R}
# need to create the directory, as otherwise R_LIBS
# will have no effect
mkdir -p $R_LIBS
if [ -n "$(env | grep -E "^GITPOD|^CODESPACE")" ]; then
  export RENV_CONFIG_PAK_ENABLED=${RENV_CONFIG_PAK_ENABLED:=TRUE}
fi
export GITHUB_PAT=${GITHUB_PAT:=$GH_TOKEN} 
if which apptainer > /dev/null 2>&1; then
  apptainer run ../"$comp_dir"/sif/r423.sif ${1:-code-insiders tunnel --accept-server-license-terms}
elif which singularity > /dev/null 2>&1; then
  singularity run ../"$comp_dir"/sif/r423.sif ${1:-code-insiders tunnel --accept-server-license-terms}
else
  echo "Neither singularity nor apptainer container runtime detected"
  exit 1
fi
