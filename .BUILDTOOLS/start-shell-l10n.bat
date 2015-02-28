@echo off

SETLOCAL
SET MOZILLABUILDDRIVE=%~d0%
SET MOZILLABUILDPATH=%~p0%
SET MOZILLABUILD=%MOZILLABUILDDRIVE%%MOZILLABUILDPATH%

echo "Mozilla tools directory: %MOZILLABUILD%"

REM Use the "new" moztools-static
set MOZ_TOOLS=%MOZILLABUILD%\moztools

rem append moztools to PATH
SET PATH=%PATH%;%MOZ_TOOLS%\bin

cd "%USERPROFILE%"
%MOZILLABUILD%\msys\bin\bash --login -i
