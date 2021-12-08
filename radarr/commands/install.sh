#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
#host/commands/make-podman-network.sh ${RADARR_NETWORK}

# Create SSL keys
radarr/commands/install-radarr-cert.sh

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${RADARR_NAME} \
  --network ${RADARR_NETWORK} \
  --volume ${RADARR_VOLUME_CONFIG}:/config:Z \
  --volume ${RADARR_VOLUME_MEDIA_HOST}:${RADARR_VOLUME_MEDIA_CONT}:z \
  --env PUID=${RADARR_UID} \
  --env PGID=${RADARR_GID} \
  --env UMASK=022 \
  --env TZ=America/Los_Angeles \
  --secret ${RADARR_DOMAIN}.p12 \
  docker.io/linuxserver/radarr

# Create a systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  $RADARR_NAME

mv $RADARR_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$RADARR_SERVICE
systemctl daemon-reload
systemctl enable $RADARR_SERVICE

# Start the service
echo "Starting $RADARR_SERVICE..."
systemctl start $RADARR_SERVICE

# Create the nginx config
echo "Enabling $RADARR_HOST_DOMAIN..."
envsubst '${RADARR_DOMAIN} ${RADARR_HOST_DOMAIN}' < radarr/config/radarr.nginx.conf > /etc/nginx/conf.d/radarr.conf
systemctl restart nginx.service

# Done
echo "Great success!!"