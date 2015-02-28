" Vim syntax file
" Language:	Mutt setup files
" Maintainer:	Preben "Peppe" Guldberg (c928400@student.dtu.dk)
" Last Change:	Tue Jul 28 17:41:25 1998

" This file covers mutt version 0.74 and up (non developer)
" It has been updated for version 0.93i
" Over the time some features have vanished but are still included
" To get a syntax file for your specific version, see
"	http://www.student.dtu.dk/~c928400/vim

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Set the keyword characters
if version < 600
  set isk=@,48-57,_,-
else
  setlocal isk=@,48-57,_,-
endif

syn match muttrcComment		"^#.*$"
syn match muttrcComment		"[^\\]#.*$"lc=1

" Escape sequences (back-tick and pipe goes here too)
syn match muttrcEscape		+\\[#tnr"'Cc]+
syn match muttrcEscape		+[`|]+

" The variables takes the following arguments
syn match  muttrcString		"=\s*[^ #"']\+"lc=1 contains=muttrcEscape
syn region muttrcString		start=+"+ms=e skip=+\\"+ end=+"+ contains=muttrcEscape,muttrcSet,muttrcCommand
syn region muttrcString		start=+'+ms=e skip=+\\'+ end=+'+ contains=muttrcEscape,muttrcSet,muttrcCommand

syn match muttrcSpecial		+\(['"]\)!\1+

" Numbers and Quadoptions may be surrounded by " or '
syn match muttrcNumber		/=\s*\d\+/lc=1
syn match muttrcNumber		/"=\s*\d\+"/lc=2
syn match muttrcNumber		/'=\s*\d\+'/lc=2
syn match muttrcQuadopt		+=\s*\(ask-\)\=\(yes\|no\)+lc=1
syn match muttrcQuadopt		+"=\s*\(ask-\)\=\(yes\|no\)"+lc=2
syn match muttrcQuadopt		+'=\s*\(ask-\)\=\(yes\|no\)'+lc=2

" Now catch some email addresses and headers (purified version from mail.vim)
syn match muttrcEmail		"[a-zA-Z0-9._-]\+@[a-zA-Z0-9./-]\+"
syn match muttrcHeader		"\<\(From\|To\|Cc\|Bcc\|Reply-To\|Subject\)\>:\="
syn match muttrcHeader		"\<\(Return-Path\|Received\|Date\|Replied\|Attach\)\>:\="

syn match   muttrcKeySpecial	contained +\(\\[Cc'"]\|\^\|\\[01]\d\{2}\)+
syn match   muttrcKey		contained "\S\+"			contains=muttrcKeySpecial
syn region  muttrcKey		contained start=+"+ skip=+\\"+ end=+"+	contains=muttrcKeySpecial
syn region  muttrcKey		contained start=+'+ skip=+\\'+ end=+'+	contains=muttrcKeySpecial
syn match   muttrcKeyName	contained "\<f\(\d\|10\)\>"
syn match   muttrcKeyName	contained "\\[trne]"
syn match   muttrcKeyName	contained "\(<BackSpace>\|<Delete>\|<Down>\|<End>\|<Enter>\)"
syn match   muttrcKeyName	contained "\(<Home>\|<Insert>\|<Left>\|<PageDown>\|<PageUp>\)"
syn match   muttrcKeyName	contained "\(<Return>\|<Right>\|<Up>\)"

syn keyword muttrcVarBool	contained allow_8bit arrow_cursor ascii_chars askbcc askcc auto_tag
syn keyword muttrcVarBool	contained autoedit beep beep_new check_new confirmappend
syn keyword muttrcVarBool	contained confirmcreate edit_headers fast_reply fcc_attach
syn keyword muttrcVarBool	contained followup_to force_name forward_decode forward_quote hdrs
syn keyword muttrcVarBool	contained header help ignore_list_reply_to mark_old markers
syn keyword muttrcVarBool	contained menu_scroll meta_key metoo mime_forward_decode pager_stop
syn keyword muttrcVarBool	contained pgp_autoencrypt pgp_autosign pgp_encryptself pgp_long_ids
syn keyword muttrcVarBool	contained pgp_replyencrypt pgp_replysign pgp_strict_enc pipe_decode
syn keyword muttrcVarBool	contained pipe_split pop_delete prompt_after read_only resolve
syn keyword muttrcVarBool	contained reverse_alias reverse_name save_address save_empty
syn keyword muttrcVarBool	contained save_name sig_dashes smart_wrap sort_re status_on_top
syn keyword muttrcVarBool	contained strict_threads suspend thorough_search tilde use_8bitmime
syn keyword muttrcVarBool	contained use_domain use_from wait_key wrap_search

syn keyword muttrcVarBool	contained noallow_8bit noarrow_cursor noascii_chars noaskbcc noaskcc
syn keyword muttrcVarBool	contained noauto_tag noautoedit nobeep nobeep_new nocheck_new
syn keyword muttrcVarBool	contained noconfirmappend noconfirmcreate noedit_headers
syn keyword muttrcVarBool	contained nofast_reply nofcc_attach nofollowup_to noforce_name
syn keyword muttrcVarBool	contained noforward_decode noforward_quote nohdrs noheader nohelp
syn keyword muttrcVarBool	contained noignore_list_reply_to nomark_old nomarkers nomenu_scroll
syn keyword muttrcVarBool	contained nometa_key nometoo nomime_forward_decode nopager_stop
syn keyword muttrcVarBool	contained nopgp_autoencrypt nopgp_autosign nopgp_encryptself
syn keyword muttrcVarBool	contained nopgp_long_ids nopgp_replyencrypt nopgp_replysign
syn keyword muttrcVarBool	contained nopgp_strict_enc nopipe_decode nopipe_split nopop_delete
syn keyword muttrcVarBool	contained noprompt_after noread_only noresolve noreverse_alias
syn keyword muttrcVarBool	contained noreverse_name nosave_address nosave_empty nosave_name
syn keyword muttrcVarBool	contained nosig_dashes nosmart_wrap nosort_re nostatus_on_top
syn keyword muttrcVarBool	contained nostrict_threads nosuspend nothorough_search notilde
syn keyword muttrcVarBool	contained nouse_8bitmime nouse_domain nouse_from nowait_key
syn keyword muttrcVarBool	contained nowrap_search

syn keyword muttrcVarBool	contained invallow_8bit invarrow_cursor invascii_chars invaskbcc
syn keyword muttrcVarBool	contained invaskcc invauto_tag invautoedit invbeep invbeep_new
syn keyword muttrcVarBool	contained invcheck_new invconfirmappend invconfirmcreate
syn keyword muttrcVarBool	contained invedit_headers invfast_reply invfcc_attach invfollowup_to
syn keyword muttrcVarBool	contained invforce_name invforward_decode invforward_quote invhdrs
syn keyword muttrcVarBool	contained invheader invhelp invignore_list_reply_to invmark_old
syn keyword muttrcVarBool	contained invmarkers invmenu_scroll invmeta_key invmetoo
syn keyword muttrcVarBool	contained invmime_forward_decode invpager_stop invpgp_autoencrypt
syn keyword muttrcVarBool	contained invpgp_autosign invpgp_encryptself invpgp_long_ids
syn keyword muttrcVarBool	contained invpgp_replyencrypt invpgp_replysign invpgp_strict_enc
syn keyword muttrcVarBool	contained invpipe_decode invpipe_split invpop_delete invprompt_after
syn keyword muttrcVarBool	contained invread_only invresolve invreverse_alias invreverse_name
syn keyword muttrcVarBool	contained invsave_address invsave_empty invsave_name invsig_dashes
syn keyword muttrcVarBool	contained invsmart_wrap invsort_re invstatus_on_top
syn keyword muttrcVarBool	contained invstrict_threads invsuspend invthorough_search invtilde
syn keyword muttrcVarBool	contained invuse_8bitmime invuse_domain invuse_from invwait_key
syn keyword muttrcVarBool	contained invwrap_search

syn keyword muttrcVarQuad	contained abort_nosubject abort_unmodified copy delete include
syn keyword muttrcVarQuad	contained mime_forward move pgp_verify_sig postpone print quit
syn keyword muttrcVarQuad	contained recall reply_to use_mailcap

syn keyword muttrcVarQuad	contained noabort_nosubject noabort_unmodified nocopy nodelete
syn keyword muttrcVarQuad	contained noinclude nomime_forward nomove nopgp_verify_sig
syn keyword muttrcVarQuad	contained nopostpone noprint noquit norecall noreply_to
syn keyword muttrcVarQuad	contained nouse_mailcap

syn keyword muttrcVarQuad	contained invabort_nosubject invabort_unmodified invcopy invdelete
syn keyword muttrcVarQuad	contained invinclude invmime_forward invmove invpgp_verify_sig
syn keyword muttrcVarQuad	contained invpostpone invprint invquit invrecall invreply_to
syn keyword muttrcVarQuad	contained invuse_mailcap

syn keyword muttrcVarNum	contained history imap_checkinterval mail_check pager_context
syn keyword muttrcVarNum	contained pager_index_lines pgp_timeout pop_port read_inc
syn keyword muttrcVarNum	contained sendmail_wait timeout write_inc

syn keyword muttrcVarStr	contained alias_file alias_format alternates attribution charset
syn keyword muttrcVarStr	contained date_format default_hook delete_format dsn_notify
syn keyword muttrcVarStr	contained dsn_return edit_hdrs editor escape folder folder_format
syn keyword muttrcVarStr	contained forw_decode forw_format forw_quote forward_format
syn keyword muttrcVarStr	contained hdr_format hostname imap_pass imap_user in_reply_to
syn keyword muttrcVarStr	contained indent_str indent_string index_format ispell locale
syn keyword muttrcVarStr	contained mailcap_path mask mbox mbox_type message_format mime_fwd
syn keyword muttrcVarStr	contained msg_format pager pager_format pgp_default_version
syn keyword muttrcVarStr	contained pgp_default_version pgp_default_version pgp_gpg
syn keyword muttrcVarStr	contained pgp_key_version pgp_receive_version pgp_send_version
syn keyword muttrcVarStr	contained pgp_sign_as pgp_sign_micalg pgp_v2 pgp_v2_language
syn keyword muttrcVarStr	contained pgp_v2_pubring pgp_v2_secring pgp_v5 pgp_v5_language
syn keyword muttrcVarStr	contained pgp_v5_pubring pgp_v5_secring pipe_sep pop_host pop_pass
syn keyword muttrcVarStr	contained pop_user post_indent_str post_indent_string postponed
syn keyword muttrcVarStr	contained print_cmd print_command query_command quote_regexp
syn keyword muttrcVarStr	contained realname record reply_regexp sendmail shell signature
syn keyword muttrcVarStr	contained simple_search sort sort_alias sort_aux sort_browser
syn keyword muttrcVarStr	contained spoolfile status_chars status_format tmpdir to_chars
syn keyword muttrcVarStr	contained visual

syn keyword muttrcMenu		contained alias attach browser compose editor generic index pager
syn keyword muttrcMenu		contained pgp

syn keyword muttrcCommand	alternative_order auto_view fcc-hook fcc-save-hook folder-hook
syn keyword muttrcCommand	hdr_order ignore lists mailboxes mbox-hook my_hdr push reset
syn keyword muttrcCommand	save-hook score send-hook source toggle unalias uncolor unignore
syn keyword muttrcCommand	unlists unmy_hdr unscore unset

syn keyword muttrcSet		set     skipwhite nextgroup=muttrcVar.*
syn keyword muttrcUnset		unset   skipwhite nextgroup=muttrcVar.*

syn keyword muttrcBind		contained bind		skipwhite nextgroup=muttrcMenu
syn match   muttrcBindLine	"^\s*bind\s\+\S\+"	skipwhite nextgroup=muttrcKey\(Name\)\= contains=muttrcBind

syn keyword muttrcMacro		contained macro		skipwhite nextgroup=muttrcMenu
syn match   muttrcMacroLine	"^\s*macro\s\+\S\+"	skipwhite nextgroup=muttrcKey\(Name\)\= contains=muttrcMacro

syn keyword muttrcAlias		contained alias
syn match   muttrcAliasLine	"^\s*alias\s\+\S\+" contains=muttrcAlias

" Colour definitions takes object, foreground and background arguments (regexps excluded).
syn keyword muttrcColorField	contained attachment body bold error hdrdefault header index
syn keyword muttrcColorField	contained indicator markers message normal quoted search signature
syn keyword muttrcColorField	contained status tilde tree underline
syn match   muttrcColorField	contained "\<quoted\d\=\>"
syn keyword muttrcColorFG	contained black blue cyan default green magenta red white yellow
syn keyword muttrcColorFG	contained brightblue brightcyan brightdefault brightgreen
syn keyword muttrcColorFG	contained brightmagenta brightred brightwhite brightyellow
syn match   muttrcColorFG	contained "\<\(bright\)\=color\d\{1,2}\>"
syn keyword muttrcColorBG	contained black blue cyan default green magenta red white yellow
syn match   muttrcColorBG	contained "\<color\d\{1,2}\>"
" Now for the match
syn keyword muttrcColor		contained color			skipwhite nextgroup=muttrcColorField
syn match   muttrcColorInit	contained "^\s*color\s\+\S\+"	skipwhite nextgroup=muttrcColorFG contains=muttrcColor
syn match   muttrcColorLine	"^\s*color\s\+\S\+\s\+\S"	skipwhite nextgroup=muttrcColorBG contains=muttrcColorInit

" Mono are almost like color (ojects inherited from color)
syn keyword muttrcMonoAttrib	contained bold none normal reverse standout underline
syn keyword muttrcMono		contained mono		skipwhite nextgroup=muttrcColorField
syn match   muttrcMonoLine	"^\s*mono\s\+\S\+"	skipwhite nextgroup=muttrcMonoAttrib contains=muttrcMono

" obsolete
syn keyword muttrcKeyName	contained backspace delete down end enter home insert left pagedown
syn keyword muttrcKeyName	contained pageup return right up
syn keyword muttrcVarBool	contained confirmfiles confirmfolders hold no_hdrs pgp_replypgp
syn keyword muttrcVarBool	contained point_new noconfirmfiles noconfirmfolders nohold nono_hdrs
syn keyword muttrcVarBool	contained nopgp_replypgp nopoint_new invconfirmfiles
syn keyword muttrcVarBool	contained invconfirmfolders invhold invno_hdrs invpgp_replypgp
syn keyword muttrcVarBool	contained invpoint_new attach_split edit_hdrs forw_decode forw_quote
syn keyword muttrcVarBool	contained mime_fwd
syn keyword muttrcVarNum	contained references
syn keyword muttrcVarQuad	contained verify_sig
syn keyword muttrcVarStr	contained local_sig local_site pgp pgp_pubring pgp_secring
syn keyword muttrcVarStr	contained pgp_version remote_sig thread_chars url_regexp web_browser
syn keyword muttrcVarStr	contained decode_format pgp_v3 pgp_v3_language pgp_v3_pubring
syn keyword muttrcVarStr	contained pgp_v3_secring sendmail_bounce
syn keyword muttrcMenu		contained url
syn keyword muttrcCommand	alternates localsite unlocalsite

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_muttrc_syntax_inits")
  if version < 508
    let did_muttrc_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink muttrcComment		Comment
  HiLink muttrcEscape		SpecialChar
  HiLink muttrcString		String
  HiLink muttrcSpecial		Special
  HiLink muttrcNumber		Number
  HiLink muttrcQuadopt		Boolean
  HiLink muttrcEmail		Special
  HiLink muttrcHeader		Type
  HiLink muttrcKeySpecial	SpecialChar
  HiLink muttrcKey		Type
  HiLink muttrcKeyName		Macro
  HiLink muttrcVarBool		Identifier
  HiLink muttrcVarQuad		Identifier
  HiLink muttrcVarNum		Identifier
  HiLink muttrcVarStr		Identifier
  HiLink muttrcMenu		Identifier
  HiLink muttrcCommand		Keyword
  HiLink muttrcSet		muttrcCommand
  HiLink muttrcUnset		muttrcCommand
  HiLink muttrcBind		muttrcCommand
  HiLink muttrcMacro		muttrcCommand
  HiLink muttrcAlias		muttrcCommand
  HiLink muttrcAliasLine	Identifier
  HiLink muttrcColorField	Identifier
  HiLink muttrcColorFG		String
  HiLink muttrcColorBG		muttrcColorFG
  HiLink muttrcColor		muttrcCommand
  HiLink muttrcMonoAttrib	muttrcColorFG
  HiLink muttrcMono		muttrcCommand

  delcommand HiLink
endif

let b:current_syntax = "muttrc"

"EOF	vim: ts=8 noet tw=100 sw=8 sts=0
