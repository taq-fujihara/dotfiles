function zf
    set -l picked (z --list | awk '{print $2}' | fzf)
    if test -z "$picked"
        return 1
    end
    cd $picked
end
