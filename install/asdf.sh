#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3
mkdir -p ~/.asdf/completions
ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

