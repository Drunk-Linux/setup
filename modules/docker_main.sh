##
# Here are functions related how docker should be used
##

docker_initial_setup() {
    if [ -f $P_ROOT/setup/checks/docker_ready ]; then
        drunk_debug "Docker image is already downloaded, starting the container now"

        sudo docker start $DOCKER_CONTAINER_NAME >/dev/null

        sleep 1
    else
        drunk_message "Docker initial setup will ask for passwd"
        sudo docker pull hilledkinged/drunk:latest

        sleep 1

        # Setup base docker container
        docker_setup_container

        # Start our new container
        sudo docker start $DOCKER_CONTAINER_NAME >/dev/null

        sleep 1

        docker_initial_sysedit

        # Tell the script that docker image is pulled
        touch $P_ROOT/setup/checks/docker_ready
    fi
}

docker_initial_sysedit() {
    # Make sure that container has sudo installed
    docker_run_cmd bottle --needed --noconfirm -Sy sudo nano mpfr mpc base-devel

    # Add developer user ( used to build pkg's without root
    docker_run_cmd useradd developer -m -g wheel

    # Change sudoers file to not ask password for all users
    docker_run_cmd bash -c /home/developer/DRUNK/setup/docker/fix_sudo.sh
}

docker_setup_container() {
    drunk_message "Docker will need passwd to setup new container"
    sudo docker container create \
        --name $DOCKER_CONTAINER_NAME \
        --volume $P_ROOT:$DOCKER_USER_FOLDER/DRUNK \
        --tty \
        hilledkinged/drunk /bin/bash
}

docker_start() {
    drunk_debug "DOCKER: Executed bash shell"
    sudo docker exec --interactive --tty $DOCKER_CONTAINER_NAME bash
}

docker_run_cmd() {
    drunk_debug "DOCKER: $@"
    sudo docker exec --tty $DOCKER_CONTAINER_NAME $@
}

docker_user_start() {
    drunk_debug "DOCKER: Executed bash shell"
    sudo docker exec --interactive --tty $DOCKER_CONTAINER_NAME su developer -c bash
}

docker_user_run_cmd() {
    drunk_debug "DOCKER: $@"
    sudo docker exec --tty $DOCKER_CONTAINER_NAME su developer -c "$@"
}
