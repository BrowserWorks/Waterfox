# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

!macro PostUpdate
  ; PostUpdate is called from both session 0 and from the user session
  ; for service updates, make sure that we only register with the user session
  ; Otherwise ApplicationID::Set can fail intermittently with a file in use error.
  System::Call "kernel32::GetCurrentProcessId() i.r0"
  System::Call "kernel32::ProcessIdToSessionId(i $0, *i ${NSIS_MAX_STRLEN} r9)"

  ; Determine if we're the protected UserChoice default or not. If so fix the
  ; start menu tile.  In case there are 2 Waterfox installations, we only do
  ; this if the application being updated is the default.
  ReadRegStr $0 HKCU "Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" "ProgId"
  ${WordFind} "$0" "-" "+1{" $0
  ${If} $0 == "WaterfoxURL"
  ${AndIf} $9 != 0 ; We're not running in session 0
    ReadRegStr $0 HKCU "Software\Classes\WaterfoxURL\shell\open\command" ""
    ${GetPathFromString} "$0" $0
    ${GetParent} "$0" $0
    ${If} ${FileExists} "$0"
      ${GetLongPath} "$0" $0
    ${EndIf}
  ${EndIf}

  ${CreateShortcutsLog}

  ; Remove registry entries for non-existent apps and for apps that point to our
  ; install location in the Software\Mozilla key and uninstall registry entries
  ; that point to our install location for both HKCU and HKLM.
  SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)
  ${RegCleanMain} "Software\Mozilla"
  ${RegCleanUninstall}
  ${UpdateProtocolHandlers}

  ; setup the application model id registration value
  ${InitHashAppModelId} "$INSTDIR" "Software\Mozilla\${AppName}\TaskBarIDs"

  ; Win7 taskbar and start menu link maintenance
  Call FixShortcutAppModelIDs

  ClearErrors
  WriteRegStr HKLM "Software\Mozilla" "${BrandShortName}InstallerTest" "Write Test"
  ${If} ${Errors}
    StrCpy $TmpVal "HKCU"
  ${Else}
    SetShellVarContext all    ; Set SHCTX to all users (e.g. HKLM)
    DeleteRegValue HKLM "Software\Mozilla" "${BrandShortName}InstallerTest"
    StrCpy $TmpVal "HKLM"
    ${RegCleanMain} "Software\Mozilla"
    ${RegCleanUninstall}
    ${UpdateProtocolHandlers}
    ${FixShellIconHandler} "HKLM"
    ${SetAppLSPCategories} ${LSP_CATEGORIES}

    ; Win7 taskbar and start menu link maintenance
    Call FixShortcutAppModelIDs

    ; Add the Firewall entries after an update
    Call AddFirewallEntries

    ReadRegStr $0 HKLM "Software\mozilla.org\Mozilla" "CurrentVersion"
    ${If} "$0" != "${GREVersion}"
      WriteRegStr HKLM "Software\mozilla.org\Mozilla" "CurrentVersion" "${GREVersion}"
    ${EndIf}
  ${EndIf}

  ; Migrate the application's Start Menu directory to a single shortcut in the
  ; root of the Start Menu Programs directory.
  ${MigrateStartMenuShortcut}

  ; Update lastwritetime of the Start Menu shortcut to clear the tile cache.
  ${If} ${AtLeastWin8}
  ${AndIf} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    FileOpen $0 "$SMPROGRAMS\${BrandFullName}.lnk" a
    FileClose $0
  ${EndIf}

  ; Adds a pinned Task Bar shortcut (see MigrateTaskBarShortcut for details).
  ${MigrateTaskBarShortcut}

  ${UpdateShortcutBranding}

  ${RemoveDeprecatedKeys}
  ${Set32to64DidMigrateReg}

  ${SetAppKeys}
  ${FixClassKeys}
  ${SetUninstallKeys}
  ${If} $TmpVal == "HKLM"
    ${SetStartMenuInternet} HKLM
  ${ElseIf} $TmpVal == "HKCU"
    ${SetStartMenuInternet} HKCU
  ${EndIf}

  ; Remove files that may be left behind by the application in the
  ; VirtualStore directory.
  ${CleanVirtualStore}

  ${RemoveDeprecatedFiles}

  ; Fix the distribution.ini file if applicable
  ${FixDistributionsINI}

  RmDir /r /REBOOTOK "$INSTDIR\${TO_BE_DELETED}"

  ; Register AccessibleHandler.dll with COM (this writes to HKLM)
  ${RegisterAccessibleHandler}

!ifdef MOZ_MAINTENANCE_SERVICE
  Call IsUserAdmin
  Pop $R0
  ${If} $R0 == "true"
  ; Only proceed if we have HKLM write access
  ${AndIf} $TmpVal == "HKLM"
    ; We check to see if the maintenance service install was already attempted.
    ; Since the Maintenance service can be installed either x86 or x64,
    ; always use the 64-bit registry for checking if an attempt was made.
    ${If} ${RunningX64}
      SetRegView 64
    ${EndIf}
    ReadRegDWORD $5 HKLM "Software\Mozilla\MaintenanceService" "Attempted"
    ClearErrors
    ${If} ${RunningX64}
      SetRegView lastused
    ${EndIf}

    ; Add the registry keys for allowed certificates.
    ${AddMaintCertKeys}

    ; If the maintenance service is already installed, do nothing.
    ; The maintenance service will launch:
    ; maintenanceservice_installer.exe /Upgrade to upgrade the maintenance
    ; service if necessary.   If the update was done from updater.exe without
    ; the service (i.e. service is failing), updater.exe will do the update of
    ; the service.  The reasons we do not do it here is because we don't want
    ; to have to prompt for limited user accounts when the service isn't used
    ; and we currently call the PostUpdate twice, once for the user and once
    ; for the SYSTEM account.  Also, this would stop the maintenance service
    ; and we need a return result back to the service when run that way.
    ${If} $5 == ""
      ; An install of maintenance service was never attempted.
      ; We know we are an Admin and that we have write access into HKLM
      ; based on the above checks, so attempt to just run the EXE.
      ; In the worst case, in case there is some edge case with the
      ; IsAdmin check and the permissions check, the maintenance service
      ; will just fail to be attempted to be installed.
      nsExec::Exec "$\"$INSTDIR\maintenanceservice_installer.exe$\""
    ${EndIf}
  ${EndIf}
!endif
!macroend
!define PostUpdate "!insertmacro PostUpdate"

!macro SetAsDefaultAppGlobal
  ${RemoveDeprecatedKeys} ; Does not use SHCTX

  SetShellVarContext all      ; Set SHCTX to all users (e.g. HKLM)
  ${SetHandlers} ; Uses SHCTX
  ${SetStartMenuInternet} "HKLM"
  ${FixShellIconHandler} "HKLM"
  ${ShowShortcuts}
!macroend
!define SetAsDefaultAppGlobal "!insertmacro SetAsDefaultAppGlobal"

; Removes shortcuts for this installation. This should also remove the
; application from Open With for the file types the application handles
; (bug 370480).
!macro HideShortcuts
  ; Find the correct registry path to clear IconsVisible.
  StrCpy $R1 "Software\Clients\StartMenuInternet\${AppRegName}-$AppUserModelID\InstallInfo"
  ReadRegDWORD $0 HKLM "$R1" "ShowIconsCommand"
  ${If} ${Errors}
    ${StrFilter} "${FileMainEXE}" "+" "" "" $0
    StrCpy $R1 "Software\Clients\StartMenuInternet\$0\InstallInfo"
  ${EndIf}
  WriteRegDWORD HKLM "$R1" "IconsVisible" 0
  ${If} ${AtLeastWin8}
    WriteRegDWORD HKCU "$R1" "IconsVisible" 0
  ${EndIf}

  SetShellVarContext all  ; Set $DESKTOP to All Users
  ${Unless} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
    SetShellVarContext current  ; Set $DESKTOP to the current user's desktop
  ${EndUnless}

  ${If} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
    ShellLink::GetShortCutArgs "$DESKTOP\${BrandFullName}.lnk"
    Pop $0
    ${If} "$0" == ""
      ShellLink::GetShortCutTarget "$DESKTOP\${BrandFullName}.lnk"
      Pop $0
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR\${FileMainEXE}"
        Delete "$DESKTOP\${BrandFullName}.lnk"
      ${EndIf}
    ${EndIf}
  ${EndIf}

  SetShellVarContext all  ; Set $SMPROGRAMS to All Users
  ${Unless} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    SetShellVarContext current  ; Set $SMPROGRAMS to the current user's Start
                                ; Menu Programs directory
  ${EndUnless}

  ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    ShellLink::GetShortCutArgs "$SMPROGRAMS\${BrandFullName}.lnk"
    Pop $0
    ${If} "$0" == ""
      ShellLink::GetShortCutTarget "$SMPROGRAMS\${BrandFullName}.lnk"
      Pop $0
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR\${FileMainEXE}"
        Delete "$SMPROGRAMS\${BrandFullName}.lnk"
      ${EndIf}
    ${EndIf}
  ${EndIf}

  ${If} ${FileExists} "$QUICKLAUNCH\${BrandFullName}.lnk"
    ShellLink::GetShortCutArgs "$QUICKLAUNCH\${BrandFullName}.lnk"
    Pop $0
    ${If} "$0" == ""
      ShellLink::GetShortCutTarget "$QUICKLAUNCH\${BrandFullName}.lnk"
      Pop $0
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR\${FileMainEXE}"
        Delete "$QUICKLAUNCH\${BrandFullName}.lnk"
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define HideShortcuts "!insertmacro HideShortcuts"

