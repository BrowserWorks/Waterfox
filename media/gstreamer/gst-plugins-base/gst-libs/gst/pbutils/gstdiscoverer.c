/* GStreamer
 * Copyright (C) 2009 Edward Hervey <edward.hervey@collabora.co.uk>
 *               2009 Nokia Corporation
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
 * SECTION:gstdiscoverer
 * @short_description: Utility for discovering information on URIs.
 *
 * The #GstDiscoverer is a utility object which allows to get as much
 * information as possible from one or many URIs.
 *
 * It provides two APIs, allowing usage in blocking or non-blocking mode.
 *
 * The blocking mode just requires calling gst_discoverer_discover_uri()
 * with the URI one wishes to discover.
 *
 * The non-blocking mode requires a running #GMainLoop iterating a
 * #GMainContext, where one connects to the various signals, appends the
 * URIs to be processed (through gst_discoverer_discover_uri_async()) and then
 * asks for the discovery to begin (through gst_discoverer_start()).
 * By default this will use the GLib default main context unless you have
 * set a custom context using g_main_context_push_thread_default().
 *
 * All the information is returned in a #GstDiscovererInfo structure.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/video/video.h>
#include <gst/audio/audio.h>

#include "pbutils.h"
#include "pbutils-private.h"

GST_DEBUG_CATEGORY_STATIC (discoverer_debug);
#define GST_CAT_DEFAULT discoverer_debug

static GQuark _CAPS_QUARK;
static GQuark _TAGS_QUARK;
static GQuark _TOC_QUARK;
static GQuark _STREAM_ID_QUARK;
static GQuark _MISSING_PLUGIN_QUARK;
static GQuark _STREAM_TOPOLOGY_QUARK;
static GQuark _TOPOLOGY_PAD_QUARK;


typedef struct
{
  GstDiscoverer *dc;
  GstPad *pad;
  GstElement *queue;
  GstElement *sink;
  GstTagList *tags;
  GstToc *toc;
  gchar *stream_id;
} PrivateStream;

struct _GstDiscovererPrivate
{
  gboolean async;

  /* allowed time to discover each uri in nanoseconds */
  GstClockTime timeout;

  /* list of pending URI to process (current excluded) */
  GList *pending_uris;

  GMutex lock;

  /* TRUE if processing a URI */
  gboolean processing;

  /* TRUE if discoverer has been started */
  gboolean running;

  /* TRUE if ASYNC_DONE has been received (need to check for subtitle tags) */
  gboolean async_done;

  /* current items */
  GstDiscovererInfo *current_info;
  GError *current_error;
  GstStructure *current_topology;

  /* List of private streams */
  GList *streams;

  /* List of these sinks and their handler IDs (to remove the probe) */
  guint pending_subtitle_pads;

  /* Global elements */
  GstBin *pipeline;
  GstElement *uridecodebin;
  GstBus *bus;

  GType decodebin_type;

  /* Custom main context variables */
  GMainContext *ctx;
  guint sourceid;
  guint timeoutid;

  /* reusable queries */
  GstQuery *seeking_query;

  /* Handler ids for various callbacks */
  gulong pad_added_id;
  gulong pad_remove_id;
  gulong source_chg_id;
  gulong element_added_id;
  gulong bus_cb_id;
};

#define DISCO_LOCK(dc) g_mutex_lock (&dc->priv->lock);
#define DISCO_UNLOCK(dc) g_mutex_unlock (&dc->priv->lock);

static void
_do_init (void)
{
  GST_DEBUG_CATEGORY_INIT (discoverer_debug, "discoverer", 0, "Discoverer");

  _CAPS_QUARK = g_quark_from_static_string ("caps");
  _TAGS_QUARK = g_quark_from_static_string ("tags");
  _TOC_QUARK = g_quark_from_static_string ("toc");
  _STREAM_ID_QUARK = g_quark_from_static_string ("stream-id");
  _MISSING_PLUGIN_QUARK = g_quark_from_static_string ("missing-plugin");
  _STREAM_TOPOLOGY_QUARK = g_quark_from_static_string ("stream-topology");
  _TOPOLOGY_PAD_QUARK = g_quark_from_static_string ("pad");
};

G_DEFINE_TYPE_EXTENDED (GstDiscoverer, gst_discoverer, G_TYPE_OBJECT, 0,
    _do_init ());

enum
{
  SIGNAL_FINISHED,
  SIGNAL_STARTING,
  SIGNAL_DISCOVERED,
  SIGNAL_SOURCE_SETUP,
  LAST_SIGNAL
};

#define DEFAULT_PROP_TIMEOUT 15 * GST_SECOND

enum
{
  PROP_0,
  PROP_TIMEOUT
};

static guint gst_discoverer_signals[LAST_SIGNAL] = { 0 };

static void gst_discoverer_set_timeout (GstDiscoverer * dc,
    GstClockTime timeout);
static gboolean async_timeout_cb (GstDiscoverer * dc);

static void discoverer_bus_cb (GstBus * bus, GstMessage * msg,
    GstDiscoverer * dc);
static void uridecodebin_pad_added_cb (GstElement * uridecodebin, GstPad * pad,
    GstDiscoverer * dc);
static void uridecodebin_pad_removed_cb (GstElement * uridecodebin,
    GstPad * pad, GstDiscoverer * dc);
static void uridecodebin_source_changed_cb (GstElement * uridecodebin,
    GParamSpec * pspec, GstDiscoverer * dc);

static void gst_discoverer_dispose (GObject * dc);
static void gst_discoverer_finalize (GObject * dc);
static void gst_discoverer_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_discoverer_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static void
gst_discoverer_class_init (GstDiscovererClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->dispose = gst_discoverer_dispose;
  gobject_class->finalize = gst_discoverer_finalize;

  gobject_class->set_property = gst_discoverer_set_property;
  gobject_class->get_property = gst_discoverer_get_property;

  g_type_class_add_private (klass, sizeof (GstDiscovererPrivate));

  /* properties */
  /**
   * GstDiscoverer:timeout:
   *
   * The duration (in nanoseconds) after which the discovery of an individual
   * URI will timeout.
   *
   * If the discovery of a URI times out, the %GST_DISCOVERER_TIMEOUT will be
   * set on the result flags.
   */
  g_object_class_install_property (gobject_class, PROP_TIMEOUT,
      g_param_spec_uint64 ("timeout", "timeout", "Timeout",
          GST_SECOND, 3600 * GST_SECOND, DEFAULT_PROP_TIMEOUT,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));

  /* signals */
  /**
   * GstDiscoverer::finished:
   * @discoverer: the #GstDiscoverer
   *
   * Will be emitted in async mode when all pending URIs have been processed.
   */
  gst_discoverer_signals[SIGNAL_FINISHED] =
      g_signal_new ("finished", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstDiscovererClass, finished),
      NULL, NULL, g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0, G_TYPE_NONE);

  /**
   * GstDiscoverer::starting:
   * @discoverer: the #GstDiscoverer
   *
   * Will be emitted when the discover starts analyzing the pending URIs
   */
  gst_discoverer_signals[SIGNAL_STARTING] =
      g_signal_new ("starting", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstDiscovererClass, starting),
      NULL, NULL, g_cclosure_marshal_VOID__VOID, G_TYPE_NONE, 0, G_TYPE_NONE);

  /**
   * GstDiscoverer::discovered:
   * @discoverer: the #GstDiscoverer
   * @info: the results #GstDiscovererInfo
   * @error: (type GLib.Error): #GError, which will be non-NULL if an error
   *                            occurred during discovery. You must not
   *                            free this #GError, it will be freed by
   *                            the discoverer.
   *
   * Will be emitted in async mode when all information on a URI could be
   * discovered, or an error occurred.
   *
   * When an error occurs, @info might still contain some partial information,
   * depending on the circumstances of the error.
   */
  gst_discoverer_signals[SIGNAL_DISCOVERED] =
      g_signal_new ("discovered", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstDiscovererClass, discovered),
      NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 2, GST_TYPE_DISCOVERER_INFO,
      G_TYPE_ERROR | G_SIGNAL_TYPE_STATIC_SCOPE);

  /**
   * GstDiscoverer::source-setup:
   * @discoverer: the #GstDiscoverer
   * @source: source element
   *
   * This signal is emitted after the source element has been created for, so
   * the URI being discovered, so it can be configured by setting additional
   * properties (e.g. set a proxy server for an http source, or set the device
   * and read speed for an audio cd source).
   *
   * This signal is usually emitted from the context of a GStreamer streaming
   * thread.
   */
  gst_discoverer_signals[SIGNAL_SOURCE_SETUP] =
      g_signal_new ("source-setup", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, G_STRUCT_OFFSET (GstDiscovererClass, source_setup),
      NULL, NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 1, GST_TYPE_ELEMENT);
}

