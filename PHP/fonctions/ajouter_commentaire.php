ajouter_commentaire($posteur, $articleid, $texte) => ajoute un commentaire à l'article donné. Attention a vérifier que $posteur n'est pas le pseudo d'un des modérateurs/administrateur puisqu'il est possible de tout mettre
<?php
function ajouter_commentaire ($posteur, $ articleId, $texte, $connexion){
	if (user_droit($posteur)!='moderateur'|| user_droit($posteur)!= 'administrateur'){
	$sql="insert into commentaire (id, art, aDate, creator, texte, statut)
		values (nextval('idauto_comm'), '$articleId', current_timestamp ,'$posteur', '$texte', 'visible');";
	$query=pg_query($connexion,$sql);
	$resultat=pg_fetch_array($query);
	}
}

?>