# 21
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/conf.d/postfixadmin.conf"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
)
# Think of extracting /etc/postfix/ !!!
# also potentialy /usr/share/postfixadmin/ and /etc/dovecot/

for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done


# 7
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
)




for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done






# ###############################
# This dir is unable to copy (need to be done manually)
"/var/spool/postfix/opendkim/" # directory to hold the OpenDKIM socket file
# ###############################




### backup_nr3 was 19 f and 7 dirs
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
drwxr-xr-x  3 root root  4096 Nov  9 20:59 %var%vmail%






### backup_nr4 was 21 f and 7 dirs
# + 
# /etc/postfix/
# /usr/share/postfixadmin/
# /etc/dovecot/
# Just for protection so (21 f 10 d)

-rw-r--r--  1 root root   195 Nov 13 15:21 %etc%aliases
-rw-------  1 root root  3000 Nov 13 15:21 %etc%dbconfig-common%postfixadmin.conf
-rw-r--r--  1 root root   753 Nov 13 15:21 %etc%default%opendkim
drwxr-xr-x  4 root root  4096 Nov 13 20:24 %etc%dovecot%
-rw-r--r--  1 root root  5729 Nov 13 15:21 %etc%dovecot%conf.d%10-auth.conf
-rw-r--r--  1 root root 18047 Nov 13 15:21 %etc%dovecot%conf.d%10-mail.conf
-rw-r--r--  1 root root  3920 Nov 13 15:21 %etc%dovecot%conf.d%10-master.conf
-rw-r--r--  1 root root  3631 Nov 13 15:21 %etc%dovecot%conf.d%10-ssl.conf
-rw-r--r--  1 root root  2880 Nov 13 15:21 %etc%dovecot%conf.d%15-mailboxes.conf
-rw-r-----  1 root root  6216 Nov 13 15:21 %etc%dovecot%dovecot-sql.conf.ext
-rw-r--r--  1 root root  4428 Nov 13 15:21 %etc%dovecot%dovecot.conf
-rw-r--r--  1 root root    17 Nov 13 15:21 %etc%hostname
-rw-r--r--  1 root root   204 Nov 13 15:21 %etc%hosts
drwxr-xr-x  9 root root  4096 Nov 13 15:22 %etc%letsencrypt%
drwxr-xr-x  8 root root  4096 Nov 13 15:22 %etc%nginx%
-rw-r--r--  1 root root  2021 Nov 13 15:21 %etc%nginx%conf.d%postfixadmin.conf
drwxr-xr-x  3 root root  4096 Nov 13 15:22 %etc%opendkim%
-rw-r--r--  1 root root  3405 Nov 13 15:21 %etc%opendkim.conf
-rw-r-----  1 root root  4172 Nov 13 15:21 %etc%policyd-rate-limit.yaml
drwxr-xr-x  6 root root  4096 Nov 13 20:22 %etc%postfix%
-rw-r--r--  1 root root  3813 Nov 13 15:21 %etc%postfix%main.cf
-rw-r--r--  1 root root  7194 Nov 13 15:21 %etc%postfix%master.cf
-rw-r--r--  1 root root    35 Nov 13 15:21 %etc%postfix%my_custom_header
drwxr-xr-x  2 root root  4096 Nov 13 15:22 %etc%postfix%sql%
-rw-r-----  1 root root   531 Nov 13 15:21 %etc%postfixadmin%dbconfig.inc.php
drwxr-xr-x  2 root root  4096 Nov 13 15:22 %etc%systemd%system%dovecot.service.d%
drwxr-xr-x 10 root root  4096 Nov 13 20:23 %usr%share%postfixadmin%
-rw-r--r--  1 root root   396 Nov 13 15:21 %usr%share%postfixadmin%config.local.php
drwxr-xr-x  2 root root  4096 Nov 13 15:22 %usr%share%postfixadmin%templates_c%
-rw-------  1 root root  1416 Nov 13 15:21 %var%spool%cron%crontabs%root
drwxr-xr-x  3 root root  4096 Nov 13 15:22 %var%vmail%





################################################################################
# Trying 8. : 
# https://www.linuxbabe.com/mail-server/block-email-spam-postfix
################################################################################






###### new
/etc/postfix/helo_access

## To whitelist a domain
# You can add other hostnames in /etc/postgrey/whitelist_clients 
/etc/postgrey/whitelist_clients


