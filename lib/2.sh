#!/bin/bash
#
#
is_debug_on && printf "\n\n[%s]\n\n" "${BASH_SOURCE[0]}"



# Open email related ports in firewall.
ufw allow 80,443,587,465,143,993/tcp
# If you use POP3 to fetch emails (I personally don’t), then also open port 110 and 995.
ufw allow 110,995/tcp










#######################################
# Main wrapper function for all of the functions from this file.
#######################################
function main_2() {

}