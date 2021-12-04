#!/bin/bash

# Generate the private key
openssl \
  genrsa \
  -des3 \
  -aes-256-cbc \
  -out ${LOCAL_CA_FOLDER_KEY}/$1.key \
  2048

# Make it private and read-only
chmod 0400 ${LOCAL_CA_FOLDER_KEY}/$1.key

# Generate the CSR
openssl \
  req \
  -new \
  -key ${LOCAL_CA_FOLDER_KEY}/$1.key \
  -out /tmp/$1.csr

# Sign the CSR and produce a certificate
openssl x509 \
  -req \
  -days 365 \
  -in /tmp/$1.csr \
  -extfile local-ca/config/users.cnf \
  -CA ${LOCAL_CA_FOLDER_CRT}/${LOCAL_CA_NAME}.crt \
  -CAkey ${LOCAL_CA_FOLDER_KEY}/${LOCAL_CA_NAME}.key \
  -CAcreateserial \
  -addtrust emailProtection clientAuth \
  -addreject serverAuth \
  -trustout \
  -out ${LOCAL_CA_FOLDER_CRT}/$1.crt

# Make it read-only
chmod 0444 ${LOCAL_CA_FOLDER_CRT}/$1.crt

# Export the cert into PKCS12 format
openssl pkcs12 \
  -export \
  -in ${LOCAL_CA_FOLDER_CRT}/$1.crt \
  -inkey ${LOCAL_CA_FOLDER_KEY}/$1.key \
  -out ${LOCAL_CA_FOLDER_KEY}/$1.p12

# Make it read-only and private
chmod 0400 ${LOCAL_CA_FOLDER_KEY}/$1.p12

# Clean up the CSR
rm -f /tmp/$1.csr