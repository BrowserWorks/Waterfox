/*

NSIS Modern User Interface
Support code for all pages

*/

;--------------------------------
;Page initialization

!macro MUI_PAGE_INIT

  !ifdef MUI_INSERT
    !warning "MUI_PAGE_* inserted after MUI_LANGUAGE"
  !endif

  ;Include interface settings in neccesary
  !insertmacro MUI_INTERFACE

  ;Define settings for installer page
  !insertmacro MUI_UNSET MUI_PAGE_UNINSTALLER
  !insertmacro MUI_UNSET MUI_PAGE_UNINSTALLER_PREFIX
  !insertmacro MUI_UNSET MUI_PAGE_UNINSTALLER_FUNCPREFIX
  
  !insertmacro MUI_SET MUI_PAGE_UNINSTALLER_PREFIX ""
  !insertmacro MUI_SET MUI_PAGE_UNINSTALLER_FUNCPREFIX ""

  ;Generate unique ID
  !insertmacro MUI_UNSET MUI_UNIQUEID
  !define MUI_UNIQUEID ${__LINE__}

!macroend

!macro MUI_UNPAGE_INIT

  !ifdef MUI_INSERT
    !warning "MUI_UNPAGE_* inserted after MUI_LANGUAGE"
  !endif

  ;Include interface settings
  !insertmacro MUI_INTERFACE

  ;Define prefixes for uninstaller page
  !insertmacro MUI_SET MUI_UNINSTALLER ""
  
  !insertmacro MUI_SET MUI_PAGE_UNINSTALLER ""
  !insertmacro MUI_SET MUI_PAGE_UNINSTALLER_PREFIX "UN"
  !insertmacro MUI_SET MUI_PAGE_UNINSTALLER_FUNCPREFIX "un."
  
  ;Generate unique ID
  !insertmacro MUI_UNSET MUI_UNIQUEID
  !define MUI_UNIQUEID ${__LINE__}  

!macroend


;--------------------------------
;Header text for standard MUI page

!macro MUI_HEADER_TEXT_PAGE TEXT SUBTEXT

  !ifdef MUI_PAGE_HEADER_TEXT & MUI_PAGE_HEADER_SUBTEXT
    !insertmacro MUI_HEADER_TEXT "${MUI_PAGE_HEADER_TEXT}" "${MUI_PAGE_HEADER_SUBTEXT}"
  !else ifdef MUI_PAGE_HEADER_TEXT
    !insertmacro MUI_HEADER_TEXT "${MUI_PAGE_HEADER_TEXT}" "${SUBTEXT}"
  !else ifdef MUI_PAGE_HEADER_SUBTEXT
    !insertmacro MUI_HEADER_TEXT "${TEXT}" "${MUI_PAGE_HEADER_SUBTEXT}"
  !else
    !insertmacro MUI_HEADER_TEXT "${TEXT}" "${SUBTEXT}"
  !endif

  !insertmacro MUI_UNSET MUI_PAGE_HEADER_TEXT
  !insertmacro MUI_UNSET MUI_PAGE_HEADER_SUBTEXT

!macroend


;--------------------------------
;Header text for custom page

!macro MUI_HEADER_TEXT TEXT SUBTEXT ;Called from script

  !verbose push
  !verbose ${MUI_VERBOSE}

  !ifdef MUI_HEADER_TRANSPARENT_TEXT
    LockWindow on
  !endif

  SendMessage $mui.Header.Text ${WM_SETTEXT} 0 "STR:${TEXT}"
  SendMessage $mui.Header.SubText ${WM_SETTEXT} 0 "STR:${SUBTEXT}"

  !ifdef MUI_HEADER_TRANSPARENT_TEXT
    LockWindow off
  !endif

  !verbose pop

!macroend


;--------------------------------
;Custom page functions

!macro MUI_PAGE_FUNCTION_CUSTOM TYPE

  !ifdef MUI_PAGE_CUSTOMFUNCTION_${TYPE}
    Call "${MUI_PAGE_CUSTOMFUNCTION_${TYPE}}"
    !undef MUI_PAGE_CUSTOMFUNCTION_${TYPE}
  !endif

!macroend


;--------------------------------
;Support for full window pages (like welcome/finish page)

