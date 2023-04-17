#!/bin/bash

message=$1

read -p "$message  [y(or Enter) / N]:" answer
if [ ! -z "$answer" ] && [ $answer != 'y' ]; then
    exit 1
else
    exit 0
fi
