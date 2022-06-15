#!/bin/bash

set -e -o pipefail -u

##
#   Export some needed things for head script to work with
##

if [ -d setup/drunk.sh ]; then
    cd .
else
    cd "$(realpath "$(dirname "$0")")/../"
fi

export P_ROOT=$(pwd)

##
#   Load modules
##

# Export all variables so bash wont freak out of undefined variables
source $P_ROOT/setup/modules/variables.sh

# Load up msg types
source $P_ROOT/setup/modules/msg_types.sh

# Load up core functions
source $P_ROOT/setup/modules/main_func.sh

# Load up package src location finder
source $P_ROOT/setup/modules/pkg_location.sh

# Load up dependency resolver
source $P_ROOT/setup/modules/dep_resolver.sh

# Feed our script how to build pkg's
source $P_ROOT/setup/modules/pkg_build.sh

# Feed it again to clean leftovers on pkg's
source $P_ROOT/setup/modules/pkg_clean.sh

##
#   Main Functions
##

# Run basic env setup
env_setup

# Declare pkg list variable here
declare -a PKG_LIST=()

###
# TODO
# Currently DrunkOS only supports x86_64
# so lets leave it here as hardcoded
# ( modules use this declaration so implementing proper way should be easy )
###
declare -a P_ARCH=x86_64

if [ "$#" -lt 1 ]; then show_help; fi
while (($# >= 1)); do
    case "$1" in
        --) shift 1; break;;
        -h|--help) show_help;;
        -b|--build) export DRUNK_BUILD=true;;
        -f|--force-build) export MAKEPKG_EXTRA_ARG=" -f ";;
        -c|--clean) export DRUNK_CLEAN=true;;
        -d|--docker)
        if [ $# -eq 1 ]; then
                drunk_err "Docker option cant be used alone ( need to be first arg! )"
        fi
        if [ -z "$1" ]; then
            drunk_warn "Make sure to add/use docker experience before adding build/clean option"
            drunk_err "nevertheless this option is in wrong place, now panicking"
        else
            export DRUNK_DOCKER=true
        fi ;;
        *)
        export PKG_LIST+=($1);;
        -*) unknown_option $1;;
        --*) unknown_option $1;;
    esac
    shift 1
done
unset -f show_help

case "$DRUNK_BUILD" in
    "true")
        case "$DRUNK_DOCKER" in
            "true")
                case "$DRUNK_CLEAN" in
                    "true")
                        build_pkg_docker
                        clean_pkg_docker
                    ;;
                    "false")
                        build_pkg_docker
                    ;;
                esac
            ;;
            "false")
                case "$DRUNK_CLEAN" in
                    "true")
                        build_pkg
                        clean_pkg
                    ;;

                    "false")
                        build_pkg
                    ;;
                esac
            ;;
        esac
    ;;
    "false")
        case "$DRUNK_CLEAN" in
            "true")
                clean_pkg
            ;;

            "false")
                return
            ;;
        esac
    ;;
esac
