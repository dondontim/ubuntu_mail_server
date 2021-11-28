# Change User Password in PostfixAdmin
Users can log into PostfixAdmin at https://postfixadmin.example.com/users/login.php, then change their passwords.


### After some service fails:
# 1. restart it:
systemctl restart <service>
# 2. After check the logs:
journalctl -xe





### The Struggle with Microsoft Mailboxes

# Microsoft seems to be using an internal blacklist that blocks many legitimate IP addresses. 
# If your emails are rejected by outlook or Hotmail, 
# you need to submit the sender information form. 
# https://support.microsoft.com/en-us/supportrequestform/8ad563e3-288e-2a61-8122-3ba03d6b8d75
# After that, 
# your email will be accepted by outlook/hotmail, but may still be labeled as spam.



USING_POP3_TO_FETCH_EMAILS='true'

function using_pop3_to_fetch_emails() {
  if [ "$USING_POP3_TO_FETCH_EMAILS" = true ]; then
    return 0
  else
    return 1
  fi
}


justeuro.eu
postfixadmin.justeuro.eu
roundcube.justeuro.eu
cdn.justeuro.eu
hackmeifyoucan.justeuro.eu
