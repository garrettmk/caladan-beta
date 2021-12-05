#!/bin/sh
source ./env.sh
set -e

# See https://libvirt.org/nss.html

# Install the packages
dnf install -y libvirt-nss

# Add libvirt and libvirt_guest modules to user-nsswitch.conf
# Insert them between "myhostname" and "resolve". So libvirt will
# be consulted after the hostname, but before sending a DNS query out
# with systemd-resolved
sed -i -r 's/hosts:(\s*)(.*myhostname)(\s*.*)/hosts:\1\2 libvirt libvirt_guest\3/' /etc/authselect/user-nsswitch.conf

# Don't forget to update authselect
authselect apply-changes