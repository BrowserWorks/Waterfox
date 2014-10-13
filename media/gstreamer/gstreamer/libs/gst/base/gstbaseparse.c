/* GStreamer
 * Copyright (C) 2008 Nokia Corporation. All rights reserved.
 *   Contact: Stefan Kost <stefan.kost@nokia.com>
 * Copyright (C) 2008 Sebastian Dröge <sebastian.droege@collabora.co.uk>.
 * Copyright (C) 2011, Hewlett-Packard Development Company, L.P.
 *   Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>, Collabora Ltd.
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
 * SECTION:gstbaseparse
 * @short_description: Base class for stream parsers
 * @see_also: #GstBaseTransform
 *
 * This base class is for parser elements that process data and splits it
 * into separate audio/video/whatever frames.
 *
 * It provides for:
 * <itemizedlist>
 *   <listitem><para>provides one sink pad and one source pad</para></listitem>
 *   <listitem><para>handles state changes</para></listitem>
 *   <listitem><para>can operate in pull mode or push mode</para></listitem>
 *   <listitem><para>handles seeking in both modes</para></listitem>
 *   <listitem><para>handles events (SEGMENT/EOS/FLUSH)</para></listitem>
 *   <listitem><para>
 *        handles queries (POSITION/DURATION/SEEKING/FORMAT/CONVERT)
 *   </para></listitem>
 *   <listitem><para>handles flushing</para></listitem>
 * </itemizedlist>
 *
 * The purpose of this base class is to provide the basic functionality of
 * a parser and share a lot of rather complex code.
 *
 * Description of the parsing mechanism:
 * <orderedlist>
 * <listitem>
 *   <itemizedlist><title>Set-up phase</title>
 *   <listitem><para>
 *     #GstBaseParse calls @start to inform subclass that data processing is
 *     about to start now.
 *   </para></listitem>
 *   <listitem><para>
 *     #GstBaseParse class calls @set_sink_caps to inform the subclass about
 *     incoming sinkpad caps. Subclass could already set the srcpad caps
 *     accordingly, but this might be delayed until calling
 *     gst_base_parse_finish_frame() with a non-queued frame.
 *   </para></listitem>
 *   <listitem><para>
 *      At least at this point subclass needs to tell the #GstBaseParse class
 *      how big data chunks it wants to receive (min_frame_size). It can do
 *      this with gst_base_parse_set_min_frame_size().
 *   </para></listitem>
 *   <listitem><para>
 *      #GstBaseParse class sets up appropriate data passing mode (pull/push)
 *      and starts to process the data.
 *   </para></listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist>
 *   <title>Parsing phase</title>
 *     <listitem><para>
 *       #GstBaseParse gathers at least min_frame_size bytes of data either
 *       by pulling it from upstream or collecting buffers in an internal
 *       #GstAdapter.
 *     </para></listitem>
 *     <listitem><para>
 *       A buffer of (at least) min_frame_size bytes is passed to subclass with
 *       @handle_frame. Subclass checks the contents and can optionally
 *       return GST_FLOW_OK along with an amount of data to be skipped to find
 *       a valid frame (which will result in a subsequent DISCONT).
 *       If, otherwise, the buffer does not hold a complete frame,
 *       @handle_frame can merely return and will be called again when additional
 *       data is available.  In push mode this amounts to an
 *       additional input buffer (thus minimal additional latency), in pull mode
 *       this amounts to some arbitrary reasonable buffer size increase.
 *       Of course, gst_base_parse_set_min_frame_size() could also be used if a
 *       very specific known amount of additional data is required.
 *       If, however, the buffer holds a complete valid frame, it can pass
 *       the size of this frame to gst_base_parse_finish_frame().
 *       If acting as a converter, it can also merely indicate consumed input data
 *       while simultaneously providing custom output data.
 *       Note that baseclass performs some processing (such as tracking
 *       overall consumed data rate versus duration) for each finished frame,
 *       but other state is only updated upon each call to @handle_frame
 *       (such as tracking upstream input timestamp).
 *       </para><para>
 *       Subclass is also responsible for setting the buffer metadata
 *       (e.g. buffer timestamp and duration, or keyframe if applicable).
 *       (although the latter can also be done by #GstBaseParse if it is
 *       appropriately configured, see below).  Frame is provided with
 *       timestamp derived from upstream (as much as generally possible),
 *       duration obtained from configuration (see below), and offset
 *       if meaningful (in pull mode).
 *       </para><para>
 *       Note that @check_valid_frame might receive any small
 *       amount of input data when leftover data is being drained (e.g. at EOS).
 *     </para></listitem>
 *     <listitem><para>
 *       As part of finish frame processing,
 *       just prior to actually pushing the buffer in question,
 *       it is passed to @pre_push_frame which gives subclass yet one
 *       last chance to examine buffer metadata, or to send some custom (tag)
 *       events, or to perform custom (segment) filtering.
 *     </para></listitem>
 *     <listitem><para>
 *       During the parsing process #GstBaseParseClass will handle both srcpad
 *       and sinkpad events. They will be passed to subclass if @event or
 *       @src_event callbacks have been provided.
 *     </para></listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist><title>Shutdown phase</title>
 *   <listitem><para>
 *     #GstBaseParse class calls @stop to inform the subclass that data
 *     parsing will be stopped.
 *   </para></listitem>
 *   </itemizedlist>
 * </listitem>
 * </orderedlist>
 *
 * Subclass is responsible for providing pad template caps for
 * source and sink pads. The pads need to be named "sink" and "src". It also
 * needs to set the fixed caps on srcpad, when the format is ensured (e.g.
 * when base class calls subclass' @set_sink_caps function).
 *
 * This base class uses %GST_FORMAT_DEFAULT as a meaning of frames. So,
 * subclass conversion routine needs to know that conversion from
 * %GST_FORMAT_TIME to %GST_FORMAT_DEFAULT must return the
 * frame number that can be found from the given byte position.
 *
 * #GstBaseParse uses subclasses conversion methods also for seeking (or
 * otherwise uses its own default one, see also below).
 *
 * Subclass @start and @stop functions will be called to inform the beginning
 * and end of data processing.
 *
 * Things that subclass need to take care of:
 * <itemizedlist>
 *   <listitem><para>Provide pad templates</para></listitem>
 *   <listitem><para>
 *      Fixate the source pad caps when appropriate
 *   </para></listitem>
 *   <listitem><para>
 *      Inform base class how big data chunks should be retrieved. This is
 *      done with gst_base_parse_set_min_frame_size() function.
 *   </para></listitem>
 *   <listitem><para>
 *      Examine data chunks passed to subclass with @handle_frame and pass
 *      proper frame(s) to gst_base_parse_finish_frame(), and setting src pad
 *      caps and timestamps on frame.
 *   </para></listitem>
 *   <listitem><para>Provide conversion functions</para></listitem>
 *   <listitem><para>
 *      Update the duration information with gst_base_parse_set_duration()
 *   </para></listitem>
 *   <listitem><para>
 *      Optionally passthrough using gst_base_parse_set_passthrough()
 *   </para></listitem>
 *   <listitem><para>
 *      Configure various baseparse parameters using
 *      gst_base_parse_set_average_bitrate(), gst_base_parse_set_syncable()
 *      and gst_base_parse_set_frame_rate().
 *   </para></listitem>
 *   <listitem><para>
 *      In particular, if subclass is unable to determine a duration, but
 *      parsing (or specs) yields a frames per seconds rate, then this can be
 *      provided to #GstBaseParse to enable it to cater for
 *      buffer time metadata (which will be taken from upstream as much as
 *      possible). Internally keeping track of frame durations and respective
 *      sizes that have been pushed provides #GstBaseParse with an estimated
 *      bitrate. A default @convert (used if not overridden) will then use these
 *      rates to perform obvious conversions.  These rates are also used to
 *      update (estimated) duration at regular frame intervals.
 *   </para></listitem>
 * </itemizedlist>
 *
 */

/* TODO:
 *  - In push mode provide a queue of adapter-"queued" buffers for upstream
 *    buffer metadata
 *  - Queue buffers/events until caps are set
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include <gst/base/gstadapter.h>

#include "gstbaseparse.h"

/* FIXME: get rid of old GstIndex code */
#include "gstindex.h"
#include "gstindex.c"
#include "gstmemindex.c"

#define GST_BASE_PARSE_FRAME_PRIVATE_FLAG_NOALLOC  (1 << 0)

#define MIN_FRAMES_TO_POST_BITRATE 10
#define TARGET_DIFFERENCE          (20 * GST_SECOND)
#define MAX_INDEX_ENTRIES          4096

GST_DEBUG_CATEGORY_STATIC (gst_base_parse_debug);
#define GST_CAT_DEFAULT gst_base_parse_debug

/* Supported formats */
static const GstFormat fmtlist[] = {
  GST_FORMAT_DEFAULT,
  GST_FORMAT_BYTES,
  GST_FORMAT_TIME,
  GST_FORMAT_UNDEFINED
};

#define GST_BASE_PARSE_GET_PRIVATE(obj)  \
    (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_BASE_PARSE, GstBaseParsePrivate))

struct _GstBaseParsePrivate
{
  GstPadMode pad_mode;

  GstAdapter *adapter;

  gint64 duration;
  GstFormat duration_fmt;
  gint64 estimated_duration;
  gint64 estimated_drift;

  guint min_frame_size;
  gboolean disable_passthrough;
  gboolean passthrough;
  gboolean pts_interpolate;
  gboolean infer_ts;
  gboolean syncable;
  gboolean has_timing_info;
  guint fps_num, fps_den;
  gint update_interval;
  guint bitrate;
  guint lead_in, lead_out;
  GstClockTime lead_in_ts, lead_out_ts;
  GstClockTime min_latency, max_latency;

  gboolean discont;
  gboolean flushing;
  gboolean drain;

  gint64 offset;
  gint64 sync_offset;
  GstClockTime next_pts;
  GstClockTime next_dts;
  GstClockTime prev_pts;
  GstClockTime prev_dts;
  GstClockTime frame_duration;
  gboolean seen_keyframe;
  gboolean is_video;
  gint flushed;

  guint64 framecount;
  guint64 bytecount;
  guint64 data_bytecount;
  guint64 acc_duration;
  GstClockTime first_frame_pts;
  GstClockTime first_frame_dts;
  gint64 first_frame_offset;

  gboolean post_min_bitrate;
  gboolean post_avg_bitrate;
  gboolean post_max_bitrate;
  guint min_bitrate;
  guint avg_bitrate;
  guint max_bitrate;
  guint posted_avg_bitrate;

  /* frames/buffers that are queued and ready to go on OK */
  GQueue queued_frames;

  GstBuffer *cache;

  /* index entry storage, either ours or provided */
  GstIndex *index;
  gint index_id;
  gboolean own_index;
  GMutex index_lock;

  /* seek table entries only maintained if upstream is BYTE seekable */
  gboolean upstream_seekable;
  gboolean upstream_has_duration;
  gint64 upstream_size;
  GstFormat upstream_format;
  /* minimum distance between two index entries */
  GstClockTimeDiff idx_interval;
  guint64 idx_byte_interval;
  /* ts and offset of last entry added */
  GstClockTime index_last_ts;
  gint64 index_last_offset;
  gboolean index_last_valid;

  /* timestamps currently produced are accurate, e.g. started from 0 onwards */
  gboolean exact_position;
  /* seek events are temporarily kept to match them with newsegments */
  GSList *pending_seeks;

  /* reverse playback */
  GSList *buffers_pending;
  GSList *buffers_head;
  GSList *buffers_queued;
  GSList *buffers_send;
  GstClockTime last_pts;
  GstClockTime last_dts;
  gint64 last_offset;

  /* Pending serialized events */
  GList *pending_events;

  /* If baseparse has checked the caps to identify if it is
   * handling video or audio */
  gboolean checked_media;

  /* offset of last parsed frame/data */
  gint64 prev_offset;
  /* force a new frame, regardless of offset */
  gboolean new_frame;
  /* whether we are merely scanning for a frame */
  gboolean scanning;
  /* ... and resulting frame, if any */
  GstBaseParseFrame *scanned_frame;

  /* TRUE if we're still detecting the format, i.e.
   * if ::detect() is still called for future buffers */
  gboolean detecting;
  GList *detect_buffers;
  guint detect_buffers_size;

  /* if TRUE, a STREAM_START event needs to be pushed */
  gboolean push_stream_start;
};

typedef struct _GstBaseParseSeek
{
  GstSegment segment;
  gboolean accurate;
  gint64 offset;
  GstClockTime start_ts;
} GstBaseParseSeek;

#define DEFAULT_DISABLE_PASSTHROUGH        FALSE

enum
{
  PROP_0,
  PROP_DISABLE_PASSTHROUGH,
  PROP_LAST
};

#define GST_BASE_PARSE_INDEX_LOCK(parse) \
  g_mutex_lock (&parse->priv->index_lock);
#define GST_BASE_PARSE_INDEX_UNLOCK(parse) \
  g_mutex_unlock (&parse->priv->index_lock);

static GstElementClass *parent_class = NULL;

static void gst_base_parse_class_init (GstBaseParseClass * klass);
static void gst_base_parse_init (GstBaseParse * parse,
    GstBaseParseClass * klass);

GType
gst_base_parse_get_type (void)
{
  static volatile gsize base_parse_type = 0;

  if (g_once_init_enter (&base_parse_type)) {
    static const GTypeInfo base_parse_info = {
      sizeof (GstBaseParseClass),
      (GBaseInitFunc) NULL,
      (GBaseFinalizeFunc) NULL,
      (GClassInitFunc) gst_base_parse_class_init,
      NULL,
      NULL,
      sizeof (GstBaseParse),
      0,
      (GInstanceInitFunc) gst_base_parse_init,
    };
    GType _type;

    _type = g_type_register_static (GST_TYPE_ELEMENT,
        "GstBaseParse", &base_parse_info, G_TYPE_FLAG_ABSTRACT);
    g_once_init_leave (&base_parse_type, _type);
  }
  return (GType) base_parse_type;
}

static void gst_base_parse_finalize (GObject * object);

static GstStateChangeReturn gst_base_parse_change_state (GstElement * element,
    GstStateChange transition);
static void gst_base_parse_reset (GstBaseParse * parse);

#if 0
static void gst_base_parse_set_index (GstElement * element, GstIndex * index);
static GstIndex *gst_base_parse_get_index (GstElement * element);
#endif

static gboolean gst_base_parse_sink_activate (GstPad * sinkpad,
    GstObject * parent);
static gboolean gst_base_parse_sink_activate_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_base_parse_handle_seek (GstBaseParse * parse,
    GstEvent * event);
static void gst_base_parse_handle_tag (GstBaseParse * parse, GstEvent * event);

static void gst_base_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_base_parse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_base_parse_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_base_parse_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

static gboolean gst_base_parse_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_base_parse_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query);

static GstFlowReturn gst_base_parse_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static void gst_base_parse_loop (GstPad * pad);

static GstFlowReturn gst_base_parse_parse_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame);

static gboolean gst_base_parse_sink_event_default (GstBaseParse * parse,
    GstEvent * event);

static gboolean gst_base_parse_src_event_default (GstBaseParse * parse,
    GstEvent * event);

static gboolean gst_base_parse_sink_query_default (GstBaseParse * parse,
    GstQuery * query);
static gboolean gst_base_parse_src_query_default (GstBaseParse * parse,
    GstQuery * query);

static void gst_base_parse_drain (GstBaseParse * parse);

static void gst_base_parse_post_bitrates (GstBaseParse * parse,
    gboolean post_min, gboolean post_avg, gboolean post_max);

static gint64 gst_base_parse_find_offset (GstBaseParse * parse,
    GstClockTime time, gboolean before, GstClockTime * _ts);
static GstFlowReturn gst_base_parse_locate_time (GstBaseParse * parse,
    GstClockTime * _time, gint64 * _offset);

static GstFlowReturn gst_base_parse_start_fragment (GstBaseParse * parse);
static GstFlowReturn gst_base_parse_finish_fragment (GstBaseParse * parse,
    gboolean prev_head);
static GstFlowReturn gst_base_parse_send_buffers (GstBaseParse * parse);

static inline GstFlowReturn gst_base_parse_check_sync (GstBaseParse * parse);

static gboolean gst_base_parse_is_seekable (GstBaseParse * parse);

static void gst_base_parse_push_pending_events (GstBaseParse * parse);

static void
gst_base_parse_clear_queues (GstBaseParse * parse)
{
  g_slist_foreach (parse->priv->buffers_queued, (GFunc) gst_buffer_unref, NULL);
  g_slist_free (parse->priv->buffers_queued);
  parse->priv->buffers_queued = NULL;
  g_slist_foreach (parse->priv->buffers_pending, (GFunc) gst_buffer_unref,
      NULL);
  g_slist_free (parse->priv->buffers_pending);
  parse->priv->buffers_pending = NULL;
  g_slist_foreach (parse->priv->buffers_head, (GFunc) gst_buffer_unref, NULL);
  g_slist_free (parse->priv->buffers_head);
  parse->priv->buffers_head = NULL;
  g_slist_foreach (parse->priv->buffers_send, (GFunc) gst_buffer_unref, NULL);
  g_slist_free (parse->priv->buffers_send);
  parse->priv->buffers_send = NULL;

  g_list_foreach (parse->priv->detect_buffers, (GFunc) gst_buffer_unref, NULL);
  g_list_free (parse->priv->detect_buffers);
  parse->priv->detect_buffers = NULL;
  parse->priv->detect_buffers_size = 0;

  g_queue_foreach (&parse->priv->queued_frames,
      (GFunc) gst_base_parse_frame_free, NULL);
  g_queue_clear (&parse->priv->queued_frames);

  gst_buffer_replace (&parse->priv->cache, NULL);

  g_list_foreach (parse->priv->pending_events, (GFunc) gst_event_unref, NULL);
  g_list_free (parse->priv->pending_events);
  parse->priv->pending_events = NULL;

  parse->priv->checked_media = FALSE;
}

static void
gst_base_parse_finalize (GObject * object)
{
  GstBaseParse *parse = GST_BASE_PARSE (object);

  g_object_unref (parse->priv->adapter);

  if (parse->priv->cache) {
    gst_buffer_unref (parse->priv->cache);
    parse->priv->cache = NULL;
  }

  g_list_foreach (parse->priv->pending_events, (GFunc) gst_mini_object_unref,
      NULL);
  g_list_free (parse->priv->pending_events);
  parse->priv->pending_events = NULL;

  if (parse->priv->index) {
    gst_object_unref (parse->priv->index);
    parse->priv->index = NULL;
  }
  g_mutex_clear (&parse->priv->index_lock);

  gst_base_parse_clear_queues (parse);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_base_parse_class_init (GstBaseParseClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = G_OBJECT_CLASS (klass);
  g_type_class_add_private (klass, sizeof (GstBaseParsePrivate));
  parent_class = g_type_class_peek_parent (klass);

  gobject_class->finalize = GST_DEBUG_FUNCPTR (gst_base_parse_finalize);
  gobject_class->set_property = GST_DEBUG_FUNCPTR (gst_base_parse_set_property);
  gobject_class->get_property = GST_DEBUG_FUNCPTR (gst_base_parse_get_property);

  /**
   * GstBaseParse:disable-passthrough:
   *
   * If set to %TRUE, baseparse will unconditionally force parsing of the
   * incoming data. This can be required in the rare cases where the incoming
   * side-data (caps, pts, dts, ...) is not trusted by the user and wants to
   * force validation and parsing of the incoming data.
   * If set to %FALSE, decision of whether to parse the data or not is up to
   * the implementation (standard behaviour).
   */
  g_object_class_install_property (gobject_class, PROP_DISABLE_PASSTHROUGH,
      g_param_spec_boolean ("disable-passthrough", "Disable passthrough",
          "Force processing (disables passthrough)",
          DEFAULT_DISABLE_PASSTHROUGH,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gstelement_class = (GstElementClass *) klass;
  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_base_parse_change_state);

#if 0
  gstelement_class->set_index = GST_DEBUG_FUNCPTR (gst_base_parse_set_index);
  gstelement_class->get_index = GST_DEBUG_FUNCPTR (gst_base_parse_get_index);
#endif

  /* Default handlers */
  klass->sink_event = gst_base_parse_sink_event_default;
  klass->src_event = gst_base_parse_src_event_default;
  klass->sink_query = gst_base_parse_sink_query_default;
  klass->src_query = gst_base_parse_src_query_default;
  klass->convert = gst_base_parse_convert_default;

  GST_DEBUG_CATEGORY_INIT (gst_base_parse_debug, "baseparse", 0,
      "baseparse element");
}

static void
gst_base_parse_init (GstBaseParse * parse, GstBaseParseClass * bclass)
{
  GstPadTemplate *pad_template;

  GST_DEBUG_OBJECT (parse, "gst_base_parse_init");

  parse->priv = GST_BASE_PARSE_GET_PRIVATE (parse);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (bclass), "sink");
  g_return_if_fail (pad_template != NULL);
  parse->sinkpad = gst_pad_new_from_template (pad_template, "sink");
  gst_pad_set_event_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_sink_event));
  gst_pad_set_query_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_sink_query));
  gst_pad_set_chain_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_chain));
  gst_pad_set_activate_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_sink_activate));
  gst_pad_set_activatemode_function (parse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_sink_activate_mode));
  GST_PAD_SET_PROXY_ALLOCATION (parse->sinkpad);
  gst_element_add_pad (GST_ELEMENT (parse), parse->sinkpad);

  GST_DEBUG_OBJECT (parse, "sinkpad created");

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (bclass), "src");
  g_return_if_fail (pad_template != NULL);
  parse->srcpad = gst_pad_new_from_template (pad_template, "src");
  gst_pad_set_event_function (parse->srcpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_src_event));
  gst_pad_set_query_function (parse->srcpad,
      GST_DEBUG_FUNCPTR (gst_base_parse_src_query));
  gst_pad_use_fixed_caps (parse->srcpad);
  gst_element_add_pad (GST_ELEMENT (parse), parse->srcpad);
  GST_DEBUG_OBJECT (parse, "src created");

  g_queue_init (&parse->priv->queued_frames);

  parse->priv->adapter = gst_adapter_new ();

  parse->priv->pad_mode = GST_PAD_MODE_NONE;

  g_mutex_init (&parse->priv->index_lock);

  /* init state */
  gst_base_parse_reset (parse);
  GST_DEBUG_OBJECT (parse, "init ok");

  GST_OBJECT_FLAG_SET (parse, GST_ELEMENT_FLAG_INDEXABLE);
}

static void
gst_base_parse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstBaseParse *parse = GST_BASE_PARSE (object);

  switch (prop_id) {
    case PROP_DISABLE_PASSTHROUGH:
      parse->priv->disable_passthrough = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_base_parse_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstBaseParse *parse = GST_BASE_PARSE (object);

  switch (prop_id) {
    case PROP_DISABLE_PASSTHROUGH:
      g_value_set_boolean (value, parse->priv->disable_passthrough);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstBaseParseFrame *
gst_base_parse_frame_copy (GstBaseParseFrame * frame)
{
  GstBaseParseFrame *copy;

  copy = g_slice_dup (GstBaseParseFrame, frame);
  copy->buffer = gst_buffer_ref (frame->buffer);
  copy->_private_flags &= ~GST_BASE_PARSE_FRAME_PRIVATE_FLAG_NOALLOC;

  GST_TRACE ("copied frame %p -> %p", frame, copy);

  return copy;
}

void
gst_base_parse_frame_free (GstBaseParseFrame * frame)
{
  GST_TRACE ("freeing frame %p", frame);

  if (frame->buffer) {
    gst_buffer_unref (frame->buffer);
    frame->buffer = NULL;
  }

  if (!(frame->_private_flags & GST_BASE_PARSE_FRAME_PRIVATE_FLAG_NOALLOC)) {
    g_slice_free (GstBaseParseFrame, frame);
  } else {
    memset (frame, 0, sizeof (*frame));
  }
}

G_DEFINE_BOXED_TYPE (GstBaseParseFrame, gst_base_parse_frame,
    (GBoxedCopyFunc) gst_base_parse_frame_copy,
    (GBoxedFreeFunc) gst_base_parse_frame_free);

/**
 * gst_base_parse_frame_init:
 * @frame: #GstBaseParseFrame.
 *
 * Sets a #GstBaseParseFrame to initial state.  Currently this means
 * all public fields are zero-ed and a private flag is set to make
 * sure gst_base_parse_frame_free() only frees the contents but not
 * the actual frame. Use this function to initialise a #GstBaseParseFrame
 * allocated on the stack.
 */
void
gst_base_parse_frame_init (GstBaseParseFrame * frame)
{
  memset (frame, 0, sizeof (GstBaseParseFrame));
  frame->_private_flags = GST_BASE_PARSE_FRAME_PRIVATE_FLAG_NOALLOC;
  GST_TRACE ("inited frame %p", frame);
}

/**
 * gst_base_parse_frame_new:
 * @buffer: (transfer none): a #GstBuffer
 * @flags: the flags
 * @overhead: number of bytes in this frame which should be counted as
 *     metadata overhead, ie. not used to calculate the average bitrate.
 *     Set to -1 to mark the entire frame as metadata. If in doubt, set to 0.
 *
 * Allocates a new #GstBaseParseFrame. This function is mainly for bindings,
 * elements written in C should usually allocate the frame on the stack and
 * then use gst_base_parse_frame_init() to initialise it.
 *
 * Returns: a newly-allocated #GstBaseParseFrame. Free with
 *     gst_base_parse_frame_free() when no longer needed.
 */
GstBaseParseFrame *
gst_base_parse_frame_new (GstBuffer * buffer, GstBaseParseFrameFlags flags,
    gint overhead)
{
  GstBaseParseFrame *frame;

  frame = g_slice_new0 (GstBaseParseFrame);
  frame->buffer = gst_buffer_ref (buffer);

  GST_TRACE ("created frame %p", frame);
  return frame;
}

static inline void
gst_base_parse_frame_update (GstBaseParse * parse, GstBaseParseFrame * frame,
    GstBuffer * buf)
{
  gst_buffer_replace (&frame->buffer, buf);

  parse->flags = 0;

  /* set flags one by one for clarity */
  if (G_UNLIKELY (parse->priv->drain))
    parse->flags |= GST_BASE_PARSE_FLAG_DRAINING;

  /* losing sync is pretty much a discont (and vice versa), no ? */
  if (G_UNLIKELY (parse->priv->discont))
    parse->flags |= GST_BASE_PARSE_FLAG_LOST_SYNC;
}

static void
gst_base_parse_reset (GstBaseParse * parse)
{
  GST_OBJECT_LOCK (parse);
  gst_segment_init (&parse->segment, GST_FORMAT_TIME);
  parse->priv->duration = -1;
  parse->priv->min_frame_size = 1;
  parse->priv->discont = TRUE;
  parse->priv->flushing = FALSE;
  parse->priv->offset = 0;
  parse->priv->sync_offset = 0;
  parse->priv->update_interval = -1;
  parse->priv->fps_num = parse->priv->fps_den = 0;
  parse->priv->frame_duration = GST_CLOCK_TIME_NONE;
  parse->priv->lead_in = parse->priv->lead_out = 0;
  parse->priv->lead_in_ts = parse->priv->lead_out_ts = 0;
  parse->priv->bitrate = 0;
  parse->priv->framecount = 0;
  parse->priv->bytecount = 0;
  parse->priv->acc_duration = 0;
  parse->priv->first_frame_pts = GST_CLOCK_TIME_NONE;
  parse->priv->first_frame_dts = GST_CLOCK_TIME_NONE;
  parse->priv->first_frame_offset = -1;
  parse->priv->estimated_duration = -1;
  parse->priv->estimated_drift = 0;
  parse->priv->next_pts = GST_CLOCK_TIME_NONE;
  parse->priv->next_dts = 0;
  parse->priv->syncable = TRUE;
  parse->priv->disable_passthrough = DEFAULT_DISABLE_PASSTHROUGH;
  parse->priv->passthrough = FALSE;
  parse->priv->pts_interpolate = TRUE;
  parse->priv->infer_ts = TRUE;
  parse->priv->has_timing_info = FALSE;
  parse->priv->post_min_bitrate = TRUE;
  parse->priv->post_avg_bitrate = TRUE;
  parse->priv->post_max_bitrate = TRUE;
  parse->priv->min_bitrate = G_MAXUINT;
  parse->priv->max_bitrate = 0;
  parse->priv->avg_bitrate = 0;
  parse->priv->posted_avg_bitrate = 0;

  parse->priv->index_last_ts = GST_CLOCK_TIME_NONE;
  parse->priv->index_last_offset = -1;
  parse->priv->index_last_valid = TRUE;
  parse->priv->upstream_seekable = FALSE;
  parse->priv->upstream_size = 0;
  parse->priv->upstream_has_duration = FALSE;
  parse->priv->upstream_format = GST_FORMAT_UNDEFINED;
  parse->priv->idx_interval = 0;
  parse->priv->idx_byte_interval = 0;
  parse->priv->exact_position = TRUE;
  parse->priv->seen_keyframe = FALSE;
  parse->priv->checked_media = FALSE;

  parse->priv->last_dts = GST_CLOCK_TIME_NONE;
  parse->priv->last_pts = GST_CLOCK_TIME_NONE;
  parse->priv->last_offset = 0;

  g_list_foreach (parse->priv->pending_events, (GFunc) gst_mini_object_unref,
      NULL);
  g_list_free (parse->priv->pending_events);
  parse->priv->pending_events = NULL;

  if (parse->priv->cache) {
    gst_buffer_unref (parse->priv->cache);
    parse->priv->cache = NULL;
  }

  g_slist_foreach (parse->priv->pending_seeks, (GFunc) g_free, NULL);
  g_slist_free (parse->priv->pending_seeks);
  parse->priv->pending_seeks = NULL;

  if (parse->priv->adapter)
    gst_adapter_clear (parse->priv->adapter);

  parse->priv->new_frame = TRUE;

  g_list_foreach (parse->priv->detect_buffers, (GFunc) gst_buffer_unref, NULL);
  g_list_free (parse->priv->detect_buffers);
  parse->priv->detect_buffers = NULL;
  parse->priv->detect_buffers_size = 0;
  GST_OBJECT_UNLOCK (parse);
}

/* gst_base_parse_parse_frame:
 * @parse: #GstBaseParse.
 * @buffer: #GstBuffer.
 *
 * Default callback for parse_frame.
 */
static GstFlowReturn
gst_base_parse_parse_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstBuffer *buffer = frame->buffer;

  if (!GST_BUFFER_PTS_IS_VALID (buffer) &&
      GST_CLOCK_TIME_IS_VALID (parse->priv->next_pts)) {
    GST_BUFFER_PTS (buffer) = parse->priv->next_pts;
  }
  if (!GST_BUFFER_DTS_IS_VALID (buffer) &&
      GST_CLOCK_TIME_IS_VALID (parse->priv->next_dts)) {
    GST_BUFFER_DTS (buffer) = parse->priv->next_dts;
  }
  if (!GST_BUFFER_DURATION_IS_VALID (buffer) &&
      GST_CLOCK_TIME_IS_VALID (parse->priv->frame_duration)) {
    GST_BUFFER_DURATION (buffer) = parse->priv->frame_duration;
  }
  return GST_FLOW_OK;
}

/* gst_base_parse_convert:
 * @parse: #GstBaseParse.
 * @src_format: #GstFormat describing the source format.
 * @src_value: Source value to be converted.
 * @dest_format: #GstFormat defining the converted format.
 * @dest_value: Pointer where the conversion result will be put.
 *
 * Converts using configured "convert" vmethod in #GstBaseParse class.
 *
 * Returns: %TRUE if conversion was successful.
 */
static gboolean
gst_base_parse_convert (GstBaseParse * parse,
    GstFormat src_format,
    gint64 src_value, GstFormat dest_format, gint64 * dest_value)
{
  GstBaseParseClass *klass = GST_BASE_PARSE_GET_CLASS (parse);
  gboolean ret;

  g_return_val_if_fail (dest_value != NULL, FALSE);

  if (!klass->convert)
    return FALSE;

  ret = klass->convert (parse, src_format, src_value, dest_format, dest_value);

#ifndef GST_DISABLE_GST_DEBUG
  {
    if (ret) {
      if (src_format == GST_FORMAT_TIME && dest_format == GST_FORMAT_BYTES) {
        GST_LOG_OBJECT (parse,
            "TIME -> BYTES: %" GST_TIME_FORMAT " -> %" G_GINT64_FORMAT,
            GST_TIME_ARGS (src_value), *dest_value);
      } else if (dest_format == GST_FORMAT_TIME &&
          src_format == GST_FORMAT_BYTES) {
        GST_LOG_OBJECT (parse,
            "BYTES -> TIME: %" G_GINT64_FORMAT " -> %" GST_TIME_FORMAT,
            src_value, GST_TIME_ARGS (*dest_value));
      } else {
        GST_LOG_OBJECT (parse,
            "%s -> %s: %" G_GINT64_FORMAT " -> %" G_GINT64_FORMAT,
            GST_STR_NULL (gst_format_get_name (src_format)),
            GST_STR_NULL (gst_format_get_name (dest_format)),
            src_value, *dest_value);
      }
    } else {
      GST_DEBUG_OBJECT (parse, "conversion failed");
    }
  }
#endif

  return ret;
}

/* gst_base_parse_sink_event:
 * @pad: #GstPad that received the event.
 * @event: #GstEvent to be handled.
 *
 * Handler for sink pad events.
 *
 * Returns: %TRUE if the event was handled.
 */
static gboolean
gst_base_parse_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstBaseParse *parse = GST_BASE_PARSE (parent);
  GstBaseParseClass *bclass = GST_BASE_PARSE_GET_CLASS (parse);
  gboolean ret;

  ret = bclass->sink_event (parse, event);

  return ret;
}


/* gst_base_parse_sink_event_default:
 * @parse: #GstBaseParse.
 * @event: #GstEvent to be handled.
 *
 * Element-level event handler function.
 *
 * The event will be unreffed only if it has been handled and this
 * function returns %TRUE
 *
 * Returns: %TRUE if the event was handled and not need forwarding.
 */
static gboolean
gst_base_parse_sink_event_default (GstBaseParse * parse, GstEvent * event)
{
  GstBaseParseClass *klass = GST_BASE_PARSE_GET_CLASS (parse);
  gboolean ret = FALSE;
  gboolean forward_immediate = FALSE;

  GST_DEBUG_OBJECT (parse, "handling event %d, %s", GST_EVENT_TYPE (event),
      GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      GST_DEBUG_OBJECT (parse, "caps: %" GST_PTR_FORMAT, caps);

      if (klass->set_sink_caps)
        ret = klass->set_sink_caps (parse, caps);
      else
        ret = TRUE;

      /* will send our own caps downstream */
      gst_event_unref (event);
      event = NULL;
      break;
    }
    case GST_EVENT_SEGMENT:
    {
      const GstSegment *in_segment;
      GstSegment out_segment;
      gint64 offset = 0, next_dts;
      guint32 seqnum = gst_event_get_seqnum (event);

      gst_event_parse_segment (event, &in_segment);
      gst_segment_init (&out_segment, GST_FORMAT_TIME);
      out_segment.rate = in_segment->rate;
      out_segment.applied_rate = in_segment->applied_rate;

      GST_DEBUG_OBJECT (parse, "segment %" GST_SEGMENT_FORMAT, in_segment);

      parse->priv->upstream_format = in_segment->format;
      if (in_segment->format == GST_FORMAT_BYTES) {
        GstBaseParseSeek *seek = NULL;
        GSList *node;

        /* stop time is allowed to be open-ended, but not start & pos */
        offset = in_segment->time;

        GST_OBJECT_LOCK (parse);
        for (node = parse->priv->pending_seeks; node; node = node->next) {
          GstBaseParseSeek *tmp = node->data;

          if (tmp->offset == offset) {
            seek = tmp;
            break;
          }
        }
        parse->priv->pending_seeks =
            g_slist_remove (parse->priv->pending_seeks, seek);
        GST_OBJECT_UNLOCK (parse);

        if (seek) {
          GST_DEBUG_OBJECT (parse,
              "Matched newsegment to%s seek: %" GST_SEGMENT_FORMAT,
              seek->accurate ? " accurate" : "", &seek->segment);

          out_segment.start = seek->segment.start;
          out_segment.stop = seek->segment.stop;
          out_segment.time = seek->segment.start;

          next_dts = seek->start_ts;
          parse->priv->exact_position = seek->accurate;
          g_free (seek);
        } else {
          /* best attempt convert */
          /* as these are only estimates, stop is kept open-ended to avoid
           * premature cutting */
          gst_base_parse_convert (parse, GST_FORMAT_BYTES, in_segment->start,
              GST_FORMAT_TIME, (gint64 *) & next_dts);

          out_segment.start = next_dts;
          out_segment.stop = GST_CLOCK_TIME_NONE;
          out_segment.time = next_dts;

          parse->priv->exact_position = (in_segment->start == 0);
        }

        gst_event_unref (event);

        event = gst_event_new_segment (&out_segment);
        gst_event_set_seqnum (event, seqnum);

        GST_DEBUG_OBJECT (parse, "Converted incoming segment to TIME. %"
            GST_SEGMENT_FORMAT, in_segment);

      } else if (in_segment->format != GST_FORMAT_TIME) {
        /* Unknown incoming segment format. Output a default open-ended
         * TIME segment */
        gst_event_unref (event);

        out_segment.start = 0;
        out_segment.stop = GST_CLOCK_TIME_NONE;
        out_segment.time = 0;

        event = gst_event_new_segment (&out_segment);
        gst_event_set_seqnum (event, seqnum);

        next_dts = 0;
      } else {
        /* not considered BYTE seekable if it is talking to us in TIME,
         * whatever else it might claim */
        parse->priv->upstream_seekable = FALSE;
        next_dts = in_segment->start;
        gst_event_copy_segment (event, &out_segment);
      }

      memcpy (&parse->segment, &out_segment, sizeof (GstSegment));

      /*
         gst_segment_set_newsegment (&parse->segment, update, rate,
         applied_rate, format, start, stop, start);
       */

      ret = TRUE;

      /* save the segment for later, right before we push a new buffer so that
       * the caps are fixed and the next linked element can receive
       * the segment but finish the current segment */
      GST_DEBUG_OBJECT (parse, "draining current segment");
      if (in_segment->rate > 0.0)
        gst_base_parse_drain (parse);
      else
        gst_base_parse_finish_fragment (parse, FALSE);
      gst_adapter_clear (parse->priv->adapter);

      parse->priv->offset = offset;
      parse->priv->sync_offset = offset;
      parse->priv->next_dts = next_dts;
      parse->priv->next_pts = GST_CLOCK_TIME_NONE;
      parse->priv->last_pts = GST_CLOCK_TIME_NONE;
      parse->priv->last_dts = GST_CLOCK_TIME_NONE;
      parse->priv->prev_pts = GST_CLOCK_TIME_NONE;
      parse->priv->prev_dts = GST_CLOCK_TIME_NONE;
      parse->priv->discont = TRUE;
      parse->priv->seen_keyframe = FALSE;
      break;
    }

    case GST_EVENT_FLUSH_START:
      GST_OBJECT_LOCK (parse);
      parse->priv->flushing = TRUE;
      GST_OBJECT_UNLOCK (parse);
      break;

    case GST_EVENT_FLUSH_STOP:
      gst_adapter_clear (parse->priv->adapter);
      gst_base_parse_clear_queues (parse);
      parse->priv->flushing = FALSE;
      parse->priv->discont = TRUE;
      parse->priv->last_pts = GST_CLOCK_TIME_NONE;
      parse->priv->last_dts = GST_CLOCK_TIME_NONE;
      parse->priv->new_frame = TRUE;

      forward_immediate = TRUE;
      break;

    case GST_EVENT_EOS:
      if (parse->segment.rate > 0.0)
        gst_base_parse_drain (parse);
      else
        gst_base_parse_finish_fragment (parse, TRUE);

      /* If we STILL have zero frames processed, fire an error */
      if (parse->priv->framecount == 0) {
        GST_ELEMENT_ERROR (parse, STREAM, WRONG_TYPE,
            ("No valid frames found before end of stream"), (NULL));
      }
      /* newsegment and other serialized events before eos */
      gst_base_parse_push_pending_events (parse);

      if (parse->priv->framecount < MIN_FRAMES_TO_POST_BITRATE) {
        /* We've not posted bitrate tags yet - do so now */
        gst_base_parse_post_bitrates (parse, TRUE, TRUE, TRUE);
      }
      forward_immediate = TRUE;
      break;
    case GST_EVENT_CUSTOM_DOWNSTREAM:{
      /* FIXME: Code duplicated from libgstvideo because core can't depend on -base */
#ifndef GST_VIDEO_EVENT_STILL_STATE_NAME
#define GST_VIDEO_EVENT_STILL_STATE_NAME "GstEventStillFrame"
#endif

      const GstStructure *s;
      gboolean ev_still_state;

      s = gst_event_get_structure (event);
      if (s != NULL &&
          gst_structure_has_name (s, GST_VIDEO_EVENT_STILL_STATE_NAME) &&
          gst_structure_get_boolean (s, "still-state", &ev_still_state)) {
        if (ev_still_state) {
          GST_DEBUG_OBJECT (parse, "draining current data for still-frame");
          if (parse->segment.rate > 0.0)
            gst_base_parse_drain (parse);
          else
            gst_base_parse_finish_fragment (parse, TRUE);
        }
        forward_immediate = TRUE;
      }
      break;
    }
    case GST_EVENT_GAP:
    {
      GST_DEBUG_OBJECT (parse, "draining current data due to gap event");

      gst_base_parse_push_pending_events (parse);

      if (parse->segment.rate > 0.0)
        gst_base_parse_drain (parse);
      else
        gst_base_parse_finish_fragment (parse, TRUE);
      forward_immediate = TRUE;
      break;
    }
    case GST_EVENT_TAG:
      /* See if any bitrate tags were posted */
      gst_base_parse_handle_tag (parse, event);
      break;

    case GST_EVENT_STREAM_START:
      if (parse->priv->pad_mode != GST_PAD_MODE_PULL)
        forward_immediate = TRUE;
      break;

    default:
      break;
  }

  /* Forward non-serialized events and EOS/FLUSH_STOP immediately.
   * For EOS this is required because no buffer or serialized event
   * will come after EOS and nothing could trigger another
   * _finish_frame() call.   *
   * If the subclass handles sending of EOS manually it can return
   * _DROPPED from ::finish() and all other subclasses should have
   * decoded/flushed all remaining data before this
   *
   * For FLUSH_STOP this is required because it is expected
   * to be forwarded immediately and no buffers are queued anyway.
   */
  if (event) {
    if (!GST_EVENT_IS_SERIALIZED (event) || forward_immediate) {
      ret = gst_pad_push_event (parse->srcpad, event);
    } else {
      // GST_VIDEO_DECODER_STREAM_LOCK (decoder);
      parse->priv->pending_events =
          g_list_prepend (parse->priv->pending_events, event);
      // GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      ret = TRUE;
    }
  }

  GST_DEBUG_OBJECT (parse, "event handled");

  return ret;
}

static gboolean
gst_base_parse_sink_query_default (GstBaseParse * parse, GstQuery * query)
{
  GstPad *pad;
  gboolean res;

  pad = GST_BASE_PARSE_SINK_PAD (parse);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_CAPS:
    {
      GstBaseParseClass *bclass;

      bclass = GST_BASE_PARSE_GET_CLASS (parse);

      if (bclass->get_sink_caps) {
        GstCaps *caps, *filter;

        gst_query_parse_caps (query, &filter);
        caps = bclass->get_sink_caps (parse, filter);
        GST_LOG_OBJECT (parse, "sink getcaps returning caps %" GST_PTR_FORMAT,
            caps);
        gst_query_set_caps_result (query, caps);
        gst_caps_unref (caps);

        res = TRUE;
      } else {
        GstCaps *caps, *template_caps, *filter;

        gst_query_parse_caps (query, &filter);
        template_caps = gst_pad_get_pad_template_caps (pad);
        if (filter != NULL) {
          caps =
              gst_caps_intersect_full (filter, template_caps,
              GST_CAPS_INTERSECT_FIRST);
          gst_caps_unref (template_caps);
        } else {
          caps = template_caps;
        }
        gst_query_set_caps_result (query, caps);
        gst_caps_unref (caps);

        res = TRUE;
      }
      break;
    }
    default:
    {
      res = gst_pad_query_default (pad, GST_OBJECT_CAST (parse), query);
      break;
    }
  }

  return res;
}

static gboolean
gst_base_parse_sink_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstBaseParseClass *bclass;
  GstBaseParse *parse;
  gboolean ret;

  parse = GST_BASE_PARSE (parent);
  bclass = GST_BASE_PARSE_GET_CLASS (parse);

  GST_DEBUG_OBJECT (parse, "%s query", GST_QUERY_TYPE_NAME (query));

  if (bclass->sink_query)
    ret = bclass->sink_query (parse, query);
  else
    ret = FALSE;

  GST_LOG_OBJECT (parse, "%s query result: %d %" GST_PTR_FORMAT,
      GST_QUERY_TYPE_NAME (query), ret, query);

  return ret;
}

static gboolean
gst_base_parse_src_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstBaseParseClass *bclass;
  GstBaseParse *parse;
  gboolean ret;

  parse = GST_BASE_PARSE (parent);
  bclass = GST_BASE_PARSE_GET_CLASS (parse);

  GST_DEBUG_OBJECT (parse, "%s query: %" GST_PTR_FORMAT,
      GST_QUERY_TYPE_NAME (query), query);

  if (bclass->src_query)
    ret = bclass->src_query (parse, query);
  else
    ret = FALSE;

  GST_LOG_OBJECT (parse, "%s query result: %d %" GST_PTR_FORMAT,
      GST_QUERY_TYPE_NAME (query), ret, query);

  return ret;
}

/* gst_base_parse_src_event:
 * @pad: #GstPad that received the event.
 * @event: #GstEvent that was received.
 *
 * Handler for source pad events.
 *
 * Returns: %TRUE if the event was handled.
 */
static gboolean
gst_base_parse_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstBaseParse *parse;
  GstBaseParseClass *bclass;
  gboolean ret = TRUE;

  parse = GST_BASE_PARSE (parent);
  bclass = GST_BASE_PARSE_GET_CLASS (parse);

  GST_DEBUG_OBJECT (parse, "event %d, %s", GST_EVENT_TYPE (event),
      GST_EVENT_TYPE_NAME (event));

  if (bclass->src_event)
    ret = bclass->src_event (parse, event);
  else
    gst_event_unref (event);

  return ret;
}

static gboolean
gst_base_parse_is_seekable (GstBaseParse * parse)
{
  /* FIXME: could do more here, e.g. check index or just send data from 0
   * in pull mode and let decoder/sink clip */
  return parse->priv->syncable;
}

/* gst_base_parse_src_event_default:
 * @parse: #GstBaseParse.
 * @event: #GstEvent that was received.
 *
 * Default srcpad event handler.
 *
 * Returns: %TRUE if the event was handled and can be dropped.
 */
static gboolean
gst_base_parse_src_event_default (GstBaseParse * parse, GstEvent * event)
{
  gboolean res = FALSE;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
      if (gst_base_parse_is_seekable (parse))
        res = gst_base_parse_handle_seek (parse, event);
      break;
    default:
      res = gst_pad_event_default (parse->srcpad, GST_OBJECT_CAST (parse),
          event);
      break;
  }
  return res;
}


/**
 * gst_base_parse_convert_default:
 * @parse: #GstBaseParse.
 * @src_format: #GstFormat describing the source format.
 * @src_value: Source value to be converted.
 * @dest_format: #GstFormat defining the converted format.
 * @dest_value: Pointer where the conversion result will be put.
 *
 * Default implementation of "convert" vmethod in #GstBaseParse class.
 *
 * Returns: %TRUE if conversion was successful.
 */
gboolean
gst_base_parse_convert_default (GstBaseParse * parse,
    GstFormat src_format,
    gint64 src_value, GstFormat dest_format, gint64 * dest_value)
{
  gboolean ret = FALSE;
  guint64 bytes, duration;

  if (G_UNLIKELY (src_format == dest_format)) {
    *dest_value = src_value;
    return TRUE;
  }

  if (G_UNLIKELY (src_value == -1)) {
    *dest_value = -1;
    return TRUE;
  }

  if (G_UNLIKELY (src_value == 0)) {
    *dest_value = 0;
    return TRUE;
  }

  /* need at least some frames */
  if (!parse->priv->framecount)
    goto no_framecount;

  duration = parse->priv->acc_duration / GST_MSECOND;
  bytes = parse->priv->bytecount;

  if (G_UNLIKELY (!duration || !bytes))
    goto no_duration_bytes;

  if (src_format == GST_FORMAT_BYTES) {
    if (dest_format == GST_FORMAT_TIME) {
      /* BYTES -> TIME conversion */
      GST_DEBUG_OBJECT (parse, "converting bytes -> time");
      *dest_value = gst_util_uint64_scale (src_value, duration, bytes);
      *dest_value *= GST_MSECOND;
      GST_DEBUG_OBJECT (parse, "conversion result: %" G_GINT64_FORMAT " ms",
          *dest_value / GST_MSECOND);
      ret = TRUE;
    } else {
      GST_DEBUG_OBJECT (parse, "converting bytes -> other not implemented");
    }
  } else if (src_format == GST_FORMAT_TIME) {
    if (dest_format == GST_FORMAT_BYTES) {
      GST_DEBUG_OBJECT (parse, "converting time -> bytes");
      *dest_value = gst_util_uint64_scale (src_value / GST_MSECOND, bytes,
          duration);
      GST_DEBUG_OBJECT (parse,
          "time %" G_GINT64_FORMAT " ms in bytes = %" G_GINT64_FORMAT,
          src_value / GST_MSECOND, *dest_value);
      ret = TRUE;
    } else {
      GST_DEBUG_OBJECT (parse, "converting time -> other not implemented");
    }
  } else if (src_format == GST_FORMAT_DEFAULT) {
    /* DEFAULT == frame-based */
    if (dest_format == GST_FORMAT_TIME) {
      GST_DEBUG_OBJECT (parse, "converting default -> time");
      if (parse->priv->fps_den) {
        *dest_value = gst_util_uint64_scale (src_value,
            GST_SECOND * parse->priv->fps_den, parse->priv->fps_num);
        ret = TRUE;
      }
    } else {
      GST_DEBUG_OBJECT (parse, "converting default -> other not implemented");
    }
  } else {
    GST_DEBUG_OBJECT (parse, "conversion not implemented");
  }
  return ret;

  /* ERRORS */
no_framecount:
  {
    GST_DEBUG_OBJECT (parse, "no framecount");
    return FALSE;
  }
no_duration_bytes:
  {
    GST_DEBUG_OBJECT (parse, "no duration %" G_GUINT64_FORMAT ", bytes %"
        G_GUINT64_FORMAT, duration, bytes);
    return FALSE;
  }

}

static void
gst_base_parse_update_duration (GstBaseParse * baseparse)
{
  GstPad *peer;
  GstBaseParse *parse;

  parse = GST_BASE_PARSE (baseparse);

  peer = gst_pad_get_peer (parse->sinkpad);
  if (peer) {
    gboolean qres = FALSE;
    gint64 ptot, dest_value;

    qres = gst_pad_query_duration (peer, GST_FORMAT_BYTES, &ptot);
    gst_object_unref (GST_OBJECT (peer));
    if (qres) {
      if (gst_base_parse_convert (parse, GST_FORMAT_BYTES, ptot,
              GST_FORMAT_TIME, &dest_value)) {

        /* inform if duration changed, but try to avoid spamming */
        parse->priv->estimated_drift +=
            dest_value - parse->priv->estimated_duration;
        if (parse->priv->estimated_drift > GST_SECOND ||
            parse->priv->estimated_drift < -GST_SECOND) {
          gst_element_post_message (GST_ELEMENT (parse),
              gst_message_new_duration_changed (GST_OBJECT (parse)));
          parse->priv->estimated_drift = 0;
        }
        parse->priv->estimated_duration = dest_value;
        GST_LOG_OBJECT (parse,
            "updated estimated duration to %" GST_TIME_FORMAT,
            GST_TIME_ARGS (dest_value));
      }
    }
  }
}

static void
gst_base_parse_post_bitrates (GstBaseParse * parse, gboolean post_min,
    gboolean post_avg, gboolean post_max)
{
  GstTagList *taglist = NULL;

  if (post_min && parse->priv->post_min_bitrate) {
    taglist = gst_tag_list_new_empty ();

    gst_tag_list_add (taglist, GST_TAG_MERGE_REPLACE,
        GST_TAG_MINIMUM_BITRATE, parse->priv->min_bitrate, NULL);
  }

  if (post_avg && parse->priv->post_avg_bitrate) {
    if (taglist == NULL)
      taglist = gst_tag_list_new_empty ();

    parse->priv->posted_avg_bitrate = parse->priv->avg_bitrate;
    gst_tag_list_add (taglist, GST_TAG_MERGE_REPLACE, GST_TAG_BITRATE,
        parse->priv->avg_bitrate, NULL);
  }

  if (post_max && parse->priv->post_max_bitrate) {
    if (taglist == NULL)
      taglist = gst_tag_list_new_empty ();

    gst_tag_list_add (taglist, GST_TAG_MERGE_REPLACE,
        GST_TAG_MAXIMUM_BITRATE, parse->priv->max_bitrate, NULL);
  }

  GST_DEBUG_OBJECT (parse, "Updated bitrates. Min: %u, Avg: %u, Max: %u",
      parse->priv->min_bitrate, parse->priv->avg_bitrate,
      parse->priv->max_bitrate);

  if (taglist != NULL) {
    gst_pad_push_event (parse->srcpad, gst_event_new_tag (taglist));
  }
}

/* gst_base_parse_update_bitrates:
 * @parse: #GstBaseParse.
 * @buffer: Current frame as a #GstBuffer
 *
 * Keeps track of the minimum and maximum bitrates, and also maintains a
 * running average bitrate of the stream so far.
 */
static void
gst_base_parse_update_bitrates (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  /* Only update the tag on a 10 kbps delta */
  static const gint update_threshold = 10000;

  guint64 data_len, frame_dur;
  gint overhead, frame_bitrate, old_avg_bitrate;
  gboolean update_min = FALSE, update_avg = FALSE, update_max = FALSE;
  GstBuffer *buffer = frame->buffer;

  overhead = frame->overhead;
  if (overhead == -1)
    return;

  data_len = gst_buffer_get_size (buffer) - overhead;
  parse->priv->data_bytecount += data_len;

  /* duration should be valid by now,
   * either set by subclass or maybe based on fps settings */
  if (GST_BUFFER_DURATION_IS_VALID (buffer) && parse->priv->acc_duration != 0) {
    /* Calculate duration of a frame from buffer properties */
    frame_dur = GST_BUFFER_DURATION (buffer);
    parse->priv->avg_bitrate = (8 * parse->priv->data_bytecount * GST_SECOND) /
        parse->priv->acc_duration;

  } else {
    /* No way to figure out frame duration (is this even possible?) */
    return;
  }

  /* override if subclass provided bitrate, e.g. metadata based */
  if (parse->priv->bitrate) {
    parse->priv->avg_bitrate = parse->priv->bitrate;
    /* spread this (confirmed) info ASAP */
    if (parse->priv->posted_avg_bitrate != parse->priv->avg_bitrate)
      gst_base_parse_post_bitrates (parse, FALSE, TRUE, FALSE);
  }

  if (frame_dur)
    frame_bitrate = (8 * data_len * GST_SECOND) / frame_dur;
  else
    return;

  GST_LOG_OBJECT (parse, "frame bitrate %u, avg bitrate %u", frame_bitrate,
      parse->priv->avg_bitrate);

  if (parse->priv->framecount < MIN_FRAMES_TO_POST_BITRATE) {
    goto exit;
  } else if (parse->priv->framecount == MIN_FRAMES_TO_POST_BITRATE) {
    /* always post all at threshold time */
    update_min = update_max = update_avg = TRUE;
  }

  if (G_LIKELY (parse->priv->framecount >= MIN_FRAMES_TO_POST_BITRATE)) {
    if (frame_bitrate < parse->priv->min_bitrate) {
      parse->priv->min_bitrate = frame_bitrate;
      update_min = TRUE;
    }

    if (frame_bitrate > parse->priv->max_bitrate) {
      parse->priv->max_bitrate = frame_bitrate;
      update_max = TRUE;
    }

    old_avg_bitrate = parse->priv->posted_avg_bitrate;
    if ((gint) (old_avg_bitrate - parse->priv->avg_bitrate) > update_threshold
        || (gint) (parse->priv->avg_bitrate - old_avg_bitrate) >
        update_threshold)
      update_avg = TRUE;
  }

  if ((update_min || update_avg || update_max))
    gst_base_parse_post_bitrates (parse, update_min, update_avg, update_max);

exit:
  return;
}

/**
 * gst_base_parse_add_index_entry:
 * @parse: #GstBaseParse.
 * @offset: offset of entry
 * @ts: timestamp associated with offset
 * @key: whether entry refers to keyframe
 * @force: add entry disregarding sanity checks
 *
 * Adds an entry to the index associating @offset to @ts.  It is recommended
 * to only add keyframe entries.  @force allows to bypass checks, such as
 * whether the stream is (upstream) seekable, another entry is already "close"
 * to the new entry, etc.
 *
 * Returns: #gboolean indicating whether entry was added
 */
gboolean
gst_base_parse_add_index_entry (GstBaseParse * parse, guint64 offset,
    GstClockTime ts, gboolean key, gboolean force)
{
  gboolean ret = FALSE;
  GstIndexAssociation associations[2];

  GST_LOG_OBJECT (parse, "Adding key=%d index entry %" GST_TIME_FORMAT
      " @ offset 0x%08" G_GINT64_MODIFIER "x", key, GST_TIME_ARGS (ts), offset);

  if (G_LIKELY (!force)) {

    if (!parse->priv->upstream_seekable) {
      GST_DEBUG_OBJECT (parse, "upstream not seekable; discarding");
      goto exit;
    }

    /* FIXME need better helper data structure that handles these issues
     * related to ongoing collecting of index entries */
    if (parse->priv->index_last_offset + parse->priv->idx_byte_interval >=
        (gint64) offset) {
      GST_LOG_OBJECT (parse,
          "already have entries up to offset 0x%08" G_GINT64_MODIFIER "x",
          parse->priv->index_last_offset + parse->priv->idx_byte_interval);
      goto exit;
    }

    if (GST_CLOCK_TIME_IS_VALID (parse->priv->index_last_ts) &&
        GST_CLOCK_DIFF (parse->priv->index_last_ts, ts) <
        parse->priv->idx_interval) {
      GST_LOG_OBJECT (parse, "entry too close to last time %" GST_TIME_FORMAT,
          GST_TIME_ARGS (parse->priv->index_last_ts));
      goto exit;
    }

    /* if last is not really the last one */
    if (!parse->priv->index_last_valid) {
      GstClockTime prev_ts;

      gst_base_parse_find_offset (parse, ts, TRUE, &prev_ts);
      if (GST_CLOCK_DIFF (prev_ts, ts) < parse->priv->idx_interval) {
        GST_LOG_OBJECT (parse,
            "entry too close to existing entry %" GST_TIME_FORMAT,
            GST_TIME_ARGS (prev_ts));
        parse->priv->index_last_offset = offset;
        parse->priv->index_last_ts = ts;
        goto exit;
      }
    }
  }

  associations[0].format = GST_FORMAT_TIME;
  associations[0].value = ts;
  associations[1].format = GST_FORMAT_BYTES;
  associations[1].value = offset;

  /* index might change on-the-fly, although that would be nutty app ... */
  GST_BASE_PARSE_INDEX_LOCK (parse);
  gst_index_add_associationv (parse->priv->index, parse->priv->index_id,
      (key) ? GST_INDEX_ASSOCIATION_FLAG_KEY_UNIT :
      GST_INDEX_ASSOCIATION_FLAG_DELTA_UNIT, 2,
      (const GstIndexAssociation *) &associations);
  GST_BASE_PARSE_INDEX_UNLOCK (parse);

  if (key) {
    parse->priv->index_last_offset = offset;
    parse->priv->index_last_ts = ts;
  }

  ret = TRUE;

exit:
  return ret;
}

/* check for seekable upstream, above and beyond a mere query */
static void
gst_base_parse_check_seekability (GstBaseParse * parse)
{
  GstQuery *query;
  gboolean seekable = FALSE;
  gint64 start = -1, stop = -1;
  guint idx_interval = 0;
  guint64 idx_byte_interval = 0;

  query = gst_query_new_seeking (GST_FORMAT_BYTES);
  if (!gst_pad_peer_query (parse->sinkpad, query)) {
    GST_DEBUG_OBJECT (parse, "seeking query failed");
    goto done;
  }

  gst_query_parse_seeking (query, NULL, &seekable, &start, &stop);

  /* try harder to query upstream size if we didn't get it the first time */
  if (seekable && stop == -1) {
    GST_DEBUG_OBJECT (parse, "doing duration query to fix up unset stop");
    gst_pad_peer_query_duration (parse->sinkpad, GST_FORMAT_BYTES, &stop);
  }

  /* if upstream doesn't know the size, it's likely that it's not seekable in
   * practice even if it technically may be seekable */
  if (seekable && (start != 0 || stop <= start)) {
    GST_DEBUG_OBJECT (parse, "seekable but unknown start/stop -> disable");
    seekable = FALSE;
  }

  /* let's not put every single frame into our index */
  if (seekable) {
    if (stop < 10 * 1024 * 1024)
      idx_interval = 100;
    else if (stop < 100 * 1024 * 1024)
      idx_interval = 500;
    else
      idx_interval = 1000;

    /* ensure that even for large files (e.g. very long audio files), the index
     * stays reasonably-size, with some arbitrary limit to the total number of
     * index entries */
    idx_byte_interval = (stop - start) / MAX_INDEX_ENTRIES;
    GST_DEBUG_OBJECT (parse,
        "Limiting index entries to %d, indexing byte interval %"
        G_GUINT64_FORMAT " bytes", MAX_INDEX_ENTRIES, idx_byte_interval);
  }

done:
  gst_query_unref (query);

  GST_DEBUG_OBJECT (parse, "seekable: %d (%" G_GUINT64_FORMAT " - %"
      G_GUINT64_FORMAT ")", seekable, start, stop);
  parse->priv->upstream_seekable = seekable;
  parse->priv->upstream_size = seekable ? stop : 0;

  GST_DEBUG_OBJECT (parse, "idx_interval: %ums", idx_interval);
  parse->priv->idx_interval = idx_interval * GST_MSECOND;
  parse->priv->idx_byte_interval = idx_byte_interval;
}

/* some misc checks on upstream */
static void
gst_base_parse_check_upstream (GstBaseParse * parse)
{
  gint64 stop;

  if (gst_pad_peer_query_duration (parse->sinkpad, GST_FORMAT_TIME, &stop))
    if (GST_CLOCK_TIME_IS_VALID (stop) && stop) {
      /* upstream has one, accept it also, and no further updates */
      gst_base_parse_set_duration (parse, GST_FORMAT_TIME, stop, 0);
      parse->priv->upstream_has_duration = TRUE;
    }

  GST_DEBUG_OBJECT (parse, "upstream_has_duration: %d",
      parse->priv->upstream_has_duration);
}

/* checks src caps to determine if dealing with audio or video */
/* TODO maybe forego automagic stuff and let subclass configure it ? */
static void
gst_base_parse_check_media (GstBaseParse * parse)
{
  GstCaps *caps;
  GstStructure *s;

  caps = gst_pad_get_current_caps (parse->srcpad);
  if (G_LIKELY (caps) && (s = gst_caps_get_structure (caps, 0))) {
    parse->priv->is_video =
        g_str_has_prefix (gst_structure_get_name (s), "video");
  } else {
    /* historical default */
    parse->priv->is_video = FALSE;
  }
  if (caps)
    gst_caps_unref (caps);

  parse->priv->checked_media = TRUE;
  GST_DEBUG_OBJECT (parse, "media is video: %d", parse->priv->is_video);
}

/* takes ownership of frame */
static void
gst_base_parse_queue_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  if (!(frame->_private_flags & GST_BASE_PARSE_FRAME_PRIVATE_FLAG_NOALLOC)) {
    /* frame allocated on the heap, we can just take ownership */
    g_queue_push_tail (&parse->priv->queued_frames, frame);
    GST_TRACE ("queued frame %p", frame);
  } else {
    GstBaseParseFrame *copy;

    /* probably allocated on the stack, must make a proper copy */
    copy = gst_base_parse_frame_copy (frame);
    g_queue_push_tail (&parse->priv->queued_frames, copy);
    GST_TRACE ("queued frame %p (copy of %p)", copy, frame);
    gst_base_parse_frame_free (frame);
  }
}

/* makes sure that @buf is properly prepared and decorated for passing
 * to baseclass, and an equally setup frame is returned setup with @buf.
 * Takes ownership of @buf. */
static GstBaseParseFrame *
gst_base_parse_prepare_frame (GstBaseParse * parse, GstBuffer * buffer)
{
  GstBaseParseFrame *frame = NULL;

  buffer = gst_buffer_make_writable (buffer);

  GST_LOG_OBJECT (parse,
      "preparing frame at offset %" G_GUINT64_FORMAT
      " (%#" G_GINT64_MODIFIER "x) of size %" G_GSIZE_FORMAT,
      GST_BUFFER_OFFSET (buffer), GST_BUFFER_OFFSET (buffer),
      gst_buffer_get_size (buffer));

  if (parse->priv->discont) {
    GST_DEBUG_OBJECT (parse, "marking DISCONT");
    GST_BUFFER_FLAG_SET (buffer, GST_BUFFER_FLAG_DISCONT);
    parse->priv->discont = FALSE;
  }

  GST_BUFFER_OFFSET (buffer) = parse->priv->offset;

  frame = gst_base_parse_frame_new (buffer, 0, 0);

  /* also ensure to update state flags */
  gst_base_parse_frame_update (parse, frame, buffer);
  gst_buffer_unref (buffer);

  if (parse->priv->prev_offset != parse->priv->offset || parse->priv->new_frame) {
    GST_LOG_OBJECT (parse, "marking as new frame");
    parse->priv->new_frame = FALSE;
    frame->flags |= GST_BASE_PARSE_FRAME_FLAG_NEW_FRAME;
  }

  frame->offset = parse->priv->prev_offset = parse->priv->offset;

  /* use default handler to provide initial (upstream) metadata */
  gst_base_parse_parse_frame (parse, frame);

  return frame;
}

/* Wraps buffer in a frame and dispatches to subclass.
 * Also manages data skipping and offset handling (including adapter flushing).
 * Takes ownership of @buffer */
static GstFlowReturn
gst_base_parse_handle_buffer (GstBaseParse * parse, GstBuffer * buffer,
    gint * skip, gint * flushed)
{
  GstBaseParseClass *klass = GST_BASE_PARSE_GET_CLASS (parse);
  GstBaseParseFrame *frame;
  GstFlowReturn ret;

  g_return_val_if_fail (skip != NULL || flushed != NULL, GST_FLOW_ERROR);

  GST_LOG_OBJECT (parse,
      "handling buffer of size %" G_GSIZE_FORMAT " with dts %" GST_TIME_FORMAT
      ", pts %" GST_TIME_FORMAT ", duration %" GST_TIME_FORMAT,
      gst_buffer_get_size (buffer), GST_TIME_ARGS (GST_BUFFER_DTS (buffer)),
      GST_TIME_ARGS (GST_BUFFER_PTS (buffer)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buffer)));

  /* track what is being flushed during this single round of frame processing */
  parse->priv->flushed = 0;
  *skip = 0;

  /* make it easy for _finish_frame to pick up input data */
  if (parse->priv->pad_mode == GST_PAD_MODE_PULL) {
    gst_buffer_ref (buffer);
    gst_adapter_push (parse->priv->adapter, buffer);
  }

  frame = gst_base_parse_prepare_frame (parse, buffer);
  ret = klass->handle_frame (parse, frame, skip);

  *flushed = parse->priv->flushed;

  GST_LOG_OBJECT (parse, "handle_frame skipped %d, flushed %d",
      *skip, *flushed);

  /* subclass can only do one of these, or semantics are too unclear */
  g_assert (*skip == 0 || *flushed == 0);

  /* track skipping */
  if (*skip > 0) {
    GstClockTime pts, dts;
    GstBuffer *outbuf;

    GST_LOG_OBJECT (parse, "finding sync, skipping %d bytes", *skip);
    if (parse->segment.rate < 0.0 && !parse->priv->buffers_queued) {
      /* reverse playback, and no frames found yet, so we are skipping
       * the leading part of a fragment, which may form the tail of
       * fragment coming later, hopefully subclass skips efficiently ... */
      pts = gst_adapter_prev_pts (parse->priv->adapter, NULL);
      dts = gst_adapter_prev_dts (parse->priv->adapter, NULL);
      outbuf = gst_adapter_take_buffer (parse->priv->adapter, *skip);
      outbuf = gst_buffer_make_writable (outbuf);
      GST_BUFFER_PTS (outbuf) = pts;
      GST_BUFFER_DTS (outbuf) = dts;
      parse->priv->buffers_head =
          g_slist_prepend (parse->priv->buffers_head, outbuf);
      outbuf = NULL;
    } else {
      gst_adapter_flush (parse->priv->adapter, *skip);
    }
    if (!parse->priv->discont)
      parse->priv->sync_offset = parse->priv->offset;
    parse->priv->offset += *skip;
    parse->priv->discont = TRUE;
    /* check for indefinite skipping */
    if (ret == GST_FLOW_OK)
      ret = gst_base_parse_check_sync (parse);
  }

  parse->priv->offset += *flushed;

  if (parse->priv->pad_mode == GST_PAD_MODE_PULL) {
    gst_adapter_clear (parse->priv->adapter);
  }

  gst_base_parse_frame_free (frame);

  return ret;
}

/* gst_base_parse_push_pending_events:
 * @parse: #GstBaseParse
 *
 * Pushes the pending events
 */
static void
gst_base_parse_push_pending_events (GstBaseParse * parse)
{
  if (G_UNLIKELY (parse->priv->pending_events)) {
    GList *r = g_list_reverse (parse->priv->pending_events);
    GList *l;

    parse->priv->pending_events = NULL;
    for (l = r; l != NULL; l = l->next) {
      gst_pad_push_event (parse->srcpad, GST_EVENT_CAST (l->data));
    }
    g_list_free (r);
  }
}

/* gst_base_parse_handle_and_push_frame:
 * @parse: #GstBaseParse.
 * @klass: #GstBaseParseClass.
 * @frame: (transfer full): a #GstBaseParseFrame
 *
 * Parses the frame from given buffer and pushes it forward. Also performs
 * timestamp handling and checks the segment limits.
 *
 * This is called with srcpad STREAM_LOCK held.
 *
 * Returns: #GstFlowReturn
 */
static GstFlowReturn
gst_base_parse_handle_and_push_frame (GstBaseParse * parse,
    GstBaseParseFrame * frame)
{
  gint64 offset;
  GstBuffer *buffer;

  g_return_val_if_fail (frame != NULL, GST_FLOW_ERROR);

  buffer = frame->buffer;
  offset = frame->offset;

  /* check if subclass/format can provide ts.
   * If so, that allows and enables extra seek and duration determining options */
  if (G_UNLIKELY (parse->priv->first_frame_offset < 0)) {
    if (GST_BUFFER_PTS_IS_VALID (buffer) && parse->priv->has_timing_info
        && parse->priv->pad_mode == GST_PAD_MODE_PULL) {
      parse->priv->first_frame_offset = offset;
      parse->priv->first_frame_pts = GST_BUFFER_PTS (buffer);
      parse->priv->first_frame_dts = GST_BUFFER_DTS (buffer);
      GST_DEBUG_OBJECT (parse, "subclass provided dts %" GST_TIME_FORMAT
          ", pts %" GST_TIME_FORMAT " for first frame at offset %"
          G_GINT64_FORMAT, GST_TIME_ARGS (parse->priv->first_frame_dts),
          GST_TIME_ARGS (parse->priv->first_frame_pts),
          parse->priv->first_frame_offset);
      if (!GST_CLOCK_TIME_IS_VALID (parse->priv->duration)) {
        gint64 off;
        GstClockTime last_ts = G_MAXINT64;

        GST_DEBUG_OBJECT (parse, "no duration; trying scan to determine");
        gst_base_parse_locate_time (parse, &last_ts, &off);
        if (GST_CLOCK_TIME_IS_VALID (last_ts))
          gst_base_parse_set_duration (parse, GST_FORMAT_TIME, last_ts, 0);
      }
    } else {
      /* disable further checks */
      parse->priv->first_frame_offset = 0;
    }
  }

  /* track upstream time if provided, not subclass' internal notion of it */
  if (parse->priv->upstream_format == GST_FORMAT_TIME) {
    GST_BUFFER_PTS (frame->buffer) = GST_CLOCK_TIME_NONE;
    GST_BUFFER_DTS (frame->buffer) = GST_CLOCK_TIME_NONE;
  }

  /* interpolating and no valid pts yet,
   * start with dts and carry on from there */
  if (parse->priv->infer_ts && parse->priv->pts_interpolate
      && !GST_CLOCK_TIME_IS_VALID (parse->priv->next_pts))
    parse->priv->next_pts = parse->priv->next_dts;

  /* again use default handler to add missing metadata;
   * we may have new information on frame properties */
  gst_base_parse_parse_frame (parse, frame);

  parse->priv->next_pts = GST_CLOCK_TIME_NONE;
  if (GST_BUFFER_DTS_IS_VALID (buffer) && GST_BUFFER_DURATION_IS_VALID (buffer)) {
    parse->priv->next_dts =
        GST_BUFFER_DTS (buffer) + GST_BUFFER_DURATION (buffer);
    if (parse->priv->pts_interpolate && GST_BUFFER_PTS_IS_VALID (buffer)) {
      GstClockTime next_pts =
          GST_BUFFER_PTS (buffer) + GST_BUFFER_DURATION (buffer);
      if (next_pts >= parse->priv->next_dts)
        parse->priv->next_pts = next_pts;
    }
  } else {
    /* we lost track, do not produce bogus time next time around
     * (probably means parser subclass has given up on parsing as well) */
    GST_DEBUG_OBJECT (parse, "no next fallback timestamp");
    parse->priv->next_dts = GST_CLOCK_TIME_NONE;
  }

  if (parse->priv->upstream_seekable && parse->priv->exact_position &&
      GST_BUFFER_PTS_IS_VALID (buffer))
    gst_base_parse_add_index_entry (parse, offset,
        GST_BUFFER_PTS (buffer),
        !GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT), FALSE);

  /* All OK, push queued frames if there are any */
  if (G_UNLIKELY (!g_queue_is_empty (&parse->priv->queued_frames))) {
    GstBaseParseFrame *queued_frame;

    while ((queued_frame = g_queue_pop_head (&parse->priv->queued_frames))) {
      gst_base_parse_push_frame (parse, queued_frame);
      gst_base_parse_frame_free (queued_frame);
    }
  }

  return gst_base_parse_push_frame (parse, frame);
}

/**
 * gst_base_parse_push_frame:
 * @parse: #GstBaseParse.
 * @frame: (transfer none): a #GstBaseParseFrame
 *
 * Pushes the frame's buffer downstream, sends any pending events and
 * does some timestamp and segment handling. Takes ownership of
 * frame's buffer, though caller retains ownership of @frame.
 *
 * This must be called with sinkpad STREAM_LOCK held.
 *
 * Returns: #GstFlowReturn
 */
GstFlowReturn
gst_base_parse_push_frame (GstBaseParse * parse, GstBaseParseFrame * frame)
{
  GstFlowReturn ret = GST_FLOW_OK;
  GstClockTime last_start = GST_CLOCK_TIME_NONE;
  GstClockTime last_stop = GST_CLOCK_TIME_NONE;
  GstBaseParseClass *klass = GST_BASE_PARSE_GET_CLASS (parse);
  GstBuffer *buffer;
  gsize size;

  g_return_val_if_fail (frame != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (frame->buffer != NULL, GST_FLOW_ERROR);

  GST_TRACE_OBJECT (parse, "pushing frame %p", frame);

  buffer = frame->buffer;

  GST_LOG_OBJECT (parse,
      "processing buffer of size %" G_GSIZE_FORMAT " with dts %" GST_TIME_FORMAT
      ", pts %" GST_TIME_FORMAT ", duration %" GST_TIME_FORMAT,
      gst_buffer_get_size (buffer),
      GST_TIME_ARGS (GST_BUFFER_DTS (buffer)),
      GST_TIME_ARGS (GST_BUFFER_PTS (buffer)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buffer)));

  /* update stats */
  parse->priv->bytecount += frame->size;
  if (G_LIKELY (!(frame->flags & GST_BASE_PARSE_FRAME_FLAG_NO_FRAME))) {
    parse->priv->framecount++;
    if (GST_BUFFER_DURATION_IS_VALID (buffer)) {
      parse->priv->acc_duration += GST_BUFFER_DURATION (buffer);
    }
  }
  /* 0 means disabled */
  if (parse->priv->update_interval < 0)
    parse->priv->update_interval = 50;
  else if (parse->priv->update_interval > 0 &&
      (parse->priv->framecount % parse->priv->update_interval) == 0)
    gst_base_parse_update_duration (parse);

  if (GST_BUFFER_PTS_IS_VALID (buffer))
    last_start = last_stop = GST_BUFFER_PTS (buffer);
  if (last_start != GST_CLOCK_TIME_NONE
      && GST_BUFFER_DURATION_IS_VALID (buffer))
    last_stop = last_start + GST_BUFFER_DURATION (buffer);

  /* should have caps by now */
  if (!gst_pad_has_current_caps (parse->srcpad))
    goto no_caps;

  if (G_UNLIKELY (!parse->priv->checked_media)) {
    /* have caps; check identity */
    gst_base_parse_check_media (parse);
  }

  /* Push pending events, including SEGMENT events */
  gst_base_parse_push_pending_events (parse);

  /* segment adjustment magic; only if we are running the whole show */
  if (!parse->priv->passthrough && parse->segment.rate > 0.0 &&
      (parse->priv->pad_mode == GST_PAD_MODE_PULL ||
          parse->priv->upstream_seekable)) {
    /* handle gaps */
    if (GST_CLOCK_TIME_IS_VALID (parse->segment.position) &&
        GST_CLOCK_TIME_IS_VALID (last_start)) {
      GstClockTimeDiff diff;

      /* only send newsegments with increasing start times,
       * otherwise if these go back and forth downstream (sinks) increase
       * accumulated time and running_time */
      diff = GST_CLOCK_DIFF (parse->segment.position, last_start);
      if (G_UNLIKELY (diff > 2 * GST_SECOND
              && last_start > parse->segment.start
              && (!GST_CLOCK_TIME_IS_VALID (parse->segment.stop)
                  || last_start < parse->segment.stop))) {

        GST_DEBUG_OBJECT (parse,
            "Gap of %" G_GINT64_FORMAT " ns detected in stream " "(%"
            GST_TIME_FORMAT " -> %" GST_TIME_FORMAT "). "
            "Sending updated SEGMENT events", diff,
            GST_TIME_ARGS (parse->segment.position),
            GST_TIME_ARGS (last_start));

        /* skip gap FIXME */
        gst_pad_push_event (parse->srcpad,
            gst_event_new_segment (&parse->segment));

        parse->segment.position = last_start;
      }
    }
  }

  /* update bitrates and optionally post corresponding tags
   * (following newsegment) */
  gst_base_parse_update_bitrates (parse, frame);

  if (klass->pre_push_frame) {
    ret = klass->pre_push_frame (parse, frame);
  } else {
    frame->flags |= GST_BASE_PARSE_FRAME_FLAG_CLIP;
  }

  /* take final ownership of frame buffer */
  if (frame->out_buffer) {
    buffer = frame->out_buffer;
    frame->out_buffer = NULL;
    gst_buffer_replace (&frame->buffer, NULL);
  } else {
    buffer = frame->buffer;
    frame->buffer = NULL;
  }

  /* subclass must play nice */
  g_return_val_if_fail (buffer != NULL, GST_FLOW_ERROR);

  size = gst_buffer_get_size (buffer);

  parse->priv->seen_keyframe |= parse->priv->is_video &&
      !GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_DELTA_UNIT);

  if (frame->flags & GST_BASE_PARSE_FRAME_FLAG_CLIP) {
    if (GST_BUFFER_TIMESTAMP_IS_VALID (buffer) &&
        GST_CLOCK_TIME_IS_VALID (parse->segment.stop) &&
        GST_BUFFER_TIMESTAMP (buffer) >
        parse->segment.stop + parse->priv->lead_out_ts) {
      GST_LOG_OBJECT (parse, "Dropped frame, after segment");
      ret = GST_FLOW_EOS;
    } else if (GST_BUFFER_TIMESTAMP_IS_VALID (buffer) &&
        GST_BUFFER_DURATION_IS_VALID (buffer) &&
        GST_CLOCK_TIME_IS_VALID (parse->segment.start) &&
        GST_BUFFER_TIMESTAMP (buffer) + GST_BUFFER_DURATION (buffer) +
        parse->priv->lead_in_ts < parse->segment.start) {
      if (parse->priv->seen_keyframe) {
        GST_LOG_OBJECT (parse, "Frame before segment, after keyframe");
        ret = GST_FLOW_OK;
      } else {
        GST_LOG_OBJECT (parse, "Dropped frame, before segment");
        ret = GST_BASE_PARSE_FLOW_DROPPED;
      }
    } else {
      ret = GST_FLOW_OK;
    }
  }

  if (ret == GST_BASE_PARSE_FLOW_DROPPED) {
    GST_LOG_OBJECT (parse, "frame (%" G_GSIZE_FORMAT " bytes) dropped", size);
    gst_buffer_unref (buffer);
    ret = GST_FLOW_OK;
  } else if (ret == GST_FLOW_OK) {
    if (parse->segment.rate > 0.0) {
      GST_LOG_OBJECT (parse, "pushing frame (%" G_GSIZE_FORMAT " bytes) now..",
          size);
      ret = gst_pad_push (parse->srcpad, buffer);
      GST_LOG_OBJECT (parse, "frame pushed, flow %s", gst_flow_get_name (ret));
    } else if (!parse->priv->disable_passthrough && parse->priv->passthrough) {

      /* in backwards playback mode, if on passthrough we need to push buffers
       * directly without accumulating them into the buffers_queued as baseparse
       * will never check for a DISCONT while on passthrough and those buffers
       * will never be pushed.
       *
       * also, as we are on reverse playback, it might be possible that
       * passthrough might have just been enabled, so make sure to drain the
       * buffers_queued list */
      if (G_UNLIKELY (parse->priv->buffers_queued != NULL)) {
        gst_base_parse_finish_fragment (parse, TRUE);
        ret = gst_base_parse_send_buffers (parse);
      }

      if (ret == GST_FLOW_OK) {
        GST_LOG_OBJECT (parse,
            "pushing frame (%" G_GSIZE_FORMAT " bytes) now..", size);
        ret = gst_pad_push (parse->srcpad, buffer);
        GST_LOG_OBJECT (parse, "frame pushed, flow %s",
            gst_flow_get_name (ret));
      } else {
        GST_LOG_OBJECT (parse,
            "frame (%" G_GSIZE_FORMAT " bytes) not pushed: %s", size,
            gst_flow_get_name (ret));
        gst_buffer_unref (buffer);
      }

    } else {
      GST_LOG_OBJECT (parse, "frame (%" G_GSIZE_FORMAT " bytes) queued for now",
          size);
      parse->priv->buffers_queued =
          g_slist_prepend (parse->priv->buffers_queued, buffer);
      ret = GST_FLOW_OK;
    }
  } else {
    GST_LOG_OBJECT (parse, "frame (%" G_GSIZE_FORMAT " bytes) not pushed: %s",
        size, gst_flow_get_name (ret));
    gst_buffer_unref (buffer);
    /* if we are not sufficiently in control, let upstream decide on EOS */
    if (ret == GST_FLOW_EOS && !parse->priv->disable_passthrough &&
        (parse->priv->passthrough ||
            (parse->priv->pad_mode == GST_PAD_MODE_PUSH &&
                !parse->priv->upstream_seekable)))
      ret = GST_FLOW_OK;
  }

  /* Update current running segment position */
  if (ret == GST_FLOW_OK && last_stop != GST_CLOCK_TIME_NONE &&
      parse->segment.position < last_stop)
    parse->segment.position = last_stop;

  return ret;

  /* ERRORS */
no_caps:
  {
    if (GST_PAD_IS_FLUSHING (parse->srcpad))
      return GST_FLOW_FLUSHING;

    GST_ELEMENT_ERROR (parse, STREAM, DECODE, ("No caps set"), (NULL));
    return GST_FLOW_ERROR;
  }
}

/**
 * gst_base_parse_finish_frame:
 * @parse: a #GstBaseParse
 * @frame: a #GstBaseParseFrame
 * @size: consumed input data represented by frame
 *
 * Collects parsed data and pushes this downstream.
 * Source pad caps must be set when this is called.
 *
 * If @frame's out_buffer is set, that will be used as subsequent frame data.
 * Otherwise, @size samples will be taken from the input and used for output,
 * and the output's metadata (timestamps etc) will be taken as (optionally)
 * set by the subclass on @frame's (input) buffer (which is otherwise
 * ignored for any but the above purpose/information).
 *
 * Note that the latter buffer is invalidated by this call, whereas the
 * caller retains ownership of @frame.
 *
 * Returns: a #GstFlowReturn that should be escalated to caller (of caller)
 */
GstFlowReturn
gst_base_parse_finish_frame (GstBaseParse * parse, GstBaseParseFrame * frame,
    gint size)
{
  GstFlowReturn ret = GST_FLOW_OK;

  g_return_val_if_fail (frame != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (frame->buffer != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (size > 0 || frame->out_buffer, GST_FLOW_ERROR);
  g_return_val_if_fail (gst_adapter_available (parse->priv->adapter) >= size,
      GST_FLOW_ERROR);

  GST_LOG_OBJECT (parse, "finished frame at offset %" G_GUINT64_FORMAT ", "
      "flushing size %d", frame->offset, size);

  /* some one-time start-up */
  if (G_UNLIKELY (parse->priv->framecount == 0)) {
    gst_base_parse_check_seekability (parse);
    gst_base_parse_check_upstream (parse);
  }

  parse->priv->flushed += size;

  if (parse->priv->scanning && frame->buffer) {
    if (!parse->priv->scanned_frame) {
      parse->priv->scanned_frame = gst_base_parse_frame_copy (frame);
    }
    goto exit;
  }

  /* either PUSH or PULL mode arranges for adapter data */
  /* ensure output buffer */
  if (!frame->out_buffer) {
    GstBuffer *src, *dest;

    frame->out_buffer = gst_adapter_take_buffer (parse->priv->adapter, size);
    dest = frame->out_buffer;
    src = frame->buffer;
    GST_BUFFER_PTS (dest) = GST_BUFFER_PTS (src);
    GST_BUFFER_DTS (dest) = GST_BUFFER_DTS (src);
    GST_BUFFER_OFFSET (dest) = GST_BUFFER_OFFSET (src);
    GST_BUFFER_DURATION (dest) = GST_BUFFER_DURATION (src);
    GST_BUFFER_OFFSET_END (dest) = GST_BUFFER_OFFSET_END (src);
    GST_MINI_OBJECT_FLAGS (dest) = GST_MINI_OBJECT_FLAGS (src);
  } else {
    gst_adapter_flush (parse->priv->adapter, size);
  }

  /* use as input for subsequent processing */
  gst_buffer_replace (&frame->buffer, frame->out_buffer);
  gst_buffer_unref (frame->out_buffer);
  frame->out_buffer = NULL;

  /* mark input size consumed */
  frame->size = size;

  /* subclass might queue frames/data internally if it needs more
   * frames to decide on the format, or might request us to queue here. */
  if (frame->flags & GST_BASE_PARSE_FRAME_FLAG_DROP) {
    gst_buffer_replace (&frame->buffer, NULL);
    goto exit;
  } else if (frame->flags & GST_BASE_PARSE_FRAME_FLAG_QUEUE) {
    GstBaseParseFrame *copy;

    copy = gst_base_parse_frame_copy (frame);
    copy->flags &= ~GST_BASE_PARSE_FRAME_FLAG_QUEUE;
    gst_base_parse_queue_frame (parse, copy);
    goto exit;
  }

  ret = gst_base_parse_handle_and_push_frame (parse, frame);

exit:
  return ret;
}

/* gst_base_parse_drain:
 *
 * Drains the adapter until it is empty. It decreases the min_frame_size to
 * match the current adapter size and calls chain method until the adapter
 * is emptied or chain returns with error.
 */
static void
gst_base_parse_drain (GstBaseParse * parse)
{
  guint avail;

  GST_DEBUG_OBJECT (parse, "draining");
  parse->priv->drain = TRUE;

  for (;;) {
    avail = gst_adapter_available (parse->priv->adapter);
    if (!avail)
      break;

    if (gst_base_parse_chain (parse->sinkpad, GST_OBJECT_CAST (parse),
            NULL) != GST_FLOW_OK) {
      break;
    }

    /* nothing changed, maybe due to truncated frame; break infinite loop */
    if (avail == gst_adapter_available (parse->priv->adapter)) {
      GST_DEBUG_OBJECT (parse, "no change during draining; flushing");
      gst_adapter_clear (parse->priv->adapter);
    }
  }

  parse->priv->drain = FALSE;
}

/* gst_base_parse_send_buffers
 *
 * Sends buffers collected in send_buffers downstream, and ensures that list
 * is empty at the end (errors or not).
 */
static GstFlowReturn
gst_base_parse_send_buffers (GstBaseParse * parse)
{
  GSList *send = NULL;
  GstBuffer *buf;
  GstFlowReturn ret = GST_FLOW_OK;
  gboolean first = TRUE;

  send = parse->priv->buffers_send;

  /* send buffers */
  while (send) {
    buf = GST_BUFFER_CAST (send->data);
    GST_LOG_OBJECT (parse, "pushing buffer %p, dts %"
        GST_TIME_FORMAT ", pts %" GST_TIME_FORMAT ", duration %" GST_TIME_FORMAT
        ", offset %" G_GINT64_FORMAT, buf,
        GST_TIME_ARGS (GST_BUFFER_DTS (buf)),
        GST_TIME_ARGS (GST_BUFFER_PTS (buf)),
        GST_TIME_ARGS (GST_BUFFER_DURATION (buf)), GST_BUFFER_OFFSET (buf));

    /* Make sure the first buffer is always DISCONT. If we split
     * GOPs inside the parser this is otherwise not guaranteed */
    if (first) {
      GST_BUFFER_FLAG_SET (buf, GST_BUFFER_FLAG_DISCONT);
      first = FALSE;
    }

    /* iterate output queue an push downstream */
    ret = gst_pad_push (parse->srcpad, buf);
    send = g_slist_delete_link (send, send);

    /* clear any leftover if error */
    if (G_UNLIKELY (ret != GST_FLOW_OK)) {
      while (send) {
        buf = GST_BUFFER_CAST (send->data);
        gst_buffer_unref (buf);
        send = g_slist_delete_link (send, send);
      }
    }
  }

  parse->priv->buffers_send = send;

  return ret;
}

/* gst_base_parse_start_fragment:
 *
 * Prepares for processing a reverse playback (forward) fragment
 * by (re)setting proper state variables.
 */
static GstFlowReturn
gst_base_parse_start_fragment (GstBaseParse * parse)
{
  GST_LOG_OBJECT (parse, "starting fragment");

  /* invalidate so no fall-back timestamping is performed;
   * ok if taken from subclass or upstream */
  parse->priv->next_pts = GST_CLOCK_TIME_NONE;
  parse->priv->prev_pts = GST_CLOCK_TIME_NONE;
  parse->priv->next_dts = GST_CLOCK_TIME_NONE;
  parse->priv->prev_dts = GST_CLOCK_TIME_NONE;
  /* prevent it hanging around stop all the time */
  parse->segment.position = GST_CLOCK_TIME_NONE;
  /* mark next run */
  parse->priv->discont = TRUE;

  /* head of previous fragment is now pending tail of current fragment */
  parse->priv->buffers_pending = parse->priv->buffers_head;
  parse->priv->buffers_head = NULL;

  return GST_FLOW_OK;
}


/* gst_base_parse_finish_fragment:
 *
 * Processes a reverse playback (forward) fragment:
 * - append head of last fragment that was skipped to current fragment data
 * - drain the resulting current fragment data (i.e. repeated chain)
 * - add time/duration (if needed) to frames queued by chain
 * - push queued data
 */
static GstFlowReturn
gst_base_parse_finish_fragment (GstBaseParse * parse, gboolean prev_head)
{
  GstBuffer *buf;
  GstFlowReturn ret = GST_FLOW_OK;
  gboolean seen_key = FALSE, seen_delta = FALSE;

  GST_LOG_OBJECT (parse, "finishing fragment");

  /* restore order */
  parse->priv->buffers_pending = g_slist_reverse (parse->priv->buffers_pending);
  while (parse->priv->buffers_pending) {
    buf = GST_BUFFER_CAST (parse->priv->buffers_pending->data);
    if (prev_head) {
      GST_LOG_OBJECT (parse, "adding pending buffer (size %" G_GSIZE_FORMAT ")",
          gst_buffer_get_size (buf));
      gst_adapter_push (parse->priv->adapter, buf);
    } else {
      GST_LOG_OBJECT (parse, "discarding head buffer");
      gst_buffer_unref (buf);
    }
    parse->priv->buffers_pending =
        g_slist_delete_link (parse->priv->buffers_pending,
        parse->priv->buffers_pending);
  }

  /* chain looks for frames and queues resulting ones (in stead of pushing) */
  /* initial skipped data is added to buffers_pending */
  gst_base_parse_drain (parse);

  if (parse->priv->buffers_send) {
    buf = GST_BUFFER_CAST (parse->priv->buffers_send->data);
    seen_key |= !GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_DELTA_UNIT);
  }

  /* add metadata (if needed to queued buffers */
  GST_LOG_OBJECT (parse, "last timestamp: %" GST_TIME_FORMAT,
      GST_TIME_ARGS (parse->priv->last_pts));
  while (parse->priv->buffers_queued) {
    buf = GST_BUFFER_CAST (parse->priv->buffers_queued->data);

    /* no touching if upstream or parsing provided time */
    if (GST_BUFFER_PTS_IS_VALID (buf)) {
      GST_LOG_OBJECT (parse, "buffer has time %" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_PTS (buf)));
    } else if (GST_BUFFER_DURATION_IS_VALID (buf)) {
      if (GST_CLOCK_TIME_IS_VALID (parse->priv->last_pts)) {
        if (G_LIKELY (GST_BUFFER_DURATION (buf) <= parse->priv->last_pts))
          parse->priv->last_pts -= GST_BUFFER_DURATION (buf);
        else
          parse->priv->last_pts = 0;
        GST_BUFFER_PTS (buf) = parse->priv->last_pts;
        GST_LOG_OBJECT (parse, "applied time %" GST_TIME_FORMAT,
            GST_TIME_ARGS (GST_BUFFER_PTS (buf)));
      }
      if (GST_CLOCK_TIME_IS_VALID (parse->priv->last_dts)) {
        if (G_LIKELY (GST_BUFFER_DURATION (buf) <= parse->priv->last_dts))
          parse->priv->last_dts -= GST_BUFFER_DURATION (buf);
        else
          parse->priv->last_dts = 0;
        GST_BUFFER_DTS (buf) = parse->priv->last_dts;
        GST_LOG_OBJECT (parse, "applied dts %" GST_TIME_FORMAT,
            GST_TIME_ARGS (GST_BUFFER_DTS (buf)));
      }
    } else {
      /* no idea, very bad */
      GST_WARNING_OBJECT (parse, "could not determine time for buffer");
    }

    parse->priv->last_pts = GST_BUFFER_PTS (buf);
    parse->priv->last_dts = GST_BUFFER_DTS (buf);

    /* reverse order for ascending sending */
    /* send downstream at keyframe not preceded by a keyframe
     * (e.g. that should identify start of collection of IDR nals) */
    if (GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_DELTA_UNIT)) {
      if (seen_key) {
        ret = gst_base_parse_send_buffers (parse);
        /* if a problem, throw all to sending */
        if (ret != GST_FLOW_OK) {
          parse->priv->buffers_send =
              g_slist_reverse (parse->priv->buffers_queued);
          parse->priv->buffers_queued = NULL;
          break;
        }
        seen_key = FALSE;
      }
      seen_delta = TRUE;
    } else {
      seen_key = TRUE;
    }

    parse->priv->buffers_send =
        g_slist_prepend (parse->priv->buffers_send, buf);
    parse->priv->buffers_queued =
        g_slist_delete_link (parse->priv->buffers_queued,
        parse->priv->buffers_queued);
  }

  /* audio may have all marked as keyframe, so arrange to send here. Also
   * we might have ended the loop above on a keyframe, in which case we
   * should */
  if (!seen_delta || seen_key)
    ret = gst_base_parse_send_buffers (parse);

  /* any trailing unused no longer usable (ideally none) */
  if (G_UNLIKELY (gst_adapter_available (parse->priv->adapter))) {
    GST_DEBUG_OBJECT (parse, "discarding %" G_GSIZE_FORMAT " trailing bytes",
        gst_adapter_available (parse->priv->adapter));
    gst_adapter_clear (parse->priv->adapter);
  }

  return ret;
}

/* small helper that checks whether we have been trying to resync too long */
static inline GstFlowReturn
gst_base_parse_check_sync (GstBaseParse * parse)
{
  if (G_UNLIKELY (parse->priv->discont &&
          parse->priv->offset - parse->priv->sync_offset > 2 * 1024 * 1024)) {
    GST_ELEMENT_ERROR (parse, STREAM, DECODE,
        ("Failed to parse stream"), (NULL));
    return GST_FLOW_ERROR;
  }

  return GST_FLOW_OK;
}

static GstFlowReturn
gst_base_parse_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstBaseParseClass *bclass;
  GstBaseParse *parse;
  GstFlowReturn ret = GST_FLOW_OK;
  GstFlowReturn old_ret = GST_FLOW_OK;
  GstBuffer *tmpbuf = NULL;
  guint fsize = 1;
  gint skip = -1;
  const guint8 *data;
  guint min_size, av;
  GstClockTime pts, dts;

  parse = GST_BASE_PARSE (parent);
  bclass = GST_BASE_PARSE_GET_CLASS (parse);

  if (parse->priv->detecting) {
    GstBuffer *detect_buf;

    if (parse->priv->detect_buffers_size == 0) {
      detect_buf = gst_buffer_ref (buffer);
    } else {
      GList *l;
      guint offset = 0;

      detect_buf = gst_buffer_new ();

      for (l = parse->priv->detect_buffers; l; l = l->next) {
        gsize tmpsize = gst_buffer_get_size (l->data);

        gst_buffer_copy_into (detect_buf, GST_BUFFER_CAST (l->data),
            GST_BUFFER_COPY_MEMORY, offset, tmpsize);
        offset += tmpsize;
      }
      if (buffer)
        gst_buffer_copy_into (detect_buf, buffer, GST_BUFFER_COPY_MEMORY,
            offset, gst_buffer_get_size (buffer));
    }

    ret = bclass->detect (parse, detect_buf);
    gst_buffer_unref (detect_buf);

    if (ret == GST_FLOW_OK) {
      GList *l;

      /* Detected something */
      parse->priv->detecting = FALSE;

      for (l = parse->priv->detect_buffers; l; l = l->next) {
        if (ret == GST_FLOW_OK && !parse->priv->flushing)
          ret =
              gst_base_parse_chain (GST_BASE_PARSE_SINK_PAD (parse),
              parent, GST_BUFFER_CAST (l->data));
        else
          gst_buffer_unref (GST_BUFFER_CAST (l->data));
      }
      g_list_free (parse->priv->detect_buffers);
      parse->priv->detect_buffers = NULL;
      parse->priv->detect_buffers_size = 0;

      if (ret != GST_FLOW_OK) {
        return ret;
      }

      /* Handle the current buffer */
    } else if (ret == GST_FLOW_NOT_NEGOTIATED) {
      /* Still detecting, append buffer or error out if draining */

      if (parse->priv->drain) {
        GST_DEBUG_OBJECT (parse, "Draining but did not detect format yet");
        return GST_FLOW_ERROR;
      } else if (parse->priv->flushing) {
        g_list_foreach (parse->priv->detect_buffers, (GFunc) gst_buffer_unref,
            NULL);
        g_list_free (parse->priv->detect_buffers);
        parse->priv->detect_buffers = NULL;
        parse->priv->detect_buffers_size = 0;
      } else {
        parse->priv->detect_buffers =
            g_list_append (parse->priv->detect_buffers, buffer);
        parse->priv->detect_buffers_size += gst_buffer_get_size (buffer);
        return GST_FLOW_OK;
      }
    } else {
      /* Something went wrong, subclass responsible for error reporting */
      return ret;
    }

    /* And now handle the current buffer if detection worked */
  }

  if (G_LIKELY (buffer)) {
    GST_LOG_OBJECT (parse,
        "buffer size: %" G_GSIZE_FORMAT ", offset = %" G_GINT64_FORMAT
        ", dts %" GST_TIME_FORMAT ", pts %" GST_TIME_FORMAT,
        gst_buffer_get_size (buffer), GST_BUFFER_OFFSET (buffer),
        GST_TIME_ARGS (GST_BUFFER_DTS (buffer)),
        GST_TIME_ARGS (GST_BUFFER_PTS (buffer)));

    if (G_UNLIKELY (!parse->priv->disable_passthrough
            && parse->priv->passthrough)) {
      GstBaseParseFrame frame;

      gst_base_parse_frame_init (&frame);
      frame.buffer = gst_buffer_make_writable (buffer);
      ret = gst_base_parse_push_frame (parse, &frame);
      gst_base_parse_frame_free (&frame);
      return ret;
    }
    /* upstream feeding us in reverse playback;
     * finish previous fragment and start new upon DISCONT */
    if (parse->segment.rate < 0.0) {
      if (G_UNLIKELY (GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_DISCONT))) {
        GST_DEBUG_OBJECT (parse, "buffer starts new reverse playback fragment");
        ret = gst_base_parse_finish_fragment (parse, TRUE);
        gst_base_parse_start_fragment (parse);
      }
    }
    gst_adapter_push (parse->priv->adapter, buffer);
  }

  /* Parse and push as many frames as possible */
  /* Stop either when adapter is empty or we are flushing */
  while (!parse->priv->flushing) {
    gint flush = 0;

    /* note: if subclass indicates MAX fsize,
     * this will not likely be available anyway ... */
    min_size = MAX (parse->priv->min_frame_size, fsize);
    av = gst_adapter_available (parse->priv->adapter);

    if (G_UNLIKELY (parse->priv->drain)) {
      min_size = av;
      GST_DEBUG_OBJECT (parse, "draining, data left: %d", min_size);
      if (G_UNLIKELY (!min_size)) {
        goto done;
      }
    }

    /* Collect at least min_frame_size bytes */
    if (av < min_size) {
      GST_DEBUG_OBJECT (parse, "not enough data available (only %d bytes)", av);
      goto done;
    }

    /* move along with upstream timestamp (if any),
     * but interpolate in between */
    pts = gst_adapter_prev_pts (parse->priv->adapter, NULL);
    dts = gst_adapter_prev_dts (parse->priv->adapter, NULL);
    if (GST_CLOCK_TIME_IS_VALID (pts) && (parse->priv->prev_pts != pts))
      parse->priv->prev_pts = parse->priv->next_pts = pts;

    if (GST_CLOCK_TIME_IS_VALID (dts) && (parse->priv->prev_dts != dts))
      parse->priv->prev_dts = parse->priv->next_dts = dts;

    /* we can mess with, erm interpolate, timestamps,
     * and incoming stuff has PTS but no DTS seen so far,
     * then pick up DTS from PTS and hope for the best ... */
    if (parse->priv->infer_ts &&
        parse->priv->pts_interpolate &&
        !GST_CLOCK_TIME_IS_VALID (dts) &&
        !GST_CLOCK_TIME_IS_VALID (parse->priv->prev_dts) &&
        GST_CLOCK_TIME_IS_VALID (pts))
      parse->priv->next_dts = pts;

    /* always pass all available data */
    data = gst_adapter_map (parse->priv->adapter, av);
    /* arrange for actual data to be copied if subclass tries to,
     * since what is passed is tied to the adapter */
    tmpbuf = gst_buffer_new_wrapped_full (GST_MEMORY_FLAG_READONLY |
        GST_MEMORY_FLAG_NO_SHARE, (gpointer) data, av, 0, av, NULL, NULL);

    /* already inform subclass what timestamps we have planned,
     * at least if provided by time-based upstream */
    if (parse->priv->upstream_format == GST_FORMAT_TIME) {
      GST_BUFFER_PTS (tmpbuf) = parse->priv->next_pts;
      GST_BUFFER_DTS (tmpbuf) = parse->priv->next_dts;
    }

    /* keep the adapter mapped, so keep track of what has to be flushed */
    ret = gst_base_parse_handle_buffer (parse, tmpbuf, &skip, &flush);
    tmpbuf = NULL;

    /* probably already implicitly unmapped due to adapter operation,
     * but for good measure ... */
    gst_adapter_unmap (parse->priv->adapter);
    if (ret != GST_FLOW_OK && ret != GST_FLOW_NOT_LINKED) {
      goto done;
    }
    if (skip == 0 && flush == 0) {
      GST_LOG_OBJECT (parse, "nothing skipped and no frames finished, "
          "breaking to get more data");
      /* ignore this return as it produced no data */
      ret = old_ret;
      goto done;
    }
    old_ret = ret;
  }

