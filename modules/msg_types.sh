##
#   Colors for msg functions to use
##

RED='\033[0;31m'
LRED='\033[1;31m'

ORANGE='\033[0;33m'
YELLOW='\033[1;33m'

GREEN='\033[0;32m'
LGREEN='\033[1;32m'

WHITE='\033[1;37m'

##
#   msg functions
##

drunk_message() {
    echo -e "${GREEN}[ MESSAGE ]: ${LGREEN}$@${WHITE}"
}

drunk_warn() {
    echo -e "${ORANGE}[ WARNING ]: ${YELLOW}$@${WHITE}"
}

drunk_err() {
    echo -e "${RED}[ ERROR ]: ${LRED}$@${WHITE}"
    exit 1
}

drunk_spacer() {
    echo " "
    echo -e ${GREEN}------------------${WHITE}
    echo " "
}

##
# DEBUG LOGS
##
if [ "$SHOW_DEBUG" = "true" ]; then
    drunk_debug() {
        echo -e "${GREEN}[ DEBUG ]: ${LGREEN}$@${WHITE}"
    }
else
    drunk_debug() {
        return
    }
fi
