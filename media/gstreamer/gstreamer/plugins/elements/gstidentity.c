/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstidentity.c:
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
 * SECTION:element-identity
 *
 * Dummy element that passes incoming data through unmodified. It has some
 * useful diagnostic functions, such as offset and timestamp checking.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include "gstelements_private.h"
#include "../../gst/gst-i18n-lib.h"
#include "gstidentity.h"

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_identity_debug);
#define GST_CAT_DEFAULT gst_identity_debug

/* Identity signals and args */
enum
{
  SIGNAL_HANDOFF,
  /* FILL ME */
  LAST_SIGNAL
};

#define DEFAULT_SLEEP_TIME              0
#define DEFAULT_DUPLICATE               1
#define DEFAULT_ERROR_AFTER             -1
#define DEFAULT_DROP_PROBABILITY        0.0
#define DEFAULT_DATARATE                0
#define DEFAULT_SILENT                  TRUE
#define DEFAULT_SINGLE_SEGMENT          FALSE
#define DEFAULT_DUMP                    FALSE
#define DEFAULT_SYNC                    FALSE
#define DEFAULT_CHECK_IMPERFECT_TIMESTAMP FALSE
#define DEFAULT_CHECK_IMPERFECT_OFFSET    FALSE
#define DEFAULT_SIGNAL_HANDOFFS           TRUE

enum
{
  PROP_0,
  PROP_SLEEP_TIME,
  PROP_ERROR_AFTER,
  PROP_DROP_PROBABILITY,
  PROP_DATARATE,
  PROP_SILENT,
  PROP_SINGLE_SEGMENT,
  PROP_LAST_MESSAGE,
  PROP_DUMP,
  PROP_SYNC,
  PROP_CHECK_IMPERFECT_TIMESTAMP,
  PROP_CHECK_IMPERFECT_OFFSET,
  PROP_SIGNAL_HANDOFFS
};


#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_identity_debug, "identity", 0, "identity element");
#define gst_identity_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstIdentity, gst_identity, GST_TYPE_BASE_TRANSFORM,
    _do_init);

static void gst_identity_finalize (GObject * object);
static void gst_identity_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_identity_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static gboolean gst_identity_sink_event (GstBaseTransform * trans,
    GstEvent * event);
static GstFlowReturn gst_identity_transform_ip (GstBaseTransform * trans,
    GstBuffer * buf);
static gboolean gst_identity_start (GstBaseTransform * trans);
static gboolean gst_identity_stop (GstBaseTransform * trans);
static GstStateChangeReturn gst_identity_change_state (GstElement * element,
    GstStateChange transition);
static gboolean gst_identity_accept_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps);

static guint gst_identity_signals[LAST_SIGNAL] = { 0 };

static GParamSpec *pspec_last_message = NULL;

