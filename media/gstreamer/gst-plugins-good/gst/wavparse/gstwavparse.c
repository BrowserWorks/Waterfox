/* -*- Mode: C; tab-width: 2; indent-tabs-mode: t; c-basic-offset: 2 -*- */
/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2006> Nokia Corporation, Stefan Kost <stefan.kost@nokia.com>.
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
 * SECTION:element-wavparse
 *
 * Parse a .wav file into raw or compressed audio.
 *
 * Wavparse supports both push and pull mode operations, making it possible to
 * stream from a network source.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch-1.0 filesrc location=sine.wav ! wavparse ! audioconvert ! alsasink
 * ]| Read a wav file and output to the soundcard using the ALSA element. The
 * wav file is assumed to contain raw uncompressed samples.
 * |[
 * gst-launch-1.0 gnomevfssrc location=http://www.example.org/sine.wav ! queue ! wavparse ! audioconvert ! alsasink
 * ]| Stream data from a network url.
 * </refsect2>
 */

/*
 * TODO:
 * http://replaygain.hydrogenaudio.org/file_format_wav.html
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <math.h>

#include "gstwavparse.h"
#include "gst/riff/riff-media.h"
#include <gst/base/gsttypefindhelper.h>
#include <gst/gst-i18n-plugin.h>

GST_DEBUG_CATEGORY_STATIC (wavparse_debug);
#define GST_CAT_DEFAULT (wavparse_debug)

#define GST_BWF_TAG_iXML GST_MAKE_FOURCC ('i','X','M','L')
#define GST_BWF_TAG_qlty GST_MAKE_FOURCC ('q','l','t','y')
#define GST_BWF_TAG_mext GST_MAKE_FOURCC ('m','e','x','t')
#define GST_BWF_TAG_levl GST_MAKE_FOURCC ('l','e','v','l')
#define GST_BWF_TAG_link GST_MAKE_FOURCC ('l','i','n','k')
#define GST_BWF_TAG_axml GST_MAKE_FOURCC ('a','x','m','l')

static void gst_wavparse_dispose (GObject * object);

static gboolean gst_wavparse_sink_activate (GstPad * sinkpad,
    GstObject * parent);
static gboolean gst_wavparse_sink_activate_mode (GstPad * sinkpad,
    GstObject * parent, GstPadMode mode, gboolean active);
static gboolean gst_wavparse_send_event (GstElement * element,
    GstEvent * event);
static GstStateChangeReturn gst_wavparse_change_state (GstElement * element,
    GstStateChange transition);

static gboolean gst_wavparse_pad_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gboolean gst_wavparse_pad_convert (GstPad * pad, GstFormat src_format,
    gint64 src_value, GstFormat * dest_format, gint64 * dest_value);

static GstFlowReturn gst_wavparse_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buf);
static gboolean gst_wavparse_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static void gst_wavparse_loop (GstPad * pad);
static gboolean gst_wavparse_srcpad_event (GstPad * pad, GstObject * parent,
    GstEvent * event);

static void gst_wavparse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_wavparse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define DEFAULT_IGNORE_LENGTH FALSE

enum
{
  PROP_0,
  PROP_IGNORE_LENGTH,
};

static GstStaticPadTemplate sink_template_factory =
GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/x-wav")
    );

#define DEBUG_INIT \
  GST_DEBUG_CATEGORY_INIT (wavparse_debug, "wavparse", 0, "WAV parser");

#define gst_wavparse_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstWavParse, gst_wavparse, GST_TYPE_ELEMENT,
    DEBUG_INIT);

typedef struct
{
  /* Offset Size    Description   Value
   * 0x00   4       ID            unique identification value
   * 0x04   4       Position      play order position
   * 0x08   4       Data Chunk ID RIFF ID of corresponding data chunk
   * 0x0c   4       Chunk Start   Byte Offset of Data Chunk *
   * 0x10   4       Block Start   Byte Offset to sample of First Channel
   * 0x14   4       Sample Offset Byte Offset to sample byte of First Channel
   */
  guint32 id;
  guint32 position;
  guint32 data_chunk_id;
  guint32 chunk_start;
  guint32 block_start;
  guint32 sample_offset;
} GstWavParseCue;

typedef struct
{
  /* Offset Size    Description     Value
   * 0x08   4       Cue Point ID    0 - 0xFFFFFFFF
   * 0x0c           Text
   */
  guint32 cue_point_id;
  gchar *text;
} GstWavParseLabl, GstWavParseNote;

static void
gst_wavparse_class_init (GstWavParseClass * klass)
{
  GstElementClass *gstelement_class;
  GObjectClass *object_class;
  GstPadTemplate *src_template;

  gstelement_class = (GstElementClass *) klass;
  object_class = (GObjectClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  object_class->dispose = gst_wavparse_dispose;

  object_class->set_property = gst_wavparse_set_property;
  object_class->get_property = gst_wavparse_get_property;

  /**
   * GstWavParse:ignore-length:
   *
   * This selects whether the length found in a data chunk
   * should be ignored. This may be useful for streamed audio
   * where the length is unknown until the end of streaming,
   * and various software/hardware just puts some random value
   * in there and hopes it doesn't break too much.
   */
  g_object_class_install_property (object_class, PROP_IGNORE_LENGTH,
      g_param_spec_boolean ("ignore-length",
          "Ignore length",
          "Ignore length from the Wave header",
          DEFAULT_IGNORE_LENGTH, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS)
      );

  gstelement_class->change_state = gst_wavparse_change_state;
  gstelement_class->send_event = gst_wavparse_send_event;

  /* register pads */
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sink_template_factory));

  src_template = gst_pad_template_new ("src", GST_PAD_SRC,
      GST_PAD_ALWAYS, gst_riff_create_audio_template_caps ());
  gst_element_class_add_pad_template (gstelement_class, src_template);

  gst_element_class_set_static_metadata (gstelement_class, "WAV audio demuxer",
      "Codec/Demuxer/Audio",
      "Parse a .wav file into raw audio",
      "Erik Walthinsen <omega@cse.ogi.edu>");
}

static void
gst_wavparse_reset (GstWavParse * wav)
{
  wav->state = GST_WAVPARSE_START;

  /* These will all be set correctly in the fmt chunk */
  wav->depth = 0;
  wav->rate = 0;
  wav->width = 0;
  wav->channels = 0;
  wav->blockalign = 0;
  wav->bps = 0;
  wav->fact = 0;
  wav->offset = 0;
  wav->end_offset = 0;
  wav->dataleft = 0;
  wav->datasize = 0;
  wav->datastart = 0;
  wav->duration = 0;
  wav->got_fmt = FALSE;
  wav->first = TRUE;

  if (wav->seek_event)
    gst_event_unref (wav->seek_event);
  wav->seek_event = NULL;
  if (wav->adapter) {
    gst_adapter_clear (wav->adapter);
    g_object_unref (wav->adapter);
    wav->adapter = NULL;
  }
  if (wav->tags)
    gst_tag_list_unref (wav->tags);
  wav->tags = NULL;
  if (wav->toc)
    gst_toc_unref (wav->toc);
  wav->toc = NULL;
  if (wav->cues)
    g_list_free_full (wav->cues, g_free);
  wav->cues = NULL;
  if (wav->labls)
    g_list_free_full (wav->labls, g_free);
  wav->labls = NULL;
  if (wav->caps)
    gst_caps_unref (wav->caps);
  wav->caps = NULL;
  if (wav->start_segment)
    gst_event_unref (wav->start_segment);
  wav->start_segment = NULL;
}

static void
gst_wavparse_dispose (GObject * object)
{
  GstWavParse *wav = GST_WAVPARSE (object);

  GST_DEBUG_OBJECT (wav, "WAV: Dispose");
  gst_wavparse_reset (wav);

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_wavparse_init (GstWavParse * wavparse)
{
  gst_wavparse_reset (wavparse);

  /* sink */
  wavparse->sinkpad =
      gst_pad_new_from_static_template (&sink_template_factory, "sink");
  gst_pad_set_activate_function (wavparse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_wavparse_sink_activate));
  gst_pad_set_activatemode_function (wavparse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_wavparse_sink_activate_mode));
  gst_pad_set_chain_function (wavparse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_wavparse_chain));
  gst_pad_set_event_function (wavparse->sinkpad,
      GST_DEBUG_FUNCPTR (gst_wavparse_sink_event));
  gst_element_add_pad (GST_ELEMENT_CAST (wavparse), wavparse->sinkpad);

  /* src */
  wavparse->srcpad =
      gst_pad_new_from_template (gst_element_class_get_pad_template
      (GST_ELEMENT_GET_CLASS (wavparse), "src"), "src");
  gst_pad_use_fixed_caps (wavparse->srcpad);
  gst_pad_set_query_function (wavparse->srcpad,
      GST_DEBUG_FUNCPTR (gst_wavparse_pad_query));
  gst_pad_set_event_function (wavparse->srcpad,
      GST_DEBUG_FUNCPTR (gst_wavparse_srcpad_event));
  gst_element_add_pad (GST_ELEMENT_CAST (wavparse), wavparse->srcpad);
}

static gboolean
gst_wavparse_parse_file_header (GstElement * element, GstBuffer * buf)
{
  guint32 doctype;

  if (!gst_riff_parse_file_header (element, buf, &doctype))
    return FALSE;

  if (doctype != GST_RIFF_RIFF_WAVE)
    goto not_wav;

  return TRUE;

  /* ERRORS */
not_wav:
  {
    GST_ELEMENT_ERROR (element, STREAM, WRONG_TYPE, (NULL),
        ("File is not a WAVE file: 0x%" G_GINT32_MODIFIER "x", doctype));
    return FALSE;
  }
}

static GstFlowReturn
gst_wavparse_stream_init (GstWavParse * wav)
{
  GstFlowReturn res;
  GstBuffer *buf = NULL;

  if ((res = gst_pad_pull_range (wav->sinkpad,
              wav->offset, 12, &buf)) != GST_FLOW_OK)
    return res;
  else if (!gst_wavparse_parse_file_header (GST_ELEMENT_CAST (wav), buf))
    return GST_FLOW_ERROR;

  wav->offset += 12;

  return GST_FLOW_OK;
}

static gboolean
gst_wavparse_time_to_bytepos (GstWavParse * wav, gint64 ts, gint64 * bytepos)
{
  /* -1 always maps to -1 */
  if (ts == -1) {
    *bytepos = -1;
    return TRUE;
  }

  /* 0 always maps to 0 */
  if (ts == 0) {
    *bytepos = 0;
    return TRUE;
  }

  if (wav->bps > 0) {
    *bytepos = gst_util_uint64_scale_ceil (ts, (guint64) wav->bps, GST_SECOND);
    return TRUE;
  } else if (wav->fact) {
    guint64 bps =
        gst_util_uint64_scale_int (wav->datasize, wav->rate, wav->fact);
    *bytepos = gst_util_uint64_scale_ceil (ts, bps, GST_SECOND);
    return TRUE;
  }

  return FALSE;
}

/* This function is used to perform seeks on the element.
 *
 * It also works when event is NULL, in which case it will just
 * start from the last configured segment. This technique is
 * used when activating the element and to perform the seek in
 * READY.
 */
