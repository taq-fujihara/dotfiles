function fish_title
  set -l current_cmd (status current-command)
  set -l path $(prompt_pwd)

  if set -l git_root (git rev-parse --show-toplevel 2> /dev/null)
    set -l abs_path (pwd)
    set above_root (dirname $git_root)
    set -l len (echo $above_root | string length)
    set below_root (string sub --start (math $len + 2) $abs_path)

    set path "/$below_root"
  end

  echo $current_cmd $path
end
