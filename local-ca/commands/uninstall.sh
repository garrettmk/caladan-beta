#!/bin/bash
source ./env.sh

# Uninstall scripts
commands/uninstall-cockpit.sh
commands/uninstall-caladan.sh
commands/uninstall-ca.sh

# If the keys directory is empty, delete it
if [! "$(ls -A $LOCAL_CA_FOLDER_KEY)" ]; then
  echo "Removing $LOCAL_CA_FOLDER_KEY..."
  rm -rf $LOCAL_CA_FOLDER_KEY
else
  echo "Keys found. Leaving $LOCAL_CA_KEY alone."
fi

# Uninstall dependencies
echo "Removing packages..."
dnf remove nss-tools

