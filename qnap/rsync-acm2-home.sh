#!/bin/sh

aux=1
FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-rsync-acm2-home.txt
dt=$(date)
/bin/echo "Inizio" $dt > $FILELOG

#rsync parameters
esclusioni="--exclude="*mms/GENERIC/*" --exclude="*mms/WMO/*" --exclude="*makedispo/log*" --exclude="*mms/GRIB/*" --exclude="*scheduler/log*""
opzioni="--progress -viah --delete-after --delete-excluded --log-file=$FILELOG"
sourcedir="root@172.16.6.33:/home/"
destinationdir="/share/BACKUP/ACM2-VIP/home/"


#rsync  
/usr/bin/rsync $esclusioni $opzioni $sourcedir $destinationdir 
aux=$?

#mail condizionale
mailto=
mailonerror=$mailto
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-rsync-acm2-home.txt

echo "Fine" $dt >> $FILELOG

#mail condizionale
if [ "$aux" -eq 0 ];
	then
		echo "Subject:  $HOSTNAME Rsync ACM2 Home OK($aux)" > $sendmailsubject
		cat $FILELOG >> $sendmailsubject
		sendmail $mailto < $sendmailsubject
	else
		echo "Subject:  $HOSTNAME Rsync ACM2 Home KO($aux)" > $sendmailsubject
        	cat $FILELOG >> $sendmailsubject
        	sendmail $mailonerror < $sendmailsubject
fi
