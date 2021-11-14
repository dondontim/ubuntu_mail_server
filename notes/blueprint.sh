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
# 1
################################################################################

sudo apt-get update -y && sudo apt-get upgrade -y && apt-get install -y git curl && git clone https://github.com/dondontim/setup.git && cd setup && bash initial_server_setup.sh
bash after_initial.sh && cd

git clone https://github.com/dondontim/ubuntu_mail_server && cd ubuntu_mail_server 
bash main.sh # 1.sh


################################################################################
# 1, 2
################################################################################

# Na razie nie
#change hostname
#install postfix
#ufw allow 25/tcp





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

Install PostfixAdmin on Ubuntu 20.04 Server

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

# If your system can’t find the setfacl command, you need to install the acl package.
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
# include the recipient’s first name in the email body and segment your list
#  based on the subscriber’s gender, age, interest, country, etc.

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

# Once it’s installed, start it with systemctl.
systemctl start postgrey
# Enable auto-start at boot time.
systemctl enable postgrey

# On Debian and Ubuntu, it listens on TCP port 10023 on localhost (both IPv4 and IPv6).
sudo netstat -lnpt | grep postgrey


# Note: You can also see postgrey logs with this command: 
sudo journalctl -u postgrey.






cp /etc/postfix/rbl_override
postmap /etc/postfix/rbl_override



apt install mutt



apt install fail2ban