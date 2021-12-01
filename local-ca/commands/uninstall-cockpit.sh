#!/bin/bash
source ./env.sh

PREFIX="cockpit.caladan.home"

# Remove links for Cockpit
# See: https://cockpit-project.org/guide/latest/https
echo "Removing links..."
rm -f /etc/cockpit/ws-certs.d/100-$PREFIX.crt
rm -f /etc/cockpit/ws-certs.d/100-$PREFIX.key

# Delete private key and certificate
echo "Removing certificate and private key..."
rm -f $LOCAL_CA_FOLDER_CRT/$PREFIX.crt
rm -f $LOCAL_CA_FOLDER_KEY/$PREFIX.key

# Restart Cockpit
echo "Restarting Cockpit"
systemctl restart cockpit.service

# All done
echo "Done"