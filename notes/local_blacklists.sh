### Remember your local blacklists
#
# Local blacklist
/etc/postfix/rbl_override # postmap /etc/postfix/rbl_override && systemctl restart postfix
# spamassassin blacklist and whitelist email address.
/etc/mail/spamassassin/local.cf # (hardlinked with /etc/spamassassin/local.cf) # systemctl restart spamassassin

### Current spammers found
# spameri@tiscali.it
# 104.168.244.79
# 
# Potential
# 192.241.213.0/24
# 167.99.176.152