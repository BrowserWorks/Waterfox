" Vim syntax file
" Language:	Fvwm{1,2} configuration file
" Maintainer:	Haakon Riiser <haakon@riiser.net>
" Last Change:	2001 Apr 25

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syn clear
elseif exists("b:current_syntax")
    finish
endif

" Fvwm configuration files are case insensitive
syn case ignore

if version >= 600
    setlocal iskeyword=_,-,+,.,a-z,A-Z,48-57
else
    set iskeyword=_,-,+,.,a-z,A-Z,48-57
endif

" Read system colors from the color database (rgb.txt)
if exists("rgb_file")
    " We don't want any hit-return prompts, so we make sure that
    " &shortmess is set to `O'
    let __fvwm_oldshm = &shortmess
    set shortmess=O

    " And we set &report to a huge number, so that no hit-return prompts
    " will be given
    let __fvwm_oldreport = &report
    set report=10000

    " Append the color database to the fvwm configuration, and read the
    " colors from this buffer
    let __fvwm_i = line("$") + 1
    exe "$r" rgb_file
    let __fvwm_lastline = line("$")
    while __fvwm_i <= __fvwm_lastline
	let __fvwm_s = matchstr(getline(__fvwm_i), '^\s*\d\+\s\+\d\+\s\+\d\+\s\+\h.*$')
	if __fvwm_s != ""
	    exe "syn keyword fvwmColors ".substitute(__fvwm_s, '^\s*\d\+\s\+\d\+\s\+\d\+\s\+\(\h.*\)$', '\1', "")
	endif
	let __fvwm_i = __fvwm_i + 1
    endwhile

    " Remove the appended data
    undo

    " Goto first line again
    1

    " and restore the old values of the variables
    let &shortmess = __fvwm_oldshm
    let &report = __fvwm_oldreport
    unlet __fvwm_i __fvwm_s __fvwm_lastline __fvwm_oldshm __fvwm_oldreport
endif
" done reading colors

syn match   fvwmWhitespace	"\s\+" contained
syn match   fvwmEnvVar		"\$\w\+"
syn match   fvwmModConf		"^\s*\*\a\+" contains=fvwmWhitespace
syn match   fvwmString		'".\{-}"'
syn match   fvwmRGBValue	"#\x\{3}"
syn match   fvwmRGBValue	"#\x\{6}"
syn match   fvwmRGBValue	"#\x\{9}"
syn match   fvwmRGBValue	"#\x\{12}"
syn match   fvwmRGBValue	"rgb:\x\{1,4}/\x\{1,4}/\x\{1,4}"
syn match   fvwmPath		"\<IconPath\s.*$"lc=8 contains=fvwmEnvVar
syn match   fvwmPath		"\<ModulePath\s.*$"lc=10 contains=fvwmEnvVar
syn match   fvwmPath		"\<PixmapPath\s.*$"lc=10 contains=fvwmEnvVar
syn match   fvwmModule		"\<Module\s\+\w\+"he=s+6
syn match   fvwmKey		"\<Key\s\+\w\+"he=s+3
syn keyword fvwmExec		Exec
syn match   fvwmComment		"^#.*$"

