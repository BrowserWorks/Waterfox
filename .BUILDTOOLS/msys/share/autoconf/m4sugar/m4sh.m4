# This file is part of Autoconf.                          -*- Autoconf -*-
# M4 sugar for common shell constructs.
# Requires GNU M4 and M4sugar.
#
# Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2006 Free Software
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
# Written by Akim Demaille, Pavel Roskin, Alexandre Oliva, Lars J. Aas
# and many other people.


# We heavily use m4's diversions both for the initializations and for
# required macros, because in both cases we have to issue soon in
# output something which is discovered late.
#
#
# KILL is only used to suppress output.
#
# - BINSH
#   AC_REQUIRE'd #! /bin/sh line
# - HEADER-REVISION
#   RCS keywords etc.
# - HEADER-COMMENT
#   Purpose of the script etc.
# - HEADER-COPYRIGHT
#   Copyright notice(s)
# - M4SH-SANITIZE
#   M4sh's shell setup
# - M4SH-INIT
#   M4sh initialization
# - BODY
#   The body of the script.


# _m4_divert(DIVERSION-NAME)
# --------------------------
# Convert a diversion name into its number.  Otherwise, return
# DIVERSION-NAME which is supposed to be an actual diversion number.
# Of course it would be nicer to use m4_case here, instead of zillions
# of little macros, but it then takes twice longer to run `autoconf'!
m4_define([_m4_divert(BINSH)],             0)
m4_define([_m4_divert(HEADER-REVISION)],   1)
m4_define([_m4_divert(HEADER-COMMENT)],    2)
m4_define([_m4_divert(HEADER-COPYRIGHT)],  3)
m4_define([_m4_divert(M4SH-SANITIZE)],     4)
m4_define([_m4_divert(M4SH-INIT)],         5)
m4_define([_m4_divert(BODY)],           1000)

# Aaarg.  Yet it starts with compatibility issues...  Libtool wants to
# use NOTICE to insert its own LIBTOOL-INIT stuff.  People should ask
# before diving into our internals :(
m4_copy([_m4_divert(M4SH-INIT)], [_m4_divert(NOTICE)])



## ------------------------- ##
## 1. Sanitizing the shell.  ##
## ------------------------- ##


# AS_REQUIRE(NAME-TO-CHECK, [BODY-TO-EXPAND = NAME-TO-CHECK])
# -----------------------------------------------------------
# BODY-TO-EXPAND is some initialization which must be expanded in the
# M4SH-INIT section when expanded (required or not).  This is very
# different from m4_require.  For instance:
#
#      m4_defun([_FOO_PREPARE], [foo=foo])
#      m4_defun([FOO],
#      [m4_require([_FOO_PREPARE])dnl
#      echo $foo])
#
#      m4_defun([_BAR_PREPARE], [bar=bar])
#      m4_defun([BAR],
#      [AS_REQUIRE([_BAR_PREPARE])dnl
#      echo $bar])
#
#      AS_INIT
#      foo1=`FOO`
#      foo2=`FOO`
#      bar1=`BAR`
#      bar2=`BAR`
#
# gives
#
#      #! /bin/sh
#      bar=bar
#
#      foo1=`foo=foo
#      echo $foo`
#      foo2=`echo $foo`
#      bar1=`echo $bar`
#      bar2=`echo $bar`
#
# Due to the simple implementation, all the AS_REQUIRE calls have to be at
# the very beginning of the macro body, or the AS_REQUIREs may not be nested.
# More exactly, if a macro doesn't have all AS_REQUIREs at its beginning,
# it may not be AS_REQUIREd.
#
m4_define([AS_REQUIRE],
[m4_provide_if([$1], [],
	       [m4_divert_text([M4SH-INIT], [m4_default([$2], [$1])])])])


# AS_REQUIRE_SHELL_FN(NAME-TO-CHECK, BODY-TO-EXPAND)
# --------------------------------------------------
# BODY-TO-EXPAND is the body of a shell function to be emitted in the
# M4SH-INIT section when expanded (required or not).  Unlike other
# xx_REQUIRE macros, BODY-TO-EXPAND is mandatory.
#
m4_define([AS_REQUIRE_SHELL_FN],
[_AS_DETECT_REQUIRED([_AS_SHELL_FN_WORK])dnl
m4_provide_if([AS_SHELL_FN_$1], [],
               [m4_provide([AS_SHELL_FN_$1])m4_divert_text([M4SH-INIT], [$1() {
$2
}])])])


# AS_BOURNE_COMPATIBLE
# --------------------
# Try to be as Bourne and/or POSIX as possible.
#
# This does not set BIN_SH, due to the problems described in
# <http://lists.gnu.org/archive/html/autoconf-patches/2006-03/msg00081.html>.
# People who need BIN_SH should set it in their environment before invoking
# configure; apparently this would include UnixWare, as described in
# <http://lists.gnu.org/archive/html/bug-autoconf/2006-06/msg00025.html>.
m4_define([AS_BOURNE_COMPATIBLE],
[# Be more Bourne compatible
DUALCASE=1; export DUALCASE # for MKS sh
_$0
])

