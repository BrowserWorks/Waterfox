@ECHO OFF

SET MOZ_MSVCBITS=64
SET MOZ_MSVCVERSION=12
SET MOZ_MSVCYEAR=2013

REM Switch CWD to the current location so that the call to start.shell-bat
REM doesn't fail if invoked from a different location.
pushd "%~dp0"

CALL start-shell.bat
