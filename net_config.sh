#!/usr/bin/env bash
#set -x 
########################################################
# created by: udi
# Version: 0.0.5
# Purpose:  create and define a new network profile
# Date  10-03-2019
#########################################################

# +++++   Functions  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

printinfo (){
	
clear ; echo ; echo  "*****   This script will helps you to define a new network profile  *****"
echo ; echo "=======  All your Hardware device are:       ============================"
nmcli device
echo ; echo "=======  Your network connections is:  ============================"
nmcli connection show 	| head -n 2
echo ; echo "=======  Your Current staus configuration is:  ==========================="
dev=$( nmcli device | grep -w "connected" |  awk '{print $1  }')  					; echo -e "Active Device is  \t "$dev
mac=$( nmcli device show $dev  | grep "GENERAL.HWADDR: " |   awk '{print $2  }')  	; echo -e "MAC Adress is \t\t  "$mac
ip=$( nmcli device show $dev  | grep "IP4.ADDRESS" |   awk '{print $2  }')  		; echo -e "Ip Adress is \t\t  "$ip
mask=$( ifconfig $dev  | grep mask |   awk '{print $4 }' ) 							; echo -e "NETMask Adress is \t  "$mask
broad=$( ifconfig $dev  | grep broadcast |   awk '{print $6 }' ) 					; echo -e "Broadcast Adress is \t  "$broad
gw=$( nmcli device show $dev  | grep "IP4.GATEWAY:" |   awk '{print $2  }')			; echo -e "Gateway Adress is \t  "$gw
dns=$( nmcli device show $dev  | grep "DNS" |   awk '{print $2  }')					; echo -e "DNS Adress is \t\t  "$dns
ssid=$( nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\: -f2)				; echo -e "SSID is \t\t  "$ssid
route=$( ip route get 4.2.2.1 |    awk '{print $3  }')      						; echo -e "Route addr. is \t\t  "$route                  
}

getconf(){

echo ; echo "=====  Let's create / Modify your network profile  ( you can use date from your current status==========================="
answer=n  ;  while [[ "$answer" != y ]]
do 
echo
read -p 'Please input wifi  or eth  ( ethernet):     ' dev1
read -p 'Please input a profile name:     ' profile
read -p 'Please input your IP addr:       ' ip 
read -p 'Please input your Gateway addr:  ' gw 
read -p 'Please input an SSID:            ' ssid 
read -s -p 'Please input an Passwd:       ' passwd
read -p 'Are all the parameters correct ?  type y  or n     '  answer
echo
done 
}

conf(){
#  wifi & ethernet configuration
wifidev=$(ifconfig | grep flag |  grep w | awk '{print $1 "\t" }' | cut -d\: -f1)
ethdev=$(ifconfig | grep flag |  grep e | awk '{print $1 "\t" }' | cut -d\: -f1)

if [[ $dev1 == "wifi" ]]
	then 
	nmcli  connection add  con-name $profile ifname $wifidev type wifi  ssid  $ssid ip4 $ip/24 gw4 $gw
	nmcli c modify $profile wifi-sec.key-mgmt wpa-psk wifi-sec.psk $passwd
	nmcli con mod  $profile +ipv4.dns "8.8.8.8 8.8.4.4"       # Adding DNS
	nmcli d connect  $wifidev
	else
	nmcli  connection add  con-name $profile ifname $ethdev type ethernet   ip4 $ip/24 gw4 $gw
	nmcli con mod  $profile +ipv4.dns "8.8.8.8 8.8.4.4"       # Adding DNS
	nmcli d connect  $ethdev
fi
}

setup_test() {
nmcli c up  $profile  								#putting connection up
echo ; echo "=======  Your network connections is:  ============================"
echo ; nmcli connection show   | head -n 2  		# testing conf
echo ; echo "  **********   Your configuration now: *************  " ; echo
command ifconfig  | grep -v TX | grep -v RX | grep -v inet6
echo "**********   Testing connection to the internet*************  " ; echo
ping -c 2 www.google.com ; echo 
}

#  Main --------------------------------------------------------

printinfo
getconf
conf
setup_test
echo ; echo "********** If you get a reply , Done succesully *************  " ; echo
