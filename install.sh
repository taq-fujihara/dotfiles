#!/usr/bin/bash

source ./bin/create_links.sh

declare -a installers=(
    "git"
    "curl"
    "wget"
    "starship"
    "asdf"
    "go"
    "ghq"
    "fzf"
    "rg"
    "bat"
    "delta"
    "xh"
    "zip"
    "unzip"
    "fish"
    "fisher"
)

source ./bin/set_path_temporarily.sh

for installer in ${installers[@]}; do
    echo ''
    echo ''
    echo ''
    echo "Checking if $installer is installed..."

    if type "$installer" > /dev/null 2>&1; then
        echo $installer is already installed.
        continue
    fi
    if type "fish" > /dev/null 2>&1; then
        fish -c "type -q ${installer}"
        if [ $? = 0 ]; then
            echo $installer is already installed \(in fish\).
            continue
        fi
    fi

    read -p "$installer command not found. Install? [Enter or y / N]: " answer
    if [ ! -z "$answer" ] && [ $answer != 'y' ]; then
        echo "$answer: skip installation..."
        continue
    fi

    "./install/$installer"

    echo '--------------------------------------------------'
    echo "Installer \"${installer}\" completed."
    echo '--------------------------------------------------'
done

# Login Shell
if [ $SHELL != "/usr/bin/fish" ]; then
    read -p "Change Login Shell to fish? [y/N]: " answer
    if [ $answer = 'y' ]; then
        chsh -s /usr/bin/fish
    fi
fi

# fish path
./bin/set_path.fish

