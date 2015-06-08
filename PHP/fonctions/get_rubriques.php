/*
get_rubriques($nomrubrique) => retourne toutes les sous rubriques de la rubrique $nomrubrique, 
si $nomrubrique == null, retourne toute les rubriques"racines" (donc sans rubrique parente).

*/

<?php
function get_rubriques($nomRubrique){
	if ($nomRubrique==NULL) {
		$sql="select title, creator, aDate
		from Rubrique 
		where mother is NULL"
	}
	else {
	$sql="select title,creator, aDate
	from Rubrique 
	where mother='$nomRubrique';";
	}
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
}



?>