[= AutoGen5 Template Library -*- Mode: Text -*-

# $Id: optlib.tpl,v 1.38 2002/09/10 02:10:57 bkorb Exp $

# Automated Options copyright 1992-2002 Bruce Korb

=][=

IF (getenv "DOCUMENT_USAGE")     =][=
  (define skip-ifdef #t)         =][=

ELIF (or (exist? "flag.ifdef")
         (exist? "flag.ifndef")) =][=
  (define skip-ifdef #f)         =][=

ELSE                             =][=
  (define skip-ifdef #t)         =][=
ENDIF

=][=
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

Emit the "#define SET_OPT_NAME ..." and "#define DISABLE_OPT_NAME ..."

=][=

DEFINE set_defines set_desc set_index opt_state =]
#define SET_[=(. opt-name)=][=
  IF (exist? "arg_type")=](a)[=ENDIF=]   STMTS( \
        [=set_desc=].optActualIndex = [=(for-index)=]; \
        [=set_desc=].optActualValue = VALUE_[=(. opt-name)=]; \
        [=set_desc=].fOptState &= OPTST_PERSISTENT; \
        [=set_desc=].fOptState |= [=opt_state=][=
  IF (exist? "arg_type")=]; \
        [=set_desc=].pzLastArg  = (char*)(a)[=
  ENDIF  =][=
  IF (or (exist? "call_proc")
         (exist? "flag_code")
         (exist? "extract_code")
         (exist? "flag_proc")
         (exist? "arg_range")
         (exist? "stack_arg")
         (~* (get "arg_type") "key|num|bool" ) )   =]; \
        (*([=(. descriptor)=].pOptProc))( &[=
                           (. pname)=]Options, \
                [=(. pname)=]Options.pOptDesc + [=set_index=] )[=
  ENDIF "callout procedure exists" =] )[=

  IF (exist? "disable") =]
#define DISABLE_[=(. opt-name)=]   STMTS( \
        [=set_desc=].fOptState &= OPTST_PERSISTENT; \
        [=set_desc=].fOptState |= OPTST_SET | OPTST_DISABLED; \
        [=set_desc=].pzLastArg  = NULL[=
    IF (or (exist? "call_proc")
           (exist? "flag_code")
           (exist? "extract_code")
           (exist? "flag_proc")
           (exist? "arg_range")
           (exist? "stack_arg") ) =]; \
        (*([=(. descriptor)=].pOptProc))( &[=
                  (. pname)=]Options, \
                [=(. pname)=]Options.pOptDesc + [=set_index=] )[=
    ENDIF "callout procedure exists" =] )[=

  ENDIF disable exists =][=

ENDDEF
=][=

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  Emit the copyright comment

  =][=

DEFINE Option_Copyright =][=
IF (exist? "copyright") =]
/*
 * [=(sprintf "%s copyright %s %s - all rights reserved"
     (. prog-name) (get "copyright.date") (get "copyright.owner") ) =][=

  CASE (get "copyright.type") =][=

    =  gpl  =]
 *
[=(gpl (. prog-name) " * " ) =][=

    = lgpl  =]
 *
[=(lgpl (. prog-name) (get "copyright.owner") " * " ) =][=

    =  bsd  =]
 *
[=(bsd  (. prog-name) (get "copyright.owner") " * " ) =][=

    = note  =]
 *
[=(prefix " * " (get "copyright.text"))=][=

    *       =] * <<indeterminate copyright type>>[=

  ESAC =]
 */[=
ENDIF "copyright exists" =][=
ENDDEF

=][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

Emit the #define's for a single option

=][=

DEFINE Option_Defines      =][=
  IF (. skip-ifdef)        =][=
  ELSE                     =][=

    IF   (exist? "ifdef")  =]
#ifdef [=(get "ifdef")     =][=
    ELIF (exist? "ifndef") =]
#ifndef [=(get "ifndef")   =][=
    ENDIF ifdef/ifndef     =][=
  ENDIF =][=

  IF (=* (get "arg_type") "key") =]
