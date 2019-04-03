#!/usr/bin/env bash

# Sample slide-file for kmom01
# Available colors can be found in colors.bash
# Name the slides 1.bash, 2.bash, 3.bash etc to utilize automation

# shellcheck source=../colors.bash
source "colors.bash"

# shellcheck disable=SC2034
BODY=(
# slide 1
"${magenta}KURSEN VLINUX-v1${reset}

Kenneth Lewenhagen, dbwebb
"



# Slide 2
"${yellow}Agenda${reset}

* Kursinnehåll
* Allmänt om Linux
* SSH
* ${ul_on}${cyan}https://dbwebb.se${reset}
"



# Slide 3
"${yellow}Kursinnehåll${reset}

* 01: Linux som server
* 02: Apache Virtual Hosts
* 03: Script med Bash
"

# Slide 4
"${cyan}Kodexempel${reset}



-------------------------------------------
#!/usr/bin/env bash

declare -a myarray
myarray[0]='item'
-------------------------------------------
"
)
