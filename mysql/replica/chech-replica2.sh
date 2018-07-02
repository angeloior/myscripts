#!/bin/sh
#
# check stato del servizio mysql e delle repliche
#

#verifica con mail
FILEDILOG=/usr/local/log/log-check-replica.txt
mailto=

mailonerror=
# sendmail subject=" $HOSTNAME Mysql Replica"
dt=$(date)
echo "inizio $dt" >${FILEDILOG}
spia=0

#determino il numero di istanze running
numeroistanze=`ps aux | grep mysql.sock | grep -v grep | awk {'print $18'} | wc -l`
echo "numeroistanze:"$numeroistanze

if [ $numeroistanze -eq 0 ];
    then
        echo "Servizio mysql KO($numeroistanze)" >>${FILEDILOG}
        cat ${FILEDILOG} | mail -s "$subject Servizio mysql KO($numeroistanze)" $mailonerror
        exit 1
     else
        echo "Servizio mysql OK($numeroistanze)"  >>${FILEDILOG}
        #cat ${FILEDILOG} | mail -s "$subject Servizio mysql OK($numeroistanze)" $mailto
fi

#nomi delle repliche
array3=( $(echo -e 'show processlist;' | mysql -uroot -p | awk {'print $2,$3'} | grep repl | awk {'print $2'}))
echo  "${array3[@]}"

#determino la porta sulla quale ascolta mysqld
#numeroporta=`ps aux | grep mysql.sock | grep -v grep | awk {'print $18'} | awk -F"=" {'print $2'}`
numeroporta=`ps aux | grep mysql.sock | grep -v grep | awk {'print $19'} | awk -F"=" {'print $2'}`
echo "numeroporta:"$numeroporta
array=( $(ps aux | grep mysql.sock | grep -v grep | awk {'print $19'} | awk -F"=" {'print $2'} ) )

a=0
#scorro array delle istanze
for i in "${array[@]}"
do
 echo $i
 #scorro array delle repliche
 array2=( $(echo -e 'show processlist;' | mysql -hfrodo2 -P$i -uroot -p | awk {'print $2,$8$9$10$11$12$13$14$15$16$17$18$19'} | grep repl | awk -F"repl" {'print $2'}))

 for x in "${array2[@]}"
 do
   echo $x
   if [ "$x" == "Hassentallbinlogtoslave;waitingforbinlogtobeupdated" ]
   then
       echo "Processo di replica ${array3[$a]} OK" >> $FILEDILOG
      a=$a+1
   else
       echo "Processo di replica ${array3[$a]} KO" >> $FILEDILOG
       spia=1
     a=$a+1
   fi
 done

done

sendmailsubject=/usr/local/log/sendmailsubject-check-archive.txt
#mail condizionale
if [ $spia -eq 0 ];
        then
                echo "Subject:  $HOSTNAME Replica OK" > $sendmailsubject
                cat $FILEDILOG >> $sendmailsubject
                sendmail $mailto < $sendmailsubject
        else
                echo "Subject:  $HOSTNAME Replica KO" > $sendmailsubject
                cat $FILEDILOG >> $sendmailsubject
                sendmail $mailonerror < $sendmailsubject
fi