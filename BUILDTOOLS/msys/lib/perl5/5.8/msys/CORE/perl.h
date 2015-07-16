/*    perl.h
 *
 *    Copyright (C) 1993, 1994, 1995, 1996, 1997, 1998, 1999,
 *    2000, 2001, 2002, 2003, 2004, 2005, 2006 by Larry Wall and others
 *
 *    You may distribute under the terms of either the GNU General Public
 *    License or the Artistic License, as specified in the README file.
 *
 */

#ifndef H_PERL
#define H_PERL 1

#ifdef PERL_FOR_X2P
/*
 * This file is being used for x2p stuff.
 * Above symbol is defined via -D in 'x2p/Makefile.SH'
 * Decouple x2p stuff from some of perls more extreme eccentricities.
 */
#undef MULTIPLICITY
#undef USE_STDIO
#define USE_STDIO
#endif /* PERL_FOR_X2P */

#if defined(DGUX)
#include <sys/fcntl.h>
#endif

#ifdef VOIDUSED
#   undef VOIDUSED
#endif 
#define VOIDUSED 1

#ifdef PERL_MICRO
#   include "uconfig.h"
#else
#   include "config.h"
#endif

#if defined(USE_ITHREADS) && defined(USE_5005THREADS)
#  include "error: USE_ITHREADS and USE_5005THREADS are incompatible"
#endif

/* See L<perlguts/"The Perl API"> for detailed notes on
 * PERL_IMPLICIT_CONTEXT and PERL_IMPLICIT_SYS */

/* Note that from here --> to <-- the same logic is
 * repeated in makedef.pl, so be certain to update
 * both places when editing. */

#ifdef PERL_IMPLICIT_SYS
/* PERL_IMPLICIT_SYS implies PerlMemShared != PerlMem
   so use slab allocator to avoid lots of MUTEX overhead
 */
#  ifndef PL_OP_SLAB_ALLOC
#    define PL_OP_SLAB_ALLOC
#  endif
#endif

#ifdef USE_ITHREADS
#  if !defined(MULTIPLICITY)
#    define MULTIPLICITY
#  endif
#endif

#ifdef USE_5005THREADS
#  ifndef PERL_IMPLICIT_CONTEXT
#    define PERL_IMPLICIT_CONTEXT
#  endif
#endif

#if defined(MULTIPLICITY)
#  ifndef PERL_IMPLICIT_CONTEXT
#    define PERL_IMPLICIT_CONTEXT
#  endif
#endif

/* undef WIN32 when building on Cygwin (for libwin32) - gph */
#if defined(__CYGWIN__) || defined(__MSYS__)
#   undef WIN32
#   undef _WIN32
#endif

/* Use the reentrant APIs like localtime_r and getpwent_r */
/* Win32 has naturally threadsafe libraries, no need to use any _r variants. */
#if defined(USE_ITHREADS) && !defined(USE_REENTRANT_API) && !defined(NETWARE) && !defined(WIN32) && !defined(PERL_DARWIN)
#   define USE_REENTRANT_API
#endif

/* <--- here ends the logic shared by perl.h and makedef.pl */

/*
 * PERL_DARWIN for MacOSX (__APPLE__ exists but is not officially sanctioned)
 * (The -DPERL_DARWIN comes from the hints/darwin.sh.)
 * __bsdi__ for BSD/OS
 */
#if defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__) || defined(PERL_DARWIN) || defined(__bsdi__) || defined(BSD41) || defined(BSD42) || defined(BSD43) || defined(BSD44)
#   ifndef BSDish
#       define BSDish
#   endif
#endif

#ifdef PERL_IMPLICIT_CONTEXT
#  ifdef USE_5005THREADS
struct perl_thread;
#    define pTHX	register struct perl_thread *thr PERL_UNUSED_DECL
#    define aTHX	thr
#    define dTHR	dNOOP /* only backward compatibility */
#    define dTHXa(a)	pTHX = (struct perl_thread*)a
#  else
#    ifndef MULTIPLICITY
#      define MULTIPLICITY
#    endif
#    define pTHX	register PerlInterpreter *my_perl PERL_UNUSED_DECL
#    define aTHX	my_perl
#    define dTHXa(a)	pTHX = (PerlInterpreter*)a
#  endif
#  define dTHX		pTHX = PERL_GET_THX
#  define pTHX_		pTHX,
#  define aTHX_		aTHX,
#  define pTHX_1	2
#  define pTHX_2	3
#  define pTHX_3	4
#  define pTHX_4	5
#  define pTHX_5	6
#  define pTHX_6	7
#  define pTHX_7	8
#  define pTHX_8	9
#  define pTHX_9	10
#endif

#define STATIC static
#define CPERLscope(x) x
#define CPERLarg void
#define CPERLarg_
#define _CPERLarg
#define PERL_OBJECT_THIS
#define _PERL_OBJECT_THIS
#define PERL_OBJECT_THIS_
#define CALL_FPTR(fptr) (*fptr)

#define CALLRUNOPS  CALL_FPTR(PL_runops)
#define CALLREGCOMP CALL_FPTR(PL_regcompp)
#define CALLREGEXEC CALL_FPTR(PL_regexecp)
#define CALLREG_INTUIT_START CALL_FPTR(PL_regint_start)
#define CALLREG_INTUIT_STRING CALL_FPTR(PL_regint_string)
#define CALLREGFREE CALL_FPTR(PL_regfree)

#ifdef PERL_FLEXIBLE_EXCEPTIONS
#  define CALLPROTECT CALL_FPTR(PL_protect)
#endif

#if defined(SYMBIAN) && defined(__GNUC__)
#  ifdef __cplusplus
#    define PERL_UNUSED_DECL
#  else
#    define PERL_UNUSED_DECL __attribute__((unused))
#  endif
#endif

#ifndef PERL_UNUSED_DECL
#  ifdef HASATTRIBUTE_UNUSED
#    define PERL_UNUSED_DECL __attribute__unused__
#  else
#    define PERL_UNUSED_DECL
#  endif
#endif

/* gcc -Wall:
 * for silencing unused variables that are actually used most of the time,
 * but we cannot quite get rid of, such as "ax" in PPCODE+noargs xsubs
 */
#ifndef PERL_UNUSED_ARG
#  ifdef lint
#    include <note.h>
#    define PERL_UNUSED_ARG(x) NOTE(ARGUNUSED(x))
#  else
#    define PERL_UNUSED_ARG(x) ((void)x)
#  endif
#endif
#ifndef PERL_UNUSED_VAR
#  define PERL_UNUSED_VAR(x) ((void)x)
#endif

#define NOOP (void)0
#define dNOOP extern int Perl___notused PERL_UNUSED_DECL

#ifndef pTHX
#  define pTHX		void
#  define pTHX_
#  define aTHX
#  define aTHX_
#  define dTHXa(a)	dNOOP
#  define dTHX		dNOOP
#  define pTHX_1	1	
#  define pTHX_2	2
#  define pTHX_3	3
#  define pTHX_4	4
#  define pTHX_5	5
#  define pTHX_6	6
#  define pTHX_7	7
#  define pTHX_8	8
#  define pTHX_9	9
#endif

/* these are only defined for compatibility; should not be used internally */
#if !defined(pTHXo) && !defined(PERL_CORE)
#  define pTHXo		pTHX
#  define pTHXo_	pTHX_
#  define aTHXo		aTHX
#  define aTHXo_	aTHX_
#  define dTHXo		dTHX
#  define dTHXoa(x)	dTHXa(x)
#endif

#ifndef pTHXx
#  define pTHXx		register PerlInterpreter *my_perl
#  define pTHXx_	pTHXx,
#  define aTHXx		my_perl
#  define aTHXx_	aTHXx,
#  define dTHXx		dTHX
#endif

/* Under PERL_IMPLICIT_SYS (used in Windows for fork emulation)
 * PerlIO_foo() expands to PL_StdIO->pFOO(PL_StdIO, ...).
 * dTHXs is therefore needed for all functions using PerlIO_foo(). */
#ifdef PERL_IMPLICIT_SYS
#  define dTHXs		dTHX
#else
#  define dTHXs		dNOOP
#endif

#undef START_EXTERN_C
#undef END_EXTERN_C
#undef EXTERN_C
#ifdef __cplusplus
#  define START_EXTERN_C extern "C" {
#  define END_EXTERN_C }
#  define EXTERN_C extern "C"
#else
#  define START_EXTERN_C
#  define END_EXTERN_C
#  define EXTERN_C extern
#endif

/* Some platforms require marking function declarations
 * for them to be exportable.  Used in perlio.h, proto.h
 * is handled either by the makedef.pl or by defining the
 * PERL_CALLCONV to be something special.  See also the
 * definition of XS() in XSUB.h. */
#ifndef PERL_EXPORT_C
#  define PERL_EXPORT_C extern
#endif
#ifndef PERL_XS_EXPORT_C
#  define PERL_XS_EXPORT_C
#endif

#ifdef OP_IN_REGISTER
#  ifdef __GNUC__
#    define stringify_immed(s) #s
#    define stringify(s) stringify_immed(s)
register struct op *Perl_op asm(stringify(OP_IN_REGISTER));
#  endif
#endif

#if defined(__STRICT_ANSI__) && defined(PERL_GCC_PEDANTIC)
#  if !defined(PERL_GCC_BRACE_GROUPS_FORBIDDEN)
#    define PERL_GCC_BRACE_GROUPS_FORBIDDEN
#  endif
#endif

/*
 * STMT_START { statements; } STMT_END;
 * can be used as a single statement, as in
 * if (x) STMT_START { ... } STMT_END; else ...
 *
 * Trying to select a version that gives no warnings...
 */
#if !(defined(STMT_START) && defined(STMT_END))
# if defined(__GNUC__) && !defined(PERL_GCC_BRACE_GROUPS_FORBIDDEN) && !defined(__cplusplus)
#   define STMT_START	(void)(	/* gcc supports "({ STATEMENTS; })" */
#   define STMT_END	)
# else
   /* Now which other defined()s do we need here ??? */
#  if (VOIDFLAGS) && (defined(sun) || defined(__sun__)) && !defined(__GNUC__)
#   define STMT_START	if (1)
#   define STMT_END	else (void)0
#  else
#   define STMT_START	do
#   define STMT_END	while (0)
#  endif
# endif
#endif

#define WITH_THX(s) STMT_START { dTHX; s; } STMT_END
#define WITH_THR(s) WITH_THX(s)

/*
 * SOFT_CAST can be used for args to prototyped functions to retain some
 * type checking; it only casts if the compiler does not know prototypes.
 */
#if defined(CAN_PROTOTYPE) && defined(DEBUGGING_COMPILE)
#define SOFT_CAST(type)	
#else
#define SOFT_CAST(type)	(type)
#endif

#ifndef BYTEORDER  /* Should never happen -- byteorder is in config.h */
#   define BYTEORDER 0x1234
#endif

/* Overall memory policy? */
#ifndef CONSERVATIVE
#   define LIBERAL 1
#endif

#if 'A' == 65 && 'I' == 73 && 'J' == 74 && 'Z' == 90
#define ASCIIish
#else
#undef  ASCIIish
#endif

/*
 * The following contortions are brought to you on behalf of all the
 * standards, semi-standards, de facto standards, not-so-de-facto standards
 * of the world, as well as all the other botches anyone ever thought of.
 * The basic theory is that if we work hard enough here, the rest of the
 * code can be a lot prettier.  Well, so much for theory.  Sorry, Henry...
 */

/* define this once if either system, instead of cluttering up the src */
#if defined(MSDOS) || defined(atarist) || defined(WIN32) || defined(NETWARE)
#define DOSISH 1
#endif

#if defined(__STDC__) || defined(vax11c) || defined(_AIX) || defined(__stdc__) || defined(__cplusplus) || defined( EPOC) || defined(NETWARE)
# define STANDARD_C 1
#endif

#if defined(__cplusplus) || defined(WIN32) || defined(__sgi) || defined(__EMX__) || defined(__DGUX) || defined( EPOC) || defined(__QNX__) || defined(NETWARE) || defined(PERL_MICRO)
# define DONT_DECLARE_STD 1
#endif

#if defined(HASVOLATILE) || defined(STANDARD_C)
#   ifdef __cplusplus
#	define VOL		/* to temporarily suppress warnings */
#   else
#	define VOL volatile
#   endif
#else
#   define VOL
#endif

#define TAINT		(PL_tainted = TRUE)
#define TAINT_NOT	(PL_tainted = FALSE)
#define TAINT_IF(c)	if (c) { PL_tainted = TRUE; }
#define TAINT_ENV()	if (PL_tainting) { taint_env(); }
#define TAINT_PROPER(s)	if (PL_tainting) { taint_proper(Nullch, s); }

/* XXX All process group stuff is handled in pp_sys.c.  Should these
   defines move there?  If so, I could simplify this a lot. --AD  9/96.
*/
/* Process group stuff changed from traditional BSD to POSIX.
   perlfunc.pod documents the traditional BSD-style syntax, so we'll
   try to preserve that, if possible.
*/
#ifdef HAS_SETPGID
#  define BSD_SETPGRP(pid, pgrp)	setpgid((pid), (pgrp))
#else
#  if defined(HAS_SETPGRP) && defined(USE_BSD_SETPGRP)
#    define BSD_SETPGRP(pid, pgrp)	setpgrp((pid), (pgrp))
#  else
#    ifdef HAS_SETPGRP2  /* DG/UX */
#      define BSD_SETPGRP(pid, pgrp)	setpgrp2((pid), (pgrp))
#    endif
#  endif
#endif
#if defined(BSD_SETPGRP) && !defined(HAS_SETPGRP)
#  define HAS_SETPGRP  /* Well, effectively it does . . . */
#endif

/* getpgid isn't POSIX, but at least Solaris and Linux have it, and it makes
    our life easier :-) so we'll try it.
*/
#ifdef HAS_GETPGID
#  define BSD_GETPGRP(pid)		getpgid((pid))
#else
#  if defined(HAS_GETPGRP) && defined(USE_BSD_GETPGRP)
#    define BSD_GETPGRP(pid)		getpgrp((pid))
#  else
#    ifdef HAS_GETPGRP2  /* DG/UX */
#      define BSD_GETPGRP(pid)		getpgrp2((pid))
#    endif
#  endif
#endif
#if defined(BSD_GETPGRP) && !defined(HAS_GETPGRP)
#  define HAS_GETPGRP  /* Well, effectively it does . . . */
#endif

/* These are not exact synonyms, since setpgrp() and getpgrp() may
   have different behaviors, but perl.h used to define USE_BSDPGRP
   (prior to 5.003_05) so some extension might depend on it.
*/
#if defined(USE_BSD_SETPGRP) || defined(USE_BSD_GETPGRP)
#  ifndef USE_BSDPGRP
#    define USE_BSDPGRP
#  endif
#endif

/* HP-UX 10.X CMA (Common Multithreaded Architecure) insists that
   pthread.h must be included before all other header files.
*/
#if (defined(USE_5005THREADS) || defined(USE_ITHREADS)) \
    && defined(PTHREAD_H_FIRST) && defined(I_PTHREAD)
#  include <pthread.h>
#endif

#ifndef _TYPES_		/* If types.h defines this it's easy. */
#   ifndef major		/* Does everyone's types.h define this? */
#	include <sys/types.h>
#   endif
#endif

#ifdef __cplusplus
#  ifndef I_STDARG
#    define I_STDARG 1
#  endif
#endif

#ifdef I_STDARG
#  include <stdarg.h>
#else
#  ifdef I_VARARGS
#    include <varargs.h>
#  endif
#endif

#ifdef USE_NEXT_CTYPE

#if NX_CURRENT_COMPILER_RELEASE >= 500
#  include <bsd/ctypes.h>
#else
#  if NX_CURRENT_COMPILER_RELEASE >= 400
#    include <objc/NXCType.h>
#  else /*  NX_CURRENT_COMPILER_RELEASE < 400 */
#    include <appkit/NXCType.h>
#  endif /*  NX_CURRENT_COMPILER_RELEASE >= 400 */
#endif /*  NX_CURRENT_COMPILER_RELEASE >= 500 */

#else /* !USE_NEXT_CTYPE */
#include <ctype.h>
#endif /* USE_NEXT_CTYPE */

#ifdef METHOD 	/* Defined by OSF/1 v3.0 by ctype.h */
#undef METHOD
#endif

#ifdef PERL_MICRO
#   define NO_LOCALE
#endif

#ifdef I_LOCALE
#   include <locale.h>
#endif

#if !defined(NO_LOCALE) && defined(HAS_SETLOCALE)
#   define USE_LOCALE
#   if !defined(NO_LOCALE_COLLATE) && defined(LC_COLLATE) \
       && defined(HAS_STRXFRM)
#	define USE_LOCALE_COLLATE
#   endif
#   if !defined(NO_LOCALE_CTYPE) && defined(LC_CTYPE)
#	define USE_LOCALE_CTYPE
#   endif
#   if !defined(NO_LOCALE_NUMERIC) && defined(LC_NUMERIC)
#	define USE_LOCALE_NUMERIC
#   endif
#endif /* !NO_LOCALE && HAS_SETLOCALE */

#include <setjmp.h>

#ifdef I_SYS_PARAM
#   ifdef PARAM_NEEDS_TYPES
#	include <sys/types.h>
#   endif
#   include <sys/param.h>
#endif

/* Use all the "standard" definitions? */
#if defined(STANDARD_C) && defined(I_STDLIB)
#   include <stdlib.h>
#endif

/* If this causes problems, set i_unistd=undef in the hint file.  */
#ifdef I_UNISTD
#   include <unistd.h>
#endif

#if defined(HAS_SYSCALL) && !defined(HAS_SYSCALL_PROTO) && !defined(PERL_MICRO)
int syscall(int, ...);
#endif

#if defined(HAS_USLEEP) && !defined(HAS_USLEEP_PROTO) && !defined(PERL_MICRO)
int usleep(unsigned int);
#endif

#ifdef PERL_MICRO /* Last chance to export Perl_my_swap */
#  define MYSWAP
#endif

#ifdef PERL_CORE

/* macros for correct constant construction */
# if INTSIZE >= 2
#  define U16_CONST(x) ((U16)x##U)
# else
#  define U16_CONST(x) ((U16)x##UL)
# endif

# if INTSIZE >= 4
#  define U32_CONST(x) ((U32)x##U)
# else
#  define U32_CONST(x) ((U32)x##UL)
# endif

# ifdef HAS_QUAD
#  if INTSIZE >= 8
#   define U64_CONST(x) ((U64)x##U)
#  elif LONGSIZE >= 8
#   define U64_CONST(x) ((U64)x##UL)
#  elif QUADKIND == QUAD_IS_LONG_LONG
#   define U64_CONST(x) ((U64)x##ULL)
#  else /* best guess we can make */
#   define U64_CONST(x) ((U64)x##UL)
#  endif
# endif

/* byte-swapping functions for big-/little-endian conversion */
# define _swab_16_(x) ((U16)( \
         (((U16)(x) & U16_CONST(0x00ff)) << 8) | \
         (((U16)(x) & U16_CONST(0xff00)) >> 8) ))

# define _swab_32_(x) ((U32)( \
         (((U32)(x) & U32_CONST(0x000000ff)) << 24) | \
         (((U32)(x) & U32_CONST(0x0000ff00)) <<  8) | \
         (((U32)(x) & U32_CONST(0x00ff0000)) >>  8) | \
         (((U32)(x) & U32_CONST(0xff000000)) >> 24) ))

# ifdef HAS_QUAD
#  define _swab_64_(x) ((U64)( \
          (((U64)(x) & U64_CONST(0x00000000000000ff)) << 56) | \
          (((U64)(x) & U64_CONST(0x000000000000ff00)) << 40) | \
          (((U64)(x) & U64_CONST(0x0000000000ff0000)) << 24) | \
          (((U64)(x) & U64_CONST(0x00000000ff000000)) <<  8) | \
          (((U64)(x) & U64_CONST(0x000000ff00000000)) >>  8) | \
          (((U64)(x) & U64_CONST(0x0000ff0000000000)) >> 24) | \
          (((U64)(x) & U64_CONST(0x00ff000000000000)) >> 40) | \
          (((U64)(x) & U64_CONST(0xff00000000000000)) >> 56) ))
# endif

/*----------------------------------------------------------------------------*/
# if BYTEORDER == 0x1234 || BYTEORDER == 0x12345678  /*     little-endian     */
/*----------------------------------------------------------------------------*/
#  define my_htole16(x)		(x)
#  define my_letoh16(x)		(x)
#  define my_htole32(x)		(x)
#  define my_letoh32(x)		(x)
#  define my_htobe16(x)		_swab_16_(x)
#  define my_betoh16(x)		_swab_16_(x)
#  define my_htobe32(x)		_swab_32_(x)
#  define my_betoh32(x)		_swab_32_(x)
#  ifdef HAS_QUAD
#   define my_htole64(x)	(x)
#   define my_letoh64(x)	(x)
#   define my_htobe64(x)	_swab_64_(x)
#   define my_betoh64(x)	_swab_64_(x)
#  endif
#  define my_htoles(x)		(x)
#  define my_letohs(x)		(x)
#  define my_htolei(x)		(x)
#  define my_letohi(x)		(x)
#  define my_htolel(x)		(x)
#  define my_letohl(x)		(x)
#  if SHORTSIZE == 1
#   define my_htobes(x)		(x)
#   define my_betohs(x)		(x)
#  elif SHORTSIZE == 2
#   define my_htobes(x)		_swab_16_(x)
#   define my_betohs(x)		_swab_16_(x)
#  elif SHORTSIZE == 4
#   define my_htobes(x)		_swab_32_(x)
#   define my_betohs(x)		_swab_32_(x)
#  elif SHORTSIZE == 8
#   define my_htobes(x)		_swab_64_(x)
#   define my_betohs(x)		_swab_64_(x)
#  else
#   define PERL_NEED_MY_HTOBES
#   define PERL_NEED_MY_BETOHS
#  endif
#  if INTSIZE == 1
#   define my_htobei(x)		(x)
#   define my_betohi(x)		(x)
#  elif INTSIZE == 2
#   define my_htobei(x)		_swab_16_(x)
#   define my_betohi(x)		_swab_16_(x)
#  elif INTSIZE == 4
#   define my_htobei(x)		_swab_32_(x)
#   define my_betohi(x)		_swab_32_(x)
#  elif INTSIZE == 8
#   define my_htobei(x)		_swab_64_(x)
#   define my_betohi(x)		_swab_64_(x)
#  else
#   define PERL_NEED_MY_HTOBEI
#   define PERL_NEED_MY_BETOHI
#  endif
#  if LONGSIZE == 1
#   define my_htobel(x)		(x)
#   define my_betohl(x)		(x)
#  elif LONGSIZE == 2
#   define my_htobel(x)		_swab_16_(x)
#   define my_betohl(x)		_swab_16_(x)
#  elif LONGSIZE == 4
#   define my_htobel(x)		_swab_32_(x)
#   define my_betohl(x)		_swab_32_(x)
#  elif LONGSIZE == 8
#   define my_htobel(x)		_swab_64_(x)
#   define my_betohl(x)		_swab_64_(x)
#  else
#   define PERL_NEED_MY_HTOBEL
#   define PERL_NEED_MY_BETOHL
#  endif
#  define my_htolen(p,n)	NOOP
#  define my_letohn(p,n)	NOOP
#  define my_htoben(p,n)	my_swabn(p,n)
#  define my_betohn(p,n)	my_swabn(p,n)
/*----------------------------------------------------------------------------*/
# elif BYTEORDER == 0x4321 || BYTEORDER == 0x87654321  /*     big-endian      */
/*----------------------------------------------------------------------------*/
#  define my_htobe16(x)		(x)
#  define my_betoh16(x)		(x)
#  define my_htobe32(x)		(x)
#  define my_betoh32(x)		(x)
#  define my_htole16(x)		_swab_16_(x)
#  define my_letoh16(x)		_swab_16_(x)
#  define my_htole32(x)		_swab_32_(x)
#  define my_letoh32(x)		_swab_32_(x)
#  ifdef HAS_QUAD
#   define my_htobe64(x)	(x)
#   define my_betoh64(x)	(x)
#   define my_htole64(x)	_swab_64_(x)
#   define my_letoh64(x)	_swab_64_(x)
#  endif
#  define my_htobes(x)		(x)
#  define my_betohs(x)		(x)
#  define my_htobei(x)		(x)
#  define my_betohi(x)		(x)
#  define my_htobel(x)		(x)
#  define my_betohl(x)		(x)
#  if SHORTSIZE == 1
#   define my_htoles(x)		(x)
#   define my_letohs(x)		(x)
#  elif SHORTSIZE == 2
#   define my_htoles(x)		_swab_16_(x)
#   define my_letohs(x)		_swab_16_(x)
#  elif SHORTSIZE == 4
#   define my_htoles(x)		_swab_32_(x)
#   define my_letohs(x)		_swab_32_(x)
#  elif SHORTSIZE == 8
#   define my_htoles(x)		_swab_64_(x)
#   define my_letohs(x)		_swab_64_(x)
#  else
#   define PERL_NEED_MY_HTOLES
#   define PERL_NEED_MY_LETOHS
#  endif
#  if INTSIZE == 1
#   define my_htolei(x)		(x)
#   define my_letohi(x)		(x)
#  elif INTSIZE == 2
#   define my_htolei(x)		_swab_16_(x)
#   define my_letohi(x)		_swab_16_(x)
#  elif INTSIZE == 4
#   define my_htolei(x)		_swab_32_(x)
#   define my_letohi(x)		_swab_32_(x)
#  elif INTSIZE == 8
#   define my_htolei(x)		_swab_64_(x)
#   define my_letohi(x)		_swab_64_(x)
#  else
#   define PERL_NEED_MY_HTOLEI
#   define PERL_NEED_MY_LETOHI
#  endif
#  if LONGSIZE == 1
#   define my_htolel(x)		(x)
#   define my_letohl(x)		(x)
#  elif LONGSIZE == 2
#   define my_htolel(x)		_swab_16_(x)
#   define my_letohl(x)		_swab_16_(x)
#  elif LONGSIZE == 4
#   define my_htolel(x)		_swab_32_(x)
#   define my_letohl(x)		_swab_32_(x)
#  elif LONGSIZE == 8
#   define my_htolel(x)		_swab_64_(x)
#   define my_letohl(x)		_swab_64_(x)
#  else
#   define PERL_NEED_MY_HTOLEL
#   define PERL_NEED_MY_LETOHL
#  endif
#  define my_htolen(p,n)	my_swabn(p,n)
#  define my_letohn(p,n)	my_swabn(p,n)
#  define my_htoben(p,n)	NOOP
#  define my_betohn(p,n)	NOOP
/*----------------------------------------------------------------------------*/
# else /*                       all other byte-orders                         */
/*----------------------------------------------------------------------------*/
#  define PERL_NEED_MY_HTOLE16
#  define PERL_NEED_MY_LETOH16
#  define PERL_NEED_MY_HTOBE16
#  define PERL_NEED_MY_BETOH16
#  define PERL_NEED_MY_HTOLE32
#  define PERL_NEED_MY_LETOH32
#  define PERL_NEED_MY_HTOBE32
#  define PERL_NEED_MY_BETOH32
#  ifdef HAS_QUAD
#   define PERL_NEED_MY_HTOLE64
#   define PERL_NEED_MY_LETOH64
#   define PERL_NEED_MY_HTOBE64
#   define PERL_NEED_MY_BETOH64
#  endif
#  define PERL_NEED_MY_HTOLES
#  define PERL_NEED_MY_LETOHS
#  define PERL_NEED_MY_HTOBES
#  define PERL_NEED_MY_BETOHS
#  define PERL_NEED_MY_HTOLEI
#  define PERL_NEED_MY_LETOHI
#  define PERL_NEED_MY_HTOBEI
#  define PERL_NEED_MY_BETOHI
#  define PERL_NEED_MY_HTOLEL
#  define PERL_NEED_MY_LETOHL
#  define PERL_NEED_MY_HTOBEL
#  define PERL_NEED_MY_BETOHL
/*----------------------------------------------------------------------------*/
# endif /*                     end of byte-order macros                       */
/*----------------------------------------------------------------------------*/

