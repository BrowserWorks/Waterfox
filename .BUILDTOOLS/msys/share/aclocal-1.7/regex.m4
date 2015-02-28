## --------------------------------- ##              -*- Autoconf -*-
## Check if --with-regex was given.  ##
## --------------------------------- ##

# Copyright 1996, 1998, 1999, 2000, 2001, 2002  Free Software Foundation, Inc.

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

# serial 4
AC_PREREQ(2.50)

# AM_WITH_REGEX
# -------------
#
# The idea is to distribute rx.[hc] and regex.[hc] together, for a
# while.  The WITH_REGEX symbol is used to decide which of regex.h or
# rx.h should be included in the application.  If `./configure
# --with-regex' is given (the default), the package will use gawk's
# regex.  If `./configure --without-regex', a check is made to see if
# rx is already installed, as with newer Linux'es.  If not found, the
# package will use the rx from the distribution.  If found, the
# package will use the system's rx which, on Linux at least, will
# result in a smaller executable file.
#
# FIXME: This macro seems quite obsolete now since rx doesn't seem to
# be maintained, while regex is.
AC_DEFUN([AM_WITH_REGEX],
[AC_LIBSOURCES([rx.h, rx.c, regex.c, regex.h])dnl
AC_MSG_CHECKING([which of GNU rx or gawk's regex is wanted])
AC_ARG_WITH(regex,
[  --without-regex         use GNU rx in lieu of gawk's regex for matching],
            [test "$withval" = yes && am_with_regex=1],
            [am_with_regex=1])
if test -n "$am_with_regex"; then
  AC_MSG_RESULT(regex)
  AC_DEFINE(WITH_REGEX, 1, [Define if using GNU regex])
  AC_CACHE_CHECK([for GNU regex in libc], am_cv_gnu_regex,
    [AC_TRY_LINK([],
                 [extern int re_max_failures; re_max_failures = 1],
		 [am_cv_gnu_regex=yes],
                 [am_cv_gnu_regex=no])])
  if test $am_cv_gnu_regex = no; then
    AC_LIBOBJ([regex])
  fi
else
  AC_MSG_RESULT(rx)
  AC_CHECK_FUNC(re_rx_search, , [AC_LIBOBJ([rx])])
fi
AC_SUBST(LIBOBJS)dnl
])

AU_DEFUN([fp_WITH_REGEX], [AM_WITH_REGEX])
