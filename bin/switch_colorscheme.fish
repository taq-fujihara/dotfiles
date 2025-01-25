#!/usr/bin/env fish

set color $argv[1]

echo
echo "Switching color scheme to \"$color\"..."

echo
echo "# Environment Variable"
echo
echo "set -x MY_COLOR_SCHEME $color" > ~/.config/fish/conf.d/color.fish
source ~/.config/fish/conf.d/color.fish
echo '  changed MY_COLOR_SCHEME value to "'$color'"'
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

echo "return \"$wez_color_scheme_name\"" > ~/.config/wezterm/color.lua
echo '  wrote "'$wez_color_scheme_name'" to ~/.config/wezterm/color.lua'
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
