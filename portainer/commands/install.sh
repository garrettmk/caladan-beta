#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh admin

# Create SSL keys
portainer/commands/install-portainer-cert.sh

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${PORTAINER_NAME} \
  --network ${PORTAINER_NETWORK} \
  --volume /var/run/docker.sock:/var/run/docker.sock:z \
  --volume /var/run/podman/podman.sock:/var/run/podman.sock:z \
  --volume ${PORTAINER_VOLUME_DATA}:/data \
  --env TZ=America/Los_Angeles \
  --secret ${PORTAINER_DOMAIN}.crt \
  --secret ${PORTAINER_DOMAIN}.key \
  docker.io/portainer/portainer-ce \
  --sslcert /run/secrets/${PORTAINER_DOMAIN}.crt \
  --sslkey /run/secrets/${PORTAINER_DOMAIN}.key

# Create a systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  $PORTAINER_NAME

mv $PORTAINER_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$PORTAINER_SERVICE
systemctl daemon-reload
systemctl enable $PORTAINER_SERVICE

# Start the service
echo "Starting $PORTAINER_SERVICE..."
systemctl start $PORTAINER_SERVICE

# Create the nginx config
echo "Enabling $PORTAINER_HOST_DOMAIN..."
envsubst '${PORTAINER_DOMAIN} ${PORTAINER_HOST_DOMAIN}' < portainer/config/portainer.nginx.conf > /etc/nginx/conf.d/portainer.conf
systemctl restart nginx.service

# Done
echo "Great success!!"