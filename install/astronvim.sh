#!/bin/bash

if [ -d ~/.config/nvim ]; then
    echo '~/.config/nvim already exists. skip installing AstroNvim...'
else
    echo 'Install astronvim'
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
fi

if [ -d ~/.config/nvim/lua/user ]; then
    echo '~/.config/nvim/lua/user already exists. skip installing AstroNvim user config...'
else
    echo 'Install astronvim (user config)'
    git clone git@github.com:taq-fujihara/astronvim_config.git ~/.config/nvim/lua/user
fi
