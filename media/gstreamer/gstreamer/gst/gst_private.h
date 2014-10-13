/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gst_private.h: Private header for within libgst
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#ifndef __GST_PRIVATE_H__
#define __GST_PRIVATE_H__

#ifdef HAVE_CONFIG_H
# ifndef GST_LICENSE   /* don't include config.h twice, it has no guards */
#  include "config.h"
# endif
#endif

/* This needs to be before glib.h, since it might be used in inline
 * functions */
extern const char             g_log_domain_gstreamer[];

#include <glib.h>

#include <stdlib.h>
#include <string.h>

/* Needed for GstRegistry * */
#include "gstregistry.h"
#include "gststructure.h"

/* we need this in pretty much all files */
#include "gstinfo.h"

/* for the flags in the GstPluginDep structure below */
#include "gstplugin.h"

/* for the pad cache */
#include "gstpad.h"

/* for GstElement */
#include "gstelement.h"

/* for GstDeviceProvider */
#include "gstdeviceprovider.h"

/* for GstToc */
#include "gsttoc.h"

#include "gstdatetime.h"

G_BEGIN_DECLS

/* used by gstparse.c and grammar.y */
struct _GstParseContext {
  GList * missing_elements;
};

/* used by gstplugin.c and gstregistrybinary.c */
typedef struct {
  /* details registered via gst_plugin_add_dependency() */
  GstPluginDependencyFlags  flags;
  gchar **env_vars;
  gchar **paths;
  gchar **names;

  /* information saved from the last time the plugin was loaded (-1 = unset) */
  guint   env_hash;  /* hash of content of environment variables in env_vars */
  guint   stat_hash; /* hash of stat() on all relevant files and directories */
} GstPluginDep;

struct _GstPluginPrivate {
  GList *deps;    /* list of GstPluginDep structures */
  GstStructure *cache_data;
};

/* FIXME: could rename all priv_gst_* functions to __gst_* now */
G_GNUC_INTERNAL  gboolean priv_gst_plugin_loading_have_whitelist (void);

G_GNUC_INTERNAL  guint32  priv_gst_plugin_loading_get_whitelist_hash (void);

G_GNUC_INTERNAL  gboolean priv_gst_plugin_desc_is_whitelisted (GstPluginDesc * desc,
                                                               const gchar   * filename);

G_GNUC_INTERNAL  gboolean _priv_plugin_deps_env_vars_changed (GstPlugin * plugin);

G_GNUC_INTERNAL  gboolean _priv_plugin_deps_files_changed (GstPlugin * plugin);

G_GNUC_INTERNAL  gboolean _priv_gst_in_valgrind (void);

/* init functions called from gst_init(). */
G_GNUC_INTERNAL  void  _priv_gst_quarks_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_mini_object_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_memory_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_allocator_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_buffer_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_buffer_list_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_structure_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_caps_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_caps_features_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_event_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_format_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_message_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_meta_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_plugin_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_query_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_sample_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_tag_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_value_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_debug_init (void);
G_GNUC_INTERNAL  void  _priv_gst_context_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_toc_initialize (void);
G_GNUC_INTERNAL  void  _priv_gst_date_time_initialize (void);

/* Private registry functions */
G_GNUC_INTERNAL
gboolean _priv_gst_registry_remove_cache_plugins (GstRegistry *registry);

G_GNUC_INTERNAL  void _priv_gst_registry_cleanup (void);

gboolean _gst_plugin_loader_client_run (void);

/* Used in GstBin for manual state handling */
G_GNUC_INTERNAL  void _priv_gst_element_state_changed (GstElement *element,
                      GstState oldstate, GstState newstate, GstState pending);

/* used in both gststructure.c and gstcaps.c; numbers are completely made up */
#define STRUCTURE_ESTIMATED_STRING_LEN(s) (16 + gst_structure_n_fields(s) * 22)
#define FEATURES_ESTIMATED_STRING_LEN(s) (16 + gst_caps_features_get_size(s) * 14)

G_GNUC_INTERNAL
gboolean  priv_gst_structure_append_to_gstring (const GstStructure * structure,
                                                GString            * s);
G_GNUC_INTERNAL
void priv_gst_caps_features_append_to_gstring (const GstCapsFeatures * features, GString *s);

G_GNUC_INTERNAL
gboolean priv_gst_structure_parse_name (gchar * str, gchar **start, gchar ** end, gchar ** next);
G_GNUC_INTERNAL
gboolean priv_gst_structure_parse_fields (gchar *str, gchar ** end, GstStructure *structure);

/* registry cache backends */
G_GNUC_INTERNAL
gboolean		priv_gst_registry_binary_read_cache	(GstRegistry * registry, const char *location);

