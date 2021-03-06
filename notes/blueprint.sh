# You can list all available mailbox users with:
sudo doveadm user '*'

# Check for open ports
nmap mail.your-domain.com

function nnn() {
  ln "$1" /root/all_files/ 
}

################################################################################
################################################################################

################################################################################
# 1 (Using made shitty script)
################################################################################

sudo apt-get update -y && sudo apt-get upgrade -y && apt-get install -y git curl && git clone https://github.com/dondontim/setup.git && cd setup && bash initial_server_setup.sh
bash after_initial.sh && cd

git clone https://github.com/dondontim/ubuntu_mail_server && cd ubuntu_mail_server 
bash main.sh # 1.sh


################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################



################################################################################
# 1
################################################################################


POSTFIX_main_mailer_type='Internet Site'
POSTFIX_mailname="justeuro.eu"
##########################################



apt-get update -y && sudo apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y

cp /etc/hosts
cp /etc/aliases 
newaliases


# Install postfix
printf "\n[debconf-set-selections]\n\n"
# Taken from: https://serverfault.com/a/144010
debconf-set-selections -v <<< "postfix postfix/main_mailer_type string $POSTFIX_main_mailer_type"
debconf-set-selections -v <<< "postfix postfix/mailname string $POSTFIX_mailname"


apt_install postfix


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
apt_update_and_upgrade





################################################################################
# 2
################################################################################


ufw allow 80,443,587,465,143,993/tcp

# POP: If you use POP3 to fetch emails (For Gmail), then also open port 110 and 995.
ufw allow 110,995/tcp


# copy all_config_postfix
cp all_config_postfix
systemctl restart postfix

# install dovecot
apt install dovecot-core dovecot-imapd

# POP: If you use POP3 to fetch emails, then also install the dovecot-pop3d package.
sudo apt install dovecot-pop3d

cp all_config_dovecot
systemctl restart dovecot

# Dovecot Automatic Restart

mkdir -p /etc/systemd/system/dovecot.service.d/
cp /etc/systemd/system/dovecot.service.d/restart.conf
systemctl daemon-reload
# Test: sudo pkill dovecot && sleep 6 && systemctl status dovecot # Check if restarted automaticaly


################################################################################
# 3
################################################################################

### Install PostfixAdmin on Ubuntu 20.04 Server

apt install dbconfig-no-thanks
apt install postfixadmin
apt remove dbconfig-no-thanks

dpkg-reconfigure postfixadmin


# YES
# Choose db (if you have mysql and other installed)
# Unix socket.
# default
# (enter) postfixadmin
# (enter)
# (password 2wice (should not contain the # )
# choose the default database administrative user. 

# PostfixAdmin
cp /etc/dbconfig-common/postfixadmin.conf
cp /etc/postfixadmin/dbconfig.inc.php

mkdir /usr/share/postfixadmin/templates_c

# If your system can???t find the setfacl command, you need to install the acl package.
command_exists 'setfacl' || apt install acl
# Give www-data user read, write and execute permissions on this dir
setfacl -R -m u:www-data:rwx /usr/share/postfixadmin/templates_c/

# Create Nginx Config File for PostfixAdmin
cp /etc/nginx/conf.d/postfixadmin.conf
nginx -t && systemctl reload nginx

# Now you should be able to see the PostfixAdmin web-based install wizard
# at http://postfixadmin.example.com/setup.php

# Install Required and Recommended PHP Modules
apt install php7.4-fpm php7.4-imap php7.4-mbstring php7.4-mysql php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-bz2 php7.4-intl php7.4-gmp


# Enabling HTTPS
certbot --nginx --non-interactive --agree-tos --hsts --staple-ocsp --redirect --cert-name "postfixadmin.justeuro.eu" --no-eff-email -m "krystatymoteusz@gmail.com"  -d "postfixadmin.justeuro.eu" 
# --hsts:        Add the Strict-Transport-Security header to every HTTP response. Forcing browser to always use TLS for the domain. Defends against SSL/TLS Stripping.
# --staple-ocsp: Enables OCSP Stapling. A valid OCSP response is stapled to the certificate that the server offers during TLS.


