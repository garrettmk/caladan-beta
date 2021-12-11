#!/bin/bash
source ./env.sh
set -e

CONTAINER_NAME=$1
SERVICE_NAME="container-${CONTAINER_NAME}.service"

# Generate a systemd service
podman generate systemd \
  --name \
  --files \
  $CONTAINER_NAME

# Get the --network parameter given to the container
NETWORK_NAME=$(podman container inspect ${CONTAINER_NAME} | sed -r -n '/--network/{n;s/\s*"(.*)".*/\1/p}')

# If the network name is of the form "container:*", then we need to bind to 
# that container's service
if [[ $NETWORK_NAME =~ ^container:.* ]]; then
  SPLIT_NAME=(${NETWORK_NAME//:/ })
  CONTAINER_NAME=${SPLIT_NAME[1]}

  # Replace the default Wants= and After= directives withBindsTo=
  sed -i -r "s/Wants=.*/BindsTo=container-${CONTAINER_NAME}.service/" $SERVICE_NAME
  sed -i -r "s/After=.*//" $SERVICE_NAME

  # Remove the Install section
  sed -i "/Install/{N;d}" $SERVICE_NAME
fi

# Add the service to systemd and enable it
mv $SERVICE_NAME /etc/systemd/system
restorecon /etc/systemd/system/$SERVICE_NAME
systemctl daemon-reload
