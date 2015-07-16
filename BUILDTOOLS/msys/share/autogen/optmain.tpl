[= AutoGen5 Template -*- Mode: text -*-

# Time-stamp:      "2010-02-24 08:41:04 bkorb"

# $Id$

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

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   BUILD GUILE MAIN

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE build-guile-main

=][=
(tpl-file-line extract-fmt)
=]
int    original_argc;
char** original_argv;

static void
inner_main(int argc, char** argv)
{
    original_argc = argc;
    original_argv = argv;

    {
        int ct = optionProcess(&[=(. pname)=]Options, argc, argv);
        char** new_argv = (char**)malloc((argc - ct + 2)*sizeof(char*));

        if (new_argv == NULL) {
            fputs(_("[=(. pname)=] cannot allocate new argv\n"), stderr);
            exit(EXIT_FAILURE);
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
        memcpy(new_argv+1, argv + ct, argc * sizeof(char*));
        argv = new_argv;
    }[=

  IF (> (len "guile-main") 0)  =][=

(def-file-line "copyright.text" extract-fmt) =]
[= guile-main =]
    exit( EXIT_SUCCESS );[=
  ELSE  =]

    export_options_to_guile( &[=(. pname)=]Options );
    scm_shell(argc, argv);[=
  ENDIF =]
}

int
main(int argc, char** argv)
{[=
  (if (exist? "before-guile-boot")
    (string-append (def-file-line "before-guile-boot" extract-fmt)
       (get "before-guile-boot") ) )
=]
    gh_enter( argc, argv, inner_main );
    /* NOT REACHED */
    return 0;
}
[=

ENDDEF build-guile-main

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   BUILD TEST MAIN

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE build-test-main

=][=
(tpl-file-line extract-fmt)
=]
#if defined([=(. main-guard)=]) /* TEST MAIN PROCEDURE: */[=

  IF (= (get "test-main") "optionParseShell")

=]

extern tOptions  genshelloptOptions;
extern void      optionParseShell( tOptions* );
extern tOptions* pShellParseOptions;[=

  ELIF (not (exist? "main-text"))  =][=

    (define option-emitter-proc (get "test-main"))
    (if (<= (string-length option-emitter-proc) 3)
        (set! option-emitter-proc "optionPutShell"))
=]

extern void [= (. option-emitter-proc) =]( tOptions* );[=

  ENDIF

=]

int
main(int argc, char** argv)
{
    int res = EXIT_SUCCESS;[=

  IF (= (get "test-main") "optionParseShell") =]
    /*
     *  Stash a pointer to the options we are generating.
     *  `genshellUsage()' will use it.
     */
    pShellParseOptions = &[=(. pname)=]Options;
    (void)optionProcess( &genshelloptOptions, argc, argv );
    optionParseShell( &[=(. pname)=]Options );[=

  ELIF (exist? "main-text") =][=
    IF (not (exist? "option-code")) =]
    {
        int ct = optionProcess( &[=(. pname)=]Options, argc, argv );
        argc -= ct;
        argv += ct;
    }[=
    ELSE            =][=
      (def-file-line "option-code" extract-fmt) =][=
      option-code   =][=
    ENDIF           =][=

  (def-file-line "main-text" extract-fmt) =][=
  main-text         =][=

  ELSE test-main is not optionParseShell and main-text not exist

=]
    (void)optionProcess( &[=(. pname)=]Options, argc, argv );
    [= (. option-emitter-proc) =]( &[=(. pname)=]Options );[=
  ENDIF=]
    return res;
}
#endif  /* defined [= (. main-guard) =] */[=

