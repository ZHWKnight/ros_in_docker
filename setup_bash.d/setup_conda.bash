#!/bin/bash

wget -O- https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh --connect-timeout 3 | bash
if [[ $? -ne 0 ]]; then
  wget -O- https://ghfast.top/https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh | bash
fi

tee ~/.condarc <<-'EOF' >> /dev/null
auto_activate_base: false
show_channel_urls: true
channels:
  - conda-forge
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
