#!/bin/bash

cd `dirname $0`
SETUP_DIR=`pwd`

echo -e "\n\n====== Install Packages ======\n\n"
for f in install/*.sh
do
	echo -e "\n** install `basename $f .sh`\n"
	$f
done

echo -e "\n\n====== Create Links of Dotfiles ======\n\n"
for f in .??*
do
	[[ "$f" == ".git" ]] && continue
	[[ "$f" == *.swp ]] && continue

	ln -sv $SETUP_DIR/$f ~/
done


