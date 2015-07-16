[= autogen5 template

#$Id$

# Time-stamp:      "2010-02-24 08:41:09 bkorb"
#
##  This file is part of AutoOpts, a companion to AutoGen.
##  AutoOpts is free software.
##  AutoOpts is Copyright (c) 1992-2010 by Bruce Korb - all rights reserved
##
##  AutoOpts is available under any one of two licenses.  The license
##  in use must be one of these two and the choice is under the control
##  of the user of the license.
##
##   The GNU Lesser General Public License, version 3 or later
##      See the files "COPYING.lgplv3" and "COPYING.gplv3"
##
##   The Modified Berkeley Software Distribution License
##      See the file "COPYING.mbsd"
##
##  These files have the following md5sums:
##
##  43b91e8ca915626ed3818ffb1b71248b pkg/libopts/COPYING.gplv3
##  06a1a2e4760c90ea5e1dad8dfaac4d39 pkg/libopts/COPYING.lgplv3
##  66a5cedaf62c4b2637025f049f9b826f pkg/libopts/COPYING.mbsd

=][=

;;;
;;;  Compute the usage line.  It is complex because we are trying to
;;;  encode as much information as we can and still be comprehensible.
;;;
;;;  The rules are:  If any options have a "value" attribute, then
;;;  there are flags allowed, so include "-<flag>" on the usage line.
;;;  If the program has the "long-opts" attribute set, then we must
;;;  have "<option-name>" or "--<name>" on the line, depending on
;;;  whether or not there are flag options.  If any options take
;;;  arguments, then append "[<val>]" to the flag description and
;;;  "[{=| }<val>]" to the option-name/name descriptions.  We will not
;;;  worry about being correct if every option has a required argument.
;;;  Finally, if there are no minimum occurrence counts (i.e. all
;;;  options are optional), then we put square brackets around the
;;;  syntax.
;;;
;;;  Compute the option arguments
;;;
(define tmp-val "")
(if (exist? "flag.arg-type")
    (set! tmp-val "[{=| }<val>]"))

(define usage-line (string-append "USAGE:  %s "

  ;; If at least one option has a minimum occurrence count
  ;; we use curly brackets around the option syntax.
  ;;
  (if (not (exist? "flag.min")) "[ " "{ ")

  (if (exist? "flag.value")
      (string-append "-<flag>"
         (if (exist? "flag.arg-type") " [<val>]" "")
         (if (exist? "long-opts") " | " "") )
      (if (not (exist? "long-opts"))
         (string-append "<option-name>" tmp-val) "" )  )

  (if (exist? "long-opts")
      (string-append "--<name>" tmp-val) "" )

  (if (not (exist? "flag.min")) " ]..." " }...")
) )

(if (exist? "argument")
  (set! usage-line (string-append usage-line

    ;; the USAGE line plus the program name plus the argument goes
    ;; past 80 columns, then break the line, else separate with space
    ;;
    (if (< 80 (+ (string-length usage-line)
          (len "argument")
          (string-length prog-name) ))
        " \\\n\t\t"
        " "
    )

    (get "argument")
  ))
)
(define usage-text (string-append version-text "\n" usage-line "\n"))

=][= # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

INCLUDE "optmain.tpl"

=]
#include <sys/types.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
[=

IF (exist? "flag.arg-range")

\=]
#include <errno.h>
extern FILE * option_usage_fp;[=

ENDIF                     =][=

IF (and (exist? "resettable") (exist? "flag.open-file")) =]
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>[=
ENDIF                     =][=

IF (or (= "shell-process"  (get "main.main-type"))
       (= "shell-parser"   (get "main.main-type"))
       (exist? "main.code")) =]
#define [= (set! make-test-main #t) main-guard =] 1[=
ENDIF
=]
#define OPTION_CODE_COMPILE 1
#include "[=

 (define lib-externs "")

 header-file =]"

