#!/bin/bash

cd `dirname $0`
SETUP_DIR=`pwd`

echo -e "\n\n====== Create Links of Dotfiles ======\n\n"

ln -sfv $SETUP_DIR/home/bashrc ~/.bashrc
ln -sfv $SETUP_DIR/home/bash_profile ~/.bash_profile
ln -sfv $SETUP_DIR/home/zshrc ~/.zshrc
ln -sfv $SETUP_DIR/home/zprofile ~/.zprofile
ln -sfv $SETUP_DIR/home/gitconfig ~/.gitconfig
ln -sfv $SETUP_DIR/home/inputrc ~/.inputrc
ln -sfv $SETUP_DIR/home/sampler.config ~/.sampler.config
ln -sfv $SETUP_DIR/home/vimrc ~/.vimrc
ln -sfv $SETUP_DIR/home/ideavimrc ~/.ideavimrc
ln -sfv $SETUP_DIR/home/powerline-shell.json ~/.powerline-shell.json

mkdir -p ~/.config/fish
ln -sfv $SETUP_DIR/home/config/fish/config.fish ~/.config/fish/config.fish
ln -sfv $SETUP_DIR/home/config/fish/fish_variables ~/.config/fish/fish_variables
ln -sfv $SETUP_DIR/home/config/fish/fishfile ~/.config/fish/fishfile

mkdir -p ~/.config/fish/functions
ln -sfv $SETUP_DIR/home/config/fish/functions/g.fish ~/.config/fish/functions/g.fish
ln -sfv $SETUP_DIR/home/config/fish/functions/d.fish ~/.config/fish/functions/d.fish

mkdir -p ~/.config/karabiner
ln -sfv $SETUP_DIR/home/config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

