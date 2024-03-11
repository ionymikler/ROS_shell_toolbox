#!/bin/bash
# Created by: Jonathan Mikler
# Creation Date: 29/February/24


main(){
    bash .make_env_file.sh
    if [ -f .env ]; then
        source "${ROS_SHELL_TOOLBOX_LOCATION}/.env"
        echo "source ${ROS_SHELL_TOOLBOX_LOCATION}/ros_shell_toolbox.sh" >> ~/.bashrc
    fi

    source ~/.bashrc

    echo "Installation complete."
}

main