static void
gst_identity_finalize (GObject * object)
{
  GstIdentity *identity;

  identity = GST_IDENTITY (object);

  g_free (identity->last_message);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_identity_class_init (GstIdentityClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseTransformClass *gstbasetrans_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);
  gstbasetrans_class = GST_BASE_TRANSFORM_CLASS (klass);

  gobject_class->set_property = gst_identity_set_property;
  gobject_class->get_property = gst_identity_get_property;

  g_object_class_install_property (gobject_class, PROP_SLEEP_TIME,
      g_param_spec_uint ("sleep-time", "Sleep time",
          "Microseconds to sleep between processing", 0, G_MAXUINT,
          DEFAULT_SLEEP_TIME, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_ERROR_AFTER,
      g_param_spec_int ("error-after", "Error After", "Error after N buffers",
          G_MININT, G_MAXINT, DEFAULT_ERROR_AFTER,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_DROP_PROBABILITY,
      g_param_spec_float ("drop-probability", "Drop Probability",
          "The Probability a buffer is dropped", 0.0, 1.0,
          DEFAULT_DROP_PROBABILITY,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_DATARATE,
      g_param_spec_int ("datarate", "Datarate",
          "(Re)timestamps buffers with number of bytes per second (0 = inactive)",
          0, G_MAXINT, DEFAULT_DATARATE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SILENT,
      g_param_spec_boolean ("silent", "silent", "silent", DEFAULT_SILENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SINGLE_SEGMENT,
      g_param_spec_boolean ("single-segment", "Single Segment",
          "Timestamp buffers and eat segments so as to appear as one segment",
          DEFAULT_SINGLE_SEGMENT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  pspec_last_message = g_param_spec_string ("last-message", "last-message",
      "last-message", NULL, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (gobject_class, PROP_LAST_MESSAGE,
      pspec_last_message);
  g_object_class_install_property (gobject_class, PROP_DUMP,
      g_param_spec_boolean ("dump", "Dump", "Dump buffer contents to stdout",
          DEFAULT_DUMP, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SYNC,
      g_param_spec_boolean ("sync", "Synchronize",
          "Synchronize to pipeline clock", DEFAULT_SYNC,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class,
      PROP_CHECK_IMPERFECT_TIMESTAMP,
      g_param_spec_boolean ("check-imperfect-timestamp",
          "Check for discontiguous timestamps",
          "Send element messages if timestamps and durations do not match up",
          DEFAULT_CHECK_IMPERFECT_TIMESTAMP,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_CHECK_IMPERFECT_OFFSET,
      g_param_spec_boolean ("check-imperfect-offset",
          "Check for discontiguous offset",
          "Send element messages if offset and offset_end do not match up",
          DEFAULT_CHECK_IMPERFECT_OFFSET,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstIdentity:signal-handoffs
   *
   * If set to #TRUE, the identity will emit a handoff signal when handling a buffer.
   * When set to #FALSE, no signal will be emitted, which might improve performance.
   */
  g_object_class_install_property (gobject_class, PROP_SIGNAL_HANDOFFS,
      g_param_spec_boolean ("signal-handoffs",
          "Signal handoffs", "Send a signal before pushing the buffer",
          DEFAULT_SIGNAL_HANDOFFS, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstIdentity::handoff:
   * @identity: the identity instance
   * @buffer: the buffer that just has been received
   * @pad: the pad that received it
   *
   * This signal gets emitted before passing the buffer downstream.
   */
  gst_identity_signals[SIGNAL_HANDOFF] =
      g_signal_new ("handoff", G_TYPE_FROM_CLASS (klass), G_SIGNAL_RUN_LAST,
      G_STRUCT_OFFSET (GstIdentityClass, handoff), NULL, NULL,
      g_cclosure_marshal_generic, G_TYPE_NONE, 1,
      GST_TYPE_BUFFER | G_SIGNAL_TYPE_STATIC_SCOPE);

  gobject_class->finalize = gst_identity_finalize;

  gst_element_class_set_static_metadata (gstelement_class,
      "Identity",
      "Generic",
      "Pass data without modification", "Erik Walthinsen <omega@cse.ogi.edu>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_identity_change_state);

  gstbasetrans_class->sink_event = GST_DEBUG_FUNCPTR (gst_identity_sink_event);
  gstbasetrans_class->transform_ip =
      GST_DEBUG_FUNCPTR (gst_identity_transform_ip);
  gstbasetrans_class->start = GST_DEBUG_FUNCPTR (gst_identity_start);
  gstbasetrans_class->stop = GST_DEBUG_FUNCPTR (gst_identity_stop);
  gstbasetrans_class->accept_caps =
      GST_DEBUG_FUNCPTR (gst_identity_accept_caps);
}

static void
gst_identity_init (GstIdentity * identity)
{
  identity->sleep_time = DEFAULT_SLEEP_TIME;
  identity->error_after = DEFAULT_ERROR_AFTER;
  identity->drop_probability = DEFAULT_DROP_PROBABILITY;
  identity->datarate = DEFAULT_DATARATE;
  identity->silent = DEFAULT_SILENT;
  identity->single_segment = DEFAULT_SINGLE_SEGMENT;
  identity->sync = DEFAULT_SYNC;
  identity->check_imperfect_timestamp = DEFAULT_CHECK_IMPERFECT_TIMESTAMP;
  identity->check_imperfect_offset = DEFAULT_CHECK_IMPERFECT_OFFSET;
  identity->dump = DEFAULT_DUMP;
  identity->last_message = NULL;
  identity->signal_handoffs = DEFAULT_SIGNAL_HANDOFFS;

  gst_base_transform_set_gap_aware (GST_BASE_TRANSFORM_CAST (identity), TRUE);
}

static void
gst_identity_notify_last_message (GstIdentity * identity)
{
  g_object_notify_by_pspec ((GObject *) identity, pspec_last_message);
}

static gboolean
gst_identity_sink_event (GstBaseTransform * trans, GstEvent * event)
{
  GstIdentity *identity;
  gboolean ret = TRUE;

  identity = GST_IDENTITY (trans);

  if (!identity->silent) {
    const GstStructure *s;
    const gchar *tstr;
    gchar *sstr;

    GST_OBJECT_LOCK (identity);
    g_free (identity->last_message);

    tstr = gst_event_type_get_name (GST_EVENT_TYPE (event));
    if ((s = gst_event_get_structure (event)))
      sstr = gst_structure_to_string (s);
    else
      sstr = g_strdup ("");

    identity->last_message =
        g_strdup_printf ("event   ******* (%s:%s) E (type: %s (%d), %s) %p",
        GST_DEBUG_PAD_NAME (trans->sinkpad), tstr, GST_EVENT_TYPE (event),
        sstr, event);
    g_free (sstr);
    GST_OBJECT_UNLOCK (identity);

    gst_identity_notify_last_message (identity);
  }

  if (identity->single_segment && (GST_EVENT_TYPE (event) == GST_EVENT_SEGMENT)) {
    if (trans->have_segment == FALSE) {
      GstEvent *news;
      GstSegment segment;

      gst_event_copy_segment (event, &segment);
      gst_event_copy_segment (event, &trans->segment);
      trans->have_segment = TRUE;

      /* This is the first segment, send out a (0, -1) segment */
      gst_segment_init (&segment, segment.format);
      news = gst_event_new_segment (&segment);

      gst_pad_event_default (trans->sinkpad, GST_OBJECT_CAST (trans), news);
    } else {
      /* need to track segment for proper running time */
      gst_event_copy_segment (event, &trans->segment);
    }
  }

  /* also transform GAP timestamp similar to buffer timestamps */
  if (identity->single_segment && (GST_EVENT_TYPE (event) == GST_EVENT_GAP) &&
      trans->have_segment && trans->segment.format == GST_FORMAT_TIME) {
    GstClockTime start, dur;

    gst_event_parse_gap (event, &start, &dur);
    if (GST_CLOCK_TIME_IS_VALID (start)) {
      start = gst_segment_to_running_time (&trans->segment,
          GST_FORMAT_TIME, start);
      gst_event_unref (event);
      event = gst_event_new_gap (start, dur);
    }
  }

  /* Reset previous timestamp, duration and offsets on SEGMENT
   * to prevent false warnings when checking for perfect streams */
  if (GST_EVENT_TYPE (event) == GST_EVENT_SEGMENT) {
    identity->prev_timestamp = identity->prev_duration = GST_CLOCK_TIME_NONE;
    identity->prev_offset = identity->prev_offset_end = GST_BUFFER_OFFSET_NONE;
  }

  if (identity->single_segment && GST_EVENT_TYPE (event) == GST_EVENT_SEGMENT) {
    /* eat up segments */
    gst_event_unref (event);
    ret = TRUE;
  } else {
    if (GST_EVENT_TYPE (event) == GST_EVENT_FLUSH_START) {
      GST_OBJECT_LOCK (identity);
      if (identity->clock_id) {
        GST_DEBUG_OBJECT (identity, "unlock clock wait");
        gst_clock_id_unschedule (identity->clock_id);
        gst_clock_id_unref (identity->clock_id);
        identity->clock_id = NULL;
      }
      GST_OBJECT_UNLOCK (identity);
    }

    ret = GST_BASE_TRANSFORM_CLASS (parent_class)->sink_event (trans, event);
  }

  return ret;
}

static void
gst_identity_check_imperfect_timestamp (GstIdentity * identity, GstBuffer * buf)
{
  GstClockTime timestamp = GST_BUFFER_TIMESTAMP (buf);

  /* invalid timestamp drops us out of check.  FIXME: maybe warn ? */
  if (timestamp != GST_CLOCK_TIME_NONE) {
    /* check if we had a previous buffer to compare to */
    if (identity->prev_timestamp != GST_CLOCK_TIME_NONE &&
        identity->prev_duration != GST_CLOCK_TIME_NONE) {
      GstClockTime t_expected;
      GstClockTimeDiff dt;

      t_expected = identity->prev_timestamp + identity->prev_duration;
      dt = GST_CLOCK_DIFF (t_expected, timestamp);
      if (dt != 0) {
        /*
         * "imperfect-timestamp" bus message:
         * @identity:        the identity instance
         * @prev-timestamp:  the previous buffer timestamp
         * @prev-duration:   the previous buffer duration
         * @prev-offset:     the previous buffer offset
         * @prev-offset-end: the previous buffer offset end
         * @cur-timestamp:   the current buffer timestamp
         * @cur-duration:    the current buffer duration
         * @cur-offset:      the current buffer offset
         * @cur-offset-end:  the current buffer offset end
         *
         * This bus message gets emitted if the check-imperfect-timestamp
         * property is set and there is a gap in time between the
         * last buffer and the newly received buffer.
         */
        gst_element_post_message (GST_ELEMENT (identity),
            gst_message_new_element (GST_OBJECT (identity),
                gst_structure_new ("imperfect-timestamp",
                    "prev-timestamp", G_TYPE_UINT64,
                    identity->prev_timestamp, "prev-duration", G_TYPE_UINT64,
                    identity->prev_duration, "prev-offset", G_TYPE_UINT64,
                    identity->prev_offset, "prev-offset-end", G_TYPE_UINT64,
                    identity->prev_offset_end, "cur-timestamp", G_TYPE_UINT64,
                    timestamp, "cur-duration", G_TYPE_UINT64,
                    GST_BUFFER_DURATION (buf), "cur-offset", G_TYPE_UINT64,
                    GST_BUFFER_OFFSET (buf), "cur-offset-end", G_TYPE_UINT64,
                    GST_BUFFER_OFFSET_END (buf), NULL)));
      }
    } else {
      GST_DEBUG_OBJECT (identity, "can't check data-contiguity, no "
          "offset_end was set on previous buffer");
    }
  }
}

static void
gst_identity_check_imperfect_offset (GstIdentity * identity, GstBuffer * buf)
{
  guint64 offset;

  offset = GST_BUFFER_OFFSET (buf);

  if (identity->prev_offset_end != offset &&
      identity->prev_offset_end != GST_BUFFER_OFFSET_NONE &&
      offset != GST_BUFFER_OFFSET_NONE) {
    /*
     * "imperfect-offset" bus message:
     * @identity:        the identity instance
     * @prev-timestamp:  the previous buffer timestamp
     * @prev-duration:   the previous buffer duration
     * @prev-offset:     the previous buffer offset
     * @prev-offset-end: the previous buffer offset end
     * @cur-timestamp:   the current buffer timestamp
     * @cur-duration:    the current buffer duration
     * @cur-offset:      the current buffer offset
     * @cur-offset-end:  the current buffer offset end
     *
     * This bus message gets emitted if the check-imperfect-offset
     * property is set and there is a gap in offsets between the
     * last buffer and the newly received buffer.
     */
    gst_element_post_message (GST_ELEMENT (identity),
        gst_message_new_element (GST_OBJECT (identity),
            gst_structure_new ("imperfect-offset", "prev-timestamp",
                G_TYPE_UINT64, identity->prev_timestamp, "prev-duration",
                G_TYPE_UINT64, identity->prev_duration, "prev-offset",
                G_TYPE_UINT64, identity->prev_offset, "prev-offset-end",
                G_TYPE_UINT64, identity->prev_offset_end, "cur-timestamp",
                G_TYPE_UINT64, GST_BUFFER_TIMESTAMP (buf), "cur-duration",
                G_TYPE_UINT64, GST_BUFFER_DURATION (buf), "cur-offset",
                G_TYPE_UINT64, GST_BUFFER_OFFSET (buf), "cur-offset-end",
                G_TYPE_UINT64, GST_BUFFER_OFFSET_END (buf), NULL)));
  } else {
    GST_DEBUG_OBJECT (identity, "can't check offset contiguity, no offset "
        "and/or offset_end were set on previous buffer");
  }
}

static const gchar *
print_pretty_time (gchar * ts_str, gsize ts_str_len, GstClockTime ts)
{
  if (ts == GST_CLOCK_TIME_NONE)
    return "none";

  g_snprintf (ts_str, ts_str_len, "%" GST_TIME_FORMAT, GST_TIME_ARGS (ts));
  return ts_str;
}

static void
gst_identity_update_last_message_for_buffer (GstIdentity * identity,
    const gchar * action, GstBuffer * buf, gsize size)
{
  gchar dts_str[64], pts_str[64], dur_str[64];
  gchar *flag_str;

  GST_OBJECT_LOCK (identity);

  flag_str = gst_buffer_get_flags_string (buf);

  g_free (identity->last_message);
  identity->last_message = g_strdup_printf ("%s   ******* (%s:%s) "
      "(%" G_GSIZE_FORMAT " bytes, dts: %s, pts:%s, duration: %s, offset: %"
      G_GINT64_FORMAT ", " "offset_end: % " G_GINT64_FORMAT
      ", flags: %08x %s) %p", action,
      GST_DEBUG_PAD_NAME (GST_BASE_TRANSFORM_CAST (identity)->sinkpad), size,
      print_pretty_time (dts_str, sizeof (dts_str), GST_BUFFER_DTS (buf)),
      print_pretty_time (pts_str, sizeof (pts_str), GST_BUFFER_PTS (buf)),
      print_pretty_time (dur_str, sizeof (dur_str), GST_BUFFER_DURATION (buf)),
      GST_BUFFER_OFFSET (buf), GST_BUFFER_OFFSET_END (buf),
      GST_BUFFER_FLAGS (buf), flag_str, buf);
  g_free (flag_str);

  GST_OBJECT_UNLOCK (identity);

  gst_identity_notify_last_message (identity);
}

static GstFlowReturn
gst_identity_transform_ip (GstBaseTransform * trans, GstBuffer * buf)
{
  GstFlowReturn ret = GST_FLOW_OK;
  GstIdentity *identity = GST_IDENTITY (trans);
  GstClockTime runtimestamp = G_GINT64_CONSTANT (0);
  gsize size;

  size = gst_buffer_get_size (buf);

  if (identity->check_imperfect_timestamp)
    gst_identity_check_imperfect_timestamp (identity, buf);
  if (identity->check_imperfect_offset)
    gst_identity_check_imperfect_offset (identity, buf);

  /* update prev values */
  identity->prev_timestamp = GST_BUFFER_TIMESTAMP (buf);
  identity->prev_duration = GST_BUFFER_DURATION (buf);
  identity->prev_offset_end = GST_BUFFER_OFFSET_END (buf);
  identity->prev_offset = GST_BUFFER_OFFSET (buf);

  if (identity->error_after >= 0) {
    identity->error_after--;
    if (identity->error_after == 0)
      goto error_after;
  }

  if (identity->drop_probability > 0.0) {
    if ((gfloat) (1.0 * rand () / (RAND_MAX)) < identity->drop_probability)
      goto dropped;
  }

  if (identity->dump) {
    GstMapInfo info;

    gst_buffer_map (buf, &info, GST_MAP_READ);
    gst_util_dump_mem (info.data, info.size);
    gst_buffer_unmap (buf, &info);
  }

  if (!identity->silent) {
    gst_identity_update_last_message_for_buffer (identity, "chain", buf, size);
  }

  if (identity->datarate > 0) {
    GstClockTime time = gst_util_uint64_scale_int (identity->offset,
        GST_SECOND, identity->datarate);

    GST_BUFFER_PTS (buf) = GST_BUFFER_DTS (buf) = time;
    GST_BUFFER_DURATION (buf) = size * GST_SECOND / identity->datarate;
  }

  if (identity->signal_handoffs)
    g_signal_emit (identity, gst_identity_signals[SIGNAL_HANDOFF], 0, buf);

  if (trans->segment.format == GST_FORMAT_TIME)
    runtimestamp = gst_segment_to_running_time (&trans->segment,
        GST_FORMAT_TIME, GST_BUFFER_TIMESTAMP (buf));

  if ((identity->sync) && (trans->segment.format == GST_FORMAT_TIME)) {
    GstClock *clock;

    GST_OBJECT_LOCK (identity);
    if ((clock = GST_ELEMENT (identity)->clock)) {
      GstClockReturn cret;
      GstClockTime timestamp;

      timestamp = runtimestamp + GST_ELEMENT (identity)->base_time;

      /* save id if we need to unlock */
      identity->clock_id = gst_clock_new_single_shot_id (clock, timestamp);
      GST_OBJECT_UNLOCK (identity);

      cret = gst_clock_id_wait (identity->clock_id, NULL);

      GST_OBJECT_LOCK (identity);
      if (identity->clock_id) {
        gst_clock_id_unref (identity->clock_id);
        identity->clock_id = NULL;
      }
      if (cret == GST_CLOCK_UNSCHEDULED)
        ret = GST_FLOW_EOS;
    }
    GST_OBJECT_UNLOCK (identity);
  }

  identity->offset += size;

  if (identity->sleep_time && ret == GST_FLOW_OK)
    g_usleep (identity->sleep_time);

  if (identity->single_segment && (trans->segment.format == GST_FORMAT_TIME)
      && (ret == GST_FLOW_OK)) {
    GST_BUFFER_PTS (buf) = GST_BUFFER_DTS (buf) = runtimestamp;
    GST_BUFFER_OFFSET (buf) = GST_CLOCK_TIME_NONE;
    GST_BUFFER_OFFSET_END (buf) = GST_CLOCK_TIME_NONE;
  }

  return ret;

  /* ERRORS */
error_after:
  {
    GST_ELEMENT_ERROR (identity, CORE, FAILED,
        (_("Failed after iterations as requested.")), (NULL));
    return GST_FLOW_ERROR;
  }
dropped:
  {
    if (!identity->silent) {
      gst_identity_update_last_message_for_buffer (identity, "dropping", buf,
          size);
    }
    /* return DROPPED to basetransform. */
    return GST_BASE_TRANSFORM_FLOW_DROPPED;
  }
}

static void
gst_identity_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstIdentity *identity;

  identity = GST_IDENTITY (object);

  switch (prop_id) {
    case PROP_SLEEP_TIME:
      identity->sleep_time = g_value_get_uint (value);
      break;
    case PROP_SILENT:
      identity->silent = g_value_get_boolean (value);
      break;
    case PROP_SINGLE_SEGMENT:
      identity->single_segment = g_value_get_boolean (value);
      break;
    case PROP_DUMP:
      identity->dump = g_value_get_boolean (value);
      break;
    case PROP_ERROR_AFTER:
      identity->error_after = g_value_get_int (value);
      break;
    case PROP_DROP_PROBABILITY:
      identity->drop_probability = g_value_get_float (value);
      break;
    case PROP_DATARATE:
      identity->datarate = g_value_get_int (value);
      break;
    case PROP_SYNC:
      identity->sync = g_value_get_boolean (value);
      break;
    case PROP_CHECK_IMPERFECT_TIMESTAMP:
      identity->check_imperfect_timestamp = g_value_get_boolean (value);
      break;
    case PROP_CHECK_IMPERFECT_OFFSET:
      identity->check_imperfect_offset = g_value_get_boolean (value);
      break;
    case PROP_SIGNAL_HANDOFFS:
      identity->signal_handoffs = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  if (identity->datarate > 0 || identity->single_segment)
    gst_base_transform_set_passthrough (GST_BASE_TRANSFORM (identity), FALSE);
  else
    gst_base_transform_set_passthrough (GST_BASE_TRANSFORM (identity), TRUE);
}

static void
gst_identity_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstIdentity *identity;

  identity = GST_IDENTITY (object);

  switch (prop_id) {
    case PROP_SLEEP_TIME:
      g_value_set_uint (value, identity->sleep_time);
      break;
    case PROP_ERROR_AFTER:
      g_value_set_int (value, identity->error_after);
      break;
    case PROP_DROP_PROBABILITY:
      g_value_set_float (value, identity->drop_probability);
      break;
    case PROP_DATARATE:
      g_value_set_int (value, identity->datarate);
      break;
    case PROP_SILENT:
      g_value_set_boolean (value, identity->silent);
      break;
    case PROP_SINGLE_SEGMENT:
      g_value_set_boolean (value, identity->single_segment);
      break;
    case PROP_DUMP:
      g_value_set_boolean (value, identity->dump);
      break;
    case PROP_LAST_MESSAGE:
      GST_OBJECT_LOCK (identity);
      g_value_set_string (value, identity->last_message);
      GST_OBJECT_UNLOCK (identity);
      break;
    case PROP_SYNC:
      g_value_set_boolean (value, identity->sync);
      break;
    case PROP_CHECK_IMPERFECT_TIMESTAMP:
      g_value_set_boolean (value, identity->check_imperfect_timestamp);
      break;
    case PROP_CHECK_IMPERFECT_OFFSET:
      g_value_set_boolean (value, identity->check_imperfect_offset);
      break;
    case PROP_SIGNAL_HANDOFFS:
      g_value_set_boolean (value, identity->signal_handoffs);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
gst_identity_start (GstBaseTransform * trans)
{
  GstIdentity *identity;

  identity = GST_IDENTITY (trans);

  identity->offset = 0;
  identity->prev_timestamp = GST_CLOCK_TIME_NONE;
  identity->prev_duration = GST_CLOCK_TIME_NONE;
  identity->prev_offset_end = GST_BUFFER_OFFSET_NONE;
  identity->prev_offset = GST_BUFFER_OFFSET_NONE;

  return TRUE;
}

static gboolean
gst_identity_stop (GstBaseTransform * trans)
{
  GstIdentity *identity;

  identity = GST_IDENTITY (trans);

  GST_OBJECT_LOCK (identity);
  g_free (identity->last_message);
  identity->last_message = NULL;
  GST_OBJECT_UNLOCK (identity);

  return TRUE;
}

static gboolean
gst_identity_accept_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps)
{
  gboolean ret;
  GstPad *pad;

  /* Proxy accept-caps */

  if (direction == GST_PAD_SRC)
    pad = GST_BASE_TRANSFORM_SINK_PAD (base);
  else
    pad = GST_BASE_TRANSFORM_SRC_PAD (base);

  ret = gst_pad_peer_query_accept_caps (pad, caps);

  return ret;
}

static GstStateChangeReturn
gst_identity_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstIdentity *identity = GST_IDENTITY (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_OBJECT_LOCK (identity);
      if (identity->clock_id) {
        GST_DEBUG_OBJECT (identity, "unlock clock wait");
        gst_clock_id_unschedule (identity->clock_id);
        gst_clock_id_unref (identity->clock_id);
        identity->clock_id = NULL;
      }
      GST_OBJECT_UNLOCK (identity);
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      break;
    default:
      break;
  }

  return ret;
}
