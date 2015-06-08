
<?php
function get_tags ($articleId){
	$sql="select art, word, modi 
	from tags
	where art=$articleId;";	
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resulat;
}


?>