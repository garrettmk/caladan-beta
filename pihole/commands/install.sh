#!/bin/bash
source ./env.sh
set -e


# Make sure the admin network exists
host/commands/make-podman-network.sh ${PIHOLE_NETWORK}

# Create SSL keys
pihole/commands/install-pihole-cert.sh

# Create the container static ip
# Grab the "subnet" line from the network's config file, and replace the last octet with "53"
PIHOLE_IP=$(sed -rn 's/\s*"subnet":\s*"(.*)\.(.*)\.(.*)\.(.*)\/.*".*$/\1.\2.\3.53/p' /etc/cni/net.d/${PIHOLE_NETWORK}.conflist)
echo "Using IP ${PIHOLE_IP}"

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${PIHOLE_NAME} \
  --network=${PIHOLE_NETWORK} \
  --volume ${PIHOLE_VOLUME_DATA}:/etc/pihole:Z \
  --cap-add NET_ADMIN \
  --dns 127.0.0.1 \
  --dns 1.1.1.1 \
  --ip ${PIHOLE_IP} \
  --env SERVER_IP=${HOST_STATIC_IP} \
  --env WEBPASSWORD=${PIHOLE_PASSWORD} \
  --env TZ=${HOST_TZ} \
  --secret ${PIHOLE_DOMAIN}.pk.crt.pem \
  --secret ${LOCAL_CA_NAME}.crt \
  docker.io/pihole/pihole

# Inject SSL params
envsubst '${PIHOLE_DOMAIN} ${LOCAL_CA_NAME}' < pihole/config/external.conf > /tmp/external.conf
podman cp /tmp/external.conf ${PIHOLE_NAME}:/etc/lighttpd/
rm -f /tmp/external.conf

# Create a systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  ${PIHOLE_NAME}

mv ${PIHOLE_SERVICE} /etc/systemd/system
restorecon /etc/systemd/system/${PIHOLE_SERVICE}
systemctl daemon-reload
systemctl enable ${PIHOLE_SERVICE}

# Start the service
echo "Starting ${PIHOLE_SERVICE}..."
systemctl start ${PIHOLE_SERVICE}


# Create a systemd network file so systemd-resolved knows where
# to send dns queries
echo "Updating systemd network settings..."
echo "[Match]
Name=enp39s0

[Network]
Address=${HOST_STATIC_IP}/24
Gateway=192.168.0.1
DNS=${PIHOLE_IP}
" > /etc/systemd/network/10-enp39s0.network

# Restart systemd-networkd and systemd-resolved
systemctl restart systemd-networkd systemd-resolved

# Create the nginx config
echo "Enabling ${PIHOLE_HOST_DOMAIN}..."
envsubst '${PIHOLE_DOMAIN} ${PIHOLE_HOST_DOMAIN}' < pihole/config/pihole.nginx.conf > /etc/nginx/conf.d/pihole.conf
systemctl restart nginx.service

# Done
echo "Great success!!"