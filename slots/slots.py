#!/usr/bin/env python3

import configparser
import pyudev
import subprocess
import pprint
import yaml
import functools
import libvirt

# Load the configuration
with open('slots/slots.yml') as f:
    config = yaml.safe_load(f)

slots = config.get('slots', {})
devices = config.get('devices', {})


# Check that all key-value pairs in A also exist in B
def is_subset(a: dict, b: dict):
    for key, value in a.items():
        if key not in b or b[key] != value:
            return False
    return True
    
# Get the matching tag in config for a device
def get_device_keys(dev: pyudev.Device):
    return [
        key for key, value in config['devices'].items()
        if is_subset(value.get('properties', {}), dev.properties)
    ]

def get_slot_keys(dev: pyudev.Device):
    return [
        key for key, value in config['slots'].items()
        if is_subset(value.get('devices', {}).get('properties', {}), dev.properties)
    ]


context = pyudev.Context()
monitor = pyudev.Monitor.from_netlink(context)
# monitor.filter_by()

for device in iter(monitor.poll, None):
    device_keys = get_device_keys(device)
    slot_keys = get_slot_keys(device)
    if len(device_keys) > 0:
        # pprint.pprint(device.action)
        print(f"{device.action} {device_keys} {slot_keys}")

# devices = context.list_devices(subsystem='usb')
# userdevices = [dict(device.properties.items()) for device in devices]

# for device in userdevices:
#     # print(list(device.properties.items()))
#     # print(device.properties['ID_MODEL_FROM_DATABASE'])
#     pprint.pprint(userdevices)
