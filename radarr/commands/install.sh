#!/bin/bash
source ./env.sh
set -e


# Ensure the network exists
host/commands/make-podman-network ${RADARR_NETWORK}

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${RADARR_NAME} \
  --network ${RADARR_NETWORK} \
  --volume ${RADARR_VOLUME_CONFIG}:/config:Z \
  --volume ${RADARR_VOLUME_MEDIA_HOST}:${RADARR_VOLUME_MEDIA_CONT}:z \
  --volume ${RADARR_VOLUME_DOWNLOADS_HOST}:${RADARR_VOLUME_DOWNLOADS_CONT}:z \
  --env PUID=${RADARR_UID} \
  --env PGID=${RADARR_GID} \
  --env UMASK=022 \
  --env TZ=${HOST_TZ} \
  docker.io/linuxserver/radarr

# Create a systemd service
echo "Creating systemd service..."
host/commands/make-container-service.sh $RADARR_NAME

# Start the service
echo "Starting $RADARR_SERVICE..."
systemctl start $RADARR_SERVICE

# Create the nginx config
echo "Enabling $RADARR_HOST_DOMAIN..."
envsubst '${RADARR_DOMAIN} ${RADARR_HOST_DOMAIN}' < radarr/config/radarr.nginx.conf > /etc/nginx/conf.d/${RADARR_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Done
echo "Great success!!"