/etc/default/postgrey


/etc/postfix/rbl_override # White list



/etc/fail2ban/jail.local
/etc/fail2ban/filter.d/postfix-flood-attack.conf


#########################

# 27
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/conf.d/postfixadmin.conf"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
  "/etc/postfix/helo_access"
  "/etc/postgrey/whitelist_clients"
  "/etc/default/postgrey"
  "/etc/postfix/rbl_override"
  "/etc/fail2ban/jail.local"
  "/etc/fail2ban/filter.d/postfix-flood-attack.conf"
)
for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done
# 12 cuz additionaly added:
# /usr/share/postfixadmin/
# /etc/dovecot/
# /etc/postgrey/
# /etc/postfix/
# /etc/fail2ban/
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
  "/usr/share/postfixadmin/"
  "/etc/dovecot/"
  "/etc/postgrey/"
  "/etc/postfix/"
  "/etc/fail2ban/"
)
for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done


-rw-r--r--  1 root root   195 Nov 14 21:05 %etc%aliases
-rw-------  1 root root  3000 Nov 14 21:05 %etc%dbconfig-common%postfixadmin.conf
-rw-r--r--  1 root root   753 Nov 14 21:05 %etc%default%opendkim
-rw-r--r--  1 root root   510 Nov 14 21:05 %etc%default%postgrey
drwxr-xr-x  4 root root  4096 Nov 14 21:06 %etc%dovecot%
-rw-r--r--  1 root root  5729 Nov 14 21:05 %etc%dovecot%conf.d%10-auth.conf
-rw-r--r--  1 root root 18047 Nov 14 21:05 %etc%dovecot%conf.d%10-mail.conf
-rw-r--r--  1 root root  3920 Nov 14 21:05 %etc%dovecot%conf.d%10-master.conf
-rw-r--r--  1 root root  3631 Nov 14 21:05 %etc%dovecot%conf.d%10-ssl.conf
-rw-r--r--  1 root root  3169 Nov 14 21:05 %etc%dovecot%conf.d%15-mailboxes.conf
-rw-r-----  1 root root  6216 Nov 14 21:05 %etc%dovecot%dovecot-sql.conf.ext
-rw-r--r--  1 root root  4428 Nov 14 21:05 %etc%dovecot%dovecot.conf
drwxr-xr-x  6 root root  4096 Nov 14 21:06 %etc%fail2ban%
-rw-r--r--  1 root root    86 Nov 14 21:05 %etc%fail2ban%filter.d%postfix-flood-attack.conf
-rw-r--r--  1 root root   404 Nov 14 21:05 %etc%fail2ban%jail.local
-rw-r--r--  1 root root    17 Nov 14 21:05 %etc%hostname
-rw-r--r--  1 root root   204 Nov 14 21:05 %etc%hosts
drwxr-xr-x  9 root root  4096 Nov 14 22:12 %etc%letsencrypt%
drwxr-xr-x  8 root root  4096 Nov 14 22:12 %etc%nginx%
-rw-r--r--  1 root root  2021 Nov 14 21:05 %etc%nginx%conf.d%postfixadmin.conf
drwxr-xr-x  3 root root  4096 Nov 14 22:12 %etc%opendkim%
-rw-r--r--  1 root root  3405 Nov 14 21:05 %etc%opendkim.conf
-rw-r-----  1 root root  4172 Nov 14 21:05 %etc%policyd-rate-limit.yaml
drwxr-xr-x  6 root root  4096 Nov 14 22:12 %etc%postfix%
-rw-r--r--  1 root root    84 Nov 14 21:05 %etc%postfix%helo_access
-rw-r--r--  1 root root  7133 Nov 14 21:05 %etc%postfix%main.cf
-rw-r--r--  1 root root  7194 Nov 14 21:05 %etc%postfix%master.cf
-rw-r--r--  1 root root    35 Nov 14 21:05 %etc%postfix%my_custom_header
-rw-r--r--  1 root root   153 Nov 14 21:05 %etc%postfix%rbl_override
drwxr-xr-x  2 root root  4096 Nov 14 21:06 %etc%postfix%sql%
-rw-r-----  1 root root   531 Nov 14 21:05 %etc%postfixadmin%dbconfig.inc.php
drwxr-xr-x  2 root root  4096 Nov 14 21:06 %etc%postgrey%
-rw-r--r--  1 root root  9278 Nov 14 21:05 %etc%postgrey%whitelist_clients
drwxr-xr-x  2 root root  4096 Nov 14 22:12 %etc%systemd%system%dovecot.service.d%
drwxr-xr-x 10 root root  4096 Nov 14 21:06 %usr%share%postfixadmin%
-rw-r--r--  1 root root   396 Nov 14 21:05 %usr%share%postfixadmin%config.local.php
drwxr-xr-x  2 root root  4096 Nov 14 22:12 %usr%share%postfixadmin%templates_c%
-rw-------  1 root root  2243 Nov 14 21:05 %var%spool%cron%crontabs%root
drwxr-xr-x  3 root root  4096 Nov 14 21:06 %var%vmail%


