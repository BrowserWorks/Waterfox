# Start of settings from configure.bat 
COMPILER=gcc
MCPU_FLAG=-mtune=pentium4
DEBUG_INFO=-gdwarf-2 -g3
NODEBUG=1
DIST_FILES=D:/devel/emacs/libs/libXpm-3.5.8/src/libXpm.dll
USER_CFLAGS=-ID:/devel/emacs/libs/libXpm-3.5.8/include -ID:/devel/emacs/libs/libXpm-3.5.8/src -ID:/devel/emacs/libs/libpng-dev_1.4.3-1/include -ID:/devel/emacs/libs/zlib-dev_1.2.5-2/include -ID:/devel/emacs/libs/giflib-4.1.4-1/include -ID:/devel/emacs/libs/jpeg-6b-4/include -ID:/devel/emacs/libs/tiff-3.8.2-1/include -ID:/devel/emacs/libs/gnutls-3.0.9/include -ID:/devel/emacs/libs/libiconv-1.13.1-1-dev/include -ID:/devel/emacs/libs/libxml2-2.7.8/include/libxml2
ESC_USER_CFLAGS=-ID:/devel/emacs/libs/libXpm-3.5.8/include -ID:/devel/emacs/libs/libXpm-3.5.8/src -ID:/devel/emacs/libs/libpng-dev_1.4.3-1/include -ID:/devel/emacs/libs/zlib-dev_1.2.5-2/include -ID:/devel/emacs/libs/giflib-4.1.4-1/include -ID:/devel/emacs/libs/jpeg-6b-4/include -ID:/devel/emacs/libs/tiff-3.8.2-1/include -ID:/devel/emacs/libs/gnutls-3.0.9/include -ID:/devel/emacs/libs/libiconv-1.13.1-1-dev/include -ID:/devel/emacs/libs/libxml2-2.7.8/include/libxml2
# End of settings from configure.bat
 
#  -*- Makefile -*- definition file for building GNU Emacs on Windows NT.
# Copyright (C) 2000-2013 Free Software Foundation, Inc.

# This file is part of GNU Emacs.

# GNU Emacs is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# GNU Emacs is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

# Ensure 'all' is the default target
all:

# NOTES
#
# I tried to force gmake to use the native shell for simplicity, by
# setting SHELL as below, but this didn't work reliably because of
# various case sensitivity niggles.  Specifically, COMSPEC (which is in
# fact usually spelled ComSpec on NT, to make life difficult) typically
# references "cmd.exe" (on NT) when the file is actually called
# "CMD.EXE" on disk for hysterical raisons.  As a result, GNU make
# thinks it doesn't exist (unless compiled with a switch to ignore
# case), and so doesn't change which shell it will invoke to execute
# commands.
#
# It would be possible, though very tedious using just gmake facilities,
# to convert the COMSPEC value to uppercase to solve this problem, but
# it isn't worth it.  That is partly because, even when using the native
# shell, gmake tends to not be happy with backslashes in command
# strings.  The obvious solution is to use forward slashes as much as
# possible, which can be made to work most of the time (putting
# filenames in quotes often helps), but there are still some internal
# cmd.exe commands like `del' and `copy' that won't work with them.
# Although it is possible to convert slashes to backslashes when
# necessary, gmake requires explicitly calling its subst function, which
# nmake does not understand).  For this reason, it is simplest to
# mandate that rm and cp be available, so we can use Unix-format file
# names everywhere.  (Fortunately both MS and GNU make, and the
# respective compilers, are happy with Unix-format names.)
#
# Since we cannot easily force the choice of a particular shell, we must
# make the effort to cope with whichever shell is being used.
# Fortunately, the only command we need to use that is shell specific is
# the testing of a file's existence for the purpose of working out when
# we are copying files to their original location.  That particular
# requirement is abstracted easily enough.
#
# The only other problem area was the change of directory when running
# temacs to dump emacs.exe (where gmake doesn't support cd foo in any
# useful way), but that has been resolved by modifying the Windows
# unexec function slightly to not require the directory change while
# still allowing objects and binaries to be in subdirectories.

