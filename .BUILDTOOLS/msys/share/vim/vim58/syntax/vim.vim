" Vim syntax file
" Language:	Vim 5.7 script
" Maintainer:	Dr. Charles E. Campbell, Jr. <Charles.E.Campbell.1@gsfc.nasa.gov>
" Last Change:	June 27, 2000
" Version:	5.7-01

" Remove old syntax
syn clear

" vimTodo: contains common special-notices for comments
"          Use the vimCommentGroup cluster to add your own.
syn keyword vimTodo contained	COMBAK	NOT	RELEASED	TODO
syn cluster vimCommentGroup	contains=vimTodo

" regular vim commands
syn keyword vimCommand contained	N[ext]	comc[lear]	inoremenu	perld[o]	star[tinsert]
syn keyword vimCommand contained	P[rint]	con[tinue]	is[earch]	po[p]	stj[ump]
syn keyword vimCommand contained	X	conf[irm]	isp[lit]	pp[op]	sts[elect]
syn keyword vimCommand contained	a[ppend]	cp[revious]	iu[nmap]	pre[serve]	sun[hide]
syn keyword vimCommand contained	ab[breviate]	cq[uit]	iuna[bbrev]	prev[ious]	sus[pend]
syn keyword vimCommand contained	abc[lear]	cr[ewind]	iunme	promptf[ind]	sv[iew]
syn keyword vimCommand contained	al[l]	cu[nmap]	iunmenu	promptr[epl]	syncbind
syn keyword vimCommand contained	am	cuna[bbrev]	j[oin]	ptN[ext]	syntax
syn keyword vimCommand contained	amenu	cunme	ju[mps]	pta[g]	t
syn keyword vimCommand contained	an	cunmenu	k	ptj[ump]	tN[ext]
syn keyword vimCommand contained	anoremenu	d[elete]	l[ist]	ptl[ast]	ta[g]
syn keyword vimCommand contained	ar[gs]	delc[ommand]	la[st]	ptn[ext]	tags
syn keyword vimCommand contained	argu[ment]	delf[unction]	le[ft]	ptp[revious]	tc[l]
syn keyword vimCommand contained	as[cii]	di[splay]	ls	ptr[ewind]	tcld[o]
syn keyword vimCommand contained	au[tocmd]	dig[raphs]	m[ove]	pts[elect]	tclf[ile]
syn keyword vimCommand contained	aug[roup]	display	ma[rk]	pu[t]	te[aroff]
syn keyword vimCommand contained	aun	dj[ump]	mak[e]	pw[d]	tj[ump]
syn keyword vimCommand contained	aunmenu	dl[ist]	map	py[thon]	tl[ast]
syn keyword vimCommand contained	autocmd	do[autocmd]	mapc[lear]	pyf[ile]	tm[enu]
syn keyword vimCommand contained	bN[ext]	doautoa[ll]	marks	q[uit]	tn[ext]
syn keyword vimCommand contained	b[uffer]	ds[earch]	me	qa[ll]	tp[revious]
syn keyword vimCommand contained	ba[ll]	dsp[lit]	menu	r[ead]	tr[ewind]
syn keyword vimCommand contained	bad[d]	e[dit]	mk[exrc]	rec[over]	ts[elect]
syn keyword vimCommand contained	bd[elete]	ec[ho]	mks[ession]	red[o]	tu[nmenu]
syn keyword vimCommand contained	be[have]	echoh[l]	mkv[imrc]	redi[r]	u[ndo]
syn keyword vimCommand contained	bl[ast]	echon	mod[e]	reg[isters]	una[bbreviate]
syn keyword vimCommand contained	bm[odified]	el[se]	n[ext]	res[ize]	unh[ide]
syn keyword vimCommand contained	bn[ext]	elsei[f]	new	ret[ab]	unl[et]
syn keyword vimCommand contained	bp[revious]	eme	nm[ap]	retu[rn]	unm[ap]
syn keyword vimCommand contained	br[ewind]	emenu	nmapc[lear]	rew[ind]	unme
syn keyword vimCommand contained	brea[k]	en[dif]	nme	ri[ght]	unmenu
syn keyword vimCommand contained	bro[wse]	endf[unction]	nmenu	rv[iminfo]	v[global]
syn keyword vimCommand contained	buffers	endw[hile]	nn[oremap]	sN[ext]	ve[rsion]
syn keyword vimCommand contained	bun[load]	ex	nnoreme	s[ubstitute]	vi[sual]
syn keyword vimCommand contained	cN[ext]	exe[cute]	nnoremenu	sa[rgument]	vie[w]
syn keyword vimCommand contained	c[hange]	exi[t]	no[remap]	sal[l]	vm[ap]
syn keyword vimCommand contained	ca[bbrev]	f[ile]	noh[lsearch]	sbN[ext]	vmapc[lear]
syn keyword vimCommand contained	cabc[lear]	files	norea[bbrev]	sb[uffer]	vme
syn keyword vimCommand contained	cal[l]	fin[d]	noreme	sba[ll]	vmenu
syn keyword vimCommand contained	cc	fix[del]	noremenu	sbl[ast]	vn[oremap]
syn keyword vimCommand contained	cd	fu[nction]	norm[al]	sbm[odified]	vnoreme
syn keyword vimCommand contained	ce[nter]	g[lobal]	nu[mber]	sbn[ext]	vnoremenu
syn keyword vimCommand contained	cf[ile]	go[to]	nun[map]	sbp[revious]	vu[nmap]
syn keyword vimCommand contained	chd[ir]	gr[ep]	nunme	sbr[ewind]	vunme
syn keyword vimCommand contained	che[ckpath]	h[elp]	nunmenu	se[t]	vunmenu
syn keyword vimCommand contained	cl[ist]	helpf[ind]	o[pen]	sf[ind]	wN[ext]
syn keyword vimCommand contained	cla[st]	hid[e]	om[ap]	sh[ell]	w[rite]
syn keyword vimCommand contained	clo[se]	his[tory]	omapc[lear]	si[malt]	wa[ll]
syn keyword vimCommand contained	cm[ap]	i[nsert]	ome	sl[eep]	wh[ile]
syn keyword vimCommand contained	cmapc[lear]	ia[bbrev]	omenu	sla[st]	win[size]
syn keyword vimCommand contained	cme	iabc[lear]	on[ly]	sm[agic]	winp[os]
syn keyword vimCommand contained	cmenu	if	ono[remap]	sn[ext]	winsize
syn keyword vimCommand contained	cn[ext]	ij[ump]	onoreme	sni[ff]	wn[ext]
syn keyword vimCommand contained	cnew[er]	il[ist]	onoremenu	sno[magic]	wp[revous]
syn keyword vimCommand contained	cnf[ile]	im[ap]	opt[ions]	so[urce]	wq
syn keyword vimCommand contained	cno[remap]	imapc[lear]	ou[nmap]	sp[lit]	wqa[ll]
syn keyword vimCommand contained	cnorea[bbrev]	ime	ounme	spr[evious]	wv[iminfo]
syn keyword vimCommand contained	cnoreme	imenu	ounmenu	sr[ewind]	x[it]
syn keyword vimCommand contained	cnoremenu	ino[remap]	p[rint]	st[op]	xa[ll]
syn keyword vimCommand contained	co[py]	inorea[bbrev]	pc[lose]	sta[g]	y[ank]
syn keyword vimCommand contained	col[der]	inoreme	pe[rl]
syn match   vimCommand contained	"z[-+^.=]"

