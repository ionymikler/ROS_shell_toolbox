#!/usr/bin/env bash
# Created by Jonathan Mikler on 31/August/23
ROS_WS_CONF_FILE="${HOME}/ws/tools/env/.ros_ws.conf"
alias gzb_src="log_info 'sourcing gazebo'&&source /usr/share/gazebo/setup.sh"
alias rebash="source ~/.bashrc"

function rsrc() {
    if [[ $1 == "-g" || $1 == "--source-gazebo" ]]; then
        gzb_src
    fi
    # Source ROS setup file for the current workspace
    local parent_dir=${PWD##*/}
    local setup_file="$PWD/install/setup.bash"
    if [ -f "$setup_file" ]; then
        # get name of parent folder
        log_info "sourcing setup for ws '$parent_dir' ($setup_file)"
        source "$setup_file"
    else
        log_error "Error: $setup_file not found.
        Are you in a ROS workspace?
        Is the workspace built?"
    fi
}

function roslog_del() {
    ROSLOG_DIR="$HOME/.ros/log"
    log_info "cleaning ros log ($ROSLOG_DIR)"
    rm -rf "$ROSLOG_DIR"/*
}

function del_pkg(){
    local pkg_name=$1
    local ws_dir="$HOME/ws/$SELECTED_ROS_WS"

    if [ -z "$pkg_name" ]; then
        log_error "A package name is required."
        return 1
    fi

    build_dir="${ws_dir}/build/${package_name}"
    install_dir="${ws_dir}/install/${package_name}"
    log_dir="${ws_dir}/log/${package_name}"

    if [ -d "$build_dir" ]; then
        log_info "Deleting $build_dir"
        rm -rf "$build_dir"
    else
        log_warn "Build directory not found for $package_name"
    fi

    if [ -d "$install_dir" ]; then
        log_info "Deleting $install_dir"
        rm -rf "$install_dir"
    else
        log_warn "Install directory not found for $package_name"
    fi

    if [ -d "$log_dir" ]; then
        log_info "Deleting $log_dir"
        rm -rf "$log_dir"
    else
        log_warn "Log directory not found for $package_name"
    fi


}

function rospkg_del() {
    if [ -z "$SELECTED_ROS_WS" ]; then
        log_error "No ROS ('SELECTED_ROS_WS') workspace selected."
        return 1
    fi
    base_dir="$HOME/ws/${SELECTED_ROS_WS}"

    if [ $# -eq 0 ]; then
        log_error "At least one package name is required."
        return 1
    fi

    for package_name in "$@"; do
        del_pkg "$package_name"
    done
}

function set_ros_ws() {
    # if no argument, then source the config file, else set the config file
    if [ -z "$1" ]; then
        if [ -f "$ROS_WS_CONF_FILE" ]; then
            source "$ROS_WS_CONF_FILE"
            if [ -z "$SELECTED_ROS_WS" ]; then
                log_error "ROS workspace not set in file $ROS_WS_CONF_FILE."
                return 1
            fi
        else
            log_error "ROS workspace config file not found at '$ROS_WS_CONF_FILE'"
            return 1
        fi
    else
        export SELECTED_ROS_WS="$1"
    fi

    # from here on, SELECTED_ROS_WS is set, but not necessarily valid
    if [ ! -d "$HOME/ws/$SELECTED_ROS_WS" ]; then
        log_error "ROS workspace '$SELECTED_ROS_WS' does not exist."
        return 1
    fi
    
    echo "export SELECTED_ROS_WS=$SELECTED_ROS_WS" >"$ROS_WS_CONF_FILE"
    ROS_WS="$SELECTED_ROS_WS"
    export $ROS_WS
    log_info "ROS workspace set to '$SELECTED_ROS_WS'"
}

function ros_ws_selected() {
    if [ -z "$SELECTED_ROS_WS" ]; then
        log_error "No ROS ('SELECTED_ROS_WS') workspace selected."
        return 1
    fi
    echo "$SELECTED_ROS_WS"
}

function cdws() {
    if [ -z "$1" ]; then
        if [ -z "$SELECTED_ROS_WS" ]; then
            log_error "No ROS ('SELECTED_ROS_WS') workspace selected."
            return 1
        fi
        cd "$HOME/ws/$SELECTED_ROS_WS"
        rsrc
    else
        if [ ! -d "$HOME/ws/$1" ]; then
            log_error "ROS workspace '$HOME/ws/$1' does not exist."
            return 1
        fi
        cd "$HOME/ws/$1"
    fi
}

alias get_ros_ws="ros_ws_selected"
alias ROS_WS="ros_ws_selected"