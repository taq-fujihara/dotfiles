function wkdir -d "Create a work directory and set CWD"
    argparse 's/suffix=' 'p/parmanent' -- $argv

    set -l destination /tmp
    if set -lq _flag_p
        set destination $HOME/work
        mkdir -p $destination
    end

    set -lq _flag_s
    or set -l _flag_s (date "+%H%M%S")

    set d $destination/work_(date "+%Y-%m-%d")-$_flag_s
    mkdir $d
    cd $d
end