#ifdef  __cplusplus
extern "C" {
#endif
[=
 IF (exist? "flag.aliases") =]
extern void optionAlias(tOptions* pOpts, tOptDesc* pOD, unsigned int alias);
[= ENDIF =]
/* TRANSLATORS: choose the translation for option names wisely because you
                cannot ever change your mind. */[=

IF (not (exist? "copyright") )

=]
#define zCopyright       NULL
#define zCopyrightNotice NULL[=
ELSE  =]
tSCC zCopyright[] =
       [= (set! tmp-text (kr-string
       (sprintf "%s copyright (c) %s %s, all rights reserved" (. prog-name)
                (get "copyright.date") (get "copyright.owner") )))
       tmp-text =][=

  CASE (get "copyright.type") =][=

    =  gpl  =][=(set! tmp-text (gpl  prog-name "" ))=][=
    = lgpl  =][=(set! tmp-text (lgpl prog-name (get "copyright.owner") ""))=][=
    =  bsd  =][=(set! tmp-text (bsd  prog-name (get "copyright.owner") ""))=][=
    = note  =][=(set! tmp-text (get  "copyright.text"))=][=
    *       =][=(set! tmp-text "Copyrighted")=][=

  ESAC =][=

(emit (def-file-line "copyright.text" extract-fmt))
(set! tmp-text (shell (string-append
"${CLexe} --fill <<\\_EOF_\n" tmp-text "\n_EOF_")))

(sprintf ";\ntSCC zCopyrightNotice[%d] =\n%s;\n"
 (+ (string-length tmp-text) 1) (kr-string tmp-text)  ) =][=

ENDIF "copyright notes"

=]
extern tUsageProc [=
  (define usage-proc (get "usage" "optionUsage"))
  usage-proc =];
[=

IF (exist? "include")

=]
/*
 *  global included definitions
 */
[=(join "\n" (stack "include"))  =]
[=

ENDIF "include exists"

=]
#ifndef NULL
#  define NULL 0
#endif
#ifndef EXIT_SUCCESS
#  define  EXIT_SUCCESS 0
#endif
#ifndef EXIT_FAILURE
#  define  EXIT_FAILURE 1
#endif[=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =]
[=

FOR flag "\n"           =][=
  INVOKE opt-strs       =][=

  (if (exist? "lib-name") (begin
      (set! lib-opt-ptr (string->c-name! (string-append
                        (get "lib-name") "_" (get "name") "_optDesc_p")))
      (set! lib-externs (string-append lib-externs
                        (sprintf "tOptDesc * const %-16s = optDesc + %d;\n"
                                 lib-opt-ptr (for-index) )  ))
  )   )                 =][=

ENDFOR flag

=][=

INVOKE help-strs        =][=
INVOKE decl-callbacks   =][=

IF (and (exist? "version") make-test-main)

=]
#ifdef [=(. main-guard) =]
# define DOVERPROC optionVersionStderr
#else
# define DOVERPROC optionPrintVersion
#endif /* [=(. main-guard)=] */[=

ENDIF

=]

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  Define the [=(. pname-cap)=] Option Descriptions.
 */