" All vimCommands are contained by vimIsCommands.
syn match vimCmdSep	"[:|]\+"	skipwhite nextgroup=vimAddress,vimAutoCmd,vimMark,vimFilter,vimUserCmd,vimSet,vimLet,vimCommand,vimSyntax
syn match vimIsCommand	"\<\a\+\>"	contains=vimCommand

" vimOptions are caught only when contained in a vimSet
syn keyword vimOption contained	:	ep	keywordprg	sc	tagstack
syn keyword vimOption contained	ai	equalalways	km	scb	tb
syn keyword vimOption contained	akm	equalprg	kp	scr	tbi
syn keyword vimOption contained	al	errorbells	langmap	scroll	tbs
syn keyword vimOption contained	aleph	errorfile	laststatus	scrollbind	term
syn keyword vimOption contained	allowrevins	errorformat	lazyredraw	scrolljump	terse
syn keyword vimOption contained	altkeymap	esckeys	lbr	scrolloff	textauto
syn keyword vimOption contained	ari	et	lcs	scrollopt	textmode
syn keyword vimOption contained	autoindent	eventignore	linebreak	scs	textwidth
syn keyword vimOption contained	autowrite	ex	lines	sect	tf
syn keyword vimOption contained	aw	expandtab	lisp	sections	tgst
syn keyword vimOption contained	background	exrc	list	secure	tildeop
syn keyword vimOption contained	backspace	fe	listchars	sel	timeout
syn keyword vimOption contained	backup	ff	lmap	selection	timeoutlen
syn keyword vimOption contained	backupdir	ffs	ls	selectmode	title
syn keyword vimOption contained	backupext	fileencoding	lz	sessionoptions	titlelen
syn keyword vimOption contained	bdir	fileformat	magic	sft	titleold
syn keyword vimOption contained	bex	fileformats	makeef	sh	titlestring
syn keyword vimOption contained	bg	filetype	makeprg	shcf	tl
syn keyword vimOption contained	bin	fk	mat	shell	tm
syn keyword vimOption contained	binary	fkmap	matchpairs	shellcmdflag	to
syn keyword vimOption contained	biosk	fo	matchtime	shellpipe	toolbar
syn keyword vimOption contained	bioskey	formatoptions	maxfuncdepth	shellquote	top
syn keyword vimOption contained	bk	formatprg	maxmapdepth	shellredir	tr
syn keyword vimOption contained	breakat	fp	maxmem	shellslash	ts
syn keyword vimOption contained	brk	ft	maxmemtot	shelltype	tsl
syn keyword vimOption contained	browsedir	gcr	mef	shellxquote	ttimeout
syn keyword vimOption contained	bs	gd	mfd	shiftround	ttimeoutlen
syn keyword vimOption contained	bsdir	gdefault	mh	shiftwidth	ttm
syn keyword vimOption contained	cb	gfm	ml	shm	ttybuiltin
syn keyword vimOption contained	cf	gfn	mls	shortmess	ttyfast
syn keyword vimOption contained	ch	gfs	mm	shortname	ttym
syn keyword vimOption contained	cin	ghr	mmd	showbreak	ttymouse
syn keyword vimOption contained	cindent	go	mmt	showcmd	ttyscroll
syn keyword vimOption contained	cink	gp	mod	showfulltag	ttytype
syn keyword vimOption contained	cinkeys	grepformat	modeline	showmatch	tw
syn keyword vimOption contained	cino	grepprg	modelines	showmode	tx
syn keyword vimOption contained	cinoptions	guicursor	modified	shq	uc
syn keyword vimOption contained	cinw	guifont	more	si	ul
syn keyword vimOption contained	cinwords	guifontset	mouse	sidescroll	undolevels
syn keyword vimOption contained	clipboard	guiheadroom	mousef	sj	updatecount
syn keyword vimOption contained	cmdheight	guioptions	mousefocus	slm	updatetime
syn keyword vimOption contained	co	guipty	mousehide	sm	ut
syn keyword vimOption contained	columns	helpfile	mousem	smartcase	vb
syn keyword vimOption contained	com	helpheight	mousemodel	smartindent	vbs
syn keyword vimOption contained	comments	hf	mouset	smarttab	verbose
syn keyword vimOption contained	compatible	hh	mousetime	smd	vi
syn keyword vimOption contained	complete	hi	mp	sn	viminfo
syn keyword vimOption contained	confirm	hid	mps	so	visualbell
syn keyword vimOption contained	consk	hidden	nf	softtabstop	wa
syn keyword vimOption contained	conskey	highlight	nrformats	sol	wak
syn keyword vimOption contained	cp	history	nu	sp	warn
syn keyword vimOption contained	cpo	hk	number	splitbelow	wb
syn keyword vimOption contained	cpoptions	hkmap	oft	sr	wc
syn keyword vimOption contained	cpt	hkmapp	osfiletype	srr	wcm
syn keyword vimOption contained	cscopeprg	hkp	pa	ss	wd
syn keyword vimOption contained	cscopetag	hl	para	ssl	weirdinvert
syn keyword vimOption contained	cscopetagorder	hls	paragraphs	ssop	wh
syn keyword vimOption contained	cscopeverbose	hlsearch	paste	st	whichwrap
syn keyword vimOption contained	csprg	ic	pastetoggle	sta	wig
syn keyword vimOption contained	cst	icon	patchmode	startofline	wildchar
syn keyword vimOption contained	csto	iconstring	path	statusline	wildcharm
syn keyword vimOption contained	csverb	ignorecase	pm	stl	wildignore
syn keyword vimOption contained	def	im	previewheight	sts	wildmenu
syn keyword vimOption contained	define	inc	pt	su	wildmode
syn keyword vimOption contained	dg	include	pvh	suffixes	wim
syn keyword vimOption contained	dict	incsearch	readonly	sw	winaltkeys
syn keyword vimOption contained	dictionary	inf	remap	swapfile	winheight
syn keyword vimOption contained	digraph	infercase	report	swapsync	winminheight
syn keyword vimOption contained	dir	insertmode	restorescreen	swb	wiv
syn keyword vimOption contained	directory	is	revins	swf	wm
syn keyword vimOption contained	display	isf	ri	switchbuf	wmh
syn keyword vimOption contained	dy	isfname	rightleft	sws	wmnu
syn keyword vimOption contained	ea	isi	rl	sxq	wrap
syn keyword vimOption contained	eb	isident	ro	syn	wrapmargin
syn keyword vimOption contained	ed	isk	rs	syntax	wrapscan
syn keyword vimOption contained	edcompatible	iskeyword	ru	ta	write
syn keyword vimOption contained	ef	isp	ruf	tabstop	writeany
syn keyword vimOption contained	efm	isprint	ruler	tag	writebackup
syn keyword vimOption contained	ei	joinspaces	rulerformat	tagbsearch	writedelay
syn keyword vimOption contained	ek	js	sb	taglength	ws
syn keyword vimOption contained	endofline	key	sbo	tagrelative	ww
syn keyword vimOption contained	eol	keymodel	sbr	tags

