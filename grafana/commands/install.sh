#!/bin/bash
source ./env.sh
set -e

# Make sure the admin network exists
host/commands/make-podman-network.sh admin

# Create SSL keys
grafana/commands/install-grafana-cert.sh

# Configure the container
echo "Configuring container..."
podman create \
  --replace \
  --name $GRAFANA_NAME \
  --network $GRAFANA_NETWORK \
  --volume $GRAFANA_VOLUME_CONFIG:/config \
  --volume $GRAFANA_VOLUME_DATA:/var/lib/grafana \
  --env GF_SERVER_PROTOCOL=https \
  --env GF_SERVER_CERT_KEY=/run/secrets/$GRAFANA_DOMAIN.key \
  --env GF_SERVER_CERT_FILE=/run/secrets/$GRAFANA_DOMAIN.crt \
  --env GF_INSTALL_PLUGINS="https://github.com/performancecopilot/grafana-pcp/releases/download/v3.2.1/performancecopilot-pcp-app-3.2.1.zip;grafana-pcp" \
  --secret ${GRAFANA_DOMAIN}.crt \
  --secret ${GRAFANA_DOMAIN}.key \
  quay.io/bitnami/grafana


# Create a systemd service
echo "Creating systemd service..."
podman generate systemd \
  --name \
  --files \
  $GRAFANA_NAME

mv $GRAFANA_SERVICE /etc/systemd/system
restorecon /etc/systemd/system/$GRAFANA_SERVICE
systemctl daemon-reload
systemctl enable $GRAFANA_SERVICE

# Start the service
echo "Starting $GRAFANA_SERVICE..."
systemctl start $GRAFANA_SERVICE

# Create the nginx config
echo "Enabling ${GRAFANA_HOST_DOMAIN}..."
envsubst '${GRAFANA_DOMAIN} ${GRAFANA_HOST_DOMAIN}' < grafana/config/grafana.nginx.conf > /etc/nginx/conf.d/grafana.conf
systemctl restart nginx.service

# Done
echo "Excellent!!"