# Use Strong Password Scheme in PostfixAdmin and Dovecot
cp /usr/share/postfixadmin/config.local.php 
ln -s /usr/share/postfixadmin/config.local.php /etc/postfixadmin/config.local.php

# Add the web server to the dovecot group.
sudo gpasswd -a www-data dovecot

systemctl restart dovecot

# NOW OPEN AND CREATE PASSWORD FOR POSTFIX ADMIN
# http://postfixadmin.example.com/setup.php

# After creating the password hash, you need to open the 
# /usr/share/postfixadmin/config.local.php 
# file and add the setup password hash at the end of the file




## Configure Postfix to Use MySQL/MariaDB Database

# First, we need to add MySQL map support for Postfix by installing the postfix-mysql package.
apt install postfix-mysql

mkdir /etc/postfix/sql/
# all these files should contain password set in postfixadmin installation wizard
cp /etc/postfix/sql/mysql_virtual_domains_maps.cf
cp /etc/postfix/sql/mysql_virtual_mailbox_maps.cf
cp /etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf
cp /etc/postfix/sql/mysql_virtual_alias_maps.cf
cp /etc/postfix/sql/mysql_virtual_alias_domain_maps.cf
cp /etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf

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
apt install dovecot-mysql

# password set in postfixadmin installation wizard
cp /etc/dovecot/dovecot-sql.conf.ext


systemctl restart dovecot


## Add Domain and Mailboxes in PostfixAdmin 

# Login to postfix and do stuff from: Step 12: Add Domain and Mailboxes in PostfixAdmin
# 1. Domain List > New Domain
# 2. Virtual List > Add Mailbox




################################################################################
# 4
################################################################################



### Configuring SPF Policy Agent

# We need to tell our Postfix SMTP server to check for SPF record of incoming emails. 
# This help with detecting forged incoming emails.
apt install postfix-policyd-spf-python


### Setting up DKIM

apt install opendkim opendkim-tools

# Then add postfix user to opendkim group.
gpasswd -a postfix opendkim #aoeuaoeu

cp /etc/opendkim.conf


### Create Signing Table, Key Table and Trusted Hosts File

# Create a directory structure for OpenDKIM
mkdir /etc/opendkim
mkdir /etc/opendkim/keys
# Change the owner from root to opendkim and make sure only opendkim user
# can read and write to the keys directory.
chown -R opendkim:opendkim /etc/opendkim
chmod go-rw /etc/opendkim/keys

cp /etc/opendkim/signing.table
cp /etc/opendkim/key.table
cp /etc/opendkim/trusted.hosts


### Generate Private/Public Keypair

# Create a separate folder for the domain.
mkdir /etc/opendkim/keys/justeuro.eu

# Generate keys using opendkim-genkey tool.
opendkim-genkey -b 2048 -d justeuro.eu -D /etc/opendkim/keys/justeuro.eu -s default -v
# Once executed, the private key will be written to default.private file
# and the public key will be written to default.txt file.

# Make opendkim as the owner of the private key.
chown opendkim:opendkim /etc/opendkim/keys/justeuro.eu/default.private

# And change the permission, so only the opendkim user has read and write access to the file.
chmod 600 /etc/opendkim/keys/justeuro.eu/default.private #aoeuaoeu


### Publish Your Public Key in DNS Records

#cat /etc/opendkim/keys/justeuro.eu/default.txt
# In your DNS manager, create a TXT record, enter default._domainkey in the name field.
# Copy everything in the parentheses and paste it into the value field of the DNS record. 
# You need to delete all double quotes and white spaces in the value field. 



### Test DKIM Key

# Run on Ubuntu server to test your key.
opendkim-testkey -d justeuro.eu -s default -vvv


