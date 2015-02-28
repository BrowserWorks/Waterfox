" Vim syntax file
" Language:	SNOBOL4
" Maintainer:	Rafal Sulejman <rms@poczta.onet.pl>
" Last change:	21 Jun 2000

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax case ignore
" A bunch of useful SNOBOL keywords
syn match snobol4Label	"^[^ \t]*"
syn keyword snobol4Statement	OUTPUT TERMINAL SCREEN INPUT
syn keyword snobol4Function	ARB ARBNO POS RPOS TAB TRIM SIZE
syn keyword snobol4Function	RTAB REPLACE DUPL DATATYPE CONVERT
syn keyword snobol4Function	LEN DEFINE TRACE STOPTR CODE REM
syn keyword snobol4Function	DIFFER IDENT ARRAY TABLE
syn keyword snobol4Function	GT GE LE EQ LT NE LGT
syn keyword snobol4Function	ANY NOTANY BREAK SPAN DATE
syn keyword snobol4Function	SUBSTR OPSYN INTEGER REMDR BAL
syn keyword snobol4Todo contained	TODO
syn match snobol4Keyword		"&TRIM\|&FULLSCAN\|&MAXLNGTH\|&ANCHOR\|&ERRLIMIT\|&ERRTEXT"
syn match snobol4Keyword		"&ALPHABET\|&LCASE\|&UCASE\|&DUMP\|&TRACE"
"integer number, or floating point number without a dot.
syn match  snobol4Number		"\<\d\+\>"
"floating point number, with dot
syn match  snobol4Number		"\<\d\+\.\d*\>"
"floating point number, starting with a dot
syn match  snobol4Number		"\.\d\+\>"

" String and Character contstants
syn region  snobol4String		  start=+"+  skip=+\\\\\|\\"+  end=+"+
syn region  snobol4String		  start=+[^a-zA-Z0-9]'+  skip=+\\\\\|\\"+  end=+'+

syn match   snobol4MathsOperator   "-\|=\|[:<>+\*^/\\]\||\|"
syn match  snobol4Comment     "^\*.*$"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_snobol4_syntax_inits")
  if version < 508
    let did_snobol4_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink snobol4Label		Label
  HiLink snobol4Conditional	Conditional
  HiLink snobol4Repeat		Repeat
  HiLink snobol4Number		Number
  HiLink snobol4Error		Error
  HiLink snobol4Statement	Statement
  HiLink snobol4String		String
  HiLink snobol4Comment	Comment
  HiLink snobol4Special	Special
  HiLink snobol4Todo		Todo
  HiLink snobol4Function	Identifier
  HiLink snobol4Keyword	Keyword
  HiLink snobol4MathsOperator	Operator

  delcommand HiLink
endif

let b:current_syntax = "snobol4"
" vim: ts=8
