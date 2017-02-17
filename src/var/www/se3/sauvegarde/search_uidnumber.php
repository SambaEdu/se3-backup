<?php


   /**
   
   * Cherche l'uidnumber de dispo pour le NAS (Backuppc)
   * @Version $Id$ 
   
   * @Projet LCS / SambaEdu 
   
   * @auteurs Philippe Chadefaux

   * @Licence Distribue selon les termes de la licence GPL
   
   * @note 
   * 
   */

   /**

   * @Repertoire: sauvegarde
   * file: search_uidnumber.php

  */	



   include "entete_ajax.inc.php";   
   require ("config.inc.php");
   require ("ldap.inc.php");
   require ("ihm.inc.php");
   include ("fonction_backup.inc.php");

   require_once("lang.inc.php");
   bindtextdomain('sauvegarde',"/var/www/se3/locale");
   textdomain ('sauvegarde');
   
   // HTMLPurifier 
   require_once ("traitement_data.inc.php");   

    $user=$_POST[user];


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
if ($_POST['user'] == '')
	die('-1');

$user = $user.':';
$command = exec("getent passwd | grep ".escapeshellarg($user));

$arr_infos = explode(':',$command);
die($arr_infos[2]);
?>