G_GNUC_INTERNAL
gboolean		priv_gst_registry_binary_write_cache	(GstRegistry * registry, GList * plugins, const char *location);


G_GNUC_INTERNAL
void      __gst_element_factory_add_static_pad_template (GstElementFactory    * elementfactory,
                                                         GstStaticPadTemplate * templ);

G_GNUC_INTERNAL
void      __gst_element_factory_add_interface           (GstElementFactory    * elementfactory,
                                                         const gchar          * interfacename);

/* used in gstvalue.c and gststructure.c */
#define GST_ASCII_IS_STRING(c) (g_ascii_isalnum((c)) || ((c) == '_') || \
    ((c) == '-') || ((c) == '+') || ((c) == '/') || ((c) == ':') || \
    ((c) == '.'))

/* This is only meant for internal uses */
G_GNUC_INTERNAL
gint __gst_date_time_compare (const GstDateTime * dt1, const GstDateTime * dt2);

G_GNUC_INTERNAL
gchar * __gst_date_time_serialize (GstDateTime * datetime, gboolean with_usecs);

#ifndef GST_DISABLE_REGISTRY
/* Secret variable to initialise gst without registry cache */
GST_EXPORT gboolean _gst_disable_registry_cache;
#endif

/* provide inline gst_g_value_get_foo_unchecked(), used in gststructure.c */
#define DEFINE_INLINE_G_VALUE_GET_UNCHECKED(ret_type,name_type,v_field) \
static inline ret_type                                                  \
gst_g_value_get_##name_type##_unchecked (const GValue *value)           \
{                                                                       \
  return value->data[0].v_field;                                        \
}

DEFINE_INLINE_G_VALUE_GET_UNCHECKED(gboolean,boolean,v_int)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(gint,int,v_int)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(guint,uint,v_uint)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(gint64,int64,v_int64)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(guint64,uint64,v_uint64)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(gfloat,float,v_float)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(gdouble,double,v_double)
DEFINE_INLINE_G_VALUE_GET_UNCHECKED(const gchar *,string,v_pointer)


/*** debugging categories *****************************************************/

#ifndef GST_REMOVE_GST_DEBUG

GST_EXPORT GstDebugCategory *GST_CAT_GST_INIT;
GST_EXPORT GstDebugCategory *GST_CAT_MEMORY;
GST_EXPORT GstDebugCategory *GST_CAT_PARENTAGE;
GST_EXPORT GstDebugCategory *GST_CAT_STATES;
GST_EXPORT GstDebugCategory *GST_CAT_SCHEDULING;
GST_EXPORT GstDebugCategory *GST_CAT_BUFFER;
GST_EXPORT GstDebugCategory *GST_CAT_BUFFER_LIST;
GST_EXPORT GstDebugCategory *GST_CAT_BUS;
GST_EXPORT GstDebugCategory *GST_CAT_CAPS;
GST_EXPORT GstDebugCategory *GST_CAT_CLOCK;
GST_EXPORT GstDebugCategory *GST_CAT_ELEMENT_PADS;
GST_EXPORT GstDebugCategory *GST_CAT_PADS;
GST_EXPORT GstDebugCategory *GST_CAT_PERFORMANCE;
GST_EXPORT GstDebugCategory *GST_CAT_PIPELINE;
GST_EXPORT GstDebugCategory *GST_CAT_PLUGIN_LOADING;
GST_EXPORT GstDebugCategory *GST_CAT_PLUGIN_INFO;
GST_EXPORT GstDebugCategory *GST_CAT_PROPERTIES;
GST_EXPORT GstDebugCategory *GST_CAT_NEGOTIATION;
GST_EXPORT GstDebugCategory *GST_CAT_REFCOUNTING;
GST_EXPORT GstDebugCategory *GST_CAT_ERROR_SYSTEM;
GST_EXPORT GstDebugCategory *GST_CAT_EVENT;
GST_EXPORT GstDebugCategory *GST_CAT_MESSAGE;
GST_EXPORT GstDebugCategory *GST_CAT_PARAMS;
GST_EXPORT GstDebugCategory *GST_CAT_CALL_TRACE;
GST_EXPORT GstDebugCategory *GST_CAT_SIGNAL;
GST_EXPORT GstDebugCategory *GST_CAT_PROBE;
GST_EXPORT GstDebugCategory *GST_CAT_REGISTRY;
GST_EXPORT GstDebugCategory *GST_CAT_QOS;
GST_EXPORT GstDebugCategory *GST_CAT_META;
GST_EXPORT GstDebugCategory *GST_CAT_LOCKING;
GST_EXPORT GstDebugCategory *GST_CAT_CONTEXT;

/* Categories that should be completely private to
 * libgstreamer should be done like this: */
#define GST_CAT_POLL _priv_GST_CAT_POLL
extern GstDebugCategory *_priv_GST_CAT_POLL;

#else

#define GST_CAT_GST_INIT         NULL
#define GST_CAT_AUTOPLUG         NULL
#define GST_CAT_AUTOPLUG_ATTEMPT NULL
#define GST_CAT_PARENTAGE        NULL
#define GST_CAT_STATES           NULL
#define GST_CAT_SCHEDULING       NULL
#define GST_CAT_DATAFLOW         NULL
#define GST_CAT_BUFFER           NULL
#define GST_CAT_BUFFER_LIST      NULL
#define GST_CAT_BUS              NULL
#define GST_CAT_CAPS             NULL
#define GST_CAT_CLOCK            NULL
#define GST_CAT_ELEMENT_PADS     NULL
#define GST_CAT_PADS             NULL
#define GST_CAT_PERFORMANCE      NULL
#define GST_CAT_PIPELINE         NULL
#define GST_CAT_PLUGIN_LOADING   NULL
#define GST_CAT_PLUGIN_INFO      NULL
#define GST_CAT_PROPERTIES       NULL
#define GST_CAT_NEGOTIATION      NULL
#define GST_CAT_REFCOUNTING      NULL
#define GST_CAT_ERROR_SYSTEM     NULL
#define GST_CAT_EVENT            NULL
#define GST_CAT_MESSAGE          NULL
#define GST_CAT_PARAMS           NULL
#define GST_CAT_CALL_TRACE       NULL
#define GST_CAT_SIGNAL           NULL
#define GST_CAT_PROBE            NULL
#define GST_CAT_REGISTRY         NULL
#define GST_CAT_QOS              NULL
#define GST_CAT_TYPES            NULL
#define GST_CAT_POLL             NULL
#define GST_CAT_META             NULL
#define GST_CAT_LOCKING          NULL
#define GST_CAT_CONTEXT          NULL

#endif

#ifdef GST_DISABLE_GST_DEBUG
/* for _gst_element_error_printf */
#define __gst_vasprintf __gst_info_fallback_vasprintf
int __gst_vasprintf (char **result, char const *format, va_list args);
#endif

/**** objects made opaque until the private bits have been made private ****/

#include <gmodule.h>
#include <time.h> /* time_t */
#include <sys/types.h> /* off_t */
#include <sys/stat.h> /* off_t */

typedef struct _GstPluginPrivate GstPluginPrivate;

struct _GstPlugin {
  GstObject       object;

  /*< private >*/
  GstPluginDesc	desc;

  GstPluginDesc *orig_desc;

  gchar *	filename;
  gchar *	basename;       /* base name (non-dir part) of plugin path */

  GModule *	module;		/* contains the module if plugin is loaded */

  off_t         file_size;
  time_t        file_mtime;
  gboolean      registered;     /* TRUE when the registry has seen a filename
                                 * that matches the plugin's basename */

  GstPluginPrivate *priv;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstPluginClass {
  GstObjectClass  object_class;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

struct _GstPluginFeature {
  GstObject      object;

  /*< private >*/
  gboolean       loaded;
  guint          rank;

  const gchar   *plugin_name;
  GstPlugin     *plugin;      /* weak ref */

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

struct _GstPluginFeatureClass {
  GstObjectClass        parent_class;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

#include "gsttypefind.h"

struct _GstTypeFindFactory {
  GstPluginFeature              feature;
  /* <private> */

  GstTypeFindFunction           function;
  gchar **                      extensions;
  GstCaps *                     caps;

  gpointer                      user_data;
  GDestroyNotify                user_data_notify;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstTypeFindFactoryClass {
  GstPluginFeatureClass         parent;
  /* <private> */

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstElementFactory {
  GstPluginFeature      parent;

  GType                 type;                   /* unique GType of element or 0 if not loaded */

  gpointer              metadata;

  GList *               staticpadtemplates;     /* GstStaticPadTemplate list */
  guint                 numpadtemplates;

  /* URI interface stuff */
  GstURIType            uri_type;
  gchar **              uri_protocols;

  GList *               interfaces;             /* interface type names this element implements */

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

struct _GstElementFactoryClass {
  GstPluginFeatureClass parent_class;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDeviceProviderFactory {
  GstPluginFeature           feature;
  /* <private> */

  GType                      type;              /* unique GType the device factory or 0 if not loaded */

  volatile GstDeviceProvider *provider;
  gpointer                   metadata;

  gpointer _gst_reserved[GST_PADDING];
};

struct _GstDeviceProviderFactoryClass {
  GstPluginFeatureClass         parent;
  /* <private> */

  gpointer _gst_reserved[GST_PADDING];
};

G_END_DECLS
#endif /* __GST_PRIVATE_H__ */
