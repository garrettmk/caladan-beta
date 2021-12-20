#!/bin/bash
source ./env.sh


# Make sure the scripts are executable
chmod 755 bin/scripts/*

# Copy scripts into /usr/local/bin
cp bin/scripts/* /usr/local/bin/
