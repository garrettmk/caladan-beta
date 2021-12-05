#!/bin/bash
source ./env.sh

# Create the private key and certificate 
local-ca/commands/make-signed-cert.sh ${PIHOLE_DOMAIN} pihole/config/${PIHOLE_DOMAIN}.ssl.cnf || exit 1

# Pihole needs them combined into one
cat ${LOCAL_CA_FOLDER_KEY}/${PIHOLE_DOMAIN}.key ${LOCAL_CA_FOLDER_CRT}/${PIHOLE_DOMAIN}.crt > ${LOCAL_CA_FOLDER_KEY}/${PIHOLE_DOMAIN}.pk.crt.pem

# Create secrets 
if [ ! -z "$(podman secret ls | grep ${PIHOLE_DOMAIN}.pk.crt.pem)" ]; then
  podman secret rm ${PIHOLE_DOMAIN}.pk.crt.pem
fi

podman secret create ${PIHOLE_DOMAIN}.pk.crt.pem ${LOCAL_CA_FOLDER_KEY}/${PIHOLE_DOMAIN}.pk.crt.pem

if [ ! -z "$(podman secret ls | grep ${LOCAL_CA_NAME}.crt)" ]; then
  podman secret rm ${LOCAL_CA_NAME}.crt
fi

podman secret create ${LOCAL_CA_NAME}.crt ${LOCAL_CA_FOLDER_CRT}/${LOCAL_CA_NAME}.crt