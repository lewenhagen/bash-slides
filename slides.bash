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


trap clear_md INT

function clear_md
{
    if [[ -f "1.md" ]]; then
        echo ">>> Clearing md-files..."
        rm -- *.md
        echo ">>> I'm done! Bye!"
    else
        echo ">>> No files to remove..."
    fi
    exit 0
}

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



function parseandprint
{
    echo "$1" | sed -r "
    s/(###)([a-Z].*$)/$(tput setaf 5)\2$(tput sgr0)/g
    s/(##)([a-Z].*$)/$(tput setaf 6)\2$(tput sgr0)/g
    s/(#)([a-Z].*$)/$(tput setaf 3)\2$(tput sgr0)/g
    s/(http.*)/$(tput setaf 6)\1$(tput sgr0)/g
    "
}



function parsemdless
{
    mdless less -w 50 "$1"
}



#
# Slideshow to present the slides from BODY array
# Argument: $1 should be 1-7 and give the correct slides
#
function slideshow
{
    local textfile
    local current=0
    local logo="logo.txt"
    local x y max

    declare -a slides

    x=$(( _LINES / 6 ))
    y=$(( ( _COLUMNS )  / 6 ))

    IFS="%"
    textfile=$(< "slides/$1.md")
    if ! [[ -z "$2" ]]; then
        count=0
        for slide in $textfile; do
            (( count++ ))
            echo "$slide" > "$count.md"
            slides+=($count)
        done
    else
        for slide in $textfile; do
            slides+=($slide)
        done
    fi

    max=${#slides[@]}

    while true; do
        tput clear
        tput sgr0
        echo -n "$(tput setaf 2)Slide: $(( current+1 ))/$max"
        echo "$(< $logo)" | PREFIX=$(tput cr; tput cuf $((_COLUMNS-20))) awk '{print ENVIRON["PREFIX"] $0}'
        tput cup $x
        if ! [[ -z "$2" ]]; then parsemdless "${slides[$current]}.md" | PREFIX=$(tput cr; tput cuf $y) awk '{print ENVIRON["PREFIX"] $0}'
        else parseandprint "${slides[$current]}" | PREFIX=$(tput cr; tput cuf $y) awk '{print ENVIRON["PREFIX"] $0}'
        fi

        read -rsn1 key

        case "$key" in
            "a")
                (( current-- ))
                [[ $current -lt 0 ]] && current=$(( max-1 ))
            ;;
            "s")
                (( current = (current+1)%max ))
            ;;
            "q")
                clear_md
            ;;
        esac
    done
}



function main
{
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

            pretty)
                shift
                slideshow "$1" mdless
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

}

main "$@"