/* The old value was hard coded at 1008. (4096-16) seems to be a bit faster,
   at least on FreeBSD.  YMMV, so experiment.  */
#ifndef PERL_ARENA_SIZE
#define PERL_ARENA_SIZE 4080
#endif

#endif /* PERL_CORE */

/* Cannot include embed.h here on Win32 as win32.h has not 
   yet been included and defines some config variables e.g. HAVE_INTERP_INTERN
 */
#if !defined(PERL_FOR_X2P) && !(defined(WIN32)||defined(VMS))
#  include "embed.h"
#endif

#define MEM_SIZE Size_t

/* Round all values passed to malloc up, by default to a multiple of
   sizeof(size_t)
*/
#ifndef PERL_STRLEN_ROUNDUP_QUANTUM
#define PERL_STRLEN_ROUNDUP_QUANTUM Size_t_size
#endif

#if defined(STANDARD_C) && defined(I_STDDEF)
#   include <stddef.h>
#   define STRUCT_OFFSET(s,m)  offsetof(s,m)
#else
#   define STRUCT_OFFSET(s,m)  (Size_t)(&(((s *)0)->m))
#endif

#if defined(I_STRING) || defined(__cplusplus)
#   include <string.h>
#else
#   include <strings.h>
#endif

/* This comes after <stdlib.h> so we don't try to change the standard
 * library prototypes; we'll use our own in proto.h instead. */

#ifdef MYMALLOC
#  ifdef PERL_POLLUTE_MALLOC
#   ifndef PERL_EXTMALLOC_DEF
#    define Perl_malloc		malloc
#    define Perl_calloc		calloc
#    define Perl_realloc	realloc
#    define Perl_mfree		free
#   endif
#  else
#    define EMBEDMYMALLOC	/* for compatibility */
#  endif

#  define safemalloc  Perl_malloc
#  define safecalloc  Perl_calloc
#  define saferealloc Perl_realloc
#  define safefree    Perl_mfree
#  define CHECK_MALLOC_TOO_LATE_FOR_(code)	STMT_START {		\
	if (!PL_tainting && MallocCfg_ptr[MallocCfg_cfg_env_read])	\
		code;							\
    } STMT_END
#  define CHECK_MALLOC_TOO_LATE_FOR(ch)				\
	CHECK_MALLOC_TOO_LATE_FOR_(MALLOC_TOO_LATE_FOR(ch))
#  define panic_write2(s)		write(2, s, strlen(s))
#  define CHECK_MALLOC_TAINT(newval)				\
	CHECK_MALLOC_TOO_LATE_FOR_(				\
		if (newval) {					\
		  panic_write2("panic: tainting with $ENV{PERL_MALLOC_OPT}\n");\
		  exit(1); })
#  define MALLOC_CHECK_TAINT(argc,argv,env)	STMT_START {	\
	if (doing_taint(argc,argv,env)) {			\
		MallocCfg_ptr[MallocCfg_skip_cfg_env] = 1;	\
    }} STMT_END;
#else  /* MYMALLOC */
#  define safemalloc  safesysmalloc
#  define safecalloc  safesyscalloc
#  define saferealloc safesysrealloc
#  define safefree    safesysfree
#  define CHECK_MALLOC_TOO_LATE_FOR(ch)		((void)0)
#  define CHECK_MALLOC_TAINT(newval)		((void)0)
#  define MALLOC_CHECK_TAINT(argc,argv,env)
#endif /* MYMALLOC */

#define TOO_LATE_FOR_(ch,what)	Perl_croak(aTHX_ "\"-%c\" is on the #! line, it must also be used on the command line%s", (char)(ch), what)
#define TOO_LATE_FOR(ch)	TOO_LATE_FOR_(ch, "")
#define MALLOC_TOO_LATE_FOR(ch)	TOO_LATE_FOR_(ch, " with $ENV{PERL_MALLOC_OPT}")
#define MALLOC_CHECK_TAINT2(argc,argv)	MALLOC_CHECK_TAINT(argc,argv,NULL)

#if !defined(HAS_STRCHR) && defined(HAS_INDEX) && !defined(strchr)
#define strchr index
#define strrchr rindex
#endif

#ifdef I_MEMORY
#  include <memory.h>
#endif

#ifdef HAS_MEMCPY
#  if !defined(STANDARD_C) && !defined(I_STRING) && !defined(I_MEMORY)
#    ifndef memcpy
        extern char * memcpy (char*, char*, int);
#    endif
#  endif
#else
#   ifndef memcpy
#	ifdef HAS_BCOPY
#	    define memcpy(d,s,l) bcopy(s,d,l)
#	else
#	    define memcpy(d,s,l) my_bcopy(s,d,l)
#	endif
#   endif
#endif /* HAS_MEMCPY */

#ifdef HAS_MEMSET
#  if !defined(STANDARD_C) && !defined(I_STRING) && !defined(I_MEMORY)
#    ifndef memset
	extern char *memset (char*, int, int);
#    endif
#  endif
#else
#  undef  memset
#  define memset(d,c,l) my_memset(d,c,l)
#endif /* HAS_MEMSET */

#if !defined(HAS_MEMMOVE) && !defined(memmove)
#   if defined(HAS_BCOPY) && defined(HAS_SAFE_BCOPY)
#	define memmove(d,s,l) bcopy(s,d,l)
#   else
#	if defined(HAS_MEMCPY) && defined(HAS_SAFE_MEMCPY)
#	    define memmove(d,s,l) memcpy(d,s,l)
#	else
#	    define memmove(d,s,l) my_bcopy(s,d,l)
#	endif
#   endif
#endif

#if defined(mips) && defined(ultrix) && !defined(__STDC__)
#   undef HAS_MEMCMP
#endif

#if defined(HAS_MEMCMP) && defined(HAS_SANE_MEMCMP)
#  if !defined(STANDARD_C) && !defined(I_STRING) && !defined(I_MEMORY)
#    ifndef memcmp
	extern int memcmp (char*, char*, int);
#    endif
#  endif
#  ifdef BUGGY_MSC
#    pragma function(memcmp)
#  endif
#else
#   ifndef memcmp
#	define memcmp 	my_memcmp
#   endif
#endif /* HAS_MEMCMP && HAS_SANE_MEMCMP */

#ifndef memzero
#   ifdef HAS_MEMSET
#	define memzero(d,l) memset(d,0,l)
#   else
#	ifdef HAS_BZERO
#	    define memzero(d,l) bzero(d,l)
#	else
#	    define memzero(d,l) my_bzero(d,l)
#	endif
#   endif
#endif

#ifndef PERL_MICRO
#ifndef memchr
#   ifndef HAS_MEMCHR
#       define memchr(s,c,n) ninstr((char*)(s), ((char*)(s)) + n, &(c), &(c) + 1)
#   endif
#endif
#endif

#ifndef HAS_BCMP
#   ifndef bcmp
#	define bcmp(s1,s2,l) memcmp(s1,s2,l)
#   endif
#endif /* !HAS_BCMP */

#ifdef I_NETINET_IN
#   include <netinet/in.h>
#endif

#ifdef I_ARPA_INET
#   include <arpa/inet.h>
#endif

#if defined(SF_APPEND) && defined(USE_SFIO) && defined(I_SFIO)
/* <sfio.h> defines SF_APPEND and <sys/stat.h> might define SF_APPEND
 * (the neo-BSD seem to do this).  */
#   undef SF_APPEND
#endif

#ifdef I_SYS_STAT
#   include <sys/stat.h>
#endif

/* The stat macros for Amdahl UTS, Unisoft System V/88 (and derivatives
   like UTekV) are broken, sometimes giving false positives.  Undefine
   them here and let the code below set them to proper values.

   The ghs macro stands for GreenHills Software C-1.8.5 which
   is the C compiler for sysV88 and the various derivatives.
   This header file bug is corrected in gcc-2.5.8 and later versions.
   --Kaveh Ghazi (ghazi@noc.rutgers.edu) 10/3/94.  */

#if defined(uts) || (defined(m88k) && defined(ghs))
#   undef S_ISDIR
#   undef S_ISCHR
#   undef S_ISBLK
#   undef S_ISREG
#   undef S_ISFIFO
#   undef S_ISLNK
#endif

#ifdef I_TIME
#   include <time.h>
#endif

#ifdef I_SYS_TIME
#   ifdef I_SYS_TIME_KERNEL
#	define KERNEL
#   endif
#   include <sys/time.h>
#   ifdef I_SYS_TIME_KERNEL
#	undef KERNEL
#   endif
#endif

#if defined(HAS_TIMES) && defined(I_SYS_TIMES)
#    include <sys/times.h>
#endif

#if defined(HAS_STRERROR) && (!defined(HAS_MKDIR) || !defined(HAS_RMDIR))
#   undef HAS_STRERROR
#endif

#include <errno.h>

#if defined(WIN32) && defined(PERL_IMPLICIT_SYS)
#  define WIN32SCK_IS_STDSCK		/* don't pull in custom wsock layer */
#endif

/* In Tru64 use the 4.4BSD struct msghdr, not the 4.3 one.
 * This is important for using IPv6. 
 * For OSF/1 3.2, however, defining _SOCKADDR_LEN would be
 * a bad idea since it breaks send() and recv(). */
#if defined(__osf__) && defined(__alpha) && !defined(_SOCKADDR_LEN) && !defined(DEC_OSF1_3_X)
#   define _SOCKADDR_LEN
#endif

#if defined(HAS_SOCKET) && !defined(VMS) && !defined(WIN32) /* VMS/WIN32 handle sockets via vmsish.h/win32.h */
# include <sys/socket.h>
# if defined(USE_SOCKS) && defined(I_SOCKS)
#   if !defined(INCLUDE_PROTOTYPES)
#       define INCLUDE_PROTOTYPES /* for <socks.h> */
#       define PERL_SOCKS_NEED_PROTOTYPES
#   endif
#   ifdef USE_5005THREADS
#       define PERL_USE_THREADS /* store our value */
#       undef USE_5005THREADS
#   endif
#   include <socks.h>
#   ifdef USE_5005THREADS
#       undef USE_5005THREADS /* socks.h does this on its own */
#   endif
#   ifdef PERL_USE_THREADS
#       define USE_5005THREADS /* restore our value */
#       undef PERL_USE_THREADS
#   endif
#   ifdef PERL_SOCKS_NEED_PROTOTYPES /* keep cpp space clean */
#       undef INCLUDE_PROTOTYPES
#       undef PERL_SOCKS_NEED_PROTOTYPES
#   endif
# endif
# ifdef I_NETDB
#  ifdef NETWARE
#   include<stdio.h>
#  endif
#  include <netdb.h>
# endif
# ifndef ENOTSOCK
#  ifdef I_NET_ERRNO
#   include <net/errno.h>
#  endif
# endif
#endif

/* sockatmark() is so new (2001) that many places might have it hidden
 * behind some -D_BLAH_BLAH_SOURCE guard.  The __THROW magic is required
 * e.g. in Gentoo, see http://bugs.gentoo.org/show_bug.cgi?id=12605 */
#if defined(HAS_SOCKATMARK) && !defined(HAS_SOCKATMARK_PROTO)
# if defined(__THROW) && defined(__GLIBC__)
int sockatmark(int) __THROW;
# else
int sockatmark(int);
# endif
#endif

#ifdef SETERRNO
# undef SETERRNO  /* SOCKS might have defined this */
#endif

#ifdef VMS
#   define SETERRNO(errcode,vmserrcode) \
	STMT_START {			\
	    set_errno(errcode);		\
	    set_vaxc_errno(vmserrcode);	\
	} STMT_END
#   define LIB_INVARG 		LIB$_INVARG
#   define RMS_DIR    		RMS$_DIR
#   define RMS_FAC    		RMS$_FAC
#   define RMS_FEX    		RMS$_FEX
#   define RMS_FNF    		RMS$_FNF
#   define RMS_IFI    		RMS$_IFI
#   define RMS_ISI    		RMS$_ISI
#   define RMS_PRV    		RMS$_PRV
#   define SS_ACCVIO      	SS$_ACCVIO
#   define SS_DEVOFFLINE	SS$_DEVOFFLINE
#   define SS_IVCHAN  		SS$_IVCHAN
#   define SS_NORMAL  		SS$_NORMAL
#else
#   define SETERRNO(errcode,vmserrcode) (errno = (errcode))
#   define LIB_INVARG 		0
#   define RMS_DIR    		0
#   define RMS_FAC    		0
#   define RMS_FEX    		0
#   define RMS_FNF    		0
#   define RMS_IFI    		0
#   define RMS_ISI    		0
#   define RMS_PRV    		0
#   define SS_ACCVIO      	0
#   define SS_DEVOFFLINE	0
#   define SS_IVCHAN  		0
#   define SS_NORMAL  		0
#endif

#ifdef USE_5005THREADS
#  define ERRSV (thr->errsv)
#  define DEFSV THREADSV(0)
#  define SAVE_DEFSV save_threadsv(0)
#else
/* FIXME? Change the assignments to PL_defgv to instantiate GvSV?  */
#  define ERRSV GvSV(PL_errgv)
#  define DEFSV GvSVn(PL_defgv)
#  define SAVE_DEFSV SAVESPTR(GvSV(PL_defgv))
#endif /* USE_5005THREADS */

#define ERRHV GvHV(PL_errgv)	/* XXX unused, here for compatibility */

#ifndef errno
	extern int errno;     /* ANSI allows errno to be an lvalue expr.
			       * For example in multithreaded environments
			       * something like this might happen:
			       * extern int *_errno(void);
			       * #define errno (*_errno()) */
#endif

#ifdef HAS_STRERROR
#       ifdef VMS
	char *strerror (int,...);
#       else
#ifndef DONT_DECLARE_STD
	char *strerror (int);
#endif
#       endif
#       ifndef Strerror
#           define Strerror strerror
#       endif
#else
#    ifdef HAS_SYS_ERRLIST
	extern int sys_nerr;
	extern char *sys_errlist[];
#       ifndef Strerror
#           define Strerror(e) \
		((e) < 0 || (e) >= sys_nerr ? "(unknown)" : sys_errlist[e])
#       endif
#   endif
#endif

#ifdef I_SYS_IOCTL
#   ifndef _IOCTL_
#	include <sys/ioctl.h>
#   endif
#endif

#if defined(mc300) || defined(mc500) || defined(mc700) || defined(mc6000)
#   ifdef HAS_SOCKETPAIR
#	undef HAS_SOCKETPAIR
#   endif
#   ifdef I_NDBM
#	undef I_NDBM
#   endif
#endif

#ifndef HAS_SOCKETPAIR
#   ifdef HAS_SOCKET
#	define socketpair Perl_my_socketpair
#   endif
#endif

#if INTSIZE == 2
#   define htoni htons
#   define ntohi ntohs
#else
#   define htoni htonl
#   define ntohi ntohl
#endif

/* Configure already sets Direntry_t */
#if defined(I_DIRENT)
#   include <dirent.h>
    /* NeXT needs dirent + sys/dir.h */
#   if  defined(I_SYS_DIR) && (defined(NeXT) || defined(__NeXT__))
#	include <sys/dir.h>
#   endif
#else
#   ifdef I_SYS_NDIR
#	include <sys/ndir.h>
#   else
#	ifdef I_SYS_DIR
#	    ifdef hp9000s500
#		include <ndir.h>	/* may be wrong in the future */
#	    else
#		include <sys/dir.h>
#	    endif
#	endif
#   endif
#endif

#ifdef PERL_MICRO
#   ifndef DIR
#      define DIR void
#   endif
#endif

#ifdef FPUTS_BOTCH
/* work around botch in SunOS 4.0.1 and 4.0.2 */
#   ifndef fputs
#	define fputs(sv,fp) fprintf(fp,"%s",sv)
#   endif
#endif

/*
 * The following gobbledygook brought to you on behalf of __STDC__.
 * (I could just use #ifndef __STDC__, but this is more bulletproof
 * in the face of half-implementations.)
 */

#if defined(I_SYSMODE) && !defined(PERL_MICRO)
#include <sys/mode.h>
#endif

#ifndef S_IFMT
#   ifdef _S_IFMT
#	define S_IFMT _S_IFMT
#   else
#	define S_IFMT 0170000
#   endif
#endif

#ifndef S_ISDIR
#   define S_ISDIR(m) ((m & S_IFMT) == S_IFDIR)
#endif

#ifndef S_ISCHR
#   define S_ISCHR(m) ((m & S_IFMT) == S_IFCHR)
#endif

#ifndef S_ISBLK
#   ifdef S_IFBLK
#	define S_ISBLK(m) ((m & S_IFMT) == S_IFBLK)
#   else
#	define S_ISBLK(m) (0)
#   endif
#endif

#ifndef S_ISREG
#   define S_ISREG(m) ((m & S_IFMT) == S_IFREG)
#endif

#ifndef S_ISFIFO
#   ifdef S_IFIFO
#	define S_ISFIFO(m) ((m & S_IFMT) == S_IFIFO)
#   else
#	define S_ISFIFO(m) (0)
#   endif
#endif

#ifndef S_ISLNK
#   ifdef _S_ISLNK
#	define S_ISLNK(m) _S_ISLNK(m)
#   else
#	ifdef _S_IFLNK
#	    define S_ISLNK(m) ((m & S_IFMT) == _S_IFLNK)
#	else
#	    ifdef S_IFLNK
#		define S_ISLNK(m) ((m & S_IFMT) == S_IFLNK)
#	    else
#		define S_ISLNK(m) (0)
#	    endif
#	endif
#   endif
#endif

#ifndef S_ISSOCK
#   ifdef _S_ISSOCK
#	define S_ISSOCK(m) _S_ISSOCK(m)
#   else
#	ifdef _S_IFSOCK
#	    define S_ISSOCK(m) ((m & S_IFMT) == _S_IFSOCK)
#	else
#	    ifdef S_IFSOCK
#		define S_ISSOCK(m) ((m & S_IFMT) == S_IFSOCK)
#	    else
#		define S_ISSOCK(m) (0)
#	    endif
#	endif
#   endif
#endif

#ifndef S_IRUSR
#   ifdef S_IREAD
#	define S_IRUSR S_IREAD
#	define S_IWUSR S_IWRITE
#	define S_IXUSR S_IEXEC
#   else
#	define S_IRUSR 0400
#	define S_IWUSR 0200
#	define S_IXUSR 0100
#   endif
#endif

#ifndef S_IRGRP
#   ifdef S_IRUSR
#       define S_IRGRP (S_IRUSR>>3)
#       define S_IWGRP (S_IWUSR>>3)
#       define S_IXGRP (S_IXUSR>>3)
#   else
#       define S_IRGRP 0040
#       define S_IWGRP 0020
#       define S_IXGRP 0010
#   endif
#endif

#ifndef S_IROTH
#   ifdef S_IRUSR
#       define S_IROTH (S_IRUSR>>6)
#       define S_IWOTH (S_IWUSR>>6)
#       define S_IXOTH (S_IXUSR>>6)
#   else
#       define S_IROTH 0040
#       define S_IWOTH 0020
#       define S_IXOTH 0010
#   endif
#endif

#ifndef S_ISUID
#   define S_ISUID 04000
#endif

#ifndef S_ISGID
#   define S_ISGID 02000
#endif

#ifndef S_IRWXU
#   define S_IRWXU (S_IRUSR|S_IWUSR|S_IXUSR)
#endif

#ifndef S_IRWXG
#   define S_IRWXG (S_IRGRP|S_IWGRP|S_IXGRP)
#endif

#ifndef S_IRWXO
#   define S_IRWXO (S_IROTH|S_IWOTH|S_IXOTH)
#endif

/* BeOS 5.0 seems to define S_IREAD and S_IWRITE in <posix/fcntl.h>
 * which would get included through <sys/file.h >, but that is 3000
 * lines in the future.  --jhi */

#if !defined(S_IREAD) && !defined(__BEOS__)
#   define S_IREAD S_IRUSR
#endif

#if !defined(S_IWRITE) && !defined(__BEOS__)
#   define S_IWRITE S_IWUSR
#endif

#ifndef S_IEXEC
#   define S_IEXEC S_IXUSR
#endif

#ifdef ff_next
#   undef ff_next
#endif

#if defined(cray) || defined(gould) || defined(i860) || defined(pyr)
#   define SLOPPYDIVIDE
#endif

#ifdef UV
#undef UV
#endif

#ifdef	SPRINTF_E_BUG
#  define sprintf UTS_sprintf_wrap
#endif

