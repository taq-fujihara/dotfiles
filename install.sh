#!/usr/bin/bash

source ./create_links.sh

sudo apt update

./install/fish.sh
./install/fisher.fish
./install/go.sh
./install/ghq.sh
./install/fzf.sh
./install/asdf.sh
./install/ripgrep.sh
./install/bat.sh
./install/terraform.sh
./install/delta.sh
./install/starship.sh

