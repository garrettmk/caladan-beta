#!/bin/bash
source ./env.sh
set -e

# Create the PKCS12 file
openssl pkcs12 \
  -export \
  -certfile ${LOCAL_CA_FOLDER_CRT}/${LOCAL_CA_NAME}.crt \
  -in ${LOCAL_CA_FOLDER_CRT}/${1}.crt \
  -inkey ${LOCAL_CA_FOLDER_KEY}/${1}.key \
  -out ${LOCAL_CA_FOLDER_KEY}/${1}.p12

# Make it read-only and private
chmod 0400 ${LOCAL_CA_FOLDER_KEY}/${1}.p12