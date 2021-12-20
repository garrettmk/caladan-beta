#!/bin/bash

######################################
## Utility functions

# Add or update a podman secret
podman_secret_upsert() {
  local NAME=$1
  local FILE=$2

  if [ ! -z "$(podman secret ls | grep ${NAME})" ]; then
    podman secret rm ${NAME}
  fi

  podman secret create ${NAME} ${FILE}
}


# If a network name starts with "container:", echo
# the name of the container
network_container_name() {
  NETWORK_NAME=$1
  if [[ $NETWORK_NAME =~ ^container:.*$ ]]; then
    SPLIT_NAME=(${NETWORK_NAME//:/ })
    CONTAINER_NAME=${SPLIT_NAME[1]}
    echo $CONTAINER_NAME
  fi
}


# Get the bus number, device number, vendor ID and product ID of a USB device
usb_device_ids() {
  MATCH=$1
  echo $(lsusb | awk -F'[ :]' "/${MATCH}/ { print \$2+0,\$4+0,\$7,\$8 }")
}


# Get the friendly description of a USB device
usb_device_description() {
  MATCH=$1
  echo $(lsusb | awk "/${MATCH}/ { for(i=7;i<=NF;i++){ printf \"%s%s\", \$i, (i < NF ? OFS : \"\") } }")
}


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

id ${QBITTORRENT_NAME} > /dev/null
if [ $? != 0 ]; then
  useradd -M -N -s /dev/null -G media ${QBITTORRENT_NAME}
fi

export QBITTORRENT_NETWORK="container:${MULLVAD_NAME}"
export QBITTORRENT_VOLUME_CONFIG="${QBITTORRENT_NAME}-config"
export QBITTORRENT_VOLUME_DOWNLOADS_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_DOWNLOADS_DIR}"
export QBITTORRENT_VOLUME_DOWNLOADS_CONT="${MEDIA_ROOT_DIR_CONT}/${MEDIA_DOWNLOADS_DIR}"
export QBITTORRENT_SERVICE="container-${QBITTORRENT_NAME}.service"
export QBITTORRENT_HOST_DOMAIN="${QBITTORRENT_NAME}.${HOST_DOMAIN}"
export QBITTORRENT_DOMAIN="${MULLVAD_NAME}.${MULLVAD_NETWORK}.${HOST_DOMAIN}"
export QBITTORRENT_UID=$(id -u ${QBITTORRENT_NAME})
export QBITTORRENT_GID=${MEDIA_GROUP_ID}


######################################
## Jellyfin

export JELLYFIN_NAME="jellyfin"
id ${JELLYFIN_NAME} > /dev/null
if [ $? != 0 ]; then
  useradd -M -N -s /dev/null -G media ${JELLYFIN_NAME}
fi

export JELLYFIN_NETWORK="media"
export JELLYFIN_VOLUME_CONFIG="${JELLYFIN_NAME}-config"
export JELLYFIN_VOLUME_MEDIA="${MEDIA_ROOT_DIR_HOST}/library"
export JELLYFIN_UID=$(id -u ${JELLYFIN_NAME})
export JELLYFIN_GID=${MEDIA_GROUP_ID}
export JELLYFIN_DOMAIN="${JELLYFIN_NAME}.${JELLYFIN_NETWORK}.${HOST_DOMAIN}"
export JELLYFIN_HOST_DOMAIN="${JELLYFIN_NAME}.${HOST_DOMAIN}"
export JELLYFIN_SERVICE="container-${JELLYFIN_NAME}.service"


######################################
## Radarr

export RADARR_NAME="radarr"
id ${RADARR_NAME} > /dev/null
if [ $? != 0 ]; then
  useradd -M -N -s /dev/null -G media ${RADARR_NAME}
fi

export RADARR_NETWORK="container:${MULLVAD_NAME}"
export RADARR_VOLUME_CONFIG="${RADARR_NAME}-config"
export RADARR_VOLUME_MEDIA_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_MOVIES_DIR}"
export RADARR_VOLUME_MEDIA_CONT="${MEDIA_ROOT_DIR_CONT}/${MEDIA_MOVIES_DIR}"
export RADARR_VOLUME_DOWNLOADS_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_DOWNLOADS_DIR}"
export RADARR_VOLUME_DOWNLOADS_CONT="${MEDIA_ROOT_DIR_CONT}/${MEDIA_DOWNLOADS_DIR}"
export RADARR_UID=$(id -u ${RADARR_NAME})
export RADARR_GID=${MEDIA_GROUP_ID}
export RADARR_DOMAIN="${MULLVAD_NAME}.${MULLVAD_NETWORK}.${HOST_DOMAIN}"
export RADARR_HOST_DOMAIN="${RADARR_NAME}.${HOST_DOMAIN}"
export RADARR_SERVICE="container-${RADARR_NAME}.service"


