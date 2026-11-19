#!/usr/bin/env bash
#
#

set -euo pipefail
umask 077

BACKUP_DIR="/opt/mysql_backup"
DATABASE="lesson9_db"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/${DATABASE}_${TIMESTAMP}.sql"

mkdir -p "$BACKUP_DIR"

echo "Starting backup of $DATABASE"

if mysqldump \
    --single-transaction \
    --databases "$DATABASE" \
    --result-file="$BACKUP_FILE"
then
    echo "Backup successful: $BACKUP_FILE"
else
    rm -f "$BACKUP_FILE"
    echo "Backup failed!" >&2
    exit 1
fi

echo "Starting rsync..."

rsync -av \
  -e "ssh -i /root/.ssh/mysql_backup_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes" \
  "$BACKUP_DIR/" \
  vagrant@192.168.56.31:/opt/store/mysql/

echo "Sync completed!"
