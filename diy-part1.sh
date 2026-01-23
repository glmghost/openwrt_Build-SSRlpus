#!/bin/bash
#
# Add third-party feed sources before updating feeds
#

# Add helloworld (required for SSR/V2Ray plugins)
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default

# Optional: uncomment if you need PassWall
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall;main' >> feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages;main' >> feeds.conf.default
