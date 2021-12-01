#!/bin/bash

# Name of image, container, etc...
LOCAL_CA_NAME="local-ca"
LOCAL_CA_CONTAINER_NAME=$LOCAL_CA_NAME

# The volume name for configuration files
LOCAL_CA_VOLUME_CONFIG="local-ca-config"

# The volume name for output files
LOCAL_CA_VOLUME_DATA="local-ca-data"

# The location on the host where the CA certificate will be copied
LOCAL_CA_FOLDER_CA="/etc/pki/ca-trust/source/anchors"

# The location on the host where certificates will be copied
LOCAL_CA_FOLDER_CRT="/etc/ssl/certs"

# The location on the host where private keys will be copied
LOCAL_CA_FOLDER_KEY="/etc/ssl/private"