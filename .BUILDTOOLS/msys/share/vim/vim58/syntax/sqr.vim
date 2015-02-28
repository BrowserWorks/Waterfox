" Vim syntax file
"    Language: Structured Query Report Writer (SQR)
"  Maintainer: Jeff Lanzarotta (frizbeefanatic@yahoo.com)
"         URL: http://lanzarotta.tripod.com/vim/syntax/sqr.vim.zip
" Last Change: April 30, 2001

" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version >= 600
  setlocal iskeyword=@,48-57,_,-
else
  set iskeyword=@,48-57,_,-
endif

syn case ignore

" The STP reserved words, defined as keywords.
syn region	sqrIncluded	contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	  sqrIncluded	contained "<[^>]*>"
syn match	  sqrInclude	"^\s*#\s*include\>\s*["<]" contains=sqrIncluded

syn keyword	sqrDefine	#define #else #end-if #if #ifdef #ifndef

syn keyword	sqrOperator	not and or desc group having in any some all between exists
syn keyword	sqrOperator	like from order to union intersect minus distinct use xor as

syn keyword	sqrStatement	array-add array-divide array-multiply array-subtract ask begin-document
syn keyword	sqrStatement	begin-footing begin-heading begin-procedure begin-report begin-select
syn keyword	sqrStatement	begin-setup begin-sql break close add
syn keyword	sqrStatement	call commit concat connect create create-array date-time display divide
syn keyword	sqrStatement	do edit else encode end-document end-evaluate end-footing end-heading
syn keyword	sqrStatement	end-if end-procedure end-report end-select end-setup end-sql end-while
syn keyword	sqrStatement	evaluate execute upper exit-select extract fill find get goto if input
syn keyword	sqrStatement	into let isnull load-lookup lookup lower lowercase match move multiply
syn keyword	sqrStatement	new-column new-page new-report next-listing no-formfeed nop on-break
syn keyword	sqrStatement	on-error open page-number page-size position printer-init put read
syn keyword	sqrStatement	rollback select set show stop string subtract unstring uppercase
syn keyword	sqrStatement	use-column when when-other where while with wrap write noline output print
syn keyword	sqrStatement	declare-layout end-declare declare-report loops
syn keyword	sqrStatement	insert update delete values

syn keyword	sqrType		char varchar datetime smalldatetime float int smallint number money tinyint

" Numeric Functions.
syn keyword	sqrFunction	abs acos asin atan ceil cos cosh def e10 exp floor log log10 mod
syn keyword	sqrFunction	power rad round sign sin sinh sqrt tan tanh trunc
syn keyword	sqrFunction	datepart datename

" Miscellaneous Functions.
syn keyword	sqrFunction	ascii chr cond edit instr isnull length lower lpad ltrim nvl range rpad
syn keyword	sqrFunction	rtrim substr to_char to_number translate upper

syn keyword	sqrParameter	quiet for-reading record status

syn keyword	sqrTodo		TODO FIXME XXX DEBUG NOTE

" Strings and characters:
syn region	sqrString	start=+"+  skip=+\\\\|\\"+  end=+"+
syn region	sqrString	start=+'+  skip=+\\\\|\\"+  end=+'+

" Numbers:
syn match	  sqrNumber	"-\=\<\d*\.\=[0-9_]\>"

" Comments:
syn region	sqrComment	start="/\*"  end="\*/" contains=sqrTodo
syn match	  sqrComment	"!.*" contains=sqrTodo
syn sync ccomment sqrComment

" Define the default highlighting.
" For version 5.7 and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn;t have hightlighting yet.
if version >= 508 || !exists("did_sqr_syn_inits")
  if version < 508
    let did_sqr_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink sqrComment Comment
  HiLink sqrNumber Number
  HiLink sqrOperator Operator
  HiLink sqrStatement Statement
  HiLink sqrString String
  HiLink sqrType Type
  HiLink sqrDefine Macro
  HiLink sqrInclude Include
  HiLink sqrTodo Todo
  HiLink sqrFunction Function
  HiLink sqrParameter Function

  delcommand HiLink
endif

let b:current_syntax = "sqr"

" vim: ts=8 sw=2
