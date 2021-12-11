#!/bin/bash
source ./env.sh
set -e


# Ensure the network exists
host/commands/make-podman-network.sh ${QBITTORRENT_NETWORK}

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
host/commands/make-container-service.sh ${QBITTORRENT_NAME}

# Start the service
echo "Starting ${QBITTORRENT_SERVICE}..."
systemctl start ${QBITTORRENT_SERVICE}

# Create the nginx config
echo "Enabling ${QBITTORRENT_HOST_DOMAIN}..."
envsubst '${QBITTORRENT_DOMAIN} ${QBITTORRENT_HOST_DOMAIN}' < qbittorrent/config/qbittorrent.nginx.conf > /etc/nginx/conf.d/${QBITTORRENT_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Yay
echo "Great success!!"