[+ AutoGen5 Template  -*- Mode: C -*-

   h=%s-temp.h
   c=%s-temp.c

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
+][+

`stamp=\`sed 's,.*stamp:,,' <<\_EOF_
  Time-stamp:        "2007-05-28 18:05:40 bkorb"
_EOF_
\` `
+][+

DEFINE emit-usage-string    +][+

  (out-push-new)            +][+
  INCLUDE "usage.tpl"       +][+
  (kr-string (string-append (shell (string-append
  "sed -e '/version information/s/ -v \\[arg\\]/ -v      /' \
       -e '/: illegal option --/d' \
       -e 's/ --version\\[=arg\\]/ --version      /' <<_EOF_\n"
  (out-pop #t) "\n_EOF_"
  )) "\n" ))  +][+

ENDDEF

+][+
  (if (not (exist? "settable"))
      (error "'settable' must be specified globally for getopt_long\n"))
  (define prog-name (string->c-name! (get "prog-name")))
  (define PROG-NAME (string-upcase prog-name))
  (out-move (string-append "getopt-" prog-name "." (suffix)))
  (dne " *  " "/* " ) +]
 *
[+ CASE copyright.type +][+
   = gpl  +][+ (gpl  prog-name " *  ") +][+
   = lgpl +][+ (lgpl prog-name (if (exist? "copyright.owner")
                                   (get "copyright.owner")
                                   (get "copyright.author")) " *  ") +][+
   = note +][+ (prefix " *  " (get "copyright.text")) +][+
   ESAC   +]
 *
 *  Last template edit: [+ `echo $stamp` +]
 *  $Id$
 */[+
CASE (suffix) +][+
== h +]
[+   (make-header-guard "autoopts") +]

extern int process_[+(. prog-name)+]_opts (int argc, char** argv);

#endif /* [+ (. header-guard) +] */
[+ == c +]
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <[+ (if (exist? "long-opts") "getopt" "unistd") +].h>
#include "[+ (base-name) +].h"
#include "[+ (. header-file) +]"

#ifndef DIRCH
#  if defined(_WIN32) && !defined(__CYGWIN__)
#    define DIRCH                  '\\'
#  else
#    define DIRCH                  '/'
#  endif
#endif[+

IF (exist? "long-opts") +]

/*
 *  getopt_long option descriptor
 */
static struct option a_long_opts[] = {[+

  FOR flag            +][+
    (sprintf

       "\n  { %-20s %d, NULL, VALUE_OPT_%s },"
          (string-append (c-string (get "name")) ",")
          (if (exist? "arg-type") 1 0)
          (string-upcase (string->c-name! (get "name")))
    ) +][+

  ENDFOR flag

+]
  { "help",              0, NULL, VALUE_OPT_HELP },[+
IF (exist? "version") +]
  { "version",           0, NULL, VALUE_OPT_VERSION },[+
ENDIF +]
  { NULL,                0, NULL, 0 }
};
[+ ENDIF +]
/*
 *  Option flag character list
 */
