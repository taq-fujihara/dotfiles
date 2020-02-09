#!/bin/bash

cd `dirname $0`
SETUP_DIR=`pwd`

for f in .??*
do
	[[ "$f" == ".git" ]] && continue
	[[ "$f" == *.swp ]] && continue

	ln -sv $SETUP_DIR/$f ~/
done

# install packages
for f in install/*.sh
do
	echo "install `basename $f .sh`"
	$f
done

