echo off
REM # Sposto tutto il contenuto recente nella cartella storico, faccio lo svecchiamento
if [%1] == [Full] GOTO run
goto:eof

:run
setlocal enableextensions
SET PERCORSORECENT="Z:\BACKUP-DR\EQUIPESRV1"
SET PERCORSOSTORICO="Z:\BACKUP-DR_STORICO\EQUIPESRV1"
dir /b /a-d %PERCORSORECENT%\ >nul 2>nul && GOTO piena
goto:eof
:piena
echo on
move /Y %PERCORSORECENT%\*.* %PERCORSOSTORICO%\
