function git_root -d "cd to git root"
    cd (git rev-parse --show-toplevel)
end