static tOptDesc optDesc[ [=
(define default-text   "")
(define default-cookie "")
UP-prefix
=]OPTION_CT ] = {[=

FOR flag "\n"           =][=

  INVOKE opt-desc       =][=

ENDFOR flag

=][=

IF (exist? "resettable")

=]

  {  /* entry idx, value */ [=
        (set! default-text (string-append default-text
               "\n    { NULL }," ))
        (set! default-cookie (string-append default-cookie
               "\n    NULL," ))
        INDEX-pfx =]RESET_OPTION, [= (. VALUE-pfx) =]RESET_OPTION,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 1, 0,
     /* opt state flags  */ OPTST_SET_ARGTYPE(OPARG_TYPE_STRING)
			  | OPTST_NO_INIT, 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL,  NULL,
     /* option proc      */ optionResetOpt,
     /* desc, NAME, name */ zResetText, NULL, zReset_Name,
     /* disablement strs */ NULL, NULL },[=

ENDIF

=][=

IF (exist? "version")   =]

  {  /* entry idx, value */ [=
        (set! default-text (string-append default-text
               "\n    { NULL }," ))
        (set! default-cookie (string-append default-cookie
               "\n    NULL," ))
         INDEX-pfx =]VERSION, [= (. VALUE-pfx) =]VERSION,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 1, 0,
     /* opt state flags  */ OPTST_VERSION_FLAGS, 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ [=
         (if make-test-main "DOVERPROC" "optionPrintVersion")=],
     /* desc, NAME, name */ zVersionText, NULL, zVersion_Name,
     /* disablement strs */ NULL, NULL },

[=

ENDIF =]

  {  /* entry idx, value */ [=
        (set! default-text (string-append default-text
               "\n    { NULL },\n    { NULL }," ))
        (set! default-cookie (string-append default-cookie
               "\n    NULL,\n    NULL," ))
        INDEX-pfx =]HELP, [= (. VALUE-pfx) =]HELP,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 1, 0,
     /* opt state flags  */ OPTST_IMM | OPTST_NO_INIT, 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ doUsageOpt,
     /* desc, NAME, name */ zHelpText, NULL, zHelp_Name,
     /* disablement strs */ NULL, NULL }[=

IF (not (exist? "no-libopts"))          =],

  {  /* entry idx, value */ [=
        (. INDEX-pfx) =]MORE_HELP, [= (. VALUE-pfx) =]MORE_HELP,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 1, 0,
     /* opt state flags  */ OPTST_MORE_HELP_FLAGS, 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL,  NULL,
     /* option proc      */ optionPagedUsage,
     /* desc, NAME, name */ zMore_HelpText, NULL, zMore_Help_Name,
     /* disablement strs */ NULL, NULL }[=

ENDIF not have no-libopts               =][=

IF (exist? "usage-opt")                 =],

  {  /* entry idx, value */ [=
        (set! default-text (string-append default-text
               "\n    { NULL }," ))
        (set! default-cookie (string-append default-cookie
               "\n    NULL," ))
        INDEX-pfx =]USAGE, [= (. VALUE-pfx) =]USAGE,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 1, 0,
     /* opt state flags  */ OPTST_IMM | OPTST_NO_INIT, 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL,  NULL,
     /* option proc      */ doUsageOpt,
     /* desc, NAME, name */ zUsageText, NULL, zUsage_Name,
     /* disablement strs */ NULL, NULL }[=

ENDIF have usage-opt                    =][=

IF (exist? "homerc")                    =],

  {  /* entry idx, value */ [=
        (set! default-text (string-append default-text
               "\n    { NULL },\n    { NULL }," ))
        (set! default-cookie (string-append default-cookie
               "\n    NULL,\n    NULL," ))
        INDEX-pfx =]SAVE_OPTS, [=
           (if (not (exist? "disable-save"))
               (string-append VALUE-pfx "SAVE_OPTS")
               "0") =],
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 1, 0,
     /* opt state flags  */ OPTST_SET_ARGTYPE(OPARG_TYPE_STRING)
                          | OPTST_ARG_OPTIONAL | OPTST_NO_INIT[=
    (if (exist? "disable-save") "| OPTST_NO_COMMAND") =], 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL,  NULL,
     /* option proc      */ NULL,
     /* desc, NAME, name */ [=
    (if (exist? "disable-save") "NULL, NULL, NULL"
         "zSave_OptsText, NULL, zSave_Opts_Name")=],
     /* disablement strs */ NULL, NULL },

  {  /* entry idx, value */ [=
        (. INDEX-pfx) =]LOAD_OPTS, [=
           (if (not (exist? "disable-load"))
               (string-append VALUE-pfx "LOAD_OPTS")
               "0") =],
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, NOLIMIT, 0,
     /* opt state flags  */ OPTST_SET_ARGTYPE(OPARG_TYPE_STRING)
			  | OPTST_DISABLE_IMM[=
    (if (exist? "disable-load") "| OPTST_NO_COMMAND") =], 0,
     /* last opt argumnt */ { NULL },
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ optionLoadOpt,
     /* desc, NAME, name */ [=
    (if (exist? "disable-load") "NULL, NULL, NULL"
         "zLoad_OptsText, zLoad_Opts_NAME, zLoad_Opts_Name")=],
     /* disablement strs */ [=
    (if (exist? "disable-load") "NULL, NULL"
         "zNotLoad_Opts_Name, zNotLoad_Opts_Pfx")=] }[=

ENDIF have homerc

=]
};
[= (. lib-externs) =]
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  Define the [= (. pname-cap) =] Option Environment
 */