static void
uridecodebin_element_added_cb (GstElement * uridecodebin,
    GstElement * child, GstDiscoverer * dc)
{
  GST_DEBUG ("New element added to uridecodebin : %s",
      GST_ELEMENT_NAME (child));

  if (G_OBJECT_TYPE (child) == dc->priv->decodebin_type) {
    g_object_set (child, "post-stream-topology", TRUE, NULL);
  }
}

static void
gst_discoverer_init (GstDiscoverer * dc)
{
  GstElement *tmp;
  GstFormat format = GST_FORMAT_TIME;

  dc->priv = G_TYPE_INSTANCE_GET_PRIVATE (dc, GST_TYPE_DISCOVERER,
      GstDiscovererPrivate);

  dc->priv->timeout = DEFAULT_PROP_TIMEOUT;
  dc->priv->async = FALSE;
  dc->priv->async_done = FALSE;

  g_mutex_init (&dc->priv->lock);

  dc->priv->pending_subtitle_pads = 0;

  GST_LOG ("Creating pipeline");
  dc->priv->pipeline = (GstBin *) gst_pipeline_new ("Discoverer");
  GST_LOG_OBJECT (dc, "Creating uridecodebin");
  dc->priv->uridecodebin =
      gst_element_factory_make ("uridecodebin", "discoverer-uri");
  if (G_UNLIKELY (dc->priv->uridecodebin == NULL)) {
    GST_ERROR ("Can't create uridecodebin");
    return;
  }
  GST_LOG_OBJECT (dc, "Adding uridecodebin to pipeline");
  gst_bin_add (dc->priv->pipeline, dc->priv->uridecodebin);

  dc->priv->pad_added_id =
      g_signal_connect_object (dc->priv->uridecodebin, "pad-added",
      G_CALLBACK (uridecodebin_pad_added_cb), dc, 0);
  dc->priv->pad_remove_id =
      g_signal_connect_object (dc->priv->uridecodebin, "pad-removed",
      G_CALLBACK (uridecodebin_pad_removed_cb), dc, 0);
  dc->priv->source_chg_id =
      g_signal_connect_object (dc->priv->uridecodebin, "notify::source",
      G_CALLBACK (uridecodebin_source_changed_cb), dc, 0);

  GST_LOG_OBJECT (dc, "Getting pipeline bus");
  dc->priv->bus = gst_pipeline_get_bus ((GstPipeline *) dc->priv->pipeline);

  dc->priv->bus_cb_id =
      g_signal_connect_object (dc->priv->bus, "message",
      G_CALLBACK (discoverer_bus_cb), dc, 0);

  GST_DEBUG_OBJECT (dc, "Done initializing Discoverer");

  /* This is ugly. We get the GType of decodebin so we can quickly detect
   * when a decodebin is added to uridecodebin so we can set the
   * post-stream-topology setting to TRUE */
  dc->priv->element_added_id =
      g_signal_connect_object (dc->priv->uridecodebin, "element-added",
      G_CALLBACK (uridecodebin_element_added_cb), dc, 0);
  tmp = gst_element_factory_make ("decodebin", NULL);
  dc->priv->decodebin_type = G_OBJECT_TYPE (tmp);
  gst_object_unref (tmp);

  /* create queries */
  dc->priv->seeking_query = gst_query_new_seeking (format);
}

static void
discoverer_reset (GstDiscoverer * dc)
{
  GST_DEBUG_OBJECT (dc, "Resetting");

  if (dc->priv->pending_uris) {
    g_list_foreach (dc->priv->pending_uris, (GFunc) g_free, NULL);
    g_list_free (dc->priv->pending_uris);
    dc->priv->pending_uris = NULL;
  }

  if (dc->priv->pipeline)
    gst_element_set_state ((GstElement *) dc->priv->pipeline, GST_STATE_NULL);
}

#define DISCONNECT_SIGNAL(o,i) G_STMT_START{           \
  if ((i) && g_signal_handler_is_connected ((o), (i))) \
    g_signal_handler_disconnect ((o), (i));            \
  (i) = 0;                                             \
}G_STMT_END

static void
gst_discoverer_dispose (GObject * obj)
{
  GstDiscoverer *dc = (GstDiscoverer *) obj;

  GST_DEBUG_OBJECT (dc, "Disposing");

  discoverer_reset (dc);

  if (G_LIKELY (dc->priv->pipeline)) {
    /* Workaround for bug #118536 */
    DISCONNECT_SIGNAL (dc->priv->uridecodebin, dc->priv->pad_added_id);
    DISCONNECT_SIGNAL (dc->priv->uridecodebin, dc->priv->pad_remove_id);
    DISCONNECT_SIGNAL (dc->priv->uridecodebin, dc->priv->source_chg_id);
    DISCONNECT_SIGNAL (dc->priv->uridecodebin, dc->priv->element_added_id);
    DISCONNECT_SIGNAL (dc->priv->bus, dc->priv->bus_cb_id);

    /* pipeline was set to NULL in _reset */
    gst_object_unref (dc->priv->pipeline);
    gst_object_unref (dc->priv->bus);

    dc->priv->pipeline = NULL;
    dc->priv->uridecodebin = NULL;
    dc->priv->bus = NULL;
  }

  gst_discoverer_stop (dc);

  if (dc->priv->seeking_query) {
    gst_query_unref (dc->priv->seeking_query);
    dc->priv->seeking_query = NULL;
  }

  G_OBJECT_CLASS (gst_discoverer_parent_class)->dispose (obj);
}

static void
gst_discoverer_finalize (GObject * obj)
{
  GstDiscoverer *dc = (GstDiscoverer *) obj;

  g_mutex_clear (&dc->priv->lock);

  G_OBJECT_CLASS (gst_discoverer_parent_class)->finalize (obj);
}

