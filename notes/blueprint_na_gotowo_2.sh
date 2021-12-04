#!/bin/bash
#
# 


################################# TODOS ########################################

# TODO(tim): processing dovecot-core takes ton of time probably because it fails and retries (set sieve closer to dovecot or before)

# TODO(tim): TEST spamassasin user_prefs

# NOTE: to change welcome email edit: /etc/postfixadmin/config.inc.php
# or 'mailbox_postcreation_script' in same file

# TODO(tim): you can cat a source file and > to dest file keeping its permissions and ownership

################################################################################




set -e

#git clone https://github.com/dondontim/backup_nr4.git


# ALREADY DONE: 
#!!! for restarts

# starting with this: cp "${LOCATION_OF_MY_FILES}
# and this are same so TODO(tim) combine it somehow
#replace_with_my_file 


LOCATION_OF_MY_FILES='/root/backup_nr4'

# GLOBALS:
#   LOCATION_OF_MY_FILES
function replace_with_my_file() {
  local ORIGINAL_TO_REPLACE \
        MY_REPLACEMENT

  ORIGINAL_TO_REPLACE="$1"

  # Replace / with % to get 
  MY_REPLACEMENT="$(echo "$ORIGINAL_TO_REPLACE" | sed 's;/;%;g')"

  MY_REPLACEMENT="${LOCATION_OF_MY_FILES}/${MY_REPLACEMENT}"

  if [[ ! -f "$MY_REPLACEMENT" ]]; then 
    echo "MY_REPLACEMENT: $MY_REPLACEMENT file dont exists"
    return 1
  else
    echo "MY_REPLACEMENT: $MY_REPLACEMENT file exists"
  fi
  

  if [[ -f "$ORIGINAL_TO_REPLACE" ]]; then 
    echo "ORIGINAL_TO_REPLACE: $ORIGINAL_TO_REPLACE file exists"
    rm "$ORIGINAL_TO_REPLACE"
    mv "$MY_REPLACEMENT" "$ORIGINAL_TO_REPLACE"
    cp "$ORIGINAL_TO_REPLACE" "$MY_REPLACEMENT"
  else
    echo "[!] Error no such file ORIGINAL_TO_REPLACE: $ORIGINAL_TO_REPLACE"
    return 1
  fi  
}

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function press_anything_to_continue() {
  read -n 1 -s -r -p "Press any key to continue"
  # -n defines the required character count to stop reading
  # -s hides the user's input
  # -r causes the string to be interpreted "raw" (without considering backslash escapes)
  echo ""
}





################################################################################
# 1
################################################################################
NEW_HOSTNAME='mail.justeuro.eu'

POSTFIX_main_mailer_type='Internet Site'
POSTFIX_mailname="justeuro.eu"
#alias L='less'
##########################################

# update && upgrade is enough I think
apt-get update -y && sudo apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y

# Set /etc/hostname too
hostnamectl set-hostname "$NEW_HOSTNAME"
replace_with_my_file "/etc/hosts"
replace_with_my_file "/etc/aliases"
newaliases


# Install postfix
#printf "\n[debconf-set-selections]\n\n"
# Taken from: https://serverfault.com/a/144010
debconf-set-selections -v <<< "postfix postfix/main_mailer_type string $POSTFIX_main_mailer_type"
debconf-set-selections -v <<< "postfix postfix/mailname string $POSTFIX_mailname"


apt-get install -y postfix


# Open TCP Port 25 (inbound) in Firewall
ufw allow 25/tcp


### Restart Postfix for the changes to take effect.
systemctl restart postfix

### Upgrading Postfix

# If you run sudo apt update, then sudo apt upgrade, 
# and the system is going to upgrade Postfix, you might be prompted to choose
# a configuration type for Postfix again. This time you should choose:
# 'No configuration' to leave your current configuration file untouched.
debconf-set-selections <<< "postfix postfix/main_mailer_type string No configuration"
apt-get update -y && sudo apt-get upgrade -y 





################################################################################
# 2
################################################################################


ufw allow 80,443,587,465,143,993/tcp

# POP: If you use POP3 to fetch emails (For Gmail), then also open port 110 and 995.
ufw allow 110,995/tcp


# cp all_config_postfix

replace_with_my_file "/etc/postfix/main.cf"
replace_with_my_file "/etc/postfix/master.cf"

#!!! systemctl restart postfix



# install dovecot
apt-get install -y dovecot-core dovecot-imapd 

# POP: If you use POP3 to fetch emails, then also install the dovecot-pop3d package.
apt-get install -y dovecot-pop3d

# cp all_config_dovecot

replace_with_my_file "/etc/dovecot/dovecot.conf"
replace_with_my_file "/etc/dovecot/conf.d/10-mail.conf"
replace_with_my_file "/etc/dovecot/conf.d/10-master.conf"
replace_with_my_file "/etc/dovecot/conf.d/10-auth.conf"
replace_with_my_file "/etc/dovecot/conf.d/10-ssl.conf"
replace_with_my_file "/etc/dovecot/conf.d/15-mailboxes.conf"

#!!! systemctl restart dovecot





################################################################################
# 3
################################################################################

### Install PostfixAdmin on Ubuntu 20.04 Server

apt-get install -y dbconfig-no-thanks
apt-get install -y postfixadmin
apt-get remove -y dbconfig-no-thanks

dpkg-reconfigure postfixadmin


# YES
# Choose db (if you have mysql and other installed)
# Unix socket.
# default
# (enter) postfixadmin
# (enter)
# (password 2wice (should not contain the # ) : 71yGyny0.{N@vYx
# choose the default database administrative user. 

