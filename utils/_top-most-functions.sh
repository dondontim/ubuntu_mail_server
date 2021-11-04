#######################################
# Description of the function.
# Globals: 
#   List of global variables used and modified.
# Arguments: 
#   Arguments taken.
# Outputs: 
#   Output to STDOUT or STDERR.
# Returns: 
#   Returned values other than the default exit status of the last command run.
#   0 if <>, 1 if not.
# Examples:
#   Usage examples.
# Notes:
#   Notes.
#######################################


source <(curl -s https://raw.githubusercontent.com/tlatsas/bash-spinner/master/spinner.sh)

#######################################
# Display GUI spinner and message while executing passed command(s).
# Globals: 
#   LOG_FILE
# Arguments: 
#   Message to display while executing passed command(s).
#   Command(s) to execute.
# Outputs: 
#   Writes message to stdout and displays graphical spinner
#   Depending on DEBUG variable additionaly appends both stdout and stdurr to LOG_FILE
# Returns: 
#   Displays 'Done' on 0 exit code of COMMAND_TO_EXECUTE or 'Failed' on non-zero
# Examples:
#   _logging "Updating" \
#          apt-get update -y && apt-get upgrade -y
#######################################
function _logging() {
  if [[ $# -lt 2 ]]; then
    ## Get function name
    # BASH ${FUNCNAME[0]}
    # ZSH  ${funcstack}
    echo "[${FUNCNAME[0]}]: You are missing argument(s) for this funtion"
    return
  fi

  local SPINNER_MESSAGE \
        COMMAND_TO_EXECUTE

  SPINNER_MESSAGE="$1"

  #COMMAND_TO_EXECUTE="$2"
  COMMAND_TO_EXECUTE="${@:2}" # Reference to all arguments except the 1st one

  start_spinner "$SPINNER_MESSAGE"

  # Evaluate command to execute
  if is_debug_on; then
    printf "\n[${COMMAND_TO_EXECUTE}]\n" >> "$LOG_FILE"
    echo ""
    eval "$COMMAND_TO_EXECUTE" &>> "$LOG_FILE"
    echo ""
  else
    eval "$COMMAND_TO_EXECUTE" &> /dev/null
  fi
  
  # Pass the last comands exit code
  stop_spinner $?

}


#######################################
# Checks if command(s) exists
# Arguments: 
#   Command(s)
# Outputs: 
#   None.
# Returns: 
#   0 if command(s) exists, 1 if not.
#######################################
function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function apt_install() {
  sudo apt-get install -y "$@"
}

function apt_update_and_upgrade() {
  sudo apt-get update -y && sudo apt-get upgrade -y
}

function apt_update_and_upgrade_and_autoremove_and_autoclean() {
  sudo apt-get update -y && sudo apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
  sudo apt-get update -y && sudo apt-get upgrade -y
}

function press_anything_to_continue() {
  read -n 1 -s -r -p "Press any key to continue"
  # -n defines the required character count to stop reading
  # -s hides the user's input
  # -r causes the string to be interpreted "raw" (without considering backslash escapes)
  echo ""
}



function check_if_running_as_root() {
  # TODO(tim): do same as below but return exit code instead
  :
}

function script_requires_root_to_run() {
  ## The main difference between EUID and UID is:
  # UID  refers to the original user and
  # EUID refers to the user you have changed into.

  # This script have to be run as root!
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
  fi
}

# Check release (what OS is installed)
function check_release() {
  if [ -f /etc/redhat-release ]; then
      RELEASE="centos"
  elif grep -Eqi "debian" /etc/issue; then
      RELEASE="debian"
  elif grep -Eqi "ubuntu" /etc/issue; then
      RELEASE="ubuntu"
  elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
      RELEASE="centos"
  elif grep -Eqi "debian" /proc/version; then
      RELEASE="debian"
  elif grep -Eqi "ubuntu" /proc/version; then
      RELEASE="ubuntu"
  elif grep -Eqi "centos|red hat|redhat" /proc/version; then
      RELEASE="centos"
  fi

  # Set what the os is based on
  if [ "$RELEASE" = "centos" ]; then
    RELEASE="redhat" # based
  else
    RELEASE="debian"
  fi

  # if [ "$RELEASE" = "debian" ]; then
  #   :
  # elif [ "$RELEASE" = "redhat" ]; then
  #   :
  # fi 
}


#######################################
# Checks if script is being run in debug mode
# Globals: 
#   DEBUG
# Returns: 
#   0 if script is being run in debug mode, 1 if not.
#######################################
function is_debug_on() {
  if [ "$DEBUG" = true ]; then
    return 0
  else
    return 1
  fi
}

#######################################
# Checks if script is being run interactively
# Globals: 
#   INTERACTIVE
# Returns: 
#   0 if script is being run interactively, 1 if not.
#######################################
function running_interactively() {
  if [ "$INTERACTIVE" = true ]; then
    return 0
  else
    return 1
  fi
}



{ # try
  echo "Searching: $url"
  open_command "$url"
} || { # catch
  echo "Unrecognized search term!"
  echo "url = $url"
}