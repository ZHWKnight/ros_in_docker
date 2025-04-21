#!/bin/bash

python3 -m pip install -i https://mirrors.ustc.edu.cn/pypi/simple --upgrade pip
pip config set global.index-url "https://mirrors.ustc.edu.cn/pypi/simple"
pip config set global.extra-index-url "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
