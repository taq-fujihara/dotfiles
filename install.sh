#!/bin/bash

cd `dirname $0`
SETUP_DIR=`pwd`

echo -e "\n\n====== Create Links of Dotfiles ======\n\n"

ln -sfv $SETUP_DIR/home/bashrc ~/.bashrc
ln -sfv $SETUP_DIR/home/gitconfig ~/.gitconfig
ln -sfv $SETUP_DIR/home/inputrc ~/.inputrc
ln -sfv $SETUP_DIR/home/sampler.config ~/.sampler.config
ln -sfv $SETUP_DIR/home/vimrc ~/.vimrc

mkdir -p ~/.config/powerline-shell

ln -sfv $SETUP_DIR/home/config/powerline-shell/config.json ~/.config/powerline-shell/config.json
