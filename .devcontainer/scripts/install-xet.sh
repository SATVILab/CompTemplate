#!/usr/bin/env bash
# Last modified: 2024 Jan 11
# Source: https://xethub.com/assets/docs/getting-started/install

# 1. Installs `xet` cli

pushd /tmp

wget https://github.com/xetdata/xet-tools/releases/latest/download/xet-linux-x86_64.deb

sudo apt install ./xet-linux-x86_64.deb

git xet install

rm -rf ./xet-linux-x86_64.deb

popd
