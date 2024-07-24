function wkdir -d "Create a work directory and set CWD"
    argparse 'p/parmanent=' -- $argv
    or return

    set -l temporary_destination /tmp/work
    set -l parmanent_destination $HOME/work

    set -l destination $temporary_destination
    set -l suffix (date "+%H%M%S")

    if set -lq _flag_p
        set destination $parmanent_destination
        set suffix $_flag_p
    end

    echo creating $destination/(date "+%Y-%m-%d")_$suffix ...

    mkdir -p $destination

    set -l work_dir $destination/(date "+%Y-%m-%d")_$suffix
    mkdir $work_dir
    cd $work_dir
end
