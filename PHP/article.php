<?php 
	include "connect.php";
	$vConn = fConnect();
	ob_start();
	session_start(); 

	if(!empty($_GET["article"])){
		$_SESSION["art"]= $_GET["article"];
	}
	elseif(!isset($_SESSION["art"]))echo "ERROR !";

?>

<html>
<head><title>Article ID <?php echo $_SESSION["art"]?></title></head>
<nav><a href="acceuil.php">Retour</a></nav>
<body>

<div align='center'>
<?php 
//Afficher le titre et les informations
	$vSql ="SELECT A.title, U.firstName, U.lastname, A.author, A.aDate AS date, A.honor, A.statut, A.nbBloc AS nb
		FROM ARTICLE A, TUSER U
		WHERE A.id=$_SESSION[art] AND A.author=U.login;";
	$vQuery=pg_query($vConn,$vSql);
	$vResult = pg_fetch_array($vQuery);
	
	$statut=$vResult["statut"];
	$honor=$vResult["honor"];
	//echo $_SESSION["user"];
	$auteurdroit=($_SESSION["user"]=="auteur" and $vResult["author"]==$_SESSION["login"] and ($statut=='en_redaction' or $statut=='supprime'));
	//echo "<br>"."$vResult[statut]";
	//echo "<br>"."$auteurdroit"."<br>";
	$editeurdroit=($_SESSION["user"]=="editeur" and $statut!='en_redaction' and $statut!='supprime');
	$nodroitpub=($_SESSION["user"]=="lecteur" or $_SESSION["user"]=="moderateur" or $_SESSION["user"]=="visiteur");
	
	echo "<h2>"."$vResult[title]"."</h2>";
	if($honor==1)echo"<b><font color='red'>ARTICLE HONORÉ</font></b><br><br>";
	echo "<b>Par</b> "."$vResult[firstname]"." "."$vResult[lastname]";
	echo "&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp";
	echo "<b>Date</b>   "."$vResult[date]";
	echo "&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp";
	if(!$nodroitpub){echo "<font color='blue'><b>Statut</b>   "."$statut"."</font>";};
	echo "<br>";
	
//Afficher les Blocs
	$nbbloc=$vResult["nb"];
	if($nbbloc>0){
		$vSql =	"SELECT art, aOrder AS order, type, title, texte, image_uml AS uml
				FROM BLOC
				WHERE art=$_SESSION[art]
				ORDER BY aOrder;";
		$vQuery=pg_query($vConn,$vSql);
		while($vResult = pg_fetch_array($vQuery)){
			if($vResult["type"]=="I"){
				echo "<br><img src='"."$vResult[uml]"."' border='0'/><br>";
				echo "<font face='arial' size='3' color='blue'>"."$vResult[title]"."</font><br> ";
				if($auteurdroit or $editeurdroit) echo "<br><a href='bloc.php?order="."$vResult[order]"."&choix=modifier'> Modifier </a>";
			}
			else {
				echo "<h3>"."$vResult[title]"."</h3><br>";
				echo "$vResult[texte]"."<br>";
				if($auteurdroit or $editeurdroit) echo "<br><a href='bloc.php?order="."$vResult[order]"."&choix=modifier'> Modifier </a>";
			}; 
			
		};
	};

	echo "</div>";
