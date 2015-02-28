" Vim syntax file
" Language:	Man page
" Maintainer:	Nam SungHyun <namsh@kldp.org>
" Previous Maintainer:	Gautam H. Mudunuri <gmudunur@informatica.com>
" Last Change:	2001 Apr 26
" Version Info:

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Get the CTRL-H syntax to handle backspaced text
if version >= 600
  runtime! syntax/ctrlh.vim
else
  source <sfile>:p:h/ctrlh.vim
endif

syn case ignore
syn match  manReference       "\f\+([1-9][a-z]\=)"
syn match  manTitle           "^\f\+([0-9]\+[a-z]\=).*"
syn match  manSectionHeading  "^[a-z][a-z ]*[a-z]$"
syn match  manOptionDesc      "^\s*[+-][a-z0-9]\S*"
" syn match  manHistory         "^[a-z].*last change.*$"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_man_syn_inits")
  if version < 508
    let did_man_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink manTitle           Title
  HiLink manSectionHeading  Statement
  HiLink manOptionDesc      Constant
  " HiLink manHistory       Comment
  HiLink manReference       PreProc

  delcommand HiLink
endif

let b:current_syntax = "man"

" vim:ts=8 sts=2 sw=2:
