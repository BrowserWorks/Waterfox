" Vim syntax file
" Language:	Mail file
" Maintainer:	Felix von Leitner <leitner@math.fu-berlin.de>
" Last Change:	2001 May 09

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" The mail header is recognized starting with a "keyword:" line and ending
" with an empty line or other line that can't be in the header.
" All lines of the header are highlighted
" For "From " matching case is required, not for the rest.
syn region	mailHeader	start="^From " skip="^[ \t]" end="^[-A-Za-z0-9/]*[^-A-Za-z0-9/:]"me=s-1 end="^[^:]*$"me=s-1 end="^---*" contains=mailHeaderKey,mailSubject

syn case ignore

syn region	mailHeader	start="^\(Newsgroups:\|From:\|To:\|Cc:\|Bcc:\|Reply-To:\|Subject:\|Return-Path:\|Received:\|Date:\|Replied:\)" skip="^[ \t]" end="^[-a-z0-9/]*[^-a-z0-9/:]"me=s-1 end="^[^:]*$"me=s-1 end="^---*" contains=mailHeaderKey,mailSubject

syn region	mailHeaderKey	contained start="^\(From\|To\|Cc\|Bcc\|Reply-To\).*" skip=",$" end="$" contains=mailEmail
syn match	mailHeaderKey	contained "^Date"

syn match	mailSubject	contained "^Subject.*"

syn match	mailEmail	contained "[_=a-z\.+A-Z0-9-]\+@[a-zA-Z0-9\./\-]\+"
syn match	mailEmail	contained "<.\{-}>"

syn region	mailSignature	start="^-- *$" end="^$"

" even and odd quoted lines
" removed ':', it caused too many bogus highlighting
" order is imporant here!
syn match	mailQuoted1	"^\([A-Za-z]\+>\|[]|}>]\).*$"
syn match	mailQuoted2	"^\(\([A-Za-z]\+>\|[]|}>]\)[ \t]*\)\{2}.*$"
syn match	mailQuoted3	"^\(\([A-Za-z]\+>\|[]|}>]\)[ \t]*\)\{3}.*$"
syn match	mailQuoted4	"^\(\([A-Za-z]\+>\|[]|}>]\)[ \t]*\)\{4}.*$"
syn match	mailQuoted5	"^\(\([A-Za-z]\+>\|[]|}>]\)[ \t]*\)\{5}.*$"
syn match	mailQuoted6	"^\(\([A-Za-z]\+>\|[]|}>]\)[ \t]*\)\{6}.*$"

" Need to sync on the header.  Assume we can do that within a hundred lines
syn sync lines=100

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ahdl_syn_inits")
  if version < 508
    let did_ahdl_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink mailHeaderKey		Type
  HiLink mailHeader		Statement
  HiLink mailQuoted1		Comment
  HiLink mailQuoted3		Comment
  HiLink mailQuoted5		Comment
  HiLink mailQuoted2		Identifier
  HiLink mailQuoted4		Identifier
  HiLink mailQuoted6		Identifier
  HiLink mailSignature		PreProc
  HiLink mailEmail		Special
  HiLink mailSubject		String

  delcommand HiLink
endif

let b:current_syntax = "mail"

" vim: ts=8
