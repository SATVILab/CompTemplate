#!/bin/bash
FETCH_R_VERSION=423
GITHUB_OAUTH_TOKEN=$GH_TOKEN
comp_dir=$(ls .. | grep -E "^Comp")
if [ -z "$comp_dir" ]; then
  sif_dir=./sif
  repo=${PWD##*/}    
  repo=${repo:-/}
else
  sif_dir=../"$comp_dir"/sif
  repo="$comp_dir"
fi
mkdir -p "$sif_dir"
../"$sif_dir"/bin/fetch --repo="https://github.com/SATVILab/$repo" --tag="r${FETCH_R_VERSION}" --release-asset="r${FETCH_R_VERSION}.sif" --github-oauth-token="$GITHUB_OAUTH_TOKEN" "$sif_dir"
