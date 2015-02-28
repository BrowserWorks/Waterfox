## ------------------------                           -*- Autoconf -*-
## Emacs LISP file handling
## From Ulrich Drepper
## Almost entirely rewritten by Alexandre Oliva
## ------------------------

# Copyright 1996, 1997, 1998, 1999, 2000, 2001, 2002
#   Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# serial 6

# AM_PATH_LISPDIR
# ---------------
AC_DEFUN([AM_PATH_LISPDIR],
[AC_ARG_WITH(lispdir,
 [  --with-lispdir          Override the default lisp directory ],
 [ lispdir="$withval"
   AC_MSG_CHECKING([where .elc files should go])
   AC_MSG_RESULT([$lispdir])],
 [
 # If set to t, that means we are running in a shell under Emacs.
 # If you have an Emacs named "t", then use the full path.
 test x"$EMACS" = xt && EMACS=
 AC_CHECK_PROGS(EMACS, emacs xemacs, no)
 if test $EMACS != "no"; then
   if test x${lispdir+set} != xset; then
     AC_CACHE_CHECK([where .elc files should go], [am_cv_lispdir],
       [# If $EMACS isn't GNU Emacs or XEmacs, this can blow up pretty badly
  # Some emacsen will start up in interactive mode, requiring C-x C-c to exit,
  #  which is non-obvious for non-emacs users.
  # Redirecting /dev/null should help a bit; pity we can't detect "broken"
  #  emacsen earlier and avoid running this altogether.
  AC_RUN_LOG([$EMACS -batch -q -eval '(while load-path (princ (concat (car load-path) "\n")) (setq load-path (cdr load-path)))' </dev/null >conftest.out])
        am_cv_lispdir=`sed -n \
       -e 's,/$,,' \
       -e '/.*\/lib\/\(x\?emacs\/site-lisp\)$/{s,,${libdir}/\1,;p;q;}' \
       -e '/.*\/share\/\(x\?emacs\/site-lisp\)$/{s,,${datadir}/\1,;p;q;}' \
       conftest.out`
       rm conftest.out
       if test -z "$am_cv_lispdir"; then
         am_cv_lispdir='${datadir}/emacs/site-lisp'
       fi
     ])
     lispdir="$am_cv_lispdir"
   fi
 fi
])
AC_SUBST(lispdir)
])# AM_PATH_LISPDIR

AU_DEFUN([ud_PATH_LISPDIR], [AM_PATH_LISPDIR])
