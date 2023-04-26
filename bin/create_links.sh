#!/bin/bash

SOURCE_DIR=`pwd`/home
DESTINATION_DIR=$HOME
BACKUP_DIR=`pwd`/backups/`date "+%Y%m%d%H%M%S"`

create_link () {
  src_relative=$1
  dst_relative=$2

  src=$SOURCE_DIR/$src_relative
  dst=$DESTINATION_DIR/$dst_relative

  echo ''
  echo ''
  echo ''
  echo "creating a link: $src_relative => $dst_relative"

  if [ -L $dst ]; then
    echo "    $dst already exists (as a link). skip..."; return
  fi

  if [ -e $dst ]; then
    echo "    $dst already exists. backup..."
    cp $dst $BACKUP_DIR
    if [ $? != 0 ]; then
      echo 'failed to backup! do not create link...'
      return 1
    fi
  fi

  if [ ! -d `dirname $dst` ]; then
    mkdir -p `dirname $dst`
  fi

  ln -sfv $src $dst
}

echo ''
echo ''
echo ''
echo '========================================================================='
echo 'This script creates symbolic links to your home directory!'
echo '========================================================================='
echo 'dotfiles source directory      :' $SOURCE_DIR
echo 'dotfiles destination directory :' $DESTINATION_DIR
echo 'backup directory               :' $BACKUP_DIR
echo '========================================================================='
echo ''
echo 'creating backup directory ...'
mkdir -p $BACKUP_DIR

# create_link bash_profile .bash_profile
# create_link bashrc .bashrc
create_link gitconfig .gitconfig
create_link ideavimrc .ideavimrc
create_link inputrc .inputrc
create_link vimrc .vimrc
create_link tmux.conf .tmux.conf
create_link xkb .xkb
create_link tool-versions .tool-versions
# create_link zprofile .zprofile
# create_link zshrc .zshrc
create_link sampler.yaml .sampler.yaml
create_link config/fish/config.fish .config/fish/config.fish
create_link config/fish/fish_plugins .config/fish/fish_plugins
create_link config/fish/functions/fish_greeting.fish .config/fish/functions/fish_greeting.fish
create_link config/fish/functions/npmi.fish .config/fish/functions/npmi.fish
create_link config/wezterm/wezterm.lua .config/wezterm/wezterm.lua
create_link config/starship.toml .config/starship.toml
# https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
create_link config/karabiner .config/karabiner
create_link local/bin/hjkl .local/bin/hjkl
create_link local/bin/hjkl_rymek .local/bin/hjkl_rymek
create_link local/bin/tmux-init .local/bin/tmux-init

