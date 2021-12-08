#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${JELLYFIN_DOMAIN} jellyfin/config/${JELLYFIN_DOMAIN}.ssl.cnf || exit 1
local-ca/commands/make-pkcs12.sh ${JELLYFIN_DOMAIN}

# Create secrets
if [ ! -z "$(podman secret ls | grep ${JELLYFIN_DOMAIN}.p12)" ]; then
  podman secret rm ${JELLYFIN_DOMAIN}.p12
fi

podman secret create ${JELLYFIN_DOMAIN}.p12 ${LOCAL_CA_FOLDER_KEY}/${JELLYFIN_DOMAIN}.p12
