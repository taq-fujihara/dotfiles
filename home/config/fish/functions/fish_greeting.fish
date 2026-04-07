function fish_greeting
  set -l frost1 8FBCBB
  set -l frost2 88C0D0
  set -l frost3 81A1C1
  set -l frost4 5E81AC

  echo
  echo (set_color $frost1)"   Terminal Session Active"
  echo (set_color 4C566A)" ---------------------------"
  echo (set_color D8DEE9)" User: " (set_color $frost2)$USER
  echo (set_color D8DEE9)" Host: " (set_color $frost3)(hostname)
  echo (set_color D8DEE9)" Date: " (set_color $frost4)(date "+%Y.%m.%d %H:%M")

  set -l date_fmt '+%Y%m%d'
  set -l cache_dir $HOME/.cache/dendron
  set -l today (date $date_fmt)
  set -l last_run_file "$cache_dir/last_pull"

  if not test -d "$cache_dir"
    mkdir -p $cache_dir
  end

  if test -f "$last_run_file"
    set -l last_run_day (date -r "$last_run_file" $date_fmt)

    if test "$last_run_day" = "$today"
      return 0
    end
  end

  # -------------------------------------------

  set -l root $DENDRON_ROOT
  
  if not test -d "$root"
    echo '"DENDRON_ROOT" is not set. done.'
    return 0
  end

  echo "⚡ Dendron Vault Update"

  if test -d "$root/.git"
    echo "🏭 Updating Dendron vault at $root"
    git -C $root pull
  end

  set -l dependencies_root $root/dependencies

  if not test -d "$dependencies_root"
    echo "No dependencies found. done."
    return 0
  end

  set -l providers (path filter --type dir -- $dependencies_root/*)

  for provider in $providers
    set -l users (path filter --type dir -- $provider/*)

    for user in $users
      set -l vault_repos (path filter --type dir -- $user/*)

      for vault_repo in $vault_repos
        echo $vault_repo

        if test -d "$vault_repo/.git"
          echo "🏭 Updating vault at $vault_repo"
          git -C $vault_repo pull
        end
      end
    end
  end

  touch $last_run_file

  return 0
end
