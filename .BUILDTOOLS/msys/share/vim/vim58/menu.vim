" These menu commands create the default Vim menus.
" You can also use this as a start for your own set of menus.
" Note that ":amenu" is often used to make a menu work in all modes.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2001 May 06

" Make sure the '<' and 'C' flags are not included in 'cpoptions', otherwise
" <CR> would not be recognized.  See ":help 'cpoptions'".
let menu_cpo_save = &cpo
let &cpo = ""

" Avoid installing the menus twice
if !exists("did_install_default_menus")
let did_install_default_menus = 1

" Help menu
amenu 9999.10 &Help.&Overview<Tab><F1>		:help<CR>
amenu 9999.20 &Help.&How-to\ links		:help how-to<CR>
amenu 9999.30 &Help.&GUI			:help gui<CR>
amenu 9999.40 &Help.&Credits			:help credits<CR>
amenu 9999.50 &Help.Co&pying			:help uganda<CR>
amenu 9999.55 &Help.-sep-			<nul>
amenu 9999.60 &Help.&Version			:version<CR>
amenu 9999.70 &Help.&About			:intro<CR>

" File menu
amenu 10.310 &File.&Open\.\.\.<Tab>:e		:browse confirm e<CR>
amenu 10.320 &File.Sp&lit-Open\.\.\.<Tab>:sp	:browse sp<CR>
amenu 10.330 &File.&Close<Tab>:q		:confirm q<CR>
amenu 10.335 &File.-SEP1-			:
amenu 10.340 &File.&Save<Tab>:w			:confirm w<CR>
amenu 10.350 &File.Save\ &As\.\.\.<Tab>:w	:browse confirm w<CR>
amenu 10.355 &File.-SEP2-			:
if has("win32")
  " Use Notepad for printing. ":w >> prn" doesn't work for PostScript printers.
  amenu 10.360 &File.&Print			:call Win32Print(":")<CR>
  vunmenu &File.&Print
  vmenu &File.&Print				<Esc>:call Win32Print(":'<,'>")<CR>
  if !exists("*Win32Print")
    fun Win32Print(range)
      let mod_save = &mod
      let ff_save = &ff
      set ff=dos
      let ttt = tempname()
      exec a:range . "w! " . ttt
      let &ff = ff_save
      let &mod = mod_save
      exec "!notepad /p " . ttt
      exec "!del " . ttt
    endfun
  endif
elseif has("unix")
  amenu 10.360 &File.&Print			:w !lpr<CR>
  vunmenu &File.&Print
  vmenu &File.&Print				:w !lpr<CR>
endif
amenu 10.365 &File.-SEP3-			:
amenu 10.370 &File.Sa&ve-Exit<Tab>:wqa		:confirm wqa<CR>
amenu 10.380 &File.E&xit<Tab>:qa		:confirm qa<CR>


" Edit menu
amenu 20.310 &Edit.&Undo<Tab>u			u
amenu 20.320 &Edit.&Redo<Tab>^R			<C-R>
amenu 20.330 &Edit.Repea&t<Tab>\.		.
amenu 20.335 &Edit.-SEP1-			:
vmenu 20.340 &Edit.Cu&t<Tab>"*x			"*x
vmenu 20.350 &Edit.&Copy<Tab>"*y		"*y
nmenu 20.360 &Edit.&Paste<Tab>"*p		"*p
vmenu	     &Edit.&Paste<Tab>"*p		"*P`]:if col(".")!=1<Bar>exe "norm l"<Bar>endif<CR>
imenu	     &Edit.&Paste<Tab>"*p		<Esc>:if col(".")!=1<Bar>exe 'norm "*p'<Bar>else<Bar>exe 'norm "*P'<Bar>endif<CR>`]a
cmenu	     &Edit.&Paste<Tab>"*p		<C-R>*
nmenu 20.370 &Edit.Put\ &Before<Tab>[p		[p
imenu	     &Edit.Put\ &Before<Tab>[p		<C-O>[p
nmenu 20.380 &Edit.Put\ &After<Tab>]p		]p
imenu	     &Edit.Put\ &After<Tab>]p		<C-O>]p
if has("win32")
  vmenu 20.390 &Edit.&Delete<Tab>x		x
endif
amenu 20.400 &Edit.&Select\ all<Tab>ggVG	:if &slm != ""<Bar>exe ":norm gggH<C-O>G"<Bar>else<Bar>exe ":norm ggVG"<Bar>endif<CR>
amenu 20.405 &Edit.-SEP2-			:
if has("win32") || has("gui_gtk")
  amenu 20.410 &Edit.&Find\.\.\.		:promptfind<CR>
  amenu 20.420 &Edit.Find\ and\ R&eplace\.\.\.	:promptrepl<CR>
  vunmenu      &Edit.Find\ and\ R&eplace\.\.\.
  vmenu	       &Edit.Find\ and\ R&eplace\.\.\.	y:promptrepl <C-R>"<CR>
else
  amenu 20.410 &Edit.&Find<Tab>/			/
  amenu 20.420 &Edit.Find\ and\ R&eplace<Tab>:%s	:%s/
  vunmenu      &Edit.Find\ and\ R&eplace
  vmenu	       &Edit.Find\ and\ R&eplace<Tab>:s		:s/
endif
amenu 20.425 &Edit.-SEP3-			:
amenu 20.430 &Edit.Options\.\.\.		:options<CR>

" Programming menu
amenu 40.300 &Tools.&Jump\ to\ this\ tag<Tab>g^] g<C-]>
vunmenu &Tools.&Jump\ to\ this\ tag<Tab>g^]
vmenu &Tools.&Jump\ to\ this\ tag<Tab>g^]	g<C-]>
amenu 40.310 &Tools.Jump\ &back<Tab>^T		<C-T>
amenu 40.320 &Tools.Build\ &Tags\ File		:!ctags -R .<CR>
amenu 40.330 &Tools.-SEP1-			:
amenu 40.340 &Tools.&Make<Tab>:make		:make<CR>
amenu 40.350 &Tools.&List\ Errors<Tab>:cl	:cl<CR>
amenu 40.360 &Tools.L&ist\ Messages<Tab>:cl!	:cl!<CR>
amenu 40.370 &Tools.&Next\ Error<Tab>:cn	:cn<CR>
amenu 40.380 &Tools.&Previous\ Error<Tab>:cp	:cp<CR>
amenu 40.390 &Tools.&Older\ List<Tab>:cold	:colder<CR>
amenu 40.400 &Tools.N&ewer\ List<Tab>:cnew	:cnewer<CR>


