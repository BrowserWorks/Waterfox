@echo off

SETLOCAL
SET MOZ_MSVCVERSION=12
SET MOZBUILDDIR=%~dp0
SET MOZILLABUILD=%MOZBUILDDIR%

echo "Mozilla tools directory: %MOZBUILDDIR%"

REM Get MSVC paths
call "%MOZBUILDDIR%guess-msvc.bat"

REM Use the "new" moztools-static
set MOZ_TOOLS=%MOZBUILDDIR%moztools-x64

rem append moztools to PATH
SET PATH=%PATH%;%MOZ_TOOLS%\bin

if "%VC12DIR%"=="" (
    if "%VC12EXPRESSDIR%"=="" (
        ECHO "Microsoft Visual C++ version 12 (2013) was not found. Exiting."
        pause
        EXIT /B 1
    )

    if "%SDKDIR%"=="" (
        ECHO "Microsoft Platform SDK was not found. Exiting."
        pause
        EXIT /B 1
    )

    rem Prepend MSVC paths
    call "%VC12EXPRESSDIR%\bin\x86_amd64\vcvarsx86_amd64.bat" 2>nul
    if "%DevEnvDir%"=="" (
      rem Might be using a compiler that shipped with an SDK, so manually set paths
      SET "PATH=%VC12EXPRESSDIR%\Bin\x86_amd64;%VC12EXPRESSDIR%\Bin;%PATH%"
      SET "INCLUDE=%VC12EXPRESSDIR%\Include;%VC12EXPRESSDIR%\Include\Sys;%INCLUDE%"
      SET "LIB=%VC12EXPRESSDIR%\Lib\amd64;%VC12EXPRESSDIR%\Lib;%LIB%"
    )

    rem Don't set SDK paths in this block, because blocks are early-evaluated.

    rem Fix problem with VC++Express Edition
    if "%SDKVER%" GEQ "6" (
        rem SDK Ver.6.0 (Windows Vista SDK) and newer
        rem do not contain ATL header files.
        rem We need to use the Platform SDK's ATL header files.
        SET USEPSDKATL=1
    )
    rem SDK ver.6.0 does not contain OleAcc.idl
    rem We need to use the Platform SDK's OleAcc.idl
    if "%SDKVER%" == "6" (
        if "%SDKMINORVER%" == "0" (
          SET USEPSDKIDL=1
        )
    )
) else (
    rem Prepend MSVC paths
    rem By default, the Windows 8.1 SDK should be automatically included via vcvars64.bat.
    if exist "%VC12DIR%\bin\amd64\vcvars64.bat" (
        call "%VC12DIR%\bin\amd64\vcvars64.bat"
    ) else (
        call "%VC12DIR%\bin\x86_amd64\vcvarsx86_amd64.bat"
    )
    ECHO Using the built-in Windows 8.1 SDK
)

if "%VC12DIR%"=="" (
    rem Prepend SDK paths - Don't use the SDK SetEnv.cmd because it pulls in
    rem random VC paths which we don't want.
    set "PATH=%SDKDIR%\bin\x64;%SDKDIR%\bin;%PATH%"
    set "LIB=%SDKDIR%\lib\x64;%SDKDIR%\lib;%LIB%"

    if "%USEPSDKATL%"=="1" (
        if "%USEPSDKIDL%"=="1" (
            set "INCLUDE=%SDKDIR%\include;%PSDKDIR%\include\atl;%PSDKDIR%\include;%INCLUDE%"
        ) else (
            set "INCLUDE=%SDKDIR%\include;%PSDKDIR%\include\atl;%INCLUDE%"
        )
    ) else (
        if "%USEPSDKIDL%"=="1" (
            set "INCLUDE=%SDKDIR%\include;%SDKDIR%\include\atl;%PSDKDIR%\include;%INCLUDE%"
        ) else (
            set "INCLUDE=%SDKDIR%\include;%SDKDIR%\include\atl;%INCLUDE%"
        )
    )
)

cd "%USERPROFILE%"

"%MOZILLABUILD%\msys\bin\bash" --login -i
