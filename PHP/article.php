<?php 
	include "connect.php";
	$vConn = fConnect();
	session_start(); 

	if(!empty($_GET["article"])){
		$_SESSION["art"]= $_GET["article"];
	}
	elseif(!isset($_SESSION["art"]))echo "ERROR !";

?>

<html>
<head><title>Article ID <?php echo $_SESSION["art"]?></title></head>
<nav><a href="acceuil.php">Retour</a></nav>
<body>

<?php 
//Afficher le titre et les informations
	$vSql ="SELECT A.title, U.firstName, U.lastname, A.auteur, A.aDate AS date, A.honor, A.statut, A.nbBloc AS nb
		FROM ARTICLE A, TUSER U
		WHERE A.id=".$_SESSION["art"]." AND A.author=U.login;";
	$vQuery=pg_query($vConn,$vSql);
	$vResult = pg_fetch_array($vQuery);
	
	$statut=$vResult["statut"];
	$auteurdroit=($_SESSION["user"]=="auteur" and $vResult["auteur"]==$_SESSION["login"] and ($vResult["statut"]=="en_redaction" or $vResult["statut"]=="supprime"));
	$editeurdroit=($_SESSION["user"]=="editeur" and $vResult["statut"]!="en_redaction" and $vResult["statut"]!="supprime");
	$nodroitpub=($_SESSION["user"]=="lecteur" or $_SESSION["user"]=="moderateur" or $_SESSION["user"]=="visiteur");
	
	echo "<h2>"."$vResult[title]"."</h2>";
	if($vResult["honor"]==1)echo"<b>ARTICLE HONORÉ</b><br>";
	echo "<b>Par</b> "."$vResult[firstname]"." "."$vResult[lastname]";
	echo "&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp";
	echo "<b>Date</b>   "."$vResult[date]";
	if($auteurdroit or $editeurdroit){echo "<font color='blue'><b>Statut</b>   "."$statut"."</font>";};
	echo "<br>";
	
//Afficher les Blocs
	$nbbloc=$vResult["nb"];
	if($nbbloc>0){
		$vSql =	"SELECT art, aOrder AS order, type, title, texte, image_uml AS uml
				FROM BLOC
				WHERE art='".$_SESSION["art"]."' 
				ORDER BY aOrder;";
		$vQuery=pg_query($vConn,$vSql);
		while($vResult = pg_fetch_array($vQuery)){
			if($vResult["type"]=="I"){
				echo "<img src='"."$vResult[uml]"."' border='0' /></div>";
				echo "<div align='center'><font face='arial' size='3' color='blue'>"."$vResult[title]"."</font><br> ";
				if($auteurdroit or $editeurdroit) echo "<a href='bloc.php?order="."$vResult[order]".",choix=modifier'> Modifier </a>";
			}
			else {
				echo "<h3>"."$vResult[title]"."</h3><br>";
				echo "$vResult[texte]"."<br>";
			}; 
			
		};
	};


//Les fonctionnements d'editeur
	if($editeurdroit){
		if($statut=="rejete"){
			
			
		};
		
		if($statut=="a_reviser"){
			
			
		};
	}


//les fonctionnements d'auteur
	if($auteurdroit){
		if($statut=="en_redaction"){
			echo "<form method='post' action='bloc.php?choix=ajouter'> <input type='submit' name='ajouter' value='Ajouter un nouveau bloc'></from><br>";
			echo "<form method='post' action=''> <input type='submit' name='supp' value='Supprimer cet article'></from><br>";
			echo "<form method='post' action=''> <input type='submit' name='soumettre' value='Soumettre cet article'></from> <font color='red'>Une fois soumis, cet article ne peux plus être modifié !</font><br>";
			if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["supp"])) {
				$vSql =	"UPDATE ARTICLE SET statut='supprime', modi='".$_SESSION["login"]."' WHERE id=".$_SESSION["art"].";";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location: article.php");
			};
			if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["soumettre"])) {
				$vSql =	"UPDATE ARTICLE SET statut='soumis', modi='".$_SESSION["login"]."' WHERE id=".$_SESSION["art"].";";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location: article.php");
			};
		}
		elseif($statut=="supprime"){
			echo "<form method='post' action=''> <input type='submit' name='recu' value='Récupérer cet article'></from><br>";
			if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["recu"])) {
				$vSql =	"UPDATE ARTICLE SET statut='en_redaction', modi='".$_SESSION["login"]."' WHERE id=".$_SESSION["art"].";";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location: article.php");
			};
		};
	};
	
	
//Afficher des commentaires
	echo "<h2>---------------COMMENTAIRE---------------</h2>";
	


//Ajouter un commentaire


//DES ARTICLE LIES
	echo "<h2>-------------DES ARTICLE LIES-------------</h2>";
	$vSql =	"SELECT A.id, A.title, A.statut
			FROM ARTICLE A
			WHERE A.id IN
			(SELECT T1.firstArticle FROM TIE_ARTICLE T1 WHERE T1.secondArticle='".$_SESSION["art"]."'
			UNION
			SELECT T2.secondArticle FROM TIE_ARTICLE T2 WHERE T2.firstArticle='".$_SESSION["art"]."');"
	$vQuery=pg_query($vConn,$vSql);
	while ($vResult = pg_fetch_array($vQuery)){
		if(($nodroitpub and $vResult[statut]=="publie")or !$nodroitpub){
			echo "<tr>";
			echo "<td><a href='acceuil.php?article="."$vResult[id]"."'>"."$vResult[title]"."</td>";
			echo "<td>$vResult[nb]</td>";
			echo "</tr>";
		};
	}
?>




<p><a href="acceuil.php">Retour</a></p>
</body>
</html>
