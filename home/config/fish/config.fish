# function fish_prompt
#   powerline-shell --shell bare $status
# end

fish_vi_key_bindings

set -U FZF_LEGACY_KEYBINDINGS 0

function fish_user_key_bindings
  for mode in insert default visual
    fish_default_key_bindings -M $mode
  end
  fish_vi_key_bindings --no-erase

  # map escape
  bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
end

function before_command --on-event fish_preexec
  if test -d "node_modules"
    # add node module binary path when node_modules directory.
    # just bypass npx...
    set -x PATH $PATH ./node_modules/.bin
  end
end

function after_command --on-event fish_postexec
  if set -l index (contains -i "./node_modules/.bin" $PATH)
    # remove node module binary path if it exists.
    # cleaning up a mess created in preexec.
    set -e PATH[$index]
  end
end

#################################################
# asdf setup
#################################################

source ~/.asdf/asdf.fish

starship init fish | source

#################################################
# Abbreviations
#################################################
abbr --add ll exa --icons -la

#################################################
# Path
#################################################
fish_add_path --global --move /usr/local/go/bin
fish_add_path --global --move ~/.local/bin
fish_add_path --global --move ~/go/bin
