<?php 
include "connect.php";
$vConn = fConnect();
ob_start();
session_start();
?>

<html>
<head><title>Gerer rubriques</title></head>
<body>
<div align="center">
<h2>GERER RUBRIQUE</h2>
</div>

<?php
	echo "<h3>Choisir une rubrique à lier :</h3>";
	$vSql ="SELECT title FROM RUBRIQUE WHERE mother IS NULL;";
	$vQuery=pg_query($vConn,$vSql);
	echo"<form method='post' action=''>" ;
	while ($vResult = pg_fetch_array($vQuery)){
		echo "<b>"."$vResult[title]"."</b>";
		echo "<input type='radio' name='rubrique' value="."$vResult[title]"."><br>";
		$vSql2 ="SELECT title FROM RUBRIQUE WHERE mother='"."$vResult[title]"."';";
		$vQuery2=pg_query($vConn,$vSql2);
		while($vResult2 = pg_fetch_array($vQuery2)){
			echo "$vResult2[title]";
			echo "<input type='radio' name='rubrique' value="."$vResult2[title]"."><br>";
		}						
		echo"<br><br>";			
	};

	echo "<font size='4'><b>Ou créer une nouveau rubrique ou une sous-rubrique de la rubrique choisi.</b></font><br>";
	echo "<font size='2' color='red'>(Pas d'espace, utilisez'-', s'il vous plaît.)</font><br>";
	echo "<input type='text' name='nrubrique' value='' size='50'><br><br>";
	echo "<input type='submit' name='submitrub' value='Submit'><br>";
	echo "</form>";

	if ($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitrub"])) {
		if(empty($_POST["nrubrique"])){
			if(empty($_POST["rubrique"])){
				echo "<font size='2' color='red'>Choisissez une rubrique ou créez une nouveau rubrique, s'il vous plaît.</font><br>";
			}
			else{
				$rub=$_POST["rubrique"];
				$vSql ="SELECT rub FROM RUBRIQUE_ARTICLE WHERE rub ='$rub' AND art = $_SESSION[art];";
				$vQuery=pg_query($vConn,$vSql);
				$vResult = pg_fetch_array($vQuery);
				if($vResult["rub"]!=NULL) {echo "<font size='2' color='red'>L'article est déjà lié à cette rubrique<br></font>";
				}
				else{
					$vSql ="INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES('$rub', $_SESSION[art], '$_SESSION[login]');";
					$vQuery=pg_query($vConn,$vSql);
					echo "<font size='2' color='blue'>Lien créé avec succès<br></font>";
				}
			};
		}
		else{
			$nrub=$_POST["nrubrique"];
			if (strpos($nrub, ' ')){ echo "<font size='2' color='red'> Pas d'espace, utilisez'-', s'il vous plaît.<br></font>";}
			else{
				$vSql ="SELECT title FROM RUBRIQUE WHERE title = upper('$nrub');";
				$vQuery=pg_query($vConn,$vSql);
				$vResult = pg_fetch_array($vQuery);
				if($vResult["title"]!=NULL) {echo "<font size='2' color='red'>Cette rubrique existe déjà.<br></font>";}
				else{
					if(empty($_POST["rubrique"])){
						$vSql ="INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ( upper('$nrub'), NULL, '$_SESSION[login]', current_timestamp);";
						$vQuery=pg_query($vConn,$vSql);
						$vSql ="INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES('$nrub',$_SESSION[art], '$_SESSION[login]');";
						$vQuery=pg_query($vConn,$vSql);
						Header("Location:rubrique.php");
					}
					else{
						$rub=$_POST["rubrique"];
						$vSql ="SELECT mother FROM RUBRIQUE WHERE title = '$rub';";
						$vQuery=pg_query($vConn,$vSql);
						$vResult = pg_fetch_array($vQuery);
						if($vResult["mother"]!=NULL) {echo "<font size='2' color='red'>On ne peux pas créer une sous rubrique d'une sous rubrique.<br></font>";}
						else{
							$vSql ="INSERT INTO RUBRIQUE (title, mother, creator, aDate) VALUES ( upper('$nrub'), '$rub', '$_SESSION[login]', current_timestamp);";
							$vQuery=pg_query($vConn,$vSql);
							$vSql ="INSERT INTO RUBRIQUE_ARTICLE (rub, art, modi) VALUES('$nrub',$_SESSION[art], '$_SESSION[login]');";
							$vQuery=pg_query($vConn,$vSql);
							Header("Location:rubrique.php");
						};
					};
				};
			};
		};
	};
pg_close($vConn);
?>

<p><a href="article.php">Retour</a></p>
</body>
</html>
