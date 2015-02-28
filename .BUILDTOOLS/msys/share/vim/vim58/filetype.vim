" Vim support file to detect file types
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2001 May 29

if !exists("did_load_filetypes")
let did_load_filetypes = 1

" Line continuation is used here, remove 'C' from 'cpoptions'
let ft_cpo_save = &cpo
set cpo-=C

augroup filetype

" Ignored extensions
au BufNewFile,BufRead *.orig,*.bak,*.old,*.new	exe "doau filetype BufRead " . expand("<afile>:r")
au BufNewFile,BufRead *~		exe "doau filetype BufRead " . substitute(expand("<afile>"), '\~$', '', '')


" Abaqus or Trasys
au BufNewFile,BufRead *.inp			call FTCheck_inp()

fun! FTCheck_inp()
  if getline(1) =~ '^\*'
    set ft=abaqus
  else
    let n = 1
    if line("$") > 500
      let nmax = 500
    else
      let nmax = line("$")
    endif
    while n <= nmax
      if getline(n) =~? "^header surface data"
	set ft=trasys
	break
      endif
      let n = n + 1
    endwhile
  endif
endfun

" ABC music notation
au BufNewFile,BufRead *.abc			set ft=abc

" ABEL
au BufNewFile,BufRead *.abl			set ft=abel

" AceDB
au BufNewFile,BufRead *.wrm			set ft=acedb

" Ada (83, 9X, 95)
au BufNewFile,BufRead *.adb,*.ads		set ft=ada

" AHDL
au BufNewFile,BufRead *.tdf			set ft=ahdl

" Apache style config file
au BufNewFile,BufRead proftpd.conf*		set ft=apachestyle

" Apache config file
au BufNewFile,BufRead httpd.conf*,srm.conf*,access.conf*,.htaccess,apache.conf* set ft=apache

" Applix ELF
au BufNewFile,BufRead *.am			set ft=elf

" Arc Macro Language
au BufNewFile,BufRead *.aml			set ft=aml

" ASN.1
au BufNewFile,BufRead *.asn,*.asn1		set ft=asn

" Active Server Pages (with Visual Basic Script)
au BufNewFile,BufRead *.asa			set ft=aspvbs

" Active Server Pages (with Perl or Visual Basic Script)
au BufNewFile,BufRead *.asp			if getline(1) . getline(2) .  getline(3) =~? "perlscript" | set ft=aspperl | else | set ft=aspvbs | endif

" Assembly (all kinds)
" *.lst is not pure assembly, it has two extra columns (address, byte codes)
au BufNewFile,BufRead *.asm,*.[sS],*.[aA],*.mac,*.lst	call FTCheck_asm()

" This function checks for the kind of assembly that is wanted by the user, or
" can be detected from the first five lines of the file.
fun! FTCheck_asm()
  " make sure b:asmsyntax exists
  if !exists("b:asmsyntax")
    let b:asmsyntax = ""
  endif

  if b:asmsyntax == ""
    call FTCheck_asmsyntax()
  endif

  " if b:asmsyntax still isn't set, default to asmsyntax or GNU
  if b:asmsyntax == ""
    if exists("g:asmsyntax")
      let b:asmsyntax = g:asmsyntax
    else
      let b:asmsyntax = "asm"
    endif
  endif

  exe "set ft=" . b:asmsyntax
endfun

fun! FTCheck_asmsyntax()
  " see if file contains any asmsyntax=foo overrides. If so, change
  " b:asmsyntax appropriately
  let head = " ".getline(1)." ".getline(2)." ".getline(3)." ".getline(4).
      \" ".getline(5)." "
  if head =~ '\sasmsyntax=\S\+\s'
    let b:asmsyntax = substitute(head, '.*\sasmsyntax=\(\S\+\)\s.*','\1', "")
  endif
endfun

" Atlas
au BufNewFile,BufRead *.atl,*.as		set ft=atlas

" Automake
au BufNewFile,BufRead [mM]akefile.am		set ft=automake

" Avenue
au BufNewFile,BufRead *.ave			set ft=ave

" Awk
au BufNewFile,BufRead *.awk			set ft=awk

" B
au BufNewFile,BufRead *.mch,*.ref,*.imp		set ft=b

" BASIC or Visual Basic
au BufNewFile,BufRead *.bas			call FTCheck_VB("basic")

" Check if one of the first five lines contains "VB_Name".  In that case it is
" probably a Visual Basic file.  Otherwise it's assumed to be "alt" filetype.
fun! FTCheck_VB(alt)
  if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'VB_Name'
    set ft=vb
  else
    exe "set ft=" . a:alt
  endif
endfun

" Batch file for MSDOS (*.cmd is close enough)
au BufNewFile,BufRead *.bat,*.sys,*.cmd		set ft=dosbatch|set nobin|set ff=dos