//Les fonctionnements d'editeur
	if($editeurdroit){
		if($statut=='rejete'){
			$vSql =	"SELECT justification FROM ARTICLE WHERE id=$_SESSION[art] ORDER BY aDate;";
			$vQuery=pg_query($vConn,$vSql);
			$vResult = pg_fetch_array($vQuery);
			echo "<br><b>Justification pour rejeter</b><br>";
			echo "$vResult[justification]<br>";
		};
		
		if($statut=='a_reviser'){
			echo "<br><b>Préconisations pour réviser</b><br>";
			$vSql =	"SELECT texte, aDate AS date FROM PRECONISATION WHERE art="."$_SESSION[art]"." ORDER BY aDate;";
			$vQuery=pg_query($vConn,$vSql);
			while($vResult = pg_fetch_array($vQuery)){
			echo "<font size='2' color='blue' >Date:"."$vResult[date]<br></font>";
			echo "$vResult[texte]"."<br><br>";
			}
		};
		
		echo "<div align='center'><br><h4>----------------------------------------Fonctionnements de l'éditeur----------------------------------------</h4><br></div>";
		echo "<br><b>-----Changer le statut d'article (Statut actuel : <font color='blue'>"."$statut"."</font>)-----</b><br>";
		echo "<form method='post' action=''>";
		echo "<input type='radio' name='changerstatut' value='en_relecture'>En relecture<br>";
		echo "<input type='radio' name='changerstatut' value='rejete'>Rejeté<br>";
		echo "<input type='radio' name='changerstatut' value='a_reviser'>À réviser<br>";
		echo "<input type='radio' name='changerstatut' value='valide'>Validé<br>";
		echo "<font size='2' color='blue'>Si vous avez coché à réviser, merci d'ajouter une préconisation.<br> 
			Si vous avez coché rejeté, merci d'ajouter une justification.<br></font>";
		echo "<font size='2' color='red'>(Merci d'insérer deux guillements simples ensemble, si vous voulez insérer un guillement simple)</font><br>";
		echo "<textarea name='statuttxt' rows='5' cols='100'></textarea><br>";
		echo "<input type='submit' name='submitstatut' value='Submit'><br>";
		echo "</form>";

		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitstatut"])){
			if(empty($_POST["changerstatut"])){
				echo "<font size='2' color='red'>Choissez un statut à changer, s'il vous plait.</font><br>";
			}
			else{
				$nstatut=$_POST["changerstatut"];
				if(($nstatut=="a_reviser" or $nstatut=="rejete")and empty($_POST["statuttxt"])){
					echo "<font size='2' color='red'>Merci d'ajouter une justification/préconisation.</font><br>";
				}
				else{
					$vSql =	"UPDATE ARTICLE SET statut='"."$nstatut"."', modi='"."$_SESSION[login]"."' WHERE id="."$_SESSION[art]".";";
					$vQuery=pg_query($vConn,$vSql);
					if($nstatut=="a_reviser"){
						$textstatut=$_POST["statuttxt"];
						$vSql =	"INSERT INTO PRECONISATION (art, aDate, editor, texte) VALUES ("."$_SESSION[art]".", current_timestamp, '"."$_SESSION[login]"."', '"."$textstatut"."');";
						$vQuery=pg_query($vConn,$vSql);
					};
					if($nstatut=="rejete"){
						$textstatut=$_POST["statuttxt"];
						$vSql =	"UPDATE ARTICLE SET justification='"."$textstatut"."' WHERE id="."$_SESSION[art]".";";
						$vQuery=pg_query($vConn,$vSql);
					}
					Header("Location:article.php");
					
				}
				
			};
		};
		if($statut=='valide'){
			echo "L'article est validé. Vous pouvez le publié<br>"; 
			echo "<form method='post' action=''> <input type='submit' name='publier' value='Publier cet article'></from><br><br>";
			if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["publier"])) {
				$vSql =	"UPDATE ARTICLE SET statut='publie', modi='"."$_SESSION[login]"."' WHERE id="."$_SESSION[art]".";";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location:article.php");
			}
		}


		echo "<form method='post' action=''> <input type='submit' name='honorer' value='Honorer/Désohorer'></from><br>";
		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["honorer"])) {
			if($honor==1){
				$vSql =	"UPDATE ARTICLE SET honor=0, modi='$_SESSION[login]' WHERE id=$_SESSION[art];";
			}
			else{
				$vSql =	"UPDATE ARTICLE SET honor=1, modi='$_SESSION[login]' WHERE id=$_SESSION[art];";
			};
			$vQuery=pg_query($vConn,$vSql);
			Header("Location:article.php");
		};

		echo "<form method='post' action=''>";
		echo "Ajouter un mot clé pour cet article : <input type='text' name='newtag' value=''>  ";
		echo "<input type='submit' name='submittag' value='Submit'><br>";
		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submittag"])){
			if(empty($_POST["newtag"])){
				echo "<font size='2' color='red'>Saisissez un mot clé, s'il vous plaît</font><br>";
			}
			else{
				$ntag=$_POST["newtag"];
				if (!ctype_alnum($ntag)){
					echo "<font size='2' color='red'>Que des lettres et chiffres, s'il vous plait</font><br>";
				}
				else{
					$vSql ="SELECT art FROM TAGS WHERE word= '$ntag' AND art=$_SESSION[art];";
					$vQuery=pg_query($vConn, $vSql);
					$vResult = pg_fetch_array($vQuery);
					if($vResult["art"]!=NULL){echo"<font size='2' color='red'>Ce mot clé existe déjà.</font><br>";}
					else{
						$vSql="INSERT INTO TAGS (art, word, modi) VALUES('$_SESSION[art]', lower('$ntag'), '$_SESSION[login]');";
						$vQuery=pg_query($vConn, $vSql);
					};
				}
	   		 }
		};


		echo "<input type='submit' name='gererrub' value='Gérer Rubriques'></from><br>";
		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["gererrub"])){Header("Location:rubrique.php");};

		

		
		echo "<div align='center'><br><h4>-----------------------------------------------------------------------------------------------------------</h4><br></div>";
	};//fin de if($editeurdroit)







