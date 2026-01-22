#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Add feed sources
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
# 取消注释下面这行如果你需要 passwall（注意：passwall 依赖 rust/sing-box/xray 等）
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall;main' >> feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages;main' >> feeds.conf.default
