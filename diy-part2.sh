#!/bin/bash
# diy-part2.sh

# 加载自定义配置前，先修复 rust 的 CI 问题
if [ -f "feeds/packages/lang/rust/Makefile" ]; then
    echo "Patching rust Makefile for CI compatibility..."
    # 方法：在 cargo build 命令中注入 config 参数
    sed -i 's|cargo build|CARGO_HOME=/tmp/cargo RUST_BACKTRACE=1 cargo build --config "build.download-ci-llvm = \\\"if-unchanged\\\""|g' feeds/packages/lang/rust/Makefile
    echo "Rust patch applied successfully."
else
    echo "Rust not found in feeds, skipping patch."
fi

# 此处可继续你的其他自定义配置，例如：
# cp -f your-config .config
# ./scripts/config/conf --enable PACKAGE_xxx
