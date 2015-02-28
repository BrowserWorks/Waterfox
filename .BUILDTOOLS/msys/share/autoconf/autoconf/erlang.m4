# This file is part of Autoconf.                       -*- Autoconf -*-
# Erlang/OTP language support.
# Copyright (C) 2006 Free Software Foundation, Inc.
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
# Written by Romain Lenglet.


# AC_ERLANG_PATH_ERLC([VALUE-IF-NOT-FOUND], [PATH])
# ----------------------------------------------
AC_DEFUN([AC_ERLANG_PATH_ERLC],
[AC_ARG_VAR([ERLC], [Erlang/OTP compiler command [autodetected]])dnl
if test -n "$ERLC"; then
    AC_MSG_CHECKING([for erlc])
    AC_MSG_RESULT([$ERLC])
else
    AC_PATH_TOOL(ERLC, erlc, [$1], [$2])
fi
AC_ARG_VAR([ERLCFLAGS], [Erlang/OTP compiler flags [none]])dnl
])# AC_ERLANG_PATH_ERLC

# AC_ERLANG_NEED_ERLC([PATH])
# ------------------------
AC_DEFUN([AC_ERLANG_NEED_ERLC],
[AC_ERLANG_PATH_ERLC([not found], [$1])
if test "$ERLC" = "not found"; then
    AC_MSG_ERROR([Erlang/OTP compiler (erlc) not found but required])
fi
])# AC_ERLANG_NEED_ERLC

# AC_ERLANG_PATH_ERL([VALUE-IF-NOT-FOUND], [PATH])
# ---------------------------------------------
AC_DEFUN([AC_ERLANG_PATH_ERL],
[AC_ARG_VAR([ERL], [Erlang/OTP interpreter command [autodetected]])dnl
if test -n "$ERL"; then
    AC_MSG_CHECKING([for erl])
    AC_MSG_RESULT([$ERL])
else
    AC_PATH_TOOL(ERL, erl, [$1], [$2])[]dnl
fi
])# AC_ERLANG_PATH_ERL

# AC_ERLANG_NEED_ERL([PATH])
# -----------------------
AC_DEFUN([AC_ERLANG_NEED_ERL],
[AC_ERLANG_PATH_ERL([not found], [$1])
if test "$ERL" = "not found"; then
    AC_MSG_ERROR([Erlang/OTP interpreter (erl) not found but required])
fi
])# AC_ERLANG_NEED_ERL







dnl Extend Autoconf's AC_LANG macro to accept Erlang as a language for tests

## ----------------------- ##
## 1. Language selection.  ##
## ----------------------- ##


# ------------------------- #
# 1x. The Erlang language.  #
# ------------------------- #

# AC_LANG(Erlang)
# ---------------
m4_define([AC_LANG(Erlang)],
[ac_ext=erl
ac_compile='$ERLC $ERLCFLAGS -b beam conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link='$ERLC $ERLCFLAGS -b beam conftest.$ac_ext >&AS_MESSAGE_LOG_FD ; echo "#!/bin/sh" > conftest$ac_exeext ; echo "\"$ERL\" -run conftest start -run init stop -noshell" >> conftest$ac_exeext ; chmod +x conftest$ac_exeext'
])

# AC_LANG_ERLANG
# --------------
m4_define([AC_LANG_ERLANG], [AC_LANG(Erlang)])


# _AC_LANG_ABBREV(Erlang)
# -----------------------
m4_define([_AC_LANG_ABBREV(Erlang)], [erl])


# _AC_LANG_PREFIX(Erlang)
# -----------------------
m4_define([_AC_LANG_PREFIX(Erlang)], [ERL])


## ---------------------- ##
## 2.Producing programs.  ##
## ---------------------- ##


# ---------------------- #
# 2x. Generic routines.  #
# ---------------------- #

# AC_LANG_SOURCE(Erlang)(BODY)
# ----------------------------
m4_define([AC_LANG_SOURCE(Erlang)],
[$1])

# AC_LANG_PROGRAM(Erlang)([PROLOGUE], [BODY])
# -------------------------------------------
m4_define([AC_LANG_PROGRAM(Erlang)],
[[-module(conftest).
-export([start/0]).]]
[$1
start() ->
$2
.
])


## -------------------------------------------- ##
## 3. Looking for Compilers and Preprocessors.  ##
## -------------------------------------------- ##

# ------------------------- #
# 3x. The Erlang compiler.  #
# ------------------------- #

# AC_LANG_PREPROC(Erlang)
# -----------------------
# Find the Erlang preprocessor.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_PREPROC(Erlang)],
[m4_warn([syntax],
         [$0: No preprocessor defined for ]_AC_LANG)])

# AC_LANG_COMPILER(Erlang)
# ----------------------------
# Find the Erlang compiler.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_COMPILER(Erlang)],
[AC_REQUIRE([AC_ERLANG_PATH_ERLC])])





dnl Macro for checking if an Erlang library is installed, and to
dnl determine its version

