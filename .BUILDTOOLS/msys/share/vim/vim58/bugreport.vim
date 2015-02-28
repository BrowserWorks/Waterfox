:" Use this script to create the file "bugreport.txt", which contains
:" information about the environment of a possible bug in Vim.
:"
:" Maintainer:	Bram Moolenaar <Bram@vim.org>
:" Last change:	2000 Feb 15
:"
:" To use inside Vim:
:"	:so $VIMRUNTIME/bugreport.vim
:" Or, from the command line:
:"	vim -s $VIMRUNTIME/bugreport.vim
:"
:" The "if 1" lines are to avoid error messages when expression evaluation is
:" not compiled in.
:"
:if 1
:  let more_save = &more
:endif
:set nomore
:if has("unix")
:  !echo "uname -a" >bugreport.txt
:  !uname -a >>bugreport.txt
:endif
:redir >>bugreport.txt
:version
:if 1
:  func BR_CheckDir(n)
:    if isdirectory(a:n)
:      echo 'directory "' . a:n . '" exists'
:    else
:      echo 'directory "' . a:n . '" does NOT exist'
:    endif
:  endfun
:  func BR_CheckFile(n)
:    if filereadable(a:n)
:      echo '"' . a:n . '" is readable'
:    else
:      echo '"' . a:n . '" is NOT readable'
:    endif
:  endfun
:  echo "--- Directories and Files ---"
:  echo '$VIM = "' . $VIM . '"'
:  call BR_CheckDir($VIM)
:  echo '$VIMRUNTIME = "' . $VIMRUNTIME . '"'
:  call BR_CheckDir($VIMRUNTIME)
:  call BR_CheckFile(&helpfile)
:  call BR_CheckFile(fnamemodify(&helpfile, ":h") . "/tags")
:  call BR_CheckFile($VIMRUNTIME . "/menu.vim")
:  call BR_CheckFile($VIMRUNTIME . "/filetype.vim")
:  call BR_CheckFile($VIMRUNTIME . "/syntax/synload.vim")
:  delfun BR_CheckDir
:  delfun BR_CheckFile
:endif
:set all
:set termcap
:if has("autocmd")
:  au
:endif
:if 1
:  echo "--- Normal mode mappings ---"
:endif
:map
:if 1
:  echo "--- Insert mode mappings ---"
:endif
:map!
:if 1
:  echo "--- Abbreviations ---"
:endif
:ab
:if 1
:  echo "--- Highlighting ---"
:endif
:highlight
:if 1
:  echo "--- Variables ---"
:endif
:if 1
:  let
:endif
:redir END
:set more&
:if 1
:  let &more = more_save
:endif
:e bugreport.txt
