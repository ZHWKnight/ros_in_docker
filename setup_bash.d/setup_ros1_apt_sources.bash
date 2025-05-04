#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  exec sudo $(realpath $0) "$@"
  exit 1
fi

gpg --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
gpg --export C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 | tee /usr/share/keyrings/ros.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/ros.gpg] https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ $(lsb_release -sc) main" |
  tee /etc/apt/sources.list.d/ros1-latest.list >/dev/null
apt-get update
