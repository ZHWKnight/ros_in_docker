#!/bin/bash

. "tools/tools.bash"

container_name=$(list_ros_containers)

container_id=$(docker ps -q -f "name=$container_name")
x11_hostname=$(docker inspect --format='{{ .Config.Hostname }}' $container_id)

xhost -local:$x11_hostname

if docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name"; then
  echo "ros docker container: $container_name is running..."
  docker stop $container_name
fi

echo "echo ros docker container: $container_name has stoped"