/* Configure gets this right but the UTS compiler gets it wrong.
   -- Hal Morris <hom00@utsglobal.com> */
#ifdef UTS
#  undef  UVTYPE
#  define UVTYPE unsigned
#endif

/*
    The IV type is supposed to be long enough to hold any integral
    value or a pointer.
    --Andy Dougherty	August 1996
*/

typedef IVTYPE IV;
typedef UVTYPE UV;

#if defined(USE_64_BIT_INT) && defined(HAS_QUAD)
#  if QUADKIND == QUAD_IS_INT64_T && defined(INT64_MAX)
#    define IV_MAX INT64_MAX
#    define IV_MIN INT64_MIN
#    define UV_MAX UINT64_MAX
#    ifndef UINT64_MIN
#      define UINT64_MIN 0
#    endif
#    define UV_MIN UINT64_MIN
#  else
#    define IV_MAX PERL_QUAD_MAX
#    define IV_MIN PERL_QUAD_MIN
#    define UV_MAX PERL_UQUAD_MAX
#    define UV_MIN PERL_UQUAD_MIN
#  endif
#  define IV_IS_QUAD
#  define UV_IS_QUAD
#else
#  if defined(INT32_MAX) && IVSIZE == 4
#    define IV_MAX INT32_MAX
#    define IV_MIN INT32_MIN
#    ifndef UINT32_MAX_BROKEN /* e.g. HP-UX with gcc messes this up */
#        define UV_MAX UINT32_MAX
#    else
#        define UV_MAX 4294967295U
#    endif
#    ifndef UINT32_MIN
#      define UINT32_MIN 0
#    endif
#    define UV_MIN UINT32_MIN
#  else
#    define IV_MAX PERL_LONG_MAX
#    define IV_MIN PERL_LONG_MIN
#    define UV_MAX PERL_ULONG_MAX
#    define UV_MIN PERL_ULONG_MIN
#  endif
#  if IVSIZE == 8
#    define IV_IS_QUAD
#    define UV_IS_QUAD
#    ifndef HAS_QUAD
#      define HAS_QUAD
#    endif
#  else
#    undef IV_IS_QUAD
#    undef UV_IS_QUAD
#    undef HAS_QUAD
#  endif
#endif

#ifndef HAS_QUAD
# undef PERL_NEED_MY_HTOLE64
# undef PERL_NEED_MY_LETOH64
# undef PERL_NEED_MY_HTOBE64
# undef PERL_NEED_MY_BETOH64
#endif

#if defined(uts) || defined(UTS)
#	undef UV_MAX
#	define UV_MAX (4294967295u)
#endif

#define IV_DIG (BIT_DIGITS(IVSIZE * 8))
#define UV_DIG (BIT_DIGITS(UVSIZE * 8))

#ifndef NO_PERL_PRESERVE_IVUV
#define PERL_PRESERVE_IVUV	/* We like our integers to stay integers. */
#endif

/*
 *  The macros INT2PTR and NUM2PTR are (despite their names)
 *  bi-directional: they will convert int/float to or from pointers.
 *  However the conversion to int/float are named explicitly:
 *  PTR2IV, PTR2UV, PTR2NV.
 *
 *  For int conversions we do not need two casts if pointers are
 *  the same size as IV and UV.   Otherwise we need an explicit
 *  cast (PTRV) to avoid compiler warnings.
 */
#if (IVSIZE == PTRSIZE) && (UVSIZE == PTRSIZE)
#  define PTRV			UV
#  define INT2PTR(any,d)	(any)(d)
#else
#  if PTRSIZE == LONGSIZE
#    define PTRV		unsigned long
#    define PTR2ul(p)		(unsigned long)(p)
#  else
#    define PTRV		unsigned
#  endif
#endif

#ifndef INT2PTR
#  define INT2PTR(any,d)	(any)(PTRV)(d)
#endif

#ifndef PTR2ul
#  define PTR2ul(p)	INT2PTR(unsigned long,p)	
#endif

#define NUM2PTR(any,d)	(any)(PTRV)(d)
#define PTR2IV(p)	INT2PTR(IV,p)
#define PTR2UV(p)	INT2PTR(UV,p)
#define PTR2NV(p)	NUM2PTR(NV,p)
#define PTR2nat(p)	(PTRV)(p)	/* pointer to integer of PTRSIZE */

/* According to strict ANSI C89 one cannot freely cast between
 * data pointers and function (code) pointers.  There are at least
 * two ways around this.  One (used below) is to do two casts,
 * first the other pointer to an (unsigned) integer, and then
 * the integer to the other pointer.  The other way would be
 * to use unions to "overlay" the pointers.  For an example of
 * the latter technique, see union dirpu in struct xpvio in sv.h.
 * The only feasible use is probably temporarily storing
 * function pointers in a data pointer (such as a void pointer). */

#define DPTR2FPTR(t,p) ((t)PTR2nat(p))	/* data pointer to function pointer */
#define FPTR2DPTR(t,p) ((t)PTR2nat(p))	/* function pointer to data pointer */

#ifdef USE_LONG_DOUBLE
#  if defined(HAS_LONG_DOUBLE) && LONG_DOUBLESIZE == DOUBLESIZE
#      define LONG_DOUBLE_EQUALS_DOUBLE
#  endif
#  if !(defined(HAS_LONG_DOUBLE) && (LONG_DOUBLESIZE > DOUBLESIZE))
#     undef USE_LONG_DOUBLE /* Ouch! */
#  endif
#endif

#ifdef OVR_DBL_DIG
/* Use an overridden DBL_DIG */
# ifdef DBL_DIG
#  undef DBL_DIG
# endif
# define DBL_DIG OVR_DBL_DIG
#else
/* The following is all to get DBL_DIG, in order to pick a nice
   default value for printing floating point numbers in Gconvert
   (see config.h). (It also has other uses, such as figuring out if
   a given precision of printing can be done with a double instead of
   a long double - Allen).
*/
#ifdef I_LIMITS
#include <limits.h>
#endif
#ifdef I_FLOAT
#include <float.h>
#endif
#ifndef HAS_DBL_DIG
#define DBL_DIG	15   /* A guess that works lots of places */
#endif
#endif
#ifdef I_FLOAT
#include <float.h>
#endif
#ifndef HAS_DBL_DIG
#define DBL_DIG	15   /* A guess that works lots of places */
#endif

#ifdef OVR_LDBL_DIG
/* Use an overridden LDBL_DIG */
# ifdef LDBL_DIG
#  undef LDBL_DIG
# endif
# define LDBL_DIG OVR_LDBL_DIG
#else
/* The following is all to get LDBL_DIG, in order to pick a nice
   default value for printing floating point numbers in Gconvert.
   (see config.h)
*/
# ifdef I_LIMITS
#   include <limits.h>
# endif
# ifdef I_FLOAT
#  include <float.h>
# endif
# ifndef HAS_LDBL_DIG
#  if LONG_DOUBLESIZE == 10
#   define LDBL_DIG 18 /* assume IEEE */
#  else
#   if LONG_DOUBLESIZE == 12
#    define LDBL_DIG 18 /* gcc? */
#   else
#    if LONG_DOUBLESIZE == 16
#     define LDBL_DIG 33 /* assume IEEE */
#    else
#     if LONG_DOUBLESIZE == DOUBLESIZE
#      define LDBL_DIG DBL_DIG /* bummer */
#     endif
#    endif
#   endif
#  endif
# endif
#endif

/*
 * This is for making sure we have a good DBL_MAX value, if possible,
 * either for usage as NV_MAX or for usage in figuring out if we can
 * fit a given long double into a double, if bug-fixing makes it
 * necessary to do so. - Allen <allens@cpan.org>
 */

#ifdef I_LIMITS
#  include <limits.h>
#endif

#ifdef I_VALUES
#  if !(defined(DBL_MIN) && defined(DBL_MAX) && defined(I_LIMITS))
#    include <values.h>
#    if defined(MAXDOUBLE) && !defined(DBL_MAX)
#      define DBL_MAX MAXDOUBLE
#    endif
#    if defined(MINDOUBLE) && !defined(DBL_MIN)
#      define DBL_MIN MINDOUBLE
#    endif
#  endif
#endif /* defined(I_VALUES) */

typedef NVTYPE NV;

#ifdef I_IEEEFP
#   include <ieeefp.h>
#endif

#ifdef USE_LONG_DOUBLE
#   ifdef I_SUNMATH
#       include <sunmath.h>
#   endif
#   define NV_DIG LDBL_DIG
#   ifdef LDBL_MANT_DIG
#       define NV_MANT_DIG LDBL_MANT_DIG
#   endif
#   ifdef LDBL_MIN
#       define NV_MIN LDBL_MIN
#   endif
#   ifdef LDBL_MAX
#       define NV_MAX LDBL_MAX
#   endif
#   ifdef LDBL_MIN_10_EXP
#       define NV_MIN_10_EXP LDBL_MIN_10_EXP
#   endif
#   ifdef LDBL_MAX_10_EXP
#       define NV_MAX_10_EXP LDBL_MAX_10_EXP
#   endif
#   ifdef LDBL_EPSILON
#       define NV_EPSILON LDBL_EPSILON
#   endif
#   ifdef LDBL_MAX
#       define NV_MAX LDBL_MAX
/* Having LDBL_MAX doesn't necessarily mean that we have LDBL_MIN... -Allen */
#   else
#       ifdef HUGE_VALL
#           define NV_MAX HUGE_VALL
#       else
#           ifdef HUGE_VAL
#               define NV_MAX ((NV)HUGE_VAL)
#           endif
#       endif
#   endif
#   ifdef HAS_SQRTL
#       define Perl_cos cosl
#       define Perl_sin sinl
#       define Perl_sqrt sqrtl
#       define Perl_exp expl
#       define Perl_log logl
#       define Perl_atan2 atan2l
#       define Perl_pow powl
#       define Perl_floor floorl
#       define Perl_ceil ceill
#       define Perl_fmod fmodl
#   endif
/* e.g. libsunmath doesn't have modfl and frexpl as of mid-March 2000 */
#   ifdef HAS_MODFL
#       define Perl_modf(x,y) modfl(x,y)
/* eg glibc 2.2 series seems to provide modfl on ppc and arm, but has no
   prototype in <math.h> */
#       ifndef HAS_MODFL_PROTO
EXTERN_C long double modfl(long double, long double *);
#	endif
#   else
#       if defined(HAS_AINTL) && defined(HAS_COPYSIGNL)
        extern long double Perl_my_modfl(long double x, long double *ip);
#           define Perl_modf(x,y) Perl_my_modfl(x,y)
#       endif
#   endif
#   ifdef HAS_FREXPL
#       define Perl_frexp(x,y) frexpl(x,y)
#   else
#       if defined(HAS_ILOGBL) && defined(HAS_SCALBNL)
        extern long double Perl_my_frexpl(long double x, int *e);
#           define Perl_frexp(x,y) Perl_my_frexpl(x,y)
#       endif
#   endif
#   ifndef Perl_isnan
#       ifdef HAS_ISNANL
#           define Perl_isnan(x) isnanl(x)
#       endif
#   endif
#   ifndef Perl_isinf
#       ifdef HAS_FINITEL
#           define Perl_isinf(x) !(finitel(x)||Perl_isnan(x))
#       endif
#   endif
#else
#   define NV_DIG DBL_DIG
#   ifdef DBL_MANT_DIG
#       define NV_MANT_DIG DBL_MANT_DIG
#   endif
#   ifdef DBL_MIN
#       define NV_MIN DBL_MIN
#   endif
#   ifdef DBL_MAX
#       define NV_MAX DBL_MAX
#   endif
#   ifdef DBL_MIN_10_EXP
#       define NV_MIN_10_EXP DBL_MIN_10_EXP
#   endif
#   ifdef DBL_MAX_10_EXP
#       define NV_MAX_10_EXP DBL_MAX_10_EXP
#   endif
#   ifdef DBL_EPSILON
#       define NV_EPSILON DBL_EPSILON
#   endif
#   ifdef DBL_MAX               /* XXX Does DBL_MAX imply having DBL_MIN? */
#       define NV_MAX DBL_MAX
#       define NV_MIN DBL_MIN
#   else
#       ifdef HUGE_VAL
#           define NV_MAX HUGE_VAL
#       endif
#   endif
#   define Perl_cos cos
#   define Perl_sin sin
#   define Perl_sqrt sqrt
#   define Perl_exp exp
#   define Perl_log log
#   define Perl_atan2 atan2
#   define Perl_pow pow
#   define Perl_floor floor
#   define Perl_ceil ceil
#   define Perl_fmod fmod
#   define Perl_modf(x,y) modf(x,y)
#   define Perl_frexp(x,y) frexp(x,y)
#endif

/* rumor has it that Win32 has _fpclass() */

/* SGI has fpclassl... but not with the same result values,
 * and it's via a typedef (not via #define), so will need to redo Configure
 * to use. Not worth the trouble, IMO, at least until the below is used
 * more places. Also has fp_class_l, BTW, via fp_class.h. Feel free to check
 * with me for the SGI manpages, SGI testing, etcetera, if you want to
 * try getting this to work with IRIX. - Allen <allens@cpan.org> */

#if !defined(Perl_fp_class) && (defined(HAS_FPCLASS)||defined(HAS_FPCLASSL))
#    ifdef I_IEEFP
#        include <ieeefp.h>
#    endif
#    ifdef I_FP
#        include <fp.h>
#    endif
#    if defined(USE_LONG_DOUBLE) && defined(HAS_FPCLASSL)
#        define Perl_fp_class()		fpclassl(x)
#    else
#        define Perl_fp_class()		fpclass(x)
#    endif
#    define Perl_fp_class_snan(x)	(Perl_fp_class(x)==FP_CLASS_SNAN)
#    define Perl_fp_class_qnan(x)	(Perl_fp_class(x)==FP_CLASS_QNAN)
#    define Perl_fp_class_nan(x)	(Perl_fp_class(x)==FP_CLASS_SNAN||Perl_fp_class(x)==FP_CLASS_QNAN)
#    define Perl_fp_class_ninf(x)	(Perl_fp_class(x)==FP_CLASS_NINF)
#    define Perl_fp_class_pinf(x)	(Perl_fp_class(x)==FP_CLASS_PINF)
#    define Perl_fp_class_inf(x)	(Perl_fp_class(x)==FP_CLASS_NINF||Perl_fp_class(x)==FP_CLASS_PINF)
#    define Perl_fp_class_nnorm(x)	(Perl_fp_class(x)==FP_CLASS_NNORM)
#    define Perl_fp_class_pnorm(x)	(Perl_fp_class(x)==FP_CLASS_PNORM)
#    define Perl_fp_class_norm(x)	(Perl_fp_class(x)==FP_CLASS_NNORM||Perl_fp_class(x)==FP_CLASS_PNORM)
#    define Perl_fp_class_ndenorm(x)	(Perl_fp_class(x)==FP_CLASS_NDENORM)
#    define Perl_fp_class_pdenorm(x)	(Perl_fp_class(x)==FP_CLASS_PDENORM)
#    define Perl_fp_class_denorm(x)	(Perl_fp_class(x)==FP_CLASS_NDENORM||Perl_fp_class(x)==FP_CLASS_PDENORM)
#    define Perl_fp_class_nzero(x)	(Perl_fp_class(x)==FP_CLASS_NZERO)
#    define Perl_fp_class_pzero(x)	(Perl_fp_class(x)==FP_CLASS_PZERO)
#    define Perl_fp_class_zero(x)	(Perl_fp_class(x)==FP_CLASS_NZERO||Perl_fp_class(x)==FP_CLASS_PZERO)
#endif

#if !defined(Perl_fp_class) && defined(HAS_FP_CLASS) && !defined(PERL_MICRO)
#    include <math.h>
#    if !defined(FP_SNAN) && defined(I_FP_CLASS)
#        include <fp_class.h>
#    endif
#    define Perl_fp_class(x)		fp_class(x)
#    define Perl_fp_class_snan(x)	(fp_class(x)==FP_SNAN)
#    define Perl_fp_class_qnan(x)	(fp_class(x)==FP_QNAN)
#    define Perl_fp_class_nan(x)	(fp_class(x)==FP_SNAN||fp_class(x)==FP_QNAN)
#    define Perl_fp_class_ninf(x)	(fp_class(x)==FP_NEG_INF)
#    define Perl_fp_class_pinf(x)	(fp_class(x)==FP_POS_INF)
#    define Perl_fp_class_inf(x)	(fp_class(x)==FP_NEG_INF||fp_class(x)==FP_POS_INF)
#    define Perl_fp_class_nnorm(x)	(fp_class(x)==FP_NEG_NORM)
#    define Perl_fp_class_pnorm(x)	(fp_class(x)==FP_POS_NORM)
#    define Perl_fp_class_norm(x)	(fp_class(x)==FP_NEG_NORM||fp_class(x)==FP_POS_NORM)
#    define Perl_fp_class_ndenorm(x)	(fp_class(x)==FP_NEG_DENORM)
#    define Perl_fp_class_pdenorm(x)	(fp_class(x)==FP_POS_DENORM)
#    define Perl_fp_class_denorm(x)	(fp_class(x)==FP_NEG_DENORM||fp_class(x)==FP_POS_DENORM)
#    define Perl_fp_class_nzero(x)	(fp_class(x)==FP_NEG_ZERO)
#    define Perl_fp_class_pzero(x)	(fp_class(x)==FP_POS_ZERO)
#    define Perl_fp_class_zero(x)	(fp_class(x)==FP_NEG_ZERO||fp_class(x)==FP_POS_ZERO)
#endif

#if !defined(Perl_fp_class) && defined(HAS_FPCLASSIFY)
#    include <math.h>
#    define Perl_fp_class(x)		fpclassify(x)
#    define Perl_fp_class_nan(x)	(fp_classify(x)==FP_SNAN||fp_classify(x)==FP_QNAN)
#    define Perl_fp_class_inf(x)	(fp_classify(x)==FP_INFINITE)
#    define Perl_fp_class_norm(x)	(fp_classify(x)==FP_NORMAL)
#    define Perl_fp_class_denorm(x)	(fp_classify(x)==FP_SUBNORMAL)
#    define Perl_fp_class_zero(x)	(fp_classify(x)==FP_ZERO)
#endif

#if !defined(Perl_fp_class) && defined(HAS_CLASS)
#    include <math.h>
#    ifndef _cplusplus
#        define Perl_fp_class(x)	class(x)
#    else
#        define Perl_fp_class(x)	_class(x)
#    endif
#    define Perl_fp_class_snan(x)	(Perl_fp_class(x)==FP_NANS)
#    define Perl_fp_class_qnan(x)	(Perl_fp_class(x)==FP_NANQ)
#    define Perl_fp_class_nan(x)	(Perl_fp_class(x)==FP_SNAN||Perl_fp_class(x)==FP_QNAN)
#    define Perl_fp_class_ninf(x)	(Perl_fp_class(x)==FP_MINUS_INF)
#    define Perl_fp_class_pinf(x)	(Perl_fp_class(x)==FP_PLUS_INF)
#    define Perl_fp_class_inf(x)	(Perl_fp_class(x)==FP_MINUS_INF||Perl_fp_class(x)==FP_PLUS_INF)
#    define Perl_fp_class_nnorm(x)	(Perl_fp_class(x)==FP_MINUS_NORM)
#    define Perl_fp_class_pnorm(x)	(Perl_fp_class(x)==FP_PLUS_NORM)
#    define Perl_fp_class_norm(x)	(Perl_fp_class(x)==FP_MINUS_NORM||Perl_fp_class(x)==FP_PLUS_NORM)
#    define Perl_fp_class_ndenorm(x)	(Perl_fp_class(x)==FP_MINUS_DENORM)
#    define Perl_fp_class_pdenorm(x)	(Perl_fp_class(x)==FP_PLUS_DENORM)
#    define Perl_fp_class_denorm(x)	(Perl_fp_class(x)==FP_MINUS_DENORM||Perl_fp_class(x)==FP_PLUS_DENORM)
#    define Perl_fp_class_nzero(x)	(Perl_fp_class(x)==FP_MINUS_ZERO)
#    define Perl_fp_class_pzero(x)	(Perl_fp_class(x)==FP_PLUS_ZERO)
#    define Perl_fp_class_zero(x)	(Perl_fp_class(x)==FP_MINUS_ZERO||Perl_fp_class(x)==FP_PLUS_ZERO)
#endif

/* rumor has it that Win32 has _isnan() */

#ifndef Perl_isnan
#   ifdef HAS_ISNAN
#       define Perl_isnan(x) isnan((NV)x)
#   else
#       ifdef Perl_fp_class_nan
#           define Perl_isnan(x) Perl_fp_class_nan(x)
#       else
#           ifdef HAS_UNORDERED
#               define Perl_isnan(x) unordered((x), 0.0)
#           else
#               define Perl_isnan(x) ((x)!=(x))
#           endif
#       endif
#   endif
#endif

#ifdef UNDER_CE
int isnan(double d);
#endif

#ifndef Perl_isinf
#   ifdef HAS_ISINF
#       define Perl_isinf(x) isinf((NV)x)
#   else
#       ifdef Perl_fp_class_inf
#           define Perl_isinf(x) Perl_fp_class_inf(x)
#       else
#           define Perl_isinf(x) ((x)==NV_INF)
#       endif
#   endif
#endif

#ifndef Perl_isfinite
#   ifdef HAS_FINITE
#       define Perl_isfinite(x) finite((NV)x)
#   else
#       ifdef HAS_ISFINITE
#           define Perl_isfinite(x) isfinite(x)
#       else
#           ifdef Perl_fp_class_finite
#               define Perl_isfinite(x) Perl_fp_class_finite(x)
#           else
#               define Perl_isfinite(x) !(Perl_is_inf(x)||Perl_is_nan(x))
#           endif
#       endif
#   endif
#endif

/* The default is to use Perl's own atof() implementation (in numeric.c).
 * Usually that is the one to use but for some platforms (e.g. UNICOS)
 * it is however best to use the native implementation of atof.
 * You can experiment with using your native one by -DUSE_PERL_ATOF=0.
 * Some good tests to try out with either setting are t/base/num.t,
 * t/op/numconvert.t, and t/op/pack.t. Note that if using long doubles
 * you may need to be using a different function than atof! */

#ifndef USE_PERL_ATOF
#   ifndef _UNICOS
#       define USE_PERL_ATOF
#   endif
#else
#   if USE_PERL_ATOF == 0
#       undef USE_PERL_ATOF
#   endif
#endif

#ifdef USE_PERL_ATOF
#   define Perl_atof(s) Perl_my_atof(s)
#   define Perl_atof2(s, n) Perl_my_atof2(aTHX_ (s), &(n))
#else
#   define Perl_atof(s) (NV)atof(s)
#   define Perl_atof2(s, n) ((n) = atof(s))
#endif

/* Previously these definitions used hardcoded figures.
 * It is hoped these formula are more portable, although
 * no data one way or another is presently known to me.
 * The "PERL_" names are used because these calculated constants
 * do not meet the ANSI requirements for LONG_MAX, etc., which
 * need to be constants acceptable to #if - kja
 *    define PERL_LONG_MAX        2147483647L
 *    define PERL_LONG_MIN        (-LONG_MAX - 1)
 *    define PERL ULONG_MAX       4294967295L
 */

#ifdef I_LIMITS  /* Needed for cast_xxx() functions below. */
#  include <limits.h>
#endif
/* Included values.h above if necessary; still including limits.h down here,
 * despite doing above, because math.h might have overriden... XXX - Allen */

/*
 * Try to figure out max and min values for the integral types.  THE CORRECT
 * SOLUTION TO THIS MESS: ADAPT enquire.c FROM GCC INTO CONFIGURE.  The
 * following hacks are used if neither limits.h or values.h provide them:
 * U<TYPE>_MAX: for types >= int: ~(unsigned TYPE)0
 *              for types <  int:  (unsigned TYPE)~(unsigned)0
 *	The argument to ~ must be unsigned so that later signed->unsigned
 *	conversion can't modify the value's bit pattern (e.g. -0 -> +0),
 *	and it must not be smaller than int because ~ does integral promotion.
 * <type>_MAX: (<type>) (U<type>_MAX >> 1)
 * <type>_MIN: -<type>_MAX - <is_twos_complement_architecture: (3 & -1) == 3>.
 *	The latter is a hack which happens to work on some machines but
 *	does *not* catch any random system, or things like integer types
 *	with NaN if that is possible.
 *
 * All of the types are explicitly cast to prevent accidental loss of
 * numeric range, and in the hope that they will be less likely to confuse
 * over-eager optimizers.
 *
 */

