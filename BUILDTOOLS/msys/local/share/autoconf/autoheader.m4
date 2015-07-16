dnl Driver and redefinitions of some Autoconf macros for autoheader.
dnl This file is part of Autoconf.
dnl Copyright (C) 1994, 1995 Free Software Foundation, Inc.
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2, or (at your option)
dnl any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
dnl 02111-1307, USA.
dnl
dnl Written by Roland McGrath.
dnl
include(acgeneral.m4)dnl
builtin(include, acspecific.m4)dnl
builtin(include, acoldnames.m4)dnl

dnl These are alternate definitions of some macros, which produce
dnl strings in the output marked with "@@@" so we can easily extract
dnl the information we want.  The `#' at the end of the first line of
dnl each definition seems to be necessary to prevent m4 from eating
dnl the newline, which makes the @@@ not always be at the beginning of
dnl a line.

define([AC_CHECK_FUNCS], [#
@@@funcs="$funcs $1"@@@
ifelse([$2], , , [
# If it was found, we do:
$2
# If it was not found, we do:
$3
])
])

define([AC_CHECK_HEADERS], [#
@@@headers="$headers $1"@@@
ifelse([$2], , , [
# If it was found, we do:
$2
# If it was not found, we do:
$3
])
])

define([AC_CHECK_HEADERS_DIRENT], [#
@@@headers="$headers $1"@@@
])

define([AC_CHECK_LIB], [#
  ifelse([$3], , [
@@@libs="$libs $1"@@@
], [
# If it was found, we do:
$3
# If it was not found, we do:
$4
])
])

define([AC_HAVE_LIBRARY], [#
changequote(<<, >>)dnl
define(<<AC_LIB_NAME>>, dnl
patsubst(patsubst($1, <<lib\([^\.]*\)\.a>>, <<\1>>), <<-l>>, <<>>))dnl
changequote([, ])dnl
  ifelse([$2], , [
@@@libs="$libs AC_LIB_NAME"@@@
], [
# If it was found, we do:
$2
# If it was not found, we do:
$3
])
])

define([AC_CHECK_SIZEOF], [#
@@@types="$types,$1"@@@
])

define([AC_CONFIG_HEADER], [#
define([AC_CONFIG_H], patsubst($1, [ .*$], []))dnl
@@@config_h=AC_CONFIG_H@@@
])

define([AC_DEFINE], [#
ifelse([$3],,[#
@@@syms="$syms $1"@@@
], [#
@@@verbatim="$verbatim
/* $3 */
#undef $1
"@@@
])])

define([AC_DEFINE_UNQUOTED], [#
ifelse([$3],,[#
@@@syms="$syms $1"@@@
], [#
@@@verbatim="$verbatim
/* $3 */
#undef $1
"@@@
])])
