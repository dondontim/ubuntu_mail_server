
# TODO(tim): Clean these below stuff
echo "" > /var/log/mail.err
echo "" > /var/log/mail.log
systemctl restart opendkim postfix dovecot policyd-rate-limit postgrey fail2ban
systemctl restart postfix  

apt-cache search dovecot | grep ^dovecot


## fail2ban log file
# /var/log/fail2ban.log




# You can check iptables rules by running the following command.
sudo iptables -L


# If you would like to manually block an IP address, run the following command.
# Replace 12.34.56.78 with the IP address you want to block.
sudo iptables -I INPUT -s 12.34.56.78 -j DROP
# If you use UFW (iptables frontend), then run
sudo ufw insert 1 deny from 12.34.56.78 to any






##### LOG ANALYSYS (tools)
#
# Opensource tools
https://opensource.com/article/19/4/log-analysis-tools 

https://www.graylog.org/success/linux
# Greylog demo
https://go2.graylog.org/see-demo-multi-dates 

# Greylog Install instructions
https://docs.graylog.org/docs/operating-system-packages

### PREQUISICIES

# Install java on ubuntu
https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-20-04

# Install elastcisearch
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-20-04







################ Dovecot Log Report

# https://doc.dovecot.org/admin_manual/logging/

## Log File Location
# Check!!! : https://doc.dovecot.org/admin_manual/logging/#changing-log-file-paths
doveadm log find

# You can easily print the last 1000 error messages of a running Dovecot:
doveadm log errors


################  TODO(tim): search tools to analyze /var/log/syslog



################ Postfix Log Report


# there are few tools that manage mail log analysys:
# http://www.postfix.org/addon.html#logfile


/usr/sbin/pflogsumm -d today /var/log/mail.log --problems-first --rej-add-from --verbose-msg-detail -q | less

#
# Pflogsumm is a great tool to create a summary of Postfix logs. Install it on Ubuntu with:
apt-get install -y pflogsumm

# Generate a report for today.
pflogsumm -d today /var/log/mail.log
# Generate a report for yesterday.
pflogsumm -d yesterday /var/log/mail.log
# If you like to generate a report for this week.
pflogsumm /var/log/mail.log
# To emit “problem” reports (bounces, defers, warnings, rejects) before “normal” stats, use --problems-first flag.
pflogsumm -d today /var/log/mail.log --problems-first
# To append the email from address to each listing in the reject report, use --rej-add-from flag.
pflogsumm -d today /var/log/mail.log --rej-add-from
# To show the full reason in reject summaries, use --verbose-msg-detail flag.
pflogsumm -d today /var/log/mail.log --rej-add-from --verbose-msg-detail


# You should pay attention to the:
# message reject detail section,
# where you can see for what reason those emails are rejected and
#  if there’s any false positives. Greylisting rejections are safe to ignore.



############## Searching mail logs


grep -i 'warning' /var/log/mail.log
grep -i 'denied' /var/log/mail.log
# fgrep == grep -F == Interpret PATTERNS as fixed strings, not regular expressions.
fgrep 'error' /var/log/mail.log

# Rejected via filters
grep -i 'reject' /var/log/mail.log
grep 'NOQUEUE' /var/log/mail.log

grep -i 'milter-reject' /var/log/mail.log

for i in `grep -i "someuser@recipientdomain.com" /var/log/mail.log | awk '{print $5}'`; do grep -i $i /var/log/mail.log; done



grep 'krystatymoteusz@gmail.com' /var/log/mail.log

grep 'from=<krystatymoteusz@gmail.com>' /var/log/mail.log
# or
grep 'to=<krystatymoteusz@gmail.com>' /var/log/mail.log

