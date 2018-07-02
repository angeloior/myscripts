#!/bin/bash
RETURN_OK=0
RETURN_WARNING=1
RETURN_CRITICAL=2
RETURN_UNKNOWN=3

MIN_NUM_FILE=50
MAX_NUM_FILE=300
IPADDRESS=$1

DIR="/home/prometeo/Input/Catop"

NUM_FILE=$(ssh $IPADDRESS /bin/ls -l /home/prometeo/Input/Catop/ | grep .GIF | wc -l)

if [ "${NUM_FILE}" -gt "$((${MAX_NUM_FILE}*2))" ];
then
        echo "CRITICAL - Il numero di file in ${DIR} è maggiore del doppio del massimo previsto: ${NUM_FILE} file"
        exit ${RETURN_CRITICAL}
elif [ "${NUM_FILE}" -eq 0 ];
then
        echo "UNKNOWN - Il numero di file in ${DIR} è zero"
        exit ${RETURN_UNKNOWN}
elif [ "${NUM_FILE}" -lt "${MIN_NUM_FILE}" ];
then
	echo "WARNING - Il numero di file in ${DIR} è minore del minimo previsto: ${NUM_FILE} file"
	exit ${RETURN_WARNING}
elif [ "${NUM_FILE}" -gt "${MAX_NUM_FILE}" ];
then
	echo "WARNING - Il numero di file in ${DIR} è maggiore del massimo previsto: ${NUM_FILE} file"
        exit ${RETURN_WARNING}
else
	echo "OK - Il numero di file in ${DIR} è di ${NUM_FILE}"
        exit ${RETURN_OK}
fi
