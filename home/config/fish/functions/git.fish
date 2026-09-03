function git -d "git command wrapper"
    if not __git_wrapper_warn_jj_repo $argv
        return 1
    end

    if __git_wrapper_disable_side_by_side_diff
        command git -c delta.side-by-side=false $argv
    else
        command git $argv
    end
end

function __git_wrapper_warn_jj_repo
    if set -q GIT_WRAPPER_NO_JJ_WARN
        return
    end

    if not __git_wrapper_may_mutate_repo $argv
        return
    end

    set -l root (__git_wrapper_root $argv)

    if test -n "$root"; and test -d "$root/.jj"
        echo "warning: this repo has .jj; consider using jj" >&2
        read --local --prompt-str "Continue? [y/N] " answer

        switch $answer
            case y Y yes YES
                return 0
            case '*'
                echo "aborted" >&2
                return 1
        end
    end
end

function __git_wrapper_may_mutate_repo
    set -l subcommand (__git_wrapper_subcommand $argv)
    set -l mutating_subcommands \
        add \
        branch \
        checkout \
        cherry-pick \
        clean \
        commit \
        merge \
        mv \
        pull \
        push \
        rebase \
        reset \
        restore \
        rm \
        stash \
        switch \
        tag

    contains -- $subcommand $mutating_subcommands
end

function __git_wrapper_subcommand
    set -l argc (count $argv)
    set -l i 1

    while test $i -le $argc
        set -l arg $argv[$i]

        switch $arg
            case --
                return 1
            case -C -c --git-dir --work-tree --namespace
                set i (math $i + 1)
            case '-C=*' '-c=*' '--git-dir=*' '--work-tree=*' '--namespace=*'
            case '-*'
            case '*'
                echo $arg
                return 0
        end

        set i (math $i + 1)
    end

    return 1
end

function __git_wrapper_root
    set -l options (__git_wrapper_global_options $argv)

    command git $options rev-parse --show-toplevel 2>/dev/null
end

function __git_wrapper_global_options
    set -l argc (count $argv)
    set -l i 1

    while test $i -le $argc
        set -l arg $argv[$i]

        switch $arg
            case --
                return
            case -C -c --git-dir --work-tree --namespace
                echo $arg
                set i (math $i + 1)

                if test $i -le $argc
                    echo $argv[$i]
                end
            case '-C=*' '-c=*' '--git-dir=*' '--work-tree=*' '--namespace=*'
                echo $arg
            case '-*'
                echo $arg
            case '*'
                return
        end

        set i (math $i + 1)
    end
end

function __git_wrapper_disable_side_by_side_diff
    set -l cols $COLUMNS

    if test -z "$cols"
        set cols (tput cols 2>/dev/null)
    end

    if test -z "$cols"
        set cols 80
    end

    test $cols -lt 160
end
