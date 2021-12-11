#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${ORGANIZR_DOMAIN} organizr/config/${ORGANIZR_DOMAIN}.ssl.cnf || exit 1

# Create secrets 
if [ ! -z "$(podman secret ls | grep ${ORGANIZR_DOMAIN}.crt)" ]; then
  podman secret rm ${ORGANIZR_DOMAIN}.crt
fi

podman secret create ${ORGANIZR_DOMAIN}.crt ${LOCAL_CA_FOLDER_CRT}/${ORGANIZR_DOMAIN}.crt

if [ ! -z "$(podman secret ls | grep ${ORGANIZR_DOMAIN}.key)" ]; then
  podman secret rm ${ORGANIZR_DOMAIN}.key
fi

podman secret create ${ORGANIZR_DOMAIN}.key ${LOCAL_CA_FOLDER_KEY}/${ORGANIZR_DOMAIN}.key