" These are the turn-off setting variants
syn keyword vimOption contained	noai	noendofline	nojs	nosc	notbi
syn keyword vimOption contained	noakm	noeol	nolazyredraw	noscb	notbs
syn keyword vimOption contained	noallowrevins	noequalalways	nolbr	noscrollbind	noterse
syn keyword vimOption contained	noaltkeymap	noerrorbells	nolinebreak	noscs	notextauto
syn keyword vimOption contained	noari	noesckeys	nolisp	nosecure	notextmode
syn keyword vimOption contained	noautoindent	noet	nolist	nosft	notf
syn keyword vimOption contained	noautowrite	noex	nolz	noshellslash	notgst
syn keyword vimOption contained	noaw	noexpandtab	nomagic	noshiftround	notildeop
syn keyword vimOption contained	nobackup	noexrc	nomh	noshortname	notimeout
syn keyword vimOption contained	nobin	nofk	noml	noshowcmd	notitle
syn keyword vimOption contained	nobinary	nofkmap	nomod	noshowfulltag	noto
syn keyword vimOption contained	nobiosk	nogd	nomodeline	noshowmatch	notop
syn keyword vimOption contained	nobioskey	nogdefault	nomodified	noshowmode	notr
syn keyword vimOption contained	nobk	noguipty	nomore	nosi	nottimeout
syn keyword vimOption contained	nocf	nohid	nomousef	nosm	nottybuiltin
syn keyword vimOption contained	nocin	nohidden	nomousefocus	nosmartcase	nottyfast
syn keyword vimOption contained	nocindent	nohk	nomousehide	nosmartindent	notx
syn keyword vimOption contained	nocompatible	nohkmap	nonu	nosmarttab	novb
syn keyword vimOption contained	noconfirm	nohkmapp	nonumber	nosmd	novisualbell
syn keyword vimOption contained	noconsk	nohkp	nopaste	nosn	nowa
syn keyword vimOption contained	noconskey	nohls	noreadonly	nosol	nowarn
syn keyword vimOption contained	nocp	nohlsearch	noremap	nosplitbelow	nowb
syn keyword vimOption contained	nocscopetag	noic	norestorescreen	nosr	noweirdinvert
syn keyword vimOption contained	nocscopeverbose	noicon	norevins	nossl	nowildmenu
syn keyword vimOption contained	nocst	noignorecase	nori	nosta	nowiv
syn keyword vimOption contained	nocsverb	noim	norightleft	nostartofline	nowmnu
syn keyword vimOption contained	nodg	noincsearch	norl	noswapfile	nowrap
syn keyword vimOption contained	nodigraph	noinf	noro	noswf	nowrapscan
syn keyword vimOption contained	noea	noinfercase	nors	nota	nowrite
syn keyword vimOption contained	noeb	noinsertmode	noru	notagbsearch	nowriteany
syn keyword vimOption contained	noed	nois	noruler	notagrelative	nowritebackup
syn keyword vimOption contained	noedcompatible	nojoinspaces	nosb	notagstack	nows
syn keyword vimOption contained	noek

" termcap codes (which can also be set)
syn keyword vimOption contained	t_AB	t_IE	t_WP	t_k1	t_kd	t_op
syn keyword vimOption contained	t_AF	t_IS	t_WS	t_k2	t_ke	t_se
syn keyword vimOption contained	t_AL	t_K1	t_ZH	t_k3	t_kh	t_so
syn keyword vimOption contained	t_CS	t_K3	t_ZR	t_k4	t_kl	t_sr
syn keyword vimOption contained	t_Co	t_K4	t_al	t_k5	t_kr	t_te
syn keyword vimOption contained	t_DL	t_K5	t_bc	t_k6	t_ks	t_ti
syn keyword vimOption contained	t_F1	t_K6	t_cd	t_k7	t_ku	t_ts
syn keyword vimOption contained	t_F2	t_K7	t_ce	t_k8	t_le	t_ue
syn keyword vimOption contained	t_F3	t_K8	t_cl	t_k9	t_mb	t_us
syn keyword vimOption contained	t_F4	t_K9	t_cm	t_kD	t_md	t_vb
syn keyword vimOption contained	t_F5	t_KA	t_cs	t_kI	t_me	t_ve
syn keyword vimOption contained	t_F6	t_RI	t_da	t_kN	t_mr	t_vi
syn keyword vimOption contained	t_F7	t_RV	t_db	t_kP	t_ms	t_vs
syn keyword vimOption contained	t_F8	t_Sb	t_dl	t_kb	t_nd	t_xs
syn keyword vimOption contained	t_F9	t_Sf	t_fs
syn match   vimOption contained	"t_#2"
syn match   vimOption contained	"t_#4"
syn match   vimOption contained	"t_%1"
syn match   vimOption contained	"t_%i"
syn match   vimOption contained	"t_&8"
syn match   vimOption contained	"t_*7"
syn match   vimOption contained	"t_@7"
syn match   vimOption contained	"t_k;"

" these settings don't actually cause errors in vim, but were supported by vi and don't do anything in vim
syn keyword vimErrSetting contained	hardtabs	w1200	w9600	wi	window
syn keyword vimErrSetting contained	ht	w300

