##
#   Setup and export env for main script
##

env_setup() {
    # Make sure that our developer dosent run this script as root
    check_user

    # Safety check so things dont get re-runned
    if [ -f $P_ROOT/setup/checks/is_checked ]; then
        drunk_debug "Developer has passed initally required steps"
    else
        install_required_deps
        check_projects

        # Tell the script that inital setup is done
        touch $P_ROOT/setup/checks/is_checked
    fi
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

install_required_deps() {
    REQ_PKGS=" docker nano mpfr mpc base-devel"
    drunk_message "Please allow this one time to run inital setup of bottle install"
    sudo bottle -Sy --needed $REQ_PKGS
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
    drunk_message "###"
    drunk_message "# Usage of drunk script"
    drunk_message "###\n"
    drunk_message " -b or --build pkgname    : Will build a pkg you asked for ( Assumes you have deps installed )"
    drunk_message " -f or --force-build      : Will add -f to makepkg so it will ignore if pkg is already built"
    drunk_message " -ne or --no-extract      : Will add -e to makepkg so prepare + extracting src over existing one is skipped ( basically resume compile flag )"
    drunk_message " -c or --clean            : Will clean up pkgbuild leftovers"
    drunk_message " -d or --docker           : This will make pkg builder use docker environment"
    drunk_message " -dr or --docker-reset    : This reset's docker container ( if it breaks for some reson )"
    exit 1
}
