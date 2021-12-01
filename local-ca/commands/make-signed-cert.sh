#!/bin/bash
source ./env.sh
set -e

PREFIX=$1

# Generate the private key
if [ ! -f "$LOCAL_CA_FOLDER_KEY/$PREFIX.key" ]; then
  echo "Create $PREFIX.key..."
  openssl genrsa \
    -out $LOCAL_CA_FOLDER_KEY/$PREFIX.key \
    2048
  
  # Make the key read-only and private
  chmod 0400 $LOCAL_CA_FOLDER_KEY/$PREFIX.key
else
  echo "$PREFIX.key already exists"
fi

# Generate the CSR
echo "Creating CSR..."
openssl req \
  -new \
  -nodes \
  -key $LOCAL_CA_FOLDER_KEY/$PREFIX.key \
  -config config/$PREFIX.cnf \
  -out /tmp/$PREFIX.csr

echo "Creating signed certificate..."
# Use the CSR to generate a certificate, signed using the local CA cert
openssl x509 \
  -req \
  -CA $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt \
  -CAkey $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key \
  -CAcreateserial \
  -in /tmp/$PREFIX.csr \
  -extfile config/$PREFIX.cnf \
  -out $LOCAL_CA_FOLDER_CRT/$PREFIX.crt \
  -days 365 \
  -extensions v3_req

# Make the certificate read-only
chmod 0640 $LOCAL_CA_FOLDER_CRT/$PREFIX.crt

# Clean up the CSR
rm -f /tmp/$PREFIX.csr

# All done
echo "Great success!!"