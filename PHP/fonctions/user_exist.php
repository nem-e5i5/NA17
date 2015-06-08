user_exists($user, $pass) => vérifie que l'utilisateur $user avec le mot de passe $pass existe dans la DB
<?php
function user_exists($login,$password,$connexion){
	$sql="select login, apassword
	from tUser
	where login='$login' and apassword='$password';";
	$query=pg_query($connexion,$sql);
	$resultat=pg_fetch_array($query);
	return $resultat['login'];	
/*
on s'en fou ce que ça renvoit tant que ça renvoie qqch de non nul
*/
}
?>

