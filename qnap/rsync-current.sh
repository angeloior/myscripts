#!/bin/bash

#rsync
#(v)erbose (i)temize per i simboli nel log (a)rchive modalit copia (h)uman readable le dimensioni

aux=1
FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-rsync-current.txt
dt=$(date)
/bin/echo "Inizio" $dt > $FILELOG

#rsync parameters
esclusioni="--exclude="lost+found""
opzioni="--progress -viah --log-file=$FILELOG"
sourcedir="root@172.16.6.32:/archive/2015/"
destinationdir="/share/CACHEDEV1_DATA/BACKUP/ACM2-2/archive/2015/"

#rsync
/usr/bin/rsync $esclusioni $opzioni $sourcedir $destinationdir
aux=$?
echo "Fine" $dt >> $FILELOG

#mail parameters
mailto=
mailonerror=
#mailonerror=$mailto
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-rsync-current.txt

#mail condizionale
if [ "$aux" -eq 0 ];
        then
                echo "Subject:  $HOSTNAME Rsync anno 2015 OK($aux)" > $sendmailsubject
                cat $FILELOG >> $sendmailsubject
                sendmail $mailto < $sendmailsubject
        else
                echo "Subject:  $HOSTNAME Rsync anno 2015 KO($aux)" > $sendmailsubject
                cat $FILELOG >> $sendmailsubject
                sendmail $mailonerror < $sendmailsubject
fi
