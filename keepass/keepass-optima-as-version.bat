@echo off
rem mettere echo on/off per trb
set username=%1
set password=%2
set ipaddress=%3

rem set data=%date:~6,4%%date:~3,2%%date:~0,2%
rem echo %data% > %ipaddress%-%data%.conf
rem #%username% -pw %password% %ipaddress%

E:\PORTABLE\putty\plink.exe -ssh -l %username% -pw %password% %ipaddress% "cat /opt/ptv-optima-as/standalone/deployments/datex-interface.war/META-INF/MANIFEST.MF | grep 'Implementation-Version'"
pause