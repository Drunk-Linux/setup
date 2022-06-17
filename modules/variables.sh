##
# Here we will export all variables
##

export DRUNK_BUILD=false
export DRUNK_CLEAN=false
export DRUNK_DOCKER=false
export P_ARCH=none

##
# Failsafe incase of error
##

export PKG_NAME=none
export PKG_ROOT_DIR=none
export depend=none
export makedepend=none
export FULL_DEP_LIST=none
export donenow=0
export PKG_VERSION=none
export PKG_REL=none
export WHAT_AM_I=none

##
# Docker related
##
export DOCKER_CONTAINER_NAME=drunk_dev
export DOCKER_USER_FOLDER=/home/developer

##
# Empty string variable's
##
export MAKEPKG_EXTRA_ARG=" "

##
# Developer friend
##

export SHOW_DEBUG=true

# This is needed so system catches up with all exports
sleep 0.1