; Adds shortcuts for this installation. This should also add the application
; to Open With for the file types the application handles (bug 370480).
!macro ShowShortcuts
  ; Find the correct registry path to set IconsVisible.
  StrCpy $R1 "Software\Clients\StartMenuInternet\${AppRegName}-$AppUserModelID\InstallInfo"
  ReadRegDWORD $0 HKLM "$R1" "ShowIconsCommand"
  ${If} ${Errors}
    ${StrFilter} "${FileMainEXE}" "+" "" "" $0
    StrCpy $R1 "Software\Clients\StartMenuInternet\$0\InstallInfo"
  ${EndIf}
  WriteRegDWORD HKLM "$R1" "IconsVisible" 1
  ${If} ${AtLeastWin8}
    WriteRegDWORD HKCU "$R1" "IconsVisible" 1
  ${EndIf}

  SetShellVarContext all  ; Set $DESKTOP to All Users
  ${Unless} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
    CreateShortCut "$DESKTOP\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
    ${If} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
      ShellLink::SetShortCutWorkingDirectory "$DESKTOP\${BrandFullName}.lnk" "$INSTDIR"
      ${If} ${AtLeastWinXP}
      ${AndIf} "$AppUserModelID" != ""
        ApplicationID::Set "$DESKTOP\${BrandFullName}.lnk" "$AppUserModelID" "true"
      ${EndIf}
    ${Else}
      SetShellVarContext current  ; Set $DESKTOP to the current user's desktop
      ${Unless} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
        CreateShortCut "$DESKTOP\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
        ${If} ${FileExists} "$DESKTOP\${BrandFullName}.lnk"
          ShellLink::SetShortCutWorkingDirectory "$DESKTOP\${BrandFullName}.lnk" \
                                                 "$INSTDIR"
          ${If} ${AtLeastWinXP}
          ${AndIf} "$AppUserModelID" != ""
            ApplicationID::Set "$DESKTOP\${BrandFullName}.lnk" "$AppUserModelID" "true"
          ${EndIf}
        ${EndIf}
      ${EndUnless}
    ${EndIf}
  ${EndUnless}

  SetShellVarContext all  ; Set $SMPROGRAMS to All Users
  ${Unless} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
    CreateShortCut "$SMPROGRAMS\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
    ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
      ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\${BrandFullName}.lnk" \
                                             "$INSTDIR"
      ${If} ${AtLeastWinXP}
      ${AndIf} "$AppUserModelID" != ""
        ApplicationID::Set "$SMPROGRAMS\${BrandFullName}.lnk" "$AppUserModelID" "true"
      ${EndIf}
    ${Else}
      SetShellVarContext current  ; Set $SMPROGRAMS to the current user's Start
                                  ; Menu Programs directory
      ${Unless} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
        CreateShortCut "$SMPROGRAMS\${BrandFullName}.lnk" "$INSTDIR\${FileMainEXE}"
        ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
          ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\${BrandFullName}.lnk" \
                                                 "$INSTDIR"
          ${If} ${AtLeastWinXP}
          ${AndIf} "$AppUserModelID" != ""
            ApplicationID::Set "$SMPROGRAMS\${BrandFullName}.lnk" "$AppUserModelID" "true"
          ${EndIf}
        ${EndIf}
      ${EndUnless}
    ${EndIf}
  ${EndUnless}

  ; Windows 7 doesn't use the QuickLaunch directory
  ${Unless} ${AtLeastWinXP}
  ${AndUnless} ${FileExists} "$QUICKLAUNCH\${BrandFullName}.lnk"
    CreateShortCut "$QUICKLAUNCH\${BrandFullName}.lnk" \
                   "$INSTDIR\${FileMainEXE}"
    ${If} ${FileExists} "$QUICKLAUNCH\${BrandFullName}.lnk"
      ShellLink::SetShortCutWorkingDirectory "$QUICKLAUNCH\${BrandFullName}.lnk" \
                                             "$INSTDIR"
    ${EndIf}
  ${EndUnless}
!macroend
!define ShowShortcuts "!insertmacro ShowShortcuts"

; Update the branding information on all shortcuts our installer created,
; in case the branding has changed between updates.
; This should only be called sometime after both MigrateStartMenuShortcut
; and MigrateTaskBarShurtcut
!macro UpdateShortcutBranding
  ${GetLongPath} "$INSTDIR\uninstall\${SHORTCUTS_LOG}" $R9
  ${If} ${FileExists} "$R9"
    ClearErrors
    ; The entries in the shortcut log are numbered, but we never actually
    ; create more than one shortcut (or log entry) in each location.
    ReadINIStr $R8 "$R9" "STARTMENU" "Shortcut0"
    ${IfNot} ${Errors}
      ${If} ${FileExists} "$SMPROGRAMS\$R8"
        ShellLink::GetShortCutTarget "$SMPROGRAMS\$R8"
        Pop $R7
        ${GetLongPath} "$R7" $R7
        ${If} $R7 == "$INSTDIR\${FileMainEXE}"
          ShellLink::GetShortCutIconLocation "$SMPROGRAMS\$R8"
          Pop $R6
          ${GetLongPath} "$R6" $R6
          ${If} $R6 != "$INSTDIR\firefox.ico"
          ${AndIf} ${FileExists} "$INSTDIR\firefox.ico"
            StrCpy $R5 "1"
          ${ElseIf} $R6 == "$INSTDIR\firefox.ico"
          ${AndIfNot} ${FileExists} "$INSTDIR\firefox.ico"
            StrCpy $R5 "1"
          ${Else}
            StrCpy $R5 "0"
          ${EndIf}

          ${If} $R5 == "1"
          ${OrIf} $R8 != "${BrandFullName}.lnk"
            Delete "$SMPROGRAMS\$R8"
            ${If} ${FileExists} "$INSTDIR\firefox.ico"
              CreateShortcut "$SMPROGRAMS\${BrandFullName}.lnk" \
                             "$INSTDIR\${FileMainEXE}" "" "$INSTDIR\firefox.ico"
            ${Else}
              CreateShortcut "$SMPROGRAMS\${BrandFullName}.lnk" \
                             "$INSTDIR\${FileMainEXE}"
            ${EndIf}
            WriteINIStr "$R9" "STARTMENU" "Shortcut0" "${BrandFullName}.lnk"
          ${EndIf}
        ${EndIf}
      ${EndIf}
    ${EndIf}

    ClearErrors
    ReadINIStr $R8 "$R9" "DESKTOP" "Shortcut0"
    ${IfNot} ${Errors}
      ${If} ${FileExists} "$DESKTOP\$R8"
        ShellLink::GetShortCutTarget "$DESKTOP\$R8"
        Pop $R7
        ${GetLongPath} "$R7" $R7
        ${If} $R7 == "$INSTDIR\${FileMainEXE}"
          ShellLink::GetShortCutIconLocation "$DESKTOP\$R8"
          Pop $R6
          ${GetLongPath} "$R6" $R6
          ${If} $R6 != "$INSTDIR\firefox.ico"
          ${AndIf} ${FileExists} "$INSTDIR\firefox.ico"
            StrCpy $R5 "1"
          ${ElseIf} $R6 == "$INSTDIR\firefox.ico"
          ${AndIfNot} ${FileExists} "$INSTDIR\firefox.ico"
            StrCpy $R5 "1"
          ${Else}
            StrCpy $R5 "0"
          ${EndIf}

          ${If} $R5 == "1"
          ${OrIf} $R8 != "${BrandFullName}.lnk"
            Delete "$DESKTOP\$R8"
            ${If} ${FileExists} "$INSTDIR\firefox.ico"
              CreateShortcut "$DESKTOP\${BrandFullName}.lnk" \
                             "$INSTDIR\${FileMainEXE}" "" "$INSTDIR\firefox.ico"
            ${Else}
              CreateShortcut "$DESKTOP\${BrandFullName}.lnk" \
                             "$INSTDIR\${FileMainEXE}"
            ${EndIf}
            WriteINIStr "$R9" "DESKTOP" "Shortcut0" "${BrandFullName}.lnk"
          ${EndIf}
        ${EndIf}
      ${EndIf}
    ${EndIf}

    ClearErrors
    ReadINIStr $R8 "$R9" "QUICKLAUNCH" "Shortcut0"
    ${IfNot} ${Errors}
      ; "QUICKLAUNCH" actually means a taskbar pin.
      ; We can't simultaneously rename and change the icon for a taskbar pin
      ; without the icon breaking, and the icon is more important than the name,
      ; so we'll forget about changing the name and just overwrite the icon.
      ${If} ${FileExists} "$QUICKLAUNCH\User Pinned\TaskBar\$R8"
        ShellLink::GetShortCutTarget "$QUICKLAUNCH\User Pinned\TaskBar\$R8"
        Pop $R7
        ${GetLongPath} "$R7" $R7
        ${If} "$INSTDIR\${FileMainEXE}" == "$R7"
          ShellLink::GetShortCutIconLocation "$QUICKLAUNCH\User Pinned\TaskBar\$R8"
          Pop $R6
          ${GetLongPath} "$R6" $R6
          ${If} $R6 != "$INSTDIR\firefox.ico"
          ${AndIf} ${FileExists} "$INSTDIR\firefox.ico"
            StrCpy $R5 "1"
          ${ElseIf} $R6 == "$INSTDIR\firefox.ico"
          ${AndIfNot} ${FileExists} "$INSTDIR\firefox.ico"
            StrCpy $R5 "1"
          ${Else}
            StrCpy $R5 "0"
          ${EndIf}

          ${If} $R5 == "1"
            ${If} ${FileExists} "$INSTDIR\firefox.ico"
              CreateShortcut "$QUICKLAUNCH\User Pinned\TaskBar\$R8" "$R7" "" \
                             "$INSTDIR\firefox.ico"
            ${Else}
              CreateShortcut "$QUICKLAUNCH\User Pinned\TaskBar\$R8" "$R7"
            ${EndIf}
          ${EndIf}
        ${EndIf}
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define UpdateShortcutBranding "!insertmacro UpdateShortcutBranding"