################################################################################
################################################################################
################################################################################


################################################################################
# 9.
################################################################################

/etc/postfix/header_checks


/etc/postfix/body_checks


/etc/default/spamass-milter


/etc/default/spamassassin
/etc/spamassassin/local.cf


# btw Think of the whole /usr/share/spamassassin/ dir

/etc/dovecot/conf.d/15-lda.conf
/etc/dovecot/conf.d/20-lmtp.conf
/etc/dovecot/conf.d/90-sieve.conf
/var/mail/SpamToJunk.sieve

# user specific - seems not working for 17 Nov
/var/vmail/justeuro.eu/admin/spamassassin/user_pref

# Deleting Email Headers For Outgoing Emails
/etc/postfix/smtp_header_checks


###############

# 38
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/conf.d/postfixadmin.conf"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
  "/etc/postfix/helo_access"
  "/etc/postgrey/whitelist_clients"
  "/etc/default/postgrey"
  "/etc/postfix/rbl_override"
  "/etc/fail2ban/jail.local"
  "/etc/fail2ban/filter.d/postfix-flood-attack.conf"
  "/etc/postfix/header_checks"
  "/etc/postfix/body_checks"
  "/etc/default/spamass-milter"
  "/etc/default/spamassassin"
  "/etc/spamassassin/local.cf"
  "/etc/dovecot/conf.d/15-lda.conf"
  "/etc/dovecot/conf.d/20-lmtp.conf"
  "/etc/dovecot/conf.d/90-sieve.conf"
  "/var/mail/SpamToJunk.sieve"
  "/var/vmail/justeuro.eu/admin/spamassassin/user_pref"
  "/etc/postfix/smtp_header_checks"
)
for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done
# 13       cuz additionaly added:
# /usr/share/postfixadmin/
# /etc/dovecot/
# /etc/postgrey/
# /etc/postfix/
# /etc/fail2ban/
# 
# /etc/spamassassin/ # added in 9.
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
  "/usr/share/postfixadmin/"
  "/etc/dovecot/"
  "/etc/postgrey/"
  "/etc/postfix/"
  "/etc/fail2ban/"
  "/etc/spamassassin/"
)
for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done


################################################################################
# 10.
################################################################################

/etc/amavis/conf.d/05-node_id

/etc/amavis/conf.d/15-content_filter_mode
 
/etc/amavis/conf.d/50-user

/etc/amavis/conf.d/21-ubuntu_defaults


###############

# 42
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/conf.d/postfixadmin.conf"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
  "/etc/postfix/helo_access"
  "/etc/postgrey/whitelist_clients"
  "/etc/default/postgrey"
  "/etc/postfix/rbl_override"
  "/etc/fail2ban/jail.local"
  "/etc/fail2ban/filter.d/postfix-flood-attack.conf"
  "/etc/postfix/header_checks"
  "/etc/postfix/body_checks"
  "/etc/default/spamass-milter"
  "/etc/default/spamassassin"
  "/etc/spamassassin/local.cf"
  "/etc/dovecot/conf.d/15-lda.conf"
  "/etc/dovecot/conf.d/20-lmtp.conf"
  "/etc/dovecot/conf.d/90-sieve.conf"
  "/var/mail/SpamToJunk.sieve"
  "/var/vmail/justeuro.eu/admin/spamassassin/user_pref"
  "/etc/postfix/smtp_header_checks"
  "/etc/amavis/conf.d/05-node_id"
  "/etc/amavis/conf.d/15-content_filter_mode"
  "/etc/amavis/conf.d/50-user"
  "/etc/amavis/conf.d/21-ubuntu_defaults"
)
for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done
# 14       cuz additionaly added:
# /usr/share/postfixadmin/
# /etc/dovecot/
# /etc/postgrey/
# /etc/postfix/
# /etc/fail2ban/
# 
# /etc/spamassassin/ # added in 9.
# /etc/amavis/ # added in 10.
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
  "/usr/share/postfixadmin/"
  "/etc/dovecot/"
  "/etc/postgrey/"
  "/etc/postfix/"
  "/etc/fail2ban/"
  "/etc/spamassassin/"
  "/etc/amavis/"
)
for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done

