# This file is part of Autoconf.                       -*- Autoconf -*-
# Interface with autoscan.

# Copyright (C) 2002 Free Software Foundation, Inc.

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

# Written by Akim Demaille.

# The prefix `AN' is chosen after `AutoscaN'.

# AN_OUTPUT(KIND, WORD, MACROS)
# -----------------------------
# Declare that the WORD, used as a KIND, requires triggering the MACROS.
m4_define([AN_OUTPUT], [])


# AN_FUNCTION(NAME, MACROS)
# AN_HEADER(NAME, MACROS)
# AN_IDENTIFIER(NAME, MACROS)
# AN_LIBRARY(NAME, MACROS)
# AN_MAKEVAR(NAME, MACROS)
# AN_PROGRAM(NAME, MACROS)
# ---------------------------
# If the FUNCTION/HEADER etc. is used in the package, then the MACROS
# should be invoked from configure.ac.
m4_define([AN_FUNCTION],   [AN_OUTPUT([function], $@)])
m4_define([AN_HEADER],     [AN_OUTPUT([header], $@)])
m4_define([AN_IDENTIFIER], [AN_OUTPUT([identifier], $@)])
m4_define([AN_LIBRARY],    [AN_OUTPUT([library], $@)])
m4_define([AN_MAKEVAR],    [AN_OUTPUT([makevar], $@)])
m4_define([AN_PROGRAM],    [AN_OUTPUT([program], $@)])
