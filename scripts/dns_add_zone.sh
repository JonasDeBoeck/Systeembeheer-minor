#! /bin/bash
if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run by root" >&2
        exit 1
fi
if [ $# -eq 0 ]
  then
    echo "No parameters supplied" >&2
    exit 1
fi

function update_serial() {
  OLD_SERIAL=$(grep -Po '\d+\s+; Serial' "/etc/bind/db.local" | grep -o '^\S*')
  NEW_SERIAL=$(("$OLD_SERIAL" + 1))
  sed -i "0,/$OLD_SERIAL/s//$NEW_SERIAL/" "/etc/bind/db.local"
}

NAME_ZONE=$1
echo "$NAME_ZONE"

touch "/etc/bind/mrt/db.$NAME_ZONE"

echo "zone \"$NAME_ZONE.jonas-deboeck.sb.uclllabs.be\" {" >> "/etc/bind/named.conf.mrt"
echo "type master;">> "/etc/bind/named.conf.mrt"
echo "file \"/etc/bind/mrt/db.$NAME_ZONE\";" >> "/etc/bind/named.conf.mrt"
echo "allow-transfer { 193.191.177.159; };" >> "/etc/bind/named.conf.mrt"
echo "};" >> "/etc/bind/named.conf.mrt"

echo ";" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "; BIND data file for local loopback interface" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo ";" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "\$TTL    604800" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "@       IN      SOA     ns.$NAME_ZONE.jonas-deboeck.sb.uclllabs.be. root.$NAME_ZONE.jonas-deboeck.sb.uclllabs.be. (" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                              2         ; Serial" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                         604800         ; Refresh" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                          86400         ; Retry" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                        2419200         ; Expire" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "                         604800 )       ; Negative Cache TTL" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo ";" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "@       IN      NS      ns.jonas-deboeck.sb.uclllabs.be." >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "@	      IN      A       193.191.177.159" >> "/etc/bind/mrt/db.$NAME_ZONE"
echo "ns      IN      A       193.191.177.159" >> "/etc/bind/mrt/db.$NAME_ZONE"

echo "$NAME_ZONE  IN  NS ns.jonas-deboeck.sb.uclllabs.be." >> "/etc/bind/db.local"

update_serial

service bind9 restart
