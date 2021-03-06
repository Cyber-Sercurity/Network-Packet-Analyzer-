#!/bin/bash
#
#A network packet analyzer which captures information of the hostname which is currently connected 
#The current network displays the Network configuration status and packet info on local ethernet connections
#Also displays the tcp/udp connections and the state of the connection including the packet information
#Then promts the user for input for the customed connection which will:
#1 traceroute the server #2 ping the server #3 live IP connections on the server #4 open and closed port types either UDP or TCP 
#Opening Script
   echo "*****Welcome to Network Packet Analyzer!*****"
   echo "To Display information of the Hostname and Network Confirguration on the currently connected network (Press I)"
   read I
   if [ $I ]
   then
#Display Hostname currently connected to
hostname=$(hostname --long)
      echo "Hostname server on: $hostname"
#IP Addres currently connected to
ifconfig=$(ifconfig -a)
   echo "Network Configuration....." 
   echo "$ifconfig"
      else 
      echo "Skipping current Network Informaton--->"
   fi
	RUNNING=true;

echo "This program will display the status of local network connections!"

#loop to run program
while [ $RUNNING ]
do
   echo "Enter in connection type that you would like to search"
   echo "Type exit to quit" 
   
   # variable to store word
   read SEARCH
   
   if [ $SEARCH = exit ] # if search = exit kill the program
   then                  
      echo "Program terminated"
      break
   
   elif [ $SEARCH = clear ] # command to clear screen
   then
      echo "Clearing screen ... "
      sleep 1
      clear
      echo "Screen was cleared  :)"
   
   else # execute search   
      
      echo " ENTER STATUS (ESTABLISHED/LISTEN/WAITING)"
      read STATUS
      # if the user chooses yes  
      if [ $STATUS != NULL ]
      then
       
         # searches for exact word entered in and statuts and prints out format
         echo "getting info from system..."       
         netstat -a | grep -w $SEARCH | grep -w $STATUS | awk '{print $1,"      ", $2,"      ", $3, "      ", $6}'

      else
        # searches for exact word entered in and prints out format
	echo "getting info from system..."       
        netstat -a | grep -w $SEARCH | awk '{print $1,"      ", $2,"      ", $3, "      ", $6}'

      fi

      echo " remove connections that are not transmitting? "
    
      read SEND

      if [ $SEND = yes ]
      then
           netstat -a | grep -w $SEARCH | grep -w $STATUS | awk ' $3 > 0 ' | awk '{print $1,"      ", $2,"      ", $3, "      ", $6}'
   
      else
           echo "NOPE"
      fi
   fi 

done 
#Using netstat -s to show packet flow in the server

   echo "The UDP and TCP connection packets"
   echo "Enter UDP or TCP: For UDP press u. For TCP press t."

   read choice
   if [ $choice = u  ]
   then
      echo "******Total UDP Connections******"
      netstat -su $host_name

   elif [ $choice = t ]
   then
      echo "******Total TCP Connections******"
      netstat -st $host_name
   fi

#traceroute user input server
skip=$D 
   echo -n "Enter a host name which you would like to track network connections and packet traffic: "
read host_name
total_hops=`traceroute $host_name | tail -n 1 | cut -d " " -f 1 `
   echo "Press Enter to skip total hops or H to show the total hops away from the server"
   read H
   if [ $H ]
   then
      echo "The host $host_name is: $total_hops hops away."
   else 
      echo "Total hops skipped--->"
   fi
# detailed tracrout on the user inputed server gives information of connection time and IP addresses on the server
detailed_traceroute=`traceroute $host_name`
   echo "Press Enter to skip tracroute or D for - Detailed summary for the traceroute: "
   read skip
   if [ $skip ]
   then
      echo "Detailed summary of traceroute: $detailed_traceroute"
   else
      echo "Traceroute Skipped--->"
   fi
#Pinging the inputed server
count=c
   echo "How many times would you like to ping the server? "
   read c
   if ping -c $c  -W $c "$host_name"; then
      echo "$host_name connection is ALIVE"
   else
      echo "$host_name connection is DOWN"
   fi

#Using nmap -sP for the live IP address unblocked on broadcast address for the host server
   echo "Would You like to Display the Live connected IP addresses on the network?(Y/N)"
   read response
   if [ $response = Y ]
   then
      echo "******Live connected IP addresses on the network******"
      nmap -sP $host_name > /dev/null 2>&1 && arp -an | grep -v incomplete | awk '{print$2}' | sed -e s,\(,, | sed -e s,\),,
   else
      echo "IP addresses skipped--->"
   fi 
#Using nmap -sT for open connections on the network and display the user input of open ports or closed ports 
   echo -n "******Open and Closed Ports on the network******"
   echo " "
   echo "Enter o for Open Ports or c for Closed Ports:"
   read Connection
   if [ $Connection = o ]
   then
       echo "Open ports: "
       nmap -sT $host_name | grep "open"
       else [ $Connection = c ]
       echo "Closed ports: "
       nmap -sT $host_name | grep "closed"
   fi
# Checks the valid ports and there connections to the Host and if user input is not valid a connection will be timed out
Port=$Port
   echo -n "Enter to check one of the above port connection:"
   read Port
   echo "$host_name $Port" | (
   TCP_TIMEOUT=3
   while read host_name Port; do
    (CURPID=$BASHPID;
    (sleep $TCP_TIMEOUT;kill $CURPID) &
    exec 3<> /dev/tcp/$host_name/$Port
    ) 2>/dev/null
    case $? in
    0)
      echo $host_name $Port is open;;
    1)
      echo $host_name $Port is closed;;
    2) # killed
      echo $host_name $Port timeouted;;
      esac
  done
) 2>/dev/null
