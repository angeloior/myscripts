#!/bin/bash
#resultlongping=`ping 172.18.28.1 -W 10 -c 5 | grep rtt | awk -F"=" {'print $2'} | awk -F"/" {'print $2'} | awk -F"." {'print $1'}`

resultlongping=`ping $1 -W 10 -c 5 | grep rtt | awk -F"=" {'print $2'} | awk -F"/" {'print $2'} | awk -F"." {'print $1'}`
#resultlongping=1201

if [ "$resultlongping" -le 1000 ] ; then	
    echo "OK - $resultlongping% of ping"
    exit 0
elif [ "$resultlongping" -gt 1000 ] && [ "$resultlongping" -le 1100 ]; then
    echo "WARNING - $resultlongping% of ping"
    exit 1
elif [ "$resultlongping" -gt 1100 ] && [ "$resultlongping" -le 10000 ]; then
    echo "CRITICAL - $resultlongping% of ping"
    exit 2
else
    echo "UNKNOWN - $resultlongping% of ping"
    exit 3
fi
