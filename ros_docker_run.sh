#!/bin/bash

export containerId=$(docker ps -l -q)
export x11_hostname=`docker inspect --format='{{ .Config.Hostname }}' $containerId`
xhost +local:$x11_hostname

CONTAINER_NAME="ros1_noetic"

if docker ps --filter "name=$CONTAINER_NAME" --filter "status=exited" | grep -q "$CONTAINER_NAME"; then
    echo "ros docker container $CONTAINER_NAME was exited ... now starting"
    docker start $CONTAINER_NAME 
fi

docker exec -it $CONTAINER_NAME /bin/bash