#define PERL_UCHAR_MIN ((unsigned char)0)

#ifdef UCHAR_MAX
#  define PERL_UCHAR_MAX ((unsigned char)UCHAR_MAX)
#else
#  ifdef MAXUCHAR
#    define PERL_UCHAR_MAX ((unsigned char)MAXUCHAR)
#  else
#    define PERL_UCHAR_MAX       ((unsigned char)~(unsigned)0)
#  endif
#endif

/*
 * CHAR_MIN and CHAR_MAX are not included here, as the (char) type may be
 * ambiguous. It may be equivalent to (signed char) or (unsigned char)
 * depending on local options. Until Configure detects this (or at least
 * detects whether the "signed" keyword is available) the CHAR ranges
 * will not be included. UCHAR functions normally.
 *                                                           - kja
 */

#define PERL_USHORT_MIN ((unsigned short)0)

#ifdef USHORT_MAX
#  define PERL_USHORT_MAX ((unsigned short)USHORT_MAX)
#else
#  ifdef MAXUSHORT
#    define PERL_USHORT_MAX ((unsigned short)MAXUSHORT)
#  else
#    ifdef USHRT_MAX
#      define PERL_USHORT_MAX ((unsigned short)USHRT_MAX)
#    else
#      define PERL_USHORT_MAX       ((unsigned short)~(unsigned)0)
#    endif
#  endif
#endif

#ifdef SHORT_MAX
#  define PERL_SHORT_MAX ((short)SHORT_MAX)
#else
#  ifdef MAXSHORT    /* Often used in <values.h> */
#    define PERL_SHORT_MAX ((short)MAXSHORT)
#  else
#    ifdef SHRT_MAX
#      define PERL_SHORT_MAX ((short)SHRT_MAX)
#    else
#      define PERL_SHORT_MAX      ((short) (PERL_USHORT_MAX >> 1))
#    endif
#  endif
#endif

#ifdef SHORT_MIN
#  define PERL_SHORT_MIN ((short)SHORT_MIN)
#else
#  ifdef MINSHORT
#    define PERL_SHORT_MIN ((short)MINSHORT)
#  else
#    ifdef SHRT_MIN
#      define PERL_SHORT_MIN ((short)SHRT_MIN)
#    else
#      define PERL_SHORT_MIN        (-PERL_SHORT_MAX - ((3 & -1) == 3))
#    endif
#  endif
#endif

#ifdef UINT_MAX
#  define PERL_UINT_MAX ((unsigned int)UINT_MAX)
#else
#  ifdef MAXUINT
#    define PERL_UINT_MAX ((unsigned int)MAXUINT)
#  else
#    define PERL_UINT_MAX       (~(unsigned int)0)
#  endif
#endif

#define PERL_UINT_MIN ((unsigned int)0)

#ifdef INT_MAX
#  define PERL_INT_MAX ((int)INT_MAX)
#else
#  ifdef MAXINT    /* Often used in <values.h> */
#    define PERL_INT_MAX ((int)MAXINT)
#  else
#    define PERL_INT_MAX        ((int)(PERL_UINT_MAX >> 1))
#  endif
#endif

#ifdef INT_MIN
#  define PERL_INT_MIN ((int)INT_MIN)
#else
#  ifdef MININT
#    define PERL_INT_MIN ((int)MININT)
#  else
#    define PERL_INT_MIN        (-PERL_INT_MAX - ((3 & -1) == 3))
#  endif
#endif

#ifdef ULONG_MAX
#  define PERL_ULONG_MAX ((unsigned long)ULONG_MAX)
#else
#  ifdef MAXULONG
#    define PERL_ULONG_MAX ((unsigned long)MAXULONG)
#  else
#    define PERL_ULONG_MAX       (~(unsigned long)0)
#  endif
#endif

#define PERL_ULONG_MIN ((unsigned long)0L)

#ifdef LONG_MAX
#  define PERL_LONG_MAX ((long)LONG_MAX)
#else
#  ifdef MAXLONG    /* Often used in <values.h> */
#    define PERL_LONG_MAX ((long)MAXLONG)
#  else
#    define PERL_LONG_MAX        ((long) (PERL_ULONG_MAX >> 1))
#  endif
#endif

#ifdef LONG_MIN
#  define PERL_LONG_MIN ((long)LONG_MIN)
#else
#  ifdef MINLONG
#    define PERL_LONG_MIN ((long)MINLONG)
#  else
#    define PERL_LONG_MIN        (-PERL_LONG_MAX - ((3 & -1) == 3))
#  endif
#endif

#ifdef UV_IS_QUAD

#    define PERL_UQUAD_MAX	(~(UV)0)
#    define PERL_UQUAD_MIN	((UV)0)
#    define PERL_QUAD_MAX 	((IV) (PERL_UQUAD_MAX >> 1))
#    define PERL_QUAD_MIN 	(-PERL_QUAD_MAX - ((3 & -1) == 3))

#endif

#ifdef MYMALLOC
#  include "malloc_ctl.h"
#endif

struct RExC_state_t;

typedef MEM_SIZE STRLEN;

typedef struct op OP;
typedef struct cop COP;
typedef struct unop UNOP;
typedef struct binop BINOP;
typedef struct listop LISTOP;
typedef struct logop LOGOP;
typedef struct pmop PMOP;
typedef struct svop SVOP;
typedef struct padop PADOP;
typedef struct pvop PVOP;
typedef struct loop LOOP;

typedef struct interpreter PerlInterpreter;

/* Amdahl's <ksync.h> has struct sv */
/* SGI's <sys/sema.h> has struct sv */
#if defined(UTS) || defined(__sgi)
#   define STRUCT_SV perl_sv
#else
#   define STRUCT_SV sv
#endif
typedef struct STRUCT_SV SV;
typedef struct av AV;
typedef struct hv HV;
typedef struct cv CV;
typedef struct regexp REGEXP;
typedef struct gp GP;
typedef struct gv GV;
typedef struct io IO;
typedef struct context PERL_CONTEXT;
typedef struct block BLOCK;

typedef struct magic MAGIC;
typedef struct xrv XRV;
typedef struct xpv XPV;
typedef struct xpviv XPVIV;
typedef struct xpvuv XPVUV;
typedef struct xpvnv XPVNV;
typedef struct xpvmg XPVMG;
typedef struct xpvlv XPVLV;
typedef struct xpvav XPVAV;
typedef struct xpvhv XPVHV;
typedef struct xpvgv XPVGV;
typedef struct xpvcv XPVCV;
typedef struct xpvbm XPVBM;
typedef struct xpvfm XPVFM;
typedef struct xpvio XPVIO;
typedef struct mgvtbl MGVTBL;
typedef union any ANY;
typedef struct ptr_tbl_ent PTR_TBL_ENT_t;
typedef struct ptr_tbl PTR_TBL_t;
typedef struct clone_params CLONE_PARAMS;

#include "handy.h"

#if defined(USE_LARGE_FILES) && !defined(NO_64_BIT_RAWIO)
#   if LSEEKSIZE == 8 && !defined(USE_64_BIT_RAWIO)
#       define USE_64_BIT_RAWIO	/* implicit */
#   endif
#endif

/* Notice the use of HAS_FSEEKO: now we are obligated to always use
 * fseeko/ftello if possible.  Don't go #defining ftell to ftello yourself,
 * however, because operating systems like to do that themself. */
#ifndef FSEEKSIZE
#   ifdef HAS_FSEEKO
#       define FSEEKSIZE LSEEKSIZE
#   else
#       define FSEEKSIZE LONGSIZE
#   endif
#endif

#if defined(USE_LARGE_FILES) && !defined(NO_64_BIT_STDIO)
#   if FSEEKSIZE == 8 && !defined(USE_64_BIT_STDIO)
#       define USE_64_BIT_STDIO /* implicit */
#   endif
#endif

#ifdef USE_64_BIT_RAWIO
#   ifdef HAS_OFF64_T
#       undef Off_t
#       define Off_t off64_t
#       undef LSEEKSIZE
#       define LSEEKSIZE 8
#   endif
/* Most 64-bit environments have defines like _LARGEFILE_SOURCE that
 * will trigger defines like the ones below.  Some 64-bit environments,
 * however, do not.  Therefore we have to explicitly mix and match. */
#   if defined(USE_OPEN64)
#       define open open64
#   endif
#   if defined(USE_LSEEK64)
#       define lseek lseek64
#   else
#       if defined(USE_LLSEEK)
#           define lseek llseek
#       endif
#   endif
#   if defined(USE_STAT64)
#       define stat stat64
#   endif
#   if defined(USE_FSTAT64)
#       define fstat fstat64
#   endif
#   if defined(USE_LSTAT64)
#       define lstat lstat64
#   endif
#   if defined(USE_FLOCK64)
#       define flock flock64
#   endif
#   if defined(USE_LOCKF64)
#       define lockf lockf64
#   endif
#   if defined(USE_FCNTL64)
#       define fcntl fcntl64
#   endif
#   if defined(USE_TRUNCATE64)
#       define truncate truncate64
#   endif
#   if defined(USE_FTRUNCATE64)
#       define ftruncate ftruncate64
#   endif
#endif

#ifdef USE_64_BIT_STDIO
#   ifdef HAS_FPOS64_T
#       undef Fpos_t
#       define Fpos_t fpos64_t
#   endif
/* Most 64-bit environments have defines like _LARGEFILE_SOURCE that
 * will trigger defines like the ones below.  Some 64-bit environments,
 * however, do not. */
#   if defined(USE_FOPEN64)
#       define fopen fopen64
#   endif
#   if defined(USE_FSEEK64)
#       define fseek fseek64 /* don't do fseeko here, see perlio.c */
#   endif
#   if defined(USE_FTELL64)
#       define ftell ftell64 /* don't do ftello here, see perlio.c */
#   endif
#   if defined(USE_FSETPOS64)
#       define fsetpos fsetpos64
#   endif
#   if defined(USE_FGETPOS64)
#       define fgetpos fgetpos64
#   endif
#   if defined(USE_TMPFILE64)
#       define tmpfile tmpfile64
#   endif
#   if defined(USE_FREOPEN64)
#       define freopen freopen64
#   endif
#endif

#if defined(OS2) || defined(MACOS_TRADITIONAL)
#  include "iperlsys.h"
#endif

#if defined(__OPEN_VM)
#   include "vmesa/vmesaish.h"
#   define ISHISH "vmesa"
#endif

#ifdef DOSISH
#   if defined(OS2)
#       include "os2ish.h"
#   else
#       include "dosish.h"
#   endif
#   define ISHISH "dos"
#endif

#if defined(VMS)
#   include "vmsish.h"
#   include "embed.h"
#   define ISHISH "vms"
#endif

#if defined(PLAN9)
#   include "./plan9/plan9ish.h"
#   define ISHISH "plan9"
#endif

#if defined(MPE)
#  include "mpeix/mpeixish.h"
#  define ISHISH "mpeix"
#endif

#if defined(__VOS__)
#   ifdef __GNUC__
#     include "./vos/vosish.h"
#   else
#     include "vos/vosish.h"
#   endif
#   define ISHISH "vos"
#endif

#if defined(EPOC)
#   include "epocish.h"
#   define ISHISH "epoc"
#endif

#if defined(MACOS_TRADITIONAL)
#   include "macos/macish.h"
#   ifndef NO_ENVIRON_ARRAY
#       define NO_ENVIRON_ARRAY
#   endif
#   define ISHISH "macos classic"
#endif

#if defined(__BEOS__)
#   include "beos/beosish.h"
#   define ISHISH "beos"
#endif

#if defined(__MSYS__)


#endif

#ifndef ISHISH
#   include "unixish.h"
#   define ISHISH "unix"
#endif

#ifndef NO_ENVIRON_ARRAY
#  define USE_ENVIRON_ARRAY
#endif

/*
 * initialise to avoid floating-point exceptions from overflow, etc
 */
#ifndef PERL_FPU_INIT
#  ifdef HAS_FPSETMASK
#    if HAS_FLOATINGPOINT_H
#      include <floatingpoint.h>
#    endif
#    define PERL_FPU_INIT fpsetmask(0);
#  else
#    if defined(SIGFPE) && defined(SIG_IGN) && !defined(PERL_MICRO)
#      define PERL_FPU_INIT       PL_sigfpe_saved = signal(SIGFPE, SIG_IGN);
#      define PERL_FPU_PRE_EXEC   { Sigsave_t xfpe; rsignal_save(SIGFPE, PL_sigfpe_saved, &xfpe);
#      define PERL_FPU_POST_EXEC    rsignal_restore(SIGFPE, &xfpe); }
#    else
#      define PERL_FPU_INIT

#    endif
#  endif
#endif
#ifndef PERL_FPU_PRE_EXEC
#  define PERL_FPU_PRE_EXEC   {
#  define PERL_FPU_POST_EXEC  }
#endif

#ifndef PERL_SYS_INIT3
#  define PERL_SYS_INIT3(argvp,argcp,envp) PERL_SYS_INIT(argvp,argcp)
#endif

#ifndef PERL_WRITE_MSG_TO_CONSOLE
#  define PERL_WRITE_MSG_TO_CONSOLE(io, msg, len) PerlIO_write(io, msg, len)
#endif

#ifndef MAXPATHLEN
#  ifdef PATH_MAX
#    ifdef _POSIX_PATH_MAX
#       if PATH_MAX > _POSIX_PATH_MAX
/* POSIX 1990 (and pre) was ambiguous about whether PATH_MAX
 * included the null byte or not.  Later amendments of POSIX,
 * XPG4, the Austin Group, and the Single UNIX Specification
 * all explicitly include the null byte in the PATH_MAX.
 * Ditto for _POSIX_PATH_MAX. */
#         define MAXPATHLEN PATH_MAX
#       else
#         define MAXPATHLEN _POSIX_PATH_MAX
#       endif
#    else
#      define MAXPATHLEN (PATH_MAX+1)
#    endif
#  else
#    ifdef _POSIX_PATH_MAX
#       define MAXPATHLEN _POSIX_PATH_MAX
#    else
#       define MAXPATHLEN 1024	/* Err on the large side. */
#    endif
#  endif
#endif

/* In case Configure was not used (we are using a "canned config"
 * such as Win32, or a cross-compilation setup, for example) try going
 * by the gcc major and minor versions.  One useful URL is
 * http://www.ohse.de/uwe/articles/gcc-attributes.html,
 * but contrary to this information warn_unused_result seems
 * not to be in gcc 3.3.5, at least. --jhi
 * Set these up now otherwise we get confused when some of the <*thread.h>
 * includes below indirectly pull in <perlio.h> (which needs to know if we
 * have HASATTRIBUTE_FORMAT).
 */

#if defined __GNUC__
#  if __GNUC__ >= 3 /* 3.0 -> */ /* XXX Verify this version */
#    define HASATTRIBUTE_FORMAT
#  endif
#  if __GNUC__ >= 3 /* 3.0 -> */
#    define HASATTRIBUTE_MALLOC
#  endif
#  if __GNUC__ == 3 && __GNUC_MINOR__ >= 3 || __GNUC__ > 3 /* 3.3 -> */
#    define HASATTRIBUTE_NONNULL
#  endif
#  if __GNUC__ == 2 && __GNUC_MINOR__ >= 5 || __GNUC__ > 2 /* 2.5 -> */
#    define HASATTRIBUTE_NORETURN
#  endif
#  if __GNUC__ >= 3 /* gcc 3.0 -> */
#    define HASATTRIBUTE_PURE
#  endif
#  if __GNUC__ >= 3 /* gcc 3.0 -> */ /* XXX Verify this version */
#    define HASATTRIBUTE_UNUSED
#  endif
#  if __GNUC__ == 3 && __GNUC_MINOR__ >= 4 || __GNUC__ > 3 /* 3.4 -> */
#    define HASATTRIBUTE_WARN_UNUSED_RESULT
#  endif
#endif

/*
 * USE_5005THREADS needs to be after unixish.h as <pthread.h> includes
 * <sys/signal.h> which defines NSIG - which will stop inclusion of <signal.h>
 * this results in many functions being undeclared which bothers C++
 * May make sense to have threads after "*ish.h" anyway
 */

#if defined(USE_5005THREADS) || defined(USE_ITHREADS)
#  if defined(USE_5005THREADS)
   /* pending resolution of licensing issues, we avoid the erstwhile
    * atomic.h everywhere */
#  define EMULATE_ATOMIC_REFCOUNTS
#  endif
#  ifdef NETWARE
#   include <nw5thread.h>
#  else
#  ifdef FAKE_THREADS
#    include "fakethr.h"
#  else
#    ifdef WIN32
#      include <win32thread.h>
#    else
#      ifdef OS2
#        include "os2thread.h"
#      else
#        ifdef I_MACH_CTHREADS
#          include <mach/cthreads.h>
#          if (defined(NeXT) || defined(__NeXT__)) && defined(PERL_POLLUTE_MALLOC)
#            define MUTEX_INIT_CALLS_MALLOC
#          endif
typedef cthread_t	perl_os_thread;
typedef mutex_t		perl_mutex;
typedef condition_t	perl_cond;
typedef void *		perl_key;
#        else /* Posix threads */
#          ifdef I_PTHREAD
#            include <pthread.h>
#          endif
typedef pthread_t	perl_os_thread;
typedef pthread_mutex_t	perl_mutex;
typedef pthread_cond_t	perl_cond;
typedef pthread_key_t	perl_key;
#        endif /* I_MACH_CTHREADS */
#      endif /* OS2 */
#    endif /* WIN32 */
#  endif /* FAKE_THREADS */
#endif	/* NETWARE */
#endif /* USE_5005THREADS || USE_ITHREADS */

#if defined(WIN32)
#  include "win32.h"
#endif

#ifdef NETWARE
#  include "netware.h"
#endif

#ifdef VMS
#   define STATUS_NATIVE	PL_statusvalue_vms
#   define STATUS_NATIVE_EXPORT \
	(((I32)PL_statusvalue_vms == -1 ? 44 : PL_statusvalue_vms) | (VMSISH_HUSHED ? 0x10000000 : 0))
#   define STATUS_NATIVE_SET(n)						\
	STMT_START {							\
	    PL_statusvalue_vms = (n);					\
	    if ((I32)PL_statusvalue_vms == -1)				\
		PL_statusvalue = -1;					\
	    else if (PL_statusvalue_vms & STS$M_SUCCESS)		\
		PL_statusvalue = 0;					\
	    else if ((PL_statusvalue_vms & STS$M_SEVERITY) == 0)	\
		PL_statusvalue = 1 << 8;				\
	    else							\
		PL_statusvalue = (PL_statusvalue_vms & STS$M_SEVERITY) << 8;	\
	} STMT_END
#   define STATUS_POSIX	PL_statusvalue
#   ifdef VMSISH_STATUS
#	define STATUS_CURRENT	(VMSISH_STATUS ? STATUS_NATIVE : STATUS_POSIX)
#   else
#	define STATUS_CURRENT	STATUS_POSIX
#   endif
#   define STATUS_POSIX_SET(n)				\
	STMT_START {					\
	    PL_statusvalue = (n);				\
	    if (PL_statusvalue != -1) {			\
		PL_statusvalue &= 0xFFFF;			\
		PL_statusvalue_vms = PL_statusvalue ? 44 : 1;	\
	    }						\
	    else PL_statusvalue_vms = -1;			\
	} STMT_END
#   define STATUS_ALL_SUCCESS	(PL_statusvalue = 0, PL_statusvalue_vms = 1)
#   define STATUS_ALL_FAILURE	(PL_statusvalue = 1, PL_statusvalue_vms = 44)
#else
#   define STATUS_NATIVE	STATUS_POSIX
#   define STATUS_NATIVE_EXPORT	STATUS_POSIX
#   define STATUS_NATIVE_SET	STATUS_POSIX_SET
#   define STATUS_POSIX		PL_statusvalue
#   define STATUS_POSIX_SET(n)		\
	STMT_START {			\
	    PL_statusvalue = (n);		\
	    if (PL_statusvalue != -1)	\
		PL_statusvalue &= 0xFFFF;	\
	} STMT_END
#   define STATUS_CURRENT STATUS_POSIX
#   define STATUS_ALL_SUCCESS	(PL_statusvalue = 0)
#   define STATUS_ALL_FAILURE	(PL_statusvalue = 1)
#endif

/* flags in PL_exit_flags for nature of exit() */
#define PERL_EXIT_EXPECTED	0x01
#define PERL_EXIT_DESTRUCT_END  0x02  /* Run END in perl_destruct */

#ifndef MEMBER_TO_FPTR
#  define MEMBER_TO_FPTR(name)		name
#endif

/* format to use for version numbers in file/directory names */
/* XXX move to Configure? */
#ifndef PERL_FS_VER_FMT
#  define PERL_FS_VER_FMT	"%d.%d.%d"
#endif

/* This defines a way to flush all output buffers.  This may be a
 * performance issue, so we allow people to disable it.  Also, if
 * we are using stdio, there are broken implementations of fflush(NULL)
 * out there, Solaris being the most prominent.
 */
#ifndef PERL_FLUSHALL_FOR_CHILD
# if defined(USE_PERLIO) || defined(FFLUSH_NULL) || defined(USE_SFIO)
#  define PERL_FLUSHALL_FOR_CHILD	PerlIO_flush((PerlIO*)NULL)
# else
#  ifdef FFLUSH_ALL
#   define PERL_FLUSHALL_FOR_CHILD	my_fflush_all()
#  else
#   define PERL_FLUSHALL_FOR_CHILD	NOOP
#  endif
# endif
#endif

#ifndef PERL_WAIT_FOR_CHILDREN
#  define PERL_WAIT_FOR_CHILDREN	NOOP
#endif

/* the traditional thread-unsafe notion of "current interpreter". */
#ifndef PERL_SET_INTERP
#  define PERL_SET_INTERP(i)		(PL_curinterp = (PerlInterpreter*)(i))
#endif

#ifndef PERL_GET_INTERP
#  define PERL_GET_INTERP		(PL_curinterp)
#endif

#if defined(PERL_IMPLICIT_CONTEXT) && !defined(PERL_GET_THX)
#  ifdef USE_5005THREADS
#    define PERL_GET_THX		((struct perl_thread *)PERL_GET_CONTEXT)
#  else
#  ifdef MULTIPLICITY
#    define PERL_GET_THX		((PerlInterpreter *)PERL_GET_CONTEXT)
#  endif
#  endif
#  define PERL_SET_THX(t)		PERL_SET_CONTEXT(t)
#endif

#ifndef SVf
#  ifdef CHECK_FORMAT
#    define SVf "-p"
#  else
#    define SVf "_"
#  endif
#endif

#ifndef SVf_precision
#  ifdef CHECK_FORMAT
#    define SVf_precision(n) "-" n "p"
#  else
#    define SVf_precision(n) "." n "_"
#  endif
#endif

#ifndef VDf
#  ifdef CHECK_FORMAT
#    define VDf "-1p"
#  else
#    define VDf "vd"
#  endif
#endif

#ifndef SVf32
#  define SVf32 SVf_precision("32")
#endif

#ifndef SVf256
#  define SVf256 SVf_precision("256")
#endif
 
#ifndef UVf
#  define UVf UVuf
#endif

#ifndef PERL_CORE
#  ifndef DieNull
#    define DieNull Perl_vdie(aTHX_ Nullch, Null(va_list *))
#  endif
#endif

/* Because 5.8.x has to keep using %_ for SVf, which will make the format
 * checking code (quite correctly) bleat a lot.  */
#ifndef CHECK_FORMAT
#  undef HASATTRIBUTE_FORMAT
#endif

#ifdef HASATTRIBUTE_FORMAT
#  define __attribute__format__(x,y,z)      __attribute__((format(x,y,z)))
#endif
#ifdef HASATTRIBUTE_MALLOC
#  define __attribute__malloc__             __attribute__((__malloc__))
#endif
#ifdef HASATTRIBUTE_NONNULL
#  define __attribute__nonnull__(a)         __attribute__((nonnull(a)))
#endif
#ifdef HASATTRIBUTE_NORETURN
#  define __attribute__noreturn__           __attribute__((noreturn))
#endif
#ifdef HASATTRIBUTE_PURE
#  define __attribute__pure__               __attribute__((pure))
#endif
#ifdef HASATTRIBUTE_UNUSED
#  define __attribute__unused__             __attribute__((unused))
#endif
#ifdef HASATTRIBUTE_WARN_UNUSED_RESULT
#  define __attribute__warn_unused_result__ __attribute__((warn_unused_result))
#endif