!macro AddAssociationIfNoneExist FILE_TYPE KEY
  ClearErrors
  EnumRegKey $7 HKCR "${FILE_TYPE}" 0
  ${If} ${Errors}
    WriteRegStr SHCTX "SOFTWARE\Classes\${FILE_TYPE}"  "" ${KEY}
  ${EndIf}
  WriteRegStr SHCTX "SOFTWARE\Classes\${FILE_TYPE}\OpenWithProgids" ${KEY} ""
!macroend
!define AddAssociationIfNoneExist "!insertmacro AddAssociationIfNoneExist"

; Adds the protocol and file handler registry entries for making Waterfox the
; default handler (uses SHCTX).
!macro SetHandlers
  ${GetLongPath} "$INSTDIR\${FileMainEXE}" $8

  ; See if we're using path hash suffixed registry keys for this install.
  StrCpy $5 ""
  ${StrFilter} "${FileMainEXE}" "+" "" "" $2
  ReadRegStr $0 SHCTX "Software\Clients\StartMenuInternet\$2\DefaultIcon" ""
  StrCpy $0 $0 -2
  ${If} $0 != $8
    StrCpy $5 "-$AppUserModelID"
  ${EndIf}

  StrCpy $0 "SOFTWARE\Classes"
  StrCpy $2 "$\"$8$\" -osint -url $\"%1$\""

  ; Associate the file handlers with WaterfoxHTML, if they aren't already.
  ReadRegStr $6 SHCTX "$0\.htm" ""
  ${WordFind} "$6" "-" "+1{" $6
  ${If} "$6" != "WaterfoxHTML"
    WriteRegStr SHCTX "$0\.htm"   "" "WaterfoxHTML$5"
  ${EndIf}

  ReadRegStr $6 SHCTX "$0\.html" ""
  ${WordFind} "$6" "-" "+1{" $6
  ${If} "$6" != "WaterfoxHTML"
    WriteRegStr SHCTX "$0\.html"  "" "WaterfoxHTML$5"
  ${EndIf}

  ReadRegStr $6 SHCTX "$0\.shtml" ""
  ${WordFind} "$6" "-" "+1{" $6
  ${If} "$6" != "WaterfoxHTML"
    WriteRegStr SHCTX "$0\.shtml" "" "WaterfoxHTML$5"
  ${EndIf}

  ReadRegStr $6 SHCTX "$0\.xht" ""
  ${WordFind} "$6" "-" "+1{" $6
  ${If} "$6" != "WaterfoxHTML"
    WriteRegStr SHCTX "$0\.xht"   "" "WaterfoxHTML$5"
  ${EndIf}

  ReadRegStr $6 SHCTX "$0\.xhtml" ""
  ${WordFind} "$6" "-" "+1{" $6
  ${If} "$6" != "WaterfoxHTML"
    WriteRegStr SHCTX "$0\.xhtml" "" "WaterfoxHTML$5"
  ${EndIf}

  ${AddAssociationIfNoneExist} ".pdf" "WaterfoxHTML$5"
  ${AddAssociationIfNoneExist} ".oga" "WaterfoxHTML$5"
  ${AddAssociationIfNoneExist} ".ogg" "WaterfoxHTML$5"
  ${AddAssociationIfNoneExist} ".ogv" "WaterfoxHTML$5"
  ${AddAssociationIfNoneExist} ".pdf" "WaterfoxHTML$5"
  ${AddAssociationIfNoneExist} ".webm" "WaterfoxHTML$5"

  ; An empty string is used for the 5th param because WaterfoxHTML is not a
  ; protocol handler
  ${AddDisabledDDEHandlerValues} "WaterfoxHTML$5" "$2" "$8,1" \
                                 "${AppRegName} HTML Document" ""

  ${AddDisabledDDEHandlerValues} "WaterfoxURL$5" "$2" "$8,1" "${AppRegName} URL" \
                                 "true"
  ; An empty string is used for the 4th & 5th params because the following
  ; protocol handlers already have a display name and the additional keys
  ; required for a protocol handler.
  ${AddDisabledDDEHandlerValues} "ftp" "$2" "$8,1" "" ""
  ${AddDisabledDDEHandlerValues} "http" "$2" "$8,1" "" ""
  ${AddDisabledDDEHandlerValues} "https" "$2" "$8,1" "" ""
!macroend
!define SetHandlers "!insertmacro SetHandlers"

; Adds the HKLM\Software\Clients\StartMenuInternet\Waterfox-[pathhash] registry
; entries (does not use SHCTX).
;
; The values for StartMenuInternet are only valid under HKLM and there can only
; be one installation registerred under StartMenuInternet per application since
; the key name is derived from the main application executable.
;
; In Windows 8 this changes slightly, you can store StartMenuInternet entries in
; HKCU.  The icon in start menu for StartMenuInternet is deprecated as of Win7,
; but the subkeys are what's important.  Control panel default programs looks
; for them only in HKLM pre win8.
;
; The StartMenuInternet key and friends are documented at
; https://msdn.microsoft.com/en-us/library/windows/desktop/cc144109(v=vs.85).aspx
;
; This function also writes our RegisteredApplications entry, which gets us
; listed in the Settings app's default browser options on Windows 8+, and in
; Set Program Access and Defaults on earlier versions.
!macro SetStartMenuInternet RegKey
  ${GetLongPath} "$INSTDIR\${FileMainEXE}" $8
  ${GetLongPath} "$INSTDIR\uninstall\helper.exe" $7
  
  ; Handle the Firefox-$AppUserModelID Key and Value that can exist
  ; from previous Waterfox versions where ${AppRegName} was set to "Firefox".
  DeleteRegKey ${RegKey} "Software\Clients\StartMenuInternet\Firefox-$AppUserModelID"
  DeleteRegValue ${RegKey} "Software\RegisteredApplications" "Firefox-$AppUserModelID"
  ClearErrors

  ; If we already have keys at the old FIREFOX.EXE path, then just update those.
  ; We have to be careful to update the existing keys in place so that we don't
  ; create duplicate keys for the same installation, or cause Windows to think
  ; something "suspicious" has happened and it should reset the default browser.
  ${StrFilter} "${FileMainEXE}" "+" "" "" $1
  ReadRegStr $0 ${RegKey} "Software\Clients\StartMenuInternet\$1\DefaultIcon" ""
  StrCpy $0 $0 -2
  ${If} $0 != $8
    StrCpy $1 "${AppRegName}-$AppUserModelID"
    StrCpy $2 "-$AppUserModelID"
  ${Else}
    StrCpy $2 ""
  ${EndIf}
  StrCpy $0 "Software\Clients\StartMenuInternet\$1"

  WriteRegStr ${RegKey} "$0" "" "${BrandFullName}"

  WriteRegStr ${RegKey} "$0\DefaultIcon" "" "$8,0"

  ; The Reinstall Command is defined at
  ; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/shell/programmersguide/shell_adv/registeringapps.asp
  WriteRegStr ${RegKey} "$0\InstallInfo" "HideIconsCommand" "$\"$7$\" /HideShortcuts"
  WriteRegStr ${RegKey} "$0\InstallInfo" "ShowIconsCommand" "$\"$7$\" /ShowShortcuts"
  WriteRegStr ${RegKey} "$0\InstallInfo" "ReinstallCommand" "$\"$7$\" /SetAsDefaultAppGlobal"
  WriteRegDWORD ${RegKey} "$0\InstallInfo" "IconsVisible" 1

  WriteRegStr ${RegKey} "$0\shell\open\command" "" "$\"$8$\""

  WriteRegStr ${RegKey} "$0\shell\properties" "" "$(CONTEXT_OPTIONS)"
  WriteRegStr ${RegKey} "$0\shell\properties\command" "" "$\"$8$\" -preferences"

  WriteRegStr ${RegKey} "$0\shell\safemode" "" "$(CONTEXT_SAFE_MODE)"
  WriteRegStr ${RegKey} "$0\shell\safemode\command" "" "$\"$8$\" -safe-mode"

  ; Capabilities registry keys
  WriteRegStr ${RegKey} "$0\Capabilities" "ApplicationDescription" "$(REG_APP_DESC)"
  WriteRegStr ${RegKey} "$0\Capabilities" "ApplicationIcon" "$8,0"
  WriteRegStr ${RegKey} "$0\Capabilities" "ApplicationName" "${BrandShortName}"

  WriteRegStr ${RegKey} "$0\Capabilities\FileAssociations" ".htm"   "WaterfoxHTML$2"
  WriteRegStr ${RegKey} "$0\Capabilities\FileAssociations" ".html"  "WaterfoxHTML$2"
  WriteRegStr ${RegKey} "$0\Capabilities\FileAssociations" ".shtml" "WaterfoxHTML$2"
  WriteRegStr ${RegKey} "$0\Capabilities\FileAssociations" ".xht"   "WaterfoxHTML$2"
  WriteRegStr ${RegKey} "$0\Capabilities\FileAssociations" ".xhtml" "WaterfoxHTML$2"

  WriteRegStr ${RegKey} "$0\Capabilities\StartMenu" "StartMenuInternet" "$1"

  WriteRegStr ${RegKey} "$0\Capabilities\URLAssociations" "ftp"    "WaterfoxURL$2"
  WriteRegStr ${RegKey} "$0\Capabilities\URLAssociations" "http"   "WaterfoxURL$2"
  WriteRegStr ${RegKey} "$0\Capabilities\URLAssociations" "https"  "WaterfoxURL$2"

  ; Registered Application
  WriteRegStr ${RegKey} "Software\RegisteredApplications" "$1" "$0\Capabilities"
