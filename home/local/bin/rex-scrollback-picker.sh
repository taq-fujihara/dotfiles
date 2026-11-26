#!/bin/bash
set -euo pipefail

work=$(mktemp -d)
cleanup() {
    status=$?
    rm -rf -- "$work"
    if [ "$status" -ne 0 ]; then
        printf 'Picker failed (%s). Press Enter to close.' "$status" >&2
        read -r ignored || true
    fi
}
trap cleanup EXIT
trap 'exit 0' HUP INT TERM

source_block=${1:?Usage: rex-scrollback-picker.sh BLOCK_ID}
rex capture -b "$source_block" --trim --unwrap > "$work/scrollback"

LC_ALL=C awk '
function ipv4(value, parts, n, i) {
    n = split(value, parts, ".")
    if (n != 4) return 0

    for (i = 1; i <= n; i++)
        if (length(parts[i]) > 3 || parts[i] + 0 > 255) return 0
    return 1
}

function ipv6(value, groups, n, i, count, compressed) {
    sub(/%.*/, "", value)
    if (index(value, ":::")) return 0

    compressed = index(value, "::")
    if (compressed && index(substr(value, compressed + 2), "::")) return 0
    if (!compressed && (value ~ /^:/ || value ~ /:$/)) return 0

    n = split(value, groups, ":")
    for (i = 1; i <= n; i++) {
        if (groups[i] == "") continue
        if (length(groups[i]) > 4 || groups[i] ~ /[^0-9a-fA-F]/) return 0
        count++
    }
    return compressed ? count < 8 : count == 8
}

BEGIN {
    # Earlier patterns take precedence within each token.
    patterns[1] = "[a-zA-Z][a-zA-Z0-9+.-]*://.+"
    patterns[2] = "[~.]*/.+"
    patterns[3] = "[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+"
    patterns[4] = "[a-fA-F0-9:]+:[a-fA-F0-9:]+%?[a-zA-Z0-9]*"
}

{
    gsub(/[<>[:cntrl:]"\047`]/, " ")
    for (i = 1; i <= NF; i++) {
        for (p = 1; p <= 4; p++) {
            if (!match($i, patterns[p])) continue
            value = substr($i, RSTART, RLENGTH)
            while (length(value) && index(".,;!?)]", substr(value, length(value))))
                value = substr(value, 1, length(value) - 1)
            if (value == "") continue
            if (p == 3 && !ipv4(value)) continue
            if (p == 4 && !ipv6(value)) continue

            if (!(value in seen)) {
                seen[value] = 1
                items[++total] = value
            }
            break
        }
    }
}

END {
    for (i = total; i > 0; i--) print items[i]
}
' "$work/scrollback" > "$work/matches"

status=0
selection=$(FZF_DEFAULT_OPTS= FZF_DEFAULT_OPTS_FILE= fzf \
    --no-multi --layout=reverse --border --no-sort \
    --prompt='Select> ' --header='Enter: copy / Alt+Enter: insert / Esc: cancel' \
    --expect=enter,alt-enter \
    --bind=esc:abort,ctrl-c:abort < "$work/matches") || status=$?

case "$status" in
    0) ;;
    1|130) exit 0 ;;
    *) exit "$status" ;;
esac

key=${selection%%$'\n'*}
selection=${selection#*$'\n'}

case "$key" in
    enter) printf '%s' "$selection" | /usr/bin/pbcopy ;;
    alt-enter) printf '%s' "$selection" | rex send -b "$source_block" ;;
esac
