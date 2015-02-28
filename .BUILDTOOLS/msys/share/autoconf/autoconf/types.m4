# This file is part of Autoconf.			-*- Autoconf -*-
# Type related macros: existence, sizeof, and structure members.
#
# Copyright (C) 2000, 2001, 2002, 2004, 2005, 2006 Free Software
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
# Written by David MacKenzie, with help from
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.


## ---------------- ##
## Type existence.  ##
## ---------------- ##

# ---------------- #
# General checks.  #
# ---------------- #

# Up to 2.13 included, Autoconf used to provide the macro
#
#    AC_CHECK_TYPE(TYPE, DEFAULT)
#
# Since, it provides another version which fits better with the other
# AC_CHECK_ families:
#
#    AC_CHECK_TYPE(TYPE,
#		   [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		   [INCLUDES = DEFAULT-INCLUDES])
#
# In order to provide backward compatibility, the new scheme is
# implemented as _AC_CHECK_TYPE_NEW, the old scheme as _AC_CHECK_TYPE_OLD,
# and AC_CHECK_TYPE branches to one or the other, depending upon its
# arguments.



# _AC_CHECK_TYPE_NEW(TYPE,
#		     [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		     [INCLUDES = DEFAULT-INCLUDES])
# ------------------------------------------------------------
# Check whether the type TYPE is supported by the system, maybe via the
# the provided includes.  This macro implements the former task of
# AC_CHECK_TYPE, with one big difference though: AC_CHECK_TYPE was
# grepping in the headers, which, BTW, led to many problems until the
# extended regular expression was correct and did not given false positives.
# It turned out there are even portability issues with egrep...
#
# The most obvious way to check for a TYPE is just to compile a variable
# definition:
#
#	  TYPE my_var;
#
# Unfortunately this does not work for const qualified types in C++,
# where you need an initializer.  So you think of
#
#	  TYPE my_var = (TYPE) 0;
#
# Unfortunately, again, this is not valid for some C++ classes.
#
# Then you look for another scheme.  For instance you think of declaring
# a function which uses a parameter of type TYPE:
#
#	  int foo (TYPE param);
#
# but of course you soon realize this does not make it with K&R
# compilers.  And by no ways you want to
#
#	  int foo (param)
#	    TYPE param
#	  { ; }
#
# since this time it's C++ who is not happy.
#
# Don't even think of the return type of a function, since K&R cries
# there too.  So you start thinking of declaring a *pointer* to this TYPE:
#
#	  TYPE *p;
#
# but you know fairly well that this is legal in C for aggregates which
# are unknown (TYPE = struct does-not-exist).
#
# Then you think of using sizeof to make sure the TYPE is really
# defined:
#
#	  sizeof (TYPE);
#
# But this succeeds if TYPE is a variable: you get the size of the
# variable's type!!!
#
# This time you tell yourself the last two options *together* will make
# it.  And indeed this is the solution invented by Alexandre Oliva.
#
# Also note that we use
#
#	  if (sizeof (TYPE))
#
# to `read' sizeof (to avoid warnings), while not depending on its type
# (not necessarily size_t etc.).  Equally, instead of defining an unused
# variable, we just use a cast to avoid warnings from the compiler.
# Suggested by Paul Eggert.
#
# Now, the next issue is that C++ disallows defining types inside casts
# and inside `sizeof()', but we would like to allow unnamed structs, for
# use inside AC_CHECK_SIZEOF, for example.  So we create a typedef of the
# new type.  Note that this does not obviate the need for the other
# constructs in general.
m4_define([_AC_CHECK_TYPE_NEW],
[AS_VAR_PUSHDEF([ac_Type], [ac_cv_type_$1])dnl
AC_CACHE_CHECK([for $1], [ac_Type],
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT([$4])
typedef $1 ac__type_new_;],
[if ((ac__type_new_ *) 0)
  return 0;
if (sizeof (ac__type_new_))
  return 0;])],
		   [AS_VAR_SET([ac_Type], [yes])],
		   [AS_VAR_SET([ac_Type], [no])])])
AS_IF([test AS_VAR_GET([ac_Type]) = yes], [$2], [$3])[]dnl
AS_VAR_POPDEF([ac_Type])dnl
])# _AC_CHECK_TYPE_NEW


