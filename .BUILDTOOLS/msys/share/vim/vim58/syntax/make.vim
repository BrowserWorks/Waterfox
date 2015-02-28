" Vim syntax file
" Language:	Makefile
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/make.vim
" Last Change:	2001 Apr 26

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" some directives
syn match makePreCondit	"^\s*\(ifeq\>\|else\>\|endif\>\|define\>\|endef\>\|ifneq\>\|ifdef\>\|ifndef\>\)"
syn match makeInclude	"^\s*include"
syn match makeStatement	"^\s*vpath"
syn match makeOverride	"^\s*override"
hi link makeOverride makeStatement

" Microsoft Makefile specials
syn case ignore
syn match makeInclude	"^!\s*include"
syn match makePreCondit "!\s*\(cmdswitches\>\|error\>\|message\>\|include\>\|if\>\|ifdef\>\|ifndef\>\|else\>\|elseif\>\|else if\>\|else\s*ifdef\>\|else\s*ifndef\>\|endif\>\|undef\>\)"
syn case match

" identifiers
syn region makeIdent	start="\$(" skip="\\)" end=")" contains=makeStatement,makeIdent
syn region makeIdent	start="\${" skip="\\}" end="}" contains=makeStatement,makeIdent
syn match makeIdent	"\$\$\w*"
syn match makeIdent	"\$[^({]"
syn match makeIdent	"^\s*\a\w*\s*[:+?!*]="me=e-2
syn match makeIdent	"^\s*\a\w*\s*="me=e-1
syn match makeIdent	"%"


" make targets
syn match makeSpecTarget	"^\.SUFFIXES"
syn match makeSpecTarget	"^\.PHONY"
syn match makeSpecTarget	"^\.DEFAULT"
syn match makeSpecTarget	"^\.PRECIOUS"
syn match makeSpecTarget	"^\.IGNORE"
syn match makeSpecTarget	"^\.SILENT"
syn match makeSpecTarget	"^\.EXPORT_ALL_VARIABLES"
syn match makeSpecTarget	"^\.KEEP_STATE"
syn match makeSpecTarget	"^\.LIBPATTERNS"
syn match makeSpecTarget	"^\.NOTPARALLEL"
syn match makeImplicit		"^\.[A-Za-z0-9_./\t -]\+\s*:[^=]"me=e-2
syn match makeImplicit		"^\.[A-Za-z0-9_./\t -]\+\s*:$"me=e-1
syn match makeTarget		"^[A-Za-z0-9_./$()%-][A-Za-z0-9_./\t $()%-]*:[^=]"me=e-2 contains=makeIdent,makeSpecTarget
syn match makeTarget		"^[A-Za-z0-9_./$()%-][A-Za-z0-9_./\t $()%-]*:$"me=e-1 contains=makeIdent,makeSpecTarget

" Statements / Functions (GNU make)
syn match makeStatement contained "(\(subst\|addprefix\|addsuffix\|basename\|call\|dir\|error\|filter\|filter-out\|findstring\|firstword\|foreach\|if\|join\|notdir\|origin\|patsubst\|shell\|sort\|strip\|suffix\|warning\|wildcard\|word\|wordlist\|words\)\>"ms=s+1

" some special characters
syn match makeSpecial	"^\s*[@-]\+"
syn match makeNextLine	"\\$"


" Errors
syn match makeError	"^ \+\t"
syn match makeError	"^ \{8\}[^ ]"me=e-1
syn region makeIgnore	start="\\$" end="^." end="^$" contains=ALLBUT,makeError

" Comment
syn region  makeComment	start="#" end="[^\\]$"
syn match   makeComment	"#$"

" match escaped quotes and any other escaped character
" except for $, as a backslash in front of a $ does
" not make it a standard character, but instead it will
" still act as the beginning of a variable
" The escaped char is not highlightet currently
syn match makeEscapedChar	"\\[^$]"


syn region  makeDString start=+"+  skip=+\\"+  end=+"+  contains=makeIdent
syn region  makeSString start=+'+  skip=+\\'+  end=+'+  contains=makeIdent
syn region  makeBString start=+`+  skip=+\\`+  end=+`+  contains=makeIdent,makeSString,makeDString,makeNextLine

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_make_syn_inits")
  if version < 508
    let did_make_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink makeNextLine	makeSpecial
  HiLink makeSpecTarget	Statement
  HiLink makeImplicit	Function
  HiLink makeTarget		Function
  HiLink makeInclude		Include
  HiLink makePreCondit	PreCondit
  HiLink makeStatement	Statement
  HiLink makeIdent		Identifier
  HiLink makeSpecial		Special
  HiLink makeComment		Comment
  HiLink makeDString		String
  HiLink makeSString		String
  HiLink makeBString		Function
  HiLink makeError		Error
  delcommand HiLink
endif

let b:current_syntax = "make"

" vim: ts=8
