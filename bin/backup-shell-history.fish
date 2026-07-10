#!/usr/bin/env fish

if not set -q BACKUP_ROOT
    echo "BACKUP_ROOT is not set. Please set it to the backup destination."
    exit 1
end

echo "Backing up shell history file to $BACKUP_ROOT"

mkdir -p $BACKUP_ROOT/.local/share/fish
rsync -avh ~/.local/share/fish/fish_history $BACKUP_ROOT/.local/share/fish/fish_history

