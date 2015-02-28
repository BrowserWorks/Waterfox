# This file is part of Autoconf.                       -*- Autoconf -*-
# Interface with autoheader.

# Copyright (C) 1992, 1993, 1994, 1995, 1996, 1998, 1999, 2000, 2001,
# 2002 Free Software Foundation, Inc.

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


# AH_OUTPUT(KEY, TEXT)
# --------------------
# Pass TEXT to autoheader.
# This macro is `read' only via `autoconf --trace', it outputs nothing.
m4_define([AH_OUTPUT], [])


# AH_VERBATIM(KEY, TEMPLATE)
# --------------------------
# If KEY is direct (i.e., no indirection such as in KEY=$my_func which
# may occur if there is AC_CHECK_FUNCS($my_func)), issue an autoheader
# TEMPLATE associated to the KEY.  Otherwise, do nothing.  TEMPLATE is
# output as is, with no formatting.
#
# Quote for Perl '' strings, which are those used by Autoheader.
m4_define([AH_VERBATIM],
[AS_LITERAL_IF([$1],
	       [AH_OUTPUT([$1], AS_ESCAPE([[$2]], [\\'']))])
])


# AH_TEMPLATE(KEY, DESCRIPTION)
# -----------------------------
# Issue an autoheader template for KEY, i.e., a comment composed of
# DESCRIPTION (properly wrapped), and then #undef KEY.
m4_define([AH_TEMPLATE],
[AH_VERBATIM([$1],
	     m4_text_wrap([$2 */], [   ], [/* ])[
#undef $1])])


# AH_TOP(TEXT)
# ------------
# Output TEXT at the top of `config.h.in'.
m4_define([AH_TOP],
[m4_define([_AH_COUNTER], m4_incr(_AH_COUNTER))dnl
AH_VERBATIM([0000]_AH_COUNTER, [$1])])


# AH_BOTTOM(TEXT)
# ---------------
# Output TEXT at the bottom of `config.h.in'.
m4_define([AH_BOTTOM],
[m4_define([_AH_COUNTER], m4_incr(_AH_COUNTER))dnl
AH_VERBATIM([zzzz]_AH_COUNTER, [$1])])

# Initialize.
m4_define([_AH_COUNTER], [0])