/* If we haven't defined the attributes yet, define them to blank. */
#ifndef __attribute__format__
#  define __attribute__format__(x,y,z)
#endif
#ifndef __attribute__malloc__
#  define __attribute__malloc__
#endif
#ifndef __attribute__nonnull__
#  define __attribute__nonnull__(a)
#endif
#ifndef __attribute__noreturn__
#  define __attribute__noreturn__
#endif
#ifndef __attribute__pure__
#  define __attribute__pure__
#endif
#ifndef __attribute__unused__
#  define __attribute__unused__
#endif
#ifndef __attribute__warn_unused_result__
#  define __attribute__warn_unused_result__
#endif

/* For functions that are marked as __attribute__noreturn__, it's not
   appropriate to call return.  In either case, include the lint directive.
 */
#ifdef HASATTRIBUTE_NORETURN
#  define NORETURN_FUNCTION_END /* NOT REACHED */
#else
#  define NORETURN_FUNCTION_END /* NOT REACHED */ return 0
#endif

/* Some unistd.h's give a prototype for pause() even though
   HAS_PAUSE ends up undefined.  This causes the #define
   below to be rejected by the compiler.  Sigh.
*/
#ifdef HAS_PAUSE
#define Pause	pause
#else
#define Pause() sleep((32767<<16)+32767)
#endif

#ifndef IOCPARM_LEN
#   ifdef IOCPARM_MASK
	/* on BSDish systems we're safe */
#	define IOCPARM_LEN(x)  (((x) >> 16) & IOCPARM_MASK)
#   else
#	if defined(_IOC_SIZE) && defined(__GLIBC__)
	/* on Linux systems we're safe; except when we're not [perl #38223] */
#	    define IOCPARM_LEN(x) (_IOC_SIZE(x) < 256 ? 256 : _IOC_SIZE(x))
#	else
	/* otherwise guess at what's safe */
#	    define IOCPARM_LEN(x)	256
#	endif
#   endif
#endif

#if defined(__CYGWIN__) || defined(__MSYS__)
/* USEMYBINMODE
 *   This symbol, if defined, indicates that the program should
 *   use the routine my_binmode(FILE *fp, char iotype, int mode) to insure
 *   that a file is in "binary" mode -- that is, that no translation
 *   of bytes occurs on read or write operations.
 */
#  define USEMYBINMODE /**/
#  include <io.h> /* for setmode() prototype */
#  define my_binmode(fp, iotype, mode) \
            (PerlLIO_setmode(fileno(fp), mode) != -1 ? TRUE : FALSE)
#endif

#if defined(__CYGWIN__) || defined(__MSYS__)
void init_os_extras(void);
#endif

#ifdef UNION_ANY_DEFINITION
UNION_ANY_DEFINITION;
#else
union any {
    void*	any_ptr;
    I32		any_i32;
    IV		any_iv;
    long	any_long;
    bool	any_bool;
    void	(*any_dptr) (void*);
    void	(*any_dxptr) (pTHX_ void*);
};
#endif

#ifdef USE_5005THREADS
#define ARGSproto struct perl_thread *thr
#else
#define ARGSproto
#endif /* USE_5005THREADS */

typedef I32 (*filter_t) (pTHX_ int, SV *, int);

#define FILTER_READ(idx, sv, len)  filter_read(idx, sv, len)
#define FILTER_DATA(idx)	   (AvARRAY(PL_rsfp_filters)[idx])
#define FILTER_ISREADER(idx)	   (idx >= AvFILLp(PL_rsfp_filters))

#if defined(_AIX) && !defined(_AIX43)
#if defined(USE_REENTRANT) || defined(_REENTRANT) || defined(_THREAD_SAFE)
/* We cannot include <crypt.h> to get the struct crypt_data
 * because of setkey prototype problems when threading */
typedef        struct crypt_data {     /* straight from /usr/include/crypt.h */
    /* From OSF, Not needed in AIX
       char C[28], D[28];
    */
    char E[48];
    char KS[16][48];
    char block[66];
    char iobuf[16];
} CRYPTD;
#endif /* threading */
#endif /* AIX */

#if !defined(OS2) && !defined(MACOS_TRADITIONAL)
#  include "iperlsys.h"
#endif

/* [perl #22371] Algorimic Complexity Attack on Perl 5.6.1, 5.8.0.
 * Note that the USE_HASH_SEED and USE_HASH_SEED_EXPLICIT are *NOT*
 * defined by Configure, despite their names being similar to the
 * other defines like USE_ITHREADS.  Configure in fact knows nothing
 * about the randomised hashes.  Therefore to enable/disable the hash
 * randomisation defines use the Configure -Accflags=... instead. */
#if !defined(NO_HASH_SEED) && !defined(USE_HASH_SEED) && !defined(USE_HASH_SEED_EXPLICIT)
#  define USE_HASH_SEED
#endif

#include "regexp.h"
#include "sv.h"
#include "util.h"
#include "form.h"
#include "gv.h"
#include "pad.h"
#include "cv.h"
#include "opnames.h"
#include "op.h"
#include "cop.h"
#include "av.h"
#include "hv.h"
#include "mg.h"
#include "scope.h"
#include "warnings.h"
#include "utf8.h"

/* Current curly descriptor */
typedef struct curcur CURCUR;
struct curcur {
    int		parenfloor;	/* how far back to strip paren data */
    int		cur;		/* how many instances of scan we've matched */
    int		min;		/* the minimal number of scans to match */
    int		max;		/* the maximal number of scans to match */
    int		minmod;		/* whether to work our way up or down */
    regnode *	scan;		/* the thing to match */
    regnode *	next;		/* what has to match after it */
    char *	lastloc;	/* where we started matching this scan */
    CURCUR *	oldcc;		/* current curly before we started this one */
};

typedef struct _sublex_info SUBLEXINFO;
struct _sublex_info {
    I32 super_state;	/* lexer state to save */
    I32 sub_inwhat;	/* "lex_inwhat" to use */
    OP *sub_op;		/* "lex_op" to use */
    char *super_bufptr;	/* PL_bufptr that was */
    char *super_bufend;	/* PL_bufend that was */
};

typedef struct magic_state MGS;	/* struct magic_state defined in mg.c */

struct scan_data_t;		/* Used in S_* functions in regcomp.c */
struct regnode_charclass_class;	/* Used in S_* functions in regcomp.c */

typedef I32 CHECKPOINT;

struct ptr_tbl_ent {
    struct ptr_tbl_ent*		next;
    const void*			oldval;
    void*			newval;
};

struct ptr_tbl {
    struct ptr_tbl_ent**	tbl_ary;
    UV				tbl_max;
    UV				tbl_items;
};

#if defined(iAPX286) || defined(M_I286) || defined(I80286)
#   define I286
#endif

#if defined(htonl) && !defined(HAS_HTONL)
#define HAS_HTONL
#endif
#if defined(htons) && !defined(HAS_HTONS)
#define HAS_HTONS
#endif
#if defined(ntohl) && !defined(HAS_NTOHL)
#define HAS_NTOHL
#endif
#if defined(ntohs) && !defined(HAS_NTOHS)
#define HAS_NTOHS
#endif
#ifndef HAS_HTONL
#if (BYTEORDER & 0xffff) != 0x4321
#define HAS_HTONS
#define HAS_HTONL
#define HAS_NTOHS
#define HAS_NTOHL
#define MYSWAP
#define htons my_swap
#define htonl my_htonl
#define ntohs my_swap
#define ntohl my_ntohl
#endif
#else
#if (BYTEORDER & 0xffff) == 0x4321
#undef HAS_HTONS
#undef HAS_HTONL
#undef HAS_NTOHS
#undef HAS_NTOHL
#endif
#endif

/*
 * Little-endian byte order functions - 'v' for 'VAX', or 'reVerse'.
 * -DWS
 */
#if BYTEORDER != 0x1234
# define HAS_VTOHL
# define HAS_VTOHS
# define HAS_HTOVL
# define HAS_HTOVS
# if BYTEORDER == 0x4321 || BYTEORDER == 0x87654321
#  define vtohl(x)	((((x)&0xFF)<<24)	\
			+(((x)>>24)&0xFF)	\
			+(((x)&0x0000FF00)<<8)	\
			+(((x)&0x00FF0000)>>8)	)
#  define vtohs(x)	((((x)&0xFF)<<8) + (((x)>>8)&0xFF))
#  define htovl(x)	vtohl(x)
#  define htovs(x)	vtohs(x)
# endif
	/* otherwise default to functions in util.c */
#ifndef htovs
short htovs(short n);
short vtohs(short n);
long htovl(long n);
long vtohl(long n);
#endif
#endif

/* *MAX Plus 1. A floating point value.
   Hopefully expressed in a way that dodgy floating point can't mess up.
   >> 2 rather than 1, so that value is safely less than I32_MAX after 1
   is added to it
   May find that some broken compiler will want the value cast to I32.
   [after the shift, as signed >> may not be as secure as unsigned >>]
*/
#define I32_MAX_P1 (2.0 * (1 + (((U32)I32_MAX) >> 1)))
#define U32_MAX_P1 (4.0 * (1 + ((U32_MAX) >> 2)))
/* For compilers that can't correctly cast NVs over 0x7FFFFFFF (or
   0x7FFFFFFFFFFFFFFF) to an unsigned integer. In the future, sizeof(UV)
   may be greater than sizeof(IV), so don't assume that half max UV is max IV.
*/
#define U32_MAX_P1_HALF (2.0 * (1 + ((U32_MAX) >> 2)))

#define UV_MAX_P1 (4.0 * (1 + ((UV_MAX) >> 2)))
#define IV_MAX_P1 (2.0 * (1 + (((UV)IV_MAX) >> 1)))
#define UV_MAX_P1_HALF (2.0 * (1 + ((UV_MAX) >> 2)))

/* This may look like unnecessary jumping through hoops, but converting
   out of range floating point values to integers *is* undefined behaviour,
   and it is starting to bite.
*/
#ifndef CAST_INLINE
#define I_32(what) (cast_i32((NV)(what)))
#define U_32(what) (cast_ulong((NV)(what)))
#define I_V(what) (cast_iv((NV)(what)))
#define U_V(what) (cast_uv((NV)(what)))
#else
#define I_32(n) ((n) < I32_MAX_P1 ? ((n) < I32_MIN ? I32_MIN : (I32) (n)) \
                  : ((n) < U32_MAX_P1 ? (I32)(U32) (n) \
                     : ((n) > 0 ? (I32) U32_MAX : 0 /* NaN */)))
#define U_32(n) ((n) < 0.0 ? ((n) < I32_MIN ? (UV) I32_MIN : (U32)(I32) (n)) \
                  : ((n) < U32_MAX_P1 ? (U32) (n) \
                     : ((n) > 0 ? U32_MAX : 0 /* NaN */)))
#define I_V(n) ((n) < IV_MAX_P1 ? ((n) < IV_MIN ? IV_MIN : (IV) (n)) \
                  : ((n) < UV_MAX_P1 ? (IV)(UV) (n) \
                     : ((n) > 0 ? (IV)UV_MAX : 0 /* NaN */)))
#define U_V(n) ((n) < 0.0 ? ((n) < IV_MIN ? (UV) IV_MIN : (UV)(IV) (n)) \
                  : ((n) < UV_MAX_P1 ? (UV) (n) \
                     : ((n) > 0 ? UV_MAX : 0 /* NaN */)))
#endif

#define U_S(what) ((U16)U_32(what))
#define U_I(what) ((unsigned int)U_32(what))
#define U_L(what) U_32(what)

/* These do not care about the fractional part, only about the range. */
#define NV_WITHIN_IV(nv) (I_V(nv) >= IV_MIN && I_V(nv) <= IV_MAX)
#define NV_WITHIN_UV(nv) ((nv)>=0.0 && U_V(nv) >= UV_MIN && U_V(nv) <= UV_MAX)

/* Used with UV/IV arguments: */
					/* XXXX: need to speed it up */
#define CLUMP_2UV(iv)	((iv) < 0 ? 0 : (UV)(iv))
#define CLUMP_2IV(uv)	((uv) > (UV)IV_MAX ? IV_MAX : (IV)(uv))

#ifndef MAXSYSFD
#   define MAXSYSFD 2
#endif

#ifndef __cplusplus
#ifndef UNDER_CE
Uid_t getuid (void);
Uid_t geteuid (void);
Gid_t getgid (void);
Gid_t getegid (void);
#endif
#endif

#ifndef Perl_debug_log
#  define Perl_debug_log	PerlIO_stderr()
#endif

#ifndef Perl_error_log
#  define Perl_error_log	(PL_stderrgv			\
				 && isGV(PL_stderrgv)		\
				 && GvIOp(PL_stderrgv)          \
				 && IoOFP(GvIOp(PL_stderrgv))	\
				 ? IoOFP(GvIOp(PL_stderrgv))	\
				 : PerlIO_stderr())
#endif


#define DEBUG_p_FLAG		0x00000001 /*      1 */
#define DEBUG_s_FLAG		0x00000002 /*      2 */
#define DEBUG_l_FLAG		0x00000004 /*      4 */
#define DEBUG_t_FLAG		0x00000008 /*      8 */
#define DEBUG_o_FLAG		0x00000010 /*     16 */
#define DEBUG_c_FLAG		0x00000020 /*     32 */
#define DEBUG_P_FLAG		0x00000040 /*     64 */
#define DEBUG_m_FLAG		0x00000080 /*    128 */
#define DEBUG_f_FLAG		0x00000100 /*    256 */
#define DEBUG_r_FLAG		0x00000200 /*    512 */
#define DEBUG_x_FLAG		0x00000400 /*   1024 */
#define DEBUG_u_FLAG		0x00000800 /*   2048 */
#define DEBUG_H_FLAG		0x00002000 /*   8192 */
#define DEBUG_X_FLAG		0x00004000 /*  16384 */
#define DEBUG_D_FLAG		0x00008000 /*  32768 */
#define DEBUG_S_FLAG		0x00010000 /*  65536 */
#define DEBUG_T_FLAG		0x00020000 /* 131072 */
#define DEBUG_R_FLAG		0x00040000 /* 262144 */
#define DEBUG_J_FLAG		0x00080000 /* 524288 */
#define DEBUG_v_FLAG		0x00100000 /*1048576 */
#define DEBUG_MASK		0x001FEFFF /* mask of all the standard flags */

#define DEBUG_DB_RECURSE_FLAG	0x40000000
#define DEBUG_TOP_FLAG		0x80000000 /* XXX what's this for ??? Signal
					      that something was done? */

#  define DEBUG_p_TEST_ (PL_debug & DEBUG_p_FLAG)
#  define DEBUG_s_TEST_ (PL_debug & DEBUG_s_FLAG)
#  define DEBUG_l_TEST_ (PL_debug & DEBUG_l_FLAG)
#  define DEBUG_t_TEST_ (PL_debug & DEBUG_t_FLAG)
#  define DEBUG_o_TEST_ (PL_debug & DEBUG_o_FLAG)
#  define DEBUG_c_TEST_ (PL_debug & DEBUG_c_FLAG)
#  define DEBUG_P_TEST_ (PL_debug & DEBUG_P_FLAG)
#  define DEBUG_m_TEST_ (PL_debug & DEBUG_m_FLAG)
#  define DEBUG_f_TEST_ (PL_debug & DEBUG_f_FLAG)
#  define DEBUG_r_TEST_ (PL_debug & DEBUG_r_FLAG)
#  define DEBUG_x_TEST_ (PL_debug & DEBUG_x_FLAG)
#  define DEBUG_u_TEST_ (PL_debug & DEBUG_u_FLAG)
#  define DEBUG_H_TEST_ (PL_debug & DEBUG_H_FLAG)
#  define DEBUG_X_TEST_ (PL_debug & DEBUG_X_FLAG)
#  define DEBUG_D_TEST_ (PL_debug & DEBUG_D_FLAG)
#  define DEBUG_S_TEST_ (PL_debug & DEBUG_S_FLAG)
#  define DEBUG_T_TEST_ (PL_debug & DEBUG_T_FLAG)
#  define DEBUG_R_TEST_ (PL_debug & DEBUG_R_FLAG)
#  define DEBUG_J_TEST_ (PL_debug & DEBUG_J_FLAG)
#  define DEBUG_v_TEST_ (PL_debug & DEBUG_v_FLAG)
#  define DEBUG_Xv_TEST_ (DEBUG_X_TEST_ && DEBUG_v_TEST_)


#ifdef DEBUGGING

#  undef  YYDEBUG
#  define YYDEBUG 1

#  define DEBUG_p_TEST DEBUG_p_TEST_
#  define DEBUG_s_TEST DEBUG_s_TEST_
#  define DEBUG_l_TEST DEBUG_l_TEST_
#  define DEBUG_t_TEST DEBUG_t_TEST_
#  define DEBUG_o_TEST DEBUG_o_TEST_
#  define DEBUG_c_TEST DEBUG_c_TEST_
#  define DEBUG_P_TEST DEBUG_P_TEST_
#  define DEBUG_m_TEST DEBUG_m_TEST_
#  define DEBUG_f_TEST DEBUG_f_TEST_
#  define DEBUG_r_TEST DEBUG_r_TEST_
#  define DEBUG_x_TEST DEBUG_x_TEST_
#  define DEBUG_u_TEST DEBUG_u_TEST_
#  define DEBUG_H_TEST DEBUG_H_TEST_
#  define DEBUG_X_TEST DEBUG_X_TEST_
#  define DEBUG_Xv_TEST DEBUG_Xv_TEST_
#  define DEBUG_D_TEST DEBUG_D_TEST_
#  define DEBUG_S_TEST DEBUG_S_TEST_
#  define DEBUG_T_TEST DEBUG_T_TEST_
#  define DEBUG_R_TEST DEBUG_R_TEST_
#  define DEBUG_J_TEST DEBUG_J_TEST_
#  define DEBUG_v_TEST DEBUG_v_TEST_

#  define PERL_DEB(a)                  a
#  define PERL_DEBUG(a) if (PL_debug)  a
#  define DEBUG_p(a) if (DEBUG_p_TEST) a
#  define DEBUG_s(a) if (DEBUG_s_TEST) a
#  define DEBUG_l(a) if (DEBUG_l_TEST) a
#  define DEBUG_t(a) if (DEBUG_t_TEST) a
#  define DEBUG_o(a) if (DEBUG_o_TEST) a
#  define DEBUG_c(a) if (DEBUG_c_TEST) a
#  define DEBUG_P(a) if (DEBUG_P_TEST) a

     /* Temporarily turn off memory debugging in case the a
      * does memory allocation, either directly or indirectly. */
#  define DEBUG_m(a)  \
    STMT_START {							\
        if (PERL_GET_INTERP) { dTHX; if (DEBUG_m_TEST) {PL_debug&=~DEBUG_m_FLAG; a; PL_debug|=DEBUG_m_FLAG;} } \
    } STMT_END

#  define DEBUG__(t, a) \
	STMT_START { \
		if (t) STMT_START {a;} STMT_END; \
	} STMT_END

#  define DEBUG_f(a) DEBUG__(DEBUG_f_TEST, a)
#  define DEBUG_r(a) DEBUG__(DEBUG_r_TEST, a)
#  define DEBUG_x(a) DEBUG__(DEBUG_x_TEST, a)
#  define DEBUG_u(a) DEBUG__(DEBUG_u_TEST, a)
#  define DEBUG_H(a) DEBUG__(DEBUG_H_TEST, a)
#  define DEBUG_X(a) DEBUG__(DEBUG_X_TEST, a)
#  define DEBUG_Xv(a) DEBUG__(DEBUG_Xv_TEST, a)
#  define DEBUG_D(a) DEBUG__(DEBUG_D_TEST, a)

#  ifdef USE_5005THREADS
#    define DEBUG_S(a) DEBUG__(DEBUG_S_TEST, a)
#  else
#    define DEBUG_S(a)
#  endif

#  define DEBUG_T(a) DEBUG__(DEBUG_T_TEST, a)
#  define DEBUG_R(a) DEBUG__(DEBUG_R_TEST, a)
#  define DEBUG_v(a) DEBUG__(DEBUG_v_TEST, a)

#else /* DEBUGGING */

#  define DEBUG_p_TEST (0)
#  define DEBUG_s_TEST (0)
#  define DEBUG_l_TEST (0)
#  define DEBUG_t_TEST (0)
#  define DEBUG_o_TEST (0)
#  define DEBUG_c_TEST (0)
#  define DEBUG_P_TEST (0)
#  define DEBUG_m_TEST (0)
#  define DEBUG_f_TEST (0)
#  define DEBUG_r_TEST (0)
#  define DEBUG_x_TEST (0)
#  define DEBUG_u_TEST (0)
#  define DEBUG_H_TEST (0)
#  define DEBUG_X_TEST (0)
#  define DEBUG_Xv_TEST (0)
#  define DEBUG_D_TEST (0)
#  define DEBUG_S_TEST (0)
#  define DEBUG_T_TEST (0)
#  define DEBUG_R_TEST (0)
#  define DEBUG_J_TEST (0)
#  define DEBUG_v_TEST (0)

#  define PERL_DEB(a)
#  define PERL_DEBUG(a)
#  define DEBUG_p(a)
#  define DEBUG_s(a)
#  define DEBUG_l(a)
#  define DEBUG_t(a)
#  define DEBUG_o(a)
#  define DEBUG_c(a)
#  define DEBUG_P(a)
#  define DEBUG_m(a)
#  define DEBUG_f(a)
#  define DEBUG_r(a)
#  define DEBUG_x(a)
#  define DEBUG_u(a)
#  define DEBUG_H(a)
#  define DEBUG_X(a)
#  define DEBUG_Xv(a)
#  define DEBUG_D(a)
#  define DEBUG_S(a)
#  define DEBUG_T(a)
#  define DEBUG_R(a)
#  define DEBUG_v(a)
#endif /* DEBUGGING */


#define DEBUG_SCOPE(where) \
    DEBUG_l(WITH_THR(Perl_deb(aTHX_ "%s scope %ld at %s:%d\n",	\
		    where, (long)PL_scopestack_ix, __FILE__, __LINE__)));




/* These constants should be used in preference to raw characters
 * when using magic. Note that some perl guts still assume
 * certain character properties of these constants, namely that
 * isUPPER() and toLOWER() may do useful mappings.
 *
 * Update the magic_names table in dump.c when adding/amending these
 */

#define PERL_MAGIC_sv		  '\0' /* Special scalar variable */
#define PERL_MAGIC_overload	  'A' /* %OVERLOAD hash */
#define PERL_MAGIC_overload_elem  'a' /* %OVERLOAD hash element */
#define PERL_MAGIC_overload_table 'c' /* Holds overload table (AMT) on stash */
#define PERL_MAGIC_bm		  'B' /* Boyer-Moore (fast string search) */
#define PERL_MAGIC_regdata	  'D' /* Regex match position data
					(@+ and @- vars) */
