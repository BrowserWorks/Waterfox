" Vim syntax file
" Language:	php PHP 3/4
" Maintainer:	Lutz Eymers <ixtab@polzin.com>
" URL:		http://www.isp.de/data/php.vim
" Email:	Subject: send syntax_vim.tgz
" Last Change:	2001 May 10
"
" Options	php_sql_query = 1  for SQL syntax highligthing inside strings
"               php_htmlInStrings = 1  for HTML syntax highligthing inside strings
"		php_minlines = x  to sync at least x lines backwards
"		php_baselib = 1  for highlighting baselib functions
"		php_asp_tags = 1  for highlighting ASP-style short tags
"		php_parentError = 1  for highligthing parent error
"		php_oldStyle = 1  for using old colorstyle
"               php_noShortTags = 1  don't sync <? ?> as php

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'php'
endif

if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

syn cluster htmlPreproc add=phpRegion,phpDoubleString

if exists( "php_sql_query")
  syn include @phpAddStrings <sfile>:p:h/sql.vim
  unlet b:current_syntax
endif
syn cluster phpAddStrings remove=sqlString,sqlComment

if exists( "php_htmlInStrings")
  syn cluster phpAddStrings add=@htmlTop
endif

syn case match

" Env Variables
syn keyword	phpEnvVar       GATEWAY_INTERFACE SERVER_NAME SERVER_SOFTWARE SERVER_PROTOCOL REQUEST_METHOD QUERY_STRING DOCUMENT_ROOT HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_CONNECTION HTTP_HOST HTTP_REFERER HTTP_USER_AGENT REMOTE_ADDR REMOTE_PORT SCRIPT_FILENAME SERVER_ADMIN SERVER_PORT SERVER_SIGNATURE PATH_TRANSLATED SCRIPT_NAME REQUEST_URI     contained

" Internal Variables
syn keyword	phpIntVar GLOBALS HTTP_GET_VARS HTTP_POST_VARS HTTP_COOKIE_VARS	HTTP_POST_FILES HTTP_ENV_VARS HTTP_SERVER_VARS PHP_ERRMSG PHP_SELF	contained

syn case ignore

" Comment
syn region	phpComment	start="/\*" skip="?>" end="\*/"	contained contains=phpTodo,phpNoEnd
syn match	phpComment	"#.*$"	contained contains=phpTodo,phpNoEnd
syn match	phpComment	"//.*$"	contained contains=phpTodo,phpNoEnd

