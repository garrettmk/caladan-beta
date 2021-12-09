#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${FLARESOLVERR_NETWORK}

# Create SSL keys
#flaresolverr/commands/install-flaresolverr-cert.sh

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
podman generate systemd \
  --name \
  --files \
  $FLARESOLVERR_NAME

mv $FLARESOLVERR_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$FLARESOLVERR_SERVICE
systemctl daemon-reload
systemctl enable $FLARESOLVERR_SERVICE

# Start the service
echo "Starting $FLARESOLVERR_SERVICE..."
systemctl start $FLARESOLVERR_SERVICE

# Create the nginx config
# echo "Enabling $FLARESOLVERR_HOST_DOMAIN..."
# envsubst '${FLARESOLVERR_DOMAIN} ${FLARESOLVERR_HOST_DOMAIN}' < flaresolverr/config/flaresolverr.nginx.conf > /etc/nginx/conf.d/flaresolverr.conf
# systemctl restart nginx.service

# Done
echo "Great success!!"