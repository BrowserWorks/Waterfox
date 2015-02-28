# This file is part of Autoconf.                       -*- Autoconf -*-
# Programming languages support.
# Copyright (C) 2000, 2001, 2002, 2004, 2005, 2006 Free Software
# Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
# As a special exception, the Free Software Foundation gives unlimited
# permission to copy, distribute and modify the configure scripts that
# are the output of Autoconf.  You need not follow the terms of the GNU
# General Public License when using or distributing such scripts, even
# though portions of the text of Autoconf appear in them.  The GNU
# General Public License (GPL) does govern all other use of the material
# that constitutes the Autoconf program.
#
# Certain portions of the Autoconf source text are designed to be copied
# (in certain cases, depending on the input) into the output of
# Autoconf.  We call these the "data" portions.  The rest of the Autoconf
# source text consists of comments plus executable code that decides which
# of the data portions to output in any given case.  We call these
# comments and executable code the "non-data" portions.  Autoconf never
# copies any of the non-data portions into its output.
#
# This special exception to the GPL applies to versions of Autoconf
# released by the Free Software Foundation.  When you make and
# distribute a modified version of Autoconf, you may extend this special
# exception to the GPL to apply to your modified version as well, *unless*
# your modified version has the potential to copy into its output some
# of the text that was the non-data portion of the version that you started
# with.  (In other words, unless your change moves or copies text from
# the non-data portions to the data portions.)  If your modification has
# such potential, you must delete any notice of this special exception
# to the GPL from your modified version.
#
# Written by David MacKenzie, with help from
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.


# Table of Contents:
#
# 1. Language selection
#    and routines to produce programs in a given language.
#  a. generic routines
#  b. C
#  c. C++
#  d. Fortran 77
#
# 2. Producing programs in a given language.
#  a. generic routines
#  b. C
#  c. C++
#  d. Fortran 77
#
# 3. Looking for a compiler
#    And possibly the associated preprocessor.
#  a. Generic routines.
#  b. C
#  c. C++
#  d. Fortran 77
#
# 4. Compilers' characteristics.
#  a. Generic routines.
#  b. C
#  c. C++
#  d. Fortran 77



## ----------------------- ##
## 1. Language selection.  ##
## ----------------------- ##



# -------------------------------- #
# 1a. Generic language selection.  #
# -------------------------------- #

# AC_LANG_CASE(LANG1, IF-LANG1, LANG2, IF-LANG2, ..., DEFAULT)
# ------------------------------------------------------------
# Expand into IF-LANG1 if the current language is LANG1 etc. else
# into default.
m4_define([AC_LANG_CASE],
[m4_case(_AC_LANG, $@)])


# _AC_LANG_DISPATCH(MACRO, LANG, ARGS)
# ------------------------------------
# Call the specialization of MACRO for LANG with ARGS.  Complain if
# unavailable.
m4_define([_AC_LANG_DISPATCH],
[m4_ifdef([$1($2)],
       [m4_indir([$1($2)], m4_shiftn(2, $@))],
       [AC_FATAL([$1: unknown language: $2])])])


# _AC_LANG_SET(OLD, NEW)
# ----------------------
# Output the shell code needed to switch from OLD language to NEW language.
# Do not try to optimize like this:
#
# m4_defun([_AC_LANG_SET],
# [m4_if([$1], [$2], [],
#        [_AC_LANG_DISPATCH([AC_LANG], [$2])])])
#
# as it can introduce differences between the sh-current language and the
# m4-current-language when m4_require is used.  Something more subtle
# might be possible, but at least for the time being, play it safe.
m4_defun([_AC_LANG_SET],
[_AC_LANG_DISPATCH([AC_LANG], [$2])])


# AC_LANG(LANG)
# -------------
# Set the current language to LANG.
m4_defun([AC_LANG],
[_AC_LANG_SET(m4_ifdef([_AC_LANG], [m4_defn([_AC_LANG])]),
	      [$1])dnl
m4_define([_AC_LANG], [$1])])


