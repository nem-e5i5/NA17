<?php
  function fConnect () {
  $vHost="tuxa.sme.utc";
  $vPort="5432";
  $vDbname="dbnf17p196";
  $vUser="nf17p196";
  $vPassword="CXPMg1dw";
  $vConn = pg_connect("host=$vHost port=$vPort dbname=$vDbname user=$vUser password=$vPassword");
  return $vConn;
}
?>
