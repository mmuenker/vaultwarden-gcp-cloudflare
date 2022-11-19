#!/bin/sh

echo "sync with rclone"

REMOTE=$(rclone --config /rclone.conf listremotes | head -n 1)
echo "use rclone remote >$RMOTE<"
rclone --config /rclone.conf sync /backups $REMOTE/vaultwarden
