<?php
function get_blocs($articleId){
			global $connexion;
	$sql="select art, aOrder, type, title, texte, image_uml, modi 
	from Bloc 
	where art='$articleId'
	order by aOrder;";
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
}
	
	
	function get_tags ($articleId){
				global $connexion;
	$sql="select art, word, modi 
	from tags
	where art=$articleId;";	
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resulat;
	}
	
	
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
	
	
	
	function get_rubriques($nomRubrique){
				global $connexion;
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
	
	
	function get_commentaires($articleId){
		global $connexion;
	$sql="select id, art, aDate, creator, texte, statut, modi
	from Commentaire
	where art='artocleId';";
	$query=pg_query($connexion,$sql);
	$resultat=pg_fetch_array($query);
	return $resultat;
	}
	
	function user_exists($login,$password){
				global $connexion;
	$sql="select login, apassword
	from tUser
	where login='$login' and apassword='$password';";
	$query=pg_query($sql);
	$resultat=pg_fetch_array($query);
	return $resultat['login'];	
	}
	
	function user_droit($user){
				global $connexion;
	$sql= "select droit from tUser where '$user'=login;";
	$query=pg_query($sql);
	$Resultat=pg_fetch_array($query);
	return $resulat['droit'];
	}
	
	function get_articles($id){
				global $connexion;
	$sql="select id, title, nbBloc, honor, aDate, author, statut, modi, justification
	from Article
	where id='$id';";
	$query=pg_query($connexion, $sql);
	$resultat=pg_fetch_array($query);
	return $resulat;
	}
	
	
	function ajouter_commentaire ($posteur, $articleId, $texte){
				global $connexion;
	if (user_droit($posteur)!='moderateur'|| user_droit($posteur)!= 'administrateur'){
	$sql="insert into commentaire (id, art, aDate, creator, texte, statut)
		values (nextval('idauto_comm'), '$articleId', current_timestamp ,'$posteur', '$texte', 'visible');";
	$query=pg_query($connexion,$sql);
	$resultat=pg_fetch_array($query);
	}
	
	function get_articles ($categorie, $nombre, $commence){
				global $connexion;
	$sql="select id, titre, nbBloc, honor, aDate, author, statut, modi, justification, count(id) as nb
	from Article
	order by id limit ".$nombre." offset ".$commence." ;"
		
	}
}
