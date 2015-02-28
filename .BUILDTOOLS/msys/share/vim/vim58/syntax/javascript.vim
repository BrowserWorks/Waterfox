" Vim syntax file
" Language:	JavaScript
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/javascript.vim
" Last Change:	2001 Apr 26

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'javascript'
endif

syn case ignore


syn match   javaScriptLineComment      "\/\/.*$"
syn match   javaScriptCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  javaScriptCommentString    start=+"+  skip=+\\\\\|\\"+  end=+"+ end=+\*/+me=s-1,he=s-1 contains=javaScriptSpecial,javaScriptCommentSkip,@htmlPreproc
syn region  javaScriptComment2String   start=+"+  skip=+\\\\\|\\"+  end=+$\|"+  contains=javaScriptSpecial,@htmlPreproc
syn region  javaScriptComment          start="/\*"  end="\*/" contains=javaScriptCommentString,javaScriptCharacter,javaScriptNumber
syn match   javaScriptSpecial          "\\\d\d\d\|\\."
syn region  javaScriptStringD          start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=javaScriptSpecial,@htmlPreproc
syn region  javaScriptStringS          start=+'+  skip=+\\\\\|\\'+  end=+'+  contains=javaScriptSpecial,@htmlPreproc
syn match   javaScriptSpecialCharacter "'\\.'"
syn match   javaScriptNumber           "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn keyword javaScriptConditional      if else
syn keyword javaScriptRepeat           while for
syn keyword javaScriptBranch           break continue
syn keyword javaScriptOperator         new in
syn keyword javaScriptType             this var
syn keyword javaScriptStatement        return with
syn keyword javaScriptFunction         function
syn keyword javaScriptBoolean          true false
syn match   javaScriptBraces           "[{}]"

" catch errors caused by wrong parenthesis
syn match   javaScriptInParen     contained "[{}]"
syn region  javaScriptParen       transparent start="(" end=")" contains=javaScriptParen,javaScript.*
syn match   javaScrParenError  ")"

if main_syntax == "javascript"
  syn sync ccomment javaScriptComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink javaScriptComment           Comment
  HiLink javaScriptLineComment       Comment
  HiLink javaScriptSpecial           Special
  HiLink javaScriptStringS           String
  HiLink javaScriptStringD           String
  HiLink javaScriptCharacter         Character
  HiLink javaScriptSpecialCharacter  javaScriptSpecial
  HiLink javaScriptNumber            javaScriptValue
  HiLink javaScriptConditional       Conditional
  HiLink javaScriptRepeat            Repeat
  HiLink javaScriptBranch            Conditional
  HiLink javaScriptOperator          Operator
  HiLink javaScriptType              Type
  HiLink javaScriptStatement         Statement
  HiLink javaScriptFunction          Function
  HiLink javaScriptBraces            Function
  HiLink javaScriptError             Error
  HiLink javaScrParenError           javaScriptError
  HiLink javaScriptInParen           javaScriptError
  HiLink javaScriptBoolean           Boolean
  delcommand HiLink
endif

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

" vim: ts=8
