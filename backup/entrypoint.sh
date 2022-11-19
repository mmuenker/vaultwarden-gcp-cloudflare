#!/bin/sh

echo "Loading crontab file"

crontab /crontab

echo "Starting cron..."

crond -f
