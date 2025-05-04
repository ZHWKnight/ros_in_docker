#!/bin/bash

privilege_command=$(
  cat <<EOF
apt-get install -y python3-rosdep 
mkdir -p /etc/ros/rosdep/sources.list.d/
mv /etc/ros/rosdep/sources.list.d/20-default.list /etc/ros/rosdep/sources.list.d/20-default.list.bak
curl -o /etc/ros/rosdep/sources.list.d/20-default.list -L https://mirrors.tuna.tsinghua.edu.cn/github-raw/ros/rosdistro/master/rosdep/sources.list.d/20-default.list
EOF
)

if [ "$EUID" -eq 0 ]; then
  eval "$privilege_command"
else
  sudo bash -c "$privilege_command"
fi

export ROSDISTRO_INDEX_URL=http://mirrors.tuna.tsinghua.edu.cn/rosdistro/index-v4.yaml
echo 'export ROSDISTRO_INDEX_URL=http://mirrors.tuna.tsinghua.edu.cn/rosdistro/index-v4.yaml' >> ~/.bashrc

rosdep update