################################################################################
# 12. (i do not do 11 (VPN))
################################################################################

/etc/postfix/postscreen_access.cidr

###############

# 43
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/conf.d/postfixadmin.conf"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
  "/etc/postfix/helo_access"
  "/etc/postgrey/whitelist_clients"
  "/etc/default/postgrey"
  "/etc/postfix/rbl_override"
  "/etc/fail2ban/jail.local"
  "/etc/fail2ban/filter.d/postfix-flood-attack.conf"
  "/etc/postfix/header_checks"
  "/etc/postfix/body_checks"
  "/etc/default/spamass-milter"
  "/etc/default/spamassassin"
  "/etc/spamassassin/local.cf"
  "/etc/dovecot/conf.d/15-lda.conf"
  "/etc/dovecot/conf.d/20-lmtp.conf"
  "/etc/dovecot/conf.d/90-sieve.conf"
  "/var/mail/SpamToJunk.sieve"
  "/var/vmail/justeuro.eu/admin/spamassassin/user_pref"
  "/etc/postfix/smtp_header_checks"
  "/etc/amavis/conf.d/05-node_id"
  "/etc/amavis/conf.d/15-content_filter_mode"
  "/etc/amavis/conf.d/50-user"
  "/etc/amavis/conf.d/21-ubuntu_defaults"
  "/etc/postfix/postscreen_access.cidr"
)
for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done
# 15       cuz additionaly added:
# /usr/share/postfixadmin/
# /etc/dovecot/
# /etc/postgrey/
# /etc/postfix/
# /etc/fail2ban/
# 
# /etc/spamassassin/ # added in 9.
# /etc/amavis/ # added in 10.
# /etc/ # added in 12.
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
  "/usr/share/postfixadmin/"
  "/etc/dovecot/"
  "/etc/postgrey/"
  "/etc/postfix/"
  "/etc/fail2ban/"
  "/etc/spamassassin/"
  "/etc/amavis/"
  "/etc/"
)
for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done



################################################################################
# SETTING UP LOCAL DNS RESOLVER
################################################################################

/etc/unbound/unbound.conf
/etc/systemd/system/unbound-resolvconf.service


###############

# 45
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/conf.d/postfixadmin.conf"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
  "/etc/postfix/helo_access"
  "/etc/postgrey/whitelist_clients"
  "/etc/default/postgrey"
  "/etc/postfix/rbl_override"
  "/etc/fail2ban/jail.local"
  "/etc/fail2ban/filter.d/postfix-flood-attack.conf"
  "/etc/postfix/header_checks"
  "/etc/postfix/body_checks"
  "/etc/default/spamass-milter"
  "/etc/default/spamassassin"
  "/etc/spamassassin/local.cf"
  "/etc/dovecot/conf.d/15-lda.conf"
  "/etc/dovecot/conf.d/20-lmtp.conf"
  "/etc/dovecot/conf.d/90-sieve.conf"
  "/var/mail/SpamToJunk.sieve"
  "/var/vmail/justeuro.eu/admin/spamassassin/user_pref"
  "/etc/postfix/smtp_header_checks"
  "/etc/amavis/conf.d/05-node_id"
  "/etc/amavis/conf.d/15-content_filter_mode"
  "/etc/amavis/conf.d/50-user"
  "/etc/amavis/conf.d/21-ubuntu_defaults"
  "/etc/postfix/postscreen_access.cidr"
  "/etc/unbound/unbound.conf"
  "/etc/systemd/system/unbound-resolvconf.service"
)
for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done
# 15       cuz additionaly added:
# /usr/share/postfixadmin/
# /etc/dovecot/
# /etc/postgrey/
# /etc/postfix/
# /etc/fail2ban/
# 
# /etc/spamassassin/ # added in 9.
# /etc/amavis/ # added in 10.
# /etc/ # added in 12.
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
  "/usr/share/postfixadmin/"
  "/etc/dovecot/"
  "/etc/postgrey/"
  "/etc/postfix/"
  "/etc/fail2ban/"
  "/etc/spamassassin/"
  "/etc/amavis/"
  "/etc/"
)
for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done

