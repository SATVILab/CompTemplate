#!/usr/bin/env bash
# Last modified: 2024 Jan 17

# 1. Authenticates to XetHub (if credentials are available)

git --xet version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    # git --xet version worked
    if [ -n "$XETHUB_PAT" ] && [ -n "$XETHUB_USERNAME" ] && [ -n "$XETHUB_EMAIL" ]; then
        echo "Authenticating to Xethub..."
        xet login -u "$XETHUB_USERNAME" -e "$XETHUB_EMAIL" -p "$XETHUB_PAT"
    else 
        echo "Xethub credentials not found. Skipping authentication..."
        echo "Set XETHUB_PAT, XETHUB_USERNAME, and XETHUB_EMAIL environment variables, then run 'xet login -u "$XETHUB_USERNAME" -e "$XETHUB_EMAIL" -p "$XETHUB_PAT"' to authenticate."
    fi
fi