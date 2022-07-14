#################################
# CPU features plug-in for NSIS #
#################################


### FUNCTION DECLARTIONS ###

!define CPUFeatures.GetFlags         '!insertmacro _CPUFeatures_GetFlags'         #Get CPU Flags as a single Hex value (for debugging only!)
!define CPUFeatures.GetFeatures      '!insertmacro _CPUFeatures_GetFeatures'      #Get all supported CPU Features, returns a single string (comma-separated list)
!define CPUFeatures.GetVendor        '!insertmacro _CPUFeatures_GetVendor'        #Get CPU vendor (e.g. "Intel" or "AMD"), returns a string
!define CPUFeatures.CheckFeature     '!insertmacro _CPUFeatures_CheckFeature'     #Check for a specific feature (e.g. "MMX1"), returns "yes" or "no" or "error"
!define CPUFeatures.CheckAllFeatures '!insertmacro _CPUFeatures_CheckAllFeatures' #Check for multiple features (comma-separated list), returns "yes" or "no" or "error"
!define CPUFeatures.GetCount         '!insertmacro _CPUFeatures_GetCount'         #Get the number of CPU's (or more precise: CPU "cores")


### SUPPORTED CPU FEATURE FLAGS ###

# MMX1         -> MMX supported
# MMX2         -> MMX2 aka MMXEX aka Integer-SSE supported
# SSE1         -> SSE supported
# SSE2         -> SSE2 supported
# SSE2_SLOW    -> Most SSE2 functions are SLOW (e.g. Athlon64)
# SSE2_FAST    -> Some SSE2 functions are only faster on specific CPU's (Core2 and Phenom)
# SSE3         -> SSE3 supported
# SSSE3        -> SSSE3 supported
# FAST_SHUFFLE -> Penryn, Nehalem, and Phenom have fast shuffle units
# STACK_MOD4   -> Stack is only mod4, not mod16
# SSE4         -> SSE4.1 supported
# SSE4.2       -> SSE4.2 supported
# SSE_MISALIGN -> Phenom support for misaligned SSE instruction arguments
# LZCNT        -> Phenom support for "leading zero count" instruction
# SLOW_CTZ     -> BSR/BSF x86 instructions are really slow
# SLOW_ATOM    -> Intel Atom ("the Atom just sucks")
# AVX1         -> AVX supported, also by the OS (AVX requires OS support even if YMM registers aren't used)
# XOP          -> AMD XOP supported
# FMA4         -> AMD FMA4 supported
# AVX2         -> AVX2 supported
# FMA3         -> Intel FMA3 supported
# 3DNOW        -> AMD 3DNow! supported
# 3DNOW_EX     -> AMD 3DNow!+ (aka Enhanced 3DNow!) supported


### MACRO DEFINITIONS ###

!macro _CPUFeatures_GetFlags out
	CPUFeatures::GetCPUFlags /NOUNLOAD
	pop ${out}
!macroend

!macro _CPUFeatures_GetFeatures out
	CPUFeatures::GetCPUFeatures /NOUNLOAD
	pop ${out}
!macroend

!macro _CPUFeatures_GetVendor out
	CPUFeatures::GetCPUVendor /NOUNLOAD
	pop ${out}
!macroend

!macro _CPUFeatures_CheckFeature feature out
	push `${feature}`
	CPUFeatures::CheckCPUFeature /NOUNLOAD
	pop ${out}
!macroend

!macro _CPUFeatures_CheckAllFeatures feature_list out
	push `${feature_list}`
	CPUFeatures::CheckAllCPUFeatures /NOUNLOAD
	pop ${out}
!macroend

!macro _CPUFeatures_GetCount out
	CPUFeatures::GetCPUCount /NOUNLOAD
	pop ${out}
!macroend


### LOGIC_LIB SUPPORT ###

!ifdef LOGICLIB
	; ${If} ${CPUSupports} <flag> ... ${EndIf}
	!macro _CPUSupports _a _b _t _f
		!insertmacro _LOGICLIB_TEMP
		push `${_b}`
		CPUFeatures::CheckCPUFeature /NOUNLOAD
		pop $_LOGICLIB_TEMP
		#StrCmp $_LOGICLIB_TEMP `error` 0 +2
		#MessageBox MB_ICONSTOP "CPUSupports_ Invalid CPU flags specified!"
		!insertmacro _== $_LOGICLIB_TEMP `yes` `${_t}` `${_f}`
	!macroend
	!define CPUSupports `"" CPUSupports`

	; ${If} ${CPUSupportsAll} <flag_list> ... ${EndIf}
	!macro _CPUSupportsAll _a _b _t _f
		!insertmacro _LOGICLIB_TEMP
		push `${_b}`
		CPUFeatures::CheckAllCPUFeatures /NOUNLOAD
		pop $_LOGICLIB_TEMP
		#StrCmp $_LOGICLIB_TEMP `error` 0 +2
		#MessageBox MB_ICONSTOP "CPUSupportsAll: Invalid CPU flags specified!"
		!insertmacro _== $_LOGICLIB_TEMP `yes` `${_t}` `${_f}`
	!macroend
	!define CPUSupportsAll `"" CPUSupportsAll`
!endif
