## Autoconf macros for working with Guile.
##
##   Copyright (C) 1998,2001 Free Software Foundation, Inc.
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this software; see the file COPYING.  If not, write to
## the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
## Boston, MA 02111-1307 USA
##
## As a special exception, the Free Software Foundation gives permission
## for additional uses of the text contained in its release of GUILE.
##
## The exception is that, if you link the GUILE library with other files
## to produce an executable, this does not by itself cause the
## resulting executable to be covered by the GNU General Public License.
## Your use of that executable is in no way restricted on account of
## linking the GUILE library code into it.
##
## This exception does not however invalidate any other reasons why
## the executable file might be covered by the GNU General Public License.
##
## This exception applies only to the code released by the
## Free Software Foundation under the name GUILE.  If you copy
## code from other Free Software Foundation releases into a copy of
## GUILE, as the General Public License permits, the exception does
## not apply to the code that you add in this way.  To avoid misleading
## anyone as to the status of such modified files, you must delete
## this exception notice from them.
##
## If you write modifications of your own for GUILE, it is your choice
## whether to permit this exception to apply to your modifications.
## If you do not wish that, delete this exception notice.

## Index
## -----
##
## GUILE_PROGS -- set paths to Guile interpreter, config and tool programs
## GUILE_FLAGS -- set flags for compiling and linking with Guile
## GUILE_SITE_DIR -- find path to Guile "site" directory
## GUILE_CHECK -- evaluate Guile Scheme code and capture the return value
## GUILE_MODULE_CHECK -- check feature of a Guile Scheme module
## GUILE_MODULE_AVAILABLE -- check availability of a Guile Scheme module
## GUILE_MODULE_REQUIRED -- fail if a Guile Scheme module is unavailable
## GUILE_MODULE_EXPORTS -- check if a module exports a variable
## GUILE_MODULE_REQUIRED_EXPORT -- fail if a module doesn't export a variable

## Code
## ----

## NOTE: Comments preceding an AC_DEFUN (starting from "Usage:") are massaged
## into doc/ref/autoconf-macros.texi (see Makefile.am in that directory).

# GUILE_PROGS -- set paths to Guile interpreter, config and tool programs
#
# Usage: GUILE_PROGS
#
# This macro looks for programs @code{guile}, @code{guile-config} and
# @code{guile-tools}, and sets variables @var{GUILE}, @var{GUILE_CONFIG} and
# @var{GUILE_TOOLS}, to their paths, respectively.  If either of the first two
# is not found, signal error.
#
# The variables are marked for substitution, as by @code{AC_SUBST}.
#
AC_DEFUN([GUILE_PROGS],
 [AC_PATH_PROG(GUILE,guile)
  if test "$GUILE" = "" ; then
      AC_MSG_ERROR([guile required but not found])
  fi
  AC_SUBST(GUILE)
  AC_PATH_PROG(GUILE_CONFIG,guile-config)
  if test "$GUILE_CONFIG" = "" ; then
      AC_MSG_ERROR([guile-config required but not found])
  fi
  AC_SUBST(GUILE_CONFIG)
  AC_PATH_PROG(GUILE_TOOLS,guile-tools)
  AC_SUBST(GUILE_TOOLS)
 ])

# GUILE_FLAGS -- set flags for compiling and linking with Guile
#
# Usage: GUILE_FLAGS
#
# This macro runs the @code{guile-config} script, installed with Guile, to
# find out where Guile's header files and libraries are installed.  It sets
# two variables, @var{GUILE_CFLAGS} and @var{GUILE_LDFLAGS}.
#
# @var{GUILE_CFLAGS}: flags to pass to a C or C++ compiler to build code that
# uses Guile header files.  This is almost always just a @code{-I} flag.
#
# @var{GUILE_LDFLAGS}: flags to pass to the linker to link a program against
# Guile.  This includes @code{-lguile} for the Guile library itself, any
# libraries that Guile itself requires (like -lqthreads), and so on.  It may
# also include a @code{-L} flag to tell the compiler where to find the
# libraries.
#
# The variables are marked for substitution, as by @code{AC_SUBST}.
#
AC_DEFUN([GUILE_FLAGS],
 [AC_REQUIRE([GUILE_PROGS])dnl
  AC_MSG_CHECKING([libguile compile flags])
  GUILE_CFLAGS="`$GUILE_CONFIG compile`"
  AC_MSG_RESULT([$GUILE_CFLAGS])
  AC_MSG_CHECKING([libguile link flags])
  GUILE_LDFLAGS="`$GUILE_CONFIG link`"
  AC_MSG_RESULT([$GUILE_LDFLAGS])
  AC_SUBST(GUILE_CFLAGS)
  AC_SUBST(GUILE_LDFLAGS)
 ])