done:
  GST_LOG_OBJECT (parse, "chain leaving");
  return ret;
}

/* pull @size bytes at current offset,
 * i.e. at least try to and possibly return a shorter buffer if near the end */
static GstFlowReturn
gst_base_parse_pull_range (GstBaseParse * parse, guint size,
    GstBuffer ** buffer)
{
  GstFlowReturn ret = GST_FLOW_OK;

  g_return_val_if_fail (buffer != NULL, GST_FLOW_ERROR);

  /* Caching here actually makes much less difference than one would expect.
   * We do it mainly to avoid pulling buffers of 1 byte all the time */
  if (parse->priv->cache) {
    gint64 cache_offset = GST_BUFFER_OFFSET (parse->priv->cache);
    gint cache_size = gst_buffer_get_size (parse->priv->cache);

    if (cache_offset <= parse->priv->offset &&
        (parse->priv->offset + size) <= (cache_offset + cache_size)) {
      *buffer = gst_buffer_copy_region (parse->priv->cache, GST_BUFFER_COPY_ALL,
          parse->priv->offset - cache_offset, size);
      GST_BUFFER_OFFSET (*buffer) = parse->priv->offset;
      return GST_FLOW_OK;
    }
    /* not enough data in the cache, free cache and get a new one */
    gst_buffer_unref (parse->priv->cache);
    parse->priv->cache = NULL;
  }

  /* refill the cache */
  ret =
      gst_pad_pull_range (parse->sinkpad, parse->priv->offset, MAX (size,
          64 * 1024), &parse->priv->cache);
  if (ret != GST_FLOW_OK) {
    parse->priv->cache = NULL;
    return ret;
  }

  if (gst_buffer_get_size (parse->priv->cache) >= size) {
    *buffer =
        gst_buffer_copy_region (parse->priv->cache, GST_BUFFER_COPY_ALL, 0,
        size);
    GST_BUFFER_OFFSET (*buffer) = parse->priv->offset;
    return GST_FLOW_OK;
  }

  /* Not possible to get enough data, try a last time with
   * requesting exactly the size we need */
  gst_buffer_unref (parse->priv->cache);
  parse->priv->cache = NULL;

  ret = gst_pad_pull_range (parse->sinkpad, parse->priv->offset, size,
      &parse->priv->cache);

  if (ret != GST_FLOW_OK) {
    GST_DEBUG_OBJECT (parse, "pull_range returned %d", ret);
    *buffer = NULL;
    return ret;
  }

  if (gst_buffer_get_size (parse->priv->cache) < size) {
    GST_DEBUG_OBJECT (parse, "Returning short buffer at offset %"
        G_GUINT64_FORMAT ": wanted %u bytes, got %" G_GSIZE_FORMAT " bytes",
        parse->priv->offset, size, gst_buffer_get_size (parse->priv->cache));

    *buffer = parse->priv->cache;
    parse->priv->cache = NULL;

    return GST_FLOW_OK;
  }

  *buffer =
      gst_buffer_copy_region (parse->priv->cache, GST_BUFFER_COPY_ALL, 0, size);
  GST_BUFFER_OFFSET (*buffer) = parse->priv->offset;

  return GST_FLOW_OK;
}

static GstFlowReturn
gst_base_parse_handle_previous_fragment (GstBaseParse * parse)
{
  gint64 offset = 0;
  GstClockTime ts = 0;
  GstBuffer *buffer;
  GstFlowReturn ret;

  GST_DEBUG_OBJECT (parse, "fragment ended; last_ts = %" GST_TIME_FORMAT
      ", last_offset = %" G_GINT64_FORMAT,
      GST_TIME_ARGS (parse->priv->last_pts), parse->priv->last_offset);

  if (!parse->priv->last_offset
      || parse->priv->last_pts <= parse->segment.start) {
    GST_DEBUG_OBJECT (parse, "past start of segment %" GST_TIME_FORMAT,
        GST_TIME_ARGS (parse->segment.start));
    ret = GST_FLOW_EOS;
    goto exit;
  }

  /* last fragment started at last_offset / last_ts;
   * seek back 10s capped at 1MB */
  if (parse->priv->last_pts >= 10 * GST_SECOND)
    ts = parse->priv->last_pts - 10 * GST_SECOND;
  /* if we are exact now, we will be more so going backwards */
  if (parse->priv->exact_position) {
    offset = gst_base_parse_find_offset (parse, ts, TRUE, NULL);
  } else {
    if (!gst_base_parse_convert (parse, GST_FORMAT_TIME, ts,
            GST_FORMAT_BYTES, &offset)) {
      GST_DEBUG_OBJECT (parse, "conversion failed, only BYTE based");
    }
  }
  offset = CLAMP (offset, parse->priv->last_offset - 1024 * 1024,
      parse->priv->last_offset - 1024);
  offset = MAX (0, offset);

  GST_DEBUG_OBJECT (parse, "next fragment from offset %" G_GINT64_FORMAT,
      offset);
  parse->priv->offset = offset;

  ret = gst_base_parse_pull_range (parse, parse->priv->last_offset - offset,
      &buffer);
  if (ret != GST_FLOW_OK)
    goto exit;

  /* offset will increase again as fragment is processed/parsed */
  parse->priv->last_offset = offset;

  gst_base_parse_start_fragment (parse);
  gst_adapter_push (parse->priv->adapter, buffer);
  ret = gst_base_parse_finish_fragment (parse, TRUE);
  if (ret != GST_FLOW_OK)
    goto exit;

  /* force previous fragment */
  parse->priv->offset = -1;

exit:
  return ret;
}

/* PULL mode:
 * pull and scan for next frame starting from current offset
 * ajusts sync, drain and offset going along */
static GstFlowReturn
gst_base_parse_scan_frame (GstBaseParse * parse, GstBaseParseClass * klass)
{
  GstBuffer *buffer;
  GstFlowReturn ret = GST_FLOW_OK;
  guint fsize, min_size;
  gint flushed = 0;
  gint skip = 0;

  GST_LOG_OBJECT (parse, "scanning for frame at offset %" G_GUINT64_FORMAT
      " (%#" G_GINT64_MODIFIER "x)", parse->priv->offset, parse->priv->offset);

  /* let's make this efficient for all subclass once and for all;
   * maybe it does not need this much, but in the latter case, we know we are
   * in pull mode here and might as well try to read and supply more anyway
   * (so does the buffer caching mechanism) */
  fsize = 64 * 1024;

  while (TRUE) {
    min_size = MAX (parse->priv->min_frame_size, fsize);

    GST_LOG_OBJECT (parse, "reading buffer size %u", min_size);

    ret = gst_base_parse_pull_range (parse, min_size, &buffer);
    if (ret != GST_FLOW_OK)
      goto done;

    /* if we got a short read, inform subclass we are draining leftover
     * and no more is to be expected */
    if (gst_buffer_get_size (buffer) < min_size) {
      GST_LOG_OBJECT (parse, "... but did not get that; marked draining");
      parse->priv->drain = TRUE;
    }

    if (parse->priv->detecting) {
      ret = klass->detect (parse, buffer);
      if (ret == GST_FLOW_NOT_NEGOTIATED) {
        /* If draining we error out, otherwise request a buffer
         * with 64kb more */
        if (parse->priv->drain) {
          gst_buffer_unref (buffer);
          GST_ERROR_OBJECT (parse, "Failed to detect format but draining");
          return GST_FLOW_ERROR;
        } else {
          fsize += 64 * 1024;
          gst_buffer_unref (buffer);
          continue;
        }
      } else if (ret != GST_FLOW_OK) {
        gst_buffer_unref (buffer);
        GST_ERROR_OBJECT (parse, "detect() returned %s",
            gst_flow_get_name (ret));
        return ret;
      }

      /* Else handle this buffer normally */
    }

    ret = gst_base_parse_handle_buffer (parse, buffer, &skip, &flushed);
    if (ret != GST_FLOW_OK)
      break;

    /* something flushed means something happened,
     * and we should bail out of this loop so as not to occupy
     * the task thread indefinitely */
    if (flushed) {
      GST_LOG_OBJECT (parse, "frame finished, breaking loop");
      break;
    }
    /* nothing flushed, no skip and draining, so nothing left to do */
    if (!skip && parse->priv->drain) {
      GST_LOG_OBJECT (parse, "no activity or result when draining; "
          "breaking loop and marking EOS");
      ret = GST_FLOW_EOS;
      break;
    }
    /* otherwise, get some more data
     * note that is checked this does not happen indefinitely */
    if (!skip) {
      GST_LOG_OBJECT (parse, "getting some more data");
      fsize += 64 * 1024;
    }
    parse->priv->drain = FALSE;
  }

done:
  return ret;
}

/* Loop that is used in pull mode to retrieve data from upstream */
static void
gst_base_parse_loop (GstPad * pad)
{
  GstBaseParse *parse;
  GstBaseParseClass *klass;
  GstFlowReturn ret = GST_FLOW_OK;

  parse = GST_BASE_PARSE (gst_pad_get_parent (pad));
  klass = GST_BASE_PARSE_GET_CLASS (parse);

  GST_LOG_OBJECT (parse, "Entering parse loop");

  if (G_UNLIKELY (parse->priv->push_stream_start)) {
    gchar *stream_id;
    GstEvent *event;

    stream_id =
        gst_pad_create_stream_id (parse->srcpad, GST_ELEMENT_CAST (parse),
        NULL);

    event = gst_event_new_stream_start (stream_id);
    gst_event_set_group_id (event, gst_util_group_id_next ());

    GST_DEBUG_OBJECT (parse, "Pushing STREAM_START");
    gst_pad_push_event (parse->srcpad, event);
    parse->priv->push_stream_start = FALSE;
    g_free (stream_id);
  }

  /* reverse playback:
   * first fragment (closest to stop time) is handled normally below,
   * then we pull in fragments going backwards */
  if (parse->segment.rate < 0.0) {
    /* check if we jumped back to a previous fragment,
     * which is a post-first fragment */
    if (parse->priv->offset < 0) {
      ret = gst_base_parse_handle_previous_fragment (parse);
      goto done;
    }
  }

  ret = gst_base_parse_scan_frame (parse, klass);
  if (ret != GST_FLOW_OK)
    goto done;

  /* eat expected eos signalling past segment in reverse playback */
  if (parse->segment.rate < 0.0 && ret == GST_FLOW_EOS &&
      parse->segment.position >= parse->segment.stop) {
    GST_DEBUG_OBJECT (parse, "downstream has reached end of segment");
    /* push what was accumulated during loop run */
    gst_base_parse_finish_fragment (parse, FALSE);
    /* force previous fragment */
    parse->priv->offset = -1;
    ret = GST_FLOW_OK;
  }

done:
  if (ret == GST_FLOW_EOS)
    goto eos;
  else if (ret != GST_FLOW_OK)
    goto pause;

  gst_object_unref (parse);
  return;

  /* ERRORS */
eos:
  {
    ret = GST_FLOW_EOS;
    GST_DEBUG_OBJECT (parse, "eos");
    /* fall-through */
  }
pause:
  {
    gboolean push_eos = FALSE;

    GST_DEBUG_OBJECT (parse, "pausing task, reason %s",
        gst_flow_get_name (ret));
    gst_pad_pause_task (parse->sinkpad);

    if (ret == GST_FLOW_EOS) {
      /* handle end-of-stream/segment */
      if (parse->segment.flags & GST_SEGMENT_FLAG_SEGMENT) {
        gint64 stop;

        if ((stop = parse->segment.stop) == -1)
          stop = parse->segment.duration;

        GST_DEBUG_OBJECT (parse, "sending segment_done");

        gst_element_post_message
            (GST_ELEMENT_CAST (parse),
            gst_message_new_segment_done (GST_OBJECT_CAST (parse),
                GST_FORMAT_TIME, stop));
        gst_pad_push_event (parse->srcpad,
            gst_event_new_segment_done (GST_FORMAT_TIME, stop));
      } else {
        /* If we STILL have zero frames processed, fire an error */
        if (parse->priv->framecount == 0) {
          GST_ELEMENT_ERROR (parse, STREAM, WRONG_TYPE,
              ("No valid frames found before end of stream"), (NULL));
        }
        push_eos = TRUE;
      }
    } else if (ret == GST_FLOW_NOT_LINKED || ret < GST_FLOW_EOS) {
      /* for fatal errors we post an error message, wrong-state is
       * not fatal because it happens due to flushes and only means
       * that we should stop now. */
      GST_ELEMENT_ERROR (parse, STREAM, FAILED, (NULL),
          ("streaming stopped, reason %s", gst_flow_get_name (ret)));
      push_eos = TRUE;
    }
    if (push_eos) {
      /* Push pending events, including SEGMENT events */
      gst_base_parse_push_pending_events (parse);

      gst_pad_push_event (parse->srcpad, gst_event_new_eos ());
    }
    gst_object_unref (parse);
  }
}

static gboolean
gst_base_parse_sink_activate (GstPad * sinkpad, GstObject * parent)
{
  GstSchedulingFlags sched_flags;
  GstBaseParse *parse;
  GstQuery *query;
  gboolean pull_mode;

  parse = GST_BASE_PARSE (parent);

  GST_DEBUG_OBJECT (parse, "sink activate");

  query = gst_query_new_scheduling ();
  if (!gst_pad_peer_query (sinkpad, query)) {
    gst_query_unref (query);
    goto baseparse_push;
  }

  gst_query_parse_scheduling (query, &sched_flags, NULL, NULL, NULL);

  pull_mode = gst_query_has_scheduling_mode (query, GST_PAD_MODE_PULL)
      && ((sched_flags & GST_SCHEDULING_FLAG_SEEKABLE) != 0);

  gst_query_unref (query);

  if (!pull_mode)
    goto baseparse_push;

  GST_DEBUG_OBJECT (parse, "trying to activate in pull mode");
  if (!gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PULL, TRUE))
    goto baseparse_push;

  parse->priv->push_stream_start = TRUE;

  return gst_pad_start_task (sinkpad, (GstTaskFunction) gst_base_parse_loop,
      sinkpad, NULL);
  /* fallback */
baseparse_push:
  {
    GST_DEBUG_OBJECT (parse, "trying to activate in push mode");
    return gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PUSH, TRUE);
  }
}

static gboolean
gst_base_parse_activate (GstBaseParse * parse, gboolean active)
{
  GstBaseParseClass *klass;
  gboolean result = TRUE;

  GST_DEBUG_OBJECT (parse, "activate %d", active);

  klass = GST_BASE_PARSE_GET_CLASS (parse);

  if (active) {
    if (parse->priv->pad_mode == GST_PAD_MODE_NONE && klass->start)
      result = klass->start (parse);

    /* If the subclass implements ::detect we want to
     * call it for the first buffers now */
    parse->priv->detecting = (klass->detect != NULL);
  } else {
    /* We must make sure streaming has finished before resetting things
     * and calling the ::stop vfunc */
    GST_PAD_STREAM_LOCK (parse->sinkpad);
    GST_PAD_STREAM_UNLOCK (parse->sinkpad);

    if (parse->priv->pad_mode != GST_PAD_MODE_NONE && klass->stop)
      result = klass->stop (parse);

    parse->priv->pad_mode = GST_PAD_MODE_NONE;
  }
  GST_DEBUG_OBJECT (parse, "activate return: %d", result);
  return result;
}

static gboolean
gst_base_parse_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean result;
  GstBaseParse *parse;

  parse = GST_BASE_PARSE (parent);

  GST_DEBUG_OBJECT (parse, "sink %sactivate in %s mode",
      (active) ? "" : "de", gst_pad_mode_get_name (mode));

  if (!gst_base_parse_activate (parse, active))
    goto activate_failed;

  switch (mode) {
    case GST_PAD_MODE_PULL:
      if (active) {
        parse->priv->pending_events =
            g_list_prepend (parse->priv->pending_events,
            gst_event_new_segment (&parse->segment));
        result = TRUE;
      } else {
        result = gst_pad_stop_task (pad);
      }
      break;
    default:
      result = TRUE;
      break;
  }
  if (result)
    parse->priv->pad_mode = active ? mode : GST_PAD_MODE_NONE;

  GST_DEBUG_OBJECT (parse, "sink activate return: %d", result);

  return result;

  /* ERRORS */
activate_failed:
  {
    GST_DEBUG_OBJECT (parse, "activate failed");
    return FALSE;
  }
}

/**
 * gst_base_parse_set_duration:
 * @parse: #GstBaseParse.
 * @fmt: #GstFormat.
 * @duration: duration value.
 * @interval: how often to update the duration estimate based on bitrate, or 0.
 *
 * Sets the duration of the currently playing media. Subclass can use this
 * when it is able to determine duration and/or notices a change in the media
 * duration.  Alternatively, if @interval is non-zero (default), then stream
 * duration is determined based on estimated bitrate, and updated every @interval
 * frames.
 */
