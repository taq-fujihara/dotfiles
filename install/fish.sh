#!/bin/bash

if type "fish" > /dev/null 2>&1; then
  echo "fish is installed"
  exit 0
fi

sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish
