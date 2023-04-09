#!/bin/bash

if type "go" > /dev/null 2>&1; then
  echo "ghq, prerequisite: golang installed"
else
  echo "install golang before install ghq"
  source ./install/go.sh
fi

if type "ghq" > /dev/null 2>&1; then
  echo ghq is installed
  exit 0
fi

go install github.com/x-motemen/ghq@latest

