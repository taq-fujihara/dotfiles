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

# preparation
source ./bin/set_path_temporarily.sh
mkdir -p ~/.local/bin

for installer in ${installers[@]}; do
    echo ''
    echo ''
    echo ''
    echo "Checking if $installer is installed..."

    if ./bin/installed.sh $installer; then
        echo "$installer is already installed."
        continue
    fi

    if ! ./bin/prompt.sh "$installer command not found. Install?"; then
        echo "$answer: skip installation..."
        continue
    fi

    "./install/$installer"

    echo '--------------------------------------------------'
    echo "Installer \"${installer}\" completed."
    echo '--------------------------------------------------'
done

echo ''
echo ''
echo ''
if ./bin/prompt.sh "Create links?"; then
    ./bin/create_links.sh
fi

# Login Shell
if [ $SHELL != "/usr/bin/fish" ]; then
    echo ''
    echo ''
    echo ''
    if ./bin/prompt.sh "Change Login Shell to fish?"; then
        chsh -s /usr/bin/fish
    fi
fi