static gboolean
gst_wavparse_perform_seek (GstWavParse * wav, GstEvent * event)
{
  gboolean res;
  gdouble rate;
  GstFormat format, bformat;
  GstSeekFlags flags;
  GstSeekType cur_type = GST_SEEK_TYPE_NONE, stop_type;
  gint64 cur, stop, upstream_size;
  gboolean flush;
  gboolean update;
  GstSegment seeksegment = { 0, };
  gint64 last_stop;

  if (event) {
    GST_DEBUG_OBJECT (wav, "doing seek with event");

    gst_event_parse_seek (event, &rate, &format, &flags,
        &cur_type, &cur, &stop_type, &stop);

    /* no negative rates yet */
    if (rate < 0.0)
      goto negative_rate;

    if (format != wav->segment.format) {
      GST_INFO_OBJECT (wav, "converting seek-event from %s to %s",
          gst_format_get_name (format),
          gst_format_get_name (wav->segment.format));
      res = TRUE;
      if (cur_type != GST_SEEK_TYPE_NONE)
        res =
            gst_pad_query_convert (wav->srcpad, format, cur,
            wav->segment.format, &cur);
      if (res && stop_type != GST_SEEK_TYPE_NONE)
        res =
            gst_pad_query_convert (wav->srcpad, format, stop,
            wav->segment.format, &stop);
      if (!res)
        goto no_format;

      format = wav->segment.format;
    }
  } else {
    GST_DEBUG_OBJECT (wav, "doing seek without event");
    flags = 0;
    rate = 1.0;
    cur_type = GST_SEEK_TYPE_SET;
    stop_type = GST_SEEK_TYPE_SET;
  }

  /* in push mode, we must delegate to upstream */
  if (wav->streaming) {
    gboolean res = FALSE;

    /* if streaming not yet started; only prepare initial newsegment */
    if (!event || wav->state != GST_WAVPARSE_DATA) {
      if (wav->start_segment)
        gst_event_unref (wav->start_segment);
      wav->start_segment = gst_event_new_segment (&wav->segment);
      res = TRUE;
    } else {
      /* convert seek positions to byte positions in data sections */
      if (format == GST_FORMAT_TIME) {
        /* should not fail */
        if (!gst_wavparse_time_to_bytepos (wav, cur, &cur))
          goto no_position;
        if (!gst_wavparse_time_to_bytepos (wav, stop, &stop))
          goto no_position;
      }
      /* mind sample boundary and header */
      if (cur >= 0) {
        cur -= (cur % wav->bytes_per_sample);
        cur += wav->datastart;
      }
      if (stop >= 0) {
        stop -= (stop % wav->bytes_per_sample);
        stop += wav->datastart;
      }
      GST_DEBUG_OBJECT (wav, "Pushing BYTE seek rate %g, "
          "start %" G_GINT64_FORMAT ", stop %" G_GINT64_FORMAT, rate, cur,
          stop);
      /* BYTE seek event */
      event = gst_event_new_seek (rate, GST_FORMAT_BYTES, flags, cur_type, cur,
          stop_type, stop);
      res = gst_pad_push_event (wav->sinkpad, event);
    }
    return res;
  }

  /* get flush flag */
  flush = flags & GST_SEEK_FLAG_FLUSH;

  /* now we need to make sure the streaming thread is stopped. We do this by
   * either sending a FLUSH_START event downstream which will cause the
   * streaming thread to stop with a WRONG_STATE.
   * For a non-flushing seek we simply pause the task, which will happen as soon
   * as it completes one iteration (and thus might block when the sink is
   * blocking in preroll). */
  if (flush) {
    GST_DEBUG_OBJECT (wav, "sending flush start");
    gst_pad_push_event (wav->srcpad, gst_event_new_flush_start ());
  } else {
    gst_pad_pause_task (wav->sinkpad);
  }

  /* we should now be able to grab the streaming thread because we stopped it
   * with the above flush/pause code */
  GST_PAD_STREAM_LOCK (wav->sinkpad);

  /* save current position */
  last_stop = wav->segment.position;

  GST_DEBUG_OBJECT (wav, "stopped streaming at %" G_GINT64_FORMAT, last_stop);

  /* copy segment, we need this because we still need the old
   * segment when we close the current segment. */
  memcpy (&seeksegment, &wav->segment, sizeof (GstSegment));

  /* configure the seek parameters in the seeksegment. We will then have the
   * right values in the segment to perform the seek */
  if (event) {
    GST_DEBUG_OBJECT (wav, "configuring seek");
    gst_segment_do_seek (&seeksegment, rate, format, flags,
        cur_type, cur, stop_type, stop, &update);
  }

  /* figure out the last position we need to play. If it's configured (stop !=
   * -1), use that, else we play until the total duration of the file */
  if ((stop = seeksegment.stop) == -1)
    stop = seeksegment.duration;

  GST_DEBUG_OBJECT (wav, "cur_type =%d", cur_type);
  if ((cur_type != GST_SEEK_TYPE_NONE)) {
    /* bring offset to bytes, if the bps is 0, we have the segment in BYTES and
     * we can just copy the last_stop. If not, we use the bps to convert TIME to
     * bytes. */
    if (!gst_wavparse_time_to_bytepos (wav, seeksegment.position,
            (gint64 *) & wav->offset))
      wav->offset = seeksegment.position;
    GST_LOG_OBJECT (wav, "offset=%" G_GUINT64_FORMAT, wav->offset);
    wav->offset -= (wav->offset % wav->bytes_per_sample);
    GST_LOG_OBJECT (wav, "offset=%" G_GUINT64_FORMAT, wav->offset);
    wav->offset += wav->datastart;
    GST_LOG_OBJECT (wav, "offset=%" G_GUINT64_FORMAT, wav->offset);
  } else {
    GST_LOG_OBJECT (wav, "continue from offset=%" G_GUINT64_FORMAT,
        wav->offset);
  }

  if (stop_type != GST_SEEK_TYPE_NONE) {
    if (!gst_wavparse_time_to_bytepos (wav, stop, (gint64 *) & wav->end_offset))
      wav->end_offset = stop;
    GST_LOG_OBJECT (wav, "end_offset=%" G_GUINT64_FORMAT, wav->end_offset);
    wav->end_offset -= (wav->end_offset % wav->bytes_per_sample);
    GST_LOG_OBJECT (wav, "end_offset=%" G_GUINT64_FORMAT, wav->end_offset);
    wav->end_offset += wav->datastart;
    GST_LOG_OBJECT (wav, "end_offset=%" G_GUINT64_FORMAT, wav->end_offset);
  } else {
    GST_LOG_OBJECT (wav, "continue to end_offset=%" G_GUINT64_FORMAT,
        wav->end_offset);
  }

  /* make sure filesize is not exceeded due to rounding errors or so,
   * same precaution as in _stream_headers */
  bformat = GST_FORMAT_BYTES;
  if (gst_pad_peer_query_duration (wav->sinkpad, bformat, &upstream_size))
    wav->end_offset = MIN (wav->end_offset, upstream_size);

  /* this is the range of bytes we will use for playback */
  wav->offset = MIN (wav->offset, wav->end_offset);
  wav->dataleft = wav->end_offset - wav->offset;

  GST_DEBUG_OBJECT (wav,
      "seek: rate %lf, offset %" G_GUINT64_FORMAT ", end %" G_GUINT64_FORMAT
      ", segment %" GST_TIME_FORMAT " -- %" GST_TIME_FORMAT, rate, wav->offset,
      wav->end_offset, GST_TIME_ARGS (seeksegment.start), GST_TIME_ARGS (stop));

  /* prepare for streaming again */
  if (flush) {
    /* if we sent a FLUSH_START, we now send a FLUSH_STOP */
    GST_DEBUG_OBJECT (wav, "sending flush stop");
    gst_pad_push_event (wav->srcpad, gst_event_new_flush_stop (TRUE));
  }

  /* now we did the seek and can activate the new segment values */
  memcpy (&wav->segment, &seeksegment, sizeof (GstSegment));

  /* if we're doing a segment seek, post a SEGMENT_START message */
  if (wav->segment.flags & GST_SEEK_FLAG_SEGMENT) {
    gst_element_post_message (GST_ELEMENT_CAST (wav),
        gst_message_new_segment_start (GST_OBJECT_CAST (wav),
            wav->segment.format, wav->segment.position));
  }

  /* now create the newsegment */
  GST_DEBUG_OBJECT (wav, "Creating newsegment from %" G_GINT64_FORMAT
      " to %" G_GINT64_FORMAT, wav->segment.position, stop);

  /* store the newsegment event so it can be sent from the streaming thread. */
  if (wav->start_segment)
    gst_event_unref (wav->start_segment);
  wav->start_segment = gst_event_new_segment (&wav->segment);

  /* mark discont if we are going to stream from another position. */
  if (last_stop != wav->segment.position) {
    GST_DEBUG_OBJECT (wav, "mark DISCONT, we did a seek to another position");
    wav->discont = TRUE;
  }

  /* and start the streaming task again */
  if (!wav->streaming) {
    gst_pad_start_task (wav->sinkpad, (GstTaskFunction) gst_wavparse_loop,
        wav->sinkpad, NULL);
  }

  GST_PAD_STREAM_UNLOCK (wav->sinkpad);

  return TRUE;

  /* ERRORS */
negative_rate:
  {
    GST_DEBUG_OBJECT (wav, "negative playback rates are not supported yet.");
    return FALSE;
  }
no_format:
  {
    GST_DEBUG_OBJECT (wav, "unsupported format given, seek aborted.");
    return FALSE;
  }
no_position:
  {
    GST_DEBUG_OBJECT (wav,
        "Could not determine byte position for desired time");
    return FALSE;
  }
}

/*
 * gst_wavparse_peek_chunk_info:
 * @wav Wavparse object
 * @tag holder for tag
 * @size holder for tag size
 *
 * Peek next chunk info (tag and size)
 *
 * Returns: %TRUE when the chunk info (header) is available
 */
static gboolean
gst_wavparse_peek_chunk_info (GstWavParse * wav, guint32 * tag, guint32 * size)
{
  const guint8 *data = NULL;

  if (gst_adapter_available (wav->adapter) < 8)
    return FALSE;

  data = gst_adapter_map (wav->adapter, 8);
  *tag = GST_READ_UINT32_LE (data);
  *size = GST_READ_UINT32_LE (data + 4);
  gst_adapter_unmap (wav->adapter);

  GST_DEBUG ("Next chunk size is %u bytes, type %" GST_FOURCC_FORMAT, *size,
      GST_FOURCC_ARGS (*tag));

  return TRUE;
}

/*
 * gst_wavparse_peek_chunk:
 * @wav Wavparse object
 * @tag holder for tag
 * @size holder for tag size
 *
 * Peek enough data for one full chunk
 *
 * Returns: %TRUE when the full chunk is available
 */
static gboolean
gst_wavparse_peek_chunk (GstWavParse * wav, guint32 * tag, guint32 * size)
{
  guint32 peek_size = 0;
  guint available;

  if (!gst_wavparse_peek_chunk_info (wav, tag, size))
    return FALSE;

  /* size 0 -> empty data buffer would surprise most callers,
   * large size -> do not bother trying to squeeze that into adapter,
   * so we throw poor man's exception, which can be caught if caller really
   * wants to handle 0 size chunk */
  if (!(*size) || (*size) >= (1 << 30)) {
    GST_INFO ("Invalid/unexpected chunk size %u for tag %" GST_FOURCC_FORMAT,
        *size, GST_FOURCC_ARGS (*tag));
    /* chain should give up */
    wav->abort_buffering = TRUE;
    return FALSE;
  }
  peek_size = (*size + 1) & ~1;
  available = gst_adapter_available (wav->adapter);

  if (available >= (8 + peek_size)) {
    return TRUE;
  } else {
    GST_LOG ("but only %u bytes available now", available);
    return FALSE;
  }
}

/*
 * gst_wavparse_calculate_duration:
 * @wav: wavparse object
 *
 * Calculate duration on demand and store in @wav. Prefer bps, but use fact as a
 * fallback.
 *
 * Returns: %TRUE if duration is available.
 */
