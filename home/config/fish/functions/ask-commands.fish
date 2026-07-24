function ask-commands
  argparse 'h/note-hint=' 'D/dry-run' -- $argv
  or return

  if set -q _flag_h; and set -q DENDRON_ROOT; and set -q DENDRON_PRIMARY_VAULT
    set note_hint $_flag_h

    set body_matches (
    rg \
      --ignore-case \
      --glob '*.md' \
      --context 3 \
      --max-count 10 \
      --no-filename \
      --word-regexp \
      "$note_hint" \
      "$DENDRON_ROOT/$DENDRON_PRIMARY_VAULT/notes/"
    )
  end

  set -l question (string join " " $argv)

  if isatty stdin
    # no input from pipe
  else
    # input from pipe, this will be used as context for the question
    read -z context
  end

  if test -z "$question" -a -z "$context"
    echo "Usage: ask-commands [--dry-run] <question>" >&2
    echo "       <command> | ask-commands [--dry-run] <question>" >&2
    return 1
  end

  set -l prompt_file (mktemp)

  begin
    if test -n "$body_matches"
      echo "以下は関連するノートの抜粋です:"
      echo "- 回答ではこの内容を優先してください"
      echo "- 答えがこのノート抜粋に含まれている場合はその内容を要約してください"
      echo "- このノート抜粋に不足がある場合のみ一般知識で補足してください"
      echo "- どこまでがこのノート抜粋由来で、どこからが補足なのか分かるようにしてください"
      echo '~~~'
      printf '%s\n' $body_matches
      echo '~~~'
      echo
    end

    if test -n "$context"
      echo "以下は参考情報です:"
      echo '~~~'
      printf '%s\n' $context
      echo '~~~'
      echo
    end

    if test -n "$question"
      echo "質問:"
      printf '%s\n' "$question"
    end

  end > $prompt_file

  set -l system_prompt_replace "あなたは Linux コマンドの提案アシスタントです。1) 指定されない場合シェルはfishを前提とします 2) 提案のみ行い、実行やファイル編集は行いません 3) まず最もシンプルなコマンドを1つ提示します 4) 必要なら代替案を最大2つ提示します 5) 説明は2〜3文以内です 6) コマンドは\`fish\`ブロックで出力します"

  if set -q _flag_dry_run
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│ Dry run mode: The following prompt would be sent to the AI │"
    echo "╰────────────────────────────────────────────────────────────╯"
    echo "System prompt:"
    echo "$system_prompt_replace"
    echo
    cat $prompt_file
  else
    pi \
      --provider openai-codex \
      --model gpt-5.4-mini:low \
      --exclude-tools write \
      --exclude-tools edit \
      --exclude-tools bash \
      --no-context-files \
      --no-skills \
      --no-prompt-templates \
      --no-extensions \
      --system-prompt $system_prompt_replace \
      -p "この要求を満たすLinuxコマンドを教えてください" < $prompt_file
  end

  command rm -f $prompt_file
end
