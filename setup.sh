#!/bin/bash

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    echo "$f"
    ln -s $f ~/$f
done

