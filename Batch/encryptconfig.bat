@ECHO OFF

IF EXIST %cd%\fwservice.exe.config (
	REN fwsyslog.exe.config web.config 
) ELSE (
	GOTO FNFAbort
)

c:\windows\microsoft.net\framework\v4.0.30319\aspnet_regiis.exe -pef "connectionStrings" %CD%
REN web.config fwsyslog.exe.config

ECHO.
ECHO Batch complete.
ECHO.
GOTO EOB

:FNFAbort
ECHO.
ECHO Batch aborted!  File fwsyslog.exe.config not found in current directory.
ECHO.


:EOB
ECHO ON


