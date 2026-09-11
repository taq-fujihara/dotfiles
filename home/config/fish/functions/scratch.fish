function scratch -d "Create a scratch file and open it in Neovim"
    argparse 'p/permanent=' -- $argv
    or return

    set -l destination /tmp/scratch
    set -l suffix (date "+%H%M%S")

    if set -q _flag_p
        set destination $HOME/scratch
        set suffix $_flag_p
    end

    mkdir -p $destination
    or return

    set -l scratch_file (
        mktemp --suffix=.txt "$destination/"(date "+%Y-%m-%d")_"$suffix"_XXXX
    )
    or return

    nvim $scratch_file
    set -l nvim_status $status

    if test -e $scratch_file; and not test -s $scratch_file
        rm -- $scratch_file
    end

    return $nvim_status
end