//les fonctionnements d'auteur
	if($auteurdroit){
		if($statut=='en_redaction'){
			echo "<div align='center'><br><h4>-----------------------------------Fonctionnements de l'auteur----------------------------------------</h4><br>";
			echo "<form method='post' action=''> <input type='submit' name='ajouterb' value='Ajouter un nouveau bloc'></from><br>";
			echo "<form method='post' action=''> <input type='submit' name='supp' value='Supprimer cet article'></from><br>";
			echo "<form method='post' action=''> <input type='submit' name='soumettre' value='Soumettre cet article'></from> <font size='2' color='red'><br>Une fois soumis, cet article ne peux plus être modifié !</font><br>";
			echo "<br><h4>-------------------------------------------------------------------------------------------------</h4><br>";
			if(isset($_POST["ajouterb"])) {Header("Location:bloc.php?choix=ajouter");}
			elseif(isset($_POST["supp"])) {
				$vSql =	"UPDATE ARTICLE SET statut='supprime', modi='$_SESSION[login]' WHERE id=$_SESSION[art];";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location:article.php");
			}
			elseif(isset($_POST["soumettre"])) {
				$vSql =	"UPDATE ARTICLE SET statut='soumis', modi='$_SESSION[login]' WHERE id=$_SESSION[art];";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location:article.php");
			};
		}
		if($statut=='supprime'){
			echo "<form method='post' action=''> <input type='submit' name='recu' value='Récupérer cet article'></from><br>";
			if(isset($_POST["recu"])) {
				$vSql =	"UPDATE ARTICLE SET statut='en_redaction', modi='$_SESSION[login]' WHERE id=$_SESSION[art];";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location:article.php");
			};
		};
	};//fin auteur fonctionnement
	echo"</div>";


//Afficher des commentaires
	echo "<div align='center'>";
	echo "<h4>-------------------------COMMENTAIRE & NOTES-------------------------</h4></div>";
	$vSql =	"SELECT id, aDate AS date, creator, texte, statut FROM COMMENTAIRE WHERE art='$_SESSION[art]' ORDER BY aDate;";
	$vQuery=pg_query($vConn,$vSql);

	while ($vResult = pg_fetch_array($vQuery)){
		if(($vResult["statut"]!='masque' and $vResult["statut"]!='supprime') or ($vResult["statut"]=='masque' and $_SESSION["user"]=="moderateur") or ($vResult["statut"]=='supprime' and $vResult["creator"]==$_SESSION["login"])){
			echo "<b>Commenteur</b> : "."$vResult[creator]"."        <b>Date</b> : "."$vResult[date]   ";
			if($vResult["statut"]=='exergue'){echo "<b>EXEGUE</b>";}
			elseif($vResult["statut"]=='supprime'){echo "<font color='red'>SUPPRIMÉ</font>";}
			elseif($vResult["statut"]=='masque'){echo "<font color='red'>MASQUÉ</font>";}
			echo "<br>";
			echo "$vResult[texte]<br>";

			if($vResult["creator"]==$_SESSION["login"] and $vResult["statut"]!='supprime') {
				echo "<a href='comment.php?action=supprimer&id="."$vResult[id]"."' class='button'>Supprimer</a>&nbsp &nbsp &nbsp &nbsp";
			}
			if($_SESSION["user"]=="moderateur"){
				if($vResult["statut"]!='masque') {
					echo "<a href='comment.php?action=masquer&id="."$vResult[id]"."' class='button'>Masquer</a>&nbsp &nbsp &nbsp &nbsp";
					if($vResult["statut"]!='exergue') {
						echo "<a href='comment.php?action=exergue&id="."$vResult[id]"."' class='button'>Mettre en exergue</a>&nbsp &nbsp &nbsp &nbsp";
					};
				}
				else {
					echo "<a href='comment.php?action=recuperer&id="."$vResult[id]"."' class='button'>Remmettre visible</a>&nbsp &nbsp &nbsp &nbsp";
				};
			};
			echo "<br><br>";


		};//fin if affhiche commentaire
	};//fin while commentaire


