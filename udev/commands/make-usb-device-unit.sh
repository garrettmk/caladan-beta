#!/bin/bash
source ./env.sh
set -e

MATCH=$1
TAG=$2


# Get the bus number, device number, vendor ID and product ID of the device
IDS=($(usb_device_ids ${MATCH}))
BUS_NUMBER=${IDS[0]}
DEVICE_NUMBER=${IDS[1]}
VENDOR_ID=${IDS[2]}
PRODUCT_ID=${IDS[3]}

# Get the device description
DESCRIPTION=$(usb_device_description ${MATCH})

# Make sure we actually got something
if [[ ${#IDS[@]} == 0 ]]; then
  echo "Device not found: ${MATCH}"
  exit 1
fi

# Create a udev rule for the device
printf "ENV{PRODUCT}==\"${VENDOR_ID}/${PRODUCT_ID}/*\", \\
  SUBSYSTEM==\"usb\", \\
  ATTRS{busnum}==\"${BUS_NUMBER}\", \\
  TAG+=\"systemd\", \\
  SYMLINK+=\"${TAG}\"\n" > /etc/udev/rules.d/20-${TAG}.rules


# Reload the rules
udevadm control --reload-rules && udevadm trigger