tSCC   zPROGNAME[]   = "[= (. pname-up) =]";
tSCC   zUsageTitle[] =
[= (kr-string usage-text) =];[=

IF (exist? "homerc") =]
tSCC   zRcName[]     = "[=
  (if (not (exist? "rcfile"))
      (string-append "." pname-down "rc")
      (get "rcfile") ) =]";
tSCC*  apzHomeList[] = {[=
  FOR homerc            =]
       [= (kr-string (get "homerc")) =],[=
  ENDFOR homerc=]
       NULL };[=

ELSE                    =]
#define zRcName     NULL
#define apzHomeList NULL[=
ENDIF                   =][=

(out-push-new)         \=]
s/@[a-z]*{\([^{@}]*\)}/``\1''/g
s=@<prog-name>@=[= prog-name =]=g
/^@\(end *\)*example/d
s/^@item *$/\
/[=

(define patch-text-sed
  (sprintf "sed %s <<\\_EODetail_\n"
    (raw-shell-str (out-pop #t)) ) )

(define patch-text (lambda (t-name)
  (set! tmp-text (kr-string (string-append "\n"

  (shell (string-append
    patch-text-sed
    (get t-name)
    "\n_EODetail_" ))
  "\n" ))) ))

(define bug-text "\n\ntSCC   zBugsAddr[]    = %s;")

(if (exist? "copyright.eaddr")
    (sprintf bug-text (kr-string (get "copyright.eaddr")))

    (if (exist? "eaddr")
        (sprintf bug-text (kr-string (get "eaddr")))

        "\n\n#define zBugsAddr NULL" )  )

                        =][=

IF (or (exist? "explain") (== (get "main.main-type") "for-each"))  =]
tSCC   zExplain[]     = [=

 (if (exist? "explain")
     (patch-text "explain")
     (set! tmp-text "")  )

 (if (== (get "main.main-type") "for-each")
   (set! tmp-text (string-append tmp-text

"\n\"If no arguments are provided, input arguments are read from stdin,\\n\\
one per line; blank and '#'-prefixed lines are comments.\\n\\
'stdin' may not be a terminal (tty).\\n\"" ))  )

 tmp-text =];[=

ELSE                    =]
#define zExplain NULL[=
ENDIF                   =][=

IF (exist? "detail")    =]
tSCC    zDetail[]     = [= (patch-text "detail") tmp-text =];[=

ELSE                    =]
#define zDetail         NULL[=
ENDIF                   =][=

IF (exist? "version")   =]
tSCC    zFullVersion[] = [=(. pname-up)=]_FULL_VERSION;[=

ELSE                    =]
#define zFullVersion    NULL[=
ENDIF                   =][=
(tpl-file-line extract-fmt)
=]
#if defined(ENABLE_NLS)
# define OPTPROC_BASE OPTPROC_TRANSLATE[=
CASE   no-xlate         =][=
!E                      =][=
= opt-cfg               =] | OPTPROC_NXLAT_OPT_CFG[=
= opt                   =] | OPTPROC_NXLAT_OPT[=
*                       =][= (error "invalid value for 'no-xlate'") =][=
ESAC   no-xlate         =]
  static tOptionXlateProc translate_option_strings;
#else
# define OPTPROC_BASE OPTPROC_NONE
# define translate_option_strings NULL
#endif /* ENABLE_NLS */
[= IF (exist? "resettable") =]
static optArgBucket_t const original[=(. pname-cap)=]Defaults[ [=
(. UP-prefix) =]OPTION_CT ] = {[=
   (substring default-text 0 (- (string-length default-text) 1)) =]
};
static void * const original[=(. pname-cap)=]Cookies[ [=
(. UP-prefix) =]OPTION_CT ] = {[=
   (substring default-cookie 0 (- (string-length default-cookie) 1)) =]
};
[= ENDIF =]
[= INVOKE usage-text usage-type = full  \=]
[= INVOKE usage-text usage-type = short \=]

