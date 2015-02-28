" Vim syntax support file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 May 10

" Transform a file into HTML, using the current syntax highlighting.

" function to produce text with HTML codes for attributes and colors
"
" a:attr  contains 'U' for underline, 'I' for italic and 'B' for bold
" a:fg	  foregound color name
" a:bg    background color name
" a:txt   text
"
" the big return statement concatenates:
" - the code to start underline/italic/bold, substituting each 'U', 'I' or 'B'
"   by the same character inside <>
" - the code to start the background color
" - the code to start the foreground color
" - the text, where each '&', '<', '>' and '"' is translated for their special
"   meaning.  A CTRL-L is translated into a page break
" - the code to end the foreground color
" - the code to end the background color
" - the code to end underline/italic/bold, substituting each 'U', 'I' or 'B'
"   by the same character inside </>, in reverse order
function! HTMLPutText(attr, bg, fg, txt)
	let bgs = ""	" code for background color start
	let bge = ""	" code for background color end
	if a:bg != ""
	  let bgs = '<SPAN style="background-color: ' . a:bg . '">'
	  let bge = '</SPAN>'
	endif
	let fgs = ""	" code for foreground color start
	let fge = ""	" code for foreground color end
	if a:fg != ""
	  let fgs = '<FONT color=' . a:fg . ">"
	  let fge = '</FONT>'
	endif
	return substitute(a:attr, '.', '<&>', 'g') . bgs . fgs . substitute(substitute(substitute(substitute(substitute(a:txt, '&', '\&amp;', 'g'), '<', '\&lt;', 'g'), '>', '\&gt;', 'g'), '"', '\&quot;', 'g'), "\x0c", '<HR class=PAGE-BREAK>', 'g') . fge . bge . substitute(a:attr[2] . a:attr[1] . a:attr[0], '.', '</&>', 'g')
endfun


if &t_Co == 8
  let cterm_color0  = "#808080"
  let cterm_color1  = "#ff6060"
  let cterm_color2  = "#00ff00"
  let cterm_color3  = "#ffff00"
  let cterm_color4  = "#8080ff"
  let cterm_color5  = "#ff40ff"
  let cterm_color6  = "#00ffff"
  let cterm_color7  = "#ffffff"
else
  let cterm_color0  = "#000000"
  let cterm_color1  = "#c00000"
  let cterm_color2  = "#008000"
  let cterm_color3  = "#804000"
  let cterm_color4  = "#0000c0"
  let cterm_color5  = "#c000c0"
  let cterm_color6  = "#008080"
  let cterm_color7  = "#c0c0c0"
  let cterm_color8  = "#808080"
  let cterm_color9  = "#ff6060"
  let cterm_color10 = "#00ff00"
  let cterm_color11 = "#ffff00"
  let cterm_color12 = "#8080ff"
  let cterm_color13 = "#ff40ff"
  let cterm_color14 = "#00ffff"
  let cterm_color15 = "#ffffff"
endif

function! HTMLColor(c)
  if exists("g:cterm_color" . a:c)
    execute "return g:cterm_color" . a:c
  else
    return ""
  endif
endfun

" Set some options to make it work faster.
" Expand tabs in original buffer to get 'tabstop' correctly used.
let old_title = &title
let old_icon = &icon
let old_paste = &paste
let old_et = &et
set notitle noicon paste et

" Split window to create a buffer with the HTML file.
if expand("%") == ""
  new Untitled.html
else
  new %.html
endif
1,$d
set noet
" Find out the background and foreground color.
if has("gui_running")
  let bg = synIDattr(highlightID("Normal"), "bg#", "gui")
  let fg = synIDattr(highlightID("Normal"), "fg#", "gui")
else
  let bg = HTMLColor(synIDattr(highlightID("Normal"), "bg", "cterm"))
  let fg = HTMLColor(synIDattr(highlightID("Normal"), "fg", "cterm"))
endif
if bg == ""
   if &background == "dark"
     let bg = "#000000"
     if fg == ""
       let fg = "#FFFFFF"
     endif
   else
     let bg = "#FFFFFF"
     if fg == ""
       let fg = "#000000"
     endif
   endif
endif

" Insert HTML header, with the background color.  Add the foreground color
" only when it is defined.
exe "normal a<HTML>\n<HEAD>\n<TITLE>".expand("%:t")."</TITLE>\n</HEAD>\n<BODY BGcolor=".bg."\e"
if fg != ""
  exe "normal a TEXT=".fg."\e"
endif
exe "normal a>\n<PRE>\n\e"

exe "normal \<C-W>p"

" Some 'constants' for ease of addressing with []
let uline = "U"
let bld = "B"
let itl = "I"

" Loop over all lines in the original text
let end = line("$")
let lnum = 1
while lnum <= end

  " Get the current line, with tabs expanded to spaces when needed
  let line = getline(lnum)
  if match(line, "\t") >= 0
    exe lnum . "retab!"
    let did_retab = 1
    let line = getline(lnum)
  else
    let did_retab = 0
  endif
  let len = strlen(line)
  let new = ""

  if exists("html_number_color")
    let new = '<FONT COLOR=' . html_number_color . '>' . strpart('        ', 0, strlen(line("$")) - strlen(lnum)) . lnum . '</FONT>  '
  endif

  " Loop over each character in the line
  let col = 1
  while col <= len
    let startcol = col " The start column for processing text
    let id = synID(lnum, col, 1)
    let col = col + 1
    " Speed loop (it's small - that's the trick)
    " Go along till we find a change in synID
    while col <= len && id == synID(lnum, col, 1) | let col = col + 1 | endwhile

    " output the text with the same synID, with all its attributes
    " The first part turns attributes into  [U][I][B]
    let id = synIDtrans(id)
    if has("gui_running")
      let new = new . HTMLPutText(uline[synIDattr(id, "underline", "gui") - 1] . itl[synIDattr(id, "italic", "gui") - 1] . bld[synIDattr(id, "bold", "gui") - 1], synIDattr(id, "bg#", "gui"), synIDattr(id, "fg#", "gui"), strpart(line, startcol - 1, col - startcol))
    else
      let new = new . HTMLPutText(uline[synIDattr(id, "underline", "cterm") - 1] . itl[synIDattr(id, "italic", "cterm") - 1] . bld[synIDattr(id, "bold", "cterm") - 1], HTMLColor(synIDattr(id, "bg", "cterm")), HTMLColor(synIDattr(id, "fg", "cterm")), strpart(line, startcol - 1, col - startcol))
    endif
    if col > len
      break
    endif
  endwhile
  if did_retab
    undo
  endif

  exe "normal \<C-W>pa" . strtrans(new) . "\n\e\<C-W>p"
  let lnum = lnum + 1
  +
endwhile
" Finish with the last line
exe "normal \<C-W>pa</PRE>\n</BODY>\n</HTML>\e"

let &title = old_title
let &icon = old_icon
let &paste = old_paste
exe "normal \<C-W>p"
let &et = old_et
exe "normal \<C-W>p"

" In case they didn't get used
let startcol = 0
let id = 0
unlet uline bld itl lnum end col startcol line len new id
unlet old_title old_icon old_paste old_et did_retab bg fg
unlet cterm_color0 cterm_color1 cterm_color2 cterm_color3
unlet cterm_color4 cterm_color5 cterm_color6 cterm_color7
if &t_Co != 8
  unlet cterm_color8 cterm_color9 cterm_color10 cterm_color11
  unlet cterm_color12 cterm_color13 cterm_color14 cterm_color15
endif
delfunc HTMLPutText
delfunc HTMLColor