" Function names
syn keyword	phpEnvVar  require include require_once include_once	contained
syn keyword	phpFunctions  apache_lookup_uri apache_note getallheaders virtual ascii2ebcdic ebcdic2ascii	contained
syn keyword	phpFunctions  array array_count_values array_diff array_filter array_flip array_intersect array_keys array_map array_merge array_merge_recursive array_multisort array_pad array_pop array_push array_rand array_reverse array_reduce array_shift array_slice array_splice array_sum array_unique array_unshift array_values array_walk arsort asort compact count current each end extract in_array array_search key krsort ksort list natsort natcasesort next pos prev range reset rsort shuffle sizeof sort uasort uksort usort	contained
syn keyword	phpFunctions  aspell_new aspell_check aspell_check_raw aspell_suggest	contained
syn keyword	phpFunctions  bcadd bccomp bcdiv bcmod bcmul bcpow bcscale bcsqrt bcsub	contained
syn keyword	phpFunctions  bzclose bzcompress bzdecompress bzerrno bzerror bzerrstr bzflush bzopen bzread bzwrite	contained
syn keyword	phpFunctions  jdtogregorian gregoriantojd jdtojulian juliantojd jdtojewish jewishtojd jdtofrench frenchtojd jdmonthname jddayofweek easter_date easter_days unixtojd jdtounix	contained
syn keyword	phpFunctions  com_load com_invoke com_propget com_get com_propput com_propset com_set	contained
syn keyword	phpFunctions  call_user_method_array call_user_method class_exists get_class get_class_methods get_class_vars get_declared_classes get_object_vars get_parent_class is_subclass_of method_exists	contained
syn keyword	phpFunctions  cpdf_global_set_document_limits cpdf_set_creator cpdf_set_title cpdf_set_subject cpdf_set_keywords cpdf_open cpdf_close cpdf_page_init cpdf_finalize_page cpdf_finalize cpdf_output_buffer cpdf_save_to_file cpdf_set_current_page cpdf_begin_text cpdf_end_text cpdf_show cpdf_show_xy cpdf_text cpdf_set_font cpdf_set_leading cpdf_set_text_rendering cpdf_set_horiz_scaling cpdf_set_text_rise cpdf_set_text_matrix cpdf_set_text_pos cpdf_set_char_spacing cpdf_set_word_spacing cpdf_continue_text cpdf_stringwidth cpdf_save cpdf_restore cpdf_translate cpdf_scale cpdf_rotate cpdf_setflat cpdf_setlinejoin cpdf_setlinecap cpdf_setmiterlimit cpdf_setlinewidth cpdf_setdash cpdf_newpath cpdf_moveto cpdf_rmoveto cpdf_curveto cpdf_lineto cpdf_rlineto cpdf_circle cpdf_arc cpdf_rect cpdf_closepath cpdf_stroke cpdf_closepath_stroke cpdf_fill cpdf_fill_stroke cpdf_closepath_fill_stroke cpdf_clip cpdf_setgray_fill cpdf_setgray_stroke cpdf_setgray cpdf_setrgbcolor_fill cpdf_setrgbcolor_stroke cpdf_setrgbcolor cpdf_add_outline cpdf_set_page_animation cpdf_import_jpeg cpdf_place_inline_image cpdf_add_annotation	contained
syn keyword	phpFunctions  curl_init curl_setopt curl_exec curl_close curl_version	contained
syn keyword	phpFunctions  cybercash_encr cybercash_decr cybercash_base64_encode cybercash_base64_decode	contained
syn keyword	phpFunctions  ctype_alnum ctype_alpha ctype_cntrl ctype_digit ctype_lower ctype_graph ctype_print ctype_punct ctype_space ctype_upper ctype_xdigit	contained
syn keyword	phpFunctions  dba_close dba_delete dba_exists dba_fetch dba_firstkey dba_insert dba_nextkey dba_popen dba_open dba_optimize dba_replace dba_sync	contained
syn keyword	phpFunctions  checkdate date getdate gettimeofday gmdate gmmktime gmstrftime localtime microtime mktime strftime time strtotime	contained
syn keyword	phpFunctions  dbase_create dbase_open dbase_close dbase_pack dbase_add_record dbase_replace_record dbase_delete_record dbase_get_record dbase_get_record_with_names dbase_numfields dbase_numrecords	contained
syn keyword	phpFunctions  dbmopen dbmclose dbmexists dbmfetch dbminsert dbmreplace dbmdelete dbmfirstkey dbmnextkey dblist	contained
syn keyword	phpFunctions  dbx_close dbx_connect dbx_error dbx_query dbx_sort dbx_cmp_asc dbx_cmp_desc	contained
syn keyword	phpFunctions  chroot chdir closedir getcwd opendir readdir rewinddir	contained
syn keyword	phpFunctions  xmldoc xmldocfile xmltree domxml_root domxml_add_root domxml_dumpmem domxml_attributes domxml_get_attribute domxml_set_attribute domxml_children domxml_new_child domxml_new_xmldoc xpath_new_context xpath_eval	contained
syn keyword	phpFunctions  error_log error_reporting restore_error_handler set_error_handler trigger_error user_error	contained
syn keyword	phpFunctions  filepro filepro_fieldname filepro_fieldtype filepro_fieldwidth filepro_retrieve filepro_fieldcount filepro_rowcount	contained
syn keyword	phpFunctions  basename chgrp chmod chown clearstatcache copy delete dirname diskfreespace fclose feof fflush fgetc fgetcsv fgets fgetss file file_exists fileatime filectime filegroup fileinode filemtime fileowner fileperms filesize filetype flock fopen fpassthru fputs fread fscanf fseek fstat ftell ftruncate fwrite set_file_buffer is_dir is_executable is_file is_link is_readable is_writable is_writeable is_uploaded_file link linkinfo mkdir move_uploaded_file pathinfo pclose popen readfile readlink rename rewind rmdir stat lstat realpath symlink tempnam tmpfile touch umask unlink	contained
syn keyword	phpFunctions  fdf_open fdf_close fdf_create fdf_save fdf_get_value fdf_set_value fdf_next_field_name fdf_set_ap fdf_set_status fdf_get_status fdf_set_file fdf_get_file fdf_set_flags fdf_set_opt fdf_set_submit_form_action fdf_set_javascript_action	contained
syn keyword	phpFunctions  ftp_connect ftp_login ftp_pwd ftp_cdup ftp_chdir ftp_mkdir ftp_rmdir ftp_nlist ftp_rawlist ftp_systype ftp_pasv ftp_get ftp_fget ftp_put ftp_fput ftp_size ftp_mdtm ftp_rename ftp_delete ftp_site ftp_quit	contained
syn keyword	phpFunctions  call_user_func_array call_user_func create_function func_get_arg func_get_args func_num_args function_exists get_defined_functions register_shutdown_function	contained
syn keyword	phpFunctions  bindtextdomain dcgettext dgettext gettext textdomain	contained
syn keyword	phpFunctions  gmp_init gmp_intval gmp_strval gmp_add gmp_sub gmp_mul gmp_div_q gmp_div_r gmp_div_qr gmp_div gmp_mod gmp_divexact gmp_cmp gmp_neg gmp_abs gmp_sign gmp_fact gmp_sqrt gmp_sqrtrm gmp_perfect_square gmp_pow gmp_powm gmp_prob_prime gmp_gcd gmp_gcdext gmp_invert gmp_legendre gmp_jacobi gmp_random gmp_and gmp_or gmp_xor gmp_setbit gmp_clrbit gmp_scan0 gmp_scan1 gmp_popcount gmp_hamdist	contained
syn keyword	phpFunctions  header headers_sent setcookie	contained
syn keyword	phpFunctions  hw_array2objrec hw_children hw_childrenobj hw_close hw_connect hw_cp hw_deleteobject hw_docbyanchor hw_docbyanchorobj hw_document_attributes hw_document_bodytag hw_document_content hw_document_setcontent hw_document_size hw_errormsg hw_edittext hw_error hw_free_document hw_getparents hw_getparentsobj hw_getchildcoll hw_getchildcollobj hw_getremote hw_getremotechildren hw_getsrcbydestobj hw_getobject hw_getandlock hw_gettext hw_getobjectbyquery hw_getobjectbyqueryobj hw_getobjectbyquerycoll hw_getobjectbyquerycollobj hw_getchilddoccoll hw_getchilddoccollobj hw_getanchors hw_getanchorsobj hw_mv hw_identify hw_incollections hw_info hw_inscoll hw_insdoc hw_insertdocument hw_insertobject hw_mapid hw_modifyobject hw_new_document hw_objrec2array hw_output_document hw_pconnect hw_pipedocument hw_root hw_unlock hw_who hw_getusername	contained
syn keyword	phpFunctions  icap_open icap_close icap_fetch_event icap_list_events icap_store_event icap_delete_event icap_snooze icap_list_alarms	contained
syn keyword	phpFunctions  getimagesize imagealphablending imagearc imagefilledarc imageellipse imagefilledellipse imagechar imagecharup imagecolorallocate imagecolordeallocate imagecolorat imagecolorclosest imagecolorclosestalpha imagecolorexact imagecolorexactalpha imagecolorresolve imagecolorresolvealpha imagegammacorrect imagecolorset imagecolorsforindex imagecolorstotal imagecolortransparent imagecopy imagecopymerge imagecopymergegray imagecopyresized imagecopyresampled imagecreate imagecreatetruecolor imagetruecolortopalette imagecreatefromgif imagecreatefromjpeg imagecreatefrompng imagecreatefromwbmp imagecreatefromstring imagedashedline imagedestroy imagefill imagefilledpolygon imagefilledrectangle imagefilltoborder imagefontheight imagefontwidth imagegif imagepng imagejpeg imagewbmp imageinterlace imageline imageloadfont imagepolygon imagepsbbox imagepsencodefont imagepsfreefont imagepsloadfont imagepsextendfont imagepsslantfont imagepstext imagerectangle imagesetpixel imagesetbrush imagesettile imagesetthickness imagestring imagestringup imagesx imagesy imagettfbbox imagettftext imagetypes read_exif_data	contained
syn keyword	phpFunctions  imap_8bit imap_alerts imap_append imap_base64 imap_binary imap_body imap_check imap_clearflag_full imap_close imap_createmailbox imap_delete imap_deletemailbox imap_errors imap_expunge imap_fetch_overview imap_fetchbody imap_fetchheader imap_fetchstructure imap_get_quota imap_getmailboxes imap_getsubscribed imap_header imap_headerinfo imap_headers imap_last_error imap_listmailbox imap_listsubscribed imap_mail imap_mail_compose imap_mail_copy imap_mail_move imap_mailboxmsginfo imap_mime_header_decode imap_msgno imap_num_msg imap_num_recent imap_open imap_ping imap_qprint imap_renamemailbox imap_reopen imap_rfc822_parse_adrlist imap_rfc822_parse_headers imap_rfc822_write_address imap_scanmailbox imap_search imap_set_quota imap_setflag_full imap_sort imap_status imap_subscribe imap_uid imap_undelete imap_unsubscribe imap_utf7_decode imap_utf7_encode imap_utf8	contained
syn keyword	phpFunctions  ifx_connect ifx_pconnect ifx_close ifx_query ifx_prepare ifx_do ifx_error ifx_errormsg ifx_affected_rows ifx_getsqlca ifx_fetch_row ifx_htmltbl_result ifx_fieldtypes ifx_fieldproperties ifx_num_fields ifx_num_rows ifx_free_result ifx_create_char ifx_free_char ifx_update_char ifx_get_char ifx_create_blob ifx_copy_blob ifx_free_blob ifx_get_blob ifx_update_blob ifx_blobinfile_mode ifx_textasvarchar ifx_byteasvarchar ifx_nullformat ifxus_create_slob ifxus_free_slob ifxus_close_slob ifxus_open_slob ifxus_tell_slob ifxus_seek_slob ifxus_read_slob ifxus_write_slob	contained
syn keyword	phpFunctions  ibase_connect ibase_pconnect ibase_close ibase_query ibase_fetch_row ibase_fetch_object ibase_field_info ibase_free_result ibase_prepare ibase_execute ibase_trans ibase_commit ibase_rollback ibase_free_query ibase_timefmt ibase_num_fields ibase_errmsg	contained
syn keyword	phpFunctions  ingres_connect ingres_pconnect ingres_close ingres_query ingres_num_rows ingres_num_fields ingres_field_name ingres_field_type ingres_field_nullable ingres_field_length ingres_field_precision ingres_field_scale ingres_fetch_array ingres_fetch_row ingres_fetch_object ingres_rollback ingres_commit ingres_autocommit	contained
syn keyword	phpFunctions  ldap_add ldap_bind ldap_close ldap_compare ldap_connect ldap_count_entries ldap_delete ldap_dn2ufn ldap_err2str ldap_errno ldap_error ldap_explode_dn ldap_first_attribute ldap_first_entry ldap_free_result ldap_get_attributes ldap_get_dn ldap_get_entries ldap_get_option ldap_get_values ldap_get_values_len ldap_list ldap_modify ldap_mod_add ldap_mod_del ldap_mod_replace ldap_next_attribute ldap_next_entry ldap_read ldap_search ldap_set_option ldap_unbind	contained
syn keyword	phpFunctions  mail ezmlm_hash	contained
syn keyword	phpFunctions  abs acos asin atan atan2 base_convert bindec ceil cos decbin dechex decoct deg2rad exp floor getrandmax hexdec lcg_value log log10 max min mt_rand mt_srand mt_getrandmax number_format octdec pi pow rad2deg rand round sin sqrt srand tan	contained
syn keyword	phpFunctions  mcal_open mcal_popen mcal_reopen mcal_close mcal_create_calendar mcal_rename_calendar mcal_delete_calendar mcal_fetch_event mcal_list_events mcal_append_event mcal_store_event mcal_delete_event mcal_snooze mcal_list_alarms mcal_event_init mcal_event_set_category mcal_event_set_title mcal_event_set_description mcal_event_set_start mcal_event_set_end mcal_event_set_alarm mcal_event_set_class mcal_is_leap_year mcal_days_in_month mcal_date_valid mcal_time_valid mcal_day_of_week mcal_day_of_year mcal_date_compare mcal_next_recurrence mcal_event_set_recur_none mcal_event_set_recur_daily mcal_event_set_recur_weekly mcal_event_set_recur_monthly_mday mcal_event_set_recur_monthly_wday mcal_event_set_recur_yearly mcal_fetch_current_stream_event mcal_event_add_attribute mcal_expunge	contained
syn keyword	phpFunctions  mcrypt_get_cipher_name mcrypt_get_block_size mcrypt_get_key_size mcrypt_create_iv mcrypt_cbc mcrypt_cfb mcrypt_ecb mcrypt_ofb mcrypt_list_algorithms mcrypt_list_modes mcrypt_get_iv_size mcrypt_encrypt mcrypt_decrypt mcrypt_module_open mcrypt_generic_init mcrypt_generic mdecrypt_generic mcrypt_generic_end mcrypt_enc_self_test mcrypt_enc_is_block_algorithm_mode mcrypt_enc_is_block_algorithm mcrypt_enc_is_block_mode mcrypt_enc_get_block_size mcrypt_enc_get_key_size mcrypt_enc_get_supported_key_sizes mcrypt_enc_get_iv_size mcrypt_enc_get_algorithms_name mcrypt_enc_get_modes_name mcrypt_module_self_test mcrypt_module_is_block_algorithm_mode mcrypt_module_is_block_algorithm mcrypt_module_is_block_mode mcrypt_module_get_algo_block_size mcrypt_module_get_algo_key_size mcrypt_module_get_algo_supported_key_sizes	contained
syn keyword	phpFunctions  mhash_get_hash_name mhash_get_block_size mhash_count mhash mhash_keygen_s2k	contained
syn keyword	phpFunctions  mssql_close mssql_connect mssql_data_seek mssql_fetch_array mssql_fetch_field mssql_fetch_object mssql_fetch_row mssql_field_length mssql_field_name mssql_field_seek mssql_field_type mssql_free_result mssql_get_last_message mssql_min_error_severity mssql_min_message_severity mssql_num_fields mssql_num_rows mssql_pconnect mssql_query mssql_result mssql_select_db	contained
syn keyword	phpFunctions  connection_aborted connection_status connection_timeout constant define defined die eval exit get_browser highlight_file highlight_string ignore_user_abort iptcparse leak pack show_source sleep uniqid unpack usleep	contained
syn keyword	phpFunctions  udm_add_search_limit udm_alloc_agent udm_api_version udm_clear_search_limits udm_errno udm_error udm_find udm_free_agent udm_free_ispell_data udm_free_res udm_get_doc_count udm_get_res_field udm_get_res_param udm_load_ispell_data udm_set_agent_param	contained
syn keyword	phpFunctions  msql msql_affected_rows msql_close msql_connect msql_create_db msql_createdb msql_data_seek msql_dbname msql_drop_db msql_dropdb msql_error msql_fetch_array msql_fetch_field msql_fetch_object msql_fetch_row msql_fieldname msql_field_seek msql_fieldtable msql_fieldtype msql_fieldflags msql_fieldlen msql_free_result msql_freeresult msql_list_fields msql_listfields msql_list_dbs msql_listdbs msql_list_tables msql_listtables msql_num_fields msql_num_rows msql_numfields msql_numrows msql_pconnect msql_query msql_regcase msql_result msql_select_db msql_selectdb msql_tablename	contained
syn keyword	phpFunctions  mysql_affected_rows mysql_change_user mysql_close mysql_connect mysql_create_db mysql_data_seek mysql_db_name mysql_db_query mysql_drop_db mysql_errno mysql_error mysql_fetch_array mysql_fetch_assoc mysql_fetch_field mysql_fetch_lengths mysql_fetch_object mysql_fetch_row mysql_field_flags mysql_field_name mysql_field_len mysql_field_seek mysql_field_table mysql_field_type mysql_free_result mysql_insert_id mysql_list_dbs mysql_list_fields mysql_list_tables mysql_num_fields mysql_num_rows mysql_pconnect mysql_query mysql_result mysql_select_db mysql_tablename	contained
syn keyword	phpFunctions  checkdnsrr closelog debugger_off debugger_on define_syslog_variables fsockopen gethostbyaddr gethostbyname gethostbynamel getmxrr getprotobyname getprotobynumber getservbyname getservbyport ip2long long2ip openlog pfsockopen socket_get_status socket_set_blocking socket_set_timeout syslog	contained
syn keyword	phpFunctions  odbc_autocommit odbc_binmode odbc_close odbc_close_all odbc_commit odbc_connect odbc_cursor odbc_do odbc_error odbc_errormsg odbc_exec odbc_execute odbc_fetch_into odbc_fetch_row odbc_field_name odbc_field_num odbc_field_type odbc_field_len odbc_field_precision odbc_field_scale odbc_free_result odbc_longreadlen odbc_num_fields odbc_pconnect odbc_prepare odbc_num_rows odbc_result odbc_result_all odbc_rollback odbc_setoption odbc_tables odbc_tableprivileges odbc_columns odbc_columnprivileges odbc_gettypeinfo odbc_primarykeys odbc_foreignkeys odbc_procedures odbc_procedurecolumns odbc_specialcolumns odbc_statistics	contained
syn keyword	phpFunctions  ocidefinebyname ocibindbyname ocilogon ociplogon ocinlogon ocilogoff ociexecute ocicommit ocirollback ocinewdescriptor ocirowcount ocinumcols ociresult ocifetch ocifetchinto ocifetchstatement ocicolumnisnull ocicolumnname ocicolumnsize ocicolumntype ociserverversion ocistatementtype ocinewcursor ocifreestatement ocifreecursor ocifreedesc ociparse ocierror ociinternaldebug	contained
syn keyword	phpFunctions  openssl_error_string openssl_free_key openssl_get_privatekey openssl_get_publickey openssl_open openssl_seal openssl_sign openssl_verify openssl_pkcs7_decrypt openssl_pkcs7_encrypt openssl_pkcs7_sign openssl_pkcs7_verify openssl_x509_checkpurpose openssl_x509_free openssl_x509_parse openssl_x509_read	contained
syn keyword	phpFunctions  ora_bind ora_close ora_columnname ora_columnsize ora_columntype ora_commit ora_commitoff ora_commiton ora_do ora_error ora_errorcode ora_exec ora_fetch ora_fetch_into ora_getcolumn ora_logoff ora_logon ora_plogon ora_numcols ora_numrows ora_open ora_parse ora_rollback	contained
syn keyword	phpFunctions  ovrimos_connect ovrimos_close ovrimos_close_all ovrimos_longreadlen ovrimos_prepare ovrimos_execute ovrimos_cursor ovrimos_exec ovrimos_fetch_into ovrimos_fetch_row ovrimos_result ovrimos_result_all ovrimos_num_rows ovrimos_num_fields ovrimos_field_name ovrimos_field_type ovrimos_field_len ovrimos_field_num ovrimos_free_result ovrimos_commit ovrimos_rollback	contained
syn keyword	phpFunctions  flush ob_start ob_get_contents ob_get_length ob_gzhandler ob_end_flush ob_end_clean ob_implicit_flush	contained
syn keyword	phpFunctions  pdf_add_annotation pdf_add_bookmark pdf_add_launchlink pdf_add_locallink pdf_add_note pdf_add_outline pdf_add_pdflink pdf_add_thumbnail pdf_add_weblink pdf_arc pdf_arcn pdf_attach_file pdf_begin_page pdf_begin_pattern pdf_begin_template pdf_circle pdf_clip pdf_close pdf_closepath pdf_closepath_fill_stroke pdf_closepath_stroke pdf_close_image pdf_close_pdi pdf_close_pdi_page pdf_concat pdf_continue_text pdf_curveto pdf_delete pdf_end_page pdf_endpath pdf_end_pattern pdf_end_template pdf_fill pdf_fill_stroke pdf_findfont pdf_get_buffer pdf_get_font pdf_get_fontname pdf_get_fontsize pdf_get_image_height pdf_get_image_width pdf_get_parameter pdf_get_pdi_parameter pdf_get_pdi_value pdf_get_value pdf_initgraphics pdf_lineto pdf_makespotcolor pdf_moveto pdf_new pdf_open pdf_open_ccitt pdf_open_file pdf_open_gif pdf_open_image pdf_open_image_file pdf_open_jpeg pdf_open_pdi pdf_open_pdi_page pdf_open_png pdf_open_tiff pdf_place_image pdf_place_pdi_page pdf_rect pdf_restore pdf_rotate pdf_save pdf_scale pdf_setcolor pdf_setdash pdf_setflat pdf_setfont pdf_setgray pdf_setgray_fill pdf_setgray_stroke pdf_setlinecap pdf_setlinejoin pdf_setlinewidth pdf_setmatrix pdf_setmiterlimit pdf_setpolydash pdf_setrgbcolor pdf_setrgbcolor_fill pdf_setrgbcolor_stroke pdf_set_border_color pdf_set_border_dash pdf_set_border_style pdf_set_char_spacing pdf_set_duration pdf_set_font pdf_set_horiz_scaling pdf_set_info pdf_set_leading pdf_set_parameter pdf_set_text_pos pdf_set_text_rendering pdf_set_text_rise pdf_set_transition pdf_set_value pdf_set_word_spacing pdf_show pdf_show_boxed pdf_show_xy pdf_skew pdf_stringwidth pdf_stroke pdf_translate pdf_open_memory_image	contained
syn keyword	phpFunctions  pfpro_init pfpro_cleanup pfpro_process pfpro_process_raw pfpro_version	contained
syn keyword	phpFunctions  assert assert_options extension_loaded dl getenv get_cfg_var get_current_user get_magic_quotes_gpc get_magic_quotes_runtime getlastmod getmyinode getmypid getmyuid getrusage ini_alter ini_get ini_restore ini_set phpcredits phpinfo phpversion php_logo_guid php_sapi_name php_uname putenv set_magic_quotes_runtime set_time_limit zend_logo_guid get_loaded_extensions get_extension_funcs get_required_files get_included_files zend_version	contained
syn keyword	phpFunctions  posix_kill posix_getpid posix_getppid posix_getuid posix_geteuid posix_getgid posix_getegid posix_setuid posix_setgid posix_getgroups posix_getlogin posix_getpgrp posix_setsid posix_setpgid posix_getpgid posix_getsid posix_uname posix_times posix_ctermid posix_ttyname posix_isatty posix_getcwd posix_mkfifo posix_getgrnam posix_getgrgid posix_getpwnam posix_getpwuid posix_getrlimit	contained
syn keyword	phpFunctions  pg_close pg_cmdtuples pg_connect pg_dbname pg_end_copy pg_errormessage pg_exec pg_fetch_array pg_fetch_object pg_fetch_row pg_fieldisnull pg_fieldname pg_fieldnum pg_fieldprtlen pg_fieldsize pg_fieldtype pg_freeresult pg_getlastoid pg_host pg_loclose pg_locreate pg_loexport pg_loimport pg_loopen pg_loread pg_loreadall pg_lounlink pg_lowrite pg_numfields pg_numrows pg_options pg_pconnect pg_port pg_put_line pg_result pg_set_client_encoding pg_client_encoding pg_trace pg_tty pg_untrace	contained
syn keyword	phpFunctions  escapeshellarg escapeshellcmd exec passthru system	contained
syn keyword	phpFunctions  pspell_add_to_personal pspell_add_to_session pspell_check pspell_clear_session pspell_config_create pspell_config_ignore pspell_config_mode pspell_config_personal pspell_config_repl pspell_config_runtogether pspell_config_save_repl pspell_new pspell_new_config pspell_new_personal pspell_save_wordlist pspell_store_replacement pspell_suggest	contained
syn keyword	phpFunctions  readline readline_add_history readline_clear_history readline_completion_function readline_info readline_list_history readline_read_history readline_write_history	contained
syn keyword	phpFunctions  recode_string recode recode_file	contained
syn keyword	phpFunctions  preg_match preg_match_all preg_replace preg_replace_callback preg_split preg_quote preg_grep	contained
syn keyword	phpFunctions  ereg ereg_replace eregi eregi_replace split spliti sql_regcase	contained
syn keyword	phpFunctions  satellite_caught_exception satellite_exception_id satellite_exception_value	contained
syn keyword	phpFunctions  sem_get sem_acquire sem_release shm_attach shm_detach shm_remove shm_put_var shm_get_var shm_remove_var	contained
syn keyword	phpFunctions  sesam_connect sesam_disconnect sesam_settransaction sesam_commit sesam_rollback sesam_execimm sesam_query sesam_num_fields sesam_field_name sesam_diagnostic sesam_fetch_result sesam_affected_rows sesam_errormsg sesam_field_array sesam_fetch_row sesam_fetch_array sesam_seek_row sesam_free_result	contained
syn keyword	phpFunctions  session_start session_destroy session_name session_module_name session_save_path session_id session_register session_unregister session_unset session_is_registered session_get_cookie_params session_set_cookie_params session_decode session_encode session_set_save_handler session_cache_limiter	contained
syn keyword	phpFunctions  shmop_open shmop_read shmop_write size shmop_delete shmop_close	contained
syn keyword	phpFunctions  swf_openfile swf_closefile swf_labelframe swf_showframe swf_setframe swf_getframe swf_mulcolor swf_addcolor swf_placeobject swf_modifyobject swf_removeobject swf_nextid swf_startdoaction swf_actiongotoframe swf_actiongeturl swf_actionnextframe swf_actionprevframe swf_actionplay swf_actionstop swf_actiontogglequality swf_actionwaitforframe swf_actionsettarget swf_actiongotolabel swf_enddoaction swf_defineline swf_definerect swf_definepoly swf_startshape swf_shapelinesold swf_shapefilloff swf_shapefillsolid swf_shapefillbitmapclip swf_shapefillbitmaptile swf_shapemoveto swf_shapelineto swf_shapecurveto swf_shapecurveto3 swf_shapearc swf_endshape swf_definefont swf_setfont swf_fontsize swf_fontslant swf_fonttracking swf_getfontinfo swf_definetext swf_textwidth swf_definebitmap swf_getbitmapinfo swf_startsymbol swf_endsymbol swf_startbutton swf_addbuttonrecord swf_oncondition swf_endbutton swf_viewport swf_ortho swf_ortho2 swf_perspective swf_polarview swf_lookat swf_pushmatrix swf_popmatrix swf_scale swf_translate swf_rotate swf_posround	contained
syn keyword	phpFunctions  snmpget snmpset snmpwalk snmpwalkoid snmp_get_quick_print snmp_set_quick_print	contained
syn keyword	phpFunctions  accept_connect bind close connect listen read socket strerror write	contained
syn keyword	phpFunctions  addcslashes addslashes bin2hex chop chr chunk_split convert_cyr_string count_chars crc32 crypt echo explode get_html_translation_table get_meta_tags hebrev hebrevc htmlentities htmlspecialchars implode join levenshtein localeconv ltrim md5 metaphone nl2br ord parse_str print printf quoted_printable_decode quotemeta rtrim sscanf setlocale similar_text soundex sprintf strncasecmp strcasecmp strchr strcmp strcoll strcspn strip_tags stripcslashes stripslashes stristr strlen strnatcmp strnatcasecmp strncmp str_pad strpos strrchr str_repeat strrev strrpos strspn strstr strtok strtolower strtoupper str_replace strtr substr substr_count substr_replace trim ucfirst ucwords wordwrap	contained
syn keyword	phpFunctions  sybase_affected_rows sybase_close sybase_connect sybase_data_seek sybase_fetch_array sybase_fetch_field sybase_fetch_object sybase_fetch_row sybase_field_seek sybase_free_result sybase_get_last_message sybase_min_client_severity sybase_min_error_severity sybase_min_message_severity sybase_min_server_severity sybase_num_fields sybase_num_rows sybase_pconnect sybase_query sybase_result sybase_select_db	contained
syn keyword	phpFunctions  base64_decode base64_encode parse_url rawurldecode rawurlencode urldecode urlencode	contained
syn keyword	phpFunctions  doubleval empty gettype get_defined_vars get_resource_type intval is_array is_bool is_double is_float is_int is_integer is_long is_null is_numeric is_object is_real is_resource is_scalar is_string isset print_r serialize settype strval unserialize unset var_dump	contained
syn keyword	phpFunctions  wddx_serialize_value wddx_serialize_vars wddx_packet_start wddx_packet_end wddx_add_vars wddx_deserialize	contained
syn keyword	phpFunctions  xml_parser_create xml_set_object xml_set_element_handler xml_set_character_data_handler xml_set_processing_instruction_handler xml_set_default_handler xml_set_unparsed_entity_decl_handler xml_set_notation_decl_handler xml_set_external_entity_ref_handler xml_parse xml_get_error_code xml_error_string xml_get_current_line_number xml_get_current_column_number xml_get_current_byte_index xml_parse_into_struct xml_parser_free xml_parser_set_option xml_parser_get_option utf8_decode utf8_encode	contained
syn keyword	phpFunctions  xslt_closelog xslt_create xslt_errno xslt_error xslt_fetch_result xslt_free xslt_openlog xslt_output_begintransform xslt_output_endtransform xslt_process xslt_run xslt_set_sax_handler xslt_transform	contained
syn keyword	phpFunctions  yaz_addinfo yaz_close yaz_connect yaz_errno yaz_error yaz_hits yaz_element yaz_database yaz_range yaz_record yaz_search yaz_present yaz_syntax yaz_scan yaz_scan_result yaz_ccl_conf yaz_ccl_parse yaz_itemorder yaz_wait	contained
syn keyword	phpFunctions  yp_get_default_domain yp_order yp_master yp_match yp_first yp_next	contained
syn keyword	phpFunctions  gzclose gzeof gzfile gzgetc gzgets gzgetss gzopen gzpassthru gzputs gzread gzrewind gzseek gztell gzwrite readgzfile gzcompress gzuncompress gzdeflate gzinflate gzencode	contained
syn keyword	phpFunctions  base64_encode xml_parser_create xml_parser_set_option xml_parse xml_parser_create	contained

