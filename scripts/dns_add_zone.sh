#! /bin/bash

NAME_ZONE=$1
echo "$NAME_ZONE"

mkdir "/etc/bind/$NAME_ZONE"
[[ $SUDO_USER ]] && chown "$SUDO_USER" "/etc/bind/$NAME_ZONE"

touch "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
[[ $SUDO_USER ]] && chown "$SUDO_USER" "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"

echo "zone \"$NAME_ZONE.jonas-deboeck.sb.uclllabs.be\" IN {" >> "/etc/bind/named.conf.local"
echo "type master;">> "/etc/bind/named.conf.local"
echo "file \"/etc/bind/$NAME_ZONE/db.$NAME_ZONE\";" >> "/etc/bind/named.conf.local"
echo "};" >> "/etc/bind/named.conf.local"

echo ";" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "; BIND data file for local loopback interface" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo ";" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "$TTL    604800" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "@       IN      SOA     $NAME_ZONE.jonas-deboeck.sb.uclllabs.be. root.$NAME_ZONE.jonas-deboeck.sb.uclllabs.be. (" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "                              2         ; Serial" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "                         604800         ; Refresh" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "                          86400         ; Retry" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "                        2419200         ; Expire" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "                         604800 )       ; Negative Cache TTL" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo ";" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "@       IN      NS      ns.jonas-deboeck.sb.uclllabs.be." >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"
echo "ns      IN      A       193.191.177.159" >> "/etc/bind/$NAME_ZONE/db.$NAME_ZONE"

service bind9 restart
