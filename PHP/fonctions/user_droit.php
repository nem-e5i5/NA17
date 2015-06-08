
<?php
function user_droit($user,$connexion){
	$sql= "select droit from tUser where '$user'=login;";
	$query=pg_query($connexion,$sql);
	$Resultat=pg_fetch_array($query);
	return $resulat['droit'];
}
?>