#define PERL_MAGIC_regdatum	  'd' /* Regex match position data element */
#define PERL_MAGIC_env		  'E' /* %ENV hash */
#define PERL_MAGIC_envelem	  'e' /* %ENV hash element */
#define PERL_MAGIC_fm		  'f' /* Formline ('compiled' format) */
#define PERL_MAGIC_regex_global	  'g' /* m//g target / study()ed string */
#define PERL_MAGIC_isa		  'I' /* @ISA array */
#define PERL_MAGIC_isaelem	  'i' /* @ISA array element */
#define PERL_MAGIC_nkeys	  'k' /* scalar(keys()) lvalue */
#define PERL_MAGIC_dbfile	  'L' /* Debugger %_<filename */
#define PERL_MAGIC_dbline	  'l' /* Debugger %_<filename element */
#define PERL_MAGIC_mutex	  'm' /* for lock op */
#define PERL_MAGIC_shared	  'N' /* Shared between threads */
#define PERL_MAGIC_shared_scalar  'n' /* Shared between threads */
#define PERL_MAGIC_collxfrm	  'o' /* Locale transformation */
#define PERL_MAGIC_tied		  'P' /* Tied array or hash */
#define PERL_MAGIC_tiedelem	  'p' /* Tied array or hash element */
#define PERL_MAGIC_tiedscalar	  'q' /* Tied scalar or handle */
#define PERL_MAGIC_qr		  'r' /* precompiled qr// regex */
#define PERL_MAGIC_sig		  'S' /* %SIG hash */
#define PERL_MAGIC_sigelem	  's' /* %SIG hash element */
#define PERL_MAGIC_taint	  't' /* Taintedness */
#define PERL_MAGIC_uvar		  'U' /* Available for use by extensions */
#define PERL_MAGIC_uvar_elem	  'u' /* Reserved for use by extensions */
#define PERL_MAGIC_vstring	  'V' /* SV was vstring literal */
#define PERL_MAGIC_vec		  'v' /* vec() lvalue */
#define PERL_MAGIC_utf8		  'w' /* Cached UTF-8 information */
#define PERL_MAGIC_substr	  'x' /* substr() lvalue */
#define PERL_MAGIC_defelem	  'y' /* Shadow "foreach" iterator variable /
					smart parameter vivification */
#define PERL_MAGIC_glob		  '*' /* GV (typeglob) */
#define PERL_MAGIC_arylen	  '#' /* Array length ($#ary) */
#define PERL_MAGIC_pos		  '.' /* pos() lvalue */
#define PERL_MAGIC_backref	  '<' /* for weak ref data */
#define PERL_MAGIC_ext		  '~' /* Available for use by extensions */


#define YYMAXDEPTH 300

#ifndef assert  /* <assert.h> might have been included somehow */
#define assert(what)	PERL_DEB( 					\
	((what) ? ((void) 0) :						\
	    (Perl_croak(aTHX_ "Assertion %s failed: file \"" __FILE__ 	\
			"\", line %d", STRINGIFY(what), __LINE__),	\
	    PerlProc_exit(1),						\
	    (void) 0)))
#endif

struct ufuncs {
    I32 (*uf_val)(pTHX_ IV, SV*);
    I32 (*uf_set)(pTHX_ IV, SV*);
    IV uf_index;
};

/* In pre-5.7-Perls the PERL_MAGIC_uvar magic didn't get the thread context.
 * XS code wanting to be backward compatible can do something
 * like the following:

#ifndef PERL_MG_UFUNC
#define PERL_MG_UFUNC(name,ix,sv) I32 name(IV ix, SV *sv)
#endif

static PERL_MG_UFUNC(foo_get, index, val)
{
    sv_setsv(val, ...);
    return TRUE;
}

-- Doug MacEachern

*/

#ifndef PERL_MG_UFUNC
#define PERL_MG_UFUNC(name,ix,sv) I32 name(pTHX_ IV ix, SV *sv)
#endif

/* Fix these up for __STDC__ */
#ifndef DONT_DECLARE_STD
char *mktemp (char*);
#ifndef atof
double atof (const char*);
#endif
#endif

#ifndef STANDARD_C
/* All of these are in stdlib.h or time.h for ANSI C */
Time_t time();
struct tm *gmtime(), *localtime();
#if defined(OEMVS) || defined(__OPEN_VM)
char *(strchr)(), *(strrchr)();
char *(strcpy)(), *(strcat)();
#else
char *strchr(), *strrchr();
char *strcpy(), *strcat();
#endif
#endif /* ! STANDARD_C */


#ifdef I_MATH
#    include <math.h>
#else
START_EXTERN_C
	    double exp (double);
	    double log (double);
	    double log10 (double);
	    double sqrt (double);
	    double frexp (double,int*);
	    double ldexp (double,int);
	    double modf (double,double*);
	    double sin (double);
	    double cos (double);
	    double atan2 (double,double);
	    double pow (double,double);
END_EXTERN_C
#endif

#if !defined(NV_INF) && defined(USE_LONG_DOUBLE) && defined(LDBL_INFINITY)
#  define NV_INF LDBL_INFINITY
#endif
#if !defined(NV_INF) && defined(DBL_INFINITY)
#  define NV_INF (NV)DBL_INFINITY
#endif
#if !defined(NV_INF) && defined(INFINITY)
#  define NV_INF (NV)INFINITY
#endif
#if !defined(NV_INF) && defined(INF)
#  define NV_INF (NV)INF
#endif
#if !defined(NV_INF) && defined(USE_LONG_DOUBLE) && defined(HUGE_VALL)
#  define NV_INF (NV)HUGE_VALL
#endif
#if !defined(NV_INF) && defined(HUGE_VAL)
#  define NV_INF (NV)HUGE_VAL
#endif

#if !defined(NV_NAN) && defined(USE_LONG_DOUBLE)
#   if !defined(NV_NAN) && defined(LDBL_NAN)
#       define NV_NAN LDBL_NAN
#   endif
#   if !defined(NV_NAN) && defined(LDBL_QNAN)
#       define NV_NAN LDBL_QNAN
#   endif
#   if !defined(NV_NAN) && defined(LDBL_SNAN)
#       define NV_NAN LDBL_SNAN
#   endif
#endif
#if !defined(NV_NAN) && defined(DBL_NAN)
#  define NV_NAN (NV)DBL_NAN
#endif
#if !defined(NV_NAN) && defined(DBL_QNAN)
#  define NV_NAN (NV)DBL_QNAN
#endif
#if !defined(NV_NAN) && defined(DBL_SNAN)
#  define NV_NAN (NV)DBL_SNAN
#endif
#if !defined(NV_NAN) && defined(QNAN)
#  define NV_NAN (NV)QNAN
#endif
#if !defined(NV_NAN) && defined(SNAN)
#  define NV_NAN (NV)SNAN
#endif
#if !defined(NV_NAN) && defined(NAN)
#  define NV_NAN (NV)NAN
#endif

#ifndef __cplusplus
#  if defined(NeXT) || defined(__NeXT__) /* or whatever catches all NeXTs */
char *crypt ();       /* Maybe more hosts will need the unprototyped version */
#  else
#    if !defined(WIN32) && !defined(VMS)
#ifndef crypt
char *crypt (const char*, const char*);
#endif
#    endif /* !WIN32 */
#  endif /* !NeXT && !__NeXT__ */
#  ifndef DONT_DECLARE_STD
#    ifndef getenv
char *getenv (const char*);
#    endif /* !getenv */
#    if !defined(HAS_LSEEK_PROTO) && !defined(EPOC) && !defined(__hpux)
#      ifdef _FILE_OFFSET_BITS
#        if _FILE_OFFSET_BITS == 64
Off_t lseek (int,Off_t,int);
#        endif
#      endif
#    endif
#  endif /* !DONT_DECLARE_STD */
#ifndef getlogin
char *getlogin (void);
#endif
#endif /* !__cplusplus */

#ifdef UNLINK_ALL_VERSIONS /* Currently only makes sense for VMS */
#define UNLINK unlnk
I32 unlnk (char*);
#else
#define UNLINK PerlLIO_unlink
#endif

/* some versions of glibc are missing the setresuid() proto */
#if defined(HAS_SETRESUID) && !defined(HAS_SETRESUID_PROTO)
int setresuid(uid_t ruid, uid_t euid, uid_t suid);
#endif
/* some versions of glibc are missing the setresgid() proto */
#if defined(HAS_SETRESGID) && !defined(HAS_SETRESGID_PROTO)
int setresgid(gid_t rgid, gid_t egid, gid_t sgid);
#endif

#ifndef HAS_SETREUID
#  ifdef HAS_SETRESUID
#    define setreuid(r,e) setresuid(r,e,(Uid_t)-1)
#    define HAS_SETREUID
#  endif
#endif
#ifndef HAS_SETREGID
#  ifdef HAS_SETRESGID
#    define setregid(r,e) setresgid(r,e,(Gid_t)-1)
#    define HAS_SETREGID
#  endif
#endif

/* Sighandler_t defined in iperlsys.h */

#ifdef HAS_SIGACTION
typedef struct sigaction Sigsave_t;
#else
typedef Sighandler_t Sigsave_t;
#endif

#define SCAN_DEF 0
#define SCAN_TR 1
#define SCAN_REPL 2

#ifdef DEBUGGING
# ifndef register
#  define register
# endif
# define RUNOPS_DEFAULT Perl_runops_debug
#else
# define RUNOPS_DEFAULT Perl_runops_standard
#endif

#ifdef MYMALLOC
#  ifdef MUTEX_INIT_CALLS_MALLOC
#    define MALLOC_INIT					\
	STMT_START {					\
		PL_malloc_mutex = NULL;			\
		MUTEX_INIT(&PL_malloc_mutex);		\
	} STMT_END
#    define MALLOC_TERM					\
	STMT_START {					\
		perl_mutex tmp = PL_malloc_mutex;	\
		PL_malloc_mutex = NULL;			\
		MUTEX_DESTROY(&tmp);			\
	} STMT_END
#  else
#    define MALLOC_INIT MUTEX_INIT(&PL_malloc_mutex)
#    define MALLOC_TERM MUTEX_DESTROY(&PL_malloc_mutex)
#  endif
#else
#  define MALLOC_INIT
#  define MALLOC_TERM
#endif


typedef int (CPERLscope(*runops_proc_t)) (pTHX);
typedef void (CPERLscope(*share_proc_t)) (pTHX_ SV *sv);
typedef int  (CPERLscope(*thrhook_proc_t)) (pTHX);
typedef OP* (CPERLscope(*PPADDR_t)[]) (pTHX);

/* _ (for $_) must be first in the following list (DEFSV requires it) */
#define THREADSV_NAMES "_123456789&`'+/.,\\\";^-%=|~:\001\005!@"

/* NeXT has problems with crt0.o globals */
#if defined(__DYNAMIC__) && \
    (defined(NeXT) || defined(__NeXT__) || defined(PERL_DARWIN))
#  if defined(NeXT) || defined(__NeXT)
#    include <mach-o/dyld.h>
#    define environ (*environ_pointer)
EXT char *** environ_pointer;
#  else
#    if defined(PERL_DARWIN) && defined(PERL_CORE)
#      include <crt_externs.h>	/* for the env array */
#      define environ (*_NSGetEnviron())
#    endif
#  endif
#else
   /* VMS and some other platforms don't use the environ array */
#  ifdef USE_ENVIRON_ARRAY
#    if !defined(DONT_DECLARE_STD) || \
        (defined(__svr4__) && defined(__GNUC__) && defined(sun)) || \
        defined(__sgi) || \
        defined(__DGUX)
extern char **	environ;	/* environment variables supplied via exec */
#    endif
#  endif
#endif

START_EXTERN_C

/* handy constants */
EXTCONST char PL_warn_uninit[]
  INIT("Use of uninitialized value%s%s");
EXTCONST char PL_warn_nosemi[]
  INIT("Semicolon seems to be missing");
EXTCONST char PL_warn_reserved[]
  INIT("Unquoted string \"%s\" may clash with future reserved word");
EXTCONST char PL_warn_nl[]
  INIT("Unsuccessful %s on filename containing newline");
EXTCONST char PL_no_wrongref[]
  INIT("Can't use %s ref as %s ref");
EXTCONST char PL_no_symref[]
  INIT("Can't use string (\"%.32s\") as %s ref while \"strict refs\" in use");
EXTCONST char PL_no_usym[]
  INIT("Can't use an undefined value as %s reference");
EXTCONST char PL_no_aelem[]
  INIT("Modification of non-creatable array value attempted, subscript %d");
EXTCONST char PL_no_helem[]
  INIT("Modification of non-creatable hash value attempted, subscript \"%s\"");
EXTCONST char PL_no_helem_sv[]
  INIT("Modification of non-creatable hash value attempted, subscript \""SVf"\"");
EXTCONST char PL_no_modify[]
  INIT("Modification of a read-only value attempted");
EXTCONST char PL_no_mem[]
  INIT("Out of memory!\n");
EXTCONST char PL_no_security[]
  INIT("Insecure dependency in %s%s");
EXTCONST char PL_no_sock_func[]
  INIT("Unsupported socket function \"%s\" called");
EXTCONST char PL_no_dir_func[]
  INIT("Unsupported directory function \"%s\" called");
EXTCONST char PL_no_func[]
  INIT("The %s function is unimplemented");
EXTCONST char PL_no_myglob[]
  INIT("\"my\" variable %s can't be in a package");
EXTCONST char PL_no_localize_ref[]
  INIT("Can't localize through a reference");
EXTCONST char PL_memory_wrap[]
  INIT("panic: memory wrap");

EXTCONST char PL_uuemap[65]
  INIT("`!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_");


#ifdef DOINIT
EXT const char *PL_sig_name[] = { SIG_NAME };
EXT int   PL_sig_num[]  = { SIG_NUM };
#else
EXT const char *PL_sig_name[];
EXT int   PL_sig_num[];
#endif

/* fast conversion and case folding tables */

#ifdef DOINIT
#ifdef EBCDIC
EXT unsigned char PL_fold[] = { /* fast EBCDIC case folding table */
    0,      1,      2,      3,      4,      5,      6,      7,
    8,      9,      10,     11,     12,     13,     14,     15,
    16,     17,     18,     19,     20,     21,     22,     23,
    24,     25,     26,     27,     28,     29,     30,     31,
    32,     33,     34,     35,     36,     37,     38,     39,
    40,     41,     42,     43,     44,     45,     46,     47,
    48,     49,     50,     51,     52,     53,     54,     55,
    56,     57,     58,     59,     60,     61,     62,     63,
    64,     65,     66,     67,     68,     69,     70,     71,
    72,     73,     74,     75,     76,     77,     78,     79,
    80,     81,     82,     83,     84,     85,     86,     87,
    88,     89,     90,     91,     92,     93,     94,     95,
    96,     97,     98,     99,     100,    101,    102,    103,
    104,    105,    106,    107,    108,    109,    110,    111,
    112,    113,    114,    115,    116,    117,    118,    119,
    120,    121,    122,    123,    124,    125,    126,    127,
    128,    'A',    'B',    'C',    'D',    'E',    'F',    'G',
    'H',    'I',    138,    139,    140,    141,    142,    143,
    144,    'J',    'K',    'L',    'M',    'N',    'O',    'P',
    'Q',    'R',    154,    155,    156,    157,    158,    159,
    160,    161,    'S',    'T',    'U',    'V',    'W',    'X',
    'Y',    'Z',    170,    171,    172,    173,    174,    175,
    176,    177,    178,    179,    180,    181,    182,    183,
    184,    185,    186,    187,    188,    189,    190,    191,
    192,    'a',    'b',    'c',    'd',    'e',    'f',    'g',
    'h',    'i',    202,    203,    204,    205,    206,    207,
    208,    'j',    'k',    'l',    'm',    'n',    'o',    'p',
    'q',    'r',    218,    219,    220,    221,    222,    223,
    224,    225,    's',    't',    'u',    'v',    'w',    'x',
    'y',    'z',    234,    235,    236,    237,    238,    239,
    240,    241,    242,    243,    244,    245,    246,    247,
    248,    249,    250,    251,    252,    253,    254,    255
};
#else   /* ascii rather than ebcdic */
EXTCONST  unsigned char PL_fold[] = {
	0,	1,	2,	3,	4,	5,	6,	7,
	8,	9,	10,	11,	12,	13,	14,	15,
	16,	17,	18,	19,	20,	21,	22,	23,
	24,	25,	26,	27,	28,	29,	30,	31,
	32,	33,	34,	35,	36,	37,	38,	39,
	40,	41,	42,	43,	44,	45,	46,	47,
	48,	49,	50,	51,	52,	53,	54,	55,
	56,	57,	58,	59,	60,	61,	62,	63,
	64,	'a',	'b',	'c',	'd',	'e',	'f',	'g',
	'h',	'i',	'j',	'k',	'l',	'm',	'n',	'o',
	'p',	'q',	'r',	's',	't',	'u',	'v',	'w',
	'x',	'y',	'z',	91,	92,	93,	94,	95,
	96,	'A',	'B',	'C',	'D',	'E',	'F',	'G',
	'H',	'I',	'J',	'K',	'L',	'M',	'N',	'O',
	'P',	'Q',	'R',	'S',	'T',	'U',	'V',	'W',
	'X',	'Y',	'Z',	123,	124,	125,	126,	127,
	128,	129,	130,	131,	132,	133,	134,	135,
	136,	137,	138,	139,	140,	141,	142,	143,
	144,	145,	146,	147,	148,	149,	150,	151,
	152,	153,	154,	155,	156,	157,	158,	159,
	160,	161,	162,	163,	164,	165,	166,	167,
	168,	169,	170,	171,	172,	173,	174,	175,
	176,	177,	178,	179,	180,	181,	182,	183,
	184,	185,	186,	187,	188,	189,	190,	191,
	192,	193,	194,	195,	196,	197,	198,	199,
	200,	201,	202,	203,	204,	205,	206,	207,
	208,	209,	210,	211,	212,	213,	214,	215,
	216,	217,	218,	219,	220,	221,	222,	223,	
	224,	225,	226,	227,	228,	229,	230,	231,
	232,	233,	234,	235,	236,	237,	238,	239,
	240,	241,	242,	243,	244,	245,	246,	247,
	248,	249,	250,	251,	252,	253,	254,	255
};
#endif  /* !EBCDIC */
#else
EXTCONST unsigned char PL_fold[];
#endif

#ifdef DOINIT
EXT unsigned char PL_fold_locale[] = {
	0,	1,	2,	3,	4,	5,	6,	7,
	8,	9,	10,	11,	12,	13,	14,	15,
	16,	17,	18,	19,	20,	21,	22,	23,
	24,	25,	26,	27,	28,	29,	30,	31,
	32,	33,	34,	35,	36,	37,	38,	39,
	40,	41,	42,	43,	44,	45,	46,	47,
	48,	49,	50,	51,	52,	53,	54,	55,
	56,	57,	58,	59,	60,	61,	62,	63,
	64,	'a',	'b',	'c',	'd',	'e',	'f',	'g',
	'h',	'i',	'j',	'k',	'l',	'm',	'n',	'o',
	'p',	'q',	'r',	's',	't',	'u',	'v',	'w',
	'x',	'y',	'z',	91,	92,	93,	94,	95,
	96,	'A',	'B',	'C',	'D',	'E',	'F',	'G',
	'H',	'I',	'J',	'K',	'L',	'M',	'N',	'O',
	'P',	'Q',	'R',	'S',	'T',	'U',	'V',	'W',
	'X',	'Y',	'Z',	123,	124,	125,	126,	127,
	128,	129,	130,	131,	132,	133,	134,	135,
	136,	137,	138,	139,	140,	141,	142,	143,
	144,	145,	146,	147,	148,	149,	150,	151,
	152,	153,	154,	155,	156,	157,	158,	159,
	160,	161,	162,	163,	164,	165,	166,	167,
	168,	169,	170,	171,	172,	173,	174,	175,
	176,	177,	178,	179,	180,	181,	182,	183,
	184,	185,	186,	187,	188,	189,	190,	191,
	192,	193,	194,	195,	196,	197,	198,	199,
	200,	201,	202,	203,	204,	205,	206,	207,
	208,	209,	210,	211,	212,	213,	214,	215,
	216,	217,	218,	219,	220,	221,	222,	223,	
	224,	225,	226,	227,	228,	229,	230,	231,
	232,	233,	234,	235,	236,	237,	238,	239,
	240,	241,	242,	243,	244,	245,	246,	247,
	248,	249,	250,	251,	252,	253,	254,	255
};
#else
EXT unsigned char PL_fold_locale[];
#endif

#ifdef DOINIT
#ifdef EBCDIC
EXT unsigned char PL_freq[] = {/* EBCDIC frequencies for mixed English/C */
    1,      2,      84,     151,    154,    155,    156,    157,
    165,    246,    250,    3,      158,    7,      18,     29,
    40,     51,     62,     73,     85,     96,     107,    118,
    129,    140,    147,    148,    149,    150,    152,    153,
    255,      6,      8,      9,     10,     11,     12,     13,
     14,     15,     24,     25,     26,     27,     28,    226,
     29,     30,     31,     32,     33,     43,     44,     45,
     46,     47,     48,     49,     50,     76,     77,     78,
     79,     80,     81,     82,     83,     84,     85,     86,
     87,     94,     95,    234,    181,    233,    187,    190,
    180,     96,     97,     98,     99,    100,    101,    102,
    104,    112,    182,    174,    236,    232,    229,    103,
    228,    226,    114,    115,    116,    117,    118,    119,
    120,    121,    122,    235,    176,    230,    194,    162,
    130,    131,    132,    133,    134,    135,    136,    137,
    138,    139,    201,    205,    163,    217,    220,    224,
    5,      248,    227,    244,    242,    255,    241,    231,
    240,    253,    16,     197,    19,     20,     21,     187,
    23,     169,    210,    245,    237,    249,    247,    239,
    168,    252,    34,     196,    36,     37,     38,     39,
    41,     42,     251,    254,    238,    223,    221,    213,
    225,    177,    52,     53,     54,     55,     56,     57,
    58,     59,     60,     61,     63,     64,     65,     66,
    67,     68,     69,     70,     71,     72,     74,     75,
    205,    208,    186,    202,    200,    218,    198,    179,
    178,    214,    88,     89,     90,     91,     92,     93,
    217,    166,    170,    207,    199,    209,    206,    204,
    160,    212,    105,    106,    108,    109,    110,    111,
    203,    113,    216,    215,    192,    175,    193,    243,
    172,    161,    123,    124,    125,    126,    127,    128,
    222,    219,    211,    195,    188,    193,    185,    184,
    191,    183,    141,    142,    143,    144,    145,    146
};
#else  /* ascii rather than ebcdic */
EXTCONST unsigned char PL_freq[] = {	/* letter frequencies for mixed English/C */
	1,	2,	84,	151,	154,	155,	156,	157,
	165,	246,	250,	3,	158,	7,	18,	29,
	40,	51,	62,	73,	85,	96,	107,	118,
	129,	140,	147,	148,	149,	150,	152,	153,
	255,	182,	224,	205,	174,	176,	180,	217,
	233,	232,	236,	187,	235,	228,	234,	226,
	222,	219,	211,	195,	188,	193,	185,	184,
	191,	183,	201,	229,	181,	220,	194,	162,
	163,	208,	186,	202,	200,	218,	198,	179,
	178,	214,	166,	170,	207,	199,	209,	206,
	204,	160,	212,	216,	215,	192,	175,	173,
	243,	172,	161,	190,	203,	189,	164,	230,
	167,	248,	227,	244,	242,	255,	241,	231,
	240,	253,	169,	210,	245,	237,	249,	247,
	239,	168,	252,	251,	254,	238,	223,	221,
	213,	225,	177,	197,	171,	196,	159,	4,
	5,	6,	8,	9,	10,	11,	12,	13,
	14,	15,	16,	17,	19,	20,	21,	22,
	23,	24,	25,	26,	27,	28,	30,	31,
	32,	33,	34,	35,	36,	37,	38,	39,
	41,	42,	43,	44,	45,	46,	47,	48,
	49,	50,	52,	53,	54,	55,	56,	57,
	58,	59,	60,	61,	63,	64,	65,	66,
	67,	68,	69,	70,	71,	72,	74,	75,
	76,	77,	78,	79,	80,	81,	82,	83,
	86,	87,	88,	89,	90,	91,	92,	93,
	94,	95,	97,	98,	99,	100,	101,	102,
	103,	104,	105,	106,	108,	109,	110,	111,
	112,	113,	114,	115,	116,	117,	119,	120,
	121,	122,	123,	124,	125,	126,	127,	128,
	130,	131,	132,	133,	134,	135,	136,	137,
	138,	139,	141,	142,	143,	144,	145,	146
};
#endif
#else
EXTCONST unsigned char PL_freq[];
#endif

#ifdef DEBUGGING
#ifdef DOINIT
EXTCONST char* PL_block_type[] = {
	"NULL",
	"SUB",
	"EVAL",
	"LOOP",
	"SUBST",
	"BLOCK",
};
#else
EXTCONST char* PL_block_type[];
#endif
#endif

END_EXTERN_C

/*****************************************************************************/
/* This lexer/parser stuff is currently global since yacc is hard to reenter */
/*****************************************************************************/
/* XXX This needs to be revisited, since BEGIN makes yacc re-enter... */