typedef enum {[=
         IF (not (exist? "arg_default")) =] [=
            (string-append UP-prefix UP-name)=]_UNDEFINED = 0,[=
         ENDIF  =]
[=(shellf "for f in %s ; do echo %s_${f} ; done | \
          ${COLUMNS_EXE} -I4 --spread=3 --sep=','"
          (string-upcase! (string->c-name! (join " " (stack "keyword"))))
          (string-append UP-prefix UP-name) )=]
} te_[=(string-append Cap-prefix cap-name)=];[=
  ENDIF

=]
#define VALUE_[=(sprintf "%-18s" opt-name)=] [=
     IF (exist? "value") =][=
        CASE (get "value") =][=
        ==  '       =]'\''[=
        ~   .       =]'[=value=]'[=
        *           =][=(error (sprintf
          "Error:  value for opt %s is `%s'\nmust be single char or 'NUMBER'"
          (get "name") (get "value")))=][=
        ESAC =][=
     ELIF (<= (for-index) 32) =][= (for-index) =][=
     ELSE                 =][= (+ (for-index) 96) =][=
     ENDIF =][=

  CASE arg_type  =][=

  =*  num        =]
#define [=(. UP-prefix)=]OPT_VALUE_[=(sprintf "%-14s" UP-name)
                 =] (*(long*)(&[=(. UP-prefix)=]OPT_ARG([=(. UP-name)=])))[=

  =*  key        =]
#define [=(. UP-prefix)=]OPT_VALUE_[=(sprintf "%-14s" UP-name)
                 =] (*(te_[=(string-append Cap-prefix cap-name)
                          =]*)(&[=(. UP-prefix)
                 =]OPT_ARG([=(. UP-name)=])))[=

  =*  bool       =]
#define [=(. UP-prefix)=]OPT_VALUE_[=(sprintf "%-14s" UP-name)
                 =] (*(ag_bool*)(&[=(. UP-prefix)=]OPT_ARG([=(. UP-name)=])))[=

  ESAC           =][=
  IF (= (string-upcase! (get "equivalence")) UP-name) =]
#define WHICH_[=(sprintf "%-18s" opt-name)
                =] ([=(. descriptor)=].optActualValue)
#define WHICH_[=(. UP-prefix)=]IDX_[=(sprintf "%-14s" UP-name)
                =] ([=(. descriptor)=].optActualIndex)[=
  ENDIF =][=
  IF (exist? "settable") =][=

    IF  (or (not (exist? "equivalence"))
            (= (get "equivalence") UP-name)) =][=

      set_defines
           set_desc  = (string-append UP-prefix "DESC(" UP-name ")" )
           set_index = (for-index)
           opt_state = OPTST_SET =][=

    ELSE "not equivalenced"   =][=
      set_defines
           set_desc  = (string-append UP-prefix "DESC("
                           (string-upcase! (get "equivalence")) ")" )
           set_index = (string-append "INDEX_" UP-prefix "OPT_"
                           (string-upcase! (get "equivalence")) )
           opt_state = "OPTST_SET | OPTST_EQUIVALENCE" =][=

    ENDIF is/not equivalenced =][=

  ENDIF settable =][=
  IF (. skip-ifdef) =][= ELSE =][=
    IF (or (exist? "ifdef") (exist? "ifndef")) =]
#endif[=
    ENDIF =][=
  ENDIF =][=

ENDDEF
=][=

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Define the arrays of values associated with an option (strings, etc.) =][=

IF (exist? "preserve-case")     =][=
  (define optname-from "_^")
  (define optname-to   "--")    =][=
ELSE                            =][=
  (define optname-from "A-Z_^")
  (define optname-to   "a-z--") =][=
ENDIF                           =][=

DEFINE   emit-nondoc-option     =][=
  #
  #  This is *NOT* a documentation option: =]
tSCC    z[= (sprintf "%-25s" (string-append cap-name
                    "_NAME[]" )) =] = "[=(. UP-name)=]";[=

    #  IF this option can be disabled,
    #  THEN we must create the string for the disabled version
    #  =][=
    IF (> (len "disable") 0) =]
tSCC    zNot[= (sprintf "%-23s" (string-append cap-name "_Name[]"))
             =]= "[=
       (string-tr! (string-append (get "disable") "-" flg-name)
                   optname-from optname-to) =]";
tSCC    zNot[= (sprintf "%-23s" (string-append cap-name "_Pfx[]"))
             =]= "[=(string-downcase! (get "disable"))=]";[=


      #  See if we can use a substring for the option name:
      #  =][=
      IF (> (len "enable") 0) =]
