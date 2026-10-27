#!/usr/bin/env bash
set -euo pipefail

if [ -d $HOME/dotfiles ]; then
  echo '"dotfiles" directory already exists in your $HOME. Abort.'
  exit 1
fi

git clone https://github.com/taq-fujihara/dotfiles.git $HOME/dotfiles

# note: download tarball from GitHub
# curl \
#   -L https://github.com/taq-fujihara/dotfiles/archive/refs/heads/main.tar.gz \
#   -o /tmp/dotfiles.tar.gz
#
# tar -zxvf /tmp/dotfiles.tar.gz
# rm /tmp/dotfiles.tar.gz

cd $HOME/dotfiles
git remote set-url origin git@github.com:taq-fujihara/dotfiles.git

if [ $(uname) == "Darwin" ]; then
  ./setup.mac.sh
else
  ./setup.ubuntu.sh
fi