ENDDEF  build-test-main

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   BUILD FOR-EACH MAIN

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE for-each-main            =][=

  (if (not (==* (get "argument") "[" ))
      (error "command line arguments must be optional for a 'for-each' main"))

  (if (not (exist? "handler-proc"))
      (error "'for-each' mains require a handler proc") )

=][=
(define handler-arg-type "")
(tpl-file-line extract-fmt)
=]
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static char*
trim_input_line(char* pz_s)
{
    char* pz_e = pz_s + strlen( pz_s );
    while ((pz_e > pz_s) && isspace( pz_e[-1] ))  pz_e--;
    *pz_e = '\0';
    while (isspace( *pz_s ))  pz_s++;

    switch (*pz_s) {
    case '\0':
    case '[= ?% comment-char "%s" "#" =]':
        return NULL;
    default:
        return pz_s;
    }
}[=

CASE handler-type =][=
=*  name         =][= (set! handler-arg-type "char const* pz_fname")
                      (define handler-proc "validate_fname")       =][=
=*  file         =][=
   (set! handler-arg-type "char const* pz_fname, FILE* entry_fp")
                      (define handler-proc "validate_fname")       =][=
*=* text         =][=
   (set! handler-arg-type
         "char const* pz_fname, char* pz_file_text, size_t text_size")
                      (define handler-proc "validate_fname")       =][=
!E               =][= (set! handler-arg-type "char const* pz_entry")
                      (define handler-proc (get "handler-proc"))       =][=
*                =][= (error) =][=
ESAC             =][=

IF (set! tmp-text (string-append (get "handler-proc") "-code"))
   (exist? tmp-text) =]

static int
[= handler-proc =]([=(. handler-arg-type)=])
{
    int res = 0;[=
   (string-append
      (def-file-line tmp-text extract-fmt)
      (get tmp-text) ) =]
    return res;
}[=

ELSE

=]

extern int [= handler-proc =]( [=(. handler-arg-type)=] );[=

ENDIF

=][=
(tpl-file-line extract-fmt)
=][=

IF (exist? "handler-type")  =]

static int
validate_fname(char const* pz_fname)
{
    char const* pz_fs_err =
        _("fs error %d (%s) %s-ing %s\n");[=

  IF (*=* (get "handler-type") "text") =]
    char*  file_text;
    size_t text_size;
    int    res;[=
  ENDIF =]

    {
        struct stat sb;
        if (stat( pz_fname, &sb ) < 0) {
            fprintf( stderr, pz_fs_err, errno, strerror(errno), "stat",
                     pz_fname );
            return 1;
        }[=

  IF (*=* (get "handler-type") "text") =]

        if (! S_ISREG(sb.st_mode)) {
            fprintf( stderr, pz_fs_err, EINVAL, strerror(EINVAL),
                     "not regular file:", pz_fname );
            return 1;
        }[=

    IF (=* (get "handler-type") "some-text") =]

        if (sb.st_size == 0) {
            fprintf( stderr, pz_fs_err, EINVAL, strerror(EINVAL),
                     "empty file:", pz_fname );
            return 1;
        }[=

    ENDIF  =]

        text_size = sb.st_size;[=

  ENDIF

=]
    }[=

CASE handler-type =][=
=*  name         =][=
    (tpl-file-line extract-fmt)
    =]

    return [= handler-proc =](pz_fname);[=

=*  file         =][=
    (tpl-file-line extract-fmt)
    =]
    {
        int res;
        FILE* fp = fopen(pz_fname, "[=
        (shellf "echo '%s' | sed 's/.*-//'"
                (get "handler-type")) =]");
        if (fp == NULL) {
            fprintf( stderr, pz_fs_err, errno, strerror(errno), "fopen",
                     pz_fname );
            return 1;
        }
        res = [= handler-proc =](pz_fname, fp);
        fclose(fp);
        return res;
    }[=

*=*  text        =][=
    (tpl-file-line extract-fmt)
    =]
    file_text = malloc( text_size + 1 );
    if (file_text == NULL) {
        fprintf(stderr, _("cannot allocate %d bytes for %s file text\n"),
                text_size+1, pz_fname);
        exit( EXIT_FAILURE );
    }

    {
        char*   pz = file_text;
        size_t  sz = text_size;
        int     fd = open(pz_fname, O_RDONLY);
        int     try_ct = 0;

        if (fd < 0) {
            fprintf( stderr, pz_fs_err, errno, strerror(errno), "open",
                     pz_fname );
            free(file_text);
            return 1;
        }

        while (sz > 0) {
            ssize_t rd_ct = read( fd, pz, sz );
            /*
             *  a read count of zero is theoretically okay, but we've already
             *  checked the file size, so we shoud be reading more.
             *  For us, a count of zero is an error.
             */
            if (rd_ct <= 0) {
                /*
                 * Try retriable errors up to 10 times.  Then bomb out.
                 */
                if (  ((errno == EAGAIN) || (errno == EINTR))
                   && (++try_ct < 10)  )
                    continue;

                fprintf( stderr, pz_fs_err, errno, strerror(errno), "read",
                         pz_fname );
                exit( EXIT_FAILURE );
            }
            pz += rd_ct;
            sz -= rd_ct;
        }
        close(fd);
    }

    /*
     *  Just in case it is a text file, we have an extra byte to NUL
     *  terminate the thing.
     */
    file_text[ text_size ] = '\0';
    res = [= handler-proc =](pz_fname, file_text, text_size);
    free(file_text);
    return res;[=
ESAC             =]
}[=

ENDIF handler-type exists

=][=
(tpl-file-line extract-fmt)
=]

