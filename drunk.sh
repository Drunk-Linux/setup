#!/bin/bash

##
#   Remember to run it only in drunk system
##

# Some needed exports
if [ -d "$(pwd)/pkgbuild" ]; then
    DRUNK_ROOT=$(pwd)
else
    DRUNK_ROOT=$(pwd)/../
fi

stage1() {
    # Upgrade drunk system
    echo "[!]: Password will be asked to update/install needed packages"
    sudo bottle -Syu || exit 1

    echo " "

    # bottle needed deps like git and tc
    sudo bottle -Sy --needed git gcc clang || exit 1
}

stage2() {
    # Make basic dev dir env
    cd $DRUNK_ROOT

    mkdir -p drunk-source repository/x86_64/pkgs/{core,cross-tools,extra,extra32,games,layers,proprietary,server} repository/x86_64/desktop

    ln -sf setup/drunk.sh drunk.sh
}

stage3() {
    # Start clonging needed things to right place
    cd $DRUNK_ROOT

    # Clone all repos
    for f in core cross-tools extra extra32 games layers proprietary server
    do
        if [ -d "$DRUNK_ROOT/repository/x86_64/$f" ]; then
            echo " "
            echo "[!]: Repo '$f' exists, running 'git pull'"
            cd repository/x86_64/$f && git pull
            cd $DRUNK_ROOT
        else
            echo " "
            echo "[!]: Repo $f dosent exist, cloning now"
            git clone https://git.it-kuny.ch/drunk/repository/x86_64/$f.git $DRUNK_ROOT/repository/x86_64/$f
        fi
    done

    for f in gnome kde xfce
    do
        if [ -d "$DRUNK_ROOT/repository/x86_64/desktop/$f" ]; then
            echo " "
            echo "[!]: Repo '$f' exists, running 'git pull'"
            cd repository/x86_64/desktop/$f && git pull
            cd $DRUNK_ROOT
        else
            echo " "
            echo "[!]: Repo $f dosent exist, cloning now"
            git clone https://git.it-kuny.ch/drunk/repository/x86_64/desktop/$f.git $DRUNK_ROOT/repository/x86_64/desktop/$f
        fi
    done

    # Clone other needed things
    if [ -d "$DRUNK_ROOT/pkgbuild" ]; then
        echo " "
        echo "[!]: Repo 'pkgbuild' exists, running 'git pull'"
        git pull
    else
        git clone https://git.it-kuny.ch/drunk/drunk-pkgbuild.git $DRUNK_ROOT/pkgbuild
    fi

    # Source code bits are up to dev to choose and clone
}

msg() {
    echo "$@"
}

finish() {
    msg Everything is now done
}

# Run all stages
stage1
stage2
stage3
finish
