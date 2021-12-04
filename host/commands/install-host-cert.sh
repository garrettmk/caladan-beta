#!/bin/bash
source ./env.sh

# Create the certificate and private key
local-ca/commands/make-signed-cert.sh ${HOST_DOMAIN} host/config/${HOST_DOMAIN}.ssl.cnf

echo "Done"