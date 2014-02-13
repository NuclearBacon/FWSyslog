@ECHO OFF

IF EXIST %cd%\fwservice.exe (
	c:\windows\microsoft.net\framework\v4.0.30319\installutil.exe %cd%\fwsyslog.exe
) ELSE (
	GOTO FNFAbort
)

ECHO.
ECHO Batch complete.
ECHO.
GOTO EOB

:FNFAbort
ECHO.
ECHO Batch aborted!  File fwsyslog.exe not found in current directory.
ECHO.


:EOB
ECHO ON


