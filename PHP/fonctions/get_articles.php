get_articles($categorie, $nombre, $commence) => retourne les $nombre dernier articles de la catégorie $categorie en partant du $commence-ième 
(exemple get_articles("pêche", 3, 1) retourne les premier articles de pêche, get_articles("pêche", 3, 4) retourne les 3 suivants) 
Note: cela doit pouvoir gérer le cas $catégorie = "honneur"

<?php
	function get_articles ($categorie, $nombre, $commence){
		$sql="select id, titre, nbBloc, honor, aDate, author, statut, modi, justification, count(id) as nb
		from Article
		order by id limit ".$nombre." offset ".$commence." ;"
		
		
		
	}



?>