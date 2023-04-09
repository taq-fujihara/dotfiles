#!/usr/bin/bash

if type "go" > /dev/null 2>&1; then
  echo "go is installed"
  exit 0
fi

GO_VERSION=1.20.3

wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -P /tmp
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz

# add /usr/local/go/bin to PATH

