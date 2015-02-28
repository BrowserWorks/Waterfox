" Vim syntax file
" Language:	SETL (dB)
" Maintainer:	Alex Poylisher <sher@komkon.org>
" Last Change:	2001 May 10

" The SETL documentation is at "http://www-robotics.eecs.lehigh.edu/~bacon/setl-doc.html".

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" SETL is entirely case-insensitive.
syn case ignore

" The SETL reserved words.

syn keyword setlKeyword		const var

syn keyword setlConditional	case else elsif if then

syn keyword setlKeyword		end

syn keyword setlSpecial		om last_error command_line command_name
syn keyword setlInclude		#include
syn keyword setlBoolean		true false

syn keyword setlOperator	abs accept acos and any arb asin assert atan
syn keyword setlOperator	atan2 bit_and bit_not bit_or bit_xor
syn keyword setlOperator	call callout ceil char chdir clear_error
syn keyword setlOperator	clock close cos cosh date denotype
syn keyword setlOperator	div domain dup dup2 eof exec exp fdate
syn keyword setlOperator	fexists filename fileno filter fix float fixed
syn keyword setlOperator	floating floor flush fork from fromb frome
syn keyword setlOperator	fsize get geta getb getc getchar getegid
syn keyword setlOperator	getenv geteuid getfile getgid getline getn
syn keyword setlOperator	getpgrp gets getuid getwd gmark
syn keyword setlOperator	gsub hex hostaddr hostname ichar impl
syn keyword setlOperator	in incs ip_addresses ip_names is_atom
syn keyword setlOperator	is_boolean is_integer is_map is_mmap
syn keyword setlOperator	is_numeric is_om is_real is_routine
syn keyword setlOperator	is_set is_smap is_string is_tuple
syn keyword setlOperator	is_open kill len less lessf lexists
syn keyword setlOperator	link log lpad mark match max mem_alloc
syn keyword setlOperator	mem_copy mem_free min mod newat not notany
syn keyword setlOperator	notin npow nprint nprinta odd open
syn keyword setlOperator	or pack_char pack_short pack_int pack_long
syn keyword setlOperator	pack_float pack_double pack_long_double
syn keyword setlOperator	peekc peekchar peer_address peer_name
syn keyword setlOperator	peer_port pexists pid pipe pipe_from_child
syn keyword setlOperator	port pow pretty print printa pump put
syn keyword setlOperator	puta putb putc putchar putenv putfile
syn keyword setlOperator	putline outs random range rany rbreak rlen
syn keyword setlOperator	rmatch rnotany rspan read reada readlink
syn keyword setlOperator	reads recv recvfrom recv_fd rem reverse
syn keyword setlOperator	rewind round routine rpad seek
syn keyword setlOperator	select send sendto send_fd setenv setgid
syn keyword setlOperator	setpgrp setrandom setuid set_intslash
syn keyword setlOperator	set_magic shutdown sign sin sinh span
syn keyword setlOperator	split sqrt store_char store_short store_int
syn keyword setlOperator	store_long store_float store_double
syn keyword setlOperator	store_long_double store_string store_c_string
syn keyword setlOperator	str strad sub subset symlink system sys_read
syn keyword setlOperator	sys_write tan tanh tie time tmpnam
syn keyword setlOperator	to_lower to_upper tod type umask ungetc
syn keyword setlOperator	ungetchar unhex unpack_char unpack_short
syn keyword setlOperator	unpack_int unpack_long unpack_float
syn keyword setlOperator	unpack_double unpack_long_double
syn keyword setlOperator	unpretty unsetenv unstr wait whole with
syn keyword setlOperator	write writea

syn keyword setlPreCondit	begin body
syn keyword setlPreCondit	program package procedure proc use

syn keyword setlRepeat		exit for forall loop while until break
syn keyword setlRepeat		continue do doing step pass

syn keyword setlStatement	goto return
syn keyword setlStatement	stop quit assert

" Todo.
syn keyword setlTodo contained	TODO FIXME XXX

" Strings and characters.
syn region  setlString1		start=+'+  skip=+''+  end=+'+
syn region  setlString2		start=+"+  skip=+""+  end=+"+

" Numbers.
syn match   setlNumber		"[+-]\=\<[0-9_]*\.\=[0-9_]*\>"

" Labels for the goto statement.
syn region  setlLabel		start="<<"  end=">>"

" Comments.
syn region  setlComment	oneline contains=setlTodo start="--"  end="$"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_setl_syntax_inits")
  if version < 508
    let did_setl_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink setlBoolean	Boolean
  HiLink setlCharacter	Character
  HiLink setlComment	Comment
  HiLink setlConditional	Conditional
  HiLink setlInclude	Include
  HiLink setlKeyword	Keyword
  HiLink setlLabel	Label
  HiLink setlNumber	Number
  HiLink setlOperator	Operator
  HiLink setlPreCondit	PreCondit
  HiLink setlRepeat	Repeat
  HiLink setlSpecial	Special
  HiLink setlStatement	Statement
  HiLink setlString1	String
  HiLink setlString2	String
  HiLink setlStructure	Structure
  HiLink setlTodo	Todo
  HiLink setlType	Type

  delcommand HiLink
endif

let b:current_syntax = "setl"

" vim: ts=8
