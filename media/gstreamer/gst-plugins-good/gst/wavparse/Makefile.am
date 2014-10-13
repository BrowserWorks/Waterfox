plugin_LTLIBRARIES = libgstwavparse.la

libgstwavparse_la_SOURCES = gstwavparse.c
libgstwavparse_la_CFLAGS = \
	$(GST_PLUGINS_BASE_CFLAGS) \
	$(GST_BASE_CFLAGS) \
	$(GST_CFLAGS)
libgstwavparse_la_LIBADD = \
	$(GST_PLUGINS_BASE_LIBS) \
	-lgstriff-@GST_API_VERSION@ \
	-lgstaudio-@GST_API_VERSION@ \
	-lgsttag-@GST_API_VERSION@ \
	$(GST_BASE_LIBS) \
	$(GST_LIBS) \
	$(LIBM)
libgstwavparse_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)
libgstwavparse_la_LIBTOOLFLAGS = $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = gstwavparse.h

Android.mk: Makefile.am $(BUILT_SOURCES)
	androgenizer \
	-:PROJECT libgstwavparse -:SHARED libgstwavparse \
	 -:TAGS eng debug \
         -:REL_TOP $(top_srcdir) -:ABS_TOP $(abs_top_srcdir) \
	 -:SOURCES $(libgstwavparse_la_SOURCES) \
	 -:CFLAGS $(DEFS) $(DEFAULT_INCLUDES) $(libgstwavparse_la_CFLAGS) \
	 -:LDFLAGS $(libgstwavparse_la_LDFLAGS) \
	           $(libgstwavparse_la_LIBADD) \
	           -ldl \
	 -:PASSTHROUGH LOCAL_ARM_MODE:=arm \
		       LOCAL_MODULE_PATH:='$$(TARGET_OUT)/lib/gstreamer-0.10' \
	> $@
