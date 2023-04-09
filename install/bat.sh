#!/usr/bin/bash

if type "bat" > /dev/null 2>&1; then
  echo "bat is installed"
  exit 0
fi

sudo apt install -y bat
ln -s /usr/bin/batcat ~/.local/bin/bat

