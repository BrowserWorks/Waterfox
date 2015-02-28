" Vim syntax file
" Language: CVS commit file
" Maintainer:  Matt Dunford (zoot@zotikos.com)
" Last Change: Thu Apr 26 13:17:53 CEST 2001

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn region cvsLine  start="^CVS:" end="$" contains=cvsFile,cvsDir,cvsFiles
syn match cvsFile contained "\s\t.*"
syn match cvsDir  contained "Committing in.*$"
syn match cvsFiles contained "\S\+ Files:"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cvs_syn_inits")
	if version < 508
		let did_cvs_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink cvsLine		Comment
	HiLink cvsFile		Identifier
	HiLink cvsFiles		cvsDir
	HiLink cvsDir		Statement

	delcommand HiLink
endif

let b:current_syntax = "cvs"
