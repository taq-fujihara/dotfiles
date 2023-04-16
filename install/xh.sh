#!/usr/bin/bash

if type "xh" > /dev/null 2>&1; then
  echo "xh is installed"
  exit 0
fi

curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh

