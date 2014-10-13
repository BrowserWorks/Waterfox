/* GStreamer input selector
 * Copyright (C) 2003 Julien Moutte <julien@moutte.net>
 * Copyright (C) 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2005 Jan Schmidt <thaytan@mad.scientist.com>
 * Copyright (C) 2007 Wim Taymans <wim.taymans@gmail.com>
 * Copyright (C) 2007 Andy Wingo <wingo@pobox.com>
 * Copyright (C) 2008 Nokia Corporation. (contact <stefan.kost@nokia.com>)
 * Copyright (C) 2011 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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
 * SECTION:element-input-selector
 * @see_also: #GstOutputSelector
 *
 * Direct one out of N input streams to the output pad.
 *
 * The input pads are from a GstPad subclass and have additional
 * properties, which users may find useful, namely:
 *
 * <itemizedlist>
 * <listitem>
 * "running-time": Running time of stream on pad (#gint64)
 * </listitem>
 * <listitem>
 * "tags": The currently active tags on the pad (#GstTagList, boxed type)
 * </listitem>
 * <listitem>
 * "active": If the pad is currently active (#gboolean)
 * </listitem>
 * <listitem>
 * "always-ok" : Make an inactive pads return #GST_FLOW_OK instead of
 * #GST_FLOW_NOT_LINKED
 * </listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "gstinputselector.h"

#define DEBUG_CACHED_BUFFERS 0

GST_DEBUG_CATEGORY_STATIC (input_selector_debug);
#define GST_CAT_DEFAULT input_selector_debug

#define GST_TYPE_INPUT_SELECTOR_SYNC_MODE (gst_input_selector_sync_mode_get_type())
static GType
gst_input_selector_sync_mode_get_type (void)
{
  static GType type = 0;
  static const GEnumValue data[] = {
    {GST_INPUT_SELECTOR_SYNC_MODE_ACTIVE_SEGMENT,
          "Sync using the current active segment",
        "active-segment"},
    {GST_INPUT_SELECTOR_SYNC_MODE_CLOCK, "Sync using the clock", "clock"},
    {0, NULL, NULL},
  };

  if (!type) {
    type = g_enum_register_static ("GstInputSelectorSyncMode", data);
  }
  return type;
}

#define GST_INPUT_SELECTOR_GET_LOCK(sel) (&((GstInputSelector*)(sel))->lock)
#define GST_INPUT_SELECTOR_GET_COND(sel) (&((GstInputSelector*)(sel))->cond)
#define GST_INPUT_SELECTOR_LOCK(sel) (g_mutex_lock (GST_INPUT_SELECTOR_GET_LOCK(sel)))
#define GST_INPUT_SELECTOR_UNLOCK(sel) (g_mutex_unlock (GST_INPUT_SELECTOR_GET_LOCK(sel)))
#define GST_INPUT_SELECTOR_WAIT(sel) (g_cond_wait (GST_INPUT_SELECTOR_GET_COND(sel), \
			GST_INPUT_SELECTOR_GET_LOCK(sel)))
#define GST_INPUT_SELECTOR_BROADCAST(sel) (g_cond_broadcast (GST_INPUT_SELECTOR_GET_COND(sel)))

static GstStaticPadTemplate gst_input_selector_sink_factory =
GST_STATIC_PAD_TEMPLATE ("sink_%u",
    GST_PAD_SINK,
    GST_PAD_REQUEST,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate gst_input_selector_src_factory =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

enum
{
  PROP_0,
  PROP_N_PADS,
  PROP_ACTIVE_PAD,
  PROP_SYNC_STREAMS,
  PROP_SYNC_MODE,
  PROP_CACHE_BUFFERS
};

#define DEFAULT_SYNC_STREAMS TRUE
#define DEFAULT_SYNC_MODE GST_INPUT_SELECTOR_SYNC_MODE_ACTIVE_SEGMENT
#define DEFAULT_CACHE_BUFFERS FALSE
#define DEFAULT_PAD_ALWAYS_OK TRUE

enum
{
  PROP_PAD_0,
  PROP_PAD_RUNNING_TIME,
  PROP_PAD_TAGS,
  PROP_PAD_ACTIVE,
  PROP_PAD_ALWAYS_OK
};

enum
{
  /* methods */
  SIGNAL_BLOCK,
  SIGNAL_SWITCH,
  LAST_SIGNAL
};
static guint gst_input_selector_signals[LAST_SIGNAL] = { 0 };

static void gst_input_selector_active_pad_changed (GstInputSelector * sel,
    GParamSpec * pspec, gpointer user_data);
static inline gboolean gst_input_selector_is_active_sinkpad (GstInputSelector *
    sel, GstPad * pad);
static GstPad *gst_input_selector_activate_sinkpad (GstInputSelector * sel,
    GstPad * pad);
static GstPad *gst_input_selector_get_linked_pad (GstInputSelector * sel,
    GstPad * pad, gboolean strict);

#define GST_TYPE_SELECTOR_PAD \
  (gst_selector_pad_get_type())
#define GST_SELECTOR_PAD(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_SELECTOR_PAD, GstSelectorPad))
#define GST_SELECTOR_PAD_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_SELECTOR_PAD, GstSelectorPadClass))
#define GST_IS_SELECTOR_PAD(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_SELECTOR_PAD))
#define GST_IS_SELECTOR_PAD_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_SELECTOR_PAD))
#define GST_SELECTOR_PAD_CAST(obj) \
  ((GstSelectorPad *)(obj))

typedef struct _GstSelectorPad GstSelectorPad;
typedef struct _GstSelectorPadClass GstSelectorPadClass;
typedef struct _GstSelectorPadCachedBuffer GstSelectorPadCachedBuffer;

struct _GstSelectorPad
{
  GstPad parent;

  gboolean active;              /* when buffer have passed the pad */
  gboolean pushed;              /* when buffer was pushed downstream since activation */
  gboolean eos;                 /* when EOS has been received */
  gboolean eos_sent;            /* when EOS was sent downstream */
  gboolean discont;             /* after switching we create a discont */
  gboolean flushing;            /* set after flush-start and before flush-stop */
  gboolean always_ok;
  GstTagList *tags;             /* last tags received on the pad */

  GstSegment segment;           /* the current segment on the pad */
  guint32 segment_seqnum;       /* sequence number of the current segment */

  gboolean events_pending;      /* TRUE if sticky events need to be updated */

  gboolean sending_cached_buffers;
  GQueue *cached_buffers;
};

struct _GstSelectorPadCachedBuffer
{
  GstBuffer *buffer;
  GstSegment segment;
};

struct _GstSelectorPadClass
{
  GstPadClass parent;
};

GType gst_selector_pad_get_type (void);
static void gst_selector_pad_finalize (GObject * object);
static void gst_selector_pad_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);
static void gst_selector_pad_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);

static gint64 gst_selector_pad_get_running_time (GstSelectorPad * pad);
static void gst_selector_pad_reset (GstSelectorPad * pad);
static gboolean gst_selector_pad_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_selector_pad_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static GstIterator *gst_selector_pad_iterate_linked_pads (GstPad * pad,
    GstObject * parent);
static GstFlowReturn gst_selector_pad_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buf);
static void gst_selector_pad_cache_buffer (GstSelectorPad * selpad,
    GstBuffer * buffer);
static void gst_selector_pad_free_cached_buffers (GstSelectorPad * selpad);

G_DEFINE_TYPE (GstSelectorPad, gst_selector_pad, GST_TYPE_PAD);