" AutoBuf Events
syn case ignore
syn keyword vimAutoEvent contained	BufCreate	BufReadPost	FileChangedShell	FilterReadPre	Syntax
syn keyword vimAutoEvent contained	BufDelete	BufReadPre	FileEncoding	FilterWritePost	TermChanged
syn keyword vimAutoEvent contained	BufEnter	BufUnload	FileReadPost	FilterWritePre	User
syn keyword vimAutoEvent contained	BufFilePost	BufWrite	FileReadPre	FocusGained	VimEnter
syn keyword vimAutoEvent contained	BufFilePre	BufWritePost	FileType	FocusLost	VimLeave
syn keyword vimAutoEvent contained	BufHidden	BufWritePre	FileWritePost	GUIEnter	VimLeavePre
syn keyword vimAutoEvent contained	BufLeave	CursorHold	FileWritePre	StdinReadPost	WinEnter
syn keyword vimAutoEvent contained	BufNewFile	FileAppendPost	FilterReadPost	StdinReadPre	WinLeave
syn keyword vimAutoEvent contained	BufRead	FileAppendPre

" Highlight commonly used Groupnames
syn keyword vimGroup contained	Comment	Identifier	Keyword	Type	Delimiter
syn keyword vimGroup contained	Constant	Function	Exception	StorageClass	SpecialComment
syn keyword vimGroup contained	String	Statement	PreProc	Structure	Debug
syn keyword vimGroup contained	Character	Conditional	Include	Typedef	Ignore
syn keyword vimGroup contained	Number	Repeat	Define	Special	Error
syn keyword vimGroup contained	Boolean	Label	Macro	SpecialChar	Todo
syn keyword vimGroup contained	Float	Operator	PreCondit	Tag

" Default highlighting groups
syn keyword vimHLGroup contained	Cursor	Menu	Normal	SpecialKey	Visual
syn keyword vimHLGroup contained	Directory	ModeMsg	Question	StatusLine	VisualNOS
syn keyword vimHLGroup contained	ErrorMsg	MoreMsg	Scrollbar	StatusLineNC	WarningMsg
syn keyword vimHLGroup contained	IncSearch	NonText	Search	Title	WildMenu
syn keyword vimHLGroup contained	LineNr
syn case match

" Function Names
syn keyword vimFuncName contained	append	delete	has	localtime	strtrans
syn keyword vimFuncName contained	argc	did_filetype	histadd	maparg	substitute
syn keyword vimFuncName contained	argv	escape	histdel	mapcheck	synID
syn keyword vimFuncName contained	browse	exists	histget	match	synIDattr
syn keyword vimFuncName contained	bufexists	expand	histnr	matchend	synIDtrans
syn keyword vimFuncName contained	bufloaded	filereadable	hlID	matchstr	system
syn keyword vimFuncName contained	bufname	fnamemodify	hlexists	nr2char	tempname
syn keyword vimFuncName contained	bufnr	getcwd	hostname	rename	virtcol
syn keyword vimFuncName contained	bufwinnr	getftime	input	setline	visualmode
syn keyword vimFuncName contained	byte2line	getline	isdirectory	strftime	winbufnr
syn keyword vimFuncName contained	char2nr	getwinposx	libcall	strlen	winheight
syn keyword vimFuncName contained	col	getwinposy	line	strpart	winnr
syn keyword vimFuncName contained	confirm	glob	line2byte
syn match   vimFunc     "\I\i*\s*("	contains=vimFuncName,vimCommand

"--- syntax above generated by mkvimvim ---

" Special Vim Highlighting

" Behave!
" =======
syn match   vimBehave	"\<be\(h\(a\(ve\=\)\=\)\=\)\=\>" contains=vimCommand skipwhite nextgroup=vimBehaveModel,vimBehaveError
syn keyword vimBehaveModel contained	mswin	xterm
syn match   vimBehaveError contained	"[^ ]\+"

" Filetypes
" =========
syn match   vimFiletype	"filet\(y\(pe\=\)\=\)\=\s\+\I\i*"	skipwhite contains=vimFTCmd,vimFTOption,vimFTError
syn match   vimFTError  contained	"\I\i*"
syn keyword vimFTCmd    contained	filet[ype]
syn keyword vimFTOption contained	on	off

" Functions : Tag is provided for those who wish to highlight tagged functions
" =========
syn cluster vimFuncList	contains=vimCommand,Tag
syn cluster vimFuncBodyList	contains=vimIsCommand,vimFunction,vimFunctionError,vimFuncBody,vimSpecFile,vimOper,vimNumber,vimComment,vimString,vimSubst,vimMark,vimRegister,vimAddress,vimFilter,vimCmplxRepeat,vimComment,vimLet,vimSet,vimAutoCmd,vimRegion,vimSynLine,vimNotation,vimCtrlChar,vimFuncVar
syn match   vimFunction	"\<fu\(n\(c\(t\(t\(i\(on\=\)\=\)\=\)\=\)\=\)\=\)\=!\=\s\+\u\w*("me=e-1	contains=@vimFuncList nextgroup=vimFuncBody
syn match   vimFunctionError	"\<fu\(n\(c\(t\(t\(i\(on\=\)\=\)\=\)\=\)\=\)\=\)\=!\=\s\+\U.\{-}("me=e-1	contains=vimCommand   nextgroup=vimFuncBody
syn region  vimFuncBody contained	start=")"	end="\<endf"	contains=@vimFuncBodyList
syn match   vimFuncVar  contained	"a:\(\I\i*\|\d\+\)"

syn keyword vimPattern  contained	start	skip	end

" Special Filenames, Modifiers, Extension Removal
syn match vimSpecFile	"<c\(word\|WORD\)>"	nextgroup=vimSpecFileMod,vimSubst
syn match vimSpecFile	"<\([acs]file\|amatch\|abuf\)>"	nextgroup=vimSpecFileMod,vimSubst
syn match vimSpecFile	"\s%[ \t:]"ms=s+1,me=e-1	nextgroup=vimSpecFileMod,vimSubst
syn match vimSpecFile	"\s%$"ms=s+1		nextgroup=vimSpecFileMod,vimSubst
syn match vimSpecFile	"\s%<"ms=s+1,me=e-1	nextgroup=vimSpecFileMod,vimSubst
syn match vimSpecFile	"#\d\+\|[#%]<\>"		nextgroup=vimSpecFileMod,vimSubst
syn match vimSpecFileMod	"\(:[phtre]\)\+"		contained

" Operators
syn match vimOper	"||\|&&\|!=\|>=\|<=\|=\~\|!\~\|>\|<\|+\|-\|=\|\." skipwhite nextgroup=vimString,vimSpecFile

