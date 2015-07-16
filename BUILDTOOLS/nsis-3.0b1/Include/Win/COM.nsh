/*
-------------
   COM.nsh
-------------

COM defines and helper macros

; Example usage:
!include Win\COM.nsh
!include Win\Propkey.nsh
!insertmacro ComHlpr_CreateInProcInstance ${CLSID_ShellLink} ${IID_IShellLink} r0 ""
${If} $0 <> 0
	${IShellLink::SetPath} $0 '("%COMSPEC%").r1'
	${IShellLink::SetArguments} $0 '("/k echo HelloWorld").r2'
	${If} $1 = 0
	${AndIf} $2 = 0
		${IUnknown::QueryInterface} $0 '("${IID_IPropertyStore}",.r1)'
		${If} $1 <> 0
			System::Call '*${SYSSTRUCT_PROPERTYKEY}(${PKEY_AppUserModel_StartPinOption})p.r2'
			System::Call '*${SYSSTRUCT_PROPVARIANT}(${VT_UI4},,&i4 ${APPUSERMODEL_STARTPINOPTION_NOPINONINSTALL})p.r3'
			${IPropertyStore::SetValue} $1 '($2,$3)'

			; Reuse the PROPERTYKEY & PROPVARIANT buffers to set another property
			System::Call '*$2${SYSSTRUCT_PROPERTYKEY}(${PKEY_AppUserModel_ExcludeFromShowInNewInstall})'
			System::Call '*$3${SYSSTRUCT_PROPVARIANT}(${VT_BOOL},,&i2 ${VARIANT_TRUE})'
			${IPropertyStore::SetValue} $1 '($2,$3)'

			System::Free $2
			System::Free $3
			${IPropertyStore::Commit} $1 ""
			${IUnknown::Release} $1 ""
		${EndIf}
		${IUnknown::QueryInterface} $0 '("${IID_IPersistFile}",.r1)'
		${If} $1 <> 0
			${IPersistFile::Save} $1 '("$SMPrograms\nsis_test.lnk",1)'
			${IUnknown::Release} $1 ""
		${EndIf}
	${EndIf}
	${IUnknown::Release} $0 ""
${EndIf}

*/


!ifndef __WIN_COM__INC
!define __WIN_COM__INC ${NSIS_CHAR_SIZE}
!verbose push
!verbose 3

!define /ifndef CLSCTX_INPROC_SERVER 0x1
!define /ifndef CLSCTX_INPROC_HANDLER 0x2
!define /ifndef CLSCTX_LOCAL_SERVER 0x4
!define /ifndef CLSCTX_REMOTE_SERVER 0x10
!define /ifndef CLSCTX_ACTIVATE_32_BIT_SERVER 0x40000
!define /ifndef CLSCTX_ACTIVATE_64_BIT_SERVER 0x80000
!define /ifndef CLSCTX_ENABLE_CLOAKING 0x100000

!define NSISCOMCALL "!insertmacro NSISCOMCALL "
!macro NSISCOMCALL vtblidx decl ptr params
!if ${NSIS_CHAR_SIZE} <> ${__WIN_COM__INC}
; Warn if QueryInterface() for IID_IShellLink etc will return the wrong interface
!warning "NSIS_CHAR_SIZE changed, existing defines and macros might not work correctly!"
!endif
System::Call `${ptr}->${vtblidx}${decl}${params}`
!macroend
!define NSISCOMIFACEDECL "!insertmacro NSISCOMIFACEDECL "
!macro NSISCOMIFACEDECL iface method vtblidx decl
!define ${iface}::${method} `${NSISCOMCALL} ${vtblidx} ${decl} `
!macroend

!macro ComHlpr_CreateInProcInstance clsid iid sysoutvarIFacePtr sysret
System::Call 'OLE32::CoCreateInstance(g "${clsid}",i 0,i ${CLSCTX_INPROC_SERVER},g "${iid}",*p.${sysoutvarIFacePtr})i${sysret}'
!macroend

!macro ComHlpr_SafeRelease _p
${If} ${_p} <> 0
	${IUnknown::Release} ${_p} ""
${EndIf}
!macroend
!macro ComHlpr_SafeReleaseAndNull _p
${If} ${_p} <> 0
	${IUnknown::Release} ${_p} ""
	StrCpy ${_p} 0
${EndIf}
!macroend


!ifndef IID_IUnknown
!define IID_IUnknown {00000000-0000-0000-C000-000000000046}
${NSISCOMIFACEDECL}IUnknown QueryInterface 0 (g,*p)i
${NSISCOMIFACEDECL}IUnknown AddRef 1 ()i
${NSISCOMIFACEDECL}IUnknown Release 2 ()i
!endif

!ifndef IID_IPersist
!define IID_IPersist {0000010c-0000-0000-C000-000000000046}
${NSISCOMIFACEDECL}IPersist GetClassID 3 (*g)i
!endif

