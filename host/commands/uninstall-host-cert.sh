#!/bin/bash
source ./env.sh

# Remove the certificate and private key files
rm -f ${LOCAL_CA_FOLDER_CRT}/${HOST_DOMAIN}.crt
rm -f ${LOCAL_CA_FOLDER_KEY}/${HOST_DOMAIN}.key