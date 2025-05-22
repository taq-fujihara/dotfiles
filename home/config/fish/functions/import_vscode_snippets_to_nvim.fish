function import_vscode_snippets_to_nvim
  set -l platform (uname)
  set -l vscode_snippets_dir "$HOME/.config/Code/User/snippets"
  set -l nvim_snippets_dir "$HOME/.config/nvim/snippets"

  mkdir -p $nvim_snippets_dir

  if test "$platform" = "Darwin"
    set vscode_snippets_dir "$HOME/Library/Application Support/Code/User/snippets"
  end

  for f in $vscode_snippets_dir/*
    set -l new_name (string replace -r '\.json$' '.jsonc' $f)

    set -l link_name (basename $new_name)

    ln -f "$f" "$nvim_snippets_dir/$link_name"
  end
end