" Batch file for 4DOS
au BufNewFile,BufRead *.btm			set ft=btm

" BC calculator
au BufNewFile,BufRead *.bc			set ft=bc

" BibTeX bibliography database file
au BufNewFile,BufRead *.bib			set ft=bib

" BIND configuration
au BufNewFile,BufRead named.conf		set ft=named

" BIND zone
au BufNewFile,BufRead /var/named/*,named.root	set ft=bindzone

" Blank
au BufNewFile,BufRead *.bl			set ft=blank

" C
au BufNewFile,BufRead *.c			set ft=c

" C#
"au BufNewFile,BufRead *.cs			set ft=cs

" Cyn++
au BufNewFile,BufRead *.cyn			set ft=cynpp

" Cynlib
" .cc and .cpp files can be C++ or Cynlib.
au BufNewFile,BufRead *.cc			if exists("cynlib_syntax_for_cc")|set ft=cynlib|else|set ft=cpp|endif
au BufNewFile,BufRead *.cpp     		if exists("cynlib_syntax_for_cpp")|set ft=cynlib|else|set ft=cpp|endif

" C++
if has("fname_case")
  au BufNewFile,BufRead *.cxx,*.c++,*.C,*.H,*.hh,*.hxx,*.hpp,*.tcc,*.inl set ft=cpp
else
  au BufNewFile,BufRead *.cxx,*.c++,*.hh,*.hxx,*.hpp,*.tcc,*.inl set ft=cpp
endif

" .h files can be C or C++, set c_syntax_for_h if you want C
au BufNewFile,BufRead *.h			if exists("c_syntax_for_h")|set ft=c|else|set ft=cpp|endif

" Cascading Style Sheets
au BufNewFile,BufRead *.css			set ft=css

" Century Term Command Scripts (*.cmd too)
au BufNewFile,BufRead *.con			set ft=cterm

" Changelog
au BufNewFile,BufRead changelog.Debian		set ft=debchangelog
au BufNewFile,BufRead [cC]hange[lL]og		if getline(1) =~ '; urgency='
	\| set ft=debchangelog | else | set ft=changelog | endif

" CHILL
au BufNewFile,BufRead *..ch			set ft=ch

" Changes for WEB and CWEB or CHILL
au BufNewFile,BufRead *.ch			call FTCheck_change()

" This function checks if one of the first ten lines start with a '@'.  In
" that case it is probably a change file, otherwise CHILL is assumed.
fun! FTCheck_change()
  let lnum = 1
  while lnum <= 10
    if getline(lnum)[0] == '@'
      set ft=change
      return
    endif
    let lnum = lnum + 1
  endwhile
  set ft=ch
endfun

" Clean
au BufNewFile,BufRead *.dcl,*.icl		set ft=clean

" Clever (also: *.ent)
au BufNewFile,BufRead *.eni			set ft=cl

" Clever or SGML
au BufNewFile,BufRead *.ent			call FTCheck_ent()

fun! FTCheck_ent()
  " This function checks for valid cl syntax in the first five lines.
  " Look for either an opening comment, '#', or a block start, '{".
  " If not found, assume SGML.
  let lnum = 1
  while lnum < 6
    let line = getline(lnum)
    if line =~ '^\s*[#{]'
      set ft=cl
      return
    elseif line !~ '^\s*$'
      " Not a blank line, not a comment, and not a block start,
      " so doesn't look like valid cl code.
      break
    endif
    let lnum = lnum + 1
  endw
  set ft=sgml
endfun

" Clipper
au BufNewFile,BufRead *.prg			set ft=clipper

" Cobol
au BufNewFile,BufRead *.cbl,*.cob,*.cpy,*.lib	set ft=cobol

" Cold Fusion
au BufNewFile,BufRead *.cfm,*.cfi		set ft=cf

" Configure scripts
au BufNewFile,BufRead configure.in,configure.ac	set ft=config

" Configure files
au BufNewFile,BufRead *.cfg			set ft=cfg

" Communicating Sequential Processes
au BufNewFile,BufRead *.csp,*.fdr		set ft=csp

" CUPL logic description and simulation
au BufNewFile,BufRead *.pld			set ft=cupl
au BufNewFile,BufRead *.si			set ft=cuplsim

" Debian Control
au BufNewFile,BufRead */debian/control		set ft=debcontrol

" Diff files
au BufNewFile,BufRead *.diff,*.rej		set ft=diff

" Diva (with Skill) or InstallShield
au BufNewFile,BufRead *.rul			if getline(1).getline(2).getline(3).getline(4).getline(5).getline(6) =~? 'InstallShield'|set ft=ishd|else|set ft=diva|endif

