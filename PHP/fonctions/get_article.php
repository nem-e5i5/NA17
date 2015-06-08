get_article($id) => retourne l'article donné par son id (le tuple entier)

<?php
function get_articles($id, $connexion){
	$sql="select id, title, nbBloc, honor, aDate, author, statut, modi, justification
	from Article
	where id='$id';";
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resulat;
	
}



?>