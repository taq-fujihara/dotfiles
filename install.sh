#!/usr/bin/bash

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

    if ./bin/installed.sh $installer; then
        echo "$installer is already installed."
        continue
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

./bin/create_links.sh

# fish path
echo ''
echo ''
echo ''
echo 'setting fish path...'
./bin/set_path.fish

# Login Shell
if [ $SHELL != "/usr/bin/fish" ]; then
    read -p "Change Login Shell to fish? [y/N]: " answer
    if [ $answer = 'y' ]; then
        chsh -s /usr/bin/fish
    fi
fi