" DCL (Digital Command Language - vms) or DNS zone file
au BufNewFile,BufRead *.com
	\ if getline(1) =~ '\($ORIGIN\|$TTL\|IN\s*SOA\)'
	\	|| getline(2) =~ '\($ORIGIN\|$TTL\|IN\s*SOA\)'
	\	|| getline(1).getline(2).getline(3).getline(4) =~ 'BIND.*named'
	\ | set ft=dns | else | set ft=dcl | endif

" Dylan - lid files
au BufNewFile,BufRead *.lid			set ft=dylanlid

" Dylan - intr files (melange)
au BufNewFile,BufRead *.intr			set ft=dylanintr

" Dylan
au BufNewFile,BufRead *.dylan			set ft=dylan

" Microsoft Module Definition
au BufNewFile,BufRead *.def			set ft=def

" Dracula
au BufNewFile,BufRead drac.*,*.drac,*.drc,*lvs,*lpe set ft=dracula

" DTD (Document Type Definition for XML)
au BufNewFile,BufRead *.dtd			set ft=dtd

" Embedix Component Description
au BufNewFile,BufRead *.ecd			set ft=ecd

" Eiffel
au BufNewFile,BufRead *.e,*.E			set ft=eiffel

" ERicsson LANGuage
au BufNewFile,BufRead *.erl			set ft=erlang

" Elm Filter Rules file
au BufNewFile,BufRead filter-rules		set ft=elmfilt

" ESQL-C
au BufNewFile,BufRead *.ec,*.EC			set ft=esqlc

" Essbase script
au BufNewFile,BufRead *.csc			set ft=csc

" Expect
au BufNewFile,BufRead *.exp			set ft=expect

" Exports
au BufNewFile,BufRead exports			set ft=exports

" Focus Executable
au BufNewFile,BufRead *.fex,*.focexec		set ft=focexec

" Focus Master file
au BufNewFile,BufRead *.mas,*.master		set ft=master

" Forth
au BufNewFile,BufRead *.fs,*.ft			set ft=forth

" Fortran
au BufNewFile,BufRead *.f,*.F,*.for,*.fpp,*.ftn,*.f77,*.f90,*.f95	set ft=fortran

" Fvwm
au BufNewFile,BufRead *fvwmrc*,*fvwm95*.hook
	\ let b:fvwm_version = 1 | set ft=fvwm
au BufNewFile,BufRead *fvwm2rc*
	\ let b:fvwm_version = 2 | set ft=fvwm

" GDB command files
au BufNewFile,BufRead .gdbinit			set ft=gdb

" GDMO
au BufNewFile,BufRead *.mo,*.gdmo		set ft=gdmo

" Gedcom
au BufNewFile,BufRead *.ged			set ft=gedcom

" GP scripts (2.0 and onward)
au BufNewFile,BufRead *.gp			set ft=gp

" GNU Server Pages
au BufNewFile,BufRead *.gsp			set ft=gsp

" Gnuplot scripts
au BufNewFile,BufRead *.gpi			set ft=gnuplot

" GTK RC
au BufNewFile,BufRead .gtkrc,gtkrc		set ft=gtkrc

" Haskell
au BufNewFile,BufRead *.hs			set ft=haskell
au BufNewFile,BufRead *.lhs			set ft=lhaskell

" Hercules
au BufNewFile,BufRead *.vc,*.ev,*.rs,*.sum,*.errsum	set ft=hercules

" HEX (Intel)
au BufNewFile,BufRead *.hex,*.h32		set ft=hex

" HTML (.shtml for server side)
au BufNewFile,BufRead *.html,*.htm,*.shtml	set ft=html

" HTML with M4
au BufNewFile,BufRead *.html.m4			set ft=htmlm4

" Hyper Builder
au BufNewFile,BufRead *.hb			set ft=hb

" Icon
au BufNewFile,BufRead *.icn			set ft=icon

" IDL (Interface Description Language)
au BufNewFile,BufRead *.idl			set ft=idl

" IDL (Interactive Data Language)
au BufNewFile,BufRead *.pro			set ft=idlang

" Inform
au BufNewFile,BufRead *.inf,*.INF		set ft=inform

" Informix 4GL (source - canonical, include file, I4GL+M4 preproc.)
au BufNewFile,BufRead *.4gl,*.4gh,*.m4gl	set ft=fgl

" .INI file for MSDOS
au BufNewFile,BufRead *.ini			set ft=dosini

" SysV Inittab
au BufNewFile,BufRead inittab			set ft=inittab

" Inno Setup
au BufNewFile,BufRead *.iss			set ft=iss

" Jam
au! BufNewFile,BufRead *.jpl,*.jpr,Prl*.*,JAM*.*	set ft=jam

