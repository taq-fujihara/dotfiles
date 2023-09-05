#!/bin/bash

FISH_PATH=$(which fish)

if [ $SHELL = $FISH_PATH ]; then
    echo "Current login shell is $SHELL. OK"
else
    echo "Current login shell is $SHELL. Change login shell to fish"
    chsh -s $FISH_PATH
    echo "Login shell is changed."
fi