static void
gst_selector_pad_class_init (GstSelectorPadClass * klass)
{
  GObjectClass *gobject_class;

  gobject_class = (GObjectClass *) klass;

  gobject_class->finalize = gst_selector_pad_finalize;

  gobject_class->get_property = gst_selector_pad_get_property;
  gobject_class->set_property = gst_selector_pad_set_property;

  g_object_class_install_property (gobject_class, PROP_PAD_RUNNING_TIME,
      g_param_spec_int64 ("running-time", "Running time",
          "Running time of stream on pad", 0, G_MAXINT64, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PAD_TAGS,
      g_param_spec_boxed ("tags", "Tags",
          "The currently active tags on the pad", GST_TYPE_TAG_LIST,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_PAD_ACTIVE,
      g_param_spec_boolean ("active", "Active",
          "If the pad is currently active", FALSE,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  /* FIXME: better property name? */
  g_object_class_install_property (gobject_class, PROP_PAD_ALWAYS_OK,
      g_param_spec_boolean ("always-ok", "Always OK",
          "Make an inactive pad return OK instead of NOT_LINKED",
          DEFAULT_PAD_ALWAYS_OK, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
}

static void
gst_selector_pad_init (GstSelectorPad * pad)
{
  pad->always_ok = DEFAULT_PAD_ALWAYS_OK;
  gst_selector_pad_reset (pad);
}

static void
gst_selector_pad_finalize (GObject * object)
{
  GstSelectorPad *pad;

  pad = GST_SELECTOR_PAD_CAST (object);

  if (pad->tags)
    gst_tag_list_unref (pad->tags);
  gst_selector_pad_free_cached_buffers (pad);

  G_OBJECT_CLASS (gst_selector_pad_parent_class)->finalize (object);
}

static void
gst_selector_pad_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstSelectorPad *spad = GST_SELECTOR_PAD_CAST (object);

  switch (prop_id) {
    case PROP_PAD_ALWAYS_OK:
      GST_OBJECT_LOCK (object);
      spad->always_ok = g_value_get_boolean (value);
      GST_OBJECT_UNLOCK (object);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_selector_pad_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstSelectorPad *spad = GST_SELECTOR_PAD_CAST (object);

  switch (prop_id) {
    case PROP_PAD_RUNNING_TIME:
      g_value_set_int64 (value, gst_selector_pad_get_running_time (spad));
      break;
    case PROP_PAD_TAGS:
      GST_OBJECT_LOCK (object);
      g_value_set_boxed (value, spad->tags);
      GST_OBJECT_UNLOCK (object);
      break;
    case PROP_PAD_ACTIVE:
    {
      GstInputSelector *sel;

      sel = GST_INPUT_SELECTOR (gst_pad_get_parent (spad));
      if (sel) {
        g_value_set_boolean (value, gst_input_selector_is_active_sinkpad (sel,
                GST_PAD_CAST (spad)));
        gst_object_unref (sel);
      } else {
        g_value_set_boolean (value, FALSE);
      }
      break;
    }
    case PROP_PAD_ALWAYS_OK:
      GST_OBJECT_LOCK (object);
      g_value_set_boolean (value, spad->always_ok);
      GST_OBJECT_UNLOCK (object);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gint64
gst_selector_pad_get_running_time (GstSelectorPad * pad)
{
  gint64 ret = 0;

  GST_OBJECT_LOCK (pad);
  if (pad->active) {
    GstFormat format = pad->segment.format;

    ret =
        gst_segment_to_running_time (&pad->segment, format,
        pad->segment.position);
  }
  GST_OBJECT_UNLOCK (pad);

  GST_DEBUG_OBJECT (pad, "running time: %" GST_TIME_FORMAT
      " segment: %" GST_SEGMENT_FORMAT, GST_TIME_ARGS (ret), &pad->segment);

  return ret;
}

/* must be called with the SELECTOR_LOCK */
static void
gst_selector_pad_reset (GstSelectorPad * pad)
{
  GST_OBJECT_LOCK (pad);
  pad->active = FALSE;
  pad->pushed = FALSE;
  pad->eos = FALSE;
  pad->eos_sent = FALSE;
  pad->events_pending = FALSE;
  pad->discont = FALSE;
  pad->flushing = FALSE;
  gst_segment_init (&pad->segment, GST_FORMAT_UNDEFINED);
  pad->sending_cached_buffers = FALSE;
  gst_selector_pad_free_cached_buffers (pad);
  GST_OBJECT_UNLOCK (pad);
}

static GstSelectorPadCachedBuffer *
gst_selector_pad_new_cached_buffer (GstSelectorPad * selpad, GstBuffer * buffer)
{
  GstSelectorPadCachedBuffer *cached_buffer =
      g_slice_new (GstSelectorPadCachedBuffer);
  cached_buffer->buffer = buffer;
  cached_buffer->segment = selpad->segment;
  return cached_buffer;
}

static void
gst_selector_pad_free_cached_buffer (GstSelectorPadCachedBuffer * cached_buffer)
{
  gst_buffer_unref (cached_buffer->buffer);
  g_slice_free (GstSelectorPadCachedBuffer, cached_buffer);
}

/* must be called with the SELECTOR_LOCK */
static void
gst_selector_pad_cache_buffer (GstSelectorPad * selpad, GstBuffer * buffer)
{
  if (selpad->segment.format != GST_FORMAT_TIME) {
    GST_DEBUG_OBJECT (selpad, "Buffer %p with segment not in time format, "
        "not caching", buffer);
    return;
  }

  GST_DEBUG_OBJECT (selpad, "Caching buffer %p", buffer);
  if (!selpad->cached_buffers)
    selpad->cached_buffers = g_queue_new ();
  g_queue_push_tail (selpad->cached_buffers,
      gst_selector_pad_new_cached_buffer (selpad, buffer));
}

/* must be called with the SELECTOR_LOCK */
static void
gst_selector_pad_free_cached_buffers (GstSelectorPad * selpad)
{
  GstSelectorPadCachedBuffer *cached_buffer;

  if (!selpad->cached_buffers)
    return;

  GST_DEBUG_OBJECT (selpad, "Freeing cached buffers");
  while ((cached_buffer = g_queue_pop_head (selpad->cached_buffers)))
    gst_selector_pad_free_cached_buffer (cached_buffer);
  g_queue_free (selpad->cached_buffers);
  selpad->cached_buffers = NULL;
}

/* strictly get the linked pad from the sinkpad. If the pad is active we return
 * the srcpad else we return NULL */
static GstIterator *
gst_selector_pad_iterate_linked_pads (GstPad * pad, GstObject * parent)
{
  GstInputSelector *sel;
  GstPad *otherpad;
  GstIterator *it = NULL;
  GValue val = { 0, };

  sel = GST_INPUT_SELECTOR (parent);

  otherpad = gst_input_selector_get_linked_pad (sel, pad, TRUE);
  if (otherpad) {
    g_value_init (&val, GST_TYPE_PAD);
    g_value_set_object (&val, otherpad);
    it = gst_iterator_new_single (GST_TYPE_PAD, &val);
    g_value_unset (&val);
    gst_object_unref (otherpad);
  }

  return it;
}

static gboolean
gst_selector_pad_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res = TRUE;
  gboolean forward;
  gboolean new_tags = FALSE;
  GstInputSelector *sel;
  GstSelectorPad *selpad;
  GstPad *prev_active_sinkpad;
  GstPad *active_sinkpad;

  sel = GST_INPUT_SELECTOR (parent);
  selpad = GST_SELECTOR_PAD_CAST (pad);
  GST_DEBUG_OBJECT (selpad, "received event %" GST_PTR_FORMAT, event);

  GST_INPUT_SELECTOR_LOCK (sel);
  prev_active_sinkpad =
      sel->active_sinkpad ? gst_object_ref (sel->active_sinkpad) : NULL;
  active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);
  GST_INPUT_SELECTOR_UNLOCK (sel);

  if (prev_active_sinkpad != active_sinkpad) {
    if (prev_active_sinkpad)
      g_object_notify (G_OBJECT (prev_active_sinkpad), "active");
    g_object_notify (G_OBJECT (active_sinkpad), "active");
    g_object_notify (G_OBJECT (sel), "active-pad");
  }
  if (prev_active_sinkpad)
    gst_object_unref (prev_active_sinkpad);

  GST_INPUT_SELECTOR_LOCK (sel);
  active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);

  /* only forward if we are dealing with the active sinkpad */
  forward = (pad == active_sinkpad);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_STREAM_START:{
      guint group_id;

      if (!gst_event_parse_group_id (event, &group_id))
        sel->have_group_id = FALSE;
      break;
    }
    case GST_EVENT_FLUSH_START:
      /* Unblock the pad if it's waiting */
      selpad->flushing = TRUE;
      GST_INPUT_SELECTOR_BROADCAST (sel);
      break;
    case GST_EVENT_FLUSH_STOP:
      gst_selector_pad_reset (selpad);
      break;
    case GST_EVENT_SEGMENT:
    {
      gst_event_copy_segment (event, &selpad->segment);
      selpad->segment_seqnum = gst_event_get_seqnum (event);

      GST_DEBUG_OBJECT (pad, "configured SEGMENT %" GST_SEGMENT_FORMAT,
          &selpad->segment);
      break;
    }
    case GST_EVENT_TAG:
    {
      GstTagList *tags, *oldtags, *newtags;

      gst_event_parse_tag (event, &tags);

      GST_OBJECT_LOCK (selpad);
      oldtags = selpad->tags;

      newtags = gst_tag_list_merge (oldtags, tags, GST_TAG_MERGE_REPLACE);
      selpad->tags = newtags;
      GST_OBJECT_UNLOCK (selpad);

      if (oldtags)
        gst_tag_list_unref (oldtags);
      GST_DEBUG_OBJECT (pad, "received tags %" GST_PTR_FORMAT, newtags);

      new_tags = TRUE;
      break;
    }
    case GST_EVENT_EOS:
      selpad->eos = TRUE;

      if (forward) {
        selpad->eos_sent = TRUE;
      } else {
        GstSelectorPad *active_selpad;

        /* If the active sinkpad is in EOS state but EOS
         * was not sent downstream this means that the pad
         * got EOS before it was set as active pad and that
         * the previously active pad got EOS after it was
         * active
         */
        active_selpad = GST_SELECTOR_PAD (active_sinkpad);
        forward = (active_selpad->eos && !active_selpad->eos_sent);
        active_selpad->eos_sent = TRUE;
      }
      GST_DEBUG_OBJECT (pad, "received EOS");
      break;
    case GST_EVENT_GAP:{
      GstClockTime ts, dur;

      GST_DEBUG_OBJECT (pad, "Received gap event: %" GST_PTR_FORMAT, event);

      gst_event_parse_gap (event, &ts, &dur);
      if (GST_CLOCK_TIME_IS_VALID (ts)) {
        if (GST_CLOCK_TIME_IS_VALID (dur))
          ts += dur;

        /* update the segment position */
        GST_OBJECT_LOCK (pad);
        selpad->segment.position = ts;
        GST_OBJECT_UNLOCK (pad);
        if (sel->sync_streams && active_sinkpad == pad)
          GST_INPUT_SELECTOR_BROADCAST (sel);
      }

    }
      break;
    default:
      break;
  }
  GST_INPUT_SELECTOR_UNLOCK (sel);
  if (new_tags)
    g_object_notify (G_OBJECT (selpad), "tags");
  if (forward) {
    GST_DEBUG_OBJECT (pad, "forwarding event");
    res = gst_pad_push_event (sel->srcpad, event);
  } else {
    /* If we aren't forwarding the event because the pad is not the
     * active_sinkpad, then set the flag on the pad
     * that says a segment needs sending if/when that pad is activated.
     * For all other cases, we send the event immediately, which makes
     * sparse streams and other segment updates work correctly downstream.
     */
    if (GST_EVENT_IS_STICKY (event))
      selpad->events_pending = TRUE;
    gst_event_unref (event);
  }

  return res;
}

static gboolean
gst_selector_pad_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  gboolean res = FALSE;
  GstInputSelector *self = (GstInputSelector *) parent;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_CAPS:
      /* always proxy caps query, regardless of active pad or not */
      res = gst_pad_peer_query (self->srcpad, query);
      break;
    case GST_QUERY_ALLOCATION:{
      GstPad *active_sinkpad;
      GstInputSelector *sel = GST_INPUT_SELECTOR (parent);

      /* Only do the allocation query for the active sinkpad,
       * after switching a reconfigure event is sent and upstream
       * should reconfigure and do a new allocation query
       */
      if (GST_PAD_DIRECTION (pad) == GST_PAD_SINK) {
        GST_INPUT_SELECTOR_LOCK (sel);
        active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);
        GST_INPUT_SELECTOR_UNLOCK (sel);

        if (pad != active_sinkpad) {
          res = FALSE;
          goto done;
        }
      }
    }
      /* fall through */
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }

done:
  return res;
}

/* must be called with the SELECTOR_LOCK, will block while the pad is blocked 
 * or return TRUE when flushing */
static gboolean
gst_input_selector_wait (GstInputSelector * self, GstSelectorPad * pad)
{
  while (self->blocked && !self->flushing && !pad->flushing) {
    /* we can be unlocked here when we are shutting down (flushing) or when we
     * get unblocked */
    GST_INPUT_SELECTOR_WAIT (self);
  }
  return self->flushing;
}

/* must be called without the SELECTOR_LOCK, will wait until the running time
 * of the active pad is after this pad or return TRUE when flushing */
static gboolean
gst_input_selector_wait_running_time (GstInputSelector * sel,
    GstSelectorPad * selpad, GstBuffer * buf)
{
  GstSegment *seg;

  GST_DEBUG_OBJECT (selpad, "entering wait for buffer %p", buf);

  /* If we have no valid timestamp we can't sync this buffer */
  if (!GST_BUFFER_TIMESTAMP_IS_VALID (buf)) {
    GST_DEBUG_OBJECT (selpad, "leaving wait for buffer with "
        "invalid timestamp");
    return FALSE;
  }

  seg = &selpad->segment;

  /* Wait until
   *   a) this is the active pad
   *   b) the pad or the selector is flushing
   *   c) the selector is not blocked
   *   d) the buffer running time is before the current running time
   *      (either active-seg or clock, depending on sync-mode)
   */

  GST_INPUT_SELECTOR_LOCK (sel);
  while (TRUE) {
    GstPad *active_sinkpad;
    GstSelectorPad *active_selpad;
    GstClock *clock;
    gint64 cur_running_time;
    GstClockTime running_time;

    active_sinkpad =
        gst_input_selector_activate_sinkpad (sel, GST_PAD_CAST (selpad));
    active_selpad = GST_SELECTOR_PAD_CAST (active_sinkpad);

    if (seg->format != GST_FORMAT_TIME) {
      GST_DEBUG_OBJECT (selpad,
          "Not waiting because we don't have a TIME segment");
      GST_INPUT_SELECTOR_UNLOCK (sel);
      return FALSE;
    }

    running_time = GST_BUFFER_TIMESTAMP (buf);
    /* If possible try to get the running time at the end of the buffer */
    if (GST_BUFFER_DURATION_IS_VALID (buf))
      running_time += GST_BUFFER_DURATION (buf);
    /* Only use the segment to convert to running time if the segment is
     * in TIME format, otherwise do our best to try to sync */
    if (GST_CLOCK_TIME_IS_VALID (seg->stop)) {
      if (running_time > seg->stop) {
        running_time = seg->stop;
      }
    }
    running_time =
        gst_segment_to_running_time (seg, GST_FORMAT_TIME, running_time);
    /* If this is outside the segment don't sync */
    if (running_time == -1) {
      GST_DEBUG_OBJECT (selpad,
          "Not waiting because buffer is outside segment");
      GST_INPUT_SELECTOR_UNLOCK (sel);
      return FALSE;
    }

    cur_running_time = GST_CLOCK_TIME_NONE;
    if (sel->sync_mode == GST_INPUT_SELECTOR_SYNC_MODE_CLOCK) {
      clock = gst_element_get_clock (GST_ELEMENT_CAST (sel));
      if (clock) {
        GstClockTime base_time;

        cur_running_time = gst_clock_get_time (clock);
        base_time = gst_element_get_base_time (GST_ELEMENT_CAST (sel));
        if (base_time <= cur_running_time)
          cur_running_time -= base_time;
        else
          cur_running_time = 0;

        gst_object_unref (clock);
      }
    } else {
      GstSegment *active_seg;

      active_seg = &active_selpad->segment;

      /* If the active segment is configured but not to time format
       * we can't do any syncing at all */
      if (active_seg->format != GST_FORMAT_TIME
          && active_seg->format != GST_FORMAT_UNDEFINED) {
        GST_DEBUG_OBJECT (selpad,
            "Not waiting because active segment isn't in TIME format");
        GST_INPUT_SELECTOR_UNLOCK (sel);
        return FALSE;
      }

      /* Get active pad's running time, if no configured segment yet keep at -1 */
      if (active_seg->format == GST_FORMAT_TIME)
        cur_running_time = gst_segment_to_running_time (active_seg,
            GST_FORMAT_TIME, active_seg->position);
    }

    if (selpad != active_selpad && !sel->flushing && !selpad->flushing &&
        (sel->blocked || cur_running_time == -1
            || running_time >= cur_running_time)) {
      if (!sel->blocked) {
        GST_DEBUG_OBJECT (selpad,
            "Waiting for active streams to advance. %" GST_TIME_FORMAT " >= %"
            GST_TIME_FORMAT, GST_TIME_ARGS (running_time),
            GST_TIME_ARGS (cur_running_time));
      } else
        GST_DEBUG_OBJECT (selpad, "Waiting for selector to unblock");

      GST_INPUT_SELECTOR_WAIT (sel);
    } else {
      GST_INPUT_SELECTOR_UNLOCK (sel);
      break;
    }
  }

  /* Return TRUE if the selector or the pad is flushing */
  return (sel->flushing || selpad->flushing);
}

static gboolean
forward_sticky_events (GstPad * sinkpad, GstEvent ** event, gpointer user_data)
{
  GstInputSelector *sel = GST_INPUT_SELECTOR (user_data);

  if (GST_EVENT_TYPE (*event) == GST_EVENT_SEGMENT) {
    GstSegment *seg = &GST_SELECTOR_PAD (sinkpad)->segment;
    GstEvent *e;

    e = gst_event_new_segment (seg);
    gst_event_set_seqnum (e, GST_SELECTOR_PAD_CAST (sinkpad)->segment_seqnum);

    gst_pad_push_event (sel->srcpad, e);
  } else if (GST_EVENT_TYPE (*event) == GST_EVENT_STREAM_START
      && !sel->have_group_id) {
    GstEvent *tmp =
        gst_pad_get_sticky_event (sel->srcpad, GST_EVENT_STREAM_START, 0);

    /* Only push stream-start once if not all our streams have a stream-id */
    if (!tmp) {
      gst_pad_push_event (sel->srcpad, gst_event_ref (*event));
    } else {
      gst_event_unref (tmp);
    }
  } else {
    gst_pad_push_event (sel->srcpad, gst_event_ref (*event));
  }

  return TRUE;
}

#if DEBUG_CACHED_BUFFERS
static void
gst_input_selector_debug_cached_buffers (GstInputSelector * sel)
{
  GList *walk;

  for (walk = GST_ELEMENT_CAST (sel)->sinkpads; walk; walk = g_list_next (walk)) {
    GstSelectorPad *selpad;
    GString *timestamps;
    gchar *str;
    int i;

    selpad = GST_SELECTOR_PAD_CAST (walk->data);
    if (!selpad->cached_buffers) {
      GST_DEBUG_OBJECT (selpad, "Cached buffers timestamps: <none>");
      continue;
    }

    timestamps = g_string_new ("Cached buffers timestamps:");
    for (i = 0; i < selpad->cached_buffers->length; ++i) {
      GstSelectorPadCachedBuffer *cached_buffer;

      cached_buffer = g_queue_peek_nth (selpad->cached_buffers, i);
      g_string_append_printf (timestamps, " %" GST_TIME_FORMAT,
          GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (cached_buffer->buffer)));
    }
    str = g_string_free (timestamps, FALSE);
    GST_DEBUG_OBJECT (selpad, "%s", str);
    g_free (str);
  }
}
#endif

