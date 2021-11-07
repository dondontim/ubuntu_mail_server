#!/bin/bash
#
#
is_debug_on && printf "\n\n[%s]\n\n" "${BASH_SOURCE[0]}"

# Install MariaDB Database Server
sudo apt install mariadb-server mariadb-client
#systemctl status mariadb
# To enable MariaDB to automatically start at boot time, run
#sudo systemctl enable mariadb

#######################################
# Main wrapper function for all of the functions from this file.
#######################################
function main_2() {
  
}