#!/bin/bash
source ./env.sh


# Remove site from nginx
rm -f /etc/nginx/conf.d/${FLARESOLVERR_HOST_DOMAIN}.conf
systemctl restart nginx.service

# Stop the service
systemctl stop ${FLARESOLVERR_SERVICE}
systemctl disable ${FLARESOLVERR_SERVICE}
rm -f /etc/systemd/system/${FLARESOLVERR_SERVICE}
systemctl daemon-reload

# Remove the container
podman container rm ${FLARESOLVERR_NAME}
