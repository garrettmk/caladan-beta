#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${SONARR_NETWORK}

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${SONARR_NAME} \
  --network ${SONARR_NETWORK} \
  --volume ${SONARR_VOLUME_CONFIG}:/config:Z \
  --volume ${SONARR_VOLUME_MEDIA_HOST}:${SONARR_VOLUME_MEDIA_CONT}:z \
  --volume ${SONARR_VOLUME_DOWNLOADS_HOST}:${SONARR_VOLUME_DOWNLOADS_CONT}:z \
  --env PUID=${SONARR_UID} \
  --env PGID=${SONARR_GID} \
  --env UMASK=022 \
  --env TZ=America/Los_Angeles \
  docker.io/linuxserver/sonarr

# Create a systemd service
echo "Creating systemd service..."
host/commands/make-container-service.sh ${SONARR_NAME}

# Start the service
echo "Starting $SONARR_SERVICE..."
systemctl start $SONARR_SERVICE

# Create the nginx config
echo "Enabling $SONARR_HOST_DOMAIN..."
envsubst '${SONARR_DOMAIN} ${SONARR_HOST_DOMAIN}' < sonarr/config/sonarr.nginx.conf > /etc/nginx/conf.d/sonarr.conf
systemctl restart nginx.service

# Done
echo "Great success!!"