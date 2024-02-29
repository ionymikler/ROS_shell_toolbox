#!/usr/bin/env bash
# Created by Jonathan Mikler on 29/February/24

# This script compiles some ROS oriented shell tools.

function verify_env_file(){
    local RED_TXT='\e[31m'
    local NC='\033[0m'

    # check if '.env' file exists, is so source it, if not echo an error message
    script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
    if [ -f "${script_dir}/.env" ]; then
        source "${script_dir}/.env"
    else
        echo -e "${RED_TXT}Error: The .env file does not exist, please run the '.get_toolbox_location.sh' script${NC}"
        return 1
    fi
}
main(){

    if ! verify_env_file; then
        return
        # # Continue with the rest of the script
        # source "${ROS_SHELL_TOOLBOX_LOCATION}/utils/utils_source.sh"
        # set_ros_ws
        # # cd "${HOME}/ws/${SELECTED_ROS_WS}"
        # # rsrc
        # # cd -
    fi
    source "${ROS_SHELL_TOOLBOX_LOCATION}/utils/utils_source.sh"
    set_ros_ws
}

main