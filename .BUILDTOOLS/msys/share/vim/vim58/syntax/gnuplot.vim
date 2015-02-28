" Vim syntax file
" Language:	gnuplot 3.7 pl0
" Maintainer:	John Hoelzel johnh51@bigfoot.com
" Last Change:	Mon Nov 20 13:11:31 PST 2000
" Filenames:    *.gpi  *.gih   scripts: #!*gnuplot
" URL:		http://bigfoot.com/~johnh51/vim/syntax/gnuplot.vim
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" some shortened names to make demo files look clean... jeh.

" commands
syn keyword gnuplotStatement	cd call clear exit set plot splot help
syn keyword gnuplotStatement	load pause quit fit rep[lot] quit if
syn keyword gnuplotStatement	FIT_LIMIT FIT_MAXITER FIT_START_LAMBDA FIT_LAMBDA_FACTOR FIT_LOG FIT_SCRIPT
syn keyword gnuplotStatement	print pwd reread reset save show test !  functions var
syn keyword gnuplotConditional	if
" numbers fm c.vim
"	integer number, or floating point number without a dot and with "f".
syn case    ignore
syn match   gnuplotNumber	"\<[0-9]\+\(u\=l\=\|lu\|f\)\>"
"	floating point number, with dot, optional exponent
syn match   gnuplotFloat	"\<[0-9]\+\.[0-9]*\(e[-+]\=[0-9]\+\)\=[fl]\=\>"
"	floating point number, starting with a dot, optional exponent
syn match   gnuplotFloat	"\.[0-9]\+\(e[-+]\=[0-9]\+\)\=[fl]\=\>"
"	floating point number, without dot, with exponent
syn match   gnuplotFloat	"\<[0-9]\+e[-+]\=[0-9]\+[fl]\=\>"
"	hex number
syn match   gnuplotNumber	"\<0x[0-9a-f]\+\(u\=l\=\|lu\)\>"
syn case    match
"	flag an octal number with wrong digits by not hilighting
syn match   gnuplotOctalError	"\<0[0-7]*[89]"

" plot args
syn keyword gnuplotType		using tit[le] notit[le] wi[th] steps fs[teps]
syn keyword gnuplotType		title notitle t
" t - too much?
syn keyword gnuplotType		with w
" w - too much?

syn keyword gnuplotType		li[nes] l
" l - too much?
syn keyword gnuplotType		linespoints via

" funcs
syn keyword gnuplotType		abs acos acosh arg asin asinh atan atanh atan2 besj0 besj1 besy0 besy1

syn keyword gnuplotType		ceil column cos cosh erf erfc exp floor gamma
syn keyword gnuplotType		ibeta inverf igamma imag invnorm int lgamma
syn keyword gnuplotType		log log10 norm rand real sgn sin sinh sqrt tan
syn keyword gnuplotType		tanh valid
" set vars
"   comment out items rarely used - if they slow you up too much.
syn keyword gnuplotType		xdata timefmt grid noytics ytics fs
syn keyword gnuplotType		logscale time notime mxtics style
syn keyword gnuplotType		axes x1y2 unique acsplines
syn keyword gnuplotType		size origin multiplot xtics xra[nge] yra[nge] square nosquare
syn keyword gnuplotType		binary matrix index every thru using smooth
syn keyword gnuplotType		angles degrees arrow noarrow autoscale noautoscale radians
" autoscale args = x y xy z t ymin ... - too much?
syn keyword gnuplotType		linear  cubicspline  bspline order level[s] auto disc[rete] incr[emental] from to head nohead graph nocontour base both nosurface table out[put] data
syn keyword gnuplotType		bar border noborder boxwidth
syn keyword gnuplotType		clabel noclabel clip noclip cntrp[aram] contour
syn keyword gnuplotType		dgrid3d nodgrid3d dummy encoding format
syn keyword gnuplotType		function grid hidden[3d] isosample[s] key nokey nohidden[3d]
syn keyword gnuplotType		defaults offset nooffset trianglepattern undefined noundefined altdiagonal bentover noaltdiagonal nobentover nogrid
syn keyword gnuplotType		left right top bottom outside below samplen spacing width box nobox linestyle ls linetype lt linewidth lw
syn keyword gnuplotType		label nolabel logscale nolog[scale] missing center font locale
syn keyword gnuplotType		mapping margin bmargin lmargin rmargin tmargin spherical cylindrical cartesian
syn keyword gnuplotType		linestyle nolinestyle linetype lt linewidth lw pointtype pt pointsize ps
syn keyword gnuplotType		nooffsets data candlesticks financebars linespoints lp vector nosurface
syn keyword gnuplotType		term[inal] linux aed767 aed512 gpic
syn keyword gnuplotType		regis tek410x tek40 vttek kc-tek40xx
syn keyword gnuplotType		km-tek40xx selanar bitgraph xlib x11 X11
syn keyword gnuplotType		aifm cgm dumb fig gif small large size
syn keyword gnuplotType		transparent hp2623a hp2648 hp500c pcl5
syn keyword gnuplotType		hpljii hpdj hppj imagen mif pbm png
syn keyword gnuplotType		postscript enhanced_postscript qms table
syn keyword gnuplotType		tgif tkcanvas epson-180dpi epson-60dpi
syn keyword gnuplotType		epson-lx800 nec-cp6 okidata starc
syn keyword gnuplotType		tandy-60dpi latex emtex pslatex pstex
syn keyword gnuplotType		eepic tpic pstricks texdraw mf metafont
syn keyword gnuplotType		timestamp notimestamp
syn keyword gnuplotType		variables version
syn keyword gnuplotType		x2data y2data ydata zdata
syn keyword gnuplotType		reverse writeback noreverse nowriteback
syn keyword gnuplotType		axis mirror autofreq nomirror rotate autofreq norotate
syn keyword gnuplotType		update
syn keyword gnuplotType		multiplot nomultiplot mxtics nomxtics mytics

