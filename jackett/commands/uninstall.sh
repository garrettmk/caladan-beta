#!/bin/bash
source ./env.sh


# Remove site from nginx
rm -f /etc/nginx/conf.d/${JACKETT_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Stop the service
systemctl stop ${JACKETT_SERVICE}
systemctl disable ${JACKETT_SERVICE}
rm -f /etc/systemd/system/${JACKETT_SERVICE}
systemctl daemon-reload

# Remove the container
podman container rm ${JACKETT_NAME}