" Java
au BufNewFile,BufRead *.java,*.jav		set ft=java

" JavaCC
au BufNewFile,BufRead *.jj,*.jjt		set ft=javacc

" JavaScript
au BufNewFile,BufRead *.js,*.javascript		set ft=javascript

" Java Server Pages
au BufNewFile,BufRead *.jsp			set ft=jsp

" Java Properties resource file (note: doesn't catch font.properties.pl)
au BufNewFile,BufRead *.properties,*.properties_??,*.properties_??_??,*.properties_??_??_*		set ft=jproperties

" Jess
au BufNewFile,BufRead *.clp			set ft=jess

" Jgraph
au BufNewFile,BufRead *.jgr			set ft=jgraph

" Kimwitu[++]
au BufNewFile,BufRead *.k			set ft=kwt

" KixTart
au BufNewFile,BufRead *.kix			set ft=kix

" KDE script
au BufNewFile,BufRead *.ks			set ft=kscript

" Lace (ISE)
au BufNewFile,BufRead *.ace,*.ACE		set ft=lace

" Latte
au BufNewFile,BufRead *.latte,*.lte		set ft=latte

" LambdaProlog (*.mod too, see Modsim)
au BufNewFile,BufRead *.sig			set ft=lprolog

" Lex
au BufNewFile,BufRead *.lex,*.l			set ft=lex

" Lilo: Linux loader
au BufNewFile,BufRead lilo.conf*		set ft=lilo

" Lisp (*.el = ELisp, *.cl = Common Lisp, *.jl = librep Lisp)
if has("fname_case")
  au BufNewFile,BufRead *.lsp,*.el,*.cl,*.jl,*.L	set ft=lisp
else
  au BufNewFile,BufRead *.lsp,*.el,*.cl,*.jl		set ft=lisp
endif

" Lite
au BufNewFile,BufRead *.lite,*.lt		set ft=lite

" LOTOS
au BufNewFile,BufRead *.lot,*.lotos		set ft=lotos

" Lout (also: *.lt)
au BufNewFile,BufRead *.lou,*.lout		set ft=lout

" Lua
au BufNewFile,BufRead *.lua			set ft=lua

" Lynx style file
au BufNewFile,BufRead *.lss			set ft=lss

" M4
au BufNewFile,BufRead *.m4			if expand("<afile>") !~? "html.m4$" | set ft=m4 | endif

" MaGic Point
au BufNewFile,BufRead *.mgp			set ft=mgp

" Mail (for Elm, trn, mutt, rn, slrn)
au BufNewFile,BufRead snd.\d\+,.letter,.letter.\d\+,.followup,.article,.article.\d\+,pico.\d\+,mutt-*-\d\+,mutt\w\{6\},ae\d\+.txt,/tmp/SLRN[0-9A-Z.]\+ set ft=mail

" Makefile (but not Automake)
au BufNewFile,BufRead [mM]akefile* if expand("<afile>") !~? 'Makefile.am\>' | set ft=make | endif
au BufNewFile,BufRead GNUmakefile,*.mk,*.mak,*.dsp set ft=make

" MakeIndex
au BufNewFile,BufRead *.ist,*.mst		set ft=ist

" Manpage
au BufNewFile,BufRead *.man			set ft=man

" Maple V
au BufNewFile,BufRead *.mv,*.mpl,*.mws		set ft=maple

" Mason
au BufNewFile,BufRead *.mason.*.mhtml		set ft=mason

" Matlab or Mathematica
au BufNewFile,BufRead *.m			call FTCheck_m()

fun! FTCheck_m()
  let n = 1
  while n < 10
    if getline(n) =~ '^\s*%'
      set ft=matlab
      return
    endif
    if getline(n) =~ '^\s*(\*'
      set ft=mma
      return
    endif
    let n = n + 1
  endwhile
  set ft=matlab
endfun

" Maya Extension Language
au BufNewFile,BufRead *.mel			set ft=mel

" Metafont
au BufNewFile,BufRead *.mf			set ft=mf

" MetaPost
au BufNewFile,BufRead *.mp			set ft=mp

" Modsim III (or LambdaProlog)
au BufNewFile,BufRead *.mod
	\ if getline(1) =~ '\<module\>' |
	\   set ft=lprolog |
	\ else |
	\   set ft=modsim3 |
	\ endif

" Modula 2
au BufNewFile,BufRead *.m2,*.DEF,*.MOD,*.md,*.mi set ft=modula2

" Modula 3 (.m3, .i3, .mg, .ig)
au BufNewFile,BufRead *.[mi][3g]		set ft=modula3

" Moterola S record
au BufNewFile,BufRead *.s19,*.s28,*.s37		set ft=srec

" Msql
au BufNewFile,BufRead *.msql			set ft=msql

