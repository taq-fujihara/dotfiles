#!/usr/bin/env fish

# Intended to be run from a VS Code task with two arguments:
#   1. the source image path
#   2. the Markdown file to update
# The script copies the image to the clipboard, creates a .draw.png placeholder,
# and rewrites the Markdown file to point at the new annotated image.

set -l relative_src $argv[1]
set -l md_file_path $argv[2]

set -l md_dir (dirname "$md_file_path")
set -l src (realpath "$md_dir/$relative_src")

set -l relative_dst (string replace -r '\.png$' '.draw.png' "$relative_src")
set -l dst ( string replace -r '\.png$' '.draw.png' "$src")

if not test -f "$src"
    echo "file not found: $src"
    exit 1
end

if test -e "$dst"
    echo "destination already exists: $dst"
    exit 1
end

cat "$src" | wl-copy

touch "$dst"

sd --fixed-strings "$relative_src" "$relative_dst" "$md_file_path"

# no remove the source file at this moment.
# rm -f "$src"

echo "$dst"
