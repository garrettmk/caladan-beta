#!/bin/bash
source ./env.sh

# Remove the podman container
echo "Removing container..."
podman container rm -f $LOCAL_CA_CONTAINER_NAME

# Remove the container volumes
echo "Removing config volume..."
podman volume rm -f $LOCAL_CA_VOLUME_CONFIG

echo "Removing data volume..."
podman volume rm -f $LOCAL_CA_VOLUME_DATA

# Remove the container image
echo "Removing container image..."
podman image rm -f $LOCAL_CA_CONTAINER_NAME

echo "Done"