void
gst_base_parse_set_duration (GstBaseParse * parse,
    GstFormat fmt, gint64 duration, gint interval)
{
  g_return_if_fail (parse != NULL);

  if (parse->priv->upstream_has_duration) {
    GST_DEBUG_OBJECT (parse, "using upstream duration; discarding update");
    goto exit;
  }

  if (duration != parse->priv->duration) {
    GstMessage *m;

    m = gst_message_new_duration_changed (GST_OBJECT (parse));
    gst_element_post_message (GST_ELEMENT (parse), m);

    /* TODO: what about duration tag? */
  }
  parse->priv->duration = duration;
  parse->priv->duration_fmt = fmt;
  GST_DEBUG_OBJECT (parse, "set duration: %" G_GINT64_FORMAT, duration);
  if (fmt == GST_FORMAT_TIME && GST_CLOCK_TIME_IS_VALID (duration)) {
    if (interval != 0) {
      GST_DEBUG_OBJECT (parse, "valid duration provided, disabling estimate");
      interval = 0;
    }
  }
  GST_DEBUG_OBJECT (parse, "set update interval: %d", interval);
  parse->priv->update_interval = interval;
exit:
  return;
}

/**
 * gst_base_parse_set_average_bitrate:
 * @parse: #GstBaseParse.
 * @bitrate: average bitrate in bits/second
 *
 * Optionally sets the average bitrate detected in media (if non-zero),
 * e.g. based on metadata, as it will be posted to the application.
 *
 * By default, announced average bitrate is estimated. The average bitrate
 * is used to estimate the total duration of the stream and to estimate
 * a seek position, if there's no index and the format is syncable
 * (see gst_base_parse_set_syncable()).
 */
void
gst_base_parse_set_average_bitrate (GstBaseParse * parse, guint bitrate)
{
  parse->priv->bitrate = bitrate;
  GST_DEBUG_OBJECT (parse, "bitrate %u", bitrate);
}

/**
 * gst_base_parse_set_min_frame_size:
 * @parse: #GstBaseParse.
 * @min_size: Minimum size of the data that this base class should give to
 *            subclass.
 *
 * Subclass can use this function to tell the base class that it needs to
 * give at least #min_size buffers.
 */
void
gst_base_parse_set_min_frame_size (GstBaseParse * parse, guint min_size)
{
  g_return_if_fail (parse != NULL);

  parse->priv->min_frame_size = min_size;
  GST_LOG_OBJECT (parse, "set frame_min_size: %d", min_size);
}

/**
 * gst_base_parse_set_frame_rate:
 * @parse: the #GstBaseParse to set
 * @fps_num: frames per second (numerator).
 * @fps_den: frames per second (denominator).
 * @lead_in: frames needed before a segment for subsequent decode
 * @lead_out: frames needed after a segment
 *
 * If frames per second is configured, parser can take care of buffer duration
 * and timestamping.  When performing segment clipping, or seeking to a specific
 * location, a corresponding decoder might need an initial @lead_in and a
 * following @lead_out number of frames to ensure the desired segment is
 * entirely filled upon decoding.
 */
void
gst_base_parse_set_frame_rate (GstBaseParse * parse, guint fps_num,
    guint fps_den, guint lead_in, guint lead_out)
{
  g_return_if_fail (parse != NULL);

  parse->priv->fps_num = fps_num;
  parse->priv->fps_den = fps_den;
  if (!fps_num || !fps_den) {
    GST_DEBUG_OBJECT (parse, "invalid fps (%d/%d), ignoring parameters",
        fps_num, fps_den);
    fps_num = fps_den = 0;
    parse->priv->frame_duration = GST_CLOCK_TIME_NONE;
    parse->priv->lead_in = parse->priv->lead_out = 0;
    parse->priv->lead_in_ts = parse->priv->lead_out_ts = 0;
  } else {
    parse->priv->frame_duration =
        gst_util_uint64_scale (GST_SECOND, fps_den, fps_num);
    parse->priv->lead_in = lead_in;
    parse->priv->lead_out = lead_out;
    parse->priv->lead_in_ts =
        gst_util_uint64_scale (GST_SECOND, fps_den * lead_in, fps_num);
    parse->priv->lead_out_ts =
        gst_util_uint64_scale (GST_SECOND, fps_den * lead_out, fps_num);
    /* aim for about 1.5s to estimate duration */
    if (parse->priv->update_interval < 0) {
      parse->priv->update_interval = fps_num * 3 / (fps_den * 2);
      GST_LOG_OBJECT (parse, "estimated update interval to %d frames",
          parse->priv->update_interval);
    }
  }
  GST_LOG_OBJECT (parse, "set fps: %d/%d => duration: %" G_GINT64_FORMAT " ms",
      fps_num, fps_den, parse->priv->frame_duration / GST_MSECOND);
  GST_LOG_OBJECT (parse, "set lead in: %d frames = %" G_GUINT64_FORMAT " ms, "
      "lead out: %d frames = %" G_GUINT64_FORMAT " ms",
      lead_in, parse->priv->lead_in_ts / GST_MSECOND,
      lead_out, parse->priv->lead_out_ts / GST_MSECOND);
}

/**
 * gst_base_parse_set_has_timing_info:
 * @parse: a #GstBaseParse
 * @has_timing: whether frames carry timing information
 *
 * Set if frames carry timing information which the subclass can (generally)
 * parse and provide.  In particular, intrinsic (rather than estimated) time
 * can be obtained following a seek.
 */
void
gst_base_parse_set_has_timing_info (GstBaseParse * parse, gboolean has_timing)
{
  parse->priv->has_timing_info = has_timing;
  GST_INFO_OBJECT (parse, "has_timing: %s", (has_timing) ? "yes" : "no");
}

/**
 * gst_base_parse_set_syncable:
 * @parse: a #GstBaseParse
 * @syncable: set if frame starts can be identified
 *
 * Set if frame starts can be identified. This is set by default and
 * determines whether seeking based on bitrate averages
 * is possible for a format/stream.
 */
void
gst_base_parse_set_syncable (GstBaseParse * parse, gboolean syncable)
{
  parse->priv->syncable = syncable;
  GST_INFO_OBJECT (parse, "syncable: %s", (syncable) ? "yes" : "no");
}

/**
 * gst_base_parse_set_passthrough:
 * @parse: a #GstBaseParse
 * @passthrough: %TRUE if parser should run in passthrough mode
 *
 * Set if the nature of the format or configuration does not allow (much)
 * parsing, and the parser should operate in passthrough mode (which only
 * applies when operating in push mode). That is, incoming buffers are
 * pushed through unmodified, i.e. no @check_valid_frame or @parse_frame
 * callbacks will be invoked, but @pre_push_frame will still be invoked,
 * so subclass can perform as much or as little is appropriate for
 * passthrough semantics in @pre_push_frame.
 */
void
gst_base_parse_set_passthrough (GstBaseParse * parse, gboolean passthrough)
{
  parse->priv->passthrough = passthrough;
  GST_INFO_OBJECT (parse, "passthrough: %s", (passthrough) ? "yes" : "no");
}

/**
 * gst_base_parse_set_pts_interpolation:
 * @parse: a #GstBaseParse
 * @pts_interpolate: %TRUE if parser should interpolate PTS timestamps
 *
 * By default, the base class will guess PTS timestamps using a simple
 * interpolation (previous timestamp + duration), which is incorrect for
 * data streams with reordering, where PTS can go backward. Sub-classes
 * implementing such formats should disable PTS interpolation.
 */
void
gst_base_parse_set_pts_interpolation (GstBaseParse * parse,
    gboolean pts_interpolate)
{
  parse->priv->pts_interpolate = pts_interpolate;
  GST_INFO_OBJECT (parse, "PTS interpolation: %s",
      (pts_interpolate) ? "yes" : "no");
}

/**
 * gst_base_parse_set_infer_ts:
 * @parse: a #GstBaseParse
 * @infer_ts: %TRUE if parser should infer DTS/PTS from each other
 *
 * By default, the base class might try to infer PTS from DTS and vice
 * versa.  While this is generally correct for audio data, it may not
 * be otherwise. Sub-classes implementing such formats should disable
 * timestamp inferring.
 */
void
gst_base_parse_set_infer_ts (GstBaseParse * parse, gboolean infer_ts)
{
  parse->priv->infer_ts = infer_ts;
  GST_INFO_OBJECT (parse, "TS inferring: %s", (infer_ts) ? "yes" : "no");
}

/**
 * gst_base_parse_set_latency:
 * @parse: a #GstBaseParse
 * @min_latency: minimum parse latency
 * @max_latency: maximum parse latency
 *
 * Sets the minimum and maximum (which may likely be equal) latency introduced
 * by the parsing process.  If there is such a latency, which depends on the
 * particular parsing of the format, it typically corresponds to 1 frame duration.
 */
void
gst_base_parse_set_latency (GstBaseParse * parse, GstClockTime min_latency,
    GstClockTime max_latency)
{
  GST_OBJECT_LOCK (parse);
  parse->priv->min_latency = min_latency;
  parse->priv->max_latency = max_latency;
  GST_OBJECT_UNLOCK (parse);
  GST_INFO_OBJECT (parse, "min/max latency %" GST_TIME_FORMAT ", %"
      GST_TIME_FORMAT, GST_TIME_ARGS (min_latency),
      GST_TIME_ARGS (max_latency));
}

static gboolean
gst_base_parse_get_duration (GstBaseParse * parse, GstFormat format,
    GstClockTime * duration)
{
  gboolean res = FALSE;

  g_return_val_if_fail (duration != NULL, FALSE);

  *duration = GST_CLOCK_TIME_NONE;
  if (parse->priv->duration != -1 && format == parse->priv->duration_fmt) {
    GST_LOG_OBJECT (parse, "using provided duration");
    *duration = parse->priv->duration;
    res = TRUE;
  } else if (parse->priv->duration != -1) {
    GST_LOG_OBJECT (parse, "converting provided duration");
    res = gst_base_parse_convert (parse, parse->priv->duration_fmt,
        parse->priv->duration, format, (gint64 *) duration);
  } else if (format == GST_FORMAT_TIME && parse->priv->estimated_duration != -1) {
    GST_LOG_OBJECT (parse, "using estimated duration");
    *duration = parse->priv->estimated_duration;
    res = TRUE;
  } else {
    GST_LOG_OBJECT (parse, "cannot estimate duration");
  }

  GST_LOG_OBJECT (parse, "res: %d, duration %" GST_TIME_FORMAT, res,
      GST_TIME_ARGS (*duration));
  return res;
}

static gboolean
gst_base_parse_src_query_default (GstBaseParse * parse, GstQuery * query)
{
  gboolean res = FALSE;
  GstPad *pad;

  pad = GST_BASE_PARSE_SRC_PAD (parse);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      gint64 dest_value;
      GstFormat format;

      GST_DEBUG_OBJECT (parse, "position query");
      gst_query_parse_position (query, &format, NULL);

      /* try upstream first */
      res = gst_pad_query_default (pad, GST_OBJECT_CAST (parse), query);
      if (!res) {
        /* Fall back on interpreting segment */
        GST_OBJECT_LOCK (parse);
        if (format == GST_FORMAT_BYTES) {
          dest_value = parse->priv->offset;
          res = TRUE;
        } else if (format == parse->segment.format &&
            GST_CLOCK_TIME_IS_VALID (parse->segment.position)) {
          dest_value = gst_segment_to_stream_time (&parse->segment,
              parse->segment.format, parse->segment.position);
          res = TRUE;
        }
        GST_OBJECT_UNLOCK (parse);
        if (!res) {
          /* no precise result, upstream no idea either, then best estimate */
          /* priv->offset is updated in both PUSH/PULL modes */
          res = gst_base_parse_convert (parse,
              GST_FORMAT_BYTES, parse->priv->offset, format, &dest_value);
        }
        if (res)
          gst_query_set_position (query, format, dest_value);
      }
      break;
    }
    case GST_QUERY_DURATION:
    {
      GstFormat format;
      GstClockTime duration;

      GST_DEBUG_OBJECT (parse, "duration query");
      gst_query_parse_duration (query, &format, NULL);

      /* consult upstream */
      res = gst_pad_query_default (pad, GST_OBJECT_CAST (parse), query);

      /* otherwise best estimate from us */
      if (!res) {
        res = gst_base_parse_get_duration (parse, format, &duration);
        if (res)
          gst_query_set_duration (query, format, duration);
      }
      break;
    }
    case GST_QUERY_SEEKING:
    {
      GstFormat fmt;
      GstClockTime duration = GST_CLOCK_TIME_NONE;
      gboolean seekable = FALSE;

      GST_DEBUG_OBJECT (parse, "seeking query");
      gst_query_parse_seeking (query, &fmt, NULL, NULL, NULL);

      /* consult upstream */
      res = gst_pad_query_default (pad, GST_OBJECT_CAST (parse), query);

      /* we may be able to help if in TIME */
      if (fmt == GST_FORMAT_TIME && gst_base_parse_is_seekable (parse)) {
        gst_query_parse_seeking (query, &fmt, &seekable, NULL, NULL);
        /* already OK if upstream takes care */
        GST_LOG_OBJECT (parse, "upstream handled %d, seekable %d",
            res, seekable);
        if (!(res && seekable)) {
          if (!gst_base_parse_get_duration (parse, GST_FORMAT_TIME, &duration)
              || duration == -1) {
            /* seekable if we still have a chance to get duration later on */
            seekable =
                parse->priv->upstream_seekable && parse->priv->update_interval;
          } else {
            seekable = parse->priv->upstream_seekable;
            GST_LOG_OBJECT (parse, "already determine upstream seekabled: %d",
                seekable);
          }
          gst_query_set_seeking (query, GST_FORMAT_TIME, seekable, 0, duration);
          res = TRUE;
        }
      }
      break;
    }
    case GST_QUERY_FORMATS:
      gst_query_set_formatsv (query, 3, fmtlist);
      res = TRUE;
      break;
    case GST_QUERY_CONVERT:
    {
      GstFormat src_format, dest_format;
      gint64 src_value, dest_value;

      gst_query_parse_convert (query, &src_format, &src_value,
          &dest_format, &dest_value);

      res = gst_base_parse_convert (parse, src_format, src_value,
          dest_format, &dest_value);
      if (res) {
        gst_query_set_convert (query, src_format, src_value,
            dest_format, dest_value);
      }
      break;
    }
    case GST_QUERY_LATENCY:
    {
      if ((res = gst_pad_peer_query (parse->sinkpad, query))) {
        gboolean live;
        GstClockTime min_latency, max_latency;

        gst_query_parse_latency (query, &live, &min_latency, &max_latency);
        GST_DEBUG_OBJECT (parse, "Peer latency: live %d, min %"
            GST_TIME_FORMAT " max %" GST_TIME_FORMAT, live,
            GST_TIME_ARGS (min_latency), GST_TIME_ARGS (max_latency));

        GST_OBJECT_LOCK (parse);
        /* add our latency */
        if (min_latency != -1)
          min_latency += parse->priv->min_latency;
        if (max_latency != -1)
          max_latency += parse->priv->max_latency;
        GST_OBJECT_UNLOCK (parse);

        gst_query_set_latency (query, live, min_latency, max_latency);
      }
      break;
    }
    case GST_QUERY_SEGMENT:
    {
      GstFormat format;
      gint64 start, stop;

      format = parse->segment.format;

      start =
          gst_segment_to_stream_time (&parse->segment, format,
          parse->segment.start);
      if ((stop = parse->segment.stop) == -1)
        stop = parse->segment.duration;
      else
        stop = gst_segment_to_stream_time (&parse->segment, format, stop);

      gst_query_set_segment (query, parse->segment.rate, format, start, stop);
      res = TRUE;
      break;
    }
    default:
      res = gst_pad_query_default (pad, GST_OBJECT_CAST (parse), query);
      break;
  }
  return res;
}

/* scans for a cluster start from @pos,
 * return GST_FLOW_OK and frame position/time in @pos/@time if found */
