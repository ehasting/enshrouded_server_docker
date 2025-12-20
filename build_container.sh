#!/usr/bin/bash

USERNAME=ehasting
IMG_NAME=enshrouded_server_podman
TAG=latest

podman build --tag ${IMG_NAME} -f Dockerfile
podman tag ${IMG_NAME}:${TAG} docker.io/${USERNAME}/${IMG_NAME}:${TAG}
podman login docker.io -u ${USERNAME}
podman push docker.io/${USERNAME}/${IMG_NAME}:${TAG}