#!/bin/bash
source ./env.sh


# Remove site from nginx
rm -f /etc/nginx/conf.d/${QBITTORRENT_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Stop the service
systemctl stop ${QBITTORRENT_SERVICE}
systemctl disable ${QBITTORRENT_SERVICE}
rm -f /etc/systemd/system/${QBITTORRENT_SERVICE}
systemctl daemon-reload

# Remove the container
podman container rm ${QBITTORRENT_NAME}
