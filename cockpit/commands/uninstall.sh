#!/bin/bash
source ./env.sh


# Stop and remove the service
echo "Stopping cockpit..."
systemctl stop cockpit.socket

echo "Removing systemd service..."
systemctl disable cockpit.socket
systemctl daemon-reload

# Close the firewall port
echo "Closing firewall ports..."
firewall-cmd --remove-service=cockpit --permanent

# Removing nginx config file
echo "Removing ${COCKPIT_DOMAIN} from nginx..."
rm -f /etc/nginx/conf.d/cockpit.conf

# Remove certificate
echo "Removing certificates..."
cockpit/commands/uninstall-cockpit-cert.sh

# Restart nginx
echo "Restarting nginx..."
systemctl restart nginx.service

# Remove packages
echo "Removin packages..."
dnf install -y \
  cockpit \
  cockpit-storaged \
  cockpit-networkmanager \
  cockpit-packagekit \
  cockpit-machines \
  cockpit-podman \
  cockpit-selinux \
  cockpit-certificates
