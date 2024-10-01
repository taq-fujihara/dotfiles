#!/usr/bin/fish

set -l INSTALL_DIR ~/.config/fish/completions

mkdir -p $INSTALL_DIR

curl -o $INSTALL_DIR/ghq.fish https://raw.githubusercontent.com/decors/fish-ghq/refs/heads/master/completions/ghq.fish

