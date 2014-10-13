plugin_LTLIBRARIES = libgstautodetect.la

libgstautodetect_la_SOURCES = \
	gstautoaudiosink.c \
	gstautoaudiosrc.c \
	gstautodetect.c \
	gstautovideosink.c \
	gstautovideosrc.c
libgstautodetect_la_CFLAGS = $(GST_CFLAGS)
libgstautodetect_la_LIBADD = $(GST_LIBS)
libgstautodetect_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)
libgstautodetect_la_LIBTOOLFLAGS = $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = \
	gstautoaudiosink.h \
	gstautoaudiosrc.h \
	gstautodetect.h \
	gstautovideosink.h \
	gstautovideosrc.h

Android.mk: Makefile.am $(BUILT_SOURCES)
	androgenizer \
	-:PROJECT libgstautodetect -:SHARED libgstautodetect \
	 -:TAGS eng debug \
         -:REL_TOP $(top_srcdir) -:ABS_TOP $(abs_top_srcdir) \
	 -:SOURCES $(libgstautodetect_la_SOURCES) \
	 -:CFLAGS $(DEFS) $(DEFAULT_INCLUDES) $(libgstautodetect_la_CFLAGS) \
	 -:LDFLAGS $(libgstautodetect_la_LDFLAGS) \
	           $(libgstautodetect_la_LIBADD) \
	           -ldl \
	 -:PASSTHROUGH LOCAL_ARM_MODE:=arm \
		       LOCAL_MODULE_PATH:='$$(TARGET_OUT)/lib/gstreamer-0.10' \
	> $@
