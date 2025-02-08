#!/bin/bash

CONTAINER_NAME="ros1_noetic"

if docker ps --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
    echo "ros docker container $CONTAINER_NAME has inited..."
else
    echo "now init docker container $CONTAINER_NAME..."
    docker run -it \
    --name=$CONTAINER_NAME \
    --user=$(id -u $USER):$(id -g $USER) \
    --env="DISPLAY" \
    --ene="QT_X11_NO_MITSHM=1" \
    --workdir="/home/$USER" \
    --network host \
    --volume="/home/$USER:/home/$USER" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    osrf/ros:noetic-desktop-full \
    /bin/bash -c "echo OK."
fi