" Can't delete a menu in Athena version
if has("gui_athena")
  let no_buffers_menu = 1
endif

if !exists("no_buffers_menu")

" Buffer list menu -- Setup functions & actions

" wait with building the menu until after loading 'session' files. Makes
" startup faster.
let bmenu_wait = 1

if !exists("bmenu_priority")
    let bmenu_priority = 60
endif

func! BmenuAdd()
    if g:bmenu_wait == 0
	call BMenuFilename(expand("<afile>"), expand("<abuf>"))
    endif
endfunc

func! BmenuRemove()
    if g:bmenu_wait == 0
	let munge = BmenuMunge(expand("<afile>"), expand("<abuf>"))

	if g:bmenu_short == 0
	    exe 'aun &Buffers.' . munge
	else
	    exe 'aun &Buffers.' . BmenuHash2(munge) . munge
	endif
	let g:bmenu_count = g:bmenu_count - 1
    endif
endfunc

" buffer menu stuff
func! BmenuShow(...)
    let g:bmenu_wait = 1
    let g:bmenu_short = 1
    let g:bmenu_count = 0
    if !exists('g:bmenu_cutoff')
	let g:bmenu_cutoff = &lines / 2
    endif
    " remove old menu, if exists
    exe g:bmenu_priority . 'am &Buffers.x x'
    aun &Buffers

    " get new priority, if exists
    if a:0 == 1
	let g:bmenu_priority = a:1
    endif

    " create new menu; make 'cpo' empty to include the <CR>
    let cpo_save = &cpo
    let &cpo = ""
    exe 'am ' . g:bmenu_priority . ".2 &Buffers.Refresh :call BmenuShow()<CR>"
    exe 'am ' . g:bmenu_priority . ".4 &Buffers.Delete :bd<CR>"
    exe 'am ' . g:bmenu_priority . ".6 &Buffers.Alternate :b #<CR>"
    exe 'am ' . g:bmenu_priority . ".8 &Buffers.-SEP- :"
    let &cpo = cpo_save

    " figure out how many buffers there are
    let buf = 1
    while buf <= bufnr('$')
	if bufexists(buf)
	    let g:bmenu_count = g:bmenu_count + 1
	endif
	let buf = buf + 1
    endwhile
    if g:bmenu_count < g:bmenu_cutoff
	let g:bmenu_short = 0
    endif

    " iterate through buffer list, adding each buffer to the menu:
    let buf = 1
    while buf <= bufnr('$')
	if bufexists(buf)
	    call BMenuFilename(bufname(buf), buf)
	endif
	let buf = buf + 1
    endwhile
    let g:bmenu_wait = 0
    aug buffer_list
	au!
	au BufCreate,BufFilePost * call BmenuAdd()
	au BufDelete,BufFilePre * call BmenuRemove()
    aug END
endfunc

func! BmenuHash(name)
    " Make name all upper case, so that chars are between 32 and 96
    let nm = substitute(a:name, ".*", '\U\0', "")
    " convert first six chars into a number for sorting:
    return (char2nr(nm[0]) - 32) * 0x1000000 + (char2nr(nm[1]) - 32) * 0x40000 + (char2nr(nm[2]) - 32) * 0x1000 + (char2nr(nm[3]) - 32) * 0x40 + (char2nr(nm[4]) - 32) * 0x40 + (char2nr(nm[5]) - 32)
endfunc

func! BmenuHash2(name)
    let nm = substitute(a:name, ".", '\L\0', "")
    if nm[0] >= 'a' && nm[0] <= 'd'
	return '&abcd.'
    elseif nm[0] >= 'e' && nm[0] <= 'h'
	return '&efgh.'
    elseif nm[0] >= 'i' && nm[0] <= 'l'
	return '&ijkl.'
    elseif nm[0] >= 'm' && nm[0] <= 'p'
	return '&mnop.'
    elseif nm[0] >= 'q' && nm[0] <= 't'
	return '&qrst.'
    elseif nm[0] >= 'u' && nm[0] <= 'z'
	return '&u-z.'
    else
	return '&others.'
endfunc

" take a buffer number, return a name to insert into a menu:
func! BMenuFilename(name, num)
    let munge = BmenuMunge(a:name, a:num)
    let hash = BmenuHash(munge)
    if g:bmenu_short == 0
	let name = 'am ' . g:bmenu_priority . '.' . hash .' &Buffers.' . munge
    else
	let name = 'am ' . g:bmenu_priority . '.' . hash . '.' . hash .' &Buffers.' . BmenuHash2(munge) . munge
    endif
    " make 'cpo' empty to include the <CR>
    let cpo_save = &cpo
    let &cpo = ""
    exe name . ' :b' . a:num . '<CR>'
    let &cpo = cpo_save
endfunc

func! BmenuMunge(fname, bnum)
    let name = a:fname
    if name == ''
	let name = '[No File]'
    endif
    let name = fnamemodify(name, ':~')
    if !isdirectory(a:fname)
	" detach file name and separate it out:
	let name2 = fnamemodify(name, ':t')
	if a:bnum >= 0
	    let name2 = name2 . ' (' . a:bnum . ')'
	endif
	let name = name2 . "\t" . fnamemodify(name,':h')
    endif
    let name = escape(name, "\\. \t|")
    let name = substitute(name, "\n", "^@", "g")
    return name
endfunc

" When just starting Vim, load the buffer menu later
if has("vim_starting")
    augroup LoadBufferMenu
        au! VimEnter * if !exists("no_buffers_menu") | call BmenuShow() | endif
	au  VimEnter * au! LoadBufferMenu
    augroup END
else
    call BmenuShow()
endif

endif " !exists("no_buffers_menu")

" Window menu
amenu 70.300 &Window.&New<Tab>^Wn		<C-W>n
amenu 70.310 &Window.S&plit<Tab>^Ws		<C-W>s
amenu 70.320 &Window.Sp&lit\ To\ #<Tab>^W^^	<C-W><C-^>
amenu 70.325 &Window.-SEP1-			:
amenu 70.330 &Window.&Close<Tab>^Wc		:confirm close<CR>
amenu 70.340 &Window.Close\ &Other(s)<Tab>^Wo	:confirm only<CR>
amenu 70.345 &Window.-SEP2-			:
amenu 70.350 &Window.Ne&xt<Tab>^Ww		<C-W>w
amenu 70.360 &Window.P&revious<Tab>^WW		<C-W>W
amenu 70.365 &Window.-SEP3-			:
amenu 70.370 &Window.&Equal\ Height<Tab>^W=	<C-W>=
amenu 70.380 &Window.&Max\ Height<Tab>^W_	<C-W>_
amenu 70.390 &Window.M&in\ Height<Tab>^W1_	<C-W>1_
amenu 70.400 &Window.Rotate\ &Up<Tab>^WR	<C-W>R
amenu 70.410 &Window.Rotate\ &Down<Tab>^Wr	<C-W>r
if has("win32") || has("gui_gtk")
  amenu 70.420 &Window.-SEP4-			:
  amenu 70.430 &Window.Select\ &Font\.\.\.	:set guifont=*<CR>
