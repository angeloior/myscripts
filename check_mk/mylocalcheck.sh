#!/bin/bash

#echo "<<<mylocalcheck>>>"
kpidcount=$(/bin/psql -t -h 10.0.23.6 -p 5432 -d optima -U postgres -c "select count(idno) from kpid")
aux=$(echo $kpidcount)
mystatus=0
itemname=myfirstcheckc
#varname=value;warn;crit
warnvalue=1346
critvalue=1347
##0 for OK, 1 for WARNING, 2 for CRITICAL and 3 for UNKNOWN

echo "$mystatus $itemname count=$aux;$warnvalue;$critvalue;0;1; myfirstcheck value are:$aux"
