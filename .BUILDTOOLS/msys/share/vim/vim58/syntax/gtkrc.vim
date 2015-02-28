" Vim syntax file
" Language: Gtk+ theme files `gtkrc'
" Maintainer: David Ne\v{c}as (Yeti), <yeti@physics.muni.cz>
" Last Change: 2001-05-13
" URI: http://physics.muni.cz/~yeti/download/gtkrc.vim

" Notes: Highlights [some] Gnome classes too.

" TODO: add `display' where appropriate

" Setup {{{
" React to possibly already-defined syntax.
" For version 5.x: Clear all syntax items unconditionally
" For version 6.x: Quit when a syntax file was already loaded
if version >= 600
  if exists("b:current_syntax")
    finish
  endif
else
  syntax clear
endif

syn case match
" }}}
" Base constructs {{{
syn match gtkrcComment "#.*$" contains=gtkrcFixme
syn keyword gtkrcFixme FIXME TODO XXX NOT contained
syn region gtkrcACString start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=gtkrcWPathSpecial,gtkrcClassName,gtkrcClassNameGnome contained
syn region gtkrcBString start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=gtkrcKeyMod contained
syn region gtkrcString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=gtkrcPathSpecial,gtkrcRGBColor
"syn region gtkrcString start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline contains=gtkrcPathSpecial,gtkrcRGBColor
syn match gtkrcPathSpecial "<parent>" contained
syn match gtkrcWPathSpecial "[*?.]" contained
"syn match gtkrcNumber "\(^\|\W\)\@<=\(\d\+\)\=\.\=\d\+"
"make it work with Vim 5:
syn match gtkrcNumber "^\(\d\+\)\=\.\=\d\+"
syn match gtkrcNumber "\W\(\d\+\)\=\.\=\d\+"lc=1
syn match gtkrcRGBColor "#\(\x\{12}\|\x\{9}\|\x\{6}\|\x\{3}\)" contained
syn cluster gtkrcPRIVATE add=gtkrcFixme,gtkrcPathSpecial,gtkrcWPathSpecial,gtkrcRGBColor,gtkrcACString
" }}}
" Keywords {{{
syn keyword gtkrcInclude include
syn keyword gtkrcPathSet module_path pixmap_path
syn keyword gtkrcTop binding style
syn keyword gtkrcTop widget widget_class nextgroup=gtkrcACString skipwhite
syn keyword gtkrcTop class nextgroup=gtkrcACString skipwhite
syn keyword gtkrcBind bind nextgroup=gtkrcBString skipwhite
syn keyword gtkrcStateName = NORMAL INSENSITIVE PRELIGHT ACTIVE SELECTED
syn keyword gtkrcPriorityName = HIGHEST RC APPLICATION GTK LOWEST
syn keyword gtkrcStyleKeyword fg bg fg_pixmap bg_pixmap bg_text base font fontset text
syn match gtkrcKeyMod "<\(alt\|ctrl\|control\|mod[1-5]\|release\|shft\|shift\)>" contained
syn cluster gtkrcPRIVATE add=gtkrcKeyMod
" }}}
" Enums and engine words {{{
" FIXME: many other words could appear here, does it make sense to include
" really all?
syn keyword gtkrcKeyword engine image
syn keyword gtkrcImage arrow_direction border detail file gap_border gap_end_border gap_end_file gap_file gap_side gap_side gap_start_border gap_start_file orientation overlay_border overlay_file overlay_stretch recolorable shadow state stretch thickness
syn keyword gtkrcConstant TRUE FALSE NONE IN OUT LEFT RIGHT TOP BOTTOM UP DOWN VERTICAL HORIZONTAL ETCHED_IN ETCHED_OUT
syn keyword gtkrcFunction function nextgroup=gtkrcFunctionEq skipwhite
syn match gtkrcFunctionEq "=" nextgroup=gtkrcFunctionName contained skipwhite
syn keyword gtkrcFunctionName ARROW BOX BOX_GAP CHECK CROSS DIAMOND EXTENSION FLAT_BOX FOCUS HANDLE HLINE OPTION OVAL POLYGON RAMP SHADOW SHADOW_GAP SLIDER STRING TAB VLINE contained
syn cluster gtkrcPRIVATE add=gtkrcFunctionName,gtkrcFunctionEq
" }}}
" Class names {{{
" (last synced with Gtk+ 1.2.10 and Gnome 1.4)
syn keyword gtkrcClassName GtkObject GtkWidget GtkMisc GtkLabel GtkAccelLabel GtkTipsQuery GtkArrow GtkImage GtkPixmap GtkContainer GtkBin GtkAlignment GtkFrame GtkAspectFrame GtkButton GtkToggleButton GtkCheckButton GtkRadioButton GtkOptionMenu GtkItem GtkMenuItem GtkCheckMenuItem GtkRadioMenuItem GtkTearoffMenuItem GtkListItem GtkTreeItem GtkWindow GtkColorSelectionDialog GtkDialog GtkInputDialog GtkFileSelection GtkFontSelectionDialog GtkPlug GtkEventBox GtkHandleBox GtkScrolledWindow GtkViewport GtkBox GtkButtonBox GtkHButtonBox GtkVButtonBox GtkVBox GtkColorSelection GtkGammaCurve GtkHBox GtkCombo GtkStatusbar GtkCList GtkCTree GtkFixed GtkNotebook GtkFontSelection GtkPaned GtkHPaned GtkVPaned GtkLayout GtkList GtkMenuShell GtkMenu GtkMenuBar GtkPacker GtkSocket GtkTable GtkToolbar GtkTree GtkCalendar GtkDrawingArea GtkCurve GtkEditable GtkEntry GtkSpinButton GtkText GtkRuler GtkHRuler GtkVRuler GtkRange GtkScale GtkHScale GtkVScale GtkScrollbar GtkHScrollbar GtkVScrollbar GtkSeparator GtkHSeparator GtkVSeparator GtkInvisible GtkPreview GtkProgress GtkProgressBar GtkData GtkAdjustment GtkTooltips GtkItemFactory contained
syn keyword gtkrcClassNameGnome GnomeAbout GnomeAnimator GnomeApp GnomeAppBar GnomeCalculator GnomeCanvas GnomeCanvasEllipse GnomeCanvasGroup GnomeCanvasImage GnomeCanvasItem GnomeCanvasLine GnomeCanvasPolygon GnomeCanvasRE GnomeCanvasRect GnomeCanvasText GnomeCanvasWidget GnomeClient GnomeColorPicker GnomeDEntryEdit GnomeDateEdit GnomeDialog GnomeDock GnomeDockBand GnomeDockItem GnomeDockLayout GnomeDruid GnomeDruidPage GnomeDruidPageFinish GnomeDruidPageStandard GnomeDruidPageStart GnomeEntry GnomeFileEntry GnomeFontPicker GnomeFontSelector GnomeHRef GnomeIconEntry GnomeIconList GnomeIconSelection GnomeIconTextItem GnomeLess GnomeMDI GnomeMDIChild GnomeMDIGenericChild GnomeMessageBox GnomeNumberEntry GnomePaperSelector GnomePixmap GnomePixmapEntry GnomeProcBar GnomePropertyBox GnomeScores GnomeSpell GnomeStock GtkClock GtkDial GtkPixmapMenuItem GtkTed contained
syn cluster gtkrcPRIVATE add=gtkrcClassName,gtkrcClassNameGnome
" }}}
" Catch errors caused by wrong parenthesization {{{
" For parentheses
syn region gtkrcParen start='(' end=')' transparent contains=ALLBUT,gtkrcParenError,@gtkrcPRIVATE
syn match gtkrcParenError ")"
" Idem for curly braces
syn region gtkrcBrace start='{' end='}' transparent contains=ALLBUT,gtkrcBraceError,@gtkrcPRIVATE
syn match gtkrcBraceError "}"
" Idem for brackets
syn region gtkrcBracket start='\[' end=']' transparent contains=ALLBUT,gtkrcBracketError,@gtkrcPRIVATE
syn match gtkrcBracketError "]"
" }}}
" Synchronization {{{
syn sync minlines=50
syn sync match gtkrcSyncClass groupthere NONE "^\s*class\>"
" }}}
" Define the default highlighting {{{
" For version 5.7 and earlier: Only when not done already
" For version 5.8 and later: Only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_gtkrc_syntax_inits")
  if version < 508
    let did_gtkrc_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink gtkrcComment        Comment
  HiLink gtkrcFixme          Todo

  HiLink gtkrcInclude        Preproc

  HiLink gtkrcACString       gtkrcString
  HiLink gtkrcBString        gtkrcString
  HiLink gtkrcString         String
  HiLink gtkrcNumber         Number
  HiLink gtkrcStateName      gtkrcConstant
  HiLink gtkrcPriorityName   gtkrcConstant
  HiLink gtkrcConstant       Constant

  HiLink gtkrcPathSpecial    gtkrcSpecial
  HiLink gtkrcWPathSpecial   gtkrcSpecial
  HiLink gtkrcRGBColor       gtkrcSpecial
  HiLink gtkrcKeyMod         gtkrcSpecial
  HiLink gtkrcSpecial        Special

  HiLink gtkrcTop            gtkrcKeyword
  HiLink gtkrcPathSet        gtkrcKeyword
  HiLink gtkrcStyleKeyword   gtkrcKeyword
  HiLink gtkrcFunction       gtkrcKeyword
  HiLink gtkrcBind           gtkrcKeyword
  HiLink gtkrcKeyword        Keyword

  HiLink gtkrcClassNameGnome gtkrcGtkClass
  HiLink gtkrcClassName      gtkrcGtkClass
  HiLink gtkrcFunctionName   gtkrcGtkClass
  HiLink gtkrcGtkClass       Type

  HiLink gtkrcImage          gtkrcOtherword
  HiLink gtkrcOtherword      Function

  HiLink gtkrcParenError     gtkrcError
  HiLink gtkrcBraceError     gtkrcError
  HiLink gtkrcBracketError   gtkrcError
  HiLink gtkrcError          Error
endif
" }}}
let b:current_syntax = "gtkrc"
