#!/bin/sh

#mail condizionale
mailto=
mailonerror=$mailto
Testo="Subject:  $HOSTNAME TEST"
FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-tar-klima.txt
#mail condizionale
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-test.txt

		echo "$Testo OK" > $sendmailsubject
		cat $FILELOG >> $sendmailsubject
                #necessario spazio finale
                echo "Ciao" >> $sendmailsubject
		/usr/sbin/sendmail $mailto < $sendmailsubject
