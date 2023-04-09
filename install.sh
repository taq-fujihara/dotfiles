#!/bin/bash

source ./install/fish.sh
source ./install/fisher.fish
source ./install/go.sh
source ./install/ghq.sh
source ./install/fzf.sh
source ./install/asdf.sh

for p in (cat ~/.config/fish/fishfile); fisher install $p; end

source ./create_links.sh