if (exists("b:fvwm_version") && b:fvwm_version == 1) || (exists("use_fvwm_1") && use_fvwm_1)
    syn match  fvwmEnvVar	"\$(\w\+)"
    syn region fvwmStyle	matchgroup=fvwmFunction start="^\s*Style\>"hs=e-5 end="$" oneline keepend contains=fvwmString,fvwmKeyword,fvwmWhiteSpace

    syn keyword fvwmFunction	AppsBackingStore AutoRaise BackingStore
    syn keyword fvwmFunction	Beep BoundaryWidth ButtonStyle
    syn keyword fvwmFunction	CenterOnCirculate CirculateDown
    syn keyword fvwmFunction	CirculateHit CirculateSkip
    syn keyword fvwmFunction	CirculateSkipIcons CirculateUp
    syn keyword fvwmFunction	ClickTime ClickToFocus Close Cursor
    syn keyword fvwmFunction	CursorMove DecorateTransients Delete
    syn keyword fvwmFunction	Desk DeskTopScale DeskTopSize Destroy
    syn keyword fvwmFunction	DontMoveOff EdgeResistance EdgeScroll
    syn keyword fvwmFunction	EndFunction EndMenu EndPopup Focus
    syn keyword fvwmFunction	Font Function GotoPage HiBackColor
    syn keyword fvwmFunction	HiForeColor Icon IconBox IconFont
    syn keyword fvwmFunction	Iconify IconPath Key Lenience Lower
    syn keyword fvwmFunction	Maximize MenuBackColor MenuForeColor
    syn keyword fvwmFunction	MenuStippleColor Module ModulePath Mouse
    syn keyword fvwmFunction	Move MWMBorders MWMButtons MWMDecorHints
    syn keyword fvwmFunction	MWMFunctionHints MWMHintOverride MWMMenus
    syn keyword fvwmFunction	NoBorder NoBoundaryWidth Nop NoPPosition
    syn keyword fvwmFunction	NoTitle OpaqueMove OpaqueResize Pager
    syn keyword fvwmFunction	PagerBackColor PagerFont PagerForeColor
    syn keyword fvwmFunction	PagingDefault PixmapPath Popup Quit Raise
    syn keyword fvwmFunction	RaiseLower RandomPlacement Refresh Resize
    syn keyword fvwmFunction	Restart SaveUnders Scroll SloppyFocus
    syn keyword fvwmFunction	SmartPlacement StartsOnDesk StaysOnTop
    syn keyword fvwmFunction	StdBackColor StdForeColor Stick Sticky
    syn keyword fvwmFunction	StickyBackColor StickyForeColor
    syn keyword fvwmFunction	StickyIcons StubbornIconPlacement
    syn keyword fvwmFunction	StubbornIcons StubbornPlacement
    syn keyword fvwmFunction	SuppressIcons Title TogglePage Wait Warp
    syn keyword fvwmFunction	WindowFont WindowList WindowListSkip
    syn keyword fvwmFunction	WindowsDesk WindowShade XORvalue

    " These keywords are only used after the "Style" command.  To avoid
    " name collision with several commands, they are contained.
    syn keyword fvwmKeyword	BackColor BorderWidth BoundaryWidth contained
    syn keyword fvwmKeyword	Button CirculateHit CirculateSkip Color contained
    syn keyword fvwmKeyword	DoubleClick ForeColor Handles HandleWidth contained
    syn keyword fvwmKeyword	Icon IconTitle NoBorder NoBoundaryWidth contained
    syn keyword fvwmKeyword	NoButton NoHandles NoIcon NoIconTitle contained
    syn keyword fvwmKeyword	NoTitle Slippery StartIconic StartNormal contained
    syn keyword fvwmKeyword	StartsAnyWhere StartsOnDesk StaysOnTop contained
    syn keyword fvwmKeyword	StaysPut Sticky Title WindowListHit contained
    syn keyword fvwmKeyword	WindowListSkip contained
