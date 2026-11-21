function wkdir_fzf -d "Select a work directory"
    set -l dir (wkdir --list | fzf)

    if test -n "$dir"
        cd -- "$dir"
    end

    commandline -f repaint
end
