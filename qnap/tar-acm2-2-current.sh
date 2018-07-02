#!/bin/sh

aux=1
FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-tar-acm2-2-current.txt
dt=$(date)
/bin/echo "Inizio" $dt > $FILELOG

destinationfile=/share/BACKUP/acm2-2/archive-2015.tar
Testo="Subject:  $HOSTNAME Tar ACM2-2 archive-2015"

#tar senza compressione
ssh root@acm2-2 "tar -c -f - /archive/2015 " > $destinationfile
aux=$?

#mail condizionale
mailto=
mailonerror=
#mailonerror=$mailto
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-tar-acm2-2-current.txt

echo "Fine" $dt >> $FILELOG

#mail condizionale
if [ "$aux" -eq 0 ];
	then
		echo "$Testo OK($aux)" > $sendmailsubject
		cat $FILELOG >> $sendmailsubject
                echo "ciao" >> $sendmailsubject
		sendmail $mailto < $sendmailsubject
	else
		echo "$Testo KO($aux)" > $sendmailsubject
        	cat $FILELOG >> $sendmailsubject
                echo "ciao" >> $sendmailsubject
        	sendmail $mailonerror < $sendmailsubject
fi
