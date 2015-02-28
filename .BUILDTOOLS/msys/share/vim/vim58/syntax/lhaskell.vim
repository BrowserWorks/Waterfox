" Vim syntax file
" Language:	Haskell with literate comments
" Maintainer:	John Williams <jrw@pobox.com>
" Last Change:	2001 May 09

" Enable literate comments
let b:hs_literate_comments=1

" Include standard Haskell highlighting
if version < 600
  source <sfile>:p:h/haskell.vim
else
  source syntax/haskell.vim
endif

" vim: ts=8
