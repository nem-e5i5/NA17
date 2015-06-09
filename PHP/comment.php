<?php 
include "connect.php";
$vConn = fConnect();

	ob_start();
	session_start(); 

	$action="";
	if(!empty($_GET["action"])){
		$action= $_GET["action"];
	}
	
	$id=0;
	if(!empty($_GET["id"])){
		$id= $_GET["id"];
	}

	if($action!="" and $id!=""){
		if($action=="supprimer"){
			$vSql =	"UPDATE COMMENTAIRE SET statut='supprime', modi='$_SESSION[login]' WHERE id=$id;";
		};

		if($action=="masquer"){
			$vSql =	"UPDATE COMMENTAIRE SET statut='masque', modi='$_SESSION[login]' WHERE id=$id;";
		};

		if($action=="exergue"){
			$vSql =	"UPDATE COMMENTAIRE SET statut='exergue', modi='$_SESSION[login]' WHERE id=$id;";
		};

		if($action=="recuperer"){
			$vSql =	"UPDATE COMMENTAIRE SET statut='visible', modi='$_SESSION[login]' WHERE id=$id;";
		};
	$vQuery=pg_query($vConn,$vSql);
	}
	Header("Location:article.php");

pg_close($vConn);
?>
