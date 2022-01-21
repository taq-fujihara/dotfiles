#!/bin/bash

cd `dirname $0`
SETUP_DIR=`pwd`

if type "apt" > /dev/null 2>&1; then
  echo "install programs via apt"
  sudo apt install -y vim ripgrep zip unzip
fi

if type "vim" > /dev/null 2>&1; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if type "pip3" > /dev/null 2>&1; then
  pip3 install powerline-shell
fi

echo -e "\n\n====== Create Links of Dotfiles ======\n\n"

ln -sfv $SETUP_DIR/home/bashrc ~/.bashrc
ln -sfv $SETUP_DIR/home/bash_profile ~/.bash_profile
ln -sfv $SETUP_DIR/home/zshrc ~/.zshrc
ln -sfv $SETUP_DIR/home/zprofile ~/.zprofile
ln -sfv $SETUP_DIR/home/gitconfig ~/.gitconfig
ln -sfv $SETUP_DIR/home/inputrc ~/.inputrc
ln -sfv $SETUP_DIR/home/sampler.yaml ~/.sampler.yaml
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
ln -sfv $SETUP_DIR/home/config/fish/functions/npmi.fish ~/.config/fish/functions/npmi.fish
ln -sfv $SETUP_DIR/home/config/fish/functions/p.fish ~/.config/fish/functions/p.fish
ln -sfv $SETUP_DIR/home/config/fish/functions/mkdirp.fish ~/.config/fish/functions/mkdirp.fish

ln -sfv $SETUP_DIR/home/local/bin/hjkl ~/.local/bin/hjkl

mkdir -p ~/.config/karabiner
ln -sfv $SETUP_DIR/home/config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

# Keymaps for Ubuntu
ln -sfv $SETUP_DIR/home/xkb ~/.xkb
