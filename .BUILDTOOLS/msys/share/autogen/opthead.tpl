[= autogen5 template

# $Id: opthead.tpl,v 2.32 2002/09/10 02:10:57 bkorb Exp $
# Automated Options copyright 1992-2002 Bruce Korb

=]
/*
 *  This file contains the programmatic interface to the Automated
 *  Options generated for the [=(. prog-name)=] program.
 *  These macros are documented in the AutoGen info file in the
 *  "AutoOpts" chapter.  Please refer to that doc for usage help.
 */
[= (make-header-guard "autoopts") =]
[= Option_Copyright =][=
% config-header "\n#include \"%s\""=]
#include <options.h>

/*
 *  Enumeration of each option:
 */
typedef enum {[=
FOR flag    =][=
  IF (not (exist? "documentation")) =]
        INDEX_[=(set-flag-names) UP-prefix=]OPT_[=
                (sprintf "%-16s =%3d," UP-name (for-index)) =][=
  ENDIF     =][=
ENDFOR flag =][=

(define option-ct (count "flag")) =][=

IF (exist? "version") =]
        INDEX_[=(. UP-prefix)=]OPT_VERSION          = [=
                (set! option-ct (+ option-ct 1)) (- option-ct 1)=],[=
ENDIF =]
        INDEX_[=(. UP-prefix)=]OPT_HELP             = [=
                (set! option-ct (+ option-ct 1)) (- option-ct 1)=],
        INDEX_[=(. UP-prefix)=]OPT_MORE_HELP        = [=
                (set! option-ct (+ option-ct 1)) (- option-ct 1)=][=

IF (exist? "homerc") =],
        INDEX_[=(. UP-prefix)=]OPT_SAVE_OPTS        = [=
                (set! option-ct (+ option-ct 1)) (- option-ct 1)=],
        INDEX_[=(. UP-prefix)=]OPT_LOAD_OPTS        = [=
                (set! option-ct (+ option-ct 1)) (- option-ct 1)=][=
ENDIF =]
} te[=(. Cap-prefix)=]OptIndex;

#define [=(. UP-prefix)=]OPTION_CT    [= (. option-ct) =][=
IF (exist? "version") =]
#define [=(. UP-prog)=]_VERSION       [=(c-string (get "version"))=]
#define [=(. UP-prog)=]_FULL_VERSION  "[=
  (. prog-name) =] - [= % prog_title "%s - " =]Ver. [=version=]"[=
ENDIF (exist? version) =]

/*
 *  Interface defines for all options.  Replace "n" with
 *  the UPPER_CASED option name (as in the te[=(. Cap-prefix)=]OptIndex
 *  enumeration above).  e.g. HAVE_[=(. UP-prefix)=]OPT( [=
    (string-upcase! (get "flag[].name" ))=] )
 */[=
(sprintf "
#ifdef __STDC__
#  define       %1$sDESC(n) %2$sOptions.pOptDesc[INDEX_%1$sOPT_ ## n]
#else
#  define       %1$sDESC(n) %2$sOptions.pOptDesc[INDEX_%1$sOPT_/**/n]
#endif
#define     HAVE_%1$sOPT(n) (! UNUSED_OPT(& %1$sDESC(n)))
#define      %1$sOPT_ARG(n) (%1$sDESC(n).pzLastArg)
#define    STATE_%1$sOPT(n) (%1$sDESC(n).fOptState & OPTST_SET_MASK)
#define    COUNT_%1$sOPT(n) (%1$sDESC(n).optOccCt)
#define    ISSEL_%1$sOPT(n) (SELECTED_OPT(&%1$sDESC(n)))
#define ISUNUSED_%1$sOPT(n) (UNUSED_OPT(& %1$sDESC(n)))
#define  ENABLED_%1$sOPT(n) (! DISABLED_OPT(& %1$sDESC(n)))
#define  STACKCT_%1$sOPT(n) (((tArgList*)(%1$sDESC(n).optCookie))->useCt)
#define STACKLST_%1$sOPT(n) (((tArgList*)(%1$sDESC(n).optCookie))->apzArgs)
#define    CLEAR_%1$sOPT(n) STMTS( \\
                %1$sDESC(n).fOptState &= OPTST_PERSISTENT;   \\
                if ( (%1$sDESC(n).fOptState & OPTST_INITENABLED) == 0) \\
                    %1$sDESC(n).fOptState |= OPTST_DISABLED; \\
                %1$sDESC(n).optCookie = NULL )"

  UP-prefix (get "prog-name")
) =]

/*
 *  Interface defines for specific options.
 */[=

FOR flag              =][=
  (set-flag-names)
  (set! opt-name   (string-append UP-prefix "OPT_" UP-name))
  (set! descriptor (string-append UP-prefix "DESC(" UP-name ")" )) =][=

 IF (exist? "documentation") =][=
   IF (or (exist? "call_proc") (exist? "flag_code") (exist? "extract_code"))
=]
#define SET_[=(. UP-prefix)=]OPT_[=(. UP-name)=]   STMTS( \
        (*([=(. descriptor)=].pOptProc))( &[=(. pname)=]Options, \
                [=(. pname)=]Options.pOptDesc + [=(for-index)=] )[=

   ENDIF              =][=
 ELSE                 =][=
   Option_Defines     =][=
 ENDIF                =][=
ENDFOR  flag          =][=#

* * * * * * * * * * * * * * * * * * * * * * * * * * * *

Autoopts maintained option values.

If *any* option flag value is specified,
then we provide flag characters for our options.
Otherwise, we will use the INDEX_* values for the option value.

There are no documentation strings because these defines
are used identically to the user-generated VALUE defines.

:=]
[=
IF (exist? "flag.value") =][=
  IF (exist? "version") =]
