" Vim syntax file
" Language:	Python
" Maintainer:	Neil Schemenauer <nas@python.ca>
" Updated:	2001-05-13
"
" There are four options to control Python syntax highlighting.
"
" For highlighted numbers:
"
"    let python_highlight_numbers = 1
"
" For highlighted builtin functions:
"
"    let python_highlight_builtins = 1
"
" For highlighted standard exceptions:
"
"    let python_highlight_exceptions = 1
"
" If you want all possible Python highlighting (the same as setting the
" preceding three options):
"
"    let python_highlight_all = 1
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn keyword pythonStatement	break continue del
syn keyword pythonStatement	except exec finally
syn keyword pythonStatement	pass print raise
syn keyword pythonStatement	return try
syn keyword pythonStatement	global assert
syn keyword pythonStatement	lambda
syn keyword pythonStatement	def class nextgroup=pythonFunction skipwhite
syn match   pythonFunction	"[a-zA-Z_][a-zA-Z0-9_]*" contained
syn keyword pythonRepeat	for while
syn keyword pythonConditional	if elif else
syn keyword pythonOperator	and in is not or
syn keyword pythonPreCondit	import from
syn match   pythonComment	"#.*$" contains=pythonTodo
syn keyword pythonTodo		contained TODO FIXME XXX

" strings
syn region pythonString		matchgroup=Normal start=+'+  end=+'+ skip=+\\\\\|\\'+ contains=pythonEscape
syn region pythonString		matchgroup=Normal start=+"+  end=+"+ skip=+\\\\\|\\"+ contains=pythonEscape
syn region pythonString		matchgroup=Normal start=+"""+  end=+"""+ contains=pythonEscape
syn region pythonString		matchgroup=Normal start=+'''+  end=+'''+ contains=pythonEscape
syn region pythonRawString	matchgroup=Normal start=+[rR]'+ end=+'+ skip=+\\\\\|\\'+
syn region pythonRawString	matchgroup=Normal start=+[rR]"+    end=+"+ skip=+\\\\\|\\"+
syn region pythonRawString	matchgroup=Normal start=+[rR]"""+ end=+"""+
syn region pythonRawString	matchgroup=Normal start=+[rR]'''+ end=+'''+
syn match  pythonEscape		+\\[abfnrtv'"\\]+ contained
syn match  pythonEscape		"\\\o\o\=\o\=" contained
syn match  pythonEscape		"\\x\x\+" contained
syn match  pythonEscape		"\\$"

if exists("python_highlight_all")
  let python_highlight_numbers = 1
  let python_highlight_builtins = 1
  let python_highlight_exceptions = 1
endif

if exists("python_highlight_numbers")
  " numbers (including longs and complex)
  syn match   pythonNumber	"\<0x\x\+[Ll]\=\>"
  syn match   pythonNumber	"\<\d\+[LljJ]\=\>"
  syn match   pythonNumber	"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
  syn match   pythonNumber	"\<\d\+\.\([eE][+-]\=\d\+\)\=[jJ]\=\>"
  syn match   pythonNumber	"\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
endif

if exists("python_highlight_builtins")
  " builtin functions, not really part of the syntax
  syn keyword pythonBuiltin	abs apply callable chr cmp coerce
  syn keyword pythonBuiltin	compile complex delattr dir divmod
  syn keyword pythonBuiltin	eval execfile filter float getattr
  syn keyword pythonBuiltin	globals hasattr hash hex id input
  syn keyword pythonBuiltin	int intern isinstance issubclass
  syn keyword pythonBuiltin	len list locals long map max min
  syn keyword pythonBuiltin	oct open ord pow range raw_input
  syn keyword pythonBuiltin	reduce reload repr round setattr
  syn keyword pythonBuiltin	slice str tuple type vars xrange
endif

if exists("python_highlight_exceptions")
  " builtin exceptions
  syn keyword pythonException	ArithmeticError AssertionError
  syn keyword pythonException	AttributeError EOFError EnvironmentError
  syn keyword pythonException	Exception FloatingPointError IOError
  syn keyword pythonException	ImportError IndexError KeyError
  syn keyword pythonException	KeyboardInterrupt LookupError
  syn keyword pythonException	MemoryError NameError NotImplementedError
  syn keyword pythonException	OSError OverflowError RuntimeError
  syn keyword pythonException	StandardError SyntaxError SystemError
  syn keyword pythonException	SystemExit TypeError ValueError
  syn keyword pythonException	ZeroDivisionError
endif


" This is fast but code inside triple quoted strings screws it up. It
" is impossible to fix because the only way to know if you are inside a
" triple quoted string is to start from the beginning of the file. If
" you have a fast machine you can try uncommenting the "sync minlines"
" and commenting out the rest.
syn sync match pythonSync grouphere NONE "):$"
syn sync maxlines=200
"syn sync minlines=2000

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink pythonStatement	Statement
  HiLink pythonFunction		Function
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonString		String
  HiLink pythonRawString	String
  HiLink pythonEscape		Special
  HiLink pythonOperator		Operator
  HiLink pythonPreCondit	PreCondit
  HiLink pythonComment		Comment
  HiLink pythonTodo		Todo
  if exists("python_highlight_numbers")
    HiLink pythonNumber	Number
  endif
  if exists("python_highlight_builtins")
    HiLink pythonBuiltin	Function
  endif
  if exists("python_highlight_exceptions")
    HiLink pythonException	Exception
  endif

  delcommand HiLink
endif

let b:current_syntax = "python"

" vim: ts=8