### Connect Postfix to OpenDKIM

# Create a directory to hold the OpenDKIM socket file and allow only 
# opendkim user and postfix group to access it.
mkdir /var/spool/postfix/opendkim
chown opendkim:postfix /var/spool/postfix/opendkim

cp /etc/default/opendkim

systemctl restart opendkim postfix



############################################################
# At the end of this tutorial there is a note with explaination!!!

# This resolves problem:
# Failed to start OpenDKIM DomainKeys Identified Mail (DKIM) Milter.
# exit code 46
mkdir /var/spool/postfix/opendkim
chown -R opendkim:opendkim /var/spool/postfix/opendkim
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
# include the recipient???s first name in the email body and segment your list
#  based on the subscriber???s gender, age, interest, country, etc.

# Conform to CAN-SPAM Act

################################################################################
# How to Set Up Postfix SMTP Relay on Ubuntu with Sendinblue (optional)
# https://www.linuxbabe.com/mail-server/postfix-smtp-relay-ubuntu-sendinblue
################################################################################



### SMTP Rate Limiting

apt install policyd-rate-limit
cp /etc/policyd-rate-limit.yaml

systemctl restart postfix policyd-rate-limit



################################################################################
# 7 Effective Tips for Blocking Email Spam with Postfix SMTP Server
# https://www.linuxbabe.com/mail-server/block-email-spam-postfix
################################################################################



### BE SURE TO CHECK IT ONCE AGAIN


cp /etc/postfix/helo_access

# Then run the following command to create the /etc/postfix/helo_access.db file.
postmap /etc/postfix/helo_access


# Enable Greylisting in Postfix
apt install postgrey

# Once it???s installed, start it with systemctl.
systemctl start postgrey
# Enable auto-start at boot time.
systemctl enable postgrey

# On Debian and Ubuntu, it listens on TCP port 10023 on localhost (both IPv4 and IPv6).
sudo netstat -lnpt | grep postgrey


# Note: You can also see postgrey logs with this command: 
sudo journalctl -u postgrey






cp /etc/postfix/rbl_override
# Hash the blacklist
# the file must be converted to a database that Postfix can read. 
# This must be done every time rbl_override is updated.
postmap /etc/postfix/rbl_override



apt install mutt



apt install fail2ban




################################################################################
# 9.
################################################################################

apt install postfix-pcre

# header_checks
cp /etc/postfix/header_checks
postmap /etc/postfix/header_checks # Kluci sie z custom_header in main.cf

# body_checks
cp /etc/postfix/body_checks
postmap /etc/postfix/body_checks


# Install SpamAssassin
apt install spamassassin spamc

systemctl enable spamassassin
systemctl start spamassassin

# Integrate SpamAssassin with Postfix SMTP Server as a Milter
apt install spamass-milter



cp /etc/default/spamass-milter




systemctl restart postfix spamass-milter



cp /etc/default/spamassassin
cp /etc/spamassassin/local.cf # local config  

systemctl restart spamassassin


# Move Spam into the Junk Folder

# This package installs two configuration files under 
# /etc/dovecot/conf.d/ directory: 90-sieve.conf and 90-sieve-extprograms.conf.
apt install dovecot-sieve


cp /etc/dovecot/conf.d/15-lda.conf
cp /etc/dovecot/conf.d/20-lmtp.conf
cp /etc/dovecot/conf.d/90-sieve.conf
cp /var/mail/SpamToJunk.sieve

# We can compile this script, so it will run faster.
sievec /var/mail/SpamToJunk.sieve

# Now there is a binary file saved as /var/mail/SpamToJunk.svbin. 
# Finally, restart dovecot for the changes to take effect.
systemctl restart dovecot

# user specific - seems not working for 17 Nov
cp /var/vmail/justeuro.eu/admin/spamassassin/user_pref

# Deleting Email Headers For Outgoing Emails
cp /etc/postfix/smtp_header_checks
postmap /etc/postfix/smtp_header_checks
systemctl reload postfix


