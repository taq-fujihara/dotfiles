function npmi
  if test (uname) = "Darwin"
    echo "Platform \"Darwin\" detected. node_modules/.metadata_never_index is being created if n    ot exists..."
    if not test -d node_modules
      mkdir node_modules
    end
    if not test -e node_modules/.metadata_never_index
      touch node_modules/.metadata_never_index
    end
    npm install
  end
end
