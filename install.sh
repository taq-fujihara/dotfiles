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
    "exa"
    "delta"
    "nvim"
    "wezterm"
    "xh"
    "zip"
    "unzip"
    "lazygit"
    "fish"
    "fisher"
)

# preparation
sudo apt update
sudo apt-get update
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

    echo "$installer command not found. Install."
    "./install/$installer"

    if [ $? = 0 ]; then
        echo '--------------------------------------------------'
        echo "Installing \"${installer}\" completed!!!"
        echo '--------------------------------------------------'
    else
        echo '--------------------------------------------------'
        if ! ./bin/prompt.sh "Seems installing ${installer} failed... Continue?"; then
            exit 1
        fi
    fi
done

# additional installation
declare -a installers=(
    "astronvim.sh"
)
for installer in ${installers[@]}; do
    echo ''
    echo ''
    echo ''

    "./install/$installer"

    if [ $? = 0 ]; then
        echo '--------------------------------------------------'
        echo "Installing \"${installer}\" completed!!!"
        echo '--------------------------------------------------'
    else
        echo '--------------------------------------------------'
        if ! ./bin/prompt.sh "Seems installing ${installer} failed... Continue?"; then
            exit 1
        fi
    fi
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
