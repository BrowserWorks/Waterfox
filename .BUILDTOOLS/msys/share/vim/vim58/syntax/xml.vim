" Vim syntax file
" Language:	XML
" Maintainer:	Johannes Zellner <johannes@zellner.org>
"		Author and previous maintainer:
"		Paul Siegmann <pauls@euronet.nl>
" Filenames:	*.xml
" URL:		http://www.zellner.org/vim/syntax/xml.vim
" Last Change:	Dec 09 1999
" $Id: xml.vim,v 1.1.1.1 2001/06/07 21:35:13 corinna Exp $

" CREDITS:
" - This syntax file will highlight xml tags and arguments.
"   The original version was derived by Paul Siegmann from
"   Claudio Fleiner's html.vim.
"
" - suggestions and patches by:
"       Rafael Garcia-Suarez
"
" REFERENCES:
"   http://www.w3.org/TR/1998/REC-xml-19980210
"   http://www.w3.org/XML/1998/06/xmlspec-report-19980910.htm
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Following items are case-sensitive
" Case-insensitive rules can be specified by 'syn case ignore' later
syn case match

" mark illegal characters
syn match xmlError "[<>&]"


" tags
syn match   xmlSpecial  contained "\\\d\d\d\|\\."
syn region  xmlString   contained start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=xmlSpecial
syn region  xmlString   contained start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=xmlSpecial
syn region  xmlEndTag             start=+</+    end=+>+              contains=xmlTagError
syn region  xmlTag                start=+<[^/]+ end=+>+              contains=xmlString,xmlTagError
syn match   xmlTagError contained "[^>]<"ms=s+1

" special characters
syn match   xmlSpecialChar "&[^;]*;"

syn keyword xmlTodo         contained TODO FIXME XXX

" The real comments (this implements the comments as defined by xml,
" but not all xml pages actually conform to it. Errors are flagged.
syn region  xmlComment                start=+<!+        end=+>+ contains=xmlCommentPart,xmlString,xmlCommentError,xmlTodo
syn match   xmlCommentError contained "[^><!]"
syn region  xmlCommentPart  contained start=+--+        end=+--+

" DTD -- we use dtd.vim here
syn region  xmlDocType matchgroup=xmlDocTypeDecl start="<!DOCTYPE"he=s+2,rs=s+2 end=">" contains=xmlDocTypeKeyword,xmlInlineDTD,xmlString
syn keyword xmlDocTypeKeyword contained DOCTYPE PUBLIC SYSTEM
syn region  xmlInlineDTD contained start="\[" end="]" contains=@xmlDTD
syn include @xmlDTD <sfile>:p:h/dtd.vim

" Processing instructions
" This allows "?>" inside strings -- good idea?
syn region  xmlProcessing matchgroup=xmlProcessingDelim start="<?" end="?>" contains=xmlString

" CData sections
syn region  xmlCdata matchgroup=xmlCdataDecl start="<!\[CDATA\[" keepend end="]]>"

" synchronizing (does not always work if a comment includes legal
" xml tags, but doing it right would mean to always start
" at the first line, which is too slow)
syn sync match xmlHighlight groupthere NONE "<[/a-zA-Z]"
syn sync match xmlHighlightSkip "^.*['\"].*$"
syn sync minlines=10

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_xml_syntax_inits")
  if version < 508
    let did_xml_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink xmlTodo                      Todo
  HiLink xmlTag                       Function
  HiLink xmlEndTag                    Identifier
  HiLink xmlSpecial                   Special
  HiLink xmlSpecialChar               Special
  HiLink xmlString                    String
  HiLink xmlComment                   Comment
  HiLink xmlCommentPart               Comment
  HiLink xmlCommentError              xmlError
  HiLink xmlTagError                  xmlError
  HiLink xmlError                     Error

  HiLink xmlProcessingDelim           Comment
  HiLink xmlProcessing                Type
  HiLink xmlCdata                     Normal
  HiLink xmlCdataDecl                 String
  HiLink xmlDocType                   Normal
  HiLink xmlDocTypeDecl               Function
  HiLink xmlDocTypeKeyword            Statement
  HiLink xmlInlineDTD                 Function

  delcommand HiLink
endif

let b:current_syntax = "xml"

" vim: ts=8
