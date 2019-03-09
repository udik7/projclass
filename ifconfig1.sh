#!/usr/bin/env bash
#set -x 
########################################################
# created by: udi
# Version: 0.0.1
# Purpose:  extract interface + IP + mac adress from ifconfig
# Date  12/30/2018
#########################################################
			
			# printing prefernce
			divider=============================================================#
			header="\n %-10s %16s %20s \n"#
			format=" %-10s %16s %20s \n"
			width=50
			printf "$header" "INT"  "IP" "      MAC ADDRESS" 
			printf "%$width.${width}s\n" "$divider"
			command ifconfig |  grep  -v RX | grep -v TX | grep -v inet6 | grep -v loop| grep -v device  > ~/ifconfigdata
															
		while read line
		do
		# extact  interface , MAC & IP
		echo $line | grep flag |  awk '{print $1 "\t" }'   > ~/interface   ; inter=$(cat  ~/interface)
		echo $line | grep eth  |  awk '{print $2 "\t" }'   > ~/macaddress  ;   mac=$(cat  ~/macaddress)
		echo $line | grep netmask | awk '{print $2 "\t"}'  >  ~/ipaddress  ;    ip=$(cat  ~/ipaddress)
		if [[ "$ip" == 127* ]] ; then mac=NONE ; fi
		printf  "$format" "$inter"  "$ip" "$mac"  																												
		done  < ~/ifconfigdata


#ifconfig |  grep  -v RX | grep -v TX | grep -v inet6 | grep -v loop| grep -v device |awk '{print $1 $2}'		
########################################################
# created by: additional help from alex
# Version: 0.0.1
# Purpose:  ifconfig
# Date  12/30/2018
#########################################################
line="================================================================="
#format=" %-10s %-14s %13s \n"
	echo ; echo ; printf "%s\n" "$line"
#	printf "$format"  "INET" "IP" "MAC"
	printf "%s\n" "$line"
	for i in $(ifconfig -a|grep flags| awk '{print $1}'|sed 's/\:/ /')
			do
							 #inter=$(ifconfig $i | grep flag |  awk '{print $1 "\t" }')
							mac=$(ifconfig   $i | grep eth  |  awk '{print $2 "\t" }')
							ip=$(ifconfig    $i | grep netmask | awk '{print $2 "\t"}')
							printf  "$format" "$i"  "$ip" "$mac"
		done
cd ~ ; rm interface macaddress ipaddress ifconfigdata
