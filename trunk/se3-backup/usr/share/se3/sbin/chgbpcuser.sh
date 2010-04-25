#!/bin/bash
#
##### Script de modif uid user backuppc #####
#
# Auteur: wawa - modifs keyser 22/01/10
#
## $Id: chgbpcuser.sh 5341 2010-03-17 16:48:16Z dbo $ ##
#
# /usr/share/se3/sbin/chgpbcuser.sh


#init param bdd partie sauvegarde #
. /usr/share/se3/includes/config.inc.sh -b 
. /usr/share/se3/includes/functions.inc.sh

cur_user=`grep "USER=" /etc/init.d/backuppc |cut -d= -f2`

if [ "$bck_user" = "backuppc" ]; then

#
# Modification de l'uidNumber de bckuppc
#

echo "Modification de l'uidNumber de bckuppc"

BPCN=`getent passwd backuppc | cut -d : -f3`
bck_uidnumber=`mysql se3db -u $dbuser -p$dbpass -B -N -e "select value from params where name='bck_uidnumber'"`

#sed -i "s/backuppc:x:$BPCN/backuppc:x:$bck_uidnumber/g" /etc/passwd

    if [ -z "$(grep "x:$bck_uidnumber:" /etc/passwd)" ]; then
      usermod -u $bck_uidnumber backuppc
      if [ "$?" != "0" ]; then
      bck_uidnumber=$(id backuppc -u)
      CHANGEMYSQL bck_uidnumber "$bck_uidnumber" 
      echo 
      fi
    else
      
      echo "conflit uidnumber ou uidnumber identique, pas de modif"
      bck_uidnumber=$(id backuppc -u)
      CHANGEMYSQL bck_uidnumber "$bck_uidnumber" 
      exit 1
    fi

fi

#
# Modification de la config backuppc
#

if [ "$bck_user" != "$cur_user" ]; then
	echo "Modification de la config backuppc"
	sed -i "s/USER=$cur_user/USER=$bck_user/g" /etc/init.d/backuppc
	BADLINE=`grep "BackupPCUser}" /etc/backuppc/config.pl | cut -c 2-`
	GOODLINE=`echo $BADLINE |sed -e "s/$cur_user/$bck_user/g" `
	sed -i "s/$BADLINE/$GOODLINE/g" /etc/backuppc/config.pl
	#BADLINE=`grep "CgiAdminUsers}" /etc/backuppc/config.pl | cut -c 2-`
	#GOODLINE=`echo $BADLINE |sed -e "s/$cur_user/$bck_user/g" `
	#sed -i "s/$BADLINE/$GOODLINE/g" /etc/backuppc/config.pl
fi

# Mise en place des droits
/usr/share/se3/sbin/droit_backuppc.sh
