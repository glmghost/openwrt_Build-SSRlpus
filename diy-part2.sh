#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds & Install feeds)
#
# This script runs AFTER feeds are installed, so we can safely patch files in feeds/
#

# ==============================
# Fix Rust build failure in CI
# ==============================
if [ -f "feeds/packages/lang/rust/Makefile" ]; then
    echo "🔧 Applying Rust CI compatibility patch..."
    # Patch the cargo build command to use 'if-unchanged' for download-ci-llvm
    sed -i 's|cargo build --manifest-path|CARGO_HOME=/tmp/cargo RUST_BACKTRACE=1 cargo build --config "build.download-ci-llvm = \\\"if-unchanged\\\"" --manifest-path|g' feeds/packages/lang/rust/Makefile
    echo "✅ Rust patch applied."
else
    echo "⚠️ Rust not found in feeds, skipping patch."
fi

# ==============================
# Optional: Remove conflicting packages from official feeds
# (Only needed if you use passwall or helloworld)
# ==============================
# If using passwall, remove official versions to avoid conflict
# rm -rf feeds/packages/net/{xray-core,sing-box,geoview}
# rm -rf feeds/luci/applications/luci-app-passwall

# If using helloworld, remove official ssr-plus if exists
# rm -rf feeds/luci/applications/luci-app-ssr-plus

# ==============================
# Your custom configuration below (optional)
# ==============================
# Example: Copy your config
# cp -f $GITHUB_WORKSPACE/.config ./

# Example: Enable specific package
# ./scripts/config/conf --enable PACKAGE_luci-app-helloworld
