<?php session_start(); if (!isset($_SESSION["user"])) {$_SESSION["user"] = "lecteur";}?>
<html>
	<head>
		<title>accueil - <?php echo $_SESSION["user"]; ?></title>
	</head>
	<body>
		<?php include($_SESSION["user"] . ".php");?>
	</body>
</html>