" M$ Resource files
au BufNewFile,BufRead *.rc			set ft=rc

" Mutt setup file
au BufNewFile,BufRead .muttrc*,Muttrc		set ft=muttrc

" Nastran input/DMAP
"au BufNewFile,BufRead *.dat			set ft=nastran

" Novell netware batch files
au BufNewFile,BufRead *.ncf			set ft=ncf

" Nroff/Troff (*.ms is checked below)
au BufNewFile,BufRead *.me,*.mm,*.tr,*.nr	set ft=nroff
au BufNewFile,BufRead *.[1-9]			call FTCheck_nroff()

" This function checks if one of the first five lines start with a dot.  In
" that case it is probably an nroff file: 'filetype' is set and 1 is returned.
fun! FTCheck_nroff()
  if getline(1)[0] . getline(2)[0] . getline(3)[0] . getline(4)[0] . getline(5)[0] =~ '\.'
    set ft=nroff
    return 1
  endif
  return 0
endfun

" Not Quite C
au BufNewFile,BufRead *.nqc			set ft=nqc

" OCAML
au BufNewFile,BufRead *.ml,*.mli,*.mll,*.mly	set ft=ocaml

" Omnimark
au BufNewFile,BufRead *.xom,*.xin		set ft=omnimark

" OpenROAD
au BufNewFile,BufRead *.or			set ft=openroad

" OPL
au BufNewFile,BufRead *.[Oo][Pp][Ll]		set ft=opl

" Oracle config file
au BufNewFile,BufRead *.ora			set ft=ora

" PApp
au BufNewFile,BufRead *.papp,*.pxml,*.pxsl	set ft=papp

" Pascal
au BufNewFile,BufRead *.pas			set ft=pascal

" Delphi project file
au BufNewFile,BufRead *.dpr			set ft=pascal

" Perl
if has("fname_case")
  au BufNewFile,BufRead *.pl,*.PL		set ft=perl
else
  au BufNewFile,BufRead *.pl			set ft=perl
endif

" Perl, XPM or XPM2
au BufNewFile,BufRead *.pm	if getline(1) =~ "XPM2"|set ft=xpm2|elseif getline(1) =~ "XPM"|set ft=xpm|else|set ft=perl|endif

" Perl POD
au BufNewFile,BufRead *.pod			set ft=pod

" Php3
au BufNewFile,BufRead *.php,*.php3		set ft=php

" Phtml
au BufNewFile,BufRead *.phtml			set ft=phtml

" Pike
au BufNewFile,BufRead *.pike,*.lpc,*.ulpc,*.pmod set ft=pike

" Pine config
au BufNewFile,BufRead .pinerc,pinerc		set ft=pine

" PL/SQL
au BufNewFile,BufRead *.pls,*.plsql		set ft=plsql

" PO (GNU gettext)
au BufNewFile,BufRead *.po			set ft=po

" Postfix main config
au BufNewFile,BufRead main.cf			set ft=pfmain

" PostScript
au BufNewFile,BufRead *.ps,*.eps		set ft=postscr

" Povray
au BufNewFile,BufRead *.pov			set ft=pov

" Povray or IA64
au BufNewFile,BufRead *.inc			call FTCheck_inc()

fun! FTCheck_inc()
  if exists("g:filetype_inc")
    exe "set ft=" . g:filetype_inc
  elseif getline(1).getline(2).getline(3) =~ "<?"
    set ft=php
  else
    call FTCheck_asmsyntax()
    if exists("b:asmsyntax")
      exe "set ft=" . b:asmsyntax
    else
      set ft=pov
    endif
  endif
endfun

" Printcap and Termcap
au BufNewFile,BufRead *printcap			let b:ptcap_type = "print"|set ft=ptcap
au BufNewFile,BufRead *termcap			let b:ptcap_type = "term"|set ft=ptcap

" PCCTS / ANTRL
"au BufNewFile,BufRead *.g			set ft=antrl
au BufNewFile,BufRead *.g			set ft=pccts

" PPWizard
au BufNewFile,BufRead *.it,*.ih			set ft=ppwiz

" Procmail
au BufNewFile,BufRead .procmail,.procmailrc	set ft=procmail

" Progress or CWEB
au BufNewFile,BufRead *.w			call FTCheck_progress_cweb()

function! FTCheck_progress_cweb()
  if exists("g:filetype_w")
    exe "set ft=" . g:filetype_w
    return
  endif
  if getline(1) =~ '&ANALYZE' || getline(3) =~ '&GLOBAL-DEFINE'
    set ft=progress
  else
    set ft=cweb
  endif
endfun

" Progress or assembly
au BufNewFile,BufRead *.i			call FTCheck_progress_asm()

