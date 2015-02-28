## ------------------------
## Python file handling
## From Andrew Dalke
## Updated by James Henstridge
## ------------------------

# Copyright 1999, 2000, 2001, 2002  Free Software Foundation, Inc.

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

# AM_PATH_PYTHON([MINIMUM-VERSION])

# Adds support for distributing Python modules and packages.  To
# install modules, copy them to $(pythondir), using the python_PYTHON
# automake variable.  To install a package with the same name as the
# automake package, install to $(pkgpythondir), or use the
# pkgpython_PYTHON automake variable.

# The variables $(pyexecdir) and $(pkgpyexecdir) are provided as
# locations to install python extension modules (shared libraries).
# Another macro is required to find the appropriate flags to compile
# extension modules.

# If your package is configured with a different prefix to python,
# users will have to add the install directory to the PYTHONPATH
# environment variable, or create a .pth file (see the python
# documentation for details).

# If the MINIUMUM-VERSION argument is passed, AM_PATH_PYTHON will
# cause an error if the version of python installed on the system
# doesn't meet the requirement.  MINIMUM-VERSION should consist of
# numbers and dots only.

AC_DEFUN([AM_PATH_PYTHON],
 [
  dnl Find a Python interpreter.  Python versions prior to 1.5 are not
  dnl supported because the default installation locations changed from
  dnl $prefix/lib/site-python in 1.4 to $prefix/lib/python1.5/site-packages
  dnl in 1.5.
  m4_define([_AM_PYTHON_INTERPRETER_LIST],
	    [python python2 python2.2 python2.1 python2.0 python1.6 python1.5])

  m4_if([$1],[],[
    dnl No version check is needed.
    # Find any Python interpreter.
    AC_PATH_PROG([PYTHON], _AM_PYTHON_INTERPRETER_LIST)
    am_display_PYTHON=python
  ], [
    dnl A version check is needed.
    if test -n "$PYTHON"; then
      # If the user set $PYTHON, use it and don't search something else.
      AC_MSG_CHECKING([whether $PYTHON version >= $1])
      AM_PYTHON_CHECK_VERSION([$PYTHON], [$1],
			      [AC_MSG_RESULT(yes)],
			      [AC_MSG_ERROR(too old)])
    else
      # Otherwise, try each interpreter until we find one that satisfies
      # VERSION.
      AC_CACHE_CHECK([for a Python interpreter with version >= $1],
	[am_cv_pathless_PYTHON],[
	for am_cv_pathless_PYTHON in _AM_PYTHON_INTERPRETER_LIST : ; do
          if test "$am_cv_pathless_PYTHON" = : ; then
            AC_MSG_ERROR([no suitable Python interpreter found])
	  fi
          AM_PYTHON_CHECK_VERSION([$am_cv_pathless_PYTHON], [$1], [break])
        done])
      # Set $PYTHON to the absolute path of $am_cv_pathless_PYTHON.
      AC_PATH_PROG([PYTHON], [$am_cv_pathless_PYTHON])
      am_display_PYTHON=$am_cv_pathless_PYTHON
    fi
  ])

  dnl Query Python for its version number.  Getting [:3] seems to be
  dnl the best way to do this; it's what "site.py" does in the standard
  dnl library.

  AC_CACHE_CHECK([for $am_display_PYTHON version], [am_cv_python_version],
    [am_cv_python_version=`$PYTHON -c "import sys; print sys.version[[:3]]"`])
  AC_SUBST([PYTHON_VERSION], [$am_cv_python_version])

  dnl Use the values of $prefix and $exec_prefix for the corresponding
  dnl values of PYTHON_PREFIX and PYTHON_EXEC_PREFIX.  These are made
  dnl distinct variables so they can be overridden if need be.  However,
  dnl general consensus is that you shouldn't need this ability.

  AC_SUBST([PYTHON_PREFIX], ['${prefix}'])
  AC_SUBST([PYTHON_EXEC_PREFIX], ['${exec_prefix}'])

  dnl At times (like when building shared libraries) you may want
  dnl to know which OS platform Python thinks this is.

  AC_CACHE_CHECK([for $am_display_PYTHON platform], [am_cv_python_platform],
    [am_cv_python_platform=`$PYTHON -c "import sys; print sys.platform"`])
  AC_SUBST([PYTHON_PLATFORM], [$am_cv_python_platform])


  dnl Set up 4 directories:

  dnl pythondir -- where to install python scripts.  This is the
  dnl   site-packages directory, not the python standard library
  dnl   directory like in previous automake betas.  This behaviour
  dnl   is more consistent with lispdir.m4 for example.
  dnl
  dnl Also, if the package prefix isn't the same as python's prefix,
  dnl then the old $(pythondir) was pretty useless.

  AC_SUBST([pythondir],
	   [$PYTHON_PREFIX"/lib/python"$PYTHON_VERSION/site-packages])

  dnl pkgpythondir -- $PACKAGE directory under pythondir.  Was
  dnl   PYTHON_SITE_PACKAGE in previous betas, but this naming is
  dnl   more consistent with the rest of automake.
  dnl   Maybe this should be put in python.am?

  AC_SUBST([pkgpythondir], [\${pythondir}/$PACKAGE])

  dnl pyexecdir -- directory for installing python extension modules
  dnl   (shared libraries)  Was PYTHON_SITE_EXEC in previous betas.

  AC_SUBST([pyexecdir],
	   [${PYTHON_EXEC_PREFIX}/lib/python${PYTHON_VERSION}/site-packages])

  dnl pkgpyexecdir -- $(pyexecdir)/$(PACKAGE)
  dnl   Maybe this should be put in python.am?

  AC_SUBST([pkgpyexecdir], [\${pyexecdir}/$PACKAGE])
])


# AM_PYTHON_CHECK_VERSION(PROG, VERSION, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
# ---------------------------------------------------------------------------
# Run ACTION-IF-TRUE if the Python interpreter PROG has version >= VERSION.
# Run ACTION-IF-FALSE otherwise.
# This test uses sys.hexversion instead of the string equivalant (first
# word of sys.version), in order to cope with versions such as 2.2c1.
# hexversion has been introduced in Python 1.5.2; it's probably not
# worth to support older versions (1.5.1 was released on October 31, 1998).
AC_DEFUN([AM_PYTHON_CHECK_VERSION],
 [prog="import sys, string
# split strings by '.' and convert to numeric.  Append some zeros
# because we need at least 4 digits for the hex conversion.
minver = map(int, string.split('$2', '.')) + [[0, 0, 0]]
minverhex = 0
for i in xrange(0, 4): minverhex = (minverhex << 8) + minver[[i]]
sys.exit(sys.hexversion < minverhex)"
  AS_IF([AM_RUN_LOG([$1 -c "$prog"])], [$3], [$4])])
