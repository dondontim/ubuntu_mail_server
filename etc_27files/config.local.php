<?php
# Local PostfixAdmin config file overwriting below:
# /usr/share/postfixadmin/config.inc.php

# use Argon2 password scheme

$CONF['encrypt'] = 'dovecot:ARGON2I';

$CONF['dovecotpw'] = "/usr/bin/doveadm pw -r 5";
if(@file_exists('/usr/bin/doveadm')) { // @ to silence openbase_dir stuff; see https://github.com/postfixadmin/postfixadmin/issues/171
    $CONF['dovecotpw'] = "/usr/bin/doveadm pw -r 5"; # debian
}

$CONF['setup_password'] = '5082bcb8630ce541ac8301b814708862:54f489bb63a7429f9e09757f450f44da0291f42c';