static void
gst_discoverer_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstDiscoverer *dc = (GstDiscoverer *) object;

  switch (prop_id) {
    case PROP_TIMEOUT:
      gst_discoverer_set_timeout (dc, g_value_get_uint64 (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_discoverer_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstDiscoverer *dc = (GstDiscoverer *) object;

  switch (prop_id) {
    case PROP_TIMEOUT:
      DISCO_LOCK (dc);
      g_value_set_uint64 (value, dc->priv->timeout);
      DISCO_UNLOCK (dc);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_discoverer_set_timeout (GstDiscoverer * dc, GstClockTime timeout)
{
  GST_DEBUG_OBJECT (dc, "timeout : %" GST_TIME_FORMAT, GST_TIME_ARGS (timeout));

  /* FIXME : update current pending timeout if we're running */
  DISCO_LOCK (dc);
  dc->priv->timeout = timeout;
  DISCO_UNLOCK (dc);
}

static GstPadProbeReturn
_event_probe (GstPad * pad, GstPadProbeInfo * info, PrivateStream * ps)
{
  GstEvent *event = GST_PAD_PROBE_INFO_EVENT (info);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_TAG:{
      GstTagList *tl = NULL, *tmp;

      gst_event_parse_tag (event, &tl);
      GST_DEBUG_OBJECT (pad, "tags %" GST_PTR_FORMAT, tl);
      DISCO_LOCK (ps->dc);
      /* If preroll is complete, drop these tags - the collected information is
       * possibly already being processed and adding more tags would be racy */
      if (G_LIKELY (ps->dc->priv->processing)) {
        GST_DEBUG_OBJECT (pad, "private stream %p old tags %" GST_PTR_FORMAT,
            ps, ps->tags);
        tmp = gst_tag_list_merge (ps->tags, tl, GST_TAG_MERGE_APPEND);
        if (ps->tags)
          gst_tag_list_unref (ps->tags);
        ps->tags = tmp;
        GST_DEBUG_OBJECT (pad, "private stream %p new tags %" GST_PTR_FORMAT,
            ps, tmp);
      } else
        GST_DEBUG_OBJECT (pad, "Dropping tags since preroll is done");
      DISCO_UNLOCK (ps->dc);
      break;
    }
    case GST_EVENT_TOC:{
      GstToc *tmp;

      gst_event_parse_toc (event, &tmp, NULL);
      GST_DEBUG_OBJECT (pad, "toc %" GST_PTR_FORMAT, tmp);
      DISCO_LOCK (ps->dc);
      ps->toc = tmp;
      if (G_LIKELY (ps->dc->priv->processing)) {
        GST_DEBUG_OBJECT (pad, "private stream %p toc %" GST_PTR_FORMAT, ps,
            tmp);
      } else
        GST_DEBUG_OBJECT (pad, "Dropping toc since preroll is done");
      DISCO_UNLOCK (ps->dc);
      break;
    }
    case GST_EVENT_STREAM_START:{
      const gchar *stream_id;

      gst_event_parse_stream_start (event, &stream_id);

      g_free (ps->stream_id);
      ps->stream_id = stream_id ? g_strdup (stream_id) : NULL;
      break;
    }
    default:
      break;
  }

  return GST_PAD_PROBE_OK;
}

static GstStaticCaps subtitle_caps = GST_STATIC_CAPS ("text/x-raw; "
    "subpicture/x-pgs; subpicture/x-dvb; subpicture/x-dvd; "
    "application/x-subtitle-unknown; application/x-ssa; application/x-ass; "
    "subtitle/x-kate; application/x-kate");

static gboolean
is_subtitle_caps (const GstCaps * caps)
{
  GstCaps *subs_caps;
  gboolean ret;

  subs_caps = gst_static_caps_get (&subtitle_caps);
  ret = gst_caps_can_intersect (caps, subs_caps);
  gst_caps_unref (subs_caps);

  return ret;
}

static GstPadProbeReturn
got_subtitle_data (GstPad * pad, GstPadProbeInfo * info, GstDiscoverer * dc)
{

  if (!(GST_IS_BUFFER (info->data) || (GST_IS_EVENT (info->data)
              && GST_EVENT_TYPE ((GstEvent *) info->data) == GST_EVENT_GAP)))
    return GST_PAD_PROBE_OK;


  DISCO_LOCK (dc);

  dc->priv->pending_subtitle_pads--;

  if (dc->priv->pending_subtitle_pads == 0) {
    GstMessage *msg = gst_message_new_application (NULL,
        gst_structure_new_empty ("DiscovererDone"));
    gst_element_post_message ((GstElement *) dc->priv->pipeline, msg);
  }
  DISCO_UNLOCK (dc);

  return GST_PAD_PROBE_REMOVE;

}

static void
uridecodebin_source_changed_cb (GstElement * uridecodebin,
    GParamSpec * pspec, GstDiscoverer * dc)
{
  GstElement *src;
  /* get a handle to the source */
  g_object_get (uridecodebin, pspec->name, &src, NULL);

  GST_DEBUG_OBJECT (dc, "got a new source %p", src);

  g_signal_emit (dc, gst_discoverer_signals[SIGNAL_SOURCE_SETUP], 0, src);
  gst_object_unref (src);
}

static void
uridecodebin_pad_added_cb (GstElement * uridecodebin, GstPad * pad,
    GstDiscoverer * dc)
{
  PrivateStream *ps;
  GstPad *sinkpad = NULL;
  GstCaps *caps;

  GST_DEBUG_OBJECT (dc, "pad %s:%s", GST_DEBUG_PAD_NAME (pad));

  ps = g_slice_new0 (PrivateStream);

  ps->dc = dc;
  ps->pad = pad;
  ps->queue = gst_element_factory_make ("queue", NULL);
  ps->sink = gst_element_factory_make ("fakesink", NULL);

  if (G_UNLIKELY (ps->queue == NULL || ps->sink == NULL))
    goto error;

  g_object_set (ps->sink, "silent", TRUE, NULL);
  g_object_set (ps->queue, "max-size-buffers", 1, "silent", TRUE, NULL);

  caps = gst_pad_query_caps (pad, NULL);

  sinkpad = gst_element_get_static_pad (ps->queue, "sink");
  if (sinkpad == NULL)
    goto error;

  if (is_subtitle_caps (caps)) {
    /* Subtitle streams are sparse and may not provide any information - don't
     * wait for data to preroll */
    gst_pad_add_probe (sinkpad, GST_PAD_PROBE_TYPE_DATA_DOWNSTREAM,
        (GstPadProbeCallback) got_subtitle_data, dc, NULL);
    g_object_set (ps->sink, "async", FALSE, NULL);
    DISCO_LOCK (dc);
    dc->priv->pending_subtitle_pads++;
    DISCO_UNLOCK (dc);
  }

  gst_caps_unref (caps);

  gst_bin_add_many (dc->priv->pipeline, ps->queue, ps->sink, NULL);

  if (!gst_element_link_pads_full (ps->queue, "src", ps->sink, "sink",
          GST_PAD_LINK_CHECK_NOTHING))
    goto error;
  if (!gst_element_sync_state_with_parent (ps->sink))
    goto error;
  if (!gst_element_sync_state_with_parent (ps->queue))
    goto error;

  if (gst_pad_link_full (pad, sinkpad,
          GST_PAD_LINK_CHECK_NOTHING) != GST_PAD_LINK_OK)
    goto error;
  gst_object_unref (sinkpad);

  /* Add an event probe */
  gst_pad_add_probe (pad, GST_PAD_PROBE_TYPE_EVENT_DOWNSTREAM,
      (GstPadProbeCallback) _event_probe, ps, NULL);

  DISCO_LOCK (dc);
  dc->priv->streams = g_list_append (dc->priv->streams, ps);
  DISCO_UNLOCK (dc);

  GST_DEBUG_OBJECT (dc, "Done handling pad");

  return;

error:
  GST_ERROR_OBJECT (dc, "Error while handling pad");
  if (sinkpad)
    gst_object_unref (sinkpad);
  if (ps->queue)
    gst_object_unref (ps->queue);
  if (ps->sink)
    gst_object_unref (ps->sink);
  g_slice_free (PrivateStream, ps);
  return;
}

static void
uridecodebin_pad_removed_cb (GstElement * uridecodebin, GstPad * pad,
    GstDiscoverer * dc)
{
  GList *tmp;
  PrivateStream *ps;
  GstPad *sinkpad;

  GST_DEBUG_OBJECT (dc, "pad %s:%s", GST_DEBUG_PAD_NAME (pad));

  /* Find the PrivateStream */
  DISCO_LOCK (dc);
  for (tmp = dc->priv->streams; tmp; tmp = tmp->next) {
    ps = (PrivateStream *) tmp->data;
    if (ps->pad == pad)
      break;
  }

  if (tmp == NULL) {
    DISCO_UNLOCK (dc);
    GST_DEBUG ("The removed pad wasn't controlled by us !");
    return;
  }

  dc->priv->streams = g_list_delete_link (dc->priv->streams, tmp);
  DISCO_UNLOCK (dc);

  gst_element_set_state (ps->sink, GST_STATE_NULL);
  gst_element_set_state (ps->queue, GST_STATE_NULL);
  gst_element_unlink (ps->queue, ps->sink);

  sinkpad = gst_element_get_static_pad (ps->queue, "sink");
  gst_pad_unlink (pad, sinkpad);
  gst_object_unref (sinkpad);

  /* references removed here */
  gst_bin_remove_many (dc->priv->pipeline, ps->sink, ps->queue, NULL);

  if (ps->tags) {
    gst_tag_list_unref (ps->tags);
  }
  if (ps->toc) {
    gst_toc_unref (ps->toc);
  }
  g_free (ps->stream_id);

  g_slice_free (PrivateStream, ps);

  GST_DEBUG ("Done handling pad");
}

static GstStructure *
collect_stream_information (GstDiscoverer * dc, PrivateStream * ps, guint idx)
{
  GstCaps *caps;
  GstStructure *st;
  gchar *stname;

  stname = g_strdup_printf ("stream-%02d", idx);
  st = gst_structure_new_empty (stname);
  g_free (stname);

  /* Get caps */
  caps = gst_pad_get_current_caps (ps->pad);
  if (!caps) {
    GST_WARNING ("Couldn't get negotiated caps from %s:%s",
        GST_DEBUG_PAD_NAME (ps->pad));
    caps = gst_pad_query_caps (ps->pad, NULL);
  }
  if (caps) {
    GST_DEBUG ("stream-%02d, got caps %" GST_PTR_FORMAT, idx, caps);
    gst_structure_id_set (st, _CAPS_QUARK, GST_TYPE_CAPS, caps, NULL);
    gst_caps_unref (caps);
  }
  if (ps->tags)
    gst_structure_id_set (st, _TAGS_QUARK, GST_TYPE_TAG_LIST, ps->tags, NULL);
  if (ps->toc)
    gst_structure_id_set (st, _TOC_QUARK, GST_TYPE_TOC, ps->toc, NULL);
  if (ps->stream_id)
    gst_structure_id_set (st, _STREAM_ID_QUARK, G_TYPE_STRING, ps->stream_id,
        NULL);

  return st;
}

/* takes ownership of new_tags, may replace *taglist with a new one */
static void
gst_discoverer_merge_and_replace_tags (GstTagList ** taglist,
    GstTagList * new_tags)
{
  if (new_tags == NULL)
    return;

  if (*taglist == NULL) {
    *taglist = new_tags;
    return;
  }

  gst_tag_list_insert (*taglist, new_tags, GST_TAG_MERGE_REPLACE);
  gst_tag_list_unref (new_tags);
}

static void
collect_common_information (GstDiscovererStreamInfo * info,
    const GstStructure * st)
{
  if (gst_structure_id_has_field (st, _TOC_QUARK)) {
    gst_structure_id_get (st, _TOC_QUARK, GST_TYPE_TOC, &info->toc, NULL);
  }

  if (gst_structure_id_has_field (st, _STREAM_ID_QUARK)) {
    gst_structure_id_get (st, _STREAM_ID_QUARK, G_TYPE_STRING, &info->stream_id,
        NULL);
  }
}

static GstDiscovererStreamInfo *
make_info (GstDiscovererStreamInfo * parent, GType type, GstCaps * caps)
{
  GstDiscovererStreamInfo *info;

  if (parent)
    info = gst_discoverer_stream_info_ref (parent);
  else {
    info = g_object_new (type, NULL);
    if (caps)
      info->caps = gst_caps_ref (caps);
  }
  return info;
}

/* Parses a set of caps and tags in st and populates a GstDiscovererStreamInfo
 * structure (parent, if !NULL, otherwise it allocates one)
 */
static GstDiscovererStreamInfo *
collect_information (GstDiscoverer * dc, const GstStructure * st,
    GstDiscovererStreamInfo * parent)
{
  GstCaps *caps;
  GstStructure *caps_st;
  GstTagList *tags_st;
  const gchar *name;
  int tmp;
  guint utmp;

  if (!st || !gst_structure_id_has_field (st, _CAPS_QUARK)) {
    GST_WARNING ("Couldn't find caps !");
    return make_info (parent, GST_TYPE_DISCOVERER_STREAM_INFO, NULL);
  }

  gst_structure_id_get (st, _CAPS_QUARK, GST_TYPE_CAPS, &caps, NULL);
  caps_st = gst_caps_get_structure (caps, 0);
  name = gst_structure_get_name (caps_st);

  if (g_str_has_prefix (name, "audio/")) {
    GstDiscovererAudioInfo *info;
    const gchar *format_str;

    info = (GstDiscovererAudioInfo *) make_info (parent,
        GST_TYPE_DISCOVERER_AUDIO_INFO, caps);

    if (gst_structure_get_int (caps_st, "rate", &tmp))
      info->sample_rate = (guint) tmp;

    if (gst_structure_get_int (caps_st, "channels", &tmp))
      info->channels = (guint) tmp;

    /* FIXME: we only want to extract depth if raw audio is what's in the
     * container (i.e. not if there is a decoder involved) */
    format_str = gst_structure_get_string (caps_st, "format");
    if (format_str != NULL) {
      const GstAudioFormatInfo *finfo;
      GstAudioFormat format;

      format = gst_audio_format_from_string (format_str);
      finfo = gst_audio_format_get_info (format);
      info->depth = GST_AUDIO_FORMAT_INFO_DEPTH (finfo);
    }

    if (gst_structure_id_has_field (st, _TAGS_QUARK)) {
      gst_structure_id_get (st, _TAGS_QUARK, GST_TYPE_TAG_LIST, &tags_st, NULL);
      if (gst_tag_list_get_uint (tags_st, GST_TAG_BITRATE, &utmp) ||
          gst_tag_list_get_uint (tags_st, GST_TAG_NOMINAL_BITRATE, &utmp))
        info->bitrate = utmp;

      if (gst_tag_list_get_uint (tags_st, GST_TAG_MAXIMUM_BITRATE, &utmp))
        info->max_bitrate = utmp;

      /* FIXME: Is it worth it to remove the tags we've parsed? */
      gst_discoverer_merge_and_replace_tags (&info->parent.tags, tags_st);
    }

    collect_common_information (&info->parent, st);

    if (!info->language && ((GstDiscovererStreamInfo *) info)->tags) {
      gchar *language;
      if (gst_tag_list_get_string (((GstDiscovererStreamInfo *) info)->tags,
              GST_TAG_LANGUAGE_CODE, &language)) {
        info->language = language;
      }
    }

    gst_caps_unref (caps);
    return (GstDiscovererStreamInfo *) info;

  } else if (g_str_has_prefix (name, "video/") ||
      g_str_has_prefix (name, "image/")) {
    GstDiscovererVideoInfo *info;
    GstVideoInfo vinfo;

    info = (GstDiscovererVideoInfo *) make_info (parent,
        GST_TYPE_DISCOVERER_VIDEO_INFO, caps);

    if (gst_video_info_from_caps (&vinfo, caps)) {
      info->width = (guint) vinfo.width;
      info->height = (guint) vinfo.height;

      info->depth = vinfo.finfo->bits * vinfo.finfo->n_components;

      info->par_num = vinfo.par_n;
      info->par_denom = vinfo.par_d;

      info->framerate_num = vinfo.fps_n;
      info->framerate_denom = vinfo.fps_d;

      info->interlaced =
          vinfo.interlace_mode != GST_VIDEO_INTERLACE_MODE_PROGRESSIVE;
    }

    if (gst_structure_id_has_field (st, _TAGS_QUARK)) {
      gst_structure_id_get (st, _TAGS_QUARK, GST_TYPE_TAG_LIST, &tags_st, NULL);
      if (gst_tag_list_get_uint (tags_st, GST_TAG_BITRATE, &utmp) ||
          gst_tag_list_get_uint (tags_st, GST_TAG_NOMINAL_BITRATE, &utmp))
        info->bitrate = utmp;

      if (gst_tag_list_get_uint (tags_st, GST_TAG_MAXIMUM_BITRATE, &utmp))
        info->max_bitrate = utmp;

      /* FIXME: Is it worth it to remove the tags we've parsed? */
      gst_discoverer_merge_and_replace_tags (&info->parent.tags, tags_st);
    }

    collect_common_information (&info->parent, st);

    gst_caps_unref (caps);
    return (GstDiscovererStreamInfo *) info;

  } else if (is_subtitle_caps (caps)) {
    GstDiscovererSubtitleInfo *info;

    info = (GstDiscovererSubtitleInfo *) make_info (parent,
        GST_TYPE_DISCOVERER_SUBTITLE_INFO, caps);

    if (gst_structure_id_has_field (st, _TAGS_QUARK)) {
      const gchar *language;

      gst_structure_id_get (st, _TAGS_QUARK, GST_TYPE_TAG_LIST, &tags_st, NULL);

      language = gst_structure_get_string (caps_st, GST_TAG_LANGUAGE_CODE);
      if (language)
        info->language = g_strdup (language);

      /* FIXME: Is it worth it to remove the tags we've parsed? */
      gst_discoverer_merge_and_replace_tags (&info->parent.tags, tags_st);
    }

    collect_common_information (&info->parent, st);

    if (!info->language && ((GstDiscovererStreamInfo *) info)->tags) {
      gchar *language;
      if (gst_tag_list_get_string (((GstDiscovererStreamInfo *) info)->tags,
              GST_TAG_LANGUAGE_CODE, &language)) {
        info->language = language;
      }
    }

    gst_caps_unref (caps);
    return (GstDiscovererStreamInfo *) info;

  } else {
    /* None of the above - populate what information we can */
    GstDiscovererStreamInfo *info;

    info = make_info (parent, GST_TYPE_DISCOVERER_STREAM_INFO, caps);

    if (gst_structure_id_get (st, _TAGS_QUARK, GST_TYPE_TAG_LIST, &tags_st,
            NULL)) {
      gst_discoverer_merge_and_replace_tags (&info->tags, tags_st);
    }

    collect_common_information (info, st);

    gst_caps_unref (caps);
    return info;
  }

}

static GstStructure *
find_stream_for_node (GstDiscoverer * dc, const GstStructure * topology)
{
  GstPad *pad;
  GstPad *target_pad = NULL;
  GstStructure *st = NULL;
  PrivateStream *ps;
  guint i;
  GList *tmp;

  if (!dc->priv->streams) {
    return NULL;
  }

  if (!gst_structure_id_has_field (topology, _TOPOLOGY_PAD_QUARK)) {
    GST_DEBUG ("Could not find pad for node %" GST_PTR_FORMAT, topology);
    return NULL;
  }

  gst_structure_id_get (topology, _TOPOLOGY_PAD_QUARK,
      GST_TYPE_PAD, &pad, NULL);

  for (i = 0, tmp = dc->priv->streams; tmp; tmp = tmp->next, i++) {
    ps = (PrivateStream *) tmp->data;

    target_pad = gst_ghost_pad_get_target (GST_GHOST_PAD (ps->pad));
    gst_object_unref (target_pad);

    if (target_pad == pad)
      break;
  }

  if (tmp)
    st = collect_stream_information (dc, ps, i);

  gst_object_unref (pad);

  return st;
}

/* this can fail due to {framed,parsed}={TRUE,FALSE} differences, thus we filter
 * the parent */
static gboolean
child_is_same_stream (const GstCaps * _parent, const GstCaps * child)
{
  GstCaps *parent = gst_caps_copy (_parent);
  guint i, size = gst_caps_get_size (parent);
  gboolean res;

  for (i = 0; i < size; i++) {
    gst_structure_remove_field (gst_caps_get_structure (parent, i), "parsed");
    gst_structure_remove_field (gst_caps_get_structure (parent, i), "framed");
  }
  res = gst_caps_can_intersect (parent, child);
  gst_caps_unref (parent);
  return res;
}


static gboolean
child_is_raw_stream (const GstCaps * parent, const GstCaps * child)
{
  const GstStructure *st1, *st2;
  const gchar *name1, *name2;

  st1 = gst_caps_get_structure (parent, 0);
  name1 = gst_structure_get_name (st1);
  st2 = gst_caps_get_structure (child, 0);
  name2 = gst_structure_get_name (st2);

  if ((g_str_has_prefix (name1, "audio/") &&
          g_str_has_prefix (name2, "audio/x-raw")) ||
      ((g_str_has_prefix (name1, "video/") ||
              g_str_has_prefix (name1, "image/")) &&
          g_str_has_prefix (name2, "video/x-raw"))) {
    /* child is the "raw" sub-stream corresponding to parent */
    return TRUE;
  }

  if (is_subtitle_caps (parent))
    return TRUE;

  return FALSE;
}

/* If a parent is non-NULL, collected stream information will be appended to it
 * (and where the information exists, it will be overriden)
 */
static GstDiscovererStreamInfo *
parse_stream_topology (GstDiscoverer * dc, const GstStructure * topology,
    GstDiscovererStreamInfo * parent)
{
  GstDiscovererStreamInfo *res = NULL;
  GstCaps *caps = NULL;
  const GValue *nval = NULL;

  GST_DEBUG ("parsing: %" GST_PTR_FORMAT, topology);

  nval = gst_structure_get_value (topology, "next");

  if (nval == NULL || GST_VALUE_HOLDS_STRUCTURE (nval)) {
    GstStructure *st = find_stream_for_node (dc, topology);
    gboolean add_to_list = TRUE;

    if (st) {
      res = collect_information (dc, st, parent);
      gst_structure_free (st);
    } else {
      /* Didn't find a stream structure, so let's just use the caps we have */
      res = collect_information (dc, topology, parent);
    }

    if (nval == NULL) {
      /* FIXME : aggregate with information from main streams */
      GST_DEBUG ("Coudn't find 'next' ! might be the last entry");
    } else {
      st = (GstStructure *) gst_value_get_structure (nval);

      GST_DEBUG ("next is a structure %" GST_PTR_FORMAT, st);

      if (!parent)
        parent = res;

      if (gst_structure_id_get (st, _CAPS_QUARK, GST_TYPE_CAPS, &caps, NULL)) {
        if (child_is_same_stream (parent->caps, caps)) {
          /* We sometimes get an extra sub-stream from the parser. If this is
           * the case, we just replace the parent caps with this stream's caps
           * since they might contain more information */
          gst_caps_replace (&parent->caps, caps);

          parse_stream_topology (dc, st, parent);
          add_to_list = FALSE;
        } else if (child_is_raw_stream (parent->caps, caps)) {
          /* This is the "raw" stream corresponding to the parent. This
           * contains more information than the parent, tags etc. */
          parse_stream_topology (dc, st, parent);
          add_to_list = FALSE;
        } else {
          GstDiscovererStreamInfo *next = parse_stream_topology (dc, st, NULL);
          res->next = next;
          next->previous = res;
        }
        gst_caps_unref (caps);
      }
    }

    if (add_to_list) {
      dc->priv->current_info->stream_list =
          g_list_append (dc->priv->current_info->stream_list, res);
    } else {
      gst_discoverer_stream_info_unref (res);
    }

  } else if (GST_VALUE_HOLDS_LIST (nval)) {
    guint i, len;
    GstDiscovererContainerInfo *cont;
    GstTagList *tags;

    if (!gst_structure_id_get (topology, _CAPS_QUARK,
            GST_TYPE_CAPS, &caps, NULL))
      GST_WARNING ("Couldn't find caps !");

    len = gst_value_list_get_size (nval);
    GST_DEBUG ("next is a list of %d entries", len);

    cont = (GstDiscovererContainerInfo *)
        g_object_new (GST_TYPE_DISCOVERER_CONTAINER_INFO, NULL);
    cont->parent.caps = caps;
    res = (GstDiscovererStreamInfo *) cont;

    if (gst_structure_id_has_field (topology, _TAGS_QUARK)) {
      GstTagList *tmp;

      gst_structure_id_get (topology, _TAGS_QUARK,
          GST_TYPE_TAG_LIST, &tags, NULL);

      GST_DEBUG ("Merge tags %" GST_PTR_FORMAT, tags);

      tmp =
          gst_tag_list_merge (cont->parent.tags, (GstTagList *) tags,
          GST_TAG_MERGE_APPEND);
      gst_tag_list_unref (tags);
      if (cont->parent.tags)
        gst_tag_list_unref (cont->parent.tags);
      cont->parent.tags = tmp;
      GST_DEBUG ("Container info tags %" GST_PTR_FORMAT, tmp);
    }

    for (i = 0; i < len; i++) {
      const GValue *subv = gst_value_list_get_value (nval, i);
      const GstStructure *subst = gst_value_get_structure (subv);
      GstDiscovererStreamInfo *substream;

      GST_DEBUG ("%d %" GST_PTR_FORMAT, i, subst);

      substream = parse_stream_topology (dc, subst, NULL);

      substream->previous = res;
      cont->streams =
          g_list_append (cont->streams,
          gst_discoverer_stream_info_ref (substream));
    }
  }

  return res;
}

/* Called when pipeline is pre-rolled */
static void
discoverer_collect (GstDiscoverer * dc)
{
  GST_DEBUG ("Collecting information");

  /* Stop the timeout handler if present */
  if (dc->priv->timeoutid) {
    g_source_remove (dc->priv->timeoutid);
    dc->priv->timeoutid = 0;
  }

  if (dc->priv->streams) {
    /* FIXME : Make this querying optional */
    if (TRUE) {
      GstElement *pipeline = (GstElement *) dc->priv->pipeline;
      gint64 dur;

      GST_DEBUG ("Attempting to query duration");

      if (gst_element_query_duration (pipeline, GST_FORMAT_TIME, &dur)) {
        GST_DEBUG ("Got duration %" GST_TIME_FORMAT, GST_TIME_ARGS (dur));
        dc->priv->current_info->duration = (guint64) dur;
      } else {
        GstStateChangeReturn sret;

        /* Some parsers may not even return a rough estimate right away, e.g.
         * because they've only processed a single frame so far, so if we
         * didn't get a duration the first time, spin a bit and try again.
         * Ugly, but still better than making parsers or other elements return
         * completely bogus values. We need some API extensions to solve this
         * better. */
        GST_INFO ("No duration yet, try a bit harder..");
        sret = gst_element_set_state (pipeline, GST_STATE_PLAYING);
        if (sret != GST_STATE_CHANGE_FAILURE) {
          int i;

          for (i = 0; i < 2; ++i) {
            g_usleep (G_USEC_PER_SEC / 20);
            if (gst_element_query_duration (pipeline, GST_FORMAT_TIME, &dur)
                && dur > 0) {
              GST_DEBUG ("Got duration %" GST_TIME_FORMAT, GST_TIME_ARGS (dur));
              dc->priv->current_info->duration = (guint64) dur;
              break;
            }
          }
          gst_element_set_state (pipeline, GST_STATE_PAUSED);
        }
      }

      if (dc->priv->seeking_query) {
        if (gst_element_query (pipeline, dc->priv->seeking_query)) {
          GstFormat format;
          gboolean seekable;

          gst_query_parse_seeking (dc->priv->seeking_query, &format,
              &seekable, NULL, NULL);
          if (format == GST_FORMAT_TIME) {
            GST_DEBUG ("Got seekable %d", seekable);
            dc->priv->current_info->seekable = seekable;
          }
        }
      }
    }

    if (dc->priv->current_topology)
      dc->priv->current_info->stream_info = parse_stream_topology (dc,
          dc->priv->current_topology, NULL);

    /*
     * Images need some special handling. They do not have a duration, have
     * caps named image/<foo> (th exception being MJPEG video which is also
     * type image/jpeg), and should consist of precisely one stream (actually
     * initially there are 2, the image and raw stream, but we squash these
     * while parsing the stream topology). At some point, if we find that these
     * conditions are not sufficient, we can count the number of decoders and
     * parsers in the chain, and if there's more than one decoder, or any
     * parser at all, we should not mark this as an image.
     */
    if (dc->priv->current_info->duration == 0 &&
        dc->priv->current_info->stream_info != NULL &&
        dc->priv->current_info->stream_info->next == NULL) {
      GstDiscovererStreamInfo *stream_info;
      GstStructure *st;

      stream_info = dc->priv->current_info->stream_info;
      st = gst_caps_get_structure (stream_info->caps, 0);

      if (g_str_has_prefix (gst_structure_get_name (st), "image/"))
        ((GstDiscovererVideoInfo *) stream_info)->is_image = TRUE;
    }
  }

  if (dc->priv->async) {
    GST_DEBUG ("Emitting 'discoverered'");
    g_signal_emit (dc, gst_discoverer_signals[SIGNAL_DISCOVERED], 0,
        dc->priv->current_info, dc->priv->current_error);
    /* Clients get a copy of current_info since it is a boxed type */
    gst_discoverer_info_unref (dc->priv->current_info);
    dc->priv->current_info = NULL;
  }
}

static void
get_async_cb (gpointer cb_data, GSource * source, GSourceFunc * func,
    gpointer * data)
{
  *func = (GSourceFunc) async_timeout_cb;
  *data = cb_data;
}

/* Wrapper since GSourceCallbackFuncs don't expect a return value from ref() */
static void
_void_g_object_ref (gpointer object)
{
  g_object_ref (G_OBJECT (object));
}

static void
handle_current_async (GstDiscoverer * dc)
{
  GSource *source;
  static GSourceCallbackFuncs cb_funcs = {
    _void_g_object_ref,
    g_object_unref,
    get_async_cb,
  };

  /* Attach a timeout to the main context */
  source = g_timeout_source_new (dc->priv->timeout / GST_MSECOND);
  g_source_set_callback_indirect (source, g_object_ref (dc), &cb_funcs);
  dc->priv->timeoutid = g_source_attach (source, dc->priv->ctx);
  g_source_unref (source);
}


/* Returns TRUE if processing should stop */
static gboolean
handle_message (GstDiscoverer * dc, GstMessage * msg)
{
  gboolean done = FALSE;

  GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg), "got a %s message",
      GST_MESSAGE_TYPE_NAME (msg));

  switch (GST_MESSAGE_TYPE (msg)) {
    case GST_MESSAGE_ERROR:{
      GError *gerr;
      gchar *debug;

      gst_message_parse_error (msg, &gerr, &debug);
      GST_WARNING_OBJECT (GST_MESSAGE_SRC (msg),
          "Got an error [debug:%s], [message:%s]", debug, gerr->message);
      dc->priv->current_error = gerr;
      g_free (debug);

      /* We need to stop */
      done = TRUE;

      /* Don't override missing plugin result code for missing plugin errors */
      if (dc->priv->current_info->result != GST_DISCOVERER_MISSING_PLUGINS ||
          (!g_error_matches (gerr, GST_CORE_ERROR,
                  GST_CORE_ERROR_MISSING_PLUGIN) &&
              !g_error_matches (gerr, GST_STREAM_ERROR,
                  GST_STREAM_ERROR_CODEC_NOT_FOUND))) {
        GST_DEBUG ("Setting result to ERROR");
        dc->priv->current_info->result = GST_DISCOVERER_ERROR;
      }
    }
      break;

    case GST_MESSAGE_EOS:
      GST_DEBUG ("Got EOS !");
      done = TRUE;
      break;

    case GST_MESSAGE_APPLICATION:{
      const gchar *name;
      gboolean async_done;
      name = gst_structure_get_name (gst_message_get_structure (msg));
      /* Maybe ASYNC_DONE is received & we're just waiting for subtitle tags */
      DISCO_LOCK (dc);
      async_done = dc->priv->async_done;
      DISCO_UNLOCK (dc);
      if (g_str_equal (name, "DiscovererDone") && async_done)
        return TRUE;
      break;
    }

    case GST_MESSAGE_ASYNC_DONE:
      if (GST_MESSAGE_SRC (msg) == (GstObject *) dc->priv->pipeline) {
        GST_DEBUG ("Finished changing state asynchronously");
        DISCO_LOCK (dc);
        if (dc->priv->pending_subtitle_pads == 0) {
          done = TRUE;
        } else {
          /* Remember that ASYNC_DONE has been received, wait for subtitles */
          dc->priv->async_done = TRUE;
        }
        DISCO_UNLOCK (dc);

      }
      break;

    case GST_MESSAGE_ELEMENT:
    {
      GQuark sttype;
      const GstStructure *structure;

      structure = gst_message_get_structure (msg);
      sttype = gst_structure_get_name_id (structure);
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg),
          "structure %" GST_PTR_FORMAT, structure);
      if (sttype == _MISSING_PLUGIN_QUARK) {
        GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg),
            "Setting result to MISSING_PLUGINS");
        dc->priv->current_info->result = GST_DISCOVERER_MISSING_PLUGINS;
        /* FIXME 2.0 Remove completely the ->misc
         * Keep the old behaviour for now.
         */
        if (dc->priv->current_info->misc)
          gst_structure_free (dc->priv->current_info->misc);
        g_ptr_array_add (dc->priv->current_info->missing_elements_details,
            gst_missing_plugin_message_get_installer_detail (msg));
      } else if (sttype == _STREAM_TOPOLOGY_QUARK) {
        if (dc->priv->current_topology)
          gst_structure_free (dc->priv->current_topology);
        dc->priv->current_topology = gst_structure_copy (structure);
      }
    }
      break;

    case GST_MESSAGE_TAG:
    {
      GstTagList *tl, *tmp;

      gst_message_parse_tag (msg, &tl);
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg), "Got tags %" GST_PTR_FORMAT, tl);
      /* Merge with current tags */
      tmp =
          gst_tag_list_merge (dc->priv->current_info->tags, tl,
          GST_TAG_MERGE_APPEND);
      gst_tag_list_unref (tl);
      if (dc->priv->current_info->tags)
        gst_tag_list_unref (dc->priv->current_info->tags);
      dc->priv->current_info->tags = tmp;
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg), "Current info %p, tags %"
          GST_PTR_FORMAT, dc->priv->current_info, tmp);
    }
      break;

    case GST_MESSAGE_TOC:
    {
      GstToc *tmp;

      gst_message_parse_toc (msg, &tmp, NULL);
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg), "Got toc %" GST_PTR_FORMAT, tmp);
      dc->priv->current_info->toc = tmp;
      GST_DEBUG_OBJECT (GST_MESSAGE_SRC (msg), "Current info %p, toc %"
          GST_PTR_FORMAT, dc->priv->current_info, tmp);
    }
      break;

    default:
      break;
  }

  return done;
}

