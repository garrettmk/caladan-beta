#!/bin/bash
source ./env.sh


# Remove site from nginx
rm -f /etc/nginx/conf.d/${SONARR_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Stop the service
systemctl stop ${SONARR_SERVICE}
systemctl disable ${SONARR_SERVICE}
rm -f /etc/systemd/system/${SONARR_SERVICE}
systemctl daemon-reload

# Remove the container
podman container rm ${SONARR_NAME}