endif

" The popup menu
amenu 1.10 PopUp.&Undo		u
amenu 1.15 PopUp.-SEP1-		:
vmenu 1.20 PopUp.Cu&t		"*x
vmenu 1.30 PopUp.&Copy		"*y
nmenu 1.40 PopUp.&Paste		"*P`]:if col(".")!=1<Bar>exe "norm l"<Bar>endif<CR>
vmenu 1.40 PopUp.&Paste		"-x"*P`]
imenu 1.40 PopUp.&Paste		<Esc>:if col(".")!=1<Bar>exe 'norm "*p'<Bar>else<Bar>exe 'norm "*P'<Bar>endif<CR>`]a
cmenu 1.40 PopUp.&Paste		<C-R>*
vmenu 1.50 PopUp.&Delete	x
amenu 1.55 PopUp.-SEP2-		:
vmenu 1.60 PopUp.Select\ Blockwise <C-V>
amenu 1.70 PopUp.Select\ &Word	vaw
amenu 1.80 PopUp.Select\ &Line	V
amenu 1.90 PopUp.Select\ &Block	<C-V>
amenu 1.100 PopUp.Select\ &All	ggVG

" The GUI toolbar (for Win32 or GTK)
if has("win32") || has("gui_gtk")
  amenu 1.10 ToolBar.Open	:browse e<CR>
  tmenu ToolBar.Open		Open file
  amenu 1.20 ToolBar.Save	:w<CR>
  tmenu ToolBar.Save		Save current file
  amenu 1.30 ToolBar.SaveAll	:wa<CR>
  tmenu ToolBar.SaveAll		Save all files

  if has("win32")
    amenu 1.40 ToolBar.Print	:call Win32Print(":")<CR>
    vunmenu ToolBar.Print
    vmenu ToolBar.Print		<Esc>:call Win32Print(":'<,'>")<CR>
  else
    amenu 1.40 ToolBar.Print	:w !lpr<CR>
    vunmenu ToolBar.Print
    vmenu ToolBar.Print		<Esc>:w !lpr<CR>
  endif
  tmenu ToolBar.Print		Print

  amenu 1.45 ToolBar.-sep1-	<nul>
  amenu 1.50 ToolBar.Undo	u
  tmenu ToolBar.Undo		Undo
  amenu 1.60 ToolBar.Redo	<C-R>
  tmenu ToolBar.Redo		Redo

  amenu 1.65 ToolBar.-sep2-	<nul>
  vmenu 1.70 ToolBar.Cut	"*x
  tmenu ToolBar.Cut		Cut to clipboard
  vmenu 1.80 ToolBar.Copy	"*y
  tmenu ToolBar.Copy		Copy to clipboard
  nmenu 1.90 ToolBar.Paste	i<C-R>*<Esc>
  vmenu ToolBar.Paste		"-xi<C-R>*<Esc>
  menu! ToolBar.Paste		<C-R>*
  tmenu ToolBar.Paste		Paste from Clipboard

  amenu 1.95 ToolBar.-sep3-	<nul>
  amenu 1.100 ToolBar.Find	:promptfind<CR>
  tmenu ToolBar.Find		Find...
  amenu 1.110 ToolBar.FindNext	n
  tmenu ToolBar.FindNext	Find Next
  amenu 1.120 ToolBar.FindPrev	N
  tmenu ToolBar.FindPrev	Find Previous
  amenu 1.130 ToolBar.Replace	:promptrepl<CR>
  vunmenu ToolBar.Replace
  vmenu ToolBar.Replace		y:promptrepl <C-R>"<CR>
  tmenu ToolBar.Replace		Find & Replace...

if 0	" disabled; These are in the Windows menu
  amenu 1.135 ToolBar.-sep4-	<nul>
  amenu 1.140 ToolBar.New	<C-W>n
  tmenu ToolBar.New		New Window
  amenu 1.150 ToolBar.WinSplit	<C-W>s
  tmenu ToolBar.WinSplit	Split Window
  amenu 1.160 ToolBar.WinMax	:resize 200<CR>
  tmenu ToolBar.WinMax		Maximise Window
  amenu 1.170 ToolBar.WinMin	:resize 1<CR>
  tmenu ToolBar.WinMin		Minimise Window
  amenu 1.180 ToolBar.WinClose	:close<CR>
  tmenu ToolBar.WinClose	Close Window
endif

  amenu 1.185 ToolBar.-sep5-	<nul>
  amenu 1.190 ToolBar.LoadSesn	:call LoadVimSesn()<CR>
  tmenu ToolBar.LoadSesn	Load session
  amenu 1.200 ToolBar.SaveSesn	:call SaveVimSesn()<CR>
  tmenu ToolBar.SaveSesn	Save current session
  amenu 1.210 ToolBar.RunScript	:browse so<CR>
  tmenu ToolBar.RunScript	Run a Vim Script

  amenu 1.215 ToolBar.-sep6-	<nul>
  amenu 1.220 ToolBar.Make	:make<CR>
  tmenu ToolBar.Make		Make current project
  amenu 1.230 ToolBar.Shell	:sh<CR>
  tmenu ToolBar.Shell		Open a command shell
  amenu 1.240 ToolBar.RunCtags	:!ctags -R .<CR>
  tmenu ToolBar.RunCtags	Build tags in current directory tree
  amenu 1.250 ToolBar.TagJump	g]
  tmenu ToolBar.TagJump		Jump to tag under cursor

  amenu 1.265 ToolBar.-sep7-	<nul>
  amenu 1.270 ToolBar.Help	:help<CR>
  tmenu ToolBar.Help		Vim Help
  if has("gui_gtk")
    amenu 1.280 ToolBar.FindHelp :helpfind<CR>
  else
    amenu 1.280 ToolBar.FindHelp :help 
  endif
  tmenu ToolBar.FindHelp	Search Vim Help

" Select a session to load; default to current session name if present
fun LoadVimSesn()
  if exists("this_session")
    let name = this_session
  else
    let name = "session.vim"
  endif
  execute "browse so " . name
endfun