################################################################################
# 10.
################################################################################


apt install amavisd-new -y

# Enable auto-start at boot time.
systemctl enable amavis

# Check logs of amavis
journalctl -eu amavis 

# Viruses are commonly spread as attachments to email messages. 
# Install the following packages for Amavis to extract and scan archive files 
# in email messages such as .7z, .cab, .doc, .exe, .iso, .jar, and .rar files.
apt install arj bzip2 cabextract cpio rpm2cpio file gzip lhasa nomarch pax p7zip-full unzip zip lrzip lzip liblz4-tool lzop unrar-free
apt-get install unrar-free # this is replacement for original: rar unrar packages names


# NOTE: that if your server doesn???t use a fully-qualified domain name (FQDN) 
# as the hostname, Amavis might fail to start. And the OS hostname might change,
# so it???s recommended to set a valid hostname directly in the Amavis configuration file.
# IN: /etc/amavis/conf.d/05-node_id
cp /etc/amavis/conf.d/05-node_id
systemctl restart amavis



### Integrate Amavis with ClamAV
apt install clamav clamav-daemon
# There will be two systemd services installed by ClamAV:
#   clamav-daemon.service: the Clam AntiVirus userspace daemon
#   clamav-freshclam.service: the ClamAV virus database updater

# Check journal/log
journalctl -eu clamav-freshclam


# it will fail main.cvd and daily.cvd (ClamAV Virus Database) were not downloaded yet when it starts. 
systemctl status clamav-daemon 
sudo systemctl restart clamav-daemon # so restart it

### BTW: If your mail server doesn???t have enough RAM left, the service will fail.
### just this: systemctl status clamav-daemon.service uses on my server 1.1GB!!! 

# The clamav-freshclam.service will check ClamAV virus database updates once per hour.

# Now we need to turn on virus-checking in Amavis.
cp /etc/amavis/conf.d/15-content_filter_mode


# There are lots of antivirus scanners in the /etc/amavis/conf.d/15-av_scanners file.
# ClamAV is the default. Amavis will call ClamAV via the /var/run/clamav/clamd.ctl Unix socket. 
# We need to add user clamav to the amavis group.
adduser clamav amavis
systemctl restart amavis clamav-daemon

# Test if received email have:
# ex. header: X-Virus-Scanned: Debian amavisd-new at justeuro.eu



### Use A Dedicated Port for Email Submissions
# NOTE: Custom settings should be added between the use strict; and 1; line.

cp /etc/amavis/conf.d/50-user
systemctl restart amavis


# If you have OpenDKIM running on your mail server, then you can disable DKIM verification in Amavis.
cp /etc/amavis/conf.d/21-ubuntu_defaults
systemctl restart amavis


### Improve amavis performance

# After running you should see that there are 4 Amavis processes
#amavisd-nanny #already done in main.cf and master.cf




################################################################################
# 12. (i do not do 11 (VPN))
################################################################################

cp /etc/postfix/postscreen_access.cidr
systemctl restart postfix

# Note: Postscreen listens on port 25 only, 
# so authenticated users from port 587 or 465 won???t be affected by Postscreen.

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
apt install git
# Clone the SPF-Tools and Postwhite Github repository.
git clone https://github.com/spf-tools/spf-tools.git
git clone https://github.com/stevejenkins/postwhite.git

# Copy the postwhite.conf file to /etc/.
sudo cp /usr/local/bin/postwhite/postwhite.conf /etc/

# Run Postwhite.
sudo /usr/local/bin/postwhite/postwhite
# The whitelist will be save as /etc/postfix/postscreen_spf_whitelist.cidr.



################################################################################
# SETTING UP LOCAL DNS RESOLVER
################################################################################


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
apt update
apt install unbound

# If it???s not running, then start it with:
systemctl start unbound
# And enable auto-start at boot time:
systemctl enable unbound



