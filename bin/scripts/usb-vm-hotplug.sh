#!/bin/bash

#
# This script is triggered by systemd services when a device is attached
# or removed from the system. It finds the first running VM in a group
# (the SLOT parameter) and attempts to attach or detach the device.
#
# SLOT: Find a VM in this group to attach to
# ACTION: "attach" or "detach"
# TAG: The device to attach to.
#

ACTION=$1
TAG=$2

# Figure out the slot
SLOT=$(get-tag-slot.sh ${TAG})
if [[ -z $SLOT ]]; then
  echo "Device ${TAG} not assigned to a slot"
  exit 0
fi

# Get the vm name
VM_NAME=$(get-slot-vm.sh ${SLOT})
if [[ -z $VM_NAME ]]; then
  echo "No VM in ${SLOT} running"
  exit 0
fi


# Attaching?
if [ ${ACTION} == "attach" ]; then
  echo "Attaching ${TAG} to ${VM_NAME}..."
  
  # Get the device information
  DEVICE=$(udevadm info --name=${TAG})
  if [[ $? != 0 ]]; then
    echo "Device not found: ${TAG}"
    exit 1
  fi

  BUS_NUMBER=$(echo "${DEVICE}" | sed -r -n 's/^.*BUSNUM=0*(.*)$/\1/p')
  DEV_NUMBER=$(echo "${DEVICE}" | sed -r -n 's/^.*DEVNUM=0*(.*)$/\1/p')
  VENDOR_ID=$(echo "${DEVICE}" | sed -r -n 's/^.*ID_VENDOR_ID=(.*)$/\1/p')
  PRODUCT_ID=$(echo "${DEVICE}" | sed -r -n 's/^.*ID_MODEL_ID=(.*)$/\1/p')

  XML="<hostdev mode='subsystem' type='usb'>
      <source>
        <address bus='${BUS_NUMBER}' device='${DEV_NUMBER}'/>
      </source>
      <alias name='ua-${TAG}'/>
    </hostdev>"

  virsh attach-device ${VM_NAME} <(echo "${XML}")

# Detaching?
else
  echo "Detaching ${TAG} from ${VM_NAME}..."

  virsh detach-device-alias ${VM_NAME} ua-${TAG}
fi