#!/bin/bash

./install/apt

./install/brew
./install/brew.ubuntu

./install/fisher
./install/astronvim
./install/starship
./install/devbox
./install/wezterm
./install/cloudsqlproxy

./bin/create_links.fish
./bin/loginshell.sh
./bin/switch_colorscheme.fish nord
