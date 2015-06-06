<?php 
include "connect.php";
$vConn = fConnect();
include "function.php";
	session_start(); 
	if(!empty($_GET["login"])){
		$_SESSION["login"]= $_GET["login"];
		if ($_SESSION["login"]=="visiteur") {$_SESSION["user"]="visiteur";}
		else{$_SESSION["user"] = fDroit($_SESSION["login"], $vConn);}
	}
	else {
		if (!isset($_SESSION["user"])) {$_SESSION["user"] = "visiteur";}
		if(!isset($_SESSION["login"])){$_SESSION["login"]="visiteur";}
		}
		
	$nodroit=($_SESSION["user"]=="lecteur" or $_SESSION["user"]=="moderateur" or $_SESSION["user"]=="visiteur");
	
	$honor=0;
	if(!empty($_GET["honor"])){
		$honor= $_GET["honor"];
	}
	
	$motclein="";
	if(!empty($_GET["motclein"])){
		$motclein= $_GET["motclein"];
	}

	$rubriquein="";
	if(!empty($_GET["rubriquein"])){
		$rubriquein= $_GET["rubriquein"];
	}

	$datein="";
	if(!empty($_GET["datein"])){
		$datein= $_GET["datein"];
	}

	$auteurin="";
	if(!empty($_GET["auteurin"])){
		$auteurin= $_GET["auteurin"];
	}


?>

<html>

<nav>
<?php 
	echo "Bonjour, ".$_SESSION['user'];
	echo "<br>";
	if($_SESSION["user"]!="visiteur"){
		echo "<a href='acceuil.php?login=visiteur'> Deconnexion </a>";
	}
	else {
		echo "<a href='inscription.php'> creer un nouveau compte </a>";
		$Err="";
		$nlogin=$nmdp="";
		echo "<form method='post' action=''> 
			Login: <input type='text' name='nlogin' value='"."$nlogin"."'>
			Mot de passe: <input type='password' name='nmdp' value='"."$nmdp"."'>
  			 <input type='submit' name='submitlogin' value='Se connecter'></from>";

		if ($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitlogin"])) {
		$nlogin=$_POST["nlogin"];
		$nmdp=$_POST["nmdp"];
		$vSql ="SELECT login FROM TUSER WHERE login= '$nlogin' AND aPassword='$nmdp';";
		$vQuery=pg_query($vConn,$vSql);
		$vResult = pg_fetch_array($vQuery);
		if($vResult['login']==NULL){
			echo"<br><font size='3' color='red'>Le login ou le mot de passe n''est pas correct</font>";
	    	}
		else{Header("Location: acceuil.php?login=".$nlogin);}
		}
	}

	if($_SESSION["user"]=="administrateur") {echo "<br><a href='autorisation.php'> Autoriser des utilisateurs </a>";}
?>
	
</nav>
<head>
	<title>accueil <?php echo $_SESSION["login"];?></title>
</head>

<body>
<p>
	<h2>Voir par</h2>
	<a href="acceuil.php">Tous les articles</a><br>
	<a href="liste.php?choix=rubrique">Rubrique</a><br>
	<a href="liste.php?choix=date">Date</a><br>
	<a href="liste.php?choix=auteur">Auteur</a><br>
	<a href="acceuil.php?honor=1">Honor</a><br>
	
	<form method="post"> <font color="blue">mot clé</font> : <input list="motcles" name="motcles"/>

	<datalist id="motcles">
<?php 
	$vSql ="SELECT DISTINCT word FROM TAGS ORDER BY word;";
	$vQuery=pg_query($vConn,$vSql);
	while ($vResult = pg_fetch_array($vQuery)){
		echo "<option value='"."$vResult[word]"."'></option>";
	}

?>
	</datalist>
	<input type="submit" name="submitmotcle" value="Rechercher"/>
	</form>
	
<?php

	if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitmotcle"])) {
		$motcle = $_POST['motcles'];
		$vSql ="SELECT word FROM TAGS WHERE word='".$motcle."';";
		$vQuery=pg_query($vConn,$vSql);
		$vResult = pg_fetch_array($vQuery);
		if($vResult["word"]==NULL){
			echo "<br><font size='3' color='red'>Desole, il n'y a aucun article publie coherant</font>";
		}
		else{
			Header("Location: acceuil.php?motclein=".$motcle);
		}
	}

?>



</p>
	<h2>Liste des articles</h2>
	<table border="1">
		<tr>
			<td width="50pt">
				<b>ID</b>
			<td width="600pt">
				<b>Titre</b>
			</td>
			<td width="50pt">
				<b>Honor</b>
			</td>
			<td width="300pt">
				<b>Auteur</b>
			</td>
			<td width="100pt">
				<b>Date</b>
			</td>	
<?php			if(!$nodroit)  {echo"<td width='100pt'><b>Statut</b></td>";}
?>			
		</tr>

