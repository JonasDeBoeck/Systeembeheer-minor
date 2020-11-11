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

  touch "/etc/apache2/sites-available/$SUBDOMEIN.conf"

  echo "<VirtualHost *:80>" >> "/etc/apache2/sites-available/$SUBDOMEIN.conf"
  echo "	ServerAdmin webmaster@localhost" >> "/etc/apache2/sites-available/$SUBDOMEIN.conf"
  echo "	ServerName $SUBDOMEIN.jonas-deboeck.sb.uclllabs.be" >> "/etc/apache2/sites-available/$SUBDOMEIN.conf"
  echo "	ServerAlias $SUBDOMEIN.jonas-deboeck.sb.uclllabs.be" >> "/etc/apache2/sites-available/$SUBDOMEIN.conf"
  echo "	DocumentRoot /var/www/$SUBDOMEIN" >> "/etc/apache2/sites-available/$SUBDOMEIN.conf"
  echo "</VirtualHost>" >> "/etc/apache2/sites-available/$SUBDOMEIN.conf"
