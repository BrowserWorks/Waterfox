" Vim syntax file
" Language:	Slrn score file
" Maintainer:	Preben "Peppe" Guldberg (c928400@student.dtu.dk)
" Last Change:	Thu Apr  2 14:02:43 1998

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match slrnscComment		"%.*$"
syn match slrnscSectionCom	".].*"lc=2

" characters in newsgroup names
if version < 600
  set isk=@,48-57,.,-,_,+
else
  setlocal isk=@,48-57,.,-,_,+
endif

syn match slrnscGroup		contained "\(\k\|\*\)\+"
syn match slrnscNumber		contained "\d\+"
syn match slrnscDate		contained "\(\d\{1,2}[-/]\)\{2}\d\{4}"
syn match slrnscDelim		contained ":"
syn match slrnscComma		contained ","
syn match slrnscOper		contained "\~"
syn match slrnscEsc		contained "\\[ecC<>.]"
syn match slrnscEsc		contained "[?^]"
syn match slrnscEsc		contained "[^\\]$\s*$"lc=1

syn region slrnscSection	matchgroup=slrnscSectionStd start="^\s*\[" end='\]' contains=slrnscGroup,slrnscComma,slrnscSectionCom
syn region slrnscSection	matchgroup=slrnscSectionNot start="^\s*\[\~" end='\]' contains=slrnscGroup,slrnscCommas,slrnscSectionCom

syn keyword slrnscItem		contained Expires From Lines References Subject Xref

syn match slrnscItemFill	contained ".*$" skipempty nextgroup=slrnscScoreItem contains=slrnscEsc

syn match slrnscScoreItem	contained "^\s*Expires:\s*\(\d\{1,2}[-/]\)\{2}\d\{4}\s*$" skipempty nextgroup=slrnscScoreItem contains=slrnscItem,slrnscDelim,slrnscDate
syn match slrnscScoreItem	contained "^\s*\~\=Lines:\s*\d\+\s*$" skipempty nextgroup=slrnscScoreItem contains=slrnscOper,slrnscItem,slrnscDelim,slrnscNumber
syn match slrnscScoreItem	contained "^\s*\~\=\(From\|References\|Subject\|Xref\):" nextgroup=slrnscItemFill contains=slrnscOper,slrnscItem,slrnscDelim
syn match slrnscScoreItem	contained "^\s*%.*$" skipempty nextgroup=slrnscScoreItem contains=slrnscComment

syn keyword slrnscScore		contained Score
syn match slrnScoreLine		"^\s*Score::\=\s\+=\=-\=\d\+\s*$" skipempty nextgroup=slrnscScoreItem contains=slrnscScore,slrnscDelim,slrnscOper,slrnscNumber

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_slrnsc_syntax_inits")
  if version < 508
    let did_slrnsc_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink slrnscComment		Comment
  HiLink slrnscSectionCom	slrnscComment
  HiLink slrnscGroup		String
  HiLink slrnscNumber		Number
  HiLink slrnscDate		Special
  HiLink slrnscDelim		Delimiter
  HiLink slrnscComma		SpecialChar
  HiLink slrnscOper		SpecialChar
  HiLink slrnscEsc		String
  HiLink slrnscSectionStd	Type
  HiLink slrnscSectionNot	Delimiter
  HiLink slrnscItem		Statement
  HiLink slrnscScore		Keyword

  delcommand HiLink
endif

let b:current_syntax = "slrnsc"

"EOF	vim: ts=8 noet tw=200 sw=8 sts=0
