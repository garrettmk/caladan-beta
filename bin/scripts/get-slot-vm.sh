#!/bin/bash

SLOT=$1

# Generate a pattern to match against
case $SLOT in
  Slot1)
    MATCH="bus='0x2e' slot='0x00' function='0x0'"
    ;;
  Slot2)
    MATCH="bus='0x2d' slot='0x00' function='0x0'"
    ;;
  *)
    echo "Not a valid slot name: ${SLOT}"
    exit 1
    ;;
esac


# Loop through running domains, and echo the name of the first match
virsh list --state-running --name | while read DOMAIN; do
  if [[ -n ${DOMAIN} && -n $(virsh dumpxml ${DOMAIN} | grep "${MATCH}") ]]; then
    echo ${DOMAIN}
    exit 0
  fi
done