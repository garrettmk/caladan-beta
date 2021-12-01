#!/bin/bash
source ./env.sh
set -e

PREFIX="cockpit.caladan.home"

# Create the private key and certificate
commands/make-signed-cert.sh $PREFIX

# Create links so Cockpit uses the right cert
# See: https://cockpit-project.org/guide/latest/https
echo "Creating links for Cockpit..."
ln -sf $LOCAL_CA_FOLDER_CRT/$PREFIX.crt /etc/cockpit/ws-certs.d/100-$PREFIX.crt
ln -sf $LOCAL_CA_FOLDER_KEY/$PREFIX.key /etc/cockpit/ws-certs.d/100-$PREFIX.key

# Restart Cockpit
echo "Restarting Cockpit"
systemctl restart cockpit.service

# All done
echo "Very nice!!"