if exists( "php_baselib" )
  syn keyword	phpBaselib	query next_record num_rows affected_rows nf f p np num_fields haltmsg seek link_id query_id metadata table_names nextid connect halt free register unregister is_registered delete url purl self_url pself_url hidden_session add_query padd_query reimport_get_vars reimport_post_vars reimport_cookie_vars set_container set_tokenname release_token put_headers get_id get_id put_id freeze thaw gc reimport_any_vars start url purl login_if is_authenticated auth_preauth auth_loginform auth_validatelogin auth_refreshlogin auth_registerform auth_doregister start check have_perm permsum perm_invalid	contained
  syn keyword	phpFunctions	page_open page_close sess_load sess_save	contained
endif

" Conditional
syn keyword	phpConditional	if else elseif endif switch endswitch	contained

" Repeat
syn keyword	phpRepeat	do for while endwhile foreach	contained

" Repeat
syn keyword	phpLabel	case default switch	contained

" Statement
syn keyword phpStatement        break return continue exit contained

" Keyword
syn keyword	phpKeyword      var     contained

" Type
syn keyword	phpType	int integer real double float string array object	contained

" Structure
syn keyword	phpStructure	class extends	contained

" StorageClass
syn keyword	phpStorageClass	global static	contained

" Operator
syn match	phpOperator	"[-=+%^&|*!.~?:]"	contained
syn match	phpOperator	"[-+*/%^&|.]="	contained
syn match	phpOperator	"/[^*/]"me=e-1	contained
syn match	phpOperator	"\$"	contained
syn match	phpOperator	"&&\|\<and\>"	contained
syn match	phpOperator	"||\|\<x\=or\>"	contained
syn match	phpRelation	"[!=<>]="	contained
syn match	phpRelation	"[<>]"	contained
syn match	phpMemberSelector	"->"	contained
syn match	phpVarSelector	"\$"	contained

