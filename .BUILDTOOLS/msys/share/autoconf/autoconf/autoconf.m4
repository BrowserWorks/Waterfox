# This file is part of Autoconf.                -*- Autoconf -*-
# Driver that loads the Autoconf macro files.
#
# Copyright (C) 1994, 1999, 2000, 2001, 2002, 2006 Free Software
# Foundation, Inc.
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
# Written by David MacKenzie and many others.
#
# Do not sinclude acsite.m4 here, because it may not be installed
# yet when Autoconf is frozen.
# Do not sinclude ./aclocal.m4 here, to prevent it from being frozen.

# general includes some AU_DEFUN.
m4_include([autoconf/autoupdate.m4])
m4_include([autoconf/autoscan.m4])
m4_include([autoconf/general.m4])
m4_include([autoconf/status.m4])
m4_include([autoconf/autoheader.m4])
m4_include([autoconf/autotest.m4])
m4_include([autoconf/programs.m4])
m4_include([autoconf/lang.m4])
m4_include([autoconf/c.m4])
m4_include([autoconf/erlang.m4])
m4_include([autoconf/fortran.m4])
m4_include([autoconf/functions.m4])
m4_include([autoconf/headers.m4])
m4_include([autoconf/types.m4])
m4_include([autoconf/libs.m4])
m4_include([autoconf/specific.m4])
m4_include([autoconf/oldnames.m4])

# We discourage the use of the non prefixed macro names: M4sugar maps
# all the builtins into `m4_'.  Autoconf has been converted to these
# names too.  But users may still depend upon these, so reestablish
# them.

m4_copy_unm4([m4_builtin])
m4_copy_unm4([m4_changequote])
m4_copy_unm4([m4_decr])
m4_copy_unm4([m4_define])
m4_copy_unm4([m4_defn])
m4_copy_unm4([m4_divert])
m4_copy_unm4([m4_divnum])
m4_copy_unm4([m4_errprint])
m4_copy_unm4([m4_esyscmd])
m4_copy_unm4([m4_ifdef])
m4_copy([m4_if], [ifelse])
m4_copy_unm4([m4_incr])
m4_copy_unm4([m4_index])
m4_copy_unm4([m4_indir])
m4_copy_unm4([m4_len])
m4_copy([m4_bpatsubst], [patsubst])
m4_copy_unm4([m4_popdef])
m4_copy_unm4([m4_pushdef])
m4_copy([m4_bregexp], [regexp])
m4_copy_unm4([m4_sinclude])
m4_copy_unm4([m4_syscmd])
m4_copy_unm4([m4_sysval])
m4_copy_unm4([m4_traceoff])
m4_copy_unm4([m4_traceon])
m4_copy_unm4([m4_translit])
m4_copy_unm4([m4_undefine])
m4_copy_unm4([m4_undivert])

# Yet some people have started to use m4_patsubst and m4_regexp.
m4_define([m4_patsubst],
[m4_expand_once([m4_warn([syntax],
		 [do not use m4_patsubst: use patsubst or m4_bpatsubst])])dnl
patsubst($@)])

m4_define([m4_regexp],
[m4_expand_once([m4_warn([syntax],
		 [do not use m4_regexp: use regexp or m4_bregexp])])dnl
regexp($@)])
