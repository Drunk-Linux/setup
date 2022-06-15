##
#   Setup and export env for main script
##

env_setup() {
    check_user
    check_projects
}

check_projects() {
    if [ -d $P_ROOT/pkgbuild ]; then
        drunk_debug "Dev has pkgbuild folder, skipping initial bootstrap"
    else
        drunk_warn "Missing pkgbuild project, running initial bootstrap"
        run_bootstrap
    fi
}

check_user() {
    if [[ $EUID -ne 0 ]]; then
        drunk_debug "User isn't root, thats good"
    else
        drunk_err "User is root and this isn't allowed"
    fi
}

run_bootstrap() {
    drunk_debug "Function run_bootstrap was started"
    git clone https://git.it-kuny.ch/drunk/drunk-pkgbuild.git $P_ROOT/pkgbuild

    create_folders

    read -p "Do you wish to clone additional sources?" yn
    case $yn in
        [Yy]* ) clone_sources;;
        [Nn]* ) echo " ";;
        * ) echo "Assuming no";;
    esac
    read -p "Do you wish to clone some repos?" yn
    case $yn in
        [Yy]* ) clone_repos;;
        [Nn]* ) echo " ";;
        * ) echo "Assuming no";;
    esac
}

create_folders() {
    mkdir -p drunk-source repository/x86_64/pkgs/{core,cross-tools,extra,extra32,games,layers,proprietary,server} repository/x86_64/desktop
}

clone_sources() {
    drunk_debug "clone sources"
}

clone_repos() {
    drunk_message "clone repos"
}

unknown_option() {
    drunk_warn "Unknown option ' $@ '"
    show_help
}

show_help() {
    echo "## Usage of drunk script"
    echo " "
    echo " -b or --build pkgname    : Will build a pkg you asked for ( Assumes you have deps installed )"
    echo " -f or --force-build      : Will add -f to makepkg so it will ignore if pkg is already built"
    echo " -c or --clean            : [WIP] Will clean up pkgbuild leftovers"
    echo " -d or --docker           : [WIP] This will make pkg builder use docker environment"

    exit 1
}
