#!/bin/bash

docker compose down

docker volume create vaultwarden_data || true

mkdir -p /tmp/data

tar -xf $1 -C /tmp/data

docker run --rm -v vaultwarden_data:/data -v "/tmp/data:/restore" alpine mv /restore /data

sudo rm -fr /tmp/data