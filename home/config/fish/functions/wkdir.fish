function wkdir -d "Create a work directory and set CWD"
    argparse 's/suffix=' 'p/parmanent' -- $argv

    set -l destination /tmp/work
    if set -lq _flag_p
        set destination $HOME/work
    end
    mkdir -p $destination

    set -lq _flag_s
    or set -l _flag_s (date "+%H%M%S")

    set d $destination/(date "+%Y-%m-%d")-$_flag_s
    mkdir $d
    cd $d
end
