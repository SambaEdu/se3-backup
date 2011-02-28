#!/bin/sh
#
# $Id$ #
#

#
# Deplace le repertoire /var/lib/backuppc vers un autre disque, en creant un lien symbolique
# Supprime completement une sauvegarde en fonction du nom de la machine
#


if [ -f /tmp/move_backuppc.lock ]
then
	echo "Lock trouv�"
	logger -t "BackupPc" "Lock trouv�..."
else 

  if [ "$1" = "" -o "$2" = "" ]
  then
	echo Syntaxe : move_rep_backup source destination
	logger -t "BackupPc" "Erreur : impossible de copier"
	exit;
  fi
  
  if [ "$1" = "delete" -a "$2" != "" ]
  then
    rm -Rf /var/lib/backuppc/pc/$2
    exit
  fi

  # On place un lock
  touch /tmp/move_backuppc.lock

  # On copie le r�pertoire backuppc vers la nouvelle destination
  # Cas ou on essaye de revenir dans /var/lib
  if [ "$2" = "/var/lib/backuppc" ]
  then
  	if [ -L "/var/lib/backuppc" ]
	then
		rm -f /var/lib/backuppc
	fi
  fi	
  mv $1 $2
  logger -t "BackupPc" "Repertoire d�plac� de $1 vers $2"
  
  # On recr�e le lien symb de /var/lib/backuppc
  if [ "$?" = "0" ]
  then
	if [ -L "/var/lib/backuppc" -o ! -d "/var/lib/backuppc" ]
	then
		rm -f /var/lib/backuppc
	fi	
	ln -s $2 /var/lib/backuppc 

	# On donne les droits a www-se3 sur $2
	# chown -R www-se3.root $2
	
	# On relance backuppc
	/etc/init.d/backuppc stop
	/etc/init.d/backuppc start
  else
	echo "Echec"
  fi
  # on flingue le lock
  if [ -f /tmp/move_backuppc.lock ]
  then
  	rm -f /tmp/move_backuppc.lock
  fi	
fi  

