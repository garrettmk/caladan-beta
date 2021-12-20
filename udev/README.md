# UDEV rules

This folder holds commands and configuration for custom udev rules.

## Notes

- Use the command `udevadm monitor -p` to listen to device events and list their properties.
- For USB devices:
  - Find their bus number, vendor ID and product ID with `lsusb`
  - Use `ENV{PRODUCT}=="<vendor id>/<product id>/*` to select a device by vendor/product
  - Use `SUBSYSTEM=="usb",ATTRS{busnum}==<bus number>` to select a particular USB bus
  - Use `TAG+="systemd"` to tell systemd to create a device unit. See https://www.freedesktop.org/software/systemd/man/systemd.device.html for more info.
  - Use `SYMLINK+="<link name>"` to name the symlink

