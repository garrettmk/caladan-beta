#!/bin/bash
source ./env.sh


# Start up the container
echo "Starting container..."
podman start $LOCAL_CA_CONTAINER_NAME || exit 1

# Create the CA certificate
echo "Creating CA certificate..."
podman exec -it $LOCAL_CA_CONTAINER_NAME create-ca-cert
if [ $? -eq 0 ]; then
  # Copy into host machine
  echo "Copying certificate and keys to host"
  podman cp $LOCAL_CA_CONTAINER_NAME:/data/$LOCAL_CA_NAME.crt $LOCAL_CA_FOLDER_CA/
  podman cp $LOCAL_CA_CONTAINER_NAME:/data/$LOCAL_CA_NAME.key $LOCAL_CA_FOLDER_KEY/

  # Update host system
  echo "Updating trust store..."
  update-ca-trust
fi

# Stop the container
echo "Stopping container..."
podman stop $LOCAL_CA_CONTAINER_NAME

# All done
echo "Very nice!!"