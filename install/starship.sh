#!/usr/bin/bash

if type "starship" > /dev/null 2>&1; then
  echo "starship is installed"
  exit 0
fi

curl -sS https://starship.rs/install.sh | sh

