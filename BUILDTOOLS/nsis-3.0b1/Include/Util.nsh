; ---------------------
;       Util.nsh
; ---------------------
;
; Voodoo macros to make end-user usage easier. This may be documented someday.

!verbose push 3
!ifndef ___UTIL__NSH___
!define ___UTIL__NSH___

# CallArtificialFunction, see WinVer.nsh and *Func.nsh for usage examples
!macro CallArtificialFunctionHelper TYPE NAME
  !verbose pop
  Call :.${NAME}${TYPE}
  !ifndef ${NAME}${TYPE}_DEFINED
    !verbose push 2
    Goto ${NAME}${TYPE}_DONE
    !define ${NAME}${TYPE}_DEFINED
    !verbose pop
    .${NAME}${TYPE}:
      !insertmacro ${NAME}
      Return
    ${NAME}${TYPE}_DONE:
  !endif
  !verbose push 2
!macroend

!macro CallArtificialFunction NAME
  !verbose push 2
  !ifdef __UNINSTALL__
    !insertmacro CallArtificialFunctionHelper uninst ${NAME}
  !else
    !insertmacro CallArtificialFunctionHelper inst ${NAME}
  !endif
  !verbose pop
!macroend
!define CallArtificialFunction `!insertmacro CallArtificialFunction`

!macro CallArtificialFunction2 NAME ; Retained for v2.4x..v3.0b0 compatibility
  ${CallArtificialFunction} ${NAME}
!macroend
!define CallArtificialFunction2 `!insertmacro CallArtificialFunction`


!define Int32Op '!insertmacro Int32Op '
!define Int64Op '!insertmacro Int64Op '
!define IntPtrOp '!insertmacro IntPtrOp '
!macro Int32Op r a o b
!if ${NSIS_PTR_SIZE} <= 4
  IntOp ${r} ${a} ${o} ${b}
!else
  !error "Int32Op not implemented"
!endif
!macroend
!macro Int64Op r a o b
System::Int64Op ${a} ${o} ${b}
Pop ${r}
!macroend
!macro IntPtrOp r a o b
!if ${NSIS_PTR_SIZE} <= 4
  ${Int32Op} ${r} ${a} ${o} "${b}"
!else
  ${Int64Op} ${r} ${a} ${o} "${b}"
!endif
!macroend

!define Int32Cmp '!insertmacro Int32Cmp '
!define Int64Cmp '!insertmacro Int64Cmp '
!define IntPtrCmp '!insertmacro IntPtrCmp '
!macro Int32Cmp a b jeek jles jgtr
!if ${NSIS_PTR_SIZE} <= 4
  IntCmp ${a} ${b} "${jeek}" "${jles}" "${jgtr}"
!else
  !error "Int32Cmp not implemented"
!endif
!macroend
!macro Int64Cmp a b jeek jles jgtr
!ifmacrondef _LOGICLIB_TEMP
!include LogicLib.nsh
!endif
!echo "Int64Cmp ${a} ${b} ${jeek} ${jles} ${jgtr}"
!verbose push 2
${IfThen} ${a} L= ${b} ${|} Goto ${jeek} ${|}
!insertmacro _L< ${a} ${b} ${jles} ${jgtr}
!verbose pop
!macroend
!macro IntPtrCmp a b jeek jles jgtr
!if ${NSIS_PTR_SIZE} <= 4
  ${Int32Cmp} ${a} ${b} ${jeek} ${jles} ${jgtr}
!else
  ${Int64Cmp} ${a} ${b} ${jeek} ${jles} ${jgtr}
!endif
!macroend

!define Int32CmpU '!insertmacro Int32CmpU '
!define Int64CmpU '!insertmacro Int64CmpU '
!define IntPtrCmpU '!insertmacro IntPtrCmpU '
!macro Int32CmpU a b jeek jles jgtr
!if ${NSIS_PTR_SIZE} <= 4
  IntCmpU ${a} ${b} "${jeek}" "${jles}" "${jgtr}"
!else
  !error "Int32CmpU not implemented"
!endif
!macroend
!macro Int64CmpU a b jeek jles jgtr
!ifmacrondef _LOGICLIB_TEMP
!include LogicLib.nsh
!endif
!echo "Int64CmpU ${a} ${b} ${jeek} ${jles} ${jgtr}"
!verbose push 2
!insertmacro _LOGICLIB_TEMP
${IfThen} ${a} L= ${b} ${|} Goto ${jeek} ${|}
${If} ${a} L> 0
  ${IfThen} ${b} L< 0 ${|} Goto ${jles} ${|}
${ElseIf} ${b} L> 0
  ${IfThen} ${a} L< 0 ${|} Goto ${jgtr} ${|}
${EndIf}
!insertmacro _L< ${a} ${b} ${jles} ${jgtr}
!verbose pop
!macroend
!macro IntPtrCmpU a b jeek jles jgtr
!if ${NSIS_PTR_SIZE} <= 4
  ${Int32CmpU} ${a} ${b} ${jeek} ${jles} ${jgtr}
!else
  ${Int64CmpU} ${a} ${b} ${jeek} ${jles} ${jgtr}
!endif
!macroend


!endif # !___UTIL__NSH___
!verbose pop
