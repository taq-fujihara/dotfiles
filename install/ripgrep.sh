#!/bin/bash

if type "rg" > /dev/null 2>&1; then
  echo ripgrep is installed
  exit 0
fi

sudo apt install -y ripgrep