static gboolean
gst_wavparse_calculate_duration (GstWavParse * wav)
{
  if (wav->duration > 0)
    return TRUE;

  if (wav->bps > 0) {
    GST_INFO_OBJECT (wav, "Got datasize %" G_GUINT64_FORMAT, wav->datasize);
    wav->duration =
        gst_util_uint64_scale_ceil (wav->datasize, GST_SECOND,
        (guint64) wav->bps);
    GST_INFO_OBJECT (wav, "Got duration (bps) %" GST_TIME_FORMAT,
        GST_TIME_ARGS (wav->duration));
    return TRUE;
  } else if (wav->fact) {
    wav->duration =
        gst_util_uint64_scale_int_ceil (GST_SECOND, wav->fact, wav->rate);
    GST_INFO_OBJECT (wav, "Got duration (fact) %" GST_TIME_FORMAT,
        GST_TIME_ARGS (wav->duration));
    return TRUE;
  }
  return FALSE;
}

static gboolean
gst_waveparse_ignore_chunk (GstWavParse * wav, GstBuffer * buf, guint32 tag,
    guint32 size)
{
  guint flush;

  if (wav->streaming) {
    if (!gst_wavparse_peek_chunk (wav, &tag, &size))
      return FALSE;
  }
  GST_DEBUG_OBJECT (wav, "Ignoring tag %" GST_FOURCC_FORMAT,
      GST_FOURCC_ARGS (tag));
  flush = 8 + ((size + 1) & ~1);
  wav->offset += flush;
  if (wav->streaming) {
    gst_adapter_flush (wav->adapter, flush);
  } else {
    gst_buffer_unref (buf);
  }

  return TRUE;
}

/*
 * gst_wavparse_cue_chunk:
 * @wav GstWavParse object
 * @data holder for data
 * @size holder for data size
 *
 * Parse cue chunk from @data to wav->cues.
 *
 * Returns: %TRUE when cue chunk is available
 */
static gboolean
gst_wavparse_cue_chunk (GstWavParse * wav, const guint8 * data, guint32 size)
{
  guint32 i, ncues;
  GList *cues = NULL;
  GstWavParseCue *cue;

  if (wav->cues) {
    GST_WARNING_OBJECT (wav, "found another cue's");
    return TRUE;
  }

  ncues = GST_READ_UINT32_LE (data);

  if (size < 4 + ncues * 24) {
    GST_WARNING_OBJECT (wav, "broken file %d %d", size, ncues);
    return FALSE;
  }

  /* parse data */
  data += 4;
  for (i = 0; i < ncues; i++) {
    cue = g_new0 (GstWavParseCue, 1);
    cue->id = GST_READ_UINT32_LE (data);
    cue->position = GST_READ_UINT32_LE (data + 4);
    cue->data_chunk_id = GST_READ_UINT32_LE (data + 8);
    cue->chunk_start = GST_READ_UINT32_LE (data + 12);
    cue->block_start = GST_READ_UINT32_LE (data + 16);
    cue->sample_offset = GST_READ_UINT32_LE (data + 20);
    cues = g_list_append (cues, cue);
    data += 24;
  }

  wav->cues = cues;

  return TRUE;
}

/*
 * gst_wavparse_labl_chunk:
 * @wav GstWavParse object
 * @data holder for data
 * @size holder for data size
 *
 * Parse labl from @data to wav->labls.
 *
 * Returns: %TRUE when labl chunk is available
 */
static gboolean
gst_wavparse_labl_chunk (GstWavParse * wav, const guint8 * data, guint32 size)
{
  GstWavParseLabl *labl;

  if (size < 5)
    return FALSE;

  labl = g_new0 (GstWavParseLabl, 1);

  /* parse data */
  data += 8;
  labl->cue_point_id = GST_READ_UINT32_LE (data);
  labl->text = g_memdup (data + 4, size - 4);

  wav->labls = g_list_append (wav->labls, labl);

  return TRUE;
}

/*
 * gst_wavparse_note_chunk:
 * @wav GstWavParse object
 * @data holder for data
 * @size holder for data size
 *
 * Parse note from @data to wav->notes.
 *
 * Returns: %TRUE when note chunk is available
 */
static gboolean
gst_wavparse_note_chunk (GstWavParse * wav, const guint8 * data, guint32 size)
{
  GstWavParseNote *note;

  if (size < 5)
    return FALSE;

  note = g_new0 (GstWavParseNote, 1);

  /* parse data */
  data += 8;
  note->cue_point_id = GST_READ_UINT32_LE (data);
  note->text = g_memdup (data + 4, size - 4);

  wav->notes = g_list_append (wav->notes, note);

  return TRUE;
}

/*
 * gst_wavparse_smpl_chunk:
 * @wav GstWavParse object
 * @data holder for data
 * @size holder for data size
 *
 * Parse smpl chunk from @data.
 *
 * Returns: %TRUE when cue chunk is available
 */
static gboolean
gst_wavparse_smpl_chunk (GstWavParse * wav, const guint8 * data, guint32 size)
{
  guint32 note_number;

  /*
     manufacturer_id = GST_READ_UINT32_LE (data);
     product_id = GST_READ_UINT32_LE (data + 4);
     sample_period = GST_READ_UINT32_LE (data + 8);
   */
  note_number = GST_READ_UINT32_LE (data + 12);
  /*
     pitch_fraction = GST_READ_UINT32_LE (data + 16);
     SMPTE_format = GST_READ_UINT32_LE (data + 20);
     SMPTE_offset = GST_READ_UINT32_LE (data + 24);
     num_sample_loops = GST_READ_UINT32_LE (data + 28);
     List of Sample Loops, 24 bytes each
   */

  if (!wav->tags)
    wav->tags = gst_tag_list_new_empty ();
  gst_tag_list_add (wav->tags, GST_TAG_MERGE_REPLACE,
      GST_TAG_MIDI_BASE_NOTE, (guint) note_number, NULL);
  return TRUE;
}

/*
 * gst_wavparse_adtl_chunk:
 * @wav GstWavParse object
 * @data holder for data
 * @size holder for data size
 *
 * Parse adtl from @data.
 *
 * Returns: %TRUE when adtl chunk is available
 */
static gboolean
gst_wavparse_adtl_chunk (GstWavParse * wav, const guint8 * data, guint32 size)
{
  guint32 ltag, lsize, offset = 0;

  while (size >= 8) {
    ltag = GST_READ_UINT32_LE (data + offset);
    lsize = GST_READ_UINT32_LE (data + offset + 4);
    switch (ltag) {
      case GST_RIFF_TAG_labl:
        gst_wavparse_labl_chunk (wav, data + offset, size);
        break;
      case GST_RIFF_TAG_note:
        gst_wavparse_note_chunk (wav, data + offset, size);
        break;
      default:
        GST_WARNING_OBJECT (wav, "Unknowm adtl %" GST_FOURCC_FORMAT,
            GST_FOURCC_ARGS (ltag));
        GST_MEMDUMP_OBJECT (wav, "Unknowm adtl", &data[offset], lsize);
        break;
    }
    offset += 8 + GST_ROUND_UP_2 (lsize);
    size -= 8 + GST_ROUND_UP_2 (lsize);
  }

  return TRUE;
}

static GstTagList *
gst_wavparse_get_tags_toc_entry (GstToc * toc, gchar * id)
{
  GstTagList *tags = NULL;
  GstTocEntry *entry = NULL;

  entry = gst_toc_find_entry (toc, id);
  if (entry != NULL) {
    tags = gst_toc_entry_get_tags (entry);
    if (tags == NULL) {
      tags = gst_tag_list_new_empty ();
      gst_toc_entry_set_tags (entry, tags);
    }
  }

  return tags;
}

/*
 * gst_wavparse_create_toc:
 * @wav GstWavParse object
 *
 * Create TOC from wav->cues and wav->labls.
 */
static gboolean
gst_wavparse_create_toc (GstWavParse * wav)
{
  gint64 start, stop;
  gchar *id;
  GList *list;
  GstWavParseCue *cue;
  GstWavParseLabl *labl;
  GstWavParseNote *note;
  GstTagList *tags;
  GstToc *toc;
  GstTocEntry *entry = NULL, *cur_subentry = NULL, *prev_subentry = NULL;

  GST_OBJECT_LOCK (wav);
  if (wav->toc) {
    GST_OBJECT_UNLOCK (wav);
    GST_WARNING_OBJECT (wav, "found another TOC");
    return FALSE;
  }

  if (!wav->cues) {
    GST_OBJECT_UNLOCK (wav);
    return TRUE;
  }

  /* FIXME: send CURRENT scope toc too */
  toc = gst_toc_new (GST_TOC_SCOPE_GLOBAL);

  /* add cue edition */
  entry = gst_toc_entry_new (GST_TOC_ENTRY_TYPE_EDITION, "cue");
  gst_toc_entry_set_start_stop_times (entry, 0, wav->duration);
  gst_toc_append_entry (toc, entry);

  /* add tracks in cue edition */
  list = wav->cues;
  while (list) {
    cue = list->data;
    prev_subentry = cur_subentry;
    /* previous track stop time = current track start time */
    if (prev_subentry != NULL) {
      gst_toc_entry_get_start_stop_times (prev_subentry, &start, NULL);
      stop = gst_util_uint64_scale_round (cue->position, GST_SECOND, wav->rate);
      gst_toc_entry_set_start_stop_times (prev_subentry, start, stop);
    }
    id = g_strdup_printf ("%08x", cue->id);
    cur_subentry = gst_toc_entry_new (GST_TOC_ENTRY_TYPE_TRACK, id);
    g_free (id);
    start = gst_util_uint64_scale_round (cue->position, GST_SECOND, wav->rate);
    stop = wav->duration;
    gst_toc_entry_set_start_stop_times (cur_subentry, start, stop);
    gst_toc_entry_append_sub_entry (entry, cur_subentry);
    list = g_list_next (list);
  }

  /* add tags in tracks */
  list = wav->labls;
  while (list) {
    labl = list->data;
    id = g_strdup_printf ("%08x", labl->cue_point_id);
    tags = gst_wavparse_get_tags_toc_entry (toc, id);
    g_free (id);
    if (tags != NULL) {
      gst_tag_list_add (tags, GST_TAG_MERGE_APPEND, GST_TAG_TITLE, labl->text,
          NULL);
    }
    list = g_list_next (list);
  }
  list = wav->notes;
  while (list) {
    note = list->data;
    id = g_strdup_printf ("%08x", note->cue_point_id);
    tags = gst_wavparse_get_tags_toc_entry (toc, id);
    g_free (id);
    if (tags != NULL) {
      gst_tag_list_add (tags, GST_TAG_MERGE_PREPEND, GST_TAG_COMMENT,
          note->text, NULL);
    }
    list = g_list_next (list);
  }

  /* send data as TOC */
  wav->toc = toc;

  /* send TOC event */
  if (wav->toc) {
    GST_OBJECT_UNLOCK (wav);
    gst_pad_push_event (wav->srcpad, gst_event_new_toc (wav->toc, FALSE));
  }

  return TRUE;
}

#define MAX_BUFFER_SIZE 4096

