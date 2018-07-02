#!/bin/sh

FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-tar-acm2-home.txt
dt=$(date)
/bin/echo "Inizio" $dt > $FILELOG

destinationfile="/share/BACKUP/acm2/home.tar"
Testo="Subject:  $HOSTNAME Tar ACM2-home"

#tar senza compressione
ssh root@acm2 "tar --exclude="*mms/GENERIC/*" --exclude="*mms/WMO/*" --exclude="*makedispo/log*" --exclude="*mms/GRIB/*" --exclude="*scheduler/log*" -c -f - /home " > $destinationfile
aux=$?

#mail condizionale
mailto=
mailonerror=
#mailonerror=$mailto
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-tar-acm2-home.txt

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
