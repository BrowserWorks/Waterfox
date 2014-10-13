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
 * SECTION:element-audiorate
 * @see_also: #GstVideoRate
 *
 * This element takes an incoming stream of timestamped raw audio frames and
 * produces a perfect stream by inserting or dropping samples as needed.
 *
 * This operation may be of use to link to elements that require or otherwise
 * implicitly assume a perfect stream as they do not store timestamps,
 * but derive this by some means (e.g. bitrate for some AVI cases).
 *
 * The properties #GstAudioRate:in, #GstAudioRate:out, #GstAudioRate:add
 * and #GstAudioRate:drop can be read to obtain information about number of
 * input samples, output samples, dropped samples (i.e. the number of unused
 * input samples) and inserted samples (i.e. the number of samples added to
 * stream).
 *
 * When the #GstAudioRate:silent property is set to FALSE, a GObject property
 * notification will be emitted whenever one of the #GstAudioRate:add or
 * #GstAudioRate:drop values changes.
 * This can potentially cause performance degradation.
 * Note that property notification will happen from the streaming thread, so
 * applications should be prepared for this.
 *
 * If the #GstAudioRate:tolerance property is non-zero, and an incoming buffer's
 * timestamp deviates less than the property indicates from what would make a
 * 'perfect time', then no samples will be added or dropped.
 * Note that the output is still guaranteed to be a perfect stream, which means
 * that the incoming data is then simply shifted (by less than the indicated
 * tolerance) to a perfect time.
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch -v alsasrc ! audiorate ! wavenc ! filesink location=alsa.wav
 * ]| Capture audio from an ALSA device, and turn it into a perfect stream
 * for saving in a raw audio file.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <stdlib.h>

#include "gstaudiorate.h"

#define GST_CAT_DEFAULT audio_rate_debug
GST_DEBUG_CATEGORY_STATIC (audio_rate_debug);

/* GstAudioRate signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

#define DEFAULT_SILENT     TRUE
#define DEFAULT_TOLERANCE  (40 * GST_MSECOND)
#define DEFAULT_SKIP_TO_FIRST FALSE

enum
{
  ARG_0,
  ARG_IN,
  ARG_OUT,
  ARG_ADD,
  ARG_DROP,
  ARG_SILENT,
  ARG_TOLERANCE,
  ARG_SKIP_TO_FIRST
};

static GstStaticPadTemplate gst_audio_rate_src_template =
GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (GST_AUDIO_CAPS_MAKE (GST_AUDIO_FORMATS_ALL)
        ", layout = (string) { interleaved, non-interleaved }")
    );

static GstStaticPadTemplate gst_audio_rate_sink_template =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (GST_AUDIO_CAPS_MAKE (GST_AUDIO_FORMATS_ALL)
        ", layout = (string) { interleaved, non-interleaved }")
    );

static gboolean gst_audio_rate_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_audio_rate_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static GstFlowReturn gst_audio_rate_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buf);

static void gst_audio_rate_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_audio_rate_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstStateChangeReturn gst_audio_rate_change_state (GstElement * element,
    GstStateChange transition);

/*static guint gst_audio_rate_signals[LAST_SIGNAL] = { 0 }; */

static GParamSpec *pspec_drop = NULL;
static GParamSpec *pspec_add = NULL;

#define gst_audio_rate_parent_class parent_class
G_DEFINE_TYPE (GstAudioRate, gst_audio_rate, GST_TYPE_ELEMENT);