static GstFlowReturn
gst_wavparse_stream_headers (GstWavParse * wav)
{
  GstFlowReturn res = GST_FLOW_OK;
  GstBuffer *buf = NULL;
  gst_riff_strf_auds *header = NULL;
  guint32 tag, size;
  gboolean gotdata = FALSE;
  GstCaps *caps = NULL;
  gchar *codec_name = NULL;
  GstEvent **event_p;
  gint64 upstream_size = 0;
  GstStructure *s;

  /* search for "_fmt" chunk, which should be first */
  while (!wav->got_fmt) {
    GstBuffer *extra;

    /* The header starts with a 'fmt ' tag */
    if (wav->streaming) {
      if (!gst_wavparse_peek_chunk (wav, &tag, &size))
        return res;

      gst_adapter_flush (wav->adapter, 8);
      wav->offset += 8;

      if (size) {
        buf = gst_adapter_take_buffer (wav->adapter, size);
        if (size & 1)
          gst_adapter_flush (wav->adapter, 1);
        wav->offset += GST_ROUND_UP_2 (size);
      } else {
        buf = gst_buffer_new ();
      }
    } else {
      if ((res = gst_riff_read_chunk (GST_ELEMENT_CAST (wav), wav->sinkpad,
                  &wav->offset, &tag, &buf)) != GST_FLOW_OK)
        return res;
    }

    if (tag == GST_RIFF_TAG_JUNK || tag == GST_RIFF_TAG_JUNQ ||
        tag == GST_RIFF_TAG_bext || tag == GST_RIFF_TAG_BEXT ||
        tag == GST_RIFF_TAG_LIST || tag == GST_RIFF_TAG_ID32 ||
        tag == GST_RIFF_TAG_id3 || tag == GST_RIFF_TAG_IDVX ||
        tag == GST_BWF_TAG_iXML || tag == GST_BWF_TAG_qlty ||
        tag == GST_BWF_TAG_mext || tag == GST_BWF_TAG_levl ||
        tag == GST_BWF_TAG_link || tag == GST_BWF_TAG_axml) {
      GST_DEBUG_OBJECT (wav, "skipping %" GST_FOURCC_FORMAT " chunk",
          GST_FOURCC_ARGS (tag));
      gst_buffer_unref (buf);
      buf = NULL;
      continue;
    }

    if (tag != GST_RIFF_TAG_fmt)
      goto invalid_wav;

    if (!(gst_riff_parse_strf_auds (GST_ELEMENT_CAST (wav), buf, &header,
                &extra)))
      goto parse_header_error;

    buf = NULL;                 /* parse_strf_auds() took ownership of buffer */

    /* do sanity checks of header fields */
    if (header->channels == 0)
      goto no_channels;
    if (header->rate == 0)
      goto no_rate;

    GST_DEBUG_OBJECT (wav, "creating the caps");

    /* Note: gst_riff_create_audio_caps might need to fix values in
     * the header header depending on the format, so call it first */
    /* FIXME: Need to handle the channel reorder map */
    caps = gst_riff_create_audio_caps (header->format, NULL, header, extra,
        NULL, &codec_name, NULL);

    if (extra)
      gst_buffer_unref (extra);

    if (!caps)
      goto unknown_format;

    /* If we got raw audio from upstream, we remove the codec_data field,
     * which may have been added if the wav header included an extended
     * chunk. We want to keep it for non raw audio.
     */
    s = gst_caps_get_structure (caps, 0);
    if (s && gst_structure_has_name (s, "audio/x-raw")) {
      gst_structure_remove_field (s, "codec_data");
    }

    /* do more sanity checks of header fields
     * (these can be sanitized by gst_riff_create_audio_caps()
     */
    wav->format = header->format;
    wav->rate = header->rate;
    wav->channels = header->channels;
    wav->blockalign = header->blockalign;
    wav->depth = header->bits_per_sample;
    wav->av_bps = header->av_bps;
    wav->vbr = FALSE;

    g_free (header);
    header = NULL;

    /* do format specific handling */
    switch (wav->format) {
      case GST_RIFF_WAVE_FORMAT_MPEGL12:
      case GST_RIFF_WAVE_FORMAT_MPEGL3:
      {
        /* Note: workaround for mp2/mp3 embedded in wav, that relies on the
         * bitrate inside the mpeg stream */
        GST_INFO ("resetting bps from %u to 0 for mp2/3", wav->av_bps);
        wav->bps = 0;
        break;
      }
      case GST_RIFF_WAVE_FORMAT_PCM:
        if (wav->blockalign > wav->channels * ((wav->depth + 7) / 8))
          goto invalid_blockalign;
        /* fall through */
      default:
        if (wav->av_bps > wav->blockalign * wav->rate)
          goto invalid_bps;
        /* use the configured bps */
        wav->bps = wav->av_bps;
        break;
    }

    wav->width = (wav->blockalign * 8) / wav->channels;
    wav->bytes_per_sample = wav->channels * wav->width / 8;

    if (wav->bytes_per_sample <= 0)
      goto no_bytes_per_sample;

    GST_DEBUG_OBJECT (wav, "blockalign = %u", (guint) wav->blockalign);
    GST_DEBUG_OBJECT (wav, "width      = %u", (guint) wav->width);
    GST_DEBUG_OBJECT (wav, "depth      = %u", (guint) wav->depth);
    GST_DEBUG_OBJECT (wav, "av_bps     = %u", (guint) wav->av_bps);
    GST_DEBUG_OBJECT (wav, "frequency  = %u", (guint) wav->rate);
    GST_DEBUG_OBJECT (wav, "channels   = %u", (guint) wav->channels);
    GST_DEBUG_OBJECT (wav, "bytes_per_sample = %u", wav->bytes_per_sample);

    /* bps can be 0 when we don't have a valid bitrate (mostly for compressed
     * formats). This will make the element output a BYTE format segment and
     * will not timestamp the outgoing buffers.
     */
    GST_DEBUG_OBJECT (wav, "bps        = %u", (guint) wav->bps);

    GST_DEBUG_OBJECT (wav, "caps = %" GST_PTR_FORMAT, caps);

    /* create pad later so we can sniff the first few bytes
     * of the real data and correct our caps if necessary */
    gst_caps_replace (&wav->caps, caps);
    gst_caps_replace (&caps, NULL);

    wav->got_fmt = TRUE;

    if (codec_name) {
      wav->tags = gst_tag_list_new_empty ();

      gst_tag_list_add (wav->tags, GST_TAG_MERGE_REPLACE,
          GST_TAG_AUDIO_CODEC, codec_name, NULL);

      g_free (codec_name);
      codec_name = NULL;
    }

  }

  gst_pad_peer_query_duration (wav->sinkpad, GST_FORMAT_BYTES, &upstream_size);
  GST_DEBUG_OBJECT (wav, "upstream size %" G_GUINT64_FORMAT, upstream_size);

  /* loop headers until we get data */
  while (!gotdata) {
    if (wav->streaming) {
      if (!gst_wavparse_peek_chunk_info (wav, &tag, &size))
        goto exit;
    } else {
      GstMapInfo map;

      buf = NULL;
      if ((res =
              gst_pad_pull_range (wav->sinkpad, wav->offset, 8,
                  &buf)) != GST_FLOW_OK)
        goto header_read_error;
      gst_buffer_map (buf, &map, GST_MAP_READ);
      tag = GST_READ_UINT32_LE (map.data);
      size = GST_READ_UINT32_LE (map.data + 4);
      gst_buffer_unmap (buf, &map);
    }

    GST_INFO_OBJECT (wav,
        "Got TAG: %" GST_FOURCC_FORMAT ", offset %" G_GUINT64_FORMAT,
        GST_FOURCC_ARGS (tag), wav->offset);

    /* wav is a st00pid format, we don't know for sure where data starts.
     * So we have to go bit by bit until we find the 'data' header
     */
    switch (tag) {
      case GST_RIFF_TAG_data:{
        GST_DEBUG_OBJECT (wav, "Got 'data' TAG, size : %u", size);
        if (wav->ignore_length) {
          GST_DEBUG_OBJECT (wav, "Ignoring length");
          size = 0;
        }
        if (wav->streaming) {
          gst_adapter_flush (wav->adapter, 8);
          gotdata = TRUE;
        } else {
          gst_buffer_unref (buf);
        }
        wav->offset += 8;
        wav->datastart = wav->offset;
        /* If size is zero, then the data chunk probably actually extends to
           the end of the file */
        if (size == 0 && upstream_size) {
          size = upstream_size - wav->datastart;
        }
        /* Or the file might be truncated */
        else if (upstream_size) {
          size = MIN (size, (upstream_size - wav->datastart));
        }
        wav->datasize = (guint64) size;
        wav->dataleft = (guint64) size;
        wav->end_offset = size + wav->datastart;
        if (!wav->streaming) {
          /* We will continue parsing tags 'till end */
          wav->offset += size;
        }
        GST_DEBUG_OBJECT (wav, "datasize = %u", size);
        break;
      }
      case GST_RIFF_TAG_fact:{
        if (wav->format != GST_RIFF_WAVE_FORMAT_MPEGL12 &&
            wav->format != GST_RIFF_WAVE_FORMAT_MPEGL3) {
          const guint data_size = 4;

          GST_INFO_OBJECT (wav, "Have fact chunk");
          if (size < data_size) {
            if (!gst_waveparse_ignore_chunk (wav, buf, tag, size)) {
              /* need more data */
              goto exit;
            }
            GST_DEBUG_OBJECT (wav, "need %u, available %u; ignoring chunk",
                data_size, size);
            break;
          }
          /* number of samples (for compressed formats) */
          if (wav->streaming) {
            const guint8 *data = NULL;

            if (!gst_wavparse_peek_chunk (wav, &tag, &size)) {
              goto exit;
            }
            gst_adapter_flush (wav->adapter, 8);
            data = gst_adapter_map (wav->adapter, data_size);
            wav->fact = GST_READ_UINT32_LE (data);
            gst_adapter_unmap (wav->adapter);
            gst_adapter_flush (wav->adapter, GST_ROUND_UP_2 (size));
          } else {
            gst_buffer_unref (buf);
            buf = NULL;
            if ((res =
                    gst_pad_pull_range (wav->sinkpad, wav->offset + 8,
                        data_size, &buf)) != GST_FLOW_OK)
              goto header_read_error;
            gst_buffer_extract (buf, 0, &wav->fact, 4);
            wav->fact = GUINT32_FROM_LE (wav->fact);
            gst_buffer_unref (buf);
          }
          GST_DEBUG_OBJECT (wav, "have fact %u", wav->fact);
          wav->offset += 8 + GST_ROUND_UP_2 (size);
          break;
        } else {
          if (!gst_waveparse_ignore_chunk (wav, buf, tag, size)) {
            /* need more data */
            goto exit;
          }
        }
        break;
      }
      case GST_RIFF_TAG_acid:{
        const gst_riff_acid *acid = NULL;
        const guint data_size = sizeof (gst_riff_acid);
        gfloat tempo;

        GST_INFO_OBJECT (wav, "Have acid chunk");
        if (size < data_size) {
          if (!gst_waveparse_ignore_chunk (wav, buf, tag, size)) {
            /* need more data */
            goto exit;
          }
          GST_DEBUG_OBJECT (wav, "need %u, available %u; ignoring chunk",
              data_size, size);
          break;
        }
        if (wav->streaming) {
          if (!gst_wavparse_peek_chunk (wav, &tag, &size)) {
            goto exit;
          }
          gst_adapter_flush (wav->adapter, 8);
          acid = (const gst_riff_acid *) gst_adapter_map (wav->adapter,
              data_size);
          tempo = acid->tempo;
          gst_adapter_unmap (wav->adapter);
        } else {
          GstMapInfo map;
          gst_buffer_unref (buf);
          buf = NULL;
          if ((res =
                  gst_pad_pull_range (wav->sinkpad, wav->offset + 8,
                      size, &buf)) != GST_FLOW_OK)
            goto header_read_error;
          gst_buffer_map (buf, &map, GST_MAP_READ);
          acid = (const gst_riff_acid *) map.data;
          tempo = acid->tempo;
          gst_buffer_unmap (buf, &map);
        }
        /* send data as tags */
        if (!wav->tags)
          wav->tags = gst_tag_list_new_empty ();
        gst_tag_list_add (wav->tags, GST_TAG_MERGE_REPLACE,
            GST_TAG_BEATS_PER_MINUTE, tempo, NULL);

        size = GST_ROUND_UP_2 (size);
        if (wav->streaming) {
          gst_adapter_flush (wav->adapter, size);
        } else {
          gst_buffer_unref (buf);
        }
        wav->offset += 8 + size;
        break;
      }
        /* FIXME: all list tags after data are ignored in streaming mode */
      case GST_RIFF_TAG_LIST:{
        guint32 ltag;

        if (wav->streaming) {
          const guint8 *data = NULL;

          if (gst_adapter_available (wav->adapter) < 12) {
            goto exit;
          }
          data = gst_adapter_map (wav->adapter, 12);
          ltag = GST_READ_UINT32_LE (data + 8);
          gst_adapter_unmap (wav->adapter);
        } else {
          gst_buffer_unref (buf);
          buf = NULL;
          if ((res =
                  gst_pad_pull_range (wav->sinkpad, wav->offset, 12,
                      &buf)) != GST_FLOW_OK)
            goto header_read_error;
          gst_buffer_extract (buf, 8, &ltag, 4);
          ltag = GUINT32_FROM_LE (ltag);
        }
        switch (ltag) {
          case GST_RIFF_LIST_INFO:{
            const gint data_size = size - 4;
            GstTagList *new;

            GST_INFO_OBJECT (wav, "Have LIST chunk INFO size %u", data_size);
            if (wav->streaming) {
              if (!gst_wavparse_peek_chunk (wav, &tag, &size)) {
                goto exit;
              }
              gst_adapter_flush (wav->adapter, 12);
              wav->offset += 12;
              if (data_size > 0) {
                buf = gst_adapter_take_buffer (wav->adapter, data_size);
                if (data_size & 1)
                  gst_adapter_flush (wav->adapter, 1);
              }
            } else {
              wav->offset += 12;
              gst_buffer_unref (buf);
              buf = NULL;
              if (data_size > 0) {
                if ((res =
                        gst_pad_pull_range (wav->sinkpad, wav->offset,
                            data_size, &buf)) != GST_FLOW_OK)
                  goto header_read_error;
              }
            }
            if (data_size > 0) {
              /* parse tags */
              gst_riff_parse_info (GST_ELEMENT (wav), buf, &new);
              if (new) {
                GstTagList *old = wav->tags;
                wav->tags =
                    gst_tag_list_merge (old, new, GST_TAG_MERGE_REPLACE);
                if (old)
                  gst_tag_list_unref (old);
                gst_tag_list_unref (new);
              }
              gst_buffer_unref (buf);
              wav->offset += GST_ROUND_UP_2 (data_size);
            }
            break;
          }
          case GST_RIFF_LIST_adtl:{
            const gint data_size = size;

            GST_INFO_OBJECT (wav, "Have 'adtl' LIST, size %u", data_size);
            if (wav->streaming) {
              const guint8 *data = NULL;

              gst_adapter_flush (wav->adapter, 12);
              data = gst_adapter_map (wav->adapter, data_size);
              gst_wavparse_adtl_chunk (wav, data, data_size);
              gst_adapter_unmap (wav->adapter);
            } else {
              GstMapInfo map;

              gst_buffer_unref (buf);
              buf = NULL;
              if ((res =
                      gst_pad_pull_range (wav->sinkpad, wav->offset + 12,
                          data_size, &buf)) != GST_FLOW_OK)
                goto header_read_error;
              gst_buffer_map (buf, &map, GST_MAP_READ);
              gst_wavparse_adtl_chunk (wav, (const guint8 *) map.data,
                  data_size);
              gst_buffer_unmap (buf, &map);
            }
            wav->offset += GST_ROUND_UP_2 (data_size);
            break;
          }
          default:
            GST_WARNING_OBJECT (wav, "Ignoring LIST chunk %" GST_FOURCC_FORMAT,
                GST_FOURCC_ARGS (ltag));
            if (!gst_waveparse_ignore_chunk (wav, buf, tag, size))
              /* need more data */
              goto exit;
            break;
        }
        break;
      }
      case GST_RIFF_TAG_cue:{
        const guint data_size = size;

        GST_DEBUG_OBJECT (wav, "Have 'cue' TAG, size : %u", data_size);
        if (wav->streaming) {
          const guint8 *data = NULL;

          if (!gst_wavparse_peek_chunk (wav, &tag, &size)) {
            goto exit;
          }
          gst_adapter_flush (wav->adapter, 8);
          wav->offset += 8;
          data = gst_adapter_map (wav->adapter, data_size);
          if (!gst_wavparse_cue_chunk (wav, data, data_size)) {
            goto header_read_error;
          }
          gst_adapter_unmap (wav->adapter);
        } else {
          GstMapInfo map;

          wav->offset += 8;
          gst_buffer_unref (buf);
          buf = NULL;
          if ((res =
                  gst_pad_pull_range (wav->sinkpad, wav->offset,
                      data_size, &buf)) != GST_FLOW_OK)
            goto header_read_error;
          gst_buffer_map (buf, &map, GST_MAP_READ);
          if (!gst_wavparse_cue_chunk (wav, (const guint8 *) map.data,
                  data_size)) {
            goto header_read_error;
          }
          gst_buffer_unmap (buf, &map);
        }
        size = GST_ROUND_UP_2 (size);
        if (wav->streaming) {
          gst_adapter_flush (wav->adapter, size);
        } else {
          gst_buffer_unref (buf);
        }
        size = GST_ROUND_UP_2 (size);
        wav->offset += size;
        break;
      }
      case GST_RIFF_TAG_smpl:{
        const gint data_size = size;

        GST_DEBUG_OBJECT (wav, "Have 'smpl' TAG, size : %u", data_size);
        if (wav->streaming) {
          const guint8 *data = NULL;

          if (!gst_wavparse_peek_chunk (wav, &tag, &size)) {
            goto exit;
          }
          gst_adapter_flush (wav->adapter, 8);
          wav->offset += 8;
          data = gst_adapter_map (wav->adapter, data_size);
          if (!gst_wavparse_smpl_chunk (wav, data, data_size)) {
            goto header_read_error;
          }
          gst_adapter_unmap (wav->adapter);
        } else {
          GstMapInfo map;

          wav->offset += 8;
          gst_buffer_unref (buf);
          buf = NULL;
          if ((res =
                  gst_pad_pull_range (wav->sinkpad, wav->offset,
                      data_size, &buf)) != GST_FLOW_OK)
            goto header_read_error;
          gst_buffer_map (buf, &map, GST_MAP_READ);
          if (!gst_wavparse_smpl_chunk (wav, (const guint8 *) map.data,
                  data_size)) {
            goto header_read_error;
          }
          gst_buffer_unmap (buf, &map);
        }
        size = GST_ROUND_UP_2 (size);
        if (wav->streaming) {
          gst_adapter_flush (wav->adapter, size);
        } else {
          gst_buffer_unref (buf);
        }
        size = GST_ROUND_UP_2 (size);
        wav->offset += size;
        break;
      }
      default:
        GST_WARNING_OBJECT (wav, "Ignoring chunk %" GST_FOURCC_FORMAT,
            GST_FOURCC_ARGS (tag));
        if (!gst_waveparse_ignore_chunk (wav, buf, tag, size))
          /* need more data */
          goto exit;
        break;
    }

    if (upstream_size && (wav->offset >= upstream_size)) {
      /* Now we are gone through the whole file */
      gotdata = TRUE;
    }
  }

  GST_DEBUG_OBJECT (wav, "Finished parsing headers");

  if (wav->bps <= 0 && wav->fact) {
#if 0
    /* not a good idea, as for embedded mp2/mp3 we set bps to 0 earlier */
    wav->bps =
        (guint32) gst_util_uint64_scale ((guint64) wav->rate, wav->datasize,
        (guint64) wav->fact);
    GST_INFO_OBJECT (wav, "calculated bps : %u, enabling VBR", wav->bps);
#endif
    wav->vbr = TRUE;
  }

  if (gst_wavparse_calculate_duration (wav)) {
    gst_segment_init (&wav->segment, GST_FORMAT_TIME);
    if (!wav->ignore_length)
      wav->segment.duration = wav->duration;
    if (!wav->toc)
      gst_wavparse_create_toc (wav);
  } else {
    /* no bitrate, let downstream peer do the math, we'll feed it bytes. */
    gst_segment_init (&wav->segment, GST_FORMAT_BYTES);
    if (!wav->ignore_length)
      wav->segment.duration = wav->datasize;
  }

  /* now we have all the info to perform a pending seek if any, if no
   * event, this will still do the right thing and it will also send
   * the right newsegment event downstream. */
  gst_wavparse_perform_seek (wav, wav->seek_event);
  /* remove pending event */
  event_p = &wav->seek_event;
  gst_event_replace (event_p, NULL);

  /* we just started, we are discont */
  wav->discont = TRUE;

  wav->state = GST_WAVPARSE_DATA;

  /* determine reasonable max buffer size,
   * that is, buffers not too small either size or time wise
   * so we do not end up with too many of them */
  /* var abuse */
  if (gst_wavparse_time_to_bytepos (wav, 40 * GST_MSECOND, &upstream_size))
    wav->max_buf_size = upstream_size;
  else
    wav->max_buf_size = 0;
  wav->max_buf_size = MAX (wav->max_buf_size, MAX_BUFFER_SIZE);
  if (wav->blockalign > 0)
    wav->max_buf_size -= (wav->max_buf_size % wav->blockalign);

  GST_DEBUG_OBJECT (wav, "max buffer size %u", wav->max_buf_size);

  return GST_FLOW_OK;

  /* ERROR */
exit:
  {
    if (codec_name)
      g_free (codec_name);
    if (header)
      g_free (header);
    if (caps)
      gst_caps_unref (caps);
    return res;
  }
fail:
  {
    res = GST_FLOW_ERROR;
    goto exit;
  }
invalid_wav:
  {
    GST_ELEMENT_ERROR (wav, STREAM, TYPE_NOT_FOUND, (NULL),
        ("Invalid WAV header (no fmt at start): %"
            GST_FOURCC_FORMAT, GST_FOURCC_ARGS (tag)));
    goto fail;
  }
parse_header_error:
  {
    GST_ELEMENT_ERROR (wav, STREAM, DEMUX, (NULL),
        ("Couldn't parse audio header"));
    goto fail;
  }
no_channels:
  {
    GST_ELEMENT_ERROR (wav, STREAM, FAILED, (NULL),
        ("Stream claims to contain no channels - invalid data"));
    goto fail;
  }
no_rate:
  {
    GST_ELEMENT_ERROR (wav, STREAM, FAILED, (NULL),
        ("Stream with sample_rate == 0 - invalid data"));
    goto fail;
  }
invalid_blockalign:
  {
    GST_ELEMENT_ERROR (wav, STREAM, FAILED, (NULL),
        ("Stream claims blockalign = %u, which is more than %u - invalid data",
            wav->blockalign, wav->channels * ((wav->depth + 7) / 8)));
    goto fail;
  }
invalid_bps:
  {
    GST_ELEMENT_ERROR (wav, STREAM, FAILED, (NULL),
        ("Stream claims av_bsp = %u, which is more than %u - invalid data",
            wav->av_bps, wav->blockalign * wav->rate));
    goto fail;
  }
no_bytes_per_sample:
  {
    GST_ELEMENT_ERROR (wav, STREAM, FAILED, (NULL),
        ("Could not caluclate bytes per sample - invalid data"));
    goto fail;
  }
unknown_format:
  {
    GST_ELEMENT_ERROR (wav, STREAM, TYPE_NOT_FOUND, (NULL),
        ("No caps found for format 0x%x, %u channels, %u Hz",
            wav->format, wav->channels, wav->rate));
    goto fail;
  }
header_read_error:
  {
    GST_ELEMENT_ERROR (wav, STREAM, DEMUX, (NULL),
        ("Couldn't read in header %d (%s)", res, gst_flow_get_name (res)));
    goto fail;
  }
}

