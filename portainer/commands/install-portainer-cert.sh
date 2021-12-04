#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${PORTAINER_DOMAIN} portainer/config/${PORTAINER_DOMAIN}.ssl.cnf || exit 1

# Create secrets 
if [ ! -z "$(podman secret ls | grep ${PORTAINER_DOMAIN}.crt)" ]; then
  podman secret rm ${PORTAINER_DOMAIN}.crt
fi

podman secret create ${PORTAINER_DOMAIN}.crt ${LOCAL_CA_FOLDER_CRT}/${PORTAINER_DOMAIN}.crt

if [ ! -z "$(podman secret ls | grep ${PORTAINER_DOMAIN}.key)" ]; then
  podman secret rm ${PORTAINER_DOMAIN}.key
fi

podman secret create ${PORTAINER_DOMAIN}.key ${LOCAL_CA_FOLDER_KEY}/${PORTAINER_DOMAIN}.key