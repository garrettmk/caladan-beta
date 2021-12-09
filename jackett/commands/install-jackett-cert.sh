#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${JACKETT_DOMAIN} jackett/config/${JACKETT_DOMAIN}.ssl.cnf || exit 1
local-ca/commands/make-pkcs12.sh ${JACKETT_DOMAIN}

# Create secrets
if [ ! -z "$(podman secret ls | grep ${JACKETT_DOMAIN}.p12)" ]; then
  podman secret rm ${JACKETT_DOMAIN}.p12
fi

podman secret create ${JACKETT_DOMAIN}.p12 ${LOCAL_CA_FOLDER_KEY}/${JACKETT_DOMAIN}.p12