/*
 * Read WAV file tag when streaming
 */
static GstFlowReturn
gst_wavparse_parse_stream_init (GstWavParse * wav)
{
  if (gst_adapter_available (wav->adapter) >= 12) {
    GstBuffer *tmp;

    /* _take flushes the data */
    tmp = gst_adapter_take_buffer (wav->adapter, 12);

    GST_DEBUG ("Parsing wav header");
    if (!gst_wavparse_parse_file_header (GST_ELEMENT_CAST (wav), tmp))
      return GST_FLOW_ERROR;

    wav->offset += 12;
    /* Go to next state */
    wav->state = GST_WAVPARSE_HEADER;
  }
  return GST_FLOW_OK;
}

/* handle an event sent directly to the element.
 *
 * This event can be sent either in the READY state or the
 * >READY state. The only event of interest really is the seek
 * event.
 *
 * In the READY state we can only store the event and try to
 * respect it when going to PAUSED. We assume we are in the
 * READY state when our parsing state != GST_WAVPARSE_DATA.
 *
 * When we are steaming, we can simply perform the seek right
 * away.
 */
static gboolean
gst_wavparse_send_event (GstElement * element, GstEvent * event)
{
  GstWavParse *wav = GST_WAVPARSE (element);
  gboolean res = FALSE;
  GstEvent **event_p;

  GST_DEBUG_OBJECT (wav, "received event %s", GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
      if (wav->state == GST_WAVPARSE_DATA) {
        /* we can handle the seek directly when streaming data */
        res = gst_wavparse_perform_seek (wav, event);
      } else {
        GST_DEBUG_OBJECT (wav, "queuing seek for later");

        event_p = &wav->seek_event;
        gst_event_replace (event_p, event);

        /* we always return true */
        res = TRUE;
      }
      break;
    default:
      break;
  }
  gst_event_unref (event);
  return res;
}

