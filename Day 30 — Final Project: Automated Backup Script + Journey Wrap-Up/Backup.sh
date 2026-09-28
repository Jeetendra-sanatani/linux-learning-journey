#!/bin/bash
# backup.sh — Automated Backup Script
# Day 30 final project — Linux Learning Journey

SOURCE="$HOME/practice"
DEST="$HOME/backups"
DATE=$(date +%F_%H-%M)
BACKUP_FILE="$DEST/backup_$DATE.tar.gz"
LOG="$DEST/backup.log"
KEEP_DAYS=7

log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG"
}

setup() {
    mkdir -p "$DEST"
    if [ ! -d "$SOURCE" ]; then
        log "ERROR: source folder $SOURCE not found"
        exit 1
    fi
}

create_backup() {
    log "Starting backup of $SOURCE"
    if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"; then
        log "Backup created: $BACKUP_FILE"
    else
        log "ERROR: backup failed"
        exit 1
    fi
}

verify_backup() {
    if tar -tzf "$BACKUP_FILE" > /dev/null 2>&1; then
        SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
        log "Verified OK (size: $SIZE)"
    else
        log "ERROR: backup file is corrupted"
        exit 1
    fi
}

cleanup_old() {
    log "Removing backups older than $KEEP_DAYS days"
    find "$DEST" -name "backup_*.tar.gz" -mtime +$KEEP_DAYS -exec rm {} \;
}

main() {
    setup
    create_backup
    verify_backup
    cleanup_old
    log "Backup complete"
}

main
