/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gsttypefindelement.c: element that detects type of stream
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
 * SECTION:element-typefind
 *
 * Determines the media-type of a stream. It applies typefind functions in the
 * order of their rank. Once the type has been detected it sets its src pad caps
 * to the found media type.
 *
 * Whenever a type is found the #GstTypeFindElement::have-type signal is
 * emitted, either from the streaming thread or the application thread
 * (the latter may happen when typefinding is done pull-based from the
 * state change function).
 *
 * Plugins can register custom typefinders by using #GstTypeFindFactory.
 */

/* FIXME: need a better solution for non-seekable streams */

/* way of operation:
 * 1) get a list of all typefind functions sorted best to worst
 * 2) if all elements have been called with all requested data goto 8
 * 3) call all functions once with all available data
 * 4) if a function returns a value >= PROP_MAXIMUM goto 8 (never implemented))
 * 5) all functions with a result > PROP_MINIMUM or functions that did not get
 *    all requested data (where peek returned NULL) stay in list
 * 6) seek to requested offset of best function that still has open data
 *    requests
 * 7) goto 2
 * 8) take best available result and use its caps
 *
 * The element has two scheduling modes:
 *
 * 1) chain based, it will collect buffers and run the typefind function on
 *    the buffer until something is found.
 * 2) getrange based, it will proxy the getrange function to the sinkpad. It
 *    is assumed that the peer element is happy with whatever format we
 *    eventually read.
 *
 * By default it tries to do pull based typefinding (this avoids joining
 * received buffers and holding them back in store.)
 *
 * When the element has no connected srcpad, and the sinkpad can operate in
 * getrange based mode, the element starts its own task to figure out the
 * type of the stream.
 *
 * Most of the actual implementation is in libs/gst/base/gsttypefindhelper.c.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gst/gst_private.h"

#include "gsttypefindelement.h"
#include "gst/gst-i18n-lib.h"
#include "gst/base/gsttypefindhelper.h"

#include <gst/gsttypefind.h>
#include <gst/gstutils.h>
#include <gst/gsterror.h>

GST_DEBUG_CATEGORY_STATIC (gst_type_find_element_debug);
#define GST_CAT_DEFAULT gst_type_find_element_debug

/* generic templates */
static GstStaticPadTemplate type_find_element_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate type_find_element_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

/* Require at least 2kB of data before we attempt typefinding in chain-mode.
 * 128kB is massive overkill for the maximum, but doesn't do any harm */
#define TYPE_FIND_MIN_SIZE   (2*1024)
#define TYPE_FIND_MAX_SIZE (128*1024)

/* TypeFind signals and args */
enum
{
  HAVE_TYPE,
  LAST_SIGNAL
};
enum
{
  PROP_0,
  PROP_CAPS,
  PROP_MINIMUM,
  PROP_FORCE_CAPS,
  PROP_LAST
};
enum
{
  MODE_NORMAL,                  /* act as identity */
  MODE_TYPEFIND,                /* do typefinding  */
  MODE_ERROR                    /* had fatal error */
};


#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_type_find_element_debug, "typefind",           \
        GST_DEBUG_BG_YELLOW | GST_DEBUG_FG_GREEN, "type finding element");
#define gst_type_find_element_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstTypeFindElement, gst_type_find_element,
    GST_TYPE_ELEMENT, _do_init);

static void gst_type_find_element_dispose (GObject * object);
static void gst_type_find_element_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_type_find_element_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

#if 0
static const GstEventMask *gst_type_find_element_src_event_mask (GstPad * pad);
#endif

static gboolean gst_type_find_element_src_event (GstPad * pad,
    GstObject * parent, GstEvent * event);
static gboolean gst_type_find_handle_src_query (GstPad * pad,
    GstObject * parent, GstQuery * query);

static gboolean gst_type_find_element_sink_event (GstPad * pad,
    GstObject * parent, GstEvent * event);
static gboolean gst_type_find_element_setcaps (GstTypeFindElement * typefind,
    GstCaps * caps);
static GstFlowReturn gst_type_find_element_chain (GstPad * sinkpad,
    GstObject * parent, GstBuffer * buffer);
static GstFlowReturn gst_type_find_element_getrange (GstPad * srcpad,
    GstObject * parent, guint64 offset, guint length, GstBuffer ** buffer);

static GstStateChangeReturn
gst_type_find_element_change_state (GstElement * element,
    GstStateChange transition);
static gboolean gst_type_find_element_activate_sink (GstPad * pad,
    GstObject * parent);
static gboolean gst_type_find_element_activate_sink_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_type_find_element_activate_src_mode (GstPad * pad,
    GstObject * parent, GstPadMode mode, gboolean active);
static GstFlowReturn
gst_type_find_element_chain_do_typefinding (GstTypeFindElement * typefind,
    gboolean check_avail);
static void gst_type_find_element_send_cached_events (GstTypeFindElement *
    typefind);

static void gst_type_find_element_loop (GstPad * pad);

