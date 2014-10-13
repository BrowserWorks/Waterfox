plugin_LTLIBRARIES = libgstdeinterlace.la

ORC_SOURCE=tvtime
include $(top_srcdir)/common/orc.mak

libgstdeinterlace_la_SOURCES = \
	gstdeinterlace.c \
	gstdeinterlacemethod.c \
	tvtime/tomsmocomp.c \
	tvtime/greedy.c \
	tvtime/greedyh.c \
	tvtime/vfir.c \
	tvtime/weavetff.c \
	tvtime/weavebff.c \
	tvtime/weave.c \
	tvtime/linear.c \
	tvtime/linearblend.c \
	tvtime/scalerbob.c
nodist_libgstdeinterlace_la_SOURCES = $(ORC_NODIST_SOURCES)

libgstdeinterlace_la_CFLAGS = \
	$(GST_PLUGINS_BASE_CFLAGS) $(GST_BASE_CFLAGS) $(GST_CFLAGS) $(ORC_CFLAGS)
libgstdeinterlace_la_LIBADD = \
	$(GST_PLUGINS_BASE_LIBS) -lgstvideo-$(GST_API_VERSION) $(GST_BASE_LIBS) $(GST_LIBS) $(ORC_LIBS)
libgstdeinterlace_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)
libgstdeinterlace_la_LIBTOOLFLAGS = $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = \
	gstdeinterlace.h \
	gstdeinterlacemethod.h \
	tvtime/mmx.h \
	tvtime/sse.h \
	tvtime/greedyh.asm \
	tvtime/greedyhmacros.h \
	tvtime/plugins.h \
	tvtime/x86-64_macros.inc \
	tvtime/tomsmocomp/SearchLoop0A.inc \
	tvtime/tomsmocomp/SearchLoopBottom.inc \
	tvtime/tomsmocomp/SearchLoopEdgeA8.inc \
	tvtime/tomsmocomp/SearchLoopEdgeA.inc \
	tvtime/tomsmocomp/SearchLoopOddA2.inc \
	tvtime/tomsmocomp/SearchLoopOddA6.inc \
	tvtime/tomsmocomp/SearchLoopOddAH2.inc \
	tvtime/tomsmocomp/SearchLoopOddAH.inc \
	tvtime/tomsmocomp/SearchLoopOddA.inc \
	tvtime/tomsmocomp/SearchLoopTop.inc \
	tvtime/tomsmocomp/SearchLoopVAH.inc \
	tvtime/tomsmocomp/SearchLoopVA.inc \
	tvtime/tomsmocomp/StrangeBob.inc \
	tvtime/tomsmocomp/TomsMoCompAll2.inc \
	tvtime/tomsmocomp/TomsMoCompAll.inc \
	tvtime/tomsmocomp/tomsmocompmacros.h \
	tvtime/tomsmocomp/WierdBob.inc

Android.mk: Makefile.am $(BUILT_SOURCES)
	androgenizer \
	-:PROJECT libgstdeinterlace -:SHARED libgstdeinterlace \
	 -:TAGS eng debug \
         -:REL_TOP $(top_srcdir) -:ABS_TOP $(abs_top_srcdir) \
	 -:SOURCES $(libgstdeinterlace_la_SOURCES) \
	 	   $(nodist_libgstdeinterlace_la_SOURCES) \
	 -:CFLAGS $(DEFS) $(DEFAULT_INCLUDES) $(libgstdeinterlace_la_CFLAGS) \
	 -:LDFLAGS $(libgstdeinterlace_la_LDFLAGS) \
	           $(libgstdeinterlace_la_LIBADD) \
	           -ldl \
	 -:PASSTHROUGH LOCAL_ARM_MODE:=arm \
		       LOCAL_MODULE_PATH:='$$(TARGET_OUT)/lib/gstreamer-0.10' \
	> $@
