#!/bin/bash
source ./env.sh
set -e


# Install packages
echo "Installing packages..."
dnf install -y nginx

# Copy the nginx config
echo "Creating configuration..."
envsubst '${HOST_DOMAIN} ${LOCAL_CA_FOLDER_CRT} ${LOCAL_CA_FOLDER_KEY}' < nginx/config/nginx.conf > /etc/nginx/nginx.conf

# Create DH parameters
# This can take a while so make sure we don't already have this
if [ ! -f "/etc/nginx/dhparams.pem" ]; then
  openssl dhparam -out /etc/nginx/dhparams.pem 4096
fi

# Enable the systemd service
echo "Starting nginx..."
systemctl enable --now nginx.service

# Done
echo "Great success!!"