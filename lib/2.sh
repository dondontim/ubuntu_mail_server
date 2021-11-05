#!/bin/bash
#
#
is_debug_on && printf "\n\n[%s]\n\n" "${BASH_SOURCE[0]}"





### Open email related ports in firewall.
function open_email_related_ports_in_firewall() {
  ufw allow 80,443,587,465,143,993/tcp
  # If you use POP3 to fetch emails (I personally don’t), then also open port 110 and 995.
  using_pop3_to_fetch_emails && ufw allow 110,995/tcp
}





### Enable Submission Service in Postfix
function enable_submission_service_in_postfix() {
  # By default the submission section is commented out.
  # So leave it as is and append below to $POSTFIX_MASTER_CF
  cat <<EOF >> "$POSTFIX_MASTER_CF"
  submission inet n       -       y       -       -       smtpd
    -o syslog_name=postfix/submission
    -o smtpd_tls_security_level=encrypt
    -o smtpd_tls_wrappermode=no
    -o smtpd_sasl_auth_enable=yes
    -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
    -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject
    -o smtpd_sasl_type=dovecot
    -o smtpd_sasl_path=private/auth
EOF
  # The above configuration enables the submission daemon of Postfix and requires TLS encryption. 
  # So later on our desktop email client can connect to the submission daemon in TLS encryption. 
  # The submission daemon listens on TCP port 587. 
  # STARTTLS is used to encrypt communications between email client and the submission daemon.

  # Microsoft Outlook mail client only supports submission over port 465. 
  # If you are going to use Microsoft Outlook, then you also need to enable
  # submission service on port 465 by replacing the following lines in the file:
  #  -o syslog_name=postfix/smtps
  #  -o smtpd_tls_wrappermode=yes

  # Hint: The SMTP protocol is used when an email client submits emails to an SMTP server.
}








### Specify the location of TLS certificate and private key in $POSTFIX_MAIN_CF
function postfix_set_tls_parameters() {
  # TODO(tim): set path to lets encrypt

  # Comment out
  # postconf -# smtp_tls_CApath
  # postconf -X smtp_tls_CApath
  postconf -# smtp_tls_CApath

  #Enable TLS Encryption when Postfix receives incoming emails
  postconf -e smtpd_tls_cert_file='/etc/letsencrypt/live/mail.your-domain.com/fullchain.pem'
  postconf -e smtpd_tls_key_file='/etc/letsencrypt/live/mail.your-domain.com/privkey.pem'
  postconf -e smtpd_tls_security_level='may'
  postconf -e smtpd_tls_loglevel='1'
  postconf -e smtpd_tls_session_cache_database='btree:${data_directory}/smtpd_scache'

  #Enable TLS Encryption when Postfix sends outgoing emails
  postconf -e smtp_tls_security_level='may'
  postconf -e smtp_tls_loglevel='1'
  postconf -e smtp_tls_session_cache_database='btree:${data_directory}/smtp_scache'

  #Enforce TLSv1.3 or TLSv1.2
  postconf -e smtpd_tls_mandatory_protocols='!SSLv2, !SSLv3, !TLSv1, !TLSv1.1' # Have to be single quotes because of "!" sign
  postconf -e smtpd_tls_protocols='!SSLv2, !SSLv3, !TLSv1, !TLSv1.1'
  postconf -e smtp_tls_mandatory_protocols='!SSLv2, !SSLv3, !TLSv1, !TLSv1.1'
  postconf -e smtp_tls_protocols='!SSLv2, !SSLv3, !TLSv1, !TLSv1.1'



  systemctl restart postfix

  # If you run the following command, 
  # you will see Postfix is now listening on port 587 and 465.
  #sudo ss -lnpt | grep master
}






### Installing Dovecot IMAP Server
function install_dovecot() {
  # Install Dovecot core package and the IMAP daemon package on Ubuntu server.
  apt_install dovecot-core dovecot-imapd

  # If you use POP3 to fetch emails, then also install the dovecot-pop3d package.
  using_pop3_to_fetch_emails && apt_install dovecot-pop3d
}






### Enabling IMAP/POP3 Protocol
function enable_IMAP/POP3_protocol() {
  if using_pop3_to_fetch_emails; then
    # Enable IMAP AND POP3 protocol.
    APPEND_LINE='protocols = imap pop3'
  else
    # Enable IMAP protocol.
    APPEND_LINE='protocols = imap'
  fi

  # Make backup and append line after match
  sed -i".bak" "/# Enable installed protocols/a $APPEND_LINE" "$DOVECOT_CONF"
}









### Configuring Mailbox Location
function configure_mailbox_location() {
  # By default, Postfix and Dovecot use mbox format to store emails. 
  # Each user’s emails are stored in a single file /var/mail/username. 
  # You can run the following command to find the mail spool directory.

  # However, nowadays it’s almost always you want to use the Maildir format to store email messages

  # The default entry to replace
  DEFAULT_ENTRY='mail_location = mbox:~/mail:INBOX=/var/mail/%u'
  DEFAULT_ENTRY_ESCAPED="$(escape_all_forward_slashes "$DEFAULT_ENTRY")"

  # Make Dovecot use the Maildir format
  # Email messages will be stored under the Maildir directory under each user’s home directory.
  SUBSTITUTE_ENTRY='mail_location = maildir:~/Maildir'

  # Replace
  sed -i".bak" "s/$DEFAULT_ENTRY_ESCAPED/$SUBSTITUTE_ENTRY/" "$DOVECOT_MAILBOX_LOCATIONS_AND_NAMESPACES_CONF_FILE"

  # Add dovecot to the mail group so that Dovecot can read the INBOX.
  adduser dovecot mail
}




### Using Dovecot to Deliver Email to Message Store
function ____() {
  # Although we configured Dovecot to store emails in Maildir format, by default, 
  # Postfix uses its built-in local delivery agent (LDA) to move inbound emails 
  # to the message store (inbox, sent, trash, Junk, etc), and it will be saved in mbox format.

  # We need to configure Postfix to pass incoming emails to Dovecot, via the LMTP protocol, 
  # which is a simplified version of SMTP, so incoming emails will saved in Maildir format by Dovecot. 
  # LMTP allows for a highly scalable and reliable mail system. 
  # It also allows us to use the sieve plugin to filter inbound messages to different folders.

  # Install the Dovecot LMTP Server.
  apt_install dovecot-lmtpd

  # Edit the Dovecot main configuration file.
  $DOVECOT_CONF
  # Add lmtp to the supported protocols.
  protocols = imap lmtp



Replace this

'  unix_listener lmtp {
    #mode = 0666
  }'

With this

'  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }'


}
















#######################################
# Main wrapper function for all of the functions from this file.
#######################################
function main_2() {

}


apt-get dist-upgrade -y