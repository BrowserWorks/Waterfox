" Vim syntax file
" Language:	Elm Filter rules
" Maintainer:	Dr. Charles E. Campbell, Jr. <Charles.E.Campbell.1@gsfc.nasa.gov>
" Last Change:	November 11, 1998

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn keyword	elmfiltAction	delete execute executec forward forwardc leave save savecopy
syn match	elmfiltArg	"[^\\]%[&0-9]"lc=1	contained
syn keyword	elmfiltCond	lines always subject sender from to lines received
syn region	elmfiltMatch	start="/" skip="\\/" end="/"
syn match	elmfiltNumber	"\d\+"
syn keyword	elmfiltOper	and not matches
syn match	elmfiltOper	"\~"
syn match	elmfiltOper	"<=\|>=\|!=\|<\|<\|=\|(\|)"
syn keyword	elmfiltRule	if then
syn region	elmfiltString	start='"' skip='"\(\\\\\)*\\"' end='"'	contains=elmfiltArg
syn match	elmfiltComment	"^#.*$"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_elmfilt_syntax_inits")
  if version < 508
    let did_elmfilt_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink elmfiltAction	Statement
  HiLink elmfiltArg	Special
  HiLink elmfiltComment	Comment
  HiLink elmfiltCond	Type
  HiLink elmfiltMatch	Special
  HiLink elmfiltNumber	Number
  HiLink elmfiltOper	Operator
  HiLink elmfiltRule	Statement
  HiLink elmfiltString	String

  delcommand HiLink
endif

let b:current_syntax = "elmfilt"
" vim: ts=9
