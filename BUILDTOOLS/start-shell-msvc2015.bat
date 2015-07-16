@ECHO OFF

SET MOZ_MSVCBITS=32
SET MOZ_MSVCVERSION=14
SET MOZ_MSVCYEAR=2015

REM Switch CWD to the current location so that the call to start.shell-bat
REM doesn't fail if invoked from a different location.
pushd "%~dp0"

CALL start-shell.bat
