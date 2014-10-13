plugin_LTLIBRARIES = libgstaudioparsers.la

libgstaudioparsers_la_SOURCES = \
	gstaacparse.c gstamrparse.c gstac3parse.c \
	gstdcaparse.c gstflacparse.c gstmpegaudioparse.c \
	gstsbcparse.c gstwavpackparse.c plugin.c

libgstaudioparsers_la_CFLAGS = \
	$(GST_PLUGINS_BASE_CFLAGS) $(GST_BASE_CFLAGS) $(GST_CFLAGS)
libgstaudioparsers_la_LIBADD = \
	-lgstpbutils-$(GST_API_VERSION) \
	$(GST_PLUGINS_BASE_LIBS) -lgsttag-$(GST_API_VERSION) \
	-lgstaudio-$(GST_API_VERSION) \
	$(GST_BASE_LIBS) $(GST_LIBS)
libgstaudioparsers_la_LDFLAGS = $(GST_PLUGIN_LDFLAGS)
libgstaudioparsers_la_LIBTOOLFLAGS = $(GST_PLUGIN_LIBTOOLFLAGS)

noinst_HEADERS = gstaacparse.h gstamrparse.h gstac3parse.h \
	gstdcaparse.h gstflacparse.h gstmpegaudioparse.h gstsbcparse.h \
	gstwavpackparse.h
