function note --description 'Open a Dendron note'
  if not set -q DENDRON_PRIMARY_VAULT
    echo "DENDRON_PRIMARY_VAULT is not set."
    return 1
  end

  set -l vault $DENDRON_PRIMARY_VAULT
  set -l query (string join ' ' $argv)

  set -l note_name (
    fd --type f --extension md . "$vault" |
    sd "^$vault/notes/" "" |
    sd "\.md\$" "" |
    fzf \
      --query "$query" \
      --select-1 \
      --exit-0 \
      --preview "bat --style=numbers --color=always '$vault/{}.md'"
  )

  test -n "$note_name"; or return

  pushd "$vault" >/dev/null; or return

  nvim "notes/$note_name.md"

  popd >/dev/null
end
