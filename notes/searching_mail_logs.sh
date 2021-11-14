
echo "" > /var/log/mail.err
echo "" > /var/log/mail.log
systemctl restart postfix dovecot


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





################ Postfix Log Report


# there are few tools that manage mail log analysys:
# http://www.postfix.org/addon.html#logfile


#
# Pflogsumm is a great tool to create a summary of Postfix logs. Install it on Ubuntu with:
apt install pflogsumm

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
fgrep 'error' mail.log

# Rejected via filters
grep -i 'reject' /var/log/mail.log
grep 'NOQUEUE' /var/log/mail.log

for i in `grep -i "someuser@recipientdomain.com" /var/log/mail.log | awk '{print $5}'`; do grep -i $i /var/log/mail.log; done



grep 'krystatymoteusz@gmail.com' /var/log/mail.log

grep 'from=<krystatymoteusz@gmail.com>' /var/log/mail.log
# or
grep 'to=<krystatymoteusz@gmail.com>' /var/log/mail.log

