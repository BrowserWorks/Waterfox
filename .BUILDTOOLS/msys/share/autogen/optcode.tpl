[= autogen5 template  -*- Mode: Text -*-

#$Id: optcode.tpl,v 2.64 2002/09/29 00:14:18 bkorb Exp $

# Automated Options copyright 1992-2002 Bruce Korb

=]
#include "[=(. header-file)=]"
[=

INCLUDE "optmain.tpl"

=][=
IF (not (exist? "copyright") )
=]
#define zCopyright       NULL
#define zCopyrightNotice NULL[=
ELSE  =]
tSCC zCopyright[] =
       [= (kr-string
       (sprintf "%s copyright (c) %s %s, all rights reserved" (. prog-name)
                (get "copyright.date") (get "copyright.owner") )) =];
tSCC zCopyrightNotice[] =
       [=
  CASE (get "copyright.type") =][=

    =  gpl  =][=(kr-string (gpl  (. prog-name) "" ))=][=

    = lgpl  =][=(kr-string (lgpl (. prog-name) (get "copyright.owner")
                                "" ))=][=

    =  bsd  =][=(kr-string (bsd  (. prog-name) (get "copyright.owner")
                                "" ))=][=

    = note  =][=(kr-string (get "copyright.text"))=][=

    *       =]"Copyrighted"[=

  ESAC =];[=

ENDIF "copyright notes"=]
[=

IF (exist? "flag.call-proc")

=]
[= (shell (string-append
"columns -I16 --first='extern tOptProc ' -S, <<_EOF_\n"
(join "\n" (stack "flag.call-proc")) "\n_EOF_" )) =][=

ENDIF

=]
extern tUsageProc [= ?% usage "%s" "optionUsage" =];

[=
IF (exist? "include") =]
/*
 *  global included definitions
 */[=

  FOR include "\n" =]
[=(get "include") =][=
  ENDFOR include =]
[=ENDIF "include exists" =]
#ifndef NULL
#  define NULL 0
#endif
#ifndef EXIT_SUCCESS
#  define  EXIT_SUCCESS 0
#endif
#ifndef EXIT_FAILURE
#  define  EXIT_FAILURE 1
#endif[=

(define number-arg (make-regexp "=.*"))

=][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


=][=

FOR flag "\n"      =][=
  (set-flag-names) =][=
  Option_Strings   =][=

ENDFOR flag
=]

/*
 *  Help option description:
 */
tSCC zHelpText[]  = "Display usage information and exit";
tSCC zHelp_Name[] = "help";

/*
 *  More_Help option description:
 */
tSCC zMore_HelpText[]  = "Extended usage information passed thru pager";
tSCC zMore_Help_Name[] = "more-help";[=
IF (exist? "version")
=]

/*
 *  Version option description:
 */
tSCC zVersionText[]    = "Output version information and exit";
tSCC zVersion_Name[]   = "version";[=
ENDIF (exist? "version")  =][=

IF (exist? "homerc")
=]

/*
 *  Save_Opts option description:
 */
tSCC zSave_OptsText[]  = "Save the option state to an rc file";
tSCC zSave_Opts_Name[] = "save-opts";

/*
 *  Load_Opts option description:
 */
extern tOptProc doLoadOpt;
tSCC    zLoad_OptsText[]     = "Load options from an rc file";
tSCC    zLoad_Opts_NAME[]    = "LOAD_OPTS";
tSCC    zNotLoad_Opts_Name[] = "no-load-opts";
tSCC    zNotLoad_Opts_Pfx[]  = "no";
#define zLoad_Opts_Name        (zNotLoad_Opts_Name + 3)[=
ENDIF (exist? "homerc") =][=


IF (or (exist? "flag.flag_code")
       (exist? "flag.extract_code")
       (exist? "flag.call_proc")
       (exist? "flag.arg_range")
       (match-value? =* "flag.arg_type" "key") ) =][=

  invoke declare-option-callbacks  =][=

ENDIF   =]
/*
 *  These are always callable, whether
 *  TEST_[=(. pname-up)=]_OPTS is defined or not
 */
static tOptProc doUsageOpt;[=
IF (exist? "version")       =][=
  IF (exist? "test_main")   =]
#ifdef TEST_[=(. pname-up)=]_OPTS
  extern tOptProc  doVersionStderr;
# define DOVERPROC doVersionStderr
#else
  extern tOptProc  doVersion;
# define DOVERPROC doVersion
#endif /* TEST_[=(. pname-up)=]_OPTS */[=
  ELSE  =]
