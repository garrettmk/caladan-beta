#!/bin/bash
source ./env.sh

# Start the container
podman start $LOCAL_CA_CONTAINER_NAME

# Run the command
podman exec -it $LOCAL_CA_CONTAINER_NAME $1

# Clean up
podman stop $LOCAL_CA_CONTAINER_NAME