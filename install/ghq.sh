#!/bin/bash

if type "go" > /dev/null 2>&1; then
  echo "golang installed"
else
  echo "install golang before install ghq"
  source ./install/go.sh
fi

go get github.com/motemen/ghq