/* must be called with the SELECTOR_LOCK */
static void
gst_input_selector_cleanup_old_cached_buffers (GstInputSelector * sel,
    GstPad * pad)
{
  GstClock *clock;
  gint64 cur_running_time;
  GList *walk;

  cur_running_time = GST_CLOCK_TIME_NONE;
  if (sel->sync_mode == GST_INPUT_SELECTOR_SYNC_MODE_CLOCK) {
    clock = gst_element_get_clock (GST_ELEMENT_CAST (sel));
    if (clock) {
      GstClockTime base_time;

      cur_running_time = gst_clock_get_time (clock);
      base_time = gst_element_get_base_time (GST_ELEMENT_CAST (sel));
      if (base_time <= cur_running_time)
        cur_running_time -= base_time;
      else
        cur_running_time = 0;

      gst_object_unref (clock);
    }
  } else {
    GstPad *active_sinkpad;
    GstSelectorPad *active_selpad;
    GstSegment *active_seg;

    active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);
    active_selpad = GST_SELECTOR_PAD_CAST (active_sinkpad);
    active_seg = &active_selpad->segment;

    /* Get active pad's running time, if no configured segment yet keep at -1 */
    if (active_seg->format == GST_FORMAT_TIME)
      cur_running_time = gst_segment_to_running_time (active_seg,
          GST_FORMAT_TIME, active_seg->position);
  }

  if (!GST_CLOCK_TIME_IS_VALID (cur_running_time))
    return;

  GST_DEBUG_OBJECT (sel, "Cleaning up old cached buffers");
  for (walk = GST_ELEMENT_CAST (sel)->sinkpads; walk; walk = g_list_next (walk)) {
    GstSelectorPad *selpad;
    GstSegment *seg;
    GstSelectorPadCachedBuffer *cached_buffer;
    GSList *maybe_remove;
    guint queue_position;

    selpad = GST_SELECTOR_PAD_CAST (walk->data);
    if (!selpad->cached_buffers)
      continue;

    seg = &selpad->segment;

    maybe_remove = NULL;
    queue_position = 0;
    while ((cached_buffer = g_queue_peek_nth (selpad->cached_buffers,
                queue_position))) {
      GstBuffer *buffer = cached_buffer->buffer;
      GstClockTime running_time;
      GSList *l;

      /* If we have no valid timestamp we can't sync this buffer */
      if (!GST_BUFFER_TIMESTAMP_IS_VALID (buffer)) {
        maybe_remove = g_slist_append (maybe_remove, cached_buffer);
        queue_position = g_slist_length (maybe_remove);
        continue;
      }

      /* the buffer is still valid if its duration is valid and the
       * timestamp + duration is >= time, or if its duration is invalid
       * and the timestamp is >= time */
      running_time = GST_BUFFER_TIMESTAMP (buffer);
      /* If possible try to get the running time at the end of the buffer */
      if (GST_BUFFER_DURATION_IS_VALID (buffer))
        running_time += GST_BUFFER_DURATION (buffer);
      /* Only use the segment to convert to running time if the segment is
       * in TIME format, otherwise do our best to try to sync */
      if (GST_CLOCK_TIME_IS_VALID (seg->stop)) {
        if (running_time > seg->stop) {
          running_time = seg->stop;
        }
      }
      running_time =
          gst_segment_to_running_time (seg, GST_FORMAT_TIME, running_time);

      GST_DEBUG_OBJECT (selpad,
          "checking if buffer %p running time=%" GST_TIME_FORMAT
          " >= stream time=%" GST_TIME_FORMAT, buffer,
          GST_TIME_ARGS (running_time), GST_TIME_ARGS (cur_running_time));
      if (running_time >= cur_running_time) {
        break;
      }

      GST_DEBUG_OBJECT (selpad, "Removing old cached buffer %p", buffer);
      g_queue_pop_nth (selpad->cached_buffers, queue_position);
      gst_selector_pad_free_cached_buffer (cached_buffer);

      for (l = maybe_remove; l != NULL; l = g_slist_next (l)) {
        /* A buffer after some invalid buffers was removed, it means the invalid buffers
         * are old, lets also remove them */
        cached_buffer = l->data;
        g_queue_remove (selpad->cached_buffers, cached_buffer);
        gst_selector_pad_free_cached_buffer (cached_buffer);
      }

      g_slist_free (maybe_remove);
      maybe_remove = NULL;
      queue_position = 0;
    }

    g_slist_free (maybe_remove);
    maybe_remove = NULL;

    if (g_queue_is_empty (selpad->cached_buffers)) {
      g_queue_free (selpad->cached_buffers);
      selpad->cached_buffers = NULL;
    }
  }

