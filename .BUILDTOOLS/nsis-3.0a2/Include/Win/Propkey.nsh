!ifndef __WIN_PROPKEY__INC
!define __WIN_PROPKEY__INC
!verbose push
!verbose 3 


/**************************************************
WTypes.h
**************************************************/
;NOTE: This list is incomplete
!define VT_EMPTY     0
!define VT_NULL      1
!define VT_I4        3
!define VT_BSTR      8
!define VT_BOOL      11
!define VT_UI4       19
!define VT_INT       22
!define VT_UINT      23
!define VT_HRESULT   25
!define VT_PTR       26
!define VT_SAFEARRAY 27
!define VT_LPSTR     30
!define VT_LPWSTR    31

!define /ifndef VARIANT_TRUE -1
!define /ifndef VARIANT_FALSE 0

!define SYSSIZEOF_PROPERTYKEY 20
!define SYSSTRUCT_PROPERTYKEY (&g16,&i4) ;System.dll is buggy when it comes to g and forces us to specify the size


/**************************************************
PropIdl.h
**************************************************/
!define SYSSIZEOF_PROPVARIANT 16
!define SYSSTRUCT_PROPVARIANT (&i2,&i6,&i8)


/**************************************************
Propkey.h
**************************************************/
!define PKEY_AppUserModel_ID                          '"{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}",5'
!define PKEY_AppUserModel_ExcludeFromShowInNewInstall '"{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}",8' ; VT_BOOL
!define PKEY_AppUserModel_PreventPinning              '"{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}",9' ; VT_BOOL
!define APPUSERMODEL_STARTPINOPTION_NOPINONINSTALL 1
!define APPUSERMODEL_STARTPINOPTION_USERPINNED 2
!define PKEY_AppUserModel_StartPinOption '"{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}",12' ; VT_UI4 [Eight+]


!verbose pop
!endif /* __WIN_PROPKEY__INC */
