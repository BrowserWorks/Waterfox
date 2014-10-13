/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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
 * SECTION:element-videorate
 *
 * This element takes an incoming stream of timestamped video frames.
 * It will produce a perfect stream that matches the source pad's framerate.
 *
 * The correction is performed by dropping and duplicating frames, no fancy
 * algorithm is used to interpolate frames (yet).
 *
 * By default the element will simply negotiate the same framerate on its
 * source and sink pad.
 *
 * This operation is useful to link to elements that require a perfect stream.
 * Typical examples are formats that do not store timestamps for video frames,
 * but only store a framerate, like Ogg and AVI.
 *
 * A conversion to a specific framerate can be forced by using filtered caps on
 * the source pad.
 *
 * The properties #GstVideoRate:in, #GstVideoRate:out, #GstVideoRate:duplicate
 * and #GstVideoRate:drop can be read to obtain information about number of
 * input frames, output frames, dropped frames (i.e. the number of unused input
 * frames) and duplicated frames (i.e. the number of times an input frame was
 * duplicated, beside being used normally).
 *
 * An input stream that needs no adjustments will thus never have dropped or
 * duplicated frames.
 *
 * When the #GstVideoRate:silent property is set to FALSE, a GObject property
 * notification will be emitted whenever one of the #GstVideoRate:duplicate or
 * #GstVideoRate:drop values changes.
 * This can potentially cause performance degradation.
 * Note that property notification will happen from the streaming thread, so
 * applications should be prepared for this.
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch -v filesrc location=videotestsrc.ogg ! oggdemux ! theoradec ! videorate ! video/x-raw,framerate=15/1 ! xvimagesink
 * ]| Decode an Ogg/Theora file and adjust the framerate to 15 fps before playing.
 * To create the test Ogg/Theora file refer to the documentation of theoraenc.
 * |[
 * gst-launch -v v4l2src ! videorate ! video/x-raw,framerate=25/2 ! theoraenc ! oggmux ! filesink location=recording.ogg
 * ]| Capture video from a V4L device, and adjust the stream to 12.5 fps before
 * encoding to Ogg/Theora.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstvideorate.h"

GST_DEBUG_CATEGORY_STATIC (video_rate_debug);
#define GST_CAT_DEFAULT video_rate_debug

