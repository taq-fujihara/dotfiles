#!/bin/bash

if [ -z `which snapa` ]; then
  echo "snap command not found. abort..."
  exit
fi

PACKAGES=`dirname $BASH_SOURCE`

echo "read packages from $PACAKGES/snap_packages.txt"

cat $PACKAGES/snap_packages.txt | while read package
do
  echo "install $package"
  sudo snap install $package
done

