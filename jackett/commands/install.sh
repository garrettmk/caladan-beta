#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${JACKETT_NETWORK}

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${JACKETT_NAME} \
  --network ${JACKETT_NETWORK} \
  --volume ${JACKETT_VOLUME_CONFIG}:/config:Z \
  --volume ${JACKETT_VOLUME_DOWNLOADS_HOST}:/downloads:z \
  --env PUID=${JACKETT_UID} \
  --env PGID=${JACKETT_GID} \
  --env UMASK=022 \
  --env TZ=America/Los_Angeles \
  --env AUTO_UPDATE=true \
  lscr.io/linuxserver/jackett

# Create a systemd service
echo "Creating systemd service..."
host/commands/make-container-service.sh ${JACKETT_NAME}

# Start the service
echo "Starting $JACKETT_SERVICE..."
systemctl start $JACKETT_SERVICE

# Create the nginx config
# echo "Enabling $JACKETT_HOST_DOMAIN..."
# envsubst '${JACKETT_DOMAIN} ${JACKETT_HOST_DOMAIN}' < jackett/config/jackett.nginx.conf > /etc/nginx/conf.d/jackett.conf
# systemctl restart nginx.service

# Done
echo "Great success!!"