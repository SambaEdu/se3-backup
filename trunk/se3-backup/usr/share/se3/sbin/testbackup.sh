#!/bin/bash

#
## $Id$ ##
#
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ "$1" = "--help" -o "$1" = "-h" ]
then
	echo "Test si le disque de sauvegarde est monte"
	echo "Usage : aucune option"
	exit
fi

#init params bdd
. /usr/share/se3/includes/config.inc.sh -b

if [ "$bpcmedia" = "1" ]; then
##### Teste si le disque USB est monte #####

mount |grep "\/var\/lib\/backuppc" >/dev/null || MBPC=0
if [ "$MBPC" = "0" ]; then
	echo "Disque USB non monte"
	EXIT1=1
fi
touch /var/lib/backuppc/test 2&> /dev/null || TBPC=0
if [ "$TBPC" = "0" ]; then
	echo "Impossible d'ecrire sur le disque USB"
	EXIT1=1
fi
fi

if [ "$bpcmedia" = "3" ]; then

##### Test si le disque NAS est monte #####
# NAS_mntsuffix=`mysql se3db -u $dbuser -p$dbpass -B -N -e "select value from params where name='NAS_mntsuffix'"`
# NAS_proto=`mysql se3db -u $dbuser -p$dbpass -B -N -e "select value from params where name='NAS_proto'"`
mount |grep "\/var\/lib\/backuppc" | grep "$NAS_proto" >/dev/null || MBPC=0
if [ "$MBPC" = "0" ]; then
	echo "Disque NAS non monte"
	EXIT1=1
fi
touch /var/lib/backuppc/$NAS_mntsuffix/test 2&> /dev/null || TBPC=0
if [ "$TBPC" = "0" ]; then
	echo "Impossible d'ecrire sur le disque NAS"
	EXIT1=1
fi
fi


if [ "$1" = "cron" ]; then
	if [ -e  /var/run/backuppc/BackupPC.pid ]; then
		if [ "$bpcmedia" = "0" ]; then
			# on teste le chemin
			CHEMIN_SAV="/var/lib/backuppc"
			[ -h "$CHEMIN_SAV" ] && CHEMIN_SAV=$(readlink -e /var/lib/backuppc)
			df |grep "$CHEMIN_SAV" >/dev/null || MBPC=0
			if [ "$MBPC" = "0" ]; then
				echo "Aucune paritition montee sur $CHEMIN_SAV"
				EXIT1=1
				
			fi
	fi
	else
		if [ $backuppc = "1" ]; then
			echo "Attention, le module sauvegarde est actif mais le service backuppc est off"
			exit 1
		fi	
	exit 0
	fi

fi
	

if [ "$EXIT1" = 1 ]; then
	echo "Arret du service backuppc"
	/etc/init.d/backuppc stop 
	exit 1
fi