static void
handle_current_sync (GstDiscoverer * dc)
{
  GTimer *timer;
  gdouble deadline = ((gdouble) dc->priv->timeout) / GST_SECOND;
  GstMessage *msg;
  gboolean done = FALSE;

  timer = g_timer_new ();
  g_timer_start (timer);

  do {
    /* poll bus with timeout */
    /* FIXME : make the timeout more fine-tuned */
    if ((msg = gst_bus_timed_pop (dc->priv->bus, GST_SECOND / 2))) {
      done = handle_message (dc, msg);
      gst_message_unref (msg);
    }
  } while (!done && (g_timer_elapsed (timer, NULL) < deadline));

  /* return result */
  if (!done) {
    GST_DEBUG ("we timed out! Setting result to TIMEOUT");
    dc->priv->current_info->result = GST_DISCOVERER_TIMEOUT;
  }

  GST_DEBUG ("Done");

  g_timer_stop (timer);
  g_timer_destroy (timer);
}

static void
_setup_locked (GstDiscoverer * dc)
{
  GstStateChangeReturn ret;

  GST_DEBUG ("Setting up");

  /* Pop URI off the pending URI list */
  dc->priv->current_info =
      (GstDiscovererInfo *) g_object_new (GST_TYPE_DISCOVERER_INFO, NULL);
  dc->priv->current_info->uri = (gchar *) dc->priv->pending_uris->data;
  dc->priv->pending_uris =
      g_list_delete_link (dc->priv->pending_uris, dc->priv->pending_uris);

  /* set uri on uridecodebin */
  g_object_set (dc->priv->uridecodebin, "uri", dc->priv->current_info->uri,
      NULL);

  GST_DEBUG ("Current is now %s", dc->priv->current_info->uri);

  dc->priv->processing = TRUE;

  /* set pipeline to PAUSED */
  DISCO_UNLOCK (dc);
  GST_DEBUG ("Setting pipeline to PAUSED");
  ret =
      gst_element_set_state ((GstElement *) dc->priv->pipeline,
      GST_STATE_PAUSED);
  if (ret == GST_STATE_CHANGE_NO_PREROLL) {
    GST_DEBUG ("Source is live, switching to PLAYING");
    ret =
        gst_element_set_state ((GstElement *) dc->priv->pipeline,
        GST_STATE_PLAYING);
  }
  DISCO_LOCK (dc);

  GST_DEBUG_OBJECT (dc, "Pipeline going to PAUSED : %s",
      gst_element_state_change_return_get_name (ret));
}