tSCC    z[=(sprintf "%-26s" (string-append cap-name "_Name[]")) =]= "[=
        (string-tr! (string-append (get "enable") "-" flg-name)
                    optname-from optname-to) =]";[=
      ELSE =]
#define z[=(sprintf "%-27s " (string-append cap-name
        "_Name")) =](zNot[= (. cap-name) =]_Name + [=
        (+ (string-length (get "disable")) 1 ) =])[=
      ENDIF =][=


    ELSE  No disablement of this option:
    =]
#define zNot[= (sprintf "%-24s" (string-append cap-name "_Pfx"))
             =] NULL
#define zNot[= (sprintf "%-24s" (string-append cap-name "_Name"))
             =] NULL
tSCC    z[=    (sprintf "%-26s" (string-append cap-name "_Name[]"))
             =]= "[= (string-tr! (string-append
        (if (exist? "enable") (string-append (get "enable") "-") "")
        (get "name"))   optname-from optname-to) =]";[=

    ENDIF (> (len "disable") 0) =][=

    #  Check for special attributes:  a default value
    #  and conflicting or required options
    =][=
    IF (exist? "arg_default")   =][=
       CASE arg_type            =][=
       =* num                   =]
#define z[=(sprintf "%-27s " (string-append cap-name "DefaultArg" ))
         =]((tCC*)[= arg_default =])[=

       =* bool                  =][=
          CASE arg_default      =][=
          ~ n.*|f.*|0           =]
#define z[=(sprintf "%-27s " (string-append cap-name "DefaultArg" ))
         =]((tCC*)AG_FALSE)[=
          *                     =]
#define z[=(sprintf "%-27s " (string-append cap-name "DefaultArg" ))
         =]((tCC*)AG_TRUE)[=
          ESAC                  =][=

       =* key                   =]
#define z[=(sprintf "%-27s " (string-append cap-name "DefaultArg" ))
         =]((tCC*)[=
          IF (=* (get "arg_default") (string-append Cap-prefix cap-name))
            =][= arg_default    =][=
          ELSE  =][=(string-append UP-prefix UP-name)=]_[=
                    (string-upcase! (get "arg_default"))=][=
          ENDIF =])[=

       =* str                   =]
tSCC    z[=(sprintf "%-28s" (string-append cap-name "DefaultArg[]" ))
         =]= [=(kr-string (get "arg_default"))=];[=

       *                        =][=
          (error (string-append cap-name
                 " has arg_default, but no valid arg_type"))  =][=
       ESAC                     =][=
    ENDIF                       =][=


    IF (exist? "flags_must") =]
static const int
    a[=(. cap-name)=]MustList[] = {[=
      FOR flags_must =]
    INDEX_[= (. UP-prefix) =]OPT_[= (string-upcase! (get "flags_must")) =],[=
      ENDFOR flags_must =] NO_EQUIVALENT };[=
    ENDIF =][=


    IF (exist? "flags_cant") =]
static const int
    a[=(. cap-name)=]CantList[] = {[=
      FOR flags_cant =]
    INDEX_[= (. UP-prefix) =]OPT_[= (string-upcase! (get "flags_cant")) =],[=
      ENDFOR flags_cant =] NO_EQUIVALENT };[=
    ENDIF =]
#define [=(. UP-name)=]_FLAGS       ([=
         CASE arg_type  =][=
         =*   num       =]OPTST_NUMERIC | [=
         =*   bool      =]OPTST_BOOLEAN | [=
         =*   key       =]OPTST_ENUMERATION | [=
         ESAC           =][=
         stack-arg      "OPTST_STACKED | "     =][=
         immediate      "OPTST_IMM | "         =][=
         immed_disable  "OPTST_DISABLE_IMM | " =][=
         must-set       "OPTST_MUST_SET | "    =][=
         ? enabled      "OPTST_INITENABLED"
                        "OPTST_DISABLED"    =] | [=
         ? no_preset    "OPTST_NO_INIT"
                        "OPTST_INIT"           =])[=
ENDDEF   emit-nondoc-option     =][=

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Define the arrays of values associated with an option (strings, etc.) =][=

DEFINE   Option_Strings

=]
/*
 *  [=(. cap-name)=] option description[=
  IF (or (exist? "flags_must") (exist? "flags_cant")) =] with
 *  "Must also have options" and "Incompatible options"[=
  ENDIF =]:
 */[=

  IF (. skip-ifdef)        =][=
  ELSE                     =][=
    IF   (exist? "ifdef")  =]
