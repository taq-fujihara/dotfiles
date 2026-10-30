#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 || ( "$1" != up && "$1" != down ) ]]; then
    printf 'Usage: %s <up|down>\n' "${0##*/}" >&2
    exit 1
fi

direction=$1

for command in niri jq flock; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$command" >&2
        exit 1
    fi
done

exec 9>"${XDG_RUNTIME_DIR:?}/niri-create-and-move-window.lock"
flock -x 9

workspaces=$(niri msg --json workspaces)
if ! original_index=$(jq -er '.[] | select(.is_focused) | .idx' <<<"$workspaces"); then
    printf 'No focused workspace.\n' >&2
    exit 1
fi
last_index=$(jq -er '
    (.[] | select(.is_focused) | .output) as $output
    | [.[] | select(.output == $output) | .idx] | max
' <<<"$workspaces")

# 末尾の空ワークスペースにフォーカスし、現在位置の上か下へ移す。
niri msg action focus-workspace "$last_index"

target_index=$original_index
if [[ "$direction" == down ]]; then
    target_index=$((target_index + 1))
fi

niri msg action move-workspace-to-index "$target_index"
