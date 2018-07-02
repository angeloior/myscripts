#!/bin/bash

FILEREPORT=/share/CACHEDEV1_DATA/homes/admin/log/report-check-archive.txt
dt=$(date)
/bin/echo "Inizio $dt" > $FILEREPORT

#anni da verificare rispetto ad acm2-2
array=(1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014)

#assegnazione temp
trovato="Ciao"
aux=1
spia=1
dt=$(date)

#scorro array2 alla ricerca anno in array acm2-2
for x in "${array[@]}"
do

  #resetto il log
  FILELOG=/share/CACHEDEV1_DATA/homes/admin/log/log-check-archive$x.txt
  /bin/echo "Inizio $dt" > $FILELOG

  #rsync dry-run per verifica differenze tra gli lv archive
  #(v)erbose (i)temize per i simboli nel log (a)rchive modalitia copia (h)uman readable le dimensioni
  #contenuto della cartella remota /archive/XXXX/* nella cartella /archive/XXXX/
  rsync  --exclude "lost+found" --dry-run --progress -viah --log-file=$FILELOG root@172.16.6.32:/archive/$x/ /share/CACHEDEV1_DATA/BACKUP/ACM2-2/archive/$x/
  
  aux=$?
  #ho copiato roba
  roba=`cat $FILELOG | wc -l`
  if [ $roba -eq 4 ] && [ $aux -eq 0 ]
     then
       spia=0
       dt=$(date)
       trovato="$x Sincronizzato ($aux), fine $dt"
     else
       trovato="$x NON sincronizzato ($aux), fine $dt"
  fi

#esito ricerca nell array
/bin/echo $trovato >> $FILEREPORT

done

dt=$(date)
echo "Fine" $dt >> $FILELOG

#mail parameters
mailto=
mailonerror=$mailto
sendmailsubject=/share/CACHEDEV1_DATA/homes/admin/log/sendmail-check-archive.txt

#mail condizionale
if [ "$aux" -eq 0 ];
        then
                echo "Subject:  $HOSTNAME Check sincronizzazione archive NAS-ACM2-2 OK($aux)" > $sendmailsubject
                cat $FILEREPORT >> $sendmailsubject
                sendmail $mailto < $sendmailsubject
        else
                echo "Subject:  $HOSTNAME Check sincronizzazione archive NAS-ACM2-2 KO($aux)" > $sendmailsubject
                cat $FILEREPORT >> $sendmailsubject
                sendmail $mailonerror < $sendmailsubject
fi
