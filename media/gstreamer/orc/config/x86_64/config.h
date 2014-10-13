/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define if building universal (internal helper macro) */
/* #undef AC_APPLE_UNIVERSAL_BUILD */

/* Enable Altivec backend */
#define ENABLE_BACKEND_ALTIVEC 1

/* Enable c64x backend */
#define ENABLE_BACKEND_C64X 1

/* Enable MIPS backend */
#define ENABLE_BACKEND_MIPS 1

/* Enable MMX backend */
#define ENABLE_BACKEND_MMX 1

/* Enable NEON backend */
#define ENABLE_BACKEND_NEON 1

/* Enable SSE backend */
#define ENABLE_BACKEND_SSE 1

/* Defined if host is amd64 */
#define HAVE_AMD64 1

/* Defined if we have __android_log_print() */
/* #undef HAVE_ANDROID_LIBLOG */

/* Defined if host is arm */
/* #undef HAVE_ARM */

/* Defined if we have clock_gettime() */
/* #undef HAVE_CLOCK_GETTIME */

/* Use malloc to allocate code for execution */
/* #undef HAVE_CODEMEM_MALLOC */

/* Use mmap to allocate code for execution */
#define HAVE_CODEMEM_MMAP 1

/* Use VirtualAlloc to allocate code for execution */
/* #undef HAVE_CODEMEM_VIRTUALALLOC */

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define to 1 if you have the `getpagesize' function. */
#define HAVE_GETPAGESIZE 1

/* Define to 1 if you have the `gettimeofday' function. */
#define HAVE_GETTIMEOFDAY 1

/* Defined if host is i386 */
/* #undef HAVE_I386 */

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Defined if host is mipsel */
/* #undef HAVE_MIPSEL */

/* Define to 1 if you have a working `mmap' system call. */
#define HAVE_MMAP 1

/* Defined if we have a monotonic clock */
/* #undef HAVE_MONOTONIC_CLOCK */

/* Defined if host OS is linux */
/* #undef HAVE_OS_LINUX */

/* Defined if host OS is MS Windows */
/* #undef HAVE_OS_WIN32 */

/* Define to 1 if you have the `posix_memalign' function. */
#define HAVE_POSIX_MEMALIGN 1

/* Defined if host is powerpc */
/* #undef HAVE_POWERPC */

/* Define to 1 if you have the `sigaction' function. */
#define HAVE_SIGACTION 1

/* Define to 1 if you have the `sigsetjmp' function. */
#define HAVE_SIGSETJMP 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/param.h> header file. */
#define HAVE_SYS_PARAM_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Use pthread thread code */
#define HAVE_THREAD_PTHREAD 1

/* Use Windows thread code */
/* #undef HAVE_THREAD_WIN32 */

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the <valgrind/valgrind.h> header file. */
/* #undef HAVE_VALGRIND_VALGRIND_H */

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#define LT_OBJDIR ".libs/"

/* Defined for compiling internal code */
#define ORC_EXPORTS 1

/* Name of package */
#define PACKAGE "orc"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "http://bugzilla.gnome.org/enter_bug.cgi?product=orc"

/* Define to the full name of this package. */
#define PACKAGE_NAME "orc"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "orc 0.4.22"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "orc"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.4.22"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "0.4.22"

/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
   significant byte first (like Motorola and SPARC, unlike Intel). */
#if defined AC_APPLE_UNIVERSAL_BUILD
# if defined __BIG_ENDIAN__
#  define WORDS_BIGENDIAN 1
# endif
#else
# ifndef WORDS_BIGENDIAN
/* #  undef WORDS_BIGENDIAN */
# endif
#endif
