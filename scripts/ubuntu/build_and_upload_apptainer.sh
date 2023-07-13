#!/bin/bash
echo "Attempting to build sif file"
sudo scripts/ubuntu/build_apptainer.sh
comp_dir=$(ls .. | grep -E "^Comp")
if [ -z "$comp_dir" ]; then
  sif_dir=./sif
else
  sif_dir=../"$comp_dir"/sif
fi
path_sif="$(get_path_sif "$sif_dir")"
if [ -z "$path_sif" ]; then
  echo "Attempt to build sif file failed"
else
  echo "Attempt to build sif file succeeded"
fi
echo "Attempting to upload sif file as a GitHub release"
scripts/ubuntu/upload_apptainer.sh
