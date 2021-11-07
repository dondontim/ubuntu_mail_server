### Automatically Clean the Junk Folder and Trash Folder

# To delete emails in Junk folder for all users, you can run
sudo doveadm expunge -A mailbox Junk all

# To delete emails in Trash folder, run
sudo doveadm expunge -A mailbox Trash all

# I think it’s better to clean emails that have been in the Junk or Trash folder for more than 2 weeks, instead of cleaning all emails.
sudo doveadm expunge -A mailbox Junk savedbefore 2w

# Then add a cron job to automate the job.
sudo crontab -e

# Add the following line to clean Junk and Trash folder every day.
@daily doveadm expunge -A mailbox Junk savedbefore 2w;doveadm expunge -A mailbox Trash savedbefore 2w

# To receive report when a Cron job produces an error, you can add the following line above all Cron jobs.
MAILTO="you@your-domain.com"

# Save and close the file. And you’re done.