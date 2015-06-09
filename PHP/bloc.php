<?php 
include "connect.php";
$vConn = fConnect();

	ob_start();
	session_start(); 

	$choix="";
	if(!empty($_GET["choix"])){
		$choix= $_GET["choix"];
	}
	else {echo "ERREUR !!!";}
	
	$order=0;
	if(!empty($_GET["order"])){
		$order= $_GET["order"];
	}

?>

<html>
<head><title><?php if($choix=="modifier")echo "Éditer un bloc"; if($choix=="ajouter") echo "Ajouter un bloc";?></title></head>
<body>
<div align="center">
<h2>BLOC</h2>

<?php
	$ntitle=$ntexte=$nurl="";
	
	if($choix=="ajouter"){
		echo "<form method='post' action=''> ";
		echo "<h3>Veuillez sasir un titre pour ce bloc : </h3>";
		echo "<textarea name='title' rows='2' cols='100'>$ntitle</textarea><br>";
		echo "<h3>Si c'est un bloc de texte, veuillez saisir le corps du bloc de texte : </h3>";
		echo "<font size='2' color='red'>(Merci d'insérer deux guillements simples ensemble, si vous voulez insérer un guillement simple)</font><br>";
		echo "<textarea name='texte' rows='20' cols='100'>$ntexte</textarea><br>";
		echo "<h3>Si c'est un bloc d'image, veuillez saisir l'url local de l'image : </h3>";
		echo "<textarea name='url' rows='5' cols='100'>$nurl</textarea><br>";
		echo "<b>Type de bloc : </b> <input type='radio' name='type' value='I'> Image";
		echo "<input type='radio' name='type' value='T'> Texte<br>";
		echo "<input type='submit' name='submit' value='Submit'><br>";
		echo "</form>";

		if ($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submit"])) {
		if (!empty($_POST["title"]) and !empty($_POST["type"])){
			$ntitle=$_POST["title"];
			$ntype=$_POST["type"];
			if($ntype=="I"){
				if(!empty($_POST["url"])){
					$nurl=$_POST["url"];
					$vSql="INSERT INTO BLOC (art, aOrder, type, title, texte, image_uml) VALUES ($_SESSION[art], fOrdreBloc($_SESSION[art]), 'I','$ntitle', NULL, '$nurl');";
					$vQuery=pg_query($vConn,$vSql);
					Header("Location:article.php");
				}
				else echo "<font size='2' color='red'>Saisissez un url pour un image, s'il vous plaît.</font><br>";
			}
			else{
				if(!empty($_POST["texte"])){
					$ntexte=$_POST["texte"];
					$vSql="INSERT INTO BLOC (art, aOrder, type, title, texte, image_uml) VALUES ($_SESSION[art], fOrdreBloc($_SESSION[art]), 'T','$ntitle', '$ntexte', NULL);";
					$vQuery=pg_query($vConn,$vSql);
					Header("Location:article.php");
				}
				else echo "<font size='2' color='red'>Saisissez le texte du bloc ne doit pas être vide !</font><br>";
			}
		}
		else echo "<font size='2' color='red'>Le titre et le type ne doivent pas être vide.</font><br>";
	}

		
	}
	elseif($choix=="modifier"){
		$vSql="SELECT type, title, texte, image_uml AS url FROM BLOC WHERE art=$_SESSION[art] AND aOrder = $order;";
		$vQuery=pg_query($vConn,$vSql);
		$vResult = pg_fetch_array($vQuery);
		$ntitle=$vResult["title"];
		echo "<form method='post' action=''> ";
		echo "<h3>Le titre du bloc : </h3>";
		echo "<textarea name='title' rows='2' cols='100'>$ntitle</textarea><br>";
		if($vResult["type"]=="T"){
			$ntexte=$vResult["texte"];
			echo "<h3>C'est un bloc de texte : </h3>";
			echo "<font size='2' color='red'>(Merci d'insérer deux guillements simples ensemble, si vous voulez insérer un guillement simple)</font><br>";
			echo "<textarea name='texte' rows='20' cols='100' >$ntexte</textarea><br>";
		}
		else{
			$nurl=$vResult["url"];
			echo "<h3>C'est un bloc d'image, l'url local de l'image : </h3>";
			echo "<textarea name='url' rows='5' cols='100'>$nurl</textarea><br>";

		};
		echo "<input type='submit' name='submitm' value='Submit'><br>";
		echo "</form>";

		if ($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitm"])) {
			if (!empty($_POST["title"])){
				$ntitle=$_POST["title"];
				if($vResult["type"]=="T"){
					if(!empty($_POST["texte"])){
						$ntexte=$_POST["texte"];
						$vSql="UPDATE BLOC SET texte ='$ntexte', title = '$ntitle', modi='$_SESSION[login]' WHERE art=$_SESSION[art] AND aOrder=$order;";
						$vQuery=pg_query($vConn,$vSql);
						Header("Location:article.php");
					}
					else echo "<font size='2' color='red'>Le corps du texte ne doit pas être vide.</font><br>";
				}
				else{
					if(!empty($_POST["url"])){
						$nurl=$_POST["url"];
						$vSql="UPDATE BLOC SET image_uml ='$nurl', title = '$ntitle', modi='$_SESSION[login]' WHERE art=$_SESSION[art] AND aOrder=$order;";
						$vQuery=pg_query($vConn,$vSql);
						Header("Location:article.php");
					}
					else echo "<font size='2' color='red'>Le corps du texte ne doit pas être vide.</font><br>";
				};
			}
			else {
				echo "<font size='2' color='red'>Le titre ne doit pas être vide.</font><br>";
			};
		}
	};
pg_close($vConn);
?>

<p><a href="article.php">Retour</a></p>
</div>
</body>
</html>
