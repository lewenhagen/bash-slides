#!/usr/bin/env bash

# shellcheck disable=SC2034
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

bold=$(tput bold)
dim=$(tput dim)
ul_on=$(tput smul)
ul_off=$(tput rmul)
standout_bold_on=$(tput smso)
standout_bold_off=$(tput rmso)

cols=$(tput cols)
rows=$(tput lines)

reset=$(tput sgr0)
