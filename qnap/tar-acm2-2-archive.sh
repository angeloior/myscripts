#!/bin/bash


#mail parameters
mailto=
mailonerror=
#mailonerror=$mailto

#anni presenti in acm2-2 da copiare in nas
#aux=`ssh root@acm2 "ls -l /archive" | awk '{print $9}' | grep -e [12]`    #>>test.txt
array=( $(ssh root@acm2-2 "ls -l /archive" | awk '{print $9}' | grep -e [12] | grep -v 2015) )
#echo $aux
#echo "${array[@]}"

#scorro array2 alla ricerca anno in array acm2-2
for x in "${array[@]}"
do

  #resetto il log
  FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-tar-archive$x.txt
  /bin/echo "Inizio $dt" > $FILELOG
  
  #tar 
  ssh root@acm2-2 "tar cf - /archive/$x" > /share/CACHEDEV1_DATA/BACKUP/acm2-2/$x.tar
  aux=$?

  dt=$(date)
  echo "Fine" $dt >> $FILELOG
  sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-tar-archive$x.txt

   #mail condizionale
   if [ $aux -eq 0 ];
        then
                echo "Subject:  $HOSTNAME Tar $x OK($aux)" > $sendmailsubject
                cat $FILELOG >> $sendmailsubject
                echo "Ciao" >> $sendmailsubject
                sendmail $mailto < $sendmailsubject
        else
                echo "Subject:  $HOSTNAME Tar $x KO($aux)" > $sendmailsubject
                cat $FILELOG >> $sendmailsubject
                echo "Ciao" >> $sendmailsubject
                sendmail $mailonerror < $sendmailsubject
   fi


done
