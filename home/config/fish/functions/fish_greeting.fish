function fish_greeting
    set cur_dir (pwd)

    if test -d ~/dotfiles
        cd ~/dotfiles

        set count (git status --short --porcelain | wc -l)
        set count (string trim "$count")
        if test "$count" != "0"
            echo (set_color yellow; echo '=========================================='; set_color normal)
            echo 'Looks dotfiles has uncommited changes...'
            echo 'Forgot to commit?'
            git status --short
            echo (set_color yellow; echo '=========================================='; set_color normal)
        end

        cd $cur_dir
    end
end
