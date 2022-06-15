##
# Here we will declare function how and where to work with pkg's
##

build_pkg() {
    drunk_debug "EXECUTED - Build pkg"

   for (( p=0; p<${#PKG_LIST[@]}; p++ )); do
    PKG_NAME=$(basename "${PKG_LIST[p]}")
    drunk_message "Started compiling package $PKG_NAME"

    # Find its location
    find_pkg_location

    cd $PKG_PATH

    if [ -f PKGBUILD  ]; then
        drunk_debug "Found correct directory with PKGBUILD"
    else
        drunk_err "directory or PKGBUILD is missing for asked pkg"
    fi

    # Resolve + install needed deps of this pkg
    resolve_dep
    install_dep

    drunk_spacer

    # Start the compiler for pkg
    makepkg $MAKEPKG_EXTRA_ARG

    drunk_spacer

    cp -f $PKG_NAME-$PKG_VERSION-$pkgrel-$P_ARCH.pkg.tar.gz $P_ROOT/pkgbuild/pkgs/$WHAT_AM_I/

    drunk_message "Build successfully done, and pkg file is located at $P_ROOT/pkgbuild/pkgs/$WHAT_AM_I/$PKG_NAME-$PKG_VERSION-$pkgrel-$P_ARCH.pkg.tar.gz"
    done
}

# TODO
build_pkg_docker() {
    drunk_debug "EXECUTED - Build pkg in docker"
    drunk_err "Sorry but docker way isn't implemented yet"
}
