#!/bin/bash
source ./env.sh


# Create the certificate and key
echo "Creating certificate and private key..."
local-ca/commands/make-signed-cert.sh ${COCKPIT_DOMAIN} cockpit/config/${COCKPIT_DOMAIN}.ssl.cnf

# Create links so Cockpit uses the right cert
# See: https://cockpit-project.org/guide/latest/https
echo "Creating links for Cockpit..."
ln -sf ${LOCAL_CA_FOLDER_CRT}/${COCKPIT_DOMAIN}.crt /etc/cockpit/ws-certs.d/100-${COCKPIT_DOMAIN}.crt
ln -sf $LOCAL_CA_FOLDER_KEY/${COCKPIT_DOMAIN}.key /etc/cockpit/ws-certs.d/100-${COCKPIT_DOMAIN}.key

# All done
echo "Very nice!!"