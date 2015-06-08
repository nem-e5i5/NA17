
<?php
function get_commentaires($articleId,$connexion){
	$sql="select id, art, aDate, creator, texte, statut, modi
	from Commentaire
	where art='artocleId';";
	$query=pg_query($connexion,$sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
}
?>