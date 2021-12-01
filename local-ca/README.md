# Local CA

## About
This folder contains resources for running a local Certificate Authority (CA) in a podman container. A systemd service is provided to run the container, as well as common commands for creating, signing and distributing certificates.

## Usage
To install the service, run:
```
# install.sh
```
This will build the container image and install a service to run the container. 