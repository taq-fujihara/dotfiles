function fish_user_key_bindings
  for mode in insert default visual
    fish_default_key_bindings -M $mode
  end
  fish_vi_key_bindings --no-erase

  # map escape
  bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
end

set -g fish_key_bindings fish_vi_key_bindings

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
abbr --add p python
abbr --add v nvim
abbr --add v. nvim .
abbr --add mkdirp mkdir -p
abbr --add ll eza --icons --git --time-style relative -al
abbr --add clip xclip -sel clip
abbr --add C --position anywhere --set-cursor "% | xclip -sel clip"
abbr --add B --position anywhere --set-cursor "% | bat"
abbr --add G --position anywhere --set-cursor "% | rg"

#################################################
# Path
#################################################
fish_add_path --global --move /usr/local/go/bin
fish_add_path --global --move ~/.local/bin
fish_add_path --global --move ~/go/bin
set -x PATH $PATH ./node_modules/.bin

if test (uname) = 'Darwin'
  fish_add_path --global --move /Applications/WezTerm.app/Contents/MacOS
end

#################################################
# Environment Variables
#################################################
set -x PIPENV_VENV_IN_PROJECT 1

#################################################
# Keybindings
#################################################
fzf_configure_bindings --directory=\cf --variables=\e\cv # Ctrl+Alt+v

#################################################
# Shell Integration
#################################################
starship init fish | source
if test -f /home/linuxbrew/.linuxbrew/bin/brew
  /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end
# These are installed via homebrew. So these are not in the path
# before `brew shellenv` is sourced.
mise activate fish | source
direnv hook fish | source
# # shell becomes a bit slow when Devbox is used as global package manager
# devbox global shellenv --init-hook | source