######################################
## Sonarr

export SONARR_NAME="sonarr"
id ${SONARR_NAME} > /dev/null
if [ $? != 0 ]; then
  useradd -M -N -s /dev/null -G media ${SONARR_NAME}
fi

export SONARR_NETWORK="container:${MULLVAD_NAME}"
export SONARR_VOLUME_CONFIG="${SONARR_NAME}-config"
export SONARR_VOLUME_MEDIA_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_SHOWS_DIR}"
export SONARR_VOLUME_MEDIA_CONT="${MEDIA_ROOT_DIR_CONT}/${MEDIA_SHOWS_DIR}"
export SONARR_VOLUME_DOWNLOADS_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_DOWNLOADS_DIR}"
export SONARR_VOLUME_DOWNLOADS_CONT="${MEDIA_ROOT_DIR_CONT}/${MEDIA_DOWNLOADS_DIR}"
export SONARR_UID=$(id -u ${SONARR_NAME})
export SONARR_GID=${MEDIA_GROUP_ID}
export SONARR_DOMAIN="${MULLVAD_NAME}.${MULLVAD_NETWORK}.${HOST_DOMAIN}"
export SONARR_HOST_DOMAIN="${SONARR_NAME}.${HOST_DOMAIN}"
export SONARR_SERVICE="container-${SONARR_NAME}.service"


######################################
## Jackett

export JACKETT_NAME="jackett"
id ${JACKETT_NAME} > /dev/null
if [ $? != 0 ]; then
  useradd -M -N -s /dev/null -G media ${JACKETT_NAME}
fi

export JACKETT_NETWORK="container:${MULLVAD_NAME}"
export JACKETT_VOLUME_CONFIG="${JACKETT_NAME}-config"
export JACKETT_VOLUME_DOWNLOADS_HOST="${MEDIA_ROOT_DIR_HOST}/${MEDIA_DOWNLOADS_DIR}"
export JACKETT_UID=$(id -u ${JACKETT_NAME})
export JACKETT_GID=${MEDIA_GROUP_ID}
export JACKETT_DOMAIN="${MULLVAD_NAME}.${MULLVAD_NETWORK}.${HOST_DOMAIN}"
export JACKETT_HOST_DOMAIN="${JACKETT_NAME}.${HOST_DOMAIN}"
export JACKETT_SERVICE="container-${JACKETT_NAME}.service"


######################################
## Flaresolverr

export FLARESOLVERR_NAME="flaresolverr"
export FLARESOLVERR_NETWORK="container:${MULLVAD_NAME}"
export FLARESOLVERR_VOLUME_CONFIG="${FLARESOLVERR_NAME}-config"
export FLARESOLVERR_DOMAIN="${MULLVAD_NAME}.${MULLVAD_NETWORK}.${HOST_DOMAIN}"
export FLARESOLVERR_HOST_DOMAIN="${FLARESOLVERR_NAME}.${HOST_DOMAIN}"
export FLARESOLVERR_SERVICE="container-${FLARESOLVERR_NAME}.service"


######################################
## Organizr

export ORGANIZR_NAME="organizr"
export ORGANIZR_NETWORK="admin"
export ORGANIZR_VOLUME_CONFIG="${ORGANIZR_NAME}-config"
export ORGANIZR_DOMAIN="${ORGANIZR_NAME}.${ORGANIZR_NETWORK}.${HOST_DOMAIN}"
export ORGANIZR_HOST_DOMAIN="${ORGANIZR_NAME}.${HOST_DOMAIN}"
export ORGANIZR_SERVICE="container-${ORGANIZR_NAME}.service"