# If you installed BIND9 resolver before, 
# then you need to run the following command to stop and disable it, 
# so Unbound can listen to the UDP port 53. 
# By default, Unbound listens on 127.0.0.1:53 and [::1]:53
systemctl disable named --now


cp /etc/unbound/unbound.conf

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
# help us accomplish this. However, I found it won???t work.
#
# Instead, create a custom unbound-resolvconf.service
cp /etc/systemd/system/unbound-resolvconf.service


# Reload systemd
systemctl daemon-reload
# Make sure your system has the resolvconf binary.
apt-get install openresolv -y
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


################################################################################
# Additional commit - before webmail
################################################################################

cp /etc/mailname

I moved /etc/nginx/conf.d/postfixadmin.conf /etc/nginx/sites-available/postfixadmin.justeuro.eu



################################################################################
### Setting up Roundcube webmail
# https://www.linuxbabe.com/ubuntu/install-roundcube-webmail-ubuntu-20-04-apache-nginx
################################################################################


### Download Roundcube Webmail on Ubuntu 20.04
# You can always check the current version: https://roundcube.net/download/
ROUNDCUBE_VERSION="1.4.12"
ROUNDCUBE_ROOT_LOCATION="/var/www/justeuro.eu/roundcube" # separate subdomain: /var/www/roundcube.justeuro.eu/

wget "https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz"

# Extract the tarball, move the newly created folder to web root (/var/www/) and rename it as roundcube at the same time.
tar xvf "roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz"
mv "roundcubemail-${ROUNDCUBE_VERSION}" "$ROUNDCUBE_ROOT_LOCATION" 

### Install Dependencies

# Install required PHP extensions.
apt install php-net-ldap2 php-net-ldap3 php-imagick php7.4-common php7.4-gd php7.4-imap php7.4-json php7.4-curl php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl php7.4-gmp
# Install Composer, which is a dependency manager for PHP.
apt install composer
# Change into the roundcube directory.
cd "$ROUNDCUBE_ROOT_LOCATION"
# Use Composer to install all needed dependencies (3rd party libraries) for Roundcube Webmail.
composer install --no-dev
## NOTE(tim): to run above command i did change open_basedir in php.ini
## TODO(tim): Set for fpm also .ini - php cli is cli and fpm is server processing files apache/nginx

# If you see the nothing to install or update message, then all dependencies are installed.

# Make the web server user (www-data) as the owner of the temp and logs directory so that web server can write to these two directories.
sudo chown www-data:www-data temp/ logs/ -R


### Create a MariaDB Database and User for Roundcube

# Execute SQL file creating database, user and granting priviledges
mysql -u root < roundcube_setup.sql

# Import the initial tables to roundcube database.
sudo mysql roundcube < "${ROUNDCUBE_ROOT_LOCATION}/SQL/mysql.initial.sql"



### Nginx Config File for Roundcube

cp /etc/nginx/sites-available/roundcube.justeuro.eu
ln -s /etc/nginx/sites-available/roundcube.justeuro.eu /etc/nginx/sites-enabled/

#certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email krystatymoteusz@gmail.com -d roundcube.justeuro.eu

### Finish the Installation in Web Browser
https://roundcube.justeuro.eu/installer/

# This was generated by installer and have to be put here
# More configuration options: https://github.com/roundcube/roundcubemail/wiki/Configuration
cp "${ROUNDCUBE_ROOT_LOCATION}/config/config.inc.php"


# After completing the installation and the final tests please 
# remove the whole installer folder from the document root of the webserver 
# or make sure that 'enable_installer' option in config.inc.php is disabled.
#
# These files may expose sensitive configuration data like server passwords
# and encryption keys to the public. 
# Make sure you cannot access this installer from your browser.
rm "${ROUNDCUBE_ROOT_LOCATION}/installer/" -r


### Configure the Sieve Message Filter

# You can create folders in Roundcube webmail and then create rules to filter
# email messages into different folders. In order to do this, you need to install
# the ManageSieve server with the following command.
apt install dovecot-sieve dovecot-managesieved