static char z_opts[] = "[+ # close quote for emacs " +][+
    FOR flag            +][+
      CASE value        +][+
      ~ [!-~]           +][+ value +][+

        CASE arg-type   +][+
        =* str          +]:[+
        == ""           +][+
        *               +][+ (error (sprintf
        "error in %s opt: The only allowed arg type is 'string'\n"
        (get "name") )) +][+
        ESAC            +][+

      ESAC              +][+

    ENDFOR              +][+
    IF  (not (exist? "help-value")) +]?[+
    ELSE                +][+
      CASE help-value   +][+
      == ""             +][+
      == '"'            +]\"[+
      *                 +][+ help-value  +][+
      ESAC              +][+
    ENDIF               +][+
    IF  (exist? "version")  +][+
      IF  (not (exist? "version-value")) +]v[+
      ELSE              +][+
        CASE version-value +][+
        == ""           +][+
        == '"'          +]\"[+
        *               +][+ version-value +][+
        ESAC            +][+
      ENDIF             +][+
    ENDIF               +][+

    (define help-opt
      (if (exist? "long-opts")        "--help"
      (if (not (exist? "flag.value")) "help"
      (if (exist? "help-value")       (string-append "-" (get "help-value"))
                                      "-?" ))) )
    ;; open quote for emacs " +]";

/*
 *  AutoOpts library replacement routines:
 */
void
optionUsage (tOptions* pOptions, int status)
{
  if (status != 0)
    fprintf (stderr, _("Try `%s [+(. help-opt)+]' for more information.\n"),
             [+ (. prog-name) +]Options.pzProgName);
  else
    {
      fputs (_([+
    INVOKE emit-usage-string  usage-type = short +]), stdout);
    }

  exit (status);
}

void
optionPrintVersion(
    tOptions*   pOptions,
    tOptDesc*   pOptDesc )
{
  char const * pz_by =
    _("[+ # " +][+

  (sprintf "%s%s %s" prog-name
     (if (exist? "prog-group")
         (sprintf " (%s)" (get "prog-group"))
         "" )
     (get "version") ) +]\n\
Written by [+(join ", " (stack "copyright.author"))+].\n\n\
copyright (c) [+ copyright.date +] by [+ copyright.owner +]\n[+

CASE copyright.type +][+
*= gpl    +]\
This is free software; see the source for copying conditions.  There is NO\n\
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.[+

ESAC +][+ # " +]\n");

  fputs (pz_by, stdout);
  exit (EXIT_SUCCESS);
}

/*
 *  If an option appears more often than is allowed, ...
 */
static void
usage_too_many (tOptDesc* pOptDesc)
{
  char const * pz =
    _("[+(. prog-name)
    +] error: the '%s' option appears more than %d times\n");
  fprintf (stderr, pz, pOptDesc->pz_Name, pOptDesc->optMaxCt);
  USAGE(EXIT_FAILURE);
}
[+
 IF (exist? "flag.min")
+]
/*
 *  There is at least one option that must appear.
 */
static void
usage_too_few (tOptDesc* pOptDesc)
{
  char const * pz =
    _("[+(. prog-name)
    +] error: the '%s' option must appear %d times\n");
  fprintf (stderr, pz, pOptDesc->pz_Name, pOptDesc->optMinCt);
  USAGE(EXIT_FAILURE);
}
[+
 ENDIF
+][+
 IF (exist? "flag.flags-cant")
+]
/*
 *  There is at least one pair of options that may not appear together
 *  on the command line.
 */
static void
usage_cannot (char const* pz_what, char const* pz_cant)
{
  char const * pz =
    _("[+(. prog-name)
    +] error: the `%s' option conflicts with the `%s' option.\n");
  fprintf (stderr, pz, pz_what, pz_cant);
  USAGE(EXIT_FAILURE);
}
[+
 ENDIF
+][+
 IF (exist? "flag.flags-must")
+]
/*
 *  There is at least one pair of options that are required to appear
 *  together on the command line.
 */
static void
usage_must (char const* pz_what, char const* pz_must)
{
  char const * pz =
    _("[+(. prog-name)
    +] error: the `%s' option requires the `%s' option.\n");
  fprintf (stderr, pz, pz_what, pz_must);
  USAGE(EXIT_FAILURE);
}
[+
 ENDIF
+]
/*
 *  Process the options for the "[+(. prog-name)+]" program.
 *  This function was generated to use the getopt_long(3GNU) function.
 *  There are [+ (+ (count "flag") (if (exist? "version") 2 1))
              +] options for this program,
 * including "help (usage)"[+
    IF (exist? "version") +] and "version"[+ ENDIF +].
 */
int
process_[+(. prog-name)+]_opts (int argc, char** argv)
{
  {
    char const * pz_prog = strrchr (argv[0], DIRCH);
    if (pz_prog != NULL)
      pz_prog++;
    else
      pz_prog = argv[0];
    [+ (. prog-name) +]Options.pzProgName = pz_prog;
  }

  for (;;) {
    switch ([+

IF (exist? "long-opts")
      +]getopt_long (argc, argv, z_opts, a_long_opts, NULL)[+
ELSE  +]getopt (argc, argv, z_opts)[+
ENDIF +]) {
    case  -1: goto leave_processing;
    case   0: break;[+
    FOR flag  +][+
      (define OPT-NAME (string-upcase! (string->c-name! (get "name"))))
+]

    case VALUE_OPT_[+ (. OPT-NAME) +]:[+

      IF (not (exist? "max")) +]
      if (HAVE_OPT( [+(. OPT-NAME)+] ))
        usage_too_many (&DESC([+(. OPT-NAME) +]));[+

      ELIF (not (= (get "max") "nolimit"))  +]
      if (DESC([+(. OPT-NAME)+]).optOccCt++ >= DESC([+(. OPT-NAME)+]).optMaxCt)
        usage_too_many (&DESC([+(. OPT-NAME) +]));[+
      ENDIF
+]
      SET_OPT_[+(. OPT-NAME)+][+ (if (exist? "arg-type") "(optarg)") +];
      break;[+

    ENDFOR +]

    case VALUE_OPT_HELP:
      USAGE(EXIT_SUCCESS);
      /* NOTREACHED */
[+ IF (exist? "version") +]
    case VALUE_OPT_VERSION:
      optionPrintVersion (&[+ (. prog-name) +]Options, &DESC(VERSION));
      /* NOTREACHED */
[+ ENDIF +]
    default:
      USAGE(EXIT_FAILURE);
    }
  } leave_processing:;
[+
FOR flag +][+
  IF
     (set! OPT-NAME (string-upcase! (string->c-name! (get "name"))))
     (define check-have-opt (or (exist? "flags-cant") (exist? "flags-must")))
     check-have-opt
+]
  if (HAVE_OPT( [+ (. OPT-NAME) +] )) {[+

    FOR flags-cant +]
    if (HAVE_OPT( [+ (string-upcase! (string->c-name! (get "flags-cant"))) +] ))
      usage_cannot (DESC([+ (. OPT-NAME) +]).pz_Name, DESC([+
        (string-upcase! (string->c-name! (get "flags-cant"))) +]).pz_Name);[+
    ENDFOR cant    +][+

    FOR flags-must +]
    if (! HAVE_OPT( [+(string-upcase! (string->c-name! (get "flags-must")))+] ))
      usage_must (DESC([+ (. OPT-NAME) +]).pz_Name, DESC([+
        (string-upcase! (string->c-name! (get "flags-must"))) +]).pz_Name);[+
    ENDFOR must    +][+
    IF (exist? "min") +][+
      IF (> (string->number (get "min" "0")) 1) +]
    if (DESC([+(. OPT-NAME)+]).optOccCt < DESC([+(. OPT-NAME)+]).optMinCt)
      usage_too_few (&DESC([+(. OPT-NAME) +]));[+

      ENDIF +][+
    ENDIF +]
  }
[+

  ENDIF

+][+

  IF (exist? "min")  +][+
    IF (. check-have-opt)
+]  else[+

    ELSE
+]
  if ([+ #
       We have a minimum count, but we have not checked for option existence
       yet because there are no option interdependencies.  We must therefore
       now check to see if the option has appeared the required number of
       times.  In the absence of a max count, our limit must be one and we
       only check for presence.  If a max count exists, then we will also
       have kept the occurrence count.  Check that against the limit. +][+

      IF (not (exist? "max"))
        +]! HAVE_OPT( [+ (. OPT-NAME) +] )[+
      ELSE  max ct exists
        +]DESC([+(. OPT-NAME)+]).optOccCt < DESC([+(. OPT-NAME)+]).optMinCt[+
      ENDIF +])[+

    ENDIF +]
    usage_too_few (&DESC([+(. OPT-NAME) +]));
[+
  ENDIF  +][+
ENDFOR   +]
  return 0;
}
[+ ESAC \+]