" Select a session to save; default to current session name if present
fun SaveVimSesn()
  if !exists("this_session")
    let this_session = "session.vim"
  endif
  execute "browse mksession! " . this_session
endfun

endif " has("win32") || has("gui_gtk")

endif " !exists("did_install_default_menus")

" Install the Syntax menu only when filetype.vim has been loaded or when
" manual syntax highlighting is enabled.
" Avoid installing the Syntax menu twice.
if (exists("did_load_filetypes") || exists("syntax_on"))
	\ && !exists("did_install_syntax_menu")
let did_install_syntax_menu = 1

" Define the SetSyn function, used for the Syntax menu entries.
" Set 'filetype' and also 'syntax' if it is manually selected.
fun! SetSyn(name)
  if a:name == "fvwm1"
    let use_fvwm_1 = 1
    let use_fvwm_2 = 0
    let name = "fvwm"
  elseif a:name == "fvwm2"
    let use_fvwm_2 = 1
    let use_fvwm_1 = 0
    let name = "fvwm"
  else
    let name = a:name
  endif
  if !exists("g:syntax_menu_synonly")
    exe "set ft=" . name
    if exists("g:syntax_manual")
      exe "set syn=" . name
    endif
  else
    exe "set syn=" . name
  endif
endfun

" The following menu items are generated by makemenu.vim.
" The Start Of The Syntax Menu

