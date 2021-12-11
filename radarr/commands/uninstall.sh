#!/bin/bash
source ./env.sh


# Remove site from nginx
rm -f /etc/nginx/conf.d/${RADARR_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Stop the service
systemctl stop ${RADARR_SERVICE}
systemctl disable ${RADARR_SERVICE}
rm -f /etc/systemd/system/${RADARR_SERVICE}
systemctl daemon-reload

# Remove the container
podman container rm ${RADARR_NAME}