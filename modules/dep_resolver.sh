##
# Here we will try to lookup what depends on what and what makedepend pkg's we need to install
##

resolve_dep() {
    drunk_debug "DEP-Resolver looks for $PKG_NAME pkg"

    cd $PKG_PATH

    source PKGBUILD

    drunk_debug "DEPENDS LIST: ${depends[*]}"
    drunk_debug "MAKEDEPENDS List: ${makedepends[*]}"

    export PKG_VERSION=$pkgver
    export PKG_REL=$pkgrel
    FULL_DEP_LIST="${depends[*]} ${makedepends[*]}"
}

install_dep() {
    drunk_message "Please insert asked password so"
    drunk_message "Bottle can install these packages ' $FULL_DEP_LIST ' so ' $PKG_NAME ' can be compiled"

    drunk_spacer
    sudo -S bottle -Sy --needed $FULL_DEP_LIST
    drunk_spacer
}
