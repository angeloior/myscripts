<?php

// Effettua semplici backups via SSH (tar e mysqldump)
// TODO: validazione del config.json
// TODO: perfezionamento gestione degli errori

date_default_timezone_set("Europe/Rome");

$freq = (isset($argv[1]) ? $argv[1] : '');

if (!in_array($freq, array("monthly", "weekly", "daily"))) {
	logmessage("Frequenza ".$freq." non disponibile.");
	exit(1);
}

$config = json_decode(file_get_contents("config.json"), true);

if (!is_array($config)) {
	logmessage("Errore di sintassi nel config.json.");
	exit(1);
}

if (!validConfig($config)) {
	logmessage("Configurazione non valida nel file config.json.");
	exit(1);
}

cleanOldBackups($config, $freq);

foreach ($config['machines'] as $machineName => $machine) {
	foreach ($machine['backups'] as $backup) {
		$backupDir = $config['general']['backup_destination'].'/'.$freq.'/'.$machineName.'/';
		if (!is_dir($backupDir)) mkdir($backupDir, 0755, true);
		switch ($backup['type']) {
			case 'tar':
				$backupFilePath = $backupDir.'/'.$backup['prefix']."_".date('YmdHis').".tar";
				$remotecmd = "tar cvf - -C \"".dirname($backup['dir'])."\" \"".basename($backup['dir'])."\"";
				logmessage("Effettuo il tar della directory ".$backup['dir']." macchina ".$machineName);
				exec("ssh ".$machine['sshuser']."@".$machine['sshhost']." \"".$remotecmd
						."\" > ".$backupFilePath, $ret);
				if (is_file($backupFilePath)) {
					logmessage("Tar della directory ".$backup['dir']." macchina ".$machineName." creato.");
				} else {
					logmessage("ERRORE nel tar della directory ".$backup['dir']." macchina ".$machineName);
				}
				break;
			case 'mysqldump':
				$backupFilePath = $backupDir.'/'.$backup['prefix']."_".date('YmdHis').".sql";
				$remotecmd = "mysqldump -u ".$backup['mysqluser']." --password=".$backup['mysqlpwd']." ".$backup['mysqldb'];
				logmessage("Effettuo il mysqldump del DB ".$backup['mysqldb']." macchina ".$machineName);
				exec("ssh ".$machine['sshuser']."@".$machine['sshhost']." \"".$remotecmd
						."\" > ".$backupFilePath, $ret);
				if (is_file($backupFilePath)) {
					logmessage("Dump del DB ".$backup['mysqldb']." macchina ".$machineName." creato.");
				} else {
					logmessage("ERRORE nel dump del DB ".$backup['mysqldb']." macchina ".$machineName);
				}
				break;
			default:
				logmessage("Tipo di backup ".$backup['type']." per la macchina ".$machinename." non riconosciuto.");
				break;
		}
		if (is_file($backupFilePath) && $config['general']['compression'] == true) {
			compressFile($backupFilePath);
		}
	}
}

function logmessage($msg) {
	print date("Y-m-d H:i:s")." - ".$msg."\n";
}

function cleanOldBackups($config, $freq) {
	logmessage("Pulizia dei files piu' vecchi...");
	$retentionDays = $config['general'][$freq.'_retention_days'];
	$backupDir = $config['general']['backup_destination'].'/'.$freq.'/';
	exec("find ".$backupDir." -type f -mtime +".$retentionDays." -exec rm -vf {} \;");
	echo("find ".$backupDir." -type f -mtime +".$retentionDays." -exec rm -vf {} \;");
}

function compressFile($file) {
	exec("cat ".$file." | gzip > ".$file.".gz", $ret);
	exec("rm -vf ".$file, $ret);
	if (is_file($file.".gz")) {
		logmessage("Compressione di ".$file." effettuata.");
	} else {
		logmessage("Errore nella compressione di ".$file." effettuata.");
	}
	return $ret;
}

function validConfig($config) {
	return true;
}