elseif (exists("b:fvwm_version") && b:fvwm_version == 2) || (exists("use_fvwm_2") && use_fvwm_2)
    syn match   fvwmEnvVar	"\${\w\+}"
    syn match   fvwmDef		'^\s*+\s*".\{-}"' contains=fvwmMenuString,fvwmWhitespace
    syn match   fvwmIcon	'%.\{-}%' contained
    syn match   fvwmIcon	'\*.\{-}\*' contained
    syn match   fvwmMenuString	'".\{-}"' contains=fvwmIcon,fvwmShortcutKey contained
    syn match   fvwmShortcutKey	"&." contained
    syn match   fvwmModule	"\<KillModule\s\+\w\+"he=s+10
    syn match   fvwmModule	"\<SendToModule\s\+\w\+"he=s+12
    syn match   fvwmModule	"\<DestroyModuleConfig\s\+\w\+"he=s+19

    syn keyword fvwmFunction	AddButtonStyle AddTitleStyle AddToDecor
    syn keyword fvwmFunction	AddToFunc AddToMenu AnimatedMove Beep
    syn keyword fvwmFunction	BorderStyle ButtonStyle ChangeDecor
    syn keyword fvwmFunction	ChangeMenuStyle ClickTime Close
    syn keyword fvwmFunction	ColorLimit ColormapFocus Current
    syn keyword fvwmFunction	CursorMove CursorStyle DefaultColors
    syn keyword fvwmFunction	DefaultFont Delete Desk DeskTopSize
    syn keyword fvwmFunction	Destroy DestroyDecor DestroyFunc
    syn keyword fvwmFunction	DestroyMenu DestroyMenuStyle Direction
    syn keyword fvwmFunction	Echo EdgeResistance EdgeScroll
    syn keyword fvwmFunction	EdgeThickness Emulate ExecUseShell
    syn keyword fvwmFunction	ExitFunction FlipFocus Focus Function
    syn keyword fvwmFunction	GlobalOpts GotoPage HilightColor IconFont
    syn keyword fvwmFunction	Iconify IconPath Lower Maximize Menu
    syn keyword fvwmFunction	MenuStyle ModulePath Mouse Move MoveToDesk
    syn keyword fvwmFunction	MoveToPage Next None Nop OpaqueMoveSize
    syn keyword fvwmFunction	PipeRead PixmapPath Popup Prev Quit
    syn keyword fvwmFunction	QuitScreen Raise RaiseLower Read Recapture
    syn keyword fvwmFunction	Refresh RefreshWindow Resize Restart
    syn keyword fvwmFunction	Scroll SetAnimation SetEnv SetMenuDelay
    syn keyword fvwmFunction	SetMenuStyle SnapAttraction SnapGrid
    syn keyword fvwmFunction	Stick Style Title TitleStyle UpdateDecor
    syn keyword fvwmFunction	Wait WarpToWindow WindowFont WindowId
    syn keyword fvwmFunction	WindowList WindowsDesk WindowShade
    syn keyword fvwmFunction	XORvalue

    syn keyword fvwmKeyword	Active ActiveDown ActiveFore
    syn keyword fvwmKeyword	ActiveForeOff ActivePlacement
    syn keyword fvwmKeyword	ActivePlacementHonorsStartsOnPage
    syn keyword fvwmKeyword	ActivePlacementIgnoresStartsOnPage
    syn keyword fvwmKeyword	ActiveUp All Alphabetic Animation
    syn keyword fvwmKeyword	AnimationOff BackColor Background
    syn keyword fvwmKeyword	BGradient BorderWidth Bottom
    syn keyword fvwmKeyword	Button CaptureHonorsStartsOnPage
    syn keyword fvwmKeyword	CaptureIgnoresStartsOnPage Centered
    syn keyword fvwmKeyword	CirculateHit CirculateHitIcon
    syn keyword fvwmKeyword	CirculateSkip CirculateSkipIcon Clear
    syn keyword fvwmKeyword	ClickToFocus ClickToFocusDoesntPassClick
    syn keyword fvwmKeyword	ClickToFocusDoesntRaise
    syn keyword fvwmKeyword	ClickToFocusPassesClick ClickToFocusRaises
    syn keyword fvwmKeyword	Color CurrentDesk CurrentPage
    syn keyword fvwmKeyword	CurrentPageAnyDesk DecorateTransient
    syn keyword fvwmKeyword	Default DGradient DoubleClickTime Down
    syn keyword fvwmKeyword	DumbPlacement East Flat FocusFollowsMouse
    syn keyword fvwmKeyword	FollowsFocus FollowsMouse Font ForeColor
    syn keyword fvwmKeyword	Foreground FVWM FvwmBorder FvwmButtons
    syn keyword fvwmKeyword	Greyed Handles HandleWidth Height
    syn keyword fvwmKeyword	HGradient HiddenHandles Hilight3DOff
    syn keyword fvwmKeyword	Hilight3DThick Hilight3DThin HilightBack
    syn keyword fvwmKeyword	HilightBackOff HintOverride Icon IconBox
    syn keyword fvwmKeyword	IconFill IconGrid Iconic Icons IconTitle
    syn keyword fvwmKeyword	Inactive Interior Item Left LeftJustified
    syn keyword fvwmKeyword	Lenience Maximized MenuFace MiniIcon
    syn keyword fvwmKeyword	MouseFocus MouseFocusClickDoesntRaise
    syn keyword fvwmKeyword	MouseFocusClickRaises MWM MWMBorder
    syn keyword fvwmKeyword	MWMButtons MWMDecor MWMDecorMax
    syn keyword fvwmKeyword	MWMDecorMenu MWMDecorMin MWMFunctions
    syn keyword fvwmKeyword	NakedTransient NoButton NoDecorHint
    syn keyword fvwmKeyword	NoDeskSort NoFuncHint NoGeometry
    syn keyword fvwmKeyword	NoHandles NoIcon NoIcons NoIconTitle
    syn keyword fvwmKeyword	NoInset NoLenience NoNormal NoOLDecor
    syn keyword fvwmKeyword	NoOnTop NoOverride NoPPosition
    syn keyword fvwmKeyword	Normal North Northeast Northwest
    syn keyword fvwmKeyword	NoSticky NoStipledTitles NotAlphabetic
    syn keyword fvwmKeyword	NoTitle NoWarp OLDecor Once OnlyIcons
    syn keyword fvwmKeyword	OnlyNormal OnlyOnTop OnlySticky
    syn keyword fvwmKeyword	OnTop Pixmap PopupDelay PopupDelayed
    syn keyword fvwmKeyword	PopupImmediately PopupOffset Quiet
    syn keyword fvwmKeyword	Raised RecaptureHonorsStartsOnPage
    syn keyword fvwmKeyword	RecaptureIgnoresStartsOnPage Rectangle
    syn keyword fvwmKeyword	Reset Right RightJustified Root
    syn keyword fvwmKeyword	SameType SelectInPlace SelectWarp
    syn keyword fvwmKeyword	SeparatorsLong SeparatorsShort ShowMapping
    syn keyword fvwmKeyword	SideColor SidePic Simple SkipMapping
    syn keyword fvwmKeyword	Slippery SlipperyIcon SloppyFocus
    syn keyword fvwmKeyword	SmartPlacement SmartPlacementIsNormal
    syn keyword fvwmKeyword	SmartPlacementIsReallySmart Solid
    syn keyword fvwmKeyword	South Southeast Southwest StartIconic
    syn keyword fvwmKeyword	StartNormal StartsAnyWhere StartsOnDesk
    syn keyword fvwmKeyword	StartsOnPage StaysOnTop StaysPut
    syn keyword fvwmKeyword	Sticky StickyIcon StipledTitles Sunk
    syn keyword fvwmKeyword	TiledPixmap Title TitleUnderlines0
    syn keyword fvwmKeyword	TitleUnderlines1 TitleUnderlines2
    syn keyword fvwmKeyword	TitleWarp TitleWarpOff Top Transient
    syn keyword fvwmKeyword	TrianglesRelief TrianglesSolid Up
    syn keyword fvwmKeyword	UseBorderStyle UseDecor UseIconName
    syn keyword fvwmKeyword	UsePPosition UseStyle UseTitleStyle
    syn keyword fvwmKeyword	Vector VGradient Warp WarpTitle West
    syn keyword fvwmKeyword	WIN WindowListHit WindowListSkip Windows
endif

if version >= 508 || !exists("did_fvwm_syntax_inits")
    if version < 508
	let did_fvwm_syntax_inits = 1
	command -nargs=+ HiLink hi link <args>
    else
	command -nargs=+ HiLink hi def link <args>
    endif

    HiLink fvwmComment		Comment
    HiLink fvwmEnvVar		Macro
    HiLink fvwmExec		Function
    HiLink fvwmFunction		Function
    HiLink fvwmIcon		Comment
    HiLink fvwmKey		Function
    HiLink fvwmKeyword		Keyword
    HiLink fvwmMenuString	String
    HiLink fvwmModConf		Macro
    HiLink fvwmModule		Function
    HiLink fvwmRGBValue		Type
    HiLink fvwmShortcutKey	SpecialChar
    HiLink fvwmString		String

    if exists("rgb_file")
	HiLink fvwmColors	Type
    endif

    delcommand HiLink
endif

let b:current_syntax = "fvwm"
" vim: sts=4 sw=4 ts=8
