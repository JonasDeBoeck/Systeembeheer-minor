#! /bin/bash
if [ $# -eq 0 ]
  then
    echo "No parameters supplied"
    exit 1
fi
NAME_ZONE=$1
echo "$NAME_ZONE"

touch "/etc/bind/mrt/db.$NAME_ZONE"

echo "zone \"$NAME_ZONE.jonas-deboeck.sb.uclllabs.be\" IN {" >> "/etc/bind/named.conf.mrt"
echo "type master;">> "/etc/bind/named.conf.mrt"
echo "file \"/etc/bind/mrt/db.$NAME_ZONE\";" >> "/etc/bind/named.conf.mrt"
echo "};" >> "/etc/bind/named.conf.mrt"

echo ";" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "; BIND data file for local loopback interface" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo ";" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "\$TTL    604800" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "@       IN      SOA     $NAME_ZONE.jonas-deboeck.sb.uclllabs.be. root.$NAME_ZONE.jonas-deboeck.sb.uclllabs.be. (" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                              2         ; Serial" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                         604800         ; Refresh" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                          86400         ; Retry" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                        2419200         ; Expire" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                         604800 )       ; Negative Cache TTL" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo ";" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "@       IN      NS      ns.jonas-deboeck.sb.uclllabs.be." >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "ns      IN      A       193.191.177.159" >> "/etc/bind/mrt/db.$NAME_ZONE"

service bind9 restart
