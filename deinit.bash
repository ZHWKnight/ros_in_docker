#!/bin/bash

. "tools/tools.bash"

container_name=$(list_ros_containers)

while true; do
    echo "Deinitializing ros container will remove all data in the container."
    read -p "Are you sure you want to proceed with this irreversible operation? (yes/no): " confirmation
    case "$confirmation" in
    [yY][eE][sS])
        echo "You chose to proceed. Performing the irreversible operation..."
        docker rm -f $container_name
        break
        ;;
    [nN][oO])
        echo "Operation canceled."
        break
        ;;
    *)
        echo "Please answer yes or no."
        ;;
    esac
done