static void
discoverer_cleanup (GstDiscoverer * dc)
{
  GST_DEBUG ("Cleaning up");

  gst_bus_set_flushing (dc->priv->bus, TRUE);

  DISCO_LOCK (dc);
  if (dc->priv->current_error) {
    g_error_free (dc->priv->current_error);
    DISCO_UNLOCK (dc);
    gst_element_set_state ((GstElement *) dc->priv->pipeline, GST_STATE_NULL);
  } else {
    DISCO_UNLOCK (dc);
  }

  gst_element_set_state ((GstElement *) dc->priv->pipeline, GST_STATE_READY);
  gst_bus_set_flushing (dc->priv->bus, FALSE);

  DISCO_LOCK (dc);
  dc->priv->current_error = NULL;
  if (dc->priv->current_topology) {
    gst_structure_free (dc->priv->current_topology);
    dc->priv->current_topology = NULL;
  }

  dc->priv->current_info = NULL;

  dc->priv->pending_subtitle_pads = 0;
  dc->priv->async_done = FALSE;

  /* Try popping the next uri */
  if (dc->priv->async) {
    if (dc->priv->pending_uris != NULL) {
      _setup_locked (dc);
      DISCO_UNLOCK (dc);
      /* Start timeout */
      handle_current_async (dc);
    } else {
      /* We're done ! */
      DISCO_UNLOCK (dc);
      g_signal_emit (dc, gst_discoverer_signals[SIGNAL_FINISHED], 0);
    }
  } else
    DISCO_UNLOCK (dc);

  GST_DEBUG ("out");
}

