############################## Testing email ###################################

# Complex tests
https://mxtoolbox.com/SuperTool.aspx
https://mxtoolbox.com/diagnostic.aspx

# Inbound emails will be delayed for a few minutes, because greylisting is enabled, 
# which tells other sending SMTP server to try delivering the email again after several minutes.
# This is useful to block spam. 
# The following message in /var/log/mail.log indicates greylisting is enabled.
# |
# | postfix/postscreen[20995]: NOQUEUE: reject: RCPT from [34.209.113.130]:36980: 450 4.3.2 Service currently unavailable;
# |
# However, greylisting can be rather annoying. 
# You can disable it by editing the Postfix main configuration file: 
# /etc/postfix/main.cf
# Find the following lines at the end of the file and comment them out. 
# (Add a # character at the beginning of each line.)
# |
# | postscreen_pipelining_enable = yes
# | postscreen_pipelining_action = enforce
# | 
# | postscreen_non_smtp_command_enable = yes
# | postscreen_non_smtp_command_action = enforce
# | 
# | postscreen_bare_newline_enable = yes
# | postscreen_bare_newline_action = enforce
# | 
# Save and close the file. Then restart Postfix for the changes to take effect.
# | systemctl restart postfix
# Now you should be able to receive emails without waiting several minutes.
https://www.wormly.com/test-smtp-server

# Testing email
https://www.mail-tester.com