#if DEBUG_CACHED_BUFFERS
  gst_input_selector_debug_cached_buffers (sel);
#endif
}

static GstFlowReturn
gst_selector_pad_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstInputSelector *sel;
  GstFlowReturn res;
  GstPad *active_sinkpad;
  GstPad *prev_active_sinkpad = NULL;
  GstSelectorPad *selpad;
  GstClockTime start_time;

  sel = GST_INPUT_SELECTOR (parent);
  selpad = GST_SELECTOR_PAD_CAST (pad);

  GST_DEBUG_OBJECT (selpad,
      "entering chain for buf %p with timestamp %" GST_TIME_FORMAT, buf,
      GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buf)));

  GST_INPUT_SELECTOR_LOCK (sel);
  /* wait or check for flushing */
  if (gst_input_selector_wait (sel, selpad)) {
    GST_INPUT_SELECTOR_UNLOCK (sel);
    goto flushing;
  }

  GST_LOG_OBJECT (pad, "getting active pad");

  prev_active_sinkpad =
      sel->active_sinkpad ? gst_object_ref (sel->active_sinkpad) : NULL;
  active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);

  /* In sync mode wait until the active pad has advanced
   * after the running time of the current buffer */
  if (sel->sync_streams) {
    /* call chain for each cached buffer if we are not the active pad
     * or if we are the active pad but didn't push anything yet. */
    if (active_sinkpad != pad || !selpad->pushed) {
      /* no need to check for sel->cache_buffers as selpad->cached_buffers
       * will only be valid if cache_buffers is TRUE */
      if (selpad->cached_buffers && !selpad->sending_cached_buffers) {
        GstSelectorPadCachedBuffer *cached_buffer;
        GstSegment saved_segment;

        saved_segment = selpad->segment;

        selpad->sending_cached_buffers = TRUE;
        while (!sel->flushing && !selpad->flushing &&
            (cached_buffer = g_queue_pop_head (selpad->cached_buffers))) {
          GST_DEBUG_OBJECT (pad, "Cached buffers found, "
              "invoking chain for cached buffer %p", cached_buffer->buffer);

          selpad->segment = cached_buffer->segment;
          selpad->events_pending = TRUE;
          GST_INPUT_SELECTOR_UNLOCK (sel);
          gst_selector_pad_chain (pad, parent, cached_buffer->buffer);
          GST_INPUT_SELECTOR_LOCK (sel);

          /* we may have cleaned up the queue in the meantime because of
           * old buffers */
          if (!selpad->cached_buffers) {
            break;
          }
        }
        selpad->sending_cached_buffers = FALSE;

        /* all cached buffers sent, restore segment for current buffer */
        selpad->segment = saved_segment;
        selpad->events_pending = TRUE;

        /* Might have changed while calling chain for cached buffers */
        active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);
      }
    }

    if (active_sinkpad != pad) {
      GST_INPUT_SELECTOR_UNLOCK (sel);
      if (gst_input_selector_wait_running_time (sel, selpad, buf))
        goto flushing;
      GST_INPUT_SELECTOR_LOCK (sel);
    }

    /* Might have changed while waiting */
    active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);
  }

  /* update the segment on the srcpad */
  start_time = GST_BUFFER_TIMESTAMP (buf);
  if (GST_CLOCK_TIME_IS_VALID (start_time)) {
    GST_LOG_OBJECT (pad, "received start time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (start_time));
    if (GST_BUFFER_DURATION_IS_VALID (buf))
      GST_LOG_OBJECT (pad, "received end time %" GST_TIME_FORMAT,
          GST_TIME_ARGS (start_time + GST_BUFFER_DURATION (buf)));

    GST_OBJECT_LOCK (pad);
    selpad->segment.position = start_time;
    GST_OBJECT_UNLOCK (pad);
  }

  /* Ignore buffers from pads except the selected one */
  if (pad != active_sinkpad)
    goto ignore;

  /* Tell all non-active pads that we advanced the running time */
  if (sel->sync_streams)
    GST_INPUT_SELECTOR_BROADCAST (sel);

  GST_INPUT_SELECTOR_UNLOCK (sel);

  if (prev_active_sinkpad != active_sinkpad) {
    if (prev_active_sinkpad)
      g_object_notify (G_OBJECT (prev_active_sinkpad), "active");
    g_object_notify (G_OBJECT (active_sinkpad), "active");
    g_object_notify (G_OBJECT (sel), "active-pad");
  }

  /* if we have a pending events, push them now */
  if (G_UNLIKELY (prev_active_sinkpad != active_sinkpad
          || selpad->events_pending)) {
    gst_pad_sticky_events_foreach (GST_PAD_CAST (selpad), forward_sticky_events,
        sel);
    selpad->events_pending = FALSE;
  }

  if (prev_active_sinkpad)
    gst_object_unref (prev_active_sinkpad);
  prev_active_sinkpad = NULL;

  if (selpad->discont) {
    buf = gst_buffer_make_writable (buf);

    GST_DEBUG_OBJECT (pad, "Marking discont buffer %p", buf);
    GST_BUFFER_FLAG_SET (buf, GST_BUFFER_FLAG_DISCONT);
    selpad->discont = FALSE;
  }

  /* forward */
  GST_LOG_OBJECT (pad, "Forwarding buffer %p with timestamp %" GST_TIME_FORMAT,
      buf, GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buf)));

  /* Only make the buffer read-only when necessary */
  if (sel->sync_streams && sel->cache_buffers)
    buf = gst_buffer_ref (buf);
  res = gst_pad_push (sel->srcpad, buf);
  GST_LOG_OBJECT (pad, "Buffer %p forwarded result=%d", buf, res);

  GST_INPUT_SELECTOR_LOCK (sel);

  if (sel->sync_streams && sel->cache_buffers) {
    /* Might have changed while pushing */
    active_sinkpad = gst_input_selector_activate_sinkpad (sel, pad);
    /* only set pad to pushed if we are still the active pad */
    if (active_sinkpad == pad)
      selpad->pushed = TRUE;

    /* cache buffer as we may need it again if we change pads */
    gst_selector_pad_cache_buffer (selpad, buf);
    gst_input_selector_cleanup_old_cached_buffers (sel, pad);
  } else {
    selpad->pushed = TRUE;
  }
  GST_INPUT_SELECTOR_UNLOCK (sel);

