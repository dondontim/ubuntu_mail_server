## Another tip from someone
# Better to install rspamd from ports and remove these blacklists entirely. 
# Blacklists are shady business, even worse than spam.


# Somebodys spam filters 
# Ref: https://forums.FreeBSD.org/threads/issue-with-postfix-and-spamhaus-rbl.70794/post-427108


# SASL CONFIG
broken_sasl_auth_clients = yes
smtpd_delay_reject = yes
smtpd_helo_required = yes

smtpd_helo_restrictions =
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_invalid_helo_hostname,
  reject_non_fqdn_helo_hostname

smtpd_sender_restrictions =
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_non_fqdn_sender,
  reject_unknown_sender_domain

smtpd_relay_restrictions =
  permit_mynetworks,
  permit_sasl_authenticated,
  defer_unauth_destination

smtpd_recipient_restrictions =
  reject_unknown_recipient_domain,
  reject_non_fqdn_recipient,
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_unauth_destination,
  reject_unauth_pipelining,
  reject_rbl_client bl.spamcop.net,
  reject_rbl_client sbl-xbl.spamhaus.org,
  reject_rbl_client zen.spamhaus.org,
  reject_rbl_client db.wpbl.info,
  reject_rbl_client cbl.abuseat.org