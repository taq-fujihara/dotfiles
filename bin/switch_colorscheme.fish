#!/usr/bin/env fish

set color $argv[1]

echo
echo "Switching color scheme to \"$color\"..."

echo
echo "# Environment Variable"
echo
sed -i -e "s/set -x MY_COLOR_SCHEME .*/set -x MY_COLOR_SCHEME $color/" home/config/fish/config.fish
source ~/.config/fish/config.fish
echo '  changed MY_COLOR_SCHEME value in config.fish to "'$color'"'
echo '  Done!'

echo
echo "# Wezterm"
echo

set -l wez_color_scheme_name ""
switch $color
case "iceberg"
    set wez_color_scheme_name "iceberg-dark"
case "everforest"
    set wez_color_scheme_name "Everforest Dark (Gogh)"
case "tokyonight"
    set wez_color_scheme_name "Tokyo Night"
case "ayu"
    set wez_color_scheme_name "Ayu Mirage"
case "nord"
    set wez_color_scheme_name "nord"
end

sed -i -e "s/local COLOR_SCHEME = \".*\"/local COLOR_SCHEME = \"$wez_color_scheme_name\"/g" home/config/wezterm/wezterm.lua
echo '  changed "COLOR_SCHEME" value in wezterm.lua to"'$wez_color_scheme_name'"'
echo '  Done!'

echo
echo "# VSCode"
echo

function update_vscode_color_theme
    set -l settings_json_path $argv[1]

    set -l vscode_color_theme_name ""
    switch $color
    case "iceberg"
        set vscode_color_theme_name "Iceberg"
    case "everforest"
        set vscode_color_theme_name "Everforest Dark"
    case "tokyonight"
        set vscode_color_theme_name "Tokyo Night"
    case "ayu"
        set vscode_color_theme_name "Ayu Mirage"
    case "nord"
        set vscode_color_theme_name "Nord"
    end

    if test -f $settings_json_path
        sed -i -e "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$vscode_color_theme_name\"/" $settings_json_path
        echo '  changed "workbench.colorTheme" value to "'$vscode_color_theme_name'" in '$settings_json_path
    end
end

update_vscode_color_theme ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
update_vscode_color_theme ~/Library/Application\ Support/Code/User/settings.json

echo '  Done!'
