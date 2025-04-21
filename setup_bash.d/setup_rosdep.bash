#!/bin/bash

$(dirname "$0")
command=$(
  cat <<EOF
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
