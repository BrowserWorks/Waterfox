@echo off

SETLOCAL
SET MOZ_MSVCVERSION=11
SET MOZBUILDDIR=%~dp0
SET MOZILLABUILD=%MOZBUILDDIR%

echo "Mozilla tools directory: %MOZBUILDDIR%"

REM Get MSVC paths
call "%MOZBUILDDIR%guess-msvc.bat"

REM Use the "new" moztools-static
set MOZ_TOOLS=%MOZBUILDDIR%moztools-x64

rem append moztools to PATH
SET PATH=%PATH%;%MOZ_TOOLS%\bin

if "%VC11DIR%"=="" (
    if "%VC11EXPRESSDIR%"=="" (
        ECHO "Microsoft Visual C++ version 11 (2012) was not found. Exiting."
        pause
        EXIT /B 1
    )

    if "%SDKDIR%"=="" (
        ECHO "Microsoft Platform SDK was not found. Exiting."
        pause
        EXIT /B 1
    )

    rem Prepend MSVC paths
    call "%VC11EXPRESSDIR%\bin\x86_amd64\vcvarsx86_amd64.bat" 2>nul
    if "%DevEnvDir%"=="" (
      rem Might be using a compiler that shipped with an SDK, so manually set paths
      SET "PATH=%VC11EXPRESSDIR%\Bin\x86_amd64;%VC11EXPRESSDIR%\Bin;%PATH%"
      SET "INCLUDE=%VC11EXPRESSDIR%\Include;%VC11EXPRESSDIR%\Include\Sys;%INCLUDE%"
      SET "LIB=%VC11EXPRESSDIR%\Lib\amd64;%VC11EXPRESSDIR%\Lib;%LIB%"
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
    if exist "%VC11DIR%\bin\amd64\vcvars64.bat" (
        call "%VC11DIR%\bin\amd64\vcvars64.bat"
    ) else (
        call "%VC11DIR%\bin\x86_amd64\vcvarsx86_amd64.bat"
    )
)

rem By default, the Windows 8.0 SDK should be automatically included via vcvars64.bat above.
rem If installed, prepend the Windows 8.1 SDK to give it priority instead.
if "%SDKVER%"=="8" (
    if "%SDKMINORVER%"=="1" (
        ECHO Using the installed Windows 8.1 SDK
        set "PATH=%SDKDIR%bin\x64;%PATH%"
        set "LIB=%SDKDIR%Lib\winv6.3\um\x64;%LIB%"
        set "LIBPATH=%SDKDIR%Lib\winv6.3\um\x64;%LIBPATH%"
        set "INCLUDE=%SDKDIR%Include\shared;%SDKDIR%Include\um;%SDKDIR%Include\winrt;%SDKDIR%Include\winrt\wrl;%SDKDIR%Include\winrt\wrl\wrappers;%INCLUDE%"
        set "WINDOWSSDKDIR=%SDKDIR%"
    ) else (
        ECHO Using the built-in Windows 8.0 SDK
    )
)

if "%VC11DIR%"=="" (
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