!macroend
!define SetStartMenuInternet "!insertmacro SetStartMenuInternet"

; Add registry keys to support the Firefox 32 bit to 64 bit migration. These
; registry entries are not removed on uninstall at this time. After the Firefox
; 32 bit to 64 bit migration effort is completed these registry entries can be
; removed during install, post update, and uninstall.
!macro Set32to64DidMigrateReg
  ${GetLongPath} "$INSTDIR" $1
  ; These registry keys are always in the 32 bit hive since they are never
  ; needed by a Firefox 64 bit install unless it has been updated from Firefox
  ; 32 bit.
  SetRegView 32

!ifdef HAVE_64BIT_BUILD

  ; Running Firefox 64 bit on Windows 64 bit
  ClearErrors
  ReadRegDWORD $2 HKLM "Software\Mozilla\${AppName}\32to64DidMigrate" "$1"
  ; If there were no errors then the system was updated from Firefox 32 bit to
  ; Firefox 64 bit and if the value is already 1 then the registry value has
  ; already been updated in the HKLM registry.
  ${IfNot} ${Errors}
  ${AndIf} $2 != 1
    ClearErrors
    WriteRegDWORD HKLM "Software\Mozilla\${AppName}\32to64DidMigrate" "$1" 1
    ${If} ${Errors}
      ; There was an error writing to HKLM so just write it to HKCU
      WriteRegDWORD HKCU "Software\Mozilla\${AppName}\32to64DidMigrate" "$1" 1
    ${Else}
      ; This will delete the value from HKCU if it exists
      DeleteRegValue HKCU "Software\Mozilla\${AppName}\32to64DidMigrate" "$1"
    ${EndIf}
  ${EndIf}

  ClearErrors
  ReadRegDWORD $2 HKCU "Software\Mozilla\${AppName}\32to64DidMigrate" "$1"
  ; If there were no errors then the system was updated from Firefox 32 bit to
  ; Firefox 64 bit and if the value is already 1 then the registry value has
  ; already been updated in the HKCU registry.
  ${IfNot} ${Errors}
  ${AndIf} $2 != 1
    WriteRegDWORD HKCU "Software\Mozilla\${AppName}\32to64DidMigrate" "$1" 1
  ${EndIf}

!else

  ; Running Firefox 32 bit
  ${If} ${RunningX64}
    ; Running Firefox 32 bit on a Windows 64 bit system
    ClearErrors
    ReadRegDWORD $2 HKLM "Software\Mozilla\${AppName}\32to64DidMigrate" "$1"
    ; If there were errors the value doesn't exist yet.
    ${If} ${Errors}
      ClearErrors
      WriteRegDWORD HKLM "Software\Mozilla\${AppName}\32to64DidMigrate" "$1" 0
      ; If there were errors write the value in HKCU.
      ${If} ${Errors}
        WriteRegDWORD HKCU "Software\Mozilla\${AppName}\32to64DidMigrate" "$1" 0
      ${EndIf}
    ${EndIf}
  ${EndIf}

!endif

  ClearErrors
  SetRegView lastused
!macroend
!define Set32to64DidMigrateReg "!insertmacro Set32to64DidMigrateReg"

; The IconHandler reference for WaterfoxHTML can end up in an inconsistent state
; due to changes not being detected by the IconHandler for side by side
; installs (see bug 268512). The symptoms can be either an incorrect icon or no
; icon being displayed for files associated with Waterfox (does not use SHCTX).
!macro FixShellIconHandler RegKey
  ; Find the correct key to update, either WaterfoxHTML or WaterfoxHTML-[PathHash]
  StrCpy $3 "WaterfoxHTML-$AppUserModelID"
  ClearErrors
  ReadRegStr $0 ${RegKey} "Software\Classes\$3\DefaultIcon" ""
  ${If} ${Errors}
    StrCpy $3 "WaterfoxHTML"
  ${EndIf}

  ClearErrors
  ReadRegStr $1 ${RegKey} "Software\Classes\$3\ShellEx\IconHandler" ""
  ${Unless} ${Errors}
    ReadRegStr $1 ${RegKey} "Software\Classes\$3\DefaultIcon" ""
    ${GetLongPath} "$INSTDIR\${FileMainEXE}" $2
    ${If} "$1" != "$2,1"
      WriteRegStr ${RegKey} "Software\Classes\$3\DefaultIcon" "" "$2,1"
    ${EndIf}
  ${EndUnless}
!macroend
!define FixShellIconHandler "!insertmacro FixShellIconHandler"

; Add Software\Mozilla\ registry entries (uses SHCTX).
!macro SetAppKeys
  ; Check if this is an ESR release and if so add registry values so it is
  ; possible to determine that this is an ESR install (bug 726781).
  ClearErrors
  ${WordFind} "${UpdateChannel}" "esr" "E#" $3
  ${If} ${Errors}
    StrCpy $3 ""
  ${Else}
    StrCpy $3 " ESR"
  ${EndIf}

  ${GetLongPath} "$INSTDIR" $8
  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal}\${AppVersion}$3 (${ARCH} ${AB_CD})\Main"
  ${WriteRegStr2} $TmpVal "$0" "Install Directory" "$8" 0
  ${WriteRegStr2} $TmpVal "$0" "PathToExe" "$8\${FileMainEXE}" 0

  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal}\${AppVersion}$3 (${ARCH} ${AB_CD})\Uninstall"
  ${WriteRegStr2} $TmpVal "$0" "Description" "${BrandFullNameInternal} ${AppVersion}$3 (${ARCH} ${AB_CD})" 0

  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal}\${AppVersion}$3 (${ARCH} ${AB_CD})"
  ${WriteRegStr2} $TmpVal  "$0" "" "${AppVersion}$3 (${ARCH} ${AB_CD})" 0
  ${If} "$3" == ""
    DeleteRegValue SHCTX "$0" "ESR"
  ${Else}
    ${WriteRegDWORD2} $TmpVal "$0" "ESR" 1 0
  ${EndIf}

  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal} ${AppVersion}$3\bin"
  ${WriteRegStr2} $TmpVal "$0" "PathToExe" "$8\${FileMainEXE}" 0

  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal} ${AppVersion}$3\extensions"
  ${WriteRegStr2} $TmpVal "$0" "Components" "$8\components" 0
  ${WriteRegStr2} $TmpVal "$0" "Plugins" "$8\plugins" 0

  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal} ${AppVersion}$3"
  ${WriteRegStr2} $TmpVal "$0" "GeckoVer" "${GREVersion}" 0
  ${If} "$3" == ""
    DeleteRegValue SHCTX "$0" "ESR"
  ${Else}
    ${WriteRegDWORD2} $TmpVal "$0" "ESR" 1 0
  ${EndIf}

  StrCpy $0 "Software\Mozilla\${BrandFullNameInternal}$3"
  ${WriteRegStr2} $TmpVal "$0" "" "${GREVersion}" 0
  ${WriteRegStr2} $TmpVal "$0" "CurrentVersion" "${AppVersion}$3 (${ARCH} ${AB_CD})" 0
!macroend
!define SetAppKeys "!insertmacro SetAppKeys"

; Add uninstall registry entries. This macro tests for write access to determine
; if the uninstall keys should be added to HKLM or HKCU.
!macro SetUninstallKeys
  ; Check if this is an ESR release and if so add registry values so it is
  ; possible to determine that this is an ESR install (bug 726781).
  ClearErrors
  ${WordFind} "${UpdateChannel}" "esr" "E#" $3
  ${If} ${Errors}
    StrCpy $3 ""
  ${Else}
    StrCpy $3 " ESR"
  ${EndIf}

  StrCpy $0 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${BrandFullNameInternal} ${AppVersion}$3 (${ARCH} ${AB_CD})"

  StrCpy $2 ""
  ClearErrors
  WriteRegStr HKLM "$0" "${BrandShortName}InstallerTest" "Write Test"
  ${If} ${Errors}
    ; If the uninstall keys already exist in HKLM don't create them in HKCU
    ClearErrors
    ReadRegStr $2 "HKLM" $0 "DisplayName"
    ${If} $2 == ""
      ; Otherwise we don't have any keys for this product in HKLM so proceeed
      ; to create them in HKCU.  Better handling for this will be done in:
      ; Bug 711044 - Better handling for 2 uninstall icons
      StrCpy $1 "HKCU"
      SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)
    ${EndIf}
    ClearErrors
  ${Else}
    StrCpy $1 "HKLM"
    SetShellVarContext all     ; Set SHCTX to all users (e.g. HKLM)
    DeleteRegValue HKLM "$0" "${BrandShortName}InstallerTest"
  ${EndIf}

  ${If} $2 == ""
    ${GetLongPath} "$INSTDIR" $8

    ; Write the uninstall registry keys
    ${WriteRegStr2} $1 "$0" "Comments" "${BrandFullNameInternal} ${AppVersion}$3 (${ARCH} ${AB_CD})" 0
    ${WriteRegStr2} $1 "$0" "DisplayIcon" "$8\${FileMainEXE},0" 0
    ${WriteRegStr2} $1 "$0" "DisplayName" "${BrandFullNameInternal} ${AppVersion}$3 (${ARCH} ${AB_CD})" 0
    ${WriteRegStr2} $1 "$0" "DisplayVersion" "${AppVersion}" 0
    ${WriteRegStr2} $1 "$0" "HelpLink" "${HelpLink}" 0
    ${WriteRegStr2} $1 "$0" "InstallLocation" "$8" 0
    ${WriteRegStr2} $1 "$0" "Publisher" "${CompanyName}" 0
    ${WriteRegStr2} $1 "$0" "UninstallString" "$\"$8\uninstall\helper.exe$\"" 0
    DeleteRegValue SHCTX "$0" "URLInfoAbout"