# _AS_BOURNE_COMPATIBLE
# ---------------------
# This is the part of AS_BOURNE_COMPATIBLE which has to be repeated inside
# each instance.
m4_define([_AS_BOURNE_COMPATIBLE],
[AS_IF([test -n "${ZSH_VERSION+set}" && (emulate sh) >/dev/null 2>&1],
 [emulate sh
  NULLCMD=:
  [#] Zsh 3.x and 4.x performs word splitting on ${1+"$[@]"}, which
  # is contrary to our usage.  Disable this feature.
  alias -g '${1+"$[@]"}'='"$[@]"'
  setopt NO_GLOB_SUBST],
 [AS_CASE([`(set -o) 2>/dev/null`], [*posix*], [set -o posix])])
])


# _AS_RUN(TEST, [SHELL])
# ----------------------
# Run TEST under the current shell (if one parameter is used)
# or under the given SHELL, protecting it from syntax errors.
m4_define([_AS_RUN],
[m4_ifval([$2],
[{ $2 <<\_ASEOF
_AS_BOURNE_COMPATIBLE
$1
_ASEOF
}],
[(eval "AS_ESCAPE(m4_quote($1))")])])


# _AS_DETECT_REQUIRED(TEST)
# -------------------------
# Refuse to execute under a shell that does not pass the given TEST.
m4_define([_AS_DETECT_REQUIRED_BODY], [:])
m4_defun([_AS_DETECT_REQUIRED],
[m4_require([_AS_DETECT_BETTER_SHELL])dnl
m4_expand_once([m4_append([_AS_DETECT_REQUIRED_BODY], [
($1) || AS_EXIT(1)
])], [_AS_DETECT_REQUIRED_provide($1)])])


# _AS_DETECT_SUGGESTED(TEST)
# --------------------------
# Prefer to execute under a shell that passes the given TEST.
m4_define([_AS_DETECT_SUGGESTED_BODY], [:])
m4_defun([_AS_DETECT_SUGGESTED],
[m4_require([_AS_DETECT_BETTER_SHELL])dnl
m4_expand_once([m4_append([_AS_DETECT_SUGGESTED_BODY], [
($1) || AS_EXIT(1)
])], [_AS_DETECT_SUGGESTED_provide($1)])])


# _AS_DETECT_BETTER_SHELL
# -----------------------
# The real workhorse for detecting a shell with the correct
# features.
#
# In previous versions, we prepended /usr/posix/bin to the path, but that
# caused a regression on OpenServer 6.0.0
# <http://lists.gnu.org/archive/html/bug-autoconf/2006-06/msg00017.html>
# and on HP-UX 11.11, see the failure of test 120 in
# <http://lists.gnu.org/archive/html/bug-autoconf/2006-10/msg00003.html>
#
# FIXME: The code should test for the OSF bug described in
# <http://lists.gnu.org/archive/html/autoconf-patches/2006-03/msg00081.html>.
#
m4_defun_once([_AS_DETECT_BETTER_SHELL],
[m4_wrap([m4_divert_text([M4SH-SANITIZE], [
AS_REQUIRE([_AS_UNSET_PREPARE])dnl
if test "x$CONFIG_SHELL" = x; then
  AS_IF([_AS_RUN([_AS_DETECT_REQUIRED_BODY]) 2>/dev/null],
        [as_have_required=yes],
	[as_have_required=no])
  AS_IF([test $as_have_required = yes && dnl
	 _AS_RUN([_AS_DETECT_SUGGESTED_BODY]) 2> /dev/null],
    [],
    [as_candidate_shells=
    _AS_PATH_WALK([/bin$PATH_SEPARATOR/usr/bin$PATH_SEPARATOR$PATH],
      [case $as_dir in
	 /*)
	   for as_base in sh bash ksh sh5; do
	     as_candidate_shells="$as_candidate_shells $as_dir/$as_base"
	   done;;
       esac])

      for as_shell in $as_candidate_shells $SHELL; do
	 # Try only shells that exist, to save several forks.
	 AS_IF([{ test -f "$as_shell" || test -f "$as_shell.exe"; } &&
		_AS_RUN([_AS_DETECT_REQUIRED_BODY],
                        [("$as_shell") 2> /dev/null])],
	       [CONFIG_SHELL=$as_shell
	       as_have_required=yes
	       AS_IF([_AS_RUN([_AS_DETECT_SUGGESTED_BODY], ["$as_shell" 2> /dev/null])],
		     [break])])
      done

      AS_IF([test "x$CONFIG_SHELL" != x],
        [for as_var in BASH_ENV ENV
        do ($as_unset $as_var) >/dev/null 2>&1 && $as_unset $as_var
        done
        export CONFIG_SHELL
        exec "$CONFIG_SHELL" "$as_myself" ${1+"$[@]"}])

    AS_IF([test $as_have_required = no],
      [echo This script requires a shell more modern than all the
      echo shells that I found on your system.  Please install a
      echo modern shell, or manually run the script under such a
      echo shell if you do have one.
      AS_EXIT(1)])
    ])
fi
])])])# _AS_DETECT_BETTER_SHELL


# _AS_SHELL_FN_WORK
# -----------------
# This is a spy to detect "in the wild" shells that do not support shell
# functions correctly.  It is based on the m4sh.at Autotest testcases.
m4_define([_AS_SHELL_FN_WORK],
[as_func_return () {
  (exit [$]1)
}
as_func_success () {
  as_func_return 0
}
as_func_failure () {
  as_func_return 1
}
as_func_ret_success () {
  return 0
}
as_func_ret_failure () {
  return 1
}

exitcode=0
AS_IF([as_func_success], [],
  [exitcode=1
  echo as_func_success failed.])
AS_IF([as_func_failure],
  [exitcode=1
  echo as_func_failure succeeded.])
AS_IF([as_func_ret_success], [],
  [exitcode=1
  echo as_func_ret_success failed.])
AS_IF([as_func_ret_failure],
  [exitcode=1
  echo as_func_ret_failure succeeded.])
AS_IF([( set x; as_func_ret_success y && test x = "[$]1" )], [],
  [exitcode=1
  echo positional parameters were not saved.])
test $exitcode = 0[]dnl
])# _AS_SHELL_FN_WORK


# AS_COPYRIGHT(TEXT)
# ------------------
# Emit TEXT, a copyright notice, as a shell comment near the top of the
# script.  TEXT is evaluated once; to accomplish that, we do not prepend
# `# ' but `@%:@ '.
m4_define([AS_COPYRIGHT],
[m4_divert_text([HEADER-COPYRIGHT],
[m4_bpatsubst([
$1], [^], [@%:@ ])])])


# AS_SHELL_SANITIZE
# -----------------
m4_defun([AS_SHELL_SANITIZE],
[## --------------------- ##
## M4sh Initialization.  ##
## --------------------- ##

AS_BOURNE_COMPATIBLE

# PATH needs CR
_AS_CR_PREPARE
_AS_PATH_SEPARATOR_PREPARE
_AS_UNSET_PREPARE

# IFS
# We need space, tab and new line, in precisely that order.  Quoting is
# there to prevent editors from complaining about space-tab.
# (If _AS_PATH_WALK were called with IFS unset, it would disable word
# splitting by setting IFS to empty value.)
as_nl='
'
IFS=" ""	$as_nl"

# Find who we are.  Look in the path if we contain no directory separator.
case $[0] in
  *[[\\/]]* ) as_myself=$[0] ;;
  *) _AS_PATH_WALK([],
		   [test -r "$as_dir/$[0]" && as_myself=$as_dir/$[0] && break])
     ;;
esac
# We did not find ourselves, most probably we were run as `sh COMMAND'
# in which case we are not to be found in the path.
if test "x$as_myself" = x; then
  as_myself=$[0]
fi
if test ! -f "$as_myself"; then
  echo "$as_myself: error: cannot find myself; rerun with an absolute file name" >&2
  AS_EXIT
fi

# Work around bugs in pre-3.0 UWIN ksh.
for as_var in ENV MAIL MAILPATH
do ($as_unset $as_var) >/dev/null 2>&1 && $as_unset $as_var
done
PS1='$ '
PS2='> '
PS4='+ '

# NLS nuisances.
for as_var in \
  LANG LANGUAGE LC_ADDRESS LC_ALL LC_COLLATE LC_CTYPE LC_IDENTIFICATION \
  LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER \
  LC_TELEPHONE LC_TIME
do
  if (set +x; test -z "`(eval $as_var=C; export $as_var) 2>&1`"); then
    eval $as_var=C; export $as_var
  else
    ($as_unset $as_var) >/dev/null 2>&1 && $as_unset $as_var
  fi
done

# Required to use basename.
_AS_EXPR_PREPARE
_AS_BASENAME_PREPARE

# Name of the executable.
as_me=`AS_BASENAME("$[0]")`

# CDPATH.
$as_unset CDPATH
])# AS_SHELL_SANITIZE


# _AS_PREPARE
# -----------
# This macro has a very special status.  Normal use of M4sh relies
# heavily on AS_REQUIRE, so that needed initializations (such as
# _AS_TEST_PREPARE) are performed on need, not on demand.  But
# Autoconf is the first client of M4sh, and for two reasons: configure
# and config.status.  Relying on AS_REQUIRE is of course fine for
# configure, but fails for config.status (which is created by
# configure).  So we need a means to force the inclusion of the
# various _AS_PREPARE_* on top of config.status.  That's basically why
# there are so many _AS_PREPARE_* below, and that's also why it is
# important not to forget some: config.status needs them.
m4_defun([_AS_PREPARE],
[_AS_LINENO_PREPARE

_AS_DIRNAME_PREPARE
_AS_ECHO_N_PREPARE
_AS_EXPR_PREPARE
_AS_LN_S_PREPARE
_AS_MKDIR_P_PREPARE
_AS_TEST_PREPARE
_AS_TR_CPP_PREPARE
_AS_TR_SH_PREPARE
])


# AS_PREPARE
# ----------
# Output all the M4sh possible initialization into the initialization
# diversion.
m4_defun([AS_PREPARE],
[m4_divert_text([M4SH-INIT], [_AS_PREPARE])])


## ----------------------------- ##
## 2. Wrappers around builtins.  ##
## ----------------------------- ##

# This section is lexicographically sorted.


# AS_CASE(WORD, [PATTERN1], [IF-MATCHED1]...[DEFAULT])
# ----------------------------------------------------
# Expand into
# | case WORD in
# | PATTERN1) IF-MATCHED1 ;;
# | ...
# | *) DEFAULT ;;
# | esac
m4_define([_AS_CASE],
[m4_if([$#], 0, [m4_fatal([$0: too few arguments: $#])],
       [$#], 1, [  *) $1 ;;],
       [$#], 2, [  $1) m4_default([$2], [:]) ;;],
       [  $1) m4_default([$2], [:]) ;;
$0(m4_shiftn(2, $@))])dnl
])
m4_defun([AS_CASE],
[m4_ifval([$2$3],
[case $1 in
_AS_CASE(m4_shift($@))
esac
])dnl
])# AS_CASE


# AS_EXIT([EXIT-CODE = 1])
# ------------------------
# Exit and set exit code to EXIT-CODE in the way that it's seen
# within "trap 0".
#
# We cannot simply use "exit N" because some shells (zsh and Solaris sh)
# will not set $? to N while running the code set by "trap 0"
# So we set $? by executing "exit N" in the subshell and then exit.
# Other shells don't use `$?' as default for `exit', hence just repeating
# the exit value can only help improving portability.
m4_define([AS_EXIT],
[{ (exit m4_default([$1], 1)); exit m4_default([$1], 1); }])


# AS_IF(TEST1, [IF-TRUE1]...[IF-FALSE])
# -------------------------------------
# Expand into
# | if TEST1; then
# |   IF-TRUE1
# | elif TEST2; then
# |   IF-TRUE2
# [...]
# | else
# |   IF-FALSE
# | fi
# with simplifications if IF-TRUE1 and/or IF-FALSE is empty.
#
m4_define([_AS_IF],
[m4_ifval([$2$3],
[elif $1; then
  m4_default([$2], [:])
m4_ifval([$3], [$0(m4_shiftn(2, $@))])],
[m4_ifvaln([$1],
[else
  $1])dnl
])dnl
])# _AS_IF
m4_defun([AS_IF],
[m4_ifval([$2$3],
[if $1; then
  m4_default([$2], [:])
m4_ifval([$3], [_$0(m4_shiftn(2, $@))])[]dnl
fi
])dnl
])# AS_IF


# _AS_UNSET_PREPARE
# -----------------
# AS_UNSET depends upon $as_unset: compute it.
# Use MAIL to trigger a bug in Bash 2.01;
# the "|| exit" suppresses the resulting "Segmentation fault" message.
# Avoid 'if ((', as that triggers a bug in pdksh 5.2.14.
m4_defun([_AS_UNSET_PREPARE],
[# Support unset when possible.
if ( (MAIL=60; unset MAIL) || exit) >/dev/null 2>&1; then
  as_unset=unset
else
  as_unset=false
fi
])


# AS_UNSET(VAR, [VALUE-IF-UNSET-NOT-SUPPORTED = `'])
# --------------------------------------------------
# Try to unset the env VAR, otherwise set it to
# VALUE-IF-UNSET-NOT-SUPPORTED.  `as_unset' must have been computed.
m4_defun([AS_UNSET],
[AS_REQUIRE([_AS_UNSET_PREPARE])dnl
$as_unset $1 || test "${$1+set}" != set || { $1=$2; export $1; }])






## ------------------------------------------ ##
## 3. Error and warnings at the shell level.  ##
## ------------------------------------------ ##

# If AS_MESSAGE_LOG_FD is defined, shell messages are duplicated there
# too.


# AS_ESCAPE(STRING, [CHARS = $"`\])
# ---------------------------------
# Escape the CHARS in STRING.
m4_define([AS_ESCAPE],
[m4_bpatsubst([$1],
	     m4_dquote(m4_default([$2], [\"$`])),
	     [\\\&])])


# _AS_QUOTE_IFELSE(STRING, IF-MODERN-QUOTATION, IF-OLD-QUOTATION)
# ---------------------------------------------------------------
# Compatibility glue between the old AS_MSG suite which did not
# quote anything, and the modern suite which quotes the quotes.
# If STRING contains `\\' or `\$', it's modern.
# If STRING contains `\"' or `\`', it's old.
# Otherwise it's modern.
# We use two quotes in the pattern to keep highlighting tools at peace.
m4_define([_AS_QUOTE_IFELSE],
[m4_bmatch([$1],
	  [\\[\\$]], [$2],
	  [\\[`""]], [$3],
	  [$2])])


# _AS_QUOTE(STRING, [CHARS = `"])
# -------------------------------
# If there are quoted (via backslash) backquotes do nothing, else
# backslash all the quotes.
m4_define([_AS_QUOTE],
[_AS_QUOTE_IFELSE([$1],
		  [AS_ESCAPE([$1], m4_default([$2], [`""]))],
		  [m4_warn([obsolete],
	   [back quotes and double quotes must not be escaped in: $1])dnl
$1])])


# _AS_ECHO_UNQUOTED(STRING, [FD = AS_MESSAGE_FD])
# -----------------------------------------------
# Perform shell expansions on STRING and echo the string to FD.
m4_define([_AS_ECHO_UNQUOTED],
[echo "$1" >&m4_default([$2], [AS_MESSAGE_FD])])


# _AS_ECHO(STRING, [FD = AS_MESSAGE_FD])
# --------------------------------------
# Protect STRING from backquote expansion, echo the result to FD.
m4_define([_AS_ECHO],
[_AS_ECHO_UNQUOTED([_AS_QUOTE([$1])], [$2])])


# _AS_ECHO_LOG(STRING)
# --------------------
# Log the string to AS_MESSAGE_LOG_FD.
m4_define([_AS_ECHO_LOG],
[_AS_ECHO([$as_me:$LINENO: $1], [AS_MESSAGE_LOG_FD])])


# _AS_ECHO_N_PREPARE
# ------------------
# Check whether to use -n, \c, or newline-tab to separate
# checking messages from result messages.
# Don't try to cache, since the results of this macro are needed to
# display the checking message.  In addition, caching something used once
# has little interest.
# Idea borrowed from dist 3.0.  Use `*c*,', not `*c,' because if `\c'
# failed there is also a newline to match.
m4_defun([_AS_ECHO_N_PREPARE],
[ECHO_C= ECHO_N= ECHO_T=
case `echo -n x` in
-n*)
  case `echo 'x\c'` in
  *c*) ECHO_T='	';;	# ECHO_T is single tab character.
  *)   ECHO_C='\c';;
  esac;;
*)
  ECHO_N='-n';;
esac
])# _AS_ECHO_N_PREPARE


# _AS_ECHO_N(STRING, [FD = AS_MESSAGE_FD])
# ----------------------------------------
# Same as _AS_ECHO, but echo doesn't return to a new line.
m4_define([_AS_ECHO_N],
[AS_REQUIRE([_AS_ECHO_N_PREPARE])dnl
echo $ECHO_N "_AS_QUOTE([$1])$ECHO_C" >&m4_default([$2],
						    [AS_MESSAGE_FD])])


# AS_MESSAGE(STRING, [FD = AS_MESSAGE_FD])
# ----------------------------------------
m4_define([AS_MESSAGE],
[m4_ifset([AS_MESSAGE_LOG_FD],
	  [{ _AS_ECHO_LOG([$1])
_AS_ECHO([$as_me: $1], [$2]);}],
	  [_AS_ECHO([$as_me: $1], [$2])])[]dnl
])


# AS_WARN(PROBLEM)
# ----------------
m4_define([AS_WARN],
[AS_MESSAGE([WARNING: $1], [2])])# AS_WARN


# AS_ERROR(ERROR, [EXIT-STATUS = 1])
# ----------------------------------
m4_define([AS_ERROR],
[{ AS_MESSAGE([error: $1], [2])
   AS_EXIT([$2]); }[]dnl
])# AS_ERROR



## -------------------------------------- ##
## 4. Portable versions of common tools.  ##
## -------------------------------------- ##

# This section is lexicographically sorted.


# AS_BASENAME(FILE-NAME)
# ----------------------
# Simulate the command 'basename FILE-NAME'.  Not all systems have basename.
# Also see the comments for AS_DIRNAME.

m4_defun([_AS_BASENAME_EXPR],
[AS_REQUIRE([_AS_EXPR_PREPARE])dnl
$as_expr X/[]$1 : '.*/\([[^/][^/]*]\)/*$' \| \
	 X[]$1 : 'X\(//\)$' \| \
	 X[]$1 : 'X\(/\)' \| .])

m4_defun([_AS_BASENAME_SED],
[echo X/[]$1 |
    sed ['/^.*\/\([^/][^/]*\)\/*$/{
	    s//\1/
	    q
	  }
	  /^X\/\(\/\/\)$/{
	    s//\1/
	    q
	  }
	  /^X\/\(\/\).*/{
	    s//\1/
	    q
	  }
	  s/.*/./; q']])

m4_defun([AS_BASENAME],
[AS_REQUIRE([_$0_PREPARE])dnl
$as_basename -- $1 ||
_AS_BASENAME_EXPR([$1]) 2>/dev/null ||
_AS_BASENAME_SED([$1])])


# _AS_BASENAME_PREPARE
# --------------------
# Avoid Solaris 9 /usr/ucb/basename, as `basename /' outputs an empty line.
# Also, traditional basename mishandles --.
m4_defun([_AS_BASENAME_PREPARE],
[if (basename -- /) >/dev/null 2>&1 && test "X`basename -- / 2>&1`" = "X/"; then
  as_basename=basename
else
  as_basename=false
fi
])# _AS_BASENAME_PREPARE


# AS_DIRNAME(FILE-NAME)
# ---------------------
# Simulate the command 'dirname FILE-NAME'.  Not all systems have dirname.
# This macro must be usable from inside ` `.
#
# Prefer expr to echo|sed, since expr is usually faster and it handles
# backslashes and newlines correctly.  However, older expr
# implementations (e.g. SunOS 4 expr and Solaris 8 /usr/ucb/expr) have
# a silly length limit that causes expr to fail if the matched
# substring is longer than 120 bytes.  So fall back on echo|sed if
# expr fails.
m4_defun([_AS_DIRNAME_EXPR],
[AS_REQUIRE([_AS_EXPR_PREPARE])dnl
$as_expr X[]$1 : 'X\(.*[[^/]]\)//*[[^/][^/]]*/*$' \| \
	 X[]$1 : 'X\(//\)[[^/]]' \| \
	 X[]$1 : 'X\(//\)$' \| \
	 X[]$1 : 'X\(/\)' \| .])

m4_defun([_AS_DIRNAME_SED],
[echo X[]$1 |
    sed ['/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
	    s//\1/
	    q
	  }
	  /^X\(\/\/\)[^/].*/{
	    s//\1/
	    q
	  }
	  /^X\(\/\/\)$/{
	    s//\1/
	    q
	  }
	  /^X\(\/\).*/{
	    s//\1/
	    q
	  }
	  s/.*/./; q']])

m4_defun([AS_DIRNAME],
[AS_REQUIRE([_$0_PREPARE])dnl
$as_dirname -- $1 ||
_AS_DIRNAME_EXPR([$1]) 2>/dev/null ||
_AS_DIRNAME_SED([$1])])


# _AS_DIRNAME_PREPARE
# --------------------
m4_defun([_AS_DIRNAME_PREPARE],
[if (as_dir=`dirname -- /` && test "X$as_dir" = X/) >/dev/null 2>&1; then
  as_dirname=dirname
else
  as_dirname=false
fi
])# _AS_DIRNAME_PREPARE


# AS_TEST_X
# ---------
# Check whether a file has executable or search permissions.
m4_defun([AS_TEST_X],
[AS_REQUIRE([_AS_TEST_PREPARE])dnl
$as_test_x $1[]dnl
])# AS_TEST_X


# AS_EXECUTABLE_P
# ---------------
# Check whether a file is a regular file that has executable permissions.
m4_defun([AS_EXECUTABLE_P],
[AS_REQUIRE([_AS_TEST_PREPARE])dnl
{ test -f $1 && AS_TEST_X([$1]); }dnl
])# AS_EXECUTABLE_P


# _AS_EXPR_PREPARE
# ----------------
# QNX 4.25 expr computes and issue the right result but exits with failure.
# Tru64 expr mishandles leading zeros in numeric strings.
# Detect these flaws.
m4_defun([_AS_EXPR_PREPARE],
[if expr a : '\(a\)' >/dev/null 2>&1 &&
   test "X`expr 00001 : '.*\(...\)'`" = X001; then
  as_expr=expr
else
  as_expr=false
fi
])# _AS_EXPR_PREPARE


# _AS_LINENO_WORKS
# ---------------
# Succeed if the currently executing shell supports LINENO.
# This macro does not expand to a single shell command, so be careful
# when using it.  Surrounding the body of this macro with {} would
# cause "bash -c '_ASLINENO_WORKS'" to fail (with Bash 2.05, anyway),
# but that bug is irrelevant to our use of LINENO.
m4_define([_AS_LINENO_WORKS],
[
  as_lineno_1=$LINENO
  as_lineno_2=$LINENO
  test "x$as_lineno_1" != "x$as_lineno_2" &&
  test "x`expr $as_lineno_1 + 1`" = "x$as_lineno_2"])


# _AS_LINENO_PREPARE
# ------------------
# If LINENO is not supported by the shell, produce a version of this
# script where LINENO is hard coded.
# Comparing LINENO against _oline_ is not a good solution, since in
# the case of embedded executables (such as config.status within
# configure) you'd compare LINENO wrt config.status vs. _oline_ wrt
# configure.
m4_define([_AS_LINENO_PREPARE],
[AS_REQUIRE([_AS_CR_PREPARE])dnl
_AS_DETECT_SUGGESTED([_AS_LINENO_WORKS])
_AS_LINENO_WORKS || {

  # Create $as_me.lineno as a copy of $as_myself, but with $LINENO
  # uniformly replaced by the line number.  The first 'sed' inserts a
  # line-number line after each line using $LINENO; the second 'sed'
  # does the real work.  The second script uses 'N' to pair each
  # line-number line with the line containing $LINENO, and appends
  # trailing '-' during substitution so that $LINENO is not a special
  # case at line end.
  # (Raja R Harinath suggested sed '=', and Paul Eggert wrote the
  # scripts with optimization help from Paolo Bonzini.  Blame Lee
  # E. McMahon (1931-1989) for sed's syntax.  :-)
  sed -n '
    p
    /[[$]]LINENO/=
  ' <$as_myself |
    sed '
      s/[[$]]LINENO.*/&-/
      t lineno
      b
      :lineno
      N
      :loop
      s/[[$]]LINENO\([[^'$as_cr_alnum'_]].*\n\)\(.*\)/\2\1\2/
      t loop
      s/-\n.*//
    ' >$as_me.lineno &&
  chmod +x "$as_me.lineno" ||
    AS_ERROR([cannot create $as_me.lineno; rerun with a POSIX shell])

  # Don't try to exec as it changes $[0], causing all sort of problems
  # (the dirname of $[0] is not the place where we might find the
  # original and so on.  Autoconf is especially sensitive to this).
  . "./$as_me.lineno"
  # Exit status is that of the last command.
  exit
}
])# _AS_LINENO_PREPARE


# _AS_LN_S_PREPARE
# ----------------
# Don't use conftest.sym to avoid file name issues on DJGPP, where this
# would yield conftest.sym.exe for DJGPP < 2.04.  And don't use `conftest'
# as base name to avoid prohibiting concurrency (e.g., concurrent
# config.statuses).
m4_defun([_AS_LN_S_PREPARE],
[rm -f conf$$ conf$$.exe conf$$.file
if test -d conf$$.dir; then
  rm -f conf$$.dir/conf$$.file
else
  rm -f conf$$.dir
  mkdir conf$$.dir
fi
echo >conf$$.file
if ln -s conf$$.file conf$$ 2>/dev/null; then
  as_ln_s='ln -s'
  # ... but there are two gotchas:
  # 1) On MSYS, both `ln -s file dir' and `ln file dir' fail.
  # 2) DJGPP < 2.04 has no symlinks; `ln -s' creates a wrapper executable.
  # In both cases, we have to default to `cp -p'.
  ln -s conf$$.file conf$$.dir 2>/dev/null && test ! -f conf$$.exe ||
    as_ln_s='cp -p'
elif ln conf$$.file conf$$ 2>/dev/null; then
  as_ln_s=ln
else
  as_ln_s='cp -p'
fi
rm -f conf$$ conf$$.exe conf$$.dir/conf$$.file conf$$.file
rmdir conf$$.dir 2>/dev/null
])# _AS_LN_S_PREPARE


# AS_LN_S(FILE, LINK)
# -------------------
# FIXME: Should we add the glue code to handle properly relative symlinks
# simulated with `ln' or `cp'?
m4_defun([AS_LN_S],
[AS_REQUIRE([_AS_LN_S_PREPARE])dnl
$as_ln_s $1 $2
])


# AS_MKDIR_P(DIR)
# ---------------
# Emulate `mkdir -p' with plain `mkdir'.
m4_define([AS_MKDIR_P],
[AS_REQUIRE([_$0_PREPARE])dnl
{ as_dir=$1
  case $as_dir in #(
  -*) as_dir=./$as_dir;;
  esac
  test -d "$as_dir" || { $as_mkdir_p && mkdir -p "$as_dir"; } || {
    as_dirs=
    while :; do
      case $as_dir in #(
      *\'*) as_qdir=`echo "$as_dir" | sed "s/'/'\\\\\\\\''/g"`;; #(
      *) as_qdir=$as_dir;;
      esac
      as_dirs="'$as_qdir' $as_dirs"
      as_dir=`AS_DIRNAME("$as_dir")`
      test -d "$as_dir" && break
    done
    test -z "$as_dirs" || eval "mkdir $as_dirs"
  } || test -d "$as_dir" || AS_ERROR([cannot create directory $as_dir]); }dnl
])# AS_MKDIR_P


# _AS_MKDIR_P_PREPARE
# -------------------
m4_defun([_AS_MKDIR_P_PREPARE],
[if mkdir -p . 2>/dev/null; then
  as_mkdir_p=:
else
  test -d ./-p && rmdir ./-p
  as_mkdir_p=false
fi
])# _AS_MKDIR_P_PREPARE


# _AS_PATH_SEPARATOR_PREPARE
# --------------------------
# Compute the path separator.
m4_defun([_AS_PATH_SEPARATOR_PREPARE],
[# The user is always right.
if test "${PATH_SEPARATOR+set}" != set; then
  echo "#! /bin/sh" >conf$$.sh
  echo  "exit 0"   >>conf$$.sh
  chmod +x conf$$.sh
  if (PATH="/nonexistent;."; conf$$.sh) >/dev/null 2>&1; then
    PATH_SEPARATOR=';'
  else
    PATH_SEPARATOR=:
  fi
  rm -f conf$$.sh
fi
])# _AS_PATH_SEPARATOR_PREPARE


# _AS_PATH_WALK([PATH = $PATH], BODY)
# -----------------------------------
# Walk through PATH running BODY for each `as_dir'.
#
# Still very private as its interface looks quite bad.
#
# `$as_dummy' forces splitting on constant user-supplied paths.
# POSIX.2 field splitting is done only on the result of word
# expansions, not on literal text.  This closes a longstanding sh security
# hole.  Optimize it away when not needed, i.e., if there are no literal
# path separators.
m4_define([_AS_PATH_WALK],
[AS_REQUIRE([_AS_PATH_SEPARATOR_PREPARE])dnl
as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
m4_bmatch([$1], [[:;]],
[as_dummy="$1"
for as_dir in $as_dummy],
[for as_dir in m4_default([$1], [$PATH])])
do
  IFS=$as_save_IFS
  test -z "$as_dir" && as_dir=.
  $2
done
IFS=$as_save_IFS
])


# AS_SET_CATFILE(VAR, DIR-NAME, FILE-NAME)
# ----------------------------------------
# Set VAR to DIR-NAME/FILE-NAME.
# Optimize the common case where $2 or $3 is '.'.
m4_define([AS_SET_CATFILE],
[case $2 in
.) $1=$3;;
*)
  case $3 in
  .) $1=$2;;
  [[\\/]]* | ?:[[\\/]]* ) $1=$3;;
  *) $1=$2/$3;;
  esac;;
esac[]dnl
])# AS_SET_CATFILE


# _AS_TEST_PREPARE
# ----------------
# Find out whether `test -x' works.  If not, prepare a substitute
# that should work well enough for most scripts.
#
# Here are some of the problems with the substitute.
# The 'ls' tests whether the owner, not the current user, can execute/search.
# The eval means '*', '?', and '[' cause inadvertent file name globbing
# after the 'eval', so jam together as many tokens as we can to minimize
# the likelihood that the inadvertent globbing will actually do anything.
# Luckily, this gorp is needed only on really ancient hosts.
#
m4_defun([_AS_TEST_PREPARE],
[if test -x / >/dev/null 2>&1; then
  as_test_x='test -x'
else
  if ls -dL / >/dev/null 2>&1; then
    as_ls_L_option=L
  else
    as_ls_L_option=
  fi
  as_test_x='
    eval sh -c '\''
      if test -d "$[]1"; then
        test -d "$[]1/.";
      else
	case $[]1 in
        -*)set "./$[]1";;
	esac;
	case `ls -ld'$as_ls_L_option' "$[]1" 2>/dev/null` in
	???[[sx]]*):;;*)false;;esac;fi
    '\'' sh
  '
fi
dnl as_executable_p is present for backward compatibility with Libtool
dnl 1.5.22, but it should go away at some point.
as_executable_p=$as_test_x
])# _AS_TEST_PREPARE




## ------------------ ##
## 5. Common idioms.  ##
## ------------------ ##

# This section is lexicographically sorted.


# AS_BOX(MESSAGE, [FRAME-CHARACTER = `-'])
# ----------------------------------------
# Output MESSAGE, a single line text, framed with FRAME-CHARACTER (which
# must not be `/').
m4_define([AS_BOX],
[AS_LITERAL_IF([$1],
	       [_AS_BOX_LITERAL($@)],
	       [_AS_BOX_INDIR($@)])])


# _AS_BOX_LITERAL(MESSAGE, [FRAME-CHARACTER = `-'])
# -------------------------------------------------
m4_define([_AS_BOX_LITERAL],
[cat <<\_ASBOX
m4_text_box($@)
_ASBOX])


# _AS_BOX_INDIR(MESSAGE, [FRAME-CHARACTER = `-'])
# -----------------------------------------------
m4_define([_AS_BOX_INDIR],
[sed 'h;s/./m4_default([$2], [-])/g;s/^.../@%:@@%:@ /;s/...$/ @%:@@%:@/;p;x;p;x' <<_ASBOX
@%:@@%:@ $1 @%:@@%:@
_ASBOX])


# AS_HELP_STRING(LHS, RHS, [COLUMN])
# ----------------------------------
#
# Format a help string so that it looks pretty when
# the user executes "script --help".  This macro takes three
# arguments, a "left hand side" (LHS), a "right hand side" (RHS), and
# the COLUMN which is a string of white spaces which leads to the
# the RHS column (default: 26 white spaces).
#
# The resulting string is suitable for use in other macros that require
# a help string (e.g. AC_ARG_WITH).
#
# Here is the sample string from the Autoconf manual (Node: External
# Software) which shows the proper spacing for help strings.
#
#    --with-readline         support fancy command line editing
#  ^ ^                       ^
#  | |                       |
#  | column 2                column 26
#  |
#  column 0
#
# A help string is made up of a "left hand side" (LHS) and a "right
# hand side" (RHS).  In the example above, the LHS is
# "--with-readline", while the RHS is "support fancy command line
# editing".
#
# If the LHS contains more than (COLUMN - 3) characters, then the LHS is
# terminated with a newline so that the RHS starts on a line of its own
# beginning with COLUMN.  In the default case, this corresponds to an
# LHS with more than 23 characters.
#
# Therefore, in the example, if the LHS were instead
# "--with-readline-blah-blah-blah", then the AS_HELP_STRING macro would
# expand into:
#
#
#    --with-readline-blah-blah-blah
#  ^ ^                       support fancy command line editing
#  | |                       ^
#  | column 2                |
#  column 0                  column 26
#
#
# m4_text_wrap hacks^Wworks around the fact that m4_format does not
# know quadrigraphs.
#
m4_define([AS_HELP_STRING],
[m4_pushdef([AS_Prefix], m4_default([$3], [                          ]))dnl
m4_pushdef([AS_Prefix_Format],
	   [  %-]m4_eval(m4_len(AS_Prefix) - 3)[s ])dnl [  %-23s ]
m4_text_wrap([$2], AS_Prefix, m4_format(AS_Prefix_Format, [$1]))dnl
m4_popdef([AS_Prefix_Format])dnl
m4_popdef([AS_Prefix])dnl
])# AS_HELP_STRING


# AS_LITERAL_IF(EXPRESSION, IF-LITERAL, IF-NOT-LITERAL)
# -----------------------------------------------------
# If EXPRESSION has shell indirections ($var or `expr`), expand
# IF-INDIR, else IF-NOT-INDIR.
# This is an *approximation*: for instance EXPRESSION = `\$' is
# definitely a literal, but will not be recognized as such.
m4_define([AS_LITERAL_IF],
[m4_bmatch(m4_quote($1), [[`$]],
	   [$3], [$2])])


# AS_TMPDIR(PREFIX, [DIRECTORY = $TMPDIR [= /tmp]])
# -------------------------------------------------
# Create as safely as possible a temporary directory in DIRECTORY
# which name is inspired by PREFIX (should be 2-4 chars max).
m4_define([AS_TMPDIR],
[# Create a (secure) tmp directory for tmp files.
m4_if([$2], [], [: ${TMPDIR=/tmp}])
{
  tmp=`(umask 077 && mktemp -d "m4_default([$2], [$TMPDIR])/$1XXXXXX") 2>/dev/null` &&
  test -n "$tmp" && test -d "$tmp"
}  ||
{
  tmp=m4_default([$2], [$TMPDIR])/$1$$-$RANDOM
  (umask 077 && mkdir "$tmp")
} ||
{
   echo "$me: cannot create a temporary directory in m4_default([$2], [$TMPDIR])" >&2
   AS_EXIT
}dnl
])# AS_TMPDIR


# AS_UNAME
# --------
# Try to describe this machine.  Meant for logs.
m4_define([AS_UNAME],
[{
cat <<_ASUNAME
m4_text_box([Platform.])

hostname = `(hostname || uname -n) 2>/dev/null | sed 1q`
uname -m = `(uname -m) 2>/dev/null || echo unknown`
uname -r = `(uname -r) 2>/dev/null || echo unknown`
uname -s = `(uname -s) 2>/dev/null || echo unknown`
uname -v = `(uname -v) 2>/dev/null || echo unknown`

/usr/bin/uname -p = `(/usr/bin/uname -p) 2>/dev/null || echo unknown`
/bin/uname -X     = `(/bin/uname -X) 2>/dev/null     || echo unknown`

/bin/arch              = `(/bin/arch) 2>/dev/null              || echo unknown`
/usr/bin/arch -k       = `(/usr/bin/arch -k) 2>/dev/null       || echo unknown`
/usr/convex/getsysinfo = `(/usr/convex/getsysinfo) 2>/dev/null || echo unknown`
/usr/bin/hostinfo      = `(/usr/bin/hostinfo) 2>/dev/null      || echo unknown`
/bin/machine           = `(/bin/machine) 2>/dev/null           || echo unknown`
/usr/bin/oslevel       = `(/usr/bin/oslevel) 2>/dev/null       || echo unknown`
/bin/universe          = `(/bin/universe) 2>/dev/null          || echo unknown`

_ASUNAME

_AS_PATH_WALK([$PATH], [echo "PATH: $as_dir"])
}])


# _AS_VERSION_COMPARE_PREPARE
# ---------------------------
# Output variables for comparing version numbers.
m4_defun([_AS_VERSION_COMPARE_PREPARE],
[[as_awk_strverscmp='
  # Use only awk features that work with 7th edition Unix awk (1978).
  # My, what an old awk you have, Mr. Solaris!
  END {
    while (length(v1) && length(v2)) {
      # Set d1 to be the next thing to compare from v1, and likewise for d2.
      # Normally this is a single character, but if v1 and v2 contain digits,
      # compare them as integers and fractions as strverscmp does.
      if (v1 ~ /^[0-9]/ && v2 ~ /^[0-9]/) {
	# Split v1 and v2 into their leading digit string components d1 and d2,
	# and advance v1 and v2 past the leading digit strings.
	for (len1 = 1; substr(v1, len1 + 1) ~ /^[0-9]/; len1++) continue
	for (len2 = 1; substr(v2, len2 + 1) ~ /^[0-9]/; len2++) continue
	d1 = substr(v1, 1, len1); v1 = substr(v1, len1 + 1)
	d2 = substr(v2, 1, len2); v2 = substr(v2, len2 + 1)
	if (d1 ~ /^0/) {
	  if (d2 ~ /^0/) {
	    # Compare two fractions.
	    while (d1 ~ /^0/ && d2 ~ /^0/) {
	      d1 = substr(d1, 2); len1--
	      d2 = substr(d2, 2); len2--
	    }
	    if (len1 != len2 && ! (len1 && len2 && substr(d1, 1, 1) == substr(d2, 1, 1))) {
	      # The two components differ in length, and the common prefix
	      # contains only leading zeros.  Consider the longer to be less.
	      d1 = -len1
	      d2 = -len2
	    } else {
	      # Otherwise, compare as strings.
	      d1 = "x" d1
	      d2 = "x" d2
	    }
	  } else {
	    # A fraction is less than an integer.
	    exit 1
	  }
	} else {
	  if (d2 ~ /^0/) {
	    # An integer is greater than a fraction.
	    exit 2
	  } else {
	    # Compare two integers.
	    d1 += 0
	    d2 += 0
	  }
	}
      } else {
	# The normal case, without worrying about digits.
	d1 = substr(v1, 1, 1); v1 = substr(v1, 2)
	d2 = substr(v2, 1, 1); v2 = substr(v2, 2)
      }
      if (d1 < d2) exit 1
      if (d1 > d2) exit 2
    }
    # Beware Solaris /usr/xgp4/bin/awk (at least through Solaris 10),
    # which mishandles some comparisons of empty strings to integers.
    if (length(v2)) exit 1
    if (length(v1)) exit 2
  }
']])# _AS_VERSION_COMPARE_PREPARE


# AS_VERSION_COMPARE(VERSION-1, VERSION-2,
#                    [ACTION-IF-LESS], [ACTION-IF-EQUAL], [ACTION-IF-GREATER])
# -----------------------------------------------------------------------------
# Compare two strings possibly containing shell variables as version strings.
m4_defun([AS_VERSION_COMPARE],
[AS_REQUIRE([_$0_PREPARE])dnl
as_arg_v1=$1
as_arg_v2=$2
dnl This usage is portable even to ancient awk,
dnl so don't worry about finding a "nice" awk version.
awk "$as_awk_strverscmp" v1="$as_arg_v1" v2="$as_arg_v2" /dev/null
case $? in
1) $3;;
0) $4;;
2) $5;;
esac[]dnl
])# _AS_VERSION_COMPARE



## ------------------------------------ ##
## Common m4/sh character translation.  ##
## ------------------------------------ ##

# The point of this section is to provide high level macros comparable
# to m4's `translit' primitive, but m4/sh polymorphic.
# Transliteration of literal strings should be handled by m4, while
# shell variables' content will be translated at runtime (tr or sed).


# _AS_CR_PREPARE
# --------------
# Output variables defining common character ranges.
# See m4_cr_letters etc.
m4_defun([_AS_CR_PREPARE],
[# Avoid depending upon Character Ranges.
as_cr_letters='abcdefghijklmnopqrstuvwxyz'
as_cr_LETTERS='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
as_cr_Letters=$as_cr_letters$as_cr_LETTERS
as_cr_digits='0123456789'
as_cr_alnum=$as_cr_Letters$as_cr_digits
])


# _AS_TR_SH_PREPARE
# -----------------
m4_defun([_AS_TR_SH_PREPARE],
[AS_REQUIRE([_AS_CR_PREPARE])dnl
# Sed expression to map a string onto a valid variable name.
as_tr_sh="eval sed 'y%*+%pp%;s%[[^_$as_cr_alnum]]%_%g'"
])


# AS_TR_SH(EXPRESSION)
# --------------------
# Transform EXPRESSION into a valid shell variable name.
# sh/m4 polymorphic.
# Be sure to update the definition of `$as_tr_sh' if you change this.
m4_defun([AS_TR_SH],
[AS_REQUIRE([_$0_PREPARE])dnl
AS_LITERAL_IF([$1],
	      [m4_bpatsubst(m4_translit([[$1]], [*+], [pp]),
			    [[^a-zA-Z0-9_]], [_])],
	      [`echo "$1" | $as_tr_sh`])])


# _AS_TR_CPP_PREPARE
# ------------------
m4_defun([_AS_TR_CPP_PREPARE],
[AS_REQUIRE([_AS_CR_PREPARE])dnl
# Sed expression to map a string onto a valid CPP name.
as_tr_cpp="eval sed 'y%*$as_cr_letters%P$as_cr_LETTERS%;s%[[^_$as_cr_alnum]]%_%g'"
])


# AS_TR_CPP(EXPRESSION)
# ---------------------
# Map EXPRESSION to an upper case string which is valid as rhs for a
# `#define'.  sh/m4 polymorphic.  Be sure to update the definition
# of `$as_tr_cpp' if you change this.
m4_defun([AS_TR_CPP],
[AS_REQUIRE([_$0_PREPARE])dnl
AS_LITERAL_IF([$1],
	      [m4_bpatsubst(m4_translit([[$1]],
					[*abcdefghijklmnopqrstuvwxyz],
					[PABCDEFGHIJKLMNOPQRSTUVWXYZ]),
			   [[^A-Z0-9_]], [_])],
	      [`echo "$1" | $as_tr_cpp`])])


# _AS_TR_PREPARE
# --------------
m4_defun([_AS_TR_PREPARE],
[AS_REQUIRE([_AS_TR_SH_PREPARE])dnl
AS_REQUIRE([_AS_TR_CPP_PREPARE])dnl
])




## --------------------------------------------------- ##
## Common m4/sh handling of variables (indirections).  ##
## --------------------------------------------------- ##


# The purpose of this section is to provide a uniform API for
# reading/setting sh variables with or without indirection.
# Typically, one can write
#   AS_VAR_SET(var, val)
# or
#   AS_VAR_SET(as_$var, val)
# and expect the right thing to happen.


# AS_VAR_SET(VARIABLE, VALUE)
# ---------------------------
# Set the VALUE of the shell VARIABLE.
# If the variable contains indirections (e.g. `ac_cv_func_$ac_func')
# perform whenever possible at m4 level, otherwise sh level.
m4_define([AS_VAR_SET],
[AS_LITERAL_IF([$1],
	       [$1=$2],
	       [eval "$1=AS_ESCAPE([$2])"])])


# AS_VAR_GET(VARIABLE)
# --------------------
# Get the value of the shell VARIABLE.
# Evaluates to $VARIABLE if there are no indirection in VARIABLE,
# else into the appropriate `eval' sequence.
# FIXME: This mishandles values that end in newlines, or have backslashes,
# or are '-n'.  Fixing this will require changing the API.
m4_define([AS_VAR_GET],
[AS_LITERAL_IF([$1],
	       [$$1],
	       [`eval echo '${'m4_bpatsubst($1, [[\\`]], [\\\&])'}'`])])


# AS_VAR_TEST_SET(VARIABLE)
# -------------------------
# Expands into the `test' expression which is true if VARIABLE
# is set.  Polymorphic.  Should be dnl'ed.
m4_define([AS_VAR_TEST_SET],
[AS_LITERAL_IF([$1],
	       [test "${$1+set}" = set],
	       [{ as_var=$1; eval "test \"\${$as_var+set}\" = set"; }])])


# AS_VAR_SET_IF(VARIABLE, IF-TRUE, IF-FALSE)
# ------------------------------------------
# Implement a shell `if-then-else' depending whether VARIABLE is set
# or not.  Polymorphic.
m4_define([AS_VAR_SET_IF],
[AS_IF([AS_VAR_TEST_SET([$1])], [$2], [$3])])


# AS_VAR_PUSHDEF and AS_VAR_POPDEF
# --------------------------------
#

# Sometimes we may have to handle literals (e.g. `stdlib.h'), while at
# other moments, the same code may have to get the value from a
# variable (e.g., `ac_header').  To have a uniform handling of both
# cases, when a new value is about to be processed, declare a local
# variable, e.g.:
#
#   AS_VAR_PUSHDEF([header], [ac_cv_header_$1])
#
# and then in the body of the macro, use `header' as is.  It is of
# first importance to use `AS_VAR_*' to access this variable.  Don't
# quote its name: it must be used right away by m4.
#
# If the value `$1' was a literal (e.g. `stdlib.h'), then `header' is
# in fact the value `ac_cv_header_stdlib_h'.  If `$1' was indirect,
# then `header's value in m4 is in fact `$ac_header', the shell
# variable that holds all of the magic to get the expansion right.
#
# At the end of the block, free the variable with
#
#   AS_VAR_POPDEF([header])


# AS_VAR_PUSHDEF(VARNAME, VALUE)
# ------------------------------
# Define the m4 macro VARNAME to an accessor to the shell variable
# named VALUE.  VALUE does not need to be a valid shell variable name:
# the transliteration is handled here.  To be dnl'ed.
m4_define([AS_VAR_PUSHDEF],
[AS_LITERAL_IF([$2],
	       [m4_pushdef([$1], [AS_TR_SH($2)])],
	       [as_$1=AS_TR_SH($2)
m4_pushdef([$1], [$as_[$1]])])])


# AS_VAR_POPDEF(VARNAME)
# ----------------------
# Free the shell variable accessor VARNAME.  To be dnl'ed.
m4_define([AS_VAR_POPDEF],
[m4_popdef([$1])])


## ----------------- ##
## Setting M4sh up.  ##
## ----------------- ##


# _AS_SHELL_FN_SPY
# ----------------
# This temporary macro checks "in the wild" for shells that do
# not support shell functions.
m4_define([_AS_SHELL_FN_SPY],
[_AS_DETECT_SUGGESTED([_AS_SHELL_FN_WORK])
_AS_RUN([_AS_SHELL_FN_WORK]) || {
  echo No shell found that supports shell functions.
  echo Please tell autoconf@gnu.org about your system,
  echo including any error possibly output before this
  echo message
}
])


# AS_INIT
# -------
# Initialize m4sh.
m4_define([AS_INIT],
[m4_init

# Forbidden tokens and exceptions.
m4_pattern_forbid([^_?AS_])

# Bangshe and minimal initialization.
m4_divert_text([BINSH], [@%:@! /bin/sh])
m4_divert_text([M4SH-SANITIZE], [AS_SHELL_SANITIZE])
AS_REQUIRE([_AS_SHELL_FN_SPY])

# Let's go!
m4_divert_pop([KILL])[]dnl
m4_divert_push([BODY])[]dnl
])