#define VALUE_[=(. UP-prefix)=]OPT_VERSION        [=
    IF (not (exist? "version_value")) =]'v'[=
    ELSE      =][=
      CASE (get "version_value")  =][=
      == ""   =]INDEX_[=(. UP-prefix)=]OPT_VERSION[=
      == "'"  =]'\''[=
      ~~ .    =]'[=version_value=]'[=
      *       =][=(error "value (flag) codes must be single characters") =][=
      ESAC    =][=
    ENDIF     =][=
  ENDIF       =][=

  IF (exist? "homerc")=]
#define VALUE_[=(. UP-prefix)=]OPT_SAVE_OPTS      [=
    IF (not (exist? "save_opts_value")) =]'>'[=
    ELSE      =][=
      CASE (get "save_opts_value")  =][=
      == ""   =]INDEX_[=(. UP-prefix)=]OPT_SAVE_OPTS[=
      == "'"  =]'\''[=
      ~~ .    =]'[=save_opts_value=]'[=
      *       =][=(error "value (flag) codes must be single characters") =][=
      ESAC    =][=
    ENDIF     =]
#define VALUE_[=(. UP-prefix)=]OPT_LOAD_OPTS      [=
    IF (not (exist? "load_opts_value")) =]'<'[=
    ELSE      =][=
      CASE (get "load_opts_value")  =][=
      == ""   =]INDEX_[=(. UP-prefix)=]OPT_LOAD_OPTS[=
      == "'"  =]'\''[=
      ~~ .    =]'[=load_opts_value=]'[=
      *       =][=(error "value (flag) codes must be single characters") =][=
      ESAC    =][=
    ENDIF     =][=
  ENDIF
=]
#define VALUE_[=(. UP-prefix)=]OPT_HELP           [=
    IF (not (exist? "help_value")) =]'?'[=
    ELSE      =][=
      CASE (get "help_value")  =][=
      == ""   =]INDEX_[=(. UP-prefix)=]OPT_HELP[=
      == "'"  =]'\''[=
      ~~ .    =]'[=help_value=]'[=
      *       =][=(error "value (flag) codes must be single characters") =][=
      ESAC    =][=
    ENDIF     =]
#define VALUE_[=(. UP-prefix)=]OPT_MORE_HELP      [=
    IF (not (exist? "more_help_value")) =]'!'[=
    ELSE      =][=
      CASE (get "more_help_value")  =][=
      == ""   =]INDEX_[=(. UP-prefix)=]OPT_MORE_HELP[=
      == "'"  =]'\''[=
      ~~ .    =]'[=more_help_value=]'[=
      *       =][=(error "value (flag) codes must be single characters") =][=
      ESAC    =][=
    ENDIF     =][=

ELSE "flag.value *DOES NOT* exist" =][=

  IF (exist? "version") =]
#define VALUE_[=(. UP-prefix)=]OPT_VERSION        INDEX_[=
                                      (. UP-prefix)=]OPT_VERSION[=
  ENDIF=][=
  IF (exist? "homerc") =]
#define VALUE_[=(. UP-prefix)=]OPT_SAVE_OPTS      INDEX_[=
                                      (. UP-prefix)=]OPT_SAVE_OPTS
#define VALUE_[=(. UP-prefix)=]OPT_LOAD_OPTS      INDEX_[=
                                      (. UP-prefix)=]OPT_LOAD_OPTS[=
  ENDIF=]
#define VALUE_[=(. UP-prefix)=]OPT_HELP           INDEX_[=
                                      (. UP-prefix)=]OPT_HELP
#define VALUE_[=(. UP-prefix)=]OPT_MORE_HELP      INDEX_[=
                                      (. UP-prefix)=]OPT_MORE_HELP[=
ENDIF=][=

IF (exist? "homerc") =]
#define SET_[=(. UP-prefix)=]OPT_SAVE_OPTS(a)   STMTS( \
        [=(. UP-prefix)=]DESC(SAVE_OPTS).fOptState &= OPTST_PERSISTENT; \
        [=(. UP-prefix)=]DESC(SAVE_OPTS).fOptState |= OPTST_SET; \
        [=(. UP-prefix)=]DESC(SAVE_OPTS).pzLastArg  = (char*)(a) )[=
ENDIF
=]

/*
 *  Interface defines not associated with particular options
 */
#define  ERRSKIP_[=(. UP-prefix)=]OPTERR STMTS( [=prog_name
                         =]Options.fOptSet &= ~OPTPROC_ERRSTOP )
#define  ERRSTOP_[=(. UP-prefix)=]OPTERR STMTS( [=prog_name
                         =]Options.fOptSet |= OPTPROC_ERRSTOP )
#define  RESTART_[=(. UP-prefix)=]OPT(n) STMTS( \
                [=(. pname)=]Options.curOptIdx = (n); \
                [=(. pname)=]Options.pzCurOpt  = NULL )
#define    START_[=(. UP-prefix)=]OPT    RESTART_[=(. UP-prefix)
                =]OPT(1)
#define     [=(. UP-prefix)=]USAGE(c)    (*[=(. pname)
                 =]Options.pUsageProc)( &[=(. pname)=]Options, c )[=#

* * * * * * * * * * * * * * * * * * * * * * * * * * * *
=]

/* * * * * *
 *
 *  Declare the [=(. prog-name)=] option descriptor.
 */
#ifdef  __cplusplus
extern "C" {
#endif

extern tOptions   [=(. pname)=]Options;[=

IF (exist? "export")=]

/* * * * * *
 *
 *  Globals exported from the [=prog_title=] option definitions
 */[=
  FOR export "\n"=]
[= (get "export") =][=
  ENDFOR export=][=
ENDIF=]

#ifdef  __cplusplus
}
#endif
#endif /* [=(. header-guard)=] */
