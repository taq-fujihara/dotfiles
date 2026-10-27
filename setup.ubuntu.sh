#!/usr/bin/env bash

./bin/confirm.sh "Install packages from apt" && \
    ./install/apt

./bin/confirm.sh "Install packages from brew" && \
    ./install/brew && \
    brew dump --file ./install/Brewfile.base && \

./bin/confirm.sh "Install GUIs from brew" && \
    ./install/brew.gui.ubuntu

./bin/confirm.sh "Install and setup Fisher" && \
    ./install/fisher

./bin/confirm.sh "Create links to config files" && \
    ./bin/create_links.fish

./bin/confirm.sh "Change login shell to fish" && \
    ./bin/change_login_shell.sh

./bin/confirm.sh "Install fish completions" && \
    ./bin/install_fish_completions.fish
