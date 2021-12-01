#!/bin/bash
source ./env.sh


# Build the image
echo "Building image..."
podman build -qt $LOCAL_CA_CONTAINER_NAME container || exit 1

# Create the config volume
podman volume exists $LOCAL_CA_VOLUME_CONFIG
if [ $? -eq 1 ]; then
  echo "Creating config volume..."
  podman volume create $LOCAL_CA_VOLUME_CONFIG || exit 1
fi

# Copy the config files to the config volume
echo "Populating config volume..."
tar -cf /tmp/$LOCAL_CA_VOLUME_CONFIG.tar -C config . || exit 1
podman volume import $LOCAL_CA_VOLUME_CONFIG /tmp/$LOCAL_CA_VOLUME_CONFIG.tar || exit 1
rm -f /tmp/$LOCAL_CA_VOLUME_CONFIG.tar

# Create the data volume
podman volume exists $LOCAL_CA_VOLUME_DATA
if [ $? -eq 1 ]; then
  echo "Creating data volume..."
  podman volume create $LOCAL_CA_VOLUME_DATA || exit 1
fi

# Create the container
echo "Creating container..."
podman create \
  --name $LOCAL_CA_CONTAINER_NAME \
  -v $LOCAL_CA_VOLUME_CONFIG:/config \
  -v $LOCAL_CA_VOLUME_DATA:/data \
  -e LOCAL_CA_NAME=$LOCAL_CA_NAME \
  localhost/$LOCAL_CA_CONTAINER_NAME \
  busy

# Make sure the private key directory exists
echo "Creating host directories..."
if [ ! -d "$LOCAL_CA_FOLDER_KEY" ]; then
  mkdir $LOCAL_CA_FOLDER_KEY
  chmod 0400 $LOCAL_CA_FOLDER_KEY
fi

# All done
echo "Great success!!"