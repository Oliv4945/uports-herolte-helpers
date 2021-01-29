#!/bin/bash


usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] interface_name

Setup UBport configuration for Samsung Galaxy S7 (herolte)

Available options:

-h, --help      Print this help and exit
EOF
  exit
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  usage
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

# Parse args
parse_params "$@"
INTERFACE_NAME="$1"
PHONE_IP="10.15.19.82"

# Setting the interface MAC & IP
msg "Setting interface \"$INTERFACE_NAME\"."
ip link set "$INTERFACE_NAME" address 02:01:02:03:04:08
ip address add 10.15.19.100/24 dev $INTERFACE_NAME
ip link set $INTERFACE_NAME up

# Sending the files to be executed on the phone
scp ./helper-install-phone.sh "phablet@$PHONE_IP":/home/phablet/
scp ./70-herolte.rules "phablet@$PHONE_IP":/home/phablet/
msg "Connecting to phone via SSH"
ssh "phablet@$PHONE_IP"