tOptions [=(. pname)=]Options = {
    OPTIONS_STRUCT_VERSION,
    0, NULL,                    /* original argc + argv    */
    ( OPTPROC_BASE[=                IF (not (exist? "allow-errors"))     =]
    + OPTPROC_ERRSTOP[=    ENDIF=][=IF      (exist? "flag.value")        =]
    + OPTPROC_SHORTOPT[=   ENDIF=][=IF      (exist? "long-opts")         =]
    + OPTPROC_LONGOPT[=    ENDIF=][=IF (not (exist? "flag.min"))         =]
    + OPTPROC_NO_REQ_OPT[= ENDIF=][=IF      (exist? "flag.disable")      =]
    + OPTPROC_NEGATIONS[=  ENDIF=][=IF (>=   number-opt-index 0)         =]
    + OPTPROC_NUM_OPT[=    ENDIF=][=IF      (exist? "environrc")         =]
    + OPTPROC_ENVIRON[=    ENDIF=][=IF (not (exist? "argument"))         =]
    + OPTPROC_NO_ARGS[=           ELIF (not (==* (get "argument") "[" )) =]
    + OPTPROC_ARGS_REQ[=   ENDIF=][=IF      (exist? "reorder-args")      =]
    + OPTPROC_REORDER[=    ENDIF=][=IF      (exist? "gnu-usage")         =]
    + OPTPROC_GNUUSAGE[=   ENDIF=] ),
    0, NULL,                    /* current option index, current option */
    NULL,         NULL,         zPROGNAME,
    zRcName,      zCopyright,   zCopyrightNotice,
    zFullVersion, apzHomeList,  zUsageTitle,
    zExplain,     zDetail,      optDesc,
    zBugsAddr,                  /* address to send bugs to */
    NULL, NULL,                 /* extensions/saved state  */
    [= (. usage-proc) =],       /* usage procedure */
    translate_option_strings,   /* translation procedure */
    /*
     *  Indexes to special options
     */
    { [= (if (exist? "no-libopts") "NO_EQUIVALENT"
             (string-append INDEX-pfx "MORE_HELP"))
       =], /* more-help option index */
      [=IF (exist? "homerc")
             =][= (. INDEX-pfx) =]SAVE_OPTS[=
        ELSE =]NO_EQUIVALENT[=
        ENDIF=], /* save option index */
      [= (if (>= number-opt-index 0) number-opt-index "NO_EQUIVALENT")
        =], /* '-#' option index */
      [= (if (>= default-opt-index 0) default-opt-index "NO_EQUIVALENT")
        =] /* index of default opt */
    },
    [= (. option-ct) =] /* full option count */, [=
       (count "flag")=] /* user option count */,
    [= (. pname) =]_full_usage, [= (. pname) =]_short_usage,
[= IF (exist? "resettable") \=]
    original[=(. pname-cap)=]Defaults, original[=(. pname-cap)=]Cookies
[= ELSE \=]
    NULL, NULL
[= ENDIF \=]
};
[=

FOR lib-name

=]
tOptDesc* [= (string->c-name! (get "lib-name")) =]_optDesc_p = NULL;
[=

ENDFOR

=]
/*
 *  Create the static procedure(s) declared above.
 */
