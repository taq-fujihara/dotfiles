function git

    set -l is_force_push (echo 0)
    if contains push $argv
        if contains -- -f $argv
            set is_force_push (echo 1)
        else if contains -- --force $argv
            set is_force_push (echo 1)
        end
    end

    if [ "$is_force_push" = 1 ]
        echo '**' \"force push\" detected '**'
        set -l current_branch (command git -C $PWD rev-parse --abbrev-ref HEAD)

        read answer --prompt-str="Type current branch name to force push: "

        if [ $answer != $current_branch ]
            echo "You typed wrong branch name. Please try again."
            return 1
        else
            echo You typed correct branch name. Proceeding to force push.
        end
    end

    command git $argv
end
