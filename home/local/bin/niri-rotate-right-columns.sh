#!/usr/bin/env bash

(
    flock -x 9 || exit 0

    original_id=$(
        niri msg --json focused-window | jq -r '.id'
    )

    [[ "$original_id" =~ ^[0-9]+$ ]] || exit 1

    niri msg action focus-column-right &&
    niri msg action move-column-to-last

    niri msg action focus-window --id "$original_id"

    sleep 0.15
) 9>"${XDG_RUNTIME_DIR}/niri-rotate.lock"