syn keyword gnuplotType		nomytics mztics nomztics mx2tics nomx2tics
syn keyword gnuplotType		my2tics nomy2tics offsets origin output
syn keyword gnuplotType		para[metric] nopara[metric] pointsize polar nopolar
syn keyword gnuplotType		xrange yrange zrange x2range y2range rrange
syn keyword gnuplotType		trange urange vrange sample[s] size
syn keyword gnuplotType		bezier boxerrorbars boxes bargraph bar[s]
syn keyword gnuplotType		boxxyerrorbars csplines dots fsteps histeps impulses
syn keyword gnuplotType		lines linesp[oints] points poiinttype sbezier splines steps
" w lt lw ls          = optional
syn keyword gnuplotType		vectors xerr[orbars] xyerr[orbars] yerr[orbars] financebars candlesticks vector
syn keyword gnuplotType		errorbars surface
syn keyword gnuplotType		tics ticslevel ticscale time timefmt view
syn keyword gnuplotType		tm_hour tm_mday tm_min tm_mon tm_sec tm_wday tm_yday tm_year
syn keyword gnuplotType		xdata xdtics noxdtics ydtics noydtics zdtics
syn keyword gnuplotType		nozdtics x2dtics nox2dtics y2dtics noy2dtics
syn keyword gnuplotType		xlab[el] ylab[el] zlab[el] x2label y2label xmtics
syn keyword gnuplotType		noxmtics ymtics noymtics zmtics nozmtics x2mtics
syn keyword gnuplotType		nox2mtics y2mtics noy2mtics xtics noxtics ytics
syn keyword gnuplotType		noytics ztics noztics x2tics nox2tics y2tics
syn keyword gnuplotType		noy2tics zero nozero zeroaxis nozeroaxis xzeroaxis
syn keyword gnuplotType		noxzeroaxis yzeroaxis noyzeroaxis x2zeroaxis
syn keyword gnuplotType		nox2zeroaxis y2zeroaxis noy2zeroaxis angles

" comments + strings
syn region gnuplotComment	start="#" end="$"
syn region gnuplotComment	start=+"+ skip=+\\"+ end=+"+
syn region gnuplotComment	start=+'+            end=+'+

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_gnuplot_syntax_inits")
  if version < 508
    let did_gnuplot_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink gnuplotStatement	Statement
  HiLink gnuplotConditional	Conditional
  HiLink gnuplotNumber		Number
  HiLink gnuplotFloat		Float
  HiLink gnuplotOctalError	Error
  HiLink gnuplotType		Type
  HiLink gnuplotComment	Comment

  delcommand HiLink
endif

let b:current_syntax = "gnuplot"

" vim: ts=8