# By default, Postfix uses its builtin local delivery agent (LDA) to move inbound emails
#  to the message store (inbox, sent, trash, Junk, etc). 
# We can configure it to use Dovecot to deliver emails, via the LMTP protocol, 
# which is a simplified version of SMTP. LMTP allows for a highly scalable 
# and reliable mail system and it is required if you want to use 
# the sieve plugin to filter inbound messages to different folders.
#
# Install the Dovecot LMTP Server.
apt install dovecot-lmtpd

systemctl restart postfix dovecot # not really needed

## NOTE: roundcube filters are stored in: 
## /var/vmail/domain.com/user/sieve/roundcube.sieve
cp /var/vmail/justeuro.eu/tim/sieve/roundcube.sieve # not required (roundcube filters)

### Removing Sensitive Information from Email Headers

# By default, Roundcube will add a User-Agent email header, 
# indicating that you are using Roundcube webmail and the version number. 
# You can tell Postfix to ignore it so recipient can not see it.
# 
# this is to file to strip headers: /etc/postfix/smtp_header_checks
# after editing always do: postmap /etc/postfix/smtp_header_checks
# and in main.cf  smtp_header_checks  directive regulates it 
# systemctl reload postfix


### Configure the Password Plugin in Roundcube

# Roundcube includes a password plugin that allows users to change 
# their passwords from the webmail interface.

# However, we need to configure this plugin before it will work. 
# Run the following command to copy the distributed password plugin config file to a new file.
cp "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php.dist" "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php"


cp "${ROUNDCUBE_ROOT_LOCATION}/plugins/password/config.inc.php"
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


### For problems check: /var/log/nginx/roundcube.error


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
# Once it???s done, log into Roundcube webmail and click the 
# About button to check what version of Rouncube you are using.




################################################################################
# FOLLOWING TODOS 
################################################################################


TODO remember to change /var/www/justeuro.eu/roundcube to /var/www/roundcube.justeuro.eu
TODO remember to change roundcube.justeuro.eu to mail.justeuro.eu


# Somebodys roundcube plugins
# https://notes.sagredo.eu/en/qmail-notes-185/roundcube-plugins-35.html

TODO repair auto sending for password change in croncab




################################################################################
# How to Install Self-Hosted Passbolt Password Manager
# https://www.linuxbabe.com/ubuntu/install-passbolt-password-manager-ubuntu-20-04

#### 
# NOT FINISHED ( ALTERNATIVE: BITWARDEN https://bitwarden.com/help/article/install-on-premise-linux/ )
####
################################################################################


# If you go to the official website to download Passbolt, 
# you are required to enter your name and email address. 
# If that???s not what you like, then download the latest stable version from
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
# Install Composer ??? the PHP dependency manager.
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

# If you are using a VPS, it???s recommended to install the haveged package
# to generate enough entropy.
apt install haveged
# The haveged.service will automatically start after installation. 
systemctl status haveged
# Then run the following command to generate a new key pair.
gpg --gen-key
# You will be asked to enter your name and email address. 
# If you are asked to set a passphrase, skip it by pressing the Tab key and selecting OK, 
# because the php-gnupg module doesn???t support using passphrase at the moment.


Copy the private key to the passbolt configuration location. Replace you@example.com with the email address when generating the PGP key.

gpg --armor --export-secret-keys you@example.com | sudo tee /var/www/passbolt/config/gpg/serverkey_private.asc > /dev/null
And copy the public key as well.

gpg --armor --export you@example.com | sudo tee /var/www/passbolt/config/gpg/serverkey.asc > /dev/null
# Initialize the www-data user???s keyring.
sudo su -s /bin/bash -c "gpg --list-keys" www-data




# TODO(tim): following steps
#
# How to Install Mailtrain v2
# https://www.linuxbabe.com/ubuntu/install-mailtrain-v2-ubuntu-20-04