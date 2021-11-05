#!/bin/bash
#
#
is_debug_on && printf "\n\n[%s]\n\n" "${BASH_SOURCE[0]}"


#######################################
# Change system hostname.
# Globals: 
#   HOSTNAME_TO_SET
#   UTILS_DIR
#   HOSTNAME_TO_SET
#######################################
function change_hostname() {
  local CURRENT_HOSTNAME
  # Get current hostname
  CURRENT_HOSTNAME="$(hostname)"

  # Change hostname in /etc/hostname
  hostnamectl set-hostname "$HOSTNAME_TO_SET"

  # You still need to update /etc/hosts file
  source "${UTILS_DIR}/manage-etc-hosts.sh"
  removehost "$CURRENT_HOSTNAME"
  addhost "$HOSTNAME_TO_SET"
}


#######################################
# Installing Postfix.
# Globals: 
#   POSTFIX_main_mailer_type
#   POSTFIX_mailname
#######################################
function installing_postfix() {
  if running_interactively; then
    :
  else
    if is_debug_on; then
      printf "\n[debconf-set-selections]\n\n"
      # Taken from: https://serverfault.com/a/144010
      debconf-set-selections -v <<< "postfix postfix/main_mailer_type string ${POSTFIX_main_mailer_type}"
      debconf-set-selections -v <<< "postfix postfix/mailname string $POSTFIX_mailname"
    else
      debconf-set-selections <<< "postfix postfix/main_mailer_type string ${POSTFIX_main_mailer_type}"
      debconf-set-selections <<< "postfix postfix/mailname string $POSTFIX_mailname"
    fi
  fi
  apt_install postfix
}


#######################################
# Change Attachment and mailbox Size Limit in Postfix config.
# Globals: 
#   POSTFIX_message_size_limit_in_bytes
#   POSTFIX_mailbox_size_limit_in_bytes
#######################################
function set_postfix_size_limits() {
  ### How To change Attachment Size Limit (default: 10MB)

  # message_size_limit
  postconf -e message_size_limit="$POSTFIX_message_size_limit_in_bytes"

  # mailbox_size_limit
  postconf -e mailbox_size_limit="$POSTFIX_mailbox_size_limit_in_bytes"
}


#######################################
# Setting the Postfix Hostname.
# Globals: 
#   HOSTNAME_TO_SET
#   POSTFIX_MAIN_CF
#######################################
function set_postfix_hostname() {
  # By default, Postfix SMTP server uses the OS’s hostname. 
  # However, the OS hostname might change, so it’s a good practice to set
  # the hostname directly in Postfix configuration file.

  grep -Eq "^myhostname ?= ?${HOSTNAME_TO_SET}" "$POSTFIX_MAIN_CF" || {
    postconf -e myhostname="$HOSTNAME_TO_SET"
  }
}


#######################################
# Creating Email Alias in $ETC_ALIASES.
# Globals: 
#   POSTMASTER_ALIAS_USERNAME
#   ETC_ALIASES
#######################################
function create_email_alias() {
  # The left-hand  side is the alias name. 
  # The right-hand side is the final destination of the email message.
  # So emails for postmaster@your-domain.com will be delivered to root@your-domain.com. 
  # The postmaster email address is required by RFC 2142.

  # Normally we don’t use the root email address. 
  # Instead, the postmaster can use a normal login name to access emails. 
  # So you can add the following line. Replace username with your real username.
  
  echo "root: $POSTMASTER_ALIAS_USERNAME" >> "$ETC_ALIASES"
  # This way, emails for postmaster@your-domain.com will be delivered to username@your-domain.com.

  ### Then rebuild the alias database
  newaliases
}


#######################################
# Using IPv4 Only.
# Globals: 
#   SET_IPV4_ONLY
#######################################
function set_ipv4_only() {
  if [ "$SET_IPV4_ONLY" = true ]; then
    # If your mail server doesn’t have a public IPv6 address, it’s better 
    # to disable IPv6 in Postfix to prevent unnecessary IPv6 connections.
    postconf -e inet_protocols='ipv4'
  fi
}



#######################################
# Main wrapper function for all of the functions from this file.
#######################################
function main_1() {

  # TODO(tim): apt_update_and_upgrade is enough cuz autoclean should be in initial_server_setup.sh
  apt_update_and_upgrade_and_autoremove_and_autoclean

  change_hostname

  ### Set Up DNS Records for Your Mail Server
  # Do it manually in here!

  # TODO(tim): after this whole tutorial create email aliases before installing postfix
  # In original it was after set_postfix_hostname before set_ipv4_only
  create_email_alias

  installing_postfix

  # Open TCP Port 25 (inbound) in Firewall
  ufw allow 25/tcp

  set_postfix_size_limits
  set_postfix_hostname


  set_ipv4_only

  ### Restart Postfix for the changes to take effect.
  systemctl restart postfix

  ### Upgrading Postfix

  # If you run sudo apt update, then sudo apt upgrade, 
  # and the system is going to upgrade Postfix, you might be prompted to choose
  # a configuration type for Postfix again. This time you should choose:
  # 'No configuration' to leave your current configuration file untouched.
  debconf-set-selections <<< "postfix postfix/main_mailer_type string No configuration"
  apt_update_and_upgrade
}