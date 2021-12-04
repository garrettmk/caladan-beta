#!/bin/bash
source ./env.sh


# Stop, disable and remove the systemd service
echo "Removing $GRAFANA_SERVICE"
systemctl stop $GRAFANA_SERVICE
systemctl disable $GRAFANA_SERVICE
rm -f /etc/systemd/system/$GRAFANA_SERVICE

# Remove the container
echo "Removing container..."
podman container rm -f $GRAFANA_NAME

# Remove the network if it's no longer needed
ech "Pruning podman networks..."
podman network prune

# All done
echo "Done"