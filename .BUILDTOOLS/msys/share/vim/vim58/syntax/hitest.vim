" Vim syntax file
" Language:	none; used to see highlighting
" Maintainer:	Ronald Schild <rs@scutum.de>
" Last Change:	1999 Jul 07
" Version:	5.4n.1

" To see your current highlight settings, do
"    :so $VIMRUNTIME/syntax/hitest.vim

" save global options and registers
let save_hidden      = &hidden
let save_lazyredraw  = &lazyredraw
let save_more        = &more
let save_report      = &report
let save_shortmess   = &shortmess
let save_wrapscan    = &wrapscan
let save_register_a  = @a
let save_register_se = @/

" set global options
set hidden lazyredraw nomore report=99999 shortmess=aoOstTW wrapscan

" print current highlight settings into register a
redir @a
highlight
redir END

" Open a new window if the current one isn't empty
if line("$") != 1 || getline(1) != ""
  new
endif

" edit temporary file
edit Highlight\ test

" set local options
set autoindent noexpandtab formatoptions=t shiftwidth=16 noswapfile tabstop=16
let &textwidth=&columns

" insert highlight settings
% delete
put a

" remove color settings (not needed here)
global! /links to/ substitute /\s.*$//e

" move linked groups to the end of file
global /links to/ move $

" move linked group names to the matching preferred groups
% substitute /^\(\w\+\)\s*\(links to\)\s*\(\w\+\)$/\3\t\2 \1/e
global /links to/ normal mz3ElD0#$p'zdd

" delete empty lines
global /^ *$/ delete

" precede syntax command
% substitute /^[^ ]*/syn keyword &\t&/

" execute syntax commands
syntax clear
% yank a
@a

" remove syntax commands again
% substitute /^syn keyword //

" pretty formatting
global /^/ exe "normal Wi\<CR>\t\eAA\ex"
global /^\S/ join

" find out first syntax highlighting
let b:various = &highlight.',:Normal,:Cursor,:,'
let b:i = 1
while b:various =~ ':'.substitute(getline(b:i), '\s.*$', ',', '')
   let b:i = b:i + 1
   if b:i > line("$") | break | endif
endwhile

" insert headlines
call append(0, "Highlighting groups for various occasions")
call append(1, "-----------------------------------------")

if b:i < line("$")-1
   let b:synhead = "Syntax highlighting groups"
   if exists("hitest_filetypes")
      redir @a
      let
      redir END
      let @a = substitute(@a, 'did_\(\w\+\)_syn\w*_inits\s*#1', ', \1', 'g')
      let @a = substitute(@a, "\n\\w[^\n]*", '', 'g')
      let @a = substitute(@a, "\n", '', 'g')
      let @a = substitute(@a, '^,', '', 'g')
      if @a != ""
         let b:synhead = b:synhead." - filetype"
         if @a =~ ','
            let b:synhead = b:synhead."s"
         endif
         let b:synhead = b:synhead.":".@a
      endif
   endif
   call append(b:i+1, "")
   call append(b:i+2, b:synhead)
   call append(b:i+3, substitute(b:synhead, '.', '-', 'g'))
endif

" remove 'hls' highlighting
nohlsearch
normal 0

" add autocommands to remove temporary file from buffer list
aug highlighttest
   au!
   au BufUnload Highlight\ test if expand("<afile>") == "Highlight test"
   au BufUnload Highlight\ test    bdelete! Highlight\ test
   au BufUnload Highlight\ test endif
   au VimLeavePre * if bufexists("Highlight test")
   au VimLeavePre *    bdelete! Highlight\ test
   au VimLeavePre * endif
aug END

" we don't want to save this temporary file
set nomodified

" the following trick avoids the "Press RETURN ..." prompt
0 append
.

" restore global options and registers
let &hidden      = save_hidden
let &lazyredraw  = save_lazyredraw
let &more        = save_more
let &report      = save_report
let &shortmess   = save_shortmess
let &wrapscan    = save_wrapscan
let @a           = save_register_a

" restore last search pattern
call histdel("search", -1)
let @/ = save_register_se

" remove variables
unlet save_hidden save_lazyredraw save_more save_report save_shortmess
unlet save_wrapscan save_register_a save_register_se

" vim: ts=8