static void
doUsageOpt(
    tOptions*   pOptions,
    tOptDesc*   pOptDesc )
{[=
  IF (exist? "resettable") =]
    if ((pOptDesc->fOptState & OPTST_RESET) != 0)
        return;
[=ENDIF=][=
  IF (exist? "usage-opt") =]
    int ex_code = (pOptDesc->optIndex == [= (. INDEX-pfx) =]HELP)
        ? EXIT_SUCCESS : EX_USAGE;
    (void)pOptions;
    [= (. UP-prefix) =]USAGE(ex_code);[=

  ELSE   =]
    (void)pOptions;
    [= (. UP-prefix) =]USAGE( EXIT_SUCCESS );[=
  ENDIF  =]
}[=

IF (or (exist? "flag.flag-code")
       (exist? "flag.extract-code")
       (exist? "flag.arg-range")
       (match-value? ~* "flag.arg-type" "key|set|fil")) =][=

  INVOKE define-option-callbacks=][=

ENDIF                           =][=

IF (. make-test-main)           =][=
  INVOKE build-test-main        =][=

ELIF (exist? "guile-main")      =][=
  INVOKE build-guile-main       =][=

ELIF (exist? "main")            =][=
  INVOKE build-main             =][=

ENDIF "test/guile main"

=][=
(tpl-file-line extract-fmt)
=]
#if ENABLE_NLS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <autoopts/usage-txt.h>

static char* AO_gettext( char const* pz );
static void  coerce_it(void** s);

static char*
AO_gettext( char const* pz )
{
    char* pzRes;
    if (pz == NULL)
        return NULL;
    pzRes = _(pz);
    if (pzRes == pz)
        return pzRes;
    pzRes = strdup( pzRes );
    if (pzRes == NULL) {
        fputs( _("No memory for duping translated strings\n"), stderr );
        exit( EXIT_FAILURE );
    }
    return pzRes;
}

static void coerce_it(void** s) { *s = AO_gettext(*s); }
#define COERSION(_f) \
  coerce_it((void*)&([= (. pname) =]Options._f))

/*
 *  This invokes the translation code (e.g. gettext(3)).
 */
static void
translate_option_strings( void )
{
    /*
     *  Guard against re-translation.  It won't work.  The strings will have
     *  been changed by the first pass through this code.  One shot only.
     */
    if (option_usage_text.field_ct != 0) {

        /*
         *  Do the translations.  The first pointer follows the field count
         *  field.  The field count field is the size of a pointer.
         */
        tOptDesc* pOD = [=(. pname)=]Options.pOptDesc;
        char**    ppz = (char**)(void*)&(option_usage_text);
        int       ix  = option_usage_text.field_ct;

        do {
            ppz++;
            *ppz = AO_gettext(*ppz);
        } while (--ix > 0);
[=

  FOR field IN pzCopyright pzCopyNotice pzFullVersion pzUsageTitle pzExplain
               pzDetail         =][=

    (sprintf "\n        COERSION(%s);" (get "field"))  =][=

  ENDFOR                        =][=

  IF (exist? "full-usage")      =]
        COERSION(pzFullUsage);[=
  ENDIF                         =][=

  IF (exist? "short-usage")     =]
        COERSION(pzShortUsage);[=
  ENDIF                         =]
        option_usage_text.field_ct = 0;

        for (ix = [=(. pname)=]Options.optCt; ix > 0; ix--, pOD++)
            coerce_it((void*)&(pOD->pzText));
    }

    if (([= (. pname) =]Options.fOptSet & OPTPROC_NXLAT_OPT_CFG) == 0) {
        tOptDesc* pOD = [=(. pname)=]Options.pOptDesc;
        int       ix;

        for (ix = [=(. pname)=]Options.optCt; ix > 0; ix--, pOD++) {[=

  FOR field IN pz_Name pz_DisableName pz_DisablePfx  =][=

    (sprintf "\n            coerce_it((void*)&(pOD->%1$s));"
             (get "field"))     =][=

  ENDFOR                        =]
        }
        /* prevent re-translation */
        [= (. pname)
        =]Options.fOptSet |= OPTPROC_NXLAT_OPT_CFG | OPTPROC_NXLAT_OPT;
    }
}

#endif /* ENABLE_NLS */

#ifdef  __cplusplus
}
#endif[=
 # /*
 * Local Variables:
 * mode: C
 * c-file-style: "stroustrup"
 * indent-tabs-mode: nil
 * End:
 * opthead.tpl ends here */    \=]
