plugin_LTLIBRARIES = libgstauparse.la

libgstauparse_la_SOURCES = gstauparse.c
libgstauparse_la_CFLAGS = $(GST_PLUGINS_BASE_CFLAGS) $(GST_BASE_CFLAGS) $(GST_CFLAGS)
libgstauparse_la_LIBADD = $(GST_PLUGINS_BASE_LIBS) -lgstaudio-$(GST_API_VERSION) $(GST_LIBS) $(GST_BASE_LIBS)
libgstauparse_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)
libgstauparse_la_LIBTOOLFLAGS = $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = gstauparse.h

Android.mk: Makefile.am $(BUILT_SOURCES)
	androgenizer \
	-:PROJECT libgstauparse -:SHARED libgstauparse \
	 -:TAGS eng debug \
         -:REL_TOP $(top_srcdir) -:ABS_TOP $(abs_top_srcdir) \
	 -:SOURCES $(libgstauparse_la_SOURCES) \
	 -:CFLAGS $(DEFS) $(DEFAULT_INCLUDES) $(libgstauparse_la_CFLAGS) \
	 -:LDFLAGS $(libgstauparse_la_LDFLAGS) \
	           $(libgstauparse_la_LIBADD) \
	           -ldl \
	 -:PASSTHROUGH LOCAL_ARM_MODE:=arm \
		       LOCAL_MODULE_PATH:='$$(TARGET_OUT)/lib/gstreamer-0.10' \
	> $@
