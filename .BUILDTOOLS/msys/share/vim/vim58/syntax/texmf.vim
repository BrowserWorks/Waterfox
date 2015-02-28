" Vim syntax file
" Language: Web2C TeX texmf.cnf configuration file
" Maintainer: David Ne\v{c}as (Yeti) <yeti@physics.muni.cz>
" Last Change: 2001-04-26
" URI: http://physics.muni.cz/~yeti/download/texmf.vim
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
" Comments {{{
syn match texmfComment "%..\+$" contains=texmfTodo
syn match texmfComment "%\s*$" contains=texmfTodo
syn keyword texmfTodo TODO FIXME contained
" }}}
" Constants and parameters {{{
syn match texmfPassedParameter "[-+]\=%\w\W"
syn match texmfPassedParameter "[-+]\=%\w$"
syn match texmfNumber "\<\d\+\>"
syn match texmfVariable "\$\(\w\k*\|{\w\k*}\)"
syn match texmfSpecial +\\"\|\\$+
syn region texmfString start=+"+ end=+"+ skip=+\\"\\\\+ contains=texmfVariable,texmfSpecial,texmfPassedParameter
" }}}
" Assignments {{{
syn match texmfLHSStart "^\s*\w\k*" nextgroup=texmfLHSDot,texmfEquals
syn match texmfLHSVariable "\w\k*" contained nextgroup=texmfLHSDot,texmfEquals
syn match texmfLHSDot "\." contained nextgroup=texmfLHSVariable
syn match texmfEquals "\s*=" contained
" }}}
" Specialities {{{
syn match texmfComma "," contained
syn match texmfColons ":\|;"
syn match texmfDoubleExclam "!!" contained
" }}}
" Catch errors caused by wrong parenthesization {{{
syn region texmfBrace matchgroup=texmfBraceBrace start="{" end="}" contains=ALLBUT,texmfTodo,texmfBraceError,texmfLHSVariable,texmfLHSDot transparent
syn match texmfBraceError "}"
" }}}
" Define the default highlighting {{{
" For version 5.7 and earlier: Only when not done already
" For version 5.8 and later: Only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_texmf_syntax_inits")
  if version < 508
    let did_texmf_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink texmfComment         Comment
  HiLink texmfTodo            Todo

  HiLink texmfPassedParameter texmfVariable
  HiLink texmfVariable        Identifier

  HiLink texmfNumber          Number
  HiLink texmfString          String

  HiLink texmfLHSStart        texmfLHS
  HiLink texmfLHSVariable     texmfLHS
  HiLink texmfLHSDot          texmfLHS
  HiLink texmfLHS             Type

  HiLink texmfEquals          Normal

  HiLink texmfBraceBrace      texmfDelimiter
  HiLink texmfComma           texmfDelimiter
  HiLink texmfColons          texmfDelimiter
  HiLink texmfDelimiter       Preproc

  HiLink texmfDoubleExclam    Statement
  HiLink texmfSpecial         Special

  HiLink texmfBraceError      texmfError
  HiLink texmfError           Error

  delcommand HiLink
endif
" }}}
let b:current_syntax = "texmf"