!macro MUI_PAGE_FUNCTION_FULLWINDOW

  !ifndef MUI_${MUI_PAGE_UNINSTALLER_PREFIX}PAGE_FUNCTION_FULLWINDOW
    !define MUI_${MUI_PAGE_UNINSTALLER_PREFIX}PAGE_FUNCTION_FULLWINDOW

    Function ${MUI_PAGE_UNINSTALLER_FUNCPREFIX}muiPageLoadFullWindow
    
      LockWindow on
      
      ;The branding text needs to be hidden because the full windows page
      ;overlaps with it.
      ShowWindow $mui.Branding.Background ${SW_HIDE}
      ShowWindow $mui.Branding.Text ${SW_HIDE}      
      
      ;The texts need to be hidden because otherwise they may show through
      ;the page above when the Alt key is pressed.
      ShowWindow $mui.Header.Text ${SW_HIDE}
      ShowWindow $mui.Header.SubText ${SW_HIDE}
      ShowWindow $mui.Header.Image ${SW_HIDE}

      ;Show line below full width of page
      ShowWindow $mui.Line.Standard ${SW_HIDE}
      ShowWindow $mui.Line.FullWindow ${SW_NORMAL}
      
      LockWindow off
      
    FunctionEnd
    
    Function ${MUI_PAGE_UNINSTALLER_FUNCPREFIX}muiPageUnloadFullWindow
    
      ;Set everything back to normal again
    
      LockWindow on
      
      ShowWindow $mui.Branding.Background ${SW_NORMAL}
      ShowWindow $mui.Branding.Text ${SW_NORMAL}
      
      ShowWindow $mui.Header.Text ${SW_NORMAL}
      ShowWindow $mui.Header.SubText ${SW_NORMAL}
      ShowWindow $mui.Header.Image ${SW_NORMAL}
      
      ShowWindow $mui.Line.Standard ${SW_NORMAL}
      ShowWindow $mui.Line.FullWindow ${SW_HIDE}
      
      LockWindow off
      
    FunctionEnd    
    
  !endif

!macroend

!macro MUI_INTERNAL_FULLWINDOW_LOADWIZARDIMAGE _un _hwndImg _ImgPath _RetImgHandle

  !ifdef MUI_${_un}WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
    !insertmacro MUI_DEFAULT MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH NoStretchNoCropNoAlign ; Legacy compatibility
  !endif
  !insertmacro MUI_DEFAULT MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH FitControl

  !if "${MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH}" == "NoStretchNoCropNoAlign"

    ${NSD_SetImage} ${_hwndImg} "${_ImgPath}" "${_RetImgHandle}"

  !else if "${MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH}" == "NoStretchNoCrop"

    !insertmacro MUI_LOADANDXALIGNIMAGE ${_hwndImg} "${_ImgPath}" Auto "${_RetImgHandle}"

  !else if "${MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH}" == "AspectFitHeight"

    !insertmacro MUI_LOADANDASPECTSTRETCHIMAGETOCONTROLHEIGHT ${_hwndImg} "${_ImgPath}" Auto "${_RetImgHandle}"

  !else

    !if "${MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH}" != "FitControl"
      !warning 'MUI_${_un}WELCOMEFINISHPAGE_BITMAP_STRETCH set to unknown value, defaulting to FitControl'
    !endif
    ${NSD_SetStretchedImage} ${_hwndImg} "${_ImgPath}" "${_RetImgHandle}"

  !endif

!macroend


;--------------------------------
;Helper macros

!include Util.nsh

!macro MUI_INTERNAL_LOADANDSIZEIMAGE _macro _hwndImg _ImgPath _XAlign _RetImgHandle
  !if "${_XAlign}" == "Auto"
    ${if} $(^RTL) == 1
      Push "*${_ImgPath}"
    ${Else}
      Push "${_ImgPath}"
    ${EndIf}
  !else if "${_XAlign}" == "Right"
    Push "*${_ImgPath}"
  !else
    Push "${_ImgPath}"
  !endif
  Push "${_hwndImg}"
  ${CallArtificialFunction} ${_macro}
  !if "${_RetImgHandle}" == "Leak"
    !insertmacro _LOGICLIB_TEMP
    Pop $_LOGICLIB_TEMP
  !else if "${_RetImgHandle}" != "Stack"
    Pop ${_RetImgHandle}
  !endif
!macroend

!macro MUI_LOADANDXALIGNIMAGE _hwndImg _ImgPath _XAlign _RetImgHandle
!insertmacro MUI_INTERNAL_LOADANDSIZEIMAGE \
  MUI_INTERNAL_LOADANDXALIGNIMAGE "${_hwndImg}" "${_ImgPath}" "${_XAlign}" "${_RetImgHandle}"