# AC_CHECK_TYPES(TYPES,
#		 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		 [INCLUDES = DEFAULT-INCLUDES])
# --------------------------------------------------------
# TYPES is an m4 list.  There are no ambiguities here, we mean the newer
# AC_CHECK_TYPE.
AC_DEFUN([AC_CHECK_TYPES],
[m4_foreach([AC_Type], [$1],
  [_AC_CHECK_TYPE_NEW(AC_Type,
		      [AC_DEFINE_UNQUOTED(AS_TR_CPP(HAVE_[]AC_Type), 1,
					  [Define to 1 if the system has the
					   type `]AC_Type['.])
$2],
		      [$3],
		      [$4])])])


# _AC_CHECK_TYPE_OLD(TYPE, DEFAULT)
# ---------------------------------
# FIXME: This is an extremely badly chosen name, since this
# macro actually performs an AC_REPLACE_TYPE.  Some day we
# have to clean this up.
m4_define([_AC_CHECK_TYPE_OLD],
[_AC_CHECK_TYPE_NEW([$1],,
   [AC_DEFINE_UNQUOTED([$1], [$2],
		       [Define to `$2' if <sys/types.h> does not define.])])dnl
])# _AC_CHECK_TYPE_OLD


# _AC_CHECK_TYPE_REPLACEMENT_TYPE_P(STRING)
# -----------------------------------------
# Return `1' if STRING seems to be a builtin C/C++ type, i.e., if it
# starts with `_Bool', `bool', `char', `double', `float', `int',
# `long', `short', `signed', or `unsigned' followed by characters
# that are defining types.
# Because many people have used `off_t' and `size_t' too, they are added
# for better common-useward backward compatibility.
m4_define([_AC_CHECK_TYPE_REPLACEMENT_TYPE_P],
[m4_bmatch([$1],
	  [^\(_Bool\|bool\|char\|double\|float\|int\|long\|short\|\(un\)?signed\|[_a-zA-Z][_a-zA-Z0-9]*_t\)[][_a-zA-Z0-9() *]*$],
	  1, 0)dnl
])# _AC_CHECK_TYPE_REPLACEMENT_TYPE_P


# _AC_CHECK_TYPE_MAYBE_TYPE_P(STRING)
# -----------------------------------
# Return `1' if STRING looks like a C/C++ type.
m4_define([_AC_CHECK_TYPE_MAYBE_TYPE_P],
[m4_bmatch([$1], [^[_a-zA-Z0-9 ]+\([_a-zA-Z0-9() *]\|\[\|\]\)*$],
	  1, 0)dnl
])# _AC_CHECK_TYPE_MAYBE_TYPE_P


# AC_CHECK_TYPE(TYPE, DEFAULT)
#  or
# AC_CHECK_TYPE(TYPE,
#		[ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		[INCLUDES = DEFAULT-INCLUDES])
# -------------------------------------------------------
#
# Dispatch respectively to _AC_CHECK_TYPE_OLD or _AC_CHECK_TYPE_NEW.
# 1. More than two arguments	     => NEW
# 2. $2 seems to be replacement type => OLD
#    See _AC_CHECK_TYPE_REPLACEMENT_TYPE_P for `replacement type'.
# 3. $2 seems to be a type	     => NEW plus a warning
# 4. default			     => NEW
AC_DEFUN([AC_CHECK_TYPE],
[m4_if($#, 3,
	 [_AC_CHECK_TYPE_NEW($@)],
       $#, 4,
	 [_AC_CHECK_TYPE_NEW($@)],
       _AC_CHECK_TYPE_REPLACEMENT_TYPE_P([$2]), 1,
	 [_AC_CHECK_TYPE_OLD($@)],
       _AC_CHECK_TYPE_MAYBE_TYPE_P([$2]), 1,
	 [AC_DIAGNOSE([syntax],
		    [$0: assuming `$2' is not a type])_AC_CHECK_TYPE_NEW($@)],
       [_AC_CHECK_TYPE_NEW($@)])[]dnl
])# AC_CHECK_TYPE



# ---------------------------- #
# Types that must be checked.  #
# ---------------------------- #

AN_IDENTIFIER([ptrdiff_t], [AC_CHECK_TYPES])


# ----------------- #
# Specific checks.  #
# ----------------- #

# AC_TYPE_GETGROUPS
# -----------------
AC_DEFUN([AC_TYPE_GETGROUPS],
[AC_REQUIRE([AC_TYPE_UID_T])dnl
AC_CACHE_CHECK(type of array argument to getgroups, ac_cv_type_getgroups,
[AC_RUN_IFELSE([AC_LANG_SOURCE(
[[/* Thanks to Mike Rendell for this test.  */
]AC_INCLUDES_DEFAULT[
#define NGID 256
#undef MAX
#define MAX(x, y) ((x) > (y) ? (x) : (y))

int
main ()
{
  gid_t gidset[NGID];
  int i, n;
  union { gid_t gval; long int lval; }  val;

  val.lval = -1;
  for (i = 0; i < NGID; i++)
    gidset[i] = val.gval;
  n = getgroups (sizeof (gidset) / MAX (sizeof (int), sizeof (gid_t)) - 1,
		 gidset);
  /* Exit non-zero if getgroups seems to require an array of ints.  This
     happens when gid_t is short int but getgroups modifies an array
     of ints.  */
  return n > 0 && gidset[n] != val.gval;
}]])],
	       [ac_cv_type_getgroups=gid_t],
	       [ac_cv_type_getgroups=int],
	       [ac_cv_type_getgroups=cross])
if test $ac_cv_type_getgroups = cross; then
  dnl When we can't run the test program (we are cross compiling), presume
  dnl that <unistd.h> has either an accurate prototype for getgroups or none.
  dnl Old systems without prototypes probably use int.
  AC_EGREP_HEADER([getgroups.*int.*gid_t], unistd.h,
		  ac_cv_type_getgroups=gid_t, ac_cv_type_getgroups=int)
fi])
AC_DEFINE_UNQUOTED(GETGROUPS_T, $ac_cv_type_getgroups,
		   [Define to the type of elements in the array set by
		    `getgroups'. Usually this is either `int' or `gid_t'.])
])# AC_TYPE_GETGROUPS


# AU::AM_TYPE_PTRDIFF_T
# ---------------------
AU_DEFUN([AM_TYPE_PTRDIFF_T],
[AC_CHECK_TYPES(ptrdiff_t)])


# AC_TYPE_INTMAX_T
# -----------------
AC_DEFUN([AC_TYPE_INTMAX_T],
[
  AC_REQUIRE([AC_TYPE_LONG_LONG_INT])
  AC_CHECK_TYPE([intmax_t],
    [AC_DEFINE([HAVE_INTMAX_T], 1,
       [Define to 1 if the system has the type `intmax_t'.])],
    [test $ac_cv_type_long_long_int = yes \
       && ac_type='long long int' \
       || ac_type='long int'
     AC_DEFINE_UNQUOTED([intmax_t], [$ac_type],
       [Define to the widest signed integer type
	if <stdint.h> and <inttypes.h> do not define.])])
])


# AC_TYPE_UINTMAX_T
# -----------------
AC_DEFUN([AC_TYPE_UINTMAX_T],
[
  AC_REQUIRE([AC_TYPE_UNSIGNED_LONG_LONG_INT])
  AC_CHECK_TYPE([uintmax_t],
    [AC_DEFINE([HAVE_UINTMAX_T], 1,
       [Define to 1 if the system has the type `uintmax_t'.])],
    [test $ac_cv_type_unsigned_long_long_int = yes \
       && ac_type='unsigned long long int' \
       || ac_type='unsigned long int'
     AC_DEFINE_UNQUOTED([uintmax_t], [$ac_type],
       [Define to the widest unsigned integer type
	if <stdint.h> and <inttypes.h> do not define.])])
])


# AC_TYPE_INTPTR_T
# -----------------
AC_DEFUN([AC_TYPE_INTPTR_T],
[
  AC_CHECK_TYPE([intptr_t],
    [AC_DEFINE([HAVE_INTPTR_T], 1,
       [Define to 1 if the system has the type `intptr_t'.])],
    [for ac_type in 'int' 'long int' 'long long int'; do
       AC_COMPILE_IFELSE(
	 [AC_LANG_BOOL_COMPILE_TRY(
	    [AC_INCLUDES_DEFAULT],
	    [[sizeof (void *) <= sizeof ($ac_type)]])],
	 [AC_DEFINE_UNQUOTED([intptr_t], [$ac_type],
	    [Define to the type of a signed integer type wide enough to
	     hold a pointer, if such a type exists, and if the system
	     does not define it.])
	  ac_type=])
       test -z "$ac_type" && break
     done])
])


# AC_TYPE_UINTPTR_T
# -----------------
AC_DEFUN([AC_TYPE_UINTPTR_T],
[
  AC_CHECK_TYPE([uintptr_t],
    [AC_DEFINE([HAVE_UINTPTR_T], 1,
       [Define to 1 if the system has the type `uintptr_t'.])],
    [for ac_type in 'unsigned int' 'unsigned long int' \
	'unsigned long long int'; do
       AC_COMPILE_IFELSE(
	 [AC_LANG_BOOL_COMPILE_TRY(
	    [AC_INCLUDES_DEFAULT],
	    [[sizeof (void *) <= sizeof ($ac_type)]])],
	 [AC_DEFINE_UNQUOTED([uintptr_t], [$ac_type],
	    [Define to the type of an unsigned integer type wide enough to
	     hold a pointer, if such a type exists, and if the system
	     does not define it.])
	  ac_type=])
       test -z "$ac_type" && break
     done])
])


# AC_TYPE_LONG_DOUBLE
# -------------------
AC_DEFUN([AC_TYPE_LONG_DOUBLE],
[
  AC_CACHE_CHECK([for long double], [ac_cv_type_long_double],
    [if test "$GCC" = yes; then
       ac_cv_type_long_double=yes
     else
       AC_COMPILE_IFELSE(
	 [AC_LANG_BOOL_COMPILE_TRY(
	    [[/* The Stardent Vistra knows sizeof (long double), but does
		 not support it.  */
	      long double foo = 0.0L;]],
	    [[/* On Ultrix 4.3 cc, long double is 4 and double is 8.  */
	      sizeof (double) <= sizeof (long double)]])],
	 [ac_cv_type_long_double=yes],
	 [ac_cv_type_long_double=no])
     fi])
  if test $ac_cv_type_long_double = yes; then
    AC_DEFINE([HAVE_LONG_DOUBLE], 1,
      [Define to 1 if the system has the type `long double'.])
  fi
])


# AC_TYPE_LONG_DOUBLE_WIDER
# -------------------------
AC_DEFUN([AC_TYPE_LONG_DOUBLE_WIDER],
[
  AC_CACHE_CHECK(
    [for long double with more range or precision than double],
    [ac_cv_type_long_double_wider],
    [AC_COMPILE_IFELSE(
       [AC_LANG_BOOL_COMPILE_TRY(
	  [[#include <float.h>
	    long double const a[] =
	      {
		 0.0L, DBL_MIN, DBL_MAX, DBL_EPSILON,
		 LDBL_MIN, LDBL_MAX, LDBL_EPSILON
	      };
	    long double
	    f (long double x)
	    {
	       return ((x + (unsigned long int) 10) * (-1 / x) + a[0]
			+ (x ? f (x) : 'c'));
	    }
	  ]],
	  [[(0 < ((DBL_MAX_EXP < LDBL_MAX_EXP)
		   + (DBL_MANT_DIG < LDBL_MANT_DIG)
		   - (LDBL_MAX_EXP < DBL_MAX_EXP)
		   - (LDBL_MANT_DIG < DBL_MANT_DIG)))
	    && (int) LDBL_EPSILON == 0
	  ]])],
       ac_cv_type_long_double_wider=yes,
       ac_cv_type_long_double_wider=no)])
  if test $ac_cv_type_long_double_wider = yes; then
    AC_DEFINE([HAVE_LONG_DOUBLE_WIDER], 1,
      [Define to 1 if the type `long double' works and has more range or
       precision than `double'.])
  fi
])# AC_TYPE_LONG_DOUBLE_WIDER


# AC_C_LONG_DOUBLE
# ----------------
AU_DEFUN([AC_C_LONG_DOUBLE],
  [
    AC_TYPE_LONG_DOUBLE_WIDER
    ac_cv_c_long_double=$ac_cv_type_long_double_wider
    if test $ac_cv_c_long_double = yes; then
      AC_DEFINE([HAVE_LONG_DOUBLE], 1,
	[Define to 1 if the type `long double' works and has more range or
	 precision than `double'.])
    fi
  ],
  [The macro `AC_C_LONG_DOUBLE' is obsolete.
You should use `AC_TYPE_LONG_DOUBLE' or `AC_TYPE_LONG_DOUBLE_WIDER' instead.]
)


# AC_TYPE_LONG_LONG_INT
# ---------------------
AC_DEFUN([AC_TYPE_LONG_LONG_INT],
[
  AC_CACHE_CHECK([for long long int], [ac_cv_type_long_long_int],
    [AC_LINK_IFELSE(
       [AC_LANG_PROGRAM(
	  [[long long int ll = 9223372036854775807ll;
	    long long int nll = -9223372036854775807LL;
	    typedef int a[((-9223372036854775807LL < 0
			    && 0 < 9223372036854775807ll)
			   ? 1 : -1)];
	    int i = 63;]],
	  [[long long int llmax = 9223372036854775807ll;
	    return ((ll << 63) | (ll >> 63) | (ll < i) | (ll > i)
		    | (llmax / ll) | (llmax % ll));]])],
       [dnl This catches a bug in Tandem NonStop Kernel (OSS) cc -O circa 2004.
	dnl If cross compiling, assume the bug isn't important, since
	dnl nobody cross compiles for this platform as far as we know.
	AC_RUN_IFELSE(
	  [AC_LANG_PROGRAM(
	     [[@%:@include <limits.h>
	       @%:@ifndef LLONG_MAX
	       @%:@ define HALF \
			(1LL << (sizeof (long long int) * CHAR_BIT - 2))
	       @%:@ define LLONG_MAX (HALF - 1 + HALF)
	       @%:@endif]],
	     [[long long int n = 1;
	       int i;
	       for (i = 0; ; i++)
		 {
		   long long int m = n << i;
		   if (m >> i != n)
		     return 1;
		   if (LLONG_MAX / 2 < m)
		     break;
		 }
	       return 0;]])],
	  [ac_cv_type_long_long_int=yes],
	  [ac_cv_type_long_long_int=no],
	  [ac_cv_type_long_long_int=yes])],
       [ac_cv_type_long_long_int=no])])
  if test $ac_cv_type_long_long_int = yes; then
    AC_DEFINE([HAVE_LONG_LONG_INT], 1,
      [Define to 1 if the system has the type `long long int'.])
  fi
])


# AC_TYPE_UNSIGNED_LONG_LONG_INT
# ------------------------------
AC_DEFUN([AC_TYPE_UNSIGNED_LONG_LONG_INT],
[
  AC_CACHE_CHECK([for unsigned long long int],
    [ac_cv_type_unsigned_long_long_int],
    [AC_LINK_IFELSE(
       [AC_LANG_PROGRAM(
	  [[unsigned long long int ull = 18446744073709551615ULL;
	    typedef int a[(18446744073709551615ULL <= (unsigned long long int) -1
			   ? 1 : -1)];
	   int i = 63;]],
	  [[unsigned long long int ullmax = 18446744073709551615ull;
	    return (ull << 63 | ull >> 63 | ull << i | ull >> i
		    | ullmax / ull | ullmax % ull);]])],
       [ac_cv_type_unsigned_long_long_int=yes],
       [ac_cv_type_unsigned_long_long_int=no])])
  if test $ac_cv_type_unsigned_long_long_int = yes; then
    AC_DEFINE([HAVE_UNSIGNED_LONG_LONG_INT], 1,
      [Define to 1 if the system has the type `unsigned long long int'.])
  fi
])


# AC_TYPE_MBSTATE_T
# -----------------
AC_DEFUN([AC_TYPE_MBSTATE_T],
  [AC_CACHE_CHECK([for mbstate_t], ac_cv_type_mbstate_t,
     [AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM(
	   [AC_INCLUDES_DEFAULT
#	    include <wchar.h>],
	   [mbstate_t x; return sizeof x;])],
	[ac_cv_type_mbstate_t=yes],
	[ac_cv_type_mbstate_t=no])])
   if test $ac_cv_type_mbstate_t = yes; then
     AC_DEFINE([HAVE_MBSTATE_T], 1,
	       [Define to 1 if <wchar.h> declares mbstate_t.])
   else
     AC_DEFINE([mbstate_t], int,
	       [Define to a type if <wchar.h> does not define.])
   fi])


# AC_TYPE_UID_T
# -------------
# FIXME: Rewrite using AC_CHECK_TYPE.
AN_IDENTIFIER([gid_t], [AC_TYPE_UID_T])
AN_IDENTIFIER([uid_t], [AC_TYPE_UID_T])
AC_DEFUN([AC_TYPE_UID_T],
[AC_CACHE_CHECK(for uid_t in sys/types.h, ac_cv_type_uid_t,
[AC_EGREP_HEADER(uid_t, sys/types.h,
  ac_cv_type_uid_t=yes, ac_cv_type_uid_t=no)])
if test $ac_cv_type_uid_t = no; then
  AC_DEFINE(uid_t, int, [Define to `int' if <sys/types.h> doesn't define.])
  AC_DEFINE(gid_t, int, [Define to `int' if <sys/types.h> doesn't define.])
fi
])


AN_IDENTIFIER([size_t], [AC_TYPE_SIZE_T])
AC_DEFUN([AC_TYPE_SIZE_T], [AC_CHECK_TYPE(size_t, unsigned int)])

AN_IDENTIFIER([ssize_t], [AC_TYPE_SSIZE_T])
AC_DEFUN([AC_TYPE_SSIZE_T], [AC_CHECK_TYPE(ssize_t, int)])

AN_IDENTIFIER([pid_t], [AC_TYPE_PID_T])
AC_DEFUN([AC_TYPE_PID_T],  [AC_CHECK_TYPE(pid_t,  int)])

AN_IDENTIFIER([off_t], [AC_TYPE_OFF_T])
AC_DEFUN([AC_TYPE_OFF_T],  [AC_CHECK_TYPE(off_t,  long int)])

AN_IDENTIFIER([mode_t], [AC_TYPE_MODE_T])
AC_DEFUN([AC_TYPE_MODE_T], [AC_CHECK_TYPE(mode_t, int)])

AN_IDENTIFIER([int8_t], [AC_TYPE_INT8_T])
AN_IDENTIFIER([int16_t], [AC_TYPE_INT16_T])
AN_IDENTIFIER([int32_t], [AC_TYPE_INT32_T])
AN_IDENTIFIER([int64_t], [AC_TYPE_INT64_T])
AN_IDENTIFIER([uint8_t], [AC_TYPE_UINT8_T])
AN_IDENTIFIER([uint16_t], [AC_TYPE_UINT16_T])
AN_IDENTIFIER([uint32_t], [AC_TYPE_UINT32_T])
AN_IDENTIFIER([uint64_t], [AC_TYPE_UINT64_T])
AC_DEFUN([AC_TYPE_INT8_T], [_AC_TYPE_INT(8)])
AC_DEFUN([AC_TYPE_INT16_T], [_AC_TYPE_INT(16)])
AC_DEFUN([AC_TYPE_INT32_T], [_AC_TYPE_INT(32)])
AC_DEFUN([AC_TYPE_INT64_T], [_AC_TYPE_INT(64)])
AC_DEFUN([AC_TYPE_UINT8_T], [_AC_TYPE_UNSIGNED_INT(8)])
AC_DEFUN([AC_TYPE_UINT16_T], [_AC_TYPE_UNSIGNED_INT(16)])
AC_DEFUN([AC_TYPE_UINT32_T], [_AC_TYPE_UNSIGNED_INT(32)])
AC_DEFUN([AC_TYPE_UINT64_T], [_AC_TYPE_UNSIGNED_INT(64)])

# _AC_TYPE_INT(NBITS)
# -------------------
AC_DEFUN([_AC_TYPE_INT],
[
  AC_CACHE_CHECK([for int$1_t], [ac_cv_c_int$1_t],
    [ac_cv_c_int$1_t=no
     for ac_type in 'int$1_t' 'int' 'long int' \
	 'long long int' 'short int' 'signed char'; do
       AC_COMPILE_IFELSE(
	 [AC_LANG_BOOL_COMPILE_TRY(
	    [AC_INCLUDES_DEFAULT],
	    [[0 < ($ac_type) (((($ac_type) 1 << ($1 - 2)) - 1) * 2 + 1)]])],
	 [AC_COMPILE_IFELSE(
	    [AC_LANG_BOOL_COMPILE_TRY(
	       [AC_INCLUDES_DEFAULT],
	       [[($ac_type) (((($ac_type) 1 << ($1 - 2)) - 1) * 2 + 1)
	         < ($ac_type) (((($ac_type) 1 << ($1 - 2)) - 1) * 2 + 2)]])],
	    [],
	    [AS_CASE([$ac_type], [int$1_t],
	       [ac_cv_c_int$1_t=yes],
	       [ac_cv_c_int$1_t=$ac_type])])])
       test "$ac_cv_c_int$1_t" != no && break
     done])
  case $ac_cv_c_int$1_t in #(
  no|yes) ;; #(
  *)
    AC_DEFINE_UNQUOTED([int$1_t], [$ac_cv_c_int$1_t],
      [Define to the type of a signed integer type of width exactly $1 bits
       if such a type exists and the standard includes do not define it.]);;
  esac
])# _AC_TYPE_INT

# _AC_TYPE_UNSIGNED_INT(NBITS)
# ----------------------------
AC_DEFUN([_AC_TYPE_UNSIGNED_INT],
[
  AC_CACHE_CHECK([for uint$1_t], [ac_cv_c_uint$1_t],
    [ac_cv_c_uint$1_t=no
     for ac_type in 'uint$1_t' 'unsigned int' 'unsigned long int' \
	 'unsigned long long int' 'unsigned short int' 'unsigned char'; do
       AC_COMPILE_IFELSE(
	 [AC_LANG_BOOL_COMPILE_TRY(
	    [AC_INCLUDES_DEFAULT],
	    [[($ac_type) -1 >> ($1 - 1) == 1]])],
	 [AS_CASE([$ac_type], [uint$1_t],
	    [ac_cv_c_uint$1_t=yes],
	    [ac_cv_c_uint$1_t=$ac_type])])
       test "$ac_cv_c_uint$1_t" != no && break
     done])
  case $ac_cv_c_uint$1_t in #(
  no|yes) ;; #(
  *)
    m4_bmatch([$1], [^\(8\|32\|64\)$],
      [AC_DEFINE([_UINT$1_T], 1,
	 [Define for Solaris 2.5.1 so the uint$1_t typedef from
	  <sys/synch.h>, <pthread.h>, or <semaphore.h> is not used.
	  If the typedef was allowed, the #define below would cause a
	  syntax error.])])
    AC_DEFINE_UNQUOTED([uint$1_t], [$ac_cv_c_uint$1_t],
      [Define to the type of an unsigned integer type of width exactly $1 bits
       if such a type exists and the standard includes do not define it.]);;
  esac
])# _AC_TYPE_UNSIGNED_INT

# AC_TYPE_SIGNAL
# --------------
# Note that identifiers starting with SIG are reserved by ANSI C.
AN_FUNCTION([signal],  [AC_TYPE_SIGNAL])
AC_DEFUN([AC_TYPE_SIGNAL],
[AC_CACHE_CHECK([return type of signal handlers], ac_cv_type_signal,
[AC_COMPILE_IFELSE(
[AC_LANG_PROGRAM([#include <sys/types.h>
#include <signal.h>
],
		 [return *(signal (0, 0)) (0) == 1;])],
		   [ac_cv_type_signal=int],
		   [ac_cv_type_signal=void])])
AC_DEFINE_UNQUOTED(RETSIGTYPE, $ac_cv_type_signal,
		   [Define as the return type of signal handlers
		    (`int' or `void').])
])


## ------------------------ ##
## Checking size of types.  ##
## ------------------------ ##

# ---------------- #
# Generic checks.  #
# ---------------- #


# AC_CHECK_SIZEOF(TYPE, [IGNORED], [INCLUDES = DEFAULT-INCLUDES])
# ---------------------------------------------------------------
AC_DEFUN([AC_CHECK_SIZEOF],
[AS_LITERAL_IF([$1], [],
	       [AC_FATAL([$0: requires literal arguments])])dnl
AC_CHECK_TYPE([$1], [], [], [$3])
# The cast to long int works around a bug in the HP C Compiler
# version HP92453-01 B.11.11.23709.GP, which incorrectly rejects
# declarations like `int a3[[(sizeof (unsigned char)) >= 0]];'.
# This bug is HP SR number 8606223364.
_AC_CACHE_CHECK_INT([size of $1], [AS_TR_SH([ac_cv_sizeof_$1])],
  [(long int) (sizeof (ac__type_sizeof_))],
  [AC_INCLUDES_DEFAULT([$3])
   typedef $1 ac__type_sizeof_;],
  [if test "$AS_TR_SH([ac_cv_type_$1])" = yes; then
     AC_MSG_FAILURE([cannot compute sizeof ($1)], 77)
   else
     AS_TR_SH([ac_cv_sizeof_$1])=0
   fi])

AC_DEFINE_UNQUOTED(AS_TR_CPP(sizeof_$1), $AS_TR_SH([ac_cv_sizeof_$1]),
		   [The size of `$1', as computed by sizeof.])
])# AC_CHECK_SIZEOF


# AC_CHECK_ALIGNOF(TYPE, [INCLUDES = DEFAULT-INCLUDES])
# -----------------------------------------------------
AC_DEFUN([AC_CHECK_ALIGNOF],
[AS_LITERAL_IF([$1], [],
	       [AC_FATAL([$0: requires literal arguments])])dnl
AC_CHECK_TYPE([$1], [], [], [$2])
# The cast to long int works around a bug in the HP C Compiler,
# see AC_CHECK_SIZEOF for more information.
_AC_CACHE_CHECK_INT([alignment of $1], [AS_TR_SH([ac_cv_alignof_$1])],
  [(long int) offsetof (ac__type_alignof_, y)],
  [AC_INCLUDES_DEFAULT([$2])
#ifndef offsetof
# define offsetof(type, member) ((char *) &((type *) 0)->member - (char *) 0)
#endif
typedef struct { char x; $1 y; } ac__type_alignof_;],
  [if test "$AS_TR_SH([ac_cv_type_$1])" = yes; then
     AC_MSG_FAILURE([cannot compute alignment of $1], 77)
   else
     AS_TR_SH([ac_cv_alignof_$1])=0
   fi])

AC_DEFINE_UNQUOTED(AS_TR_CPP(alignof_$1), $AS_TR_SH([ac_cv_alignof_$1]),
		   [The normal alignment of `$1', in bytes.])
])# AC_CHECK_ALIGNOF


# AU::AC_INT_16_BITS
# ------------------
# What a great name :)
AU_DEFUN([AC_INT_16_BITS],
[AC_CHECK_SIZEOF([int])
test $ac_cv_sizeof_int = 2 &&
  AC_DEFINE(INT_16_BITS, 1,
	    [Define to 1 if `sizeof (int)' = 2.  Obsolete, use `SIZEOF_INT'.])
], [your code should no longer depend upon `INT_16_BITS', but upon
`SIZEOF_INT == 2'.  Remove this warning and the `AC_DEFINE' when you
adjust the code.])


# AU::AC_LONG_64_BITS
# -------------------
AU_DEFUN([AC_LONG_64_BITS],
[AC_CHECK_SIZEOF([long int])
test $ac_cv_sizeof_long_int = 8 &&
  AC_DEFINE(LONG_64_BITS, 1,
	    [Define to 1 if `sizeof (long int)' = 8.  Obsolete, use
	     `SIZEOF_LONG_INT'.])
], [your code should no longer depend upon `LONG_64_BITS', but upon
`SIZEOF_LONG_INT == 8'.  Remove this warning and the `AC_DEFINE' when
you adjust the code.])



## -------------------------- ##
## Generic structure checks.  ##
## -------------------------- ##


# ---------------- #
# Generic checks.  #
# ---------------- #

# AC_CHECK_MEMBER(AGGREGATE.MEMBER,
#		  [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		  [INCLUDES = DEFAULT-INCLUDES])
# ---------------------------------------------------------
# AGGREGATE.MEMBER is for instance `struct passwd.pw_gecos', shell
# variables are not a valid argument.
AC_DEFUN([AC_CHECK_MEMBER],
[AS_LITERAL_IF([$1], [],
	       [AC_FATAL([$0: requires literal arguments])])dnl
m4_bmatch([$1], [\.], ,
	 [m4_fatal([$0: Did not see any dot in `$1'])])dnl
AS_VAR_PUSHDEF([ac_Member], [ac_cv_member_$1])dnl
dnl Extract the aggregate name, and the member name
AC_CACHE_CHECK([for $1], [ac_Member],
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT([$4])],
[dnl AGGREGATE ac_aggr;
static m4_bpatsubst([$1], [\..*]) ac_aggr;
dnl ac_aggr.MEMBER;
if (ac_aggr.m4_bpatsubst([$1], [^[^.]*\.]))
return 0;])],
		[AS_VAR_SET([ac_Member], [yes])],
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT([$4])],
[dnl AGGREGATE ac_aggr;
static m4_bpatsubst([$1], [\..*]) ac_aggr;
dnl sizeof ac_aggr.MEMBER;
if (sizeof ac_aggr.m4_bpatsubst([$1], [^[^.]*\.]))
return 0;])],
		[AS_VAR_SET([ac_Member], [yes])],
		[AS_VAR_SET([ac_Member], [no])])])])
AS_IF([test AS_VAR_GET([ac_Member]) = yes], [$2], [$3])dnl
AS_VAR_POPDEF([ac_Member])dnl
])# AC_CHECK_MEMBER


# AC_CHECK_MEMBERS([AGGREGATE.MEMBER, ...],
#		   [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND]
#		   [INCLUDES = DEFAULT-INCLUDES])
# ---------------------------------------------------------
# The first argument is an m4 list.
AC_DEFUN([AC_CHECK_MEMBERS],
[m4_foreach([AC_Member], [$1],
  [AC_CHECK_MEMBER(AC_Member,
	 [AC_DEFINE_UNQUOTED(AS_TR_CPP(HAVE_[]AC_Member), 1,
			    [Define to 1 if `]m4_bpatsubst(AC_Member,
						     [^[^.]*\.])[' is
			     member of `]m4_bpatsubst(AC_Member, [\..*])['.])
$2],
		 [$3],
		 [$4])])])



# ------------------------------------------------------- #
# Members that ought to be tested with AC_CHECK_MEMBERS.  #
# ------------------------------------------------------- #

AN_IDENTIFIER([st_blksize], [AC_CHECK_MEMBERS([struct stat.st_blksize])])
AN_IDENTIFIER([st_rdev],    [AC_CHECK_MEMBERS([struct stat.st_rdev])])


# Alphabetic order, please.

# _AC_STRUCT_DIRENT(MEMBER)
# -------------------------
AC_DEFUN([_AC_STRUCT_DIRENT],
[
  AC_REQUIRE([AC_HEADER_DIRENT])
  AC_CHECK_MEMBERS([struct dirent.$1], [], [],
    [[
#include <sys/types.h>
#ifdef HAVE_DIRENT_H
# include <dirent.h>
#else
# define dirent direct
# ifdef HAVE_SYS_NDIR_H
#  include <sys/ndir.h>
# endif
# ifdef HAVE_SYS_DIR_H
#  include <sys/dir.h>
# endif
# ifdef HAVE_NDIR_H
#  include <ndir.h>
# endif
#endif
    ]])
])

# AC_STRUCT_DIRENT_D_INO
# -----------------------------------
AC_DEFUN([AC_STRUCT_DIRENT_D_INO], [_AC_STRUCT_DIRENT([d_ino])])

# AC_STRUCT_DIRENT_D_TYPE
# ------------------------------------
AC_DEFUN([AC_STRUCT_DIRENT_D_TYPE], [_AC_STRUCT_DIRENT([d_type])])


# AC_STRUCT_ST_BLKSIZE
# --------------------
AU_DEFUN([AC_STRUCT_ST_BLKSIZE],
[AC_CHECK_MEMBERS([struct stat.st_blksize],
		 [AC_DEFINE(HAVE_ST_BLKSIZE, 1,
			    [Define to 1 if your `struct stat' has
			     `st_blksize'.  Deprecated, use
			     `HAVE_STRUCT_STAT_ST_BLKSIZE' instead.])])
], [your code should no longer depend upon `HAVE_ST_BLKSIZE', but
`HAVE_STRUCT_STAT_ST_BLKSIZE'.  Remove this warning and
the `AC_DEFINE' when you adjust the code.])# AC_STRUCT_ST_BLKSIZE


# AC_STRUCT_ST_BLOCKS
# -------------------
# If `struct stat' contains an `st_blocks' member, define
# HAVE_STRUCT_STAT_ST_BLOCKS.  Otherwise, add `fileblocks.o' to the
# output variable LIBOBJS.  We still define HAVE_ST_BLOCKS for backward
# compatibility.  In the future, we will activate specializations for
# this macro, so don't obsolete it right now.
#
# AC_OBSOLETE([$0], [; replace it with
#   AC_CHECK_MEMBERS([struct stat.st_blocks],
#		      [AC_LIBOBJ([fileblocks])])
# Please note that it will define `HAVE_STRUCT_STAT_ST_BLOCKS',
# and not `HAVE_ST_BLOCKS'.])dnl
#
AN_IDENTIFIER([st_blocks],  [AC_STRUCT_ST_BLOCKS])
AC_DEFUN([AC_STRUCT_ST_BLOCKS],
[AC_CHECK_MEMBERS([struct stat.st_blocks],
		  [AC_DEFINE(HAVE_ST_BLOCKS, 1,
			     [Define to 1 if your `struct stat' has
			      `st_blocks'.  Deprecated, use
			      `HAVE_STRUCT_STAT_ST_BLOCKS' instead.])],
		  [AC_LIBOBJ([fileblocks])])
])# AC_STRUCT_ST_BLOCKS


# AC_STRUCT_ST_RDEV
# -----------------
AU_DEFUN([AC_STRUCT_ST_RDEV],
[AC_CHECK_MEMBERS([struct stat.st_rdev],
		 [AC_DEFINE(HAVE_ST_RDEV, 1,
			    [Define to 1 if your `struct stat' has `st_rdev'.
			     Deprecated, use `HAVE_STRUCT_STAT_ST_RDEV'
			     instead.])])
], [your code should no longer depend upon `HAVE_ST_RDEV', but
`HAVE_STRUCT_STAT_ST_RDEV'.  Remove this warning and
the `AC_DEFINE' when you adjust the code.])# AC_STRUCT_ST_RDEV


# AC_STRUCT_TM
# ------------
# FIXME: This macro is badly named, it should be AC_CHECK_TYPE_STRUCT_TM.
# Or something else, but what? AC_CHECK_TYPE_STRUCT_TM_IN_SYS_TIME?
AN_IDENTIFIER([tm], [AC_STRUCT_TM])
AC_DEFUN([AC_STRUCT_TM],
[AC_CACHE_CHECK([whether struct tm is in sys/time.h or time.h],
  ac_cv_struct_tm,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([#include <sys/types.h>
#include <time.h>
],
				    [struct tm tm;
				     int *p = &tm.tm_sec;
 				     return !p;])],
		   [ac_cv_struct_tm=time.h],
		   [ac_cv_struct_tm=sys/time.h])])
if test $ac_cv_struct_tm = sys/time.h; then
  AC_DEFINE(TM_IN_SYS_TIME, 1,
	    [Define to 1 if your <sys/time.h> declares `struct tm'.])
fi
])# AC_STRUCT_TM


# AC_STRUCT_TIMEZONE
# ------------------
# Figure out how to get the current timezone.  If `struct tm' has a
# `tm_zone' member, define `HAVE_TM_ZONE'.  Otherwise, if the
# external array `tzname' is found, define `HAVE_TZNAME'.
AN_IDENTIFIER([tm_zone], [AC_STRUCT_TIMEZONE])
AC_DEFUN([AC_STRUCT_TIMEZONE],
[AC_REQUIRE([AC_STRUCT_TM])dnl
AC_CHECK_MEMBERS([struct tm.tm_zone],,,[#include <sys/types.h>
#include <$ac_cv_struct_tm>
])
if test "$ac_cv_member_struct_tm_tm_zone" = yes; then
  AC_DEFINE(HAVE_TM_ZONE, 1,
	    [Define to 1 if your `struct tm' has `tm_zone'. Deprecated, use
	     `HAVE_STRUCT_TM_TM_ZONE' instead.])
else
  AC_CHECK_DECLS([tzname], , , [#include <time.h>])
  AC_CACHE_CHECK(for tzname, ac_cv_var_tzname,
[AC_LINK_IFELSE([AC_LANG_PROGRAM(
[[#include <time.h>
#if !HAVE_DECL_TZNAME
extern char *tzname[];
#endif
]],
[[return tzname[0][0];]])],
		[ac_cv_var_tzname=yes],
		[ac_cv_var_tzname=no])])
  if test $ac_cv_var_tzname = yes; then
    AC_DEFINE(HAVE_TZNAME, 1,
	      [Define to 1 if you don't have `tm_zone' but do have the external
	       array `tzname'.])
  fi
fi
])# AC_STRUCT_TIMEZONE