done:

  if (prev_active_sinkpad)
    gst_object_unref (prev_active_sinkpad);
  prev_active_sinkpad = NULL;

  return res;

  /* dropped buffers */
ignore:
  {
    gboolean active_pad_pushed = GST_SELECTOR_PAD_CAST (active_sinkpad)->pushed;

    GST_DEBUG_OBJECT (pad, "Pad not active, discard buffer %p", buf);
    /* when we drop a buffer, we're creating a discont on this pad */
    selpad->discont = TRUE;
    GST_INPUT_SELECTOR_UNLOCK (sel);
    gst_buffer_unref (buf);

    /* figure out what to return upstream */
    GST_OBJECT_LOCK (selpad);
    if (selpad->always_ok || !active_pad_pushed)
      res = GST_FLOW_OK;
    else
      res = GST_FLOW_NOT_LINKED;
    GST_OBJECT_UNLOCK (selpad);

    goto done;
  }
flushing:
  {
    GST_DEBUG_OBJECT (pad, "We are flushing, discard buffer %p", buf);
    gst_buffer_unref (buf);
    res = GST_FLOW_FLUSHING;
    goto done;
  }
}

static void gst_input_selector_dispose (GObject * object);
static void gst_input_selector_finalize (GObject * object);

static void gst_input_selector_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_input_selector_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstPad *gst_input_selector_request_new_pad (GstElement * element,
    GstPadTemplate * templ, const gchar * unused, const GstCaps * caps);
