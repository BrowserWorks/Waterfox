[= AutoGen5 Template -*- Mode: text -*-

# $Id: optmain.tpl,v 2.23 2002/09/10 02:10:57 bkorb Exp $

# Automated Options copyright 1992-2002 Bruce Korb

=]
[=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   BUILD GUILE MAIN

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE build-guile-main

=]
int    original_argc;
char** original_argv;


    static void
#ifdef __cplusplus
inner_main( int argc, char** argv )
#else
inner_main( argc, argv )
      int    argc;
      char** argv;
#endif
{
    original_argc = argc;
    original_argv = argv;

    {
        int ct = optionProcess( &[=(. pname)=]Options, argc, argv );
        char** new_argv = (char**)malloc( (argc - ct + 2)*sizeof(char*) );

        if (new_argv == NULL) {
            fputs( "[=(. pname)=] cannot allocate new argv\n", stderr );
            exit( EXIT_FAILURE );
        }

        /*
         *  argc will be reduced by one less than the count returned
         *  by optionProcess.  That count includes the program name,
         *  but we are adding the program name back in (plus a NULL ptr).
         */
        argc -= (ct-1);
        new_argv[0] = argv[0];

        /*
         *  Copy the argument pointers, plus the terminating NULL ptr.
         */
        memcpy( new_argv+1, argv + ct, argc * sizeof( char* ));
        argv = new_argv;
    }
[=
  IF (> (len "guile-main") 0)  =]
    [=guile-main=]
    exit( EXIT_SUCCESS );[=
  ELSE  =]
    export_options_to_guile( &[=(. pname)=]Options );
    scm_shell( argc, argv );[=
  ENDIF =]
}

int
#ifdef __cplusplus
main( int    argc,
      char** argv )
#else
main( argc, argv )
      int    argc;
      char** argv;
#endif
{[=
    % before-guile-boot "\n    %s\n"
 =]
    gh_enter( argc, argv, inner_main );
    /* NOT REACHED */
    return 0;
}
[=

ENDDEF

=][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   BUILD TEST MAIN

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE build-test-main

=]
#if defined( TEST_[= (. pname-up) =]_OPTS )

int
main( int argc, char** argv )
{[=

  IF (= (get "test_main") "putShellParse") =]
    extern tOptions  genshelloptOptions;
    extern void      putShellParse( tOptions* );
    extern tOptions* pShellParseOptions;

    /*
     *  Stash a pointer to the options we are generating.
     *  `genshellUsage()' will use it.
     */
    pShellParseOptions = &[=prog_name=]Options;
    (void)optionProcess( &genshelloptOptions, argc, argv );
    putShellParse( &[=prog_name=]Options );[=

  ELIF
      ;;  Also check to see if the user supplies all the code for main()
      (exist? "main-text") =]
[= main-text =][=

  ELSE=]
    (void)optionProcess( &[=prog_name=]Options, argc, argv );[=

    IF  ;;  the user is specifying a routine to call, then call that procedure

        (> (string-length (get "test_main")) 3) =]

    {
        void [=test_main=]( tOptions* );
        [=test_main=]( &[=prog_name=]Options );
    }[=

   ELSE  Call our library procedure for emitting shell results
    =]
    putBourneShell( &[=prog_name=]Options );[=

    ENDIF =][=
  ENDIF=]
    return EXIT_SUCCESS;
}
#endif  /* defined TEST_[= (. pname-up) =]_OPTS */[=

ENDDEF  =][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   DECLARE OPTION CALLBACKS

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE declare-option-callbacks      =][=

   #  For test builds, no need to call option procs  =][=

  IF (exist? "test_main")            =]
#if ! defined( TEST_[=(. pname-up)=]_OPTS )[=
  ENDIF

  =]
/*
 *  Procedures to call when option(s) are encountered
 */[=


  FOR flag                           =][=
    (set-flag-names)                 =][=

    CASE arg_type                    =][=
    =*  key                          =]
static tOptProc doOpt[=(. cap-name)  =];[=
    =*  bool                         =][=
    =*  num                          =][=
      IF (exist? "arg_range")        =]
