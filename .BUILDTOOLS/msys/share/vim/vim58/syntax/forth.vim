" Vim syntax file
" Language   : FORTH
" Maintainer : Christian V. J. Brüssow <cvjb@bigfoot.de>
" Last change: Son 06 Mai 2001 20:16:25 CEST

" Thanks to...
"
" John Providenza <john@probo.com> made some improvements
" for the highlighting of strings, and added the code for
" highlighting hex numbers.


" The list of keywords is incomplete, compared with the offical ANS
" wordlist. If you use this language, please improve it, and send me
" the patches.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Synchronization method
syn sync ccomment maxlines=200

" I use gforth, so I set this to case ignore
syn case ignore

" Some special, non-FORTH keywords
syn keyword forthTodo contained TODO FIXME
syn match forthTodo contained 'Copyright\(\s([Cc])\)\=\(\s[0-9]\{2,4}\)\='

" Characters allowed in keywords
" I don't know if 128-255 are allowed in ANS-FORHT
if version >= 600
	setlocal iskeyword=!,@,33-64,A-Z,91-96,a-z,123-126,128-255
else
	set iskeyword=!,@,33-64,A-Z,91-96,a-z,123-126,128-255
endif


" Keywords

" basic mathematical and logical operators
syn keyword forthOperators + - * / MOD /MOD NEGATE ABS MIN MAX
syn keyword forthOperators AND OR XOR NOT INVERT 2* 2/ 1+ 1- 2+ 2- 8*
syn keyword forthOperators M+ */ */MOD M* UM* M*/ UM/MOD FM/MOD SM/REM
syn keyword forthOperators D+ D- DNEGATE DABS DMIN DMAX
syn keyword forthOperators F+ F- F* F/ FNEGATE FABS FMAX FMIN FLOOR FROUND
syn keyword forthOperators F** FSQRT FEXP FEXPM1 FLN FLNP1 FLOG FALOG FSIN
syn keyword forthOperators FCOS FSINCOS FTAN FASIN FACOS FATAN FATAN2 FSINH
syn keyword forthOperators FCOSH FTANH FASINH FACOSH FATANH
syn keyword forthOperators 0< 0<= 0<> 0= 0> 0>= <= <> = > >=

" stack manipulations
syn keyword forthStack DROP NIP DUP OVER TUCK SWAP ROT -ROT ?DUP PICK ROLL
syn keyword forthStack 2DROP 2NIP 2DUP 2OVER 2TUCK 2SWAP 2ROT
syn keyword forthStack 3DUP 4DUP
syn keyword forthRStack >R R> R@ RDROP 2>R 2R> 2R@ 2RDROP
syn keyword forthFStack FDROP FNIP FDUP FOVER FTUCK FSWAP FROT

" stack pointer manipulations
syn keyword forthSP SP@ SP! FP@ FP! RP@ RP! LP@ LP!

" address operations
syn keyword forthMemory @ ! +! C@ C! 2@ 2! F@ F! SF@ SF! DF@ DF!
syn keyword forthAdrArith CHARS CHAR+ CELLS CELL+ CELL ALIGN ALIGNED FLOATS
syn keyword forthAdrArith FLOAT+ FLOAT FALIGN FALIGNED SFLOATS SFLOAT+
syn keyword forthAdrArith SFALIGN SFALIGNED DFLOATS DFLOAT+ DFALIGN DFALIGNED
syn keyword forthAdrArith MAXALIGN MAXALIGNED CFALIGN CFALIGNED
syn keyword forthAdrArith ADDRESS-UNIT-BITS ALLOT ALLOCATE HERE
syn keyword forthMemBlks MOVE ERASE CMOVE CMOVE> FILL BLANK

" conditionals
syn keyword forthCond IF ELSE ENDIF THEN CASE OF ENDOF ENDCASE ?DUP-IF
syn keyword forthCond ?DUP-0=-IF AHEAD CS-PICK CS-ROLL CATCH THROW

" iterations
syn keyword forthLoop BEGIN WHILE REPEAT UNTIL AGAIN
syn keyword forthLoop ?DO LOOP I J K +DO U+DO -DO U-DO DO +LOOP -LOOP
syn keyword forthLoop UNLOOP LEAVE ?LEAVE EXIT DONE FOR NEXT

