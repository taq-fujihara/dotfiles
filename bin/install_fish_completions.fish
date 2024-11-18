#!/usr/bin/env fish

set INSTALL_DIR ~/.config/fish/completions
mkdir -p $INSTALL_DIR

function gen_completion
  set -l command_name $argv[1]
  set -l cmd $argv[2]

  echo "Creating shell completion file for $command_name"
  eval $cmd > $INSTALL_DIR/$command_name.fish
end

gen_completion fd "fd --gen-completions=fish"
gen_completion mise "mise completion fish"
gen_completion podman "podman completion fish"
gen_completion rg "rg --generate complete-fish"
gen_completion ruff "ruff generate-shell-completion fish"
gen_completion uv "uv generate-shell-completion fish"
gen_completion ghq "curl https://raw.githubusercontent.com/decors/fish-ghq/refs/heads/master/completions/ghq.fish"
gen_completion jj "jj util completion fish"
