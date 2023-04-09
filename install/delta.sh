#!/usr/bin/bash

if type "delta" > /dev/null 2>&1; then
  echo "delta is installed"
  exit 0
fi

wget https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb -P /tmp
sudo dpkg -i /tmp/git-delta_0.15.1_amd64.deb

