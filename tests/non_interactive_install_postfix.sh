PRIMARY_DOMAIN='justeuro.eu'
POSTFIX_mailname="$PRIMARY_DOMAIN"
POSTFIX_main_mailer_type='Internet Site'

# Taken from: https://serverfault.com/a/144010
debconf-set-selections <<< "postfix postfix/mailname string $POSTFIX_mailname"
debconf-set-selections <<< "postfix postfix/main_mailer_type string '${POSTFIX_main_mailer_type}'"
apt-get install --assume-yes postfix