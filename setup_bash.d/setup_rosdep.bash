#!/bin/bash

command=$(
  cat <<EOF
python3 -m pip install -i https://mirrors.ustc.edu.cn/pypi/simple --upgrade pip
pip config set global.index-url "https://mirrors.ustc.edu.cn/pypi/simple"
pip config set global.extra-index-url "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
pip install rosdepc
rosdepc init
EOF
)

if [ "$EUID" -eq 0 ]; then
  eval "$command"
else
  sudo bash -c "$command"
fi

rosdepc update
