#!/bin/sh

FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-rsync-nsed.txt
dt=$(date)
/bin/echo "Inizio" $dt > $FILELOG

#rsync parameters
opzioni="--progress -viah --log-file=$FILELOG"
sourcedir="root@172.16.1.140:/acm/"
destinationdir="/share/BACKUP/nsed/"

#rsync  
/usr/bin/rsync $opzioni $sourcedir $destinationdir 
aux=$?

#mail condizionale
mailto=
#mailonerror=
mailonerror=$mailto
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-rsync-nsed.txt

echo "Fine" $dt >> $FILELOG

#mail condizionale
if [ "$aux" -eq 0 ];
	then
		echo "Subject:  $HOSTNAME Rsync NSED" > $sendmailsubject
		cat $FILELOG >> $sendmailsubject
                echo "ciao"  >> $sendmailsubject
		sendmail $mailto < $sendmailsubject
	else
		echo "Subject:  $HOSTNAME Rsync NSED" > $sendmailsubject
        	cat $FILELOG >> $sendmailsubject
                echo "ciao"  >> $sendmailsubject
        	sendmail $mailonerror < $sendmailsubject
fi
