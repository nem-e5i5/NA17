<div>
	<form method="get" action="search.php">
		<input type="text" name="tag" />
		<input type="submit" value="rechercher"/>
	</form>
</div>
<div>
<?php include ('include/format_article.php');
if (isset($_GET["tag"]))
{
	$tag = explode(" ", $_GET["tag"]);
	foreach (rechercher_articles($tag) as $article) affiche_article($article);
}
?>
</div>