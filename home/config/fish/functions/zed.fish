function zed -d "merge settings and open zed"
  set -l zed_path $HOME/.config/zed

  if test -f $zed_path/settings.base.json; and test -f $zed_path/settings.override.json
    sed '/^\/\//d' $zed_path/settings.base.json > $zed_path/.settings.base.json.tmp
    jq -s add $zed_path/.settings.base.json.tmp $zed_path/settings.override.json > $zed_path/settings.json
  end
  
  command zed $argv
end
