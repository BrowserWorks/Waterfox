/* GStreamer
 * Copyright (C) <2007> Wim Taymans <wim.taymans@gmail.com>
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

/**
 * SECTION:element-uridecodebin
 *
 * Decodes data from a URI into raw media. It selects a source element that can
 * handle the given #GstURIDecodeBin:uri scheme and connects it to a decodebin.
 */

/* FIXME 0.11: suppress warnings for deprecated API such as GValueArray
 * with newer GLib versions (>= 2.31.0) */
#define GLIB_DISABLE_DEPRECATION_WARNINGS

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <string.h>

#include <gst/gst.h>
#include <gst/gst-i18n-plugin.h>
#include <gst/pbutils/missing-plugins.h>

#include "gstplay-enum.h"
#include "gstrawcaps.h"
#include "gstplayback.h"

/* From gstdecodebin2.c */
gint _decode_bin_compare_factories_func (gconstpointer p1, gconstpointer p2);

#define GST_TYPE_URI_DECODE_BIN \
  (gst_uri_decode_bin_get_type())
#define GST_URI_DECODE_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_URI_DECODE_BIN,GstURIDecodeBin))
#define GST_URI_DECODE_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_URI_DECODE_BIN,GstURIDecodeBinClass))
#define GST_IS_URI_DECODE_BIN(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_URI_DECODE_BIN))
#define GST_IS_URI_DECODE_BIN_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_URI_DECODE_BIN))
#define GST_URI_DECODE_BIN_CAST(obj) ((GstURIDecodeBin *) (obj))

typedef struct _GstURIDecodeBin GstURIDecodeBin;
typedef struct _GstURIDecodeBinClass GstURIDecodeBinClass;

#define GST_URI_DECODE_BIN_LOCK(dec) (g_mutex_lock(&((GstURIDecodeBin*)(dec))->lock))
#define GST_URI_DECODE_BIN_UNLOCK(dec) (g_mutex_unlock(&((GstURIDecodeBin*)(dec))->lock))

typedef struct _GstURIDecodeBinStream
{
  gulong probe_id;
  guint bitrate;
} GstURIDecodeBinStream;

/**
 * GstURIDecodeBin
 *
 * uridecodebin element struct
 */
struct _GstURIDecodeBin
{
  GstBin parent_instance;

  GMutex lock;                  /* lock for constructing */

  GMutex factories_lock;
  guint32 factories_cookie;
  GList *factories;             /* factories we can use for selecting elements */

  gchar *uri;
  guint64 connection_speed;
  GstCaps *caps;
  gchar *encoding;

  gboolean is_stream;
  gboolean is_adaptive;
  gboolean need_queue;
  guint64 buffer_duration;      /* When buffering, buffer duration (ns) */
  guint buffer_size;            /* When buffering, buffer size (bytes) */
  gboolean download;
  gboolean use_buffering;

  GstElement *source;
  GstElement *queue;
  GstElement *typefind;
  guint have_type_id;           /* have-type signal id from typefind */
  GSList *decodebins;
  GSList *pending_decodebins;
  GHashTable *streams;
  guint numpads;

  /* for dynamic sources */
  guint src_np_sig_id;          /* new-pad signal id */
  guint src_nmp_sig_id;         /* no-more-pads signal id */
  gint pending;

  gboolean async_pending;       /* async-start has been emitted */

  gboolean expose_allstreams;   /* Whether to expose unknow type streams or not */

  guint64 ring_buffer_max_size; /* 0 means disabled */
};

struct _GstURIDecodeBinClass
{
  GstBinClass parent_class;

  /* signal fired when we found a pad that we cannot decode */
  void (*unknown_type) (GstElement * element, GstPad * pad, GstCaps * caps);

  /* signal fired to know if we continue trying to decode the given caps */
    gboolean (*autoplug_continue) (GstElement * element, GstPad * pad,
      GstCaps * caps);
  /* signal fired to get a list of factories to try to autoplug */
  GValueArray *(*autoplug_factories) (GstElement * element, GstPad * pad,
      GstCaps * caps);
  /* signal fired to sort the factories */
  GValueArray *(*autoplug_sort) (GstElement * element, GstPad * pad,
      GstCaps * caps, GValueArray * factories);
  /* signal fired to select from the proposed list of factories */
    GstAutoplugSelectResult (*autoplug_select) (GstElement * element,
      GstPad * pad, GstCaps * caps, GstElementFactory * factory);
  /* signal fired when a autoplugged element that is not linked downstream
   * or exposed wants to query something */
    gboolean (*autoplug_query) (GstElement * element, GstPad * pad,
      GstQuery * query);

  /* emitted when all data is decoded */
  void (*drained) (GstElement * element);
};

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src_%u",
    GST_PAD_SRC,
    GST_PAD_SOMETIMES,
    GST_STATIC_CAPS_ANY);

static GstStaticCaps default_raw_caps = GST_STATIC_CAPS (DEFAULT_RAW_CAPS);

GST_DEBUG_CATEGORY_STATIC (gst_uri_decode_bin_debug);
#define GST_CAT_DEFAULT gst_uri_decode_bin_debug

/* signals */
enum
{
  SIGNAL_UNKNOWN_TYPE,
  SIGNAL_AUTOPLUG_CONTINUE,
  SIGNAL_AUTOPLUG_FACTORIES,
  SIGNAL_AUTOPLUG_SELECT,
  SIGNAL_AUTOPLUG_SORT,
  SIGNAL_AUTOPLUG_QUERY,
  SIGNAL_DRAINED,
  SIGNAL_SOURCE_SETUP,
  LAST_SIGNAL
};

/* properties */
#define DEFAULT_PROP_URI            NULL
#define DEFAULT_PROP_SOURCE         NULL
#define DEFAULT_CONNECTION_SPEED    0
#define DEFAULT_CAPS                (gst_static_caps_get (&default_raw_caps))
#define DEFAULT_SUBTITLE_ENCODING   NULL
#define DEFAULT_BUFFER_DURATION     -1
#define DEFAULT_BUFFER_SIZE         -1
#define DEFAULT_DOWNLOAD            FALSE
#define DEFAULT_USE_BUFFERING       FALSE
#define DEFAULT_EXPOSE_ALL_STREAMS  TRUE
#define DEFAULT_RING_BUFFER_MAX_SIZE 0

enum
{
  PROP_0,
  PROP_URI,
  PROP_SOURCE,
  PROP_CONNECTION_SPEED,
  PROP_CAPS,
  PROP_SUBTITLE_ENCODING,
  PROP_BUFFER_SIZE,
  PROP_BUFFER_DURATION,
  PROP_DOWNLOAD,
  PROP_USE_BUFFERING,
  PROP_EXPOSE_ALL_STREAMS,
  PROP_RING_BUFFER_MAX_SIZE,
  PROP_LAST
};

static guint gst_uri_decode_bin_signals[LAST_SIGNAL] = { 0 };

GType gst_uri_decode_bin_get_type (void);
#define gst_uri_decode_bin_parent_class parent_class
G_DEFINE_TYPE (GstURIDecodeBin, gst_uri_decode_bin, GST_TYPE_BIN);

static void remove_decoders (GstURIDecodeBin * bin, gboolean force);
static void gst_uri_decode_bin_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_uri_decode_bin_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_uri_decode_bin_finalize (GObject * obj);

static void handle_message (GstBin * bin, GstMessage * msg);

static gboolean gst_uri_decode_bin_query (GstElement * element,
    GstQuery * query);
static GstStateChangeReturn gst_uri_decode_bin_change_state (GstElement *
    element, GstStateChange transition);

static gboolean
_gst_boolean_accumulator (GSignalInvocationHint * ihint,
    GValue * return_accu, const GValue * handler_return, gpointer dummy)
{
  gboolean myboolean;

  myboolean = g_value_get_boolean (handler_return);
  if (!(ihint->run_type & G_SIGNAL_RUN_CLEANUP))
    g_value_set_boolean (return_accu, myboolean);

  /* stop emission if FALSE */
  return myboolean;
}

static gboolean
_gst_boolean_or_accumulator (GSignalInvocationHint * ihint,
    GValue * return_accu, const GValue * handler_return, gpointer dummy)
{
  gboolean myboolean;
  gboolean retboolean;

  myboolean = g_value_get_boolean (handler_return);
  retboolean = g_value_get_boolean (return_accu);

  if (!(ihint->run_type & G_SIGNAL_RUN_CLEANUP))
    g_value_set_boolean (return_accu, myboolean || retboolean);

  return TRUE;
}

static gboolean
_gst_array_accumulator (GSignalInvocationHint * ihint,
    GValue * return_accu, const GValue * handler_return, gpointer dummy)
{
  gpointer array;

  array = g_value_get_boxed (handler_return);
  if (!(ihint->run_type & G_SIGNAL_RUN_CLEANUP))
    g_value_set_boxed (return_accu, array);

  return FALSE;
}

static gboolean
_gst_select_accumulator (GSignalInvocationHint * ihint,
    GValue * return_accu, const GValue * handler_return, gpointer dummy)
{
  GstAutoplugSelectResult res;

  res = g_value_get_enum (handler_return);
  if (!(ihint->run_type & G_SIGNAL_RUN_CLEANUP))
    g_value_set_enum (return_accu, res);

  /* Call the next handler in the chain (if any) when the current callback
   * returns TRY. This makes it possible to register separate autoplug-select
   * handlers that implement different TRY/EXPOSE/SKIP strategies.
   */
  if (res == GST_AUTOPLUG_SELECT_TRY)
    return TRUE;

  return FALSE;
}

static gboolean
_gst_array_hasvalue_accumulator (GSignalInvocationHint * ihint,
    GValue * return_accu, const GValue * handler_return, gpointer dummy)
{
  gpointer array;

  array = g_value_get_boxed (handler_return);
  if (!(ihint->run_type & G_SIGNAL_RUN_CLEANUP))
    g_value_set_boxed (return_accu, array);

  if (array != NULL)
    return FALSE;

  return TRUE;
}

static gboolean
gst_uri_decode_bin_autoplug_continue (GstElement * element, GstPad * pad,
    GstCaps * caps)
{
  /* by default we always continue */
  return TRUE;
}

/* Must be called with factories lock! */
static void
gst_uri_decode_bin_update_factories_list (GstURIDecodeBin * dec)
{
  guint32 cookie;

  cookie = gst_registry_get_feature_list_cookie (gst_registry_get ());
  if (!dec->factories || dec->factories_cookie != cookie) {
    if (dec->factories)
      gst_plugin_feature_list_free (dec->factories);
    dec->factories =
        gst_element_factory_list_get_elements
        (GST_ELEMENT_FACTORY_TYPE_DECODABLE, GST_RANK_MARGINAL);
    dec->factories =
        g_list_sort (dec->factories, _decode_bin_compare_factories_func);
    dec->factories_cookie = cookie;
  }
}

static GValueArray *
gst_uri_decode_bin_autoplug_factories (GstElement * element, GstPad * pad,
    GstCaps * caps)
{
  GList *list, *tmp;
  GValueArray *result;
  GstURIDecodeBin *dec = GST_URI_DECODE_BIN_CAST (element);

  GST_DEBUG_OBJECT (element, "finding factories");

  /* return all compatible factories for caps */
  g_mutex_lock (&dec->factories_lock);
  gst_uri_decode_bin_update_factories_list (dec);
  list =
      gst_element_factory_list_filter (dec->factories, caps, GST_PAD_SINK,
      gst_caps_is_fixed (caps));
  g_mutex_unlock (&dec->factories_lock);

  result = g_value_array_new (g_list_length (list));
  for (tmp = list; tmp; tmp = tmp->next) {
    GstElementFactory *factory = GST_ELEMENT_FACTORY_CAST (tmp->data);
    GValue val = { 0, };

    g_value_init (&val, G_TYPE_OBJECT);
    g_value_set_object (&val, factory);
    g_value_array_append (result, &val);
    g_value_unset (&val);
  }
  gst_plugin_feature_list_free (list);

  GST_DEBUG_OBJECT (element, "autoplug-factories returns %p", result);

  return result;
}

