<?php
function get_blocs($articleId){
	$sql="select art, aOrder, type, title, texte, image_uml, modi 
	from Bloc 
	where art='$articleId'
	order by aOrder;";
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
}


?>