am 50.10.100 &Syntax.AB.Abaqus :cal SetSyn("abaqus")<CR>
am 50.10.110 &Syntax.AB.ABC :cal SetSyn("abc")<CR>
am 50.10.120 &Syntax.AB.ABEL :cal SetSyn("abel")<CR>
am 50.10.130 &Syntax.AB.AceDB :cal SetSyn("acedb")<CR>
am 50.10.140 &Syntax.AB.Ada :cal SetSyn("ada")<CR>
am 50.10.150 &Syntax.AB.Aflex :cal SetSyn("aflex")<CR>
am 50.10.160 &Syntax.AB.AHDL :cal SetSyn("ahdl")<CR>
am 50.10.170 &Syntax.AB.Amiga\ DOS :cal SetSyn("amiga")<CR>
am 50.10.180 &Syntax.AB.Antlr :cal SetSyn("antlr")<CR>
am 50.10.190 &Syntax.AB.Apache\ config :cal SetSyn("apache")<CR>
am 50.10.200 &Syntax.AB.Apache-style\ config :cal SetSyn("apachestyle")<CR>
am 50.10.210 &Syntax.AB.Applix\ ELF :cal SetSyn("elf")<CR>
am 50.10.220 &Syntax.AB.Arc\ Macro\ Language :cal SetSyn("aml")<CR>
am 50.10.230 &Syntax.AB.ASP\ with\ VBSages :cal SetSyn("aspvbs")<CR>
am 50.10.240 &Syntax.AB.ASP\ with\ Perl :cal SetSyn("aspperl")<CR>
am 50.10.250 &Syntax.AB.Assembly.680x0 :cal SetSyn("asm68k")<CR>
am 50.10.260 &Syntax.AB.Assembly.GNU :cal SetSyn("asm")<CR>
am 50.10.270 &Syntax.AB.Assembly.H8300 :cal SetSyn("asmh8300")<CR>
am 50.10.280 &Syntax.AB.Assembly.Intel\ Itanium :cal SetSyn("ia64")<CR>
am 50.10.290 &Syntax.AB.Assembly.Microsoft :cal SetSyn("masm")<CR>
am 50.10.300 &Syntax.AB.Assembly.Netwide :cal SetSyn("nasm")<CR>
am 50.10.310 &Syntax.AB.ASN\.1 :cal SetSyn("asn")<CR>
am 50.10.320 &Syntax.AB.Atlas :cal SetSyn("atlas")<CR>
am 50.10.330 &Syntax.AB.Automake :cal SetSyn("automake")<CR>
am 50.10.340 &Syntax.AB.Avenue :cal SetSyn("ave")<CR>
am 50.10.350 &Syntax.AB.Awk :cal SetSyn("awk")<CR>
am 50.10.360 &Syntax.AB.Ayacc :cal SetSyn("ayacc")<CR>
am 50.10.380 &Syntax.AB.B :cal SetSyn("b")<CR>
am 50.10.390 &Syntax.AB.BASIC :cal SetSyn("basic")<CR>
am 50.10.400 &Syntax.AB.BC\ calculator :cal SetSyn("bc")<CR>
am 50.10.410 &Syntax.AB.BibFile :cal SetSyn("bib")<CR>
am 50.10.420 &Syntax.AB.BIND\ configuration :cal SetSyn("named")<CR>
am 50.10.430 &Syntax.AB.BIND\ zone :cal SetSyn("bindzone")<CR>
am 50.10.440 &Syntax.AB.Blank :cal SetSyn("blank")<CR>
am 50.20.100 &Syntax.CD.C :cal SetSyn("c")<CR>
am 50.20.110 &Syntax.CD.C++ :cal SetSyn("cpp")<CR>
am 50.20.120 &Syntax.CD.Crontab :cal SetSyn("crontab")<CR>
am 50.20.130 &Syntax.CD.Cyn++ :cal SetSyn("cynpp")<CR>
am 50.20.140 &Syntax.CD.Cynlib :cal SetSyn("cynlib")<CR>
am 50.20.150 &Syntax.CD.Cascading\ Style\ Sheets :cal SetSyn("css")<CR>
am 50.20.160 &Syntax.CD.Century\ Term :cal SetSyn("cterm")<CR>
am 50.20.170 &Syntax.CD.CHILL :cal SetSyn("ch")<CR>
am 50.20.180 &Syntax.CD.Change :cal SetSyn("change")<CR>
am 50.20.190 &Syntax.CD.ChangeLog :cal SetSyn("changelog")<CR>
am 50.20.200 &Syntax.CD.Clean :cal SetSyn("clean")<CR>
am 50.20.210 &Syntax.CD.Clever :cal SetSyn("cl")<CR>
am 50.20.220 &Syntax.CD.Clipper :cal SetSyn("clipper")<CR>
am 50.20.230 &Syntax.CD.Cold\ Fusion :cal SetSyn("cf")<CR>
am 50.20.240 &Syntax.CD.Configure\ script :cal SetSyn("config")<CR>
am 50.20.250 &Syntax.CD.Configure\ file :cal SetSyn("cfg")<CR>
am 50.20.260 &Syntax.CD.Csh\ shell\ script :cal SetSyn("csh")<CR>
am 50.20.270 &Syntax.CD.Ctrl-H :cal SetSyn("ctrlh")<CR>
am 50.20.280 &Syntax.CD.Cobol :cal SetSyn("cobol")<CR>
am 50.20.290 &Syntax.CD.CSP :cal SetSyn("csp")<CR>
am 50.20.300 &Syntax.CD.CUPL :cal SetSyn("cupl")<CR>
am 50.20.310 &Syntax.CD.CUPL\ simulation :cal SetSyn("cuplsim")<CR>
am 50.20.320 &Syntax.CD.CVS\ commit :cal SetSyn("cvs")<CR>
am 50.20.330 &Syntax.CD.CWEB :cal SetSyn("cweb")<CR>
am 50.20.350 &Syntax.CD.Diff :cal SetSyn("diff")<CR>
am 50.20.360 &Syntax.CD.Digital\ Command\ Lang :cal SetSyn("dcl")<CR>
am 50.20.370 &Syntax.CD.Diva\ (with\ SKILL) :cal SetSyn("diva")<CR>
am 50.20.380 &Syntax.CD.DNS :cal SetSyn("dns")<CR>
am 50.20.390 &Syntax.CD.Dracula :cal SetSyn("dracula")<CR>
am 50.20.400 &Syntax.CD.DTD :cal SetSyn("dtd")<CR>
am 50.20.420 &Syntax.CD.Zope\ DTML :cal SetSyn("dtml")<CR>
am 50.20.440 &Syntax.CD.Debian\ Changelog :cal SetSyn("debchangelog")<CR>
am 50.20.450 &Syntax.CD.Debian\ Control :cal SetSyn("debcontrol")<CR>
am 50.20.460 &Syntax.CD.Dylan :cal SetSyn("dylan")<CR>
am 50.20.470 &Syntax.CD.Dylan\ intr :cal SetSyn("dylanintr")<CR>
am 50.20.480 &Syntax.CD.Dylan\ lid :cal SetSyn("dylanlid")<CR>
am 50.30.100 &Syntax.EFGH.Eiffel :cal SetSyn("eiffel")<CR>
am 50.30.110 &Syntax.EFGH.Elm\ Filter :cal SetSyn("elmfilt")<CR>
am 50.30.120 &Syntax.EFGH.Embedix\ Component\ Description :cal SetSyn("ecd")<CR>
am 50.30.130 &Syntax.EFGH.ERicsson\ LANGuage :cal SetSyn("erlang")<CR>
am 50.30.140 &Syntax.EFGH.ESQL-C :cal SetSyn("esqlc")<CR>
am 50.30.150 &Syntax.EFGH.Essbase\ script :cal SetSyn("csc")<CR>
am 50.30.160 &Syntax.EFGH.Expect :cal SetSyn("expect")<CR>
am 50.30.170 &Syntax.EFGH.Exports :cal SetSyn("exports")<CR>
am 50.30.190 &Syntax.EFGH.Focus\ Executable :cal SetSyn("focexec")<CR>
am 50.30.200 &Syntax.EFGH.Focus\ Master :cal SetSyn("master")<CR>
am 50.30.210 &Syntax.EFGH.FORM :cal SetSyn("form")<CR>
am 50.30.220 &Syntax.EFGH.Forth :cal SetSyn("forth")<CR>
am 50.30.230 &Syntax.EFGH.Fortran :cal SetSyn("fortran")<CR>
am 50.30.240 &Syntax.EFGH.FoxPro :cal SetSyn("foxpro")<CR>
am 50.30.250 &Syntax.EFGH.Fvwm\ configuration :cal SetSyn("fvwm1")<CR>
am 50.30.260 &Syntax.EFGH.Fvwm2\ configuration :cal SetSyn("fvwm2")<CR>
am 50.30.280 &Syntax.EFGH.GDB\ command\ file :cal SetSyn("gdb")<CR>
am 50.30.290 &Syntax.EFGH.GDMO :cal SetSyn("gdmo")<CR>
am 50.30.300 &Syntax.EFGH.Gedcom :cal SetSyn("gedcom")<CR>
am 50.30.310 &Syntax.EFGH.GP :cal SetSyn("gp")<CR>
am 50.30.320 &Syntax.EFGH.GNU\ Server\ Pages :cal SetSyn("gsp")<CR>
am 50.30.330 &Syntax.EFGH.GNUplot :cal SetSyn("gnuplot")<CR>
am 50.30.340 &Syntax.EFGH.GTKrc :cal SetSyn("gtkrc")<CR>
am 50.30.360 &Syntax.EFGH.Haskell :cal SetSyn("haskell")<CR>
am 50.30.370 &Syntax.EFGH.Haskell-literal :cal SetSyn("lhaskell")<CR>
am 50.30.380 &Syntax.EFGH.Hercules :cal SetSyn("hercules")<CR>
am 50.30.390 &Syntax.EFGH.HTML :cal SetSyn("html")<CR>
am 50.30.400 &Syntax.EFGH.HTML\ with\ M4 :cal SetSyn("htmlm4")<CR>
am 50.30.410 &Syntax.EFGH.HTML/OS :cal SetSyn("htmlos")<CR>
am 50.30.420 &Syntax.EFGH.Hyper\ Builder :cal SetSyn("hb")<CR>
am 50.40.100 &Syntax.IJKL.Icon :cal SetSyn("icon")<CR>
am 50.40.110 &Syntax.IJKL.IDL :cal SetSyn("idl")<CR>
am 50.40.120 &Syntax.IJKL.Interactive\ Data\ Lang :cal SetSyn("idlang")<CR>
am 50.40.130 &Syntax.IJKL.Inform :cal SetSyn("inform")<CR>
am 50.40.140 &Syntax.IJKL.Informix\ 4GL :cal SetSyn("fgl")<CR>
am 50.40.150 &Syntax.IJKL.Inittab :cal SetSyn("inittab")<CR>
am 50.40.160 &Syntax.IJKL.Inno\ Setup :cal SetSyn("iss")<CR>
am 50.40.170 &Syntax.IJKL.InstallShield\ Rules :cal SetSyn("ishd")<CR>
am 50.40.190 &Syntax.IJKL.Jam :cal SetSyn("jam")<CR>
am 50.40.200 &Syntax.IJKL.Java :cal SetSyn("java")<CR>
am 50.40.210 &Syntax.IJKL.JavaCC :cal SetSyn("javacc")<CR>
am 50.40.220 &Syntax.IJKL.JavaScript :cal SetSyn("javascript")<CR>
am 50.40.230 &Syntax.IJKL.Java\ Server\ Pages :cal SetSyn("jsp")<CR>
am 50.40.240 &Syntax.IJKL.Java\ Properties :cal SetSyn("jproperties")<CR>
am 50.40.250 &Syntax.IJKL.Jess :cal SetSyn("jess")<CR>
am 50.40.260 &Syntax.IJKL.Jgraph :cal SetSyn("jgraph")<CR>
am 50.40.280 &Syntax.IJKL.KDE\ script :cal SetSyn("kscript")<CR>
am 50.40.290 &Syntax.IJKL.Kimwitu :cal SetSyn("kwt")<CR>
am 50.40.300 &Syntax.IJKL.Kixtart :cal SetSyn("kix")<CR>
am 50.40.320 &Syntax.IJKL.Lace :cal SetSyn("lace")<CR>
am 50.40.330 &Syntax.IJKL.Lamda\ Prolog :cal SetSyn("lprolog")<CR>
am 50.40.340 &Syntax.IJKL.Latte :cal SetSyn("latte")<CR>
am 50.40.350 &Syntax.IJKL.Lex :cal SetSyn("lex")<CR>
am 50.40.360 &Syntax.IJKL.Lilo :cal SetSyn("lilo")<CR>
am 50.40.370 &Syntax.IJKL.Lisp :cal SetSyn("lisp")<CR>
am 50.40.380 &Syntax.IJKL.Lite :cal SetSyn("lite")<CR>
am 50.40.390 &Syntax.IJKL.LOTOS :cal SetSyn("lotos")<CR>
am 50.40.400 &Syntax.IJKL.Lout :cal SetSyn("lout")<CR>
am 50.40.410 &Syntax.IJKL.Lua :cal SetSyn("lua")<CR>
am 50.40.420 &Syntax.IJKL.Lynx\ Style :cal SetSyn("lss")<CR>
am 50.50.100 &Syntax.MNO.M4 :cal SetSyn("m4")<CR>
am 50.50.110 &Syntax.MNO.MaGic\ Point :cal SetSyn("mgp")<CR>
am 50.50.120 &Syntax.MNO.Mail :cal SetSyn("mail")<CR>
am 50.50.130 &Syntax.MNO.Makefile :cal SetSyn("make")<CR>
am 50.50.140 &Syntax.MNO.MakeIndex :cal SetSyn("ist")<CR>
am 50.50.150 &Syntax.MNO.Man\ page :cal SetSyn("man")<CR>
am 50.50.160 &Syntax.MNO.Maple :cal SetSyn("maple")<CR>
am 50.50.170 &Syntax.MNO.Mason :cal SetSyn("mason")<CR>
am 50.50.180 &Syntax.MNO.Mathematica :cal SetSyn("mma")<CR>
am 50.50.190 &Syntax.MNO.Matlab :cal SetSyn("matlab")<CR>
am 50.50.200 &Syntax.MNO.MEL\ (for\ Maya) :cal SetSyn("mel")<CR>
am 50.50.210 &Syntax.MNO.Metafont :cal SetSyn("mf")<CR>
am 50.50.220 &Syntax.MNO.MetaPost :cal SetSyn("mp")<CR>
am 50.50.230 &Syntax.MNO.MS\ Module\ Definition :cal SetSyn("def")<CR>
am 50.50.240 &Syntax.MNO.Model :cal SetSyn("model")<CR>
am 50.50.250 &Syntax.MNO.Modsim\ III :cal SetSyn("modsim3")<CR>
am 50.50.260 &Syntax.MNO.Modula\ 2 :cal SetSyn("modula2")<CR>
am 50.50.270 &Syntax.MNO.Modula\ 3 :cal SetSyn("modula3")<CR>
am 50.50.280 &Syntax.MNO.Msql :cal SetSyn("msql")<CR>
am 50.50.290 &Syntax.MNO.MS-DOS\ \.bat\ file :cal SetSyn("dosbatch")<CR>
am 50.50.300 &Syntax.MNO.4DOS\ \.bat\ file :cal SetSyn("btm")<CR>
am 50.50.310 &Syntax.MNO.MS-DOS\ \.ini\ file :cal SetSyn("dosini")<CR>
am 50.50.320 &Syntax.MNO.MS\ Resource\ file :cal SetSyn("rc")<CR>
am 50.50.330 &Syntax.MNO.Muttrc :cal SetSyn("muttrc")<CR>
am 50.50.350 &Syntax.MNO.Nastran\ input/DMAP :cal SetSyn("nastran")<CR>
am 50.50.360 &Syntax.MNO.Novell\ batch :cal SetSyn("ncf")<CR>
am 50.50.370 &Syntax.MNO.Not\ Quite\ C :cal SetSyn("nqc")<CR>
am 50.50.380 &Syntax.MNO.Nroff :cal SetSyn("nroff")<CR>
am 50.50.400 &Syntax.MNO.Objective\ C :cal SetSyn("objc")<CR>
am 50.50.410 &Syntax.MNO.OCAML :cal SetSyn("ocaml")<CR>
am 50.50.420 &Syntax.MNO.Omnimark :cal SetSyn("omnimark")<CR>
am 50.50.430 &Syntax.MNO.OpenROAD :cal SetSyn("openroad")<CR>
am 50.50.440 &Syntax.MNO.Open\ Psion\ Lang :cal SetSyn("opl")<CR>
am 50.50.450 &Syntax.MNO.Oracle\ config :cal SetSyn("ora")<CR>
am 50.60.100 &Syntax.PQR.PApp :cal SetSyn("papp")<CR>
am 50.60.110 &Syntax.PQR.Pascal :cal SetSyn("pascal")<CR>
am 50.60.120 &Syntax.PQR.PCCTS :cal SetSyn("pccts")<CR>
am 50.60.130 &Syntax.PQR.PPWizard :cal SetSyn("ppwiz")<CR>
am 50.60.140 &Syntax.PQR.Perl :cal SetSyn("perl")<CR>
am 50.60.150 &Syntax.PQR.Perl\ POD :cal SetSyn("pod")<CR>
am 50.60.160 &Syntax.PQR.Perl\ XS :cal SetSyn("xs")<CR>
am 50.60.170 &Syntax.PQR.PHP\ 3-4 :cal SetSyn("php")<CR>
am 50.60.180 &Syntax.PQR.Phtml :cal SetSyn("phtml")<CR>
am 50.60.190 &Syntax.PQR.PIC\ assembly :cal SetSyn("pic")<CR>
am 50.60.200 &Syntax.PQR.Pike :cal SetSyn("pike")<CR>
am 50.60.210 &Syntax.PQR.Pine\ RC :cal SetSyn("pine")<CR>
am 50.60.220 &Syntax.PQR.PL/SQL :cal SetSyn("plsql")<CR>
am 50.60.230 &Syntax.PQR.PO\ (GNU\ gettext) :cal SetSyn("po")<CR>
am 50.60.240 &Syntax.PQR.Postfix\ main\ config :cal SetSyn("pfmain")<CR>
am 50.60.250 &Syntax.PQR.PostScript :cal SetSyn("postscr")<CR>
am 50.60.260 &Syntax.PQR.Povray :cal SetSyn("pov")<CR>
am 50.60.270 &Syntax.PQR.Printcap :cal SetSyn("pcap")<CR>
am 50.60.280 &Syntax.PQR.Procmail :cal SetSyn("procmail")<CR>
am 50.60.290 &Syntax.PQR.Progress :cal SetSyn("progress")<CR>
am 50.60.300 &Syntax.PQR.Product\ Spec\ File :cal SetSyn("psf")<CR>
am 50.60.310 &Syntax.PQR.Prolog :cal SetSyn("prolog")<CR>
am 50.60.320 &Syntax.PQR.Purify\ log :cal SetSyn("purifylog")<CR>
am 50.60.330 &Syntax.PQR.Python :cal SetSyn("python")<CR>
am 50.60.350 &Syntax.PQR.R :cal SetSyn("r")<CR>
am 50.60.360 &Syntax.PQR.Radiance :cal SetSyn("radiance")<CR>
am 50.60.370 &Syntax.PQR.RCS\ log\ output :cal SetSyn("rcslog")<CR>
am 50.60.380 &Syntax.PQR.Rebol :cal SetSyn("rebol")<CR>
am 50.60.390 &Syntax.PQR.Registry\ of\ MS-Windows :cal SetSyn("registry")<CR>
am 50.60.400 &Syntax.PQR.Remind :cal SetSyn("remind")<CR>
am 50.60.410 &Syntax.PQR.Renderman\ Shader\ Lang :cal SetSyn("sl")<CR>
am 50.60.420 &Syntax.PQR.Rexx :cal SetSyn("rexx")<CR>
am 50.60.430 &Syntax.PQR.Robots\.txt :cal SetSyn("robots")<CR>
am 50.60.440 &Syntax.PQR.Rpcgen :cal SetSyn("rpcgen")<CR>
am 50.60.450 &Syntax.PQR.RTF :cal SetSyn("rtf")<CR>
am 50.60.460 &Syntax.PQR.Ruby :cal SetSyn("ruby")<CR>
am 50.70.100 &Syntax.S.S-lang :cal SetSyn("slang")<CR>
am 50.70.110 &Syntax.S.Samba\ config :cal SetSyn("samba")<CR>
am 50.70.120 &Syntax.S.SAS :cal SetSyn("sas")<CR>
am 50.70.130 &Syntax.S.Sather :cal SetSyn("sather")<CR>
am 50.70.140 &Syntax.S.Scheme :cal SetSyn("scheme")<CR>
am 50.70.150 &Syntax.S.SDL :cal SetSyn("sdl")<CR>
am 50.70.160 &Syntax.S.Sed :cal SetSyn("sed")<CR>
am 50.70.170 &Syntax.S.Sendmail\.cf :cal SetSyn("sm")<CR>
am 50.70.180 &Syntax.S.SETL :cal SetSyn("setl")<CR>
am 50.70.190 &Syntax.S.SGML\ DTD :cal SetSyn("sgml")<CR>
am 50.70.200 &Syntax.S.SGML\ Declarations :cal SetSyn("sgmldecl")<CR>
am 50.70.210 &Syntax.S.SGML\ linuxdoc :cal SetSyn("sgmllnx")<CR>
am 50.70.220 &Syntax.S.Sh\ shell\ script :cal SetSyn("sh")<CR>
am 50.70.230 &Syntax.S.SiCAD :cal SetSyn("sicad")<CR>
am 50.70.240 &Syntax.S.Simula :cal SetSyn("simula")<CR>
am 50.70.250 &Syntax.S.Sinda\ compare :cal SetSyn("sindacmp")<CR>
am 50.70.260 &Syntax.S.Sinda\ input :cal SetSyn("sinda")<CR>
am 50.70.270 &Syntax.S.Sinda\ output :cal SetSyn("sindaout")<CR>
am 50.70.280 &Syntax.S.SKILL :cal SetSyn("skill")<CR>
am 50.70.290 &Syntax.S.SLRN\ rc :cal SetSyn("slrnrc")<CR>
am 50.70.300 &Syntax.S.SLRN\ score :cal SetSyn("slrnsc")<CR>
am 50.70.310 &Syntax.S.SmallTalk :cal SetSyn("st")<CR>
am 50.70.320 &Syntax.S.SMIL :cal SetSyn("smil")<CR>
am 50.70.330 &Syntax.S.SMITH :cal SetSyn("smith")<CR>
am 50.70.340 &Syntax.S.SNMP\ MIB :cal SetSyn("mib")<CR>
am 50.70.350 &Syntax.S.SNNS\ network :cal SetSyn("snnsnet")<CR>
am 50.70.360 &Syntax.S.SNNS\ pattern :cal SetSyn("snnspat")<CR>
am 50.70.370 &Syntax.S.SNNS\ result :cal SetSyn("snnsres")<CR>
am 50.70.380 &Syntax.S.Snobol4 :cal SetSyn("snobol4")<CR>
am 50.70.390 &Syntax.S.Snort\ Configuration :cal SetSyn("hog")<CR>
am 50.70.400 &Syntax.S.SPEC\ (Linux\ RPM) :cal SetSyn("spec")<CR>
am 50.70.410 &Syntax.S.Spice :cal SetSyn("spice")<CR>
am 50.70.420 &Syntax.S.Speedup :cal SetSyn("spup")<CR>
am 50.70.430 &Syntax.S.Squid :cal SetSyn("squid")<CR>
am 50.70.440 &Syntax.S.SQL :cal SetSyn("sql")<CR>
am 50.70.450 &Syntax.S.SQR :cal SetSyn("sqr")<CR>
am 50.70.460 &Syntax.S.Standard\ ML :cal SetSyn("sml")<CR>
am 50.70.470 &Syntax.S.Stored\ Procedures :cal SetSyn("stp")<CR>
am 50.70.480 &Syntax.S.Strace :cal SetSyn("strace")<CR>
am 50.80.100 &Syntax.TUV.Tads :cal SetSyn("tads")<CR>
am 50.80.110 &Syntax.TUV.Tags :cal SetSyn("tags")<CR>
am 50.80.120 &Syntax.TUV.TAK\ compare :cal SetSyn("tak")<CR>
am 50.80.130 &Syntax.TUV.TAK\ input :cal SetSyn("tak")<CR>
am 50.80.140 &Syntax.TUV.TAK\ output :cal SetSyn("takout")<CR>
am 50.80.150 &Syntax.TUV.Tcl/Tk :cal SetSyn("tcl")<CR>
am 50.80.160 &Syntax.TUV.TealInfo :cal SetSyn("tli")<CR>
am 50.80.170 &Syntax.TUV.Telix\ Salt :cal SetSyn("tsalt")<CR>
am 50.80.180 &Syntax.TUV.Termcap :cal SetSyn("ptcap")<CR>
am 50.80.190 &Syntax.TUV.TeX :cal SetSyn("tex")<CR>
am 50.80.200 &Syntax.TUV.Texinfo :cal SetSyn("texinfo")<CR>
am 50.80.210 &Syntax.TUV.TeX\ configuration :cal SetSyn("texmf")<CR>
am 50.80.220 &Syntax.TUV.TF\ mud\ client :cal SetSyn("tf")<CR>
am 50.80.230 &Syntax.TUV.Trasys\ input :cal SetSyn("trasys")<CR>
am 50.80.240 &Syntax.TUV.TSS.Command\ Line :cal SetSyn("tsscl")<CR>
am 50.80.250 &Syntax.TUV.TSS.Geometry :cal SetSyn("tssgm")<CR>
am 50.80.260 &Syntax.TUV.TSS.Optics :cal SetSyn("tssop")<CR>
am 50.80.270 &Syntax.TUV.Turbo\ assembly :cal SetSyn("tasm")<CR>
am 50.80.290 &Syntax.TUV.UIT/UIL :cal SetSyn("uil")<CR>
am 50.80.300 &Syntax.TUV.UnrealScript :cal SetSyn("uc")<CR>
am 50.80.320 &Syntax.TUV.Verilog\ HDL :cal SetSyn("verilog")<CR>
am 50.80.330 &Syntax.TUV.Vgrindefs :cal SetSyn("vgrindefs")<CR>
am 50.80.340 &Syntax.TUV.VHDL :cal SetSyn("vhdl")<CR>
am 50.80.350 &Syntax.TUV.Vim\ help\ file :cal SetSyn("help")<CR>
am 50.80.360 &Syntax.TUV.Vim\ script :cal SetSyn("vim")<CR>
am 50.80.370 &Syntax.TUV.Viminfo\ file :cal SetSyn("viminfo")<CR>
am 50.80.380 &Syntax.TUV.Virata :cal SetSyn("virata")<CR>
am 50.80.390 &Syntax.TUV.Visual\ Basic :cal SetSyn("vb")<CR>
am 50.80.400 &Syntax.TUV.VRML :cal SetSyn("vrml")<CR>
am 50.80.410 &Syntax.TUV.VSE\ JCL :cal SetSyn("vsejcl")<CR>
am 50.90.100 &Syntax.WXYZ.WEB :cal SetSyn("web")<CR>
am 50.90.110 &Syntax.WXYZ.Webmacro :cal SetSyn("webmacro")<CR>
am 50.90.120 &Syntax.WXYZ.Website\ MetaLanguage :cal SetSyn("wml")<CR>
am 50.90.130 &Syntax.WXYZ.Wdiff :cal SetSyn("wdiff")<CR>
am 50.90.140 &Syntax.WXYZ.Whitespace\ (add) :cal SetSyn("whitespace")<CR>
am 50.90.150 &Syntax.WXYZ.WinBatch/Webbatch :cal SetSyn("winbatch")<CR>
am 50.90.160 &Syntax.WXYZ.Windows\ Scripting\ Host :cal SetSyn("wsh")<CR>
am 50.90.180 &Syntax.WXYZ.X\ Keyboard\ Extension :cal SetSyn("xkb")<CR>
am 50.90.190 &Syntax.WXYZ.X\ Pixmap :cal SetSyn("xpm")<CR>
am 50.90.200 &Syntax.WXYZ.X\ Pixmap\ (2) :cal SetSyn("xpm2")<CR>
am 50.90.210 &Syntax.WXYZ.X\ resources :cal SetSyn("xdefaults")<CR>
am 50.90.220 &Syntax.WXYZ.Xmath :cal SetSyn("xmath")<CR>
am 50.90.230 &Syntax.WXYZ.XML :cal SetSyn("xml")<CR>
am 50.90.240 &Syntax.WXYZ.XXD\ hex\ dump :cal SetSyn("xxd")<CR>
am 50.90.260 &Syntax.WXYZ.Yacc :cal SetSyn("yacc")<CR>
am 50.90.280 &Syntax.WXYZ.Z-80\ assembler :cal SetSyn("z8a")<CR>
am 50.90.290 &Syntax.WXYZ.Zsh\ shell\ script :cal SetSyn("zsh")<CR>

