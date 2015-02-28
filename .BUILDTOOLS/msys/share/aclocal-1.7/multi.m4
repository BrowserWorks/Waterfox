# Copyright 1998, 1999, 2000, 2001 Free Software Foundation, Inc.

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

# serial 3

# AM_ENABLE_MULTILIB([MAKEFILE], [REL-TO-TOP-SRCDIR])
# ---------------------------------------------------
# Add --enable-multilib to configure.
AC_DEFUN([AM_ENABLE_MULTILIB],
[# Default to --enable-multilib
AC_ARG_ENABLE(multilib,
[  --enable-multilib         build many library versions (default)],
[case "$enableval" in
  yes) multilib=yes ;;
  no)  multilib=no ;;
  *)   AC_MSG_ERROR([bad value $enableval for multilib option]) ;;
 esac],
              [multilib=yes])

# We may get other options which we leave undocumented:
# --with-target-subdir, --with-multisrctop, --with-multisubdir
# See config-ml.in if you want the gory details.

if test "$srcdir" = "."; then
  if test "$with_target_subdir" != "."; then
    multi_basedir="$srcdir/$with_multisrctop../$2"
  else
    multi_basedir="$srcdir/$with_multisrctop$2"
  fi
else
  multi_basedir="$srcdir/$2"
fi
AC_SUBST(multi_basedir)

AC_OUTPUT_COMMANDS([
# Only add multilib support code if we just rebuilt the top-level
# Makefile.
case " $CONFIG_FILES " in
 *" ]m4_default([$1],Makefile)[ "*)
   ac_file=]m4_default([$1],Makefile)[ . ${multi_basedir}/config-ml.in
   ;;
esac],
                   [
srcdir="$srcdir"
host="$host"
target="$target"
with_multisubdir="$with_multisubdir"
with_multisrctop="$with_multisrctop"
with_target_subdir="$with_target_subdir"
ac_configure_args="${multilib_arg} ${ac_configure_args}"
multi_basedir="$multi_basedir"
CONFIG_SHELL=${CONFIG_SHELL-/bin/sh}
CC="$CC"])])dnl