static guint gst_type_find_element_signals[LAST_SIGNAL] = { 0 };

static void
gst_type_find_element_have_type (GstTypeFindElement * typefind,
    guint probability, GstCaps * caps)
{
  g_assert (caps != NULL);

  GST_INFO_OBJECT (typefind, "found caps %" GST_PTR_FORMAT ", probability=%u",
      caps, probability);

  GST_OBJECT_LOCK (typefind);
  if (typefind->caps)
    gst_caps_unref (typefind->caps);
  typefind->caps = gst_caps_ref (caps);
  GST_OBJECT_UNLOCK (typefind);

  gst_pad_set_caps (typefind->src, caps);
}

static void
gst_type_find_element_class_init (GstTypeFindElementClass * typefind_class)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (typefind_class);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (typefind_class);

  gobject_class->set_property = gst_type_find_element_set_property;
  gobject_class->get_property = gst_type_find_element_get_property;
  gobject_class->dispose = gst_type_find_element_dispose;

  g_object_class_install_property (gobject_class, PROP_CAPS,
      g_param_spec_boxed ("caps", _("caps"),
          _("detected capabilities in stream"), GST_TYPE_CAPS,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_MINIMUM,
      g_param_spec_uint ("minimum", _("minimum"),
          "minimum probability required to accept caps", GST_TYPE_FIND_MINIMUM,
          GST_TYPE_FIND_MAXIMUM, GST_TYPE_FIND_MINIMUM,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_FORCE_CAPS,
      g_param_spec_boxed ("force-caps", _("force caps"),
          _("force caps without doing a typefind"), GST_TYPE_CAPS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstTypeFindElement::have-type:
   * @typefind: the typefind instance
   * @probability: the probability of the type found
   * @caps: the caps of the type found
   *
   * This signal gets emitted when the type and its probability has
   * been found.
   */
  gst_type_find_element_signals[HAVE_TYPE] = g_signal_new ("have-type",
      G_TYPE_FROM_CLASS (typefind_class), G_SIGNAL_RUN_FIRST,
      G_STRUCT_OFFSET (GstTypeFindElementClass, have_type), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 2,
      G_TYPE_UINT, GST_TYPE_CAPS | G_SIGNAL_TYPE_STATIC_SCOPE);

  typefind_class->have_type =
      GST_DEBUG_FUNCPTR (gst_type_find_element_have_type);

  gst_element_class_set_static_metadata (gstelement_class,
      "TypeFind",
      "Generic",
      "Finds the media type of a stream",
      "Benjamin Otte <in7y118@public.uni-hamburg.de>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&type_find_element_src_template));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&type_find_element_sink_template));

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_type_find_element_change_state);
}

static void
gst_type_find_element_init (GstTypeFindElement * typefind)
{
  /* sinkpad */
  typefind->sink =
      gst_pad_new_from_static_template (&type_find_element_sink_template,
      "sink");

  gst_pad_set_activate_function (typefind->sink,
      GST_DEBUG_FUNCPTR (gst_type_find_element_activate_sink));
  gst_pad_set_activatemode_function (typefind->sink,
      GST_DEBUG_FUNCPTR (gst_type_find_element_activate_sink_mode));
  gst_pad_set_chain_function (typefind->sink,
      GST_DEBUG_FUNCPTR (gst_type_find_element_chain));
  gst_pad_set_event_function (typefind->sink,
      GST_DEBUG_FUNCPTR (gst_type_find_element_sink_event));
  GST_PAD_SET_PROXY_ALLOCATION (typefind->sink);
  gst_element_add_pad (GST_ELEMENT (typefind), typefind->sink);

  /* srcpad */
  typefind->src =
      gst_pad_new_from_static_template (&type_find_element_src_template, "src");

  gst_pad_set_activatemode_function (typefind->src,
      GST_DEBUG_FUNCPTR (gst_type_find_element_activate_src_mode));
  gst_pad_set_getrange_function (typefind->src,
      GST_DEBUG_FUNCPTR (gst_type_find_element_getrange));
  gst_pad_set_event_function (typefind->src,
      GST_DEBUG_FUNCPTR (gst_type_find_element_src_event));
  gst_pad_set_query_function (typefind->src,
      GST_DEBUG_FUNCPTR (gst_type_find_handle_src_query));
  gst_pad_use_fixed_caps (typefind->src);
  gst_element_add_pad (GST_ELEMENT (typefind), typefind->src);

  typefind->mode = MODE_TYPEFIND;
  typefind->caps = NULL;
  typefind->min_probability = 1;

  typefind->adapter = gst_adapter_new ();
}

static void
gst_type_find_element_dispose (GObject * object)
{
  GstTypeFindElement *typefind = GST_TYPE_FIND_ELEMENT (object);

  if (typefind->adapter) {
    g_object_unref (typefind->adapter);
    typefind->adapter = NULL;
  }

  if (typefind->force_caps) {
    gst_caps_unref (typefind->force_caps);
    typefind->force_caps = NULL;
  }

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_type_find_element_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTypeFindElement *typefind;

  typefind = GST_TYPE_FIND_ELEMENT (object);

  switch (prop_id) {
    case PROP_MINIMUM:
      typefind->min_probability = g_value_get_uint (value);
      break;
    case PROP_FORCE_CAPS:
      GST_OBJECT_LOCK (typefind);
      if (typefind->force_caps)
        gst_caps_unref (typefind->force_caps);
      typefind->force_caps = g_value_dup_boxed (value);
      GST_OBJECT_UNLOCK (typefind);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_type_find_element_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstTypeFindElement *typefind;

  typefind = GST_TYPE_FIND_ELEMENT (object);

  switch (prop_id) {
    case PROP_CAPS:
      GST_OBJECT_LOCK (typefind);
      g_value_set_boxed (value, typefind->caps);
      GST_OBJECT_UNLOCK (typefind);
      break;
    case PROP_MINIMUM:
      g_value_set_uint (value, typefind->min_probability);
      break;
    case PROP_FORCE_CAPS:
      GST_OBJECT_LOCK (typefind);
      g_value_set_boxed (value, typefind->force_caps);
      GST_OBJECT_UNLOCK (typefind);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_type_find_handle_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  GstTypeFindElement *typefind;
  gboolean res = FALSE;

  typefind = GST_TYPE_FIND_ELEMENT (parent);
  GST_DEBUG_OBJECT (typefind, "Handling src query %s",
      GST_QUERY_TYPE_NAME (query));

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SCHEDULING:
      /* FIXME, filter out the scheduling modes that we understand */
      res = gst_pad_peer_query (typefind->sink, query);
      break;
    case GST_QUERY_CAPS:
    {
      GST_DEBUG_OBJECT (typefind,
          "Got caps query, our caps are %" GST_PTR_FORMAT, typefind->caps);

      /* We can hijack caps query if we typefind already */
      if (typefind->caps) {
        gst_query_set_caps_result (query, typefind->caps);
        res = TRUE;
      } else {
        res = gst_pad_peer_query (typefind->sink, query);
      }
      break;
    }
    case GST_QUERY_POSITION:
    {
      gint64 peer_pos;
      GstFormat format;

      if (!(res = gst_pad_peer_query (typefind->sink, query)))
        goto out;

      gst_query_parse_position (query, &format, &peer_pos);

      GST_OBJECT_LOCK (typefind);
      /* FIXME: this code assumes that there's no discont in the queue */
      switch (format) {
        case GST_FORMAT_BYTES:
          peer_pos -= gst_adapter_available (typefind->adapter);
          break;
        default:
          /* FIXME */
          break;
      }
      GST_OBJECT_UNLOCK (typefind);
      gst_query_set_position (query, format, peer_pos);
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }
out:
  return res;
}

static gboolean
gst_type_find_element_seek (GstTypeFindElement * typefind, GstEvent * event)
{
  GstSeekFlags flags;
  GstSeekType start_type, stop_type;
  GstFormat format;
  gboolean flush;
  gdouble rate;
  gint64 start, stop;
  GstSegment seeksegment = { 0, };

  gst_event_parse_seek (event, &rate, &format, &flags, &start_type, &start,
      &stop_type, &stop);

  /* we can only seek on bytes */
  if (format != GST_FORMAT_BYTES) {
    GST_DEBUG_OBJECT (typefind, "Can only seek on BYTES");
    return FALSE;
  }

  /* copy segment, we need this because we still need the old
   * segment when we close the current segment. */
  memcpy (&seeksegment, &typefind->segment, sizeof (GstSegment));

  GST_DEBUG_OBJECT (typefind, "configuring seek");
  gst_segment_do_seek (&seeksegment, rate, format, flags,
      start_type, start, stop_type, stop, NULL);

  flush = ! !(flags & GST_SEEK_FLAG_FLUSH);

  GST_DEBUG_OBJECT (typefind, "New segment %" GST_SEGMENT_FORMAT, &seeksegment);

  if (flush) {
    GST_DEBUG_OBJECT (typefind, "Starting flush");
    gst_pad_push_event (typefind->sink, gst_event_new_flush_start ());
    gst_pad_push_event (typefind->src, gst_event_new_flush_start ());
  } else {
    GST_DEBUG_OBJECT (typefind, "Non-flushing seek, pausing task");
    gst_pad_pause_task (typefind->sink);
  }

  /* now grab the stream lock so that streaming cannot continue, for
   * non flushing seeks when the element is in PAUSED this could block
   * forever. */
  GST_DEBUG_OBJECT (typefind, "Waiting for streaming to stop");
  GST_PAD_STREAM_LOCK (typefind->sink);

  if (flush) {
    GST_DEBUG_OBJECT (typefind, "Stopping flush");
    gst_pad_push_event (typefind->sink, gst_event_new_flush_stop (TRUE));
    gst_pad_push_event (typefind->src, gst_event_new_flush_stop (TRUE));
  }

  /* now update the real segment info */
  GST_DEBUG_OBJECT (typefind, "Committing new seek segment");
  memcpy (&typefind->segment, &seeksegment, sizeof (GstSegment));
  typefind->offset = typefind->segment.start;

  /* notify start of new segment */
  if (typefind->segment.flags & GST_SEGMENT_FLAG_SEGMENT) {
    GstMessage *msg;

    msg = gst_message_new_segment_start (GST_OBJECT (typefind),
        GST_FORMAT_BYTES, typefind->segment.start);
    gst_element_post_message (GST_ELEMENT (typefind), msg);
  }

  typefind->need_segment = TRUE;

  /* restart our task since it might have been stopped when we did the
   * flush. */
  gst_pad_start_task (typefind->sink,
      (GstTaskFunction) gst_type_find_element_loop, typefind->sink, NULL);

  /* streaming can continue now */
  GST_PAD_STREAM_UNLOCK (typefind->sink);

  return TRUE;
}

static gboolean
gst_type_find_element_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstTypeFindElement *typefind = GST_TYPE_FIND_ELEMENT (parent);

  if (typefind->mode != MODE_NORMAL) {
    /* need to do more? */
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (event));
    return FALSE;
  }

  /* Only handle seeks here if driving the pipeline */
  if (typefind->segment.format != GST_FORMAT_UNDEFINED &&
      GST_EVENT_TYPE (event) == GST_EVENT_SEEK) {
    return gst_type_find_element_seek (typefind, event);
  } else {
    return gst_pad_push_event (typefind->sink, event);
  }
}

static void
start_typefinding (GstTypeFindElement * typefind)
{
  GST_DEBUG_OBJECT (typefind, "starting typefinding");

  GST_OBJECT_LOCK (typefind);
  if (typefind->caps)
    gst_caps_replace (&typefind->caps, NULL);
  GST_OBJECT_UNLOCK (typefind);

  typefind->mode = MODE_TYPEFIND;
}

static void
stop_typefinding (GstTypeFindElement * typefind)
{
  GstState state;
  gboolean push_cached_buffers;
  gsize avail;
  GstBuffer *buffer;
  GstClockTime pts, dts;

  gst_element_get_state (GST_ELEMENT (typefind), &state, NULL, 0);

  push_cached_buffers = (state >= GST_STATE_PAUSED && typefind->caps);

  GST_DEBUG_OBJECT (typefind, "stopping typefinding%s",
      push_cached_buffers ? " and pushing cached events and buffers" : "");

  typefind->mode = MODE_NORMAL;
  if (push_cached_buffers)
    gst_type_find_element_send_cached_events (typefind);

  GST_OBJECT_LOCK (typefind);
  avail = gst_adapter_available (typefind->adapter);
  if (avail == 0)
    goto no_data;

  pts = gst_adapter_prev_pts (typefind->adapter, NULL);
  dts = gst_adapter_prev_dts (typefind->adapter, NULL);
  buffer = gst_adapter_take_buffer (typefind->adapter, avail);
  GST_BUFFER_PTS (buffer) = pts;
  GST_BUFFER_DTS (buffer) = dts;
  GST_OBJECT_UNLOCK (typefind);

  if (!push_cached_buffers) {
    gst_buffer_unref (buffer);
  } else {
    GstPad *peer = gst_pad_get_peer (typefind->src);

    /* make sure the user gets a meaningful error message in this case,
     * which is not a core bug or bug of any kind (as the default error
     * message emitted by gstpad.c otherwise would make you think) */
    if (peer && GST_PAD_CHAINFUNC (peer) == NULL) {
      GST_DEBUG_OBJECT (typefind, "upstream only supports push mode, while "
          "downstream element only works in pull mode, erroring out");
      GST_ELEMENT_ERROR (typefind, STREAM, FAILED,
          ("%s cannot work in push mode. The operation is not supported "
              "with this source element or protocol.",
              G_OBJECT_TYPE_NAME (GST_PAD_PARENT (peer))),
          ("Downstream pad %s:%s has no chainfunction, and the upstream "
              "element does not support pull mode", GST_DEBUG_PAD_NAME (peer)));
      typefind->mode = MODE_ERROR;      /* make the chain function error out */
      gst_buffer_unref (buffer);
    } else {
      gst_pad_push (typefind->src, buffer);
    }
    if (peer)
      gst_object_unref (peer);
  }
  return;

  /* ERRORS */
no_data:
  {
    GST_DEBUG_OBJECT (typefind, "we have no data to typefind");
    GST_OBJECT_UNLOCK (typefind);
    return;
  }
}

static gboolean
gst_type_find_element_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  gboolean res = FALSE;
  GstTypeFindElement *typefind = GST_TYPE_FIND_ELEMENT (parent);

  GST_DEBUG_OBJECT (typefind, "got %s event in mode %d",
      GST_EVENT_TYPE_NAME (event), typefind->mode);

  switch (typefind->mode) {
    case MODE_TYPEFIND:
      switch (GST_EVENT_TYPE (event)) {
        case GST_EVENT_CAPS:
        {
          GstCaps *caps;

          /* Parse and push out our caps and data */
          gst_event_parse_caps (event, &caps);
          res = gst_type_find_element_setcaps (typefind, caps);

          gst_event_unref (event);
          break;
        }
        case GST_EVENT_GAP:
        {
          GST_FIXME_OBJECT (typefind,
              "GAP events during typefinding not handled properly");

          /* FIXME: These would need to be inserted in the stream at
           * the right position between buffers, but we combine all
           * buffers with a GstAdapter. Drop the GAP event for now,
           * which will only cause an implicit GAP between buffers.
           */
          gst_event_unref (event);
          res = TRUE;
          break;
        }
        case GST_EVENT_EOS:
        {
          GST_INFO_OBJECT (typefind, "Got EOS and no type found yet");
          gst_type_find_element_chain_do_typefinding (typefind, FALSE);

          res = gst_pad_push_event (typefind->src, event);
          break;
        }
        case GST_EVENT_FLUSH_STOP:{
          GList *l;

          GST_OBJECT_LOCK (typefind);

          for (l = typefind->cached_events; l; l = l->next) {
            if (!GST_EVENT_IS_STICKY (l->data) ||
                GST_EVENT_TYPE (l->data) == GST_EVENT_SEGMENT ||
                GST_EVENT_TYPE (l->data) == GST_EVENT_EOS) {
              gst_event_unref (l->data);
            } else {
              gst_pad_store_sticky_event (typefind->src, l->data);
            }
          }

          g_list_free (typefind->cached_events);
          typefind->cached_events = NULL;
          gst_adapter_clear (typefind->adapter);
          GST_OBJECT_UNLOCK (typefind);
          /* fall through */
        }
        case GST_EVENT_FLUSH_START:
          res = gst_pad_push_event (typefind->src, event);
          break;
        default:
          /* Forward events that would happen before the caps event
           * directly instead of storing them. There's no reason not
           * to send them directly and we should only store events
           * for later sending that would need to come after the caps
           * event */
          if (GST_EVENT_TYPE (event) < GST_EVENT_CAPS) {
            res = gst_pad_push_event (typefind->src, event);
          } else {
            GST_DEBUG_OBJECT (typefind, "Saving %s event to send later",
                GST_EVENT_TYPE_NAME (event));
            GST_OBJECT_LOCK (typefind);
            typefind->cached_events =
                g_list_append (typefind->cached_events, event);
            GST_OBJECT_UNLOCK (typefind);
            res = TRUE;
          }
          break;
      }
      break;
    case MODE_NORMAL:
      res = gst_pad_push_event (typefind->src, event);
      break;
    case MODE_ERROR:
      break;
    default:
      g_assert_not_reached ();
  }
  return res;
}

static void
gst_type_find_element_send_cached_events (GstTypeFindElement * typefind)
{
  GList *l, *cached_events;

  GST_OBJECT_LOCK (typefind);
  cached_events = typefind->cached_events;
  typefind->cached_events = NULL;
  GST_OBJECT_UNLOCK (typefind);

  for (l = cached_events; l != NULL; l = l->next) {
    GstEvent *event = GST_EVENT (l->data);

    GST_DEBUG_OBJECT (typefind, "sending cached %s event",
        GST_EVENT_TYPE_NAME (event));
    gst_pad_push_event (typefind->src, event);
  }
  g_list_free (cached_events);
}

static gboolean
gst_type_find_element_setcaps (GstTypeFindElement * typefind, GstCaps * caps)
{
  /* don't operate on ANY caps */
  if (gst_caps_is_any (caps))
    return TRUE;

  g_signal_emit (typefind, gst_type_find_element_signals[HAVE_TYPE], 0,
      GST_TYPE_FIND_MAXIMUM, caps);

  /* Shortcircuit typefinding if we get caps */
  GST_DEBUG_OBJECT (typefind, "Skipping typefinding, using caps from "
      "upstream: %" GST_PTR_FORMAT, caps);

  stop_typefinding (typefind);

  return TRUE;
}

static gchar *
gst_type_find_get_extension (GstTypeFindElement * typefind, GstPad * pad)
{
  GstQuery *query;
  gchar *uri, *result;
  size_t len;
  gint find;

  query = gst_query_new_uri ();

  /* try getting the caps with an uri query and from the extension */
  if (!gst_pad_peer_query (pad, query))
    goto peer_query_failed;

  gst_query_parse_uri (query, &uri);
  if (uri == NULL)
    goto no_uri;

  GST_DEBUG_OBJECT (typefind, "finding extension of %s", uri);

  /* find the extension on the uri, this is everything after a '.' */
  len = strlen (uri);
  find = len - 1;

  while (find >= 0) {
    if (uri[find] == '.')
      break;
    find--;
  }
  if (find < 0)
    goto no_extension;

  result = g_strdup (&uri[find + 1]);

  GST_DEBUG_OBJECT (typefind, "found extension %s", result);
  gst_query_unref (query);
  g_free (uri);

  return result;

  /* ERRORS */
peer_query_failed:
  {
    GST_WARNING_OBJECT (typefind, "failed to query peer uri");
    gst_query_unref (query);
    return NULL;
  }
no_uri:
  {
    GST_WARNING_OBJECT (typefind, "could not parse the peer uri");
    gst_query_unref (query);
    return NULL;
  }
no_extension:
  {
    GST_WARNING_OBJECT (typefind, "could not find uri extension in %s", uri);
    gst_query_unref (query);
    g_free (uri);
    return NULL;
  }
}

static GstCaps *
gst_type_find_guess_by_extension (GstTypeFindElement * typefind, GstPad * pad,
    GstTypeFindProbability * probability)
{
  gchar *ext;
  GstCaps *caps;

  ext = gst_type_find_get_extension (typefind, pad);
  if (!ext)
    return NULL;

  caps = gst_type_find_helper_for_extension (GST_OBJECT_CAST (typefind), ext);
  if (caps)
    *probability = GST_TYPE_FIND_MAXIMUM;

  g_free (ext);

  return caps;
}

static GstFlowReturn
gst_type_find_element_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer)
{
  GstTypeFindElement *typefind;
  GstFlowReturn res = GST_FLOW_OK;

  typefind = GST_TYPE_FIND_ELEMENT (parent);

  GST_LOG_OBJECT (typefind, "handling buffer in mode %d", typefind->mode);

  switch (typefind->mode) {
    case MODE_ERROR:
      /* we should already have called GST_ELEMENT_ERROR */
      return GST_FLOW_ERROR;
    case MODE_NORMAL:
      /* don't take object lock as typefind->caps should not change anymore */
      return gst_pad_push (typefind->src, buffer);
    case MODE_TYPEFIND:
    {
      GST_OBJECT_LOCK (typefind);
      gst_adapter_push (typefind->adapter, buffer);
      GST_OBJECT_UNLOCK (typefind);

      res = gst_type_find_element_chain_do_typefinding (typefind, TRUE);

      if (typefind->mode == MODE_ERROR)
        res = GST_FLOW_ERROR;

      break;
    }
    default:
      g_assert_not_reached ();
      return GST_FLOW_ERROR;
  }

  return res;
}

static GstFlowReturn
gst_type_find_element_chain_do_typefinding (GstTypeFindElement * typefind,
    gboolean check_avail)
{
  GstTypeFindProbability probability;
  GstCaps *caps = NULL;
  gsize avail;
  const guint8 *data;
  gboolean have_min, have_max;

  GST_OBJECT_LOCK (typefind);
  if (typefind->force_caps) {
    caps = gst_caps_ref (typefind->force_caps);
    probability = GST_TYPE_FIND_MAXIMUM;
  }

  if (!caps) {
    avail = gst_adapter_available (typefind->adapter);

    if (check_avail) {
      have_min = avail >= TYPE_FIND_MIN_SIZE;
      have_max = avail >= TYPE_FIND_MAX_SIZE;
    } else {
      have_min = avail > 0;
      have_max = TRUE;
    }

    if (!have_min)
      goto not_enough_data;

    /* map all available data */
    data = gst_adapter_map (typefind->adapter, avail);
    caps = gst_type_find_helper_for_data (GST_OBJECT (typefind),
        data, avail, &probability);
    gst_adapter_unmap (typefind->adapter);

    if (caps == NULL && have_max)
      goto no_type_found;
    else if (caps == NULL)
      goto wait_for_data;

    /* found a type */
    if (probability < typefind->min_probability)
      goto low_probability;
  }

  GST_OBJECT_UNLOCK (typefind);

  /* probability is good enough too, so let's make it known ... emiting this
   * signal calls our object handler which sets the caps. */
  g_signal_emit (typefind, gst_type_find_element_signals[HAVE_TYPE], 0,
      probability, caps);

  /* .. and send out the accumulated data */
  stop_typefinding (typefind);
  gst_caps_unref (caps);

  return GST_FLOW_OK;

not_enough_data:
  {
    GST_DEBUG_OBJECT (typefind, "not enough data for typefinding yet "
        "(%" G_GSIZE_FORMAT " bytes)", avail);
    GST_OBJECT_UNLOCK (typefind);
    return GST_FLOW_OK;
  }
no_type_found:
  {
    GST_OBJECT_UNLOCK (typefind);
    GST_ELEMENT_ERROR (typefind, STREAM, TYPE_NOT_FOUND, (NULL), (NULL));
    stop_typefinding (typefind);
    return GST_FLOW_ERROR;
  }
wait_for_data:
  {
    GST_DEBUG_OBJECT (typefind,
        "no caps found with %" G_GSIZE_FORMAT " bytes of data, "
        "waiting for more data", avail);
    GST_OBJECT_UNLOCK (typefind);
    return GST_FLOW_OK;
  }
low_probability:
  {
    GST_DEBUG_OBJECT (typefind, "found caps %" GST_PTR_FORMAT ", but "
        "probability is %u which is lower than the required minimum of %u",
        caps, probability, typefind->min_probability);

    gst_caps_unref (caps);

    if (have_max)
      goto no_type_found;

    GST_OBJECT_UNLOCK (typefind);
    GST_DEBUG_OBJECT (typefind, "waiting for more data to try again");
    return GST_FLOW_OK;
  }
}

static GstFlowReturn
gst_type_find_element_getrange (GstPad * srcpad, GstObject * parent,
    guint64 offset, guint length, GstBuffer ** buffer)
{
  GstTypeFindElement *typefind;
  GstFlowReturn ret;

  typefind = GST_TYPE_FIND_ELEMENT (parent);

  ret = gst_pad_pull_range (typefind->sink, offset, length, buffer);

  return ret;
}

static gboolean
gst_type_find_element_activate_src_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;
  GstTypeFindElement *typefind;

  typefind = GST_TYPE_FIND_ELEMENT (parent);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      /* make sure our task stops pushing, we can't call _stop here because this
       * activation might happen from the streaming thread. */
      gst_pad_pause_task (typefind->sink);
      res = gst_pad_activate_mode (typefind->sink, mode, active);
      break;
    default:
      res = TRUE;
      break;
  }
  return res;
}

