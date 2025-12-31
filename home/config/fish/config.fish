#################################################
# Theme
#################################################

fish_config theme choose nord

#################################################
# Key Bindings
#################################################

function fish_user_key_bindings
  for mode in insert default visual
    fish_default_key_bindings -M $mode
  end
  fish_vi_key_bindings --no-erase

  # map escape
  bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
end

set -g fish_key_bindings fish_vi_key_bindings

fzf_configure_bindings --directory=\cf --variables=\e\cv # Ctrl+Alt+v

#################################################
# Aliases
#################################################

alias rm='rm -i'

#################################################
# Abbreviations
#################################################

abbr --add b bat
abbr --add c code-insiders
abbr --add c. code-insiders .
abbr --add d docker
abbr --add g git
abbr --add j jj
abbr --add o open
abbr --add o. open .
abbr --add p python
abbr --add v nvim
abbr --add v. nvim .
abbr --add mkdirp mkdir -p
abbr --add ll eza --icons --git --time-style relative -al
abbr --add mr mise run
abbr --add mx mise exec --
abbr --add clip fish_clipboard_copy
abbr --add C --position anywhere --set-cursor "% | fish_clipboard_copy"
abbr --add B --position anywhere --set-cursor "% | bat"
abbr --add G --position anywhere --set-cursor "% | rg"
abbr --add F --position anywhere --set-cursor "% | fzf"

#################################################
# Path
#################################################

fish_add_path --global --move /usr/local/go/bin
fish_add_path --global --move ~/.local/bin
fish_add_path --global --move ~/go/bin

if test (uname) = 'Darwin'
  fish_add_path --global --move /Applications/WezTerm.app/Contents/MacOS
end

#################################################
# Environment Variables
#################################################

set -x PIPENV_VENV_IN_PROJECT 1
set -x MY_COLOR_SCHEME nord


#################################################
# Shell Integration
#################################################

if test -f /home/linuxbrew/.linuxbrew/bin/brew
  /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end
starship init fish | source
# These are installed via homebrew. So these are not in the path
# before `brew shellenv` is sourced.
mise activate fish | source
direnv hook fish | source
zoxide init fish | source
