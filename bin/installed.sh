#!/bin/bash

command=$1

if type "$command" > /dev/null 2>&1; then
    exit 0
fi
if type "fish" > /dev/null 2>&1; then
    fish -c "type -q ${command}"
    if [ $? = 0 ]; then
        exit 0
    fi
fi

exit 1
