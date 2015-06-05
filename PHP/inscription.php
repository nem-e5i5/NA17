 <!DOCTYPE HTML>
<html>
<head>
<style>
.error {color: #FF0000;}
</style>
</head>
<body>

<?php
include "connect.php";
$vConn = fConnect();
// define variables and set to empty values
$loginErr = $mdpErr = "";
$login = $nom = $prenom = $mdp = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
   if (empty($_POST["login"])) {
     $loginErr = "Champs obligatoire";
   } else {
     $login=$_POST["login"];
     if (strlen($login)>30) {
       $loginErr = "Moins de 30 caracteres, s'il vous plait";
     }
     else {
	if(strlen($login)<7){
	   $loginErr = "Plus de 7 caracteres, s'il vous plait";
	}
	else {
	    if (!preg_match("/[A-Za-z0-9]+/",$login)){
		$loginErr = "Que des lettres et chiffres";
	    }
	    else{
		$vSql ="SELECT login FROM TUSER WHERE login= '$login';";
		$vQuery=pg_query($vConn, $vSql);
		$vResult = pg_fetch_array($vQuery);
		if($vResult['login']!=NULL){
			$loginErr = "Le login existe deja";
	    	}
	    }
        }
    }
    if (!empty($_POST["nom"]))$nom=$_POST["nom"];
    if (!empty($_POST["prenom"]))$prenom=$_POST["prenom"];

    if (empty($_POST["mdp"])) {
     $mdpErr = "Champs obligatoire";
   } else {
     $mdp=$_POST["mdp"];
     if (strlen($mdp)<8) {
       $mdpErr = "Au moins 8 caracteres, s'il vous plait";
     }
     else {
	if (preg_match("/\\s/", $mdp)) {
		$mdpErr = "Pas d'epace, s'il vous plait";
	}

     }
   }

}}
	if($mdpErr=="" && $loginErr==""){
	$vSql="INSERT INTO TUSER (login, firstname, lastname, aPassword, droit) VALUES ('$login','$prenom','$nom','$mdp', 'lecteur');";
	$vQuery=pg_query($vConn,$vSql);}
?>

<h2>Creer un nouveau compte</h2>
<p><span class="error">* required field.</span></p>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
   Login(7~30 caracteres): <input type="text" name="login" value="<?php echo $login;?>">
   <span class="error">* <?php echo $loginErr;?></span>
   <br><br>
   Nom: <input type="text" name="nom" value="<?php echo $nom;?>">
   <br><br>
   Prenom: <input type="text" name="prenom" value="<?php echo $prenom;?>">
   <br><br>
   Mot de passe: <input type="text" name="mdp" value="<?php echo $mdp;?>">
   <span class="error">* <?php echo $mdpErr;?></span>
   <br><br>
   <input type="submit" name="submit" value="Submit">
</form>
</body>
</html>