static gboolean
gst_wavparse_have_dts_caps (const GstCaps * caps, GstTypeFindProbability prob)
{
  GstStructure *s;

  s = gst_caps_get_structure (caps, 0);
  if (!gst_structure_has_name (s, "audio/x-dts"))
    return FALSE;
  if (prob >= GST_TYPE_FIND_LIKELY)
    return TRUE;
  /* DTS at non-0 offsets and without second sync may yield POSSIBLE .. */
  if (prob < GST_TYPE_FIND_POSSIBLE)
    return FALSE;
  /* .. in which case we want at least a valid-looking rate and channels */
  if (!gst_structure_has_field (s, "channels"))
    return FALSE;
  /* and for extra assurance we could also check the rate from the DTS frame
   * against the one in the wav header, but for now let's not do that */
  return gst_structure_has_field (s, "rate");
}

static GstTagList *
gst_wavparse_get_upstream_tags (GstWavParse * wav, GstTagScope scope)
{
  GstTagList *tags = NULL;
  GstEvent *ev;
  gint i;

  i = 0;
  while ((ev = gst_pad_get_sticky_event (wav->sinkpad, GST_EVENT_TAG, i++))) {
    gst_event_parse_tag (ev, &tags);
    if (tags != NULL && gst_tag_list_get_scope (tags) == scope) {
      tags = gst_tag_list_copy (tags);
      gst_tag_list_remove_tag (tags, GST_TAG_CONTAINER_FORMAT);
      gst_event_unref (ev);
      break;
    }
    tags = NULL;
    gst_event_unref (ev);
  }
  return tags;
}

static void
gst_wavparse_add_src_pad (GstWavParse * wav, GstBuffer * buf)
{
  GstStructure *s;
  GstTagList *tags, *utags;

  GST_DEBUG_OBJECT (wav, "adding src pad");

  g_assert (wav->caps != NULL);

  s = gst_caps_get_structure (wav->caps, 0);
  if (s && gst_structure_has_name (s, "audio/x-raw") && buf != NULL) {
    GstTypeFindProbability prob;
    GstCaps *tf_caps;

    tf_caps = gst_type_find_helper_for_buffer (GST_OBJECT (wav), buf, &prob);
    if (tf_caps != NULL) {
      GST_LOG ("typefind caps = %" GST_PTR_FORMAT ", P=%d", tf_caps, prob);
      if (gst_wavparse_have_dts_caps (tf_caps, prob)) {
        GST_INFO_OBJECT (wav, "Found DTS marker in file marked as raw PCM");
        gst_caps_unref (wav->caps);
        wav->caps = tf_caps;

        gst_tag_list_add (wav->tags, GST_TAG_MERGE_REPLACE,
            GST_TAG_AUDIO_CODEC, "dts", NULL);
      } else {
        GST_DEBUG_OBJECT (wav, "found caps %" GST_PTR_FORMAT " for stream "
            "marked as raw PCM audio, but ignoring for now", tf_caps);
        gst_caps_unref (tf_caps);
      }
    }
  }

  gst_pad_set_caps (wav->srcpad, wav->caps);
  gst_caps_replace (&wav->caps, NULL);

  if (wav->start_segment) {
    GST_DEBUG_OBJECT (wav, "Send start segment event on newpad");
    gst_pad_push_event (wav->srcpad, wav->start_segment);
    wav->start_segment = NULL;
  }

  /* upstream tags, e.g. from id3/ape tag before the wav file; assume for now
   * that there'll be only one scope/type of tag list from upstream, if any */
  utags = gst_wavparse_get_upstream_tags (wav, GST_TAG_SCOPE_GLOBAL);
  if (utags == NULL)
    utags = gst_wavparse_get_upstream_tags (wav, GST_TAG_SCOPE_STREAM);

  /* if there's a tag upstream it's probably been added to override the
   * tags from inside the wav header, so keep upstream tags if in doubt */
  tags = gst_tag_list_merge (utags, wav->tags, GST_TAG_MERGE_KEEP);

  if (wav->tags != NULL) {
    gst_tag_list_unref (wav->tags);
    wav->tags = NULL;
  }

  if (utags != NULL)
    gst_tag_list_unref (utags);

  /* send tags downstream, if any */
  if (tags != NULL)
    gst_pad_push_event (wav->srcpad, gst_event_new_tag (tags));
}

static GstFlowReturn
gst_wavparse_stream_data (GstWavParse * wav)
{
  GstBuffer *buf = NULL;
  GstFlowReturn res = GST_FLOW_OK;
  guint64 desired, obtained;
  GstClockTime timestamp, next_timestamp, duration;
  guint64 pos, nextpos;

iterate_adapter:
  GST_LOG_OBJECT (wav,
      "offset: %" G_GINT64_FORMAT " , end: %" G_GINT64_FORMAT " , dataleft: %"
      G_GINT64_FORMAT, wav->offset, wav->end_offset, wav->dataleft);

  /* Get the next n bytes and output them */
  if (wav->dataleft == 0 || wav->dataleft < wav->blockalign)
    goto found_eos;

  /* scale the amount of data by the segment rate so we get equal
   * amounts of data regardless of the playback rate */
  desired =
      MIN (gst_guint64_to_gdouble (wav->dataleft),
      wav->max_buf_size * ABS (wav->segment.rate));

  if (desired >= wav->blockalign && wav->blockalign > 0)
    desired -= (desired % wav->blockalign);

  GST_LOG_OBJECT (wav, "Fetching %" G_GINT64_FORMAT " bytes of data "
      "from the sinkpad", desired);

  if (wav->streaming) {
    guint avail = gst_adapter_available (wav->adapter);
    guint extra;

    /* flush some bytes if evil upstream sends segment that starts
     * before data or does is not send sample aligned segment */
    if (G_LIKELY (wav->offset >= wav->datastart)) {
      extra = (wav->offset - wav->datastart) % wav->bytes_per_sample;
    } else {
      extra = wav->datastart - wav->offset;
    }

    if (G_UNLIKELY (extra)) {
      extra = wav->bytes_per_sample - extra;
      if (extra <= avail) {
        GST_DEBUG_OBJECT (wav, "flushing %u bytes to sample boundary", extra);
        gst_adapter_flush (wav->adapter, extra);
        wav->offset += extra;
        wav->dataleft -= extra;
        goto iterate_adapter;
      } else {
        GST_DEBUG_OBJECT (wav, "flushing %u bytes", avail);
        gst_adapter_clear (wav->adapter);
        wav->offset += avail;
        wav->dataleft -= avail;
        return GST_FLOW_OK;
      }
    }

    if (avail < desired) {
      GST_LOG_OBJECT (wav, "Got only %u bytes of data from the sinkpad", avail);
      return GST_FLOW_OK;
    }

    buf = gst_adapter_take_buffer (wav->adapter, desired);
  } else {
    if ((res = gst_pad_pull_range (wav->sinkpad, wav->offset,
                desired, &buf)) != GST_FLOW_OK)
      goto pull_error;

    /* we may get a short buffer at the end of the file */
    if (gst_buffer_get_size (buf) < desired) {
      gsize size = gst_buffer_get_size (buf);

      GST_LOG_OBJECT (wav, "Got only %" G_GSIZE_FORMAT " bytes of data", size);
      if (size >= wav->blockalign) {
        if (wav->blockalign > 0) {
          buf = gst_buffer_make_writable (buf);
          gst_buffer_resize (buf, 0, size - (size % wav->blockalign));
        }
      } else {
        gst_buffer_unref (buf);
        goto found_eos;
      }
    }
  }

  obtained = gst_buffer_get_size (buf);

  /* our positions in bytes */
  pos = wav->offset - wav->datastart;
  nextpos = pos + obtained;

  /* update offsets, does not overflow. */
  buf = gst_buffer_make_writable (buf);
  GST_BUFFER_OFFSET (buf) = pos / wav->bytes_per_sample;
  GST_BUFFER_OFFSET_END (buf) = nextpos / wav->bytes_per_sample;

  /* first chunk of data? create the source pad. We do this only here so
   * we can detect broken .wav files with dts disguised as raw PCM (sigh) */
  if (G_UNLIKELY (wav->first)) {
    wav->first = FALSE;
    /* this will also push the segment events */
    gst_wavparse_add_src_pad (wav, buf);
  } else {
    /* If we have a pending start segment, send it now. */
    if (G_UNLIKELY (wav->start_segment != NULL)) {
      gst_pad_push_event (wav->srcpad, wav->start_segment);
      wav->start_segment = NULL;
    }
  }

  if (wav->bps > 0) {
    /* and timestamps if we have a bitrate, be careful for overflows */
    timestamp =
        gst_util_uint64_scale_ceil (pos, GST_SECOND, (guint64) wav->bps);
    next_timestamp =
        gst_util_uint64_scale_ceil (nextpos, GST_SECOND, (guint64) wav->bps);
    duration = next_timestamp - timestamp;

    /* update current running segment position */
    if (G_LIKELY (next_timestamp >= wav->segment.start))
      wav->segment.position = next_timestamp;
  } else if (wav->fact) {
    guint64 bps =
        gst_util_uint64_scale_int (wav->datasize, wav->rate, wav->fact);
    /* and timestamps if we have a bitrate, be careful for overflows */
    timestamp = gst_util_uint64_scale_ceil (pos, GST_SECOND, bps);
    next_timestamp = gst_util_uint64_scale_ceil (nextpos, GST_SECOND, bps);
    duration = next_timestamp - timestamp;
  } else {
    /* no bitrate, all we know is that the first sample has timestamp 0, all
     * other positions and durations have unknown timestamp. */
    if (pos == 0)
      timestamp = 0;
    else
      timestamp = GST_CLOCK_TIME_NONE;
    duration = GST_CLOCK_TIME_NONE;
    /* update current running segment position with byte offset */
    if (G_LIKELY (nextpos >= wav->segment.start))
      wav->segment.position = nextpos;
  }
  if ((pos > 0) && wav->vbr) {
    /* don't set timestamps for VBR files if it's not the first buffer */
    timestamp = GST_CLOCK_TIME_NONE;
    duration = GST_CLOCK_TIME_NONE;
  }
  if (wav->discont) {
    GST_DEBUG_OBJECT (wav, "marking DISCONT");
    GST_BUFFER_FLAG_SET (buf, GST_BUFFER_FLAG_DISCONT);
    wav->discont = FALSE;
  }

  GST_BUFFER_TIMESTAMP (buf) = timestamp;
  GST_BUFFER_DURATION (buf) = duration;

  GST_LOG_OBJECT (wav,
      "Got buffer. timestamp:%" GST_TIME_FORMAT " , duration:%" GST_TIME_FORMAT
      ", size:%" G_GSIZE_FORMAT, GST_TIME_ARGS (timestamp),
      GST_TIME_ARGS (duration), gst_buffer_get_size (buf));

  if ((res = gst_pad_push (wav->srcpad, buf)) != GST_FLOW_OK)
    goto push_error;

  if (obtained < wav->dataleft) {
    wav->offset += obtained;
    wav->dataleft -= obtained;
  } else {
    wav->offset += wav->dataleft;
    wav->dataleft = 0;
  }

  /* Iterate until need more data, so adapter size won't grow */
  if (wav->streaming) {
    GST_LOG_OBJECT (wav,
        "offset: %" G_GINT64_FORMAT " , end: %" G_GINT64_FORMAT, wav->offset,
        wav->end_offset);
    goto iterate_adapter;
  }
  return res;

  /* ERROR */
found_eos:
  {
    GST_DEBUG_OBJECT (wav, "found EOS");
    return GST_FLOW_EOS;
  }
pull_error:
  {
    /* check if we got EOS */
    if (res == GST_FLOW_EOS)
      goto found_eos;

    GST_WARNING_OBJECT (wav,
        "Error getting %" G_GINT64_FORMAT " bytes from the "
        "sinkpad (dataleft = %" G_GINT64_FORMAT ")", desired, wav->dataleft);
    return res;
  }
push_error:
  {
    GST_INFO_OBJECT (wav,
        "Error pushing on srcpad %s:%s, reason %s, is linked? = %d",
        GST_DEBUG_PAD_NAME (wav->srcpad), gst_flow_get_name (res),
        gst_pad_is_linked (wav->srcpad));
    return res;
  }
}

