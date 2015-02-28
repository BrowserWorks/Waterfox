[= AutoGen5 Template   -*- Mode: C -*-

h=options.h

#ID:  $Id: options_h.tpl,v 2.8 2002/07/26 04:22:12 bkorb Exp $

=][=

(dne " *  " "/*  ")

=]
 *
 *  This file defines all the global structures and special values
 *  used in the automated option processing library.
 *
 *  Automated Options copyright 1992-[=`date +Y`=] Bruce Korb
 *
[=(lgpl "AutoOpts" "Bruce Korb" " *  ")=]
 */
[=(make-header-guard "autoopts")=]

/*
 *  PUBLIC DEFINES
 *
 *  The following defines may be used in applications that need to test
 *  the state of an option.  To test against these masks and values,
 *  a pointer to an option descriptor must be obtained.  There are two
 *  ways:  1.  inside an option processing procedure, it is the second
 *  argument, conventionally "tOptDesc* pOD".  2.  Outside of an option
 *  procedure (or to reference a different option descriptor), use
 *  either "&DESC( opt_name )" or "&pfx_DESC( opt_name )".  See the
 *  relevant generated header file to determine which and what values
 *  for "opt_name" are available.
 */

#define OPTST_INIT         0x00000  /* Initial compiled value            */
#define OPTST_SET          0x00001  /* Set via the "SET_OPT()" macro     */
#define OPTST_PRESET       0x00002  /* Set via an RC/INI file            */
#define OPTST_DEFINED      0x00004  /* Set via a command line option     */
#define OPTST_SET_MASK     0x0000F  /* mask of flags that show set state */

#define OPTST_EQUIVALENCE  0x00010  /* selected by equiv'ed option       */
#define OPTST_DISABLED     0x00020  /* option is in disabled state       */

#define OPTST_NO_INIT      0x00100  /* option cannot be preset           */
#define OPTST_NUMBER_OPT   0x00200  /* opt value (flag) is any digit     */
#define OPTST_STACKED      0x00400  /* opt uses stackOptArg procedure    */
#define OPTST_INITENABLED  0x00800  /* option defaults to enabled        */
#define OPTST_ENUMERATION  0x01000  /* opt arg is an enum (keyword list) */
#define OPTST_BOOLEAN      0x02000  /* opt arg is boolean-valued         */
#define OPTST_NUMERIC      0x04000  /* opt arg has numeric value         */
#define OPTST_DOCUMENT     0x08000  /* opt is for documentation only     */
#define OPTST_IMM          0x10000  /* process option on first pass      */
#define OPTST_DISABLE_IMM  0x20000  /* process disablement on first pass */
#define OPTST_OMITTED      0x40000  /* compiled out of program           */
#define OPTST_MUST_SET     0x80000  /* must be set or pre-set            */

#define OPTST_PERSISTENT  0xFFFF00  /* mask of flags that do not change  */

#define SELECTED_OPT( pod )  ( (pod)->fOptState & (OPTST_SET | OPTST_DEFINED))
#define UNUSED_OPT(   pod )  (((pod)->fOptState & OPTST_SET_MASK) == 0)
#define DISABLED_OPT( pod )  ( (pod)->fOptState & OPTST_DISABLED)
#define OPTION_STATE( pod )  ((pod)->fOptState)

/*
 *  PRIVATE INTERFACES
 *
 *  The following values are used in the generated code to communicate
 *  with the option library procedures.  They are not for public use
 *  and may be subject to change.
 */

/*
 *  Define any special processing flags
 */
#define OPTPROC_NONE        0x0000
#define OPTPROC_LONGOPT     0x0001 /* Process long style options      */
#define OPTPROC_SHORTOPT    0x0002 /* Process short style "flags"     */
#define OPTPROC_ERRSTOP     0x0004 /* Stop on argument errors         */
#define OPTPROC_DISABLEDOPT 0x0008 /* Current option is disabled      */
#define OPTPROC_NO_REQ_OPT  0x0010 /* no options are required         */
#define OPTPROC_NUM_OPT     0x0020 /* there is a number option        */
#define OPTPROC_INITDONE    0x0040 /* have initializations been done? */
#define OPTPROC_NEGATIONS   0x0080 /* any negation options?           */
#define OPTPROC_ENVIRON     0x0100 /* check environment?              */
#define OPTPROC_NO_ARGS     0x0200 /* Disallow remaining arguments    */
#define OPTPROC_ARGS_REQ    0x0400 /* Require arguments after options */
#define OPTPROC_REORDER     0x0800 /* reorder argunemts after options */

#define STMTS(s)  do { s; } while (0)

#define ARG_NONE  ' '
#define ARG_MUST  ':'
#define ARG_MAY   '?'

/*
 *  The following must be #defined instead of typedef-ed
 *  because "static const" cannot both be applied to a type,
 *  tho each individually can...so they all are
 */
#define tSCC      static const char
#define tSC       static char
#define tCUC      const unsigned char
#define tUC       unsigned char
#define tCC       const char
#define tUI       unsigned int
#define tUL       unsigned long

/*
 *  It is so disgusting that there must be so many ways
 *  of specifying TRUE and FALSE.
 */
typedef enum { AG_FALSE = 0, AG_TRUE } ag_bool;

/*
 *  Define a structure that describes each option and
 *  a pointer to the procedure that handles it.
 *  The argument is the count of this flag previously seen.
 */
typedef struct options  tOptions;
typedef struct optDesc  tOptDesc;
typedef struct optNames tOptNames;

/*
 *  The option procedures do the special processing for each
 *  option flag that needs it.
 */
