#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${SONARR_DOMAIN} sonarr/config/${SONARR_DOMAIN}.ssl.cnf || exit 1
local-ca/commands/make-pkcs12.sh ${SONARR_DOMAIN}

# Create secrets
if [ ! -z "$(podman secret ls | grep ${SONARR_DOMAIN}.p12)" ]; then
  podman secret rm ${SONARR_DOMAIN}.p12
fi

podman secret create ${SONARR_DOMAIN}.p12 ${LOCAL_CA_FOLDER_KEY}/${SONARR_DOMAIN}.p12
