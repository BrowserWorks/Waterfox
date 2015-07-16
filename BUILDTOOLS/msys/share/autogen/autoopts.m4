dnl  -*- Mode: M4 -*-
dnl --------------------------------------------------------------------
dnl autoopts.m4 --- Configure paths for autoopts
dnl
dnl Author:            Gary V. Vaughan <gvaughan@localhost>
dnl Time-stamp:        "2010-02-24 08:41:23 bkorb"
dnl            by: bkorb
dnl
dnl  This file is part of AutoOpts, a companion to AutoGen.
dnl  AutoOpts is free software.
dnl  AutoOpts is Copyright (c) 1992-2010 by Bruce Korb - all rights reserved
dnl
dnl  AutoOpts is available under any one of two licenses.  The license
dnl  in use must be one of these two and the choice is under the control
dnl  of the user of the license.
dnl
dnl   The GNU Lesser General Public License, version 3 or later
dnl      See the files "COPYING.lgplv3" and "COPYING.gplv3"
dnl
dnl   The Modified Berkeley Software Distribution License
dnl      See the file "COPYING.mbsd"
dnl
dnl  These files have the following md5sums:
dnl
dnl  43b91e8ca915626ed3818ffb1b71248b pkg/libopts/COPYING.gplv3
dnl  06a1a2e4760c90ea5e1dad8dfaac4d39 pkg/libopts/COPYING.lgplv3
dnl  66a5cedaf62c4b2637025f049f9b826f pkg/libopts/COPYING.mbsd
dnl --------------------------------------------------------------------
dnl @(#) $Id$
dnl --------------------------------------------------------------------
dnl
dnl Code:

# serial 1

dnl AG_PATH_AUTOOPTS([MIN-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
dnl Test for AUTOOPTS, and define AUTOGEN, AUTOOPTS_CFLAGS, AUTOGEN_LDFLAGS
dnl      and AUTOOPTS_LIBS.
dnl
AC_DEFUN([AG_PATH_AUTOOPTS],
[dnl Get the cflags and libraries from the autoopts-config script
AC_ARG_WITH(opts-prefix,
[  --with-opts-prefix=PFX  Prefix where autoopts is installed (optional)])

AC_ARG_WITH(opts-exec-prefix,
[  --with-opts-exec-prefix=PFX
                          Exec prefix where autoopts is installed (optional)])

AC_ARG_ENABLE(opts-test,
[  --disable-opts-test     Do not try to run a test AutoOpts program])

  if test x$with_opts_exec_prefix != x ; then
    aocfg_args="$aocfg_args --exec-prefix=$with_opts_exec_prefix"
    if test x${AUTOOPTS_CONFIG+set} != xset ; then
      AUTOOPTS_CONFIG=$with_opts_exec_prefix/bin/autoopts-config
    fi
  fi
  if test x$with_opts_prefix != x ; then
     aocfg_args="$aocfg_args --prefix=$with_opts_prefix"
    if test x${AUTOOPTS_CONFIG+set} != xset ; then
      AUTOOPTS_CONFIG=$with_opts_prefix/bin/autoopts-config
    fi
  fi
  if test -n "$AUTOOPTS_CONFIG"; then
    :
  else
    AC_PATH_PROG(AUTOOPTS_CONFIG, autoopts-config, no)
  fi
  min_opts_version="9:0:0"
  AC_MSG_CHECKING(for autoopts version >= $min_opts_version)
  no_autoopts=""
  if test "$AUTOOPTS_CONFIG" = "no" ; then
    no_autoopts=yes
  else
    min_cur=9
    min_rev=0
    min_age=0
    AUTOGEN=`$AUTOOPTS_CONFIG $aocfg_args --autogen`
    AUTOOPTS_CFLAGS=`$AUTOOPTS_CONFIG $aocfg_args --cflags`
    AUTOGEN_LDFLAGS=`$AUTOOPTS_CONFIG $aocfg_args --pkgdatadir`
    AUTOOPTS_LIBS=`$AUTOOPTS_CONFIG $aocfg_args --libs`
changequote(,)dnl
    aocfg_version=`$AUTOOPTS_CONFIG $aocfg_args --version`
    aocfg_current=`echo $aocfg_version | \
      sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\1/'`
    aocfg_revision=`echo $aocfg_version | \
      sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\2/'`
    aocfg_age=`echo $aocfg_version | \
      sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\3/'`
changequote([,])dnl
    if test "x$enable_opts_test" != "xno" ; then
      AC_LANG_SAVE
      AC_LANG_C
      ac_save_CFLAGS="$CFLAGS"
      ac_save_LDFLAGS="$LDFLAGS"
      ac_save_LIBS="$LIBS"
      CFLAGS="$CFLAGS $AUTOOPTS_CFLAGS"
      LDFLAGS="$LDFLAGS $AUTOOPTS $CFLAGS"
      LIBS="$LIBS $AUTOOPTS_LIBS"
      dnl
      dnl Now check if the installed AUTOOPTS is sufficiently new. (Also
      dnl sanity checks the results of autoopts-config to some extent.
      dnl
      rm -f confopts.def conf.optstest
      AC_TRY_RUN([
#include <autoopts/options.h>
#include <stdio.h>
#include <stdlib.h>

static char const zBadVer[] = "\n\\
*** 'autoopts-config --version' returned $aocfg_current:$aocfg_revision:$aocfg_age,\n\\
***                but autoopts returned (%d:%d:0)\n\\
*** If autoopts-config was correct, then it is best to remove the old version\n\\
*** of autoopts. You may also be able to fix the error by modifying your\n\\
*** LD_LIBRARY_PATH enviroment variable, or by editing /etc/ld.so.conf.\n\\
*** Make sure you have run ldconfig if that is required on your system.\n\\
*** Otherwise, set the environment variable AUTOOPTS_CONFIG to point to\n\\
*** the correct copy of autoopts-config, and remove the file config.cache\n\\
*** before re-running configure.\n";

static char const zOldVer[] = "\n\\
*** An old version of autoopts (%d:%d:%d) was found.\n\\
*** You need a version of autoopts newer than $min_cur:$min_rev:$min_age.  \
The latest version of\n\\
*** autoopts is always available from http://autogen.sourceforge.net.\n\\
*** If you have already installed a sufficiently new version, this error\n\\
*** probably means that the wrong copy of the autoopts-config shell script is\n\\
*** being found. The easiest way to fix this is to remove the old version\n\\
*** of autoopts, but you can also set the AUTOOPTS_CONFIG environment to point\n\\
*** to the correct copy of autoopts-config. (In this case, you will have to\n\\
*** modify your LD_LIBRARY_PATH enviroment variable, or edit /etc/ld.so.conf\n\\
*** so that the correct libraries are found at run-time).\n";


int
main ()
{
    int current, revision;
    char tmp_version[16];

    system ("touch conf.optstest");

    strcpy(tmp_version, optionVersion());
    if (sscanf(tmp_version, "%d.%d", &current, &revision) != 2) {
        printf("bad version string: -->>%s<<-- is not -->>%d.%d<<--\n",
               optionVersion(), current, revision);
        exit(1);
    }

    if (  (current  != $aocfg_current)
       || (revision != $aocfg_revision)) {
        printf( zBadVer, current, revision);
        return 1;
    }
#if defined (AO_CURRENT) && defined (AO_REVISION) && defined (AO_AGE)
    if (  ($aocfg_current  != AO_CURRENT)
       || ($aocfg_revision != AO_REVISION)
       || ($aocfg_age      != AO_AGE))  {
        printf("*** autoopts header files (version %d:%d:%d) do not match\n",
               AO_CURRENT, AO_REVISION, AO_AGE);
        printf("*** library (version %d:%d:0)\n", current, revision);
        return 1;
    }
#endif

    if (  ($aocfg_current - $aocfg_age > $min_cur)
       || (  ($aocfg_current - $aocfg_age == $min_cur)
          && ($aocfg_revision >= $min_rev) ))
        return 0;

    printf(zOldVer, $aocfg_current, $aocfg_revision,
           $aocfg_age);
    return 1;
}
],, no_autoopts=yes,[echo $ac_n "cross compiling; assumed OK... $ac_c"])
      CFLAGS="$ac_save_CFLAGS"
      LDFLAGS="$ac_save_LDFLAGS"
      LIBS="$ac_save_LIBS"
      AC_LANG_RESTORE
    fi
  fi

  if test "x$no_autoopts" = x ; then
    AC_MSG_RESULT(yes)
    ifelse([$2], , :, [$2])
  else
    AC_MSG_RESULT(no)
    if test "$AUTOOPTS_CONFIG" = "no" ; then
      cat << _EOF_
*** The autoopts-config script installed by AutoGen could not be found
*** If AutoGen was installed in PREFIX, make sure PREFIX/bin is in
*** your path, or set the AUTOOPTS_CONFIG environment variable to the
*** full path to autoopts-config.
_EOF_
     else
       if test -f conf.optstest ; then
         :
       else
         echo "*** Could not run autoopts test program, checking why..."
         CFLAGS="$CFLAGS $AUTOOPTS_CFLAGS"
         LIBS="$LIBS $AUTOOPTS_LIBS"
         AC_LANG_SAVE
         AC_LANG_C
         AC_TRY_LINK([
#include <autoopts/options.h>
#include <stdio.h>
], [return strcmp("$aocfg_current:$aocfg_revision:$aocfg_age", optionVersion());],
        [ cat << _EOF_
*** The test program compiled, but did not run. This usually means that
*** the run-time linker is not finding libopts or finding the wrong version
*** of libopts. If it is not finding libopts, you'll need to set your
*** LD_LIBRARY_PATH environment variable, or edit /etc/ld.so.conf to point
*** to the installed location  Also, make sure you have run ldconfig if that
*** is required on your system
***
*** If you have an old version installed, it is best to remove it, although
*** you may also be able to get things to work by modifying LD_LIBRARY_PATH
_EOF_
], [cat << _EOF_
*** The test program failed to compile or link. See the file config.log for
*** the exact error that occured. This usually means AutoGen was incorrectly
*** installed or that you have moved libopts since it was installed. In the
*** latter case, you may want to edit the autoopts-config script:
*** $AUTOOPTS_CONFIG
_EOF_
])
          CFLAGS="$ac_save_CFLAGS"
          LIBS="$ac_save_LIBS"
          AC_LANG_RESTORE
       fi
     fi
     AUTOGEN=:
     AUTOOPTS_CFLAGS=""
     AUTOOPTS_LIBS=""
     ifelse([$3], , :, [$3])
  fi
  AC_SUBST(AUTOGEN)
  AC_SUBST(AUTOOPTS_CFLAGS)
  AC_SUBST(AUTOGEN_LDFLAGS)
  AC_SUBST(AUTOOPTS_LIBS)
  rm -f confopts.def conf.optstest
])
dnl
dnl autoopts.m4 ends here
