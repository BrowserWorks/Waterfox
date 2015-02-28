" Vim syntax file
" Language:	crontab
" Maintainer:	John Hoelzel johnh51@bigfoot.com
" Last Change:	2001 May 10
" Filenames:    Linux: */crontab.*
" URL:		http://bigfoot.com/~johnh51/vim/syntax/crontab.vim
"
" line format:
" Minutes   Hours   Days   Months   Days_of_Week   Commands # comments

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn sync lines=2

" times
syn match crontabStatement	"^\s\{}\S\{1,}\s\{1,}\S\{1,}\s\{1,}\S\{1,}\s\{1,}\S\{1,}\s\{1,}\S\{1,}\s"

" comments
syn region crontabComment	start="#" end="$"


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_crontab_syntax_inits")
  if version < 508
    let did_crontab_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink crontabStatement	Statement
  HiLink crontabComment		Comment

  delcommand HiLink
endif

let b:current_syntax = "crontab"

" vim: ts=8
