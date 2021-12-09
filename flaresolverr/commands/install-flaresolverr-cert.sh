#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${FLARESOLVERR_DOMAIN} flaresolverr/config/${FLARESOLVERR_DOMAIN}.ssl.cnf || exit 1
local-ca/commands/make-pkcs12.sh ${FLARESOLVERR_DOMAIN}

# Create secrets
if [ ! -z "$(podman secret ls | grep ${FLARESOLVERR_DOMAIN}.p12)" ]; then
  podman secret rm ${FLARESOLVERR_DOMAIN}.p12
fi

podman secret create ${FLARESOLVERR_DOMAIN}.p12 ${LOCAL_CA_FOLDER_KEY}/${FLARESOLVERR_DOMAIN}.p12
