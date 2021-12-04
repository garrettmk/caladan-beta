#!/bin/bash
source ./env.sh
set -e

# Add packages
echo "Installing Performance Co-Pilot..."
dnf install -y pcp

# If we have cockpit installed, install the integration
if [ ! -z "$(dnf list installed | grep cockpit)" ]; then
  echo "Cockpit detected, installing integration..."
  dnf install -y cockpit-pcp
fi;

# All done
echo "Radical!!"