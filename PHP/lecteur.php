<?php include ('include/format_article.php');
function affiche_rubrique($rubrique)
{
	echo "<div>";
	if ($rubrique != null) echo '<a href="?rubrique=' . urlencode($rubrique["title"]) . '">' . $rubrique["title"] . '</a>';
	$srl = get_rubrique($rubrique == null? $rubrique["title"] : null);
	if (!empty($srl))
	{
		echo "<br/><ul>";
		foreach($srl as $sous_rubrique)
		{
			echo "<li>";
			affiche_rubrique($sous_rubrique);
			echo "</li>";
		}
		echo "</ul>";
	}
	echo "</div>";
}
affiche_rubrique(null);
$categorie = isset($_GET["rubrique"]) && ctype_alnum($_GET["rubrique"]) ? $_GET["rubrique"] : null;
foreach (get_articles($categorie, 3) as $article) affiche_article($article);
?>