static tOptProc doOpt[=(. cap-name)  =];[=
      ENDIF                          =][=
    *                                =][=
      IF (exist? "call_proc")        =]
extern tOptProc [=(get "call_proc")  =];[=

      ELIF (or (exist? "extract_code")
               (exist? "flag_code")) =]
static tOptProc doOpt[=(. cap-name)  =];[=

      ENDIF                          =][=
    ESAC                             =][=
  ENDFOR                             =][=
 
  IF (exist? "test_main")            =][=

     # "A test environment is to be generated" =]

#else /* *is*  defined( TEST_[=(. pname-up)=]_OPTS ) */
/*
 *  Under test, omit argument processing, or call stackOptArg,
 *  if multiple copies are allowed.
 */[=
    FOR flag            =][=
    (set! cap-name (string->c-name! (string-capitalize! (get "name"))) ) =][=

      IF (exist? "call_proc") =]
#define [=(get "call_proc")   =] [=
          IF (~ (get "max") "1{0,1}")
                        =]NULL[=
          ELSE          =]stackOptArg[=
          ENDIF         =][=

      ELIF (or (exist? "flag_code")
               (exist? "extract_code")
               (exist? "arg_range")) =]
#define doOpt[=(. cap-name)   =] [=
          IF (~ (get "max") "1{0,1}")
                        =]NULL[=
          ELSE          =]stackOptArg[=
          ENDIF         =][=

      ELIF (=* (get "arg_type") "key")  =]
static tOptProc doOpt[=(. cap-name)  =];[=
      ENDIF             =][=

    ENDFOR flag         =]
#endif /* defined( TEST_[=(. pname-up)=]_OPTS ) */[=
  ENDIF (exist? "test_main") =]
[=

ENDDEF

=][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   DEFINE OPTION CALLBACKS

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE callback-proc-header     =]

/* * * * * * *
 *
 *   For the "[=(string-capitalize! (get "name"))=] Option".
 */
static void
#ifdef __cplusplus
doOpt[=(. cap-name) =](
    tOptions*   pOptions,
    tOptDesc*   pOptDesc )
#else
doOpt[=(. cap-name) =]( pOptions, pOptDesc )
    tOptions*   pOptions;
    tOptDesc*   pOptDesc;
