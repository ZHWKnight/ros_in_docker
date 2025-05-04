#!/bin/bash

. "tools/tools.bash"

container_name=$(list_ros_containers)

container_id=$(docker ps -q -f "name=$container_name")
x11_hostname=$(docker inspect --format='{{ .Config.Hostname }}' $container_id)

xhost +local:$x11_hostname

if docker ps --filter "name=$container_name" --filter "status=exited" | grep -wq "$container_name"; then
  echo "ros docker container: $container_name was exited ... now starting"
  docker start $container_name
fi

docker exec -it $container_name bash