static void
gst_type_find_element_loop (GstPad * pad)
{
  GstTypeFindElement *typefind;
  GstFlowReturn ret = GST_FLOW_OK;

  typefind = GST_TYPE_FIND_ELEMENT (GST_PAD_PARENT (pad));

  if (typefind->need_stream_start) {
    gchar *stream_id;
    GstEvent *event;

    stream_id = gst_pad_create_stream_id (typefind->src,
        GST_ELEMENT_CAST (typefind), NULL);

    GST_DEBUG_OBJECT (typefind, "Pushing STREAM_START");
    event = gst_event_new_stream_start (stream_id);
    gst_event_set_group_id (event, gst_util_group_id_next ());
    gst_pad_push_event (typefind->src, event);

    typefind->need_stream_start = FALSE;
    g_free (stream_id);
  }

  if (typefind->mode == MODE_TYPEFIND) {
    GstPad *peer = NULL;
    GstCaps *found_caps = NULL;
    GstTypeFindProbability probability = GST_TYPE_FIND_NONE;

    GST_DEBUG_OBJECT (typefind, "find type in pull mode");

    GST_OBJECT_LOCK (typefind);
    if (typefind->force_caps) {
      found_caps = gst_caps_ref (typefind->force_caps);
      probability = GST_TYPE_FIND_MAXIMUM;
    }
    GST_OBJECT_UNLOCK (typefind);

    if (!found_caps) {
      peer = gst_pad_get_peer (pad);
      if (peer) {
        gint64 size;
        gchar *ext;

        if (!gst_pad_query_duration (peer, GST_FORMAT_BYTES, &size)) {
          GST_WARNING_OBJECT (typefind, "Could not query upstream length!");
          gst_object_unref (peer);

          ret = GST_FLOW_ERROR;
          goto pause;
        }

        /* the size if 0, we cannot continue */
        if (size == 0) {
          /* keep message in sync with message in sink event handler */
          GST_ELEMENT_ERROR (typefind, STREAM, TYPE_NOT_FOUND,
              (_("Stream contains no data.")), ("Can't typefind empty stream"));
          gst_object_unref (peer);
          ret = GST_FLOW_ERROR;
          goto pause;
        }
        ext = gst_type_find_get_extension (typefind, pad);

        found_caps =
            gst_type_find_helper_get_range (GST_OBJECT_CAST (peer),
            GST_OBJECT_PARENT (peer),
            (GstTypeFindHelperGetRangeFunction) (GST_PAD_GETRANGEFUNC (peer)),
            (guint64) size, ext, &probability);
        g_free (ext);

        GST_DEBUG ("Found caps %" GST_PTR_FORMAT, found_caps);

        gst_object_unref (peer);
      }
    }

    if (!found_caps || probability < typefind->min_probability) {
      GST_DEBUG ("Trying to guess using extension");
      gst_caps_replace (&found_caps, NULL);
      found_caps =
          gst_type_find_guess_by_extension (typefind, pad, &probability);
    }

    if (!found_caps || probability < typefind->min_probability) {
      GST_ELEMENT_ERROR (typefind, STREAM, TYPE_NOT_FOUND, (NULL), (NULL));
      gst_caps_replace (&found_caps, NULL);
      ret = GST_FLOW_ERROR;
      goto pause;
    }

    GST_DEBUG ("Emiting found caps %" GST_PTR_FORMAT, found_caps);
    g_signal_emit (typefind, gst_type_find_element_signals[HAVE_TYPE],
        0, probability, found_caps);
    typefind->mode = MODE_NORMAL;
    gst_caps_unref (found_caps);
  } else if (typefind->mode == MODE_NORMAL) {
    GstBuffer *outbuf = NULL;

    if (typefind->need_segment) {
      typefind->need_segment = FALSE;
      gst_pad_push_event (typefind->src,
          gst_event_new_segment (&typefind->segment));
    }

    /* Pull 4k blocks and send downstream */
    ret = gst_pad_pull_range (typefind->sink, typefind->offset, 4096, &outbuf);
    if (ret != GST_FLOW_OK)
      goto pause;

    typefind->offset += gst_buffer_get_size (outbuf);

    ret = gst_pad_push (typefind->src, outbuf);
    if (ret != GST_FLOW_OK)
      goto pause;
  } else {
    /* Error out */
    ret = GST_FLOW_ERROR;
    goto pause;
  }

  return;

pause:
  {
    const gchar *reason = gst_flow_get_name (ret);
    gboolean push_eos = FALSE;

    GST_LOG_OBJECT (typefind, "pausing task, reason %s", reason);
    gst_pad_pause_task (typefind->sink);

    if (ret == GST_FLOW_EOS) {
      /* perform EOS logic */

      if (typefind->segment.flags & GST_SEGMENT_FLAG_SEGMENT) {
        gint64 stop;

        /* for segment playback we need to post when (in stream time)
         * we stopped, this is either stop (when set) or the duration. */
        if ((stop = typefind->segment.stop) == -1)
          stop = typefind->offset;

        GST_LOG_OBJECT (typefind, "Sending segment done, at end of segment");
        gst_element_post_message (GST_ELEMENT (typefind),
            gst_message_new_segment_done (GST_OBJECT (typefind),
                GST_FORMAT_BYTES, stop));
        gst_pad_push_event (typefind->src,
            gst_event_new_segment_done (GST_FORMAT_BYTES, stop));
      } else {
        push_eos = TRUE;
      }
    } else if (ret == GST_FLOW_NOT_LINKED || ret < GST_FLOW_EOS) {
      /* for fatal errors we post an error message */
      GST_ELEMENT_ERROR (typefind, STREAM, FAILED, (NULL),
          ("stream stopped, reason %s", reason));
      push_eos = TRUE;
    }
    if (push_eos) {
      /* send EOS, and prevent hanging if no streams yet */
      GST_LOG_OBJECT (typefind, "Sending EOS, at end of stream");
      gst_pad_push_event (typefind->src, gst_event_new_eos ());
    }
    return;
  }
}