static GstFlowReturn
gst_base_parse_find_frame (GstBaseParse * parse, gint64 * pos,
    GstClockTime * time, GstClockTime * duration)
{
  GstBaseParseClass *klass;
  gint64 orig_offset;
  gboolean orig_drain, orig_discont;
  GstFlowReturn ret = GST_FLOW_OK;
  GstBuffer *buf = NULL;
  GstBaseParseFrame *sframe = NULL;

  g_return_val_if_fail (pos != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (time != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (duration != NULL, GST_FLOW_ERROR);

  klass = GST_BASE_PARSE_GET_CLASS (parse);

  *time = GST_CLOCK_TIME_NONE;
  *duration = GST_CLOCK_TIME_NONE;

  /* save state */
  orig_offset = parse->priv->offset;
  orig_discont = parse->priv->discont;
  orig_drain = parse->priv->drain;

  GST_DEBUG_OBJECT (parse, "scanning for frame starting at %" G_GINT64_FORMAT
      " (%#" G_GINT64_MODIFIER "x)", *pos, *pos);

  /* jump elsewhere and locate next frame */
  parse->priv->offset = *pos;
  /* mark as scanning so frames don't get processed all the way */
  parse->priv->scanning = TRUE;
  ret = gst_base_parse_scan_frame (parse, klass);
  parse->priv->scanning = FALSE;
  /* retrieve frame found during scan */
  sframe = parse->priv->scanned_frame;
  parse->priv->scanned_frame = NULL;

  if (ret != GST_FLOW_OK || !sframe)
    goto done;

  /* get offset first, subclass parsing might dump other stuff in there */
  *pos = sframe->offset;
  buf = sframe->buffer;
  g_assert (buf);

  /* but it should provide proper time */
  *time = GST_BUFFER_TIMESTAMP (buf);
  *duration = GST_BUFFER_DURATION (buf);

  GST_LOG_OBJECT (parse,
      "frame with time %" GST_TIME_FORMAT " at offset %" G_GINT64_FORMAT,
      GST_TIME_ARGS (*time), *pos);

done:
  if (sframe)
    gst_base_parse_frame_free (sframe);

  /* restore state */
  parse->priv->offset = orig_offset;
  parse->priv->discont = orig_discont;
  parse->priv->drain = orig_drain;

  return ret;
}

/* bisect and scan through file for frame starting before @time,
 * returns OK and @time/@offset if found, NONE and/or error otherwise
 * If @time == G_MAXINT64, scan for duration ( == last frame) */
static GstFlowReturn
gst_base_parse_locate_time (GstBaseParse * parse, GstClockTime * _time,
    gint64 * _offset)
{
  GstFlowReturn ret = GST_FLOW_OK;
  gint64 lpos, hpos, newpos;
  GstClockTime time, ltime, htime, newtime, dur;
  gboolean cont = TRUE;
  const GstClockTime tolerance = TARGET_DIFFERENCE;
  const guint chunk = 4 * 1024;

  g_return_val_if_fail (_time != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (_offset != NULL, GST_FLOW_ERROR);

  GST_DEBUG_OBJECT (parse, "Bisecting for time %" GST_TIME_FORMAT,
      GST_TIME_ARGS (*_time));

  /* TODO also make keyframe aware if useful some day */

  time = *_time;

  /* basic cases */
  if (time == 0) {
    *_offset = 0;
    return GST_FLOW_OK;
  }

  if (time == -1) {
    *_offset = -1;
    return GST_FLOW_OK;
  }

  /* do not know at first */
  *_offset = -1;
  *_time = GST_CLOCK_TIME_NONE;

  /* need initial positions; start and end */
  lpos = parse->priv->first_frame_offset;
  ltime = parse->priv->first_frame_pts;
  /* try other one if no luck */
  if (!GST_CLOCK_TIME_IS_VALID (ltime))
    ltime = parse->priv->first_frame_dts;
  if (!gst_base_parse_get_duration (parse, GST_FORMAT_TIME, &htime)) {
    GST_DEBUG_OBJECT (parse, "Unknown time duration, cannot bisect");
    return GST_FLOW_ERROR;
  }
  hpos = parse->priv->upstream_size;

  GST_DEBUG_OBJECT (parse,
      "Bisection initial bounds: bytes %" G_GINT64_FORMAT " %" G_GINT64_FORMAT
      ", times %" GST_TIME_FORMAT " %" GST_TIME_FORMAT, lpos, hpos,
      GST_TIME_ARGS (ltime), GST_TIME_ARGS (htime));

  /* check preconditions are satisfied;
   * start and end are needed, except for special case where we scan for
   * last frame to determine duration */
  if (parse->priv->pad_mode != GST_PAD_MODE_PULL || !hpos ||
      !GST_CLOCK_TIME_IS_VALID (ltime) ||
      (!GST_CLOCK_TIME_IS_VALID (htime) && time != G_MAXINT64)) {
    return GST_FLOW_OK;
  }

  /* shortcut cases */
  if (time < ltime) {
    goto exit;
  } else if (time < ltime + tolerance) {
    *_offset = lpos;
    *_time = ltime;
    goto exit;
  } else if (time >= htime) {
    *_offset = hpos;
    *_time = htime;
    goto exit;
  }

  while (htime > ltime && cont) {
    GST_LOG_OBJECT (parse,
        "lpos: %" G_GUINT64_FORMAT ", ltime: %" GST_TIME_FORMAT, lpos,
        GST_TIME_ARGS (ltime));
    GST_LOG_OBJECT (parse,
        "hpos: %" G_GUINT64_FORMAT ", htime: %" GST_TIME_FORMAT, hpos,
        GST_TIME_ARGS (htime));
    if (G_UNLIKELY (time == G_MAXINT64)) {
      newpos = hpos;
    } else if (G_LIKELY (hpos > lpos)) {
      newpos =
          gst_util_uint64_scale (hpos - lpos, time - ltime, htime - ltime) +
          lpos - chunk;
    } else {
      /* should mean lpos == hpos, since lpos <= hpos is invariant */
      newpos = lpos;
      /* we check this case once, but not forever, so break loop */
      cont = FALSE;
    }

    /* ensure */
    newpos = CLAMP (newpos, lpos, hpos);
    GST_LOG_OBJECT (parse,
        "estimated _offset for %" GST_TIME_FORMAT ": %" G_GINT64_FORMAT,
        GST_TIME_ARGS (time), newpos);

    ret = gst_base_parse_find_frame (parse, &newpos, &newtime, &dur);
    if (ret == GST_FLOW_EOS) {
      /* heuristic HACK */
      hpos = MAX (lpos, hpos - chunk);
      continue;
    } else if (ret != GST_FLOW_OK) {
      goto exit;
    }

    if (newtime == -1 || newpos == -1) {
      GST_DEBUG_OBJECT (parse, "subclass did not provide metadata; aborting");
      break;
    }

    if (G_UNLIKELY (time == G_MAXINT64)) {
      *_offset = newpos;
      *_time = newtime;
      if (GST_CLOCK_TIME_IS_VALID (dur))
        *_time += dur;
      break;
    } else if (newtime > time) {
      /* overshoot */
      hpos = (newpos >= hpos) ? MAX (lpos, hpos - chunk) : MAX (lpos, newpos);
      htime = newtime;
    } else if (newtime + tolerance > time) {
      /* close enough undershoot */
      *_offset = newpos;
      *_time = newtime;
      break;
    } else if (newtime < ltime) {
      /* so a position beyond lpos resulted in earlier time than ltime ... */
      GST_DEBUG_OBJECT (parse, "non-ascending time; aborting");
      break;
    } else {
      /* undershoot too far */
      newpos += newpos == lpos ? chunk : 0;
      lpos = CLAMP (newpos, lpos, hpos);
      ltime = newtime;
    }
  }

exit:
  GST_LOG_OBJECT (parse, "return offset %" G_GINT64_FORMAT ", time %"
      GST_TIME_FORMAT, *_offset, GST_TIME_ARGS (*_time));
  return ret;
}

static gint64
gst_base_parse_find_offset (GstBaseParse * parse, GstClockTime time,
    gboolean before, GstClockTime * _ts)
{
  gint64 bytes = 0, ts = 0;
  GstIndexEntry *entry = NULL;

  if (time == GST_CLOCK_TIME_NONE) {
    ts = time;
    bytes = -1;
    goto exit;
  }

  GST_BASE_PARSE_INDEX_LOCK (parse);
  if (parse->priv->index) {
    /* Let's check if we have an index entry for that time */
    entry = gst_index_get_assoc_entry (parse->priv->index,
        parse->priv->index_id,
        before ? GST_INDEX_LOOKUP_BEFORE : GST_INDEX_LOOKUP_AFTER,
        GST_INDEX_ASSOCIATION_FLAG_KEY_UNIT, GST_FORMAT_TIME, time);
  }

  if (entry) {
    gst_index_entry_assoc_map (entry, GST_FORMAT_BYTES, &bytes);
    gst_index_entry_assoc_map (entry, GST_FORMAT_TIME, &ts);

    GST_DEBUG_OBJECT (parse, "found index entry for %" GST_TIME_FORMAT
        " at %" GST_TIME_FORMAT ", offset %" G_GINT64_FORMAT,
        GST_TIME_ARGS (time), GST_TIME_ARGS (ts), bytes);
  } else {
    GST_DEBUG_OBJECT (parse, "no index entry found for %" GST_TIME_FORMAT,
        GST_TIME_ARGS (time));
    if (!before) {
      bytes = -1;
      ts = GST_CLOCK_TIME_NONE;
    }
  }
  GST_BASE_PARSE_INDEX_UNLOCK (parse);

exit:
  if (_ts)
    *_ts = ts;

  return bytes;
}

/* returns TRUE if seek succeeded */
static gboolean
gst_base_parse_handle_seek (GstBaseParse * parse, GstEvent * event)
{
  gdouble rate;
  GstFormat format;
  GstSeekFlags flags;
  GstSeekType start_type = GST_SEEK_TYPE_NONE, stop_type;
  gboolean flush, update, res = TRUE, accurate;
  gint64 start, stop, seekpos, seekstop;
  GstSegment seeksegment = { 0, };
  GstClockTime start_ts;
  guint32 seqnum;
  GstEvent *segment_event;

  /* try upstream first, unless we're driving the streaming thread ourselves */
  if (parse->priv->pad_mode != GST_PAD_MODE_PULL) {
    res = gst_pad_push_event (parse->sinkpad, gst_event_ref (event));
    if (res)
      goto done;
  }

  gst_event_parse_seek (event, &rate, &format, &flags,
      &start_type, &start, &stop_type, &stop);
  seqnum = gst_event_get_seqnum (event);

  GST_DEBUG_OBJECT (parse, "seek to format %s, rate %f, "
      "start type %d at %" GST_TIME_FORMAT ", end type %d at %"
      GST_TIME_FORMAT, gst_format_get_name (format), rate,
      start_type, GST_TIME_ARGS (start), stop_type, GST_TIME_ARGS (stop));

  /* we can only handle TIME, so check if subclass can convert
   * to TIME format if it's some other format (such as DEFAULT) */
  if (format != GST_FORMAT_TIME) {
    if (!gst_base_parse_convert (parse, format, start, GST_FORMAT_TIME, &start)
        || !gst_base_parse_convert (parse, format, stop, GST_FORMAT_TIME,
            &stop))
      goto no_convert_to_time;

    GST_INFO_OBJECT (parse, "converted %s format to start time "
        "%" GST_TIME_FORMAT " and stop time %" GST_TIME_FORMAT,
        gst_format_get_name (format), GST_TIME_ARGS (start),
        GST_TIME_ARGS (stop));

    format = GST_FORMAT_TIME;
  }

  /* no negative rates in push mode (unless upstream takes care of that, but
   * we've already tried upstream and it didn't handle the seek request) */
  if (rate < 0.0 && parse->priv->pad_mode == GST_PAD_MODE_PUSH)
    goto negative_rate;

  if (rate < 0.0 && parse->priv->pad_mode == GST_PAD_MODE_PULL)
    goto negative_rate_pull_mode;

  if (start_type != GST_SEEK_TYPE_SET ||
      (stop_type != GST_SEEK_TYPE_SET && stop_type != GST_SEEK_TYPE_NONE))
    goto wrong_type;

  /* get flush flag */
  flush = flags & GST_SEEK_FLAG_FLUSH;

  /* copy segment, we need this because we still need the old
   * segment when we close the current segment. */
  gst_segment_copy_into (&parse->segment, &seeksegment);

  GST_DEBUG_OBJECT (parse, "configuring seek");
  gst_segment_do_seek (&seeksegment, rate, format, flags,
      start_type, start, stop_type, stop, &update);

  /* accurate seeking implies seek tables are used to obtain position,
   * and the requested segment is maintained exactly, not adjusted any way */
  accurate = flags & GST_SEEK_FLAG_ACCURATE;

  /* maybe we can be accurate for (almost) free */
  gst_base_parse_find_offset (parse, seeksegment.position, TRUE, &start_ts);
  if (seeksegment.position <= start_ts + TARGET_DIFFERENCE) {
    GST_DEBUG_OBJECT (parse, "accurate seek possible");
    accurate = TRUE;
  }
  if (accurate) {
    GstClockTime startpos = seeksegment.position;

    /* accurate requested, so ... seek a bit before target */
    if (startpos < parse->priv->lead_in_ts)
      startpos = 0;
    else
      startpos -= parse->priv->lead_in_ts;
    seekpos = gst_base_parse_find_offset (parse, startpos, TRUE, &start_ts);
    seekstop = gst_base_parse_find_offset (parse, seeksegment.stop, FALSE,
        NULL);
  } else {
    start_ts = seeksegment.position;
    if (!gst_base_parse_convert (parse, format, seeksegment.position,
            GST_FORMAT_BYTES, &seekpos))
      goto convert_failed;
    if (!gst_base_parse_convert (parse, format, seeksegment.stop,
            GST_FORMAT_BYTES, &seekstop))
      goto convert_failed;
  }

  GST_DEBUG_OBJECT (parse,
      "seek position %" G_GINT64_FORMAT " in bytes: %" G_GINT64_FORMAT,
      start_ts, seekpos);
  GST_DEBUG_OBJECT (parse,
      "seek stop %" G_GINT64_FORMAT " in bytes: %" G_GINT64_FORMAT,
      seeksegment.stop, seekstop);

  if (parse->priv->pad_mode == GST_PAD_MODE_PULL) {
    gint64 last_stop;

    GST_DEBUG_OBJECT (parse, "seek in PULL mode");

    if (flush) {
      if (parse->srcpad) {
        GstEvent *fevent = gst_event_new_flush_start ();
        GST_DEBUG_OBJECT (parse, "sending flush start");

        gst_event_set_seqnum (fevent, seqnum);

        gst_pad_push_event (parse->srcpad, gst_event_ref (fevent));
        /* unlock upstream pull_range */
        gst_pad_push_event (parse->sinkpad, fevent);
      }
    } else {
      gst_pad_pause_task (parse->sinkpad);
    }

    /* we should now be able to grab the streaming thread because we stopped it
     * with the above flush/pause code */
    GST_PAD_STREAM_LOCK (parse->sinkpad);

    /* save current position */
    last_stop = parse->segment.position;
    GST_DEBUG_OBJECT (parse, "stopped streaming at %" G_GINT64_FORMAT,
        last_stop);

    /* now commit to new position */

    /* prepare for streaming again */
    if (flush) {
      GstEvent *fevent = gst_event_new_flush_stop (TRUE);
      GST_DEBUG_OBJECT (parse, "sending flush stop");
      gst_event_set_seqnum (fevent, seqnum);
      gst_pad_push_event (parse->srcpad, gst_event_ref (fevent));
      gst_pad_push_event (parse->sinkpad, fevent);
      gst_base_parse_clear_queues (parse);
    } else {
      /* keep track of our position */
      seeksegment.base = gst_segment_to_running_time (&seeksegment,
          seeksegment.format, parse->segment.position);
    }

    memcpy (&parse->segment, &seeksegment, sizeof (GstSegment));

    /* store the newsegment event so it can be sent from the streaming thread. */
    /* This will be sent later in _loop() */
    segment_event = gst_event_new_segment (&parse->segment);
    gst_event_set_seqnum (segment_event, seqnum);
    parse->priv->pending_events =
        g_list_prepend (parse->priv->pending_events, segment_event);

    GST_DEBUG_OBJECT (parse, "Created newseg format %d, "
        "start = %" GST_TIME_FORMAT ", stop = %" GST_TIME_FORMAT
        ", time = %" GST_TIME_FORMAT, format,
        GST_TIME_ARGS (parse->segment.start),
        GST_TIME_ARGS (parse->segment.stop),
        GST_TIME_ARGS (parse->segment.time));

    /* one last chance in pull mode to stay accurate;
     * maybe scan and subclass can find where to go */
    if (!accurate) {
      gint64 scanpos;
      GstClockTime ts = seeksegment.position;

      gst_base_parse_locate_time (parse, &ts, &scanpos);
      if (scanpos >= 0) {
        accurate = TRUE;
        seekpos = scanpos;
        /* running collected index now consists of several intervals,
         * so optimized check no longer possible */
        parse->priv->index_last_valid = FALSE;
        parse->priv->index_last_offset = 0;
        parse->priv->index_last_ts = 0;
      }
    }

    /* mark discont if we are going to stream from another position. */
    if (seekpos != parse->priv->offset) {
      GST_DEBUG_OBJECT (parse,
          "mark DISCONT, we did a seek to another position");
      parse->priv->offset = seekpos;
      parse->priv->last_offset = seekpos;
      parse->priv->seen_keyframe = FALSE;
      parse->priv->discont = TRUE;
      parse->priv->next_dts = start_ts;
      parse->priv->next_pts = GST_CLOCK_TIME_NONE;
      parse->priv->last_dts = GST_CLOCK_TIME_NONE;
      parse->priv->last_pts = GST_CLOCK_TIME_NONE;
      parse->priv->sync_offset = seekpos;
      parse->priv->exact_position = accurate;
    }

    /* Start streaming thread if paused */
    gst_pad_start_task (parse->sinkpad,
        (GstTaskFunction) gst_base_parse_loop, parse->sinkpad, NULL);

    GST_PAD_STREAM_UNLOCK (parse->sinkpad);

    /* handled seek */
    res = TRUE;
  } else {
    GstEvent *new_event;
    GstBaseParseSeek *seek;
    GstSeekFlags flags = (flush ? GST_SEEK_FLAG_FLUSH : GST_SEEK_FLAG_NONE);

    /* The only thing we need to do in PUSH-mode is to send the
       seek event (in bytes) to upstream. Segment / flush handling happens
       in corresponding src event handlers */
    GST_DEBUG_OBJECT (parse, "seek in PUSH mode");
    if (seekstop >= 0 && seekstop <= seekpos)
      seekstop = seekpos;
    new_event = gst_event_new_seek (rate, GST_FORMAT_BYTES, flags,
        GST_SEEK_TYPE_SET, seekpos, stop_type, seekstop);
    gst_event_set_seqnum (new_event, seqnum);

    /* store segment info so its precise details can be reconstructed when
     * receiving newsegment;
     * this matters for all details when accurate seeking,
     * is most useful to preserve NONE stop time otherwise */
    seek = g_new0 (GstBaseParseSeek, 1);
    seek->segment = seeksegment;
    seek->accurate = accurate;
    seek->offset = seekpos;
    seek->start_ts = start_ts;
    GST_OBJECT_LOCK (parse);
    /* less optimal, but preserves order */
    parse->priv->pending_seeks =
        g_slist_append (parse->priv->pending_seeks, seek);
    GST_OBJECT_UNLOCK (parse);

    res = gst_pad_push_event (parse->sinkpad, new_event);

    if (!res) {
      GST_OBJECT_LOCK (parse);
      parse->priv->pending_seeks =
          g_slist_remove (parse->priv->pending_seeks, seek);
      GST_OBJECT_UNLOCK (parse);
      g_free (seek);
    }
  }

done:
  gst_event_unref (event);
  return res;

  /* ERRORS */
negative_rate_pull_mode:
  {
    GST_FIXME_OBJECT (parse, "negative playback in pull mode needs fixing");
    res = FALSE;
    goto done;
  }
negative_rate:
  {
    GST_DEBUG_OBJECT (parse, "negative playback rates delegated upstream.");
    res = FALSE;
    goto done;
  }
wrong_type:
  {
    GST_DEBUG_OBJECT (parse, "unsupported seek type.");
    res = FALSE;
    goto done;
  }
no_convert_to_time:
  {
    GST_DEBUG_OBJECT (parse, "seek in %s format was requested, but subclass "
        "couldn't convert that into TIME format", gst_format_get_name (format));
    res = FALSE;
    goto done;
  }
convert_failed:
  {
    GST_DEBUG_OBJECT (parse, "conversion TIME to BYTES failed.");
    res = FALSE;
    goto done;
  }
}

/* Checks if bitrates are available from upstream tags so that we don't
 * override them later
 */
static void
gst_base_parse_handle_tag (GstBaseParse * parse, GstEvent * event)
{
  GstTagList *taglist = NULL;
  guint tmp;

  gst_event_parse_tag (event, &taglist);

  /* We only care about stream tags here */
  if (gst_tag_list_get_scope (taglist) != GST_TAG_SCOPE_STREAM)
    return;

  if (gst_tag_list_get_uint (taglist, GST_TAG_MINIMUM_BITRATE, &tmp)) {
    GST_DEBUG_OBJECT (parse, "upstream min bitrate %d", tmp);
    parse->priv->post_min_bitrate = FALSE;
  }
  if (gst_tag_list_get_uint (taglist, GST_TAG_BITRATE, &tmp)) {
    GST_DEBUG_OBJECT (parse, "upstream avg bitrate %d", tmp);
    parse->priv->post_avg_bitrate = FALSE;
  }
  if (gst_tag_list_get_uint (taglist, GST_TAG_MAXIMUM_BITRATE, &tmp)) {
    GST_DEBUG_OBJECT (parse, "upstream max bitrate %d", tmp);
    parse->priv->post_max_bitrate = FALSE;
  }
}

#if 0
static void
gst_base_parse_set_index (GstElement * element, GstIndex * index)
{
  GstBaseParse *parse = GST_BASE_PARSE (element);

  GST_BASE_PARSE_INDEX_LOCK (parse);
  if (parse->priv->index)
    gst_object_unref (parse->priv->index);
  if (index) {
    parse->priv->index = gst_object_ref (index);
    gst_index_get_writer_id (index, GST_OBJECT_CAST (element),
        &parse->priv->index_id);
    parse->priv->own_index = FALSE;
  } else {
    parse->priv->index = NULL;
  }
  GST_BASE_PARSE_INDEX_UNLOCK (parse);
}

static GstIndex *
gst_base_parse_get_index (GstElement * element)
{
  GstBaseParse *parse = GST_BASE_PARSE (element);
  GstIndex *result = NULL;

  GST_BASE_PARSE_INDEX_LOCK (parse);
  if (parse->priv->index)
    result = gst_object_ref (parse->priv->index);
  GST_BASE_PARSE_INDEX_UNLOCK (parse);

  return result;
}
#endif

static GstStateChangeReturn
gst_base_parse_change_state (GstElement * element, GstStateChange transition)
{
  GstBaseParse *parse;
  GstStateChangeReturn result;

  parse = GST_BASE_PARSE (element);

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      /* If this is our own index destroy it as the
       * old entries might be wrong for the new stream */
      GST_BASE_PARSE_INDEX_LOCK (parse);
      if (parse->priv->own_index) {
        gst_object_unref (parse->priv->index);
        parse->priv->index = NULL;
        parse->priv->own_index = FALSE;
      }

      /* If no index was created, generate one */
      if (G_UNLIKELY (!parse->priv->index)) {
        GST_DEBUG_OBJECT (parse, "no index provided creating our own");

        parse->priv->index = g_object_new (gst_mem_index_get_type (), NULL);
        gst_index_get_writer_id (parse->priv->index, GST_OBJECT (parse),
            &parse->priv->index_id);
        parse->priv->own_index = TRUE;
      }
      GST_BASE_PARSE_INDEX_UNLOCK (parse);
      break;
    default:
      break;
  }

  result = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_base_parse_reset (parse);
      break;
    default:
      break;
  }

  return result;
}

/**
 * gst_base_parse_set_ts_at_offset:
 * @parse: a #GstBaseParse
 * @offset: offset into current buffer
 *
 * This function should only be called from a @handle_frame implementation.
 *
 * #GstBaseParse creates initial timestamps for frames by using the last
 * timestamp seen in the stream before the frame starts.  In certain
 * cases, the correct timestamps will occur in the stream after the
 * start of the frame, but before the start of the actual picture data.
 * This function can be used to set the timestamps based on the offset
 * into the frame data that the picture starts.
 *
 * Since: 1.2
 */
void
gst_base_parse_set_ts_at_offset (GstBaseParse * parse, gsize offset)
{
  GstClockTime pts, dts;

  g_return_if_fail (GST_IS_BASE_PARSE (parse));

  pts = gst_adapter_prev_pts_at_offset (parse->priv->adapter, offset, NULL);
  dts = gst_adapter_prev_dts_at_offset (parse->priv->adapter, offset, NULL);

  if (!GST_CLOCK_TIME_IS_VALID (pts) || !GST_CLOCK_TIME_IS_VALID (dts)) {
    GST_DEBUG_OBJECT (parse,
        "offset adapter timestamps dts=%" GST_TIME_FORMAT " pts=%"
        GST_TIME_FORMAT, GST_TIME_ARGS (dts), GST_TIME_ARGS (pts));
  }
  if (GST_CLOCK_TIME_IS_VALID (pts) && (parse->priv->prev_pts != pts))
    parse->priv->prev_pts = parse->priv->next_pts = pts;

  if (GST_CLOCK_TIME_IS_VALID (dts) && (parse->priv->prev_dts != dts))
    parse->priv->prev_dts = parse->priv->next_dts = dts;
}