; Don't add URLUpdateInfo which is the release notes url except for the release
; and esr channels since nightly, aurora, and beta do not have release notes.
; Note: URLUpdateInfo is only defined in the official branding.nsi.
!ifdef URLUpdateInfo
!ifndef BETA_UPDATE_CHANNEL
    ${WriteRegStr2} $1 "$0" "URLUpdateInfo" "${URLUpdateInfo}" 0
!endif
!endif
    ${WriteRegStr2} $1 "$0" "URLInfoAbout" "${URLInfoAbout}" 0
    ${WriteRegDWORD2} $1 "$0" "NoModify" 1 0
    ${WriteRegDWORD2} $1 "$0" "NoRepair" 1 0

    ${GetSize} "$8" "/S=0K" $R2 $R3 $R4
    ${WriteRegDWORD2} $1 "$0" "EstimatedSize" $R2 0

    ${If} "$TmpVal" == "HKLM"
      SetShellVarContext all     ; Set SHCTX to all users (e.g. HKLM)
    ${Else}
      SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)
    ${EndIf}
  ${EndIf}
!macroend
!define SetUninstallKeys "!insertmacro SetUninstallKeys"

; Due to a bug when associating some file handlers, only SHCTX was checked for
; some file types such as ".pdf". SHCTX is set to HKCU or HKLM depending on
; whether the installer has write access to HKLM. The bug would happen when
; HCKU was checked and didn't exist since programs aren't required to set the
; HKCU Software\Classes keys when associating handlers. The fix uses the merged
; view in HKCR to check for existance of an existing association. This macro
; cleans affected installations by removing the HKLM and HKCU value if it is set
; to WaterfoxHTML when there is a value for PersistentHandler or by removing the
; HKCU value when the HKLM value has a value other than an empty string.
!macro FixBadFileAssociation FILE_TYPE
  ; Only delete the default value in case the key has values for OpenWithList,
  ; OpenWithProgids, PersistentHandler, etc.
  ReadRegStr $0 HKCU "Software\Classes\${FILE_TYPE}" ""
  ${WordFind} "$0" "-" "+1{" $0
  ReadRegStr $1 HKLM "Software\Classes\${FILE_TYPE}" ""
  ${WordFind} "$1" "-" "+1{" $1
  ReadRegStr $2 HKCR "${FILE_TYPE}\PersistentHandler" ""
  ${If} "$2" != ""
    ; Since there is a persistent handler remove WaterfoxHTML as the default
    ; value from both HKCU and HKLM if it set to WaterfoxHTML.
    ${If} "$0" == "WaterfoxHTML"
      DeleteRegValue HKCU "Software\Classes\${FILE_TYPE}" ""
    ${EndIf}
    ${If} "$1" == "WaterfoxHTML"
      DeleteRegValue HKLM "Software\Classes\${FILE_TYPE}" ""
    ${EndIf}
  ${ElseIf} "$0" == "WaterfoxHTML"
    ; Since HKCU is set to WaterfoxHTML remove WaterfoxHTML as the default value
    ; from HKCU if HKLM is set to a value other than an empty string.
    ${If} "$1" != ""
      DeleteRegValue HKCU "Software\Classes\${FILE_TYPE}" ""
    ${EndIf}
  ${EndIf}
!macroend
!define FixBadFileAssociation "!insertmacro FixBadFileAssociation"

; Add app specific handler registry entries under Software\Classes if they
; don't exist (does not use SHCTX).
!macro FixClassKeys
  StrCpy $1 "SOFTWARE\Classes"

  ; File handler keys and name value pairs that may need to be created during
  ; install or upgrade.
  ReadRegStr $0 HKCR ".shtml" "Content Type"
  ${If} "$0" == ""
    StrCpy $0 "$1\.shtml"
    ${WriteRegStr2} $TmpVal "$1\.shtml" "" "shtmlfile" 0
    ${WriteRegStr2} $TmpVal "$1\.shtml" "Content Type" "text/html" 0
    ${WriteRegStr2} $TmpVal "$1\.shtml" "PerceivedType" "text" 0
  ${EndIf}

  ReadRegStr $0 HKCR ".xht" "Content Type"
  ${If} "$0" == ""
    ${WriteRegStr2} $TmpVal "$1\.xht" "" "xhtfile" 0
    ${WriteRegStr2} $TmpVal "$1\.xht" "Content Type" "application/xhtml+xml" 0
  ${EndIf}

  ReadRegStr $0 HKCR ".xhtml" "Content Type"
  ${If} "$0" == ""
    ${WriteRegStr2} $TmpVal "$1\.xhtml" "" "xhtmlfile" 0
    ${WriteRegStr2} $TmpVal "$1\.xhtml" "Content Type" "application/xhtml+xml" 0
  ${EndIf}

  ; Remove possibly badly associated file types
  ${FixBadFileAssociation} ".pdf"
  ${FixBadFileAssociation} ".oga"
  ${FixBadFileAssociation} ".ogg"
  ${FixBadFileAssociation} ".ogv"
  ${FixBadFileAssociation} ".pdf"
  ${FixBadFileAssociation} ".webm"
!macroend
!define FixClassKeys "!insertmacro FixClassKeys"

; Updates protocol handlers if their registry open command value is for this
; install location (uses SHCTX).
!macro UpdateProtocolHandlers
  ; Store the command to open the app with an url in a register for easy access.
  ${GetLongPath} "$INSTDIR\${FileMainEXE}" $8
  StrCpy $2 "$\"$8$\" -osint -url $\"%1$\""

  ; Only set the file and protocol handlers if the existing one under HKCR is
  ; for this install location.

  ${IsHandlerForInstallDir} "WaterfoxHTML-$AppUserModelID" $R9
  ${If} "$R9" == "true"
    ; An empty string is used for the 5th param because WaterfoxHTML is not a
    ; protocol handler.
    ${AddDisabledDDEHandlerValues} "WaterfoxHTML-$AppUserModelID" "$2" "$8,1" \
                                   "${AppRegName} HTML Document" ""
  ${Else}
    ${IsHandlerForInstallDir} "WaterfoxHTML" $R9
    ${If} "$R9" == "true"
      ${AddDisabledDDEHandlerValues} "WaterfoxHTML" "$2" "$8,1" \
                                     "${AppRegName} HTML Document" ""
    ${EndIf}
  ${EndIf}

  ${IsHandlerForInstallDir} "WaterfoxURL-$AppUserModelID" $R9
  ${If} "$R9" == "true"
    ${AddDisabledDDEHandlerValues} "WaterfoxURL-$AppUserModelID" "$2" "$8,1" \
                                   "${AppRegName} URL" "true"
  ${Else}
    ${IsHandlerForInstallDir} "WaterfoxURL" $R9
    ${If} "$R9" == "true"
      ${AddDisabledDDEHandlerValues} "WaterfoxURL" "$2" "$8,1" \
                                     "${AppRegName} URL" "true"
    ${EndIf}
  ${EndIf}

  ; An empty string is used for the 4th & 5th params because the following
  ; protocol handlers already have a display name and the additional keys
  ; required for a protocol handler.
  ${IsHandlerForInstallDir} "ftp" $R9
  ${If} "$R9" == "true"
    ${AddDisabledDDEHandlerValues} "ftp" "$2" "$8,1" "" ""
  ${EndIf}

  ${IsHandlerForInstallDir} "http" $R9
  ${If} "$R9" == "true"
    ${AddDisabledDDEHandlerValues} "http" "$2" "$8,1" "" ""
  ${EndIf}

  ${IsHandlerForInstallDir} "https" $R9
  ${If} "$R9" == "true"
    ${AddDisabledDDEHandlerValues} "https" "$2" "$8,1" "" ""
  ${EndIf}
!macroend
!define UpdateProtocolHandlers "!insertmacro UpdateProtocolHandlers"

!ifdef MOZ_MAINTENANCE_SERVICE
; Adds maintenance service certificate keys for the install dir.
; For the cert to work, it must also be signed by a trusted cert for the user.
!macro AddMaintCertKeys
  Push $R0
  ; Allow main Mozilla cert information for updates
  ; This call will push the needed key on the stack
  ServicesHelper::PathToUniqueRegistryPath "$INSTDIR"
  Pop $R0
  ${If} $R0 != ""
    ; More than one certificate can be specified in a different subfolder
    ; for example: $R0\1, but each individual binary can be signed
    ; with at most one certificate.  A fallback certificate can only be used
    ; if the binary is replaced with a different certificate.
    ; We always use the 64bit registry for certs.
    ${If} ${RunningX64}
      SetRegView 64
    ${EndIf}

    ; PrefetchProcessName was originally used to experiment with deleting
    ; Windows prefetch as a speed optimization.  It is no longer used though.
    DeleteRegValue HKLM "$R0" "prefetchProcessName"

    ; Setting the Attempted value will ensure that a new Maintenance Service
    ; install will never be attempted again after this from updates.  The value
    ; is used only to see if updates should attempt new service installs.
    WriteRegDWORD HKLM "Software\Mozilla\MaintenanceService" "Attempted" 1

    ; These values associate the allowed certificates for the current
    ; installation.
    WriteRegStr HKLM "$R0\0" "name" "${CERTIFICATE_NAME}"
    WriteRegStr HKLM "$R0\0" "issuer" "${CERTIFICATE_ISSUER}"
    ; These values associate the allowed certificates for the previous
    ;  installation, so that we can update from it cleanly using the
    ;  old updater.exe (which will still have this signature).
    WriteRegStr HKLM "$R0\1" "name" "${CERTIFICATE_NAME_PREVIOUS}"
    WriteRegStr HKLM "$R0\1" "issuer" "${CERTIFICATE_ISSUER_PREVIOUS}"
    ${If} ${RunningX64}
      SetRegView lastused
    ${EndIf}
    ClearErrors
  ${EndIf}
  ; Restore the previously used value back
  Pop $R0
