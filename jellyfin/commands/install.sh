#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${JELLYFIN_NETWORK}

# Create SSL keys
jellyfin/commands/install-jellyfin-cert.sh

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${JELLYFIN_NAME} \
  --network ${JELLYFIN_NETWORK} \
  --volume ${JELLYFIN_VOLUME_CONFIG}:/config:Z \
  --volume ${JELLYFIN_VOLUME_MEDIA}:/media:z \
  --env PUID=${JELLYFIN_UID} \
  --env PGID=${JELLYFIN_GID} \
  --env UMASK=022 \
  --env TZ=America/Los_Angeles \
  --env JELLYFIN_PublishedServerUrl=${HOST_STATIC_IP} \
  --publish 8096:8096 \
  --publish 8920:8920 \
  --publish 7359:7359/udp \
  --publish 1900:1900/udp \
  --secret ${JELLYFIN_DOMAIN}.p12 \
  docker.io/linuxserver/jellyfin

# Create a systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  $JELLYFIN_NAME

mv $JELLYFIN_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$JELLYFIN_SERVICE
systemctl daemon-reload
systemctl enable $JELLYFIN_SERVICE

# Start the service
echo "Starting $JELLYFIN_SERVICE..."
systemctl start $JELLYFIN_SERVICE

# Create the nginx config
echo "Enabling $JELLYFIN_HOST_DOMAIN..."
envsubst '${JELLYFIN_DOMAIN} ${JELLYFIN_HOST_DOMAIN}' < jellyfin/config/jellyfin.nginx.conf > /etc/nginx/conf.d/jellyfin.conf
systemctl restart nginx.service

# Done
echo "Great success!!"