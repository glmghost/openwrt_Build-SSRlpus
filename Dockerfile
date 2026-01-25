# 使用Debian作为基础镜像以确保兼容性
FROM debian:bullseye-slim

LABEL maintainer="OpenWrt Docker Builder" \
      description="Generic OpenWrt container for running OpenWrt as a service" \
      version="1.0"

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    OPENWRT_ROOT=/openwrt \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 安装必要的系统库和工具
RUN apt-get update && apt-get install -y \
    # 基础系统库
    libc6 \
    libgcc1 \
    libustream-ssl \
    libjson-c5 \
    libubox1 \
    libblobmsg-json-dev \
    libubus1 \
    libuci1 \
    libiwinfo-lua \
    liblucihttp0 \
    liblucihttp-ucode \
    # 工具
    tar \
    gzip \
    curl \
    wget \
    iptables \
    iputils-ping \
    dnsutils \
    procps \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# 创建OpenWrt根目录
RUN mkdir -p ${OPENWRT_ROOT}

# 从构建目录复制OpenWrt rootfs
# 这里假设rootfs tarball在构建上下文的openwrt/bin/targets目录下
COPY openwrt/bin/targets/*/*/*rootfs*.tar.gz /tmp/openwrt-rootfs.tar.gz

# 解压rootfs到OpenWrt根目录
RUN tar -xzf /tmp/openwrt-rootfs.tar.gz -C ${OPENWRT_ROOT} \
    && rm -f /tmp/openwrt-rootfs.tar.gz

# 创建必要的系统目录
RUN mkdir -p ${OPENWRT_ROOT}/proc \
             ${OPENWRT_ROOT}/sys \
             ${OPENWRT_ROOT}/dev \
             ${OPENWRT_ROOT}/tmp \
             ${OPENWRT_ROOT}/run \
             ${OPENWRT_ROOT}/var/run \
             ${OPENWRT_ROOT}/var/log \
             ${OPENWRT_ROOT}/mnt \
             ${OPENWRT_ROOT}/media \
             ${OPENWRT_ROOT}/overlay

# 设置临时目录权限
RUN chmod 1777 ${OPENWRT_ROOT}/tmp

# 创建一个启动脚本用于挂载必要的文件系统
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# 挂载必要的虚拟文件系统\n\
mkdir -p /proc /sys /dev /tmp /run\n\
mount -t proc proc /proc 2>/dev/null || true\n\
mount -t sysfs sysfs /sys 2>/dev/null || true\n\
mount -t devtmpfs devtmpfs /dev 2>/dev/null || true\n\
mkdir -p /dev/pts /dev/shm\n\
mount -t devpts devpts /dev/pts 2>/dev/null || true\n\
mount -t tmpfs tmpfs /dev/shm 2>/dev/null || true\n\
mount -t tmpfs tmpfs /run 2>/dev/null || true\n\
\n\
# 设置网络接口\n\
ip link set lo up\n\
\n\
# 启动OpenWrt init系统\n\
if [ -x "${OPENWRT_ROOT}/sbin/init" ]; then\n\
    exec chroot ${OPENWRT_ROOT} /sbin/init\n\
elif [ -x "${OPENWRT_ROOT}/etc/init.d/rcS" ]; then\n\
    exec chroot ${OPENWRT_ROOT} /bin/sh /etc/init.d/rcS\n\
else\n\
    echo "Error: No init system found in OpenWrt rootfs"\n\
    tail -f /dev/null\n\
fi' > /start-openwrt.sh \
    && chmod +x /start-openwrt.sh

# 设置工作目录
WORKDIR ${OPENWRT_ROOT}

# 暴露常见的OpenWrt服务端口
EXPOSE 22 80 443 53 67 68 54321

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD chroot ${OPENWRT_ROOT} /bin/ping -c 1 127.0.0.1 || exit 1

# 设置默认入口点
ENTRYPOINT ["/start-openwrt.sh"]

# 默认命令
CMD ["/bin/bash"]
