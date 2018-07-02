#!/bin/sh

#mail condizionale
mailto=
mailonerror=
#mailonerror=$mailto
FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-tar-klima.txt
Testo="Subject:  $HOSTNAME Tar KLIMA"
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-tar-klima.txt
dt=$(date)
/bin/echo "Inizio $dt" > $FILELOG
mountpoint=/share/CACHEDEV1_DATA/homes/admin/mountpoint-klima
catalogfile=/share/BACKUP/klima/catalogfile.txt

#umount
umount $mountpoint 

#mount
mount.cifs //172.16.100.122/SegreKlima $mountpoint -o username=,domain=,password=
auxx=$?

if [ $auxx -ne 0 ];
then
                echo "$Testo KO($auxx)" > $sendmailsubject
                cat $FILELOG >> $sendmailsubject
                echo "dummy" >> $sendmailsubject
                sendmail $mailonerror < $sendmailsubject
                exit 0
fi

#tar senza compressione
#tar cf /share/BACKUP/klima/klima-segreklima.tar $mountpoint 
tar --listed-incremental=$catalogfile -c -f /share/BACKUP/klima/klima-segreklima.tar $mountpoint
aux=$?
dt=$(date)
echo "Fine $x $dt" >> $FILELOG

#umount
umount $mountpoint 

#mail condizionale
    if [ $aux -eq 0 ];
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
