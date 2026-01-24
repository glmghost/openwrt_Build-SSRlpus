#!/bin/bash
# Fix for Rust build issues
sed -i '/CONFIG_TARGET_ROOTFS_INITRAMFS/d' .config
echo 'CONFIG_TARGET_ROOTFS_INITRAMFS=y' >> .config

# Set default LAN IP to 192.168.31.238
sed -i 's/192.168.1.1/192.168.31.238/g' package/base-files/files/bin/config_generate
