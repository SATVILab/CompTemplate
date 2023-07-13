#!/bin/bash
FETCH_R_VERSION=423
GITHUB_OAUTH_TOKEN=$GH_TOKEN
comp_dir=$(ls .. | grep -E "^Comp")
mkdir -p ../"$comp_dir"/sif 
../"$comp_dir"/bin/fetch --repo="https://github.com/SATVILab/$comp_dir" --tag="r${FETCH_R_VERSION}" --release-asset="r${FETCH_R_VERSION}.sif" --github-oauth-token="$GITHUB_OAUTH_TOKEN" ../"$comp_dir"/sif

