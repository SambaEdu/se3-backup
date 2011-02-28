<?php


   /**
   
   * Change l'uidnumber de backuppc (Backuppc)
   * @Version $Id$ 
   
   * @Projet LCS / SambaEdu 
   
   * @auteurs Philippe Chadefaux

   * @Licence Distribue selon les termes de la licence GPL
   
   * @note 
 
   */

   /**

   * @Repertoire: sauvegarde
   * file: valid_uidnumber.php

  */	



   include "entete_ajax.inc.php";   
   require ("config.inc.php");
   require ("ldap.inc.php");
   require ("ihm.inc.php");
   include ("fonction_backup.inc.php");

   require_once("lang.inc.php");
   bindtextdomain('sauvegarde',"/var/www/se3/locale");
   textdomain ('sauvegarde');


###############################################################################
# Octobre 2008
# Ajout de parametrage en Ajax pour NAS Mrt@EquipeTice.
# Scripts systeme de wawa
###############################################################################

// Verifie les droits
if (ldap_get_right("system_is_admin",$login)!="Y")
        die (gettext("Vous n'avez pas les droits suffisants pour acc&#233;der &#224; cette fonction")."</BODY></HTML>");

//aide 
$_SESSION["pageaide"]="Sauvegarde Backuppc";
if ($_POST['uidnumber'] == '')
	die('erreur');

$uidnum = ':x:'.$_POST['uidnumber'].':';
$command = `getent passwd | grep $uidnum`;


die($command);
?>
