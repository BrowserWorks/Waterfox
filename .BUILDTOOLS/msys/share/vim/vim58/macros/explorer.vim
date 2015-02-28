"=============================================================================
" File : explorer.vim
" Author : M A Aziz Ahmed (aziz@123india.com)
" Last update : Sun Feb 27 2000
" Version : 1.1
"-----------------------------------------------------------------------------
" This file implements a file explorer. Latest version available at:
" http://www.freespeech.org/aziz/vim/my_macros/
"-----------------------------------------------------------------------------
" Just type ,e to launch the file explorer (this file should have been
" sourced) in a separate window. Type ,s to split the current window and
" launch explorer there. If the current buffer is modified, the window is
" anyway split (irrespective of ,e or ,s).
" It is also possible to delete files and rename files within explorer.
" (In UNIX, renaming doesn't seem to work, though!)
" The directory which explorer uses by default is determined by the 'browsedir'
" option.
"=============================================================================

nmap ,e   :call ExplInitiate(0)<cr>
nmap ,s   :call ExplInitiate(1)<cr>
 
function! ExplInitiate(split, ...)
  if (expand("%:p:t")=="_fileExplorer.tmp")
    echo "Already in file explorer"
  else
    let g:oldCh=&ch
    let &ch=2
    if (a:0==0)
      call ExplInitializeDirName("")
    else
      call ExplInitializeDirName(a:1)
    endif
    if ((&modified==1) || (a:split==1))
      sp /_fileExplorer.tmp
      let b:splitWindow=1
    else
      e /_fileExplorer.tmp
      let b:splitWindow=0
    endif
    call ExplSyntaxFile()
    call ExplProcessFile(g:currDir)
  endif
endfunction

function! ExplInitializeDirName(dirName)
  if (a:dirName=="")
    if (exists("&bsdir"))
      if (&bsdir=="buffer")
        let startDir=expand("%:p:h")
      elseif ((!exists("g:currDir")) || (&bsdir=="current"))
        let startDir=getcwd()
      else
        let startDir=expand(g:currDir)
      endif
    elseif (!exists("g:currDir"))
      let startDir=getcwd()
    else
      let startDir=expand(g:currDir)
    endif
  else
    let startDir = a:dirName
  endif
  let g:currDir=(substitute(startDir,"\\","/","g"))."/"
  " In case the ending / was already a part of getcwd(), two //s would appear
  " at the end of g:currDir. So remove one of them
  let g:currDir=substitute(g:currDir,"//$","/","g")
  let g:currDir=substitute(g:currDir,"/./","/","g")
endfunction

