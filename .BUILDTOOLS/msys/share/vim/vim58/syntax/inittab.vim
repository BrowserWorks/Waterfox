" Vim syntax file
" Language: SysV-compatible init process control file `inittab'
" Maintainer: David Ne\v{c}as (Yeti), <yeti@physics.muni.cz>
" Last Change: 2001-05-13
" URI: http://physics.muni.cz/~yeti/download/inittab.vim

" Notes: In fact this file is made to work with Linux's init v2.78, which is
"        compatible, but...
"        The inittab file format is quite strict, so we highlight everything
"        not recognized as an error---please report problems.

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
syn match inittabError "[^:]\+:"me=e-1 contained
syn match inittabError "[^:]\+$" contained
" On AIX, `:' at a begin of line acts a comment char (braindead)
syn match inittabComment "^[#:].*$" contains=inittabFixme
syn match inittabComment "#.*$" contained contains=inittabFixme
syn keyword inittabFixme FIXME TODO XXX NOT
" }}}
" Shell {{{
syn region inittabShString start=+"+ end=+"+ skip=+\\\\\|\\\"+ contained
syn region inittabShString start=+'+ end=+'+ contained
syn match inittabShOption "\s[-+][[:alnum:]]\+"ms=s+1 contained
syn match inittabShOption "\s--[:alnum:][-[:alnum:]]*"ms=s+1 contained
syn match inittabShCommand "/\S\+" contained
syn cluster inittabSh add=inittabShOption,inittabShString,inittabShCommand
" }}}
" Keywords {{{
syn keyword inittabActionName respawn wait once boot bottwait off ondemand sysinit powerwait powerfail powerokwait powerfailnow ctrlaltdel kbrequest initdefault contained
" }}}
" Line parser {{{
syn match inittabId "^[[:alnum:]~]\{1,4}" nextgroup=inittabColonRunLevels,inittabError
syn match inittabColonRunLevels ":" contained nextgroup=inittabRunLevels,inittabColonAction,inittabError
syn match inittabRunLevels "[0-6A-Ca-cSs]\+" contained nextgroup=inittabColonAction,inittabError
syn match inittabColonAction ":" contained nextgroup=inittabAction,inittabError
syn match inittabAction "\w\+" contained nextgroup=inittabColonProcess,inittabError contains=inittabActionName
syn match inittabColonProcess ":" contained nextgroup=inittabProcessPlus,inittabProcess,inittabError
syn match inittabProcessPlus "+" contained nextgroup=inittabProcess,inittabError
syn region inittabProcess start="/" end="$" transparent oneline contained contains=@inittabSh,inittabComment
" }}}
" Define the default highlighting {{{
" For version 5.7 and earlier: Only when not done already
" For version 5.8 and later: Only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_apache_syntax_inits")
  if version < 508
    let did_apache_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink inittabComment        Comment
  HiLink inittabFixme          Todo
  HiLink inittabActionName     Type
  HiLink inittabError          Error
  HiLink inittabId             Identifier
  HiLink inittabRunLevels      Special

  HiLink inittabColonProcess   inittabColon
  HiLink inittabColonAction    inittabColon
  HiLink inittabColonRunLevels inittabColon
  HiLink inittabColon          PreProc

  HiLink inittabShString       String
  HiLink inittabShOption       Special
  HiLink inittabShCommand      Statement

  delcommand HiLink
endif
" }}}
let b:current_syntax = "inittab"