function! FTCheck_progress_asm()
  if exists("g:filetype_i")
    exe "set ft=" . g:filetype_i
    return
  endif
  " This function checks for an assembly comment the first ten lines.
  " If not found, assume Progress.
  let lnum = 1
  while lnum <= 10
    let line = getline(lnum)
    if line =~ '^\s*;' || line =~ '^\*'
      call FTCheck_asm()
      return
    elseif line !~ '^\s*$' || line =~ '^/\*'
      " Not an empty line: Doesn't look like valid assembly code.
      " Or it looks like a Progress /* comment
      break
    endif
    let lnum = lnum + 1
  endw
  set ft=progress
endfun

" Progress or Pascal
au BufNewFile,BufRead *.p			call FTCheck_progress_pascal()

function! FTCheck_progress_pascal()
  if exists("g:filetype_p")
    exe "set ft=" . g:filetype_p
    return
  endif
  " This function checks for valid Pascal syntax in the first ten lines.
  " Look for either an opening comment or a program start.
  " If not found, assume Progress.
  let lnum = 1
  while lnum <= 10
    let line = getline(lnum)
    if line =~ '^\s*\(program\|procedure\|function\|const\|type\|var\)\>'
    	\ || line =~ '^\s*{'
      set ft=pascal
      return
    elseif line !~ '^\s*$' || line =~ '^/\*'
      " Not an empty line: Doesn't look like valid Pascal code.
      " Or it looks like a Progress /* comment
      break
    endif
    let lnum = lnum + 1
  endw
  set ft=progress
endfun

" Software Distributor Product Specification File (POSIX 1387.2-1995)
au BufNewFile,BufRead *.psf			set ft=psf
au BufNewFile,BufRead INDEX,INFO
	\ if getline(1) =~ '^\s*\(distribution\|installed_software\|root\|bundle\|product\)\s*$' |
	\   set ft=psf |
	\ endif

" Prolog
au BufNewFile,BufRead *.pdb			set ft=prolog

" Python
au BufNewFile,BufRead *.py			set ft=python

" Radiance
au BufNewFile,BufRead *.rad,*.mat		set ft=radiance

" Registry for MS-Windows
au BufNewFile,BufRead *.reg
	\ if getline(1) =~? '^REGEDIT[0-9]*\s*$' | set ft=registry | endif

" Rexx
au BufNewFile,BufRead *.rexx,*.rex		set ft=rexx

" Rexx or Rebol
au BufNewFile,BufRead *.r
	\ if getline(1) =~ '^REBOL'|set ft=rebol|else|set ft=rexx|endif

" Remind
au BufNewFile,BufRead .reminders*		set ft=remind

" Robots.txt
au BufNewFile,BufRead robots.txt		set ft=robots

" Rpcgen
au BufNewFile,BufRead *.x			set ft=rpcgen

" RTF
au BufNewFile,BufRead *.rtf			set ft=rtf

" Ruby
au BufNewFile,BufRead *.rb			set ft=ruby

" S-lang (or shader language!)
au BufNewFile,BufRead *.sl			set ft=slang

" Samba config
au BufNewFile,BufRead smb.conf			set ft=samba

" SAS script
au BufNewFile,BufRead *.sas			set ft=sas

" Sather
au BufNewFile,BufRead *.sa			set ft=sather

" SDL
au BufNewFile,BufRead *.sdl,*.pr		set ft=sdl

" sed
au BufNewFile,BufRead *.sed			set ft=sed

" Sendmail
au BufNewFile,BufRead sendmail.cf		set ft=sm

" SETL
au BufNewFile,BufRead *.setl,*.stl		set ft=setl

" SGML
au BufNewFile,BufRead *.sgm,*.sgml
	\ if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'linuxdoc'|
	\   set ft=sgmllnx |
	\ elseif getline(1) =~ '<!DOCTYPE.*DocBook' || getline(2) =~ '<!DOCTYPE.*DocBook' |
	\   let b:docbk_type="sgml" |
	\   set ft=docbk |
	\ else |
	\   set ft=sgml |
	\ endif

" SGMLDECL
au BufNewFile,BufRead *.decl,*.dcl,*.dec
	\ if getline(1).getline(2).getline(3) =~? '^<!SGML' |
	\    set ft=sgmldecl |
	\ endif

" Shell scripts (sh, ksh, bash, bash2, csh); Allow .profile_foo etc.
au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash_profile*,*.bash call SetFileTypeSH("bash")
au BufNewFile,BufRead .kshrc*,*.ksh call SetFileTypeSH("ksh")
au BufNewFile,BufRead /etc/profile,.profile*,*.sh,*.env call SetFileTypeSH(getline(1))
au BufNewFile,BufRead .login*,.cshrc*,csh.cshrc,csh.login,csh.logout,.tcshrc*,*.csh,*.tcsh,.alias set ft=csh

