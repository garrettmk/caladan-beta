#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${RADARR_DOMAIN} radarr/config/${RADARR_DOMAIN}.ssl.cnf || exit 1
local-ca/commands/make-pkcs12.sh ${RADARR_DOMAIN}

# Create secrets
if [ ! -z "$(podman secret ls | grep ${RADARR_DOMAIN}.p12)" ]; then
  podman secret rm ${RADARR_DOMAIN}.p12
fi

podman secret create ${RADARR_DOMAIN}.p12 ${LOCAL_CA_FOLDER_KEY}/${RADARR_DOMAIN}.p12
