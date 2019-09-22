#!/bin/bash
################################################################################
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Install all Ubuntu/Debian program automatically
#
################################################################################

COLOR_REST='\e[0m'
COLOR_GREEN='\e[0;32m'
COLOR_RED='\e[0;31m'
output() {
  echo -e "${COLOR_GREEN}$1${COLOR_REST}"
}

displayErr() {
    echo
    echo -e "${COLOR_RED}$1${COLOR_REST}"
    echo
    exit 1;
}

initial() {
    output "Installing tools"
    # update package and upgrade Ubuntu
    mkdir /etc/bash_completion.d
    apt-get -y update && apt-get -y upgrade
    # terminal-based package manager (terminal interface only)
	
	PACKAGES=""
	PACKAGES+=" bash-completion"
	PACKAGES+=" dialog"
	PACKAGES+=" pv"
	PACKAGES+=" libreadline-dev"
	PACKAGES+=" figlet"
	PACKAGES+=" nano"
	PACKAGES+=" mc"
	PACKAGES+=" git"
	apt-get install -y $PACKAGES
}
initial