static GValueArray *
gst_uri_decode_bin_autoplug_sort (GstElement * element, GstPad * pad,
    GstCaps * caps, GValueArray * factories)
{
  return NULL;
}

static GstAutoplugSelectResult
gst_uri_decode_bin_autoplug_select (GstElement * element, GstPad * pad,
    GstCaps * caps, GstElementFactory * factory)
{
  GST_DEBUG_OBJECT (element, "default autoplug-select returns TRY");

  /* Try factory. */
  return GST_AUTOPLUG_SELECT_TRY;
}

static gboolean
gst_uri_decode_bin_autoplug_query (GstElement * element, GstPad * pad,
    GstQuery * query)
{
  /* No query handled here */
  return FALSE;
}

static void
gst_uri_decode_bin_class_init (GstURIDecodeBinClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBinClass *gstbin_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbin_class = GST_BIN_CLASS (klass);

  gobject_class->set_property = gst_uri_decode_bin_set_property;
  gobject_class->get_property = gst_uri_decode_bin_get_property;
  gobject_class->finalize = gst_uri_decode_bin_finalize;

  g_object_class_install_property (gobject_class, PROP_URI,
      g_param_spec_string ("uri", "URI", "URI to decode",
          DEFAULT_PROP_URI, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SOURCE,
      g_param_spec_object ("source", "Source", "Source object used",
          GST_TYPE_ELEMENT, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_CONNECTION_SPEED,
      g_param_spec_uint64 ("connection-speed", "Connection Speed",
          "Network connection speed in kbps (0 = unknown)",
          0, G_MAXUINT64 / 1000, DEFAULT_CONNECTION_SPEED,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_CAPS,
      g_param_spec_boxed ("caps", "Caps",
          "The caps on which to stop decoding. (NULL = default)",
          GST_TYPE_CAPS, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SUBTITLE_ENCODING,
      g_param_spec_string ("subtitle-encoding", "subtitle encoding",
          "Encoding to assume if input subtitles are not in UTF-8 encoding. "
          "If not set, the GST_SUBTITLE_ENCODING environment variable will "
          "be checked for an encoding to use. If that is not set either, "
          "ISO-8859-15 will be assumed.", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_BUFFER_SIZE,
      g_param_spec_int ("buffer-size", "Buffer size (bytes)",
          "Buffer size when buffering streams (-1 default value)",
          -1, G_MAXINT, DEFAULT_BUFFER_SIZE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BUFFER_DURATION,
      g_param_spec_int64 ("buffer-duration", "Buffer duration (ns)",
          "Buffer duration when buffering streams (-1 default value)",
          -1, G_MAXINT64, DEFAULT_BUFFER_DURATION,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstURIDecodeBin::download:
   *
   * For certain media type, enable download buffering.
   */
  g_object_class_install_property (gobject_class, PROP_DOWNLOAD,
      g_param_spec_boolean ("download", "Download",
          "Attempt download buffering when buffering network streams",
          DEFAULT_DOWNLOAD, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstURIDecodeBin::use-buffering:
   *
   * Emit BUFFERING messages based on low-/high-percent thresholds of the
   * demuxed or parsed data.
   * When download buffering is activated and used for the current media
   * type, this property does nothing. Otherwise perform buffering on the
   * demuxed or parsed media.
   *
   * Since: 0.10.26
   */
  g_object_class_install_property (gobject_class, PROP_USE_BUFFERING,
      g_param_spec_boolean ("use-buffering", "Use Buffering",
          "Perform buffering on demuxed/parsed media",
          DEFAULT_USE_BUFFERING, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstURIDecodeBin::expose-all-streams
   *
   * Expose streams of unknown type.
   *
   * If set to %FALSE, then only the streams that can be decoded to the final
   * caps (see 'caps' property) will have a pad exposed. Streams that do not
   * match those caps but could have been decoded will not have decoder plugged
   * in internally and will not have a pad exposed. 
   *
   * Since: 0.10.30
   */
  g_object_class_install_property (gobject_class, PROP_EXPOSE_ALL_STREAMS,
      g_param_spec_boolean ("expose-all-streams", "Expose All Streams",
          "Expose all streams, including those of unknown type or that don't match the 'caps' property",
          DEFAULT_EXPOSE_ALL_STREAMS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstURIDecodeBin::ring-buffer-max-size
   *
   * The maximum size of the ring buffer in kilobytes. If set to 0, the ring
   * buffer is disabled. Default is 0.
   *
   * Since: 0.10.31
   */
  g_object_class_install_property (gobject_class, PROP_RING_BUFFER_MAX_SIZE,
      g_param_spec_uint64 ("ring-buffer-max-size",
          "Max. ring buffer size (bytes)",
          "Max. amount of data in the ring buffer (bytes, 0 = ring buffer disabled)",
          0, G_MAXUINT, DEFAULT_RING_BUFFER_MAX_SIZE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstURIDecodeBin::unknown-type:
   * @bin: The uridecodebin.
   * @pad: the new pad containing caps that cannot be resolved to a 'final'.
   * stream type.
   * @caps: the #GstCaps of the pad that cannot be resolved.
   *
   * This signal is emitted when a pad for which there is no further possible
   * decoding is added to the uridecodebin.
   */
  gst_uri_decode_bin_signals[SIGNAL_UNKNOWN_TYPE] =
      g_signal_new ("unknown-type", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstURIDecodeBinClass, unknown_type),
      NULL, NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 2,
      GST_TYPE_PAD, GST_TYPE_CAPS);

  /**
   * GstURIDecodeBin::autoplug-continue:
   * @bin: The uridecodebin.
   * @pad: The #GstPad.
   * @caps: The #GstCaps found.
   *
   * This signal is emitted whenever uridecodebin finds a new stream. It is
   * emitted before looking for any elements that can handle that stream.
   *
   * <note>
   *   Invocation of signal handlers stops after the first signal handler
   *   returns #FALSE. Signal handlers are invoked in the order they were
   *   connected in.
   * </note>
   *
   * Returns: #TRUE if you wish uridecodebin to look for elements that can
   * handle the given @caps. If #FALSE, those caps will be considered as
   * final and the pad will be exposed as such (see 'pad-added' signal of
   * #GstElement).
   */
  gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_CONTINUE] =
      g_signal_new ("autoplug-continue", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstURIDecodeBinClass,
          autoplug_continue), _gst_boolean_accumulator, NULL,
      g_cclosure_marshal_generic, G_TYPE_BOOLEAN, 2, GST_TYPE_PAD,
      GST_TYPE_CAPS);

  /**
   * GstURIDecodeBin::autoplug-factories:
   * @bin: The uridecodebin.
   * @pad: The #GstPad.
   * @caps: The #GstCaps found.
   *
   * This function is emitted when an array of possible factories for @caps on
   * @pad is needed. Uridecodebin will by default return an array with all
   * compatible factories, sorted by rank.
   *
   * If this function returns NULL, @pad will be exposed as a final caps.
   *
   * If this function returns an empty array, the pad will be considered as
   * having an unhandled type media type.
   *
   * <note>
   *   Only the signal handler that is connected first will ever by invoked.
   *   Don't connect signal handlers with the #G_CONNECT_AFTER flag to this
   *   signal, they will never be invoked!
   * </note>
   *
   * Returns: a #GValueArray* with a list of factories to try. The factories are
   * by default tried in the returned order or based on the index returned by
   * "autoplug-select".
   */
  gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_FACTORIES] =
      g_signal_new ("autoplug-factories", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstURIDecodeBinClass,
          autoplug_factories), _gst_array_accumulator, NULL,
      g_cclosure_marshal_generic, G_TYPE_VALUE_ARRAY, 2,
      GST_TYPE_PAD, GST_TYPE_CAPS);

  /**
   * GstURIDecodeBin::autoplug-sort:
   * @bin: The uridecodebin.
   * @pad: The #GstPad.
   * @caps: The #GstCaps.
   * @factories: A #GValueArray of possible #GstElementFactory to use.
   *
   * Once decodebin has found the possible #GstElementFactory objects to try
   * for @caps on @pad, this signal is emited. The purpose of the signal is for
   * the application to perform additional sorting or filtering on the element
   * factory array.
   *
   * The callee should copy and modify @factories or return #NULL if the
   * order should not change.
   *
   * <note>
   *   Invocation of signal handlers stops after one signal handler has
   *   returned something else than #NULL. Signal handlers are invoked in
   *   the order they were connected in.
   *   Don't connect signal handlers with the #G_CONNECT_AFTER flag to this
   *   signal, they will never be invoked!
   * </note>
   *
   * Returns: A new sorted array of #GstElementFactory objects.
   *
   * Since: 0.10.33
   */
  gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_SORT] =
      g_signal_new ("autoplug-sort", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstURIDecodeBinClass, autoplug_sort),
      _gst_array_hasvalue_accumulator, NULL,
      g_cclosure_marshal_generic, G_TYPE_VALUE_ARRAY, 3, GST_TYPE_PAD,
      GST_TYPE_CAPS, G_TYPE_VALUE_ARRAY | G_SIGNAL_TYPE_STATIC_SCOPE);

  /**
   * GstURIDecodeBin::autoplug-select:
   * @bin: The uridecodebin.
   * @pad: The #GstPad.
   * @caps: The #GstCaps.
   * @factory: A #GstElementFactory to use.
   *
   * This signal is emitted once uridecodebin has found all the possible
   * #GstElementFactory that can be used to handle the given @caps. For each of
   * those factories, this signal is emitted.
   *
   * The signal handler should return a #GST_TYPE_AUTOPLUG_SELECT_RESULT enum
   * value indicating what decodebin should do next.
   *
   * A value of #GST_AUTOPLUG_SELECT_TRY will try to autoplug an element from
   * @factory.
   *
   * A value of #GST_AUTOPLUG_SELECT_EXPOSE will expose @pad without plugging
   * any element to it.
   *
   * A value of #GST_AUTOPLUG_SELECT_SKIP will skip @factory and move to the
   * next factory.
   *
   * <note>
   *   The signal handler will not be invoked if any of the previously
   *   registered signal handlers (if any) return a value other than
   *   GST_AUTOPLUG_SELECT_TRY. Which also means that if you return
   *   GST_AUTOPLUG_SELECT_TRY from one signal handler, handlers that get
   *   registered next (again, if any) can override that decision.
   * </note>
   *
   * Returns: a #GST_TYPE_AUTOPLUG_SELECT_RESULT that indicates the required
   * operation. The default handler will always return
   * #GST_AUTOPLUG_SELECT_TRY.
   */
  gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_SELECT] =
      g_signal_new ("autoplug-select", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstURIDecodeBinClass,
          autoplug_select), _gst_select_accumulator, NULL,
      g_cclosure_marshal_generic,
      GST_TYPE_AUTOPLUG_SELECT_RESULT, 3, GST_TYPE_PAD, GST_TYPE_CAPS,
      GST_TYPE_ELEMENT_FACTORY);

  /**
   * GstDecodeBin::autoplug-query:
   * @bin: The decodebin.
   * @child: The child element doing the query
   * @pad: The #GstPad.
   * @query: The #GstQuery.
   *
   * This signal is emitted whenever an autoplugged element that is
   * not linked downstream yet and not exposed does a query. It can
   * be used to tell the element about the downstream supported caps
   * for example.
   *
   * Returns: #TRUE if the query was handled, #FALSE otherwise.
   */
  gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_QUERY] =
      g_signal_new ("autoplug-query", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstURIDecodeBinClass, autoplug_query),
      _gst_boolean_or_accumulator, NULL, g_cclosure_marshal_generic,
      G_TYPE_BOOLEAN, 3, GST_TYPE_PAD, GST_TYPE_ELEMENT,
      GST_TYPE_QUERY | G_SIGNAL_TYPE_STATIC_SCOPE);

  /**
   * GstURIDecodeBin::drained:
   *
   * This signal is emitted when the data for the current uri is played.
   */
  gst_uri_decode_bin_signals[SIGNAL_DRAINED] =
      g_signal_new ("drained", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstURIDecodeBinClass, drained), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 0, G_TYPE_NONE);

  /**
   * GstURIDecodeBin::source-setup:
   * @bin: the uridecodebin.
   * @source: source element
   *
   * This signal is emitted after the source element has been created, so
   * it can be configured by setting additional properties (e.g. set a
   * proxy server for an http source, or set the device and read speed for
   * an audio cd source). This is functionally equivalent to connecting to
   * the notify::source signal, but more convenient.
   *
   * Since: 0.10.33
   */
  gst_uri_decode_bin_signals[SIGNAL_SOURCE_SETUP] =
      g_signal_new ("source-setup", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_ELEMENT);

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_set_static_metadata (gstelement_class,
      "URI Decoder", "Generic/Bin/Decoder",
      "Autoplug and decode an URI to raw media",
      "Wim Taymans <wim.taymans@gmail.com>");

  gstelement_class->query = GST_DEBUG_FUNCPTR (gst_uri_decode_bin_query);
  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_uri_decode_bin_change_state);

  gstbin_class->handle_message = GST_DEBUG_FUNCPTR (handle_message);

  klass->autoplug_continue =
      GST_DEBUG_FUNCPTR (gst_uri_decode_bin_autoplug_continue);
  klass->autoplug_factories =
      GST_DEBUG_FUNCPTR (gst_uri_decode_bin_autoplug_factories);
  klass->autoplug_sort = GST_DEBUG_FUNCPTR (gst_uri_decode_bin_autoplug_sort);
  klass->autoplug_select =
      GST_DEBUG_FUNCPTR (gst_uri_decode_bin_autoplug_select);
  klass->autoplug_query = GST_DEBUG_FUNCPTR (gst_uri_decode_bin_autoplug_query);
}

static void
gst_uri_decode_bin_init (GstURIDecodeBin * dec)
{
  /* first filter out the interesting element factories */
  g_mutex_init (&dec->factories_lock);

  g_mutex_init (&dec->lock);

  dec->uri = g_strdup (DEFAULT_PROP_URI);
  dec->connection_speed = DEFAULT_CONNECTION_SPEED;
  dec->caps = DEFAULT_CAPS;
  dec->encoding = g_strdup (DEFAULT_SUBTITLE_ENCODING);

  dec->buffer_duration = DEFAULT_BUFFER_DURATION;
  dec->buffer_size = DEFAULT_BUFFER_SIZE;
  dec->download = DEFAULT_DOWNLOAD;
  dec->use_buffering = DEFAULT_USE_BUFFERING;
  dec->expose_allstreams = DEFAULT_EXPOSE_ALL_STREAMS;
  dec->ring_buffer_max_size = DEFAULT_RING_BUFFER_MAX_SIZE;

  GST_OBJECT_FLAG_SET (dec, GST_ELEMENT_FLAG_SOURCE);
}

static void
gst_uri_decode_bin_finalize (GObject * obj)
{
  GstURIDecodeBin *dec = GST_URI_DECODE_BIN (obj);

  remove_decoders (dec, TRUE);
  g_mutex_clear (&dec->lock);
  g_mutex_clear (&dec->factories_lock);
  g_free (dec->uri);
  g_free (dec->encoding);
  if (dec->factories)
    gst_plugin_feature_list_free (dec->factories);
  if (dec->caps)
    gst_caps_unref (dec->caps);

  G_OBJECT_CLASS (parent_class)->finalize (obj);
}

static void
gst_uri_decode_bin_set_encoding (GstURIDecodeBin * dec, const gchar * encoding)
{
  GSList *walk;

  GST_URI_DECODE_BIN_LOCK (dec);

  /* set property first */
  GST_OBJECT_LOCK (dec);
  g_free (dec->encoding);
  dec->encoding = g_strdup (encoding);
  GST_OBJECT_UNLOCK (dec);

  /* set the property on all decodebins now */
  for (walk = dec->decodebins; walk; walk = g_slist_next (walk)) {
    GObject *decodebin = G_OBJECT (walk->data);

    g_object_set (decodebin, "subtitle-encoding", encoding, NULL);
  }
  GST_URI_DECODE_BIN_UNLOCK (dec);
}

static void
gst_uri_decode_bin_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstURIDecodeBin *dec = GST_URI_DECODE_BIN (object);

  switch (prop_id) {
    case PROP_URI:
      GST_OBJECT_LOCK (dec);
      g_free (dec->uri);
      dec->uri = g_value_dup_string (value);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_CONNECTION_SPEED:
      GST_OBJECT_LOCK (dec);
      dec->connection_speed = g_value_get_uint64 (value) * 1000;
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_CAPS:
      GST_OBJECT_LOCK (dec);
      if (dec->caps)
        gst_caps_unref (dec->caps);
      dec->caps = g_value_dup_boxed (value);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_SUBTITLE_ENCODING:
      gst_uri_decode_bin_set_encoding (dec, g_value_get_string (value));
      break;
    case PROP_BUFFER_SIZE:
      dec->buffer_size = g_value_get_int (value);
      break;
    case PROP_BUFFER_DURATION:
      dec->buffer_duration = g_value_get_int64 (value);
      break;
    case PROP_DOWNLOAD:
      dec->download = g_value_get_boolean (value);
      break;
    case PROP_USE_BUFFERING:
      dec->use_buffering = g_value_get_boolean (value);
      break;
    case PROP_EXPOSE_ALL_STREAMS:
      dec->expose_allstreams = g_value_get_boolean (value);
      break;
    case PROP_RING_BUFFER_MAX_SIZE:
      dec->ring_buffer_max_size = g_value_get_uint64 (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_uri_decode_bin_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstURIDecodeBin *dec = GST_URI_DECODE_BIN (object);

  switch (prop_id) {
    case PROP_URI:
      GST_OBJECT_LOCK (dec);
      g_value_set_string (value, dec->uri);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_SOURCE:
      GST_OBJECT_LOCK (dec);
      g_value_set_object (value, dec->source);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_CONNECTION_SPEED:
      GST_OBJECT_LOCK (dec);
      g_value_set_uint64 (value, dec->connection_speed / 1000);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_CAPS:
      GST_OBJECT_LOCK (dec);
      g_value_set_boxed (value, dec->caps);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_SUBTITLE_ENCODING:
      GST_OBJECT_LOCK (dec);
      g_value_set_string (value, dec->encoding);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_BUFFER_SIZE:
      GST_OBJECT_LOCK (dec);
      g_value_set_int (value, dec->buffer_size);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_BUFFER_DURATION:
      GST_OBJECT_LOCK (dec);
      g_value_set_int64 (value, dec->buffer_duration);
      GST_OBJECT_UNLOCK (dec);
      break;
    case PROP_DOWNLOAD:
      g_value_set_boolean (value, dec->download);
      break;
    case PROP_USE_BUFFERING:
      g_value_set_boolean (value, dec->use_buffering);
      break;
    case PROP_EXPOSE_ALL_STREAMS:
      g_value_set_boolean (value, dec->expose_allstreams);
      break;
    case PROP_RING_BUFFER_MAX_SIZE:
      g_value_set_uint64 (value, dec->ring_buffer_max_size);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
do_async_start (GstURIDecodeBin * dbin)
{
  GstMessage *message;

  dbin->async_pending = TRUE;

  message = gst_message_new_async_start (GST_OBJECT_CAST (dbin));
  GST_BIN_CLASS (parent_class)->handle_message (GST_BIN_CAST (dbin), message);
}

static void
do_async_done (GstURIDecodeBin * dbin)
{
  GstMessage *message;

  if (dbin->async_pending) {
    GST_DEBUG_OBJECT (dbin, "posting ASYNC_DONE");
    message =
        gst_message_new_async_done (GST_OBJECT_CAST (dbin),
        GST_CLOCK_TIME_NONE);
    GST_BIN_CLASS (parent_class)->handle_message (GST_BIN_CAST (dbin), message);

    dbin->async_pending = FALSE;
  }
}

#define DEFAULT_QUEUE_SIZE          (3 * GST_SECOND)
#define DEFAULT_QUEUE_MIN_THRESHOLD ((DEFAULT_QUEUE_SIZE * 30) / 100)
#define DEFAULT_QUEUE_THRESHOLD     ((DEFAULT_QUEUE_SIZE * 95) / 100)

static void
unknown_type_cb (GstElement * element, GstPad * pad, GstCaps * caps,
    GstURIDecodeBin * decoder)
{
  gchar *capsstr;

  capsstr = gst_caps_to_string (caps);
  GST_ELEMENT_WARNING (decoder, STREAM, CODEC_NOT_FOUND,
      (_("No decoder available for type \'%s\'."), capsstr), (NULL));
  g_free (capsstr);
}

/* add a streaminfo that indicates that the stream is handled by the
 * given element. This usually means that a stream without actual data is
 * produced but one that is sunken by an element. Examples of this are:
 * cdaudio, a hardware decoder/sink, dvd meta bins etc...
 */
static void
add_element_stream (GstElement * element, GstURIDecodeBin * decoder)
{
  g_warning ("add element stream");
}

/* when the decoder element signals that no more pads will be generated, we
 * can commit the current group.
 */
static void
no_more_pads_full (GstElement * element, gboolean subs,
    GstURIDecodeBin * decoder)
{
  gboolean final;

  /* setup phase */
  GST_DEBUG_OBJECT (element, "no more pads, %d pending", decoder->pending);

  GST_URI_DECODE_BIN_LOCK (decoder);
  final = (decoder->pending == 0);

  /* nothing pending, we can exit */
  if (final)
    goto done;

  /* the object has no pending no_more_pads */
  if (!g_object_get_data (G_OBJECT (element), "pending"))
    goto done;
  g_object_set_data (G_OBJECT (element), "pending", NULL);

  decoder->pending--;
  final = (decoder->pending == 0);

done:
  GST_URI_DECODE_BIN_UNLOCK (decoder);

  if (final) {
    /* If we got not a single stream yet, that means that all
     * decodebins had missing plugins for all of their streams!
     */
    if (!decoder->streams || g_hash_table_size (decoder->streams) == 0) {
      GST_ELEMENT_ERROR (decoder, CORE, MISSING_PLUGIN, (NULL),
          ("no suitable plugins found"));
    } else {
      gst_element_no_more_pads (GST_ELEMENT_CAST (decoder));
    }
  }

  return;
}

static void
no_more_pads (GstElement * element, GstURIDecodeBin * decoder)
{
  no_more_pads_full (element, FALSE, decoder);
}

static void
source_no_more_pads (GstElement * element, GstURIDecodeBin * bin)
{
  GST_DEBUG_OBJECT (bin, "No more pads in source element %s.",
      GST_ELEMENT_NAME (element));

  g_signal_handler_disconnect (element, bin->src_np_sig_id);
  bin->src_np_sig_id = 0;
  g_signal_handler_disconnect (element, bin->src_nmp_sig_id);
  bin->src_nmp_sig_id = 0;

  no_more_pads_full (element, FALSE, bin);
}

static void
configure_stream_buffering (GstURIDecodeBin * decoder)
{
  GstElement *queue = NULL;
  GHashTableIter iter;
  gpointer key, value;
  gint bitrate = 0;

  /* automatic configuration enabled ? */
  if (decoder->buffer_size != -1)
    return;

  GST_URI_DECODE_BIN_LOCK (decoder);
  if (decoder->queue)
    queue = gst_object_ref (decoder->queue);

  g_hash_table_iter_init (&iter, decoder->streams);
  while (g_hash_table_iter_next (&iter, &key, &value)) {
    GstURIDecodeBinStream *stream = value;

    if (stream->bitrate && bitrate >= 0)
      bitrate += stream->bitrate;
    else
      bitrate = -1;
  }
  GST_URI_DECODE_BIN_UNLOCK (decoder);

  GST_DEBUG_OBJECT (decoder, "overall bitrate %d", bitrate);
  if (!queue)
    return;

  if (bitrate > 0) {
    guint64 time;
    guint bytes;

    /* all streams have a bitrate;
     * configure queue size based on queue duration using combined bitrate */
    g_object_get (queue, "max-size-time", &time, NULL);
    GST_DEBUG_OBJECT (decoder, "queue buffering time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (time));
    if (time > 0) {
      bytes = gst_util_uint64_scale (time, bitrate, 8 * GST_SECOND);
      GST_DEBUG_OBJECT (decoder, "corresponds to buffer size %d", bytes);
      g_object_set (queue, "max-size-bytes", bytes, NULL);
    }
  }

  gst_object_unref (queue);
}

static GstPadProbeReturn
decoded_pad_event_probe (GstPad * pad, GstPadProbeInfo * info,
    gpointer user_data)
{
  GstEvent *event = GST_PAD_PROBE_INFO_EVENT (info);
  GstURIDecodeBin *decoder = user_data;

  GST_LOG_OBJECT (pad, "%s, decoder %p", GST_EVENT_TYPE_NAME (event), decoder);

  /* look for a bitrate tag */
  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_TAG:
    {
      GstTagList *list;
      guint bitrate = 0;
      GstURIDecodeBinStream *stream;

      gst_event_parse_tag (event, &list);
      if (!gst_tag_list_get_uint_index (list, GST_TAG_NOMINAL_BITRATE, 0,
              &bitrate)) {
        gst_tag_list_get_uint_index (list, GST_TAG_BITRATE, 0, &bitrate);
      }
      GST_DEBUG_OBJECT (pad, "found bitrate %u", bitrate);
      if (bitrate) {
        GST_URI_DECODE_BIN_LOCK (decoder);
        stream = g_hash_table_lookup (decoder->streams, pad);
        GST_URI_DECODE_BIN_UNLOCK (decoder);
        if (stream) {
          stream->bitrate = bitrate;
          /* no longer need this probe now */
          gst_pad_remove_probe (pad, stream->probe_id);
          /* configure buffer if possible */
          configure_stream_buffering (decoder);
        }
      }
      break;
    }
    default:
      break;
  }

  /* never drop */
  return GST_PAD_PROBE_OK;
}


static gboolean
copy_sticky_events (GstPad * pad, GstEvent ** event, gpointer user_data)
{
  GstPad *gpad = GST_PAD_CAST (user_data);

  GST_DEBUG_OBJECT (gpad, "store sticky event %" GST_PTR_FORMAT, *event);
  gst_pad_store_sticky_event (gpad, *event);

  return TRUE;
}

/* Called by the signal handlers when a decodebin has found a new raw pad */
static void
new_decoded_pad_added_cb (GstElement * element, GstPad * pad,
    GstURIDecodeBin * decoder)
{
  GstPad *newpad;
  GstPadTemplate *pad_tmpl;
  gchar *padname;
  GstURIDecodeBinStream *stream;

  GST_DEBUG_OBJECT (element, "new decoded pad, name: <%s>", GST_PAD_NAME (pad));

  GST_URI_DECODE_BIN_LOCK (decoder);
  padname = g_strdup_printf ("src_%u", decoder->numpads);
  decoder->numpads++;
  GST_URI_DECODE_BIN_UNLOCK (decoder);

  pad_tmpl = gst_static_pad_template_get (&srctemplate);
  newpad = gst_ghost_pad_new_from_template (padname, pad, pad_tmpl);
  gst_object_unref (pad_tmpl);
  g_free (padname);

  /* store ref to the ghostpad so we can remove it */
  g_object_set_data (G_OBJECT (pad), "uridecodebin.ghostpad", newpad);

  /* add event probe to monitor tags */
  stream = g_slice_alloc0 (sizeof (GstURIDecodeBinStream));
  stream->probe_id =
      gst_pad_add_probe (pad, GST_PAD_PROBE_TYPE_EVENT_DOWNSTREAM,
      decoded_pad_event_probe, decoder, NULL);
  GST_URI_DECODE_BIN_LOCK (decoder);
  g_hash_table_insert (decoder->streams, pad, stream);
  GST_URI_DECODE_BIN_UNLOCK (decoder);

  gst_pad_set_active (newpad, TRUE);
  gst_pad_sticky_events_foreach (pad, copy_sticky_events, newpad);
  gst_element_add_pad (GST_ELEMENT_CAST (decoder), newpad);
}

static GstPadProbeReturn
source_pad_event_probe (GstPad * pad, GstPadProbeInfo * info,
    gpointer user_data)
{
  GstEvent *event = GST_PAD_PROBE_INFO_EVENT (info);
  GstURIDecodeBin *decoder = user_data;

  GST_LOG_OBJECT (pad, "%s, decoder %p", GST_EVENT_TYPE_NAME (event), decoder);

  if (GST_EVENT_TYPE (event) == GST_EVENT_EOS) {
    GST_DEBUG_OBJECT (pad, "we received EOS");

    g_signal_emit (decoder,
        gst_uri_decode_bin_signals[SIGNAL_DRAINED], 0, NULL);
  }
  /* never drop events */
  return GST_PAD_PROBE_OK;
}

/* called when we found a raw pad on the source element. We need to set up a
 * padprobe to detect EOS before exposing the pad. */
static void
expose_decoded_pad (GstElement * element, GstPad * pad,
    GstURIDecodeBin * decoder)
{
  gst_pad_add_probe (pad, GST_PAD_PROBE_TYPE_EVENT_DOWNSTREAM,
      source_pad_event_probe, decoder, NULL);

  new_decoded_pad_added_cb (element, pad, decoder);
}

static void
pad_removed_cb (GstElement * element, GstPad * pad, GstURIDecodeBin * decoder)
{
  GstPad *ghost;

  GST_DEBUG_OBJECT (element, "pad removed name: <%s:%s>",
      GST_DEBUG_PAD_NAME (pad));

  /* we only care about srcpads */
  if (!GST_PAD_IS_SRC (pad))
    return;

  if (!(ghost = g_object_get_data (G_OBJECT (pad), "uridecodebin.ghostpad")))
    goto no_ghost;

  /* unghost the pad */
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (ghost), NULL);

  /* deactivate and remove */
  gst_pad_set_active (pad, FALSE);
  gst_element_remove_pad (GST_ELEMENT_CAST (decoder), ghost);

  return;

  /* ERRORS */
no_ghost:
  {
    GST_WARNING_OBJECT (element, "no ghost pad found");
    return;
  }
}

/* helper function to lookup stuff in lists */
static gboolean
array_has_value (const gchar * values[], const gchar * value)
{
  gint i;

  for (i = 0; values[i]; i++) {
    if (g_str_has_prefix (value, values[i]))
      return TRUE;
  }
  return FALSE;
}

static gboolean
array_has_uri_value (const gchar * values[], const gchar * value)
{
  gint i;

  for (i = 0; values[i]; i++) {
    if (!g_ascii_strncasecmp (value, values[i], strlen (values[i])))
      return TRUE;
  }
  return FALSE;
}

/* list of URIs that we consider to be streams and that need buffering.
 * We have no mechanism yet to figure this out with a query. */
static const gchar *stream_uris[] = { "http://", "https://", "mms://",
  "mmsh://", "mmsu://", "mmst://", "fd://", "myth://", "ssh://",
  "ftp://", "sftp://",
  NULL
};

/* list of URIs that need a queue because they are pretty bursty */
static const gchar *queue_uris[] = { "cdda://", NULL };

/* blacklisted URIs, we know they will always fail. */
static const gchar *blacklisted_uris[] = { NULL };

/* media types that use adaptive streaming */
static const gchar *adaptive_media[] = {
  "application/x-hls", "application/x-smoothstreaming-manifest",
  "application/dash+xml", NULL
};

#define IS_STREAM_URI(uri)          (array_has_uri_value (stream_uris, uri))
#define IS_QUEUE_URI(uri)           (array_has_uri_value (queue_uris, uri))
#define IS_BLACKLISTED_URI(uri)     (array_has_uri_value (blacklisted_uris, uri))
#define IS_ADAPTIVE_MEDIA(media)    (array_has_value (adaptive_media, media))

/*
 * Generate and configure a source element.
 */
static GstElement *
gen_source_element (GstURIDecodeBin * decoder)
{
  GObjectClass *source_class;
  GstElement *source;
  GParamSpec *pspec;
  GstQuery *query;
  GstSchedulingFlags flags;
  GError *err = NULL;

  if (!decoder->uri)
    goto no_uri;

  GST_LOG_OBJECT (decoder, "finding source for %s", decoder->uri);

  if (!gst_uri_is_valid (decoder->uri))
    goto invalid_uri;

  if (IS_BLACKLISTED_URI (decoder->uri))
    goto uri_blacklisted;

  source =
      gst_element_make_from_uri (GST_URI_SRC, decoder->uri, "source", &err);
  if (!source)
    goto no_source;

  GST_LOG_OBJECT (decoder, "found source type %s", G_OBJECT_TYPE_NAME (source));

  query = gst_query_new_scheduling ();
  if (gst_element_query (source, query)) {
    gst_query_parse_scheduling (query, &flags, NULL, NULL, NULL);
    decoder->is_stream = flags & GST_SCHEDULING_FLAG_BANDWIDTH_LIMITED;
  } else
    decoder->is_stream = IS_STREAM_URI (decoder->uri);
  gst_query_unref (query);

  GST_LOG_OBJECT (decoder, "source is stream: %d", decoder->is_stream);

  decoder->need_queue = IS_QUEUE_URI (decoder->uri);
  GST_LOG_OBJECT (decoder, "source needs queue: %d", decoder->need_queue);

  source_class = G_OBJECT_GET_CLASS (source);

  /* make HTTP sources send extra headers so we get icecast
   * metadata in case the stream is an icecast stream */
  if (!strncmp (decoder->uri, "http://", 7)) {
    pspec = g_object_class_find_property (source_class, "iradio-mode");

    if (pspec && G_PARAM_SPEC_VALUE_TYPE (pspec) == G_TYPE_STRING) {
      GST_LOG_OBJECT (decoder, "configuring iradio-mode");
      g_object_set (source, "iradio-mode", TRUE, NULL);
    }
  }

  pspec = g_object_class_find_property (source_class, "connection-speed");
  if (pspec != NULL) {
    guint64 speed = decoder->connection_speed / 1000;
    gboolean wrong_type = FALSE;

    if (G_PARAM_SPEC_TYPE (pspec) == G_TYPE_PARAM_UINT) {
      GParamSpecUInt *pspecuint = G_PARAM_SPEC_UINT (pspec);

      speed = CLAMP (speed, pspecuint->minimum, pspecuint->maximum);
    } else if (G_PARAM_SPEC_TYPE (pspec) == G_TYPE_PARAM_INT) {
      GParamSpecInt *pspecint = G_PARAM_SPEC_INT (pspec);

      speed = CLAMP (speed, pspecint->minimum, pspecint->maximum);
    } else if (G_PARAM_SPEC_TYPE (pspec) == G_TYPE_PARAM_UINT64) {
      GParamSpecUInt64 *pspecuint = G_PARAM_SPEC_UINT64 (pspec);

      speed = CLAMP (speed, pspecuint->minimum, pspecuint->maximum);
    } else if (G_PARAM_SPEC_TYPE (pspec) == G_TYPE_PARAM_INT64) {
      GParamSpecInt64 *pspecint = G_PARAM_SPEC_INT64 (pspec);

      speed = CLAMP (speed, pspecint->minimum, pspecint->maximum);
    } else {
      GST_WARNING_OBJECT (decoder,
          "The connection speed property %" G_GUINT64_FORMAT
          " of type %s is not usefull not setting it", speed,
          g_type_name (G_PARAM_SPEC_TYPE (pspec)));
      wrong_type = TRUE;
    }

    if (wrong_type == FALSE) {
      g_object_set (source, "connection-speed", speed, NULL);

      GST_DEBUG_OBJECT (decoder,
          "setting connection-speed=%" G_GUINT64_FORMAT " to source element",
          speed);
    }
  }

  pspec = g_object_class_find_property (source_class, "subtitle-encoding");
  if (pspec != NULL && G_PARAM_SPEC_VALUE_TYPE (pspec) == G_TYPE_STRING) {
    GST_DEBUG_OBJECT (decoder,
        "setting subtitle-encoding=%s to source element", decoder->encoding);
    g_object_set (source, "subtitle-encoding", decoder->encoding, NULL);
  }
  return source;

  /* ERRORS */
no_uri:
  {
    GST_ELEMENT_ERROR (decoder, RESOURCE, NOT_FOUND,
        (_("No URI specified to play from.")), (NULL));
    return NULL;
  }
invalid_uri:
  {
    GST_ELEMENT_ERROR (decoder, RESOURCE, NOT_FOUND,
        (_("Invalid URI \"%s\"."), decoder->uri), (NULL));
    g_clear_error (&err);
    return NULL;
  }
uri_blacklisted:
  {
    GST_ELEMENT_ERROR (decoder, RESOURCE, FAILED,
        (_("This stream type cannot be played yet.")), (NULL));
    return NULL;
  }
no_source:
  {
    /* whoops, could not create the source element, dig a little deeper to
     * figure out what might be wrong. */
    if (err != NULL && err->code == GST_URI_ERROR_UNSUPPORTED_PROTOCOL) {
      gchar *prot;

      prot = gst_uri_get_protocol (decoder->uri);
      if (prot == NULL)
        goto invalid_uri;

      gst_element_post_message (GST_ELEMENT_CAST (decoder),
          gst_missing_uri_source_message_new (GST_ELEMENT (decoder), prot));

      GST_ELEMENT_ERROR (decoder, CORE, MISSING_PLUGIN,
          (_("No URI handler implemented for \"%s\"."), prot), (NULL));

      g_free (prot);
    } else {
      GST_ELEMENT_ERROR (decoder, RESOURCE, NOT_FOUND,
          ("%s", (err) ? err->message : "URI was not accepted by any element"),
          ("No element accepted URI '%s'", decoder->uri));
    }

    g_clear_error (&err);
    return NULL;
  }
}

/**
 * has_all_raw_caps:
 * @pad: a #GstPad
 * @all_raw: pointer to hold the result
 *
 * check if the caps of the pad are all raw. The caps are all raw if
 * all of its structures contain audio/x-raw or video/x-raw.
 *
 * Returns: %FALSE @pad has no caps. Else TRUE and @all_raw set t the result.
 */
static gboolean
has_all_raw_caps (GstPad * pad, GstCaps * rawcaps, gboolean * all_raw)
{
  GstCaps *caps, *intersection;
  gint capssize;
  gboolean res = FALSE;

  caps = gst_pad_query_caps (pad, NULL);
  if (caps == NULL)
    return FALSE;

  GST_DEBUG_OBJECT (pad, "have caps %" GST_PTR_FORMAT, caps);

  capssize = gst_caps_get_size (caps);
  /* no caps, skip and move to the next pad */
  if (capssize == 0 || gst_caps_is_empty (caps) || gst_caps_is_any (caps))
    goto done;

  intersection = gst_caps_intersect (caps, rawcaps);
  *all_raw = !gst_caps_is_empty (intersection)
      && (gst_caps_get_size (intersection) == capssize);
  gst_caps_unref (intersection);

  res = TRUE;

done:
  gst_caps_unref (caps);
  return res;
}

static void
post_missing_plugin_error (GstElement * dec, const gchar * element_name)
{
  GstMessage *msg;

  msg = gst_missing_element_message_new (dec, element_name);
  gst_element_post_message (dec, msg);

  GST_ELEMENT_ERROR (dec, CORE, MISSING_PLUGIN,
      (_("Missing element '%s' - check your GStreamer installation."),
          element_name), (NULL));
}

/**
 * analyse_source:
 * @decoder: a #GstURIDecodeBin
 * @is_raw: are all pads raw data
 * @have_out: does the source have output
 * @is_dynamic: is this a dynamic source
 * @use_queue: put a queue before raw output pads
 *
 * Check the source of @decoder and collect information about it.
 *
 * @is_raw will be set to TRUE if the source only produces raw pads. When this
 * function returns, all of the raw pad of the source will be added
 * to @decoder.
 *
 * @have_out: will be set to TRUE if the source has output pads.
 *
 * @is_dynamic: TRUE if the element will create (more) pads dynamically later
 * on.
 *
 * Returns: FALSE if a fatal error occured while scanning.
 */
static gboolean
analyse_source (GstURIDecodeBin * decoder, gboolean * is_raw,
    gboolean * have_out, gboolean * is_dynamic, gboolean use_queue)
{
  GstIterator *pads_iter;
  gboolean done = FALSE;
  gboolean res = TRUE;
  GstCaps *rawcaps;
  GstPad *pad;
  GValue item = { 0, };

  *have_out = FALSE;
  *is_raw = FALSE;
  *is_dynamic = FALSE;

  g_object_get (decoder, "caps", &rawcaps, NULL);
  if (!rawcaps)
    rawcaps = DEFAULT_CAPS;

  pads_iter = gst_element_iterate_src_pads (decoder->source);
  while (!done) {
    switch (gst_iterator_next (pads_iter, &item)) {
      case GST_ITERATOR_ERROR:
        res = FALSE;
        /* FALLTROUGH */
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
      case GST_ITERATOR_RESYNC:
        /* reset results and resync */
        *have_out = FALSE;
        *is_raw = FALSE;
        *is_dynamic = FALSE;
        gst_iterator_resync (pads_iter);
        break;
      case GST_ITERATOR_OK:
        pad = g_value_dup_object (&item);
        /* we now officially have an ouput pad */
        *have_out = TRUE;

        /* if FALSE, this pad has no caps and we continue with the next pad. */
        if (!has_all_raw_caps (pad, rawcaps, is_raw)) {
          gst_object_unref (pad);
          g_value_reset (&item);
          break;
        }

        /* caps on source pad are all raw, we can add the pad */
        if (*is_raw) {
          GstElement *outelem;

          if (use_queue) {
            GstPad *sinkpad;

            /* insert a queue element right before the raw pad */
            outelem = gst_element_factory_make ("queue2", NULL);
            if (!outelem)
              goto no_queue2;

            gst_bin_add (GST_BIN_CAST (decoder), outelem);

            sinkpad = gst_element_get_static_pad (outelem, "sink");
            gst_pad_link (pad, sinkpad);
            gst_object_unref (sinkpad);

            /* save queue pointer so we can remove it later */
            decoder->queue = outelem;

            /* get the new raw srcpad */
            gst_object_unref (pad);
            pad = gst_element_get_static_pad (outelem, "src");
          } else {
            outelem = decoder->source;
          }
          expose_decoded_pad (outelem, pad, decoder);
        }
        gst_object_unref (pad);
        g_value_reset (&item);
        break;
    }
  }
  g_value_unset (&item);
  gst_iterator_free (pads_iter);
  gst_caps_unref (rawcaps);

  if (!*have_out) {
    GstElementClass *elemclass;
    GList *walk;

    /* element has no output pads, check for padtemplates that list SOMETIMES
     * pads. */
    elemclass = GST_ELEMENT_GET_CLASS (decoder->source);

    walk = gst_element_class_get_pad_template_list (elemclass);
    while (walk != NULL) {
      GstPadTemplate *templ;

      templ = (GstPadTemplate *) walk->data;
      if (GST_PAD_TEMPLATE_DIRECTION (templ) == GST_PAD_SRC) {
        if (GST_PAD_TEMPLATE_PRESENCE (templ) == GST_PAD_SOMETIMES)
          *is_dynamic = TRUE;
        break;
      }
      walk = g_list_next (walk);
    }
  }

  return res;
no_queue2:
  {
    post_missing_plugin_error (GST_ELEMENT_CAST (decoder), "queue2");

    gst_object_unref (pad);
    g_value_unset (&item);
    gst_iterator_free (pads_iter);
    gst_caps_unref (rawcaps);

    return FALSE;
  }
}

/* Remove all decodebin from ourself
 * If force is FALSE, then the decodebin instances will be stored in
 * pending_decodebins for re-use later on.
 * If force is TRUE, then all decodebin instances will be unreferenced
 * and cleared, including the pending ones. */
static void
remove_decoders (GstURIDecodeBin * bin, gboolean force)
{
  GSList *walk;

  for (walk = bin->decodebins; walk; walk = g_slist_next (walk)) {
    GstElement *decoder = GST_ELEMENT_CAST (walk->data);

    GST_DEBUG_OBJECT (bin, "removing old decoder element");
    if (force) {
      gst_element_set_state (decoder, GST_STATE_NULL);
      gst_bin_remove (GST_BIN_CAST (bin), decoder);
    } else {
      GstCaps *caps;

      gst_element_set_state (decoder, GST_STATE_READY);
      /* add it to our list of pending decodebins */
      g_object_ref (decoder);
      gst_bin_remove (GST_BIN_CAST (bin), decoder);
      /* restore some properties we might have changed */
      g_object_set (decoder, "sink-caps", NULL, NULL);
      caps = DEFAULT_CAPS;
      g_object_set (decoder, "caps", caps, NULL);
      gst_caps_unref (caps);
      /* make it freshly floating again */
      g_object_force_floating (G_OBJECT (decoder));

      bin->pending_decodebins =
          g_slist_prepend (bin->pending_decodebins, decoder);
    }
  }
  g_slist_free (bin->decodebins);
  bin->decodebins = NULL;
  if (force) {
    GSList *tmp;

    for (tmp = bin->pending_decodebins; tmp; tmp = tmp->next) {
      gst_element_set_state ((GstElement *) tmp->data, GST_STATE_NULL);
      gst_object_unref ((GstElement *) tmp->data);
    }
    g_slist_free (bin->pending_decodebins);
    bin->pending_decodebins = NULL;

  }

  /* Don't loose the SOURCE flag */
  GST_OBJECT_FLAG_SET (bin, GST_ELEMENT_FLAG_SOURCE);
}

static void
proxy_unknown_type_signal (GstElement * decodebin, GstPad * pad, GstCaps * caps,
    GstURIDecodeBin * dec)
{
  GST_DEBUG_OBJECT (dec, "unknown-type signaled");

  g_signal_emit (dec,
      gst_uri_decode_bin_signals[SIGNAL_UNKNOWN_TYPE], 0, pad, caps);
}

static gboolean
proxy_autoplug_continue_signal (GstElement * decodebin, GstPad * pad,
    GstCaps * caps, GstURIDecodeBin * dec)
{
  gboolean result;

  g_signal_emit (dec,
      gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_CONTINUE], 0, pad, caps,
      &result);

  GST_DEBUG_OBJECT (dec, "autoplug-continue returned %d", result);

  return result;
}

static GValueArray *
proxy_autoplug_factories_signal (GstElement * decodebin, GstPad * pad,
    GstCaps * caps, GstURIDecodeBin * dec)
{
  GValueArray *result;

  g_signal_emit (dec,
      gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_FACTORIES], 0, pad, caps,
      &result);

  GST_DEBUG_OBJECT (dec, "autoplug-factories returned %p", result);

  return result;
}

static GValueArray *
proxy_autoplug_sort_signal (GstElement * decodebin, GstPad * pad,
    GstCaps * caps, GValueArray * factories, GstURIDecodeBin * dec)
{
  GValueArray *result;

  g_signal_emit (dec,
      gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_SORT], 0, pad, caps,
      factories, &result);

  GST_DEBUG_OBJECT (dec, "autoplug-sort returned %p", result);

  return result;
}

static GstAutoplugSelectResult
proxy_autoplug_select_signal (GstElement * decodebin, GstPad * pad,
    GstCaps * caps, GstElementFactory * factory, GstURIDecodeBin * dec)
{
  GstAutoplugSelectResult result;

  g_signal_emit (dec,
      gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_SELECT], 0, pad, caps, factory,
      &result);

  GST_DEBUG_OBJECT (dec, "autoplug-select returned %d", result);

  return result;
}

static gboolean
proxy_autoplug_query_signal (GstElement * decodebin, GstPad * pad,
    GstElement * element, GstQuery * query, GstURIDecodeBin * dec)
{
  gboolean ret = FALSE;

  g_signal_emit (dec,
      gst_uri_decode_bin_signals[SIGNAL_AUTOPLUG_QUERY], 0, pad, element, query,
      &ret);

  GST_DEBUG_OBJECT (dec, "autoplug-query returned %d", ret);

  return ret;
}

static void
proxy_drained_signal (GstElement * decodebin, GstURIDecodeBin * dec)
{
  GST_DEBUG_OBJECT (dec, "drained signaled");

  g_signal_emit (dec, gst_uri_decode_bin_signals[SIGNAL_DRAINED], 0, NULL);
}

/* make a decodebin and connect to all the signals */
static GstElement *
make_decoder (GstURIDecodeBin * decoder)
{
  GstElement *decodebin;

  /* re-use pending decodebin */
  if (decoder->pending_decodebins) {
    GSList *first = decoder->pending_decodebins;
    GST_LOG_OBJECT (decoder, "re-using pending decodebin");
    decodebin = (GstElement *) first->data;
    decoder->pending_decodebins =
        g_slist_delete_link (decoder->pending_decodebins, first);
  } else {
    GST_LOG_OBJECT (decoder, "making new decodebin");

    /* now create the decoder element */
    decodebin = gst_element_factory_make ("decodebin", NULL);

    if (!decodebin)
      goto no_decodebin;

    /* sanity check */
    if (decodebin->numsinkpads == 0)
      goto no_typefind;

    /* connect signals to proxy */
    g_signal_connect (decodebin, "unknown-type",
        G_CALLBACK (proxy_unknown_type_signal), decoder);
    g_signal_connect (decodebin, "autoplug-continue",
        G_CALLBACK (proxy_autoplug_continue_signal), decoder);
    g_signal_connect (decodebin, "autoplug-factories",
        G_CALLBACK (proxy_autoplug_factories_signal), decoder);
    g_signal_connect (decodebin, "autoplug-sort",
        G_CALLBACK (proxy_autoplug_sort_signal), decoder);
    g_signal_connect (decodebin, "autoplug-select",
        G_CALLBACK (proxy_autoplug_select_signal), decoder);
    g_signal_connect (decodebin, "autoplug-query",
        G_CALLBACK (proxy_autoplug_query_signal), decoder);
    g_signal_connect (decodebin, "drained",
        G_CALLBACK (proxy_drained_signal), decoder);

    /* set up callbacks to create the links between decoded data
     * and video/audio/subtitle rendering/output. */
    g_signal_connect (decodebin,
        "pad-added", G_CALLBACK (new_decoded_pad_added_cb), decoder);
    g_signal_connect (decodebin,
        "pad-removed", G_CALLBACK (pad_removed_cb), decoder);
    g_signal_connect (decodebin, "no-more-pads",
        G_CALLBACK (no_more_pads), decoder);
    g_signal_connect (decodebin,
        "unknown-type", G_CALLBACK (unknown_type_cb), decoder);
  }

  /* configure caps if we have any */
  if (decoder->caps)
    g_object_set (decodebin, "caps", decoder->caps, NULL);

  /* Propagate expose-all-streams and connection-speed properties */
  g_object_set (decodebin, "expose-all-streams", decoder->expose_allstreams,
      "connection-speed", decoder->connection_speed / 1000, NULL);

  if (!decoder->is_stream || decoder->is_adaptive) {
    /* propagate the use-buffering property but only when we are not already
     * doing stream buffering with queue2. FIXME, we might want to do stream
     * buffering with the multiqueue buffering instead of queue2. */
    g_object_set (decodebin, "use-buffering", decoder->use_buffering
        || decoder->is_adaptive, NULL);

    if (decoder->use_buffering || decoder->is_adaptive) {
      guint max_bytes;
      guint64 max_time;

      /* configure sizes when buffering */
      if ((max_bytes = decoder->buffer_size) == -1)
        max_bytes = 2 * 1024 * 1024;
      if ((max_time = decoder->buffer_duration) == -1)
        max_time = 5 * GST_SECOND;

      g_object_set (decodebin, "max-size-bytes", max_bytes, "max-size-buffers",
          (guint) 0, "max-size-time", max_time, NULL);
    }
  }

  g_object_set_data (G_OBJECT (decodebin), "pending", GINT_TO_POINTER (1));
  g_object_set (decodebin, "subtitle-encoding", decoder->encoding, NULL);
  decoder->pending++;
  GST_LOG_OBJECT (decoder, "have %d pending dynamic objects", decoder->pending);

  gst_bin_add (GST_BIN_CAST (decoder), decodebin);

  decoder->decodebins = g_slist_prepend (decoder->decodebins, decodebin);

  return decodebin;

  /* ERRORS */
no_decodebin:
  {
    post_missing_plugin_error (GST_ELEMENT_CAST (decoder), "decodebin");
    GST_ELEMENT_ERROR (decoder, CORE, MISSING_PLUGIN, (NULL),
        ("No decodebin element, check your installation"));
    return NULL;
  }
no_typefind:
  {
    gst_object_unref (decodebin);
    GST_ELEMENT_ERROR (decoder, CORE, MISSING_PLUGIN, (NULL),
        ("No typefind element, decodebin is unusable, check your installation"));
    return NULL;
  }
}

/* signaled when we have a stream and we need to configure the download
 * buffering or regular buffering */
static void
type_found (GstElement * typefind, guint probability,
    GstCaps * caps, GstURIDecodeBin * decoder)
{
  GstElement *src_elem, *dec_elem, *queue = NULL;
  GstStructure *s;
  const gchar *media_type, *elem_name;
  gboolean do_download = FALSE;

  GST_DEBUG_OBJECT (decoder, "typefind found caps %" GST_PTR_FORMAT, caps);

  s = gst_caps_get_structure (caps, 0);
  media_type = gst_structure_get_name (s);

  decoder->is_adaptive = IS_ADAPTIVE_MEDIA (media_type);

  /* only enable download buffering if the upstream duration is known */
  if (decoder->download) {
    gint64 dur;

    do_download = (gst_element_query_duration (typefind, GST_FORMAT_BYTES, &dur)
        && dur != -1);
  }

  dec_elem = make_decoder (decoder);
  if (!dec_elem)
    goto no_decodebin;

  if (decoder->is_adaptive) {
    src_elem = typefind;
  } else {
    if (do_download) {
      elem_name = "downloadbuffer";
    } else {
      elem_name = "queue2";
    }
    queue = gst_element_factory_make (elem_name, NULL);
    if (!queue)
      goto no_buffer_element;

    decoder->queue = queue;

    GST_DEBUG_OBJECT (decoder, "check media-type %s, %d", media_type,
        do_download);

    if (do_download) {
      gchar *temp_template, *filename;
      const gchar *tmp_dir, *prgname;

      tmp_dir = g_get_user_cache_dir ();
      prgname = g_get_prgname ();
      if (prgname == NULL)
        prgname = "GStreamer";

      filename = g_strdup_printf ("%s-XXXXXX", prgname);

      /* build our filename */
      temp_template = g_build_filename (tmp_dir, filename, NULL);

      GST_DEBUG_OBJECT (decoder, "enable download buffering in %s (%s, %s, %s)",
          temp_template, tmp_dir, prgname, filename);

      /* configure progressive download for selected media types */
      g_object_set (queue, "temp-template", temp_template, NULL);

      g_free (filename);
      g_free (temp_template);
    } else {
      g_object_set (queue, "use-buffering", TRUE, NULL);
      g_object_set (queue, "ring-buffer-max-size",
          decoder->ring_buffer_max_size, NULL);
      /* Disable max-size-buffers */
      g_object_set (queue, "max-size-buffers", 0, NULL);
    }

    /* If buffer size or duration are set, set them on the element */
    if (decoder->buffer_size != -1)
      g_object_set (queue, "max-size-bytes", decoder->buffer_size, NULL);
    if (decoder->buffer_duration != -1)
      g_object_set (queue, "max-size-time", decoder->buffer_duration, NULL);

    gst_bin_add (GST_BIN_CAST (decoder), queue);

    if (!gst_element_link_pads (typefind, "src", queue, "sink"))
      goto could_not_link;
    src_elem = queue;
  }

  /* to force caps on the decodebin element and avoid reparsing stuff by
   * typefind. It also avoids a deadlock in the way typefind activates pads in
   * the state change */
  g_object_set (dec_elem, "sink-caps", caps, NULL);

  if (!gst_element_link_pads (src_elem, "src", dec_elem, "sink"))
    goto could_not_link;

  /* PLAYING in one go might fail (see bug #632782) */
  gst_element_set_state (dec_elem, GST_STATE_PAUSED);
  gst_element_set_state (dec_elem, GST_STATE_PLAYING);
  if (queue)
    gst_element_set_state (queue, GST_STATE_PLAYING);

  do_async_done (decoder);

  return;

  /* ERRORS */
no_decodebin:
  {
    /* error was posted */
    return;
  }
could_not_link:
  {
    GST_ELEMENT_ERROR (decoder, CORE, NEGOTIATION,
        (NULL), ("Can't link typefind to decodebin element"));
    return;
  }
no_buffer_element:
  {
    post_missing_plugin_error (GST_ELEMENT_CAST (decoder), elem_name);
    return;
  }
}

/* setup a streaming source. This will first plug a typefind element to the
 * source. After we find the type, we decide to plug a queue2 and continue to
 * plug a decodebin starting from the found caps */
static gboolean
setup_streaming (GstURIDecodeBin * decoder)
{
  GstElement *typefind;

  /* now create the decoder element */
  typefind = gst_element_factory_make ("typefind", NULL);
  if (!typefind)
    goto no_typefind;

  gst_bin_add (GST_BIN_CAST (decoder), typefind);

  if (!gst_element_link_pads (decoder->source, NULL, typefind, "sink"))
    goto could_not_link;

  decoder->typefind = typefind;

  /* connect a signal to find out when the typefind element found
   * a type */
  decoder->have_type_id =
      g_signal_connect (decoder->typefind, "have-type",
      G_CALLBACK (type_found), decoder);

  do_async_start (decoder);

  return TRUE;

  /* ERRORS */
no_typefind:
  {
    post_missing_plugin_error (GST_ELEMENT_CAST (decoder), "typefind");
    GST_ELEMENT_ERROR (decoder, CORE, MISSING_PLUGIN, (NULL),
        ("No typefind element, check your installation"));
    return FALSE;
  }
could_not_link:
  {
    GST_ELEMENT_ERROR (decoder, CORE, NEGOTIATION,
        (NULL), ("Can't link source to typefind element"));
    gst_bin_remove (GST_BIN_CAST (decoder), typefind);
    /* Don't loose the SOURCE flag */
    GST_OBJECT_FLAG_SET (decoder, GST_ELEMENT_FLAG_SOURCE);
    return FALSE;
  }
}

static void
free_stream (gpointer value)
{
  g_slice_free (GstURIDecodeBinStream, value);
}

/* remove source and all related elements */
static void
remove_source (GstURIDecodeBin * bin)
{
  GstElement *source = bin->source;

  if (source) {
    GST_DEBUG_OBJECT (bin, "removing old src element");
    gst_element_set_state (source, GST_STATE_NULL);

    if (bin->src_np_sig_id) {
      g_signal_handler_disconnect (source, bin->src_np_sig_id);
      bin->src_np_sig_id = 0;
    }
    if (bin->src_nmp_sig_id) {
      g_signal_handler_disconnect (source, bin->src_nmp_sig_id);
      bin->src_nmp_sig_id = 0;
    }
    gst_bin_remove (GST_BIN_CAST (bin), source);
    bin->source = NULL;
  }
  if (bin->queue) {
    GST_DEBUG_OBJECT (bin, "removing old queue element");
    gst_element_set_state (bin->queue, GST_STATE_NULL);
    gst_bin_remove (GST_BIN_CAST (bin), bin->queue);
    bin->queue = NULL;
  }
  if (bin->typefind) {
    GST_DEBUG_OBJECT (bin, "removing old typefind element");
    gst_element_set_state (bin->typefind, GST_STATE_NULL);
    gst_bin_remove (GST_BIN_CAST (bin), bin->typefind);
    bin->typefind = NULL;
  }
  if (bin->streams) {
    g_hash_table_destroy (bin->streams);
    bin->streams = NULL;
  }
  /* Don't loose the SOURCE flag */
  GST_OBJECT_FLAG_SET (bin, GST_ELEMENT_FLAG_SOURCE);
}

/* is called when a dynamic source element created a new pad. */
static void
source_new_pad (GstElement * element, GstPad * pad, GstURIDecodeBin * bin)
{
  GstElement *decoder;
  gboolean is_raw;
  GstCaps *rawcaps;

  GST_URI_DECODE_BIN_LOCK (bin);
  GST_DEBUG_OBJECT (bin, "Found new pad %s.%s in source element %s",
      GST_DEBUG_PAD_NAME (pad), GST_ELEMENT_NAME (element));

  g_object_get (bin, "caps", &rawcaps, NULL);
  if (!rawcaps)
    rawcaps = DEFAULT_CAPS;

  /* if this is a pad with all raw caps, we can expose it */
  if (has_all_raw_caps (pad, rawcaps, &is_raw) && is_raw) {
    /* it's all raw, create output pads. */
    GST_URI_DECODE_BIN_UNLOCK (bin);
    gst_caps_unref (rawcaps);
    expose_decoded_pad (element, pad, bin);
    return;
  }
  gst_caps_unref (rawcaps);

  /* not raw, create decoder */
  decoder = make_decoder (bin);
  if (!decoder)
    goto no_decodebin;

  /* and link to decoder */
  if (!gst_element_link_pads (bin->source, NULL, decoder, "sink"))
    goto could_not_link;

  GST_DEBUG_OBJECT (bin, "linked decoder to new pad");

  gst_element_set_state (decoder, GST_STATE_PLAYING);
  GST_URI_DECODE_BIN_UNLOCK (bin);

  return;

  /* ERRORS */
no_decodebin:
  {
    /* error was posted */
    GST_URI_DECODE_BIN_UNLOCK (bin);
    return;
  }
could_not_link:
  {
    GST_ELEMENT_ERROR (bin, CORE, NEGOTIATION,
        (NULL), ("Can't link source to decoder element"));
    GST_URI_DECODE_BIN_UNLOCK (bin);
    return;
  }
}

static gboolean
is_live_source (GstElement * source)
{
  GObjectClass *source_class = NULL;
  gboolean is_live = FALSE;
  GParamSpec *pspec;

  source_class = G_OBJECT_GET_CLASS (source);
  pspec = g_object_class_find_property (source_class, "is-live");
  if (!pspec || G_PARAM_SPEC_VALUE_TYPE (pspec) != G_TYPE_BOOLEAN)
    return FALSE;

  g_object_get (G_OBJECT (source), "is-live", &is_live, NULL);

  return is_live;
}

/* construct and run the source and decoder elements until we found
 * all the streams or until a preroll queue has been filled.
*/
static gboolean
setup_source (GstURIDecodeBin * decoder)
{
  gboolean is_raw, have_out, is_dynamic;

  GST_DEBUG_OBJECT (decoder, "setup source");

  /* delete old src */
  remove_source (decoder);

  decoder->pending = 0;

  /* create and configure an element that can handle the uri */
  if (!(decoder->source = gen_source_element (decoder)))
    goto no_source;

  /* state will be merged later - if file is not found, error will be
   * handled by the application right after. */
  gst_bin_add (GST_BIN_CAST (decoder), decoder->source);

  /* notify of the new source used */
  g_object_notify (G_OBJECT (decoder), "source");

  g_signal_emit (decoder, gst_uri_decode_bin_signals[SIGNAL_SOURCE_SETUP],
      0, decoder->source);

  if (is_live_source (decoder->source))
    decoder->is_stream = FALSE;

  /* remove the old decoders now, if any */
  remove_decoders (decoder, FALSE);

  /* stream admin setup */
  decoder->streams = g_hash_table_new_full (NULL, NULL, NULL, free_stream);

  /* see if the source element emits raw audio/video all by itself,
   * if so, we can create streams for the pads and be done with it.
   * Also check that is has source pads, if not, we assume it will
   * do everything itself.  */
  if (!analyse_source (decoder, &is_raw, &have_out, &is_dynamic,
          decoder->need_queue))
    goto invalid_source;

  if (is_raw) {
    GST_DEBUG_OBJECT (decoder, "Source provides all raw data");
    /* source provides raw data, we added the pads and we can now signal a
     * no_more pads because we are done. */
    gst_element_no_more_pads (GST_ELEMENT_CAST (decoder));
    return TRUE;
  }
  if (!have_out && !is_dynamic) {
    GST_DEBUG_OBJECT (decoder, "Source has no output pads");
    /* create a stream to indicate that this uri is handled by a self
     * contained element. We are now done. */
    add_element_stream (decoder->source, decoder);
    return TRUE;
  }
  if (is_dynamic) {
    GST_DEBUG_OBJECT (decoder, "Source has dynamic output pads");
    /* connect a handler for the new-pad signal */
    decoder->src_np_sig_id =
        g_signal_connect (decoder->source, "pad-added",
        G_CALLBACK (source_new_pad), decoder);
    decoder->src_nmp_sig_id =
        g_signal_connect (decoder->source, "no-more-pads",
        G_CALLBACK (source_no_more_pads), decoder);
    g_object_set_data (G_OBJECT (decoder->source), "pending",
        GINT_TO_POINTER (1));
    decoder->pending++;
  } else {
    if (decoder->is_stream) {
      GST_DEBUG_OBJECT (decoder, "Setting up streaming");
      /* do the stream things here */
      if (!setup_streaming (decoder))
        goto streaming_failed;
    } else {
      GstElement *dec_elem;

      /* no streaming source, we can link now */
      GST_DEBUG_OBJECT (decoder, "Plugging decodebin to source");

      dec_elem = make_decoder (decoder);
      if (!dec_elem)
        goto no_decoder;

      if (!gst_element_link_pads (decoder->source, NULL, dec_elem, "sink"))
        goto could_not_link;
    }
  }
  return TRUE;

  /* ERRORS */
no_source:
  {
    /* error message was already posted */
    return FALSE;
  }
invalid_source:
  {
    GST_ELEMENT_ERROR (decoder, CORE, FAILED,
        (_("Source element is invalid.")), (NULL));
    return FALSE;
  }
no_decoder:
  {
    /* message was posted */
    return FALSE;
  }
streaming_failed:
  {
    /* message was posted */
    return FALSE;
  }
could_not_link:
  {
    GST_ELEMENT_ERROR (decoder, CORE, NEGOTIATION,
        (NULL), ("Can't link source to decoder element"));
    return FALSE;
  }
}

static void
value_list_append_structure_list (GValue * list_val, GstStructure ** first,
    GList * structure_list)
{
  GList *l;

  for (l = structure_list; l != NULL; l = l->next) {
    GValue val = { 0, };

    if (*first == NULL)
      *first = gst_structure_copy ((GstStructure *) l->data);

    g_value_init (&val, GST_TYPE_STRUCTURE);
    g_value_take_boxed (&val, gst_structure_copy ((GstStructure *) l->data));
    gst_value_list_append_value (list_val, &val);
    g_value_unset (&val);
  }
}

/* if it's a redirect message with multiple redirect locations we might
 * want to pick a different 'best' location depending on the required
 * bitrates and the connection speed */
static GstMessage *
handle_redirect_message (GstURIDecodeBin * dec, GstMessage * msg)
{
  const GValue *locations_list, *location_val;
  GstMessage *new_msg;
  GstStructure *new_structure = NULL;
  GList *l_good = NULL, *l_neutral = NULL, *l_bad = NULL;
  GValue new_list = { 0, };
  guint size, i;
  const GstStructure *structure;

  GST_DEBUG_OBJECT (dec, "redirect message: %" GST_PTR_FORMAT, msg);
  GST_DEBUG_OBJECT (dec, "connection speed: %" G_GUINT64_FORMAT,
      dec->connection_speed);

  structure = gst_message_get_structure (msg);
  if (dec->connection_speed == 0 || structure == NULL)
    return msg;

  locations_list = gst_structure_get_value (structure, "locations");
  if (locations_list == NULL)
    return msg;

  size = gst_value_list_get_size (locations_list);
  if (size < 2)
    return msg;

  /* maintain existing order as much as possible, just sort references
   * with too high a bitrate to the end (the assumption being that if
   * bitrates are given they are given for all interesting streams and
   * that the you-need-at-least-version-xyz redirect has the same bitrate
   * as the lowest referenced redirect alternative) */
  for (i = 0; i < size; ++i) {
    const GstStructure *s;
    gint bitrate = 0;

    location_val = gst_value_list_get_value (locations_list, i);
    s = (const GstStructure *) g_value_get_boxed (location_val);
    if (!gst_structure_get_int (s, "minimum-bitrate", &bitrate) || bitrate <= 0) {
      GST_DEBUG_OBJECT (dec, "no bitrate: %" GST_PTR_FORMAT, s);
      l_neutral = g_list_append (l_neutral, (gpointer) s);
    } else if (bitrate > dec->connection_speed) {
      GST_DEBUG_OBJECT (dec, "bitrate too high: %" GST_PTR_FORMAT, s);
      l_bad = g_list_append (l_bad, (gpointer) s);
    } else if (bitrate <= dec->connection_speed) {
      GST_DEBUG_OBJECT (dec, "bitrate OK: %" GST_PTR_FORMAT, s);
      l_good = g_list_append (l_good, (gpointer) s);
    }
  }

  g_value_init (&new_list, GST_TYPE_LIST);
  value_list_append_structure_list (&new_list, &new_structure, l_good);
  value_list_append_structure_list (&new_list, &new_structure, l_neutral);
  value_list_append_structure_list (&new_list, &new_structure, l_bad);
  gst_structure_take_value (new_structure, "locations", &new_list);

  g_list_free (l_good);
  g_list_free (l_neutral);
  g_list_free (l_bad);

  new_msg = gst_message_new_element (msg->src, new_structure);
  gst_message_unref (msg);

  GST_DEBUG_OBJECT (dec, "new redirect message: %" GST_PTR_FORMAT, new_msg);
  return new_msg;
}

static void
handle_message (GstBin * bin, GstMessage * msg)
{
  switch (GST_MESSAGE_TYPE (msg)) {
    case GST_MESSAGE_ELEMENT:{
      if (gst_message_has_name (msg, "redirect")) {
        /* sort redirect messages based on the connection speed. This simplifies
         * the user of this element as it can in most cases just pick the first item
         * of the sorted list as a good redirection candidate. It can of course
         * choose something else from the list if it has a better way. */
        msg = handle_redirect_message (GST_URI_DECODE_BIN (bin), msg);
      }
      break;
    }
    case GST_MESSAGE_ERROR:{
      GError *err = NULL;

      /* Filter out missing plugin error messages from the decodebins. Only if
       * all decodebins exposed no streams we will report a missing plugin
       * error from no_more_pads_full()
       */
      gst_message_parse_error (msg, &err, NULL);
      if (g_error_matches (err, GST_CORE_ERROR, GST_CORE_ERROR_MISSING_PLUGIN)
          || g_error_matches (err, GST_STREAM_ERROR,
              GST_STREAM_ERROR_CODEC_NOT_FOUND)) {
        no_more_pads_full (GST_ELEMENT (GST_MESSAGE_SRC (msg)), FALSE,
            GST_URI_DECODE_BIN (bin));
        gst_message_unref (msg);
        msg = NULL;
      }
      g_clear_error (&err);
      break;
    }
    default:
      break;
  }

  if (msg)
    GST_BIN_CLASS (parent_class)->handle_message (bin, msg);
}

/* generic struct passed to all query fold methods
 * FIXME, move to core.
 */
typedef struct
{
  GstQuery *query;
  gint64 min;
  gint64 max;
  gboolean seekable;
  gboolean live;
} QueryFold;

typedef void (*QueryInitFunction) (GstURIDecodeBin * dec, QueryFold * fold);
typedef void (*QueryDoneFunction) (GstURIDecodeBin * dec, QueryFold * fold);

/* for duration/position we collect all durations/positions and take
 * the MAX of all valid results */
static void
decoder_query_init (GstURIDecodeBin * dec, QueryFold * fold)
{
  fold->min = 0;
  fold->max = -1;
  fold->seekable = TRUE;
  fold->live = 0;
}

static gboolean
decoder_query_duration_fold (const GValue * item, GValue * ret,
    QueryFold * fold)
{
  GstPad *pad = g_value_get_object (item);

  if (gst_pad_query (pad, fold->query)) {
    gint64 duration;

    g_value_set_boolean (ret, TRUE);

    gst_query_parse_duration (fold->query, NULL, &duration);

    GST_DEBUG_OBJECT (item, "got duration %" G_GINT64_FORMAT, duration);

    if (duration > fold->max)
      fold->max = duration;
  }
  return TRUE;
}

static void
decoder_query_duration_done (GstURIDecodeBin * dec, QueryFold * fold)
{
  GstFormat format;

  gst_query_parse_duration (fold->query, &format, NULL);
  /* store max in query result */
  gst_query_set_duration (fold->query, format, fold->max);

  GST_DEBUG ("max duration %" G_GINT64_FORMAT, fold->max);
}

static gboolean
decoder_query_position_fold (const GValue * item, GValue * ret,
    QueryFold * fold)
{
  GstPad *pad = g_value_get_object (item);

  if (gst_pad_query (pad, fold->query)) {
    gint64 position;

    g_value_set_boolean (ret, TRUE);

    gst_query_parse_position (fold->query, NULL, &position);

    GST_DEBUG_OBJECT (item, "got position %" G_GINT64_FORMAT, position);

    if (position > fold->max)
      fold->max = position;
  }

  return TRUE;
}

static void
decoder_query_position_done (GstURIDecodeBin * dec, QueryFold * fold)
{
  GstFormat format;

  gst_query_parse_position (fold->query, &format, NULL);
  /* store max in query result */
  gst_query_set_position (fold->query, format, fold->max);

  GST_DEBUG_OBJECT (dec, "max position %" G_GINT64_FORMAT, fold->max);
}

static gboolean
decoder_query_latency_fold (const GValue * item, GValue * ret, QueryFold * fold)
{
  GstPad *pad = g_value_get_object (item);

  if (gst_pad_query (pad, fold->query)) {
    GstClockTime min, max;
    gboolean live;

    g_value_set_boolean (ret, TRUE);

    gst_query_parse_latency (fold->query, &live, &min, &max);

    GST_DEBUG_OBJECT (item,
        "got latency min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT
        ", live %d", GST_TIME_ARGS (min), GST_TIME_ARGS (max), live);

    /* for the combined latency we collect the MAX of all min latencies and
     * the MIN of all max latencies */
    if (min > fold->min)
      fold->min = min;
    if (fold->max == -1)
      fold->max = max;
    else if (max < fold->max)
      fold->max = max;
    if (fold->live == FALSE)
      fold->live = live;
  }

  return TRUE;
}

static void
decoder_query_latency_done (GstURIDecodeBin * dec, QueryFold * fold)
{
  /* store max in query result */
  gst_query_set_latency (fold->query, fold->live, fold->min, fold->max);

  GST_DEBUG_OBJECT (dec,
      "latency min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT
      ", live %d", GST_TIME_ARGS (fold->min), GST_TIME_ARGS (fold->max),
      fold->live);
}

/* we are seekable if all srcpads are seekable */
static gboolean
decoder_query_seeking_fold (const GValue * item, GValue * ret, QueryFold * fold)
{
  GstPad *pad = g_value_get_object (item);

  if (gst_pad_query (pad, fold->query)) {
    gboolean seekable;

    g_value_set_boolean (ret, TRUE);
    gst_query_parse_seeking (fold->query, NULL, &seekable, NULL, NULL);

    GST_DEBUG_OBJECT (item, "got seekable %d", seekable);

    if (fold->seekable == TRUE)
      fold->seekable = seekable;
  }

  return TRUE;
}

static void
decoder_query_seeking_done (GstURIDecodeBin * dec, QueryFold * fold)
{
  GstFormat format;

  gst_query_parse_seeking (fold->query, &format, NULL, NULL, NULL);
  gst_query_set_seeking (fold->query, format, fold->seekable, 0, -1);

  GST_DEBUG_OBJECT (dec, "seekable %d", fold->seekable);
}

/* generic fold, return first valid result */
static gboolean
decoder_query_generic_fold (const GValue * item, GValue * ret, QueryFold * fold)
{
  GstPad *pad = g_value_get_object (item);
  gboolean res;

  if ((res = gst_pad_query (pad, fold->query))) {
    g_value_set_boolean (ret, TRUE);
    GST_DEBUG_OBJECT (item, "answered query %p", fold->query);
  }

  /* and stop as soon as we have a valid result */
  return !res;
}


/* we're a bin, the default query handler iterates sink elements, which we don't
 * have normally. We should just query all source pads.
 */
static gboolean
gst_uri_decode_bin_query (GstElement * element, GstQuery * query)
{
  GstURIDecodeBin *decoder;
  gboolean res = FALSE;
  GstIterator *iter;
  GstIteratorFoldFunction fold_func;
  QueryInitFunction fold_init = NULL;
  QueryDoneFunction fold_done = NULL;
  QueryFold fold_data;
  GValue ret = { 0 };

  decoder = GST_URI_DECODE_BIN (element);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_DURATION:
      /* iterate and collect durations */
      fold_func = (GstIteratorFoldFunction) decoder_query_duration_fold;
      fold_init = decoder_query_init;
      fold_done = decoder_query_duration_done;
      break;
    case GST_QUERY_POSITION:
      /* iterate and collect durations */
      fold_func = (GstIteratorFoldFunction) decoder_query_position_fold;
      fold_init = decoder_query_init;
      fold_done = decoder_query_position_done;
      break;
    case GST_QUERY_LATENCY:
      /* iterate and collect durations */
      fold_func = (GstIteratorFoldFunction) decoder_query_latency_fold;
      fold_init = decoder_query_init;
      fold_done = decoder_query_latency_done;
      break;
    case GST_QUERY_SEEKING:
      /* iterate and collect durations */
      fold_func = (GstIteratorFoldFunction) decoder_query_seeking_fold;
      fold_init = decoder_query_init;
      fold_done = decoder_query_seeking_done;
      break;
    default:
      fold_func = (GstIteratorFoldFunction) decoder_query_generic_fold;
      break;
  }

  fold_data.query = query;

  g_value_init (&ret, G_TYPE_BOOLEAN);
  g_value_set_boolean (&ret, FALSE);

  iter = gst_element_iterate_src_pads (element);
  GST_DEBUG_OBJECT (element, "Sending query %p (type %d) to src pads",
      query, GST_QUERY_TYPE (query));

  if (fold_init)
    fold_init (decoder, &fold_data);

  while (TRUE) {
    GstIteratorResult ires;

    ires = gst_iterator_fold (iter, fold_func, &ret, &fold_data);

    switch (ires) {
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (iter);
        if (fold_init)
          fold_init (decoder, &fold_data);
        g_value_set_boolean (&ret, FALSE);
        break;
      case GST_ITERATOR_OK:
      case GST_ITERATOR_DONE:
        res = g_value_get_boolean (&ret);
        if (fold_done != NULL && res)
          fold_done (decoder, &fold_data);
        goto done;
      default:
        res = FALSE;
        goto done;
    }
  }
done:
  gst_iterator_free (iter);

  return res;
}

