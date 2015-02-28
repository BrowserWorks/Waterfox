dnl  -*- Mode: M4 -*- 
dnl --------------------------------------------------------------------
dnl autoopts.m4 --- Configure paths for autoopts
dnl 
dnl Author:	           Gary V. Vaughan <gvaughan@localhost>
dnl Maintainer:	       Gary V. Vaughan <gvaughan@localhost>
dnl Created:	       Sun Nov 15 23:37:14 1998
dnl Last Modified:     Mon May 17 01:02:44 1999				
dnl            by: bkorb
dnl --------------------------------------------------------------------
dnl @(#) $Id: autoopts.m4,v 2.6 2002/09/11 03:36:11 bkorb Exp $
dnl --------------------------------------------------------------------
dnl 
dnl Code:

# serial 1

dnl AG_PATH_AUTOOPTS([MIN-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
dnl Test for AUTOOPTS, and define AUTOGEN, AUTOOPTS_CFLAGS, AUTOGEN_LDFLAGS
dnl      and AUTOOPTS_LIBS.
dnl
AC_DEFUN(AG_PATH_AUTOOPTS,
[dnl Get the cflags and libraries from the autoopts-config script
AC_ARG_WITH(opts-prefix,
[  --with-opts-prefix=PFX  Prefix where autoopts is installed (optional)])

AC_ARG_WITH(opts-exec-prefix,
[  --with-opts-exec-prefix=PFX
                          Exec prefix where autoopts is installed (optional)])

AC_ARG_ENABLE(opts-test,
[  --disable-opts-test     Do not try to compile and run a test autoopts program])

  if test x$with_opts_exec_prefix != x ; then
    autoopts_config_args="$autoopts_config_args --exec-prefix=$with_opts_exec_prefix"
    if test x${AUTOOPTS_CONFIG+set} != xset ; then
      AUTOOPTS_CONFIG=$with_opts_exec_prefix/bin/autoopts-config
    fi
  fi
  if test x$with_opts_prefix != x ; then
     autoopts_config_args="$autoopts_config_args --prefix=$with_opts_prefix"
    if test x${AUTOOPTS_CONFIG+set} != xset ; then
      AUTOOPTS_CONFIG=$with_opts_prefix/bin/autoopts-config
    fi
  fi
  if test -n "$AUTOOPTS_CONFIG"; then
    :
  else
    AC_PATH_PROG(AUTOOPTS_CONFIG, autoopts-config, no)
  fi
  min_opts_version=ifelse([$1], ,4:2:0,$1)
  AC_MSG_CHECKING(for autoopts version >= $min_opts_version)
  no_autoopts=""
  if test "$AUTOOPTS_CONFIG" = "no" ; then
    no_autoopts=yes
  else
    AUTOGEN=`$AUTOOPTS_CONFIG $autoopts_config_args --autogen`
    AUTOOPTS_CFLAGS=`$AUTOOPTS_CONFIG $autoopts_config_args --cflags`
    AUTOGEN_LDFLAGS=`$AUTOOPTS_CONFIG $autoopts_config_args --pkgdatadir`
    AUTOOPTS_LIBS=`$AUTOOPTS_CONFIG $autoopts_config_args --libs`
changequote(,)dnl
    autoopts_config_version=`$AUTOOPTS_CONFIG $autoopts_config_args --version`
    autoopts_config_current=`echo $autoopts_config_version | \
      sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\1/'`
    autoopts_config_revision=`echo $autoopts_config_version | \
      sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\2/'`
    autoopts_config_age=`echo $autoopts_config_version | \
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
#include <options.h>
#include <stdio.h>
#include <stdlib.h>

int 
main ()
{
    int current, revision, age;
    int autoopts_current, autoopts_revision, autoopts_age;
    char tmp_version[16];

    system ("touch conf.optstest");

    /* HP/UX 9 (%@#!) writes to sscanf strings */
    strcpy(tmp_version, "$min_opts_version");
    if (sscanf(tmp_version, "%d:%d:%d", &current, &revision, &age) != 3)
    {
        printf("%s, bad version string\n", "$min_opts_version");
        exit(1);
    }

    strcpy(tmp_version, optionVersion());
    if (sscanf(tmp_version, "%d:%d:%d", &autoopts_current,
	       &autoopts_revision, &autoopts_age) != 3)
    {
        printf("%s, bad version string\n", optionVersion);
        exit(1);
    }

    if ((current != $autoopts_config_current) ||
        (revision != $autoopts_config_revision) ||
        (age != $autoopts_config_age))
    {
        printf("\n*** 'autoopts-config --version' returned %d:%d:%d,"
               " but autoopts returned (%d:%d:%d)\n",
	       $autoopts_config_current,
               $autoopts_config_revision, $autoopts_config_age,
               current, revision, age);
        printf("*** If autoopts-config was correct, then it is best to"
	       "remove the\n");
        printf("*** old version of autoopts. You may also "
               "be able to fix the error\n");
        printf("*** by modifying your LD_LIBRARY_PATH enviroment variable, "
               "or by editing\n");
        printf("*** /etc/ld.so.conf. Make sure you have run ldconfig if that "
               "is\n");
        printf("*** required on your system.\n");
        printf("*** If autoopts-config was wrong, set the environment "
               "variable AUTOOPTS_CONFIG\n");
        printf("*** to point to the correct copy of autoopts-config, and "
               "remove the file\n");
        printf("*** config.cache before re-running configure\n");
    } 
#if defined (AO_CURRENT) && defined (AO_REVISION) && defined (AO_AGE)
    else if (($autoopts_config_current != AO_CURRENT) ||
             ($autoopts_config_revision != AO_REVISION) ||
	     ($autoopts_config_age != AO_AGE))
    {
        printf("*** autoopts header files (version %d:%d:%d) do not match\n",
	       AO_CURRENT, AO_REVISION, AO__AGE);
        printf("*** library (version %d:%d:%d)\n", autoopts_current,
               autoopts_revision, autoopts_age);
    }
#endif
    else
    {
        if ((autoopts_current - autoopts_age > current - age) ||
            ((autoopts_current - autoopts_age == current - age) &&
             (autoopts_age > age)) ||
            ((autoopts_current - autoopts_age == current - age) &&
             (autoopts_age == age) &&
             (autoopts_revision >= revision)))
        {
            return 0;
        }
        else
        {
            printf("\n*** An old version of autoopts (%d:%d:%d) was found.\n",
                   autoopts_current, autoopts_revision, autoopts_age);
            printf("*** You need a version of autoopts newer than %d:%d:%d.  "
                   "The latest version of\n", current, revision, age);
	    printf("*** autoopts is always available from "
		   "ftp://autogen.linuxave.org.\n");
            printf("***\n");
            printf("*** If you have already installed a sufficiently new "
                   "version, this error\n");
            printf("*** probably means that the wrong copy of the "
                   "autoopts-config shell script is\n");
            printf("*** being found. The easiest way to fix this is to "
                   "remove the old version\n");
            printf("*** of autoopts, but you can also set the "
                   "AUTOOPTS_CONFIG environment to point to the\n");
            printf("*** correct copy of autoopts-config. (In this case, "
                   "you will have to\n");
            printf("*** modify your LD_LIBRARY_PATH enviroment variable, or "
                   "edit /etc/ld.so.conf\n");
            printf("*** so that the correct libraries are found at "
                   "run-time).\n");
        }
    }
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
#include <options.h>
#include <stdio.h>
],      [ return strcmp("$autoopts_config_current:$autoopts_config_revision:$autoopts_config_age", optionVersion()); ],
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
