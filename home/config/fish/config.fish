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

source ~/.asdf/asdf.fish

#################################################
# Abbreviations
#################################################
abbr --add c code-insiders
abbr --add c. code-insiders .
abbr --add d docker
abbr --add g git
abbr --add p python
abbr --add v nvim
abbr --add v. nvim .
abbr --add mkdirp mkdir -p
abbr --add ll exa --icons -la
abbr --add clip xclip -sel clip
abbr --add C --position anywhere --set-cursor "% | xclip -sel clip"
abbr --add B --position anywhere --set-cursor "% | bat"
abbr --add drunpostgres --set-cursor "docker run --rm --name my-postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:%"
abbr --add dexecbash --set-cursor "docker exec -it % /bin/bash"

#################################################
# Path
#################################################
fish_add_path --global --move /usr/local/go/bin
fish_add_path --global --move ~/.local/bin
fish_add_path --global --move ~/go/bin

#################################################
# Environment Variables
#################################################
set -x PIPENV_VENV_IN_PROJECT 1

starship init fish | source
