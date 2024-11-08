#!/usr/bin/env fish

set SOURCE_DIR (pwd)/home
set DESTINATION_DIR $HOME
set BACKUP_ROOT (pwd)/backup
set BACKUP_DIR $BACKUP_ROOT/(date "+%Y%m%d%H%M%S")


function warn
  echo (set_color yellow; echo $argv[1]; set_color normal)
end

function error
  echo (set_color red; echo $argv[1]; set_color normal)
end

function create_link
  set -l src $SOURCE_DIR/$argv[1]
  set -l dst $DESTINATION_DIR/$argv[2]

  if test -L $dst
    warn "$dst already exists (as a link). skip..."
    return
  end

  if test -e $dst
    warn "$dst already exists. backup..."
    cp $dst $BACKUP_DIR/
    if test $status != 0
      error 'Failed to backup! Did not create link...'
      return 1
    end
  end

  mkdir -p (dirname $dst)
  ln -sfv $src $dst
end


echo '==============================================================='
echo 'This script creates symbolic links of dotfiles!'
echo '==============================================================='
echo 'dotfiles source directory      :' $SOURCE_DIR
echo 'dotfiles destination directory :' $DESTINATION_DIR
echo 'backup directory               :' $BACKUP_DIR
echo '==============================================================='
echo ''
echo 'creating backup directory...'
mkdir -p $BACKUP_DIR
echo '*' > $BACKUP_ROOT/.gitignore

create_link gitconfig .gitconfig
create_link xkb .xkb
create_link tigrc .tigrc
create_link sampler.yaml .sampler.yaml
create_link config/gh/config.yml .config/gh/config.yml
create_link config/git/ignore .config/git/ignore
create_link config/gitui/key_bindings.ron .config/gitui/key_bindings.ron
create_link config/fish/config.fish .config/fish/config.fish
create_link config/fish/fish_plugins .config/fish/fish_plugins
create_link config/fish/functions/fish_greeting.fish .config/fish/functions/fish_greeting.fish
create_link config/fish/functions/fontview.fish .config/fish/functions/fontview.fish
create_link config/fish/functions/git.fish .config/fish/functions/git.fish
create_link config/fish/functions/gitroot.fish .config/fish/functions/gitroot.fish
create_link config/fish/functions/npmi.fish .config/fish/functions/npmi.fish
create_link config/fish/functions/update_astronvim.fish .config/fish/functions/update_astronvim.fish
create_link config/fish/functions/printpath.fish .config/fish/functions/printpath.fish
create_link config/fish/functions/wezinit.fish .config/fish/functions/wezinit.fish
create_link config/fish/functions/wkdir.fish .config/fish/functions/wkdir.fish
create_link config/fish/functions/zed.fish .config/fish/functions/zed.fish
create_link config/fish/functions/zf.fish .config/fish/functions/zf.fish
# https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
create_link config/karabiner .config/karabiner
create_link config/lazygit/config.yml .config/lazygit/config.yml
create_link config/mise/config.toml .config/mise/config.toml
create_link config/starship.toml .config/starship.toml
create_link config/wezterm/wezterm.lua .config/wezterm/wezterm.lua
create_link config/yazi/yazi.toml .config/yazi/yazi.toml
create_link config/zed/keymap.json .config/zed/keymap.json
create_link config/zed/settings.base.json .config/zed/settings.base.json
create_link local/bin/hjkl .local/bin/hjkl
create_link local/bin/hjkl_rymek .local/bin/hjkl_rymek