static void
discoverer_bus_cb (GstBus * bus, GstMessage * msg, GstDiscoverer * dc)
{
  if (dc->priv->processing) {
    if (handle_message (dc, msg)) {
      GST_DEBUG ("Stopping asynchronously");
      /* Serialise with _event_probe() */
      DISCO_LOCK (dc);
      dc->priv->processing = FALSE;
      DISCO_UNLOCK (dc);
      discoverer_collect (dc);
      discoverer_cleanup (dc);
    }
  }
}

static gboolean
async_timeout_cb (GstDiscoverer * dc)
{
  if (!g_source_is_destroyed (g_main_current_source ())) {
    dc->priv->timeoutid = 0;
    GST_DEBUG ("Setting result to TIMEOUT");
    dc->priv->current_info->result = GST_DISCOVERER_TIMEOUT;
    dc->priv->processing = FALSE;
    discoverer_collect (dc);
    discoverer_cleanup (dc);
  }
  return FALSE;
}

/* If there is a pending URI, it will pop it from the list of pending
 * URIs and start the discovery on it.
 *
 * Returns GST_DISCOVERER_OK if the next URI was popped and is processing,
 * else a error flag.
 */
static GstDiscovererResult
start_discovering (GstDiscoverer * dc)
{
  GstDiscovererResult res = GST_DISCOVERER_OK;

  GST_DEBUG ("Starting");

  DISCO_LOCK (dc);
  if (dc->priv->pending_uris == NULL) {
    GST_WARNING ("No URI to process");
    res = GST_DISCOVERER_URI_INVALID;
    DISCO_UNLOCK (dc);
    goto beach;
  }

  if (dc->priv->current_info != NULL) {
    GST_WARNING ("Already processing a file");
    res = GST_DISCOVERER_BUSY;
    DISCO_UNLOCK (dc);
    goto beach;
  }

  g_signal_emit (dc, gst_discoverer_signals[SIGNAL_STARTING], 0);

  _setup_locked (dc);

  DISCO_UNLOCK (dc);

  if (dc->priv->async)
    handle_current_async (dc);
  else
    handle_current_sync (dc);

beach:
  return res;
}


