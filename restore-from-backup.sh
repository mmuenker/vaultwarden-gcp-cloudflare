#!/bin/bash

docker compose down

docker volume create vaultwarden_data || true

tar -xf $1 -C /tmp/data

docker run -v vaultwarden_data:/data -v "/tmp/data:/restore" alpine mv /restore /data

