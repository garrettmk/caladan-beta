#!/bin/bash
source ./env.sh


# Stop the service
echo "Stopping nginx..."
systemctl stop nginx.service
systemctl disable nginx.service

# Remove the package
echo "Removing packages..."
dnf remove nginx

# Remove configuration
echo "Removing configuration..."
rm -rf /etc/nginx

# Done
echo "Done"