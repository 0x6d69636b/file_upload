#!/bin/bash
# dnssec zone walking PoC
# test case: dnssec.se ns3.named.se 
#

#
# Check if arguments were given, if not, print usage
#
if [[ -z "$1" || -z "$2" ]]; then
	echo "[*] DNSSEC Zone Walking PoC"
	echo "[*] Usage : $0 <domain> <name server>"
	exit 0
fi

#
# Variables
#
DIG="/usr/bin/dig"
DOMAIN="$1."
NAMESERVER=$2
SUBDOMAIN=""
REQUEST=$DOMAIN

#
# Ask for NSEC record and try to follow the NSEC chain
# loop until the answer is equal to the domain name -> back at the top of the zone file
#
while [ "$SUBDOMAIN" != "$DOMAIN" ]
do
	SUBDOMAIN=`$DIG @$NAMESERVER NSEC $REQUEST +short | cut -d " " -f 1`
	
	if [ "$SUBDOMAIN" == "$DOMAIN" ]; then
		break
	fi
    
	if [ -z "$SUBDOMAIN" ]; then
		echo "[!] no NSEC record found"
		break
	fi
	
	REQUEST=$SUBDOMAIN    
	echo "[*] $SUBDOMAIN"
done
exit 0

