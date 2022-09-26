#!/bin/bash
source ./env.sh

VM_IMAGES_PATH="/var/lib/libvirt/images"
BACKUP_HOST="fractal.home"
BACKUP_PATH="/mnt/backup/vm"

# The VM domains we are going to back up
declare -a BACKUP_DOMAINS=("Gaming" "Homework" "Fedora" "Gnome" "Music")


# For each domain, make a a copy of the definition XML
# and the drive file, and transfer them to storage
for DOMAIN in ${BACKUP_DOMAINS[@]}; do
    echo "Backing up ${DOMAIN}..."

    TEMP_PATH="${VM_IMAGES_PATH}/_${DOMAIN}"
    mkdir -p ${TEMP_PATH}

    if [[ -f "${TEMP_PATH}/${DOMAIN}.xml" ]]; then
        echo "- Domain XML already captured"
    else
        echo "- Capturing domain XML..."
        virsh dumpxml ${DOMAIN} > ${TEMP_PATH}/${DOMAIN}.xml
        if [ $? != 0 ]; then
            exit 1
        fi
    fi

    if [[ -f "${TEMP_PATH}/${DOMAIN}.qcow2.gz" ]]; then
        echo "- Domain image already copied"
    else
        echo "- Copying VM image..."
        gzip -c ${VM_IMAGES_PATH}/${DOMAIN}.qcow2 | pv > ${TEMP_PATH}/${DOMAIN}.qcow2.gz
        if [ $? != 0 ]; then
            exit 1
        fi
    fi

    echo "- Sending backup to storage..."
    scp -pr ${TEMP_PATH} ${BACKUP_HOST}:${BACKUP_PATH}
    if [ $? != 0 ]; then
        exit 1
    fi

    echo "- Cleaning up..."
    rm -rf ${TEMP_PATH}
done