static gboolean
gst_type_find_element_activate_sink_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;
  GstTypeFindElement *typefind;

  typefind = GST_TYPE_FIND_ELEMENT (parent);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      if (active) {
        gst_segment_init (&typefind->segment, GST_FORMAT_BYTES);
        typefind->need_segment = TRUE;
        typefind->need_stream_start = TRUE;
        typefind->offset = 0;
        res = TRUE;
      } else {
        res = gst_pad_stop_task (pad);
      }
      break;
    case GST_PAD_MODE_PUSH:
      if (active)
        start_typefinding (typefind);
      else
        stop_typefinding (typefind);

      res = TRUE;
      break;
    default:
      res = FALSE;
      break;
  }
  return res;
}

static gboolean
gst_type_find_element_activate_sink (GstPad * pad, GstObject * parent)
{
  GstQuery *query;
  gboolean pull_mode;
  GstSchedulingFlags sched_flags;

  query = gst_query_new_scheduling ();

  if (!gst_pad_peer_query (pad, query)) {
    gst_query_unref (query);
    goto typefind_push;
  }

  gst_query_parse_scheduling (query, &sched_flags, NULL, NULL, NULL);

  pull_mode = gst_query_has_scheduling_mode (query, GST_PAD_MODE_PULL)
      && ((sched_flags & GST_SCHEDULING_FLAG_SEEKABLE) != 0);

  gst_query_unref (query);

  if (!pull_mode)
    goto typefind_push;

  if (!gst_pad_activate_mode (pad, GST_PAD_MODE_PULL, TRUE))
    goto typefind_push;

  /* only start our task if we ourselves decide to start in pull mode */
  return gst_pad_start_task (pad, (GstTaskFunction) gst_type_find_element_loop,
      pad, NULL);

typefind_push:
  {
    return gst_pad_activate_mode (pad, GST_PAD_MODE_PUSH, TRUE);
  }
}

static GstStateChangeReturn
gst_type_find_element_change_state (GstElement * element,
    GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstTypeFindElement *typefind;

  typefind = GST_TYPE_FIND_ELEMENT (element);


  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
    case GST_STATE_CHANGE_READY_TO_NULL:
      GST_OBJECT_LOCK (typefind);
      gst_caps_replace (&typefind->caps, NULL);

      g_list_foreach (typefind->cached_events,
          (GFunc) gst_mini_object_unref, NULL);
      g_list_free (typefind->cached_events);
      typefind->cached_events = NULL;
      typefind->mode = MODE_TYPEFIND;
      GST_OBJECT_UNLOCK (typefind);
      break;
    default:
      break;
  }

  return ret;
}