!ifndef IID_IPersistFile
!define IID_IPersistFile {0000010b-0000-0000-C000-000000000046}
${NSISCOMIFACEDECL}IPersistFile IsDirty 4 ()i
${NSISCOMIFACEDECL}IPersistFile Load 5 (w,i)i
${NSISCOMIFACEDECL}IPersistFile Save 6 (w,i)i
${NSISCOMIFACEDECL}IPersistFile SaveCompleted 7 (w)i
${NSISCOMIFACEDECL}IPersistFile GetCurFile 8 (*w)i
!endif

!ifndef CLSID_ShellLink
!define CLSID_ShellLink {00021401-0000-0000-c000-000000000046}
!endif
!ifndef IID_IShellLink
!define IID_IShellLinkA {000214ee-0000-0000-c000-000000000046}
!define IID_IShellLinkW {000214f9-0000-0000-c000-000000000046}
!ifdef NSIS_UNICODE
!define IID_IShellLink ${IID_IShellLinkW}
!else
!define IID_IShellLink ${IID_IShellLinkA}
!endif
${NSISCOMIFACEDECL}IShellLink GetPath 3 (t,i,p,i)i
${NSISCOMIFACEDECL}IShellLink GetIDList 4 (*p)i
${NSISCOMIFACEDECL}IShellLink SetIDList 5 (p)i
${NSISCOMIFACEDECL}IShellLink GetDescription 6 (t,i)i
${NSISCOMIFACEDECL}IShellLink SetDescription 7 (t)i
${NSISCOMIFACEDECL}IShellLink GetWorkingDirectory 8 (t,i)i
${NSISCOMIFACEDECL}IShellLink SetWorkingDirectory 9 (t)i
${NSISCOMIFACEDECL}IShellLink GetArguments 10 (t,i)i
${NSISCOMIFACEDECL}IShellLink SetArguments 11 (t)i
${NSISCOMIFACEDECL}IShellLink GetHotkey 12 (*i0)i
${NSISCOMIFACEDECL}IShellLink SetHotkey 13 (&i2)i
${NSISCOMIFACEDECL}IShellLink GetShowCmd 14 (*i)i
${NSISCOMIFACEDECL}IShellLink SetShowCmd 15 (i)i
${NSISCOMIFACEDECL}IShellLink GetIconLocation 16 (t,i,*i)i
${NSISCOMIFACEDECL}IShellLink SetIconLocation 17 (t,i)i
${NSISCOMIFACEDECL}IShellLink SetRelativePath 18 (t,i)i
${NSISCOMIFACEDECL}IShellLink Resolve 19 (p,i)i
${NSISCOMIFACEDECL}IShellLink SetPath 20 (t)i
!endif

!ifndef IID_IShellLinkDataList
!define IID_IShellLinkDataList {45e2b4ae-b1c3-11d0-b92f-00a0c90312e1}
${NSISCOMIFACEDECL}IShellLinkDataList AddDataBlock 3 (p)i
${NSISCOMIFACEDECL}IShellLinkDataList CopyDataBlock 4 (i,*p)i
${NSISCOMIFACEDECL}IShellLinkDataList RemoveDataBlock 5 (i)i
${NSISCOMIFACEDECL}IShellLinkDataList GetFlags 6 (*i)i
${NSISCOMIFACEDECL}IShellLinkDataList SetFlags 7 (i)i
!endif
!define /ifndef EXP_SZ_LINK_SIG         0xA0000001
!define /ifndef NT_CONSOLE_PROPS_SIG    0xA0000002
!define /ifndef NT_FE_CONSOLE_PROPS_SIG 0xA0000004
!define /ifndef EXP_SPECIAL_FOLDER_SIG  0xA0000005
!define /ifndef EXP_DARWIN_ID_SIG       0xA0000006
!define /ifndef EXP_SZ_ICON_SIG         0xA0000007
!define /ifndef EXP_PROPERTYSTORAGE_SIG 0xA0000009
;SHELL_LINK_DATA_FLAGS
!define /ifndef SLDF_HAS_ID_LIST                           0x00000001
!define /ifndef SLDF_HAS_LINK_INFO                         0x00000002
!define /ifndef SLDF_HAS_NAME                              0x00000004
!define /ifndef SLDF_HAS_RELPATH                           0x00000008
!define /ifndef SLDF_HAS_WORKINGDIR                        0x00000010
!define /ifndef SLDF_HAS_ARGS                              0x00000020
!define /ifndef SLDF_HAS_ICONLOCATION                      0x00000040
!define /ifndef SLDF_UNICODE                               0x00000080
!define /ifndef SLDF_FORCE_NO_LINKINFO                     0x00000100
!define /ifndef SLDF_HAS_EXP_SZ                            0x00000200
!define /ifndef SLDF_RUN_IN_SEPARATE                       0x00000400
!define /ifndef SLDF_HAS_LOGO3ID                           0x00000800
!define /ifndef SLDF_HAS_DARWINID                          0x00001000
!define /ifndef SLDF_RUNAS_USER                            0x00002000
!define /ifndef SLDF_HAS_EXP_ICON_SZ                       0x00004000
!define /ifndef SLDF_NO_PIDL_ALIAS                         0x00008000
!define /ifndef SLDF_FORCE_UNCNAME                         0x00010000
!define /ifndef SLDF_RUN_WITH_SHIMLAYER                    0x00020000
!define /ifndef SLDF_FORCE_NO_LINKTRACK                    0x00040000 ;[Vista+]
!define /ifndef SLDF_ENABLE_TARGET_METADATA                0x00080000
!define /ifndef SLDF_DISABLE_LINK_PATH_TRACKING            0x00100000 ;[Seven+]
!define /ifndef SLDF_DISABLE_KNOWNFOLDER_RELATIVE_TRACKING 0x00200000
!define /ifndef SLDF_NO_KF_ALIAS                           0x00400000
!define /ifndef SLDF_ALLOW_LINK_TO_LINK                    0x00800000
!define /ifndef SLDF_UNALIAS_ON_SAVE                       0x01000000
!define /ifndef SLDF_PREFER_ENVIRONMENT_PATH               0x02000000
!define /ifndef SLDF_KEEP_LOCAL_IDLIST_FOR_UNC_TARGET      0x04000000
!define /ifndef SLDF_PERSIST_VOLUME_ID_RELATIVE            0x08000000 ;[Eight+]