!macroend
!define AddMaintCertKeys "!insertmacro AddMaintCertKeys"
!endif

!macro RegisterAccessibleHandler
  ${RegisterDLL} "$INSTDIR\AccessibleHandler.dll"
!macroend
!define RegisterAccessibleHandler "!insertmacro RegisterAccessibleHandler"

; Removes various registry entries for reasons noted below (does not use SHCTX).
!macro RemoveDeprecatedKeys
  StrCpy $0 "SOFTWARE\Classes"
  ; Remove support for launching chrome urls from the shell during install or
  ; update if the DefaultIcon is from firefox.exe (Bug 301073).
  ${RegCleanAppHandler} "chrome"

  ; Remove protocol handler registry keys added by the MS shim
  DeleteRegKey HKLM "Software\Classes\Waterfox.URL"
  DeleteRegKey HKCU "Software\Classes\Waterfox.URL"
!macroend
!define RemoveDeprecatedKeys "!insertmacro RemoveDeprecatedKeys"

; Removes various directories and files for reasons noted below.
!macro RemoveDeprecatedFiles
  ; Remove talkback if it is present (remove after bug 386760 is fixed)
  ${If} ${FileExists} "$INSTDIR\extensions\talkback@mozilla.org"
    RmDir /r /REBOOTOK "$INSTDIR\extensions\talkback@mozilla.org"
  ${EndIf}

  ; Remove the Java Console extension (bug 1165156)
  ${If} ${FileExists} "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0031-ABCDEFFEDCBA}"
    RmDir /r /REBOOTOK "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0031-ABCDEFFEDCBA}"
  ${EndIf}
  ${If} ${FileExists} "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0034-ABCDEFFEDCBA}"
    RmDir /r /REBOOTOK "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0034-ABCDEFFEDCBA}"
  ${EndIf}
  ${If} ${FileExists} "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0039-ABCDEFFEDCBA}"
    RmDir /r /REBOOTOK "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0039-ABCDEFFEDCBA}"
  ${EndIf}
  ${If} ${FileExists} "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0045-ABCDEFFEDCBA}"
    RmDir /r /REBOOTOK "$INSTDIR\extensions\{CAFEEFAC-0016-0000-0045-ABCDEFFEDCBA}"
  ${EndIf}
  ${If} ${FileExists} "$INSTDIR\extensions\{CAFEEFAC-0017-0000-0000-ABCDEFFEDCBA}"
    RmDir /r /REBOOTOK "$INSTDIR\extensions\{CAFEEFAC-0017-0000-0000-ABCDEFFEDCBA}"
  ${EndIf}
!macroend
!define RemoveDeprecatedFiles "!insertmacro RemoveDeprecatedFiles"

; Converts specific partner distribution.ini from ansi to utf-8 (bug 882989)
!macro FixDistributionsINI
  StrCpy $1 "$INSTDIR\distribution\distribution.ini"
  StrCpy $2 "$INSTDIR\distribution\utf8fix"
  StrCpy $0 "0" ; Default to not attempting to fix

  ; Check if the distribution.ini settings are for a partner build that needs
  ; to have its distribution.ini converted from ansi to utf-8.
  ${If} ${FileExists} "$1"
    ${Unless} ${FileExists} "$2"
      ReadINIStr $3 "$1" "Preferences" "app.distributor"
      ${If} "$3" == "yahoo"
        ReadINIStr $3 "$1" "Preferences" "app.distributor.channel"
        ${If} "$3" == "de"
        ${OrIf} "$3" == "es"
        ${OrIf} "$3" == "e1"
        ${OrIf} "$3" == "mx"
          StrCpy $0 "1"
        ${EndIf}
      ${EndIf}
      ; Create the utf8fix so this only runs once
      FileOpen $3 "$2" w
      FileClose $3
    ${EndUnless}
  ${EndIf}

  ${If} "$0" == "1"
    StrCpy $0 "0"
    ClearErrors
    ReadINIStr $3 "$1" "Global" "version"
    ${Unless} ${Errors}
      StrCpy $4 "$3" 2
      ${If} "$4" == "1."
        StrCpy $4 "$3" "" 2 ; Everything after "1."
        ${If} $4 < 23
          StrCpy $0 "1"
        ${EndIf}
      ${EndIf}
    ${EndUnless}
  ${EndIf}

  ${If} "$0" == "1"
    ClearErrors
    FileOpen $3 "$1" r
    ${If} ${Errors}
      FileClose $3
    ${Else}
      StrCpy $2 "$INSTDIR\distribution\distribution.new"
      ClearErrors
      FileOpen $4 "$2" w
      ${If} ${Errors}
        FileClose $3
        FileClose $4
      ${Else}
        StrCpy $0 "0" ; Default to not replacing the original distribution.ini
        ${Do}
          FileReadByte $3 $5
          ${If} $5 == ""
            ${Break}
          ${EndIf}
          ${If} $5 == 233 ; ansi é
            StrCpy $0 "1"
            FileWriteByte $4 195
            FileWriteByte $4 169
          ${ElseIf} $5 == 241 ; ansi ñ
            StrCpy $0 "1"
            FileWriteByte $4 195
            FileWriteByte $4 177
          ${ElseIf} $5 == 252 ; ansi ü
            StrCpy $0 "1"
            FileWriteByte $4 195
            FileWriteByte $4 188
          ${ElseIf} $5 < 128
            FileWriteByte $4 $5
          ${EndIf}
        ${Loop}
        FileClose $3
        FileClose $4
        ${If} "$0" == "1"
          ClearErrors
          Rename "$1" "$1.bak"
          ${Unless} ${Errors}
            Rename "$2" "$1"
            Delete "$1.bak"
          ${EndUnless}
        ${Else}
          Delete "$2"
        ${EndIf}
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define FixDistributionsINI "!insertmacro FixDistributionsINI"

; Adds a pinned shortcut to Task Bar on update for Windows 7 and above if this
; macro has never been called before and the application is default (see
; PinToTaskBar for more details).
; Since defaults handling is handled by Windows in Win8 and later, we always
; attempt to pin a taskbar on that OS.  If Windows sets the defaults at
; installation time, then we don't get the opportunity to run this code at
; that time.
!macro MigrateTaskBarShortcut
  ${GetShortcutsLogPath} $0
  ${If} ${FileExists} "$0"
    ClearErrors
    ReadINIStr $1 "$0" "TASKBAR" "Migrated"
    ${If} ${Errors}
      ClearErrors
      WriteIniStr "$0" "TASKBAR" "Migrated" "true"
      ${If} ${AtLeastWinXP}
        ; If we didn't run the stub installer, AddTaskbarSC will be empty.
        ; We determine whether to pin based on whether we're the default
        ; browser, or if we're on win8 or later, we always pin.
        ${If} $AddTaskbarSC == ""
          ; No need to check the default on Win8 and later
          ${If} ${AtMostWin2008R2}
            ; Check if the Waterfox is the http handler for this user
            SetShellVarContext current ; Set SHCTX to the current user
            ${IsHandlerForInstallDir} "http" $R9
            ${If} $TmpVal == "HKLM"
              SetShellVarContext all ; Set SHCTX to all users
            ${EndIf}
          ${EndIf}
          ${If} "$R9" == "true"
          ${OrIf} ${AtLeastWin8}
            ${PinToTaskBar}
          ${EndIf}
        ${ElseIf} $AddTaskbarSC == "1"
          ${PinToTaskBar}
        ${EndIf}
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define MigrateTaskBarShortcut "!insertmacro MigrateTaskBarShortcut"