int
main(int argc, char** argv)
{
    int res = 0;
    {
        int ct = optionProcess( &[=(. pname)=]Options, argc, argv );
        argc -= ct;
        argv += ct;
    }[=

    (def-file-line "main-init" extract-fmt) =][=
    main-init =][=
    (tpl-file-line extract-fmt)

=]
    /*
     *  Input list from command line
     */
    if (argc > 0) {
        do  {
            res |= [= (. handler-proc) =]( *(argv++) );
        } while (--argc > 0);
    }

    /*
     *  Input list from tty input
     */
    else if (isatty( STDIN_FILENO )) {
        fputs( _("[=(. prog-name)=] ERROR: input list is a tty\n"), stderr );
        [= (. UP-prefix) =]USAGE( EXIT_FAILURE );
        /* NOTREACHED */
    }

    /*
     *  Input list from a pipe or file or some such
     */
    else {
        int in_ct   = 0;
        size_t pg_size = getpagesize();
        char* buf   = malloc( pg_size );
        if (buf == NULL) {
            fputs( _("[=(. prog-name)
                   =] ERROR: no memory for input list\n"), stderr );
            return EXIT_FAILURE;
        }

        for (;;) {
            char* pz = fgets( buf, (ssize_t)pg_size, stdin );
            if (pz == NULL)
                break;

            pz = trim_input_line( pz );
            if (pz != NULL) {
                 res |= [= (. handler-proc) =]( pz );
                 in_ct++;
            }
        }

        if (in_ct == 0)
            fputs( _("[=(. prog-name)
                   =] Warning:  no input lines were read\n"), stderr );
        free(buf);
    }[=

    (def-file-line "main-fini" extract-fmt) =][=
    main-fini =][=
    (tpl-file-line extract-fmt)

=]

    return res;
}[=

ENDDEF  for-each-main

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   BUILD MAIN

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE build-main               =][= FOR main[] =][=

 CASE main-type                 =][=
  == guile                      =][=
     build-guile-main           =][=

  == shell-process              =][=
     INVOKE build-test-main  test-main = "optionPutShell"   =][=

  == shell-parser               =][=
     INVOKE build-test-main  test-main = "optionParseShell" =][=

  == main                       =][=
     INVOKE build-test-main     =][=

  == include                    =]
[=   INCLUDE tpl                =][=

  == invoke                     =][=
     INVOKE (get "func")        =][=

  == for-each                   =][=
     INVOKE for-each-main       =][=

  *                             =][=
     (error (sprintf "unknown/invalid main-type: '%s'" (get "main-type"))) =][=

  ESAC =][= ENDFOR first-main   =][=

ENDDEF build-main

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   DECLARE OPTION CALLBACK PROCEDURES

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE decl-callbacks

   This is the test for whether or not to emit callback handling code:

=]
/*
 *  Declare option callback procedures
 */[=
  (define undef-proc-names "")
  (define decl-type "")
  (define extern-proc-list (string-append

    "optionPagedUsage\n"
    "optionStackArg\n"
    "optionUnstackArg\n"
    "optionBooleanVal\n"
    "optionNumericVal\n"
    "optionTimeVal\n"
    "optionNestedVal\n"
    "optionVersionStderr\n"
    "optionPrintVersion\n"
    "optionResetOpt\n"

  ) )

  (define extern-test-list "")

  (define emit-decl-list (lambda(txt-var is-extern)
    (if (> (string-length txt-var) 1) (begin

      (emit (if is-extern "\nextern tOptProc\n" "\nstatic tOptProc\n"))
      (set! txt-var (shellf "
        (egrep -v '^%s$' | sort -u | \
        sed 's@$@,@;$s@,$@;@' ) <<_EOProcs_\n%s_EOProcs_"
            (if is-extern "NULL" "(NULL|optionStackArg|optionUnstackArg)")
            txt-var ))

      (emit (shellf (if (< (string-length txt-var) 72)
                  "f='%s' ; echo \"   \" $f"
                  "${CLexe} --spread=1 -I4 <<_EOProcs_\n%s\n_EOProcs_" )
            txt-var ))
    ))
  ))

  (define static-proc-list "doUsageOpt\n")
  (define static-test-list static-proc-list)
  (define ifdef-fmt (string-append
    "\n#if%1$sdef %2$s"
    "\n  %3$s tOptProc %4$s;"
    "\n#else /* not %2$s */"
    "\n# define %4$s NULL"
    "\n#endif /* def/not %2$s */"))

  (define set-ifdef (lambda(n-or-def ifdef-cb ifdef-name) (begin
     (set! decl-type (if (hash-ref is-ext-cb-proc flg-name) "extern" "static"))
     (ag-fprintf 0 ifdef-fmt n-or-def ifdef-name decl-type ifdef-cb )
  )))

  (define set-cb-decl (lambda() (begin
     (if make-test-main (begin
         (set! tmp-val (hash-ref test-proc-name flg-name))
         (if (hash-ref is-ext-cb-proc flg-name)
             (set! extern-test-list (string-append extern-test-list
                   tmp-val "\n" ))

             (set! static-test-list (string-append static-test-list
                   tmp-val "\n" ))
         )
     )   )

     (set! tmp-val (hash-ref cb-proc-name flg-name))

     (if (exist? "ifdef")  (set-ifdef ""  tmp-val (get "ifdef"))
     (if (exist? "ifndef") (set-ifdef "n" tmp-val (get "ifdef"))
     (if (hash-ref is-ext-cb-proc flg-name)
         (set! extern-proc-list (string-append
               extern-proc-list tmp-val "\n" ))

         (set! static-proc-list (string-append
               static-proc-list tmp-val "\n" ))
     )))
  )))
  =][=

  FOR    flag   =][=

    ;;  Fill in four strings with names of callout procedures:
    ;;  extern-test-list - external callouts done IFF test main is built
    ;;  static-test-list - static callouts done IFF test main is built
    ;;  extern-proc-list - external callouts for normal compilation
    ;;  static-proc-list - static callouts for normal compilation
    ;;
    ;;  Anything under the control of "if[n]def" has the declaration or
    ;;  #define to NULL emitted immediately.
    ;;
    (set! flg-name (get "name"))

    (if (and (hash-ref have-cb-procs flg-name)
             (not (hash-ref is-lib-cb-proc flg-name)) )
              (set-cb-decl)
    )           =][=

  ENDFOR flag   =][=

  IF (. make-test-main)                         =][=
    INVOKE emit-testing-defines                 =][=
  ENDIF make-test-main                          =][=

  (emit-decl-list extern-proc-list #t)
  (emit-decl-list static-proc-list #f)
  (set! static-proc-list "")                    =][=

  FOR     flag                                  =][=

    (set! flg-name (get "name"))
    (if (not (= (hash-ref cb-proc-name  flg-name)
               (hash-ref test-proc-name flg-name)))
        (set! static-proc-list (string-append static-proc-list
              "#define " (up-c-name "name") "_OPT_PROC "
                     (hash-ref cb-proc-name flg-name) "\n"))  )
    =][=
  ENDFOR  flag                                  =][=

  IF (> (string-length static-proc-list) 0) =]

/*
 *  #define map the "normal" callout procs
 */
[= (. static-proc-list)                         =][=

  ENDIF  have some #define mappings

=][=

  IF (. make-test-main)                         =][=

    FOR     flag                                =][=
      IF (set! flg-name (get "name"))
         (not (= (hash-ref cb-proc-name   flg-name)
                 (hash-ref test-proc-name flg-name))) =]
#define [=(up-c-name "name")=]_OPT_PROC [=(hash-ref cb-proc-name flg-name)=][=
      ENDIF                                     =][=
    ENDFOR  flag                                =]
#endif /* defined([=(. main-guard)=]) */[=

  ENDIF (. make-test-main)                      =][=

(. undef-proc-names)                            =][=

ENDDEF decl-callbacks                           =][=

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE emit-testing-defines

=]
#if defined([=(tpl-file-line extract-fmt) main-guard =])
/*
 *  Under test, omit argument processing, or call optionStackArg,
 *  if multiple copies are allowed.
 */[=

    (emit-decl-list extern-test-list #t)
    (emit-decl-list static-test-list #f)
    (set! static-test-list "")                  =][=

    FOR     flag                                =][=

      (set! flg-name (get "name"))
      (if (not (= (hash-ref cb-proc-name  flg-name)
                 (hash-ref test-proc-name flg-name)))
          (set! static-test-list (string-append static-test-list
                "#define " (up-c-name "name") "_OPT_PROC "
                       (hash-ref test-proc-name flg-name) "\n"))  )
      =][=
    ENDFOR  flag                                =][=

    IF (> (string-length static-test-list) 0)   =]

/*
 *  #define map the "normal" callout procs to the test ones...
 */
[= (. static-test-list)                         =][=

    ENDIF  have some #define mappings

=]

#else /* NOT defined [=(. main-guard)=] */
/*
 *  When not under test, there are different procs to use
 */[=

ENDDEF emit-testing-defines

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

   DEFINE OPTION CALLBACKS

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE callback-proc-header     =]

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 *   For the [=name=] option[=

  IF  (exist? "ifdef")

=], when [= ifdef =] is #define-d.
 */
#ifdef [= ifdef                 =][=
    (set! endif-test-main (string-append
	   (sprintf "\n#endif /* defined %s */" (get "ifdef"))
	   endif-test-main
    )) =][=

  ELIF (exist? "ifndef")

=], when [= ifndef =] is *not* #define-d.
 */
#ifndef [= ifndef               =][=
    (set! endif-test-main (string-append
	   (sprintf "\n#endif /* ! defined %s */" (get "ifndef"))
	   endif-test-main
    )) =][=

  ELSE  unconditional code:

=].
 */[=

  ENDIF ifdef / ifndef

=]
static void
doOpt[= (set! endif-test-main (string-append "\n}" endif-test-main))
        cap-name =](tOptions* pOptions, tOptDesc* pOptDesc)
{
[=

ENDDEF   callback-proc-header

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE   scale-val

=]
    switch (*(pzEnd++)) {
    case '\0': pzEnd--;     break;
    case 't':  val *= 1000;
    case 'g':  val *= 1000;
    case 'm':  val *= 1000;
    case 'k':  val *= 1000; break;

    case 'T':  val *= 1024;
    case 'G':  val *= 1024;
    case 'M':  val *= 1024;
    case 'K':  val *= 1024; break;

    default:   goto bad_value;
    }
    if (*pzEnd != '\0')  goto bad_value;
[=

ENDDEF   scale-val

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE range-option-code

=][=

(if (not (=* (get "arg-type") "num"))
    (error (string-append "range option " low-name " is not numeric")) )
(define range-count (count "arg-range"))

\=]
    static const struct {long const rmin, rmax;} rng[[=
      (. range-count)  =]] = {
[=(out-push-new)      =][=
  FOR arg-range ",\n" =]{ [=
    CASE arg-range    =][=
      *==    "->"     =][=
             (string-substitute (get "arg-range") "->" "") =], LONG_MAX[=

      ==*    "->"     =]LONG_MIN, [=
             (string-substitute (get "arg-range") "->" "") =][=

      *==*   "->"     =][=
             (string-substitute (get "arg-range") "->" ", ") =][=

      ~~ -{0,1}[0-9]+ =][=arg-range=], LONG_MIN[=

      *  =][= (error (string-append "Invalid range spec:  ``"
              (get "arg-range") "''" ))  =][=

    ESAC arg-range    =] }[=
  ENDFOR =][=
  (shellf "${CLexe} -I8 --spread=2 <<_EOF_\n%s\n_EOF_"
          (out-pop #t)) =] };
    long val;
    int  ix;
    char * pzEnd;

    if (pOptions <= OPTPROC_EMIT_LIMIT)
        goto emit_ranges;[=

  IF (exist? "resettable")

=]
    if ((pOptDesc->fOptState & OPTST_RESET) != 0)
        return;[=

  ENDIF

=]

    errno = 0;
    val = strtol(pOptDesc->optArg.argString, &pzEnd, 0);
    if ((pOptDesc->optArg.argString == pzEnd) || (errno != 0))
        goto bad_value;
[=

    IF (exist? "scaled")
        =][= INVOKE scale-val =][=
    ELSE  =]
    if (*pzEnd != '\0')
        goto bad_value;[=

    ENDIF

=]
    for (ix = 0; ix < [=(. range-count)=]; ix++) {
        if (val < rng[ix].rmin)
            continue;  /* ranges need not be ordered. */
        if (val == rng[ix].rmin)
            goto valid_return;
        if (rng[ix].rmax == LONG_MIN)
            continue;
        if (val <= rng[ix].rmax)
            goto valid_return;
    }

  bad_value:

    option_usage_fp = stderr;

  emit_ranges:
    optionShowRange(pOptions, pOptDesc, (void *)rng, [= (. range-count) =]);
    return;

  valid_return:
    if ((pOptDesc->fOptState & OPTST_ALLOC_ARG) != 0) {
        free((void *)pOptDesc->optArg.argString);
        pOptDesc->fOptState &= ~OPTST_ALLOC_ARG;
    }
    pOptDesc->optArg.argInt = val;[=

ENDDEF   range-option-code

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE alias-option-code       \=]
    optionAlias(pOptions, pOptDesc, [=
        (string-append INDEX-pfx (up-c-name "aliases")) =]);
[=

ENDDEF   alias-option-code

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE   keyword-code           =][=

(set! tmp-ct (count "keyword"))
(if (not (exist? "arg-default"))
    (begin
      (set! tmp-ct (+ 1 tmp-ct))
      (emit "    static char const zDef[2] = { 0x7F, 0 };\n")
)   )

(emit (tpl-file-line extract-fmt))

(sprintf "    static char const * const azNames[%d] = {" tmp-ct)

=][=

? arg-default "\n" " zDef,\n"   =][=

(shell (string-append
  "${CLexe} -I8 --spread=2 --sep=',' -f'\"%s\"' <<_EOF_\n"
   (join "\n" (stack "keyword"))
  "\n_EOF_\n"  )) =]
    };

    if (pOptions <= OPTPROC_EMIT_LIMIT) {
        (void) optionEnumerationVal(pOptions, pOptDesc, azNames, [=
           (. tmp-ct)=]);
        return; /* protect AutoOpts client code from internal callbacks */
    }[=

  IF (exist? "resettable")

=]
    if ((pOptDesc->fOptState & OPTST_RESET) != 0)
        return;[=

  ENDIF

=][=

  IF (exist? "arg-optional")

=]

    if (pOptDesc->optArg.argString == NULL)
        pOptDesc->optArg.argEnum = [=
             (string-append UP-name "_"    (if (> (len "arg-optional") 0)
                (up-c-name "arg-optional") (if (exist? "arg-default")
                (up-c-name "arg-default")
                "UNDEFINED"  ))) =];
    else
        pOptDesc->optArg.argEnum =
            optionEnumerationVal(pOptions, pOptDesc, azNames, [=(. tmp-ct)=]);
[=

  ELSE

=]

    pOptDesc->optArg.argEnum =
        optionEnumerationVal( pOptions, pOptDesc, azNames, [=(. tmp-ct)=] );
[=

  ENDIF                         =][=

  IF (exist? "extra-code")

=]
[= extra-code                   =][=

  ENDIF                         =][=

ENDDEF   keyword-code

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE   set-membership-code

=][=

(if (not (exist? "keyword"))
    (error "set membership requires keywords"))
(set! tmp-ct (count "keyword"))
(emit (tpl-file-line extract-fmt))
(ag-fprintf 0 "    static char const * const azNames[%d] = {\n" tmp-ct)

(shell (string-append

  "${CLexe} -I8 --spread=2 --sep=',' -f'\"%s\"' <<_EOF_\n"
  (join "\n" (stack "keyword"))
  "\n_EOF_\n" )) =]
    };[=

  IF (exist? "resettable")

=]
    if ((pOptDesc->fOptState & OPTST_RESET) != 0)
        return;[=

  ENDIF

=]
    optionSetMembers(pOptions, pOptDesc, azNames, [= (. tmp-ct) =]);[=

ENDDEF   set-membership-code

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE   file-name-code

\=]
    static teOptFileType const  type =
        [= (set! tmp-val (get "open-file")) =][=
   CASE file-exists                 =][=
   == ""                            =]FTYPE_MODE_MAY_EXIST[=
   =* "no"                          =]FTYPE_MODE_MUST_NOT_EXIST[=
   *                                =]FTYPE_MODE_MUST_EXIST[=
   ESAC =] + [= CASE open-file      =][=

   == ""                            =]FTYPE_MODE_NO_OPEN[=
   =* "desc"                        =]FTYPE_MODE_OPEN_FD[=
   *                                =]FTYPE_MODE_FOPEN_FP[=

   ESAC =];
    static tuFileMode           mode;
[= IF (or (=* tmp-val "desc") (== tmp-val "")) \=]
    mode.file_flags = [= (if (exist? "file-mode") (get "file-mode") "0") =];
[= ELSE \=]
#ifndef FOPEN_BINARY_FLAG
#  define FOPEN_BINARY_FLAG
#endif
    mode.file_mode = [= (c-string (get "file-mode")) =] FOPEN_BINARY_FLAG;
[= ENDIF =]
    optionFileCheck(pOptions, pOptDesc, type, mode);[=

ENDDEF   file-name-code

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # =][=

DEFINE define-option-callbacks      =][=

  FOR  flag  =][=

    (set-flag-names)
    (define endif-test-main "")     =][=

# # # # # # # # # # # # # # # # # # =][=

    IF (or (exist? "extract-code")
           (exist? "flag-code") )   =][=

      (if make-test-main
          (begin
            (set! endif-test-main
                  (sprintf "\n#endif /* defined(%s) */" main-guard))
            (sprintf "\n\n#if ! defined(%s)" main-guard)
      )   ) =][=

      INVOKE callback-proc-header   =][=

      IF (exist? "flag-code")       =][=
         (def-file-line "flag-code" "    /* extracted from %s, line %d */\n")
         =][=  flag-code            =][=

      ELSE                          =][=

         (extract (string-append (base-name) ".c.save") (string-append
                  "/*  %s =-= " cap-name " Opt Code =-= %s */"))
                                    =][=
      ENDIF

# # # # # # # # # # # # # # # # # # =][=

    ELIF (exist? "arg-range")       =][=

      INVOKE callback-proc-header   =][=
      INVOKE range-option-code      =][=

# # # # # # # # # # # # # # # # # # =][=

    ELIF (exist? "aliases")         =][=

      INVOKE callback-proc-header   =][=
      INVOKE alias-option-code      =][=

# # # # # # # # # # # # # # # # # # =][=

    ELSE =][= CASE arg-type         =][=

      =* key                        =][=
      INVOKE callback-proc-header   =][=
      INVOKE keyword-code           =][=

# # # # # # # # # # # # # # # # # # =][=

      =* set                        =][=

      INVOKE callback-proc-header   =][=
      INVOKE set-membership-code    =][=

# # # # # # # # # # # # # # # # # # =][=

      =* fil                        =][=
      INVOKE callback-proc-header   =][=
      INVOKE file-name-code         =][=

      ESAC                          =][=
    ENDIF                           =][=

    (. endif-test-main)             =][=

  ENDFOR flag                       =][=

ENDDEF define-option-callbacks

=]
