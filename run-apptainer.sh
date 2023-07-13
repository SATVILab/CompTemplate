#!/bin/bash
# get the Comp directory's full name.
# needed as Comp* is not always expanded when 
# needed below
date

# Function to check if sif is in there and then return the path if it is
get_path_sif() {
  # Check if directory exists
  if [ -d "$1" ]; then
    # If it does exist, then check if it has a sif file
    if [ -n "$(ls "$1" | grep -E 'sif$')" ]; then
      echo "$1/$(ls "$1" | grep -E 'sif$')"
    else
      echo "File not found" >&2
      exit 1
    fi
  else
    echo "Directory does not exist" >&2
    exit 1
  fi
}

# Attempt to get path to sif in ./sif
echo "Attempting to get path to sif in ./sif"
path_sif=$(get_path_sif "sif")

# If path_sif is empty, attempt to get path to sif in ../$comp_dir/sif
if [ -z "$path_sif" ]; then
  comp_dir=$(ls .. | grep -e "^Comp")
  echo "Attempting to get path to sif in ../$comp_dir/sif"
  path_sif=$(get_path_sif "../$comp_dir/sif")
fi

# Exit if sif file not found
test -n "$path_sif" || { echo "sif file not found"; exit 1; }

echo "Final path to sif: $path_sif"

if [ -n "$(env | grep -E "^GITPOD|^CODESPACE")" ]; then
  export RENV_CONFIG_PAK_ENABLED=${RENV_CONFIG_PAK_ENABLED:=TRUE}
fi

# Run apptainer if it is found, and singularity if apptainer is not.
# Exit with an error if neither is found
if command -v apptainer > /dev/null 2>&1; then
  echo "Running apptainer"
  apptainer run "$path_sif" "$1"
elif command -v singularity > /dev/null 2>&1; then
  echo "Running singularity"
  singularity run "$path_sif" "$1"
else
  echo "Neither singularity nor apptainer container runtime detected"
  exit 1
fi
