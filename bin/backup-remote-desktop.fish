#!/usr/bin/env fish

if not set -q BACKUP_ROOT
    echo "BACKUP_ROOT is not set. Please set it to the backup destination."
    exit 1
end

echo "Backing up remote desktop entries to $BACKUP_ROOT"

mkdir -p $BACKUP_ROOT/.var/app/org.remmina.Remmina/data/remmina
rsync -avh ~/.var/app/org.remmina.Remmina/data/remmina/ $BACKUP_ROOT/.var/app/org.remmina.Remmina/data/remmina/
