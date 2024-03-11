#!/usr/bin/env bash
# Created by Jonathan Mikler on 29/February/24

# get the absolute path of the 'ROS_shell_toolbox' directory and wirtes it on a .env file inside of it

main(){
    script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    echo "export ROS_SHELL_TOOLBOX_LOCATION=$script_dir" > $script_dir/.env

    if [ -f "$script_dir/.env" ]; then
        source "$script_dir/.env"
        echo "file .env already exists"
        echo "ROS-Toolbox location: ${ROS_SHELL_TOOLBOX_LOCATION}"
        read -p "Do you want to replace it with '${script_dir}'? (y/n): " replace_env

        if [ "$replace_env" == "y" ]; then
            echo "export ROS_SHELL_TOOLBOX_LOCATION=$script_dir" > "$script_dir/.env"
            echo "The .env file has been replaced."
        fi
    else
        echo "export ROS_SHELL_TOOLBOX_LOCATION=$script_dir" > "$script_dir/.env"
        echo "The .env file has been created."
    fi

}

main