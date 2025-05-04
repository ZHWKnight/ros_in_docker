#!/bin/bash

if [ "$EUID" -eq 0 ]; then
  apt-get install -y python3-pip
else
  sudo apt-get install -y python3-pip
fi

python3 -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade pip
pip config set global.index-url "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
pip config set global.extra-index-url "https://mirrors.ustc.edu.cn/pypi/simple"
