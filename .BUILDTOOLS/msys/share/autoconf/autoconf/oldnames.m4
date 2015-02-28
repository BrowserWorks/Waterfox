# This file is part of Autoconf.                           -*- Autoconf -*-
# Support old macros, and provide automated updates.
# Copyright (C) 1994, 1999, 2000, 2001, 2003 Free Software Foundation, Inc.
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
# Originally written by David J. MacKenzie.


## ---------------------------- ##
## General macros of Autoconf.  ##
## ---------------------------- ##

AU_ALIAS([AC_WARN],		[AC_MSG_WARN])
AU_ALIAS([AC_ERROR],		[AC_MSG_ERROR])
AU_ALIAS([AC_HAVE_HEADERS],	[AC_CHECK_HEADERS])
AU_ALIAS([AC_HEADER_CHECK],	[AC_CHECK_HEADER])
AU_ALIAS([AC_HEADER_EGREP],	[AC_EGREP_HEADER])
AU_ALIAS([AC_PREFIX],		[AC_PREFIX_PROGRAM])
AU_ALIAS([AC_PROGRAMS_CHECK],	[AC_CHECK_PROGS])
AU_ALIAS([AC_PROGRAMS_PATH],	[AC_PATH_PROGS])
AU_ALIAS([AC_PROGRAM_CHECK],	[AC_CHECK_PROG])
AU_ALIAS([AC_PROGRAM_EGREP],	[AC_EGREP_CPP])
AU_ALIAS([AC_PROGRAM_PATH],	[AC_PATH_PROG])
AU_ALIAS([AC_SIZEOF_TYPE],	[AC_CHECK_SIZEOF])
AU_ALIAS([AC_TEST_CPP],		[AC_TRY_CPP])
AU_ALIAS([AC_TEST_PROGRAM],	[AC_TRY_RUN])



## ----------------------------- ##
## Specific macros of Autoconf.  ##
## ----------------------------- ##

AU_ALIAS([AC_CHAR_UNSIGNED],	[AC_C_CHAR_UNSIGNED])
AU_ALIAS([AC_CONST],		[AC_C_CONST])
AU_ALIAS([AC_CROSS_CHECK],	[AC_C_CROSS])
AU_ALIAS([AC_FIND_X],		[AC_PATH_X])
AU_ALIAS([AC_FIND_XTRA],	[AC_PATH_XTRA])
AU_ALIAS([AC_GCC_TRADITIONAL],	[AC_PROG_GCC_TRADITIONAL])
AU_ALIAS([AC_GETGROUPS_T],	[AC_TYPE_GETGROUPS])
AU_ALIAS([AC_INLINE],		[AC_C_INLINE])
AU_ALIAS([AC_LN_S],		[AC_PROG_LN_S])
AU_ALIAS([AC_LONG_DOUBLE],	[AC_C_LONG_DOUBLE])
AU_ALIAS([AC_LONG_FILE_NAMES],	[AC_SYS_LONG_FILE_NAMES])
AU_ALIAS([AC_MAJOR_HEADER],	[AC_HEADER_MAJOR])
AU_ALIAS([AC_MINUS_C_MINUS_O],	[AC_PROG_CC_C_O])
AU_ALIAS([AC_MODE_T],		[AC_TYPE_MODE_T])
AU_ALIAS([AC_OFF_T],		[AC_TYPE_OFF_T])
AU_ALIAS([AC_PID_T],		[AC_TYPE_PID_T])
AU_ALIAS([AC_RESTARTABLE_SYSCALLS],		[AC_SYS_RESTARTABLE_SYSCALLS])
AU_ALIAS([AC_RETSIGTYPE],	[AC_TYPE_SIGNAL])
AU_ALIAS([AC_SET_MAKE],		[AC_PROG_MAKE_SET])
AU_ALIAS([AC_SIZE_T],		[AC_TYPE_SIZE_T])
AU_ALIAS([AC_STAT_MACROS_BROKEN],		[AC_HEADER_STAT])
AU_ALIAS([AC_STDC_HEADERS],	[AC_HEADER_STDC])
AU_ALIAS([AC_ST_BLKSIZE],	[AC_STRUCT_ST_BLKSIZE])
AU_ALIAS([AC_ST_BLOCKS],	[AC_STRUCT_ST_BLOCKS])
AU_ALIAS([AC_ST_RDEV],		[AC_STRUCT_ST_RDEV])
AU_ALIAS([AC_SYS_SIGLIST_DECLARED],		[AC_DECL_SYS_SIGLIST])
AU_ALIAS([AC_TIMEZONE],		[AC_STRUCT_TIMEZONE])
AU_ALIAS([AC_TIME_WITH_SYS_TIME],		[AC_HEADER_TIME])
AU_ALIAS([AC_UID_T],		[AC_TYPE_UID_T])
AU_ALIAS([AC_WORDS_BIGENDIAN],	[AC_C_BIGENDIAN])
AU_ALIAS([AC_YYTEXT_POINTER],	[AC_DECL_YYTEXT])
AU_ALIAS([AM_CYGWIN32],		[AC_CYGWIN32])
AU_ALIAS([AC_CYGWIN32],         [AC_CYGWIN])
AU_ALIAS([AM_EXEEXT],		[AC_EXEEXT])
# We cannot do this, because in libtool.m4 yet they provide
# this update.  Some solution is needed.
# AU_ALIAS([AM_PROG_LIBTOOL],		[AC_PROG_LIBTOOL])
AU_ALIAS([AM_MINGW32],		[AC_MINGW32])
AU_ALIAS([AM_PROG_INSTALL],	[AC_PROG_INSTALL])