# AC_ERLANG_CHECK_LIB(LIBRARY, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -------------------------------------------------------------------
AC_DEFUN([AC_ERLANG_CHECK_LIB],
[AC_REQUIRE([AC_ERLANG_PATH_ERLC])[]dnl
AC_REQUIRE([AC_ERLANG_PATH_ERL])[]dnl
AC_CACHE_CHECK([for Erlang/OTP '$1' library subdirectory],
    [erlang_cv_lib_dir_$1],
    [AC_LANG_PUSH(Erlang)[]dnl
     AC_RUN_IFELSE(
        [AC_LANG_PROGRAM([], [dnl
            ReturnValue = case code:lib_dir("[$1]") of
            {error, bad_name} ->
                file:write_file("conftest.out", "not found\n"),
                1;
            LibDir ->
                file:write_file("conftest.out", LibDir),
                0
            end,
            halt(ReturnValue)])],
        [erlang_cv_lib_dir_$1=`cat conftest.out`],
        [if test ! -f conftest.out; then
             AC_MSG_FAILURE([test Erlang program execution failed])
         else
             erlang_cv_lib_dir_$1="not found"
         fi])
     AC_LANG_POP(Erlang)[]dnl
    ])
AC_CACHE_CHECK([for Erlang/OTP '$1' library version],
    [erlang_cv_lib_ver_$1],
    [AS_IF([test "$erlang_cv_lib_dir_$1" = "not found"],
        [erlang_cv_lib_ver_$1="not found"],
        [erlang_cv_lib_ver_$1=`echo "$erlang_cv_lib_dir_$1" | sed -n -e 's,^.*-\([[^/-]]*\)$,\1,p'`])[]dnl
    ])
AC_SUBST([ERLANG_LIB_DIR_$1], [$erlang_cv_lib_dir_$1])
AC_SUBST([ERLANG_LIB_VER_$1], [$erlang_cv_lib_ver_$1])
AS_IF([test "$erlang_cv_lib_dir_$1" = "not found"], [$3], [$2])
])# AC_ERLANG_CHECK_LIB



dnl Determines the Erlang/OTP root directory

# AC_ERLANG_SUBST_ROOT_DIR
# ---------------
AC_DEFUN([AC_ERLANG_SUBST_ROOT_DIR],
[AC_REQUIRE([AC_ERLANG_NEED_ERLC])[]dnl
AC_REQUIRE([AC_ERLANG_NEED_ERL])[]dnl
AC_CACHE_CHECK([for Erlang/OTP root directory],
    [erlang_cv_root_dir],
    [AC_LANG_PUSH(Erlang)[]dnl
     AC_RUN_IFELSE(
        [AC_LANG_PROGRAM([], [dnl
            RootDir = code:root_dir(),
            file:write_file("conftest.out", RootDir),
            ReturnValue = 0,
            halt(ReturnValue)])],
        [erlang_cv_root_dir=`cat conftest.out`],
        [AC_MSG_FAILURE([test Erlang program execution failed])])
     AC_LANG_POP(Erlang)[]dnl
    ])
AC_SUBST([ERLANG_ROOT_DIR], [$erlang_cv_root_dir])
])# AC_ERLANG_SUBST_ROOT_DIR

# AC_ERLANG_SUBST_LIB_DIR
# ---------------
AC_DEFUN([AC_ERLANG_SUBST_LIB_DIR],
[AC_REQUIRE([AC_ERLANG_NEED_ERLC])[]dnl
AC_REQUIRE([AC_ERLANG_NEED_ERL])[]dnl
AC_CACHE_CHECK([for Erlang/OTP library base directory],
    [erlang_cv_lib_dir],
    [AC_LANG_PUSH(Erlang)[]dnl
     AC_RUN_IFELSE(
        [AC_LANG_PROGRAM([], [dnl
            LibDir = code:lib_dir(),
            file:write_file("conftest.out", LibDir),
            ReturnValue = 0,
            halt(ReturnValue)])],
        [erlang_cv_lib_dir=`cat conftest.out`],
        [AC_MSG_FAILURE([test Erlang program execution failed])])
     AC_LANG_POP(Erlang)[]dnl
    ])
AC_SUBST([ERLANG_LIB_DIR], [$erlang_cv_lib_dir])
])# AC_ERLANG_SUBST_LIB_DIR


dnl Directories for installing Erlang/OTP packages are separated from the
dnl directories determined by running the Erlang/OTP installation that is used
dnl for building.


# AC_ERLANG_SUBST_INSTALL_LIB_DIR
# ---------------
AC_DEFUN([AC_ERLANG_SUBST_INSTALL_LIB_DIR],
[AC_MSG_CHECKING([for Erlang/OTP library installation base directory])
AC_ARG_VAR([ERLANG_INSTALL_LIB_DIR],
    [Erlang/OTP library installation base directory [LIBDIR/erlang/lib]])
if test -n "$ERLANG_INSTALL_LIB_DIR"; then
    AC_MSG_RESULT([$ERLANG_INSTALL_LIB_DIR])
else
    AC_SUBST([ERLANG_INSTALL_LIB_DIR], ['${libdir}/erlang/lib'])
    AC_MSG_RESULT([$libdir/erlang/lib])
fi
])# AC_ERLANG_SUBST_INSTALL_LIB_DIR


# AC_ERLANG_SUBST_INSTALL_LIB_SUBDIR(PACKAGE_TARNAME, PACKAGE_VERSION)
# ---------------
AC_DEFUN([AC_ERLANG_SUBST_INSTALL_LIB_SUBDIR],
[AC_REQUIRE([AC_ERLANG_SUBST_INSTALL_LIB_DIR])[]dnl
AC_MSG_CHECKING([for Erlang/OTP '$1' library installation subdirectory])
AC_ARG_VAR([ERLANG_INSTALL_LIB_DIR_$1],
    [Erlang/OTP '$1' library installation subdirectory [ERLANG_INSTALL_LIB_DIR/$1-$2]])
if test -n "$ERLANG_INSTALL_LIB_DIR_$1"; then
    AC_MSG_RESULT([$ERLANG_INSTALL_LIB_DIR_$1])
else
    AC_SUBST([ERLANG_INSTALL_LIB_DIR_$1], ['${ERLANG_INSTALL_LIB_DIR}/$1-$2'])
    AC_MSG_RESULT([$ERLANG_INSTALL_LIB_DIR/$1-$2])
fi
])# AC_ERLANG_SUBST_INSTALL_LIB_SUBDIR