#endif
{
[=

ENDDEF                          =][=

# # # # # # # # # # # # # # # # =][=

DEFINE range-option-code

=][=

(if (not (=* (get "arg_type") "num"))
    (error (string-append "range option " low-name " is not numeric")) )

=]    static const struct {const int rmin, rmax;} rng[ [=(count "arg_range")=] ] = {
[=(out-push-new)      =][=
  FOR arg_range ",\n" =][=
    CASE arg_range    =][=
      *==    "->"     =][=
             (shellf "f=`echo '%s'|sed 's,->$,,'`
                     echo \"{ $f, INT_MAX }\"" (get "arg_range")) =][=

      ==*    "->"     =][=
             (shellf "f=`echo '%s'|sed 's,^->,,'`
                     echo \"{ INT_MIN, $f }\"" (get "arg_range")) =][=

      *==*   "->"     =][=
             (shellf "f=`echo '%s'|sed 's/->/, /'`
                     echo \"{ $f }\"" (get "arg_range")) =][=

      ~~ -{0,1}[0-9]+ =]{ [=arg_range=], INT_MIN }[=

      *  =][= (error (string-append "Invalid range spec:  ``"
              (get "arg_range") "''" ))  =][=

    ESAC arg_range    =][=
  ENDFOR =][=
  (shellf "${COLUMNS_EXE} -I8 --spread=2 <<_EOF_\n%s\n_EOF_"
          (out-pop #t)) =] };
    int val, ix;
    tCC* pzIndent = "\t\t\t\t  ";

    if (pOptDesc == NULL) /* usage is requesting range list */
        goto emit_ranges;

    val = atoi( pOptDesc->pzLastArg );
    for (ix = 0; ix < [=(count "arg_range")=]; ix++) {
        if (val < rng[ix].rmin)
            continue;  /* ranges need not be ordered. */
        if (val == rng[ix].rmin)
            goto valid_return;
        if (rng[ix].rmax == INT_MIN)
            continue;
        if (val <= rng[ix].rmax)
            goto valid_return;
    }

    fprintf( stderr, "%s error:  %s option value ``%s''is out of range.\n",
             pOptions->pzProgName, pOptDesc->pz_Name, pOptDesc->pzLastArg );
    pzIndent = "\t";

  emit_ranges:[=


  IF (> (count "arg_range") 1) =]
    fprintf( stderr, "%sit must lie in one of the ranges:\n", pzIndent );
    for ( ix=0;; ) {
        if (rng[ix].rmax == INT_MIN)
             fprintf( stderr, "%s%d exactly", pzIndent, rng[ix].rmin );
        else fprintf( stderr, "%s%d to %d", pzIndent,
                      rng[ix].rmin, rng[ix].rmax );
        if (++ix >= [=(count "arg_range")=])
            break;
        fputs( ", or\n", stderr );
    }

    fputc( '\n', stderr );[=

  ELIF (*==* (get "arg_range") "->")  =]
    fprintf( stderr, "%sit must lie in the range: %d to %d\n",
             pzIndent, rng[0].rmin, rng[0].rmax );[=

  ELSE  =]
    fprintf( stderr, "%sit must be: %d exactly\n", pzIndent, rng[0].rmin );[=

  ENDIF =]
    if (pOptDesc == NULL)
        return;

    [=(. UP-prefix)=]USAGE( EXIT_FAILURE );
    /* NOTREACHED */

  valid_return:
    pOptDesc->pzLastArg = (char*)val;[=

ENDDEF                          =][=

# # # # # # # # # # # # # # # # =][=

DEFINE define-option-callbacks  =][=

  FOR  flag  =][=

    (set! UP-name    (string->c-name! (string-upcase! (get "name"))) )
    (set! cap-name   (string-capitalize UP-name))
    (set! low-name   (string-downcase UP-name))      =][=

    IF (or (exist? "flag_code")
           (exist? "extract_code")
           (exist? "arg_range") ) =][=

      IF (exist? "test_main") =]

#if ! defined( TEST_[= (. pname-up) =]_OPTS )[=

      ENDIF =][=

      invoke callback-proc-header  =][=

      IF (exist? "flag_code")      =][=
         flag_code                 =][=

      ELIF (exist? "extract_code") =][=
         (extract (string-append (base-name) ".c.save") (string-append
                  "/*  %s =-= " cap-name " Opt Code =-= %s */"))
         =][=

      ELIF (exist? "arg_range")    =][=
         range-option-code         =][=

      ENDIF =]
}[=

  IF (exist? "test_main") =]

#endif /* ! defined TEST_[= (. pname-up) =]_OPTS */[=

  ENDIF =][=


    ELIF (=* (get "arg_type") "key") =][=

      invoke callback-proc-header  =][=
      IF (not (exist? "arg_default"))
=]    tSCC zDef[2] = { 0x7F, 0 };
[=    ENDIF =][=

    IF (> (len "arg_optional") 0) =]
    te_[=(string-append Cap-prefix cap-name)=] def_val = [=
       IF (not (=* (get "arg_optional") low-name))
             =][=(. UP-name)=]_[=
       ENDIF =][=(string-upcase! (string->c-name! (get "arg_optional")))
             =];[=
    ENDIF
=]    tSCC* az_names[] = {[=
      IF (not (exist? "arg_default")) =] zDef,[=
      ENDIF  =]
[=(shellf
  "${COLUMNS_EXE} -I8 --spread=2 --sep=',' -f'\"%%s\"' <<_EOF_\n%s\n_EOF_\n"
          (join "\n" (stack "keyword")) )=]
    };
[=

    IF (> (len "arg_optional") 0) =]
    if (((tUL)pOptions > 0x0FUL) && (pOptDesc->pzLastArg == NULL))
        pOptDesc->pzLastArg = (char*)def_val;
    else[=
    ENDIF =]
    pOptDesc->pzLastArg =
        optionEnumerationVal( pOptions, pOptDesc, az_names, [=
        (+ (count "keyword") (if (exist? "arg_default") 0 1)) =] );
}[=
    ENDIF       =][=
  ENDFOR flag   =]
[=

ENDDEF

=]