//Ajouter un commentaire
	if($_SESSION["user"]!="visiteur"){
		echo "<br><b>Ajoutez un commentaire à cet article : </b><br>";
		echo "<font size='2' color='red'>(Merci d'insérer deux guillements simples ensemble, si vous voulez insérer un guillement simple)</font><br>";
		echo "<form method='post' action=''> ";
		echo "<textarea name='commtxt' rows='5' cols='100'></textarea><br>";
		echo "<input type='submit' name='submitcomm' value='Submit'><br>";
		echo "</form>";

		if($_SERVER["REQUEST_METHOD"] == "POST" and isset($_POST["submitcomm"])){
			if(empty($_POST["commtxt"])){
				echo "<font size='2' color='red'>Saisissez votre commantaire, s'il vous plaît !</font><br>";
			}
			else{
				$ncomm=$_POST["commtxt"];
				$vSql =	"INSERT INTO COMMENTAIRE(id, art, aDate, creator, texte, statut) VALUES(nextval('idauto_comm'), $_SESSION[art], current_timestamp ,'$_SESSION[login]', '$ncomm', 'visible');";
				$vQuery=pg_query($vConn,$vSql);
				Header("Location:article.php");
			};
			
		};

	};

//Afficher le note	
	echo"<b> NOTE MOYEN: </b><br>";
	$vSql =	"SELECT AVG(note) AS moyen, COUNT(*) AS nb FROM NOTE WHERE art=$_SESSION[art];";
	$vQuery=pg_query($vConn,$vSql);
	$vResult = pg_fetch_array($vQuery);
	if($vResult["nb"]==0){
		echo"Il n'y a personne qui a noté.<br>";
	}
	else{
		echo"$vResult[nb] personnes ont noté : $vResult[moyen]<br>";
	};

//Noter l'article
	if($_SESSION["user"]!="visiteur"){
		
		$vSql =	"SELECT note FROM NOTE WHERE noteur='$_SESSION[login]' AND art =$_SESSION[art];";
		$vQuery=pg_query($vConn,$vSql);
		$vResult = pg_fetch_array($vQuery);
		if($vResult["note"]==NULL){
			echo"<br><b>Noter l'article : </b>";

		}else{
			echo"<br><b>Vous avez déjà noté : $vResult[note]</b> /10<br>";
			echo"<br><b>Changez votre note : </b>";
		};
			echo "<form method='post' action=''> ";
			echo "<input type='text' name='note' size='5'/> /10              ";
			echo "<input type='submit' name='submitnote' value='Submit'><br>";
			echo "</form>";

			if(isset($_POST["submitnote"])){
				if(empty($_POST["note"])){
					echo "<font size='2' color='red'>Saisissez votre note, s'il vous plaît !</font><br>";
				}
				else{
					$note=$_POST["note"];
					if(is_int($note) and $note<=10 and $note>=1){
						if($vResult["note"]==NULL){
							$vSql =	"INSERT INTO NOTE(art, noteur, note) VALUES($_SESSION[art], '$_SESSION[login]',$note );";

						}else{
							$vSql =	"UPDATE NOTE SET note = $note WHERE art=$_SESSION[art] AND noteur= '$_SESSION[login]';";
						};
						$vQuery=pg_query($vConn,$vSql);
						Header("Location:article.php");
					}
					else echo "<font size='2' color='red'>Saisissez une note valable, s'il vous plaît !</font><br>";
				};
			
			};


	};

//Des articles lies
	echo "<div align='center'><h4>-----------------------DES ARTICLE LIES-----------------------</h4>";
	$vSql =	"SELECT A.id, A.title, A.statut
			FROM ARTICLE A
			WHERE A.id IN
			(SELECT T1.firstArticle FROM TIE_ARTICLE T1 WHERE T1.secondArticle=$_SESSION[art]
			UNION
			SELECT T2.secondArticle FROM TIE_ARTICLE T2 WHERE T2.firstArticle=$_SESSION[art]);";
	$vQuery=pg_query($vConn,$vSql);
	while ($vResult = pg_fetch_array($vQuery)){
		if(($nodroitpub and $vResult["statut"]=="publie")or !$nodroitpub){
			echo "<a href='article.php?article="."$vResult[id]"."'>"."$vResult[title]"."<br>";
		};
	}


	echo "</div>";
pg_close($vConn);
?>


<p><a href="acceuil.php">Retour</a></p>
</body>
</html>
