#! /bin/bash

NAME_ZONE=$1
echo "$NAME_ZONE"

mkdir "/etc/bind/$NAME_ZONE"
touch "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"

echo "zone \"$NAME_ZONE.jonas-deboeck.sb.uclllabs.be\" IN {" >> "/etc/bind/named.conf.local"
echo "type master;">> "/etc/bind/named.conf.local"
echo "file \"/$NAME_ZONE/db.$NAME_ZONE\";" >> "/etc/bind/named.conf.local"
echo "};" >> "/etc/bind/named.conf.local"
