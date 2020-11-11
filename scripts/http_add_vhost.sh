#!/bin/bash

FQDN=$1
# echo "$FQDN"
SUBDOMEIN="$(cut -d'.' -f1 <<< "$1")"
# echo "$SUBDOMEIN"
FILENAAM="db.$SUBDOMEIN"
# echo "$FILENAAM"
if [-e "/etc/bind/mrt/$FILENAAM" ]
then
  mkdir "/var/www/$SUBDOMEIN"
  touch "/var/www/$SUBDOMEIN/index.html"
  echo "welcome $SUBDOMEIN" >> "/var/www/$SUBDOMEIN/index.html"

  