/**
 * gst_discoverer_start:
 * @discoverer: A #GstDiscoverer
 *
 * Allow asynchronous discovering of URIs to take place.
 * A #GMainLoop must be available for #GstDiscoverer to properly work in
 * asynchronous mode.
 */
void
gst_discoverer_start (GstDiscoverer * discoverer)
{
  GSource *source;
  GMainContext *ctx = NULL;

  GST_DEBUG_OBJECT (discoverer, "Starting...");

  if (discoverer->priv->async) {
    GST_DEBUG_OBJECT (discoverer, "We were already started");
    return;
  }

  discoverer->priv->async = TRUE;
  discoverer->priv->running = TRUE;

  ctx = g_main_context_get_thread_default ();

  /* Connect to bus signals */
  if (ctx == NULL)
    ctx = g_main_context_default ();

  source = gst_bus_create_watch (discoverer->priv->bus);
  g_source_set_callback (source, (GSourceFunc) gst_bus_async_signal_func,
      NULL, NULL);
  discoverer->priv->sourceid = g_source_attach (source, ctx);
  g_source_unref (source);
  discoverer->priv->ctx = g_main_context_ref (ctx);

  start_discovering (discoverer);
  GST_DEBUG_OBJECT (discoverer, "Started");
}

/**
 * gst_discoverer_stop:
 * @discoverer: A #GstDiscoverer
 *
 * Stop the discovery of any pending URIs and clears the list of
 * pending URIS (if any).
 */
