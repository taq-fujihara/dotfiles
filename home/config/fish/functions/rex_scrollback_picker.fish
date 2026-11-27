function rex_scrollback_picker -d "Copy or insert a scrollback match" -a source_block insert_target
    if test (count $argv) -lt 1; or test (count $argv) -gt 2; or test -z "$source_block"; or not contains -- "$insert_target" "" commandline
        echo "Usage: rex_scrollback_picker BLOCK_ID [commandline]" >&2
        return 2
    end

    set -l max_lines 5000
    set -l matches (rex capture -b "$source_block" --trim --unwrap | tail -n "$max_lines" | LC_ALL=C awk '
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
    patterns[3] = "[0-9]+\\\\.[0-9]+\\\\.[0-9]+\\\\.[0-9]+"
    patterns[4] = "[a-fA-F0-9:]+:[a-fA-F0-9:]+%?[a-zA-Z0-9]*"
}

{
    gsub(/[<>[:cntrl:]"\\047`]/, " ")
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
')
    set -l pipeline_status $pipestatus
    set -l result 0
    for pipeline_result in $pipeline_status
        if test $pipeline_result -ne 0
            set result $pipeline_result
            break
        end
    end
    if test $result -ne 0
        return $result
    end

    set -l selection (string join \n -- $matches | FZF_DEFAULT_OPTS= FZF_DEFAULT_OPTS_FILE= fzf \
        --no-multi --layout=reverse --border --no-sort \
        --prompt='Select> ' --header='Enter: copy / Alt+Enter: insert / Esc: cancel' \
        --expect=enter,alt-enter \
        --bind=esc:abort,ctrl-c:abort)
    set result $status

    switch $result
        case 1 130
            return 0
        case 0
        case '*'
            return $result
    end

    switch "$selection[1]"
        case enter
            printf '%s' "$selection[2]" | fish_clipboard_copy
        case alt-enter
            if test "$insert_target" = commandline
                commandline --insert -- "$selection[2]"
            else
                printf '%s' "$selection[2]" | rex send -b "$source_block"
            end
    end
end
