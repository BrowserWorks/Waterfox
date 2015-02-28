" Vim syntax support file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	1998 Dec 6

" This file is used for ":syntax manual".
" It installs the Syntax autocommands, but no the FileType autocommands.

if has("syntax")

  " Load the Syntax autocommands and set the default methods for highlighting.
  if !exists("syntax_on")
    so <sfile>:p:h/synload.vim
  endif

  let syntax_manual = 1

  " Remove the connection between FileType and Syntax autocommands.
  au! syntax FileType

  " If the GUI is already running, may still need to install the FileType menu.
  if has("gui_running") && !exists("did_install_syntax_menu")
    source $VIMRUNTIME/menu.vim
  endif

endif " has("syntax")

" vim: ts=8 sts=0
