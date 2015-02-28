# Helper functions for option handling.                    -*- Autoconf -*-

# Copyright 2002  Free Software Foundation, Inc.

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

# serial 1

# Obsolete Automake macros.

# We put here only the macros whose substitution is not an Automake
# macro; otherwise including this file would trigger dependencies for
# all the subsitutions.  Generally, obsolete Automake macros are
# better AU_DEFUNed in the same file as their replacement, or alone in
# a separate file (see obsol-gt.m4 or obsol-lt.m4 for instance).

AU_DEFUN([AC_FEATURE_CTYPE],     [AC_HEADER_STDC])
AU_DEFUN([AC_FEATURE_ERRNO],     [AC_REPLACE_FUNCS([strerror])])
AU_DEFUN([AM_CYGWIN32],	         [AC_CYGWIN])
AU_DEFUN([AM_EXEEXT],            [AC_EXEEXT])
AU_DEFUN([AM_FUNC_MKTIME],       [AC_FUNC_MKTIME])
AU_DEFUN([AM_HEADER_TIOCGWINSZ_NEEDS_SYS_IOCTL],
				 [AC_HEADER_TIOCGWINSZ])
AU_DEFUN([AM_MINGW32],           [AC_MINGW32])
AU_DEFUN([AM_PROG_INSTALL],      [AC_PROG_INSTALL])
AU_DEFUN([AM_SANITY_CHECK_CC],   [AC_PROG_CC])
AU_DEFUN([AM_SYS_POSIX_TERMIOS], [AC_SYS_POSIX_TERMIOS])
AU_DEFUN([fp_FUNC_FNMATCH],      [AC_FUNC_FNMATCH])
AU_DEFUN([fp_PROG_INSTALL],      [AC_PROG_INSTALL])
AU_DEFUN([md_TYPE_PTRDIFF_T],    [AC_CHECK_TYPES([ptrdiff_t])])

# Don't know how to translate these.
# If used, Autoconf will complain that they are possibly unexpended;
# this seems a good enough error message.
# AC_FEATURE_EXIT
# AC_SYSTEM_HEADER
