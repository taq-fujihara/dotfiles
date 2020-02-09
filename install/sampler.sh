#!/bin/bash

VERSION=1.1.0
INSTALL_PATH=$HOME/.local/bin/sampler

if [ -e $INSTALL_PATH ]; then
	echo "looks sampler is already installed($INSTALL_PATH). skip..."
	exit 0
fi

curl -L https://github.com/sqshq/sampler/releases/download/v${VERSION}/sampler-${VERSION}-linux-amd64 -o $INSTALL_PATH

chmod +x $INSTALL_PATH

