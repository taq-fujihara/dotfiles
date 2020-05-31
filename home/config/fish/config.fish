function fish_prompt
  powerline-shell --shell bare $status
end

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

#################################################
# Aliases
#################################################

alias ll='ls -alF'