###################### END UNBOUND LOCAL DNS RESOLVER

################################################################################
# Additional commit - before webmail (all tested working very nice)
################################################################################

/etc/mailname

I moved /etc/nginx/conf.d/postfixadmin.conf /etc/nginx/sites-available/postfixadmin.justeuro.eu

###############

# 46
FILES=(
  "/etc/hostname"
  "/etc/hosts"
  "/etc/aliases"
  "/etc/postfix/main.cf"
  "/etc/postfix/master.cf"
  "/etc/dovecot/dovecot.conf"
  "/etc/dovecot/conf.d/10-mail.conf"
  "/etc/dovecot/conf.d/10-master.conf"
  "/etc/dovecot/conf.d/10-auth.conf"
  "/etc/dovecot/conf.d/10-ssl.conf"
  "/etc/dovecot/conf.d/15-mailboxes.conf"
  "/etc/dbconfig-common/postfixadmin.conf"
  "/etc/postfixadmin/dbconfig.inc.php"
  "/etc/nginx/sites-available/postfixadmin.justeuro.eu"
  "/usr/share/postfixadmin/config.local.php"
  "/etc/dovecot/dovecot-sql.conf.ext"
  "/var/spool/cron/crontabs/root"
  "/etc/opendkim.conf"
  "/etc/default/opendkim"
  "/etc/policyd-rate-limit.yaml"
  "/etc/postfix/my_custom_header"
  "/etc/postfix/helo_access"
  "/etc/postgrey/whitelist_clients"
  "/etc/default/postgrey"
  "/etc/postfix/rbl_override"
  "/etc/fail2ban/jail.local"
  "/etc/fail2ban/filter.d/postfix-flood-attack.conf"
  "/etc/postfix/header_checks"
  "/etc/postfix/body_checks"
  "/etc/default/spamass-milter"
  "/etc/default/spamassassin"
  "/etc/spamassassin/local.cf"
  "/etc/dovecot/conf.d/15-lda.conf"
  "/etc/dovecot/conf.d/20-lmtp.conf"
  "/etc/dovecot/conf.d/90-sieve.conf"
  "/var/mail/SpamToJunk.sieve"
  "/var/vmail/justeuro.eu/admin/spamassassin/user_pref"
  "/etc/postfix/smtp_header_checks"
  "/etc/amavis/conf.d/05-node_id"
  "/etc/amavis/conf.d/15-content_filter_mode"
  "/etc/amavis/conf.d/50-user"
  "/etc/amavis/conf.d/21-ubuntu_defaults"
  "/etc/postfix/postscreen_access.cidr"
  "/etc/unbound/unbound.conf"
  "/etc/systemd/system/unbound-resolvconf.service"
  "/etc/mailname"
)
for f in "${FILES[@]}"; do
  NAME="$(echo "$f" | sed "s;/;%;g")"
  cp "$f" "/root/backup_nr4/${NAME}"
done
# 15       cuz additionaly added:
# /usr/share/postfixadmin/
# /etc/dovecot/
# /etc/postgrey/
# /etc/postfix/
# /etc/fail2ban/
# 
# /etc/spamassassin/ # added in 9.
# /etc/amavis/ # added in 10.
# /etc/ # added in 12.
DIRS=(
  "/etc/opendkim/"
  "/etc/systemd/system/dovecot.service.d/"
  "/usr/share/postfixadmin/templates_c/"
  "/etc/postfix/sql/"
  "/var/vmail/"
  "/etc/letsencrypt/"
  "/etc/nginx/"
  "/usr/share/postfixadmin/"
  "/etc/dovecot/"
  "/etc/postgrey/"
  "/etc/postfix/"
  "/etc/fail2ban/"
  "/etc/spamassassin/"
  "/etc/amavis/"
  "/etc/"
)
for d in "${DIRS[@]}"; do
  NAME="$(echo "$d" | sed "s;/;%;g")"
  cp -r "$d" "/root/backup_nr4/${NAME}"
done

################################################################################
# Setting up Roundcube webmail
################################################################################
