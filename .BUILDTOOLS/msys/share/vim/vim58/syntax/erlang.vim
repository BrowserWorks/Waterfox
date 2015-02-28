" Vim syntax file
" Language:    erlang (ERicsson LANGuage)
"              http://www.erlang.se
"              http://www.erlang.org
" Maintainer:  Kre¹imir Mar¾iæ (Kresimir Marzic) <kmarzic@fly.srk.fer.hr>
" Last update: Fri, 27-Apr-2001
" Filenames:   .erl
" URL:         http://www.srk.fer.hr/~kmarzic/vim/syntax/erlang.vim


" There are three sets of highlighting in here:
" One is "erlang_characters", second is  "erlang_functions" and third
" is "erlang_keywords".
" If you want to disable keywords highlighting, put in your .vimrc:
"       let erlang_keywords=1
" If you want to disable erlang function highlighting, put in your .vimrc
" this:
"       let erlang_functions=1
" If you want to disable special characters highlighting, put in
" your .vimrc:
"       let erlang_characters=1


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists ("b:current_syntax")
	finish
endif


syn case match


if ! exists ("erlang_characters")
	syn match   erlangComment  "%.*"
	syn match   erlangModifier "\~w\|\~n"
	syn match   erlangOperator "/=\|=/=\|=:=\|=<\|==\|>=\|<\|>"
	" syn match   erlangOperator "+\|-\|\*\|\/"
	syn match   erlangOperator "!\|->\|\."
	syn keyword erlangOperator div rem band bor bxor bsl bsr
	syn region  erlangString   start=+"+ skip=+\\"+ end=+"+ contains=erlangModifier
	syn region  erlangAtom     start=+'+ skip=+\\'+ end=+'+
	syn match   erlangNumberInteger "\([+-]\)\d\+"
	syn match   erlangNumberFloat0 "[+-]\d\+.\d\+\|\d\+.\d\+"
	syn match   erlangNumberFloat1 "\d\+E\d\+\|\d\+E[+-]\d\+\|[+-]\d\+E\d\+\|[+-]\d\+E[+-]\d\+"
	syn match   erlangNumberFloat1 "\d\+E\d\+.\d\+\|\d\+E[+-]\d\+.\d\+\|[+-]\d\+E\d\+.\d\+\|[+-]\d\+E[+-]\d\+.\d\+"
	syn match   erlangNumberFloat1 "\d\+.\d\+E\d\+\|\d\+.\d\+E[+-]\d\+\|[+-]\d\+.\d\+E\d\+\|[+-]\d\+.\d\+E[+-]\d\+"
	syn match   erlangNumberFloat1 "\d\+.\d\+E\d\+.\d\+\|\d\+.\d\+E[+-]\d\+.\d\+\|[+-]\d\+.\d\+E\d\+.\d\+\|[+-]\d\+.\d\+E[+-]\d\+.\d\+"
	syn match   erlangNumberFloat2 "\d\+#[A-F0-9]\+"
	syn match   erlangNumberFloat2 "\E\d\+\|\E\+[+-]\d\+"
	syn match   erlangNumberFloat3 "$\x\+"
endif

if ! exists ("erlang_functions")
	syn keyword erlangFunction  abs append apply atom_to_list binary
	syn keyword erlangFunction  concat_binary binary_to_list binary_to_term
	syn keyword erlangFunction  concat_binary date element erase exit float
	syn keyword erlangFunction  float_to_list get get_keys group_leader halt
	syn keyword erlangFunction  hash hd integer_to_list length link
	syn keyword erlangFunction  list_to_atom list_to_binary list_to_float
	syn keyword erlangFunction  list_to_integer list_to_pid list_to_touple
	syn keyword erlangFunction  make_ref now open_port pid_to_list
	syn keyword erlangFunction  process_flag process_info processes put
	syn keyword erlangFunction  register registered round self send
	syn keyword erlangFunction  setelement size spawn spawn_link split_binary
	syn keyword erlangFunction  throw time tl trunc tuple_to_list unlink
	syn keyword erlangFunction  unregister whereis

	syn keyword erlangGuard  atom constant float integer list number pid
	syn keyword erlangGuard  port reference tuple binary

	syn keyword erlangBif  element float hd length round self size
	syn keyword erlangBif  trunc tl abs node nodes
endif

if ! exists ("erlang_keywords")
	syn match   erlangConstant "-author\|-behaviour\|-copyright\|-define"
	syn match   erlangConstant "-export\|-include\|-module\|-vsn"

	syn keyword erlangKeyword  alive check_process_code delete_module
	syn keyword erlangKeyword  disconnect_node get_cookie is_alive
	syn keyword erlangKeyword  load_module math module_load monitor_node
	syn keyword erlangKeyword  node nodes pre_load purge_module set_cookie
	syn keyword erlangKeyword  statistics term_to_binary

	syn keyword erlangCondition  end endif else elseif if of after
	syn keyword erlangCondition  receive when case case_clause
endif



" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists ("did_erlang_inits")
	if version < 508
		let did_erlang_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink erlangComment Comment
	HiLink erlangModifier Special
	HiLink erlangOperator Operator
	HiLink erlangString String
	HiLink erlangAtom String
	HiLink erlangNumberInteger Number
	HiLink erlangNumberFloat0 Number
	HiLink erlangNumberFloat1 Number
	HiLink erlangNumberFloat2 Number
	HiLink erlangNumberFloat3 Number

	HiLink erlangFunction Function
	HiLink erlangGuard Function
	HiLink erlangBif Special

	HiLink erlangConstant Type
	HiLink erlangKeyword Keyword
	HiLink erlangCondition Conditional

	delcommand HiLink
endif


let b:current_syntax = "erlang"

" eof
