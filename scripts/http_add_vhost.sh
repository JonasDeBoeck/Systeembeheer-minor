#!/bin/bash

FQDN=$1
# echo "$FQDN"
SUBDOMEIN="$(cut -d'.' -f1 <<< "$1")"
echo "$SUBDOMEIN"
