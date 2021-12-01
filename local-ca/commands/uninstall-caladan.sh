#!/bin/bash
source ./env.sh

$PREFIX="caladan.home"

# Remove files
echo "Removing $PREFIX.crt and $PREFIX.key..."
rm -f $LOCAL_CA_FOLDER_CRT/$PREFIX.crt
rm -f $LOCAL_CA_FOLDER_KEY/$PREFIX.key

