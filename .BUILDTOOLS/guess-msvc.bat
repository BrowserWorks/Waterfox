REM -*- Mode: fundamental; tab-width: 8; indent-tabs-mode: 1 -*-
@ECHO OFF

set CYGWIN=
if not defined MOZ_NO_RESET_PATH (
    set PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem
)

REM if DISPLAY is set, rxvt attempts to load libX11.dll and fails to start
REM (see mozilla bug 376828)
SET DISPLAY=

SET INCLUDE=
SET LIB=

SET WINCURVERKEY=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion
REG QUERY "%WINCURVERKEY%" /v "ProgramFilesDir (x86)" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  SET WIN64=1
) else (
  SET WIN64=0
)

if "%WIN64%" == "1" (
  SET MSVCROOTKEY=HKLM\SOFTWARE\Wow6432Node\Microsoft\VisualStudio
  SET MSVCEXPROOTKEY=HKLM\SOFTWARE\Wow6432Node\Microsoft\VCExpress
) else (
  SET MSVCROOTKEY=HKLM\SOFTWARE\Microsoft\VisualStudio
  SET MSVCEXPROOTKEY=HKLM\SOFTWARE\Microsoft\VCExpress
)

SET MSVC10KEY=%MSVCROOTKEY%\10.0\Setup\VC
SET MSVC10EXPRESSKEY=%MSVCEXPROOTKEY%\10.0\Setup\VC
SET MSVC11KEY=%MSVCROOTKEY%\11.0\Setup\VC
SET MSVC11EXPRESSKEY=%MSVCEXPROOTKEY%\11.0\Setup\VC
SET MSVC12KEY=%MSVCROOTKEY%\12.0\Setup\VC
SET MSVC12EXPRESSKEY=%MSVCEXPROOTKEY%\12.0\Setup\VC

REM First see if we can find MSVC, then set the variable
REM NOTE: delims=<tab><space>
REM NOTE: run the initial REQ QUERY outside of the if() to set ERRORLEVEL correctly

REG QUERY "%MSVC10KEY%" /v ProductDir >nul 2>nul
if "%VC10DIR%"=="" (
  REM Newer SDKs (7.1) install the VC10 compilers and set this key,
  REM but they're functionally equivalent to the VC10 Express compilers.
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%MSVC10KEY%" /v ProductDir') DO SET TEMPVC10DIR=%%B
  )
)

REM We'll double-check for a VC10 Pro install here per the comment above.
REG QUERY "%MSVCROOTKEY%\10.0\InstalledProducts\Microsoft Visual C++" >nul 2>nul
if NOT "%TEMPVC10DIR%"=="" (
  IF %ERRORLEVEL% EQU 0 (
    SET "VC10DIR=%TEMPVC10DIR%"
  ) ELSE (
    SET "VC10EXPRESSDIR=%TEMPVC10DIR%"
  )
)

REG QUERY "%MSVC10EXPRESSKEY%" /v ProductDir >nul 2>nul
if "%VC10EXPRESSDIR%"=="" (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%MSVC10EXPRESSKEY%" /v ProductDir') DO SET VC10EXPRESSDIR=%%B
  )
)

REG QUERY "%MSVC11KEY%" /v ProductDir >nul 2>nul
if "%VC11DIR%"=="" (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%MSVC11KEY%" /v ProductDir') DO SET VC11DIR=%%B
  )
)

REG QUERY "%MSVC11EXPRESSKEY%" /v ProductDir >nul 2>nul
if "%VC11EXPRESSDIR%"=="" (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%MSVC11EXPRESSKEY%" /v ProductDir') DO SET VC11EXPRESSDIR=%%B
  )
)

REG QUERY "%MSVC12KEY%" /v ProductDir >nul 2>nul
if "%VC12DIR%"=="" (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%MSVC12KEY%" /v ProductDir') DO SET VC12DIR=%%B
  )
)

REG QUERY "%MSVC12EXPRESSKEY%" /v ProductDir >nul 2>nul
if "%VC12EXPRESSDIR%"=="" (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%MSVC12EXPRESSKEY%" /v ProductDir') DO SET VC12EXPRESSDIR=%%B
  )
)

REM Look for Installed SDKs:
SET SDK7KEY=HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v7.0
SET SDK7AKEY=HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v7.0A
SET SDK71KEY=HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v7.1
REM 8.0 and 8.1 uses same key tree
SET SDKPRODUCTKEY=HKLM\SOFTWARE\Microsoft\Windows Kits\Installed Products
SET SDK80KEY=HKLM\SOFTWARE\Microsoft\Windows Kits\Installed Roots

REM Just a base value to compare against
SET SDKDIR=
SET SDKVER=0
SET SDKMINORVER=0

