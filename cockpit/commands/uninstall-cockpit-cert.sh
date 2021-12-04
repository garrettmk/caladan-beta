#!/bin/bash
source ./env.sh

# Remove links for Cockpit
# See: https://cockpit-project.org/guide/latest/https
echo "Removing links..."
rm -f /etc/cockpit/ws-certs.d/100-${COCKPIT_DOMAIN}.crt
rm -f /etc/cockpit/ws-certs.d/100-${COCKPIT_DOMAIN}.key

# Delete private key and certificate
echo "Removing certificate and private key..."
rm -f $LOCAL_CA_FOLDER_CRT/${COCKPIT_DOMAIN}.crt
rm -f $LOCAL_CA_FOLDER_KEY/${COCKPIT_DOMAIN}.key

# All done
echo "Done"