function! ExplProcessFile(fileName)
  if ((isdirectory(a:fileName)) || (a:fileName==g:currDir."../"))
    "Delete all lines
    1,$d
    let oldRep=&report
    set report=1000
    if (a:fileName==g:currDir."../")
      let g:currDir=substitute(g:currDir,"/[^/]*/$","/","")
    else
      let g:currDir=a:fileName
    endif
    call ExplAddHeader()
    " exec("cd ".escape(g:currDir, ' '))
    call ExplDisplayFiles(g:currDir)
    normal zz
    echo "Loaded contents of ".g:currDir
    let &report=oldRep
  elseif (filereadable(a:fileName))
    if (filereadable(@#))
      exec("e! #")
    endif
    exec("e! ".escape(a:fileName, ' '))
    call ExplCloseExplorer()
  endif
  let &modified=0
endfunction

function! ExplGetFileName()
  return g:currDir.getline(".")
endfunction

function! ExplAddHeader()
    " Give a very brief help
    let @f="\" <enter> : open file or directory\n"
    let @f=@f."\" - : go up one level      c : change directory\n"
    let @f=@f."\" r : rename file          d : delete file\n"
    let @f=@f."\" q : quit file explorer   s : set this dir to current directory\n"
    let @f=@f."\"---------------------------------------------------\n"
    let @f=@f.". ".g:currDir."\n"
    let @f=@f."\"---------------------------------------------------\n"
    " Add parent directory
    let @f=@f."../\n"
    put! f
    $ 
    d
endfunction

function! ExplDisplayFiles(dir)
  let @f=glob(a:dir."*")
  if (@f!="")
    normal mt
    put f
    .,$g/^/call ExplMarkDirs()
    normal `t
  endif
endfunction

function! ExplMarkDirs()
  let oldRep=&report
  set report=1000
  "Remove slashes if added
  s;/$;;e  
  "Removes all the leading slashes and adds slashes at the end of directories
  s;^.*\\\([^\\]*\)$;\1;e
  s;^.*/\([^/]*\)$;\1;e
  normal ^
  if (isdirectory(ExplGetFileName()))
    s;$;/;
  else
    " Move the file at the end so that directories appear first
    m$
  endif
  let &report=oldRep
endfunction

function! ExplDeleteFile() range
  let oldRep = &report
  let &report = 1000

  let filesDeleted = 0
  let stopDel = 0
  let delAll = 0
  let currLine = a:firstline
  let lastLine = a:lastline
  while ((currLine <= lastLine) && (stopDel==0))
    exec(currLine)
    let fileName=ExplGetFileName()
    if (isdirectory(fileName))
      echo fileName." : Directory deletion not supported yet"
      let currLine = currLine + 1
    else
      if (delAll == 0)
        let sure=input("Delete ".fileName."?(y/n/a/q) ")
        if (sure=="a")
          let delAll = 1
        endif
      endif
      if ((sure=="y") || (sure=="a"))
        let success=delete(fileName)
        if (success!=0)
          exec (" ")
          echo "\nCannot delete ".fileName
          let currLine = currLine + 1
        else
          d
          let filesDeleted = filesDeleted + 1
          let lastLine = lastLine - 1
        endif
      elseif (sure=="q")
        let stopDel = 1
      elseif (sure=="n")
        let currLine = currLine + 1
      endif
    endif
  endwhile
  echo "\n".filesDeleted." files deleted"
  let &report = oldRep
  let &modified=0
endfunction

function! ExplRenameFile()
  let fileName=ExplGetFileName()
  if (isdirectory(fileName))
    echo "Directory renaming not supported yet"
  elseif (filereadable(fileName))
    let altName=input("Rename ".fileName." to : ")
    echo " "
    let success=rename(fileName, g:currDir.altName)
    if (success!=0)
      echo "Cannot rename ".fileName. " to ".altName
    else
      echo "Renamed ".fileName." to ".altName
      let oldRep=&report
      set report=1000
      exec("s/^\\S*$/".altName."/")
      let &report=oldRep
    endif
  endif
  let &modified=0
endfunction

function! ExplGotoDir(dummy, dirName)
  if (isdirectory(expand(a:dirName)))
    " Guess the complete path
    if (isdirectory(expand(getcwd()."/".a:dirName)))
      let dirpath=getcwd()."/".a:dirName
    else
      let dirpath=expand(a:dirName)
    endif
    call ExplInitializeDirName(dirpath)
    call ExplProcessFile(g:currDir)
  else
    echo a:dirName." : No such directory"
  endif
endfunction

function! ExplCloseExplorer()
  bd! /_fileExplorer.tmp
  if (exists("g:oldCh"))
    let &ch=g:oldCh
  endif
endfunction

function! ExplBack2PrevFile()
  if ((@#!="") && (@#!="_fileExplorer.tmp") && (b:splitWindow==0) && 
        \(isdirectory(@#)==0))
    exec("e #")
  endif
  call ExplCloseExplorer()
endfunction

function! ExplSyntaxFile()
  if 1 || has("syntax") && exists("syntax_on") && !has("syntax_items")
    syn match browseSynopsis	"^\".*"
    syn match browseDirectory	"[^\"].*/$"
    syn match browseCurDir	"^\. .*$"
    
    if !exists("g:did_browse_syntax_inits")
      let did_browse_syntax_inits = 1
      hi link browseSynopsis	PreProc
      hi link browseDirectory	Directory
      hi link browseCurDir	Statement
    endif
  endif
endfunction
      
function! ExplEditDir(fileName)
  if (isdirectory(a:fileName))
    " Do some processing if the path is relative..
    let completePath=expand("%:p")
    call ExplInitiate(0, completePath)
  elseif ((expand("%")=="") && (bufloaded(".")==1))
    " This is a workaround for a vim bug in Windows. When one tries to edit   
    " :e .
    " expand("%") *sometimes* returns a blank string
    call ExplInitiate(0, getcwd())
  endif
endfunction

augroup fileExplorer
  au!
  au BufEnter _fileExplorer.tmp let oldSwap=&swapfile | set noswapfile
  au BufLeave _fileExplorer.tmp let &swapfile=oldSwap
  au BufEnter _fileExplorer.tmp nm <cr> :call ExplProcessFile(ExplGetFileName())<cr>
  au BufLeave _fileExplorer.tmp nun <cr>
  au BufEnter _fileExplorer.tmp nm - :call ExplProcessFile(g:currDir."../")<cr>
  au BufLeave _fileExplorer.tmp nun -
  au BufEnter _fileExplorer.tmp nm c :ChangeDirectory to: 
  au BufLeave _fileExplorer.tmp nun c
  au BufEnter _fileExplorer.tmp nm r :call ExplRenameFile()<cr>
  au BufLeave _fileExplorer.tmp nun r
  au BufEnter _fileExplorer.tmp nm d :. call ExplDeleteFile()<cr>
  au BufLeave _fileExplorer.tmp nun d
  au BufEnter _fileExplorer.tmp vm d :call ExplDeleteFile()<cr>
  au BufLeave _fileExplorer.tmp vun d
  au BufEnter _fileExplorer.tmp nm q :call ExplBack2PrevFile()<cr>
  au BufLeave _fileExplorer.tmp nun q
  au BufEnter _fileExplorer.tmp nm s :exec ("cd ".escape(g:currDir,' '))<cr>
  au BufLeave _fileExplorer.tmp nun s
  au BufEnter _fileExplorer.tmp command! -nargs=+ -complete=dir ChangeDirectory call ExplGotoDir(<f-args>)
  au BufLeave _fileExplorer.tmp delcommand ChangeDirectory
  au BufEnter * nested call ExplEditDir(expand("%"))
augroup end
