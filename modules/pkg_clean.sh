##
# Here we will declare function how and where to clean pkg's
##

# TODO
clean_pkg() {
    for (( p=0; p<${#PKG_LIST[@]}; p++ )); do
    PKG_NAME=$(basename "${PKG_LIST[p]}")

    drunk_debug "CLEANER: Executed"

    find_pkg_location

    cd $PKG_PATH

    if [ -f PKGBUILD  ]; then
        drunk_debug "Found correct directory with PKGBUILD"
    else
        drunk_err "directory or PKGBUILD is missing for asked pkg"
    fi

    if [ -d src ]; then
        drunk_debug "$PKG_NAME has been selected for cleaning"
    else
        drunk_err "$PKG_NAME isn't dirty, meaning we will not clean it!"
    fi

    # Cleanup everything
    rm -rf pkg/ src/ *pkg* *xz* *tar.gz *tar.bz2 *.zip */ *tgz *tar.zst *sign* *sig* *asc*

    drunk_message "$PKG_NAME has been cleaned"

    done
}

# TODO
clean_pkg_docker() {
    drunk_debug "EXECUTED - Build pkg in docker"
    drunk_err "Sorry but docker way isn't implemented yet"
}
