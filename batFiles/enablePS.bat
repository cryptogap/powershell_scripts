@ECHO OFF 

:: This batch file details Windows 10, hardware, and networking configuration.

TITLE Zabbix Config





ECHO Would you like to run PowerShell Zabbix? (Y/N)

SET /P choice=Type Y or N and press ENTER: 

IF /I "%choice%" EQU "Y" GOTO :Run

IF /I "%choice%" EQU "N" GOTO :End

:Run

ECHO Running PowerShell Zabbix...

start /wait powershell.exe -executionpolicy remotesigned -File "\\fbcaddata\Company\Common\Zabbix\zabbixConfig.ps1" | ECHO > nul

ECHO PowerShell Zabbix complete.

GOTO :End

:End

Pause