" User-Specified Commands
syn cluster vimUserCmdList	contains=vimAddress,vimSyntax,vimHighlight,vimAutoCmd,vimCmplxRepeat,vimComment,vimCtrlChar,vimEscapeBrace,vimFilter,vimFunc,vimFunction,vimIsCommand,vimMark,vimNotation,vimNumber,vimOper,vimRegion,vimRegister,vimLet,vimSet,vimSetEqual,vimSetString,vimSpecFile,vimString,vimSubst,vimSubstEnd,vimSubstRange,vimSynLine
syn match   vimUserCmd	"\<com\(m\(a\(nd\=\)\=\)\=\)\=!\=\>.*$"		contains=vimUserAttrb,@vimUserCmdList
syn match   vimUserAttrb	contained	"-n\(a\(r\(gs\=\)\=\)\=\)\==[01*?+]"	contains=vimUserAttrbKey,vimOper
syn match   vimUserAttrb	contained	"-com\(p\(l\(e\(te\=\)\=\)\=\)\=\)\==\(augroup\|buffer\|command\|dir\|event\|file\|help\|highlight\|menu\|option\|tag\|var\)"	contains=vimUserAttrbKey,vimUserAttrbCmplt,vimOper
syn match   vimUserAttrb	contained	"-ra\(n\(ge\=\)\=\)\=\(=%\|=\d\+\)\="	contains=vimNumber,vimOper,vimUserAttrbKey
syn match   vimUserAttrb	contained	"-cou\(nt\=\)\==\d\+"		contains=vimNumber,vimOper,vimUserAttrbKey
syn match   vimUserAttrb	contained	"-b\(a\(ng\=\)\=\)\="		contains=vimOper,vimUserAttrbKey
syn match   vimUserAttrb	contained	"-re\(g\(i\(s\(t\(er\=\)\=\)\=\)\=\)\=\)\="	contains=vimOper,vimUserAttrbKey
syn keyword vimUserAttrbKey	contained	b[ang]	cou[nt]	ra[nge]
syn keyword vimUserAttrbKey	contained	com[plete]	n[args]	re[gister]
syn keyword vimUserAttrbCmplt	contained	augroup	dir	help	menu	tag
syn keyword vimUserAttrbCmplt	contained	buffer	event	highlight	option	var
syn keyword vimUserAttrbCmplt	contained	command	file

" Numbers
" =======
syn match vimNumber	"\<\d\+.\d\+"
syn match vimNumber	"\<\d\+L\="
syn match vimNumber	"-\d\+.\d\+"
syn match vimNumber	"-\d\+L\="
syn match vimNumber	"[[;:]\d\+"lc=1
syn match vimNumber	"0[xX]\x\+"
syn match vimNumber	"#\x\+"

" Lower Priority Comments: after some vim commands...
" =======================
syn match  vimComment	+\s"[^\-:.%#=*].*$+lc=1	contains=@vimCommentGroup,vimCommentString
syn match  vimComment	+\<endif\s\+".*$+lc=5	contains=@vimCommentGroup,vimCommentString
syn match  vimComment	+\<else\s\+".*$+lc=4	contains=@vimCommentGroup,vimCommentString
syn region vimCommentString	contained oneline start='\S\s\+"'ms=s+1	end='"'

" Environment Variables
" =====================
syn match vimEnvvar	"\$\I\i*"
syn match vimEnvvar	"\${\I\i*}"

" Try to catch strings, if nothing else matches (therefore it must precede the others!)
"  vmEscapeBrace handles ["]  []"] (ie. stays as string)
syn region	vimEscapeBrace	oneline contained transparent	start="[^\\]\(\\\\\)*\[\^\=\]\=" skip="\\\\\|\\\]" end="\]"me=e-1
syn match	vimPatSep	contained	"\\[|()]"
syn match	vimNotPatSep	contained	"\\\\"
syn region	vimString	oneline	start=+[^:a-zA-Z>!\\]"+lc=1 skip=+\\\\\|\\"+ end=+"+	contains=vimEscapeBrace,vimPatSep,vimNotPatSep
syn region	vimString	oneline	start=+[^:a-zA-Z>!\\]'+lc=1 skip=+\\\\\|\\'+ end=+'+	contains=vimEscapeBrace,vimPatSep,vimNotPatSep
syn region	vimString	oneline	start=+=!+lc=1	skip=+\\\\\|\\!+ end=+!+		contains=vimEscapeBrace,vimPatSep,vimNotPatSep
syn region	vimString	oneline	start="=+"lc=1	skip="\\\\\|\\+" end="+"		contains=vimEscapeBrace,vimPatSep,vimNotPatSep
syn region	vimString	oneline	start="[^\\]+\s*[^a-zA-Z0-9.]"lc=1 skip="\\\\\|\\+" end="+"	contains=vimEscapeBrace,vimPatSep,vimNotPatSep
syn region	vimString	oneline	start="\s/\s*\A"lc=1 skip="\\\\\|\\+" end="/"		contains=vimEscapeBrace,vimPatSep,vimNotPatSep
syn match        vimString	contained	+"[^"]*\\$+	skipnl nextgroup=vimStringCont
syn match	vimStringCont	contained	+\(\\\\\|.\)\{-}[^\\]"+

" Substitutions
" =============
syn cluster	vimSubstList	contains=vimPatSep,vimSubstTwoBS,vimSubstRange,vimNotation
syn cluster	vimSubstEndList	contains=vimSubstPat,vimSubstTwoBS,vimNotation
syn region	vimSubst	oneline	 start=":\=s/.\{-}" skip="\\\\\|\\/" end="/"	contains=@vimSubstList nextgroup=vimSubstEnd1
syn region	vimSubstEnd1	contained oneline start="."lc=1	   skip="\\\\\|\\/" end="/"	contains=@vimSubstEndList
syn region	vimSubst	oneline	 start=":\=s?.\{-}" skip="\\\\\|\\?" end="?"	contains=@vimSubstList nextgroup=vimSubstEnd2
syn region	vimSubstEnd2	contained oneline start="."lc=1	   skip="\\\\\|\\?" end="?"	contains=@vimSubstEndList
syn region	vimSubst	oneline	 start=":\=s@.\{-}" skip="\\\\\|\\@" end="@"	contains=@vimSubstList nextgroup=vimSubstEnd3
syn region	vimSubstEnd3	contained oneline start="."lc=1	   skip="\\\\\|\\@" end="@"	contains=@vimSubstEndList
syn region	vimSubstRange	contained oneline start="\["	   skip="\\\\\|\\]" end="]"
syn match	vimSubstPat	contained	"\\\d"
syn match	vimSubstTwoBS	contained	"\\\\"

