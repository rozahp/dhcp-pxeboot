#!/bin/bash
##
## File: 	newmac.sh
##
## Description: creates a new random MAC-address with local administrated MAC bit set.
##

##
## Get local admin random positive nibbles
##

NIBBLE1=`cat /dev/urandom | hexdump | cut -d" " -f2- | head -1 | tr -d " " | tr "[[:lower:]]" "[[:upper:]]" | cut -c1`
NIBBLE2=`cat /dev/urandom | hexdump | cut -d" " -f2- | head -1 | tr -d " " | tr -d "[13579bdf]" | tr "[[:lower:]]" "[[:upper:]]" | cut -c1`

##
## Get random hex characters
##

TMPMAC=`cat /dev/urandom | hd | head -1  | cut -d " " -f3-7 | tr " " ":" | tr "[[:lower:]]" "[[:upper:]]"`

##
## Insert nibbles and create MAC-address
##

echo Newmac: $NIBBLE1$NIBBLE2:$TMPMAC

##
## EOF
##
