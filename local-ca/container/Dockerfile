FROM alpine:latest

# Update packages and install dependencies
RUN \
  apk update && \
  apk add openssl

# Copy in the directory structure
COPY rootfs /
