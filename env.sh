#!/bin/bash


######################################  
## Host settings

export HOST_DOMAIN="caladan.home"
export HOST_STATIC_IP="192.168.0.11"
export HOST_TZ="America/Los_Angeles"

######################################
## Local CA

export LOCAL_CA_NAME="local-ca"
export LOCAL_CA_CONTAINER_NAME=$LOCAL_CA_NAME
export LOCAL_CA_VOLUME_CONFIG="${LOCAL_CA_NAME}-config"
export LOCAL_CA_VOLUME_DATA="${LOCAL_CA_NAME}-data"
export LOCAL_CA_FOLDER_CA="/etc/pki/ca-trust/source/anchors"
export LOCAL_CA_FOLDER_CRT="/etc/ssl/certs"
export LOCAL_CA_FOLDER_KEY="/etc/ssl/private"


#####################################
## nginx



#####################################
## Cockpit

export COCKPIT_DOMAIN="cockpit.${HOST_DOMAIN}"


#####################################
## Performance Co-Pilot


#####################################
## Grafana

export GRAFANA_NAME="grafana"
export GRAFANA_NETWORK="admin"
export GRAFANA_DOMAIN="${GRAFANA_NAME}.${GRAFANA_NETWORK}.${HOST_DOMAIN}"
export GRAFANA_HOST_DOMAIN=${GRAFANA_NAME}.${HOST_DOMAIN}
export GRAFANA_SERVICE="container-${GRAFANA_NAME}.service"
export GRAFANA_VOLUME_CONFIG="${GRAFANA_NAME}-config"
export GRAFANA_VOLUME_DATA="${GRAFANA_NAME}-data"


#####################################
## Portainer

export PORTAINER_NAME="portainer"
export PORTAINER_NETWORK="admin"
export PORTAINER_DOMAIN="${PORTAINER_NAME}.${PORTAINER_NETWORK}.${HOST_DOMAIN}"
export PORTAINER_HOST_DOMAIN="${PORTAINER_NAME}.${HOST_DOMAIN}"
export PORTAINER_SERVICE="container-${PORTAINER_NAME}.service"
export PORTAINER_VOLUME_DATA="portainer-data"


#####################################
## Pihole

export PIHOLE_NAME="pihole"
export PIHOLE_NETWORK="admin"
export PIHOLE_DOMAIN="${PIHOLE_NAME}.${PIHOLE_NETWORK}.${HOST_DOMAIN}"
export PIHOLE_HOST_DOMAIN="${PIHOLE_NAME}.${HOST_DOMAIN}"
export PIHOLE_SERVICE="container-${PIHOLE_NAME}.service"
export PIHOLE_VOLUME_DATA="pihole-data"
export PIHOLE_PASSWORD="foofoo"