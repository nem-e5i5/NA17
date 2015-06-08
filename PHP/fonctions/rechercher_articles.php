rechercher_articles($tag) => retourne tout les articles contenant tout les tag contenu dans le mot clé $tag
//count($yt) => taille
<?php
function rechercher_articles($tag){
	$sql ="select A.id
	from Article A, Tags T
	where T.art=A.id
	and t.word in ('$tags');";
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
}

?>