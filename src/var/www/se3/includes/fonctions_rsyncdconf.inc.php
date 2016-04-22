<?php


   /**
   * Librairie de fonctions utilisees pour la conf de rsyncd.conf

   * @Version $Id$

   * @Projet LCS / SambaEdu

   * @Auteurs plouf plouf@sambaedu.org

   * @Note: Ce fichier de fonction doit etre appele par un include

   * @Licence Distribue sous la licence GPL
   */

   /**

   * file: functions_rsyncdconf.inc.php
   * @Repertoire: includes/
   */





//=================================================

/**
* Lit dans rsyncd.conf et retourne la valeur de $Name

* @Parametres $Name
* @Return La valeur de la variable $Name definie dans /etc/rsyncd.conf
*/

function variable ($Name) { // retourne la valeur de Name
	if (file_exists("/etc/rsyncd.conf")) {
		$lignes = file("/etc/rsyncd.conf");
		foreach ($lignes as $num => $ligne) {
			if (preg_match ("/$Name=(.*)/",$ligne,$reg)) {
				$var = trim($reg[1]);
				return $var;
			}
		}
	}
} // fin function


/**
* Stop ou start rsyncd

* @Parametres stop ou start
* @Return
*/

function stopstartrsync ($etat) {
        exec("sudo /usr/share/se3/scripts/mk_rsyncconf.sh $etat");
	sleep(5);
}

/**
* Test si rsync est bien installe

* @Parametres
* @Return ok si rsync est installe
*/

function rsync_ok () {

    $rsync = exec("dpkg -l | grep rsync  > /dev/null && echo ok");
    return $rsync;
 }
 

/**
* Test si rsyncd.conf existe

* @Parametres
* @Return ok si rsyncd.conf est existe
*/

function rsyncd_conf_ok () {
    if (file_exists("/etc/rsyncd.conf")) {
        return 1;
    } else {
        return 0;
    }
 }


/**
* Recup le mot de passe de rsyncd.conf

* @Parametres
* @Return retourne le mot de passe de rsyncd
*/

function rsyncd_pass () {

    $Pass = exec("sudo /usr/share/se3/scripts/mk_rsyncconf.sh pass"); 
    return $Pass;
}

 ?>