" Marks, Registers, Addresses, Filters
syn match  vimMark		"[!,:]'[a-zA-Z0-9]"lc=1
syn match  vimMark		"'[a-zA-Z0-9][,!]"me=e-1
syn match  vimMark		"'[<>][,!]"me=e-1
syn match  vimMark		"\<norm\s'[a-zA-Z0-9]"lc=5
syn match  vimMark		"\<normal\s'[a-zA-Z0-9]"lc=7
syn match  vimPlainMark	contained	"'[a-zA-Z0-9]"

syn match  vimRegister		'[^(,;.]"[a-zA-Z0-9\-:.%#*=][^a-zA-Z_"]'lc=1,me=e-1
syn match  vimRegister		'\<norm\s\+"[a-zA-Z0-9]'lc=5
syn match  vimRegister		'\<normal\s\+"[a-zA-Z0-9]'lc=7
syn match  vimPlainRegister	contained	'"[a-zA-Z0-9\-:.%#*=]'

syn match  vimAddress		",\."lc=1
syn match  vimAddress		"[%.]" skipwhite	nextgroup=vimString

syn match  vimFilter	contained	"^!.\{-}\(|\|$\)"	contains=vimSpecFile
syn match  vimFilter	contained	"\A!.\{-}\(|\|$\)"ms=s+1	contains=vimSpecFile

" Complex repeats (:h complex-repeat)
syn match  vimCmplxRepeat		'[^a-zA-Z_/\\]q[0-9a-zA-Z"]'lc=1
syn match  vimCmplxRepeat		'@[0-9a-z".=@:]'

" Set command and associated set-options (vimOptions) with comment
syn region vimSet	matchgroup=vimCommand start="\<set\>" end="|"me=e-1 end="$" matchgroup=vimNotation end="<CR>" keepend contains=vimSetEqual,vimOption,vimErrSetting,vimComment,vimSetString
syn region vimSetEqual	contained	start="="	skip="\\\\\|\\\s" end="[| \t]\|$"me=e-1 contains=vimCtrlChar,vimSetSep,vimNotation
syn region vimSetString	contained	start=+="+hs=s+1	skip=+\\\\\|\\"+  end=+"+	contains=vimCtrlChar
syn match  vimSetSep	contained	"[,:]"

" Let
" ===
syn keyword vimLet		let	skipwhite nextgroup=vimLetVar
syn match   vimLetVar	contained	"\I\i*"

" Autocmd
" =======
syn match   vimAutoEventList	contained	"\(!\s\+\)\=\(\a\+,\)*\a\+"	contains=vimAutoEvent nextgroup=vimAutoCmdSpace
syn match   vimAutoCmdSpace	contained	"\s\+"		nextgroup=vimAutoCmdSfxList
syn match   vimAutoCmdSfxList	contained	"\S*"
syn keyword vimAutoCmd		au[tocmd] do[autocmd] doautoa[ll]	skipwhite nextgroup=vimAutoEventList

" Echo and Execute -- prefer strings!
syn region  vimEcho	oneline	start="\<ec\(ho\=\)\=\>"   skip="\(\\\\\)*\\|" end="$\||" contains=vimCommand,vimString,vimOper
syn region  vimEcho	oneline	start="\<exe\(c\(u\(te\=\)\=\)\=\)\=\>"   skip="\(\\\\\)*\\|" end="$\||" contains=vimCommand,vimString,vimOper

" Syntax
"=======
syn match   vimGroupList	contained	"@\=[^ \t,]*"	contains=vimGroupSpecial,vimPatSep
syn match   vimGroupList	contained	"@\=[^ \t,]*,"	nextgroup=vimGroupList contains=vimGroupSpecial,vimPatSep
syn keyword vimGroupSpecial	contained	ALL	ALLBUT
syn match   vimSynError	contained	"\i\+"
syn match   vimSynError	contained	"\i\+="	nextgroup=vimGroupList
syn match   vimSynContains	contained	"contains="	nextgroup=vimGroupList
syn match   vimSynNextgroup	contained	"nextgroup="	nextgroup=vimGroupList

syn match   vimSyntax	"\<sy\(n\(t\(ax\=\)\=\)\=\)\=\>"		contains=vimCommand skipwhite nextgroup=vimSynType,vimComment
syn match   vimAuSyntax	contained	"\s+sy\(n\(t\(ax\=\)\=\)\=\)\="	contains=vimCommand skipwhite nextgroup=vimSynType,vimComment

" Syntax: case
syn keyword vimSynType	contained	case	skipwhite nextgroup=vimSynCase,vimSynCaseError
syn match   vimSynCaseError	contained	"\i\+"
syn keyword vimSynCase	contained	ignore	match

" Syntax: clear
syn keyword vimSynType	contained	clear	skipwhite nextgroup=vimGroupList

" Syntax: cluster
syn keyword vimSynType		contained	cluster		skipwhite nextgroup=vimClusterName
syn region  vimClusterName	contained	matchgroup=vimGroupName start="\k\+" skip="\\\\\|\\|" end="$\||" contains=vimGroupAdd,vimGroupRem,vimSynContains,vimSynError
syn match   vimGroupAdd	contained	"add="		nextgroup=vimGroupList
syn match   vimGroupRem	contained	"remove="	nextgroup=vimGroupList

" Syntax: include
syn keyword vimSynType	contained	include		skipwhite nextgroup=vimGroupList

" Syntax: keyword
syn keyword vimSynType	contained	keyword		skipwhite nextgroup=vimSynKeyRegion
syn region  vimSynKeyRegion	contained oneline matchgroup=vimGroupName start="\k\+" skip="\\\\\|\\|" end="$\||" contains=vimSynNextgroup,vimSynKeyOpt
syn match   vimSynKeyOpt	contained	"\<\(contained\|transparent\|skipempty\|skipwhite\|skipnl\)\>"

" Syntax: match
syn keyword vimSynType	contained	match	skipwhite nextgroup=vimSynMatchRegion
syn region  vimSynMatchRegion	contained oneline matchgroup=vimGroupName start="\k\+" end="$" contains=vimComment,vimSynContains,vimSynError,vimSynMtchOpt,vimSynNextgroup,vimSynRegPat
syn match   vimSynMtchOpt	contained	"\<\(contained\|excludenl\|transparent\|skipempty\|skipwhite\|skipnl\|display\|fold\)\>"

" Syntax: off and on
syn keyword vimSynType	contained	off	on