/* GstVideoRate signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

#define DEFAULT_SILENT          TRUE
#define DEFAULT_NEW_PREF        1.0
#define DEFAULT_SKIP_TO_FIRST   FALSE
#define DEFAULT_DROP_ONLY       FALSE
#define DEFAULT_AVERAGE_PERIOD  0
#define DEFAULT_MAX_RATE        G_MAXINT

enum
{
  PROP_0,
  PROP_IN,
  PROP_OUT,
  PROP_DUP,
  PROP_DROP,
  PROP_SILENT,
  PROP_NEW_PREF,
  PROP_SKIP_TO_FIRST,
  PROP_DROP_ONLY,
  PROP_AVERAGE_PERIOD,
  PROP_MAX_RATE
};

static GstStaticPadTemplate gst_video_rate_src_template =
    GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-raw;" "image/jpeg;" "image/png")
    );

static GstStaticPadTemplate gst_video_rate_sink_template =
    GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("video/x-raw;" "image/jpeg;" "image/png")
    );

static void gst_video_rate_swap_prev (GstVideoRate * videorate,
    GstBuffer * buffer, gint64 time);
static gboolean gst_video_rate_sink_event (GstBaseTransform * trans,
    GstEvent * event);
static gboolean gst_video_rate_query (GstBaseTransform * trans,
    GstPadDirection direction, GstQuery * query);

static gboolean gst_video_rate_setcaps (GstBaseTransform * trans,
    GstCaps * in_caps, GstCaps * out_caps);

static GstCaps *gst_video_rate_transform_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter);

static GstCaps *gst_video_rate_fixate_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * othercaps);

static GstFlowReturn gst_video_rate_transform_ip (GstBaseTransform * trans,
    GstBuffer * buf);

static gboolean gst_video_rate_start (GstBaseTransform * trans);
static gboolean gst_video_rate_stop (GstBaseTransform * trans);


static void gst_video_rate_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_video_rate_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GParamSpec *pspec_drop = NULL;
static GParamSpec *pspec_duplicate = NULL;

#define gst_video_rate_parent_class parent_class
G_DEFINE_TYPE (GstVideoRate, gst_video_rate, GST_TYPE_BASE_TRANSFORM);

static void
gst_video_rate_class_init (GstVideoRateClass * klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstBaseTransformClass *base_class = GST_BASE_TRANSFORM_CLASS (klass);

  object_class->set_property = gst_video_rate_set_property;
  object_class->get_property = gst_video_rate_get_property;

  base_class->set_caps = GST_DEBUG_FUNCPTR (gst_video_rate_setcaps);
  base_class->transform_caps =
      GST_DEBUG_FUNCPTR (gst_video_rate_transform_caps);
  base_class->transform_ip = GST_DEBUG_FUNCPTR (gst_video_rate_transform_ip);
  base_class->sink_event = GST_DEBUG_FUNCPTR (gst_video_rate_sink_event);
  base_class->start = GST_DEBUG_FUNCPTR (gst_video_rate_start);
  base_class->stop = GST_DEBUG_FUNCPTR (gst_video_rate_stop);
  base_class->fixate_caps = GST_DEBUG_FUNCPTR (gst_video_rate_fixate_caps);
  base_class->query = GST_DEBUG_FUNCPTR (gst_video_rate_query);

  g_object_class_install_property (object_class, PROP_IN,
      g_param_spec_uint64 ("in", "In",
          "Number of input frames", 0, G_MAXUINT64, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (object_class, PROP_OUT,
      g_param_spec_uint64 ("out", "Out", "Number of output frames", 0,
          G_MAXUINT64, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  pspec_duplicate = g_param_spec_uint64 ("duplicate", "Duplicate",
      "Number of duplicated frames", 0, G_MAXUINT64, 0,
      G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (object_class, PROP_DUP, pspec_duplicate);
  pspec_drop = g_param_spec_uint64 ("drop", "Drop", "Number of dropped frames",
      0, G_MAXUINT64, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (object_class, PROP_DROP, pspec_drop);
  g_object_class_install_property (object_class, PROP_SILENT,
      g_param_spec_boolean ("silent", "silent",
          "Don't emit notify for dropped and duplicated frames", DEFAULT_SILENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (object_class, PROP_NEW_PREF,
      g_param_spec_double ("new-pref", "New Pref",
          "Value indicating how much to prefer new frames (unused)", 0.0, 1.0,
          DEFAULT_NEW_PREF, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstVideoRate:skip-to-first:
   * 
   * Don't produce buffers before the first one we receive.
   */
  g_object_class_install_property (object_class, PROP_SKIP_TO_FIRST,
      g_param_spec_boolean ("skip-to-first", "Skip to first buffer",
          "Don't produce buffers before the first one we receive",
          DEFAULT_SKIP_TO_FIRST, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstVideoRate:drop-only:
   *
   * Only drop frames, no duplicates are produced.
   */
  g_object_class_install_property (object_class, PROP_DROP_ONLY,
      g_param_spec_boolean ("drop-only", "Only Drop",
          "Only drop frames, no duplicates are produced",
          DEFAULT_DROP_ONLY, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstVideoRate:average-period:
   *
   * Arrange for maximum framerate by dropping frames beyond a certain framerate,
   * where the framerate is calculated using a moving average over the
   * configured.
   */
  g_object_class_install_property (object_class, PROP_AVERAGE_PERIOD,
      g_param_spec_uint64 ("average-period", "Period over which to average",
          "Period over which to average the framerate (in ns) (0 = disabled)",
          0, G_MAXINT64, DEFAULT_AVERAGE_PERIOD,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstVideoRate:max-rate:
   *
   * maximum framerate to pass through
   */
  g_object_class_install_property (object_class, PROP_MAX_RATE,
      g_param_spec_int ("max-rate", "maximum framerate",
          "Maximum framerate allowed to pass through "
          "(in frames per second, implies drop-only)",
          1, G_MAXINT, DEFAULT_MAX_RATE,
          G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (element_class,
      "Video rate adjuster", "Filter/Effect/Video",
      "Drops/duplicates/adjusts timestamps on video frames to make a perfect stream",
      "Wim Taymans <wim@fluendo.com>");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_video_rate_sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_video_rate_src_template));
}

static void
gst_value_fraction_get_extremes (const GValue * v,
    gint * min_num, gint * min_denom, gint * max_num, gint * max_denom)
{
  if (GST_VALUE_HOLDS_FRACTION (v)) {
    *min_num = *max_num = gst_value_get_fraction_numerator (v);
    *min_denom = *max_denom = gst_value_get_fraction_denominator (v);
  } else if (GST_VALUE_HOLDS_FRACTION_RANGE (v)) {
    const GValue *min, *max;

    min = gst_value_get_fraction_range_min (v);
    *min_num = gst_value_get_fraction_numerator (min);
    *min_denom = gst_value_get_fraction_denominator (min);

    max = gst_value_get_fraction_range_max (v);
    *max_num = gst_value_get_fraction_numerator (max);
    *max_denom = gst_value_get_fraction_denominator (max);
  } else if (GST_VALUE_HOLDS_LIST (v)) {
    gint min_n = G_MAXINT, min_d = 1, max_n = 0, max_d = 1;
    int i, n;

    *min_num = G_MAXINT;
    *min_denom = 1;
    *max_num = 0;
    *max_denom = 1;

    n = gst_value_list_get_size (v);

    g_assert (n > 0);

    for (i = 0; i < n; i++) {
      const GValue *t = gst_value_list_get_value (v, i);

      gst_value_fraction_get_extremes (t, &min_n, &min_d, &max_n, &max_d);
      if (gst_util_fraction_compare (min_n, min_d, *min_num, *min_denom) < 0) {
        *min_num = min_n;
        *min_denom = min_d;
      }

      if (gst_util_fraction_compare (max_n, max_d, *max_num, *max_denom) > 0) {
        *max_num = max_n;
        *max_denom = max_d;
      }
    }
  } else {
    g_warning ("Unknown type for framerate");
    *min_num = 0;
    *min_denom = 1;
    *max_num = G_MAXINT;
    *max_denom = 1;
  }
}

/* Clamp the framerate in a caps structure to be a smaller range then
 * [1...max_rate], otherwise return false */
static gboolean
gst_video_max_rate_clamp_structure (GstStructure * s, gint maxrate,
    gint * min_num, gint * min_denom, gint * max_num, gint * max_denom)
{
  gboolean ret = FALSE;

  if (!gst_structure_has_field (s, "framerate")) {
    /* No framerate field implies any framerate, clamping would result in
     * [1..max_rate] so not a real subset */
    goto out;
  } else {
    const GValue *v;
    GValue intersection = { 0, };
    GValue clamp = { 0, };
    gint tmp_num, tmp_denom;

    g_value_init (&clamp, GST_TYPE_FRACTION_RANGE);
    gst_value_set_fraction_range_full (&clamp, 0, 1, maxrate, 1);

    v = gst_structure_get_value (s, "framerate");
    ret = gst_value_intersect (&intersection, v, &clamp);
    g_value_unset (&clamp);

    if (!ret)
      goto out;

    gst_value_fraction_get_extremes (&intersection,
        min_num, min_denom, max_num, max_denom);

    gst_value_fraction_get_extremes (v,
        &tmp_num, &tmp_denom, max_num, max_denom);

    if (gst_util_fraction_compare (*max_num, *max_denom, maxrate, 1) > 0) {
      *max_num = maxrate;
      *max_denom = 1;
    }

    gst_structure_take_value (s, "framerate", &intersection);
  }

out:
  return ret;
}

static GstCaps *
gst_video_rate_transform_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter)
{
  GstVideoRate *videorate = GST_VIDEO_RATE (trans);
  GstCaps *ret;
  GstStructure *s, *s1, *s2, *s3 = NULL;
  int maxrate = g_atomic_int_get (&videorate->max_rate);
  gint i;

  ret = gst_caps_new_empty ();

  for (i = 0; i < gst_caps_get_size (caps); i++) {
    s = gst_caps_get_structure (caps, i);

    s1 = gst_structure_copy (s);
    s2 = gst_structure_copy (s);

    if (videorate->drop_only) {
      gint min_num = 0, min_denom = 1;
      gint max_num = G_MAXINT, max_denom = 1;

      /* Clamp the caps to our maximum rate as the first caps if possible */
      if (!gst_video_max_rate_clamp_structure (s1, maxrate,
              &min_num, &min_denom, &max_num, &max_denom)) {
        min_num = 0;
        min_denom = 1;
        max_num = maxrate;
        max_denom = 1;

        /* clamp wouldn't be a real subset of 1..maxrate, in this case the sink
         * caps should become [1..maxrate], [1..maxint] and the src caps just
         * [1..maxrate].  In case there was a caps incompatibility things will
         * explode later as appropriate :)
         *
         * In case [X..maxrate] == [X..maxint], skip as we'll set it later
         */
        if (direction == GST_PAD_SRC && maxrate != G_MAXINT)
          gst_structure_set (s1, "framerate", GST_TYPE_FRACTION_RANGE,
              min_num, min_denom, maxrate, 1, NULL);
        else {
          gst_structure_free (s1);
          s1 = NULL;
        }
      }

      if (direction == GST_PAD_SRC) {
        /* We can accept anything as long as it's at least the minimal framerate
         * the the sink needs */
        gst_structure_set (s2, "framerate", GST_TYPE_FRACTION_RANGE,
            min_num, min_denom, G_MAXINT, 1, NULL);

        /* Also allow unknown framerate, if it isn't already */
        if (min_num != 0 || min_denom != 1) {
          s3 = gst_structure_copy (s);
          gst_structure_set (s3, "framerate", GST_TYPE_FRACTION, 0, 1, NULL);
        }
      } else if (max_num != 0 || max_denom != 1) {
        /* We can provide everything upto the maximum framerate at the src */
        gst_structure_set (s2, "framerate", GST_TYPE_FRACTION_RANGE,
            0, 1, max_num, max_denom, NULL);
      }
    } else if (direction == GST_PAD_SINK) {
      gint min_num = 0, min_denom = 1;
      gint max_num = G_MAXINT, max_denom = 1;

      if (!gst_video_max_rate_clamp_structure (s1, maxrate,
              &min_num, &min_denom, &max_num, &max_denom)) {
        gst_structure_free (s1);
        s1 = NULL;
      }
      gst_structure_set (s2, "framerate", GST_TYPE_FRACTION_RANGE, 0, 1,
          maxrate, 1, NULL);
    } else {
      /* set the framerate as a range */
      gst_structure_set (s2, "framerate", GST_TYPE_FRACTION_RANGE, 0, 1,
          G_MAXINT, 1, NULL);
    }
    if (s1 != NULL)
      ret = gst_caps_merge_structure (ret, s1);
    ret = gst_caps_merge_structure (ret, s2);
    if (s3 != NULL)
      ret = gst_caps_merge_structure (ret, s3);
  }
  if (filter) {
    GstCaps *intersection;

    intersection =
        gst_caps_intersect_full (filter, ret, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (ret);
    ret = intersection;
  }
  return ret;
}

static GstCaps *
gst_video_rate_fixate_caps (GstBaseTransform * trans,
    GstPadDirection direction, GstCaps * caps, GstCaps * othercaps)
{
  GstStructure *s;
  gint num, denom;

  s = gst_caps_get_structure (caps, 0);
  if (G_UNLIKELY (!gst_structure_get_fraction (s, "framerate", &num, &denom)))
    return othercaps;

  othercaps = gst_caps_truncate (othercaps);
  othercaps = gst_caps_make_writable (othercaps);
  s = gst_caps_get_structure (othercaps, 0);
  gst_structure_fixate_field_nearest_fraction (s, "framerate", num, denom);

  return othercaps;
}

static gboolean
gst_video_rate_setcaps (GstBaseTransform * trans, GstCaps * in_caps,
    GstCaps * out_caps)
{
  GstVideoRate *videorate = GST_VIDEO_RATE (trans);
  GstStructure *structure;
  gboolean ret = TRUE;
  gint rate_numerator, rate_denominator;

  GST_DEBUG_OBJECT (trans, "setcaps called in: %" GST_PTR_FORMAT
      " out: %" GST_PTR_FORMAT, in_caps, out_caps);

  structure = gst_caps_get_structure (in_caps, 0);
  if (!gst_structure_get_fraction (structure, "framerate",
          &rate_numerator, &rate_denominator))
    goto no_framerate;

  videorate->from_rate_numerator = rate_numerator;
  videorate->from_rate_denominator = rate_denominator;

  structure = gst_caps_get_structure (out_caps, 0);
  if (!gst_structure_get_fraction (structure, "framerate",
          &rate_numerator, &rate_denominator))
    goto no_framerate;

  /* out_frame_count is scaled by the frame rate caps when calculating next_ts.
   * when the frame rate caps change, we must update base_ts and reset
   * out_frame_count */
  if (videorate->to_rate_numerator) {
    videorate->base_ts +=
        gst_util_uint64_scale (videorate->out_frame_count,
        videorate->to_rate_denominator * GST_SECOND,
        videorate->to_rate_numerator);
  }
  videorate->out_frame_count = 0;
  videorate->to_rate_numerator = rate_numerator;
  videorate->to_rate_denominator = rate_denominator;

  if (rate_numerator)
    videorate->wanted_diff = gst_util_uint64_scale_int (GST_SECOND,
        rate_denominator, rate_numerator);
  else
    videorate->wanted_diff = 0;

done:
  /* After a setcaps, our caps may have changed. In that case, we can't use
   * the old buffer, if there was one (it might have different dimensions) */
  GST_DEBUG_OBJECT (videorate, "swapping old buffers");
  gst_video_rate_swap_prev (videorate, NULL, GST_CLOCK_TIME_NONE);
  videorate->last_ts = GST_CLOCK_TIME_NONE;
  videorate->average = 0;

  return ret;

no_framerate:
  {
    GST_DEBUG_OBJECT (videorate, "no framerate specified");
    ret = FALSE;
    goto done;
  }
}

static void
gst_video_rate_reset (GstVideoRate * videorate)
{
  GST_DEBUG_OBJECT (videorate, "resetting internal variables");

  videorate->in = 0;
  videorate->out = 0;
  videorate->base_ts = 0;
  videorate->out_frame_count = 0;
  videorate->drop = 0;
  videorate->dup = 0;
  videorate->next_ts = GST_CLOCK_TIME_NONE;
  videorate->last_ts = GST_CLOCK_TIME_NONE;
  videorate->discont = TRUE;
  videorate->average = 0;
  gst_video_rate_swap_prev (videorate, NULL, 0);

  gst_segment_init (&videorate->segment, GST_FORMAT_TIME);
}

static void
gst_video_rate_init (GstVideoRate * videorate)
{
  gst_video_rate_reset (videorate);
  videorate->silent = DEFAULT_SILENT;
  videorate->new_pref = DEFAULT_NEW_PREF;
  videorate->drop_only = DEFAULT_DROP_ONLY;
  videorate->average_period = DEFAULT_AVERAGE_PERIOD;
  videorate->average_period_set = DEFAULT_AVERAGE_PERIOD;
  videorate->max_rate = DEFAULT_MAX_RATE;

  videorate->from_rate_numerator = 0;
  videorate->from_rate_denominator = 0;
  videorate->to_rate_numerator = 0;
  videorate->to_rate_denominator = 0;

  gst_base_transform_set_gap_aware (GST_BASE_TRANSFORM (videorate), TRUE);
}

/* flush the oldest buffer */
static GstFlowReturn
gst_video_rate_flush_prev (GstVideoRate * videorate, gboolean duplicate)
{
  GstFlowReturn res;
  GstBuffer *outbuf;
  GstClockTime push_ts;

  if (!videorate->prevbuf)
    goto eos_before_buffers;

  /* make sure we can write to the metadata */
  outbuf = gst_buffer_make_writable (gst_buffer_ref (videorate->prevbuf));

  GST_BUFFER_OFFSET (outbuf) = videorate->out;
  GST_BUFFER_OFFSET_END (outbuf) = videorate->out + 1;

  if (videorate->discont) {
    GST_BUFFER_FLAG_SET (outbuf, GST_BUFFER_FLAG_DISCONT);
    videorate->discont = FALSE;
  } else
    GST_BUFFER_FLAG_UNSET (outbuf, GST_BUFFER_FLAG_DISCONT);

  if (duplicate)
    GST_BUFFER_FLAG_SET (outbuf, GST_BUFFER_FLAG_GAP);
  else
    GST_BUFFER_FLAG_UNSET (outbuf, GST_BUFFER_FLAG_GAP);

  /* this is the timestamp we put on the buffer */
  push_ts = videorate->next_ts;

  videorate->out++;
  videorate->out_frame_count++;
  if (videorate->to_rate_numerator) {
    /* interpolate next expected timestamp in the segment */
    videorate->next_ts =
        videorate->segment.base + videorate->segment.start +
        videorate->base_ts + gst_util_uint64_scale (videorate->out_frame_count,
        videorate->to_rate_denominator * GST_SECOND,
        videorate->to_rate_numerator);
    GST_BUFFER_DURATION (outbuf) = videorate->next_ts - push_ts;
  }

  /* We do not need to update time in VFR (variable frame rate) mode */
  if (!videorate->drop_only) {
    /* adapt for looping, bring back to time in current segment. */
    GST_BUFFER_TIMESTAMP (outbuf) = push_ts - videorate->segment.base;
  }

  GST_LOG_OBJECT (videorate,
      "old is best, dup, pushing buffer outgoing ts %" GST_TIME_FORMAT,
      GST_TIME_ARGS (push_ts));

  res = gst_pad_push (GST_BASE_TRANSFORM_SRC_PAD (videorate), outbuf);

  return res;

  /* WARNINGS */
eos_before_buffers:
  {
    GST_INFO_OBJECT (videorate, "got EOS before any buffer was received");
    return GST_FLOW_OK;
  }
}

static void
gst_video_rate_swap_prev (GstVideoRate * videorate, GstBuffer * buffer,
    gint64 time)
{
  GST_LOG_OBJECT (videorate, "swap_prev: storing buffer %p in prev", buffer);
  if (videorate->prevbuf)
    gst_buffer_unref (videorate->prevbuf);
  videorate->prevbuf = buffer != NULL ? gst_buffer_ref (buffer) : NULL;
  videorate->prev_ts = time;
}

static void
gst_video_rate_notify_drop (GstVideoRate * videorate)
{
  g_object_notify_by_pspec ((GObject *) videorate, pspec_drop);
}

static void
gst_video_rate_notify_duplicate (GstVideoRate * videorate)
{
  g_object_notify_by_pspec ((GObject *) videorate, pspec_duplicate);
}

#define MAGIC_LIMIT  25
static gboolean
gst_video_rate_sink_event (GstBaseTransform * trans, GstEvent * event)
{
  GstVideoRate *videorate;

  videorate = GST_VIDEO_RATE (trans);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEGMENT:
    {
      const GstSegment *segment;

      gst_event_parse_segment (event, &segment);

      if (segment->format != GST_FORMAT_TIME)
        goto format_error;

      GST_DEBUG_OBJECT (videorate, "handle NEWSEGMENT");

      /* close up the previous segment, if appropriate */
      if (videorate->prevbuf) {
        gint count = 0;
        GstFlowReturn res;

        res = GST_FLOW_OK;
        /* fill up to the end of current segment,
         * or only send out the stored buffer if there is no specific stop.
         * regardless, prevent going loopy in strange cases */
        while (res == GST_FLOW_OK && count <= MAGIC_LIMIT &&
            ((GST_CLOCK_TIME_IS_VALID (videorate->segment.stop) &&
                    videorate->next_ts - videorate->segment.base
                    < videorate->segment.stop)
                || count < 1)) {
          res = gst_video_rate_flush_prev (videorate, count > 0);
          count++;
        }
        if (count > 1) {
          videorate->dup += count - 1;
          if (!videorate->silent)
            gst_video_rate_notify_duplicate (videorate);
        } else if (count == 0) {
          videorate->drop++;
          if (!videorate->silent)
            gst_video_rate_notify_drop (videorate);
        }
        /* clean up for the new one; _chain will resume from the new start */
        gst_video_rate_swap_prev (videorate, NULL, 0);
      }

      videorate->base_ts = 0;
      videorate->out_frame_count = 0;
      videorate->next_ts = GST_CLOCK_TIME_NONE;

      /* We just want to update the accumulated stream_time  */
      gst_segment_copy_into (segment, &videorate->segment);

      GST_DEBUG_OBJECT (videorate, "updated segment: %" GST_SEGMENT_FORMAT,
          &videorate->segment);
      break;
    }
    case GST_EVENT_EOS:{
      gint count = 0;
      GstFlowReturn res = GST_FLOW_OK;

      GST_DEBUG_OBJECT (videorate, "Got EOS");

      /* If the segment has a stop position, fill the segment */
      if (GST_CLOCK_TIME_IS_VALID (videorate->segment.stop)) {
        /* fill up to the end of current segment,
         * or only send out the stored buffer if there is no specific stop.
         * regardless, prevent going loopy in strange cases */
        while (res == GST_FLOW_OK && count <= MAGIC_LIMIT &&
            ((videorate->next_ts - videorate->segment.base <
                    videorate->segment.stop)
                || count < 1)) {
          res = gst_video_rate_flush_prev (videorate, count > 0);
          count++;
        }
      } else if (videorate->prevbuf) {
        /* Output at least one frame but if the buffer duration is valid, output
         * enough frames to use the complete buffer duration */
        if (GST_BUFFER_DURATION_IS_VALID (videorate->prevbuf)) {
          GstClockTime end_ts =
              videorate->next_ts + GST_BUFFER_DURATION (videorate->prevbuf);

          while (res == GST_FLOW_OK && count <= MAGIC_LIMIT &&
              ((videorate->next_ts - videorate->segment.base < end_ts)
                  || count < 1)) {
            res = gst_video_rate_flush_prev (videorate, count > 0);
            count++;
          }
        } else {
          res = gst_video_rate_flush_prev (videorate, FALSE);
          count = 1;
        }
      }

      if (count > 1) {
        videorate->dup += count - 1;
        if (!videorate->silent)
          gst_video_rate_notify_duplicate (videorate);
      } else if (count == 0) {
        videorate->drop++;
        if (!videorate->silent)
          gst_video_rate_notify_drop (videorate);
      }

      break;
    }
    case GST_EVENT_FLUSH_STOP:
      /* also resets the segment */
      GST_DEBUG_OBJECT (videorate, "Got FLUSH_STOP");
      gst_video_rate_reset (videorate);
      break;
    case GST_EVENT_GAP:
      /* no gaps after videorate, ignore the event */
      gst_event_unref (event);
      return TRUE;
    default:
      break;
  }

  return GST_BASE_TRANSFORM_CLASS (parent_class)->sink_event (trans, event);

  /* ERRORS */
format_error:
  {
    GST_WARNING_OBJECT (videorate,
        "Got segment but doesn't have GST_FORMAT_TIME value");
    return FALSE;
  }
}

static gboolean
gst_video_rate_query (GstBaseTransform * trans, GstPadDirection direction,
    GstQuery * query)
{
  GstVideoRate *videorate = GST_VIDEO_RATE (trans);
  gboolean res = FALSE;
  GstPad *otherpad;

  otherpad = (direction == GST_PAD_SRC) ?
      GST_BASE_TRANSFORM_SINK_PAD (trans) : GST_BASE_TRANSFORM_SRC_PAD (trans);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_LATENCY:
    {
      GstClockTime min, max;
      gboolean live;
      guint64 latency;
      guint64 avg_period;
      GstPad *peer;

      GST_OBJECT_LOCK (videorate);
      avg_period = videorate->average_period_set;
      GST_OBJECT_UNLOCK (videorate);

      if (avg_period == 0 && (peer = gst_pad_get_peer (otherpad))) {
        if ((res = gst_pad_query (peer, query))) {
          gst_query_parse_latency (query, &live, &min, &max);

          GST_DEBUG_OBJECT (videorate, "Peer latency: min %"
              GST_TIME_FORMAT " max %" GST_TIME_FORMAT,
              GST_TIME_ARGS (min), GST_TIME_ARGS (max));

          if (videorate->from_rate_numerator != 0) {
            /* add latency. We don't really know since we hold on to the frames
             * until we get a next frame, which can be anything. We assume
             * however that this will take from_rate time. */
            latency = gst_util_uint64_scale (GST_SECOND,
                videorate->from_rate_denominator,
                videorate->from_rate_numerator);
          } else {
            /* no input framerate, we don't know */
            latency = 0;
          }

          GST_DEBUG_OBJECT (videorate, "Our latency: %"
              GST_TIME_FORMAT, GST_TIME_ARGS (latency));

          min += latency;
          if (max != -1)
            max += latency;

          GST_DEBUG_OBJECT (videorate, "Calculated total latency : min %"
              GST_TIME_FORMAT " max %" GST_TIME_FORMAT,
              GST_TIME_ARGS (min), GST_TIME_ARGS (max));

          gst_query_set_latency (query, live, min, max);
        }
        gst_object_unref (peer);
        break;
      }
      /* Simple fallthrough if we don't have a latency or not a peer that we
       * can't ask about its latency yet.. */
    }
    default:
      res =
          GST_BASE_TRANSFORM_CLASS (parent_class)->query (trans, direction,
          query);
      break;
  }

  return res;
}

static GstFlowReturn
gst_video_rate_trans_ip_max_avg (GstVideoRate * videorate, GstBuffer * buf)
{
  GstClockTime ts = GST_BUFFER_TIMESTAMP (buf);

  videorate->in++;

  if (!GST_CLOCK_TIME_IS_VALID (ts) || videorate->wanted_diff == 0)
    goto push;

  /* drop frames if they exceed our output rate */
  if (GST_CLOCK_TIME_IS_VALID (videorate->last_ts)) {
    GstClockTimeDiff diff = ts - videorate->last_ts;

    /* Drop buffer if its early compared to the desired frame rate and
     * the current average is higher than the desired average
     */
    if (diff < videorate->wanted_diff &&
        videorate->average < videorate->wanted_diff)
      goto drop;

    /* Update average */
    if (videorate->average) {
      GstClockTimeDiff wanted_diff;

      if (G_LIKELY (videorate->average_period > videorate->wanted_diff))
        wanted_diff = videorate->wanted_diff;
      else
        wanted_diff = videorate->average_period * 10;

      videorate->average =
          gst_util_uint64_scale_round (videorate->average,
          videorate->average_period - wanted_diff,
          videorate->average_period) +
          gst_util_uint64_scale_round (diff, wanted_diff,
          videorate->average_period);
    } else {
      videorate->average = diff;
    }
  }

  videorate->last_ts = ts;

push:
  videorate->out++;
  return GST_FLOW_OK;

drop:
  if (!videorate->silent)
    gst_video_rate_notify_drop (videorate);
  return GST_BASE_TRANSFORM_FLOW_DROPPED;
}

static GstFlowReturn
gst_video_rate_transform_ip (GstBaseTransform * trans, GstBuffer * buffer)
{
  GstVideoRate *videorate;
  GstFlowReturn res = GST_BASE_TRANSFORM_FLOW_DROPPED;
  GstClockTime intime, in_ts, in_dur;
  GstClockTime avg_period;
  gboolean skip = FALSE;

  videorate = GST_VIDEO_RATE (trans);

  /* make sure the denominators are not 0 */
  if (videorate->from_rate_denominator == 0 ||
      videorate->to_rate_denominator == 0)
    goto not_negotiated;

  GST_OBJECT_LOCK (videorate);
  avg_period = videorate->average_period_set;
  GST_OBJECT_UNLOCK (videorate);

  /* MT-safe switching between modes */
  if (G_UNLIKELY (avg_period != videorate->average_period)) {
    gboolean switch_mode = (avg_period == 0 || videorate->average_period == 0);
    videorate->average_period = avg_period;
    videorate->last_ts = GST_CLOCK_TIME_NONE;

    if (switch_mode) {
      if (avg_period) {
        /* enabling average mode */
        videorate->average = 0;
        /* make sure no cached buffers from regular mode are left */
        gst_video_rate_swap_prev (videorate, NULL, 0);
      } else {
        /* enable regular mode */
        videorate->next_ts = GST_CLOCK_TIME_NONE;
        skip = TRUE;
      }

      /* max averaging mode has a no latency, normal mode does */
      gst_element_post_message (GST_ELEMENT (videorate),
          gst_message_new_latency (GST_OBJECT (videorate)));
    }
  }

  if (videorate->average_period > 0)
    return gst_video_rate_trans_ip_max_avg (videorate, buffer);

  in_ts = GST_BUFFER_TIMESTAMP (buffer);
  in_dur = GST_BUFFER_DURATION (buffer);

  if (G_UNLIKELY (in_ts == GST_CLOCK_TIME_NONE)) {
    in_ts = videorate->last_ts;
    if (G_UNLIKELY (in_ts == GST_CLOCK_TIME_NONE))
      goto invalid_buffer;
  }

  /* get the time of the next expected buffer timestamp, we use this when the
   * next buffer has -1 as a timestamp */
  videorate->last_ts = in_ts;
  if (in_dur != GST_CLOCK_TIME_NONE)
    videorate->last_ts += in_dur;

  GST_DEBUG_OBJECT (videorate, "got buffer with timestamp %" GST_TIME_FORMAT,
      GST_TIME_ARGS (in_ts));

  /* the input time is the time in the segment + all previously accumulated
   * segments */
  intime = in_ts + videorate->segment.base;

  /* we need to have two buffers to compare */
  if (videorate->prevbuf == NULL) {
    gst_video_rate_swap_prev (videorate, buffer, intime);
    videorate->in++;
    if (!GST_CLOCK_TIME_IS_VALID (videorate->next_ts)) {
      /* new buffer, we expect to output a buffer that matches the first
       * timestamp in the segment */
      if (videorate->skip_to_first || skip) {
        videorate->next_ts = intime;
        videorate->base_ts = in_ts - videorate->segment.start;
        videorate->out_frame_count = 0;
      } else {
        videorate->next_ts = videorate->segment.start + videorate->segment.base;
      }
    }
  } else {
    GstClockTime prevtime;
    gint count = 0;
    gint64 diff1, diff2;

    prevtime = videorate->prev_ts;

    GST_LOG_OBJECT (videorate,
        "BEGINNING prev buf %" GST_TIME_FORMAT " new buf %" GST_TIME_FORMAT
        " outgoing ts %" GST_TIME_FORMAT, GST_TIME_ARGS (prevtime),
        GST_TIME_ARGS (intime), GST_TIME_ARGS (videorate->next_ts));

    videorate->in++;

    /* drop new buffer if it's before previous one */
    if (intime < prevtime) {
      GST_DEBUG_OBJECT (videorate,
          "The new buffer (%" GST_TIME_FORMAT
          ") is before the previous buffer (%"
          GST_TIME_FORMAT "). Dropping new buffer.",
          GST_TIME_ARGS (intime), GST_TIME_ARGS (prevtime));
      videorate->drop++;
      if (!videorate->silent)
        gst_video_rate_notify_drop (videorate);
      goto done;
    }

    /* got 2 buffers, see which one is the best */
    do {

      diff1 = prevtime - videorate->next_ts;
      diff2 = intime - videorate->next_ts;

      /* take absolute values, beware: abs and ABS don't work for gint64 */
      if (diff1 < 0)
        diff1 = -diff1;
      if (diff2 < 0)
        diff2 = -diff2;

      GST_LOG_OBJECT (videorate,
          "diff with prev %" GST_TIME_FORMAT " diff with new %"
          GST_TIME_FORMAT " outgoing ts %" GST_TIME_FORMAT,
          GST_TIME_ARGS (diff1), GST_TIME_ARGS (diff2),
          GST_TIME_ARGS (videorate->next_ts));

      /* output first one when its the best */
      if (diff1 <= diff2) {
        GstFlowReturn r;
        count++;

        /* on error the _flush function posted a warning already */
        if ((r = gst_video_rate_flush_prev (videorate,
                    count > 1)) != GST_FLOW_OK) {
          res = r;
          goto done;
        }
      }

      /* Do not produce any dups. We can exit loop now */
      if (videorate->drop_only)
        break;
      /* continue while the first one was the best, if they were equal avoid
       * going into an infinite loop */
    }
    while (diff1 < diff2);

    /* if we outputed the first buffer more then once, we have dups */
    if (count > 1) {
      videorate->dup += count - 1;
      if (!videorate->silent)
        gst_video_rate_notify_duplicate (videorate);
    }
    /* if we didn't output the first buffer, we have a drop */
    else if (count == 0) {
      videorate->drop++;

      if (!videorate->silent)
        gst_video_rate_notify_drop (videorate);

      GST_LOG_OBJECT (videorate,
          "new is best, old never used, drop, outgoing ts %"
          GST_TIME_FORMAT, GST_TIME_ARGS (videorate->next_ts));
    }
    GST_LOG_OBJECT (videorate,
        "END, putting new in old, diff1 %" GST_TIME_FORMAT
        ", diff2 %" GST_TIME_FORMAT ", next_ts %" GST_TIME_FORMAT
        ", in %" G_GUINT64_FORMAT ", out %" G_GUINT64_FORMAT ", drop %"
        G_GUINT64_FORMAT ", dup %" G_GUINT64_FORMAT, GST_TIME_ARGS (diff1),
        GST_TIME_ARGS (diff2), GST_TIME_ARGS (videorate->next_ts),
        videorate->in, videorate->out, videorate->drop, videorate->dup);

    /* swap in new one when it's the best */
    gst_video_rate_swap_prev (videorate, buffer, intime);
  }
done:
  return res;

  /* ERRORS */
not_negotiated:
  {
    GST_WARNING_OBJECT (videorate, "no framerate negotiated");
    res = GST_FLOW_NOT_NEGOTIATED;
    goto done;
  }

invalid_buffer:
  {
    GST_WARNING_OBJECT (videorate,
        "Got buffer with GST_CLOCK_TIME_NONE timestamp, discarding it");
    res = GST_BASE_TRANSFORM_FLOW_DROPPED;
    goto done;
  }
}

static gboolean
gst_video_rate_start (GstBaseTransform * trans)
{
  gst_video_rate_reset (GST_VIDEO_RATE (trans));
  return TRUE;
}

static gboolean
gst_video_rate_stop (GstBaseTransform * trans)
{
  gst_video_rate_reset (GST_VIDEO_RATE (trans));
  return TRUE;
}

static void
gst_video_rate_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstVideoRate *videorate = GST_VIDEO_RATE (object);

  GST_OBJECT_LOCK (videorate);
  switch (prop_id) {
    case PROP_SILENT:
      videorate->silent = g_value_get_boolean (value);
      break;
    case PROP_NEW_PREF:
      videorate->new_pref = g_value_get_double (value);
      break;
    case PROP_SKIP_TO_FIRST:
      videorate->skip_to_first = g_value_get_boolean (value);
      break;
    case PROP_DROP_ONLY:
      videorate->drop_only = g_value_get_boolean (value);
      goto reconfigure;
      break;
    case PROP_AVERAGE_PERIOD:
      videorate->average_period_set = g_value_get_uint64 (value);
      break;
    case PROP_MAX_RATE:
      g_atomic_int_set (&videorate->max_rate, g_value_get_int (value));
      goto reconfigure;
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  GST_OBJECT_UNLOCK (videorate);
  return;

reconfigure:
  GST_OBJECT_UNLOCK (videorate);
  gst_base_transform_reconfigure_src (GST_BASE_TRANSFORM (videorate));
}

static void
gst_video_rate_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstVideoRate *videorate = GST_VIDEO_RATE (object);

  GST_OBJECT_LOCK (videorate);
  switch (prop_id) {
    case PROP_IN:
      g_value_set_uint64 (value, videorate->in);
      break;
    case PROP_OUT:
      g_value_set_uint64 (value, videorate->out);
      break;
    case PROP_DUP:
      g_value_set_uint64 (value, videorate->dup);
      break;
    case PROP_DROP:
      g_value_set_uint64 (value, videorate->drop);
      break;
    case PROP_SILENT:
      g_value_set_boolean (value, videorate->silent);
      break;
    case PROP_NEW_PREF:
      g_value_set_double (value, videorate->new_pref);
      break;
    case PROP_SKIP_TO_FIRST:
      g_value_set_boolean (value, videorate->skip_to_first);
      break;
    case PROP_DROP_ONLY:
      g_value_set_boolean (value, videorate->drop_only);
      break;
    case PROP_AVERAGE_PERIOD:
      g_value_set_uint64 (value, videorate->average_period_set);
      break;
    case PROP_MAX_RATE:
      g_value_set_int (value, g_atomic_int_get (&videorate->max_rate));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  GST_OBJECT_UNLOCK (videorate);
}

static gboolean
plugin_init (GstPlugin * plugin)
{
  GST_DEBUG_CATEGORY_INIT (video_rate_debug, "videorate", 0,
      "VideoRate stream fixer");

  return gst_element_register (plugin, "videorate", GST_RANK_NONE,
      GST_TYPE_VIDEO_RATE);
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    videorate,
    "Adjusts video frames",
    plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN)
