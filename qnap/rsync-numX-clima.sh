#!/bin/sh

# -n dry run
#--delete-before
#--delete-after
#--delete-after

aux=1
FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-rsync-num.txt

SERVERNAME=NUM0-CLIMA
#data
#rsync -vaurh --exclude="*Trash*" --exclude="lost+found" --progress --delete-before root@num0-clima:/data /share/BACKUP/$SERVERNAME/rsync --log-file=$FILELOG

#home
#rsync -vaurh --exclude="*Trash*" --exclude="lost+found" --progress --delete-before root@num0-clima:/home /share/BACKUP/$SERVERNAME/rsync --log-file=$FILELOG

#work
rsync -vaurh --exclude="*Trash*" --exclude="lost+found" --progress --delete-before root@num0-clima:/work /share/BACKUP/$SERVERNAME/rsync --log-file=$FILELOG


SERVERNAME=NUM1-CLIMA
#data
rsync -vaurh --exclude="*Trash*" --exclude="lost+found" --progress --delete-before root@num1-clima:/data /share/BACKUP/$SERVERNAME/rsync --log-file=$FILELOG

#home
rsync -vaurh --exclude="*Trash*" --exclude="lost+found" --progress --delete-before root@num1-clima:/home /share/BACKUP/$SERVERNAME/rsync --log-file=$FILELOG

#work
rsync -vaurh --exclude="*Trash*" --exclude="lost+found" --progress --delete-before root@num1-clima:/work /share/BACKUP/$SERVERNAME/rsync --log-file=$FILELOG

aux=$?
#mail condizionale
mailto=
mailonerror=
subject=" QNAP-CLIMA Rsync"

if [ $aux -eq 0 ]

        then
                echo "$subject OK($aux)" >> ${FILELOG}
                echo "$subject OK($aux)" | mail -s "$subject OK($aux)" $mailto
        else
                echo "$subject KO($aux)" >> ${FILELOG}
                echo "$subject KO($aux)" | mail -s "$subject KO($aux)" $mailonerror
fi