" new words
syn match forthColonDef '\<:\s*[^ \t]\+\>'
syn keyword forthEndOfColonDef ;
syn keyword forthDefine CONSTANT 2CONSTANT FCONSTANT VARIABLE 2VARIABLE CREATE
syn keyword forthDefine USER VALUE TO DEFER IS DOES> IMMEDIATE COMPILE-ONLY
syn keyword forthDefine COMPILE RESTRICT INTERPRET POSTPONE EXECUTE LITERAL
syn keyword forthDefine CREATE-INTERPRET/COMPILE INTERPRETATION> <INTERPRETATION
syn keyword forthDefine COMPILATION> <COMPILATION ] LASTXT COMP' POSTPONE,
syn keyword forthDefine FIND-NAME NAME>INT NAME?INT NAME>COMP NAME>STRING STATE
syn match forthDefine "\[COMP']"
syn match forthDefine "'"
syn match forthDefine '\<\[\>'
syn match forthDefine "\[']"
syn match forthDefine '\[COMPILE]'

" debugging
syn keyword forthDebug PRINTDEBUGDATA PRINTDEBUGLINE
syn match forthDebug "\<\~\~\>"

" Assembler
syn keyword forthAssembler ASSEMBLER CODE END-CODE ;CODE FLUSH-ICACHE C,

" basic character operations
syn keyword forthCharOps (.) CHAR EXPECT FIND WORD TYPE -TRAILING EMIT KEY
syn keyword forthCharOps KEY? TIB CR
syn region forthCharOps start=+."\s+ skip=+\\"+ end=+"+

" char-number conversion
syn keyword forthConversion <# # #> #S (NUMBER) (NUMBER?) CONVERT D>F D>S DIGIT
syn keyword forthConversion DPL F>D HLD HOLD NUMBER S>D SIGN >NUMBER

" interptreter, wordbook, compiler
syn keyword forthForth (LOCAL) BYE COLD ABORT >BODY >NEXT >LINK CFA >VIEW HERE
syn keyword forthForth PAD WORDS VIEW VIEW> N>LINK NAME> LINK> L>NAME FORGET
syn keyword forthForth BODY>
syn region forthForth start=+ABORT"\s+ skip=+\\"+ end=+"+

" vocabularies
syn keyword forthVocs ONLY FORTH ALSO ROOT SEAL VOCS ORDER CONTEXT #VOCS
syn keyword forthVocs VOCABULARY DEFINITIONS

" numbers
syn keyword forthMath DECIMAL HEX BASE
syn match forthInteger '\<-\=[0-9.]*[0-9.]\+\>'
syn match forthHex '\<[0-9a-fA-F]*[0-9][0-9a-fA-F]*\>'
syn match forthFloat '\<-\=[0-9]*[.]\=[0-9]\+[Ee][0-9]\+\>'

" Strings
syn region forthString start=+\.*\"+ end=+"+ end=+$+

" Comments
syn match forthComment '\\\s.*$' contains=forthTodo
syn region forthComment start='\\S\s' end='.*' contains=forthTodo
syn match forthComment '\.(\s[^)]*)' contains=forthTodo
syn region forthComment start='(\s' skip='\\)' end=')' contains=forthTodo
"syn match forthComment '(\s[^\-]*\-\-[^\-]*)' contains=forthTodo

" Include files
syn match forthInclude '^INCLUDE\s\+\k\+'

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_forth_syn_inits")
	if version < 508
		let did_forth_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	" The default methods for highlighting. Can be overriden later.
	HiLink forthTodo Todo
	HiLink forthOperators Operator
	HiLink forthMath Number
	HiLink forthInteger Number
	HiLink forthFloat Float
	HiLink forthStack Special
	HiLink forthRstack Special
	HiLink forthFStack Special
	HiLink forthSP Special
	HiLink forthMemory Function
	HiLink forthAdrArith Function
	HiLink forthMemBlks Function
	HiLink forthCond Conditional
	HiLink forthLoop Repeat
	HiLink forthColonDef Define
	HiLink forthEndOfColonDef Define
	HiLink forthDefine Define
	HiLink forthDebug Debug
	HiLink forthAssembler Include
	HiLink forthCharOps Character
	HiLink forthConversion String
	HiLink forthForth Statement
	HiLink forthVocs Statement
	HiLink forthString String
	HiLink forthComment Comment

	delcommand HiLink
endif

let b:current_syntax = "forth"

" vim:ts=3:sw=3
