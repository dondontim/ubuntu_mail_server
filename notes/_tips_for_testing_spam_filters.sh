### Tips for testing spam filters

1.
# just drop the TTL on your DNS down to a dew minutes and 
# add the new service as a high value MX record. 
# Spammers Still tend to go for high value 'backup' MX records as they seem
# to thing they are less protected that the main MX.

# That'll attract tons of spam to that new service


2.
# Open up an email at domain_name@domain_name.TLD or accounting@ or hr@ or info@. 
# If your domain is already known to spammers, 
# you should automatically see a lot of traffic in those mailboxes. 
# Set your MTA or existing anti-spam to push mail from those accounts with all
# filtering off into your test environment. 

# Also, a lot of products have 'spam simulator' or 'spam test' options where 
# some recent spam is submitted to the system. 
# I think the spamassisin guys publish this as a tar file now and again



# Testing email deliverability
https://www.mailgun.com/email-testing-tool/send-spam-test-emails/


https://mailtrap.io/blog/test-email-deliverability/
https://mailtrap.io/blog/email-deliverability/