static void
gst_wavparse_loop (GstPad * pad)
{
  GstFlowReturn ret;
  GstWavParse *wav = GST_WAVPARSE (GST_PAD_PARENT (pad));
  GstEvent *event;
  gchar *stream_id;

  GST_LOG_OBJECT (wav, "process data");

  switch (wav->state) {
    case GST_WAVPARSE_START:
      GST_INFO_OBJECT (wav, "GST_WAVPARSE_START");
      if ((ret = gst_wavparse_stream_init (wav)) != GST_FLOW_OK)
        goto pause;

      stream_id =
          gst_pad_create_stream_id (wav->srcpad, GST_ELEMENT_CAST (wav), NULL);
      event = gst_event_new_stream_start (stream_id);
      gst_event_set_group_id (event, gst_util_group_id_next ());
      gst_pad_push_event (wav->srcpad, event);
      g_free (stream_id);

      wav->state = GST_WAVPARSE_HEADER;
      /* fall-through */

    case GST_WAVPARSE_HEADER:
      GST_INFO_OBJECT (wav, "GST_WAVPARSE_HEADER");
      if ((ret = gst_wavparse_stream_headers (wav)) != GST_FLOW_OK)
        goto pause;

      wav->state = GST_WAVPARSE_DATA;
      GST_INFO_OBJECT (wav, "GST_WAVPARSE_DATA");
      /* fall-through */

    case GST_WAVPARSE_DATA:
      if ((ret = gst_wavparse_stream_data (wav)) != GST_FLOW_OK)
        goto pause;
      break;
    default:
      g_assert_not_reached ();
  }
  return;

  /* ERRORS */
pause:
  {
    const gchar *reason = gst_flow_get_name (ret);

    GST_DEBUG_OBJECT (wav, "pausing task, reason %s", reason);
    gst_pad_pause_task (pad);

    if (ret == GST_FLOW_EOS) {
      /* handle end-of-stream/segment */
      /* so align our position with the end of it, if there is one
       * this ensures a subsequent will arrive at correct base/acc time */
      if (wav->segment.format == GST_FORMAT_TIME) {
        if (wav->segment.rate > 0.0 &&
            GST_CLOCK_TIME_IS_VALID (wav->segment.stop))
          wav->segment.position = wav->segment.stop;
        else if (wav->segment.rate < 0.0)
          wav->segment.position = wav->segment.start;
      }
      if (wav->state == GST_WAVPARSE_START) {
        GST_ELEMENT_ERROR (wav, STREAM, WRONG_TYPE, (NULL),
            ("No valid input found before end of stream"));
        gst_pad_push_event (wav->srcpad, gst_event_new_eos ());
      } else {
        /* add pad before we perform EOS */
        if (G_UNLIKELY (wav->first)) {
          wav->first = FALSE;
          gst_wavparse_add_src_pad (wav, NULL);
        }

        /* perform EOS logic */
        if (wav->segment.flags & GST_SEEK_FLAG_SEGMENT) {
          GstClockTime stop;

          if ((stop = wav->segment.stop) == -1)
            stop = wav->segment.duration;

          gst_element_post_message (GST_ELEMENT_CAST (wav),
              gst_message_new_segment_done (GST_OBJECT_CAST (wav),
                  wav->segment.format, stop));
          gst_pad_push_event (wav->srcpad,
              gst_event_new_segment_done (wav->segment.format, stop));
        } else {
          gst_pad_push_event (wav->srcpad, gst_event_new_eos ());
        }
      }
    } else if (ret == GST_FLOW_NOT_LINKED || ret < GST_FLOW_EOS) {
      /* for fatal errors we post an error message, post the error
       * first so the app knows about the error first. */
      GST_ELEMENT_ERROR (wav, STREAM, FAILED,
          (_("Internal data flow error.")),
          ("streaming task paused, reason %s (%d)", reason, ret));
      gst_pad_push_event (wav->srcpad, gst_event_new_eos ());
    }
    return;
  }
}

static GstFlowReturn
gst_wavparse_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstFlowReturn ret;
  GstWavParse *wav = GST_WAVPARSE (parent);

  GST_LOG_OBJECT (wav, "adapter_push %" G_GSIZE_FORMAT " bytes",
      gst_buffer_get_size (buf));

  gst_adapter_push (wav->adapter, buf);

  switch (wav->state) {
    case GST_WAVPARSE_START:
      GST_INFO_OBJECT (wav, "GST_WAVPARSE_START");
      if ((ret = gst_wavparse_parse_stream_init (wav)) != GST_FLOW_OK)
        goto done;

      if (wav->state != GST_WAVPARSE_HEADER)
        break;

      /* otherwise fall-through */
    case GST_WAVPARSE_HEADER:
      GST_INFO_OBJECT (wav, "GST_WAVPARSE_HEADER");
      if ((ret = gst_wavparse_stream_headers (wav)) != GST_FLOW_OK)
        goto done;

      if (!wav->got_fmt || wav->datastart == 0)
        break;

      wav->state = GST_WAVPARSE_DATA;
      GST_INFO_OBJECT (wav, "GST_WAVPARSE_DATA");

      /* fall-through */
    case GST_WAVPARSE_DATA:
      if (buf && GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_DISCONT))
        wav->discont = TRUE;
      if ((ret = gst_wavparse_stream_data (wav)) != GST_FLOW_OK)
        goto done;
      break;
    default:
      g_return_val_if_reached (GST_FLOW_ERROR);
  }
done:
  if (G_UNLIKELY (wav->abort_buffering)) {
    wav->abort_buffering = FALSE;
    ret = GST_FLOW_ERROR;
    /* sort of demux/parse error */
    GST_ELEMENT_ERROR (wav, STREAM, DEMUX, (NULL), ("unhandled buffer size"));
  }

  return ret;
}

static GstFlowReturn
gst_wavparse_flush_data (GstWavParse * wav)
{
  GstFlowReturn ret = GST_FLOW_OK;
  guint av;

  if ((av = gst_adapter_available (wav->adapter)) > 0) {
    wav->dataleft = av;
    wav->end_offset = wav->offset + av;
    ret = gst_wavparse_stream_data (wav);
  }

  return ret;
}

static gboolean
gst_wavparse_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstWavParse *wav = GST_WAVPARSE (parent);
  gboolean ret = TRUE;

  GST_LOG_OBJECT (wav, "handling %s event", GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      /* discard, we'll come up with proper src caps */
      gst_event_unref (event);
      break;
    }
    case GST_EVENT_SEGMENT:
    {
      gint64 start, stop, offset = 0, end_offset = -1;
      GstSegment segment;

      /* some debug output */
      gst_event_copy_segment (event, &segment);
      GST_DEBUG_OBJECT (wav, "received newsegment %" GST_SEGMENT_FORMAT,
          &segment);

      if (wav->state != GST_WAVPARSE_DATA) {
        GST_DEBUG_OBJECT (wav, "still starting, eating event");
        goto exit;
      }

      /* now we are either committed to TIME or BYTE format,
       * and we only expect a BYTE segment, e.g. following a seek */
      if (segment.format == GST_FORMAT_BYTES) {
        /* handle (un)signed issues */
        start = segment.start;
        stop = segment.stop;
        if (start > 0) {
          offset = start;
          start -= wav->datastart;
          start = MAX (start, 0);
        }
        if (stop > 0) {
          end_offset = stop;
          segment.stop -= wav->datastart;
          segment.stop = MAX (stop, 0);
        }
        if (wav->segment.format == GST_FORMAT_TIME) {
          guint64 bps = wav->bps;

          /* operating in format TIME, so we can convert */
          if (!bps && wav->fact)
            bps =
                gst_util_uint64_scale_int (wav->datasize, wav->rate, wav->fact);
          if (bps) {
            if (start >= 0)
              start =
                  gst_util_uint64_scale_ceil (start, GST_SECOND,
                  (guint64) wav->bps);
            if (stop >= 0)
              stop =
                  gst_util_uint64_scale_ceil (stop, GST_SECOND,
                  (guint64) wav->bps);
          }
        }
      } else {
        GST_DEBUG_OBJECT (wav, "unsupported segment format, ignoring");
        goto exit;
      }

      segment.start = start;
      segment.stop = stop;

      /* accept upstream's notion of segment and distribute along */
      segment.format = wav->segment.format;
      segment.time = segment.position = segment.start;
      segment.duration = wav->segment.duration;
      segment.base = gst_segment_to_running_time (&wav->segment,
          GST_FORMAT_TIME, wav->segment.position);

      gst_segment_copy_into (&segment, &wav->segment);

      /* also store the newsegment event for the streaming thread */
      if (wav->start_segment)
        gst_event_unref (wav->start_segment);
      GST_DEBUG_OBJECT (wav, "Storing newseg %" GST_SEGMENT_FORMAT, &segment);
      wav->start_segment = gst_event_new_segment (&segment);

      /* stream leftover data in current segment */
      gst_wavparse_flush_data (wav);
      /* and set up streaming thread for next one */
      wav->offset = offset;
      wav->end_offset = end_offset;
      if (wav->end_offset > 0) {
        wav->dataleft = wav->end_offset - wav->offset;
      } else {
        /* infinity; upstream will EOS when done */
        wav->dataleft = G_MAXUINT64;
      }
    exit:
      gst_event_unref (event);
      break;
    }
    case GST_EVENT_EOS:
      if (wav->state == GST_WAVPARSE_START) {
        GST_ELEMENT_ERROR (wav, STREAM, WRONG_TYPE, (NULL),
            ("No valid input found before end of stream"));
      } else {
        /* add pad if needed so EOS is seen downstream */
        if (G_UNLIKELY (wav->first)) {
          wav->first = FALSE;
          gst_wavparse_add_src_pad (wav, NULL);
        } else {
          /* stream leftover data in current segment */
          gst_wavparse_flush_data (wav);
        }
      }

      /* fall-through */
    case GST_EVENT_FLUSH_STOP:
    {
      GstClockTime dur;

      gst_adapter_clear (wav->adapter);
      wav->discont = TRUE;
      dur = wav->segment.duration;
      gst_segment_init (&wav->segment, wav->segment.format);
      wav->segment.duration = dur;
      /* fall-through */
    }
    default:
      ret = gst_pad_event_default (wav->sinkpad, parent, event);
      break;
  }

  return ret;
}