extern  tOptProc  doVersion;
#define DOVERPROC doVersion[=
  ENDIF =][=
ENDIF =]
extern tOptProc doPagedUsage;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  Define the [=(. pname-cap)=] Option Descriptions.
 */
static tOptDesc optDesc[ [=(. UP-prefix)=]OPTION_CT ] = {[=

FOR flag "\n"       =][=
  (set-flag-names)  =][=
  Option_Descriptor =][=

  ;;  IF this is the default option AND we already have one,...
  ;;  THEN remember this index
  ;;
  (if (and (exist? "default") (>= default-opt-index 0))
      (error (sprintf "\n\tDefault argument %d duplicates %d\n"
                      (for-index) default-opt-index) ))

  ;;  IF this is the default option then remember this index
  ;;
  (if (and (exist? "default"))
      (set! default-opt-index (for-index)) ) =][=

ENDFOR flag

=][=

IF (exist? "version") =]

  {  /* entry idx, value */ INDEX_[= (. UP-prefix) =]OPT_VERSION, VALUE_[=
                                     (. UP-prefix) =]OPT_VERSION,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* option argument  */ ARG_MAY,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max act ct  */ 0, 1, 0,
     /* opt state flags  */ OPTST_INIT,
     /* last opt argumnt */ NULL,
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ DOVERPROC,
     /* desc, NAME, name */ zVersionText, NULL, zVersion_Name,
     /* disablement strs */ NULL, NULL },[=
ENDIF=]

  {  /* entry idx, value */ INDEX_[= (. UP-prefix) =]OPT_HELP, VALUE_[=
                                     (. UP-prefix) =]OPT_HELP,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* option argument  */ ARG_NONE,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max act ct  */ 0, 1, 0,
     /* opt state flags  */ OPTST_IMM,
     /* last opt argumnt */ NULL,
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ doUsageOpt,
     /* desc, NAME, name */ zHelpText, NULL, zHelp_Name,
     /* disablement strs */ NULL, NULL },

  {  /* entry idx, value */ INDEX_[= (. UP-prefix) =]OPT_MORE_HELP, VALUE_[=
                                     (. UP-prefix) =]OPT_MORE_HELP,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* option argument  */ ARG_NONE,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max act ct  */ 0, 1, 0,
     /* opt state flags  */ OPTST_IMM,
     /* last opt argumnt */ NULL,
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL,  NULL,
     /* option proc      */ doPagedUsage,
     /* desc, NAME, name */ zMore_HelpText, NULL, zMore_Help_Name,
     /* disablement strs */ NULL, NULL }[=

IF (exist? "homerc")
=],

  {  /* entry idx, value */ INDEX_[= (. UP-prefix) =]OPT_SAVE_OPTS, VALUE_[=
                                     (. UP-prefix) =]OPT_SAVE_OPTS,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* option argument  */ '?',
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max act ct  */ 0, 1, 0,
     /* opt state flags  */ OPTST_INIT,
     /* last opt argumnt */ NULL,
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL,  NULL,
     /* option proc      */ NULL,
     /* desc, NAME, name */ zSave_OptsText, NULL, zSave_Opts_Name,
     /* disablement strs */ NULL, NULL },

  {  /* entry idx, value */ INDEX_[= (. UP-prefix) =]OPT_LOAD_OPTS, VALUE_[=
                                     (. UP-prefix) =]OPT_LOAD_OPTS,
     /* equiv idx value  */ NO_EQUIVALENT, 0,
     /* option argument  */ ARG_MUST,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, NOLIMIT, 0,
     /* opt state flags  */ OPTST_DISABLE_IMM,
     /* last opt argumnt */ NULL,
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ doLoadOpt,
     /* desc, NAME, name */ zLoad_OptsText, zLoad_Opts_NAME, zLoad_Opts_Name,
     /* disablement strs */ zNotLoad_Opts_Name, zNotLoad_Opts_Pfx }[=
ENDIF=]
};

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *  Define the [= (. pname-cap) =] Option Environment
 */
tSCC   zPROGNAME[]   = "[= (. pname-up) =]";
tSCC   zUsageTitle[] =
[= USAGE_LINE           =];[=

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

(define patch-text (lambda (t-name)
  (kr-string (string-append "\n" (shellf
  "sed 's/@[a-z]*{\\([^{@}]*\\)}/``\\1'\"''/g\" <<'_EODetail_'\n%s\n_EODetail_"
  (get t-name)  ) "\n" )) ))

(define bug-text "\n\ntSCC   zBugsAddr[]    = %s;")

(if (exist? "copyright.eaddr")
    (sprintf bug-text (kr-string (get "copyright.eaddr")))

    (if (exist? "eaddr")
        (sprintf bug-text (kr-string (get "eaddr")))

        "\n\n#define zBugsAddr NULL" )  )

                        =][=

IF (exist? "explain")   =]
tSCC   zExplain[]     = [= (patch-text "explain") =];[=
ELSE                    =]
#define zExplain NULL[=
ENDIF                   =][=

IF (exist? "detail")    =]