" Syntax: region
syn keyword vimSynType	contained	region	skipwhite nextgroup=vimSynRegion
syn region  vimSynRegion	contained oneline matchgroup=vimGroupName start="\k\+" skip="\\\\\|\\|" end="$\||" contains=vimSynContains,vimSynNextgroup,vimSynRegOpt,vimSynReg,vimSynMtchGrp
syn match   vimSynRegOpt	contained	"\<\(contained\|excludenl\|transparent\|skipempty\|skipwhite\|skipnl\|oneline\|keepend\|display\|fold\)\>"
syn match   vimSynReg		contained	"\(start\|skip\|end\)="he=e-1	nextgroup=vimSynRegPat
syn match   vimSynMtchGrp	contained	"matchgroup="	nextgroup=vimGroup,vimHLGroup
syn region  vimSynRegPat	contained oneline	start="!"  skip="\\\\\|\\!"  end="!"  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start="%"  skip="\\\\\|\\-"  end="%"  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start="'"  skip="\\\\\|\\'"  end="'"  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start="+"  skip="\\\\\|\\+"  end="+"  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start="@"  skip="\\\\\|\\@"  end="@"  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start='"'  skip='\\\\\|\\"'  end='"'  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start='/'  skip='\\\\\|\\/'  end='/'  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start=','  skip='\\\\\|\\,'  end=','  contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn region  vimSynRegPat	contained oneline	start='\$' skip='\\\\\|\\\$' end='\$' contains=vimPatSep,vimNotPatSep,vimSynPatRange,vimSynNotPatRange nextgroup=vimSynPatMod
syn match   vimSynPatMod	contained	"\(hs\|ms\|me\|hs\|he\|rs\|re\)=[se]\([-+]\d\+\)\="
syn match   vimSynPatMod	contained	"\(hs\|ms\|me\|hs\|he\|rs\|re\)=[se]\([-+]\d\+\)\=," nextgroup=vimSynPatMod
syn match   vimSynPatMod	contained	"lc=\d\+"
syn match   vimSynPatMod	contained	"lc=\d\+," nextgroup=vimSynPatMod
syn region  vimSynPatRange	contained oneline start="\["	skip="\\\\\|\\]"   end="]"
syn match   vimSynNotPatRange	contained	"\\\\\|\\\["

" Syntax: sync
" ============
syn keyword vimSynType	contained	sync	skipwhite	nextgroup=vimSyncC,vimSyncLines,vimSyncMatch,vimSyncError,vimSyncLinecont
syn match   vimSyncError	contained	"\i\+"
syn keyword vimSyncC	contained	ccomment	clear
syn keyword vimSyncMatch	contained	match	skipwhite	nextgroup=vimSyncGroupName
syn keyword vimSyncLinecont	contained	linecont	skipwhite	nextgroup=vimSynRegPat
syn match   vimSyncLines	contained	"\(min\|max\)\=lines="	nextgroup=vimNumber
syn match   vimSyncGroupName	contained	"\k\+"	skipwhite	nextgroup=vimSyncKey
syn match   vimSyncKey	contained	"\<groupthere\|grouphere\>"	skipwhite nextgroup=vimSyncGroup
syn match   vimSyncGroup	contained	"\k\+"	skipwhite	nextgroup=vimSynRegPat,vimSyncNone
syn keyword vimSyncNone	contained	NONE

" Additional IsCommand stuff, here by reasons of precedence
" ====================
syn match vimIsCommand	"<Bar>\s*\a\+"	transparent contains=vimCommand,vimNotation

" Highlighting
" ============
syn match   vimHighlight		"\<hi\(g\(h\(l\(i\(g\(ht\=\)\=\)\=\)\=\)\=\)\=\)\=\>" skipwhite nextgroup=vimHiLink,vimHiClear,vimHiKeyList,vimComment

syn match   vimHiGroup	contained	"\i\+"
syn case ignore
syn keyword vimHiAttrib	contained	none bold inverse italic reverse standout underline
syn keyword vimFgBgAttrib	contained	none bg background fg foreground
syn case match
syn match   vimHiAttribList	contained	"\i\+"	contains=vimHiAttrib
syn match   vimHiAttribList	contained	"\i\+,"he=e-1	contains=vimHiAttrib nextgroup=vimHiAttribList,vimHiAttrib
syn case ignore
syn keyword vimHiCtermColor	contained	black	darkcyan	darkred	lightcyan	lightred
syn keyword vimHiCtermColor	contained	blue	darkgray	gray	lightgray	magenta
syn keyword vimHiCtermColor	contained	brown	darkgreen	green	lightgreen	red
syn keyword vimHiCtermColor	contained	cyan	darkgrey	grey	lightgrey	white
syn keyword vimHiCtermColor	contained	darkBlue	darkmagenta	lightblue	lightmagenta	yellow
syn case match
syn match   vimHiFontname	contained	"[a-zA-Z\-*]\+"
syn match   vimHiGuiFontname	contained	"'[a-zA-Z\-* ]\+'"
syn match   vimHiGuiRgb	contained	"#\x\{6}"
syn match   vimHiCtermError	contained	"[^0-9]\i*"

" Highlighting: hi group key=arg ...
syn cluster vimHiCluster contains=vimHiGroup,vimHiTerm,vimHiCTerm,vimHiStartStop,vimHiCtermFgBg,vimHiGui,vimHiGuiFont,vimHiGuiFgBg,vimHiKeyError
syn region vimHiKeyList	contained oneline start="\i\+" skip="\\\\\|\\|" end="$\||"	contains=@vimHiCluster
syn match  vimHiKeyError	contained	"\i\+="he=e-1
syn match  vimHiTerm	contained	"[tT][eE][rR][mM]="he=e-1			nextgroup=vimHiAttribList
syn match  vimHiStartStop	contained	"\([sS][tT][aA][rR][tT]\|[sS][tT][oO][pP]\)="he=e-1	nextgroup=vimHiTermcap,vimOption
syn match  vimHiCTerm	contained	"[cC][tT][eE][rR][mM]="he=e-1			nextgroup=vimHiAttribList
syn match  vimHiCtermFgBg	contained	"[cC][tT][eE][rR][mM][fFbB][gG]="he=e-1		nextgroup=vimNumber,vimHiCtermColor,vimFgBgAttrib,vimHiCtermError
syn match  vimHiGui	contained	"[gG][uU][iI]="he=e-1			nextgroup=vimHiAttribList
syn match  vimHiGuiFont	contained	"[fF][oO][nN][tT]="he=e-1			nextgroup=vimHiFontname
syn match  vimHiGuiFgBg	contained	"[gG][uU][iI][fFbB][gG]="he=e-1			nextgroup=vimHiGroup,vimHiGuiFontname,vimHiGuiRgb,vimFgBgAttrib
syn match  vimHiTermcap	contained	"\S\+"		contains=vimNotation