" The End Of The Syntax Menu


am 50.95 &Syntax.-SEP1-				:

am 50.100 &Syntax.Set\ 'syntax'\ only		:let syntax_menu_synonly=1<CR>
am 50.101 &Syntax.Set\ 'filetype'\ too		:call SmenuNosynonly()<CR>
fun! SmenuNosynonly()
  if exists("syntax_menu_synonly")
    unlet syntax_menu_synonly
  endif
endfun

am 50.110 &Syntax.&Off			:syn off<CR>
am 50.112 &Syntax.&Manual		:syn manual<CR>
am 50.114 &Syntax.A&utomatic		:syn on<CR>

am 50.116 &Syntax.&on\ (this\ file)	:call SmenuSynoff()<CR>
fun! SmenuSynoff()
  if !exists("syntax_on")
    syn manual
  endif
  set syn=ON
endfun
am 50.118 &Syntax.o&ff\ (this\ file)	:syn clear<CR>

am 50.700 &Syntax.-SEP3-		:
am 50.710 &Syntax.Co&lor\ test		:sp $VIMRUNTIME/syntax/colortest.vim<Bar>so %<CR>
am 50.720 &Syntax.&Highlight\ test	:so $VIMRUNTIME/syntax/hitest.vim<CR>
am 50.730 &Syntax.&Convert\ to\ HTML	:so $VIMRUNTIME/syntax/2html.vim<CR>

endif " !exists("did_install_syntax_menu")

" Restore the previous value of 'cpoptions'.
let &cpo = menu_cpo_save
unlet menu_cpo_save
