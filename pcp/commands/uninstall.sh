#!/bin/bash
source ./env.sh


echo "Removing Performance Co-Pilot..."

# Stop services
echo "Stopping services..."
systemctl stop pmproxy
systemctl stop pmlogger
systemctl stop pmcd

systemctl disable pmproxy
systemctl disable pmlogger
systemctl disable pmcd

# If cockpit is installed, remove the integration
if [ ! -z $(dnf list installed | grep cockpit-pcp) ]; then
  dnf uninstall -y cockpit-pcp
fi

# Uninstall base packages
dnf uninstall -y pcp

# All done
echo "Done"