tSCC    zDetail[]     = [= (patch-text "detail") =];[=

ELSE                    =]

#define zDetail NULL[=
ENDIF                   =][=

IF (not (exist? "usage")) =]

extern  tUsageProc optionUsage;[=
ENDIF=][=

IF (exist? "version")   =]

tSCC    zFullVersion[] = [=(. pname-up)=]_FULL_VERSION;[=

ELSE                    =]

#define zFullVersion NULL[=
ENDIF                   =]

tOptions [=(. pname)=]Options = {
    OPTIONS_STRUCT_VERSION,
    NULL,         NULL,        zPROGNAME,
    zRcName,      zCopyright,  zCopyrightNotice,
    zFullVersion, apzHomeList, zUsageTitle,
    zExplain,     zDetail,     NULL,
    [=IF (exist? "usage")=][=usage=][=
      ELSE               =]optionUsage[=ENDIF=],
    ( OPTPROC_NONE[=                IF (not (exist? "allow_errors"))     =]
    + OPTPROC_ERRSTOP[=    ENDIF=][=IF      (exist? "flag.value")        =]
    + OPTPROC_SHORTOPT[=   ENDIF=][=IF      (exist? "long_opts")         =]
    + OPTPROC_LONGOPT[=    ENDIF=][=IF (not (exist? "flag.min"))         =]
    + OPTPROC_NO_REQ_OPT[= ENDIF=][=IF      (exist? "flag.disable")      =]
    + OPTPROC_NEGATIONS[=  ENDIF=][=IF (>=   number-opt-index 0)         =]
    + OPTPROC_NUM_OPT[=    ENDIF=][=IF      (exist? "environrc")         =]
    + OPTPROC_ENVIRON[=    ENDIF=][=IF (and (exist? "plus_marks")
                                            (exist? "flag.disable"))     =]
    + OPTPROC_PLUSMARKS[=  ENDIF=][=IF (not (exist? "argument"))         =]
    + OPTPROC_NO_ARGS[=           ELIF (not (==* (get "argument") "[" )) =]
    + OPTPROC_ARGS_REQ[=   ENDIF=][=IF      (exist? "reorder-opts")      =]
    + OPTPROC_REORDER[=    ENDIF=] ),
    0, NULL,
    { INDEX_[= (. UP-prefix) =]OPT_MORE_HELP,
      [=IF (exist? "homerc")
             =]INDEX_[= (. UP-prefix) =]OPT_SAVE_OPTS[=
        ELSE =] 0 /* no option state saving */[=
        ENDIF=],
      [= IF (>= number-opt-index 0)
              =][= (. number-opt-index) =] /* index of '-#' option */[=
         ELSE =]NO_EQUIVALENT /* no '-#' option */[=
         ENDIF  =],
      [=
         IF (>= default-opt-index 0)
              =][= (. default-opt-index) =] /* index of default opt */[=
         ELSE =]NO_EQUIVALENT /* no default option */[=
         ENDIF =] },
    [= (. UP-prefix) =]OPTION_CT, [=(count "flag")=] /* user option count */,
    optDesc,
    0, (char**)NULL,  /* original argc + argv    */
    zBugsAddr         /* address to send bugs to */
};

/*
 *  Create the static procedure(s) declared above.
 */
static void
#ifdef __cplusplus
doUsageOpt(
    tOptions*   pOptions,
    tOptDesc*   pOptDesc )
#else
doUsageOpt( pOpts, pOD )
    tOptions*  pOpts;
    tOptDesc*  pOD;
#endif
{
    [= (. UP-prefix) =]USAGE( EXIT_SUCCESS );
}[=

IF (or (exist? "flag.flag_code")
       (exist? "flag.extract_code")
       (exist? "flag.arg_range")
       (match-value? =* "flag.arg_type" "key")) =][=

  invoke  define-option-callbacks  =][=

ENDIF                              =][=

IF (exist? "test_main")            =][=

  IF (exist? "guile-main")         =][=
     (error "both ``test_main'' and ``guile-main'' have been defined") =][=

  ELSE                             =][=
     invoke build-test-main        =][=
  ENDIF                            =][=

ELIF (exist? "guile-main")         =][=
  `echo invoking build-guile-main >&2` =][=
     invoke build-guile-main       =][=

ENDIF "test/guile main"

=]