; Adds a pinned Task Bar shortcut on Windows 7 if there isn't one for the main
; application executable already. Existing pinned shortcuts for the same
; application model ID must be removed first to prevent breaking the pinned
; item's lists but multiple installations with the same application model ID is
; an edgecase. If removing existing pinned shortcuts with the same application
; model ID removes a pinned pinned Start Menu shortcut this will also add a
; pinned Start Menu shortcut.
!macro PinToTaskBar
  ${If} ${AtLeastWinXP}
    StrCpy $8 "false" ; Whether a shortcut had to be created
    ${IsPinnedToTaskBar} "$INSTDIR\${FileMainEXE}" $R9
    ${If} "$R9" == "false"
      ; Find an existing Start Menu shortcut or create one to use for pinning
      ${GetShortcutsLogPath} $0
      ${If} ${FileExists} "$0"
        ClearErrors
        ReadINIStr $1 "$0" "STARTMENU" "Shortcut0"
        ${Unless} ${Errors}
          SetShellVarContext all ; Set SHCTX to all users
          ${Unless} ${FileExists} "$SMPROGRAMS\$1"
            SetShellVarContext current ; Set SHCTX to the current user
            ${Unless} ${FileExists} "$SMPROGRAMS\$1"
              StrCpy $8 "true"
              CreateShortCut "$SMPROGRAMS\$1" "$INSTDIR\${FileMainEXE}"
              ${If} ${FileExists} "$SMPROGRAMS\$1"
                ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\$1" \
                                                       "$INSTDIR"
                ${If} "$AppUserModelID" != ""
                  ApplicationID::Set "$SMPROGRAMS\$1" "$AppUserModelID" "true"
                ${EndIf}
              ${EndIf}
            ${EndUnless}
          ${EndUnless}

          ${If} ${FileExists} "$SMPROGRAMS\$1"
            ; Count of Start Menu pinned shortcuts before unpinning.
            ${PinnedToStartMenuLnkCount} $R9

            ; Having multiple shortcuts pointing to different installations with
            ; the same AppUserModelID (e.g. side by side installations of the
            ; same version) will make the TaskBar shortcut's lists into an bad
            ; state where the lists are not shown. To prevent this first
            ; uninstall the pinned item.
            ApplicationID::UninstallPinnedItem "$SMPROGRAMS\$1"

            ; Count of Start Menu pinned shortcuts after unpinning.
            ${PinnedToStartMenuLnkCount} $R8

            ; If there is a change in the number of Start Menu pinned shortcuts
            ; assume that unpinning unpinned a side by side installation from
            ; the Start Menu and pin this installation to the Start Menu.
            ${Unless} $R8 == $R9
              ; Pin the shortcut to the Start Menu. 5381 is the shell32.dll
              ; resource id for the "Pin to Start Menu" string.
              InvokeShellVerb::DoIt "$SMPROGRAMS" "$1" "5381"
            ${EndUnless}

            ; Pin the shortcut to the TaskBar. 5386 is the shell32.dll resource
            ; id for the "Pin to Taskbar" string.
            InvokeShellVerb::DoIt "$SMPROGRAMS" "$1" "5386"

            ; Delete the shortcut if it was created
            ${If} "$8" == "true"
              Delete "$SMPROGRAMS\$1"
            ${EndIf}
          ${EndIf}

          ${If} $TmpVal == "HKCU"
            SetShellVarContext current ; Set SHCTX to the current user
          ${Else}
            SetShellVarContext all ; Set SHCTX to all users
          ${EndIf}
        ${EndUnless}
      ${EndIf}
    ${EndIf}
  ${EndIf}
!macroend
!define PinToTaskBar "!insertmacro PinToTaskBar"

; Adds a shortcut to the root of the Start Menu Programs directory if the
; application's Start Menu Programs directory exists with a shortcut pointing to
; this installation directory. This will also remove the old shortcuts and the
; application's Start Menu Programs directory by calling the RemoveStartMenuDir
; macro.
!macro MigrateStartMenuShortcut
  ${GetShortcutsLogPath} $0
  ${If} ${FileExists} "$0"
    ClearErrors
    ReadINIStr $5 "$0" "SMPROGRAMS" "RelativePathToDir"
    ${Unless} ${Errors}
      ClearErrors
      ReadINIStr $1 "$0" "STARTMENU" "Shortcut0"
      ${If} ${Errors}
        ; The STARTMENU ini section doesn't exist.
        ${LogStartMenuShortcut} "${BrandFullName}.lnk"
        ${GetLongPath} "$SMPROGRAMS" $2
        ${GetLongPath} "$2\$5" $1
        ${If} "$1" != ""
          ClearErrors
          ReadINIStr $3 "$0" "SMPROGRAMS" "Shortcut0"
          ${Unless} ${Errors}
            ${If} ${FileExists} "$1\$3"
              ShellLink::GetShortCutTarget "$1\$3"
              Pop $4
              ${If} "$INSTDIR\${FileMainEXE}" == "$4"
                CreateShortCut "$SMPROGRAMS\${BrandFullName}.lnk" \
                               "$INSTDIR\${FileMainEXE}"
                ${If} ${FileExists} "$SMPROGRAMS\${BrandFullName}.lnk"
                  ShellLink::SetShortCutWorkingDirectory "$SMPROGRAMS\${BrandFullName}.lnk" \
                                                         "$INSTDIR"
                  ${If} ${AtLeastWinXP}
                  ${AndIf} "$AppUserModelID" != ""
                    ApplicationID::Set "$SMPROGRAMS\${BrandFullName}.lnk" \
                                       "$AppUserModelID" "true"
                  ${EndIf}
                ${EndIf}
              ${EndIf}
            ${EndIf}
          ${EndUnless}
        ${EndIf}
      ${EndIf}
      ; Remove the application's Start Menu Programs directory, shortcuts, and
      ; ini section.
      ${RemoveStartMenuDir}
    ${EndUnless}
  ${EndIf}
!macroend
!define MigrateStartMenuShortcut "!insertmacro MigrateStartMenuShortcut"

; Removes the application's start menu directory along with its shortcuts if
; they exist and if they exist creates a start menu shortcut in the root of the
; start menu directory (bug 598779). If the application's start menu directory
; is not empty after removing the shortucts the directory will not be removed
; since these additional items were not created by the installer (uses SHCTX).
!macro RemoveStartMenuDir
  ${GetShortcutsLogPath} $0
  ${If} ${FileExists} "$0"
    ; Delete Start Menu Programs shortcuts, directory if it is empty, and
    ; parent directories if they are empty up to but not including the start
    ; menu directory.
    ${GetLongPath} "$SMPROGRAMS" $1
    ClearErrors
    ReadINIStr $2 "$0" "SMPROGRAMS" "RelativePathToDir"
    ${Unless} ${Errors}
      ${GetLongPath} "$1\$2" $2
      ${If} "$2" != ""
        ; Delete shortucts in the Start Menu Programs directory.
        StrCpy $3 0
        ${Do}
          ClearErrors
          ReadINIStr $4 "$0" "SMPROGRAMS" "Shortcut$3"
          ; Stop if there are no more entries
          ${If} ${Errors}
            ${ExitDo}
          ${EndIf}
          ${If} ${FileExists} "$2\$4"
            ShellLink::GetShortCutTarget "$2\$4"
            Pop $5
            ${If} "$INSTDIR\${FileMainEXE}" == "$5"
              Delete "$2\$4"
            ${EndIf}
          ${EndIf}
          IntOp $3 $3 + 1 ; Increment the counter
        ${Loop}
        ; Delete Start Menu Programs directory and parent directories
        ${Do}
          ; Stop if the current directory is the start menu directory
          ${If} "$1" == "$2"
            ${ExitDo}
          ${EndIf}
          ClearErrors
          RmDir "$2"
          ; Stop if removing the directory failed
          ${If} ${Errors}
            ${ExitDo}
          ${EndIf}
          ${GetParent} "$2" $2
        ${Loop}
      ${EndIf}
      DeleteINISec "$0" "SMPROGRAMS"
    ${EndUnless}
  ${EndIf}
!macroend
!define RemoveStartMenuDir "!insertmacro RemoveStartMenuDir"

; Creates the shortcuts log ini file with the appropriate entries if it doesn't
; already exist.
!macro CreateShortcutsLog
  ${GetShortcutsLogPath} $0
  ${Unless} ${FileExists} "$0"
    ${LogStartMenuShortcut} "${BrandFullName}.lnk"
    ${LogQuickLaunchShortcut} "${BrandFullName}.lnk"
    ${LogDesktopShortcut} "${BrandFullName}.lnk"
  ${EndUnless}
!macroend
!define CreateShortcutsLog "!insertmacro CreateShortcutsLog"

; The files to check if they are in use during (un)install so the restart is
; required message is displayed. All files must be located in the $INSTDIR
; directory.
!macro PushFilesToCheck
  ; The first string to be pushed onto the stack MUST be "end" to indicate
  ; that there are no more files to check in $INSTDIR and the last string
  ; should be ${FileMainEXE} so if it is in use the CheckForFilesInUse macro
  ; returns after the first check.
  Push "end"
  Push "AccessibleHandler.dll"
  Push "AccessibleMarshal.dll"
  Push "IA2Marshal.dll"
  Push "freebl3.dll"
  Push "nssckbi.dll"
  Push "nspr4.dll"
  Push "nssdbm3.dll"
  Push "mozsqlite3.dll"
  Push "xpcom.dll"
  Push "crashreporter.exe"
  Push "minidump-analyzer.exe"
  Push "updater.exe"
  Push "${FileMainEXE}"
!macroend
!define PushFilesToCheck "!insertmacro PushFilesToCheck"


; Pushes the string "true" to the top of the stack if the Firewall service is
; running and pushes the string "false" to the top of the stack if it isn't.
!define SC_MANAGER_ALL_ACCESS 0x3F
!define SERVICE_QUERY_CONFIG 0x0001
!define SERVICE_QUERY_STATUS 0x0004
!define SERVICE_RUNNING 0x4

