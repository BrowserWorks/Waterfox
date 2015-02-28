# tclConfig.sh --
# 
# This shell script (for sh) is generated automatically by Tcl's
# configure script.  It will create shell variables for most of
# the configuration options discovered by the configure script.
# This script is intended to be included by the configure scripts
# for Tcl extensions so that they don't have to figure this all
# out for themselves.
#
# The information in this file is specific to a single platform.

TCL_DLL_FILE="tcl85.dll"

# Tcl's version number.
TCL_VERSION='8.5'
TCL_MAJOR_VERSION='8'
TCL_MINOR_VERSION='5'
TCL_PATCH_LEVEL='8.5.15'

# C compiler to use for compilation.
TCL_CC='cl'

# -D flags for use with the C compiler.
TCL_DEFS='-nologo -c -W3 -W3 -D _CRT_SECURE_NO_DEPRECATE -D _CRT_NONSTDC_NO_DEPRECATE -Fp.\Release_VC9\tcl_Dynamic\ -O2  -Ot -Oi -fp:strict -Gs -GS -GL -MD -I"..\win" -I"..\generic" -I"..\libtommath" -DTCL_PIPE_DLL=\"tclpip85.dll\" -DTCL_TOMMATH -DMP_PREC=4 -Dinline=__inline -DTCL_CFGVAL_ENCODING=\"cp1252\" -DSTDC_HEADERS -DNDEBUG -DTCL_CFG_OPTIMIZED'

# If TCL was built with debugging symbols, generated libraries contain
# this string at the end of the library name (before the extension).
TCL_DBGX=

# Default flags used in an optimized and debuggable build, respectively.
TCL_CFLAGS_DEBUG='-nologo -c -W3 -YX -Fp.\Release_VC9\tcl_Dynamic\ -MDd'
TCL_CFLAGS_OPTIMIZE='-nologo -c -W3 -YX -Fp.\Release_VC9\tcl_Dynamic\ -MD'

# Default linker flags used in an optimized and debuggable build, respectively.
TCL_LDFLAGS_DEBUG='-nologo -machine:IX86 -debug -debugtype:cv'
TCL_LDFLAGS_OPTIMIZE='-nologo -machine:IX86 -release -opt:ref -opt:icf,3'

# Flag, 1: we built a shared lib, 0 we didn't
TCL_SHARED_BUILD=1

# The name of the Tcl library (may be either a .a file or a shared library):
TCL_LIB_FILE='tcl85.lib'

# Flag to indicate whether shared libraries need export files.
TCL_NEEDS_EXP_FILE=

# String that can be evaluated to generate the part of the export file
# name that comes after the "libxxx" (includes version number, if any,
# extension, and anything else needed).  May depend on the variables
# VERSION.  On most UNIX systems this is ${VERSION}.exp.
TCL_EXPORT_FILE_SUFFIX='85.lib'

# Additional libraries to use when linking Tcl.
TCL_LIBS='kernel32.lib user32.lib ws2_32.lib'

# Top-level directory in which Tcl's platform-independent files are
# installed.
TCL_PREFIX='..\..\tcltk'

# Top-level directory in which Tcl's platform-specific files (e.g.
# executables) are installed.
TCL_EXEC_PREFIX='..\..\tcltk\bin'

# Flags to pass to cc when compiling the components of a shared library:
TCL_SHLIB_CFLAGS=''

# Flags to pass to cc to get warning messages
TCL_CFLAGS_WARNING='-W3'

# Extra flags to pass to cc:
TCL_EXTRA_CFLAGS='-YX'

# Base command to use for combining object files into a shared library:
TCL_SHLIB_LD='link -nologo -machine:IX86 -ltcg -release -opt:ref -opt:icf,3 -opt:nowin98 -dll'

# Base command to use for combining object files into a static library:
TCL_STLIB_LD='lib -nologo'

# Either '$LIBS' (if dependent libraries should be included when linking
# shared libraries) or an empty string.  See Tcl's configure.in for more
# explanation.
TCL_SHLIB_LD_LIBS='kernel32.lib user32.lib ws2_32.lib'

