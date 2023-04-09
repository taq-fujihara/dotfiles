#!/bin/bash

if type "fzf" > /dev/null 2>&1; then
  echo "fzf is installed"
  exit 0
fi

sudo apt install -y fzf

