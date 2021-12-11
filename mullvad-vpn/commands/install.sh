#!/bin/bash
source ./env.sh
set -e

echo "Here"
# Make sure the vpn network exists
host/commands/make-podman-network.sh ${MULLVAD_NETWORK}

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name ${MULLVAD_NAME} \
  --network ${MULLVAD_NETWORK} \
  --cap-add NET_ADMIN \
  --device /dev/net/tun \
  --env KILL_SWITCH=on \
  --env FORWARDED_PORTS=54801 \
  --env SUBNETS=192.168.0.0/24,192.168.1.0/24 \
  docker.io/yacht7/openvpn-client

# Copy in the config files
mkdir /tmp/vpn
cp mullvad-vpn/config/${MULLVAD_CONFIG}/* /tmp/vpn/
podman cp /tmp/vpn ${MULLVAD_NAME}:/data
rm -rf /tmp/vpn

# Create systemd service
echo "Creating systemd service..."
host/commands/make-container-service.sh ${MULLVAD_NAME}

# Start the service
echo "Starting ${MULLVAD_SERVICE}..."
systemctl enable --now ${MULLVAD_SERVICE}

# Yay
echo "Great success!!"