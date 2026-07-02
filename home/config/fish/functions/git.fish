function git -d "git wrapper that disables side-by-side diff when the terminal is narrow"
    set -l cols $COLUMNS

    if test -z "$cols"
        set cols (tput cols 2>/dev/null)
    end

    if test -z "$cols"
        set cols 80
    end

    if test $cols -lt 160
        command git -c delta.side-by-side=false $argv
    else
        command git $argv
    end
end