#ifdef __Lynx__
/* LynxOS defines these in scsi.h which is included via ioctl.h */
#ifdef FORMAT
#undef FORMAT
#endif
#ifdef SPACE
#undef SPACE
#endif
#endif

#include "perly.h"

#define LEX_NOTPARSING		11	/* borrowed from toke.c */

typedef enum {
    XOPERATOR,
    XTERM,
    XREF,
    XSTATE,
    XBLOCK,
    XATTRBLOCK,
    XATTRTERM,
    XTERMBLOCK
} expectation;

enum {		/* pass one of these to get_vtbl */
    want_vtbl_sv,
    want_vtbl_env,
    want_vtbl_envelem,
    want_vtbl_sig,
    want_vtbl_sigelem,
    want_vtbl_pack,
    want_vtbl_packelem,
    want_vtbl_dbline,
    want_vtbl_isa,
    want_vtbl_isaelem,
    want_vtbl_arylen,
    want_vtbl_glob,
    want_vtbl_mglob,
    want_vtbl_nkeys,
    want_vtbl_taint,
    want_vtbl_substr,
    want_vtbl_vec,
    want_vtbl_pos,
    want_vtbl_bm,
    want_vtbl_fm,
    want_vtbl_uvar,
    want_vtbl_defelem,
    want_vtbl_regexp,
    want_vtbl_collxfrm,
    want_vtbl_amagic,
    want_vtbl_amagicelem,
#ifdef USE_5005THREADS
    want_vtbl_mutex,
#endif
    want_vtbl_regdata,
    want_vtbl_regdatum,
    want_vtbl_backref,
    want_vtbl_utf8
};

				/* Note: the lowest 8 bits are reserved for
				   stuffing into op->op_private */
#define HINT_PRIVATE_MASK	0x000000ff
#define HINT_INTEGER		0x00000001 /* integer pragma */
#define HINT_STRICT_REFS	0x00000002 /* strict pragma */
#define HINT_LOCALE		0x00000004 /* locale pragma */
#define HINT_BYTES		0x00000008 /* bytes pragma */
/* #define HINT_notused10	0x00000010 */
				/* Note: 20,40,80 used for NATIVE_HINTS */
				/* currently defined by vms/vmsish.h */

#define HINT_BLOCK_SCOPE	0x00000100
#define HINT_STRICT_SUBS	0x00000200 /* strict pragma */
#define HINT_STRICT_VARS	0x00000400 /* strict pragma */

/* The HINT_NEW_* constants are used by the overload pragma */
#define HINT_NEW_INTEGER	0x00001000
#define HINT_NEW_FLOAT		0x00002000
#define HINT_NEW_BINARY		0x00004000
#define HINT_NEW_STRING		0x00008000
#define HINT_NEW_RE		0x00010000
#define HINT_LOCALIZE_HH	0x00020000 /* %^H needs to be copied */

#define HINT_RE_TAINT		0x00100000 /* re pragma */
#define HINT_RE_EVAL		0x00200000 /* re pragma */

#define HINT_FILETEST_ACCESS	0x00400000 /* filetest pragma */
#define HINT_UTF8		0x00800000 /* utf8 pragma */

/* The following are stored in $sort::hints, not in PL_hints */
#define HINT_SORT_SORT_BITS	0x000000FF /* allow 256 different ones */
#define HINT_SORT_QUICKSORT	0x00000001
#define HINT_SORT_MERGESORT	0x00000002
#define HINT_SORT_STABLE	0x00000100 /* sort styles (currently one) */

/* Various states of the input record separator SV (rs) */
#define RsSNARF(sv)   (! SvOK(sv))
#define RsSIMPLE(sv)  (SvOK(sv) && (! SvPOK(sv) || SvCUR(sv)))
#define RsPARA(sv)    (SvPOK(sv) && ! SvCUR(sv))
#define RsRECORD(sv)  (SvROK(sv) && (SvIV(SvRV(sv)) > 0))

/* A struct for keeping various DEBUGGING related stuff,
 * neatly packed.  Currently only scratch variables for
 * constructing debug output are included.  Needed always,
 * not just when DEBUGGING, though, because of the re extension. c*/
struct perl_debug_pad {
  SV pad[3];
};

#define PERL_DEBUG_PAD(i)	&(PL_debug_pad.pad[i])
#define PERL_DEBUG_PAD_ZERO(i)	(SvPVX(PERL_DEBUG_PAD(i))[0] = 0, \
	(((XPV*) SvANY(PERL_DEBUG_PAD(i)))->xpv_cur = 0), \
	PERL_DEBUG_PAD(i))

/* Enable variables which are pointers to functions */
typedef void (CPERLscope(*peep_t))(pTHX_ OP* o);
typedef regexp*(CPERLscope(*regcomp_t)) (pTHX_ char* exp, char* xend, PMOP* pm);
typedef I32 (CPERLscope(*regexec_t)) (pTHX_ regexp* prog, char* stringarg,
				      char* strend, char* strbeg, I32 minend,
				      SV* screamer, void* data, U32 flags);
typedef char* (CPERLscope(*re_intuit_start_t)) (pTHX_ regexp *prog, SV *sv,
						char *strpos, char *strend,
						U32 flags,
						struct re_scream_pos_data_s *d);
typedef SV*	(CPERLscope(*re_intuit_string_t)) (pTHX_ regexp *prog);
typedef void	(CPERLscope(*regfree_t)) (pTHX_ struct regexp* r);

typedef void (*DESTRUCTORFUNC_NOCONTEXT_t) (void*);
typedef void (*DESTRUCTORFUNC_t) (pTHX_ void*);
typedef void (*SVFUNC_t) (pTHX_ SV*);
typedef I32  (*SVCOMPARE_t) (pTHX_ SV*, SV*);
typedef void (*XSINIT_t) (pTHX);
typedef void (*ATEXIT_t) (pTHX_ void*);
typedef void (*XSUBADDR_t) (pTHX_ CV *);

/* Set up PERLVAR macros for populating structs */
#define PERLVAR(var,type) type var;
#define PERLVARA(var,n,type) type var[n];
#define PERLVARI(var,type,init) type var;
#define PERLVARIC(var,type,init) type var;

/* Interpreter exitlist entry */
typedef struct exitlistentry {
    void (*fn) (pTHX_ void*);
    void *ptr;
} PerlExitListEntry;

#ifdef PERL_GLOBAL_STRUCT
struct perl_vars {
#  include "perlvars.h"
};

#  ifdef PERL_CORE
EXT struct perl_vars PL_Vars;
EXT struct perl_vars *PL_VarsPtr INIT(&PL_Vars);
#  else /* PERL_CORE */
#    if !defined(__GNUC__) || !defined(WIN32)
EXT
#    endif /* WIN32 */
struct perl_vars *PL_VarsPtr;
#    define PL_Vars (*((PL_VarsPtr) \
		       ? PL_VarsPtr : (PL_VarsPtr = Perl_GetVars(aTHX))))
#  endif /* PERL_CORE */
#endif /* PERL_GLOBAL_STRUCT */

#if defined(MULTIPLICITY)
/* If we have multiple interpreters define a struct
   holding variables which must be per-interpreter
   If we don't have threads anything that would have
   be per-thread is per-interpreter.
*/

struct interpreter {
#  ifndef USE_5005THREADS
#    include "thrdvar.h"
#  endif
#  include "intrpvar.h"
/*
 * The following is a buffer where new variables must
 * be defined to maintain binary compatibility with previous versions
 */
PERLVARA(object_compatibility,30,	char)
};

#else
struct interpreter {
    char broiled;
};
#endif /* MULTIPLICITY */

#ifdef USE_5005THREADS
/* If we have threads define a struct with all the variables
 * that have to be per-thread
 */


struct perl_thread {
#include "thrdvar.h"
};

typedef struct perl_thread *Thread;

#else
typedef void *Thread;
#endif

/* Done with PERLVAR macros for now ... */
#undef PERLVAR
#undef PERLVARA
#undef PERLVARI
#undef PERLVARIC

/* Types used by pack/unpack */ 
typedef enum {
  e_no_len,     /* no length  */
  e_number,     /* number, [] */
  e_star        /* asterisk   */
} howlen_t;

typedef struct {
  char*    patptr;   /* current template char */
  char*    patend;   /* one after last char   */
  char*    grpbeg;   /* 1st char of ()-group  */
  char*    grpend;   /* end of ()-group       */
  I32      code;     /* template code (!<>)   */
  I32      length;   /* length/repeat count   */
  howlen_t howlen;   /* how length is given   */ 
  int      level;    /* () nesting level      */
  U32      flags;    /* /=4, comma=2, pack=1  */
                     /*   and group modifiers */
} tempsym_t;

#include "thread.h"
#include "pp.h"

#ifndef PERL_CALLCONV
#  define PERL_CALLCONV
#endif
#undef PERL_CKDEF
#undef PERL_PPDEF
#define PERL_CKDEF(s)	PERL_CALLCONV OP *s (pTHX_ OP *o);
#define PERL_PPDEF(s)	PERL_CALLCONV OP *s (pTHX);

#include "proto.h"

/* this has structure inits, so it cannot be included before here */
#include "opcode.h"

/* The following must follow proto.h as #defines mess up syntax */

#if !defined(PERL_FOR_X2P)
#  include "embedvar.h"
#endif

/* Now include all the 'global' variables
 * If we don't have threads or multiple interpreters
 * these include variables that would have been their struct-s
 */

#define PERLVAR(var,type) EXT type PL_##var;
#define PERLVARA(var,n,type) EXT type PL_##var[n];
#define PERLVARI(var,type,init) EXT type  PL_##var INIT(init);
#define PERLVARIC(var,type,init) EXTCONST type PL_##var INIT(init);

#if !defined(MULTIPLICITY)
START_EXTERN_C
#  include "intrpvar.h"
#  ifndef USE_5005THREADS
#    include "thrdvar.h"
#  endif
END_EXTERN_C
#endif

#if defined(WIN32)
/* Now all the config stuff is setup we can include embed.h */
#  include "embed.h"
#endif

#ifndef PERL_GLOBAL_STRUCT
START_EXTERN_C

#  include "perlvars.h"

END_EXTERN_C
#endif

#include "reentr.inc"

#undef PERLVAR
#undef PERLVARA
#undef PERLVARI
#undef PERLVARIC

START_EXTERN_C

#ifdef DOINIT

EXT MGVTBL PL_vtbl_sv =		{MEMBER_TO_FPTR(Perl_magic_get),
				MEMBER_TO_FPTR(Perl_magic_set),
					MEMBER_TO_FPTR(Perl_magic_len),
						0,	0};
EXT MGVTBL PL_vtbl_env =	{0,	MEMBER_TO_FPTR(Perl_magic_set_all_env),
				0,	MEMBER_TO_FPTR(Perl_magic_clear_all_env),
							0};
EXT MGVTBL PL_vtbl_envelem =	{0,	MEMBER_TO_FPTR(Perl_magic_setenv),
					0,	MEMBER_TO_FPTR(Perl_magic_clearenv),
							0};
EXT MGVTBL PL_vtbl_sig =	{0,	0,		 0, 0, 0};
#ifdef PERL_MICRO
EXT MGVTBL PL_vtbl_sigelem =	{0,	0,		 0, 0, 0};
#else
EXT MGVTBL PL_vtbl_sigelem =	{MEMBER_TO_FPTR(Perl_magic_getsig),
					MEMBER_TO_FPTR(Perl_magic_setsig),
					0,	MEMBER_TO_FPTR(Perl_magic_clearsig),
							0};
#endif
EXT MGVTBL PL_vtbl_pack =	{0,	0,	
    				MEMBER_TO_FPTR(Perl_magic_sizepack),	
				MEMBER_TO_FPTR(Perl_magic_wipepack),
							0};
EXT MGVTBL PL_vtbl_packelem =	{MEMBER_TO_FPTR(Perl_magic_getpack),
					MEMBER_TO_FPTR(Perl_magic_setpack),
					0,	MEMBER_TO_FPTR(Perl_magic_clearpack),
							0};
EXT MGVTBL PL_vtbl_dbline =	{0,	MEMBER_TO_FPTR(Perl_magic_setdbline),
					0,	0,	0};
EXT MGVTBL PL_vtbl_isa =	{0,	MEMBER_TO_FPTR(Perl_magic_setisa),
					0,	MEMBER_TO_FPTR(Perl_magic_setisa),
							0};
EXT MGVTBL PL_vtbl_isaelem =	{0,	MEMBER_TO_FPTR(Perl_magic_setisa),
					0,	0,	0};
EXT MGVTBL PL_vtbl_arylen =	{MEMBER_TO_FPTR(Perl_magic_getarylen),
				MEMBER_TO_FPTR(Perl_magic_setarylen),
					0,	0,	0};
EXT MGVTBL PL_vtbl_glob =	{MEMBER_TO_FPTR(Perl_magic_getglob),
				MEMBER_TO_FPTR(Perl_magic_setglob),
					0,	0,	0};
EXT MGVTBL PL_vtbl_mglob =	{0,	MEMBER_TO_FPTR(Perl_magic_setmglob),
					0,	0,	0};
EXT MGVTBL PL_vtbl_nkeys =	{MEMBER_TO_FPTR(Perl_magic_getnkeys),
				MEMBER_TO_FPTR(Perl_magic_setnkeys),
					0,	0,	0};
EXT MGVTBL PL_vtbl_taint =	{MEMBER_TO_FPTR(Perl_magic_gettaint),
    					MEMBER_TO_FPTR(Perl_magic_settaint),
					0,	0,	0};
EXT MGVTBL PL_vtbl_substr =	{MEMBER_TO_FPTR(Perl_magic_getsubstr),
    					MEMBER_TO_FPTR(Perl_magic_setsubstr),
					0,	0,	0};
EXT MGVTBL PL_vtbl_vec =	{MEMBER_TO_FPTR(Perl_magic_getvec),
					MEMBER_TO_FPTR(Perl_magic_setvec),
					0,	0,	0};
EXT MGVTBL PL_vtbl_pos =	{MEMBER_TO_FPTR(Perl_magic_getpos),
				MEMBER_TO_FPTR(Perl_magic_setpos),
					0,	0,	0};
EXT MGVTBL PL_vtbl_bm =	{0,	MEMBER_TO_FPTR(Perl_magic_setbm),
					0,	0,	0};
EXT MGVTBL PL_vtbl_fm =	{0,	MEMBER_TO_FPTR(Perl_magic_setfm),
					0,	0,	0};
EXT MGVTBL PL_vtbl_uvar =	{MEMBER_TO_FPTR(Perl_magic_getuvar),
				MEMBER_TO_FPTR(Perl_magic_setuvar),
					0,	0,	0};
#ifdef USE_5005THREADS
EXT MGVTBL PL_vtbl_mutex =	{0,	0,	0,	0,	
					MEMBER_TO_FPTR(Perl_magic_mutexfree)};
#endif /* USE_5005THREADS */
EXT MGVTBL PL_vtbl_defelem = {MEMBER_TO_FPTR(Perl_magic_getdefelem),
    					MEMBER_TO_FPTR(Perl_magic_setdefelem),
					0,	0,	0};

EXT MGVTBL PL_vtbl_regexp = {0, MEMBER_TO_FPTR(Perl_magic_setregexp),0,0, MEMBER_TO_FPTR(Perl_magic_freeregexp)};
EXT MGVTBL PL_vtbl_regdata = {0, 0, MEMBER_TO_FPTR(Perl_magic_regdata_cnt), 0, 0};
EXT MGVTBL PL_vtbl_regdatum = {MEMBER_TO_FPTR(Perl_magic_regdatum_get),
			       MEMBER_TO_FPTR(Perl_magic_regdatum_set), 0, 0, 0};

#ifdef USE_LOCALE_COLLATE
EXT MGVTBL PL_vtbl_collxfrm = {0,
				MEMBER_TO_FPTR(Perl_magic_setcollxfrm),
					0,	0,	0};
#endif

EXT MGVTBL PL_vtbl_amagic =       {0,     MEMBER_TO_FPTR(Perl_magic_setamagic),
                                        0,      0,      MEMBER_TO_FPTR(Perl_magic_setamagic)};
EXT MGVTBL PL_vtbl_amagicelem =   {0,     MEMBER_TO_FPTR(Perl_magic_setamagic),
                                        0,      0,      MEMBER_TO_FPTR(Perl_magic_setamagic)};

EXT MGVTBL PL_vtbl_backref = 	  {0,	0,
					0,	0,	MEMBER_TO_FPTR(Perl_magic_killbackrefs)};

EXT MGVTBL PL_vtbl_ovrld   = 	  {0,	0,
					0,	0,	MEMBER_TO_FPTR(Perl_magic_freeovrld)};

EXT MGVTBL PL_vtbl_utf8 = {0,
				MEMBER_TO_FPTR(Perl_magic_setutf8),
					0,	0,	0};

#else /* !DOINIT */

EXT MGVTBL PL_vtbl_sv;
EXT MGVTBL PL_vtbl_env;
EXT MGVTBL PL_vtbl_envelem;
EXT MGVTBL PL_vtbl_sig;
EXT MGVTBL PL_vtbl_sigelem;
EXT MGVTBL PL_vtbl_pack;
EXT MGVTBL PL_vtbl_packelem;
EXT MGVTBL PL_vtbl_dbline;
EXT MGVTBL PL_vtbl_isa;
EXT MGVTBL PL_vtbl_isaelem;
EXT MGVTBL PL_vtbl_arylen;
EXT MGVTBL PL_vtbl_glob;
EXT MGVTBL PL_vtbl_mglob;
EXT MGVTBL PL_vtbl_nkeys;
EXT MGVTBL PL_vtbl_taint;
EXT MGVTBL PL_vtbl_substr;
EXT MGVTBL PL_vtbl_vec;
EXT MGVTBL PL_vtbl_pos;
EXT MGVTBL PL_vtbl_bm;
EXT MGVTBL PL_vtbl_fm;
EXT MGVTBL PL_vtbl_uvar;
EXT MGVTBL PL_vtbl_ovrld;

#ifdef USE_5005THREADS
EXT MGVTBL PL_vtbl_mutex;
#endif /* USE_5005THREADS */

EXT MGVTBL PL_vtbl_defelem;
EXT MGVTBL PL_vtbl_regexp;
EXT MGVTBL PL_vtbl_regdata;
EXT MGVTBL PL_vtbl_regdatum;

#ifdef USE_LOCALE_COLLATE
EXT MGVTBL PL_vtbl_collxfrm;
#endif

EXT MGVTBL PL_vtbl_amagic;
EXT MGVTBL PL_vtbl_amagicelem;

EXT MGVTBL PL_vtbl_backref;
EXT MGVTBL PL_vtbl_utf8;

#endif /* !DOINIT */

enum {
  fallback_amg,        abs_amg,
  bool__amg,   nomethod_amg,
  string_amg,  numer_amg,
  add_amg,     add_ass_amg,
  subtr_amg,   subtr_ass_amg,
  mult_amg,    mult_ass_amg,
  div_amg,     div_ass_amg,
  modulo_amg,  modulo_ass_amg,
  pow_amg,     pow_ass_amg,
  lshift_amg,  lshift_ass_amg,
  rshift_amg,  rshift_ass_amg,
  band_amg,    band_ass_amg,
  bor_amg,     bor_ass_amg,
  bxor_amg,    bxor_ass_amg,
  lt_amg,      le_amg,
  gt_amg,      ge_amg,
  eq_amg,      ne_amg,
  ncmp_amg,    scmp_amg,
  slt_amg,     sle_amg,
  sgt_amg,     sge_amg,
  seq_amg,     sne_amg,
  not_amg,     compl_amg,
  inc_amg,     dec_amg,
  atan2_amg,   cos_amg,
  sin_amg,     exp_amg,
  log_amg,     sqrt_amg,
  repeat_amg,   repeat_ass_amg,
  concat_amg,  concat_ass_amg,
  copy_amg,    neg_amg,
  to_sv_amg,   to_av_amg,
  to_hv_amg,   to_gv_amg,
  to_cv_amg,   iter_amg,
  int_amg,	DESTROY_amg,
  max_amg_code
  /* Do not leave a trailing comma here.  C9X allows it, C89 doesn't. */
};

#define NofAMmeth max_amg_code
#define AMG_id2name(id) (PL_AMG_names[id]+1)

#ifdef DOINIT
EXTCONST char * PL_AMG_names[NofAMmeth] = {
  /* Names kept in the symbol table.  fallback => "()", the rest has
     "(" prepended.  The only other place in perl which knows about
     this convention is AMG_id2name (used for debugging output and
     'nomethod' only), the only other place which has it hardwired is
     overload.pm.  */
  "()",		"(abs",			/* "fallback" should be the first. */
  "(bool",	"(nomethod",
  "(\"\"",	"(0+",
  "(+",		"(+=",
  "(-",		"(-=",
  "(*",		"(*=",
  "(/",		"(/=",
  "(%",		"(%=",
  "(**",	"(**=",
  "(<<",	"(<<=",
  "(>>",	"(>>=",
  "(&",		"(&=",
  "(|",		"(|=",
  "(^",		"(^=",
  "(<",		"(<=",
  "(>",		"(>=",
  "(==",	"(!=",
  "(<=>",	"(cmp",
  "(lt",	"(le",
  "(gt",	"(ge",
  "(eq",	"(ne",
  "(!",		"(~",
  "(++",	"(--",
  "(atan2",	"(cos",
  "(sin",	"(exp",
  "(log",	"(sqrt",
  "(x",		"(x=",
  "(.",		"(.=",
  "(=",		"(neg",
  "(${}",	"(@{}",
  "(%{}",	"(*{}",
  "(&{}",	"(<>",
  "(int",	"DESTROY",
};
#else
EXTCONST char * PL_AMG_names[NofAMmeth];
#endif /* def INITAMAGIC */

END_EXTERN_C

struct am_table {
  U32 was_ok_sub;
  long was_ok_am;
  U32 flags;
  CV* table[NofAMmeth];
  long fallback;
};
struct am_table_short {
  U32 was_ok_sub;
  long was_ok_am;
  U32 flags;
};
typedef struct am_table AMT;
typedef struct am_table_short AMTS;

#define AMGfallNEVER	1
#define AMGfallNO	2
#define AMGfallYES	3

#define AMTf_AMAGIC		1
#define AMTf_OVERLOADED		2
#define AMT_AMAGIC(amt)		((amt)->flags & AMTf_AMAGIC)
#define AMT_AMAGIC_on(amt)	((amt)->flags |= AMTf_AMAGIC)
#define AMT_AMAGIC_off(amt)	((amt)->flags &= ~AMTf_AMAGIC)
#define AMT_OVERLOADED(amt)	((amt)->flags & AMTf_OVERLOADED)
#define AMT_OVERLOADED_on(amt)	((amt)->flags |= AMTf_OVERLOADED)
#define AMT_OVERLOADED_off(amt)	((amt)->flags &= ~AMTf_OVERLOADED)

#define StashHANDLER(stash,meth)	gv_handler((stash),CAT2(meth,_amg))

/*
 * some compilers like to redefine cos et alia as faster
 * (and less accurate?) versions called F_cos et cetera (Quidquid
 * latine dictum sit, altum viditur.)  This trick collides with
 * the Perl overloading (amg).  The following #defines fool both.
 */

#ifdef _FASTMATH
#   ifdef atan2
#       define F_atan2_amg  atan2_amg
#   endif
#   ifdef cos
#       define F_cos_amg    cos_amg
#   endif
#   ifdef exp
#       define F_exp_amg    exp_amg
#   endif
#   ifdef log
#       define F_log_amg    log_amg
#   endif
#   ifdef pow
#       define F_pow_amg    pow_amg
#   endif
#   ifdef sin
#       define F_sin_amg    sin_amg
#   endif
#   ifdef sqrt
#       define F_sqrt_amg   sqrt_amg
#   endif
#endif /* _FASTMATH */

#define PERLDB_ALL		(PERLDBf_SUB	| PERLDBf_LINE	|	\
				 PERLDBf_NOOPT	| PERLDBf_INTER	|	\
				 PERLDBf_SUBLINE| PERLDBf_SINGLE|	\
				 PERLDBf_NAMEEVAL| PERLDBf_NAMEANON)
					/* No _NONAME, _GOTO */