#ifdef [=(get "ifdef")     =][=
    ELIF (exist? "ifndef") =]
#ifndef [=(get "ifndef")   =][=
    ENDIF ifdef/ifndef     =][=
  ENDIF =]
tSCC    z[=(. cap-name)=]Text[] =
        [=(kr-string (get "descrip"))=];[=

  IF (exist? "documentation")     =]
#define [=(. UP-name)=]_FLAGS       (OPTST_DOCUMENT | OPTST_NO_INIT)[=
  ELSE  NOT a doc option:         =][=
     emit-nondoc-option           =][=
  ENDIF  (exist? "documentation") =][=

  IF (. skip-ifdef)        =][=
  ELSE                     =][=
    IF (or (exist? "ifdef") (exist? "ifndef")) =]

#else   /* disable [=(. cap-name)=] */
#define VALUE_[=(. UP-prefix)=]OPT_[=(. UP-name)=] NO_EQUIVALENT
#define [=(. UP-name)=]_FLAGS       (OPTST_OMITTED | OPTST_NO_INIT)[=

      IF (exist? "arg_default") =]
#define z[=(. cap-name)=]DefaultArg NULL[=
      ENDIF =][=

      IF (exist? "flags_must")  =]
#define a[=(. cap-name)=]MustList   NULL[=
      ENDIF =][=

      IF (exist? "flags_cant")  =]
#define a[=(. cap-name)=]CantList   NULL[=
      ENDIF =]
