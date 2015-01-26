#!/bin/bash

#
## $Id$ ##
#
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin


#init params bdd
. /usr/share/se3/includes/config.inc.sh -b

if [ "$1" = "--help" -o "$1" = "-h" ]
then
	echo "Test si le disque de sauvegarde est monte"
	echo "Usage : aucune option"
	exit
fi

function free_space
{
libre=$(($(stat -f --format="%a*%S/1048576" /var/lib/backuppc))) 
if [ "$libre" -lt 15000 ];then
	echo "Espace insuffisant sur /var/lib/backuppc : $libre Mo"
	EXIT1=1
fi
}

function stop_service
{
echo "Arret du service backuppc"
/usr/share/se3/scripts/startbackup stop
exit 1
}

function test_media
{

if [ "$bpcmedia" = "0" ]; then
			# on teste le chemin
			CHEMIN_SAV="/var/lib/backuppc"
			[ -h "$CHEMIN_SAV" ] && CHEMIN_SAV=$(readlink -e /var/lib/backuppc)
			df |grep "$CHEMIN_SAV" >/dev/null || MBPC=0
			if [ "$MBPC" = "0" ]; then
				echo "Aucune partition montee sur $CHEMIN_SAV"
				EXIT1=1
			fi
			
			
elif [ "$bpcmedia" = "1" ]; then
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
	
	
elif [ "$bpcmedia" = "3" ]; then
	
	##### Test si le disque NAS est monte #####
	# NAS_mntsuffix=`mysql se3db -u $dbuser -p$dbpass -B -N -e "select value from params where name='NAS_mntsuffix'"`
	# NAS_proto=`mysql se3db -u $dbuser -p$dbpass -B -N -e "select value from params where name='NAS_proto'"`
	mount |grep "\/var\/lib\/backuppc" | grep "$NAS_protocol" >/dev/null || MBPC=0
	if [ "$MBPC" = "0" ]; then
		echo "Disque NAS non monte"
		EXIT1=1
	fi
	touch /var/lib/backuppc/$NAS_mntsuffix/test 2&1> /dev/null || TBPC=0
	if [ "$TBPC" = "0" ]; then
		echo "Impossible d'ecrire sur le disque NAS"
		EXIT1=1
	fi
	
fi
free_space
}


if [ "$1" = "cron" ]; then
	if [ -e  /var/run/backuppc/BackupPC.pid ]; then
		test_media
		[ "$EXIT1" = "1" ] && stop_service
	else
		if [ $backuppc = "1" ]; then
			if [ ! -e /tmp/alerte-backuppc ]; then
				
				echo "Attention, le module sauvegarde est actif mais le service backuppc est off"
				touch /tmp/alerte-backuppc
				EXIT1=1
			else
				/usr/bin/find /tmp/ -maxdepth 1 -type f -name "alerte-backuppc" -ctime +1 -delete 
			fi
		fi	
	
	fi
else
	test_media
	[ "$EXIT1" = "1" ] && exit 1
fi




	
exit 0