" Identifier
syn match	phpIdentifier	"$\h\w*"	contained contains=phpEnvVar,phpIntVar,phpVarSelector

" Methoden
syn match	phpMethods	"->\h\w*"	contained contains=phpBaselib,phpMemberSelector

" Include
syn keyword	phpInclude	include require include_once require_once       contained

" Define
syn keyword	phpDefine	Function cfunction new	contained

" Boolean
syn keyword	phpBoolean	true false	contained

" String
syn region	phpStringDouble	keepend matchgroup=None start=+"+ skip=+\\\\\|\\"+  end=+"+ contains=@phpAddStrings,phpIdentifier,phpSpecialChar contained
syn region	phpStringSingle	keepend matchgroup=None start=+'+ skip=+\\\\\|\\'+  end=+'+ contains=@phpAddStrings,phpSpecialChar contained

" Number
syn match phpNumber	"-\=\<\d\+\>"	contained

" Float
syn match phpFloat	"\(-\=\<\d+\|-\=\)\.\d\+\>"	contained

" SpecialChar
syn match phpSpecialChar	"\\[abcfnrtyv\\]"	contained
syn match phpSpecialChar	"\\\d\{3}"	contained contains=phpOctalError
syn match phpSpecialChar	"\\x[0-9a-fA-F]\{2}"	contained

