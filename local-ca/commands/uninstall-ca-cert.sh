#!/bin/bash
source ./env.sh

# Remove the CA certificate and keys
echo "Removing CA certificate and keys..."
rm -f $LOCAL_CA_FOLDER_CA/$LOCAL_CA_NAME.crt
rm -f $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key

# Update the trust store
echo "Updating host..."
update-ca-trust

# Remove the CA cert/key from the container
# Probably not really necessary...?