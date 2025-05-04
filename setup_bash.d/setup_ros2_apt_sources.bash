#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  exec sudo $(realpath $0) "$@"
  exit 1
fi

curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg --connect-timeout 3
if [[ $? -ne 0 ]]; then
  curl -sSL https://ghfast.top/https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
fi
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt-get update

apt-get install -y \
  ros-dev-tools