!macro IsFirewallSvcRunning
  Push $R9
  Push $R8
  Push $R7
  Push $R6
  Push "false"

  System::Call 'advapi32::OpenSCManagerW(n, n, i ${SC_MANAGER_ALL_ACCESS}) i.R6'
  ${If} $R6 != 0
    ; MpsSvc is the Firewall service.
    ; When opening the service with SERVICE_QUERY_CONFIG the return value will
    ; be 0 if the service is not installed.
    System::Call 'advapi32::OpenServiceW(i R6, t "MpsSvc", i ${SERVICE_QUERY_CONFIG}) i.R7'
    ${If} $R7 != 0
      System::Call 'advapi32::CloseServiceHandle(i R7) n'
      ; Open the service with SERVICE_QUERY_CONFIG so its status can be queried.
      System::Call 'advapi32::OpenServiceW(i R6, t "MpsSvc", i ${SERVICE_QUERY_STATUS}) i.R7'
    ${Else}
      ; SharedAccess is the Firewall service on Windows XP.
      ; When opening the service with SERVICE_QUERY_CONFIG the return value will
      ; be 0 if the service is not installed.
      System::Call 'advapi32::OpenServiceW(i R6, t "SharedAccess", i ${SERVICE_QUERY_CONFIG}) i.R7'
      ${If} $R7 != 0
        System::Call 'advapi32::CloseServiceHandle(i R7) n'
        ; Open the service with SERVICE_QUERY_CONFIG so its status can be
        ; queried.
        System::Call 'advapi32::OpenServiceW(i R6, t "SharedAccess", i ${SERVICE_QUERY_STATUS}) i.R7'
      ${EndIf}
    ${EndIf}
    ; Did the calls to OpenServiceW succeed?
    ${If} $R7 != 0
      System::Call '*(i,i,i,i,i,i,i) i.R9'
      ; Query the current status of the service.
      System::Call 'advapi32::QueryServiceStatus(i R7, i $R9) i'
      System::Call '*$R9(i, i.R8)'
      System::Free $R9
      System::Call 'advapi32::CloseServiceHandle(i R7) n'
      IntFmt $R8 "0x%X" $R8
      ${If} $R8 == ${SERVICE_RUNNING}
        Pop $R9
        Push "true"
      ${EndIf}
    ${EndIf}
    System::Call 'advapi32::CloseServiceHandle(i R6) n'
  ${EndIf}

  Exch 1
  Pop $R6
  Exch 1
  Pop $R7
  Exch 1
  Pop $R8
  Exch 1
  Pop $R9
!macroend
!define IsFirewallSvcRunning "!insertmacro IsFirewallSvcRunning"
!define un.IsFirewallSvcRunning "!insertmacro IsFirewallSvcRunning"

; Sets this installation as the default browser by setting the registry keys
; under HKEY_CURRENT_USER via registry calls and using the AppAssocReg NSIS
; plugin. This is a function instead of a macro so it is
; easily called from an elevated instance of the binary. Since this can be
; called by an elevated instance logging is not performed in this function.
Function SetAsDefaultAppUserHKCU
  ; See if we're using path hash suffixed registry keys for this install
  ${GetLongPath} "$INSTDIR\${FileMainEXE}" $8
  ${StrFilter} "${FileMainEXE}" "+" "" "" $R9
  ClearErrors
  ReadRegStr $0 HKCU "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
  ${If} ${Errors}
  ${OrIf} ${AtMostWin2008R2}
    ClearErrors
    ReadRegStr $0 HKLM "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
  ${EndIf}
  StrCpy $0 $0 -2
  ${If} $0 != $8
    ${If} $AppUserModelID == ""
      ${InitHashAppModelId} "$INSTDIR" "Software\Mozilla\${AppName}\TaskBarIDs"
    ${EndIf}
    StrCpy $R9 "${AppRegName}-$AppUserModelID"
  ${EndIf}

  ; Only set as the user's StartMenuInternet browser if the StartMenuInternet
  ; registry keys are for this install.
  ClearErrors
  ReadRegStr $0 HKCU "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
  ${If} ${Errors}
  ${OrIf} ${AtMostWin2008R2}
    ClearErrors
    ReadRegStr $0 HKLM "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
  ${EndIf}
  ${Unless} ${Errors}
    WriteRegStr HKCU "Software\Clients\StartMenuInternet" "" "$R9"
  ${Else}
    ClearErrors
    ReadRegStr $0 HKCU "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
    ${If} ${Errors}
    ${OrIf} ${AtMostWin2008R2}
      ClearErrors
      ReadRegStr $0 HKLM "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
    ${EndIf}
    ${Unless} ${Errors}
      ${GetPathFromString} "$0" $0
      ${GetParent} "$0" $0
      ${If} ${FileExists} "$0"
        ${GetLongPath} "$0" $0
        ${If} "$0" == "$INSTDIR"
          WriteRegStr HKCU "Software\Clients\StartMenuInternet" "" "$R9"
        ${EndIf}
      ${EndIf}
    ${EndUnless}
  ${EndUnless}

  SetShellVarContext current  ; Set SHCTX to the current user (e.g. HKCU)

  ${If} ${AtLeastWin8}
    ${SetStartMenuInternet} "HKCU"
    ${FixShellIconHandler} "HKCU"
    ${FixClassKeys} ; Does not use SHCTX
  ${EndIf}

  ${SetHandlers}

  ; Only register as the handler if the app registry name
  ; exists under the RegisteredApplications registry key. The protocol and
  ; file handlers set previously at the user level will associate this install
  ; as the default browser.
  ClearErrors
  ReadRegStr $0 HKLM "Software\RegisteredApplications" "$R9"
  ${Unless} ${Errors}
    ; This is all protected by a user choice hash in Windows 8 so it won't
    ; help, but it also won't hurt.
    AppAssocReg::SetAppAsDefaultAll "$R9"
  ${EndUnless}
  ${RemoveDeprecatedKeys}
  ${MigrateTaskBarShortcut}
FunctionEnd

; Helper for updating the shortcut application model IDs.
Function FixShortcutAppModelIDs
  ${If} ${AtLeastWinXP}
  ${AndIf} "$AppUserModelID" != ""
    ${UpdateShortcutAppModelIDs} "$INSTDIR\${FileMainEXE}" "$AppUserModelID" $0
  ${EndIf}
FunctionEnd

; Helper for adding Firewall exceptions during install and after app update.
Function AddFirewallEntries
  ${IsFirewallSvcRunning}
  Pop $0
  ${If} "$0" == "true"
    liteFirewallW::AddRule "$INSTDIR\${FileMainEXE}" "${BrandShortName} ($INSTDIR)"
  ${EndIf}
FunctionEnd

; The !ifdef NO_LOG prevents warnings when compiling the installer.nsi due to
; this function only being used by the uninstaller.nsi.
!ifdef NO_LOG

Function SetAsDefaultAppUser
  ; On Win8, we want to avoid having a UAC prompt since we'll already have
  ; another action for control panel default browser selection popping up
  ; to the user.  Win8 is the first OS where the start menu keys can be
  ; added into HKCU.  The call to SetAsDefaultAppUserHKCU will have already
  ; set the HKCU keys for SetStartMenuInternet.
  ${If} ${AtLeastWin8}
    ; Check if this is running in an elevated process
    ClearErrors
    ${GetParameters} $0
    ${GetOptions} "$0" "/UAC:" $0
    ${If} ${Errors} ; Not elevated
      Call SetAsDefaultAppUserHKCU
    ${Else} ; Elevated - execute the function in the unelevated process
      GetFunctionAddress $0 SetAsDefaultAppUserHKCU
      UAC::ExecCodeSegment $0
    ${EndIf}
    Return ; Nothing more needs to be done
  ${EndIf}

  ; Before Win8, it is only possible to set this installation of the application
  ; as the StartMenuInternet handler if it was added to the HKLM
  ; StartMenuInternet registry keys.
  ; http://support.microsoft.com/kb/297878

  ; Check if this install location registered as a StartMenuInternet client
  ClearErrors
  ReadRegStr $0 HKCU "Software\Clients\StartMenuInternet\${AppRegName}-$AppUserModelID\DefaultIcon" ""
  ${If} ${Errors}
  ${OrIf} ${AtMostWin2008R2}
    ClearErrors
    ReadRegStr $0 HKLM "Software\Clients\StartMenuInternet\${AppRegName}-$AppUserModelID\DefaultIcon" ""
  ${EndIf}
  ${If} ${Errors}
    ${StrFilter} "${FileMainEXE}" "+" "" "" $R9
    ClearErrors
    ReadRegStr $0 HKCU "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
  ${EndIf}
  ${If} ${Errors}
  ${OrIf} ${AtMostWin2008R2}
    ClearErrors
    ReadRegStr $0 HKLM "Software\Clients\StartMenuInternet\$R9\DefaultIcon" ""
  ${EndIf}

  ${Unless} ${Errors}
    ${GetPathFromString} "$0" $0
    ${GetParent} "$0" $0
    ${If} ${FileExists} "$0"
      ${GetLongPath} "$0" $0
      ${If} "$0" == "$INSTDIR"
        ; Check if this is running in an elevated process
        ClearErrors
        ${GetParameters} $0
        ${GetOptions} "$0" "/UAC:" $0
        ${If} ${Errors} ; Not elevated
          Call SetAsDefaultAppUserHKCU
        ${Else} ; Elevated - execute the function in the unelevated process
          GetFunctionAddress $0 SetAsDefaultAppUserHKCU
          UAC::ExecCodeSegment $0
        ${EndIf}
        Return ; Nothing more needs to be done
      ${EndIf}
    ${EndIf}
  ${EndUnless}

  ; The code after ElevateUAC won't be executed when the user:
  ; a) is a member of the administrators group (e.g. elevation is required)
  ; b) is not a member of the administrators group and chooses to elevate
  ${ElevateUAC}

  ${SetStartMenuInternet} "HKLM"

  SetShellVarContext all  ; Set SHCTX to all users (e.g. HKLM)

  ${FixClassKeys} ; Does not use SHCTX
  ${FixShellIconHandler} "HKLM"
  ${RemoveDeprecatedKeys} ; Does not use SHCTX

  ClearErrors
  ${GetParameters} $0
  ${GetOptions} "$0" "/UAC:" $0
  ${If} ${Errors}
    Call SetAsDefaultAppUserHKCU
  ${Else}
    GetFunctionAddress $0 SetAsDefaultAppUserHKCU
    UAC::ExecCodeSegment $0
  ${EndIf}
FunctionEnd
!define SetAsDefaultAppUser "Call SetAsDefaultAppUser"

!endif ; NO_LOG
