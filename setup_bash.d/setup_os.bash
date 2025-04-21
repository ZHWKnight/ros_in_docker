#!/bin/bash

# run this script as root
if [ "$EUID" -ne 0 ]; then
  exec sudo $(realpath $0) "$@"
  exit 1
fi

# Modify the sources.list to use USTC mirror
mv /etc/apt/sources.list /etc/apt/sources.list.bak &>/dev/null
mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak &>/dev/null
tee /etc/apt/sources.list.d/ubuntu.sources <<-'EOF' >/dev/null
Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: focal focal-updates focal-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: focal-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

gpg --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
gpg --export C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 | tee /usr/share/keyrings/ros.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/ros.gpg] https://mirrors.ustc.edu.cn/ros/ubuntu $(lsb_release -sc) main" |
  tee /etc/apt/sources.list.d/ros1-latest.list >/dev/null
apt-get update

apt-get install -y \
  build-essential \
  python3-catkin-tools \
  python3-osrf-pycommon \
  python3-rosdep \
  python3-pip \
  ;

apt-get install -y \
  bash-completion \
  iputils-ping \
  wget \
  curl \
  iproute2 \
  vim \
  git \
  cmake \
  tree \
  ;