# Suffix to use for the name of a shared library.
TCL_SHLIB_SUFFIX='.dll'

# Library file(s) to include in tclsh and other base applications
# in order to provide facilities needed by DLOBJ above.
TCL_DL_LIBS=''

# Flags to pass to the compiler when linking object files into
# an executable tclsh or tcltest binary.
TCL_LD_FLAGS=''

# Flags to pass to ld, such as "-R /usr/local/tcl/lib", that tell the
# run-time dynamic linker where to look for shared libraries such as
# libtcl.so.  Used when linking applications.  Only works if there
# is a variable "LIB_RUNTIME_DIR" defined in the Makefile.
TCL_LD_SEARCH_FLAGS=''

# Additional object files linked with Tcl to provide compatibility
# with standard facilities from ANSI C or POSIX.
TCL_COMPAT_OBJS=''

# Name of the ranlib program to use.
TCL_RANLIB=''

# -l flag to pass to the linker to pick up the Tcl library
TCL_LIB_FLAG=''

# String to pass to linker to pick up the Tcl library from its
# build directory.
TCL_BUILD_LIB_SPEC=''

# String to pass to linker to pick up the Tcl library from its
# installed directory.
TCL_LIB_SPEC='..\..\tcltk\lib\tcl85.lib'

# String to pass to the compiler so that an extension can
# find installed Tcl headers.
TCL_INCLUDE_SPEC='-I..\..\tcltk\include'

# Indicates whether a version numbers should be used in -l switches
# ("ok" means it's safe to use switches like -ltcl7.5;  "nodots" means
# use switches like -ltcl75).  SunOS and FreeBSD require "nodots", for
# example.
TCL_LIB_VERSIONS_OK=''

# String that can be evaluated to generate the part of a shared library
# name that comes after the "libxxx" (includes version number, if any,
# extension, and anything else needed).  May depend on the variables
# VERSION and SHLIB_SUFFIX.  On most UNIX systems this is
# ${VERSION}${SHLIB_SUFFIX}.
TCL_SHARED_LIB_SUFFIX='85.dll'

# String that can be evaluated to generate the part of an unshared library
# name that comes after the "libxxx" (includes version number, if any,
# extension, and anything else needed).  May depend on the variable
# VERSION.  On most UNIX systems this is ${VERSION}.a.
TCL_UNSHARED_LIB_SUFFIX='85.lib'

# Location of the top-level source directory from which Tcl was built.
# This is the directory that contains a README file as well as
# subdirectories such as generic, unix, etc.  If Tcl was compiled in a
# different place than the directory containing the source files, this
# points to the location of the sources, not the location where Tcl was
# compiled.
TCL_SRC_DIR='..'

# List of standard directories in which to look for packages during
# "package require" commands.  Contains the "prefix" directory plus also
# the "exec_prefix" directory, if it is different.
TCL_PACKAGE_PATH=''

# Tcl supports stub.
TCL_SUPPORTS_STUBS=1

# The name of the Tcl stub library (.a):
TCL_STUB_LIB_FILE='tclstub85.lib'

# -l flag to pass to the linker to pick up the Tcl stub library
TCL_STUB_LIB_FLAG='tclstub85.lib'

# String to pass to linker to pick up the Tcl stub library from its
# build directory.
TCL_BUILD_STUB_LIB_SPEC='-L.\Release_VC9 tclstub85.lib'

# String to pass to linker to pick up the Tcl stub library from its
# installed directory.
TCL_STUB_LIB_SPEC='-L..\..\tcltk\lib tclstub85.lib'

# Path to the Tcl stub library in the build directory.
TCL_BUILD_STUB_LIB_PATH='.\Release_VC9\tclstub85.lib'

# Path to the Tcl stub library in the install directory.
TCL_STUB_LIB_PATH='..\..\tcltk\lib\tclstub85.lib'

# Flag, 1: we built Tcl with threads enables, 0 we didn't
TCL_THREADS=0

