<?php

//viene inviato dall'esterno come testo il contenuto di un file xml
//inserisce nella variabile datapost il post ricevuto via http
$dataPOST = file_get_contents("php://input");

//scrive il contenuto ricevuto via http post in un file xml
file_put_contents('vms-scriba.xml', $dataPOST);

?>