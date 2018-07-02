#!/bin/sh

#mail condizionale
mailto=
mailonerror=
#mailonerror=$mailto
spia=0

#server
array=(epimeteo)
array2=(/var/www/html)
Testo="Subject:  $HOSTNAME Tar $i"

#tar senza compressione
for i in "${array[@]}"
do
   
    FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-tar-$i.txt
    dt=$(date)
    /bin/echo "Inizio $i $dt" > $FILELOG
    Testo="Subject:  $HOSTNAME Tar $i"
    for x in "${array2[@]}"
     do
     ssh root@$i "tar cf - /var/www/html" > /share/BACKUP/$i/$i.tar
     aux=$?
     dt=$(date)
     echo "Fine $x $dt" >> $FILELOG
     if [ $aux -ne 0 ]
       then
         spia=1
     fi
     done

    #mail condizionale
    sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-tar-$i.txt
    if [ $spia -eq 0 ];
	then
		echo "$Testo OK" > $sendmailsubject
		cat $FILELOG >> $sendmailsubject
                echo "ciao"  >> $sendmailsubject
		sendmail $mailto < $sendmailsubject
	else
		echo "$Testo KO" > $sendmailsubject
        	cat $FILELOG >> $sendmailsubject
                 echo "ciao"  >> $sendmailsubject
        	sendmail $mailonerror < $sendmailsubject
    fi
done