void
gst_discoverer_stop (GstDiscoverer * discoverer)
{
  GST_DEBUG_OBJECT (discoverer, "Stopping...");

  if (!discoverer->priv->async) {
    GST_DEBUG_OBJECT (discoverer,
        "We were already stopped, or running synchronously");
    return;
  }

  DISCO_LOCK (discoverer);
  if (discoverer->priv->processing) {
    /* We prevent any further processing by setting the bus to
     * flushing and setting the pipeline to READY.
     * _reset() will take care of the rest of the cleanup */
    if (discoverer->priv->bus)
      gst_bus_set_flushing (discoverer->priv->bus, TRUE);
    if (discoverer->priv->pipeline)
      gst_element_set_state ((GstElement *) discoverer->priv->pipeline,
          GST_STATE_READY);
  }
  discoverer->priv->running = FALSE;
  DISCO_UNLOCK (discoverer);

  /* Remove timeout handler */
  if (discoverer->priv->timeoutid) {
    g_source_remove (discoverer->priv->timeoutid);
    discoverer->priv->timeoutid = 0;
  }
  /* Remove signal watch */
  if (discoverer->priv->sourceid) {
    g_source_remove (discoverer->priv->sourceid);
    discoverer->priv->sourceid = 0;
  }
  /* Unref main context */
  if (discoverer->priv->ctx) {
    g_main_context_unref (discoverer->priv->ctx);
    discoverer->priv->ctx = NULL;
  }
  discoverer_reset (discoverer);

  discoverer->priv->async = FALSE;

  GST_DEBUG_OBJECT (discoverer, "Stopped");
}

/**
 * gst_discoverer_discover_uri_async:
 * @discoverer: A #GstDiscoverer
 * @uri: the URI to add.
 *
 * Appends the given @uri to the list of URIs to discoverer. The actual
 * discovery of the @uri will only take place if gst_discoverer_start() has
 * been called.
 *
 * A copy of @uri will be made internally, so the caller can safely g_free()
 * afterwards.
 *
 * Returns: %TRUE if the @uri was successfully appended to the list of pending
 * uris, else %FALSE
 */
gboolean
gst_discoverer_discover_uri_async (GstDiscoverer * discoverer,
    const gchar * uri)
{
  gboolean can_run;

  GST_DEBUG_OBJECT (discoverer, "uri : %s", uri);

  DISCO_LOCK (discoverer);
  can_run = (discoverer->priv->pending_uris == NULL);
  discoverer->priv->pending_uris =
      g_list_append (discoverer->priv->pending_uris, g_strdup (uri));
  DISCO_UNLOCK (discoverer);

  if (can_run)
    start_discovering (discoverer);

  return TRUE;
}


/* Synchronous mode */
/**
 * gst_discoverer_discover_uri:
 * @discoverer: A #GstDiscoverer
 * @uri: The URI to run on.
 * @err: (out) (allow-none): If an error occurred, this field will be filled in.
 *
 * Synchronously discovers the given @uri.
 *
 * A copy of @uri will be made internally, so the caller can safely g_free()
 * afterwards.
 *
 * Returns: (transfer full): the result of the scanning. Can be %NULL if an
 * error occurred.
 */
GstDiscovererInfo *
gst_discoverer_discover_uri (GstDiscoverer * discoverer, const gchar * uri,
    GError ** err)
{
  GstDiscovererResult res = 0;
  GstDiscovererInfo *info;

  GST_DEBUG_OBJECT (discoverer, "uri:%s", uri);

  DISCO_LOCK (discoverer);
  if (G_UNLIKELY (discoverer->priv->current_info)) {
    DISCO_UNLOCK (discoverer);
    GST_WARNING_OBJECT (discoverer, "Already handling a uri");
    return NULL;
  }

  discoverer->priv->pending_uris =
      g_list_append (discoverer->priv->pending_uris, g_strdup (uri));
  DISCO_UNLOCK (discoverer);

  res = start_discovering (discoverer);
  discoverer_collect (discoverer);

  /* Get results */
  if (err) {
    if (discoverer->priv->current_error)
      *err = g_error_copy (discoverer->priv->current_error);
    else
      *err = NULL;
  }
  if (res != GST_DISCOVERER_OK) {
    GST_DEBUG ("Setting result to %d (was %d)", res,
        discoverer->priv->current_info->result);
    discoverer->priv->current_info->result = res;
  }
  info = discoverer->priv->current_info;

  discoverer_cleanup (discoverer);

  return info;
}

/**
 * gst_discoverer_new:
 * @timeout: timeout per file, in nanoseconds. Allowed are values between
 *     one second (#GST_SECOND) and one hour (3600 * #GST_SECOND)
 * @err: a pointer to a #GError. can be %NULL
 *
 * Creates a new #GstDiscoverer with the provided timeout.
 *
 * Returns: (transfer full): The new #GstDiscoverer.
 * If an error occurred when creating the discoverer, @err will be set
 * accordingly and %NULL will be returned. If @err is set, the caller must
 * free it when no longer needed using g_error_free().
 */
GstDiscoverer *
gst_discoverer_new (GstClockTime timeout, GError ** err)
{
  GstDiscoverer *res;

  res = g_object_new (GST_TYPE_DISCOVERER, "timeout", timeout, NULL);
  if (res->priv->uridecodebin == NULL) {
    if (err)
      *err = g_error_new (GST_CORE_ERROR, GST_CORE_ERROR_MISSING_PLUGIN,
          "Couldn't create 'uridecodebin' element");
    gst_object_unref (res);
    res = NULL;
  }
  return res;
}
