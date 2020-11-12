#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run by root" >&2
        exit 1
fi

FQDN=$1
# echo "$FQDN"
SUBDOMEIN="$(cut -d'.' -f1 <<< "$1")"
ZONE="$(cut -d'.' -f2 <<< "$1")"
# echo "$SUBDOMEIN"
FILENAAM="db.$SUBDOMEIN"
# echo "$FILENAAM"
if [ -e "/etc/bind/mrt/$FILENAAM" ]
then
  mkdir "/var/www/$SUBDOMEIN"
  touch "/var/www/$SUBDOMEIN/index.html"
  echo "welcome $SUBDOMEIN.$ZONE" >> "/var/www/$SUBDOMEIN/index.html"

  touch "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"

  echo "<VirtualHost *:80>" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "	ServerAdmin webmaster@localhost" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "	ServerName $SUBDOMEIN.jonas-deboeck.sb.uclllabs.be" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "	ServerAlias $SUBDOMEIN.jonas-deboeck.sb.uclllabs.be" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "	DocumentRoot /var/www/$SUBDOMEIN" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "	ErrorLog ${APACHE_LOG_DIR}/$SUBDOMEIN-error.log" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "	CustomLog ${APACHE_LOG_DIR}/$SUBDOMEIN-access.log combined" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"
  echo "</VirtualHost>" >> "/etc/apache2/sites-available/mrt.$SUBDOMEIN.conf"

  a2ensite "mrt.$SUBDOMEIN.conf"
  systemctl reload apache2
else
  echo "The given subzone doesn't exist" >&2
  exit 1
fi
