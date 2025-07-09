#!/bin/bash

# run this script as root
if [ "$EUID" -ne 0 ]; then
  exec sudo $(realpath $0) "$@"
  exit 1
fi

# Modify the sources.list to use USTC mirror
mv /etc/apt/sources.list /etc/apt/sources.list.bak &>/dev/null
mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak &>/dev/null
tee /etc/apt/sources.list.d/ubuntu.sources <<-EOF >/dev/null
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: $(lsb_release -sc) $(lsb_release -sc)-updates $(lsb_release -sc)-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
# Types: deb-src
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: $(lsb_release -sc) $(lsb_release -sc)-updates $(lsb_release -sc)-backports
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
Types: deb
URIs: https://security.ubuntu.com/ubuntu/
Suites: $(lsb_release -sc)-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# Types: deb-src
# URIs: https://security.ubuntu.com/ubuntu/
# Suites: $(lsb_release -sc)-security
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 预发布软件源，不建议启用

# Types: deb
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: $(lsb_release -sc)-proposed
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# Types: deb-src
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: $(lsb_release -sc)-proposed
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

apt-get update
apt-get install -y \
  bash-completion \
  iputils-ping \
  iproute2 \
  wget \
  curl \
  vim \
  git \
  cmake \
  tree \
  ;
