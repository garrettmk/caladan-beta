#!/bin/bash

#
# Get the slot name from a given device tag
#

TAG=$1

# Figure out the slot
SLOT1_TAGS=("moonlander1" "mouse1" "mtrack1" "yeti1")
SLOT2_TAGS=("moonlander2" "mouse2" "mtrack2" "yeti2")

if [[ ${SLOT1_TAGS[@]} =~ ${TAG} ]]; then
  echo Slot1
elif [[ ${SLOT2_TAGS[@]} =~ ${TAG} ]]; then
  echo Slot2
fi