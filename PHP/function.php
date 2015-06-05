<?php

function fDroit($login, $vConn) {
	$vSql ="SELECT droit FROM TUSER WHERE login ='$login';";
	$vQuery=pg_query($vConn,$vSql);
	$vResult = pg_fetch_array($vQuery);
	return $vResult['droit'];
}
?>
