" Vim syntax file
" Language:	Windows Scripting Host
" Maintainer:	Paul Moore <gustav@morpheus.demon.co.uk>
" Last Change:	16 Oct 2000

" This reuses the XML, VB and JavaScript syntax files. While VB is not
" VBScript, it's close enough for us. No attempt is made to handle
" other languages.
" Send comments, suggestions and requests to the maintainer.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version < 600
  source <sfile>:p:h/xml.vim
else
  runtime! syntax/xml.vim
endif
unlet b:current_syntax

syn case ignore

if version < 600
  syn include @wshVBScript <sfile>:p:h/vb.vim
  syn include @wshJavaScript <sfile>:p:h/javascript.vim
else
  syn include @wshVBScript syntax/vb.vim
  unlet b:current_syntax
  syn include @wshJavaScript syntax/javascript.vim
endif

syn region wshVBScript matchgroup=xmlTag start="<script[^>]*VBScript\(>\|[^>]*[^/>]>\)" end="</script>" contains=@wshVBScript
syn region wshJavaScript matchgroup=xmlTag start="<script[^>]*J\(ava\)\=Script\(>\|[^>]*[^/>]>\)" end="</script>" contains=@wshJavaScript

let b:current_syntax = "wsh"
