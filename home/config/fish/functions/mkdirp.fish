# Defined in - @ line 1
function mkdirp --wraps=mkdir
  mkdir -p $argv;
end
