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
  -x509                     `# Create a self-signed certificate, not a request` \
  -nodes                    `# Don't encrypt private keys` \
  -sha512                   `# Use SHA512 message digest to sign` \
  -days 365                 `# Make valid for 1 year` \
  -config config/$LOCAL_CA_NAME.cnf    `# Use the CA config file` \
  -key $LOCAL_CA_FOLDER_KEY/$LOCAL_CA_NAME.key         `# Sign with the key we just generated` \
  -out $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt         `# Output to ca.crt` \
  -verbose                  `# Talk to me baby` \
  || exit 1

# Make the certificate read-only
chmod 444 $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt

# Update the host trust store
echo "Update trust store..."
cp $LOCAL_CA_FOLDER_CRT/$LOCAL_CA_NAME.crt $LOCAL_CA_FOLDER_CA/
update-ca-trust

# All done
echo "Great success!!"