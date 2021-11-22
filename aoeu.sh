/etc/hostname
/etc/hosts
/etc/aliases

/etc/postfix/main.cf
/etc/postfix/master.cf

/etc/dovecot/dovecot.conf
/etc/dovecot/conf.d/10-mail.conf
/etc/dovecot/conf.d/10-master.conf
/etc/dovecot/conf.d/10-auth.conf
/etc/dovecot/conf.d/10-ssl.conf
/etc/dovecot/conf.d/15-mailboxes.conf





### Auto-Renew TLS Certificate
#
#You can create Cron job to automatically renew TLS certificate. Simply open root user’s crontab file.
sudo crontab -e
@daily certbot renew --quiet && systemctl reload postfix dovecot nginx
#Reloading Postfix, Dovecot and the web server is necessary to make these programs pick up the new certificate and private key.

### Dovecot Automatic Restart
#
/etc/systemd/system/dovecot.service.d/restart.conf
systemctl daemon-reload






# Postfix admin ONLY! do sed
/etc/dbconfig-common/postfixadmin.conf
Change
dbc_dbtype='mysql'
to
dbc_dbtype='mysqli'

/etc/postfixadmin/dbconfig.inc.php
Change
$dbtype='mysql';
to
$dbtype='mysqli';
# END Postfix admin 


/etc/nginx/conf.d/postfixadmin.conf
/usr/share/postfixadmin/config.local.php


### Postfix admin x mysql
# In all below: Replace password with the postfixadmin password you set in Step 2.
/etc/postfix/sql/mysql_virtual_domains_maps.cf
/etc/postfix/sql/mysql_virtual_mailbox_maps.cf
/etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf
/etc/postfix/sql/mysql_virtual_alias_maps.cf
/etc/postfix/sql/mysql_virtual_alias_domain_maps.cf
/etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf



/etc/dovecot/dovecot-sql.conf.ext # Replace password with the postfixadmin password you set in Step 2.











### Automatically Clean the Junk Folder and Trash Folder
#
# clean emails that have been in the Junk or Trash folder for more than 2 weeks, instead of cleaning all emails.

sudo crontab -e
# Add the following line to clean Junk and Trash folder every day.
@daily doveadm expunge -A mailbox Junk savedbefore 2w;doveadm expunge -A mailbox Trash savedbefore 2w
# To receive report when a Cron job produces an error, you can add the following line above all Cron jobs.

MAILTO="you@your-domain.com"







/var/spool/cron/crontabs/root





I DZIALA JAK NA RAZIE!!!!



-rw-r--r-- 1 root root   195 Nov  9 18:11 %etc%aliases
-rw------- 1 root root  3000 Nov  9 18:11 %etc%dbconfig-common%postfixadmin.conf
-rw-r--r-- 1 root root  5729 Nov  9 18:11 %etc%dovecot%conf.d%10-auth.conf
-rw-r--r-- 1 root root 18047 Nov  9 18:11 %etc%dovecot%conf.d%10-mail.conf
-rw-r--r-- 1 root root  3920 Nov  9 18:11 %etc%dovecot%conf.d%10-master.conf
-rw-r--r-- 1 root root  3631 Nov  9 18:11 %etc%dovecot%conf.d%10-ssl.conf
-rw-r--r-- 1 root root  2880 Nov  9 18:11 %etc%dovecot%conf.d%15-mailboxes.conf
-rw-r----- 1 root root  6216 Nov  9 18:11 %etc%dovecot%dovecot-sql.conf.ext
-rw-r--r-- 1 root root  4428 Nov  9 18:11 %etc%dovecot%dovecot.conf
-rw-r--r-- 1 root root    17 Nov  9 18:11 %etc%hostname
-rw-r--r-- 1 root root   204 Nov  9 18:11 %etc%hosts
-rw-r--r-- 1 root root  2021 Nov  9 18:11 %etc%nginx%conf.d%postfixadmin.conf
-rw-r--r-- 1 root root  2892 Nov  9 18:11 %etc%postfix%main.cf
-rw-r--r-- 1 root root  6986 Nov  9 18:11 %etc%postfix%master.cf
-rw-r-x--- 1 root root   319 Nov  9 18:11 %etc%postfix%sql%mysql_virtual_alias_domain_catchall_maps.cf
-rw-r-x--- 1 root root   289 Nov  9 18:11 %etc%postfix%sql%mysql_virtual_alias_domain_mailbox_maps.cf
-rw-r-x--- 1 root root   279 Nov  9 18:11 %etc%postfix%sql%mysql_virtual_alias_domain_maps.cf
-rw-r-x--- 1 root root   171 Nov  9 18:11 %etc%postfix%sql%mysql_virtual_alias_maps.cf
-rw-r-x--- 1 root root   435 Nov  9 18:11 %etc%postfix%sql%mysql_virtual_domains_maps.cf
-rw-r-x--- 1 root root   177 Nov  9 18:11 %etc%postfix%sql%mysql_virtual_mailbox_maps.cf
-rw-r----- 1 root root   531 Nov  9 18:11 %etc%postfixadmin%dbconfig.inc.php
-rw-r--r-- 1 root root    39 Nov  9 18:11 %etc%systemd%system%dovecot.service.d%restart.conf
-rw-r--r-- 1 root root   396 Nov  9 18:11 %usr%share%postfixadmin%config.local.php
-rw------- 1 root root  1416 Nov  9 18:11 %var%spool%cron%crontabs%root
24 till here
drwxr-xr-x 4 root root  4096 Nov  9 18:11 .
drwx------ 7 root root  4096 Nov  9 01:33 ..
drwxr-xr-x 9 root root  4096 Nov  9 00:05 letsencrypt
drwxr-xr-x 8 root root  4096 Nov  9 00:06 nginx










