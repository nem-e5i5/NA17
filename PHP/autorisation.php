<html>
<head><title>Autorisation</title></head>
<body>
<h2>Autoriser un utilisateur</h2>
<p><a href="acceuil.php">Retour</a></p>
<?php
include "connect.php";
$vConn = fConnect();
?>
	<p>
	<table border="1">
		<tr>
			<td width="100pt">
				<b>Login</b>
			</td>
			<td width="300pt">
				<b>Nom</b>
			</td>
			<td width="150pt">
				<b>Droit</b>
			</td>
			<td width="60pt">
				<b>Choix</b>
			</td>	
		</tr>
<?php
	$vSql ="SELECT login, firstName, lastname, droit FROM TUSER ORDER BY login;";
	$vQuery=pg_query($vConn,$vSql);
	$vResult = pg_fetch_array($vQuery);
	echo"<form method='post' action=''>" ;
	while ($vResult = pg_fetch_array($vQuery)){
		echo "<tr>";
		echo "<td>$vResult[login]</td>";
		echo "<td>$vResult[firstname]"." "."$vResult[lastname]"."</td>";
		echo "<td>$vResult[droit]</td>";
		echo "<td>
			<input type='radio' name='login' value="."$vResult[login]".">
			</td>";
		echo "</tr>";
	}
	echo "</p>";
	echo"
	<p><select name='droit'>
	<option value='administrateur'>Administrateur</option> 
	<option value='editeur' selected>Editeur</option>
	<option value='auteur'>Auteur</option>
	<option value='lecteur'>Lecteur</option>
	<option value='moderateur'>Moderateur</option>
	</select>

	<input type='submit' name='submit' value='Autoriser'> 
	</form></p>";
?>

<?php
	
	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		if (!empty($_POST["login"]) and !empty($_POST["droit"])){
			$login=$_POST["login"];$succes=1;
			$droit=$_POST["droit"];
			$vSql ="UPDATE TUSER SET droit = '$droit' WHERE login = '$login';";
			$vQuery=pg_query($vConn,$vSql);
			Header("Location: autorisation.php");
		}
		else echo "<font size='3' color='red'>Choisissez, s'il vous plait.";
	}
pg_close($vConn);
?>

</body>
</html>