#define PERLDBf_SUB		0x01	/* Debug sub enter/exit */
#define PERLDBf_LINE		0x02	/* Keep line # */
#define PERLDBf_NOOPT		0x04	/* Switch off optimizations */
#define PERLDBf_INTER		0x08	/* Preserve more data for
					   later inspections  */
#define PERLDBf_SUBLINE		0x10	/* Keep subr source lines */
#define PERLDBf_SINGLE		0x20	/* Start with single-step on */
#define PERLDBf_NONAME		0x40	/* For _SUB: no name of the subr */
#define PERLDBf_GOTO		0x80	/* Report goto: call DB::goto */
#define PERLDBf_NAMEEVAL	0x100	/* Informative names for evals */
#define PERLDBf_NAMEANON	0x200	/* Informative names for anon subs */

#define PERLDB_SUB	(PL_perldb && (PL_perldb & PERLDBf_SUB))
#define PERLDB_LINE	(PL_perldb && (PL_perldb & PERLDBf_LINE))
#define PERLDB_NOOPT	(PL_perldb && (PL_perldb & PERLDBf_NOOPT))
#define PERLDB_INTER	(PL_perldb && (PL_perldb & PERLDBf_INTER))
#define PERLDB_SUBLINE	(PL_perldb && (PL_perldb & PERLDBf_SUBLINE))
#define PERLDB_SINGLE	(PL_perldb && (PL_perldb & PERLDBf_SINGLE))
#define PERLDB_SUB_NN	(PL_perldb && (PL_perldb & (PERLDBf_NONAME)))
#define PERLDB_GOTO	(PL_perldb && (PL_perldb & PERLDBf_GOTO))
#define PERLDB_NAMEEVAL	(PL_perldb && (PL_perldb & PERLDBf_NAMEEVAL))
#define PERLDB_NAMEANON	(PL_perldb && (PL_perldb & PERLDBf_NAMEANON))


#ifdef USE_LOCALE_NUMERIC

#define SET_NUMERIC_STANDARD() \
	set_numeric_standard();

#define SET_NUMERIC_LOCAL() \
	set_numeric_local();

#define IN_LOCALE_RUNTIME	(PL_curcop->op_private & HINT_LOCALE)
#define IN_LOCALE_COMPILETIME	(PL_hints & HINT_LOCALE)

#define IN_LOCALE \
	(IN_PERL_COMPILETIME ? IN_LOCALE_COMPILETIME : IN_LOCALE_RUNTIME)

#define STORE_NUMERIC_LOCAL_SET_STANDARD() \
	bool was_local = PL_numeric_local && IN_LOCALE; \
	if (was_local) SET_NUMERIC_STANDARD();

#define STORE_NUMERIC_STANDARD_SET_LOCAL() \
	bool was_standard = PL_numeric_standard && IN_LOCALE; \
	if (was_standard) SET_NUMERIC_LOCAL();

#define RESTORE_NUMERIC_LOCAL() \
	if (was_local) SET_NUMERIC_LOCAL();

#define RESTORE_NUMERIC_STANDARD() \
	if (was_standard) SET_NUMERIC_STANDARD();

#define Atof				my_atof

#else /* !USE_LOCALE_NUMERIC */

#define SET_NUMERIC_STANDARD()  	/**/
#define SET_NUMERIC_LOCAL()     	/**/
#define IS_NUMERIC_RADIX(a, b)		(0)
#define STORE_NUMERIC_LOCAL_SET_STANDARD()	/**/
#define STORE_NUMERIC_STANDARD_SET_LOCAL()	/**/
#define RESTORE_NUMERIC_LOCAL()		/**/
#define RESTORE_NUMERIC_STANDARD()	/**/
#define Atof				my_atof
#define IN_LOCALE_RUNTIME		0

#endif /* !USE_LOCALE_NUMERIC */

#if !defined(Strtol) && defined(USE_64_BIT_INT) && defined(IV_IS_QUAD) && QUADKIND == QUAD_IS_LONG_LONG
#    ifdef __hpux
#        define strtoll __strtoll	/* secret handshake */
#    endif
#    ifdef WIN64
#        define strtoll _strtoi64	/* secret handshake */
#    endif
#   if !defined(Strtol) && defined(HAS_STRTOLL)
#       define Strtol	strtoll
#   endif
#    if !defined(Strtol) && defined(HAS_STRTOQ)
#       define Strtol	strtoq
#    endif
/* is there atoq() anywhere? */
#endif
#if !defined(Strtol) && defined(HAS_STRTOL)
#   define Strtol	strtol
#endif
#ifndef Atol
/* It would be more fashionable to use Strtol() to define atol()
 * (as is done for Atoul(), see below) but for backward compatibility
 * we just assume atol(). */
#   if defined(USE_64_BIT_INT) && defined(IV_IS_QUAD) && QUADKIND == QUAD_IS_LONG_LONG && defined(HAS_ATOLL)
#    ifdef WIN64
#       define atoll    _atoi64		/* secret handshake */
#    endif
#       define Atol	atoll
#   else
#       define Atol	atol
#   endif
#endif

#if !defined(Strtoul) && defined(USE_64_BIT_INT) && defined(UV_IS_QUAD) && QUADKIND == QUAD_IS_LONG_LONG
#    ifdef __hpux
#        define strtoull __strtoull	/* secret handshake */
#    endif
#    ifdef WIN64
#        define strtoull _strtoui64	/* secret handshake */
#    endif
#    if !defined(Strtoul) && defined(HAS_STRTOULL)
#       define Strtoul	strtoull
#    endif
#    if !defined(Strtoul) && defined(HAS_STRTOUQ)
#       define Strtoul	strtouq
#    endif
/* is there atouq() anywhere? */
#endif
#if !defined(Strtoul) && defined(HAS_STRTOUL)
#   define Strtoul	strtoul
#endif
#if !defined(Strtoul) && defined(HAS_STRTOL) /* Last resort. */
#   define Strtoul(s, e, b)	strchr((s), '-') ? ULONG_MAX : (unsigned long)strtol((s), (e), (b))
#endif
#ifndef Atoul
#   define Atoul(s)	Strtoul(s, (char **)NULL, 10)
#endif


/* if these never got defined, they need defaults */
#ifndef PERL_SET_CONTEXT
#  define PERL_SET_CONTEXT(i)		PERL_SET_INTERP(i)
#endif

#ifndef PERL_GET_CONTEXT
#  define PERL_GET_CONTEXT		PERL_GET_INTERP
#endif

#ifndef PERL_GET_THX
#  define PERL_GET_THX			((void*)NULL)
#endif

#ifndef PERL_SET_THX
#  define PERL_SET_THX(t)		NOOP
#endif

#ifndef PERL_SCRIPT_MODE
#define PERL_SCRIPT_MODE "r"
#endif

/*
 * Some operating systems are stingy with stack allocation,
 * so perl may have to guard against stack overflow.
 */
#ifndef PERL_STACK_OVERFLOW_CHECK
#define PERL_STACK_OVERFLOW_CHECK()  NOOP
#endif

/*
 * Some nonpreemptive operating systems find it convenient to
 * check for asynchronous conditions after each op execution.
 * Keep this check simple, or it may slow down execution
 * massively.
 */

#ifndef PERL_MICRO
#	ifndef PERL_ASYNC_CHECK
#		define PERL_ASYNC_CHECK() if (PL_sig_pending) despatch_signals()
#	endif
#endif

#ifndef PERL_ASYNC_CHECK
#   define PERL_ASYNC_CHECK()  NOOP
#endif

/*
 * On some operating systems, a memory allocation may succeed,
 * but put the process too close to the system's comfort limit.
 * In this case, PERL_ALLOC_CHECK frees the pointer and sets
 * it to NULL.
 */
#ifndef PERL_ALLOC_CHECK
#define PERL_ALLOC_CHECK(p)  NOOP
#endif

#ifdef HAS_SEM
#   include <sys/ipc.h>
#   include <sys/sem.h>
#   ifndef HAS_UNION_SEMUN	/* Provide the union semun. */
    union semun {
	int		val;
	struct semid_ds	*buf;
	unsigned short	*array;
    };
#   endif
#   ifdef USE_SEMCTL_SEMUN
#	ifdef IRIX32_SEMUN_BROKEN_BY_GCC
            union gccbug_semun {
		int             val;
		struct semid_ds *buf;
		unsigned short  *array;
		char            __dummy[5];
	    };
#           define semun gccbug_semun
#	endif
#       define Semctl(id, num, cmd, semun) semctl(id, num, cmd, semun)
#   else
#       ifdef USE_SEMCTL_SEMID_DS
#           ifdef EXTRA_F_IN_SEMUN_BUF
#               define Semctl(id, num, cmd, semun) semctl(id, num, cmd, semun.buff)
#           else
#               define Semctl(id, num, cmd, semun) semctl(id, num, cmd, semun.buf)
#           endif
#       endif
#   endif
#endif

/*
 * Boilerplate macros for initializing and accessing interpreter-local
 * data from C.  All statics in extensions should be reworked to use
 * this, if you want to make the extension thread-safe.  See ext/re/re.xs
 * for an example of the use of these macros, and perlxs.pod for more.
 *
 * Code that uses these macros is responsible for the following:
 * 1. #define MY_CXT_KEY to a unique string, e.g.
 *    "DynaLoader::_guts" XS_VERSION
 * 2. Declare a typedef named my_cxt_t that is a structure that contains
 *    all the data that needs to be interpreter-local.
 * 3. Use the START_MY_CXT macro after the declaration of my_cxt_t.
 * 4. Use the MY_CXT_INIT macro such that it is called exactly once
 *    (typically put in the BOOT: section).
 * 5. Use the members of the my_cxt_t structure everywhere as
 *    MY_CXT.member.
 * 6. Use the dMY_CXT macro (a declaration) in all the functions that
 *    access MY_CXT.
 */

#if defined(PERL_IMPLICIT_CONTEXT)

/* This must appear in all extensions that define a my_cxt_t structure,
 * right after the definition (i.e. at file scope).  The non-threads
 * case below uses it to declare the data as static. */
#define START_MY_CXT

/* Fetches the SV that keeps the per-interpreter data. */
#define dMY_CXT_SV \
	SV *my_cxt_sv = *hv_fetch(PL_modglobal, MY_CXT_KEY,		\
				  sizeof(MY_CXT_KEY)-1, TRUE)

/* This declaration should be used within all functions that use the
 * interpreter-local data. */
#define dMY_CXT	\
	dMY_CXT_SV;							\
	my_cxt_t *my_cxtp = INT2PTR(my_cxt_t*, SvUV(my_cxt_sv))

/* Creates and zeroes the per-interpreter data.
 * (We allocate my_cxtp in a Perl SV so that it will be released when
 * the interpreter goes away.) */
#define MY_CXT_INIT \
	dMY_CXT_SV;							\
	/* newSV() allocates one more than needed */			\
	my_cxt_t *my_cxtp = (my_cxt_t*)SvPVX(newSV(sizeof(my_cxt_t)-1));\
	Zero(my_cxtp, 1, my_cxt_t);					\
	sv_setuv(my_cxt_sv, PTR2UV(my_cxtp))

/* Clones the per-interpreter data. */
#define MY_CXT_CLONE \
	dMY_CXT_SV;							\
	my_cxt_t *my_cxtp = (my_cxt_t*)SvPVX(newSV(sizeof(my_cxt_t)-1));\
	Copy(INT2PTR(my_cxt_t*, SvUV(my_cxt_sv)), my_cxtp, 1, my_cxt_t);\
	sv_setuv(my_cxt_sv, PTR2UV(my_cxtp))

/* This macro must be used to access members of the my_cxt_t structure.
 * e.g. MYCXT.some_data */
#define MY_CXT		(*my_cxtp)

/* Judicious use of these macros can reduce the number of times dMY_CXT
 * is used.  Use is similar to pTHX, aTHX etc. */
#define pMY_CXT		my_cxt_t *my_cxtp
#define pMY_CXT_	pMY_CXT,
#define _pMY_CXT	,pMY_CXT
#define aMY_CXT		my_cxtp
#define aMY_CXT_	aMY_CXT,
#define _aMY_CXT	,aMY_CXT

#else /* USE_ITHREADS */

#define START_MY_CXT	static my_cxt_t my_cxt;
#define dMY_CXT_SV	dNOOP
#define dMY_CXT		dNOOP
#define MY_CXT_INIT	NOOP
#define MY_CXT_CLONE	NOOP
#define MY_CXT		my_cxt

#define pMY_CXT		void
#define pMY_CXT_
#define _pMY_CXT
#define aMY_CXT
#define aMY_CXT_
#define _aMY_CXT

#endif /* !defined(USE_ITHREADS) */

#ifdef I_FCNTL
#  include <fcntl.h>
#endif

#ifdef __Lynx__
#  include <fcntl.h>
#endif

#ifdef I_SYS_FILE
#  include <sys/file.h>
#endif

#if defined(HAS_FLOCK) && !defined(HAS_FLOCK_PROTO)
int flock(int fd, int op);
#endif

#ifndef O_RDONLY
/* Assume UNIX defaults */
#    define O_RDONLY	0000
#    define O_WRONLY	0001
#    define O_RDWR	0002
#    define O_CREAT	0100
#endif

#ifndef O_BINARY
#  define O_BINARY 0
#endif

#ifndef O_TEXT
#  define O_TEXT 0
#endif

#if O_TEXT != O_BINARY
    /* If you have different O_TEXT and O_BINARY and you are a CLRF shop,
     * that is, you are somehow DOSish. */
#   if defined(__BEOS__) || defined(__VOS__) || defined(__CYGWIN__) || defined(__MSYS__)
    /* BeOS has O_TEXT != O_BINARY but O_TEXT and O_BINARY have no effect;
     * BeOS is always UNIXoid (LF), not DOSish (CRLF). */
    /* VOS has O_TEXT != O_BINARY, and they have effect,
     * but VOS always uses LF, never CRLF. */
    /* If you have O_TEXT different from your O_BINARY but you still are
     * not a CRLF shop. */
#       undef PERLIO_USING_CRLF
#   else
    /* If you really are DOSish. */
#      define PERLIO_USING_CRLF 1
#   endif
#endif

#ifdef IAMSUID

#ifdef I_SYS_STATVFS
#   if defined(PERL_SCO) && !defined(_SVID3)
#       define _SVID3
#   endif
#   include <sys/statvfs.h>     /* for f?statvfs() */
#endif
#ifdef I_SYS_MOUNT
#   include <sys/mount.h>       /* for *BSD f?statfs() */
#endif
#ifdef I_MNTENT
#   include <mntent.h>          /* for getmntent() */
#endif
#ifdef I_SYS_STATFS
#   include <sys/statfs.h>      /* for some statfs() */
#endif
#ifdef I_SYS_VFS
#  ifdef __sgi
#    define sv IRIX_sv		/* kludge: IRIX has an sv of its own */
#  endif
#    include <sys/vfs.h>	/* for some statfs() */
#  ifdef __sgi
#    undef IRIX_sv
#  endif
#endif
#ifdef I_USTAT
#   include <ustat.h>           /* for ustat() */
#endif

#if !defined(PERL_MOUNT_NOSUID) && defined(MOUNT_NOSUID)
#    define PERL_MOUNT_NOSUID MOUNT_NOSUID
#endif
#if !defined(PERL_MOUNT_NOSUID) && defined(MNT_NOSUID)
#    define PERL_MOUNT_NOSUID MNT_NOSUID
#endif
#if !defined(PERL_MOUNT_NOSUID) && defined(MS_NOSUID)
#   define PERL_MOUNT_NOSUID MS_NOSUID
#endif
#if !defined(PERL_MOUNT_NOSUID) && defined(M_NOSUID)
#   define PERL_MOUNT_NOSUID M_NOSUID
#endif

#if !defined(PERL_MOUNT_NOEXEC) && defined(MOUNT_NOEXEC)
#    define PERL_MOUNT_NOEXEC MOUNT_NOEXEC
#endif
#if !defined(PERL_MOUNT_NOEXEC) && defined(MNT_NOEXEC)
#    define PERL_MOUNT_NOEXEC MNT_NOEXEC
#endif
#if !defined(PERL_MOUNT_NOEXEC) && defined(MS_NOEXEC)
#   define PERL_MOUNT_NOEXEC MS_NOEXEC
#endif
#if !defined(PERL_MOUNT_NOEXEC) && defined(M_NOEXEC)
#   define PERL_MOUNT_NOEXEC M_NOEXEC
#endif

#endif /* IAMSUID */

#ifdef I_LIBUTIL
#   include <libutil.h>		/* setproctitle() in some FreeBSDs */
#endif

#ifndef EXEC_ARGV_CAST
#define EXEC_ARGV_CAST(x) x
#endif

#define IS_NUMBER_IN_UV		      0x01 /* number within UV range (maybe not
					      int).  value returned in pointed-
					      to UV */
#define IS_NUMBER_GREATER_THAN_UV_MAX 0x02 /* pointed to UV undefined */
#define IS_NUMBER_NOT_INT	      0x04 /* saw . or E notation */
#define IS_NUMBER_NEG		      0x08 /* leading minus sign */
#define IS_NUMBER_INFINITY	      0x10 /* this is big */
#define IS_NUMBER_NAN                 0x20 /* this is not */

#define GROK_NUMERIC_RADIX(sp, send) grok_numeric_radix(sp, send)

/* Input flags: */
#define PERL_SCAN_ALLOW_UNDERSCORES   0x01 /* grok_??? accept _ in numbers */
#define PERL_SCAN_DISALLOW_PREFIX     0x02 /* grok_??? reject 0x in hex etc */
#define PERL_SCAN_SILENT_ILLDIGIT     0x04 /* grok_??? not warn about illegal digits */
/* Output flags: */
#define PERL_SCAN_GREATER_THAN_UV_MAX 0x02 /* should this merge with above? */

/* to let user control profiling */
#ifdef PERL_GPROF_CONTROL
extern void moncontrol(int);
#define PERL_GPROF_MONCONTROL(x) moncontrol(x)
#else
#define PERL_GPROF_MONCONTROL(x)
#endif

#ifdef UNDER_CE
#include "wince.h"
#endif

/* ISO 6429 NEL - C1 control NExt Line */
/* See http://www.unicode.org/unicode/reports/tr13/ */
#ifdef EBCDIC	/* In EBCDIC NEL is just an alias for LF */
#   if '^' == 95	/* CP 1047: MVS OpenEdition - OS/390 - z/OS */
#       define NEXT_LINE_CHAR	0x15
#   else		/* CDRA */
#       define NEXT_LINE_CHAR	0x25
#   endif
#else
#   define NEXT_LINE_CHAR	0x85
#endif

/* The UTF-8 bytes of the Unicode LS and PS, U+2028 and U+2029 */
#define UNICODE_LINE_SEPA_0	0xE2
#define UNICODE_LINE_SEPA_1	0x80
#define UNICODE_LINE_SEPA_2	0xA8
#define UNICODE_PARA_SEPA_0	0xE2
#define UNICODE_PARA_SEPA_1	0x80
#define UNICODE_PARA_SEPA_2	0xA9

#ifndef PIPESOCK_MODE
#  define PIPESOCK_MODE
#endif

#ifndef SOCKET_OPEN_MODE
#  define SOCKET_OPEN_MODE	PIPESOCK_MODE
#endif

#ifndef PIPE_OPEN_MODE
#  define PIPE_OPEN_MODE	PIPESOCK_MODE
#endif

#define PERL_MAGIC_UTF8_CACHESIZE	2

#define PERL_UNICODE_STDIN_FLAG			0x0001
#define PERL_UNICODE_STDOUT_FLAG		0x0002
#define PERL_UNICODE_STDERR_FLAG		0x0004
#define PERL_UNICODE_IN_FLAG			0x0008
#define PERL_UNICODE_OUT_FLAG			0x0010
#define PERL_UNICODE_ARGV_FLAG			0x0020
#define PERL_UNICODE_LOCALE_FLAG		0x0040
#define PERL_UNICODE_WIDESYSCALLS_FLAG		0x0080 /* for Sarathy */

#define PERL_UNICODE_STD_FLAG		\
	(PERL_UNICODE_STDIN_FLAG	| \
	 PERL_UNICODE_STDOUT_FLAG	| \
	 PERL_UNICODE_STDERR_FLAG)

#define PERL_UNICODE_INOUT_FLAG		\
	(PERL_UNICODE_IN_FLAG	| \
	 PERL_UNICODE_OUT_FLAG)

#define PERL_UNICODE_DEFAULT_FLAGS	\
	(PERL_UNICODE_STD_FLAG		| \
	 PERL_UNICODE_INOUT_FLAG	| \
	 PERL_UNICODE_LOCALE_FLAG)

#define PERL_UNICODE_ALL_FLAGS			0x00ff

#define PERL_UNICODE_STDIN			'I'
#define PERL_UNICODE_STDOUT			'O'
#define PERL_UNICODE_STDERR			'E'
#define PERL_UNICODE_STD			'S'
#define PERL_UNICODE_IN				'i'
#define PERL_UNICODE_OUT			'o'
#define PERL_UNICODE_INOUT			'D'
#define PERL_UNICODE_ARGV			'A'
#define PERL_UNICODE_LOCALE			'L'
#define PERL_UNICODE_WIDESYSCALLS		'W'

#define PERL_SIGNALS_UNSAFE_FLAG	0x0001

/* From sigaction(2) (FreeBSD man page):
 * | Signal routines normally execute with the signal that
 * | caused their invocation blocked, but other signals may
 * | yet occur.
 * Emulation of this behavior (from within Perl) is enabled
 * by defining PERL_BLOCK_SIGNALS.
 */
#define PERL_BLOCK_SIGNALS

#if defined(HAS_SIGPROCMASK) && defined(PERL_BLOCK_SIGNALS)
#   define PERL_BLOCKSIG_ADD(set,sig) \
	sigset_t set; sigemptyset(&(set)); sigaddset(&(set), sig)
#   define PERL_BLOCKSIG_BLOCK(set) \
	sigprocmask(SIG_BLOCK, &(set), NULL)
#   define PERL_BLOCKSIG_UNBLOCK(set) \
	sigprocmask(SIG_UNBLOCK, &(set), NULL)
#endif /* HAS_SIGPROCMASK && PERL_BLOCK_SIGNALS */

/* How about the old style of sigblock()? */

#ifndef PERL_BLOCKSIG_ADD
#   define PERL_BLOCKSIG_ADD(set, sig)	NOOP
#endif
#ifndef PERL_BLOCKSIG_BLOCK
#   define PERL_BLOCKSIG_BLOCK(set)	NOOP
#endif
#ifndef PERL_BLOCKSIG_UNBLOCK
#   define PERL_BLOCKSIG_UNBLOCK(set)	NOOP
#endif

/* Use instead of abs() since abs() forces its argument to be an int,
 * but also beware since this evaluates its argument twice, so no x++. */
#define PERL_ABS(x) ((x) < 0 ? -(x) : (x))

#if defined(__DECC) && defined(__osf__)
#pragma message disable (mainparm) /* Perl uses the envp in main(). */
#endif

/* and finally... */
#define PERL_PATCHLEVEL_H_IMPLICIT
#include "patchlevel.h"
#undef PERL_PATCHLEVEL_H_IMPLICIT

/* Mention

   NV_PRESERVES_UV

   HAS_MKSTEMP
   HAS_MKSTEMPS
   HAS_MKDTEMP

   HAS_GETCWD

   HAS_MMAP
   HAS_MPROTECT
   HAS_MSYNC
   HAS_MADVISE
   HAS_MUNMAP
   I_SYSMMAN
   Mmap_t

   NVef
   NVff
   NVgf

   HAS_UALARM
   HAS_USLEEP

   HAS_SETITIMER
   HAS_GETITIMER

   HAS_SENDMSG
   HAS_RECVMSG
   HAS_READV
   HAS_WRITEV
   I_SYSUIO
   HAS_STRUCT_MSGHDR
   HAS_STRUCT_CMSGHDR

   HAS_NL_LANGINFO

   HAS_DIRFD

   so that Configure picks them up. */

/* Source code compatibility cruft:
   PERL_XS_APIVERSION is not used, and has been superseded by inc_version_list
   It and PERL_PM_APIVERSION are retained for source compatibility in the
   5.8.x maintenance branch.
 */

#define PERL_XS_APIVERSION "5.8.3"
#define PERL_PM_APIVERSION "5.005"

#endif /* Include guard */

