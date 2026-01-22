#!/bin/bash
# diy-part1.sh

# 默认操作（可保留）
# sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.1/g' target/linux/x86/Makefile

# ========== 关键修复：Rust CI 兼容性补丁 ==========
echo "Applying Rust CI compatibility patch..."

# 等待 feeds 安装后才能 patch，所以放在 diy-part1.sh 末尾（此时 feeds 已 update & install）
# 但注意：此脚本在 feeds install 之前运行，所以我们需手动进入 feeds 目录处理

# 实际上，在 Load custom feeds 步骤中，此脚本在 feeds update/install 之前运行
# 因此我们只能预设：后续会安装 rust，所以提前准备一个 hook 或直接修改 Makefile 模板

# 更可靠方式：在 feeds 安装后、配置加载前 patch —— 但当前流程限制
# 所以我们在 diy-part2.sh 中做 patch（更合理）

# 因此，建议将 patch 移到 diy-part2.sh！
# 但为保持结构清晰，我们在这里不执行 patch，而是在下一步骤前由主流程保证

# 实际 patch 将在下面的“Load custom configuration”步骤中通过 diy-part2.sh 完成
# 所以此处留空或仅做提示
echo "Rust patch will be applied in diy-part2.sh after feeds install."
