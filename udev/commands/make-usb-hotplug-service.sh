#!/bin/bash
source ./env.sh
set -e

TAG=$1

SERVICE="hotplug-${TAG}.service"
DEVICE="dev-${TAG}.device"

# Create the service file
echo "[Unit]
Description=${TAG} hotplug service
BindsTo=${DEVICE}
After=${DEVICE}

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/usb-vm-hotplug.sh attach ${TAG}
ExecStop=/usr/local/bin/usb-vm-hotplug.sh detach ${TAG}

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/${SERVICE}

# Create dependencies with the device
mkdir -p /etc/systemd/system/${DEVICE}.wants
ln -sf /etc/systemd/system/${SERVICE} /etc/systemd/system/${DEVICE}.wants/${SERVICE}

# Reload systemd and start the service
systemctl daemon-reload
# systemctl enable --now ${SERVICE}