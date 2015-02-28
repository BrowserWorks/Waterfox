" Interactive Data Language syntax file (IDL, too :-)
" located at http://www.creaso.com
" Maintainer:	Hermann.Rochholz@gmx.de
" Last Change:	2001 May 10
" Cleaned a little bit up  April 2001
" Update to vim V6.xx 2001 May
" Preliminary, because I do not use higher language elements of IDL until now.

" Remove any old syntax stuff hanging around
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded

" change 6.xx -----------------------------------------------------------------
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
" change 6.xx -----------------------------------------------------------------

syntax case ignore

syn keyword idlangStatement	return continue endloop
syn keyword idlangConditional	if else goto then begin of
syn keyword idlangConditional	endcase  endelse endfor
syn keyword idlangConditional	endif endrep endwhile
syn keyword idlangRepeat	for while case
"syn match   idlangStrucvar	"[a-zA-Z][a-zA-Z0-9_]*\.[a-zA-Z0-9_]*[a-zA-Z]\ *\((\|)\|\[\)"me=e-1
syn match   idlangStrucvar	"[a-zA-Z][a-zA-Z0-9_]*\.[a-zA-Z0-9_]*[a-zA-Z]"
syn match   idlangSystem            "\![a-zA-Z][a-zA-Z0-9_]*\.\=[a-zA-Z0-9_]*[a-zA-Z]*"
syn match   idlangKeyword           ",\ *\/[a-zA-Z_]\{3,}"ms=s+1

syn keyword idlangTodo contained	TODO

syn region  idlangString	start=+"+  end=+"+
syn region  idlangString	start=+'+  end=+'+

"syn match  idlangIdentifier	"\<[a-zA-Z_][a-zA-Z0-9_]*\>"
"syn match  idlangDelimiter	"[()]"

syn match   idlangPreCondit	"^@.*[A-Z][A-Z0-9_]\+"
syn match  idlangRealNumber	"-\=\<[0-9]\+\.[0-9]\+[eE]-\=[0-9]\+\>"
syn match  idlangRealNumber	"-\=\<[0-9]\+\.[0-9]\+\>"
syn match  idlangNumber	"-\=\<[0-9]\+\>"

" If you don't like initial tabs in idlang
"syn match idlangShowIniTab "\t"

syn match  idlangComment	"[\;].*$" contains=idlangTodo

syn match  idlangConditionll	"endif\ \+else\ \+\(if\|begin\)"
syn match  idlangConditionll	"then\ \+begin"

syn match  idlangContinueLine	"\$\ *\($\|;\)"he=s+1 contains=idlangComment
syn match  idlangContinueLine	/&\ *\(\a\|;\)/he=s+1 contains=ALL

syn match  idlangDblCommaError	"\,\ *\,"
syn keyword idlangStop              stop  pause

syn match idlangOperator	"\ and\ "
syn match idlangOperator	"\ eq\ "
syn match idlangOperator	"\ ge\ "
syn match idlangOperator	"\ gt\ "
syn match idlangOperator	"\ le\ "
syn match idlangOperator	"\ lt\ "
syn match idlangOperator	"\ ne\ "
syn match idlangOperator	/\(\ \|(\)not\ /hs=e-3
syn match idlangOperator	"\ or\ "
syn match idlangOperator	"\ xor\ "

syn match idlangLogicalConstant	"\ true\ "
syn match idlangLogicalConstant	"\ false\ "

"syn keyword idlangType	int int2 int4
"syn keyword idlangType	integer real real8 int4
"syn keyword idlangType	complex
"syn keyword idlangType	character logical

syn keyword idlangStructure	common strarr bytarr  complexarr  dblarr
syn keyword idlangStructure	dcomplexarr fltarr intarr lonarr make_array
"syn keyword idlangStructure	external intrinsic save


syn keyword idlangReadWrite	openw openr readf read  printf print
syn keyword idlangReadWrite	close rewind backspace inquire write
syn keyword idlangUnixCmd	spawn

syn keyword idlangFormat	format unit fmt status file
syn keyword idlangFormat	err form access iostat rec
syn keyword idlangFormat	recl blank


syn keyword idlangImplicit	abs acos acot atan asin cos
syn keyword idlangImplicit	cosh cot aimag anint atan2
syn keyword idlangImplicit	cmplx conj
syn keyword idlangImplicit	dprod exp
syn keyword idlangImplicit	log ln log10 ALOG ALOG10
syn keyword idlangImplicit	max min mod
syn keyword idlangImplicit	sin sinh sign sqrt tan tanh
syn keyword idlangImplicit	maximum minimum modulo

syn keyword idlangColor	definecolor setcolor

syn keyword idlangDiagram	linewidth crosshatch addfillcurve
syn keyword idlangDiagram	setxlabel setylabel setxscale setyscale
syn keyword idlangDiagram	setxaxis setyaxis addgraph

syn keyword idlangRoutine	A_CORRELATE ABS
syn keyword idlangRoutine	AMOEBA ANNOTATE ARG_PRESENT ARROW
syn keyword idlangRoutine	ASCII_TEMPLATE ASSOC AXIS

syn keyword idlangRoutine	BAR_PLOT BESELI BESELJ BESELY
syn keyword idlangRoutine	BETA BILINEAR BIN_DATE BINDGEN
syn keyword idlangRoutine	BINOMIAL BLAS_AXPY BLK_CON BOX_CURSOR
syn keyword idlangRoutine	BREAKPOINT BROYDEN BYTARR
syn keyword idlangRoutine	BYTE BYTEORDER BYTSCL

syn keyword idlangRoutine	C_CORRELATE CALDAT CALENDAR
syn keyword idlangRoutine	CALL_EXTERNAL CALL_FUNCTION
syn keyword idlangRoutine	CALL_METHOD CALL_PROCEDURE
syn keyword idlangRoutine	CATCH CD CEIL CHEBYSHEV
syn keyword idlangRoutine	CHECK_MATH CHISQR_CVF CHISQR_PDF
syn keyword idlangRoutine	CHOLDC CHOLSOL CINDGEN CIR_3PNT
"syn keyword idlangRoutine	CLOSE
syn keyword idlangRoutine	CLUST_WTS CLUSTER COLOR_CONVERT
syn keyword idlangRoutine	COLOR_QUAN COMFIT COMPLEX COMPLEXARR
syn keyword idlangRoutine	COMPLEXROUND COMPUTE_MESH_NORMALS COND
syn keyword idlangRoutine	CONGRID CONJ CONSTRAINED_MIN CONTOUR
syn keyword idlangRoutine	CONVERT_COORD CONVOL COORD2TO3
syn keyword idlangRoutine	CORRELATE CRAMER CREATE_STRUCT
syn keyword idlangRoutine	CREATE_VIEW CROSSP CRVLENGTH
syn keyword idlangRoutine	CT_LUMINANCE CTI_TEST CURSOR CURVEFIT
syn keyword idlangRoutine	CV_COORD CW_ANIMATE CW_ANIMATE_LOAD
syn keyword idlangRoutine	CW_ANIMATE_RUN CW_ANIMATE_GETP CW_ARCBALL
syn keyword idlangRoutine	CW_BGROUP CW_CLR_INDEX CW_COLORSEL
syn keyword idlangRoutine	CW_DEFROI CW_DICE CW_FIELD CW_FORM
syn keyword idlangRoutine	CW_FSLIDER CW_ORIENT CW_PDMENU
syn keyword idlangRoutine	CW_RGBSLIDER CW_TMPL CW_ZOOM

syn keyword idlangRoutine	DAY_NAME DAY_OF_WEEK DAY_OF_YEAR
syn keyword idlangRoutine	DBLARR DCINDGEN DCOMPLEX
syn keyword idlangRoutine	DCOMPLEXARR DEFINE_KEY DEFROI
"syn keyword idlangRoutine	DELETE_SYMBOL (VMS Only)
"syn keyword idlangRoutine	DELLOG (VMS Only)
syn keyword idlangRoutine	DEFSYSV DELETE_SYMBOL DELLOG
syn keyword idlangRoutine	DELVAR DEMO_MODE DERIV DERIVSIG
syn keyword idlangRoutine	DETERM DEVICE DFPMIN
syn keyword idlangRoutine	DIALOG_MESSAGE DIALOG_PICKFILE
syn keyword idlangRoutine	DIALOG_PRINTJOB DIALOG_PRINTERSETUP
syn keyword idlangRoutine	DIGITAL_FILTER DILATE DINDGEN
syn keyword idlangRoutine	DISSOLVE DIST DO_APPLE_SCRIPT
syn keyword idlangRoutine	DOC_LIBRARY DOUBLE DT_ADD
syn keyword idlangRoutine	DT_SUBTRACT DT_TO_VAR

syn keyword idlangRoutine	EFONT EIGENQL EIGENVEC ELMHES
syn keyword idlangRoutine	EMPTY EOF ERASE ERODE
syn keyword idlangRoutine	ERRORF ERRPLOT EXECUTE EXIT
syn keyword idlangRoutine	EXP EXPAND EXPAND_PATH
syn keyword idlangRoutine	EXPINT EXTRAC EXTRACT_SLICE

syn keyword idlangRoutine	F_CVF F_PDF FACTORIAL FFT
syn keyword idlangRoutine	FILEPATH FINDFILE FINDGEN FINITE
syn keyword idlangRoutine	FIX FLICK FLOAT FLOOR
syn keyword idlangRoutine	FLOW3 FLTARR FLUSH
syn keyword idlangRoutine	FORMAT_AXIS_VALUES FREE_LUN
syn keyword idlangRoutine	FSTAT FULSTR FUNCT
syn keyword idlangRoutine	FV_TEST FX_ROOT FZ_ROOTS

syn keyword idlangRoutine	GAMMA GAMMA_CT GAUSS_CVF
syn keyword idlangRoutine	GAUSS_PDF GAUSS2DFIT GAUSSFIT
syn keyword idlangRoutine	GAUSSINT GET_KBRD GET_LUN
"syn keyword idlangRoutine	GET_SYMBOL (VMS Only)
syn keyword idlangRoutine	GET_SYMBOL GETENV GRID3 GS_ITER

syn keyword idlangRoutine	H_EQ_CT H_EQ_INT HANNING
syn keyword idlangRoutine	HDF_BROWSER HDF_READ HEAP_GC HELP
syn keyword idlangRoutine	HILBERT HIST_2D HIST_EQUAL
syn keyword idlangRoutine	HISTOGRAM HLS HQR HSV

syn keyword idlangRoutine	IBETA IDENTITY IDLDT__DEFINE
syn keyword idlangRoutine	IGAMMA IMAGE_CONT IMAGINARY
syn keyword idlangRoutine	INDGEN INT_2D INT_3D
syn keyword idlangRoutine	INT_TABULATED INTARR INTERPOL
syn keyword idlangRoutine	INTERPOLATE INVERT IOCTL ISHFT

syn keyword idlangRoutine	JOURNAL JUL_TO_DT JULDAY

syn keyword idlangRoutine	KEYWORD_SET KRIG2D
syn keyword idlangRoutine	KURTOSIS KW_TEST

syn keyword idlangRoutine	LABEL_DATE LABEL_REGION
syn keyword idlangRoutine	LADFIT LEEFILT LINBCG LINDGEN
syn keyword idlangRoutine	LINFIT LINKIMAGE
syn keyword idlangRoutine	LIVE_CONTOUR LIVE_CONTROL
syn keyword idlangRoutine	LIVE_DESTROY LIVE_EXPORT
syn keyword idlangRoutine	LIVE_IMAGE LIVE_INFO
syn keyword idlangRoutine	LIVE_LINE LIVE_OPLOT
syn keyword idlangRoutine	LIVE_PLOT LIVE_PRINT
syn keyword idlangRoutine	LIVE_RECT LIVE_STYLE
syn keyword idlangRoutine	LIVE_SURFACE LIVE_TEXT
syn keyword idlangRoutine	LJLCT LL_ARC_DISTANCE
syn keyword idlangRoutine	LMFIT LMGR LNGAMMA
syn keyword idlangRoutine	LNP_TEST LOADCT LONARR
syn keyword idlangRoutine	LONG LSODE LU_COMPLEX
syn keyword idlangRoutine	LUDC LUMPROVE LUSOL

syn keyword idlangRoutine	M_CORRELATE MACHAR
syn keyword idlangRoutine	MAKE_ARRAY MAP_CONTINENTS
syn keyword idlangRoutine	MAP_GRID MAP_IMAGE
syn keyword idlangRoutine	MAP_PATCH MAP_SET MD_TEST
syn keyword idlangRoutine	MEAN MEANABSDEV MEDIAN
syn keyword idlangRoutine	MESH_OBJ MESSAGE MIN_CURVE_SURF
syn keyword idlangRoutine	MK_HTML_HELP MODIFYCT
syn keyword idlangRoutine	MOMENT MPEG_CLOSE MPEG_OPEN
syn keyword idlangRoutine	MPEG_PUT MPEG_SAVE MULTI

syn keyword idlangRoutine	N_ELEMENTS N_PARAMS
syn keyword idlangRoutine	N_TAGS NEWTON NORM

syn keyword idlangRoutine	OBJ_CLASS OBJ_DESTROY
syn keyword idlangRoutine	OBJ_ISA OBJ_NEW OBJ_VALID
syn keyword idlangRoutine	OBJARR ON_ERROR
syn keyword idlangRoutine	ON_IOERROR ONLINE_HELP
syn keyword idlangRoutine	OPEN OPLOT OPLOTERR

syn keyword idlangRoutine	P_CORRELATE PCOMP PLOT
syn keyword idlangRoutine	PLOT_3DBOX PLOT_FIELD PLOTERR
syn keyword idlangRoutine	PLOTS PNT_LINE POINT_LUN
syn keyword idlangRoutine	POLAR_CONTOUR POLAR_SURFACE
syn keyword idlangRoutine	POLY POLY_2D POLY_AREA
syn keyword idlangRoutine	POLY_FIT POLYFILL POLYFILLV
syn keyword idlangRoutine	POLYFITW POLYSHADE POLYWARP
syn keyword idlangRoutine	POPD POWELL PRIMES
syn keyword idlangRoutine	PRINT PRINTF PRINTD
syn keyword idlangRoutine	PROFILE PROFILER PROFILES
syn keyword idlangRoutine	PROJECT_VOL PS_SHOW_FONTS
syn keyword idlangRoutine	PSAFM PSEUDO PTR_FREE PTR_NEW
syn keyword idlangRoutine	PTR_VALID PTRARR PUSHD

syn keyword idlangRoutine	QROMB QROMO QSIMP

syn keyword idlangRoutine	R_CORRELATE R_TEST
syn keyword idlangRoutine	RANDOMN RANDOMU
syn keyword idlangRoutine	RANKS RDPIX
syn keyword idlangRoutine	READ READF READS READU
syn keyword idlangRoutine	READ_ASCII READ_BMP
syn keyword idlangRoutine	READ_GIF READ_INTERFILE
syn keyword idlangRoutine	READ_JPEG READ_PICT
syn keyword idlangRoutine	READ_PPM READ_SPR
syn keyword idlangRoutine	READ_SRF READ_SYLK
syn keyword idlangRoutine	READ_TIFF READ_WAVE
syn keyword idlangRoutine	READ_X11_BITMAP READ_XWD
syn keyword idlangRoutine	REBIN RECALL_COMMANDS
syn keyword idlangRoutine	RECON3 REDUCE_COLORS REFORM
syn keyword idlangRoutine	REGRESS REPLICATE
syn keyword idlangRoutine	REPLICATE_INPLACE RESOLVE_ALL
syn keyword idlangRoutine	RESOLVE_ROUTINE RESTORE
syn keyword idlangRoutine	RETALL RETURN REVERSE REWIND
syn keyword idlangRoutine	RIEMANN RK4 ROBERTS ROT
syn keyword idlangRoutine	ROTATE ROUND ROUTINE_INFO
syn keyword idlangRoutine	RS_TEST RSTRPOS

syn keyword idlangRoutine	S_TEST SAVE SCALE3 SCALE3D
syn keyword idlangRoutine	SEARCH2D SEARCH3D
syn keyword idlangRoutine	SEC_TO_DT SET_PLOT SET_SHADING
"syn keyword idlangRoutine	SETENV (Unix and Windows Only)
syn keyword idlangRoutine	SET_SYMBOL SETENV
"syn keyword idlangRoutine	SETLOG (VMS Only)
syn keyword idlangRoutine	SETLOG SETUP_KEYS SFIT
syn keyword idlangRoutine	SHADE_SURF SHADE_SURF_IRR
syn keyword idlangRoutine	SHADE_VOLUME SHIFT
syn keyword idlangRoutine	SHOW3 SHOWFONT SINDGEN
syn keyword idlangRoutine	SIZE SKEWNESS SKIPF
syn keyword idlangRoutine	SLICER3 SLIDE_IMAGE SMOOTH
syn keyword idlangRoutine	SOBEL SORT SPAWN SPH_4PNT
syn keyword idlangRoutine	SPH_SCAT SPL_INIT SPL_INTERP
syn keyword idlangRoutine	SPLINE SPLINE_P SPRSAB
syn keyword idlangRoutine	SPRSAX SPRSIN STANDARDIZE
syn keyword idlangRoutine	STDDEV STR_SEP STR_TO_DT
syn keyword idlangRoutine	STRARR STRCOMPRESS
syn keyword idlangRoutine	STRETCH STRING STRLEN
syn keyword idlangRoutine	STRLOWCASE STRMESSAGE
syn keyword idlangRoutine	STRMID STRPOS STRPUT STRTRIM
syn keyword idlangRoutine	STRUCT_ASSIGN STRUPCASE
syn keyword idlangRoutine	SURFACE SURFR SVDC SVDFIT
syn keyword idlangRoutine	SVSOL SWAP_ENDIAN SYSTIME

syn keyword idlangRoutine	T_CVF T_PDF T3D TAG_NAMES
syn keyword idlangRoutine	TAPRD TAPWRT TEK_COLOR
syn keyword idlangRoutine	TEMPORARY THIN THREED
syn keyword idlangRoutine	TIME_TEST2 TM_TEST TODAY
syn keyword idlangRoutine	TOTAL TRACE TRANSPOSE
syn keyword idlangRoutine	TRI_SURF TRIANGULATE TRIGRID
syn keyword idlangRoutine	TRIQL TRIRED TRISOL TRNLOG
syn keyword idlangRoutine	TS_COEF TS_DIFF TS_FCAST
syn keyword idlangRoutine	TS_SMOOTH
syn keyword idlangRoutine	TV TVCRS TVLCT TVRD TVSCL

syn keyword idlangRoutine	UNIQ USERSYM

syn keyword idlangRoutine	VAR_TO_DT VARIANCE
syn keyword idlangRoutine	VAX_FLOAT VEL VELOVECT
syn keyword idlangRoutine	VERT_T3D VOIGT
syn keyword idlangRoutine	VORONOI VOXEL_PROJ

syn keyword idlangRoutine	WAIT WARP_TRI WDELETE
syn keyword idlangRoutine	WEOF WF_DRAW WHERE
syn keyword idlangRoutine	WIDGET_BASE WIDGET_BUTTON
syn keyword idlangRoutine	WIDGET_CONTROL WIDGET_DRAW
syn keyword idlangRoutine	WIDGET_DROPLIST WIDGET_EVENT
syn keyword idlangRoutine	WIDGET_INFO WIDGET_LABEL
syn keyword idlangRoutine	WIDGET_LIST WIDGET_SLIDER
syn keyword idlangRoutine	WIDGET_TABLE WIDGET_TEXT
syn keyword idlangRoutine	WINDOW
syn keyword idlangRoutine	WRITE_BMP WRITE_GIF
syn keyword idlangRoutine	WRITE_JPEG WRITE_NRIF
syn keyword idlangRoutine	WRITE_PICT WRITE_PPM
syn keyword idlangRoutine	WRITE_SPR WRITE_SRF
syn keyword idlangRoutine	WRITE_SYLK WRITE_TIFF
syn keyword idlangRoutine	WRITE_WAVE WRITEU WSET WSHOW WTN

syn keyword idlangRoutine	XBM_EDIT XDISPLAYFILE
syn keyword idlangRoutine	XFONT XINTERANIMATE
syn keyword idlangRoutine	XLOADCT XMANAGER
syn keyword idlangRoutine	XMNG_TMPL XMTOOL
syn keyword idlangRoutine	XPALETTE XREGISTERED
syn keyword idlangRoutine	XSQ_TEST XSURFACE
syn keyword idlangRoutine	XVAREDIT XYOUTS

syn keyword idlangRoutine	ZOOM ZOOM_24


"syn keyword idlangRoutine	EOS_*
"syn keyword idlangRoutine	HDF_GR*, HDF_AN*
syn keyword idlangRoutine	HDF_BROWSER HDF_READ
syn keyword idlangRoutine	L64INDGEN LIVE_LOAD
syn keyword idlangRoutine	LON64ARR LONG64
syn keyword idlangRoutine	MAP_PROJ_INFO
syn keyword idlangRoutine	QUERY_BMP QUERY_DICOM
syn keyword idlangRoutine	QUERY_JPEG QUERY_PICT
syn keyword idlangRoutine	QUERY_PNG QUERY_PPM
syn keyword idlangRoutine	QUERY_SRF QUERY_TIFF
syn keyword idlangRoutine	READ_DICOM READ_PNG
syn keyword idlangRoutine	UINDGEN UINT UINTARR
syn keyword idlangRoutine	UL64INDGEN ULINDGEN
syn keyword idlangRoutine	ULON64ARR ULONARR
syn keyword idlangRoutine	ULONG ULONG64
syn keyword idlangRoutine	WRITE_PNG
syn keyword idlangRoutine	BYTEORDER L64SWAP

" overwrite LongName
syn match  idlangContinueLine	"nomessage"
syn match  idlangContinueLine	"insertcol"

syn match idlangReadWrite	"\ *pro\ "
syn match idlangReadWrite	"\ *function\ "

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
" change 6.xx -----------------------------------------------------------------
if version >= 508 || !exists("did_idlang_syn_inits")
  if version < 508
    let did_idlang_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
" change 6.xx -----------------------------------------------------------------

" OLD  if !exists("did_idlang_syntax_inits")
" OLD    let did_idlang_syntax_inits = 1

  HiLink idlangConditional	Conditional
  HiLink idlangConditionll	Conditional
  HiLink idlangRepeat	Repeat
  HiLink idlangColor	idlangType
  HiLink idlangCommand	idlangType
  HiLink idlangRoutine	idlangType
  HiLink idlangDiagram	idlangType
  HiLink idlangIO	idlangType
  HiLink idlangStatement	Statement
  HiLink idlangType	Type
  HiLink idlangContinueLine	Todo
  HiLink idlangRealNumber	Float
  HiLink idlangNumber	Number
  HiLink idlangCommentError	Error
  HiLink idlangString	String
  HiLink idlangOperator	Operator
  HiLink idlangLogicalConstant	Constant
  HiLink idlangComment	Comment
  HiLink idlangTodo	Todo
  HiLink idlangUnitHeader	idlangPreCondit
  HiLink idlangFormat	idlangImplicit
  HiLink idlangReadWrite	Statement
  HiLink idlangImplicit	Identifier
  HiLink idlangUnixCmd	Statement
  HiLink idlangPreProc	PreProc
"  HiLink idlangExtended	idlangImplicit
  HiLink idlangPreCondit	PreCondit

  " optional hiing
  "HiLink idlangContinueError		Error
  "HiLink idlangSpecial		Special
  "HiLink idlangPointRealNumber	idlangNumber
  "HiLink idlangPointDoubleNumber	idlangNumber
"  HiLink idlangLongName	Error
  HiLink idlangDblCommaError	Error
  HiLink idlangStop	Error
  "HiLink idlangDelimiter		Identifier
  HiLink idlangStructure	idlangType
  HiLink idlangStrucvar	idlangPreProc
  HiLink idlangSystem	Identifier
  HiLink idlangKeyword	Special

  "HiLink idlangIdentifier	Identifier

  delcommand HiLink
endif

let b:current_syntax = "idlang"

" vim: ts=18

