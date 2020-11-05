#!/bin/bash
arp -s 193.191.177.254 ca:fe:c0:ff:ee:00
systemctl start add_arp_entry
systemctl enable add_arp_entry