static GstStateChangeReturn
gst_uri_decode_bin_change_state (GstElement * element,
    GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstURIDecodeBin *decoder;

  decoder = GST_URI_DECODE_BIN (element);

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      if (!setup_source (decoder))
        goto source_failed;
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_DEBUG ("ready to paused");
      if (ret == GST_STATE_CHANGE_FAILURE)
        goto setup_failed;
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_DEBUG ("paused to ready");
      remove_decoders (decoder, FALSE);
      remove_source (decoder);
      do_async_done (decoder);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      GST_DEBUG ("ready to null");
      remove_decoders (decoder, TRUE);
      remove_source (decoder);
      break;
    default:
      break;
  }
  return ret;

  /* ERRORS */
source_failed:
  {
    return GST_STATE_CHANGE_FAILURE;
  }
setup_failed:
  {
    /* clean up leftover groups */
    return GST_STATE_CHANGE_FAILURE;
  }
}

gboolean
gst_uri_decode_bin_plugin_init (GstPlugin * plugin)
{
  GST_DEBUG_CATEGORY_INIT (gst_uri_decode_bin_debug, "uridecodebin", 0,
      "URI decoder element");

  return gst_element_register (plugin, "uridecodebin", GST_RANK_NONE,
      GST_TYPE_URI_DECODE_BIN);
}
