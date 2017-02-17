<?php


   /**

   * Change le proprio pour le NAS (Backuppc)
   * Ajout du support de NAS
   * @Version $Id$

   * @Projet LCS / SambaEdu

   * @auteurs Philippe Chadefaux Wawa MrT

   * @Licence Distribue selon les termes de la licence GPL

   * @note

   */

	require ("config.inc.php");
   	require_once ("functions.inc.php");
	require ("ldap.inc.php");
	require ("ihm.inc.php");
	include ("fonction_backup.inc.php");

	require_once("lang.inc.php");
	bindtextdomain('sauvegarde',"/var/www/se3/locale");
	textdomain ('sauvegarde');
        
        // HTMLPurifier
        require_once ("traitement_data.inc.php");

        $bck_user = $_POST['bck_user'];


	// Verifie les droits
	$login =isauth();
	if (ldap_get_right("system_is_admin",$login)!="Y")
       	die (gettext("Vous n'avez pas les droits suffisants pour acc&#233;der &#224; cette fonction")."</BODY></HTML>");
	
	$bck_user = trim($bck_user);
		
	
	$sql= "SELECT * FROM `params` WHERE name = 'bck_user';";
	$c = mysql_query($sql) or die("ERREUR: $sql");
	if (mysql_num_rows($c) == 0 ) {
		$sql2 = "INSERT INTO `params` ( `id` , `name` , `value` , `srv_id` , `descr` , `cat` )"
			 ."VALUES (NULL , 'bck_user', '".mysql_real_escape_string($bck_user)."', '0', 'utilisateur proprietaire backuppc', '5');";
		$c2 = mysql_query($sql2) or die("ERREUR: ".htmlspecialchars($sql2, ENT_QUOTES, 'UTF-8'));
	} else {
		$sql2 = "UPDATE `params` SET `value` = '".mysql_real_escape_string($bck_user)."' , `cat` = '5'  WHERE `params`.`name` ='bck_user' ;";
		$c2 = mysql_query($sql2) or die("ERREUR: ".htmlspecialchars($sql2, ENT_QUOTES, 'UTF-8'));
	}

	
	$bck_uidnumber = trim($_POST['bck_uidnumber']);
		
	
	$sql= "SELECT * FROM `params` WHERE name = 'bck_uidnumber';";
	$c = mysql_query($sql) or die("ERREUR: $sql");
	if (mysql_num_rows($c) == 0 ) {
		$sql2 = "INSERT INTO `params` ( `id` , `name` , `value` , `srv_id` , `descr` , `cat` )"
			 ."VALUES (NULL , 'bck_uidnumber', '".mysql_real_escape_string($bck_uidnumber)."', '0', 'uidnumber proprietaire backuppc', '5');";
		$c2 = mysql_query($sql2) or die("ERREUR: ".htmlspecialchars($sql2, ENT_QUOTES, 'UTF-8'));

	} else {
		$sql2 = "UPDATE `params` SET `value` = '".mysql_real_escape_string($bck_uidnumber)."' , `cat` = '5' WHERE `params`.`name` ='bck_uidnumber' ;";
		$c2 = mysql_query($sql2) or die("ERREUR: ".htmlspecialchars($sql2, ENT_QUOTES, 'UTF-8'));
	}


	exec ("sudo /usr/share/se3/sbin/chgbpcuser.sh");
	die("Modifications r&eacute;alis&eacute;es avec succes !");

?>