REM Support a maximum version of the Windows SDK to use, to support older
REM branches and older compilers.  (Note that this is unrelated to the configure
REM option on which version of Windows to support.)
IF NOT DEFINED MOZ_MAXWINSDK (
  REM Maximum WinSDK version to use; 2 digits for major, 2 for minor, 2 for revision
  REM Revivsion is A = 01, B = 02, etc.
  SET MOZ_MAXWINSDK=999999
)

REM Windows Software Development Kit DirectX Remote (SDK 8.1)
if "%WIN64%" == "1" (
  REG QUERY "%SDKPRODUCTKEY%" /v "{5247E16E-BCF8-95AB-1653-B3F8FBF8B3F1}" >nul 2>nul
) else (
  REG QUERY "%SDKPRODUCTKEY%" /v "{A1CB8286-CFB3-A985-D799-721A0F2A27F3}" >nul 2>nul
)
if "%SDKDIR%"=="" IF %MOZ_MAXWINSDK% GEQ 80100 (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%SDK80KEY%" /v KitsRoot81') DO SET SDKDIR=%%B
	SET SDKVER=8
	SET SDKMINORVER=1
  )
)

REM The Installed Products key still exists even if the SDK is uninstalled.
REM Verify that the Windows.h header exists to confirm that the SDK is
REM installed.
IF "%SDKDIR%" NEQ "" IF NOT EXIST "%SDKDIR%\Include\um\Windows.h" (
  SET SDKDIR=
)

REM Windows Software Development Kit DirectX Remote (SDK 8.0)
if "%WIN64%" == "1" (
  REG QUERY "%SDKPRODUCTKEY%" /v "{5FB4C443-6BD6-1514-2717-3827D65AE6FB}" >nul 2>nul
) else (
  REG QUERY "%SDKPRODUCTKEY%" /v "{23176E97-26CB-C72A-19EB-BFB21AC1D15A}" >nul 2>nul
)
if "%SDKDIR%"=="" IF %MOZ_MAXWINSDK% GEQ 80000 (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%SDK80KEY%" /v KitsRoot') DO SET SDKDIR=%%B
	SET SDKVER=8
	SET SDKMINORVER=0
  )
)

REM The Installed Products key still exists even if the SDK is uninstalled.
REM Verify that the Windows.h header exists to confirm that the SDK is
REM installed.
IF "%SDKDIR%" NEQ "" IF NOT EXIST "%SDKDIR%\Include\um\Windows.h" (
  SET SDKDIR=
)

REG QUERY "%SDK71KEY%" /v InstallationFolder >nul 2>nul
if "%SDKDIR%"=="" IF %MOZ_MAXWINSDK% GEQ 70100 (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%SDK71KEY%" /v InstallationFolder') DO SET SDKDIR=%%B
    SET SDKVER=7
    SET SDKMINORVER=1
  )
)

REG QUERY "%SDK7AKEY%" /v InstallationFolder >nul 2>nul
if "%SDKDIR%"=="" IF %MOZ_MAXWINSDK% GEQ 70001 (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%SDK7AKEY%" /v InstallationFolder') DO SET SDKDIR=%%B
    SET SDKVER=7
    SET SDKMINORVER=0A
  )
)

REG QUERY "%SDK7KEY%" /v InstallationFolder >nul 2>nul
if "%SDKDIR%"=="" IF %MOZ_MAXWINSDK% GEQ 70000 (
  IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=2*" %%A IN ('REG QUERY "%SDK7KEY%" /v InstallationFolder') DO SET SDKDIR=%%B
    SET SDKVER=7
  )
)

if defined VC10DIR ECHO Visual C++ 10 directory: %VC10DIR%
if defined VC10EXPRESSDIR ECHO Visual C++ 10 Express directory: %VC10EXPRESSDIR%
if defined VC11DIR ECHO Visual C++ 11 directory: %VC11DIR%
if defined VC11EXPRESSDIR ECHO Visual C++ 11 Express directory: %VC11EXPRESSDIR%
if defined VC12DIR ECHO Visual C++ 12 directory: %VC12DIR%
if defined VC12EXPRESSDIR ECHO Visual C++ 12 Express directory: %VC12EXPRESSDIR%

setlocal enableextensions enabledelayedexpansion

if "!SDKDIR!"=="" (
    SET SDKDIR=!PSDKDIR!
    SET SDKVER=%PSDKVER%
) else (
    ECHO Windows SDK directory: !SDKDIR!
    ECHO Windows SDK version: %SDKVER%.%SDKMINORVER%
)
if not "!PSDKDIR!"=="" (
    ECHO Platform SDK directory: !PSDKDIR!
    ECHO Platform SDK version: %PSDKVER%
)

setlocal disableextensions enabledelayedexpansion