# PostfixAdmin
replace_with_my_file "/etc/dbconfig-common/postfixadmin.conf"
replace_with_my_file "/etc/postfixadmin/dbconfig.inc.php"

mkdir /usr/share/postfixadmin/templates_c

# If your system can’t find the setfacl command, you need to install the acl package.
command_exists 'setfacl' || apt-get install -y acl
# Give www-data user read, write and execute permissions on this dir
setfacl -R -m u:www-data:rwx /usr/share/postfixadmin/templates_c/

# Create Nginx Config File for PostfixAdmin
# ALREADY DONE: cp /etc/nginx/conf.d/postfixadmin.conf 
nginx -t && systemctl reload nginx

# Now you should be able to see the PostfixAdmin web-based install wizard
# at http://postfixadmin.example.com/setup.php

# Install Required and Recommended PHP Modules
apt-get install -y php7.4-fpm php7.4-imap php7.4-mbstring php7.4-mysql php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-bz2 php7.4-intl php7.4-gmp


# Enabling HTTPS
# ALREADY DONE: certbot --nginx --non-interactive --agree-tos --hsts --staple-ocsp --redirect --cert-name "postfixadmin.justeuro.eu" --no-eff-email -m "krystatymoteusz@gmail.com"  -d "postfixadmin.justeuro.eu" 
# --hsts:        Add the Strict-Transport-Security header to every HTTP response. Forcing browser to always use TLS for the domain. Defends against SSL/TLS Stripping.
# --staple-ocsp: Enables OCSP Stapling. A valid OCSP response is stapled to the certificate that the server offers during TLS.


# Use Strong Password Scheme in PostfixAdmin and Dovecot
cp "${LOCATION_OF_MY_FILES}/%usr%share%postfixadmin%config.local.php" /usr/share/postfixadmin/config.local.php 
ln -s /usr/share/postfixadmin/config.local.php /etc/postfixadmin/config.local.php

# Add the web server to the dovecot group.
sudo gpasswd -a www-data dovecot

#!!! systemctl restart dovecot


#!!! todo NOW OPEN AND CREATE PASSWORD FOR POSTFIX ADMIN
# http://postfixadmin.example.com/setup.php

# After creating the password hash, you need to open the 
# /usr/share/postfixadmin/config.local.php 
# file and add the setup password hash at the end of the file



## Configure Postfix to Use MySQL/MariaDB Database

# First, we need to add MySQL map support for Postfix by installing the postfix-mysql package.
apt-get install -y postfix-mysql

mkdir /etc/postfix/sql/
# all these files should contain password set in postfixadmin installation wizard
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%sql%/mysql_virtual_domains_maps.cf" /etc/postfix/sql/mysql_virtual_domains_maps.cf
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%sql%/mysql_virtual_mailbox_maps.cf" /etc/postfix/sql/mysql_virtual_mailbox_maps.cf
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%sql%/mysql_virtual_alias_domain_mailbox_maps.cf" /etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%sql%/mysql_virtual_alias_maps.cf" /etc/postfix/sql/mysql_virtual_alias_maps.cf
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%sql%/mysql_virtual_alias_domain_maps.cf" /etc/postfix/sql/mysql_virtual_alias_domain_maps.cf
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%sql%/mysql_virtual_alias_domain_catchall_maps.cf" /etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf


