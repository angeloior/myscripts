#!/bin/bash
#
# Script per il backup di sistema in single user
#
PERCORSO_OUT1="/home/pozzo/32/backup/bilbo1/"
FILE_LOG="/usr/local/log/backup1.log"

LIVELLO=`runlevel`

if [ "$LIVELLO" != "1 S" ]; then
	echo "Attenzione, sistema non in single-user mode, backup non consistente!"
	echo "Vuoi procedere ugualmente?"
	select sn in "Si" "No"; do
		case $sn in
			Si ) break;;
			No ) exit;;
		esac
done
fi

#mount /dev/sdao2 /mnt

#rc=$?
#if [ "$rc" != "0" ]; then
#	echo "Errore mount"
#		exit $rc
#fi

mkdir /usr/local/log
rm -f $FILE_LOG
touch $FILE_LOG 
tailf $FILE_LOG &

dump -0uf - /boot 2>>$FILE_LOG | ssh root@mmsdev "cat > $PERCORSO_OUT1/boot.dmp"
dump -0uf - / 2>>$FILE_LOG | ssh root@mmsdev"cat > $PERCORSO_OUT1/root.dmp"
dump -0uf - /var 2>>$FILE_LOG | ssh root@mmsdev "cat > $PERCORSO_OUT1/var.dmp"

kill %1

#umount /mnt

