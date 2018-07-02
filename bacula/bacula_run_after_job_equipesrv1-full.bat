echo off
REM # Elimino non ricorsivamente i files di backup totale piu vecchi di n giori
if [%1] == [Full] GOTO run
goto:eof

:run
SET PERCORSOSTORICO="Z:\BACKUP-DR_STORICO\EQUIPESRV1"
SET X_OLD_FILES=31
echo on
for /f "skip=%X_OLD_FILES% delims=" %%f in ('dir /a:-d /b /o:-d "%PERCORSOSTORICO%\*.*"') do (del "%PERCORSOSTORICO%\%%~nf%%~xf")
echo Elimino lo storico piu vecchio di %X_OLD_FILES% giorni


