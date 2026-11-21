function wkdir -d "Create a work directory and set CWD"
    argparse 'p/parmanent=' 'l/list' -- $argv
    or return

    set -l temporary_destination /tmp/work
    set -l parmanent_destination $HOME/work

    if set -lq _flag_l
        for work_dir in "$temporary_destination"/*/ "$parmanent_destination"/*/
            printf '%s\n' $work_dir
        end
        return 0
    end

    set -l destination $temporary_destination
    set -l suffix (date "+%H%M%S")

    if set -lq _flag_p
        set destination $parmanent_destination
        set suffix $_flag_p
    end

    mkdir -p $destination

    set -l work_dir $destination/(date "+%Y-%m-%d")_$suffix
    mkdir $work_dir
    cd $work_dir
end
