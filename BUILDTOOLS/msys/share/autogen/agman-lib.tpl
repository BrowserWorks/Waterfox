[+:   -*- nroff -*-

## agman-lib.tpl -- Template for command line man pages
##
## Time-stamp:      "2010-02-24 08:41:28 bkorb"
## Author:          Jim Van Zandt <jrv@vanzandt.mv.com>
##              by: bkorb
##
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
##
## ---------------------------------------------------------------------
## $Id$
## ---------------------------------------------------------------------
##
## This "library" converts texi-isms into man-isms.  It gets included
## by the man page template at the point where texi-isms might start appearing
## and then "emit-man-text" is invoked when all the text has been assembled.
##

AutoGen5 template null

:+][+:

    ;; * * * * * * * * * * * * * * * * * * * * * * * * *
    ;;
    ;;  Display the command line prototype,
    ;;  based only on the argument processing type.
    ;;
    ;;  And run the entire output through "sed" to convert texi-isms
    ;;
    (out-push-new)

:+]sed \
 -e   's;@code{\([^}]*\)};\\fB\1\\fP;g' \
 -e    's;@var{\([^}]*\)};\\fB\1\\fP;g' \
 -e   's;@samp{\([^}]*\)};\\fB\1\\fP;g' \
 -e      's;@i{\([^}]*\)};\\fI\1\\fP;g' \
 -e   's;@file{\([^}]*\)};\\fI\1\\fP;g' \
 -e   's;@emph{\([^}]*\)};\\fI\1\\fP;g' \
 -e 's;@strong{\([^}]*\)};\\fB\1\\fP;g' \
 -e 's/@\([{}]\)/\1/g' \
 -e 's,^\$\*$,.br,' \
 -e '/@ *example/,/@ *end *example/s/^/    /' \
 -e 's/^ *@ *example/.nf/' \
 -e 's/^ *@ *end *example/.fi/' \
 -e  '/^ *@ *noindent/d' \
 -e  '/^ *@ *enumerate/d' \
 -e 's/^ *@ *end *enumerate/.br/' \
 -e  '/^ *@ *table/d' \
 -e 's/^ *@ *end *table/.br/' \
 -e 's/^@item \(.*\)/.sp\
.IR "\1"/' \
 -e 's/^@item/.sp 1/' \
 -e 's/\*\([a-zA-Z0-9:~=_ -]*\)\*/\\fB\1\\fP/g' \
 -e 's/``\([a-zA-Z0-9:~+=_ -]*\)'"''"'/\\(lq\1\\(rq/g' \
 -e "s/^'/\\'/" \
 -e 's/^@\*/.br/' \
 -e 's/ -/ \\-/g;s/^\.in \\-/.in -/' <<'_End_Of_Man_'
[+:

DEFINE emit-man-text    :+]
_End_Of_Man_[+:

(shell (out-pop #t) )   :+][+:

ENDDEF emit-man-text    :+][+: #

agman-lib.tpl ends here :+]
