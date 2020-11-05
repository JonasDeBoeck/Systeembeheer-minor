#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run by root" >&2
        exit 1
fi

function extract_subdomain_from_fqdn () {
  SUB="$(cut -d'.' -f1 <<< "$1")"
}

function db_file_exists() {
  FILE="/etc/bind/mrt/db.$1"
  if [[ -f "$FILE"  ]]; then
    return 1
  else
    echo "DB file for this subdomain does not exist"
    exit 1
  fi
}

function update_serial() {
  OLD_SERIAL=$(grep -Po '\d+\s+; Serial' "/etc/bind/mrt/db.$SUB" | grep -o '^\S*')
  NEW_SERIAL=$(("$OLD_SERIAL" + 1))
  sed -i "0,/$OLD_SERIAL/s//$NEW_SERIAL/" "/etc/bind/mrt/db.$SUB"
}

function create_a_record() {
  extract_subdomain_from_fqdn "$ZONE"
  db_file_exists "$SUB"
  echo "$DOMEIN    IN    A    $IP" >> "/etc/bind/mrt/db.$SUB"
  update_serial "$SUB"
}

function create_cname_record(){
  SUB="$(cut -d'.' -f2 <<< "$DOMEIN")"
  db_file_exists "$SUB"
  echo "$ALIAS    IN    CNAME    $DOMEIN." >> "/etc/bind/mrt/db.$SUB"
  update_serial "$SUB"
}

function create_mx_record() {
  extract_subdomain_from_fqdn "$DOMEIN"
  db_file_exists "$SUB"
  echo "        IN    MX    10    $NAME" >> "/etc/bind/mrt/db.$SUB"
  echo "$NAME    IN    A    $IP" >> "/etc/bind/mrt/db.$SUB"
  update_serial "$SUB"
}

if [[ $1 != "-t" ]]; then
  RECORD_TYPE="A"
  DOMEIN=$1
  IP=$2
  ZONE=$3
  create_a_record "$DOMEIN" "$IP" "$SUB"
else
  while getopts ":t:" opt; do
    case $opt in
      t) RECORD_TYPE="$OPTARG"
      ;;
      \?) echo "Invalid option -$OPTARG" >&2
          exit 1
      ;;
    esac
  done

  case $RECORD_TYPE in
    MX) echo "$RECORD_TYPE"
        NAME=$3
        IP=$4
        DOMEIN=$5
        create_mx_record "$NAME" "$IP" "$DOMEIN"
    ;;
    A) echo "$RECORD_TYPE"
       DOMEIN=$3
       IP=$4
       ZONE=$5
       create_a_record "$DOMEIN" "$IP" "$SUB"
    ;;
    CNAME) echo "$RECORD_TYPE"
           ALIAS=$3
           DOMEIN=$4
           create_cname_record "$ALIAS" "$DOMEIN"
    ;;
    *) echo "Invalid record type given" >&2
       exit 1
    ;;
  esac
fi

service bind9 restart