typedef void (tOptProc)( tOptions*  pOpts, tOptDesc* pOptDesc );
typedef tOptProc*  tpOptProc;

/*
 *  The usage procedure will never return.  It calls "exit(2)"
 *  with the "exitCode" argument passed to it.
 */
typedef void (tUsageProc)( tOptions* pOpts, int exitCode );
typedef tUsageProc* tpUsageProc;

/*
 *  Special definitions.  "NOLIMIT" is the 'max' value to use when
 *  a flag may appear multiple times without limit.  "NO_EQUIVALENT"
 *  is an illegal value for 'optIndex' (option description index).
 */
#define NOLIMIT          ((tUC)~0)
#define OPTION_LIMIT     0x7F
#define NO_EQUIVALENT    (OPTION_LIMIT+1)

/*
 *  Special values for optValue.  It must not be generatable from the
 *  computation "optIndex +96".  Since "optIndex" is limited to 100, ...
 */
#define NUMBER_OPTION    '#'

typedef struct argList tArgList;
#define MIN_ARG_ALLOC_CT   6
#define INCR_ARG_ALLOC_CT  8
struct argList {
    int               useCt;
    int               allocCt;
    char*             apzArgs[ MIN_ARG_ALLOC_CT ];
};

/*
 *  Descriptor structure for each option.
 *  Only the fields marked "PUBLIC" are for public use.
 */
struct optDesc {
    tCUC              optIndex;         /* PUBLIC */
    tCUC              optValue;         /* PUBLIC */
    tUC               optActualIndex;   /* PUBLIC */
    tUC               optActualValue;   /* PUBLIC */

    tUC               optArgType;
    tCUC              optEquivIndex;    /* PUBLIC */
    tCUC              optMinCt;
    tCUC              optMaxCt;

    tUL               optOccCt;         /* PUBLIC */
    tUL               fOptState;        /* PUBLIC */
    char*             pzLastArg;        /* PUBLIC */
    void*             optCookie;        /* PUBLIC */

    const int *       pOptMust;
    const int *       pOptCant;
    tpOptProc         pOptProc;
    const char*       pzText;

    const char*       pz_NAME;
    const char*       pz_Name;
    const char*       pz_DisableName;
    const char*       pz_DisablePfx;
};

/*
 *  Some options need special processing, so we store their
 *  indexes in a known place:
 */
typedef struct specOptIndex tSpecOptIndex;
struct specOptIndex {
    tUC               more_help;
    tUC               save_opts;
    tUC               number_option;
    tUC               default_opt;
};
[=# /*
     *  These "vers" values are manipulated by the contents of ../VERSION
     */ =]
#define  OPTIONS_STRUCT_VERSION  [=  vers-curr    =]
#define  OPTIONS_VERSION_STRING  "[= vers-info    =]"
#define  OPTIONS_MINIMUM_VERSION [=  vers-min     =]
#define  OPTIONS_MIN_VER_STRING  "[= vers-min-str =]"

struct options {
    const int         structVersion;
    const char*       pzProgPath;
    const char*       pzProgName;
    const char*       pzPROGNAME;
    const char*       pzRcName;
    const char*       pzCopyright;
    const char*       pzCopyNotice;
    const char*       pzFullVersion;
    const char**      papzHomeList;
    const char*       pzUsageTitle;
    const char*       pzExplain;
    const char*       pzDetail;
    void*             pSavedState;
    tpUsageProc       pUsageProc;
    tUI               fOptSet;
    tUI               curOptIdx;
    char*             pzCurOpt;
    tSpecOptIndex     specOptIdx;
    const int         optCt;
    const int         presetOptCt;
    tOptDesc*         pOptDesc;
    int               origArgCt;
    char**            origArgVect;
    const char*       pzBugAddr;
};

#if defined( __STDC__ ) || defined( __cplusplus )
#  ifndef PROTO
#    define PROTO(s) s
#  endif

#else
#  ifndef PROTO
#    define PROTO(s) ()
#  endif

#  ifndef void
#    define void int
#  endif

#  ifndef const
#    define const
#  endif
#endif

#ifdef  __cplusplus
extern "C" {
#endif
[=

FOR export_func  "\n"   =][=

  IF (exist? "private") =]
/* AutoOpts PRIVATE FUNCTION: */[=
  ELSE  =]
/* From: [=srcfile=] line [=linenum=]
 *
 * [=name=] - [=what=]
[=   IF (exist? "arg") =] *
 * Arguments:[=
       FOR arg     =]
 * [=(sprintf "%-12s " (get "arg-name"))=][=arg-desc=][=
       ENDFOR arg  =]
[=   ENDIF =][=

     IF (exist? "ret-type") =] *
 * Returns: [=ret-type=] - [=ret-desc=]
[=   ENDIF =] *
[=(prefix " *  " (get "doc"))=]
 */[=
   ENDIF
=]
[= ?% ret-type "%s" "void"  =] [=name=] PROTO(( [=
   IF (not (exist? "arg"))
          =]void[=
   ELSE   =][=(join ", " (stack "arg.arg-type")) =][=
   ENDIF  =] ));
[=ENDFOR  =]
/*
 *  These routines should only be called by code generated by AutoOpts.
 *  These are not user functions.
 */
tOptProc stackOptArg, unstackOptArg, optionBooleanVal, optionNumericVal;

#ifdef  __cplusplus
}
#endif
#endif /* [=(. header-guard)=] */
/*
 * Local Variables:
 * c-file-style: "stroustrup"
 * indent-tabs-mode: nil
 * End:
 * [=(out-name)=] ends here */[=

## optexport.tpl ends here  =]
