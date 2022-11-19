#!/bin/sh

# Create backup and prune old backups
# Borrowed heavily from https://github.com/shivpatel/bitwarden_rs-local-backup
# with the addition of backing up:
# * attachments directory
# * sends directory
# * config.json
# * rsa_key* files

# use sqlite3 to create backup (avoids corruption if db write in progress)
SQL_NAME="db.sqlite3"
SQL_BACKUP_DIR="/tmp"
SQL_BACKUP_NAME=$SQL_BACKUP_DIR/$SQL_NAME
sqlite3 /data/$SQL_NAME ".backup '$SQL_BACKUP_NAME'"

# build a string of files and directories to back up
DATA="/data"
cd $DATA
FILES=""
FILES="$FILES $([ -d attachments ] && echo attachments)"
FILES="$FILES $([ -d sends ] && echo sends)"
FILES="$FILES $([ -f config.json ] && echo config.json)"
FILES="$FILES $([ -f rsa_key.der -o -f rsa_key.pem -o -f rsa_key.pub.der ] && echo rsa_key*)"

# tar up files and encrypt with openssl and encryption key
BACKUP_DIR=/backups
BACKUP_FILE=$BACKUP_DIR/"bw_backup_$(date "+%F-%H%M%S").tar.gz"
BACKUP_DAYS=90

tar -czf $BACKUP_FILE -C $SQL_BACKUP_DIR $SQL_NAME -C $DATA $FILES
printf "Backup file created at %b\n" "$BACKUP_FILE" > $LOG

# cleanup tmp folder
rm -f $SQL_BACKUP_NAME

# rm any backups older than 30 days
find $BACKUP_DIR/* -mtime +$BACKUP_DAYS -exec rm {} \;

printf "$BACKUP_FILE"
