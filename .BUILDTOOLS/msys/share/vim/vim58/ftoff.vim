" Vim support file to switch off detection of file types
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Feb 02

if exists("did_load_filetypes")
  unlet did_load_filetypes
endif

" Remove all autocommands in the filetype group
au! filetype *

" vim: ts=8 tw=0 sts=0
