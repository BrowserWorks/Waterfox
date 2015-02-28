" diffwin.vim: a simple way to use diff to compare two source files
"		       and to synchronize the three windows to the current,
"		       next, and previous difference blocks.
" 
"	Author : Charles E. Campbell, Jr.   (Charles.E.Campbell.1@gsfc.nasa.gov)
"	Date   : 9/22/2000
"
" To enable: put this file into your <.vimrc> or source it from there.
"		You may wish to modify the maps' temporary directory;
"		its easiest to use vms's version: copy it, then :s/tmp:/newpath/g
"
" To use: start Vim as shown below, use \df to generate differences,
"         and then hit the <F8> key:
"
"		vim -o newfile oldfile
"       \df
"		<F8>
"
" The resulting three windows will look like this:
"
"		             Diff Block Format:
"		+----+
"		|diff|		*** oldfilename date
"		+----+		--- newfilename date
"		|new |		***************
"		+----+		*** #,# ****
"		|old |      how to convert new -> old (shows new stuff)
"		+----+      --- #,# ----
"                   how to convert old -> new (shows old stuff)
"                   ***************
"
" You can synchronize the files in the new&old windows to the current
" difference-block being considered: just move the cursor in the diff
" window to the difference of interest and hit the "\dc".  Use "\dn"
" (or "F8") and "\dp" to navigate to the next/previous difference block,
" respectively.
"
" Maps:
"  \df : opens a third window on top with the diff file.
"  \dc : synchronize windows to current  diff, cursor at new->old diff section
"  \dC : synchronize windows to current  diff, cursor at old->new diff section
"  \dn : synchronize windows to next     diff
"  \dp : synchronize windows to previous diff
"  \ds : reSet diff (re-runs diff on new/old/files)
"  \du : apply patch from down->up (old->new)
"  \db : apply patch from up->bottom (new->old)
"  <F8>: same as \dn
if version < 600
  if has("unix")
    map \df :let lzs1=&lz<CR><C-W>k:let tmpfile=tempname()<CR>:exe "!diff -c ".expand("#1")." ".expand("#2").">".tmpfile<CR><C-W>s:exe "e ".tmpfile<CR>:exe "!/bin/rm -f ".tmpfile<CR>:unlet tmpfile<CR>:set ft=diff<CR>gg:let &lz=lzs1<CR>\dn
  elseif has("win32")
    map \df :let lzs1=&lz<CR><C-W>k:let tmpfile=tempname()<CR>:exe "!diff -c ".expand("#1")." ".expand("#2").">".tmpfile<CR><C-W>s:exe "e ".tmpfile<CR>:exe "!erase ".tmpfile<CR>:unlet tmpfile<CR>:set ft=diff<CR>gg:let &lz=lzs1<CR>\dn
  elseif has("vms")
    map \df :let lzs1=&lz<CR><C-W>k:let tmpfile=tempname()<CR>:exe "!diff -c ".expand("#1")." ".expand("#2").">".tmpfile<CR><C-W>s:exe "e ".tmpfile<CR>:exe "!del ".tmpfile.";*"<CR>:unlet tmpfile<CR>:set ft=diff<CR>gg:let &lz=lzs1<CR>\dn
  endif
else
  map \df :let lzs1=&lz<CR><C-W>k<C-W>s:ene<CR>:exe "0r !diff -c ".expand("#1")." ".expand("#2")<CR>:set nomod<CR>:set ft=diff<CR>gg:let &lz=lzs1<CR>\dn
endif
map \dc	:let lzs3=&lz<CR><C-W>k<C-W>k?^\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*$<CR>jYpdwf,DAGz<C-V><CR><Esc>"bYdd<C-W>j@b<C-W>k?^\*\*\*\*\*<CR>/^--- <CR>Ypdwf,DAGz<C-V><CR><Esc>"aYdd2<C-W>j@a2<C-W>k?^\*\*\* <CR>z<CR>:set nomod<CR>:let &lz=lzs3<CR>:echo "diff converts middle window to lower window"<CR>
map \dC \dc/^--- <CR>z<CR>:echo "diff converts lower window to middle window"<CR>
map \dn :let lzs4=&lz<CR><C-W>k<C-W>k/^\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*$<CR>j\dc:let &lz=lzs4<CR>
map \dp	:let lzs5=&lz<CR><C-W>k<C-W>k?^\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*$<CR>?<CR>j\dc:let &lz=lzs5<CR>
if version >= 520
  map \ds :let lzs2=&lz<CR>:wa<CR>2<C-W>k:exe "0r !diff -c ".expand("#1")." ".expand("#2")<CR>:set nomod<CR>:set ft=diff<CR>gg:let &lz=lzs2<CR><CR>\dn
else
  map \ds :let lzs2=&lz<CR>:wa<CR>2<C-W>k:exe "0r !diff -c ".expand("#1")." ".expand("#2")<CR>:set nomod<CR>gg:let &lz=lzs2<CR><CR>\dn
endif
map <F8> \dc

" ---------------------------------------------------------------------

" Functions didn't enter vim until Version 5.2
if version >= 520
  map \db :call DiffPatch(0)<CR>\ds
  map \du :call DiffPatch(1)<CR>\ds
  " DiffPatch: applies current patch section to newfile/oldfile
  "  Uses anonymous register
  "  Variables:
  "    old2new: =1 DiffPatch being used to convert old -> new
  "             =0 DiffPatch being used to convert new -> old
  fu! DiffPatch(old2new)
  
    " use lazy updating
    let lzs8=&lz
    set lz
  
    exe "norm 2\<c-w>k?\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*\\*$\<CR>j"
    let newpat='\*\*\* \(\d\+\),\(\d\+\).*$'
    let new1=substitute(getline("."),newpat,'\1',"")
    let new2=substitute(getline("."),newpat,'\2',"")
  
    exe "norm /^--- \<CR>"
    let oldpat='--- \(\d\+\),\(\d\+\).*$'
    let old1=substitute(getline("."),oldpat,'\1',"")
    let old2=substitute(getline("."),oldpat,'\2',"")
  
    if a:old2new == 1
      exe "norm \<c-w>j:".new1.",".new2."d\<CR>"
      exe "norm \<c-w>j:".old1.",".old2."y\<CR>"
  	let new1=new1-1
  	exe "norm \<c-w>k".new1."Gp"
    else
      exe "norm 2\<c-w>j:".old1.",".old2."d\<CR>"
      exe "norm \<c-w>k:".new1.",".new2."y\<CR>"
  	let old1=old1-1
  	exe "norm \<c-w>j".old1."Gp"
    endif
  
    let &lz=lzs8
  endfunction
endif

" ---------------------------------------------------------------------
" vim:ts=4
