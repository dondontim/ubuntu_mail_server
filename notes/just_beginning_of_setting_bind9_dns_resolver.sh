


# Run the following command to install BIND 9, from the default repository. 
# BIND 9 is the current version and BIND 10 is a dead project.
apt-get update
apt-get install bind9 bind9utils bind9-dnsutils bind9-doc bind9-host


systemctl start named
systemctl enable named

# The BIND server will run as the bind user, which is created during installation, 
# and listens on TCP and UDP port 53, as can be seen by running the following command:
netstat -lnptu | grep named


# Usually DNS queries are sent to the UDP port 53. 
# The TCP port 53 is for responses sizes larger than 512 bytes.
#
# The BIND daemon is called named. The named binary is installed by the bind9 package 
# and there’s another important binary: rndc, the remote name daemon controller,
# which is installed by the bind9utils package. The rndc binary is used to reload/stop
# and control other aspects of the BIND daemon. Communication is done over TCP port 953.
#
# For example, we can check the status of the BIND name server.
rndc status


### Configurations for a Local DNS Resolver
#
# /etc/bind/ is the directory that contains configurations for BIND.
# 
# * named.conf: the primary config file which includes configs of three other files.
# * db.127: localhost IPv4 reverse mapping zone file.
# * db.local: localhost forward IPv4 and IPv6 mapping zone file.
# * db.empty: an empty zone file
# * The bind9 package on Ubuntu 20.04 doesn’t ship with a db.root file, 
#   it now uses the root hints file at /usr/share/dns/root.hints. 
#   The root hints file is used by DNS resolvers to query root DNS servers. 
#   There are 13 groups of root DNS servers, from a.root-servers.net to m.root-servers.net.
# 
# Out of the box, the BIND9 server on Ubuntu provides recursive service for 
# localhost and local network clients only. Outside queries will be denied. 
# So you don’t have to edit the configuration files. 


cp /etc/bind/named.conf.options

# Test the config file syntax
if named-checkconf; then
  # If the test is successful (indicated by a silent output), then restart BIND9.
  systemctl restart named
  echo 'reloading bind server'
fi


# If you have UFW firewall running on the BIND server, 
# then you need to open port 53 to allow LAN clients to send DNS queries.
ufw allow in from 192.168.0.0/24 to any port 53


journalctl -eu named