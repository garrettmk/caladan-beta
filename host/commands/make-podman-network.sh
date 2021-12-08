#!/bin/bash
source ./env.sh

NETWORK_NAME=$1
NETWORK_DOMAIN=${NETWORK_NAME}.${HOST_DOMAIN}

# If the network is a container, just check and make sure it exists
if [[ $NETWORK_NAME =~ ^container:.* ]]; then
  SPLIT_NAME=(${NETWORK_NAME//:/ })
  CONTAINER_NAME=${SPLIT_NAME[1]}

  podman container exists ${CONTAINER_NAME}
  if [ $? != 0 ]; then
    echo "Container network ${CONTAINER_NAME} does not exist."
    exit 1
  fi

  exit 0
fi

# Create the network if it doesn't already exist
podman network exists ${NETWORK_NAME}
if [ $? == 1 ]; then
  echo "Creating podman network '${NETWORK_NAME}'..."
  podman network create ${NETWORK_NAME}
else
  echo "Podman network '${NETWORK_NAME}' already exists"
fi

# Get the bridge name and gateway address
BRIDGE_NAME=$(sed -rn 's/^\s*"bridge": "(.*)".*$/\1/p' /etc/cni/net.d/${NETWORK_NAME}.conflist)
GATEWAY_ADDRESS=$(sed -rn 's/^\s*"gateway": "(.*)".*$/\1/p' /etc/cni/net.d/${NETWORK_NAME}.conflist)

# Set the DNS domain of the network
echo "Setting DNS domain..."
sed -i -r "s/^\s*\"domainName\": \"(.*)\".*$/\"domainName\": \"${NETWORK_DOMAIN}\",/" /etc/cni/net.d/${NETWORK_NAME}.conflist

# Create a systemd network file so systemd-resolved knows where to
# send requests on this network
echo "Configuring systemd-networkd..."
echo "[Match]
Name=${BRIDGE_NAME}

[Network]
DNS=${GATEWAY_ADDRESS}
Domains=~${NETWORK_DOMAIN}
" > /etc/systemd/network/20-${BRIDGE_NAME}.network

# Done
echo "Great success!!"