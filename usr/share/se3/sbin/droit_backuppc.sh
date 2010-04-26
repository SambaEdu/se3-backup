#!/bin/bash
## $Id: droit_backuppc.sh 5443 2010-04-25 23:41:01Z keyser $ ##
#
##### Permet de positionner les droits pour backuppc #####
#

if [ "$1" = "--help" -o "$1" = "-h" ]
then
	echo "Script permettant de positionner les droits pour backuppc."
	
	echo "Usage : pas d'option"
	exit
fi	

bck_user="backuppc"
test -e /var/run/backuppc/BackupPC.pid && bpc_etat="1"

[ ! -z "$bpc_etat" ] &&  invoke-rc.d backuppc stop
sed "s/www-se3/backuppc/" -i /etc/init.d/backuppc
[ -e /etc/backuppc/config.pl ] &&  sed "s/www-se3/backuppc/g" -i /etc/backuppc/config.pl


chown -R www-se3.backuppc /usr/share/backuppc
chown -R $bck_user.www-data /etc/backuppc
chmod -R 770 /etc/backuppc
chown $bck_user.www-data /etc/SeConfig.ph
chmod 640 /etc/SeConfig.ph
chown $bck_user /usr/share/backuppc/cgi-bin/index.cgi
chmod u+s /usr/share/backuppc/cgi-bin/index.cgi
chown -R $bck_user /var/run/backuppc
if [ -h /var/lib/backuppc ]; then
repsauve=$(readlink /var/lib/backuppc)
else
repsauve="/var/lib/backuppc"
fi
getfacl $repsauve 2>/dev/null|grep owner|grep $bck_user||chown -R $bck_user $repsauve
[ "$bpc_etat" == "1" ] &&  invoke-rc.d backuppc start

