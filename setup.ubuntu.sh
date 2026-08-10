!/usr/bin/env bash

./install/apt

brew dump --file ./install/Brewfile.base

./install/fisher
./install/devbox

./bin/create_links.fish
./bin/change_login_shell.sh
