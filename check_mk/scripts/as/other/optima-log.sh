#!/bin/bash

#echo "<<<local_optima-log>>>"

#Got this script from Manfred, Written for Project Dirif in the first place!
PYTHON_BIN="/bin/python3.4"

AS_HOME='/opt/ptv-optima-as'
LOG_DIR=$AS_HOME"/standalone/log"

AS_LOG=$LOG_DIR"/server.log"
OPTIMA_LOG=$LOG_DIR"/optima.log"

#INRIX_LOG=$LOG_DIR"/optima-dataInterface.log"
INRIX_LOG=$LOG_DIR"/server.log"
DATEX2_LOG=$LOG_DIR"/optima-datex2.log"
DBWORKER_LOG=$LOG_DIR"/optima-dbworker.log"
HARMONIZER_LOG=$LOG_DIR"/optima-harmonizer.log"

OPTIMA_PUT=$LOG_DIR"/optima-put.log"
OPTIMA_WSI=$LOG_DIR"/optima-wsi.log"


#################################### Harmonizer #################################################

FINISH_LINE=$(egrep 'Process finished.' $HARMONIZER_LOG | tail -n 1)
FINISH_ID=$(echo $FINISH_LINE | awk '{print $5,$6,$7,$8 }')
START_LINE=$(grep -e "$FINISH_ID Starting process." $HARMONIZER_LOG | tail -n 1)

$PYTHON_BIN ./lineformat.py "harmonizer" "Harmonizer" "$START_LINE" "$FINISH_LINE" 5 10 40


#################################### Inrix START-STOP #######################################################

#Lines from optima-dataInterface.log
#2016-12-15 10:38:30,509 INFO  [com.sistemaits.datainterfaces.datex.process.AdiProcess] (Thread-277) Starting [Traffic State INRIX]
#2016-12-15 10:38:32,385 INFO  [com.sistemaits.datainterfaces.datex.process.AdiProcess] (Thread-277) Done [Traffic State INRIX]

FINISH_LINE=$(egrep 'Done \[Traffic State INRIX\]' $INRIX_LOG | tail -n 1)
FINISH_ID=$(echo $FINISH_LINE | awk '{print $5 }')
START_LINE=$(grep -e "$FINISH_ID Starting \[Traffic State INRIX\]" $INRIX_LOG | tail -n 1)

#lineformat.py checkname servicename STARTLINE FINISHLINE warn_minutes_ago critical_minutes_ago critical_execution_time_seconds
$PYTHON_BIN ./lineformat.py "inrix" "Inrix" "$START_LINE" "$FINISH_LINE" 5 10 5

#################################### TraffficStateInrix Provider #######################################################

FINISH_LINE=`egrep '\[com.sistemaits.optima.adi.providers.inrix.TrafficStateInrixProvider\] \(Thread-[0-9]*\) Found [0-9]* closed segment' $AS_LOG | tail -n 1`
FINISH_ID=`echo $FINISH_LINE | awk '{print $5 }'`
TMP_LOG=/tmp/tmp.log
egrep "\[com.sistemaits.optima.adi.providers.inrix.TrafficStateInrixProvider\] \($FINISH_ID\)" $AS_LOG > $TMP_LOG

#Verify Time to load Inrix traffic
STRING_INRIX_TRAFFIC_TIME=`grep "Total time to load Inrix data from server" $TMP_LOG |awk '{print $14}' |sed -e "s/PT\([0-9]*\.[0-9]*\)S/\1/g"`

#Verify Time to Parse Inrix traffic
STRING_INRIX_TIME_PARSE=`grep "Time to parse Inrix data" $TMP_LOG |awk '{print $11}'|sed -e "s/PT\([0-9]*\.[0-9]*\)S/\1/g"`

#Verify elements from Provider
NUM_ELEMENTS=`grep "elements from Provider" $TMP_LOG | awk '{print $7}'`

if [ `echo $STRING_INRIX_TRAFFIC_TIME'<=45' | bc -l`  ]; then
  echo 0 "optima-log-inrix_traffic_time" count=${STRING_INRIX_TRAFFIC_TIME:2:7} OK - inrix_traffic_time=${STRING_INRIX_TRAFFIC_TIME:0:7} seconds \(Max: 45\)
else
  echo 2 "optima-log-inrix_traffic_time" count=${STRING_INRIX_TRAFFIC_TIME:2:7} ERROR - inrix_traffic_time=${STRING_INRIX_TRAFFIC_TIME:0:7} seconds \(Max: 45\)
fi

if [ `echo $STRING_INRIX_TIME_PARSE'<=10' | bc -l` ]; then
  echo 0 "optima-log-inrix_time_parse" count=${STRING_INRIX_TIME_PARSE:2:7} OK - inrix_time_parse=${STRING_INRIX_TIME_PARSE:0:7} seconds \(Max: 10\)
else
  echo 2 "optima-log-inrix_time_parse" count=${STRING_INRIX_TIME_PARSE:2:7} ERROR - inrix_time_parse=${STRING_INRIX_TIME_PARSE:0:7} seconds \(Max: 10\)
fi

if [ `echo $NUM_ELEMENTS'<=30000' | bc -l` ]; then
  echo 0 "optima-log-inrix_elements_provider" count=$NUM_ELEMENTS OK - inrix_elements_provider=$NUM_ELEMENTS \(Max: 30000\)
else
  echo 2 "optima-log-inrix_elements_provider" count=$NUM_ELEMENTS ERROR - inrix_elements_provider=$NUM_ELEMENTS \(Max: 30000\)
fi

