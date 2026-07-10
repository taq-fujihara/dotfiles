#!/usr/bin/env fish

if not set -q BACKUP_ROOT
    echo "BACKUP_ROOT is not set. Please set it to the backup destination."
    exit 1
end

echo "Backing up secrets to $BACKUP_ROOT"

rsync -avh ~/.ssh/ $BACKUP_ROOT/.ssh/

