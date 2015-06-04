<?php
function affiche_article($article)
{
	?>
<div>
	<h3><?php echo $article["titre"]; ?></h3><small>rédigé le <?php echo $article["date"];?> par <?php echo $article["author"];?></small><br/>
	<?php foreach (get_blocs($article["id"]) as $bloc) { affiche_bloc($bloc); echo "<br/>"; }?>
	<span>Tags: <?php foreach (get_tags($article["id"]) as $tag) {affiche_tag($tag); echo " "; } ?></span><br/>
	<span>Liés: <br/><?php foreach (get_ties($article["id"]) as $tie) {affiche_tie($tie, $article["id"]); echo "<br/>"; } ?></span>
	<a href="?comment.php?article=<?php echo $article["id"]; ?>">commentaires</a>
</div>
	<?php
}
function affiche_bloc($bloc)
{
	echo "<p>";
	echo "<h4>" . $bloc["title"] . "</h4>"
	if (isset($bloc["texte"]))
	{
		echo "<p>" . $bloc["texte"] . "</p>";
	}
	else
	{
		?><img src="<?php echo $bloc["path"]; ?>"><img><?php
	}
	echo "</p>";
}
function affiche_tag($tag)
{
	echo '<a href="search.php?tag='. urlencode($tag["word"]) . '">' . $tag["word"] . '</a>';
}
function affiche_tie($tie, $piv)
{
	$id = $tie["firstArticle"] == $piv ? $tie["secondArticle"] : $tie["firstArticle"];
	$article = get_article($id);
	echo '<a href="article.php?id='. $id . '">' . $article["titre"] . '</a>';
}
?>