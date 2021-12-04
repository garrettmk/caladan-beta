#!/bin/bash
source ./env.sh

# Remove CA certificate
echo "Removing CA certificate..."
rm -f $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt
rm -f $LOCAL_CA_FOLDER_CA/$LOCAL_CA_NAME.crt

# Remove CA private key
echo "Removing CA private key..."
rm -f $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key

# Update trust store
echo "Updating host..."
update-ca-trust

# All done
echo "Done"