" Highlight: clear
syn keyword vimHiClear	contained	clear		nextgroup=vimHiGroup

" Highlight: link
syn region vimHiLink	contained oneline matchgroup=vimCommand start="link" end="$"	contains=vimHiGroup,vimGroup,vimHLGroup

" Angle-Bracket Notation (tnx to Michael Geddes)
" ======================
syn case ignore
syn match vimNotation	"\\<\([scam]-\)\{0,4}\(f\d\{1,2}\|[^ \t:]\|cr\|lf\|linefeed\|return\|del\(ete\)\=\|bs\|backspace\|tab\|esc\|right\|left\|Help\|Undo\|Insert\|Ins\|k\=Home\|k \=End\|kPlus\|kMinus\|kDivide\|kMultiply\|kEnter\|k\=\(page\)\=\(\|down\|up\)\)>" contains=vimBracket
syn match vimNotation	"\\<\([scam2-4]-\)\{0,4}\(right\|left\|middle\)\(mouse\|drag\|release\)>" contains=vimBracket
syn match vimNotation	"\\<\(bslash\|space\|bar\|nop\|nul\|lt\)>"		contains=vimBracket
syn match vimNotation	'\\<C-R>[0-9a-z"%#:.\-=]'he=e-1			contains=vimBracket
syn match vimNotation	'\\<\(line[12]\|count\|bang\|reg\|args\|lt\|[qf]-args\)>'	contains=vimBracket
syn match vimBracket contained	"[\\<>]"
syn case match

" Control Characters
" ==================
syn match vimCtrlChar	"[--]"

" Beginners - Patterns that involve ^
" =========
syn match  vimLineComment	+^[ \t:]*".*$+		contains=@vimCommentGroup,vimCommentString,vimCommentTitle
syn match  vimCommentTitle	'"\s*\u\a*\(\s\+\u\a*\)*:'ms=s+1	contained
syn match  vimContinue	"^\s*\\"

" Highlighting Settings
" ====================
if !exists("did_vim_syntax_inits")
  let did_vim_syntax_inits = 1

  " The default methods for highlighting.  Can be overridden later
  hi link vimAuHighlight	vimHighlight

  hi link vimAddress	vimMark
  hi link vimAutoCmd	vimCommand
  hi link vimAutoCmdOpt	vimOption
  hi link vimAutoSet	vimCommand
  hi link vimBehaveError	vimError
  hi link vimCommentString	vimString
  hi link vimCondHL	vimCommand
  hi link vimElseif	vimCondHL
  hi link vimErrSetting	vimError
  hi link vimFgBgAttrib	vimHiAttrib
  hi link vimFTCmd	vimCommand
  hi link vimFTOption	vimSynType
  hi link vimFTError	vimError
  hi link vimFunctionError	vimError
  hi link vimGroupAdd	vimSynOption
  hi link vimGroupRem	vimSynOption
  hi link vimHLGroup	vimGroup
  hi link vimHiAttribList	vimError
  hi link vimHiCTerm	vimHiTerm
  hi link vimHiCtermError	vimError
  hi link vimHiCtermFgBg	vimHiTerm
  hi link vimHiGroup	vimGroupName
  hi link vimHiGui	vimHiTerm
  hi link vimHiGuiFgBg	vimHiTerm
  hi link vimHiGuiFont	vimHiTerm
  hi link vimHiGuiRgb	vimNumber
  hi link vimHiKeyError	vimError
  hi link vimHiStartStop	vimHiTerm
  hi link vimHighlight	vimCommand
  hi link vimKeyCode	vimSpecFile
  hi link vimKeyCodeError	vimError
  hi link vimLet		vimCommand
  hi link vimLineComment	vimComment
  hi link vimNotFunc	vimCommand
  hi link vimNotPatSep	vimString
  hi link vimPlainMark	vimMark
  hi link vimPlainRegister	vimRegister
  hi link vimSetString	vimString
  hi link vimSpecFileMod	vimSpecFile
  hi link vimStringCont	vimString
  hi link vimSynCaseError	vimError
  hi link vimSynContains	vimSynOption
  hi link vimSynKeyOpt	vimSynOption
  hi link vimSynMtchGrp	vimSynOption
  hi link vimSynMtchOpt	vimSynOption
  hi link vimSynNextgroup	vimSynOption
  hi link vimSynNotPatRange	vimSynRegPat
  hi link vimSynPatRange	vimString
  hi link vimSynRegOpt	vimSynOption
  hi link vimSynRegPat	vimString
  hi link vimSyntax	vimCommand
  hi link vimSynType	vimSpecial
  hi link vimSyncGroup	vimGroupName
  hi link vimSyncGroupName	vimGroupName
  hi link vimUserAttrb	vimSpecial
  hi link vimUserAttrbCmplt	vimSpecial
  hi link vimUserAttrbKey	vimOption
  hi link vimUserCmd	vimCommand

  hi link vimAutoEvent	Type
  hi link vimBracket	Delimiter
  hi link vimCmplxRepeat	SpecialChar
  hi link vimCommand	Statement
  hi link vimComment	Comment
  hi link vimCommentTitle	PreProc
  hi link vimContinue	Special
  hi link vimCtrlChar	SpecialChar
  hi link vimEnvvar	PreProc
  hi link vimError	Error
  hi link vimFuncName	Function
  hi link vimFuncVar	Identifier
  hi link vimGroup	Type
  hi link vimGroupSpecial	Special
  hi link vimHLMod	PreProc
  hi link vimHiAttrib	PreProc
  hi link vimHiTerm	Type
  hi link vimKeyword	Statement
  hi link vimMark	Number
  hi link vimNotation	Special
  hi link vimNumber	Number
  hi link vimOper	Operator
  hi link vimOption	PreProc
  hi link vimPatSep	SpecialChar
  hi link vimPattern	Type
  hi link vimRegister	SpecialChar
  hi link vimSetSep	Statement
  hi link vimSpecFile	Identifier
  hi link vimSpecial	Type
  hi link vimStatement	Statement
  hi link vimString	String
  hi link vimSubstPat	SpecialChar
  hi link vimSynCase	Type
  hi link vimSynCaseError	Error
  hi link vimSynError	Error
  hi link vimSynOption	Special
  hi link vimSynReg	Type
  hi link vimSyncC	Type
  hi link vimSyncError	Error
  hi link vimSyncKey	Type
  hi link vimSyncNone	Type
  hi link vimTodo	Todo
endif

let b:current_syntax = "vim"

" vim: ts=17
