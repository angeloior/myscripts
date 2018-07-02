#!/bin/bash
#
# Script per il backup di sistema in single user
#
#PERCORSO_OUT1="/"
#PERCORSO_OUT2="/var"
PERCORSO_OUT="/mnt"
FILE_LOG="/usr/local/log/backup1.log"

LIVELLO=`runlevel`

if [ "$LIVELLO" != "unknown" ]; then
	echo "Attenzione, sistema non in single-user mode, backup non consistente!"
	echo "Vuoi procedere ugualmente?"
	select sn in "Si" "No"; do
		case $sn in
			Si ) break;;
			No ) exit;;
		esac
done
fi

mount /dev/sda2 /mnt

mkdir /usr/local/log
rm -f $FILE_LOG
touch $FILE_LOG 
tailf $FILE_LOG &

#oldstyle
#dump -0uf - /var 2>>$FILE_LOG | bzip2 -q > $PERCORSO_OUT1/var.dmp.bz2
#mv $PERCORSO_OUT1/var.dmp.bz2 $PERCORSO_OUT2
#dump -0uf - /boot 2>>$FILE_LOG | bzip2 -q > $PERCORSO_OUT2/boot.dmp.bz2
#dump -0uf - / 2>>$FILE_LOG | bzip2 -q > $PERCORSO_OUT2/root.dmp.bz2

#new style
dump -0uf $PERCORSO_OUT/root.dmp / 2>>$FILE_LOG
dump -0uf $PERCORSO_OUT/boot.dmp /boot 2>>$FILE_LOG
dump -0uf $PERCORSO_OUT/var.dmp /var 2>>$FILE_LOG

kill %1
umount /mnt

