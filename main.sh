#!/bin/bash
#
#

#sudo apt-get update -y && sudo apt-get upgrade -y && apt-get install -y git curl && git clone https://github.com/dondontim/setup.git && cd setup && bash initial_server_setup.sh
#cd && git clone https://github.com/dondontim/ubuntu_mail_server && cd ubuntu_mail_server
#git clone https://github.com/dondontim/ubuntu_mail_server && cd ubuntu_mail_server

# The set -e option instructs bash to immediately exit if any command
# has a non-zero exit status. By default, bash does not do this
set -e 

# TODO(tim): add realpath
# https://stackoverflow.com/questions/2564634/convert-absolute-path-into-relative-path-given-a-current-directory-using-bash
LIB_DIR='lib'
UTILS_DIR='utils'

source "${UTILS_DIR}/_top-most-functions.sh"


script_requires_root_to_run



DEBUG=true # @boolean lowercase
LOG_FILE="/root/ubuntu_mail_server.log"

# An apex domain - domain that does not contain a subdomain, such as example.com
# Apex domains are also known as base, bare, naked, root apex, or zone apex domains.
# An apex domain is configured with an A , ALIAS , or ANAME record through your DNS provider.
APEX_DOMAIN='justeuro.eu'

# DEFAULT IP FOR HOSTNAME
# IP="127.0.0.1"
command_exists 'dig' || apt_install dnsutils
IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"




HOSTNAME_TO_SET="eu-central-1.${APEX_DOMAIN}"


INTERACTIVE=false

# If set to false below variables have to be set as they wont be read from input
if [ "$INTERACTIVE" = false ]; then
  POSTFIX_main_mailer_type='Internet Site'
  POSTFIX_mailname="$APEX_DOMAIN"

  ## Size limit in here refers to:
  #   * emails originating from your own mail server and 
  #   * emails coming to your mail server.
  #
  ## Setting some value here to "0" means no size limit (unlimited)
  #
  ## How to determine a reasonable attachment size limit?
  # Ref: https://serverfault.com/a/27596
  # Gmail   attachment size limit: 25 MB
  # Outlook attachment size limit: 20 MB

  # message_size_limit with headers 
  POSTFIX_message_size_limit_in_bytes='20971520' # 20MB
  
  # NOTE: the 'message_size_limit' should not be larger than the 'mailbox_size_limit'

  POSTFIX_mailbox_size_limit_in_bytes='0'

  ## Messages with a BODY over 100 – 150 KB trigger spam filters. 
  # So, the common recommendation is to keep email body size between 15 KB and 100 KB.
  # Gmail clips emails that are larger than 102 KB. It supplies readers a link
  # if they want to view the complete email, 
  # but there's no guarantee your recipient will be willing to click it.
fi




POSTFIX_MAIN_CF='/etc/postfix/main.cf'
POSTFIX_MASTER_CF='/etc/postfix/master.cf'

SET_IPV4_ONLY=true




# PATH TO YOUR HOSTS FILE
ETC_HOSTS='/etc/hosts'
# PATH TO YOUR ALIASES FILE
ETC_ALIASES='/etc/aliases'

POSTMASTER_ALIAS_USERNAME='tim'



# ${BASH_SOURCE[0]}
# if file2 (sourced) is in a different directory then:
#  $(basename ${BASH_SOURCE[0]}) seems to work better to get the filename only. 
# To get the directory only use "$( cd "$(dirname "$BASH_SOURCE")" ; pwd -P )"


# BEFORE YOU SHOULD INSTALL WEB SERVER CUZ WE WILL NEED TLS CERTIFICATE AND THIS WAY IT IS EASIER




# postconf -# smtp_tls_CApath # Comment out an entry
# postconf -X smtp_tls_CApath # Remove      an entry


################################################################################


# 1. Setting up a basic Postfix SMTP server (MTA)
#    Ref: https://www.linuxbabe.com/mail-server/setup-basic-postfix-mail-sever-ubuntu

source "${LIB_DIR}/1.sh"
main_1

# You can send plain text emails and read incoming emails using the command line.

# If you Append $APEX_DOMAIN to 'mydestination = ' you will be able to send emails 
# from inside server e.g. from root@justeuro.eu to tim@justeuro.eu



# 2. Install Dovecot IMAP server on Ubuntu & Enable TLS Encryption
#    Ref: https://www.linuxbabe.com/mail-server/secure-email-server-ubuntu-postfix-dovecot

USING_POP3_TO_FETCH_EMAILS=true
DOVECOT_CONF='/etc/dovecot/dovecot.conf'

# Mailbox location config file
DOVECOT_MAILBOX_LOCATIONS_AND_NAMESPACES_CONF_FILE='/etc/dovecot/conf.d/10-mail.conf'

#source "${LIB_DIR}/2.sh"
#main_2

## Securing Email Server Traffic with TLS Certificate




# 3. PostfixAdmin – Create Virtual Mailboxes on Ubuntu 20.04 Mail Server
#    Ref: https://www.linuxbabe.com/mail-server/postfixadmin-create-virtual-mailboxes-ubuntu-20-04

# . 
#    Ref: 

# . 
#    Ref: 

# . 
#    Ref: 

# . 
#    Ref: 

# . 
#    Ref: 

# . 
#    Ref: 

# . 
#    Ref: 

# . 
#    Ref: 