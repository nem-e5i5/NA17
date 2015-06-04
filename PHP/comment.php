<?php include ('include/format_article.php');

function affiche_commentaire($commentaire)
{
	?>
<div>
	<h3><small>écrit par <?php echo $commentaire["creator"];?></small></h3>
	<div>
		<pre><?php echo $commentaire["texte"];?></pre>
	</div>
	<a href="?supprimer=<?php echo $commentaire["id"];?>">supprimer le commentaire</a>
</div>
	<?php
}

if (isset($_GET["article"]) || isset($_POST["article"])
{
	afficher_article(get_article($id));
	$id = isset($_GET["article"]) ? $_GET["article"] : $_POST["article"];
	if (isset($_POST["text"]))
	{
		$posteur = $_POST["text"];
		$texte = $_POST["text"];
		ajouter_commentaire($posteur, $id, $texte);
		echo "<span>commentaire ajouté</span>"
	}
	
	
	foreach (get_commentaires($id) as $commentaire) affiche_commentaire($commentaire);
	?>
	<div>
		<form method="post" action="comment.php">
			<input type="text" value="pseudo" name="pseudo"/>
			<input type="hidden" value="<?php echo $id; ?>" name="article"/>
			<edit name="text">
				
			</edit>
			<input type="submit" value="envoyer" />
		</form>
	</div>
	<?php
}
?>