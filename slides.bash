#!/usr/bin/env bash

#
# Author: Kenneth Lewenhagen
# To be used in vlinux course
# https://github.com/dbwebb-se/vlinux
# https://dbwebb.se/kurser/vlinux
#

# Globals
VERSION="1.0.0"
SCRIPT=$( basename "$0" )
_COLUMNS=$(tput cols)
_LINES=$(tput lines)



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"$SCRIPT for slide presentations."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  <0-7>                Coursepart/folder"
""
"Options:"
"  --help, -h     Print help."
"  --version, -v  Print version."
"  --export       Creates .pdf from selected course part"
    )

    printf "%s\n" "${txt[@]}"
}



#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )

    [[ $message ]] && printf "%s\n" "$message"

    printf "%s\n" "${txt[@]}"
}



#
# Slideshow to present the slides from BODY array
# Argument: $1 should be 1-7 and give the correct slides
#
function slideshow
{
    # shellcheck source=slides/1.bash
    source "slides/$1.bash"

    local current=0
    local max=${#BODY[@]}

    while true; do
        theslide="${BODY[$current]}"
        x=$(( _LINES / 6 ))
        y=$(( ( _COLUMNS )  / 6 ))
        tput clear
        tput cup $x

        echo "$theslide" | PREFIX=$(tput cr; tput cuf $y) awk '{print ENVIRON["PREFIX"] $0}'
        read -rsn1 key

        if [[ "$key" = "a" ]]; then
            (( current = (current - 1)%max ))
        elif [[ "$key" = "s" ]]; then
            (( current = (current + 1)%max ))
        elif [[ "$key" = "q" ]]; then
            exit 0
        fi
    done
}



while (( $# ))
do
    case "$1" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            echo "$SCRIPT version $VERSION"
            exit 0
        ;;

        [1-7])
            slideshow "$1"
            exit 0
        ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;
    esac
done
