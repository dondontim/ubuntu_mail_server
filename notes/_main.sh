

# TIP: use the command "postconf -n" to view all main.cf parameter settings, 
#      "postconf parametername" to view a specific parameter, and 
#      "postconf 'parametername=value'" to set a specific parameter.

# You can get the variables for a specific installed package using:
# debconf-show <packagename>
# ex. $ sudo debconf-show mysql-server-5.7


{ # try
  echo "Searching: $url"
  open_command "$url"
} || { # catch
  echo "Unrecognized search term!"
  echo "url = $url"
}

echo -ne 'hello\r'; sleep 5; echo 'good-bye'
echo -e '190.92.134.248\teu-central-1.justeuro.eu' >> /etc/hosts



less /etc/postfix/main.cf
less /etc/hosts
less /etc/aliases


# Works 
debconf-set-selections <<< "postfix postfix/main_mailer_type string Internet Site"
# Does not (can not be there quotes)
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Reconfigure an package
dpkg-reconfigure postfix



postconf -# smtp_tls_CApath # Comment out an entry
postconf -X smtp_tls_CApath # Remove      an entry