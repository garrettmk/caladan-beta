#!/bin/bash
source ./env.sh
set -e


# Install packages
echo "Installing Cockpit..."
dnf install -y \
  cockpit \
  cockpit-storaged \
  cockpit-networkmanager \
  cockpit-packagekit \
  cockpit-machines \
  cockpit-podman \
  cockpit-selinux

# Open the port in the firewall
echo "Open ports in firewall..."
firewall-cmd --add-service=cockpit --permanent

# Creating certificates
echo "Creating certificate for ${COCKPIT_DOMAIN}..."
cockpit/commands/install-cockpit-cert.sh

# Enable the systemd service
echo "Starting cockpit..."
systemctl enable --now cockpit.socket

# Enable the site with nginx
echo "Enabling ${COCKPIT_DOMAIN}..."
envsubst '${COCKPIT_DOMAIN}' < cockpit/config/cockpit.conf > /etc/nginx/conf.d/cockpit.conf

# Restart nginx
echo "Restarting nginx..."
systemctl restart nginx.service

# All done
echo "Very nice!!"