<?php

	if($motclein=="" and $rubriquein=="" and $datein=="" and $auteurin==""){
	$vSql ="SELECT A.id, A.title, A.honor, A.aDate AS date, A.author, U.firstname, U.lastname, A.statut
		FROM ARTICLE A, TUSER U
		WHERE A.author=U.login
		ORDER BY A.aDate, A.id;";
	}
	else{
		if($motclein!=""){
			$vSql ="SELECT A.id, A.title, A.honor, A.aDate AS date, A.author, U.firstname, U.lastname, A.statut
			FROM ARTICLE A, TUSER U, TAGS T
			WHERE A.author=U.login AND T.art=A.id AND T.word='".$motclein."'
			ORDER BY A.aDate, A.id;";}

		if($rubriquein!=""){
			$vSql ="SELECT A.id, A.title, A.honor, A.aDate AS date, A.author, U.firstname, U.lastname, A.statut
			FROM ARTICLE A, RUBRIQUE_ARTICLE RA, TUSER U
			WHERE A.id=RA.art AND RA.rub='".$rubriquein."' AND A.author=U.login
			ORDER BY A.aDate;";}

		if($datein!=""){
			$vSql ="SELECT A.id, A.title, U.firstName, U.lastname, A.aDate AS date, A.honor, A.statut
				FROM ARTICLE A, TUSER U
				WHERE A.aDate = to_date('".$datein."', 'YYYY-MM-DD') AND A.author=U.login
				ORDER BY aDate;";}

		if($auteurin!=""){
			$vSql ="SELECT A.id, A.title, U.firstName, U.lastname, A.aDate AS date, A.honor, A.statut
				FROM ARTICLE A, TUSER U
				WHERE A.author=U.login AND A.author='".$auteurin."';";}

	};

	$vQuery=pg_query($vConn,$vSql);
	while ($vResult = pg_fetch_array($vQuery)){
		if(($nodroit and $vResult['statut']!="publie") or !$nodroit) {
			if(($honor and $vResult['honor']==1)or !$honor){
				echo "<tr>";
				echo "<td>$vResult[id]</td>";
				echo "<td> <a href='article.php?article="."$vResult[id]"."'>"."$vResult[title]"."</td>";
				echo "<td>$vResult[honor]</td>";
				echo "<td>$vResult[firstname]"." "."$vResult[lastname]"."</td>";
				echo "<td>$vResult[date]</td>";
				if(!$nodroit){echo "<td>$vResult[statut]</td>";}
				echo "</tr>";
			}
		}
	}
?>
	</table> 
	
<?php
	if($_SESSION["user"]=="editeur"){
			echo "<br><br><b>Vous pouvez lier deux articles: </b><br>";
			echo"<form method='post' action=''> 
			id_article1: <input type='text' name='art1' value='' size='5'> &nbsp &nbsp &nbsp
			id_article2: <input type='text' name='art2' value='' size='5'>
  			 <input type='submit' name='submitlier' value='Lier deux articles'></from>";
  			echo "<br><font size='2' color='orange'>id_article1 < id_article2, s'il vous plait</font>";
  			
		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitlier"])) {
			if(!empty($_POST["art1"]) and !empty($_POST["art1"])){
				$art1=$_POST["art1"]; 
				$art2=$_POST["art2"];
				if($art1<$art) {
					$vSql ="SELECT modi FROM TAGS WHERE firstArticle=".$art1." AND secondArticle=".$art2.";";
					$vQuery=pg_query($vConn,$vSql);
					$vResult = pg_fetch_array($vQuery);
					if ($vResult["modi"]!=NULL) echo "<br><font size='3' color='red'>Articles deja lies</font>";
					else{
						$vSql ="INSERT INTO TIE_ARTICLE(firstArticle, secondArticle,modi) VALUES (".$art1.",".$art2.",'".$_SESSION['login']."');";
						$vQuery=pg_query($vConn,$vSql);
						echo "<br><font size='3' color='red'>Articles lies avec succes</font>";
						//Header("Location: acceuil.php");
					}
				}
				else echo "<br><font size='3' color='red'>id_article1 < id_article2, s'il vous plait</font>";
			}
			else echo "<br><font size='3' color='red'>Les IDs ne doivent pas être nuls</font>";
		}
	};
	
	if($_SESSION["user"]=="auteur"){
		echo "<h2>Creer un nouveau article</h2>";
		echo"<form method='post'> 
			Titre: <input type='text' name='ntitle' value=''>
 			 <input type='submit' name='submitntitle' value='Creer'/></from>";
 			 
 		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitntitle"])) {
			if(!empty($_POST["ntitle"])){
				$ntitle=$_POST["ntitle"];
				$vSql ="SELECT title FROM ARTICLE WHERE title='".$ntitle."';";
				$vQuery=pg_query($vConn,$vSql);
				$vResult = pg_fetch_array($vQuery);
				if($vResult["title"]=NULL) echo "<br><font size='3' color='red'>Le titre existe deja</font>";
				else {
					$vSql ="INSERT INTO ARTICLE (id, title, nbBloc, honor, aDate, author, statut) VALUES (nextval('idauto_art'), '".$ntitle."', 0, 0, current_date, '".$_SESSION['login']."', 'en_redaction');";
					$vQuery=pg_query($vConn,$vSql);
					$vSql ="SELECT id FROM ARTICLE WHERE title ='".$ntitle."';";
					$vQuery=pg_query($vConn,$vSql);
					$vResult = pg_fetch_array($vQuery);
					$nid=$vResult["id"];
					Header("Location: article.php?article=".$nid);
				};
			}
			else echo "<br><font size='3' color='red'>Le titre ne doit pas être nuls</font>";
		};
	};

pg_close($vConn);
?> 

</body>
</html>
