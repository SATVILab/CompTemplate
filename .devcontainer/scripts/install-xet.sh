pushd /tmp

wget https://github.com/xetdata/xet-tools/releases/latest/download/xet-linux-x86_64.deb

sudo apt install ./xet-linux-x86_64.deb

git xet install

rm -rf ./xet-linux-x86_64.deb

popd