#if 0
/* convert and query stuff */
static const GstFormat *
gst_wavparse_get_formats (GstPad * pad)
{
  static GstFormat formats[] = {
    GST_FORMAT_TIME,
    GST_FORMAT_BYTES,
    GST_FORMAT_DEFAULT,         /* a "frame", ie a set of samples per Hz */
    0
  };

  return formats;
}
#endif

static gboolean
gst_wavparse_pad_convert (GstPad * pad,
    GstFormat src_format, gint64 src_value,
    GstFormat * dest_format, gint64 * dest_value)
{
  GstWavParse *wavparse;
  gboolean res = TRUE;

  wavparse = GST_WAVPARSE (GST_PAD_PARENT (pad));

  if (*dest_format == src_format) {
    *dest_value = src_value;
    return TRUE;
  }

  if ((wavparse->bps == 0) && !wavparse->fact)
    goto no_bps_fact;

  GST_INFO_OBJECT (wavparse, "converting value from %s to %s",
      gst_format_get_name (src_format), gst_format_get_name (*dest_format));

  switch (src_format) {
    case GST_FORMAT_BYTES:
      switch (*dest_format) {
        case GST_FORMAT_DEFAULT:
          *dest_value = src_value / wavparse->bytes_per_sample;
          /* make sure we end up on a sample boundary */
          *dest_value -= *dest_value % wavparse->bytes_per_sample;
          break;
        case GST_FORMAT_TIME:
          /* src_value + datastart = offset */
          GST_INFO_OBJECT (wavparse,
              "src=%" G_GINT64_FORMAT ", offset=%" G_GINT64_FORMAT, src_value,
              wavparse->offset);
          if (wavparse->bps > 0)
            *dest_value = gst_util_uint64_scale_ceil (src_value, GST_SECOND,
                (guint64) wavparse->bps);
          else if (wavparse->fact) {
            guint64 bps = gst_util_uint64_scale_int_ceil (wavparse->datasize,
                wavparse->rate, wavparse->fact);

            *dest_value =
                gst_util_uint64_scale_int_ceil (src_value, GST_SECOND, bps);
          } else {
            res = FALSE;
          }
          break;
        default:
          res = FALSE;
          goto done;
      }
      break;

    case GST_FORMAT_DEFAULT:
      switch (*dest_format) {
        case GST_FORMAT_BYTES:
          *dest_value = src_value * wavparse->bytes_per_sample;
          break;
        case GST_FORMAT_TIME:
          *dest_value = gst_util_uint64_scale (src_value, GST_SECOND,
              (guint64) wavparse->rate);
          break;
        default:
          res = FALSE;
          goto done;
      }
      break;

    case GST_FORMAT_TIME:
      switch (*dest_format) {
        case GST_FORMAT_BYTES:
          if (wavparse->bps > 0)
            *dest_value = gst_util_uint64_scale (src_value,
                (guint64) wavparse->bps, GST_SECOND);
          else {
            guint64 bps = gst_util_uint64_scale_int (wavparse->datasize,
                wavparse->rate, wavparse->fact);

            *dest_value = gst_util_uint64_scale (src_value, bps, GST_SECOND);
          }
          /* make sure we end up on a sample boundary */
          *dest_value -= *dest_value % wavparse->blockalign;
          break;
        case GST_FORMAT_DEFAULT:
          *dest_value = gst_util_uint64_scale (src_value,
              (guint64) wavparse->rate, GST_SECOND);
          break;
        default:
          res = FALSE;
          goto done;
      }
      break;

    default:
      res = FALSE;
      goto done;
  }

done:
  return res;

  /* ERRORS */
no_bps_fact:
  {
    GST_DEBUG_OBJECT (wavparse, "bps 0 or no fact chunk, cannot convert");
    res = FALSE;
    goto done;
  }
}

/* handle queries for location and length in requested format */
static gboolean
gst_wavparse_pad_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  gboolean res = TRUE;
  GstWavParse *wav = GST_WAVPARSE (parent);

  /* only if we know */
  if (wav->state != GST_WAVPARSE_DATA) {
    return FALSE;
  }

  GST_LOG_OBJECT (pad, "%s query", GST_QUERY_TYPE_NAME (query));

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      gint64 curb;
      gint64 cur;
      GstFormat format;

      /* this is not very precise, as we have pushed severla buffer upstream for prerolling */
      curb = wav->offset - wav->datastart;
      gst_query_parse_position (query, &format, NULL);
      GST_INFO_OBJECT (wav, "pos query at %" G_GINT64_FORMAT, curb);

      switch (format) {
        case GST_FORMAT_BYTES:
          format = GST_FORMAT_BYTES;
          cur = curb;
          break;
        default:
          res = gst_wavparse_pad_convert (pad, GST_FORMAT_BYTES, curb,
              &format, &cur);
          break;
      }
      if (res)
        gst_query_set_position (query, format, cur);
      break;
    }
    case GST_QUERY_DURATION:
    {
      gint64 duration = 0;
      GstFormat format;

      if (wav->ignore_length) {
        res = FALSE;
        break;
      }

      gst_query_parse_duration (query, &format, NULL);

      switch (format) {
        case GST_FORMAT_BYTES:{
          format = GST_FORMAT_BYTES;
          duration = wav->datasize;
          break;
        }
        case GST_FORMAT_TIME:
          if ((res = gst_wavparse_calculate_duration (wav))) {
            duration = wav->duration;
          }
          break;
        default:
          res = FALSE;
          break;
      }
      if (res)
        gst_query_set_duration (query, format, duration);
      break;
    }
    case GST_QUERY_CONVERT:
    {
      gint64 srcvalue, dstvalue;
      GstFormat srcformat, dstformat;

      gst_query_parse_convert (query, &srcformat, &srcvalue,
          &dstformat, &dstvalue);
      res = gst_wavparse_pad_convert (pad, srcformat, srcvalue,
          &dstformat, &dstvalue);
      if (res)
        gst_query_set_convert (query, srcformat, srcvalue, dstformat, dstvalue);
      break;
    }
    case GST_QUERY_SEEKING:{
      GstFormat fmt;
      gboolean seekable = FALSE;

      gst_query_parse_seeking (query, &fmt, NULL, NULL, NULL);
      if (fmt == wav->segment.format) {
        if (wav->streaming) {
          GstQuery *q;

          q = gst_query_new_seeking (GST_FORMAT_BYTES);
          if ((res = gst_pad_peer_query (wav->sinkpad, q))) {
            gst_query_parse_seeking (q, &fmt, &seekable, NULL, NULL);
            GST_LOG_OBJECT (wav, "upstream BYTE seekable %d", seekable);
          }
          gst_query_unref (q);
        } else {
          GST_LOG_OBJECT (wav, "looping => seekable");
          seekable = TRUE;
          res = TRUE;
        }
      } else if (fmt == GST_FORMAT_TIME) {
        res = TRUE;
      }
      if (res) {
        gst_query_set_seeking (query, fmt, seekable, 0, wav->segment.duration);
      }
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }
  return res;
}

static gboolean
gst_wavparse_srcpad_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstWavParse *wavparse = GST_WAVPARSE (parent);
  gboolean res = FALSE;

  GST_DEBUG_OBJECT (wavparse, "%s event", GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
      /* can only handle events when we are in the data state */
      if (wavparse->state == GST_WAVPARSE_DATA) {
        res = gst_wavparse_perform_seek (wavparse, event);
      }
      gst_event_unref (event);
      break;

    case GST_EVENT_TOC_SELECT:
    {
      char *uid = NULL;
      GstTocEntry *entry = NULL;
      GstEvent *seek_event;
      gint64 start_pos;

      if (!wavparse->toc) {
        GST_DEBUG_OBJECT (wavparse, "no TOC to select");
        return FALSE;
      } else {
        gst_event_parse_toc_select (event, &uid);
        if (uid != NULL) {
          GST_OBJECT_LOCK (wavparse);
          entry = gst_toc_find_entry (wavparse->toc, uid);
          if (entry == NULL) {
            GST_OBJECT_UNLOCK (wavparse);
            GST_WARNING_OBJECT (wavparse, "no TOC entry with given UID: %s",
                uid);
            res = FALSE;
          } else {
            gst_toc_entry_get_start_stop_times (entry, &start_pos, NULL);
            GST_OBJECT_UNLOCK (wavparse);
            seek_event = gst_event_new_seek (1.0,
                GST_FORMAT_TIME,
                GST_SEEK_FLAG_FLUSH,
                GST_SEEK_TYPE_SET, start_pos, GST_SEEK_TYPE_SET, -1);
            res = gst_wavparse_perform_seek (wavparse, seek_event);
            gst_event_unref (seek_event);
          }
          g_free (uid);
        } else {
          GST_WARNING_OBJECT (wavparse, "received empty TOC select event");
          res = FALSE;
        }
      }
      gst_event_unref (event);
      break;
    }

    default:
      res = gst_pad_push_event (wavparse->sinkpad, event);
      break;
  }
  return res;
}

static gboolean
gst_wavparse_sink_activate (GstPad * sinkpad, GstObject * parent)
{
  GstWavParse *wav = GST_WAVPARSE (parent);
  GstQuery *query;
  gboolean pull_mode;

  if (wav->adapter) {
    gst_adapter_clear (wav->adapter);
    g_object_unref (wav->adapter);
    wav->adapter = NULL;
  }

  query = gst_query_new_scheduling ();

  if (!gst_pad_peer_query (sinkpad, query)) {
    gst_query_unref (query);
    goto activate_push;
  }

  pull_mode = gst_query_has_scheduling_mode_with_flags (query,
      GST_PAD_MODE_PULL, GST_SCHEDULING_FLAG_SEEKABLE);
  gst_query_unref (query);

  if (!pull_mode)
    goto activate_push;

  GST_DEBUG_OBJECT (sinkpad, "activating pull");
  wav->streaming = FALSE;
  return gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PULL, TRUE);

activate_push:
  {
    GST_DEBUG_OBJECT (sinkpad, "activating push");
    wav->streaming = TRUE;
    wav->adapter = gst_adapter_new ();
    return gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PUSH, TRUE);
  }
}


static gboolean
gst_wavparse_sink_activate_mode (GstPad * sinkpad, GstObject * parent,
    GstPadMode mode, gboolean active)
{
  gboolean res;

  switch (mode) {
    case GST_PAD_MODE_PUSH:
      res = TRUE;
      break;
    case GST_PAD_MODE_PULL:
      if (active) {
        /* if we have a scheduler we can start the task */
        res = gst_pad_start_task (sinkpad, (GstTaskFunction) gst_wavparse_loop,
            sinkpad, NULL);
      } else {
        res = gst_pad_stop_task (sinkpad);
      }
      break;
    default:
      res = FALSE;
      break;
  }
  return res;
}

static GstStateChangeReturn
gst_wavparse_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstWavParse *wav = GST_WAVPARSE (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      gst_wavparse_reset (wav);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      gst_wavparse_reset (wav);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      break;
    default:
      break;
  }
  return ret;
}

static void
gst_wavparse_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstWavParse *self;

  g_return_if_fail (GST_IS_WAVPARSE (object));
  self = GST_WAVPARSE (object);

  switch (prop_id) {
    case PROP_IGNORE_LENGTH:
      self->ignore_length = g_value_get_boolean (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (self, prop_id, pspec);
  }

}

static void
gst_wavparse_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstWavParse *self;

  g_return_if_fail (GST_IS_WAVPARSE (object));
  self = GST_WAVPARSE (object);

  switch (prop_id) {
    case PROP_IGNORE_LENGTH:
      g_value_set_boolean (value, self->ignore_length);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (self, prop_id, pspec);
  }
}

static gboolean
plugin_init (GstPlugin * plugin)
{
  gst_riff_init ();

  return gst_element_register (plugin, "wavparse", GST_RANK_PRIMARY,
      GST_TYPE_WAVPARSE);
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    wavparse,
    "Parse a .wav file into raw audio",
    plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN)
