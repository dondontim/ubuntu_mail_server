#!/bin/bash
#
# Ref: https://gist.github.com/irazasyed/a7b0a079e7727a4315b9


#######################################
# Make a backup of $ETC_HOSTS and remove a hostname entry if exists.
# Globals: 
#   ETC_HOSTS
# Arguments: 
#   hostname to remove.
# Notes:
#   TODO(tim): Add $DEBUG check and adjust output
#######################################
function removehost() {
  local HOSTNAME
  # Hostname to remove.
  HOSTNAME="$1"
  if grep -q "$HOSTNAME" "$ETC_HOSTS"; then
    echo "$HOSTNAME Found in your $ETC_HOSTS, Removing now...";
    sudo sed -i".bak" "/$HOSTNAME/d" "$ETC_HOSTS"
  else
    echo "$HOSTNAME was not found in your $ETC_HOSTS";
  fi
}


#######################################
# Add provided hostname to $ETC_HOSTS.
# Globals: 
#   ETC_HOSTS
#   IP
# Arguments: 
#   hostname to add.
# Notes:
#   TODO(tim): Add $DEBUG check and adjust output
#######################################
function addhost() {
  local HOSTNAME \
        HOSTS_LINE
  # Hostname to add.
  HOSTNAME="$1"
  HOSTS_LINE="${IP}\t${HOSTNAME}"

  if grep -q "$HOSTNAME" "$ETC_HOSTS"; then
      echo "$HOSTNAME already exists : $(grep "$HOSTNAME" "$ETC_HOSTS")"
    else
      echo "Adding $HOSTNAME to your $ETC_HOSTS";
      # TODO(tim): I think below is overdone 
      #sudo -- sh -c -e "echo '${HOSTS_LINE}' >> $ETC_HOSTS";
      echo -e "$HOSTS_LINE" >> "$ETC_HOSTS";

      if grep -q "$HOSTNAME" "$ETC_HOSTS"; then
          printf "%s was added succesfully \n%s\n" \
            "$HOSTNAME" \
            "$(grep "$HOSTNAME" "$ETC_HOSTS")";
        else
          echo "Failed to Add ${HOSTNAME}, Try again!";
      fi
  fi
}
