#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
    printf 'Usage: %s MESSAGE\n' "$0" >&2
    exit 2
fi

while true; do
    printf '%s [Y/n] ' "$1" >&2
    if ! IFS= read -r answer; then
        exit 1
    fi

    case "$answer" in
        ''|[Yy]|[Yy][Ee][Ss]) exit 0 ;;
        [Nn]|[Nn][Oo]) exit 1 ;;
        *) printf 'Please enter y or n.\n' >&2 ;;
    esac
done
