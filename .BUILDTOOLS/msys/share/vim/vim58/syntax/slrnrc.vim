" Vim syntax file
" Language:	Slrn setup file
" Maintainer:	Preben "Peppe" Guldberg (c928400@student.dtu.dk)
" Last Change:	Fri Apr  3 11:09:41 1998

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn keyword slrnrcTodo		contained Todo

" in some places white space is illegal
syn match slrnrcSpaceError	contained "\s"

syn match slrnrcNumber		contained "-\=\<\d\+\>"
syn match slrnrcNumber		contained +'[^']\+'+

syn match slrnrcSpecKey		contained +\(\\[e"']\|\^[^'"]\)+

syn match  slrnrcKey		contained "\S\+"	contains=slrnrcSpecKey
syn region slrnrcKey		contained start=+"+ skip=+\\"+ end=+"+ oneline contains=slrnrcSpecKey
syn region slrnrcKey		contained start=+'+ skip=+\\'+ end=+'+ oneline contains=slrnrcSpecKey

syn match slrnrcSpecChar	contained +'+
syn match slrnrcSpecChar	contained +\\[n"]+
syn match slrnrcSpecChar	contained "%[dfmnrs%]"

syn match  slrnrcString		contained /[^ \t%"']\+/	contains=slrnrcSpecChar
syn region slrnrcString		contained start=+"+ skip=+\\"+ end=+"+ oneline contains=slrnrcSpecChar

syn match slangPreCondit	"^#ifn\=\(def\>\|false\>\|true\>\|\$\)"
syn match slangPreCondit	"^#\(elif\|else\|endif\)\>"

syn match slrnrcComment		"%.*$"	contains=slrnrcTodo

syn keyword slrnrcVarInt	contained author_display beep cc_followup confirm_actions
syn keyword slrnrcVarInt	contained display_author_realname display_score
syn keyword slrnrcVarInt	contained group_dsc_start_column kill_score lines_per_update
syn keyword slrnrcVarInt	contained max_low_score min_high_score mouse
syn keyword slrnrcVarInt	contained new_subject_breaks_threads no_backups prompt_next_group
syn keyword slrnrcVarInt	contained query_next_article query_next_group
syn keyword slrnrcVarInt	contained query_read_group_cutoff query_reconnect read_active
syn keyword slrnrcVarInt	contained reject_long_lines scroll_by_page show_article
syn keyword slrnrcVarInt	contained show_descriptions show_thread_subject sorting_method
syn keyword slrnrcVarInt	contained spoiler_char spoiler_display_mode spool_check_up_on_nov
syn keyword slrnrcVarInt	contained uncollapse_threads unsubscribe_new_groups
syn keyword slrnrcVarInt	contained use_header_numbers use_metamail use_mime use_tilde
syn keyword slrnrcVarInt	contained use_tmpdir use_xgtitle wrap_flags write_newsrc_flags
syn keyword slrnrcVarInt	contained ignore_signature use_color use_blink use_grouplens
syn keyword slrnrcVarInt	contained use_inews use_slrnpull grouplens_port
" match as a "string" too
syn region  slrnrcVarIntStr	contained matchgroup=slrnrcVarInt start=+"+ end=+"+ oneline contains=slrnrcVarInt,slrnrcSpaceError

syn keyword slrnrcVarStr	contained Xbrowser art_help_line cc_followup_string charset
syn keyword slrnrcVarStr	contained custom_headers decode_directory editor_command
syn keyword slrnrcVarStr	contained followup_custom_headers followup_string group_help_line
syn keyword slrnrcVarStr	contained grouplens_host grouplens_pseudoname header_help_line
syn keyword slrnrcVarStr	contained inews_program macro_directory mail_editor_command
syn keyword slrnrcVarStr	contained metamail_command mime_charset non_Xbrowser organization
syn keyword slrnrcVarStr	contained post_editor_command post_object postpone_directory
syn keyword slrnrcVarStr	contained quote_string realname reply_custom_headers reply_string
syn keyword slrnrcVarStr	contained replyto save_directory save_posts save_replies
syn keyword slrnrcVarStr	contained score_editor_command sendmail_command server_object
syn keyword slrnrcVarStr	contained signature spool_active_file spool_activetimes_file
syn keyword slrnrcVarStr	contained spool_inn_root spool_newsgroups_file spool_nov_file
syn keyword slrnrcVarStr	contained spool_nov_root spool_root username
" obsolete
"syn keyword slrnrcVarStr	contained followup
" match as a "string" too
syn region  slrnrcVarStrStr	contained matchgroup=slrnrcVarStr start=+"+ end=+"+ oneline contains=slrnrcVarStr,slrnrcSpaceError

" various commands
syn region slrnrcCmdLine	matchgroup=slrnrcCmd start="^\s*\(autobaud\|grouplens_add\|hostname\|ignore_quotes\|include\|interpret\|nnrpaccess\|scorefile\|server\)\>" end="$" oneline contains=slrnrc\(String\|Comment\)

" setting variables
syn keyword slrnrcSet		contained set
syn match   slrnrcSetStr	"^\s*set\s\+\S\+" skipwhite nextgroup=slrnrcString contains=slrnrcSet,slrnrcVarStr\(Str\)\=
syn match   slrnrcSetInt	contained "^\s*set\s\+\S\+" contains=slrnrcSet,slrnrcVarInt\(Str\)\=
syn match   slrnrcSetIntLine	"^\s*set\s\+\S\+\s\+\(-\=\d\+\>\|'[^']\+'\)" contains=slrnrcSetInt,slrnrcNumber,slrnrcVarInt

" color definitions
syn keyword slrnrcColorObj	contained article author box cursor description error frame
syn keyword slrnrcColorObj	contained group grouplens_display header_name header_number
syn keyword slrnrcColorObj	contained headers high_score menu menu_press normal quotes
syn keyword slrnrcColorObj	contained response_char selection signature status subject
syn keyword slrnrcColorObj	contained thread_number tilde tree
syn region  slrnrcColorObjStr	contained matchgroup=slrnrcColorObj start=+"+ end=+"+ oneline contains=slrnrcColorObj,slrnrcSpaceError
syn keyword slrnrcColorVal	contained black red green brown blue magenta cyan lightgray
syn keyword slrnrcColorVal	contained gray brightred brightgreen yellow brightblue brightmagenta brightcyan white
syn region  slrnrcColorValStr	contained matchgroup=slrnrcColorVal start=+"+ end=+"+ oneline contains=slrnrcColorVal,slrnrcSpaceError
" mathcing a function with three arguments
syn keyword slrnrcColor		contained color
syn match   slrnrcColorInit	contained "^\s*color\s\+\S\+" skipwhite nextgroup=slrnrcColorVal\(Str\)\= contains=slrnrcColor\(Obj\|ObjStr\)\=
syn match   slrnrcColorLine	"^\s*color\s\+\S\+\s\+\S\+" skipwhite nextgroup=slrnrcColorVal\(Str\)\= contains=slrnrcColor\(Init\|Val\|ValStr\)

" mono settings
syn keyword slrnrcMonoVal	contained blink bold none reverse underline
syn region  slrnrcMonoValStr	contained matchgroup=slrnrcMonoVal start=+"+ end=+"+ oneline contains=slrnrcMonoVal,slrnrcSpaceError
" color object is inherited
" mono needs at least one argument
syn keyword slrnrcMono		contained mono
syn match   slrnrcMonoInit	contained "^\s*mono\s\+\S\+" contains=slrnrcMono,slrnrcColorObj\(Str\)\=
syn match   slrnrcMonoLine	"^\s*mono\s\+\S\+\s\+\S.*" contains=slrnrcMono\(Init\|Val\|ValStr\),slrnrcComment

" Functions in article mode
syn keyword slrnrcFunArt	contained art_bob art_eob art_xpunge article_linedn article_lineup
syn keyword slrnrcFunArt	contained article_pagedn article_pageup article_search
syn keyword slrnrcFunArt	contained author_search_backward author_search_forward browse_url
syn keyword slrnrcFunArt	contained cancel catchup catchup_all create_score decode delete
syn keyword slrnrcFunArt	contained delete_thread digit_arg down enlarge_window exchange_mark
syn keyword slrnrcFunArt	contained fast_quit followup forward forward_digest
syn keyword slrnrcFunArt	contained get_children_headers get_parent_header goto_article
syn keyword slrnrcFunArt	contained goto_beginning goto_end goto_last_read
syn keyword slrnrcFunArt	contained grouplens_rate_article header_bob header_eob help
syn keyword slrnrcFunArt	contained hide_article left locate_article locate_header_by_msgid
syn keyword slrnrcFunArt	contained mark_spot next next_high_score next_same_subject pagedn
syn keyword slrnrcFunArt	contained pageup pipe_article post post_postponed prev quit redraw
syn keyword slrnrcFunArt	contained repeat_last_key reply right save scroll_dn scroll_up
syn keyword slrnrcFunArt	contained show_spoilers shrink_window skip_quotes
syn keyword slrnrcFunArt	contained skip_to_next_group skip_to_prev_group
syn keyword slrnrcFunArt	contained subject_search_backward subject_search_forward suspend
syn keyword slrnrcFunArt	contained tag_header toggle_collapse_threads toggle_header_tag
syn keyword slrnrcFunArt	contained toggle_headers toggle_quotes toggle_rot13
syn keyword slrnrcFunArt	contained toggle_show_author toggle_sort uncatchup uncatchup_all
syn keyword slrnrcFunArt	contained undelete untag_headers up wrap_article

" Functions in group mode
syn keyword slrnrcFunGroup	contained add_group bob catchup digit_arg down eob group_bob
syn keyword slrnrcFunGroup	contained group_eob group_search group_search_forward help
syn keyword slrnrcFunGroup	contained move_group pagedown pageup post post_postponed quit
syn keyword slrnrcFunGroup	contained redraw refresh_groups repeat_last_key save_newsrc
syn keyword slrnrcFunGroup	contained select_group subscribe suspend toggle_group_display
syn keyword slrnrcFunGroup	contained toggle_hidden toggle_list_all toggle_scoring
syn keyword slrnrcFunGroup	contained transpose_groups uncatch_up unsubscribe up

" Functions in readline mode (actually from slang's slrline.c)
syn keyword slrnrcFunRead	contained bdel bol del deleol down enter eol left
syn keyword slrnrcFunRead	contained quoted_insert right trim up

" binding keys
syn keyword slrnrcSetkeyObj	contained article group readline
syn region  slrnrcSetkeyObjStr	contained matchgroup=slrnrcSetkeyObj start=+"+ end=+"+ oneline contains=slrnrcSetkeyObj
syn match   slrnrcSetkeyArt	contained '\("\=\)\<article\>\1\s\+\S\+' skipwhite nextgroup=slrnrcKey contains=slrnrcSetKeyObj\(Str\)\=,slrnrcFunArt
syn match   slrnrcSetkeyGroup	contained '\("\=\)\<group\>\1\s\+\S\+' skipwhite nextgroup=slrnrcKey contains=slrnrcSetKeyObj\(Str\)\=,slrnrcFunGroup
syn match   slrnrcSetkeyRead	contained '\("\=\)\<readline\>\1\s\+\S\+' skipwhite nextgroup=slrnrcKey contains=slrnrcSetKeyObj\(Str\)\=,slrnrcFunRead
syn match   slrnrcSetkey	"^\s*setkey\>" skipwhite nextgroup=slrnrcSetkeyArt,slrnrcSetkeyGroup,slrnrcSetkeyRead

" unbinding keys
syn match   slrnrcUnsetkey	'^\s*unsetkey\s\+\("\)\=\(article\|group\|readline\)\>\1' skipwhite nextgroup=slrnrcKey contains=slrnrcSetkeyObj\(Str\)\=

" uncomment these lines and the linking below to get these highlighted
"syn keyword slrnrcObsolete	ccfollowup_string decode_directory editor_command followup
"syn keyword slrnrcObsolete	organization quote_string realname replyto signature username

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_slrnrc_syntax_inits")
  if version < 508
    let did_slrnrc_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink slrnrcTodo		Todo
  HiLink slrnrcSpaceError	Error
  HiLink slrnrcNumber		Number
  HiLink slrnrcSpecKey		SpecialChar
  HiLink slrnrcKey		String
  HiLink slrnrcSpecChar	SpecialChar
  HiLink slrnrcString		String
  HiLink slangPreCondit	Special
  HiLink slrnrcComment		Comment
  HiLink slrnrcVarInt		Identifier
  HiLink slrnrcVarStr		Identifier
  HiLink slrnrcCmd		slrnrcSet
  HiLink slrnrcSet		Operator
  HiLink slrnrcColor		Keyword
  HiLink slrnrcColorObj	Identifier
  HiLink slrnrcColorVal	String
  HiLink slrnrcMono		Keyword
  HiLink slrnrcMonoObj		Identifier
  HiLink slrnrcMonoVal		String
  HiLink slrnrcFunArt		Macro
  HiLink slrnrcFunGroup	Macro
  HiLink slrnrcFunRead		Macro
  HiLink slrnrcSetkeyObj	Identifier
  HiLink slrnrcSetkey		Keyword
  HiLink slrnrcUnsetkey	slrnrcSetkey

  "HiLink slrnrcObsolete	Special

  delcommand HiLink
endif

let b:current_syntax = "slrnrc"

"EOF	vim: ts=8 noet tw=120 sw=8 sts=0