# GUILE_SITE_DIR -- find path to Guile "site" directory
#
# Usage: GUILE_SITE_DIR
#
# This looks for Guile's "site" directory, usually something like
# PREFIX/share/guile/site, and sets var @var{GUILE_SITE} to the path.
# Note that the var name is different from the macro name.
#
# The variable is marked for substitution, as by @code{AC_SUBST}.
#
AC_DEFUN([GUILE_SITE_DIR],
 [AC_REQUIRE([GUILE_PROGS])dnl
  AC_MSG_CHECKING(for Guile site directory)
  GUILE_SITE=`[$GUILE_CONFIG] info pkgdatadir`/site
  AC_MSG_RESULT($GUILE_SITE)
  AC_SUBST(GUILE_SITE)
 ])

# GUILE_CHECK -- evaluate Guile Scheme code and capture the return value
#
# Usage: GUILE_CHECK_RETVAL(var,check)
#
# @var{var} is a shell variable name to be set to the return value.
# @var{check} is a Guile Scheme expression, evaluated with "$GUILE -c", and
#    returning either 0 or non-#f to indicate the check passed.
#    Non-0 number or #f indicates failure.
#    Avoid using the character "#" since that confuses autoconf.
#
AC_DEFUN([GUILE_CHECK],
 [AC_REQUIRE([GUILE_PROGS])
  $GUILE -c "$2" > /dev/null 2>&1
  $1=$?
 ])

# GUILE_MODULE_CHECK -- check feature of a Guile Scheme module
#
# Usage: GUILE_MODULE_CHECK(var,module,featuretest,description)
#
# @var{var} is a shell variable name to be set to "yes" or "no".
# @var{module} is a list of symbols, like: (ice-9 common-list).
# @var{featuretest} is an expression acceptable to GUILE_CHECK, q.v.
# @var{description} is a present-tense verb phrase (passed to AC_MSG_CHECKING).
#
AC_DEFUN([GUILE_MODULE_CHECK],
         [AC_MSG_CHECKING([if $2 $4])
	  GUILE_CHECK($1,(use-modules $2) (exit ((lambda () $3))))
	  if test "$$1" = "0" ; then $1=yes ; else $1=no ; fi
          AC_MSG_RESULT($$1)
         ])

# GUILE_MODULE_AVAILABLE -- check availability of a Guile Scheme module
#
# Usage: GUILE_MODULE_AVAILABLE(var,module)
#
# @var{var} is a shell variable name to be set to "yes" or "no".
# @var{module} is a list of symbols, like: (ice-9 common-list).
#
AC_DEFUN([GUILE_MODULE_AVAILABLE],
         [GUILE_MODULE_CHECK($1,$2,0,is available)
         ])

# GUILE_MODULE_REQUIRED -- fail if a Guile Scheme module is unavailable
#
# Usage: GUILE_MODULE_REQUIRED(symlist)
#
# @var{symlist} is a list of symbols, WITHOUT surrounding parens,
# like: ice-9 common-list.
#
AC_DEFUN([GUILE_MODULE_REQUIRED],
         [GUILE_MODULE_AVAILABLE(ac_guile_module_required, ($1))
          if test "$ac_guile_module_required" = "no" ; then
              AC_MSG_ERROR([required guile module not found: ($1)])
          fi
         ])

# GUILE_MODULE_EXPORTS -- check if a module exports a variable
#
# Usage: GUILE_MODULE_EXPORTS(var,module,modvar)
#
# @var{var} is a shell variable to be set to "yes" or "no".
# @var{module} is a list of symbols, like: (ice-9 common-list).
# @var{modvar} is the Guile Scheme variable to check.
#
AC_DEFUN([GUILE_MODULE_EXPORTS],
 [GUILE_MODULE_CHECK($1,$2,$3,exports `$3')
 ])

# GUILE_MODULE_REQUIRED_EXPORT -- fail if a module doesn't export a variable
#
# Usage: GUILE_MODULE_REQUIRED_EXPORT(module,modvar)
#
# @var{module} is a list of symbols, like: (ice-9 common-list).
# @var{modvar} is the Guile Scheme variable to check.
#
AC_DEFUN([GUILE_MODULE_REQUIRED_EXPORT],
 [GUILE_MODULE_EXPORTS(guile_module_required_export,$1,$2)
  if test "$guile_module_required_export" = "no" ; then
      AC_MSG_ERROR([module $1 does not export $2; required])
  fi
 ])

## guile.m4 ends here
