" Vim syntax file
"    Language: Stored Procedures (STP)
"  Maintainer: Jeff Lanzarotta (frizbeefanatic@yahoo.com)
"         URL: http://lanzarotta.tripod.com/vim/syntax/plsql.vim.zip
" Last Change: April 30, 2001

" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" The STP reserved words, defined as keywords.

syn keyword stpSpecial    null

syn keyword stpKeyword    begin break call case create deallocate dynamic else
syn keyword stpKeyword    elseif end execute for from function go grant if
syn keyword stpKeyword    index insert into max min on output procedure public
syn keyword stpKeyword    result return returns scroll table then to when while

syn keyword stpOperator   asc not and or desc group having in is any some all
syn keyword stpOperator   between exists like escape with union intersect minus
syn keyword stpOperator   out prior distinct sysdate

syn keyword stpStatement  alter analyze as audit avg by close clustered comment
syn keyword stpStatement  commit continue count create cursor declare delete
syn keyword stpStatement  drop exec execute explain fetch from index insert
syn keyword stpStatement  into lock max min next noaudit nonclustered open order
syn keyword stpStatement  output print raiserror recompile rename revoke
syn keyword stpStatement  rollback savepoint select set sum transaction
syn keyword stpStatement  truncate unique update values where

syn keyword stpFunction   abs acos ascii asin atan atn2 avg ceiling charindex
syn keyword stpFunction   charlength convert col_name col_length cos cot count
syn keyword stpFunction   curunreservedpgs datapgs datalength dateadd datediff
syn keyword stpFunction   datename datepart db_id db_name degree difference
syn keyword stpFunction   exp floor getdate hextoint host_id host_name index_col
syn keyword stpFunction   inttohex isnull lct_admin log log10 lower ltrim max
syn keyword stpFunction   min now object_id object_name patindex pi pos power
syn keyword stpFunction   proc_role radians rand replace replicate reserved_pgs
syn keyword stpFunction   reverse right rtrim rowcnt round show_role sign sin
syn keyword stpFunction   soundex space sqrt str stuff substr substring sum
syn keyword stpFunction   suser_id suser_name tan tsequal upper used_pgs user
syn keyword stpFunction   user_id user_name valid_name valid_user

syn keyword stpType       binary bit char datetime decimal double float image
syn keyword stpType       int integer long money nchar numeric precision real
syn keyword stpType       smalldatetime smallint smallmoney text time tinyint
syn keyword stpType       timestamp varbinary varchar

syn keyword stpGlobals    @@char_convert @@cient_csname @@client_csid
syn keyword stpGlobals    @@connections @@cpu_busy @@error @@identity
syn keyword stpGlobals    @@idle @@io_busy @@isolation @@langid @@language
syn keyword stpGlobals    @@maxcharlen @@max_connections @@ncharsize
syn keyword stpGlobals    @@nestlevel @@packet_errors @@pack_received
syn keyword stpGlobals    @@pack_sent @@procid @@rowcount @@servername
syn keyword stpGlobals    @@spid @@sqlstatus @@testts @@textcolid @@textdbid
syn keyword stpGlobals    @@textobjid @@textptr @@textsize @@thresh_hysteresis
syn keyword stpGlobals    @@timeticks @@total_error @@total_read @@total_write
syn keyword stpGlobals    @@tranchained @@trancount @@transtate @@version

syn keyword stpTodo       TODO FIXME XXX DEBUG NOTE

" Strings and characters:
syn match   stpStringError  "'.*$"
syn match   stpString	      "'\([^']\|''\)*'"

" Numbers:
syn match   stpNumber		  "-\=\<\d*\.\=[0-9_]\>"

" Comments:
syn region  stpComment    start="/\*"  end="\*/" contains=stpTodo
syn match   stpComment    "--.*" contains=stpTodo

" Parens:
syn region  stpParen      transparent start='(' end=')' contains=ALLBUT,stpParenError
syn match   stpParenError ")"

" Syntax Synchronizing
syn sync    minlines=10	maxlines=100

" Syntax Synchronizing
syn sync minlines=10 maxlines=100

" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when and item doesn't have highlighting yet.
if version >= 508 || !exists("did_stp_syn_inits")
  if version < 508
    let did_stp_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink stpComment Comment
  HiLink stpKeyword Keyword
  HiLink stpNumber	Number
  HiLink stpOperator	Operator
  HiLink stpSpecial Special
  HiLink stpStatement	Statement
  HiLink stpString	String
  HiLink stpStringError Error
  HiLink stpType Type
  HiLink stpTodo Todo
  HiLink stpFunction	Function
  HiLink stpGlobals Macro
  HiLink stpParen Normal
  HiLink stpParenError Error
  HiLink stpSQLKeyword Function

  delcommand HiLink
endif

let b:current_syntax = "stp"

" vim ts=8 sw=2
