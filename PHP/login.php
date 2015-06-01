<?php session_start(); if ($_SESSION["user"]) {unset($_SESSION["user"]);} if (!isset($_POST["user"])) {?>
<html>
	<head>
		<title>connexion</title>
	</head>
	<body>
		<form method="post" action="login.php">
			<input name="user" type="text" value="utilisateur" />
			<input name="pass" type="password" value="" />
			<input type="submit" />
		</form>
	</body>
</html>
<?php } else {

if (user_exists($_POST["user"], $_POST["pass"]))
{
	$_SESSION["user"] = user_droit($_POST["user"]);
	header("Location: index.php");
}
else
{
	?><p>identifiants incorrects.</p><?php
}
}?>