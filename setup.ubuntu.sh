#!/bin/bash

sudo apt update
sudo apt install -y \
  curl \
  git \
  build-essential \
  software-properties-common \
  zip

./install/brew

# temporarily add brew to path
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

./install/by-brew
./install/by-brew.ubuntu

./install/astronvim.sh
./install/starship
./install/fish
./install/fisher

./bin/create_links.sh
./bin/loginshell.sh

