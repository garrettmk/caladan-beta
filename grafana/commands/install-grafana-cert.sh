#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${GRAFANA_DOMAIN} grafana/config/${GRAFANA_DOMAIN}.ssl.cnf || exit 0

# Create secrets 
if [ ! -z "$(podman secret ls | grep ${GRAFANA_DOMAIN}.crt)" ]; then
  podman secret rm ${GRAFANA_DOMAIN}.crt
fi

podman secret create ${GRAFANA_DOMAIN}.crt ${LOCAL_CA_FOLDER_CRT}/${GRAFANA_DOMAIN}.crt

if [ ! -z "$(podman secret ls | grep ${GRAFANA_DOMAIN}.key)" ]; then
  podman secret rm ${GRAFANA_DOMAIN}.key
fi

podman secret create ${GRAFANA_DOMAIN}.key ${LOCAL_CA_FOLDER_KEY}/${GRAFANA_DOMAIN}.key