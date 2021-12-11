#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${FLARESOLVERR_NETWORK}

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${FLARESOLVERR_NAME} \
  --network ${FLARESOLVERR_NETWORK} \
  --env LOG_LEVEL=info \
  --env LOG_HTML=false \
  --env CAPTCHA_SOLVER=none \
  --env TZ=America/Los_Angeles \
  docker.io/flaresolverr/flaresolverr

# Create a systemd service
echo "Creating systemd service..."
host/commands/make-container-service.sh ${FLARESOLVERR_NAME}

# Start the service
echo "Starting $FLARESOLVERR_SERVICE..."
systemctl start $FLARESOLVERR_SERVICE

# Create the nginx config
# echo "Enabling $FLARESOLVERR_HOST_DOMAIN..."
# envsubst '${FLARESOLVERR_DOMAIN} ${FLARESOLVERR_HOST_DOMAIN}' < flaresolverr/config/flaresolverr.nginx.conf > /etc/nginx/conf.d/flaresolverr.conf
# systemctl restart nginx.service

# Done
echo "Great success!!"