static void gst_input_selector_release_pad (GstElement * element, GstPad * pad);

static GstStateChangeReturn gst_input_selector_change_state (GstElement *
    element, GstStateChange transition);

static gboolean gst_input_selector_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_input_selector_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gint64 gst_input_selector_block (GstInputSelector * self);

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (input_selector_debug, \
        "input-selector", 0, "An input stream selector element");
#define gst_input_selector_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstInputSelector, gst_input_selector, GST_TYPE_ELEMENT,
    _do_init);

static void
gst_input_selector_class_init (GstInputSelectorClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);

  gobject_class->dispose = gst_input_selector_dispose;
  gobject_class->finalize = gst_input_selector_finalize;

  gobject_class->set_property = gst_input_selector_set_property;
  gobject_class->get_property = gst_input_selector_get_property;

  g_object_class_install_property (gobject_class, PROP_N_PADS,
      g_param_spec_uint ("n-pads", "Number of Pads",
          "The number of sink pads", 0, G_MAXUINT, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_ACTIVE_PAD,
      g_param_spec_object ("active-pad", "Active pad",
          "The currently active sink pad", GST_TYPE_PAD,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstInputSelector:sync-streams
   *
   * If set to %TRUE all inactive streams will be synced to the
   * running time of the active stream or to the current clock.
   *
   * To make sure no buffers are dropped by input-selector
   * that might be needed when switching the active pad,
   * sync-mode should be set to "clock" and cache-buffers to TRUE.
   */
  g_object_class_install_property (gobject_class, PROP_SYNC_STREAMS,
      g_param_spec_boolean ("sync-streams", "Sync Streams",
          "Synchronize inactive streams to the running time of the active "
          "stream or to the current clock",
          DEFAULT_SYNC_STREAMS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS |
          GST_PARAM_MUTABLE_READY));

  /**
   * GstInputSelector:sync-mode
   *
   * Select how input-selector will sync buffers when in sync-streams mode.
   *
   * Note that when using the "active-segment" mode, the "active-segment" may
   * be ahead of current clock time when switching the active pad, as the current
   * active pad may have pushed more buffers than what was displayed/consumed,
   * which may cause delays and some missing buffers.
   */
  g_object_class_install_property (gobject_class, PROP_SYNC_MODE,
      g_param_spec_enum ("sync-mode", "Sync mode",
          "Behavior in sync-streams mode", GST_TYPE_INPUT_SELECTOR_SYNC_MODE,
          DEFAULT_SYNC_MODE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS |
          GST_PARAM_MUTABLE_READY));

  /**
   * GstInputSelector:cache-buffers
   *
   * If set to %TRUE and GstInputSelector:sync-streams is also set to %TRUE,
   * the active pad will cache the buffers still considered valid (after current
   * running time, see sync-mode) to avoid missing frames if/when the pad is
   * reactivated.
   *
   * The active pad may push more buffers than what is currently displayed/consumed
   * and when changing pads those buffers will be discarded and the only way to
   * reactivate that pad without loosing the already consumed buffers is to enable cache.
   */
  g_object_class_install_property (gobject_class, PROP_CACHE_BUFFERS,
      g_param_spec_boolean ("cache-buffers", "Cache Buffers",
          "Cache buffers for active-pad",
          DEFAULT_CACHE_BUFFERS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS |
          GST_PARAM_MUTABLE_READY));

  /**
   * GstInputSelector::block:
   * @inputselector: the #GstInputSelector
   *
   * Block all sink pads in preparation for a switch. Returns the stop time of
   * the current switch segment, as a running time, or 0 if there is no current
   * active pad or the current active pad never received data.
   */
  gst_input_selector_signals[SIGNAL_BLOCK] =
      g_signal_new ("block", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
      G_STRUCT_OFFSET (GstInputSelectorClass, block), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_INT64, 0);

  gst_element_class_set_static_metadata (gstelement_class, "Input selector",
      "Generic", "N-to-1 input stream selector",
      "Julien Moutte <julien@moutte.net>, "
      "Jan Schmidt <thaytan@mad.scientist.com>, "
      "Wim Taymans <wim.taymans@gmail.com>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&gst_input_selector_sink_factory));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&gst_input_selector_src_factory));

  gstelement_class->request_new_pad = gst_input_selector_request_new_pad;
  gstelement_class->release_pad = gst_input_selector_release_pad;
  gstelement_class->change_state = gst_input_selector_change_state;

  klass->block = GST_DEBUG_FUNCPTR (gst_input_selector_block);
}

static void
gst_input_selector_init (GstInputSelector * sel)
{
  sel->srcpad = gst_pad_new ("src", GST_PAD_SRC);
  gst_pad_set_iterate_internal_links_function (sel->srcpad,
      GST_DEBUG_FUNCPTR (gst_selector_pad_iterate_linked_pads));
  gst_pad_set_query_function (sel->srcpad,
      GST_DEBUG_FUNCPTR (gst_input_selector_query));
  gst_pad_set_event_function (sel->srcpad,
      GST_DEBUG_FUNCPTR (gst_input_selector_event));
  GST_OBJECT_FLAG_SET (sel->srcpad, GST_PAD_FLAG_PROXY_CAPS);
  gst_element_add_pad (GST_ELEMENT (sel), sel->srcpad);
  /* sinkpad management */
  sel->active_sinkpad = NULL;
  sel->padcount = 0;
  sel->sync_streams = DEFAULT_SYNC_STREAMS;
  sel->have_group_id = TRUE;

  g_mutex_init (&sel->lock);
  g_cond_init (&sel->cond);
  sel->blocked = FALSE;

  /* lets give a change for downstream to do something on
   * active-pad change before we start pushing new buffers */
  g_signal_connect_data (sel, "notify::active-pad",
      (GCallback) gst_input_selector_active_pad_changed, NULL,
      NULL, G_CONNECT_AFTER);
}

static void
gst_input_selector_dispose (GObject * object)
{
  GstInputSelector *sel = GST_INPUT_SELECTOR (object);

  if (sel->active_sinkpad) {
    gst_object_unref (sel->active_sinkpad);
    sel->active_sinkpad = NULL;
  }
  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_input_selector_finalize (GObject * object)
{
  GstInputSelector *sel = GST_INPUT_SELECTOR (object);

  g_mutex_clear (&sel->lock);
  g_cond_clear (&sel->cond);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/* this function must be called with the SELECTOR_LOCK. It returns TRUE when the
 * active pad changed. */
static gboolean
gst_input_selector_set_active_pad (GstInputSelector * self, GstPad * pad)
{
  GstSelectorPad *old, *new;
  GstPad **active_pad_p;

  if (pad == self->active_sinkpad)
    return FALSE;

  old = GST_SELECTOR_PAD_CAST (self->active_sinkpad);
  new = GST_SELECTOR_PAD_CAST (pad);

  GST_DEBUG_OBJECT (self, "setting active pad to %s:%s",
      GST_DEBUG_PAD_NAME (new));

  if (old)
    old->pushed = FALSE;
  if (new)
    new->pushed = FALSE;

  /* Send a new SEGMENT event on the new pad next */
  if (old != new && new)
    new->events_pending = TRUE;

  active_pad_p = &self->active_sinkpad;
  gst_object_replace ((GstObject **) active_pad_p, GST_OBJECT_CAST (pad));

  if (old && old != new)
    gst_pad_push_event (GST_PAD_CAST (old), gst_event_new_reconfigure ());
  if (new)
    gst_pad_push_event (GST_PAD_CAST (new), gst_event_new_reconfigure ());

  GST_DEBUG_OBJECT (self, "New active pad is %" GST_PTR_FORMAT,
      self->active_sinkpad);

  return TRUE;
}

static void
gst_input_selector_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstInputSelector *sel = GST_INPUT_SELECTOR (object);

  switch (prop_id) {
    case PROP_ACTIVE_PAD:
    {
      GstPad *pad;

      pad = g_value_get_object (value);

      GST_INPUT_SELECTOR_LOCK (sel);

#if DEBUG_CACHED_BUFFERS
      gst_input_selector_debug_cached_buffers (sel);
#endif

      gst_input_selector_set_active_pad (sel, pad);

#if DEBUG_CACHED_BUFFERS
      gst_input_selector_debug_cached_buffers (sel);
#endif

      GST_INPUT_SELECTOR_UNLOCK (sel);
      break;
    }
    case PROP_SYNC_STREAMS:
      GST_INPUT_SELECTOR_LOCK (sel);
      sel->sync_streams = g_value_get_boolean (value);
      GST_INPUT_SELECTOR_UNLOCK (sel);
      break;
    case PROP_SYNC_MODE:
      GST_INPUT_SELECTOR_LOCK (sel);
      sel->sync_mode = g_value_get_enum (value);
      GST_INPUT_SELECTOR_UNLOCK (sel);
      break;
    case PROP_CACHE_BUFFERS:
      GST_INPUT_SELECTOR_LOCK (object);
      sel->cache_buffers = g_value_get_boolean (value);
      GST_INPUT_SELECTOR_UNLOCK (object);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_input_selector_active_pad_changed (GstInputSelector * sel,
    GParamSpec * pspec, gpointer user_data)
{
  /* Wake up all non-active pads in sync mode, they might be
   * the active pad now */
  if (sel->sync_streams)
    GST_INPUT_SELECTOR_BROADCAST (sel);
}

static void
gst_input_selector_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstInputSelector *sel = GST_INPUT_SELECTOR (object);

  switch (prop_id) {
    case PROP_N_PADS:
      GST_INPUT_SELECTOR_LOCK (object);
      g_value_set_uint (value, sel->n_pads);
      GST_INPUT_SELECTOR_UNLOCK (object);
      break;
    case PROP_ACTIVE_PAD:
      GST_INPUT_SELECTOR_LOCK (object);
      g_value_set_object (value, sel->active_sinkpad);
      GST_INPUT_SELECTOR_UNLOCK (object);
      break;
    case PROP_SYNC_STREAMS:
      GST_INPUT_SELECTOR_LOCK (object);
      g_value_set_boolean (value, sel->sync_streams);
      GST_INPUT_SELECTOR_UNLOCK (object);
      break;
    case PROP_SYNC_MODE:
      GST_INPUT_SELECTOR_LOCK (object);
      g_value_set_enum (value, sel->sync_mode);
      GST_INPUT_SELECTOR_UNLOCK (object);
      break;
    case PROP_CACHE_BUFFERS:
      GST_INPUT_SELECTOR_LOCK (object);
      g_value_set_boolean (value, sel->cache_buffers);
      GST_INPUT_SELECTOR_UNLOCK (object);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstPad *
gst_input_selector_get_linked_pad (GstInputSelector * sel, GstPad * pad,
    gboolean strict)
{
  GstPad *otherpad = NULL;

  GST_INPUT_SELECTOR_LOCK (sel);
  if (pad == sel->srcpad)
    otherpad = sel->active_sinkpad;
  else if (pad == sel->active_sinkpad || !strict)
    otherpad = sel->srcpad;
  if (otherpad)
    gst_object_ref (otherpad);
  GST_INPUT_SELECTOR_UNLOCK (sel);

  return otherpad;
}

static gboolean
gst_input_selector_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstInputSelector *sel;
  gboolean result = FALSE;
  GstIterator *iter;
  gboolean done = FALSE;
  GValue item = { 0, };
  GstPad *eventpad;
  GList *pushed_pads = NULL;

  sel = GST_INPUT_SELECTOR (parent);
  /* Send upstream events to all sinkpads */
  iter = gst_element_iterate_sink_pads (GST_ELEMENT_CAST (sel));

  /* This is now essentially a copy of gst_pad_event_default_dispatch
   * with a different iterator */
  while (!done) {
    switch (gst_iterator_next (iter, &item)) {
      case GST_ITERATOR_OK:
        eventpad = g_value_get_object (&item);

        /* if already pushed,  skip */
        if (g_list_find (pushed_pads, eventpad)) {
          g_value_reset (&item);
          break;
        }

        gst_event_ref (event);
        result |= gst_pad_push_event (eventpad, event);

        g_value_reset (&item);
        break;
      case GST_ITERATOR_RESYNC:
        /* We don't reset the result here because we don't push the event
         * again on pads that got the event already and because we need
         * to consider the result of the previous pushes */
        gst_iterator_resync (iter);
        break;
      case GST_ITERATOR_ERROR:
        GST_ERROR_OBJECT (pad, "Could not iterate over sinkpads");
        done = TRUE;
        break;
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
    }
  }
  g_value_unset (&item);
  gst_iterator_free (iter);

  g_list_free (pushed_pads);

  gst_event_unref (event);

  return result;
}

/* query on the srcpad. We override this function because by default it will
 * only forward the query to one random sinkpad */
static gboolean
gst_input_selector_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  gboolean res = FALSE;
  GstInputSelector *sel;

  sel = GST_INPUT_SELECTOR (parent);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_LATENCY:
    {
      GList *walk;
      GstClockTime resmin, resmax;
      gboolean reslive;

      resmin = 0;
      resmax = -1;
      reslive = FALSE;

      /* perform the query on all sinkpads and combine the results. We take the
       * max of min and the min of max for the result latency. */
      GST_INPUT_SELECTOR_LOCK (sel);
      for (walk = GST_ELEMENT_CAST (sel)->sinkpads; walk;
          walk = g_list_next (walk)) {
        GstPad *sinkpad = GST_PAD_CAST (walk->data);

        if (gst_pad_peer_query (sinkpad, query)) {
          GstClockTime min, max;
          gboolean live;

          /* one query succeeded, we succeed too */
          res = TRUE;

          gst_query_parse_latency (query, &live, &min, &max);

          GST_DEBUG_OBJECT (sinkpad,
              "peer latency min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT
              ", live %d", GST_TIME_ARGS (min), GST_TIME_ARGS (max), live);

          if (live) {
            if (min > resmin)
              resmin = min;
            if (resmax == -1)
              resmax = max;
            else if (max < resmax)
              resmax = max;
            if (reslive == FALSE)
              reslive = live;
          }
        }
      }
      GST_INPUT_SELECTOR_UNLOCK (sel);
      if (res) {
        gst_query_set_latency (query, reslive, resmin, resmax);

        GST_DEBUG_OBJECT (sel,
            "total latency min %" GST_TIME_FORMAT ", max %" GST_TIME_FORMAT
            ", live %d", GST_TIME_ARGS (resmin), GST_TIME_ARGS (resmax),
            reslive);
      }

      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }

  return res;
}

/* check if the pad is the active sinkpad */
static inline gboolean
gst_input_selector_is_active_sinkpad (GstInputSelector * sel, GstPad * pad)
{
  gboolean res;

  GST_INPUT_SELECTOR_LOCK (sel);
  res = (pad == sel->active_sinkpad);
  GST_INPUT_SELECTOR_UNLOCK (sel);

  return res;
}

/* Get or create the active sinkpad, must be called with SELECTOR_LOCK */
static GstPad *
gst_input_selector_activate_sinkpad (GstInputSelector * sel, GstPad * pad)
{
  GstPad *active_sinkpad;
  GstSelectorPad *selpad;

  selpad = GST_SELECTOR_PAD_CAST (pad);

  selpad->active = TRUE;
  active_sinkpad = sel->active_sinkpad;
  if (sel->active_sinkpad == NULL) {
    GValue item = G_VALUE_INIT;
    GstIterator *iter = gst_element_iterate_sink_pads (GST_ELEMENT_CAST (sel));
    GstIteratorResult ires;

    while ((ires = gst_iterator_next (iter, &item)) == GST_ITERATOR_RESYNC)
      gst_iterator_resync (iter);
    if (ires == GST_ITERATOR_OK) {
      /* If no pad is currently selected, we return the first usable pad to
       * guarantee consistency */

      active_sinkpad = sel->active_sinkpad = g_value_dup_object (&item);
      g_value_reset (&item);
      GST_DEBUG_OBJECT (sel, "Activating pad %s:%s",
          GST_DEBUG_PAD_NAME (active_sinkpad));
    } else
      GST_WARNING_OBJECT (sel, "Couldn't find a default sink pad");
    gst_iterator_free (iter);
  }

  return active_sinkpad;
}

static GstPad *
gst_input_selector_request_new_pad (GstElement * element,
    GstPadTemplate * templ, const gchar * unused, const GstCaps * caps)
{
  GstInputSelector *sel;
  gchar *name = NULL;
  GstPad *sinkpad = NULL;

  g_return_val_if_fail (templ->direction == GST_PAD_SINK, NULL);

  sel = GST_INPUT_SELECTOR (element);

  GST_INPUT_SELECTOR_LOCK (sel);

  GST_LOG_OBJECT (sel, "Creating new pad %d", sel->padcount);
  name = g_strdup_printf ("sink_%u", sel->padcount++);
  sinkpad = g_object_new (GST_TYPE_SELECTOR_PAD,
      "name", name, "direction", templ->direction, "template", templ, NULL);
  g_free (name);

  sel->n_pads++;

  gst_pad_set_event_function (sinkpad,
      GST_DEBUG_FUNCPTR (gst_selector_pad_event));
  gst_pad_set_query_function (sinkpad,
      GST_DEBUG_FUNCPTR (gst_selector_pad_query));
  gst_pad_set_chain_function (sinkpad,
      GST_DEBUG_FUNCPTR (gst_selector_pad_chain));
  gst_pad_set_iterate_internal_links_function (sinkpad,
      GST_DEBUG_FUNCPTR (gst_selector_pad_iterate_linked_pads));

  GST_OBJECT_FLAG_SET (sinkpad, GST_PAD_FLAG_PROXY_CAPS);
  GST_OBJECT_FLAG_SET (sinkpad, GST_PAD_FLAG_PROXY_ALLOCATION);
  gst_pad_set_active (sinkpad, TRUE);
  gst_element_add_pad (GST_ELEMENT (sel), sinkpad);
  GST_INPUT_SELECTOR_UNLOCK (sel);

  return sinkpad;
}

static void
gst_input_selector_release_pad (GstElement * element, GstPad * pad)
{
  GstInputSelector *sel;

  sel = GST_INPUT_SELECTOR (element);
  GST_LOG_OBJECT (sel, "Releasing pad %s:%s", GST_DEBUG_PAD_NAME (pad));

  GST_INPUT_SELECTOR_LOCK (sel);
  /* if the pad was the active pad, makes us select a new one */
  if (sel->active_sinkpad == pad) {
    GST_DEBUG_OBJECT (sel, "Deactivating pad %s:%s", GST_DEBUG_PAD_NAME (pad));
    gst_object_unref (sel->active_sinkpad);
    sel->active_sinkpad = NULL;
  }
  sel->n_pads--;
  GST_INPUT_SELECTOR_UNLOCK (sel);

  gst_pad_set_active (pad, FALSE);
  gst_element_remove_pad (GST_ELEMENT (sel), pad);
}

static void
gst_input_selector_reset (GstInputSelector * sel)
{
  GList *walk;

  GST_INPUT_SELECTOR_LOCK (sel);
  /* clear active pad */
  if (sel->active_sinkpad) {
    gst_object_unref (sel->active_sinkpad);
    sel->active_sinkpad = NULL;
  }
  /* reset each of our sinkpads state */
  for (walk = GST_ELEMENT_CAST (sel)->sinkpads; walk; walk = g_list_next (walk)) {
    GstSelectorPad *selpad = GST_SELECTOR_PAD_CAST (walk->data);

    gst_selector_pad_reset (selpad);

    if (selpad->tags) {
      gst_tag_list_unref (selpad->tags);
      selpad->tags = NULL;
    }
  }
  sel->have_group_id = TRUE;
  GST_INPUT_SELECTOR_UNLOCK (sel);
}

static GstStateChangeReturn
gst_input_selector_change_state (GstElement * element,
    GstStateChange transition)
{
  GstInputSelector *self = GST_INPUT_SELECTOR (element);
  GstStateChangeReturn result;

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_INPUT_SELECTOR_LOCK (self);
      self->blocked = FALSE;
      self->flushing = FALSE;
      GST_INPUT_SELECTOR_UNLOCK (self);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      /* first unlock before we call the parent state change function, which
       * tries to acquire the stream lock when going to ready. */
      GST_INPUT_SELECTOR_LOCK (self);
      self->blocked = FALSE;
      self->flushing = TRUE;
      GST_INPUT_SELECTOR_BROADCAST (self);
      GST_INPUT_SELECTOR_UNLOCK (self);
      break;
    default:
      break;
  }

  result = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_input_selector_reset (self);
      break;
    default:
      break;
  }

  return result;
}

static gint64
gst_input_selector_block (GstInputSelector * self)
{
  gint64 ret = 0;
  GstSelectorPad *spad;

  GST_INPUT_SELECTOR_LOCK (self);

  if (self->blocked)
    GST_WARNING_OBJECT (self, "switch already blocked");

  self->blocked = TRUE;
  spad = GST_SELECTOR_PAD_CAST (self->active_sinkpad);

  if (spad)
    ret = gst_selector_pad_get_running_time (spad);
  else
    GST_DEBUG_OBJECT (self, "no active pad while blocking");

  GST_INPUT_SELECTOR_UNLOCK (self);

  return ret;
}