static void
gst_audio_rate_class_init (GstAudioRateClass * klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);

  object_class->set_property = gst_audio_rate_set_property;
  object_class->get_property = gst_audio_rate_get_property;

  g_object_class_install_property (object_class, ARG_IN,
      g_param_spec_uint64 ("in", "In",
          "Number of input samples", 0, G_MAXUINT64, 0,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (object_class, ARG_OUT,
      g_param_spec_uint64 ("out", "Out", "Number of output samples", 0,
          G_MAXUINT64, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  pspec_add = g_param_spec_uint64 ("add", "Add", "Number of added samples",
      0, G_MAXUINT64, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (object_class, ARG_ADD, pspec_add);
  pspec_drop = g_param_spec_uint64 ("drop", "Drop", "Number of dropped samples",
      0, G_MAXUINT64, 0, G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (object_class, ARG_DROP, pspec_drop);
  g_object_class_install_property (object_class, ARG_SILENT,
      g_param_spec_boolean ("silent", "silent",
          "Don't emit notify for dropped and duplicated frames", DEFAULT_SILENT,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  /**
   * GstAudioRate:tolerance:
   *
   * The difference between incoming timestamp and next timestamp must exceed
   * the given value for audiorate to add or drop samples.
   */
  g_object_class_install_property (object_class, ARG_TOLERANCE,
      g_param_spec_uint64 ("tolerance", "tolerance",
          "Only act if timestamp jitter/imperfection exceeds indicated tolerance (ns)",
          0, G_MAXUINT64, DEFAULT_TOLERANCE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstAudioRate:skip-to-first:
   *
   * Don't produce buffers before the first one we receive.
   */
  g_object_class_install_property (object_class, ARG_SKIP_TO_FIRST,
      g_param_spec_boolean ("skip-to-first", "Skip to first buffer",
          "Don't produce buffers before the first one we receive",
          DEFAULT_SKIP_TO_FIRST, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (element_class,
      "Audio rate adjuster", "Filter/Effect/Audio",
      "Drops/duplicates/adjusts timestamps on audio samples to make a perfect stream",
      "Wim Taymans <wim@fluendo.com>");

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_audio_rate_sink_template));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&gst_audio_rate_src_template));

  element_class->change_state = gst_audio_rate_change_state;
}

static void
gst_audio_rate_reset (GstAudioRate * audiorate)
{
  audiorate->next_offset = -1;
  audiorate->next_ts = -1;
  audiorate->discont = TRUE;
  gst_segment_init (&audiorate->sink_segment, GST_FORMAT_UNDEFINED);
  gst_segment_init (&audiorate->src_segment, GST_FORMAT_TIME);

  GST_DEBUG_OBJECT (audiorate, "handle reset");
}

static gboolean
gst_audio_rate_setcaps (GstAudioRate * audiorate, GstCaps * caps)
{
  GstAudioInfo info;

  if (!gst_audio_info_from_caps (&info, caps))
    goto wrong_caps;

  audiorate->info = info;

  return TRUE;

  /* ERRORS */
wrong_caps:
  {
    GST_DEBUG_OBJECT (audiorate, "could not parse caps");
    return FALSE;
  }
}

static void
gst_audio_rate_init (GstAudioRate * audiorate)
{
  audiorate->sinkpad =
      gst_pad_new_from_static_template (&gst_audio_rate_sink_template, "sink");
  gst_pad_set_event_function (audiorate->sinkpad, gst_audio_rate_sink_event);
  gst_pad_set_chain_function (audiorate->sinkpad, gst_audio_rate_chain);
  GST_PAD_SET_PROXY_CAPS (audiorate->sinkpad);
  gst_element_add_pad (GST_ELEMENT (audiorate), audiorate->sinkpad);

  audiorate->srcpad =
      gst_pad_new_from_static_template (&gst_audio_rate_src_template, "src");
  gst_pad_set_event_function (audiorate->srcpad, gst_audio_rate_src_event);
  GST_PAD_SET_PROXY_CAPS (audiorate->srcpad);
  gst_element_add_pad (GST_ELEMENT (audiorate), audiorate->srcpad);

  audiorate->in = 0;
  audiorate->out = 0;
  audiorate->drop = 0;
  audiorate->add = 0;
  audiorate->silent = DEFAULT_SILENT;
  audiorate->tolerance = DEFAULT_TOLERANCE;
}

static void
gst_audio_rate_fill_to_time (GstAudioRate * audiorate, GstClockTime time)
{
  GstBuffer *buf;

  GST_DEBUG_OBJECT (audiorate, "next_ts: %" GST_TIME_FORMAT
      ", filling to %" GST_TIME_FORMAT, GST_TIME_ARGS (audiorate->next_ts),
      GST_TIME_ARGS (time));

  if (!GST_CLOCK_TIME_IS_VALID (time) ||
      !GST_CLOCK_TIME_IS_VALID (audiorate->next_ts))
    return;

  /* feed an empty buffer to chain with the given timestamp,
   * it will take care of filling */
  buf = gst_buffer_new ();
  GST_BUFFER_TIMESTAMP (buf) = time;
  gst_audio_rate_chain (audiorate->sinkpad, GST_OBJECT_CAST (audiorate), buf);
}

static gboolean
gst_audio_rate_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res;
  GstAudioRate *audiorate;

  audiorate = GST_AUDIO_RATE (parent);

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      if ((res = gst_audio_rate_setcaps (audiorate, caps))) {
        res = gst_pad_push_event (audiorate->srcpad, event);
      } else {
        gst_event_unref (event);
      }
      break;
    }
    case GST_EVENT_FLUSH_STOP:
      GST_DEBUG_OBJECT (audiorate, "handling FLUSH_STOP");
      gst_audio_rate_reset (audiorate);
      res = gst_pad_push_event (audiorate->srcpad, event);
      break;
    case GST_EVENT_SEGMENT:
    {
      gst_event_copy_segment (event, &audiorate->sink_segment);

      GST_DEBUG_OBJECT (audiorate, "handle NEWSEGMENT");
#if 0
      /* FIXME: bad things will likely happen if rate < 0 ... */
      if (!update) {
        /* a new segment starts. We need to figure out what will be the next
         * sample offset. We mark the offsets as invalid so that the _chain
         * function will perform this calculation. */
        gst_audio_rate_fill_to_time (audiorate, audiorate->src_segment.stop);
#endif
        audiorate->next_offset = -1;
        audiorate->next_ts = -1;
#if 0
      } else {
        gst_audio_rate_fill_to_time (audiorate, audiorate->src_segment.start);
      }
#endif

      GST_DEBUG_OBJECT (audiorate, "updated segment: %" GST_SEGMENT_FORMAT,
          &audiorate->sink_segment);

      if (audiorate->sink_segment.format == GST_FORMAT_TIME) {
        /* TIME formats can be copied to src and forwarded */
        res = gst_pad_push_event (audiorate->srcpad, event);
        gst_segment_copy_into (&audiorate->sink_segment,
            &audiorate->src_segment);
      } else {
        /* other formats will be handled in the _chain function */
        gst_event_unref (event);
        res = TRUE;
      }
      break;
    }
    case GST_EVENT_EOS:
      /* Fill segment until the end */
      if (GST_CLOCK_TIME_IS_VALID (audiorate->src_segment.stop))
        gst_audio_rate_fill_to_time (audiorate, audiorate->src_segment.stop);
      res = gst_pad_push_event (audiorate->srcpad, event);
      break;
    case GST_EVENT_GAP:
      /* no gaps after audiorate, ignore the event */
      gst_event_unref (event);
      res = TRUE;
      break;
    default:
      res = gst_pad_event_default (pad, parent, event);
      break;
  }

  return res;
}

static gboolean
gst_audio_rate_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res;
  GstAudioRate *audiorate;

  audiorate = GST_AUDIO_RATE (parent);

  switch (GST_EVENT_TYPE (event)) {
    default:
      res = gst_pad_push_event (audiorate->sinkpad, event);
      break;
  }

  return res;
}

static gboolean
gst_audio_rate_convert (GstAudioRate * audiorate,
    GstFormat src_fmt, guint64 src_val, GstFormat dest_fmt, guint64 * dest_val)
{
  return gst_audio_info_convert (&audiorate->info, src_fmt, src_val, dest_fmt,
      (gint64 *) dest_val);
}


static gboolean
gst_audio_rate_convert_segments (GstAudioRate * audiorate)
{
  GstFormat src_fmt, dst_fmt;

  src_fmt = audiorate->sink_segment.format;
  dst_fmt = audiorate->src_segment.format;

#define CONVERT_VAL(field) gst_audio_rate_convert (audiorate, \
		src_fmt, audiorate->sink_segment.field,       \
		dst_fmt, &audiorate->src_segment.field);

  audiorate->sink_segment.rate = audiorate->src_segment.rate;
  audiorate->sink_segment.flags = audiorate->src_segment.flags;
  audiorate->sink_segment.applied_rate = audiorate->src_segment.applied_rate;
  CONVERT_VAL (start);
  CONVERT_VAL (stop);
  CONVERT_VAL (time);
  CONVERT_VAL (base);
  CONVERT_VAL (position);
#undef CONVERT_VAL

  return TRUE;
}

static void
gst_audio_rate_notify_drop (GstAudioRate * audiorate)
{
  g_object_notify_by_pspec ((GObject *) audiorate, pspec_drop);
}

static void
gst_audio_rate_notify_add (GstAudioRate * audiorate)
{
  g_object_notify_by_pspec ((GObject *) audiorate, pspec_add);
}

static GstFlowReturn
gst_audio_rate_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstAudioRate *audiorate;
  GstClockTime in_time;
  guint64 in_offset, in_offset_end, in_samples;
  guint in_size;
  GstFlowReturn ret = GST_FLOW_OK;
  GstClockTimeDiff diff;
  gint rate, bpf;

  audiorate = GST_AUDIO_RATE (parent);

  rate = GST_AUDIO_INFO_RATE (&audiorate->info);
  bpf = GST_AUDIO_INFO_BPF (&audiorate->info);

  /* need to be negotiated now */
  if (bpf == 0)
    goto not_negotiated;

  /* we have a new pending segment */
  if (audiorate->next_offset == -1) {
    gint64 pos;

    /* update the TIME segment */
    gst_audio_rate_convert_segments (audiorate);

    /* first buffer, we are negotiated and we have a segment, calculate the
     * current expected offsets based on the segment.start, which is the first
     * media time of the segment and should match the media time of the first
     * buffer in that segment, which is the offset expressed in DEFAULT units.
     */
    /* convert first timestamp of segment to sample position */
    pos = gst_util_uint64_scale_int (audiorate->src_segment.start,
        GST_AUDIO_INFO_RATE (&audiorate->info), GST_SECOND);

    GST_DEBUG_OBJECT (audiorate, "resync to offset %" G_GINT64_FORMAT, pos);

    /* resyncing is a discont */
    audiorate->discont = TRUE;

    audiorate->next_offset = pos;
    audiorate->next_ts = gst_util_uint64_scale_int (audiorate->next_offset,
        GST_SECOND, GST_AUDIO_INFO_RATE (&audiorate->info));

    if (audiorate->skip_to_first && GST_BUFFER_TIMESTAMP_IS_VALID (buf)) {
      GST_DEBUG_OBJECT (audiorate, "but skipping to first buffer instead");
      pos = gst_util_uint64_scale_int (GST_BUFFER_TIMESTAMP (buf),
          GST_AUDIO_INFO_RATE (&audiorate->info), GST_SECOND);
      GST_DEBUG_OBJECT (audiorate, "so resync to offset %" G_GINT64_FORMAT,
          pos);
      audiorate->next_offset = pos;
      audiorate->next_ts = GST_BUFFER_TIMESTAMP (buf);
    }
  }

  in_time = GST_BUFFER_TIMESTAMP (buf);
  if (in_time == GST_CLOCK_TIME_NONE) {
    GST_DEBUG_OBJECT (audiorate, "no timestamp, using expected next time");
    in_time = audiorate->next_ts;
  }

  in_size = gst_buffer_get_size (buf);
  in_samples = in_size / bpf;
  audiorate->in += in_samples;

  /* calculate the buffer offset */
  in_offset = gst_util_uint64_scale_int_round (in_time, rate, GST_SECOND);
  in_offset_end = in_offset + in_samples;

  GST_LOG_OBJECT (audiorate,
      "in_time:%" GST_TIME_FORMAT ", in_duration:%" GST_TIME_FORMAT
      ", in_size:%u, in_offset:%" G_GUINT64_FORMAT ", in_offset_end:%"
      G_GUINT64_FORMAT ", ->next_offset:%" G_GUINT64_FORMAT ", ->next_ts:%"
      GST_TIME_FORMAT, GST_TIME_ARGS (in_time),
      GST_TIME_ARGS (GST_FRAMES_TO_CLOCK_TIME (in_samples, rate)),
      in_size, in_offset, in_offset_end, audiorate->next_offset,
      GST_TIME_ARGS (audiorate->next_ts));

  diff = in_time - audiorate->next_ts;
  if (diff <= (GstClockTimeDiff) audiorate->tolerance &&
      diff >= (GstClockTimeDiff) - audiorate->tolerance) {
    /* buffer time close enough to expected time,
     * so produce a perfect stream by simply 'shifting'
     * it to next ts and offset and sending */
    GST_LOG_OBJECT (audiorate, "within tolerance %" GST_TIME_FORMAT,
        GST_TIME_ARGS (audiorate->tolerance));
    /* The outgoing buffer's offset will be set to ->next_offset, we also
     * need to adjust the offset_end value accordingly */
    in_offset_end = audiorate->next_offset + in_samples;
    audiorate->out += in_samples;
    goto send;
  }

  /* do we need to insert samples */
  if (in_offset > audiorate->next_offset) {
    GstBuffer *fill;
    gint fillsize;
    guint64 fillsamples;

    /* We don't want to allocate a single unreasonably huge buffer - it might
       be hundreds of megabytes. So, limit each output buffer to one second of
       audio */
    fillsamples = in_offset - audiorate->next_offset;

    while (fillsamples > 0) {
      guint64 cursamples = MIN (fillsamples, rate);

      fillsamples -= cursamples;
      fillsize = cursamples * bpf;

      fill = gst_buffer_new_and_alloc (fillsize);

      /* FIXME, 0 might not be the silence byte for the negotiated format. */
      gst_buffer_memset (fill, 0, 0, fillsize);

      GST_DEBUG_OBJECT (audiorate, "inserting %" G_GUINT64_FORMAT " samples",
          cursamples);

      GST_BUFFER_OFFSET (fill) = audiorate->next_offset;
      audiorate->next_offset += cursamples;
      GST_BUFFER_OFFSET_END (fill) = audiorate->next_offset;

      /* Use next timestamp, then calculate following timestamp based on 
       * offset to get duration. Necessary complexity to get 'perfect' 
       * streams */
      GST_BUFFER_TIMESTAMP (fill) = audiorate->next_ts;
      audiorate->next_ts = gst_util_uint64_scale_int (audiorate->next_offset,
          GST_SECOND, rate);
      GST_BUFFER_DURATION (fill) = audiorate->next_ts -
          GST_BUFFER_TIMESTAMP (fill);

      /* we created this buffer to fill a gap */
      GST_BUFFER_FLAG_SET (fill, GST_BUFFER_FLAG_GAP);
      /* set discont if it's pending, this is mostly done for the first buffer 
       * and after a flushing seek */
      if (audiorate->discont) {
        GST_BUFFER_FLAG_SET (fill, GST_BUFFER_FLAG_DISCONT);
        audiorate->discont = FALSE;
      }

      fill = gst_audio_buffer_clip (fill, &audiorate->src_segment, rate, bpf);
      if (fill)
        ret = gst_pad_push (audiorate->srcpad, fill);

      if (ret != GST_FLOW_OK)
        goto beach;
      audiorate->out += cursamples;
      audiorate->add += cursamples;

      if (!audiorate->silent)
        gst_audio_rate_notify_add (audiorate);
    }

  } else if (in_offset < audiorate->next_offset) {
    /* need to remove samples */
    if (in_offset_end <= audiorate->next_offset) {
      guint64 drop = in_size / bpf;

      audiorate->drop += drop;

      GST_DEBUG_OBJECT (audiorate, "dropping %" G_GUINT64_FORMAT " samples",
          drop);

      /* we can drop the buffer completely */
      gst_buffer_unref (buf);
      buf = NULL;

      if (!audiorate->silent)
        gst_audio_rate_notify_drop (audiorate);

      goto beach;
    } else {
      guint64 truncsamples;
      guint truncsize, leftsize;
      GstBuffer *trunc;

      /* truncate buffer */
      truncsamples = audiorate->next_offset - in_offset;
      truncsize = truncsamples * bpf;
      leftsize = in_size - truncsize;

      trunc =
          gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL, truncsize,
          leftsize);

      gst_buffer_unref (buf);
      buf = trunc;

      audiorate->drop += truncsamples;
      audiorate->out += (leftsize / bpf);
      GST_DEBUG_OBJECT (audiorate, "truncating %" G_GUINT64_FORMAT " samples",
          truncsamples);

      if (!audiorate->silent)
        gst_audio_rate_notify_drop (audiorate);
    }
  }

send:
  if (gst_buffer_get_size (buf) == 0)
    goto beach;

  /* Now calculate parameters for whichever buffer (either the original
   * or truncated one) we're pushing. */
  GST_BUFFER_OFFSET (buf) = audiorate->next_offset;
  GST_BUFFER_OFFSET_END (buf) = in_offset_end;

  GST_BUFFER_TIMESTAMP (buf) = audiorate->next_ts;
  audiorate->next_ts = gst_util_uint64_scale_int (in_offset_end,
      GST_SECOND, rate);
  GST_BUFFER_DURATION (buf) = audiorate->next_ts - GST_BUFFER_TIMESTAMP (buf);

  if (audiorate->discont) {
    /* we need to output a discont buffer, do so now */
    GST_DEBUG_OBJECT (audiorate, "marking DISCONT on output buffer");
    buf = gst_buffer_make_writable (buf);
    GST_BUFFER_FLAG_SET (buf, GST_BUFFER_FLAG_DISCONT);
    audiorate->discont = FALSE;
  } else if (GST_BUFFER_IS_DISCONT (buf)) {
    /* else we make everything continuous so we can safely remove the DISCONT
     * flag from the buffer if there was one */
    GST_DEBUG_OBJECT (audiorate, "removing DISCONT from buffer");
    buf = gst_buffer_make_writable (buf);
    GST_BUFFER_FLAG_UNSET (buf, GST_BUFFER_FLAG_DISCONT);
  }

  buf = gst_audio_buffer_clip (buf, &audiorate->src_segment, rate, bpf);
  if (buf) {
    /* set last_stop on segment */
    audiorate->src_segment.position =
        GST_BUFFER_TIMESTAMP (buf) + GST_BUFFER_DURATION (buf);

    ret = gst_pad_push (audiorate->srcpad, buf);
  }
  buf = NULL;

  audiorate->next_offset = in_offset_end;
beach:

  if (buf)
    gst_buffer_unref (buf);

  return ret;

  /* ERRORS */
not_negotiated:
  {
    gst_buffer_unref (buf);

    GST_ELEMENT_ERROR (audiorate, STREAM, FORMAT,
        (NULL), ("pipeline error, format was not negotiated"));
    return GST_FLOW_NOT_NEGOTIATED;
  }
}

