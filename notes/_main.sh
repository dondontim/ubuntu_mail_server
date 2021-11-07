# Logs
grep postfix /var/log/syslog
/var/log/mail.log

# TIP: use the command "postconf -n" to view all main.cf parameter settings, 
#      "postconf parametername" to view a specific parameter, and 
#      "postconf 'parametername=value'" to set a specific parameter.



{ # try
  echo "Searching: $url"
  open_command "$url"
} || { # catch
  echo "Unrecognized search term!"
  echo "url = $url"
}

echo -ne 'hello\r'; sleep 5; echo 'good-bye'
echo -e '190.92.134.248\teu-central-1.justeuro.eu' >> /etc/hosts





# You can get the variables for a specific installed package using:
# debconf-show <packagename>
# ex. $ sudo debconf-show mysql-server-5.7

# Works 
debconf-set-selections <<< "postfix postfix/main_mailer_type string Internet Site"
# Does not (can not be there quotes)
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Reconfigure an package
dpkg-reconfigure postfix



postconf -# smtp_tls_CApath # Comment out an entry
postconf -X smtp_tls_CApath # Remove      an entry






################################################################################
# All config files to copy
################################################################################


####### Postfix

# Postfix main configuration file
/etc/postfix/main.cf
/etc/postfix/master.cf



####### Dovecot 

# Dovecot main configuration file
/etc/dovecot/dovecot.conf
# The config file for mailbox locations and namespaces
/etc/dovecot/conf.d/10-mail.conf
# master config file
/etc/dovecot/conf.d/10-master.conf
# authentication config file.
/etc/dovecot/conf.d/10-auth.conf
# SSL/TLS config file.
/etc/dovecot/conf.d/10-ssl.conf
# Auto-create Sent and Trash Folder
/etc/dovecot/conf.d/15-mailboxes.conf


# Email Aliases
/etc/aliases


# Dovecot auto restart file
/etc/systemd/system/dovecot.service.d/restart.conf


# PostfixAdmin
/etc/dbconfig-common/postfixadmin.conf
/etc/postfixadmin/dbconfig.inc.php

# Create Nginx Config File for PostfixAdmin
/etc/nginx/conf.d/postfixadmin.conf

# postfixadmin config file
/usr/share/postfixadmin/config.local.php # Local version of:  /usr/share/postfixadmin/config.inc.php


# Postfix x mysql
/etc/postfix/sql/mysql_virtual_domains_maps.cf
/etc/postfix/sql/mysql_virtual_mailbox_maps.cf
/etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf
/etc/postfix/sql/mysql_virtual_alias_maps.cf
/etc/postfix/sql/mysql_virtual_alias_domain_maps.cf
/etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf


/etc/dovecot/dovecot-sql.conf.ext

# OpenDKIM main configuration file.
/etc/opendkim.conf

# Signing table.
/etc/opendkim/signing.table
# Key table
/etc/opendkim/key.table
# Trusted hosts file.
/etc/opendkim/trusted.hosts



/etc/default/opendkim



# SMTP Rate Limiting
/etc/policyd-rate-limit.yaml





# File permissions

-rw-r--r-- 1 tim  tim   5913 Nov  7 18:17 10-auth.conf
-rw-r--r-- 1 tim  tim  18156 Nov  7 18:17 10-mail.conf
-rw-r--r-- 1 tim  tim   3930 Nov  7 18:17 10-master.conf
-rw-r--r-- 1 tim  tim   3524 Nov  7 18:17 10-ssl.conf
-rw-r--r-- 1 tim  tim   2880 Nov  7 18:17 15-mailboxes.conf
-rw-r--r-- 1 tim  tim    195 Nov  7 18:17 aliases
-rw-rw-r-- 1 tim  tim    496 Nov  7 18:19 aoeu
-rw-r--r-- 1 root root   521 Nov  7 18:18 config.local.php
-rw-r----- 1 root root   531 Nov  7 18:18 dbconfig.inc.php
-rw-r----- 1 root root  6215 Nov  7 18:23 dovecot-sql.conf.ext
-rw-r--r-- 1 tim  tim   4428 Nov  7 18:16 dovecot.conf
-rw-r--r-- 1 root root   102 Nov  7 18:23 key.table
-rw-r--r-- 1 root root  4719 Nov  7 18:16 main.cf
-rw-r--r-- 1 tim  tim   7226 Nov  7 18:16 master.cf
-rw-r-x--- 1 root root   369 Nov  7 18:23 mysql_virtual_alias_domain_catchall_maps.cf
-rw-r-x--- 1 root root   339 Nov  7 18:23 mysql_virtual_alias_domain_mailbox_maps.cf
-rw-r-x--- 1 root root   329 Nov  7 18:23 mysql_virtual_alias_domain_maps.cf
-rw-r-x--- 1 root root   221 Nov  7 18:23 mysql_virtual_alias_maps.cf
-rw-r-x--- 1 root root   416 Nov  7 18:23 mysql_virtual_domains_maps.cf
-rw-r-x--- 1 root root   227 Nov  7 18:23 mysql_virtual_mailbox_maps.cf
-rw-r--r-- 1 root root   743 Nov  7 18:23 opendkim
-rw-r--r-- 1 root root  3370 Nov  7 18:23 opendkim.conf
-rw-r----- 1 root root  4171 Nov  7 18:23 policyd-rate-limit.yaml
-rw------- 1 root root  3000 Nov  7 18:47 etc_dbconfig-common_postfixadmin.conf
-rw-r--r-- 1 root root  2021 Nov  7 18:48 etc_nginx_conf.d_postfixadmin.conf
-rw-r--r-- 1 tim  tim     39 Nov  7 18:17 restart.conf
-rw-r--r-- 1 root root    48 Nov  7 18:23 signing.table
-rw-r--r-- 1 root root    35 Nov  7 18:23 trusted.hosts