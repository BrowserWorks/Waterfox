!include MUI.nsh
!include LogicLib.nsh
!include nsDialogs.nsh
!include WinMessages.nsh
!include FileFunc.nsh

Name "nsDialogs Welcome"
OutFile "nsDialogs Welcome.exe"

Page custom nsDialogsWelcome
Page custom nsDialogsDirectory
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_LANGUAGE English


Var DIALOG
Var HEADLINE
Var TEXT
Var IMAGECTL
Var IMAGE
Var DIRECTORY
Var FREESPACE

Var HEADLINE_FONT

Function .onInit

	CreateFont $HEADLINE_FONT "$(^Font)" "14" "700"

	InitPluginsDir
	File /oname=$PLUGINSDIR\welcome.bmp "${NSISDIR}\Contrib\Graphics\Wizard\orange-nsis.bmp"

FunctionEnd

Function HideControls

    LockWindow on
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1045
    ShowWindow $0 ${SW_NORMAL}
    LockWindow off

FunctionEnd

Function ShowControls

    LockWindow on
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1045
    ShowWindow $0 ${SW_HIDE}
    LockWindow off

FunctionEnd

Function nsDialogsWelcome

	nsDialogs::Create 1044
	Pop $DIALOG

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_BITMAP} 0 0 0 109u 193u ""
	Pop $IMAGECTL

	StrCpy $0 $PLUGINSDIR\welcome.bmp
	System::Call 'user32::LoadImage(p 0, t r0, i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_LOADFROMFILE})p.s'
	Pop $IMAGE
	
	SendMessage $IMAGECTL ${STM_SETIMAGE} ${IMAGE_BITMAP} $IMAGE

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 10u -130u 20u "Welcome to nsDialogs!"
	Pop $HEADLINE

	SendMessage $HEADLINE ${WM_SETFONT} $HEADLINE_FONT 0

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 32u -130u -32u "nsDialogs is the next generation of user interfaces in NSIS. It gives the developer full control over custom pages. Some of the features include control text containing variables, callbacks directly into script functions and creation of any type of control. Create boring old edit boxes or load some external library and create custom controls with no need of creating your own plug-in.$\r$\n$\r$\nUnlike InstallOptions, nsDialogs doesn't use INI files to communicate with the script. By interacting directly with the script, nsDialogs can perform much faster without the need of costly, old and inefficient INI operations. Direct interaction also allows direct calls to functions defined in the script and removes the need of conversion functions like Io2Nsis.$\r$\n$\r$\nHit the Next button to see how it all fits into a mock directory page."
	Pop $TEXT

	SetCtlColors $DIALOG "" 0xffffff
	SetCtlColors $HEADLINE "" 0xffffff
	SetCtlColors $TEXT "" 0xffffff

	Call HideControls

	nsDialogs::Show

	Call ShowControls

	System::Call gdi32::DeleteObject(p$IMAGE)

FunctionEnd

!define SHACF_FILESYSTEM 1

Function nsDialogsDirectory

	!insertmacro MUI_HEADER_TEXT "Choose Install Location" "Choose the folder in which to install $(^NameDA)."

	GetDlgItem $0 $HWNDPARENT 1
	EnableWindow $0 0

	nsDialogs::Create 1018
	Pop $DIALOG

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_CENTER} 0 0 0 100% 30 "Directory page"
	Pop $HEADLINE

	SendMessage $HEADLINE ${WM_SETFONT} $HEADLINE_FONT 0

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 0 30 100% 40 "Select the installation directory of NSIS to continue. $_CLICK"
	Pop $TEXT

	nsDialogs::CreateControl EDIT ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${ES_AUTOHSCROLL}|${WS_TABSTOP} ${WS_EX_CLIENTEDGE} 0 75 100% 12u ""
	Pop $DIRECTORY

	SendMessage $HWNDPARENT ${WM_NEXTDLGCTL} $DIRECTORY 1

	GetFunctionAddress $0 DirChange
	nsDialogs::OnChange $DIRECTORY $0

	System::Call shlwapi::SHAutoComplete(i$DIRECTORY,i${SHACF_FILESYSTEM})

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 0 -10u 100% 10u ""
	Pop $FREESPACE

	Call UpdateFreeSpace

	nsDialogs::Show

FunctionEnd

Function UpdateFreeSpace

	${GetRoot} $INSTDIR $0
	StrCpy $1 " bytes"

	System::Call kernel32::GetDiskFreeSpaceEx(tr0,*l,*l,*l.r0)

	${If} $0 > 1024
	${OrIf} $0 < 0
		System::Int64Op $0 / 1024
		Pop $0
		StrCpy $1 "kb"
		${If} $0 > 1024
		${OrIf} $0 < 0
			System::Int64Op $0 / 1024
			Pop $0
			StrCpy $1 "mb"
			${If} $0 > 1024
			${OrIf} $0 < 0
				System::Int64Op $0 / 1024
				Pop $0
				StrCpy $1 "gb"
			${EndIf}
		${EndIf}
	${EndIf}

	SendMessage $FREESPACE ${WM_SETTEXT} 0 "STR:Free space: $0$1"

FunctionEnd

Function DirChange

	Pop $0 # dir hwnd

	GetDlgItem $0 $HWNDPARENT 1

	System::Call user32::GetWindowText(p$DIRECTORY,t.d,i${NSIS_MAX_STRLEN})

	${If} ${FileExists} $INSTDIR\makensis.exe
		EnableWindow $0 1
	${Else}
		EnableWindow $0 0
	${EndIf}

	Call UpdateFreeSpace

FunctionEnd

Section
SectionEnd
