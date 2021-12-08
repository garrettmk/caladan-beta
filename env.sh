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
export PORTAINER_VOLUME_DATA="${PORTAINER_NAME}-data"


#####################################
## Pihole

export PIHOLE_NAME="pihole"
export PIHOLE_NETWORK="admin"
export PIHOLE_DOMAIN="${PIHOLE_NAME}.${PIHOLE_NETWORK}.${HOST_DOMAIN}"
export PIHOLE_HOST_DOMAIN="${PIHOLE_NAME}.${HOST_DOMAIN}"
export PIHOLE_SERVICE="container-${PIHOLE_NAME}.service"
export PIHOLE_VOLUME_DATA="${PIHOLE_NAME}-data"
export PIHOLE_PASSWORD="foofoo"


####################################
## Mullvad VPN

export MULLVAD_NAME="mullvad-vpn"
export MULLVAD_NETWORK="arrr"
export MULLVAD_VOLUME_DATA="${MULLVAD_NAME}-data"
export MULLVAD_SERVICE="container-${MULLVAD_NAME}.service"
export MULLVAD_CONFIG="linux_us_all"


#####################################
## Media variables

export MEDIA_ROOT_DIR_HOST="/mnt/volumes/media"
export MEDIA_ROOT_DIR_CONT="/media"

export MEDIA_DOWNLOADS_DIR="downloads"
export MEDIA_MOVIES_DIR="library/movies"
export MEDIA_SHOWS_DIR="library/shows"

if [ -z $(cat /etc/group | grep "media" | awk -F\: '{print $3}') ]; then
  groupadd media
fi

export MEDIA_GROUP_ID=$(cat /etc/group | grep "media" | awk -F\: '{print $3}')


#####################################
## qBittorrent


export QBITTORRENT_NAME="qbittorrent"

id ${QBITTORRENT_NAME}
if [ $? != 0 ]; then
  useradd -M -N -s /dev/null -G media ${QBITTORRENT_NAME}
fi

export QBITTORRENT_NETWORK=${MULLVAD_NETWORK}
export QBITTORRENT_VOLUME_CONFIG="${QBITTORRENT_NAME}-config"
export QBITTORRENT_VOLUME_DOWNLOADS_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_DOWNLOADS_DIR}"
export QBITTORRENT_VOLUME_DOWNLOADS_CONT="${MEDIA_ROOT_DIR_CONT}/${MEDIA_DOWNLOADS_DIR}"
export QBITTORRENT_SERVICE="container-${QBITTORRENT_NAME}.service"
export QBITTORRENT_HOST_DOMAIN="${QBITTORRENT_NAME}.${HOST_DOMAIN}"
# export QBITTORRENT_DOMAIN="${QBITTORRENT_NAME}.${QBITTORRENT_NETWORK}.${HOST_DOMAIN}"
export QBITTORRENT_DOMAIN="${MULLVAD_NAME}.${MULLVAD_NETWORK}.${HOST_DOMAIN}"
export QBITTORRENT_UID=$(id -u ${QBITTORRENT_NAME})
export QBITTORRENT_GID=${MEDIA_GROUP_ID}