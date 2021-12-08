#!/bin/bash
source ./env.sh
set -e


# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${QBITTORRENT_NAME} \
  --network ${QBITTORRENT_NETWORK} \
  --env PUID=${QBITTORRENT_UID} \
  --env PGID=${QBITTORRENT_GID} \
  --env UMASK=022 \
  --env TZ=${HOST_TZ} \
  --env WEBUI_PORT=8080 \
  --volume ${QBITTORRENT_VOLUME_CONFIG}:/config:Z \
  --volume ${QBITTORRENT_VOLUME_DOWNLOADS_HOST}:${QBITTORRENT_VOLUME_DOWNLOADS_CONT}:z \
  docker.io/linuxserver/qbittorrent


# Create systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  ${QBITTORRENT_NAME}

mv $QBITTORRENT_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$QBITTORRENT_SERVICE
systemctl daemon-reload
systemctl enable $QBITTORRENT_SERVICE


# Start the service
echo "Starting ${QBITTORRENT_SERVICE}..."
systemctl start ${QBITTORRENT_SERVICE}


# Create the nginx config
echo "Enabling ${QBITTORRENT_HOST_DOMAIN}..."
envsubst '${QBITTORRENT_DOMAIN} ${QBITTORRENT_HOST_DOMAIN}' < qbittorrent/config/qbittorrent.nginx.conf > /etc/nginx/conf.d/qbittorrent.conf
systemctl restart nginx.service

# Yay
echo "Great success!!"