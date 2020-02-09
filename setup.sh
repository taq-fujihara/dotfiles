#!/bin/bash

cd `dirname $0`
SETUP_DIR=`pwd`

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    ln -sv $SETUP_DIR/$f ~/
done

