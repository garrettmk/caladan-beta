#!/bin/bash
source ./env.sh


# Create the CA private key 
if [ ! -f "$LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key" ]; then
  echo "Creating CA private key..."
  openssl genrsa \
    -aes256 \
    -out $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key \
    4096 || exit 1

  # Make the CA key read-only and private
  chmod 0400 $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key
else
  echo "CA key already exists"
fi

# Generate a self-signed CA certificate
echo "Creating CA certificate..."
openssl req \
  -x509 \
  -nodes \
  -sha512 \
  -days 365 \
  -config local-ca/config/$LOCAL_CA_NAME.ssl.cnf \
  -key $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key \
  -out $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt \
  || exit 1

# Make the certificate read-only
chmod 444 $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt

# Update the host trust store
echo "Updating trust store..."
cp $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt $LOCAL_CA_FOLDER_CA/
update-ca-trust

# All done
echo "Great success!!"