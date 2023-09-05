#!/bin/bash

echo 'Install astronvim'
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

echo 'Install astronvim (user config)'
git clone https://github.com/taq-fujihara/astronvim_config.git ~/.config/nvim/lua/user
git -C ~/.config/nvim/lua/user remote set-url origin git@github.com:taq-fujihara/astronvim_config.git
