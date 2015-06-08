get_ties($articleid)  => retourne tout les articles liés à un article

<?php
function get_ties($articleId){
	$sql="select id, title, nbBloc, honor, aDate, author, statut, modi, justification
	from article
	where article.id in (
		select firstArticle from tie_article where secondArticle=1
		union 
		select secondArticle from tie_article where firstArticle=1
	);";
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
}


?>