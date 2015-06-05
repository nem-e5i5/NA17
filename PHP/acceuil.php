<?php 
include "connect.php";
$vConn = fConnect();
include "function.php";
	session_start(); 
	if(!empty($_GET["login"])){
		$login= $_GET["login"];
		if ($login=="visiteur") {$_SESSION["user"]="no";}
		else{$_SESSION["user"] = fDroit($login, $vConn);}
	}
	else {
		if (!isset($_SESSION["user"])) {$_SESSION["user"] = "no";}
		if(!isset($login)){$login="visiteur"; }
		}
	$nodroit=($_SESSION["user"]=="lecteur" or $_SESSION["user"]=="moderateur" or $_SESSION["user"]=="no");
?>

<html>

<nav>
<?php 
	if($_SESSION["user"]!="no"){
		echo "<a href='acceuil.php?login=visiteur'> Deconnexion </a>";
	}
	else {
		echo "<a href='inscription.php'> creer un nouveau compte </a>";
		$Err="";
		$nlogin=$nmdp="";
		echo "<form method='post' action=''> 
			Login: <input type='text' name='nlogin' value='"."$nlogin"."'>
			Mot de passe: <input type='password' name='nmdp' value='"."$nmdp"."'>
  			 <input type='submit' name='se connecter' value='Submit'></from>";

		if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$nlogin=$_POST["nlogin"];
		$nmdp=$_POST["nmdp"];
		$vSql ="SELECT login FROM TUSER WHERE login= '$nlogin' AND aPassword='$nmdp';";
		$vQuery=pg_query($vConn,$vSql);
		$vResult = pg_fetch_array($vQuery);
		if($vResult['login']==NULL){
			echo"<br><font size='3' color='red'>Le login ou le mot de passe n''est pas correct</span></font>";
	    	}
		else{Header("Location: acceuil.php?login=".$nlogin);}
		}
	}
?> 

	
</nav>
<head>
	<title>accueil <?php echo $login;?></title>
</head>

<body>
<p>
	
</p>
	<h2>Liste des articles</h2>
	<table border="1">
		<tr>
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
<?php	if(!$nodroit)  {echo"<td width='100pt'>
				<b>Statut</b>
			</td>";}
?>			
		</tr>

<?php 
	$vSql ="SELECT A.id, A.title, A.honor, A.aDate AS date, A.author, U.firstname, U.lastname, A.statut
		FROM ARTICLE A, TUSER U
		WHERE A.author=U.login
		ORDER BY A.aDate;";
	$vQuery=pg_query($vConn,$vSql);
	while ($vResult = pg_fetch_array($vQuery)){
		if(($nodroit and $vResult['statut']!="publie") or !$nodroit) {
			echo "<tr>";
			echo "<td> <a href='article.php?article="."$vResult[id]"."'>"."$vResult[title]"."</td>";
			echo "<td>$vResult[honor]</td>";
			echo "<td>$vResult[firstname]"." "."$vResult[lastname]"."</td>";
			echo "<td>$vResult[date]</td>";
			if(!$nodroit)
			{echo "<td>$vResult[statut]</td>";}
			echo "</tr>";
		}
	}
?> 
</body>
</html>