/etc/opendkim.conf
/etc/default/opendkim

/etc/opendkim/signing.table
/etc/opendkim/key.table
/etc/opendkim/trusted.hosts



# -R
/etc/opendkim/

# directory to hold the OpenDKIM socket file
/var/spool/postfix/opendkim/


/etc/systemd/system/dovecot.service.d/ # 2


/usr/share/postfixadmin/templates_c/ # 3

/etc/postfix/sql/

/var/vmail/



/etc/letsencrypt/
/etc/nginx/




# After part 4

-rw-r--r--  1 root root   195 Nov  9 20:54 %etc%aliases
-rw-------  1 root root  3000 Nov  9 20:54 %etc%dbconfig-common%postfixadmin.conf
-rw-r--r--  1 root root   753 Nov  9 20:54 %etc%default%opendkim
-rw-r--r--  1 root root  5729 Nov  9 20:54 %etc%dovecot%conf.d%10-auth.conf
-rw-r--r--  1 root root 18047 Nov  9 20:54 %etc%dovecot%conf.d%10-mail.conf
-rw-r--r--  1 root root  3920 Nov  9 20:54 %etc%dovecot%conf.d%10-master.conf
-rw-r--r--  1 root root  3631 Nov  9 20:54 %etc%dovecot%conf.d%10-ssl.conf
-rw-r--r--  1 root root  2880 Nov  9 20:54 %etc%dovecot%conf.d%15-mailboxes.conf
-rw-r-----  1 root root  6216 Nov  9 20:54 %etc%dovecot%dovecot-sql.conf.ext
-rw-r--r--  1 root root  4428 Nov  9 20:54 %etc%dovecot%dovecot.conf
-rw-r--r--  1 root root    17 Nov  9 20:54 %etc%hostname
-rw-r--r--  1 root root   204 Nov  9 20:54 %etc%hosts
drwxr-xr-x  9 root root  4096 Nov  9 20:59 %etc%letsencrypt%
drwxr-xr-x  8 root root  4096 Nov  9 20:59 %etc%nginx%
-rw-r--r--  1 root root  2021 Nov  9 20:54 %etc%nginx%conf.d%postfixadmin.conf
drwxr-xr-x  3 root root  4096 Nov  9 20:59 %etc%opendkim%
-rw-r--r--  1 root root  3405 Nov  9 20:54 %etc%opendkim.conf
-rw-r--r--  1 root root  3522 Nov  9 20:54 %etc%postfix%main.cf
-rw-r--r--  1 root root  7194 Nov  9 20:54 %etc%postfix%master.cf
drwxr-xr-x  2 root root  4096 Nov  9 20:59 %etc%postfix%sql%
-rw-r-----  1 root root   531 Nov  9 20:54 %etc%postfixadmin%dbconfig.inc.php
drwxr-xr-x  2 root root  4096 Nov  9 20:59 %etc%systemd%system%dovecot.service.d%
-rw-r--r--  1 root root   396 Nov  9 20:54 %usr%share%postfixadmin%config.local.php
drwxr-xr-x  2 root root  4096 Nov  9 20:59 %usr%share%postfixadmin%templates_c%
-rw-------  1 root root  1416 Nov  9 20:54 %var%spool%cron%crontabs%root
drwxr-xr-x  2 root root  4096 Nov  9 20:59 %var%spool%postfix%opendkim%
drwxr-xr-x  3 root root  4096 Nov  9 20:59 %var%vmail%




# 6
#
/etc/policyd-rate-limit.yaml

/etc/postfix/main.cf






# Custom priority header 
/etc/postfix/my_custom_header # The problem in here is that
# all incoming and outgoing mail have this header appended


# no 7 cuz no multiple domains

# 8

fuck it till now