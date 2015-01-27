#!/bin/bash

#
## $Id$ ##
#
##### Démonte le disque USB ou NAS #####
#

if [ "$1" = "--help" -o "$1" = "-h" ]
then
	echo "D&#233;monte le disque USB/NAS"
	echo "Usage : aucune option"
	exit
fi

#init params bdd
. /usr/share/se3/includes/config.inc.sh -b

if [ "$bpcmedia" = "3" ]; then
	NAS_mntsuffix=`mysql se3db -u $dbuser -p$dbpass -B -N -e "select value from params where name='NAS_NAS_mntsuffix'"`
else
	$NAS_mntsuffix=""
fi

echo "Deconnexion du disque de sauvegarde en cours..."
/etc/init.d/backuppc stop > /dev/null
sleep 2
ps auxw |grep backuppc | grep www-se3 >/dev/null && killall -9 "/usr/bin/perl"
mount |grep "\/var\/lib\/backuppc" >/dev/null || MBPC=0
if [ ! "$MBPC" = "0" ]; then
	umount /var/lib/backuppc/$NAS_mntsuffix
fi
mount |grep "\/var\/lib\/backuppc" >/dev/null && EXIT1=1
if [ "$EXIT1" = 1 ]; then
	echo "Impossible de d&#233;monter le disque de sauvegarde" 
	echo "Impossible de d&#233;monter le disque de sauvegarde" | mail -s "Erreur sauvegarde se3" root
	exit 1
fi
