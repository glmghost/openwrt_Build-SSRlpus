#!/bin/bash
#
# This script runs AFTER feeds are installed.
# Working directory: openwrt/
#

# ==============================
# Fix Rust CI build error
# ==============================
if [ -f "feeds/packages/lang/rust/Makefile" ]; then
    echo "🔧 Applying Rust CI compatibility patch..."
    sed -i 's|cargo build --manifest-path|CARGO_HOME=/tmp/cargo RUST_BACKTRACE=1 cargo build --config "build.download-ci-llvm = \\\"if-unchanged\\\"" --manifest-path|g' feeds/packages/lang/rust/Makefile
    echo "✅ Rust patch applied."
else
    echo "⚠️ Rust not found, skipping patch."
fi

# ==============================
# Set default LAN IP to 192.168.31.238
# NOTE: This creates openwrt/files/ which will be packed into firmware
# ==============================
echo "🔧 Setting default IP to 192.168.31.238..."
mkdir -p files/etc/config
cat > files/etc/config/network << 'EOF'
config interface 'loopback'
    option device 'lo'
    option proto 'static'
    option ipaddr '127.0.0.1'
    option netmask '255.0.0.0'

config globals 'globals'
    option ula_prefix 'fd00::/8'

config interface 'lan'
    option device 'br-lan'
    option proto 'static'
    option ipaddr '192.168.31.238'
    option netmask '255.255.255.0'
    option ip6assign '60'

config interface 'wan'
    option device 'eth0'
    option proto 'dhcp'

config interface 'wan6'
    option device 'eth0'
    option proto 'dhcpv6'
EOF
echo "✅ Network config created in ./files/etc/config/network"

# ==============================
# Optional: Set default hostname
# ==============================
# mkdir -p files/etc
# echo "MyOpenWrt" > files/etc/hostname