fun! SetFileTypeSH(name)
  if a:name =~ '\<ksh\>'
    let b:is_kornshell = 1
    if exists("b:is_bash")
      unlet b:is_bash
    endif
  elseif exists("g:bash_is_sh") || a:name =~ '\<bash\>' || a:name =~ '\<bash2\>'
    let b:is_bash = 1
    if exists("b:is_kornshell")
      unlet b:is_kornshell
    endif
  endif
  set ft=sh
endfun

" Z-Shell script
au BufNewFile,BufRead .zsh*,.zlog*,.zprofile,.zfbfmarks,.zcompdump*,zsh*,zlog*  set ft=zsh

" Scheme
au BufNewFile,BufRead *.scm			set ft=scheme

" Simula
au BufNewFile,BufRead *.sim			set ft=simula

" SINDA
au BufNewFile,BufRead *.sin,*.s85		set ft=sinda

" SKILL
au BufNewFile,BufRead *.il			set ft=skill

" SLRN
au BufNewFile,BufRead .slrnrc			set ft=slrnrc
au BufNewFile,BufRead *.score			set ft=slrnsc

" Smalltalk
au BufNewFile,BufRead *.st			set ft=st

" Smalltalk or Tex
au BufNewFile,BufRead *.cls
	\ if getline(1) =~ "^%" |
	\   set ft=tex |
	\ else |
	\   set ft=st |
	\ endif

" SMIL or XML
au BufNewFile,BufRead *.smil
	\ if getline(1) =~ '<?\s*xml.*?>'|
	\   set ft=xml|
	\ else|
	\   set ft=smil|
	\ endif

" SMIL or SNMP MIB file
au BufNewFile,BufRead *.smi		if getline(1) =~ '\<smil\>'|set ft=smil|else|set ft=mib|endif

" SMITH
au BufNewFile,BufRead *.smt,*.smith		set ft=smith

" Snobol4
au BufNewFile,BufRead *.sno			set ft=snobol4

" SNMP MIB files
au BufNewFile,BufRead *.mib			set ft=mib

" Snort Configuration
au BufNewFile,BufRead *.hog,snort.conf,vision.conf,*.rules	set ft=hog

" Spec (Linux RPM)
au BufNewFile,BufRead *.spec			set ft=spec

" Speedup (AspenTech plant simulator)
au BufNewFile,BufRead *.speedup,*.spdata,*.spd	set ft=spup

" Spice
au BufNewFile,BufRead *.sp,*.spice		set ft=spice

" Squid
au BufNewFile,BufRead squid.conf		set ft=squid

" SQL (all but the first one for Oracle Designer)
au BufNewFile,BufRead *.sql,*.tyb,*.typ,*.tyc,*.pkb,*.pks	set ft=sql

" SQR
au BufNewFile,BufRead *.sqr,*.sqi		set ft=sqr

" Stored Procedures
au BufNewFile,BufRead *.stp			set ft=stp

" Standard ML
au BufNewFile,BufRead *.sml			set ft=sml

" Tads
au BufNewFile,BufRead *.t			set ft=tads

" Tags
au BufNewFile,BufRead tags			set ft=tags

" TAK
au BufNewFile,BufRead *.tak			set ft=tak

" Tcl
au BufNewFile,BufRead *.tcl,*.tk,*.itcl,*.itk	set ft=tcl

" TealInfo
au BufNewFile,BufRead *.tli			set ft=tli

" Telix Salt
au BufNewFile,BufRead *.slt			set ft=tsalt

" TeX
au BufNewFile,BufRead *.tex,*.latex,*.sty,*.dtx,*.ltx	set ft=tex

" Texinfo
au BufNewFile,BufRead *.texinfo,*.texi,*.txi	set ft=texinfo

" TeX configuration
au BufNewFile,BufRead texmf.cnf			set ft=texmf

" TSS - Geometry
au BufNewFile,BufReadPost *.tssgm		set ft=tssgm

" TSS - Optics
au BufNewFile,BufReadPost *.tssop		set ft=tssop

" TSS - Command Line (temporary)
au BufNewFile,BufReadPost *.tsscl		set ft=tsscl

" TF mud client
au BufNewFile,BufRead *.tf			set ft=tf

" Motif UIT/UIL files
au BufNewFile,BufRead *.uit,*.uil		set ft=uil

" UnrealScript
au BufNewFile,BufRead *.uc			set ft=uc

" Verilog HDL
au BufNewFile,BufRead *.v			set ft=verilog

" VHDL
au BufNewFile,BufRead *.hdl,*.vhd,*.vhdl,*.vhdl_[0-9]*,*.vbe,*.vst  set ft=vhdl

