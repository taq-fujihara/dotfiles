#!/usr/bin/fish

if type -q fisher
  echo fisher is installed
  return
end

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