" Error
syn match phpOctalError	"[89]"	contained
syn match phpParentError	"[)}\]]"	contained

" Todo
syn keyword	phpTodo TODO Todo todo	contained

syn cluster	phpInside	contains=phpComment,phpFunctions,phpIdentifier,phpConditional,phpRepeat,phpLabel,phpStatement,phpOperator,phpRelation,phpStringSingle,phpStringDouble,phpNumber,phpFloat,phpSpecialChar,phpParent,phpParentError,phpInclude,phpKeyword,phpType,phpIdentifierParent,phpBoolean,phpStructure,phpMethods

syn cluster	phpTop	contains=@phpInside,phpDefine,phpParentError,phpStorageClass

if exists("php_parentError")
  syn region	phpParent	matchgroup=Delimiter start="(" end=")" contained contains=@phpInside
  syn region	phpParent	matchgroup=Delimiter start="{" end="}" contained contains=@phpTop
  syn region	phpParent	matchgroup=Delimiter start="\[" end="\]" contained contains=@phpInside

  if exists("php_noShortTags")
    syn region	 phpRegion	keepend matchgroup=Delimiter start="<?php" skip=+".\{-}?>.\{-}"\|'.\{-}?>.\{-}'\|/\*.\{-}?>.\{-}\*/+ end="?>" contains=@phpTop
  else
    syn region	 phpRegion	keepend matchgroup=Delimiter start="<?\(php\)\=" skip=+".\{-}?>.\{-}"\|'.\{-}?>.\{-}'\|/\*.\{-}?>.\{-}\*/+ end="?>" contains=@phpTop
  endif
  syn region	 phpRegion	 keepend matchgroup=Delimiter start=+<script language="php">+ skip=+".\{-}</script>.\{-}"\|'.\{-}</script>.\{-}'\|/\*.\{-}</script>.\{-}\*/+ end=+</script>+ contains=@phpTop
  if exists("php_asp_tags")
    syn region	 phpRegion	keepend matchgroup=Delimiter start="<%\(=\)\=" skip=+".\{-}%>.\{-}"\|'.\{-}%>.\{-}'\|/\*.\{-}%>.\{-}\*/+ end="%>" contains=@phpTop
  endif
