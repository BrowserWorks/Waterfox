plugin_LTLIBRARIES = libgstvideoconvert.la

ORC_SOURCE=gstvideoconvertorc
include $(top_srcdir)/common/orc.mak

libgstvideoconvert_la_SOURCES = gstvideoconvert.c videoconvert.c gstcms.c
nodist_libgstvideoconvert_la_SOURCES = $(ORC_NODIST_SOURCES)
libgstvideoconvert_la_CFLAGS = \
	$(GST_PLUGINS_BASE_CFLAGS) \
	$(GST_CFLAGS) \
	$(ORC_CFLAGS)
libgstvideoconvert_la_LIBADD = \
	$(top_builddir)/gst-libs/gst/video/libgstvideo-$(GST_API_VERSION).la \
	$(GST_BASE_LIBS) \
	$(GST_LIBS) \
	$(ORC_LIBS) \
	$(LIBM)
libgstvideoconvert_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)
libgstvideoconvert_la_LIBTOOLFLAGS = $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = gstvideoconvert.h videoconvert.h gstcms.h

Android.mk: Makefile.am $(BUILT_SOURCES)
	androgenizer \
	-:PROJECT libgstvideoconvert -:SHARED libgstvideoconvert \
	 -:TAGS eng debug \
         -:REL_TOP $(top_srcdir) -:ABS_TOP $(abs_top_srcdir) \
	 -:SOURCES $(libgstvideoconvert_la_SOURCES) \
	           $(nodist_libgstvideoconvert_la_SOURCES) \
	 -:CFLAGS $(DEFS) $(DEFAULT_INCLUDES) $(libgstvideoconvert_la_CFLAGS) \
	 -:LDFLAGS $(libgstvideoconvert_la_LDFLAGS) \
	           $(libgstvideoconvert_la_LIBADD) \
	           -ldl \
	 -:PASSTHROUGH LOCAL_ARM_MODE:=arm \
		       LOCAL_MODULE_PATH:='$$(TARGET_OUT)/lib/gstreamer-0.10' \
	> $@
