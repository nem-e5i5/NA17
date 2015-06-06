<html>
<head><title>Liste</title></head>
<body>
<h2>Liste pour choisir</h2>

<?php
include "connect.php";
$vConn = fConnect();

	$choix="";
	if(!empty($_GET["choix"])){
		$choix= $_GET["choix"];
	}

	if($choix=="auteur"){	echo"
				<p><table border='1'><tr>
				<td width='300pt'><b>Liste</b></td>
				<td width='100pt'><b>Nombre d'articles</b></td></tr>";
					
				$vSql ="SELECT A.author, U.firstName, U.lastname, COUNT(*) AS nb
					FROM ARTICLE A, TUSER U
					WHERE A.author=U.login
					GROUP BY A.author, U.firstName, U.lastname
					ORDER BY A.author;";
				$vQuery=pg_query($vConn,$vSql);
				while ($vResult = pg_fetch_array($vQuery)){
					echo "<tr>";
					echo "<td><a href='acceuil.php?auteurin="."$vResult[author]"."'>"."$vResult[firstname]"." "."$vResult[lastname]"."</td>";
					echo "<td>$vResult[nb]</td>";
					echo "</tr>";
				}
				echo "</table>";
					

			}
	elseif($choix=="date"){	echo"
				<p><table border='1'><tr>
				<td width='100pt'><b>Date</b></td>
				<td width='100pt'><b>Nombre d'articles</b></td></tr>";
				$vSql ="SELECT aDate AS date, COUNT(*) AS nb FROM ARTICLE GROUP BY aDate ORDER BY aDate;";
				$vQuery=pg_query($vConn,$vSql);
				while ($vResult = pg_fetch_array($vQuery)){
					echo "<tr>";
					echo "<td><a href='acceuil.php?datein="."$vResult[date]"."'>"."$vResult[date]"."</td>";
					echo "<td>$vResult[nb]</td>";
					echo "</tr>";
				}
				echo "</table>";
			}
	elseif($choix=="rubrique"){
				$vSql ="SELECT title FROM RUBRIQUE WHERE mother IS NULL;";
				$vQuery=pg_query($vConn,$vSql);
				while ($vResult = pg_fetch_array($vQuery)){
					echo "<td><b><br><br><a href='acceuil.php?rubriquein="."$vResult[title]"."'>"."$vResult[title]"."</b></td>";
					$vSql2 ="SELECT title FROM RUBRIQUE WHERE mother='"."$vResult[title]"."';";
					$vQuery2=pg_query($vConn,$vSql2);
					$vResult2 = pg_fetch_array($vQuery2);
					while($vResult2 = pg_fetch_array($vQuery2)){
						echo "<td><br><a href='acceuil.php?rubriquein="."$vResult2[title]"."'>"."$vResult2[title]"."</td>";
					}						
						
				}
			}
	elseif($choix=="statut"){echo"
				<p><table border='1'><tr>
				<td width='200pt'><b>Statut</b></td>
				<td width='100pt'><b>Nombre d'articles</b></td></tr>";
				$vSql ="SELECT statut, COUNT(*) AS nb FROM ARTICLE GROUP BY statut ORDER BY statut;";
				$vQuery=pg_query($vConn,$vSql);
				while ($vResult = pg_fetch_array($vQuery)){
					echo "<tr>";
					echo "<td><a href='acceuil.php?statutin="."$vResult[statut]"."'>"."$vResult[statut]"."</td>";
					echo "<td>$vResult[nb]</td>";
					echo "</tr>";
				}
				echo "</table>";


		}






pg_close($vConn);
?>
<p><br><br><a href="acceuil.php">Retour</a></p>
</body>
</html>