# AC_LANG_PUSH(LANG)
# ------------------
# Save the current language, and use LANG.
m4_defun([AC_LANG_PUSH],
[_AC_LANG_SET(m4_ifdef([_AC_LANG], [m4_defn([_AC_LANG])]),
	      [$1])dnl
m4_pushdef([_AC_LANG], [$1])])


# AC_LANG_POP([LANG])
# -------------------
# If given, check that the current language is LANG, and restore the
# previous language.
m4_defun([AC_LANG_POP],
[m4_ifval([$1],
 [m4_if([$1], m4_defn([_AC_LANG]), [],
  [m4_fatal([$0($1): unexpected current language: ]m4_defn([_AC_LANG]))])])dnl
m4_pushdef([$0 OLD], m4_defn([_AC_LANG]))dnl
m4_popdef([_AC_LANG])dnl
_AC_LANG_SET(m4_defn([$0 OLD]), m4_defn([_AC_LANG]))dnl
m4_popdef([$0 OLD])dnl
])


# AC_LANG_SAVE
# ------------
# Save the current language, but don't change language.
AU_DEFUN([AC_LANG_SAVE],
[[AC_LANG_SAVE]],
[Instead of using `AC_LANG', `AC_LANG_SAVE', and `AC_LANG_RESTORE',
you should use `AC_LANG_PUSH' and `AC_LANG_POP'.])
AC_DEFUN([AC_LANG_SAVE],
[m4_pushdef([_AC_LANG], _AC_LANG)dnl
AC_DIAGNOSE([obsolete], [The macro `AC_LANG_SAVE' is obsolete.
You should run autoupdate.])])


# AC_LANG_RESTORE
# ---------------
# Restore the current language from the stack.
AU_DEFUN([AC_LANG_RESTORE], [AC_LANG_POP($@)])


# _AC_LANG_ABBREV
# ---------------
# Return a short signature of _AC_LANG which can be used in shell
# variable names, or in M4 macro names.
m4_defun([_AC_LANG_ABBREV],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# _AC_LANG_PREFIX
# ---------------
# Return a short (upper case) signature of _AC_LANG that is used to
# prefix environment variables like FLAGS.
m4_defun([_AC_LANG_PREFIX],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_ASSERT(LANG)
# --------------------
# Current language must be LANG.
m4_defun([AC_LANG_ASSERT],
[m4_if(_AC_LANG, $1, [],
       [m4_fatal([$0: current language is not $1: ] _AC_LANG)])])



## ---------------------- ##
## 2.Producing programs.  ##
## ---------------------- ##


# ---------------------- #
# 2a. Generic routines.  #
# ---------------------- #


# AC_LANG_CONFTEST(BODY)
# ----------------------
# Save the BODY in `conftest.$ac_ext'.  Add a trailing new line.
AC_DEFUN([AC_LANG_CONFTEST],
[cat >conftest.$ac_ext <<_ACEOF
$1
_ACEOF])


# AC_LANG_SOURCE(BODY)
# --------------------
# Produce a valid source for the current language, which includes the
# BODY, and as much as possible `confdefs.h'.
AC_DEFUN([AC_LANG_SOURCE],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_PROGRAM([PROLOGUE], [BODY])
# -----------------------------------
# Produce a valid source for the current language.  Prepend the
# PROLOGUE (typically CPP directives and/or declarations) to an
# execution the BODY (typically glued inside the `main' function, or
# equivalent).
AC_DEFUN([AC_LANG_PROGRAM],
[AC_LANG_SOURCE([_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])])


# AC_LANG_CALL(PROLOGUE, FUNCTION)
# --------------------------------
# Call the FUNCTION.
AC_DEFUN([AC_LANG_CALL],
[m4_ifval([$2], [], [m4_warn([syntax], [$0: no function given])])dnl
_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_FUNC_LINK_TRY(FUNCTION)
# -------------------------------
# Produce a source which links correctly iff the FUNCTION exists.
AC_DEFUN([AC_LANG_FUNC_LINK_TRY],
[m4_ifval([$1], [], [m4_warn([syntax], [$0: no function given])])dnl
_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_BOOL_COMPILE_TRY(PROLOGUE, EXPRESSION)
# ----------------------------------------------
# Produce a program that compiles with success iff the boolean EXPRESSION
# evaluates to true at compile time.
AC_DEFUN([AC_LANG_BOOL_COMPILE_TRY],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_INT_SAVE(PROLOGUE, EXPRESSION)
# --------------------------------------
# Produce a program that saves the runtime evaluation of the integer
# EXPRESSION into `conftest.val'.
AC_DEFUN([AC_LANG_INT_SAVE],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


## -------------------------------------------- ##
## 3. Looking for Compilers and Preprocessors.  ##
## -------------------------------------------- ##

# ----------------------------------------------------- #
# 3a. Generic routines in compilers and preprocessors.  #
# ----------------------------------------------------- #

# AC_LANG_COMPILER
# ----------------
# Find a compiler for the current LANG.  Be sure to be run before
# AC_LANG_PREPROC.
#
# Note that because we might AC_REQUIRE `AC_LANG_COMPILER(C)' for
# instance, the latter must be AC_DEFUN'd, not just define'd.
m4_define([AC_LANG_COMPILER],
[AC_BEFORE([AC_LANG_COMPILER(]_AC_LANG[)],
	   [AC_LANG_PREPROC(]_AC_LANG[)])dnl
_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_COMPILER_REQUIRE
# ------------------------
# Ensure we have a compiler for the current LANG.
AC_DEFUN([AC_LANG_COMPILER_REQUIRE],
[m4_require([AC_LANG_COMPILER(]_AC_LANG[)],
	    [AC_LANG_COMPILER])])



# _AC_LANG_COMPILER_GNU
# ---------------------
# Check whether the compiler for the current language is GNU.
#
# It doesn't seem necessary right now to have a different source
# according to the current language, since this works fine.  Some day
# it might be needed.  Nevertheless, pay attention to the fact that
# the position of `choke me' on the seventh column is meant: otherwise
# some Fortran compilers (e.g., SGI) might consider it's a
# continuation line, and warn instead of reporting an error.
m4_define([_AC_LANG_COMPILER_GNU],
[AC_CACHE_CHECK([whether we are using the GNU _AC_LANG compiler],
		[ac_cv_[]_AC_LANG_ABBREV[]_compiler_gnu],
[_AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[#ifndef __GNUC__
       choke me
#endif
]])],
		   [ac_compiler_gnu=yes],
		   [ac_compiler_gnu=no])
ac_cv_[]_AC_LANG_ABBREV[]_compiler_gnu=$ac_compiler_gnu
])])# _AC_LANG_COMPILER_GNU


# AC_LANG_PREPROC
# ---------------
# Find a preprocessor for the current language.  Note that because we
# might AC_REQUIRE `AC_LANG_PREPROC(C)' for instance, the latter must
# be AC_DEFUN'd, not just define'd.  Since the preprocessor depends
# upon the compiler, look for the compiler.
m4_define([AC_LANG_PREPROC],
[AC_LANG_COMPILER_REQUIRE()dnl
_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# AC_LANG_PREPROC_REQUIRE
# -----------------------
# Ensure we have a preprocessor for the current language.
AC_DEFUN([AC_LANG_PREPROC_REQUIRE],
[m4_require([AC_LANG_PREPROC(]_AC_LANG[)],
	    [AC_LANG_PREPROC])])


# AC_REQUIRE_CPP
# --------------
# Require the preprocessor for the current language.
# FIXME: AU_ALIAS once AC_LANG is officially documented (2.51?).
AC_DEFUN([AC_REQUIRE_CPP],
[AC_LANG_PREPROC_REQUIRE])



# AC_NO_EXECUTABLES
# -----------------
# FIXME: The GCC team has specific needs which the current Autoconf
# framework cannot solve elegantly.  This macro implements a dirty
# hack until Autoconf is able to provide the services its users
# need.
#
# Several of the support libraries that are often built with GCC can't
# assume the tool-chain is already capable of linking a program: the
# compiler often expects to be able to link with some of such
# libraries.
#
# In several of these libraries, workarounds have been introduced to
# avoid the AC_PROG_CC_WORKS test, that would just abort their
# configuration.  The introduction of AC_EXEEXT, enabled either by
# libtool or by CVS autoconf, have just made matters worse.
#
# Unlike an earlier version of this macro, using AC_NO_EXECUTABLES does
# not disable link tests at autoconf time, but at configure time.
# This allows AC_NO_EXECUTABLES to be invoked conditionally.
AC_DEFUN_ONCE([AC_NO_EXECUTABLES],
[m4_divert_push([KILL])
m4_divert_text([DEFAULTS], [ac_no_link=no])

AC_BEFORE([$0], [_AC_COMPILER_EXEEXT])
AC_BEFORE([$0], [AC_LINK_IFELSE])

m4_define([_AC_COMPILER_EXEEXT],
[AC_LANG_CONFTEST([AC_LANG_PROGRAM()])
if _AC_DO_VAR(ac_link); then
  ac_no_link=no
  ]m4_defn([_AC_COMPILER_EXEEXT])[
else
  ac_no_link=yes
  # Setting cross_compile will disable run tests; it will
  # also disable AC_CHECK_FILE but that's generally
  # correct if we can't link.
  cross_compiling=yes
  EXEEXT=
  _AC_COMPILER_EXEEXT_CROSS
fi
])

m4_define([AC_LINK_IFELSE],
[if test x$ac_no_link = xyes; then
  AC_MSG_ERROR([Link tests are not allowed after AC@&t@_NO_EXECUTABLES.])
fi
]m4_defn([AC_LINK_IFELSE]))

m4_divert_pop()dnl
])# AC_NO_EXECUTABLES



# ----------------------------- #
# Computing EXEEXT and OBJEXT.  #
# ----------------------------- #


# Files to ignore
# ---------------
# Ignore .d files produced by CFLAGS=-MD.
#
# On UWIN (which uses a cc wrapper for MSVC), the compiler also generates
# a .pdb file
#
# When the w32 free Borland C++ command line compiler links a program
# (conftest.exe), it also produces a file named `conftest.tds' in
# addition to `conftest.obj'.
#
# - *.bb, *.bbg
#   Created per object by GCC when given -ftest-coverage.
#
# - *.xSYM
#   Created on BeOS.  Seems to be per executable.
#
# - *.map, *.inf
#   Created by the Green Hills compiler.


# _AC_COMPILER_OBJEXT_REJECT
# --------------------------
# Case/esac pattern matching the files to be ignored when looking for
# compiled object files.
m4_define([_AC_COMPILER_OBJEXT_REJECT],
[*.$ac_ext | *.xcoff | *.tds | *.d | *.pdb | *.xSYM | *.bb | *.bbg | *.map | *.inf])


# _AC_COMPILER_EXEEXT_REJECT
# --------------------------
# Case/esac pattern matching the files to be ignored when looking for
# compiled executables.
m4_define([_AC_COMPILER_EXEEXT_REJECT],
[_AC_COMPILER_OBJEXT_REJECT | *.o | *.obj])


# We must not AU define them, because autoupdate would then remove
# them, which is right, but Automake 1.4 would remove the support for
# $(EXEEXT) etc.
# FIXME: Remove this once Automake fixed.
AC_DEFUN([AC_EXEEXT],   [])
AC_DEFUN([AC_OBJEXT],   [])


# _AC_COMPILER_EXEEXT_DEFAULT
# ---------------------------
# Check for the extension used for the default name for executables.
#
# We do this in order to find out what is the extension we must add for
# creating executables (see _AC_COMPILER_EXEEXT's comments).
#
# Beware of `expr' that may return `0' or `'.  Since this macro is
# the first one in touch with the compiler, it should also check that
# it compiles properly.
#
# On OpenVMS 7.1 system, the DEC C 5.5 compiler when called through a
# GNV (gnv.sourceforge.net) cc wrapper, produces the output file named
# `a_out.exe'.
m4_define([_AC_COMPILER_EXEEXT_DEFAULT],
[# Try to create an executable without -o first, disregard a.out.
# It will help us diagnose broken compilers, and finding out an intuition
# of exeext.
AC_MSG_CHECKING([for _AC_LANG compiler default output file name])
ac_link_default=`echo "$ac_link" | sed ['s/ -o *conftest[^ ]*//']`
#
# List of possible output files, starting from the most likely.
# The algorithm is not robust to junk in `.', hence go to wildcards (a.*)
# only as a last resort.  b.out is created by i960 compilers.
ac_files='a_out.exe a.exe conftest.exe a.out conftest a.* conftest.* b.out'
#
# The IRIX 6 linker writes into existing files which may not be
# executable, retaining their permissions.  Remove them first so a
# subsequent execution test works.
ac_rmfiles=
for ac_file in $ac_files
do
  case $ac_file in
    _AC_COMPILER_EXEEXT_REJECT ) ;;
    * ) ac_rmfiles="$ac_rmfiles $ac_file";;
  esac
done
rm -f $ac_rmfiles

AS_IF([_AC_DO_VAR(ac_link_default)],
[# Autoconf-2.13 could set the ac_cv_exeext variable to `no'.
# So ignore a value of `no', otherwise this would lead to `EXEEXT = no'
# in a Makefile.  We should not override ac_cv_exeext if it was cached,
# so that the user can short-circuit this test for compilers unknown to
# Autoconf.
for ac_file in $ac_files ''
do
  test -f "$ac_file" || continue
  case $ac_file in
    _AC_COMPILER_EXEEXT_REJECT )
	;;
    [[ab]].out )
	# We found the default executable, but exeext='' is most
	# certainly right.
	break;;
    *.* )
        if test "${ac_cv_exeext+set}" = set && test "$ac_cv_exeext" != no;
	then :; else
	   ac_cv_exeext=`expr "$ac_file" : ['[^.]*\(\..*\)']`
	fi
	# We set ac_cv_exeext here because the later test for it is not
	# safe: cross compilers may not add the suffix if given an `-o'
	# argument, so we may need to know it at that point already.
	# Even if this section looks crufty: it has the advantage of
	# actually working.
	break;;
    * )
	break;;
  esac
done
test "$ac_cv_exeext" = no && ac_cv_exeext=
],
      [ac_file=''])
AC_MSG_RESULT([$ac_file])
AS_IF([test -z "$ac_file"],
[_AC_MSG_LOG_CONFTEST
AC_MSG_FAILURE([_AC_LANG compiler cannot create executables], 77)])
ac_exeext=$ac_cv_exeext
])# _AC_COMPILER_EXEEXT_DEFAULT


# _AC_COMPILER_EXEEXT_WORKS
# -------------------------
m4_define([_AC_COMPILER_EXEEXT_WORKS],
[# Check that the compiler produces executables we can run.  If not, either
# the compiler is broken, or we cross compile.
AC_MSG_CHECKING([whether the _AC_LANG compiler works])
# FIXME: These cross compiler hacks should be removed for Autoconf 3.0
# If not cross compiling, check that we can run a simple program.
if test "$cross_compiling" != yes; then
  if _AC_DO_TOKENS([./$ac_file]); then
    cross_compiling=no
  else
    if test "$cross_compiling" = maybe; then
	cross_compiling=yes
    else
	AC_MSG_FAILURE([cannot run _AC_LANG compiled programs.
If you meant to cross compile, use `--host'.])
    fi
  fi
fi
AC_MSG_RESULT([yes])
])# _AC_COMPILER_EXEEXT_WORKS


# _AC_COMPILER_EXEEXT_CROSS
# -------------------------
m4_define([_AC_COMPILER_EXEEXT_CROSS],
[# Check that the compiler produces executables we can run.  If not, either
# the compiler is broken, or we cross compile.
AC_MSG_CHECKING([whether we are cross compiling])
AC_MSG_RESULT([$cross_compiling])
])# _AC_COMPILER_EXEEXT_CROSS


# _AC_COMPILER_EXEEXT_O
# ---------------------
# Check for the extension used when `-o foo'.  Try to see if ac_cv_exeext,
# as computed by _AC_COMPILER_EXEEXT_DEFAULT is OK.
m4_define([_AC_COMPILER_EXEEXT_O],
[AC_MSG_CHECKING([for suffix of executables])
AS_IF([_AC_DO_VAR(ac_link)],
[# If both `conftest.exe' and `conftest' are `present' (well, observable)
# catch `conftest.exe'.  For instance with Cygwin, `ls conftest' will
# work properly (i.e., refer to `conftest.exe'), while it won't with
# `rm'.
for ac_file in conftest.exe conftest conftest.*; do
  test -f "$ac_file" || continue
  case $ac_file in
    _AC_COMPILER_EXEEXT_REJECT ) ;;
    *.* ) ac_cv_exeext=`expr "$ac_file" : ['[^.]*\(\..*\)']`
	  break;;
    * ) break;;
  esac
done],
	      [AC_MSG_FAILURE([cannot compute suffix of executables: cannot compile and link])])
rm -f conftest$ac_cv_exeext
AC_MSG_RESULT([$ac_cv_exeext])
])# _AC_COMPILER_EXEEXT_O


# _AC_COMPILER_EXEEXT
# -------------------
# Check for the extension used for executables.  It compiles a test
# executable.  If this is called, the executable extensions will be
# automatically used by link commands run by the configure script.
#
# Note that some compilers (cross or not), strictly obey to `-o foo' while
# the host requires `foo.exe', so we should not depend upon `-o' to
# test EXEEXT.  But then, be sure not to destroy user files.
#
# Must be run before _AC_COMPILER_OBJEXT because _AC_COMPILER_EXEEXT_DEFAULT
# checks whether the compiler works.
m4_define([_AC_COMPILER_EXEEXT],
[AC_LANG_CONFTEST([AC_LANG_PROGRAM()])
ac_clean_files_save=$ac_clean_files
ac_clean_files="$ac_clean_files a.out a.exe b.out"
_AC_COMPILER_EXEEXT_DEFAULT
_AC_COMPILER_EXEEXT_WORKS
rm -f a.out a.exe conftest$ac_cv_exeext b.out
ac_clean_files=$ac_clean_files_save
_AC_COMPILER_EXEEXT_CROSS
_AC_COMPILER_EXEEXT_O
rm -f conftest.$ac_ext
AC_SUBST([EXEEXT], [$ac_cv_exeext])dnl
ac_exeext=$EXEEXT
])# _AC_COMPILER_EXEEXT


# _AC_COMPILER_OBJEXT
# -------------------
# Check the object extension used by the compiler: typically `.o' or
# `.obj'.  If this is called, some other behavior will change,
# determined by ac_objext.
#
# This macro is called by AC_LANG_COMPILER, the latter being required
# by the AC_COMPILE_IFELSE macros, so use _AC_COMPILE_IFELSE.  And in fact,
# don't, since _AC_COMPILE_IFELSE needs to know ac_objext for the `test -s'
# it includes.  So do it by hand.
m4_define([_AC_COMPILER_OBJEXT],
[AC_CACHE_CHECK([for suffix of object files], ac_cv_objext,
[AC_LANG_CONFTEST([AC_LANG_PROGRAM()])
rm -f conftest.o conftest.obj
AS_IF([_AC_DO_VAR(ac_compile)],
[for ac_file in conftest.o conftest.obj conftest.*; do
  test -f "$ac_file" || continue;
  case $ac_file in
    _AC_COMPILER_OBJEXT_REJECT ) ;;
    *) ac_cv_objext=`expr "$ac_file" : '.*\.\(.*\)'`
       break;;
  esac
done],
      [_AC_MSG_LOG_CONFTEST
AC_MSG_FAILURE([cannot compute suffix of object files: cannot compile])])
rm -f conftest.$ac_cv_objext conftest.$ac_ext])
AC_SUBST([OBJEXT], [$ac_cv_objext])dnl
ac_objext=$OBJEXT
])# _AC_COMPILER_OBJEXT





## ------------------------------- ##
## 4. Compilers' characteristics.  ##
## ------------------------------- ##

# AC_LANG_WERROR
# ------------------
# Treat warnings from the current language's preprocessor, compiler, and
# linker as fatal errors.
AC_DEFUN([AC_LANG_WERROR],
[m4_divert_text([DEFAULTS], [ac_[]_AC_LANG_ABBREV[]_werror_flag=])
ac_[]_AC_LANG_ABBREV[]_werror_flag=yes])# AC_LANG_WERROR