static void
gst_audio_rate_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstAudioRate *audiorate = GST_AUDIO_RATE (object);

  switch (prop_id) {
    case ARG_SILENT:
      audiorate->silent = g_value_get_boolean (value);
      break;
    case ARG_TOLERANCE:
      audiorate->tolerance = g_value_get_uint64 (value);
      break;
    case ARG_SKIP_TO_FIRST:
      audiorate->skip_to_first = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_audio_rate_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstAudioRate *audiorate = GST_AUDIO_RATE (object);

  switch (prop_id) {
    case ARG_IN:
      g_value_set_uint64 (value, audiorate->in);
      break;
    case ARG_OUT:
      g_value_set_uint64 (value, audiorate->out);
      break;
    case ARG_ADD:
      g_value_set_uint64 (value, audiorate->add);
      break;
    case ARG_DROP:
      g_value_set_uint64 (value, audiorate->drop);
      break;
    case ARG_SILENT:
      g_value_set_boolean (value, audiorate->silent);
      break;
    case ARG_TOLERANCE:
      g_value_set_uint64 (value, audiorate->tolerance);
      break;
    case ARG_SKIP_TO_FIRST:
      g_value_set_boolean (value, audiorate->skip_to_first);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstStateChangeReturn
gst_audio_rate_change_state (GstElement * element, GstStateChange transition)
{
  GstAudioRate *audiorate = GST_AUDIO_RATE (element);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      audiorate->in = 0;
      audiorate->out = 0;
      audiorate->drop = 0;
      audiorate->add = 0;
      gst_audio_info_init (&audiorate->info);
      gst_audio_rate_reset (audiorate);
      break;
    default:
      break;
  }

  return GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
}

static gboolean
plugin_init (GstPlugin * plugin)
{
  GST_DEBUG_CATEGORY_INIT (audio_rate_debug, "audiorate", 0,
      "AudioRate stream fixer");

  return gst_element_register (plugin, "audiorate", GST_RANK_NONE,
      GST_TYPE_AUDIO_RATE);
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    audiorate,
    "Adjusts audio frames",
    plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN)
