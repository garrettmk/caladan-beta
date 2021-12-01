#!/bin/bash
source ./env.sh
set -e

PREFIX="caladan.home"

# Make the private key/certificate
commands/make-signed-cert.sh $PREFIX