!macroend
!macro MUI_INTERNAL_LOADANDXALIGNIMAGE
  System::Store "S"
  System::Call 'USER32::GetWindowRect(psr0,@r1)'
  System::Call 'USER32::MapWindowPoints(p0,p$hwndparent,pr1,i2)' ; Note: Assuming control is not in inner dialog
  System::Call '*$1(i.r5,i.r6,i.r7,i.r8)'
  IntOp $7 $7 - $5
  IntOp $8 $8 - $6

  Pop $1
  StrCpy $3 $1 1
  ${If} $3 == "*" ; Move control to the right?
    StrCpy $1 $1 "" 1
  ${Endif}
  System::Call 'USER32::LoadImage(p0,tr1,i${IMAGE_BITMAP},i0,i0,i${LR_LOADFROMFILE})p.r2'
  SendMessage $0 ${STM_SETIMAGE} ${IMAGE_BITMAP} $2 $1
  Push $2 ; Return value
  System::Call 'GDI32::DeleteObject(pr1)' ; Note: Assuming the previous image (if any) was a bitmap
  System::Call 'USER32::GetClientRect(pr0,@r1)'
  System::Call '*$1(i,i,i.r1,i.r2)'

  ${If} $3 == "*"
  ${AndIf} $1 < $7 ; ImgW < CtlW
    IntOp $3 $7 - $1
    IntOp $5 $5 + $3
    System::Call 'USER32::SetWindowPos(pr0,p0,ir5,ir6,i,i,i0x15)'
  ${EndIf}

  System::Store "L"
!macroend

!macro MUI_LOADANDASPECTSTRETCHIMAGETOCONTROLHEIGHT _hwndImg _ImgPath _XAlign _RetImgHandle
!insertmacro MUI_INTERNAL_LOADANDSIZEIMAGE \
  MUI_INTERNAL_LOADANDASPECTSTRETCHIMAGETOCONTROLHEIGHT "${_hwndImg}" "${_ImgPath}" "${_XAlign}" "${_RetImgHandle}"
!macroend
!macro MUI_INTERNAL_LOADANDASPECTSTRETCHIMAGETOCONTROLHEIGHT
  System::Store "S"
  System::Call 'USER32::GetWindowRect(psr0,@r1)'
  System::Call 'USER32::MapWindowPoints(p0,p$hwndparent,pr1,i2)' ; Note: Assuming control is not in inner dialog
  System::Call '*$1(i.r5,i.r6,i.r7,i.r8)'
  IntOp $7 $7 - $5
  IntOp $8 $8 - $6

  Pop $1
  StrCpy $3 $1 1
  ${If} $3 == "*" ; Move control to the right?
    StrCpy $1 $1 "" 1
  ${Endif}
  System::Call 'USER32::LoadImage(p0,tr1,i${IMAGE_BITMAP},i0,i0,i${LR_LOADFROMFILE})p.r2'
  SendMessage $0 ${STM_SETIMAGE} ${IMAGE_BITMAP} $2 $1
  Push $2 ; Return value
  System::Call 'GDI32::DeleteObject(pr1)' ; Note: Assuming the previous image (if any) was a bitmap
  System::Call 'USER32::GetClientRect(pr0,@r1)'
  System::Call '*$1(i,i,i.r1,i.r2)'

  IntOp $R7 $7 * 10000
  IntOp $R8 $8 * 10000
  IntOp $R1 $1 * 10000
  IntOp $R2 $2 * 10000
  IntOp $R3 $R1 / $2
  StrCpy $R4 10000
  ${If} $R1 > $R2
    StrCpy $R3 10000
    IntOp $R4 $R2 / $1
  ${EndIf}

  ${DoWhile} $R2 > $R8 ; ImgH > CtlH
  IntOp $R1 $R1 - $R3
  IntOp $R2 $R2 - $R4
  ${Loop}
  ${DoWhile} $R2 < $R8 ; ImgH < CtlH
  IntOp $R1 $R1 + $R3
  IntOp $R2 $R2 + $R4
  ${Loop}
  IntOp $1 $R1 / 10000
  IntOp $2 $R2 / 10000

  ${If} $1 < $7
  ${AndIf} $3 == "*"
    IntOp $R3 $7 - $1
    IntOp $5 $5 + $R3
  ${EndIf}

  ${DoWhile} $2 > $8 ; Non-aspect-maintained stretch to make it a pixel perfect match
  IntOp $2 $2 - 1
  IntOp $1 $1 - 1
  ${IfThen} $3 == "*" ${|} IntOp $5 $5 + 1 ${|}
  ${Loop}

  System::Call 'USER32::SetWindowPos(pr0,p0,ir5,ir6,ir1,ir2,i0x14)'
  System::Store "L"
!macroend


