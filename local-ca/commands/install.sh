#!/bin/bash
source ./env.sh


# Install dependencies
echo "Installing dependencies..."
dnf install -y nss-tools

# Make sure the private key directory exists
if [ ! -d "$LOCAL_CA_FOLDER_KEY" ]; then
  echo "Creating host directories..."
  mkdir $LOCAL_CA_FOLDER_KEY
  chmod 0400 $LOCAL_CA_FOLDER_KEY
else
  echo "$LOCAL_CA_FOLDER_KEY already exists"
fi

# Install scripts
local-ca/commands/install-ca-cert.sh