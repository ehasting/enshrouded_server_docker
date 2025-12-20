#!/usr/bin/bash

mkdir -p data

podman run --rm -it --name enshroudedserver -p 15637:15637/udp \
       -v ./data:/data:Z \
        enshrouded_server_custom:latest