#define z[=(. cap-name)=]Text       NULL
#define z[=(. cap-name)=]_NAME      NULL
#define z[=(. cap-name)=]_Name      NULL
#define zNot[=(. cap-name)=]_Name   NULL
#define zNot[=(. cap-name)=]_Pfx    NULL
#endif  /* ifdef/ifndef  */[=
    ENDIF ifdef/ifndef   =][=
  ENDIF (. skip-ifdef)   =][=

ENDDEF Option_Strings =][=


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

Define the values for an option descriptor   =][=

DEFINE Option_Descriptor =][=

  IF (exist? "documentation") =]
  {  /* entry idx, value */ 0, 0,
     /* equiv idx, value */ 0, 0,
     /* option argument  */ ARG_NONE,
     /* equivalenced to  */ NO_EQUIVALENT,
     /* min, max, act ct */ 0, 0, 0,
     /* opt state flags  */ [=(. UP-name)=]_FLAGS,
     /* last opt argumnt */ NULL,
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ NULL, NULL,
     /* option proc      */ [=
         IF   (exist? "call_proc")        =][=call_proc=][=
         ELIF (or (exist? "extract_code")
                  (exist? "flag_code"))   =]doOpt[=(. cap-name)=][=
         ELSE                             =]NULL[=
         ENDIF =],
     /* desc, NAME, name */ z[=(. cap-name)=]Text, NULL, NULL,
     /* disablement strs */ NULL, NULL },[=

  ELSE

=]
  {  /* entry idx, value */ [=(for-index)=], VALUE_[=
                              (. UP-prefix)=]OPT_[=(. UP-name)=],
     /* equiv idx, value */ [=
          IF (== (string-upcase! (get "equivalence")) UP-name)
              =]NO_EQUIVALENT, 0,[=
          ELIF (exist? "equivalence")
              =]NOLIMIT, NOLIMIT,[=
          ELSE
              =][=(for-index)=], VALUE_[=(. UP-prefix)=]OPT_[=(. UP-name)=],[=
          ENDIF=]
     /* option argument  */ ARG_[=
         IF (not (exist? "arg_type"))  =]NONE[=
         ELIF (exist? "arg_optional")  =]MAY[=
         ELSE                          =]MUST[=
         ENDIF =],
     /* equivalenced to  */ [=
         IF (and (exist? "equivalence")
                 (not (string-ci=? (string-upcase! (get "equivalence"))
                                   (. UP-name)) ) )
               =]INDEX_[=(. UP-prefix)=]OPT_[=(string-upcase!
                         (get "equivalence"))=][=
         ELSE  =]NO_EQUIVALENT[=
         ENDIF =],
     /* min, max, act ct */ [=(if (exist? "min") (get "min") "0")=], [=
         (if (exist? "max") (get "max") "1")=], 0,
     /* opt state flags  */ [=(. UP-name)=]_FLAGS,
     /* last opt argumnt */ [=
         IF (exist? "arg_default")
              =](char*)z[=(. cap-name)=]DefaultArg[=
         ELSE =]NULL[= ENDIF =],
     /* arg list/cookie  */ NULL,
     /* must/cannot opts */ [=
         IF (exist? "flags_must")=]a[=(. cap-name)=]MustList[=
         ELSE                    =]NULL[=
         ENDIF=], [=
         IF (exist? "flags_cant")=]a[=(. cap-name)=]CantList[=
         ELSE                    =]NULL[=
         ENDIF=],
     /* option proc      */ [=
         IF   (exist? "call_proc")        =][=call_proc=][=
         ELIF (or (exist? "extract_code")
                  (exist? "flag_code")
                  (exist? "arg_range"))   =]doOpt[=(. cap-name)=][=

         ELIF (exist? "flag_proc") =]doOpt[= (string-capitalize!
                                             (get "flag_proc")) =][=

         ELIF (exist? "stack_arg") =][=
           IF (or (not (exist? "equivalence"))
                  (= (get "equivalence") (get "name")) )

                          =]stackOptArg[=
           ELSE           =]unstackOptArg[=
           ENDIF          =][=

         ELSE             =][=
           CASE arg_type  =][=
           =*   bool      =]optionBooleanVal[=
           =*   num       =]optionNumericVal[=
           =*   key       =]doOpt[=(. cap-name)=][=
           *              =]NULL[=
           ESAC           =][=
         ENDIF=],
     /* desc, NAME, name */ z[=(. cap-name)=]Text,  z[=(. cap-name)=]_NAME,
                            z[=(. cap-name)=]_Name,
     /* disablement strs */ zNot[=(. cap-name)
                            =]_Name, zNot[=(. cap-name)=]_Pfx },[=
  ENDIF =][=

ENDDEF Option_Descriptor =][=


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

Compute the usage line.  It is complex because we are trying to
encode as much information as we can and still be comprehensible.

The rules are:  If any options have a "value" attribute, then
there are flags allowed, so include "-<flag>" on the usage line.
If the program has the "long_opts" attribute set, then we must
have "<option-name>" or "--<name>" on the line, depending on
whether or not there are flag options.  If any options take 
arguments, then append "[<val>]" to the flag description and
"[{=| }<val>]" to the option-name/name descriptions.  We won't
worry about being correct if every option has a required argument.
Finally, if there are no minimum occurrence counts (i.e. all
options are optional), then we put square brackets around the
syntax. =][=

DEFINE USAGE_LINE   =][=

  ;;  Compute the option arguments
  ;;
  (if (exist? "flag.arg_type")
      (begin
        (define flag-arg " [<val>]")
        (define  opt-arg "[{=| }<val>]") )
      (begin
        (define flag-arg "")
        (define  opt-arg "") )  )

  (define usage-line (string-append "USAGE:  %s "

      ;; If at least one option has a minimum occurrence count
      ;; we use curly brackets around the option syntax.
      ;;
      (if (not (exist? "flag.min")) "[ " "{ ")

    (if (exist? "flag.value")
        (string-append "-<flag>" flag-arg
           (if (exist? "long_opts") " | " "") )
        (if (not (exist? "long_opts"))
           (string-append "<option-name>" opt-arg))  )

    (if (exist? "long_opts")
        (string-append "--<name>" opt-arg) "" )

    (if (not (exist? "flag.min")) " ]..." " }...")
  ) )

  (if (exist? "argument")

    (set! usage-line (string-append usage-line

          ;; the USAGE line plus the program name plus the argument goes
          ;; past 80 columns, then break the line, else separate with space
          ;;
          (if (< 80 (+ (string-length usage-line)
                (len "argument")
                (len "prog_name") ))
              " \\\n\t\t"  " ")
          (get "argument")  ))
  )

  (kr-string (string-append prog-name " - " (get "prog_title")
           (if (exist? "version") (string-append " - Ver. " (get "version"))
               "" )
           "\n" usage-line "\n" ))    =][=

ENDDEF
=]