# Since the database passwords are stored in plain text so they should be readable
# only by user postfix and root, which is done by executing the following two commands.
chmod 0640 /etc/postfix/sql/*
setfacl -R -m u:postfix:rx /etc/postfix/sql/


# create a user named vmail with ID 2000 and a group with ID 2000. (as set in /etc/postfix/main.cf)
adduser vmail --system --group --uid 2000 --disabled-login --no-create-home

# Create the mail base location.
mkdir /var/vmail/

# Make vmail as the owner.
chown vmail:vmail /var/vmail/ -R


## Configure Dovecot to Use MySQL/MariaDB Database

# We also need to configure the Dovecot IMAP server to query user information from the database.
apt-get install -y dovecot-mysql

# password set in postfixadmin installation wizard
replace_with_my_file "/etc/dovecot/dovecot-sql.conf.ext"


#!!! systemctl restart dovecot


## Add Domain and Mailboxes in PostfixAdmin 

# Login to postfix and do stuff from: Step 12: Add Domain and Mailboxes in PostfixAdmin
# 1. Domain List > New Domain
# 2. Virtual List > Add Mailbox


#################### ADDITIONALY #########################
### ADDITIONALY
#################### ADDITIONALY #########################

replace_with_my_file "/etc/postfixadmin/config.inc.php"

echo ""
echo "visit: https://postfixadmin.justeuro.eu/setup.php end enter there credentials"
echo "IF YOU ARE DONE:"
#press_anything_to_continue
echo ""
# TODO(tim): jak zrekonstrulujesz baze danych tutaj to nie musisz 
# Chyba tege robic manualnie
# mysqldump -u username -p database_name > data-dump.sql

# TODO(tim): try with:
# Re-create postfixadmin database
mysql -u root postfixadmin < "${LOCATION_OF_MY_FILES}/sql/postfixadmin.sql"
# NOTE: After you created postfixadmin db virtual mailboxes werent created so you cannot run 


### Remove file setup.php
# Create backup of /usr/share/postfixadmin/public/setup.php
mv "/usr/share/postfixadmin/public/setup.php" "/usr/share/postfixadmin/public/setup.php.bak"

# TODO(tim): DOMYSLNIE REMOVE IT
#rm "/usr/share/postfixadmin/public/setup.php"

### REMEMBER TO MAKE BACKUP OF A POSTFIXADMIN DATABASE


################################################################################
# 4 
################################################################################



### Configuring SPF Policy Agent

# We need to tell our Postfix SMTP server to check for SPF record of incoming emails. 
# This help with detecting forged incoming emails.
apt-get install -y postfix-policyd-spf-python


### Setting up DKIM

apt-get install -y opendkim opendkim-tools

# Then add postfix user to opendkim group.
gpasswd -a postfix opendkim

replace_with_my_file "/etc/opendkim.conf"



# Below 3 lines are enough for all above section so commented
mv "${LOCATION_OF_MY_FILES}/%etc%opendkim%" /etc/opendkim
# Change the owner from root to opendkim and make sure only opendkim user
# can read and write to the keys directory.
chown -R opendkim:opendkim /etc/opendkim
# Group and others - (minus) read and write
chmod go-rw /etc/opendkim/keys
# And change the permission, so only the opendkim user has read and write access to the file.
chmod 600 /etc/opendkim/keys/justeuro.eu/default.private


### Test DKIM Key

# Run on Ubuntu server to test your key.
opendkim-testkey -d justeuro.eu -s default -vvv


### Connect Postfix to OpenDKIM

# Create a directory to hold the OpenDKIM socket file and allow only 
# opendkim user and postfix group to access it.
mkdir /var/spool/postfix/opendkim
chown opendkim:postfix /var/spool/postfix/opendkim

replace_with_my_file "/etc/default/opendkim"

systemctl restart opendkim
#!!! systemctl restart opendkim postfix



### COMMENTED!
############################################################
# At the end of this tutorial there is a note with explaination!!!

# This resolves problem:
# Failed to start OpenDKIM DomainKeys Identified Mail (DKIM) Milter.
# exit code 46
#mkdir /var/spool/postfix/opendkim
#chown -R opendkim:opendkim /var/spool/postfix/opendkim
############################################################




################################################################################
### 7 Effective Tips to Stop Your Emails Being Marked as Spam
# https://www.linuxbabe.com/mail-server/how-to-stop-your-emails-being-marked-as-spam
################################################################################

### DO IT!!!!
# You can also tell the recipient to:
# * check spam folder and 
# * add your email address to contact list.


# Include your contact information and your mailing address at the bottom of the email message.

# Personalize the email message as much as possible. For example, 
# include the recipient’s first name in the email body and segment your list
#  based on the subscriber’s gender, age, interest, country, etc.

# Conform to CAN-SPAM Act

################################################################################
# How to Set Up Postfix SMTP Relay on Ubuntu with Sendinblue (optional)
# https://www.linuxbabe.com/mail-server/postfix-smtp-relay-ubuntu-sendinblue
################################################################################



### SMTP Rate Limiting

apt-get install -y policyd-rate-limit
replace_with_my_file "/etc/policyd-rate-limit.yaml"

systemctl restart policyd-rate-limit
#!!! systemctl restart postfix policyd-rate-limit




################################################################################
# 7 Effective Tips for Blocking Email Spam with Postfix SMTP Server
# https://www.linuxbabe.com/mail-server/block-email-spam-postfix
################################################################################



### BE SURE TO CHECK IT ONCE AGAIN


cp "${LOCATION_OF_MY_FILES}/%etc%postfix%helo_access" /etc/postfix/helo_access


# Then run the following command to create the /etc/postfix/helo_access.db file.
postmap /etc/postfix/helo_access


# Enable Greylisting in Postfix
apt-get install -y postgrey

# Once it’s installed, start it with systemctl.
systemctl start postgrey
# Enable auto-start at boot time.
systemctl enable postgrey

# On Debian and Ubuntu, it listens on TCP port 10023 on localhost (both IPv4 and IPv6).
# TEST: sudo netstat -lnpt | grep postgrey


# Note: You can also see postgrey logs with this command: 
# TEST: sudo journalctl -u postgrey






cp "${LOCATION_OF_MY_FILES}/%etc%postfix%rbl_override" /etc/postfix/rbl_override
# Hash the blacklist
# the file must be converted to a database that Postfix can read. 
# This must be done every time rbl_override is updated.
postmap /etc/postfix/rbl_override



apt-get install -y mutt



apt-get install -y fail2ban




################################################################################
# 9.
################################################################################

apt-get install -y postfix-pcre

# header_checks
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%header_checks" /etc/postfix/header_checks
# Kluci sie z custom_header in main.cf dlatego custom_header is deleted
postmap /etc/postfix/header_checks 

# body_checks
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%body_checks" /etc/postfix/body_checks
postmap /etc/postfix/body_checks


# Install SpamAssassin
apt-get install -y spamassassin spamc

systemctl enable spamassassin
systemctl start spamassassin

# Integrate SpamAssassin with Postfix SMTP Server as a Milter
apt-get install -y spamass-milter



replace_with_my_file "/etc/default/spamass-milter"




systemctl restart spamass-milter
#!!! systemctl restart postfix spamass-milter




replace_with_my_file "/etc/default/spamassassin"
replace_with_my_file "/etc/spamassassin/local.cf" # local config  

systemctl restart spamassassin
#!!! systemctl restart spamassassin



# Move Spam into the Junk Folder

# This package installs two configuration files under 
# /etc/dovecot/conf.d/ directory: 90-sieve.conf and 90-sieve-extprograms.conf.
apt-get install -y dovecot-sieve


# ADD ALL SIEVE files here
mkdir /var/mail/sieve.d

# All sieve scripts that have to be executed before users scripts should be here
mkdir /var/mail/sieve.d/sieve_before
# BECAUSE OF BELOW ERROR WHEN TEST: # doveadm log errors
# Dec 02 17:44:50 Error: lmtp(tim@justeuro.eu)<238063><qRjmLAL4qGHvoQMAsxeaUA>: sieve: binary save: failed to create temporary file: open(/var/mail/sieve.d/sieve_before/JUSTEURO_INTERNAL.svbin.) failed: Permission denied (euid=2000(vmail) egid=2000(vmail) missing +w perm: /var/mail/sieve.d/sieve_before, dir owned by 0:8 mode=0755)
# Dec 02 17:44:50 Error: lmtp(tim@justeuro.eu)<238063><qRjmLAL4qGHvoQMAsxeaUA>: sieve: The LDA Sieve plugin does not have permission to save global Sieve script binaries; global Sieve scripts like `/var/mail/sieve.d/sieve_before/JUSTEURO_INTERNAL.sieve' need to be pre-compiled using the sievec tool
# Set write permission on vmail:
chown vmail /var/mail/sieve.d/
chmod 755 /var/mail/sieve.d/
chown vmail /var/mail/sieve.d/sieve_before
chmod 755 /var/mail/sieve.d/sieve_before
# OR
chown -R vmail:mail /var/mail/sieve.d/


cp "${LOCATION_OF_MY_FILES}/%etc%dovecot%conf.d%15-lda.conf" /etc/dovecot/conf.d/15-lda.conf
cp "${LOCATION_OF_MY_FILES}/%etc%dovecot%conf.d%20-lmtp.conf" /etc/dovecot/conf.d/20-lmtp.conf

# In: /etc/dovecot/conf.d/90-sieve.conf are specified sieve files to be executed
cp "${LOCATION_OF_MY_FILES}/%etc%dovecot%conf.d%90-sieve.conf" /etc/dovecot/conf.d/90-sieve.conf

# Logging file setting dovecot logs to /var/log/dovecot.log
cp "${LOCATION_OF_MY_FILES}/%etc%dovecot%conf.d%10-logging.conf" /etc/dovecot/conf.d/10-logging.conf


cp "${LOCATION_OF_MY_FILES}/%var%mail%sieve.d%sieve_before%SpamToJunk.sieve" /var/mail/sieve.d/sieve_before/SpamToJunk.sieve
cp "${LOCATION_OF_MY_FILES}/%var%mail%sieve.d%sieve_before%JUSTEURO_INTERNAL.sieve" /var/mail/sieve.d/sieve_before/JUSTEURO_INTERNAL.sieve


#cp /etc/dovecot/conf.d/15-lda.conf
#cp /etc/dovecot/conf.d/20-lmtp.conf
#cp /etc/dovecot/conf.d/90-sieve.conf
#cp /var/mail/SpamToJunk.sieve
#cp /var/mail/JUSTEURO_INTERNAL.sieve

# We can compile this script, so it will run faster.
sievec /var/mail/sieve.d/sieve_before/SpamToJunk.sieve
sievec /var/mail/sieve.d/sieve_before/JUSTEURO_INTERNAL.sieve


# Now there is a binary file saved as /var/mail/sieve.d/sieve_before/SpamToJunk.svbin. 
# Finally, restart dovecot for the changes to take effect.
#!!! systemctl restart dovecot
systemctl restart dovecot

# user specific
#!!! TODO(tim): cp /var/vmail/justeuro.eu/admin/spamassassin/user_pref

# Deleting Email Headers For Outgoing Emails
cp "${LOCATION_OF_MY_FILES}/%etc%postfix%smtp_header_checks" /etc/postfix/smtp_header_checks
#cp /etc/postfix/smtp_header_checks
postmap /etc/postfix/smtp_header_checks
systemctl reload postfix


################################################################################
# 10.
################################################################################


apt-get install -y amavisd-new 

# Enable auto-start at boot time.
systemctl enable amavis

# Check logs of amavis
#journalctl -eu amavis 

# Viruses are commonly spread as attachments to email messages. 
# Install the following packages for Amavis to extract and scan archive files 
# in email messages such as .7z, .cab, .doc, .exe, .iso, .jar, and .rar files.
apt-get install -y arj bzip2 cabextract cpio rpm2cpio file gzip lhasa nomarch pax p7zip-full unzip zip lrzip lzip liblz4-tool lzop unrar-free
# unrar-free is replacement for original: rar unrar packages names


# NOTE: that if your server doesn’t use a fully-qualified domain name (FQDN) 
# as the hostname, Amavis might fail to start. And the OS hostname might change,
# so it’s recommended to set a valid hostname directly in the Amavis configuration file.
# IN: /etc/amavis/conf.d/05-node_id
replace_with_my_file "/etc/amavis/conf.d/05-node_id"
systemctl restart amavis
#!!! systemctl restart amavis




### Integrate Amavis with ClamAV

apt-get install -y clamav clamav-daemon
# There will be two systemd services installed by ClamAV:
#   clamav-daemon.service: the Clam AntiVirus userspace daemon
#   clamav-freshclam.service: the ClamAV virus database updater


#!!! Look line above

# Check journal/log
#journalctl -eu clamav-freshclam


# it will fail main.cvd and daily.cvd (ClamAV Virus Database) were not downloaded yet when it starts. 
#systemctl status clamav-daemon # TODO(tim): THIS FAILED dont run it in production script!!!
systemctl restart clamav-daemon # so restart it
#!!! systemctl restart clamav-daemon

### BTW: If your mail server doesn’t have enough RAM left, the service will fail.
### just this: systemctl status clamav-daemon.service uses on my server 1.1GB!!! 

# The clamav-freshclam.service will check ClamAV virus database updates once per hour.

# Now we need to turn on virus-checking in Amavis.
replace_with_my_file "/etc/amavis/conf.d/15-content_filter_mode"


# There are lots of antivirus scanners in the /etc/amavis/conf.d/15-av_scanners file.
# ClamAV is the default. Amavis will call ClamAV via the /var/run/clamav/clamd.ctl Unix socket. 
# We need to add user clamav to the amavis group.
adduser clamav amavis
systemctl restart amavis clamav-daemon
#!!! systemctl restart amavis clamav-daemon

# Test: if received email have:
# ex. header: X-Virus-Scanned: Debian amavisd-new at justeuro.eu




################################################################################
### ClamAV Automatic Shutdown
################################################################################
#
# I found that the clamav-daemon service has a tendency to stop without clear reason
# even when there’s enough RAM. This will delay emails for 1 minute. 
# We can configure it to automatically restart if it stops via the systemd service unit. 

# Manual
function clamav_auto_restart_manual() {
  # Copy the original service unit file to the /etc/systemd/system/ directory.
  cp /lib/systemd/system/clamav-daemon.service /etc/systemd/system/clamav-daemon.service
  # Then edit the service unit file.
  vim /etc/systemd/system/clamav-daemon.service
  # Add the following two lines in the [service] section.
  Restart=always
  RestartSec=3

  # Like this:
  [Service]
  ExecStart=/usr/sbin/clamd --foreground=true
  # Reload the database
  ExecReload=/bin/kill -USR2 $MAINPID
  StandardOutput=syslog
  Restart=always
  RestartSec=3

  # Save and close the file. Then reload systemd and restart clamav-daemon.service.
  systemctl daemon-reload
  systemctl restart clamav-daemon
}


# Same as above but done by copying already edited file
# NOTE: take care that /etc/systemd/system/clamav-daemon.service differs from
# original: /lib/systemd/system/clamav-daemon.service only with above two lines
cp "${LOCATION_OF_MY_FILES}/%etc%systemd%system%clamav-daemon.service" /etc/systemd/system/clamav-daemon.service
systemctl daemon-reload
systemctl restart clamav-daemon










### Use A Dedicated Port for Email Submissions
# NOTE: Custom settings should be added between the use strict; and 1; line.

replace_with_my_file "/etc/amavis/conf.d/50-user"
systemctl restart amavis
#!!! systemctl restart amavis


# If you have OpenDKIM running on your mail server, then you can disable DKIM verification in Amavis.
replace_with_my_file "/etc/amavis/conf.d/21-ubuntu_defaults"
systemctl restart amavis
#!!! systemctl restart amavis


### Improve amavis performance

# After running you should see that there are 4 Amavis processes
#amavisd-nanny #already done in main.cf and master.cf




################################################################################
# 12. (i do not do 11 (VPN))
################################################################################

cp "${LOCATION_OF_MY_FILES}/%etc%postfix%postscreen_access.cidr" /etc/postfix/postscreen_access.cidr
#cp /etc/postfix/postscreen_access.cidr
systemctl restart postfix
#!!! systemctl restart postfix

# Note: Postscreen listens on port 25 only, 
# so authenticated users from port 587 or 465 won’t be affected by Postscreen.

### Step 2: Pregreet Test
# 
# There is a pregreet test in Postscreen to detect spam. 
# As you may already know, in SMTP protocol, the receiving SMTP server should always
# declare its hostname before the sending SMTP server does so. 
# Some spammers violate this rule and declare their hostnames before the receiving SMTP server does.


# The sender will try the first mail server (with priority 0). 
# If mail.yourdomain.com rejects email by greylisting, 
# then the sender would immediately try the second mail server (with priority 5).
# Instead of waiting to retry to same mx record (if would be only one)


## Using Postwhite
cd /usr/local/bin/
apt-get install -y git
# Clone the SPF-Tools and Postwhite Github repository.
git clone https://github.com/spf-tools/spf-tools.git
git clone https://github.com/stevejenkins/postwhite.git

# Copy the postwhite.conf file to /etc/.
cp /usr/local/bin/postwhite/postwhite.conf /etc/

# Run Postwhite.
/usr/local/bin/postwhite/postwhite
# The whitelist will be save as /etc/postfix/postscreen_spf_whitelist.cidr.



################################################################################
# SETTING UP LOCAL DNS RESOLVER
################################################################################

#!!! HERE IS A LOT

########### Unbound ##############
#
# Ref: https://www.linuxbabe.com/ubuntu/set-up-unbound-dns-resolver-on-ubuntu-20-04-server

###### Helper functions

# Returns 0 if service is active and non 0 if not
function is_service_running() {
  systemctl is-active --quiet "$@"
}
###### END Helper functions



### Install Unbound DNS Resolver on Ubuntu 20.04
apt-get update -y
apt-get install -y unbound

# If it’s not running, then start it with:
systemctl start unbound
# And enable auto-start at boot time:
systemctl enable unbound



# If you installed BIND9 resolver before, 
# then you need to run the following command to stop and disable it, 
# so Unbound can listen to the UDP port 53. 
# By default, Unbound listens on 127.0.0.1:53 and [::1]:53
systemctl disable named --now


replace_with_my_file "/etc/unbound/unbound.conf"

# By default, Ubuntu runs the systemd-resolved stub resolver which listens on 127.0.0.53:53. 
# You need to stop it, so unbound can bind to 0.0.0.0:53.
systemctl disable systemd-resolved --now

systemctl restart unbound

# If you have UFW firewall running on the Unbound server, 
# then you need to open port 53 to allow LAN clients to send DNS queries.

# This will open TCP and UDP port 53 to the private network (if you have VPN setup) 10.0.0.0/8.
#ufw allow in from 10.0.0.0/8 to any port 53
ufw allow in from 190.92.134.0/24 to any port 53


### Setting the Default DNS Resolver on Ubuntu 20.04 Server

# We need to make Ubuntu 20.04 server use 127.0.0.1 as DNS resolver, 
# so unbound will answer DNS queries. The unbound package on Ubuntu ships with
# a systemd service unbound-resolvconf.service that is supposed to 
# help us accomplish this. However, I found it won’t work.
#
# Instead, create a custom unbound-resolvconf.service
cp "${LOCATION_OF_MY_FILES}/%etc%systemd%system%unbound-resolvconf.service" /etc/systemd/system/unbound-resolvconf.service
#cp /etc/systemd/system/unbound-resolvconf.service


# Reload systemd
systemctl daemon-reload
# Make sure your system has the resolvconf binary.
apt-get install -y openresolv
# Next, restart this service.
systemctl restart unbound-resolvconf.service



if is_service_running "unbound"; then
  if grep -q 'nameserver 127.0.0.1' /etc/resolv.conf; then
    echo 'success setting up unbound as local DNS resolver'
  else
    echo 'fail setting up unbound as local DNS resolver'
  fi
else 
  echo '[error]: unbound not running'
fi

###################### END UNBOUND LOCAL DNS RESOLVER

apt-get install -y dnsutils
# TEST: Check server that was queried if it is 127.0.0.1:53 all is good


################################################################################
# Additional commit - before webmail TODO(tim): delete this section
################################################################################

#cp /etc/mailname
echo "$POSTFIX_mailname" > /etc/mailname


### Configure the Sieve Message Filter

############### TODO(tim): You need to configure it before roundcube because it is required by 
# my files dovecot.conf

# You can create folders in Roundcube webmail and then create rules to filter
# email messages into different folders. In order to do this, you need to install
# the ManageSieve server with the following command.
apt-get install -y dovecot-sieve dovecot-managesieved

# By default, Postfix uses its builtin local delivery agent (LDA) to move inbound emails
# to the message store (inbox, sent, trash, Junk, etc). 
# We can configure it to use Dovecot to deliver emails, via the LMTP protocol, 
# which is a simplified version of SMTP. LMTP allows for a highly scalable 
# and reliable mail system and it is required if you want to use 
# the sieve plugin to filter inbound messages to different folders.
#
# Install the Dovecot LMTP Server.
apt-get install -y dovecot-lmtpd






systemctl daemon-reload
systemctl restart opendkim postfix dovecot policyd-rate-limit spamass-milter spamassassin amavis clamav-freshclam clamav-daemon unbound unbound-resolvconf
systemctl status opendkim postfix dovecot policyd-rate-limit spamass-milter spamassassin amavis clamav-freshclam clamav-daemon unbound unbound-resolvconf # | less


#### NOTE: roundcube filters are stored in: 
## /var/vmail/domain.com/user/sieve/roundcube.sieve
#cp /var/vmail/justeuro.eu/tim/sieve/roundcube.sieve # not required (roundcube filters)

### Removing Sensitive Information from Email Headers

# By default, Roundcube will add a User-Agent email header, 
# indicating that you are using Roundcube webmail and the version number. 
# You can tell Postfix to ignore it so recipient can not see it.
# 
# this is to file to strip headers: /etc/postfix/smtp_header_checks
# after editing always do: postmap /etc/postfix/smtp_header_checks
# and in main.cf  smtp_header_checks  directive regulates it 
# systemctl reload postfix



# Pflogsumm is a great tool to create a summary of Postfix logs. Install it on Ubuntu with:
apt-get install -y pflogsumm









exit 0



# Find out enabled services
systemctl list-unit-files | grep enabled
# Find out currently running services
systemctl | grep running.

# OR

# Not sure which one is good

systemctl list-unit-files --state=enabled
systemctl list-unit-files --state=failed

# To list all the systemd service which are in state=active and sub=running
systemctl list-units --type=service --state=running
# To list all the systemd serice which are in state=active and sub either running or exited
systemctl list-units --type=service --state=active


# To enable and start at the same time: 
systemctl enable --now ...



# TODO(tim): enable all below services
opendkim postfix dovecot policyd-rate-limit spamass-milter spamassassin amavis clamav-freshclam clamav-daemon unbound unbound-resolvconf



######## ADDITIONAL FILES THAT SHOULD BE COPIED

### TODO(tim): Check what this files should or have permissions
# AS i saw by running it manually

# This file exists but cp overwites it: /etc/postgrey/whitelist_clients
-rw-r--r-- 1 root root
cp "${LOCATION_OF_MY_FILES}/%etc%postgrey%whitelist_clients" "/etc/postgrey/whitelist_clients"
# exists too
-rw-r--r-- 1 root root
cp "${LOCATION_OF_MY_FILES}/%etc%default%postgrey" "/etc/default/postgrey"
# doesnt exists (TODO(tim): Replace with your client IP)
-rw-r--r--   1 root root as all files in /etc/fail2ban/
cp "${LOCATION_OF_MY_FILES}/%etc%fail2ban%jail.local" "/etc/fail2ban/jail.local"
# doesnt exists
-rw-r--r--   1 root root as all files in /etc/fail2ban/filter.d/
cp "${LOCATION_OF_MY_FILES}/%etc%fail2ban%filter.d%postfix-flood-attack.conf" "/etc/fail2ban/filter.d/postfix-flood-attack.conf"


cp "${LOCATION_OF_MY_FILES}/%var%spool%cron%crontabs%root" "/var/spool/cron/crontabs/root"
# -rw------- 1 root crontab
chmod 600 "/var/spool/cron/crontabs/root" 
chown root:crontab "/var/spool/cron/crontabs/root"







#### Set some cronjob scripts

# Set correct permissions on all of this
mv "${LOCATION_OF_MY_FILES}/%root%scripts%" /root/scripts
chmod 700 /root/scripts -R



# TODO(tim):
# Check the all files
# Set path and shell in crontab
# set correct permissions on backup_nr4 to copy already good files


################################################################################
### Setting up Roundcube webmail
# https://www.linuxbabe.com/ubuntu/install-roundcube-webmail-ubuntu-20-04-apache-nginx
################################################################################




### Download Roundcube Webmail on Ubuntu 20.04
# You can always check the current version: https://roundcube.net/download/
ROUNDCUBE_VERSION="1.4.12"
ROUNDCUBE_ROOT_LOCATION="/var/www/justeuro.eu/mail" # separate subdomain: /var/www/mail.justeuro.eu/

wget "https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz"

# Extract the tarball, move the newly created folder to web root (/var/www/) and rename it as roundcube at the same time.
tar xvf "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz"
mv roundcubemail-${ROUNDCUBE_VERSION}/* "$ROUNDCUBE_ROOT_LOCATION" 

### Install Dependencies

# Install required PHP extensions.
apt-get install -y php-net-ldap2 php-net-ldap3 php-imagick php7.4-common php7.4-gd php7.4-imap php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl php7.4-gmp
# Install Composer, which is a dependency manager for PHP.
apt-get install -y composer
# Change into the roundcube directory.
cd "$ROUNDCUBE_ROOT_LOCATION"
# Use Composer to install all needed dependencies (3rd party libraries) for Roundcube Webmail.

# It will throw a warning but it must be run as root
composer install --no-dev
## NOTE(tim): to run above command i did change open_basedir in php.ini
## TODO(tim): Set for fpm also .ini - php cli is cli and fpm is server processing files apache/nginx

# If you see the nothing to install or update message, then all dependencies are installed.

# Make the web server user (www-data) as the owner of the temp and logs directory so that web server can write to these two directories.
chown www-data:www-data temp/ logs/ -R


### Create a MariaDB Database and User for Roundcube

# Execute SQL file creating database, user and granting priviledges
#mysql -u root < roundcube_setup.sql
# OR sth like
#
# Then create a new database for Roundcube using the following command. 
# This tutorial name it roundcube, you can use whatever name you like for the database.
mysql -u root -e "CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
# Next, create a new database user on localhost using the following command. 
# Again, this tutorial name it roundcubeuser, you can use whatever name you like. 
# Replace password with your preferred password.
mysql -u root -e "CREATE USER roundcubeuser@localhost IDENTIFIED BY 'XBV(pjku?6iB0';"
# Then grant all permission of the new database to the new user so later on Roundcube webmail can write to the database.
mysql -u root -e "GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;"
# Flush the privileges table for the changes to take effect.
mysql -u root -e "flush privileges;"


# Import the initial tables to roundcube database.
mysql roundcube < "${ROUNDCUBE_ROOT_LOCATION}/SQL/mysql.initial.sql"



### Nginx Config File for Roundcube

# ALREADY DONE: cp /etc/nginx/sites-available/roundcube.justeuro.eu
# ALREADY DONE: ln -s /etc/nginx/sites-available/roundcube.justeuro.eu /etc/nginx/sites-enabled/

# ALREADY DONE: #certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email krystatymoteusz@gmail.com -d roundcube.justeuro.eu

### Finish the Installation in Web Browser
# https://mail.justeuro.eu/installer/






# This was generated by installer and have to be put here
# More configuration options: https://github.com/roundcube/roundcubemail/wiki/Configuration

cp "${LOCATION_OF_MY_FILES}/%var%www%justeuro.eu%mail%config%config.inc.php" "${ROUNDCUBE_ROOT_LOCATION}/config/config.inc.php"

# Copy mime.types file for error: Mimetype to file extension mapping:  NOT OK 
cp "${LOCATION_OF_MY_FILES}/%var%www%justeuro.eu%mail%config%mime.types" "${ROUNDCUBE_ROOT_LOCATION}/config/mime.types"


# After completing the installation and the final tests please 
# remove the whole installer folder from the document root of the webserver 
# or make sure that 'enable_installer' option in config.inc.php is disabled.
#
# These files may expose sensitive configuration data like server passwords
# and encryption keys to the public. 
# Make sure you cannot access this installer from your browser.
rm "${ROUNDCUBE_ROOT_LOCATION}/installer/" -r







### Configure the Password Plugin in Roundcube

# Roundcube includes a password plugin that allows users to change 
# their passwords from the webmail interface.

# However, we need to configure this plugin before it will work. 
# Run the following command to copy the distributed password plugin config file to a new file.
cp "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php.dist" "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php"

# Put my already configured file to destination (TODO(tim): you can delete above line)
mv "${LOCATION_OF_MY_FILES}/%var%www%justeuro.eu%mail%plugins%password%config.inc.php" "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php"

# Since this file contains the database password, 
# we should allow only the www-data user to read and write to this file.
chown www-data:www-data "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php"
chmod 600 "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php"


# Use client_max_body_size and set it to the desired value in your server blocks. Nginx will directly drop the handling of the request if the request body exceeds the size specified in this directive. Please note that you won't get any POST submitted in that case.

# There are 3 plugins in Roundcube for attachments/file upload:
#
# * database_attachments
# * filesystem_attachments
# * redundant_attachments
#
# Roundcube can use only one plugin for attachments/file uploads. 
# I found that the 'database_attachment' plugin can be error_prone and cause you trouble. 


### For problems check: /var/log/nginx/justeuro.eu/mail.err









cat <<EOF
# NOTE: After you created postfixadmin db virtual mailboxes werent created so you need to run below line manually:
# User specific spamassasin rules and points
cp "${LOCATION_OF_MY_FILES}/%var%vmail%justeuro.eu%admin%spamassassin%user_pref" "/var/vmail/justeuro.eu/admin/spamassassin/user_pref"
EOF






exit 0







### How to Upgrade Roundcube

# Download the Roundcube latest version to your home directory.
cd ~
wget https://github.com/roundcube/roundcubemail/releases/download/1.5.0/roundcubemail-1.5.0-complete.tar.gz
# Extract the archive.
tar xvf roundcubemail-1.5.0-complete.tar.gz
# Change the owner to www-data.
chown www-data:www-data roundcubemail-1.5.0/ -R
# Then run the install script.
roundcubemail-1.5.0/bin/installto.sh "${ROUNDCUBE_ROOT_LOCATION}/"
# Once it’s done, log into Roundcube webmail and click the 
# About button to check what version of Rouncube you are using.




################################################################################
# FOLLOWING TODOS 
################################################################################


# Somebodys roundcube plugins
# https://notes.sagredo.eu/en/qmail-notes-185/roundcube-plugins-35.html






# Dovecot Automatic Restart
mkdir -p /etc/systemd/system/dovecot.service.d/
cp "${LOCATION_OF_MY_FILES}/%etc%systemd%system%dovecot.service.d%restart.conf" "/etc/systemd/system/dovecot.service.d/restart.conf"

# Reload systemd
systemctl daemon-reload
# TEST(tim): sudo pkill dovecot && sleep 6 && systemctl status dovecot # Check if restarted automaticaly



################################################################################
# How to Install Self-Hosted Passbolt Password Manager
# https://www.linuxbabe.com/ubuntu/install-passbolt-password-manager-ubuntu-20-04

#### 
# NOT FINISHED ( ALTERNATIVE: BITWARDEN https://bitwarden.com/help/article/install-on-premise-linux/ )
####
################################################################################


# If you go to the official website to download Passbolt, 
# you are required to enter your name and email address. 
# If that’s not what you like, then download the latest stable version from
#  Github by executing the following commands on your server.
apt install git
cd /var/www/
git clone https://github.com/passbolt/passbolt_api.git

# The files will be saved in passbolt_api directory. We rename it to passbolt.
mv passbolt_api passbolt
# Then make the web server user (www-data) as the owner of this directory.
chown -R www-data:www-data /var/www/passbolt
# Run the following command to install PHP modules required or recommended by Passbolt
apt install php-imagick php-gnupg php7.4-common php7.4-mysql php7.4-fpm php7.4-ldap php7.4-gd php7.4-imap php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl php7.4-gmp php7.4-xsl


# Change directory.
cd /var/www/passbolt/
# Install Composer – the PHP dependency manager.
apt install composer
# Create cache directory for Composer.
mkdir /var/www/.composer
# Make www-data as the owner.
chown -R www-data:www-data /var/www/.composer
# Use Composer to install dependencies.
sudo -u www-data composer install --no-dev
# If it asks you to set folder permissions, choose Y OR ENTER CUZ IT DEFAULTS TO TRUE


### Create a MariaDB Database and User for Passbolt

##### Change: passbolt, passboltuser, password
#
# Next, create a new database for Passbolt using the following command. 
# This tutorial names it passbolt, you can use whatever name you like for the database. 
# We also specify utf8mb4 as the character set to support non-Latin characters and emojis.
CREATE DATABASE passbolt DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
# The following command will create a database user and password, 
# and at the same time grant all permission of the new database to the new user 
# so later on Passbolt can write to the database.
GRANT ALL ON passbolt.* TO 'passboltuser'@'localhost' IDENTIFIED BY 'password';
# Flush privileges table and exit MariaDB console.
FLUSH PRIVILEGES;

mysql -u root -e "CREATE DATABASE passbolt DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -e "GRANT ALL ON passbolt.* TO 'passboltuser'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "FLUSH PRIVILEGES;"


### Generate OpenPGP Key

# If you are using a VPS, it’s recommended to install the haveged package
# to generate enough entropy.
apt install haveged
# The haveged.service will automatically start after installation. 
systemctl status haveged
# Then run the following command to generate a new key pair.
gpg --gen-key
# You will be asked to enter your name and email address. 
# If you are asked to set a passphrase, skip it by pressing the Tab key and selecting OK, 
# because the php-gnupg module doesn’t support using passphrase at the moment.


Copy the private key to the passbolt configuration location. Replace you@example.com with the email address when generating the PGP key.

gpg --armor --export-secret-keys you@example.com | sudo tee /var/www/passbolt/config/gpg/serverkey_private.asc > /dev/null
And copy the public key as well.

gpg --armor --export you@example.com | sudo tee /var/www/passbolt/config/gpg/serverkey.asc > /dev/null
# Initialize the www-data user’s keyring.
sudo su -s /bin/bash -c "gpg --list-keys" www-data




# TODO(tim): following steps
#
# How to Install Mailtrain v2
# https://www.linuxbabe.com/ubuntu/install-mailtrain-v2-ubuntu-20-04




# Troubleshooting Problems with Postfix, Dovecot, and MySQL
# https://www.linode.com/docs/guides/troubleshooting-problems-with-postfix-dovecot-and-mysql/