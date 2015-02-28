## ----------------------------------- ##
## Check if --with-dmalloc was given.  ##
## From Franc,ois Pinard               ##
## ----------------------------------- ##

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

# serial 2

AC_DEFUN([AM_WITH_DMALLOC],
[AC_MSG_CHECKING([if malloc debugging is wanted])
AC_ARG_WITH(dmalloc,
[  --with-dmalloc          use dmalloc, as in
                          http://www.dmalloc.com/dmalloc.tar.gz],
[if test "$withval" = yes; then
  AC_MSG_RESULT(yes)
  AC_DEFINE(WITH_DMALLOC,1,
            [Define if using the dmalloc debugging malloc package])
  LIBS="$LIBS -ldmalloc"
  LDFLAGS="$LDFLAGS -g"
else
  AC_MSG_RESULT(no)
fi], [AC_MSG_RESULT(no)])
])

AU_DEFUN([fp_WITH_DMALLOC], [AM_WITH_DMALLOC])
