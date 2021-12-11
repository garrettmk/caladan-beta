#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${ORGANIZR_NETWORK}

# Create SSL keys
#organizr/commands/install-organizr-cert.sh

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${ORGANIZR_NAME} \
  --network ${ORGANIZR_NETWORK} \
  --volume ${ORGANIZR_VOLUME_CONFIG}:/config \
  docker.io/organizr/organizr

# Create a systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  $ORGANIZR_NAME

mv $ORGANIZR_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$ORGANIZR_SERVICE
systemctl daemon-reload
systemctl enable $ORGANIZR_SERVICE

# Start the service
echo "Starting $ORGANIZR_SERVICE..."
systemctl start $ORGANIZR_SERVICE

# Create the nginx config
echo "Enabling $ORGANIZR_HOST_DOMAIN..."
envsubst '${ORGANIZR_DOMAIN} ${ORGANIZR_HOST_DOMAIN}' < organizr/config/organizr.nginx.conf > /etc/nginx/conf.d/organizr.conf
systemctl restart nginx.service

# Done
echo "Great success!!"