else
  syn match	phpParent	"[({[\]})]"	contained

  if exists("php_noShortTags")
    syn region	 phpRegion	matchgroup=Delimiter start="<?php" end="?>" contains=@phpTop
  else
    syn region	 phpRegion	matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpTop
  endif
  syn region	 phpRegion	matchgroup=Delimiter start=+<script language="php">+ end=+</script>+ contains=@phpTop
  if exists("php_asp_tags")
    syn region	 phpRegion	matchgroup=Delimiter start="<%\(=\)\=" end="%>" contains=@phpTop
  endif
endif

" sync
if exists("php_minlines")
  exec "syn sync minlines=" . php_minlines
else
  syn sync minlines=100
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_php_syn_inits")
  if version < 508
    let did_php_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink	 phpComment	Comment
  HiLink	 phpBoolean	Boolean
  HiLink	 phpStorageClass	StorageClass
  HiLink	 phpStructure	Structure
  HiLink	 phpStringSingle	String
  HiLink	 phpStringDouble	String
  HiLink	 phpNumber	Number
  HiLink	 phpFloat	Float
  HiLink	 phpFunctions	Function
  HiLink	 phpBaselib	Function
  HiLink	 phpRepeat	Repeat
  HiLink	 phpConditional	Conditional
  HiLink	 phpLabel	Label
  HiLink	 phpStatement	Statement
  HiLink	 phpKeyword	Statement
  HiLink	 phpType	Type
  HiLink	 phpInclude	Include
  HiLink	 phpDefine	Define
  HiLink	 phpSpecialChar	SpecialChar
  HiLink	 phpParent	Delimiter
  HiLink	 phpParentError	Error
  HiLink	 phpOctalError	Error
  HiLink	 phpTodo	Todo
  HiLink	 phpMemberSelector	Structure
  HiLink	 phpNoEnd	Operator
  if exists("php_oldStyle")
        hi	phpIntVar guifg=Red ctermfg=DarkRed
        hi	phpEnvVar guifg=Red ctermfg=DarkRed
        hi	phpOperator guifg=SeaGreen ctermfg=DarkGreen
        hi	phpVarSelector guifg=SeaGreen ctermfg=DarkGreen
        hi	phpRelation guifg=SeaGreen ctermfg=DarkGreen
        hi	phpIdentifier guifg=DarkGray ctermfg=Brown
  else
        HiLink	phpIntVar	Identifier
        HiLink	phpEnvVar	Identifier
        HiLink	phpOperator	Operator
        HiLink	phpVarSelector	Operator
        HiLink	phpRelation	Operator
        HiLink	phpIdentifier	Identifier
  endif

  delcommand HiLink
endif

let b:current_syntax = "php"

if main_syntax == 'php'
  unlet main_syntax
endif

" vim: ts=8
