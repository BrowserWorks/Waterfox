" Vim syntax file
" Language:	Cascading Style Sheets
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" URL:		http://www.fleiner.com/vim/syntax/css.vim
" Last Change:	2001 Apr 26

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'css'
endif

syn case ignore


syn keyword cssTagName address applet area a base basefont
syn keyword cssTagName big blockquote body br b caption center
syn keyword cssTagName cite code dd dfn dir div dl dt em font
syn keyword cssTagName form h1 h2 h3 h4 h5 h6 head hr html img
syn keyword cssTagName input isindex i kbd link li link map menu
syn keyword cssTagName meta ol option param pre p samp
syn keyword cssTagName select small span strike strong style sub sup
syn keyword cssTagName table td textarea th title tr tt ul u var

syn match cssIdentifier "#[a-zA-Z][a-zA-Z0-9-]*"

syn match cssLength contained "[-+]\=\d\+\(\.\d*\)\=\(%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\)\="
syn keyword cssColor contained aqua black blue fuchsia gray green lime maroon navy olive purple red silver teal yellow
syn match cssColor contained "white"
syn match cssColor contained "\(#[0-9A-Fa-f]\{3\}\>\|#[0-9A-Fa-f]\{6\}\>\|rgb\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)\)"
syn match cssURL contained "\<url\s*([^)]*)"ms=s+4,me=e-1

syn match cssImportant contained "!\s*important\>"

syn match cssFontProperties contained "\<font\>\(-\(family\|style\|variant\|weight\|size\)\)\="
syn keyword cssFontProperties contained xyz
syn keyword cssFontAttr contained cursive fantasy monospace normal italic oblique
syn keyword cssFontAttr contained bold bolder lighter medium larger smaller
syn match cssFontAttr contained "\<\(sans\>-\)\=\<serif\>"
syn match cssFontAttr contained "\<small-caps\>"
syn match cssFontAttr contained "\<\(x\{1,2\}-\)\=\(\<small\>\|\<large\>\)\>"

syn match cssColorProperties contained "\<color\>"
syn match cssColorProperties contained "\<background\>\(-\(color\|image\|repeat\|attachment\|position\)\>\)\="
syn keyword cssColorAttr contained transparent none top center bottom left right scroll fixed
syn match cssColorAttr contained "\<\(repeat\|repeat-x\|repeat-y\|no-repeat\)\>"


syn match cssTextProperties contained "\<\(word-spacing\|letter-spacing\|text-decoration\|vertical-align\|text-transform\|text-align\|text-indent\|line-height\)\>"
syn keyword cssTextAttr contained normal none underline overline blink sub super middle
syn keyword cssTextAttr contained capitalize uppercase lowercase none left right center justify
syn match cssTextAttr contained "\<line-through\>"
syn match cssTextAttr contained "\<\(text-\)\=\<\(top\|bottom\)\>"

syn match cssBoxProperties contained "\<margin\>\(-\(top\|right\|bottom\|left\)\>\)\="
syn match cssBoxProperties contained "\<padding\>\(-\(top\|right\|bottom\|left\)\>\)\="
syn match cssBoxProperties contained "\<border\>\(-\(top\|right\|bottom\|left\)\>\)\=\(-width\>\)\="
syn match cssBoxProperties contained "\<border-color\>"
syn match cssBoxProperties contained "\<border-style\>"
syn keyword cssBoxProperties contained width height float clear
syn keyword cssBoxAttr contained auto thin medium thick left right none both
syn keyword cssBoxAttr contained none dotted dashed solid double groove ridge inset outset

syn keyword cssClassificationProperties contained display
syn match cssClassificationProperties contained "\<white-space\>"
syn match cssClassificationProperties contained "\<list-\(item\|style\(-\(type\|image\|position\)\)\=\)\>"
syn keyword cssClassificationAttr contained block inline none normal pre nowrap
syn keyword cssClassificationAttr contained disc circle square decimal none
syn match cssClassificationAttr contained "\<list-item\>"
syn match cssClassificationAttr contained "\<\(lower\|upper\)-\(roman\|alpha\)\>"

syn region cssInclude start="@import" start="@include" end=";" contains=cssComment,cssURL
syn match cssBraces contained "[{}]"
syn match cssError contained "{@<>"
syn region cssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=css.*Attr,css.*Properties,cssComment,cssLength,cssColor,cssURL,cssImportant,cssError,cssString

syn match cssPseudoClass transparent ":\S*" contains=cssPseudoClassId
syn keyword cssPseudoClassId contained link visited active hover
syn match cssPseudoClassId contained "\<first-\(line\|letter\)\>"

syn region cssComment start="/\*" end="\*/"
syn match cssComment "//.*$"

syn region cssString start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region cssString start=+'+ skip=+\\\\\|\\'+ end=+'+

if main_syntax == "css"
  syn sync minlines=10
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_css_syn_inits")
  if version < 508
    let did_css_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cssComment Comment
  HiLink cssTagName Statement
  HiLink cssFontProperties StorageClass
  HiLink cssColorProperties StorageClass
  HiLink cssTextProperties StorageClass
  HiLink cssBoxProperties StorageClass
  HiLink cssClassificationProperties StorageClass
  HiLink cssFontAttr Type
  HiLink cssColorAttr Type
  HiLink cssTextAttr Type
  HiLink cssBoxAttr Type
  HiLink cssClassificationAttr Type
  HiLink cssPseudoClassId PreProc
  HiLink cssLength Number
  HiLink cssColor Constant
  HiLink cssURL String
  HiLink cssIdentifier Function
  HiLink cssInclude Include
  HiLink cssImportant Special
  HiLink cssBraces Function
  HiLink cssError Error
  HiLink cssInclude Include
  HiLink cssString String
  delcommand HiLink
endif

let b:current_syntax = "css"

if main_syntax == 'css'
  unlet main_syntax
endif

" vim: ts=8