" Vim Help file
if has("mac")
  au BufNewFile,BufRead *[/:]vim*[/:]doc[/:]*.txt,*[/:]runtime[/:]doc[/:]*.txt set ft=help
else
  au BufNewFile,BufRead */vim*/doc/*.txt,*/runtime/doc/*.txt	set ft=help
endif

" Vim script
au BufNewFile,BufRead *vimrc*,*.vim,.exrc,_exrc set ft=vim

" Viminfo file
au BufNewFile,BufRead .viminfo,_viminfo		set ft=viminfo

" Virata Config Script File
au BufRead,BufNewFile *.hw,*.module,*.pkg	set ft=virata

" Visual Basic (also uses *.bas) or FORM
au BufNewFile,BufRead *.frm			call FTCheck_VB("form")

" Vgrindefs file
au BufNewFile,BufRead vgrindefs			set ft=vgrindefs

" VRML V1.0c
au BufNewFile,BufRead *.wrl			set ft=vrml

" Webmacro
au BufNewFile,BufRead *.wm			set ft=webmacro

" Website MetaLanguage
au BufNewFile,BufRead *.wml			set ft=wml

" Winbatch
au BufNewFile,BufRead *.wbt			set ft=winbatch

" CVS commit file
au BufNewFile,BufRead cvs\d\+			set ft=cvs

" WEB (*.web is also used for Winbatch: Guess, based on expecting "%" comment
" lines in a WEB file).
au BufNewFile,BufRead *.web			if getline(1)[0].getline(2)[0].getline(3)[0].getline(4)[0].getline(5)[0] =~ "%" | set ft=web | else | set ft=winbatch | endif

" Windows Scripting Host and Windows Script Component
au BufNewFile,BufRead *.ws[fc]			set ft=wsh

" X Pixmap (dynamically sets colors, use BufEnter to make it work better)
au BufEnter *.xpm				if getline(1) =~ "XPM2"|set ft=xpm2|else|set ft=xpm|endif
au BufEnter *.xpm2				set ft=xpm2

" XS Perl extension interface language
au BufEnter *.xs				set ft=xs

" X Keyboard Extensions
au BufNewFile,BufRead *X11*/xkb/*
	\ if expand("<afile>:t") !~ '\.' |
	\   set ft=xkb |
	\ endif

" X resources file
au BufNewFile,BufRead .Xdefaults,.Xresources,Xresources*,*/app-defaults/*,*/Xresources/*,xdm-config set ft=xdefaults

" Xmath
au BufNewFile,BufRead *.msc,*.msf		set ft=xmath
au BufNewFile,BufRead *.ms			if !FTCheck_nroff() | set ft=xmath | endif

" vim: ts=8
" XML
au BufNewFile,BufRead *.xsl			set ft=xml
au BufNewFile,BufRead *.xml
	\ if getline(1) =~ '<!DOCTYPE.*DocBook' || getline(2) =~ '<!DOCTYPE.*DocBook' |
	\   let b:docbk_type="xml" |
	\   set ft=docbk |
	\ else |
	\   set ft=xml |
	\ endif

" Yacc
au BufNewFile,BufRead *.y			set ft=yacc

" Z80 assembler asz80
au BufNewFile,BufRead *.z8a			set ft=z8a

augroup END


" Source the user-specified filetype file
if exists("myfiletypefile") && file_readable(expand(myfiletypefile))
  execute "source " . myfiletypefile
endif


" Check for "*" after loading myfiletypefile, so that scripts.vim is only used
" when there are no matching file name extensions.
augroup filetype
  au BufNewFile,BufRead,StdinReadPost *		if !did_filetype()|so <sfile>:p:h/scripts.vim|endif


" Extra checks for when no filetype has been detected now

" Printcap and Termcap
au BufNewFile,BufRead *printcap*		if !did_filetype()|let b:ptcap_type = "print"|set ft=ptcap|endif
au BufNewFile,BufRead *termcap*			if !did_filetype()|let b:ptcap_type = "term"|set ft=ptcap|endif

" Crontab
au BufNewFile,BufRead crontab.*			if !did_filetype()|set ft=crontab|endif

" GTK RC
au BufNewFile,BufRead .gtkrc*,gtkrc*		set ft=gtkrc


augroup END


" If the GUI is already running, may still need to install the Syntax menu.
" Don't do it when the 'M' flag is included in 'guioptions'
if has("gui_running") && !exists("did_install_syntax_menu") && &guioptions !~# "M"
  source <sfile>:p:h/menu.vim
endif

" Restore 'cpoptions'
let &cpo = ft_cpo_save
unlet ft_cpo_save


endif " !exists("did_load_filetypes")

" vim: ts=8