# This doesn't work.
#SHELL:=$(COMSPEC)

# Determine whether make is using sh or cmd/command as shell; cmd.exe
# will output "ECHO is on" when echo is given by itself, while sh will
# not produce any output.
sh_output := $(shell echo)
ifeq "$(findstring ECHO, $(sh_output))" "ECHO"
THE_SHELL = $(COMSPEC)$(ComSpec)
SHELLTYPE=CMD
else
USING_SH = 1
THE_SHELL = $(SHELL)
SHELLTYPE=SH
endif

MAKETYPE=gmake

# The following "ifeq" does not appear to DTRT, and therefore breaks
# the build on mingw32. Also the -m option does not exist in many
# (reasonably recent even) versions of Cygwin. These issues need to be
# remedied before putting this cygpath kludge back in.

# Convert CURDIR to native file name, if in Cygwin format
#ifeq "$(shell cygpath $(CURDIR))" "$(CURDIR)"
#CURDIR	        := $(shell cygpath -m $(CURDIR))
#endif

THISDIR		= .

# Cygwin has changed quoting rules somewhat since b20, in a way that
# affects makefiles using sh as the command processor, so we need to
# detect which rules to use.
ifdef USING_SH
sh_output := $(shell echo [Please ignore a syntax error on the next line - it is intentional] 1>&2)
sh_output := $(shell echo foo")
# This single quote " is to fix fontification due to previous line
ifeq "$(sh_output)" ""
NEW_CYGWIN = 1
endif

# By default, newer versions of Cygwin mess with NTFS ACLs in an
# attempt to emulate traditional posix file permissions. This can
# cause bad effects, such as .exe files that are missing the
# FILE_EXECUTE/FILE_GENERIC_EXECUTE permissions when they are created
# with Cygwin commands that don't expect to be creating executable
# files. Then when we later use a non-Cygwin program to create the
# real .exe, the previous Cygwin defined ACL sticks.
CYGWIN=nontsec
export CYGWIN
endif

ALL_DEPS	= $^
EMPTY =
SPACE = $(EMPTY) $(EMPTY)

SUBSYSTEM_WINDOWS=-Wl,-subsystem,windows
SUBSYSTEM_CONSOLE=-Wl,-subsystem,console

# INSTALL_DIR is the directory into which emacs will be installed.
#
ifndef INSTALL_DIR
INSTALL_DIR     = $(CURDIR)/..
endif

export EMACSLOADPATH

# Determine the architecture we're running on.
# Define ARCH for our purposes;
# Define CPU for use by ntwin32.mak;
# Define CONFIG_H to the appropriate config.h for the system;
#
ifdef PROCESSOR_ARCHITECTURE
# We're on Windows NT
CPU		= $(PROCESSOR_ARCHITECTURE)
CONFIG_H	= config.nt
OS_TYPE		= windowsnt
 ifeq "$(PROCESSOR_ARCHITECTURE)" "x86"
ARCH		= i386
CPU		= i386
EMACS_HEAPSIZE	= 27
EMACS_PURESIZE	= 5000000
EMACS_MANIFEST	= emacs-x86.manifest
 else
  ifeq "$(PROCESSOR_ARCHITECTURE)" "MIPS"
ARCH		= mips
EMACS_HEAPSIZE	= 27
EMACS_PURESIZE	= 5000000
EMACS_MANIFEST	= emacs-mips.manifest
  else
   ifeq "$(PROCESSOR_ARCHITECTURE)" "ALPHA"
ARCH		= alpha
EMACS_HEAPSIZE	= 27
EMACS_PURESIZE	= 5000000
EMACS_MANIFEST	= emacs-alpha.manifest
   else
    ifeq "$(PROCESSOR_ARCHITECTURE)" "PPC"
ARCH		= ppc
EMACS_HEAPSIZE	= 27
EMACS_PURESIZE	= 5000000
EMACS_MANIFEST	= emacs-ppc.manifest
    else
     $(error Unknown architecture type "$(PROCESSOR_ARCHITECTURE)")
    endif
   endif
  endif
 endif
else
# We're on Windows 95
ARCH		= i386
CPU		= i386
CONFIG_H	= config.nt
OS_TYPE		= windows95
endif

AR		= ar -rsc
AR_OUT		=
CC		= gcc
CC_OUT		= -o$(SPACE)
LINK		= gcc
LINK_OUT	= -o$(SPACE)
RC		= windres -O coff
RC_OUT		= -o$(SPACE)
RC_INCLUDE	= --include-dir$(SPACE)

libc		=
baselibs	=
O		= o
A		= a

BASE_LIBS	= $(libc) $(baselibs)

ADVAPI32	= -ladvapi32
COMCTL32	= -lcomctl32
COMDLG32	= -lcomdlg32
GDI32		= -lgdi32
MPR		= -lmpr
SHELL32		= -lshell32
USER32		= -luser32
WSOCK32		= -lwsock32
WINMM		= -lwinmm
WINSPOOL	= -lwinspool
OLE32		= -lole32
UNISCRIBE	= -lusp10
UUID		= -luuid

# Used by src/makefile.w32-in, since Nmake barfs on $(func SOMETHING)
OBJ0_c		= $(patsubst $(BLD)%.$(O),$(CURDIR)%.c,$(OBJ0))
OBJ1_c		= $(patsubst $(BLD)%.$(O),$(CURDIR)%.c,$(OBJ1))
OBJ2_c		= $(patsubst $(BLD)%.$(O),$(CURDIR)%.c,$(OBJ2))

ifdef NOOPT
DEBUG_CFLAGS	= -DEMACSDEBUG -fno-crossjumping -std=gnu99
else
DEBUG_CFLAGS	=
endif

MWINDOWS        = -mwindows

CFLAGS          = -I. $(ARCH_CFLAGS) $(DEBUG_CFLAGS) $(PROFILE_CFLAGS) $(USER_CFLAGS) $(LOCAL_FLAGS)
ESC_CFLAGS      = -I. $(ARCH_CFLAGS) $(DEBUG_CFLAGS) $(PROFILE_CFLAGS) $(ESC_USER_CFLAGS) $(LOCAL_FLAGS)
EMACS_EXTRA_C_FLAGS = -DUSE_CRT_DLL=1

ifdef PROFILE
PROFILE_CFLAGS  = -pg
PROFILE_LDFLAGS  = -pg
else
PROFILE_CFLAGS  =
PROFILE_LDFLAGS =
endif


# see comments in allocate_heap in w32heap.c before changing any of the
# -stack, -heap, or -image-base settings.
TEMACS_EXTRA_LINK = -Wl,-stack,0x00800000 -Wl,-heap,0x00100000 -Wl,-image-base,0x01000000 $(SUBSYSTEM_CONSOLE) -Wl,-entry,__start -Wl,-Map,$(BLD)/temacs.map

ifdef NOOPT
OBJDIR          = oo
else
OBJDIR          = oo-spd
endif
$(OBJDIR):;	-mkdir "$(OBJDIR)"
BLD             = $(OBJDIR)/$(ARCH)
stamp_BLD:      $(OBJDIR)
		-mkdir "$(BLD)"
		echo $(BLD) > $@

COMPILER_TEMP_FILES =

CP		= cp -f
CP_DIR		= cp -rf
DEL		= rm
DEL_TREE	= rm -r

DIRNAME		= $(notdir $(CURDIR))

ifdef USING_SH

IFNOTSAMEDIR	= if [ ! -s ../$(DIRNAME)_same-dir.tst ] ; then
FOREACH		= for f in
FORVAR		= $${f}
FORDO		= ; do
ENDFOR		= ; done
ENDIF		= ; fi
ARGQUOTE	= '
ifdef NEW_CYGWIN
DQUOTE		= "
else
DQUOTE		= ""
endif

else

IFNOTSAMEDIR	= if not exist ../$(DIRNAME)_same-dir.tst
FOREACH		= for %%f in (
FORVAR		= %%f
FORDO		= ) do
ENDFOR		=
ENDIF		=
ARGQUOTE	= "
DQUOTE		= \"

endif

ifdef NODEBUG
DEBUG_FLAG =
DEBUG_LINK =
else
DEBUG_FLAG = $(DEBUG_INFO)
DEBUG_LINK = $(DEBUG_INFO)
endif

ifdef NOCYGWIN
NOCYGWIN = -mno-cygwin
endif

ifdef USER_LIBS
USER_LIBS := $(patsubst %,-l%,$(USER_LIBS))
endif

PRAGMA_SYSTEM_HEADER = \#pragma GCC system_header

ifeq "$(ARCH)" "i386"
ifdef NOOPT
ARCH_CFLAGS     = -c $(DEBUG_FLAG) $(NOCYGWIN)
else
ARCH_CFLAGS     = -c $(DEBUG_FLAG) $(NOCYGWIN) $(MCPU_FLAG) -O2 \
		  # -fbuiltin \
		  # -finline-functions \
		  # -fomit-frame-pointer
endif
ARCH_LDFLAGS	= $(SYS_LDFLAGS)
else
ERROR Unknown architecture type "$(ARCH)".
endif

LINK_FLAGS	= $(ARCH_LDFLAGS) $(DEBUG_LINK) $(PROFILE_LDFLAGS) $(NOCYGWIN) $(USER_LDFLAGS)

export XMFLAGS

.DEFAULT:

$(BLD)/%.o: %.c
		$(CC) $(CFLAGS) $(CC_OUT)$@ $<
# -*- Makefile -*- for leim subdirectory in GNU Emacs on the Microsoft Windows API.

# Copyright (C) 2000-2013 Free Software Foundation, Inc.
# Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
#   2006, 2007
#   National Institute of Advanced Industrial Science and Technology (AIST)
#   Registration Number H14PRO021

# This file is part of GNU Emacs.

# GNU Emacs is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# GNU Emacs is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.


srcdir=.

# Where to install LEIM files.
INSTALLDIR=$(INSTALL_DIR)/leim

# On IBM RS6000, double-dot gets screwed up.
dot = .

# Which Emacs to use to convert TIT files to Emacs Lisp files,
# byte-compile Emacs Lisp files, and generate the file leim-list.el.
BUILT_EMACS = $(THISDIR)/$(dot)$(dot)/src/$(BLD)/emacs.exe

buildlisppath=$(CURDIR)/$(dot)$(dot)/lisp

# How to run Emacs.
RUN_EMACS = "$(BUILT_EMACS)" -batch --no-site-file --no-site-lisp

# Set EMACSLOADPATH correctly (already defined in environment).
EMACSLOADPATH=$(buildlisppath)

# Subdirectories to be made if $(srcdir) is different from the current
# directory.
SUBDIRS=quail

# Files generated from TIT dictionaries for Chinese GB character set.
TIT_GB=\
	quail/CCDOSPY.elc	\
	quail/Punct.elc		\
	quail/QJ.elc		\
	quail/SW.elc		\
	quail/TONEPY.elc

# Files generated from TIT dictionaries for Chinese BIG5 character set.
TIT_BIG5=\
	quail/4Corner.elc	\
	quail/ARRAY30.elc	\
	quail/ECDICT.elc	\
	quail/ETZY.elc		\
	quail/Punct-b5.elc	\
	quail/PY-b5.elc		\
	quail/QJ-b5.elc		\
	quail/ZOZY.elc

CHINESE_TIT=$(TIT_GB) $(TIT_BIG5)

NON_TIT_GB=$(srcdir)/quail/py-punct.elc

NON_TIT_BIG5=$(srcdir)/quail/pypunct-b5.elc

CHINESE_NON_TIT=$(NON_TIT_GB) $(NON_TIT_BIG5)

CHINESE_GB=$(TIT_GB) $(NON_TIT_GB)

CHINESE_BIG5=$(TIT_BIG5) $(NON_TIT_BIG5)

JAPANESE=$(srcdir)/quail/japanese.elc $(srcdir)/ja-dic/ja-dic.elc

KOREAN=	$(srcdir)/quail/hangul.elc	\
	$(srcdir)/quail/hanja.elc	\
	$(srcdir)/quail/hanja3.elc	\
	$(srcdir)/quail/hanja-jis.elc	\
	$(srcdir)/quail/symbol-ksc.elc

THAI=$(srcdir)/quail/thai.elc

VIETNAMESE=$(srcdir)/quail/viqr.elc $(srcdir)/quail/vntelex.elc

LAO=$(srcdir)/quail/lao.elc $(srcdir)/quail/lrt.elc

INDIAN=$(srcdir)/quail/indian.elc

TIBETAN=$(srcdir)/quail/tibetan.elc

LATIN=	$(srcdir)/quail/latin-pre.elc	\
	$(srcdir)/quail/latin-post.elc	\
	$(srcdir)/quail/latin-alt.elc	\
	$(srcdir)/quail/latin-ltx.elc	\
	$(srcdir)/quail/welsh.elc

UNICODE=$(srcdir)/quail/sgml-input.elc	\
	$(srcdir)/quail/rfc1345.elc	\
	$(srcdir)/quail/uni-input.elc

SLAVIC= \
	$(srcdir)/quail/czech.elc \
	$(srcdir)/quail/croatian.elc \
	$(srcdir)/quail/slovak.elc

GREEK=$(srcdir)/quail/greek.elc

RUSSIAN=$(srcdir)/quail/cyrillic.elc $(srcdir)/quail/cyril-jis.elc

MISC= \
	$(srcdir)/quail/arabic.elc \
	$(srcdir)/quail/ethiopic.elc \
	$(srcdir)/quail/ipa.elc \
	$(srcdir)/quail/ipa-praat.elc \
	$(srcdir)/quail/hebrew.elc \
	$(srcdir)/quail/georgian.elc \
	$(srcdir)/quail/persian.elc \
	$(srcdir)/quail/sisheng.elc

MISC_DIC=\
	quail/tsang-b5.elc	\
	quail/quick-b5.elc	\
	quail/tsang-cns.elc	\
	quail/quick-cns.elc	\
	quail/PY.elc		\
	quail/ZIRANMA.elc	\
	quail/CTLau.elc		\
	quail/CTLau-b5.elc

CHINESE=$(CHINESE_GB) $(CHINESE_BIG5)
EASTASIA=$(CHINESE) $(JAPANESE) $(KOREAN)
ASIA=$(EASTASIA) $(THAI) $(VIETNAMESE) $(LAO) $(INDIAN) $(TIBETAN)
EUROPEAN=$(LATIN) $(SLAVIC) $(GREEK) $(RUSSIAN)
WORLD=$(ASIA) $(EUROPEAN) $(MISC) $(MISC_DIC) $(UNICODE)

TIT=$(CHINESE_TIT)
NON_TIT=$(CHINESE_NON_TIT) $(JAPANESE) $(KOREAN) $(EUROPEAN) $(MISC)

.SUFFIXES: .elc .el

.el.elc:
	$(RUN_EMACS) -f batch-byte-compile $<

all: $(BUILT_EMACS) $(SUBDIRS) $(WORLD) leim-list.el

# To ensure that we can run Emacs.  This target is ignored (never
# being hit) if a user changes default value of EMACS.
$(dot)$(dot)/src/emacs:
	cd ../src; $(MAKE) $(MFLAGS) emacs

$(SUBDIRS):
	mkdir "$@"
	echo stamp>stamp-subdir

# The rules which generate $(TIT) and ${MISC_DIC) files create them all
# in one go.  So we need to prevent parallel execution for that target,
# otherwise Emacs complains about files being locked.  .NOTPARALLEL is
# for GNU Make, .NO_PARALLEL is for other Make's.
.NOTPARALLEL: $(TIT) $(MISC_DIC)

.NO_PARALLEL: $(TIT) $(MISC_DIC)

# Rule to generate quail/*.el from CXTERM-DIC/*.tit.
#
# WARNING: Do NOT split the part inside $(ARGQUOTE)s into multiple lines as
#          this can break with GNU Make 3.81 and later if sh.exe is used.
$(TIT):
	$(RUN_EMACS) -l \
	    $(ARGQUOTE)$(buildlisppath)/international/titdic-cnv$(ARGQUOTE) \
	    --eval $(ARGQUOTE)(batch-titdic-convert t)$(ARGQUOTE) \
	    -dir quail $(srcdir)/CXTERM-DIC
	$(RUN_EMACS)  -l \
	    $(ARGQUOTE)$(buildlisppath)/international/quail$(ARGQUOTE) \
	    -f batch-byte-compile $(TIT:.elc=.el)

# Rule to generate quail/*.el from MISC_DIC/*.tit.
$(MISC_DIC):
	$(RUN_EMACS) -l \
	    $(ARGQUOTE)$(buildlisppath)/international/titdic-cnv$(ARGQUOTE) \
	    -f batch-miscdic-convert -dir quail $(srcdir)/MISC-DIC
	$(RUN_EMACS)  -l \
	    $(ARGQUOTE)$(buildlisppath)/international/quail$(ARGQUOTE) \
	    -f batch-byte-compile $(MISC_DIC:.elc=.el)

#
# WARNING: Do NOT split the parts inside $(ARGQUOTE)s into multiple lines as
#          this can break with GNU Make 3.81 and later if sh.exe is used.
leim-list.el: $(SUBDIRS) $(WORLD) $(srcdir)/leim-ext.el
	- $(DEL) leim-list.el
	$(RUN_EMACS) -l \
	    $(ARGQUOTE)$(buildlisppath)/international/quail$(ARGQUOTE) \
	    --eval $(ARGQUOTE)(update-leim-list-file $(DQUOTE).$(DQUOTE))$(ARGQUOTE)
	$(RUN_EMACS) --eval $(ARGQUOTE)(w32-append-code-lines $(DQUOTE)$@$(DQUOTE) $(DQUOTE)$(srcdir)/leim-ext.el$(DQUOTE))$(ARGQUOTE)

install: all
	- mkdir "$(INSTALLDIR)"
	- $(DEL) $(DIRNAME)_same-dir.tst
	- $(DEL) $(INSTALL_DIR)/$(DIRNAME)_same-dir.tst
	echo SameDirTest > $(INSTALL_DIR)/$(DIRNAME)_same-dir.tst
	$(IFNOTSAMEDIR) $(CP) leim-list.el $(INSTALLDIR) $(ENDIF)
	$(IFNOTSAMEDIR) $(CP_DIR) quail $(INSTALLDIR) $(ENDIF)
	$(IFNOTSAMEDIR) $(CP_DIR) ja-dic $(INSTALLDIR) $(ENDIF)
	- $(DEL) $(INSTALL_DIR)/$(DIRNAME)_same-dir.tst

clean mostlyclean:
	- $(FOREACH) $(TIT) $(FORDO) $(DEL) $(FORVAR) $(ENDFOR)
	- $(FOREACH) $(MISC_DIC) $(FORDO) $(DEL) $(FORVAR) $(ENDFOR)
	- $(FOREACH) $(TIT:.elc=.el) $(FORDO) $(DEL) $(FORVAR) $(ENDFOR)
	- $(FOREACH) $(MISC_DIC:.elc=.el) $(FORDO) $(DEL) $(FORVAR) $(ENDFOR)
	- $(DEL) leim-list.el
	- $(DEL) leim-list.el~

distclean: clean
	- $(DEL) stamp-subdir
	- $(DEL) makefile

maintainer-clean: distclean
	- $(FOREACH) $(WORLD) $(FORDO) $(DEL) $(FORVAR) $(ENDFOR)

# We used to delete *~ here, but that might inadvertently remove
# precious files if it happens to match their short 8+3 aliases.
extraclean: maintainer-clean
	- $(FOREACH) *.el~ "#*" $(FORDO) $(DEL) $(FORVAR) $(ENDFOR)
