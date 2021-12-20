#!/bin/bash
#
# Make attach or detach the necessary devices to put a VM in a slot
#

VM_NAME=$1
SLOT=$2


GTX1080="<hostdev mode='subsystem' type='pci' managed='yes'>
  <driver name='vfio'/>
  <source>
    <address domain='0x0000' bus='0x2d' slot='0x00' function='0x0'/>
  </source>
  <alias name='nvidia_gtx1080_video'/>
</hostdev>
</domain>
<hostdev mode='subsystem' type='pci' managed='yes'>
  <driver name='vfio'/>
  <source>
    <address domain='0x0000' bus='0x2d' slot='0x00' function='0x1'/>
  </source>
  <alias name='nvidia_gtx1080_audio'/>
</hostdev>
"

GT750TI="<hostdev mode='subsystem' type='pci' managed='yes'>
  <driver name='vfio'/>
  <source>
    <address domain='0x0000' bus='0x2e' slot='0x00' function='0x0'/>
  </source>
  <alias name='nvidia_gt750ti_video'/>
</hostdev>
<hostdev mode='subsystem' type='pci' managed='yes'>
  <driver name='vfio'/>
  <source>
    <address domain='0x0000' bus='0x2e' slot='0x00' function='0x1'/>
  </source>
  <alias name='nvidia_gt750ti_audio'/>
</hostdev>"


# Get the current XML
VM_DEFINITION=$(virsh dumpxml ${VM_NAME})

# Reomve a device from the VM
function remove-device() {
  virt-xml $1 --remove-device --hostdev alias.name=$2
}

case $SLOT in
  Slot1)


# Add host devices to VM
virsh define <(virsh dumpxml ${VM_NAME} | DEVICES=${DEVICES} perl -p -e 's/<\/devices>/$ENV{DEVICES}<\/devices>/g')

# Remove devices from VM