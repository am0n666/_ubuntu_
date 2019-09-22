#!/bin/bash
################################################################################
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Install all Ubuntu/Debian program automatically
#
################################################################################

# get sever os name: ubuntu or debian
server_name=`lsb_release -ds | awk -F ' ' '{printf $1}' | tr A-Z a-z`
version_name=`lsb_release -cs`

usage() {
  echo 'Usage: '$0' [--help|-h] [-i|--install] [upx|mycli|pgcli|tmux|docker|git-extras|postgresql|hhvm|elasticsearch|ajenti|redis|ruby|perl|s4cmd|optipng|timezone|jenkins|mosh|gearman|nginx|nginx_mainline|percona|mariadb|clean-kernel|server|desktop|initial|all]'
  exit 1;
}

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
    output "Update all packages and install aptitude tool command."
    # update package and upgrade Ubuntu
    apt-get -y update && apt-get -y upgrade
    # terminal-based package manager (terminal interface only)
    apt-get -y install software-properties-common
}
