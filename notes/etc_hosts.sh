IP='190.92.134.248'
HOSTNAME='eu-central-1.justeuro.eu'
HOSTS_LINE="${IP}\t${HOSTNAME}"
ETC_HOSTS='/etc/hosts'

sudo -- sh -c -e "echo '${HOSTS_LINE}' >> $ETC_HOSTS";
echo -e "$HOSTS_LINE" >> "$ETC_HOSTS";