!ifndef IID_IShellItem
!define IID_IShellItem {43826d1e-e718-42ee-bc55-a1e261c37bfe}
${NSISCOMIFACEDECL}IShellItem BindToHandler 3 (p,g,g,*p)i
${NSISCOMIFACEDECL}IShellItem GetParent 4 (*p)i
${NSISCOMIFACEDECL}IShellItem GetDisplayName 5 (i,*p)i
${NSISCOMIFACEDECL}IShellItem GetAttributes 6 (i,*i)i
${NSISCOMIFACEDECL}IShellItem Compare 7 (p,i,*i)i
!endif

!ifndef CLSID_StartMenuPin
!define CLSID_StartMenuPin {a2a9545d-a0c2-42b4-9708-a0b2badd77c8}
!endif
!ifndef IID_IStartMenuPinnedList
!define IID_IStartMenuPinnedList {4CD19ADA-25A5-4A32-B3B7-347BEE5BE36B}
${NSISCOMIFACEDECL}IStartMenuPinnedList RemoveFromList 3 (p)i
!endif

!ifndef IID_IPropertyStore
!define IID_IPropertyStore {886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99}
${NSISCOMIFACEDECL}IPropertyStore GetCount 3 (*i)i
${NSISCOMIFACEDECL}IPropertyStore GetAt 4 (i,p)i
${NSISCOMIFACEDECL}IPropertyStore GetValue 5 (p,p)i
${NSISCOMIFACEDECL}IPropertyStore SetValue 6 (p,p)i
${NSISCOMIFACEDECL}IPropertyStore Commit 7 ()i
!endif

!ifndef CLSID_ApplicationAssociationRegistration
!define CLSID_ApplicationAssociationRegistration {591209c7-767b-42b2-9fba-44ee4615f2c7}
!endif
!ifndef IID_IApplicationAssociationRegistration
!define IID_IApplicationAssociationRegistration {4e530b0a-e611-4c77-a3ac-9031d022281b} ;[Vista+]
${NSISCOMIFACEDECL}IApplicationAssociationRegistration QueryCurrentDefault 3 (w,i,i,*p)i
${NSISCOMIFACEDECL}IApplicationAssociationRegistration QueryAppIsDefault 4 (w,i,i,w,*i)i
${NSISCOMIFACEDECL}IApplicationAssociationRegistration QueryAppIsDefaultAll 5 (i,w,*i)i
${NSISCOMIFACEDECL}IApplicationAssociationRegistration SetAppAsDefault 6 (w,w,i)i
${NSISCOMIFACEDECL}IApplicationAssociationRegistration SetAppAsDefaultAll 7 (w)i
${NSISCOMIFACEDECL}IApplicationAssociationRegistration ClearUserAssociations 8 ()i
!endif
!ifndef CLSID_ApplicationAssociationRegistrationUI
!define CLSID_ApplicationAssociationRegistrationUI {1968106d-f3b5-44cf-890e-116fcb9ecef1}
!endif
!ifndef IID_IApplicationAssociationRegistrationUI
!define IID_IApplicationAssociationRegistrationUI {1f76a169-f994-40ac-8fc8-0959e8874710} ;[Vista+]
${NSISCOMIFACEDECL}IApplicationAssociationRegistrationUI LaunchAdvancedAssociationUI 3 (w)i
!endif


!verbose pop
!endif /* __WIN_COM__INC */
