/* GStreamer
 * Copyright (C) 2008 David Schleef <ds@schleef.org>
 * Copyright (C) 2011 Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>.
 * Copyright (C) 2011 Nokia Corporation. All rights reserved.
 *   Contact: Stefan Kost <stefan.kost@nokia.com>
 * Copyright (C) 2012 Collabora Ltd.
 *	Author : Edward Hervey <edward@collabora.com>
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
 * SECTION:gstvideodecoder
 * @short_description: Base class for video decoders
 * @see_also: 
 *
 * This base class is for video decoders turning encoded data into raw video
 * frames.
 *
 * The GstVideoDecoder base class and derived subclasses should cooperate as follows:
 * <orderedlist>
 * <listitem>
 *   <itemizedlist><title>Configuration</title>
 *   <listitem><para>
 *     Initially, GstVideoDecoder calls @start when the decoder element
 *     is activated, which allows the subclass to perform any global setup.
 *   </para></listitem>
 *   <listitem><para>
 *     GstVideoDecoder calls @set_format to inform the subclass of caps
 *     describing input video data that it is about to receive, including
 *     possibly configuration data.
 *     While unlikely, it might be called more than once, if changing input
 *     parameters require reconfiguration.
 *   </para></listitem>
 *   <listitem><para>
 *     Incoming data buffers are processed as needed, described in Data Processing below.
 *   </para></listitem>
 *   <listitem><para>
 *     GstVideoDecoder calls @stop at end of all processing.
 *   </para></listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist>
 *   <title>Data processing</title>
 *     <listitem><para>
 *       The base class gathers input data, and optionally allows subclass
 *       to parse this into subsequently manageable chunks, typically
 *       corresponding to and referred to as 'frames'.
 *     </para></listitem>
 *     <listitem><para>
 *       Each input frame is provided in turn to the subclass' @handle_frame callback.
 *       The ownership of the frame is given to the @handle_frame callback.
 *     </para></listitem>
 *     <listitem><para>
 *       If codec processing results in decoded data, the subclass should call
 *       @gst_video_decoder_finish_frame to have decoded data pushed.
 *       downstream. Otherwise, the subclass must call @gst_video_decoder_drop_frame, to
 *       allow the base class to do timestamp and offset tracking, and possibly to
 *       requeue the frame for a later attempt in the case of reverse playback.
 *     </para></listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist><title>Shutdown phase</title>
 *   <listitem><para>
 *     The GstVideoDecoder class calls @stop to inform the subclass that data
 *     parsing will be stopped.
 *   </para></listitem>
 *   </itemizedlist>
 * </listitem>
 * <listitem>
 *   <itemizedlist><title>Additional Notes</title>
 *   <listitem>
 *     <itemizedlist><title>Seeking/Flushing</title>
 *     <listitem><para>
 *   When the pipeline is seeked or otherwise flushed, the subclass is informed via a call
 *   to its @reset callback, with the hard parameter set to true. This indicates the
 *   subclass should drop any internal data queues and timestamps and prepare for a fresh
 *   set of buffers to arrive for parsing and decoding.
 *     </para></listitem>
 *     </itemizedlist>
 *   </listitem>
 *   <listitem>
 *     <itemizedlist><title>End Of Stream</title>
 *     <listitem><para>
 *   At end-of-stream, the subclass @parse function may be called some final times with the 
 *   at_eos parameter set to true, indicating that the element should not expect any more data
 *   to be arriving, and it should parse and remaining frames and call
 *   gst_video_decoder_have_frame() if possible.
 *     </para></listitem>
 *     </itemizedlist>
 *   </listitem>
 *   </itemizedlist>
 * </listitem>
 * </orderedlist>
 *
 * The subclass is responsible for providing pad template caps for
 * source and sink pads. The pads need to be named "sink" and "src". It also
 * needs to provide information about the ouptput caps, when they are known.
 * This may be when the base class calls the subclass' @set_format function,
 * though it might be during decoding, before calling
 * @gst_video_decoder_finish_frame. This is done via
 * @gst_video_decoder_set_output_state
 *
 * The subclass is also responsible for providing (presentation) timestamps
 * (likely based on corresponding input ones).  If that is not applicable
 * or possible, the base class provides limited framerate based interpolation.
 *
 * Similarly, the base class provides some limited (legacy) seeking support
 * if specifically requested by the subclass, as full-fledged support
 * should rather be left to upstream demuxer, parser or alike.  This simple
 * approach caters for seeking and duration reporting using estimated input
 * bitrates. To enable it, a subclass should call
 * @gst_video_decoder_set_estimate_rate to enable handling of incoming byte-streams.
 *
 * The base class provides some support for reverse playback, in particular
 * in case incoming data is not packetized or upstream does not provide
 * fragments on keyframe boundaries.  However, the subclass should then be prepared
 * for the parsing and frame processing stage to occur separately (in normal
 * forward processing, the latter immediately follows the former),
 * The subclass also needs to ensure the parsing stage properly marks keyframes,
 * unless it knows the upstream elements will do so properly for incoming data.
 *
 * The bare minimum that a functional subclass needs to implement is:
 * <itemizedlist>
 *   <listitem><para>Provide pad templates</para></listitem>
 *   <listitem><para>
 *      Inform the base class of output caps via @gst_video_decoder_set_output_state
 *   </para></listitem>
 *   <listitem><para>
 *      Parse input data, if it is not considered packetized from upstream
 *      Data will be provided to @parse which should invoke @gst_video_decoder_add_to_frame and
 *      @gst_video_decoder_have_frame to separate the data belonging to each video frame.
 *   </para></listitem>
 *   <listitem><para>
 *      Accept data in @handle_frame and provide decoded results to
 *      @gst_video_decoder_finish_frame, or call @gst_video_decoder_drop_frame.
 *   </para></listitem>
 * </itemizedlist>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

/* TODO
 *
 * * Add a flag/boolean for I-frame-only/image decoders so we can do extra
 *   features, like applying QoS on input (as opposed to after the frame is
 *   decoded).
 * * Add a flag/boolean for decoders that require keyframes, so the base
 *   class can automatically discard non-keyframes before one has arrived
 * * Detect reordered frame/timestamps and fix the pts/dts
 * * Support for GstIndex (or shall we not care ?)
 * * Calculate actual latency based on input/output timestamp/frame_number
 *   and if it exceeds the recorded one, save it and emit a GST_MESSAGE_LATENCY
 * * Emit latency message when it changes
 *
 */

/* Implementation notes:
 * The Video Decoder base class operates in 2 primary processing modes, depending
 * on whether forward or reverse playback is requested.
 *
 * Forward playback:
 *   * Incoming buffer -> @parse() -> add_to_frame()/have_frame() -> handle_frame() -> 
 *     push downstream
 *
 * Reverse playback is more complicated, since it involves gathering incoming data regions
 * as we loop backwards through the upstream data. The processing concept (using incoming
 * buffers as containing one frame each to simplify things) is:
 *
 * Upstream data we want to play:
 *  Buffer encoded order:  1  2  3  4  5  6  7  8  9  EOS
 *  Keyframe flag:            K        K        
 *  Groupings:             AAAAAAA  BBBBBBB  CCCCCCC
 *
 * Input:
 *  Buffer reception order:  7  8  9  4  5  6  1  2  3  EOS
 *  Keyframe flag:                       K        K
 *  Discont flag:            D        D        D
 *
 * - Each Discont marks a discont in the decoding order.
 * - The keyframes mark where we can start decoding.
 *
 * Initially, we prepend incoming buffers to the gather queue. Whenever the
 * discont flag is set on an incoming buffer, the gather queue is flushed out
 * before the new buffer is collected.
 *
 * The above data will be accumulated in the gather queue like this:
 *
 *   gather queue:  9  8  7
 *                        D
 *
 * Whe buffer 4 is received (with a DISCONT), we flush the gather queue like
 * this:
 *
 *   while (gather)
 *     take head of queue and prepend to parse queue (this reverses the sequence,
 *     so parse queue is 7 -> 8 -> 9)
 *
 *   Next, we process the parse queue, which now contains all un-parsed packets (including
 *   any leftover ones from the previous decode section)
 *
 *   for each buffer now in the parse queue:
 *     Call the subclass parse function, prepending each resulting frame to
 *     the parse_gather queue. Buffers which precede the first one that
 *     produces a parsed frame are retained in the parse queue for re-processing on
 *     the next cycle of parsing.
 *
 *   The parse_gather queue now contains frame objects ready for decoding, in reverse order.
 *   parse_gather: 9 -> 8 -> 7
 *
 *   while (parse_gather)
 *     Take the head of the queue and prepend it to the decode queue
 *     If the frame was a keyframe, process the decode queue
 *   decode is now 7-8-9
 *
 *  Processing the decode queue results in frames with attached output buffers
 *  stored in the 'output_queue' ready for outputting in reverse order.
 *
 * After we flushed the gather queue and parsed it, we add 4 to the (now empty) gather queue.
 * We get the following situation:
 *
 *  gather queue:    4
 *  decode queue:    7  8  9
 *
 * After we received 5 (Keyframe) and 6:
 *
 *  gather queue:    6  5  4
 *  decode queue:    7  8  9
 *
 * When we receive 1 (DISCONT) which triggers a flush of the gather queue:
 *
 *   Copy head of the gather queue (6) to decode queue:
 *
 *    gather queue:    5  4
 *    decode queue:    6  7  8  9
 *
 *   Copy head of the gather queue (5) to decode queue. This is a keyframe so we
 *   can start decoding.
 *
 *    gather queue:    4
 *    decode queue:    5  6  7  8  9
 *
 *   Decode frames in decode queue, store raw decoded data in output queue, we
 *   can take the head of the decode queue and prepend the decoded result in the
 *   output queue:
 *
 *    gather queue:    4
 *    decode queue:    
 *    output queue:    9  8  7  6  5
 *
 *   Now output all the frames in the output queue, picking a frame from the
 *   head of the queue.
 *
 *   Copy head of the gather queue (4) to decode queue, we flushed the gather
 *   queue and can now store input buffer in the gather queue:
 *
 *    gather queue:    1
 *    decode queue:    4
 *
 *  When we receive EOS, the queue looks like:
 *
 *    gather queue:    3  2  1
 *    decode queue:    4
 *
 *  Fill decode queue, first keyframe we copy is 2:
 *
 *    gather queue:    1
 *    decode queue:    2  3  4
 *
 *  Decoded output:
 *
 *    gather queue:    1
 *    decode queue:    
 *    output queue:    4  3  2
 *
 *  Leftover buffer 1 cannot be decoded and must be discarded.
 */

#include "gstvideodecoder.h"
#include "gstvideoutils.h"

#include <gst/video/video.h>
#include <gst/video/video-event.h>
#include <gst/video/gstvideopool.h>
#include <gst/video/gstvideometa.h>
#include <string.h>

GST_DEBUG_CATEGORY (videodecoder_debug);
#define GST_CAT_DEFAULT videodecoder_debug

#define GST_VIDEO_DECODER_GET_PRIVATE(obj)  \
    (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_VIDEO_DECODER, \
        GstVideoDecoderPrivate))

struct _GstVideoDecoderPrivate
{
  /* FIXME introduce a context ? */

  GstBufferPool *pool;
  GstAllocator *allocator;
  GstAllocationParams params;

  /* parse tracking */
  /* input data */
  GstAdapter *input_adapter;
  /* assembles current frame */
  GstAdapter *output_adapter;

  /* Whether we attempt to convert newsegment from bytes to
   * time using a bitrate estimation */
  gboolean do_estimate_rate;

  /* Whether input is considered packetized or not */
  gboolean packetized;

  /* Error handling */
  gint max_errors;
  gint error_count;
  gboolean had_output_data;
  gboolean had_input_data;

  gboolean needs_format;
  gboolean do_caps;

  /* ... being tracked here;
   * only available during parsing */
  GstVideoCodecFrame *current_frame;
  /* events that should apply to the current frame */
  GList *current_frame_events;
  /* events that should be pushed before the next frame */
  GList *pending_events;

  /* relative offset of input data */
  guint64 input_offset;
  /* relative offset of frame */
  guint64 frame_offset;
  /* tracking ts and offsets */
  GList *timestamps;

  /* last outgoing ts */
  GstClockTime last_timestamp_out;
  /* incoming pts - dts */
  GstClockTime pts_delta;
  gboolean reordered_output;

  /* reverse playback */
  /* collect input */
  GList *gather;
  /* to-be-parsed */
  GList *parse;
  /* collected parsed frames */
  GList *parse_gather;
  /* frames to be handled == decoded */
  GList *decode;
  /* collected output - of buffer objects, not frames */
  GList *output_queued;


  /* base_picture_number is the picture number of the reference picture */
  guint64 base_picture_number;
  /* combine with base_picture_number, framerate and calcs to yield (presentation) ts */
  GstClockTime base_timestamp;

  /* FIXME : reorder_depth is never set */
  int reorder_depth;
  int distance_from_sync;

  guint32 system_frame_number;
  guint32 decode_frame_number;

  GList *frames;                /* Protected with OBJECT_LOCK */
  GstVideoCodecState *input_state;
  GstVideoCodecState *output_state;     /* OBJECT_LOCK and STREAM_LOCK */
  gboolean output_state_changed;

  /* QoS properties */
  gdouble proportion;           /* OBJECT_LOCK */
  GstClockTime earliest_time;   /* OBJECT_LOCK */
  GstClockTime qos_frame_duration;      /* OBJECT_LOCK */
  gboolean discont;
  /* qos messages: frames dropped/processed */
  guint dropped;
  guint processed;

  /* Outgoing byte size ? */
  gint64 bytes_out;
  gint64 time;

  gint64 min_latency;
  gint64 max_latency;

  GstTagList *tags;
  gboolean tags_changed;
};

static GstElementClass *parent_class = NULL;
static void gst_video_decoder_class_init (GstVideoDecoderClass * klass);
static void gst_video_decoder_init (GstVideoDecoder * dec,
    GstVideoDecoderClass * klass);

static void gst_video_decoder_finalize (GObject * object);

static gboolean gst_video_decoder_setcaps (GstVideoDecoder * dec,
    GstCaps * caps);
static gboolean gst_video_decoder_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_video_decoder_src_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static GstFlowReturn gst_video_decoder_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buf);
static gboolean gst_video_decoder_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static GstStateChangeReturn gst_video_decoder_change_state (GstElement *
    element, GstStateChange transition);
static gboolean gst_video_decoder_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static void gst_video_decoder_reset (GstVideoDecoder * decoder, gboolean full,
    gboolean flush_hard);

static GstFlowReturn gst_video_decoder_decode_frame (GstVideoDecoder * decoder,
    GstVideoCodecFrame * frame);

static GstClockTime gst_video_decoder_get_frame_duration (GstVideoDecoder *
    decoder, GstVideoCodecFrame * frame);
static GstVideoCodecFrame *gst_video_decoder_new_frame (GstVideoDecoder *
    decoder);
static GstFlowReturn gst_video_decoder_clip_and_push_buf (GstVideoDecoder *
    decoder, GstBuffer * buf);
static GstFlowReturn gst_video_decoder_flush_parse (GstVideoDecoder * dec,
    gboolean at_eos);

static void gst_video_decoder_clear_queues (GstVideoDecoder * dec);

static gboolean gst_video_decoder_sink_event_default (GstVideoDecoder * decoder,
    GstEvent * event);
static gboolean gst_video_decoder_src_event_default (GstVideoDecoder * decoder,
    GstEvent * event);
static gboolean gst_video_decoder_decide_allocation_default (GstVideoDecoder *
    decoder, GstQuery * query);
static gboolean gst_video_decoder_propose_allocation_default (GstVideoDecoder *
    decoder, GstQuery * query);
static gboolean gst_video_decoder_negotiate_default (GstVideoDecoder * decoder);
static GstFlowReturn gst_video_decoder_parse_available (GstVideoDecoder * dec,
    gboolean at_eos, gboolean new_buffer);
static gboolean gst_video_decoder_negotiate_unlocked (GstVideoDecoder *
    decoder);
static gboolean gst_video_decoder_sink_query_default (GstVideoDecoder * decoder,
    GstQuery * query);
static gboolean gst_video_decoder_src_query_default (GstVideoDecoder * decoder,
    GstQuery * query);

/* we can't use G_DEFINE_ABSTRACT_TYPE because we need the klass in the _init
 * method to get to the padtemplates */
GType
gst_video_decoder_get_type (void)
{
  static volatile gsize type = 0;

  if (g_once_init_enter (&type)) {
    GType _type;
    static const GTypeInfo info = {
      sizeof (GstVideoDecoderClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_video_decoder_class_init,
      NULL,
      NULL,
      sizeof (GstVideoDecoder),
      0,
      (GInstanceInitFunc) gst_video_decoder_init,
    };

    _type = g_type_register_static (GST_TYPE_ELEMENT,
        "GstVideoDecoder", &info, G_TYPE_FLAG_ABSTRACT);
    g_once_init_leave (&type, _type);
  }
  return type;
}

static void
gst_video_decoder_class_init (GstVideoDecoderClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);

  GST_DEBUG_CATEGORY_INIT (videodecoder_debug, "videodecoder", 0,
      "Base Video Decoder");

  parent_class = g_type_class_peek_parent (klass);
  g_type_class_add_private (klass, sizeof (GstVideoDecoderPrivate));

  gobject_class->finalize = gst_video_decoder_finalize;

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_video_decoder_change_state);

  klass->sink_event = gst_video_decoder_sink_event_default;
  klass->src_event = gst_video_decoder_src_event_default;
  klass->decide_allocation = gst_video_decoder_decide_allocation_default;
  klass->propose_allocation = gst_video_decoder_propose_allocation_default;
  klass->negotiate = gst_video_decoder_negotiate_default;
  klass->sink_query = gst_video_decoder_sink_query_default;
  klass->src_query = gst_video_decoder_src_query_default;
}

static void
gst_video_decoder_init (GstVideoDecoder * decoder, GstVideoDecoderClass * klass)
{
  GstPadTemplate *pad_template;
  GstPad *pad;

  GST_DEBUG_OBJECT (decoder, "gst_video_decoder_init");

  decoder->priv = GST_VIDEO_DECODER_GET_PRIVATE (decoder);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (klass), "sink");
  g_return_if_fail (pad_template != NULL);

  decoder->sinkpad = pad = gst_pad_new_from_template (pad_template, "sink");

  gst_pad_set_chain_function (pad, GST_DEBUG_FUNCPTR (gst_video_decoder_chain));
  gst_pad_set_event_function (pad,
      GST_DEBUG_FUNCPTR (gst_video_decoder_sink_event));
  gst_pad_set_query_function (pad,
      GST_DEBUG_FUNCPTR (gst_video_decoder_sink_query));
  gst_element_add_pad (GST_ELEMENT (decoder), decoder->sinkpad);

  pad_template =
      gst_element_class_get_pad_template (GST_ELEMENT_CLASS (klass), "src");
  g_return_if_fail (pad_template != NULL);

  decoder->srcpad = pad = gst_pad_new_from_template (pad_template, "src");

  gst_pad_set_event_function (pad,
      GST_DEBUG_FUNCPTR (gst_video_decoder_src_event));
  gst_pad_set_query_function (pad,
      GST_DEBUG_FUNCPTR (gst_video_decoder_src_query));
  gst_pad_use_fixed_caps (pad);
  gst_element_add_pad (GST_ELEMENT (decoder), decoder->srcpad);

  gst_segment_init (&decoder->input_segment, GST_FORMAT_TIME);
  gst_segment_init (&decoder->output_segment, GST_FORMAT_TIME);

  g_rec_mutex_init (&decoder->stream_lock);

  decoder->priv->input_adapter = gst_adapter_new ();
  decoder->priv->output_adapter = gst_adapter_new ();
  decoder->priv->packetized = TRUE;
  decoder->priv->needs_format = FALSE;

  gst_video_decoder_reset (decoder, TRUE, TRUE);
}

static gboolean
gst_video_rawvideo_convert (GstVideoCodecState * state,
    GstFormat src_format, gint64 src_value,
    GstFormat * dest_format, gint64 * dest_value)
{
  gboolean res = FALSE;
  guint vidsize;
  guint fps_n, fps_d;

  g_return_val_if_fail (dest_format != NULL, FALSE);
  g_return_val_if_fail (dest_value != NULL, FALSE);

  if (src_format == *dest_format || src_value == 0 || src_value == -1) {
    *dest_value = src_value;
    return TRUE;
  }

  vidsize = GST_VIDEO_INFO_SIZE (&state->info);
  fps_n = GST_VIDEO_INFO_FPS_N (&state->info);
  fps_d = GST_VIDEO_INFO_FPS_D (&state->info);

  if (src_format == GST_FORMAT_BYTES &&
      *dest_format == GST_FORMAT_DEFAULT && vidsize) {
    /* convert bytes to frames */
    *dest_value = gst_util_uint64_scale_int (src_value, 1, vidsize);
    res = TRUE;
  } else if (src_format == GST_FORMAT_DEFAULT &&
      *dest_format == GST_FORMAT_BYTES && vidsize) {
    /* convert bytes to frames */
    *dest_value = src_value * vidsize;
    res = TRUE;
  } else if (src_format == GST_FORMAT_DEFAULT &&
      *dest_format == GST_FORMAT_TIME && fps_n) {
    /* convert frames to time */
    *dest_value = gst_util_uint64_scale (src_value, GST_SECOND * fps_d, fps_n);
    res = TRUE;
  } else if (src_format == GST_FORMAT_TIME &&
      *dest_format == GST_FORMAT_DEFAULT && fps_d) {
    /* convert time to frames */
    *dest_value = gst_util_uint64_scale (src_value, fps_n, GST_SECOND * fps_d);
    res = TRUE;
  } else if (src_format == GST_FORMAT_TIME &&
      *dest_format == GST_FORMAT_BYTES && fps_d && vidsize) {
    /* convert time to bytes */
    *dest_value = gst_util_uint64_scale (src_value,
        fps_n * (guint64) vidsize, GST_SECOND * fps_d);
    res = TRUE;
  } else if (src_format == GST_FORMAT_BYTES &&
      *dest_format == GST_FORMAT_TIME && fps_n && vidsize) {
    /* convert bytes to time */
    *dest_value = gst_util_uint64_scale (src_value,
        GST_SECOND * fps_d, fps_n * (guint64) vidsize);
    res = TRUE;
  }

  return res;
}

static gboolean
gst_video_encoded_video_convert (gint64 bytes, gint64 time,
    GstFormat src_format, gint64 src_value, GstFormat * dest_format,
    gint64 * dest_value)
{
  gboolean res = FALSE;

  g_return_val_if_fail (dest_format != NULL, FALSE);
  g_return_val_if_fail (dest_value != NULL, FALSE);

  if (G_UNLIKELY (src_format == *dest_format || src_value == 0 ||
          src_value == -1)) {
    if (dest_value)
      *dest_value = src_value;
    return TRUE;
  }

  if (bytes <= 0 || time <= 0) {
    GST_DEBUG ("not enough metadata yet to convert");
    goto exit;
  }

  switch (src_format) {
    case GST_FORMAT_BYTES:
      switch (*dest_format) {
        case GST_FORMAT_TIME:
          *dest_value = gst_util_uint64_scale (src_value, time, bytes);
          res = TRUE;
          break;
        default:
          res = FALSE;
      }
      break;
    case GST_FORMAT_TIME:
      switch (*dest_format) {
        case GST_FORMAT_BYTES:
          *dest_value = gst_util_uint64_scale (src_value, bytes, time);
          res = TRUE;
          break;
        default:
          res = FALSE;
      }
      break;
    default:
      GST_DEBUG ("unhandled conversion from %d to %d", src_format,
          *dest_format);
      res = FALSE;
  }

exit:
  return res;
}

static GstVideoCodecState *
_new_input_state (GstCaps * caps)
{
  GstVideoCodecState *state;
  GstStructure *structure;
  const GValue *codec_data;

  state = g_slice_new0 (GstVideoCodecState);
  state->ref_count = 1;
  gst_video_info_init (&state->info);
  if (G_UNLIKELY (!gst_video_info_from_caps (&state->info, caps)))
    goto parse_fail;
  state->caps = gst_caps_ref (caps);

  structure = gst_caps_get_structure (caps, 0);

  codec_data = gst_structure_get_value (structure, "codec_data");
  if (codec_data && G_VALUE_TYPE (codec_data) == GST_TYPE_BUFFER)
    state->codec_data = GST_BUFFER (g_value_dup_boxed (codec_data));

  return state;

parse_fail:
  {
    g_slice_free (GstVideoCodecState, state);
    return NULL;
  }
}

static GstVideoCodecState *
_new_output_state (GstVideoFormat fmt, guint width, guint height,
    GstVideoCodecState * reference)
{
  GstVideoCodecState *state;

  state = g_slice_new0 (GstVideoCodecState);
  state->ref_count = 1;
  gst_video_info_init (&state->info);
  gst_video_info_set_format (&state->info, fmt, width, height);

  if (reference) {
    GstVideoInfo *tgt, *ref;

    tgt = &state->info;
    ref = &reference->info;

    /* Copy over extra fields from reference state */
    tgt->interlace_mode = ref->interlace_mode;
    tgt->flags = ref->flags;
    /* only copy values that are not unknown so that we don't override the
     * defaults. subclasses should really fill these in when they know. */
    if (ref->chroma_site)
      tgt->chroma_site = ref->chroma_site;
    if (ref->colorimetry.range)
      tgt->colorimetry.range = ref->colorimetry.range;
    if (ref->colorimetry.matrix)
      tgt->colorimetry.matrix = ref->colorimetry.matrix;
    if (ref->colorimetry.transfer)
      tgt->colorimetry.transfer = ref->colorimetry.transfer;
    if (ref->colorimetry.primaries)
      tgt->colorimetry.primaries = ref->colorimetry.primaries;
    GST_DEBUG ("reference par %d/%d fps %d/%d",
        ref->par_n, ref->par_d, ref->fps_n, ref->fps_d);
    tgt->par_n = ref->par_n;
    tgt->par_d = ref->par_d;
    tgt->fps_n = ref->fps_n;
    tgt->fps_d = ref->fps_d;
  }

  GST_DEBUG ("reference par %d/%d fps %d/%d",
      state->info.par_n, state->info.par_d,
      state->info.fps_n, state->info.fps_d);

  return state;
}

static gboolean
gst_video_decoder_setcaps (GstVideoDecoder * decoder, GstCaps * caps)
{
  GstVideoDecoderClass *decoder_class;
  GstVideoCodecState *state;
  gboolean ret = TRUE;

  decoder_class = GST_VIDEO_DECODER_GET_CLASS (decoder);

  GST_DEBUG_OBJECT (decoder, "setcaps %" GST_PTR_FORMAT, caps);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  if (decoder->priv->input_state) {
    GST_DEBUG_OBJECT (decoder,
        "Checking if caps changed old %" GST_PTR_FORMAT " new %" GST_PTR_FORMAT,
        decoder->priv->input_state->caps, caps);
    if (gst_caps_is_equal (decoder->priv->input_state->caps, caps))
      goto caps_not_changed;
  }

  state = _new_input_state (caps);

  if (G_UNLIKELY (state == NULL))
    goto parse_fail;

  if (decoder_class->set_format)
    ret = decoder_class->set_format (decoder, state);

  if (!ret)
    goto refused_format;

  if (decoder->priv->input_state)
    gst_video_codec_state_unref (decoder->priv->input_state);
  decoder->priv->input_state = state;

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return ret;

caps_not_changed:
  {
    GST_DEBUG_OBJECT (decoder, "Caps did not change - ignore");
    GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
    return TRUE;
  }

  /* ERRORS */
parse_fail:
  {
    GST_WARNING_OBJECT (decoder, "Failed to parse caps");
    GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
    return FALSE;
  }

refused_format:
  {
    GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
    GST_WARNING_OBJECT (decoder, "Subclass refused caps");
    gst_video_codec_state_unref (state);
    return FALSE;
  }
}

static void
gst_video_decoder_finalize (GObject * object)
{
  GstVideoDecoder *decoder;

  decoder = GST_VIDEO_DECODER (object);

  GST_DEBUG_OBJECT (object, "finalize");

  g_rec_mutex_clear (&decoder->stream_lock);

  if (decoder->priv->input_adapter) {
    g_object_unref (decoder->priv->input_adapter);
    decoder->priv->input_adapter = NULL;
  }
  if (decoder->priv->output_adapter) {
    g_object_unref (decoder->priv->output_adapter);
    decoder->priv->output_adapter = NULL;
  }

  if (decoder->priv->input_state)
    gst_video_codec_state_unref (decoder->priv->input_state);
  if (decoder->priv->output_state)
    gst_video_codec_state_unref (decoder->priv->output_state);

  if (decoder->priv->pool) {
    gst_object_unref (decoder->priv->pool);
    decoder->priv->pool = NULL;
  }

  if (decoder->priv->allocator) {
    gst_object_unref (decoder->priv->allocator);
    decoder->priv->allocator = NULL;
  }

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/* hard == FLUSH, otherwise discont */
static GstFlowReturn
gst_video_decoder_flush (GstVideoDecoder * dec, gboolean hard)
{
  GstVideoDecoderClass *klass = GST_VIDEO_DECODER_GET_CLASS (dec);
  GstFlowReturn ret = GST_FLOW_OK;

  GST_LOG_OBJECT (dec, "flush hard %d", hard);

  /* Inform subclass */
  if (klass->reset) {
    GST_FIXME_OBJECT (dec, "GstVideoDecoder::reset() is deprecated");
    klass->reset (dec, hard);
  }

  if (klass->flush)
    klass->flush (dec);

  /* and get (re)set for the sequel */
  gst_video_decoder_reset (dec, FALSE, hard);

  return ret;
}

static gboolean
gst_video_decoder_push_event (GstVideoDecoder * decoder, GstEvent * event)
{
  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEGMENT:
    {
      GstSegment segment;

      GST_VIDEO_DECODER_STREAM_LOCK (decoder);

      gst_event_copy_segment (event, &segment);

      GST_DEBUG_OBJECT (decoder, "segment %" GST_SEGMENT_FORMAT, &segment);

      if (segment.format != GST_FORMAT_TIME) {
        GST_DEBUG_OBJECT (decoder, "received non TIME newsegment");
        GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
        break;
      }

      decoder->output_segment = segment;
      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      break;
    }
    default:
      break;
  }

  GST_DEBUG_OBJECT (decoder, "pushing event %s",
      gst_event_type_get_name (GST_EVENT_TYPE (event)));

  return gst_pad_push_event (decoder->srcpad, event);
}

static GstFlowReturn
gst_video_decoder_parse_available (GstVideoDecoder * dec, gboolean at_eos,
    gboolean new_buffer)
{
  GstVideoDecoderClass *decoder_class = GST_VIDEO_DECODER_GET_CLASS (dec);
  GstVideoDecoderPrivate *priv = dec->priv;
  GstFlowReturn ret = GST_FLOW_OK;
  gsize was_available, available;
  guint inactive = 0;

  available = gst_adapter_available (priv->input_adapter);

  while (available || new_buffer) {
    new_buffer = FALSE;
    /* current frame may have been parsed and handled,
     * so we need to set up a new one when asking subclass to parse */
    if (priv->current_frame == NULL)
      priv->current_frame = gst_video_decoder_new_frame (dec);

    was_available = available;
    ret = decoder_class->parse (dec, priv->current_frame,
        priv->input_adapter, at_eos);
    if (ret != GST_FLOW_OK)
      break;

    /* if the subclass returned success (GST_FLOW_OK), it is expected
     * to have collected and submitted a frame, i.e. it should have
     * called gst_video_decoder_have_frame(), or at least consumed a
     * few bytes through gst_video_decoder_add_to_frame().
     *
     * Otherwise, this is an implementation bug, and we error out
     * after 2 failed attempts */
    available = gst_adapter_available (priv->input_adapter);
    if (!priv->current_frame || available != was_available)
      inactive = 0;
    else if (++inactive == 2)
      goto error_inactive;
  }

  return ret;

  /* ERRORS */
error_inactive:
  {
    GST_ERROR_OBJECT (dec, "Failed to consume data. Error in subclass?");
    return GST_FLOW_ERROR;
  }
}

static GstFlowReturn
gst_video_decoder_drain_out (GstVideoDecoder * dec, gboolean at_eos)
{
  GstVideoDecoderClass *decoder_class = GST_VIDEO_DECODER_GET_CLASS (dec);
  GstVideoDecoderPrivate *priv = dec->priv;
  GstFlowReturn ret = GST_FLOW_OK;

  GST_VIDEO_DECODER_STREAM_LOCK (dec);

  if (dec->input_segment.rate > 0.0) {
    /* Forward mode, if unpacketized, give the child class
     * a final chance to flush out packets */
    if (!priv->packetized) {
      ret = gst_video_decoder_parse_available (dec, TRUE, FALSE);
    }

    if (at_eos) {
      if (decoder_class->finish)
        ret = decoder_class->finish (dec);
    }
  } else {
    /* Reverse playback mode */
    ret = gst_video_decoder_flush_parse (dec, TRUE);
  }

  GST_VIDEO_DECODER_STREAM_UNLOCK (dec);

  return ret;
}

static GList *
_flush_events (GstPad * pad, GList * events)
{
  GList *tmp;

  for (tmp = events; tmp; tmp = tmp->next) {
    if (GST_EVENT_TYPE (tmp->data) == GST_EVENT_EOS ||
        GST_EVENT_TYPE (tmp->data) == GST_EVENT_SEGMENT ||
        !GST_EVENT_IS_STICKY (tmp->data)) {
      gst_event_unref (tmp->data);
    } else {
      gst_pad_store_sticky_event (pad, GST_EVENT_CAST (tmp->data));
    }
  }
  g_list_free (events);

  return NULL;
}

static gboolean
gst_video_decoder_sink_event_default (GstVideoDecoder * decoder,
    GstEvent * event)
{
  GstVideoDecoderPrivate *priv;
  gboolean ret = FALSE;
  gboolean forward_immediate = FALSE;

  priv = decoder->priv;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_STREAM_START:
    {
      GstFlowReturn flow_ret = GST_FLOW_OK;

      flow_ret = gst_video_decoder_drain_out (decoder, FALSE);
      ret = (flow_ret == GST_FLOW_OK);

      GST_DEBUG_OBJECT (decoder, "received STREAM_START. Clearing taglist");
      GST_VIDEO_DECODER_STREAM_LOCK (decoder);
      /* Flush our merged taglist after a STREAM_START */
      if (priv->tags)
        gst_tag_list_unref (priv->tags);
      priv->tags = NULL;
      priv->tags_changed = FALSE;
      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

      /* Forward STREAM_START immediately. Everything is drained after
       * the STREAM_START event and we can forward this event immediately
       * now without having buffers out of order.
       */
      forward_immediate = TRUE;
      break;
    }
    case GST_EVENT_CAPS:
    {
      ret = TRUE;
      decoder->priv->do_caps = TRUE;
      gst_event_unref (event);
      event = NULL;
      break;
    }
    case GST_EVENT_EOS:
    {
      GstFlowReturn flow_ret = GST_FLOW_OK;

      flow_ret = gst_video_decoder_drain_out (decoder, TRUE);
      ret = (flow_ret == GST_FLOW_OK);

      /* Error out even if EOS was ok when we had input, but no output */
      if (ret && priv->had_input_data && !priv->had_output_data) {
        GST_ELEMENT_ERROR (decoder, STREAM, DECODE,
            ("No valid frames decoded before end of stream"),
            ("no valid frames found"));
      }

      /* Forward EOS immediately. This is required because no
       * buffer or serialized event will come after EOS and
       * nothing could trigger another _finish_frame() call.
       *
       * The subclass can override this behaviour by overriding
       * the ::sink_event() vfunc and not chaining up to the
       * parent class' ::sink_event() until a later time.
       */
      forward_immediate = TRUE;
      break;
    }
    case GST_EVENT_GAP:
    {
      GstFlowReturn flow_ret = GST_FLOW_OK;

      flow_ret = gst_video_decoder_drain_out (decoder, FALSE);
      ret = (flow_ret == GST_FLOW_OK);

      /* Forward GAP immediately. Everything is drained after
       * the GAP event and we can forward this event immediately
       * now without having buffers out of order.
       */
      forward_immediate = TRUE;
      break;
    }
    case GST_EVENT_CUSTOM_DOWNSTREAM:
    {
      gboolean in_still;
      GstFlowReturn flow_ret = GST_FLOW_OK;

      if (gst_video_event_parse_still_frame (event, &in_still)) {
        if (in_still) {
          GST_DEBUG_OBJECT (decoder, "draining current data for still-frame");
          flow_ret = gst_video_decoder_drain_out (decoder, FALSE);
          ret = (flow_ret == GST_FLOW_OK);
        }
        /* Forward STILL_FRAME immediately. Everything is drained after
         * the STILL_FRAME event and we can forward this event immediately
         * now without having buffers out of order.
         */
        forward_immediate = TRUE;
      }
      break;
    }
    case GST_EVENT_SEGMENT:
    {
      GstSegment segment;

      GST_VIDEO_DECODER_STREAM_LOCK (decoder);

      gst_event_copy_segment (event, &segment);

      if (segment.format == GST_FORMAT_TIME) {
        GST_DEBUG_OBJECT (decoder,
            "received TIME SEGMENT %" GST_SEGMENT_FORMAT, &segment);
      } else {
        gint64 start;

        GST_DEBUG_OBJECT (decoder,
            "received SEGMENT %" GST_SEGMENT_FORMAT, &segment);

        /* handle newsegment as a result from our legacy simple seeking */
        /* note that initial 0 should convert to 0 in any case */
        if (priv->do_estimate_rate &&
            gst_pad_query_convert (decoder->sinkpad, GST_FORMAT_BYTES,
                segment.start, GST_FORMAT_TIME, &start)) {
          /* best attempt convert */
          /* as these are only estimates, stop is kept open-ended to avoid
           * premature cutting */
          GST_DEBUG_OBJECT (decoder,
              "converted to TIME start %" GST_TIME_FORMAT,
              GST_TIME_ARGS (start));
          segment.start = start;
          segment.stop = GST_CLOCK_TIME_NONE;
          segment.time = start;
          /* replace event */
          gst_event_unref (event);
          event = gst_event_new_segment (&segment);
        } else {
          GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
          goto newseg_wrong_format;
        }
      }

      priv->base_timestamp = GST_CLOCK_TIME_NONE;
      priv->base_picture_number = 0;

      decoder->input_segment = segment;

      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      break;
    }
    case GST_EVENT_FLUSH_STOP:
    {
      GList *l;

      GST_VIDEO_DECODER_STREAM_LOCK (decoder);
      for (l = priv->frames; l; l = l->next) {
        GstVideoCodecFrame *frame = l->data;

        frame->events = _flush_events (decoder->srcpad, frame->events);
      }
      priv->current_frame_events = _flush_events (decoder->srcpad,
          decoder->priv->current_frame_events);

      /* well, this is kind of worse than a DISCONT */
      gst_video_decoder_flush (decoder, TRUE);
      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      /* Forward FLUSH_STOP immediately. This is required because it is
       * expected to be forwarded immediately and no buffers are queued
       * anyway.
       */
      forward_immediate = TRUE;
      break;
    }
    case GST_EVENT_TAG:
    {
      GstTagList *tags;

      gst_event_parse_tag (event, &tags);

      if (gst_tag_list_get_scope (tags) == GST_TAG_SCOPE_STREAM) {
        gst_video_decoder_merge_tags (decoder, tags, GST_TAG_MERGE_REPLACE);
        gst_event_unref (event);
        event = NULL;
        ret = TRUE;
      }
      break;
    }
    default:
      break;
  }

  /* Forward non-serialized events immediately, and all other
   * events which can be forwarded immediately without potentially
   * causing the event to go out of order with other events and
   * buffers as decided above.
   */
  if (event) {
    if (!GST_EVENT_IS_SERIALIZED (event) || forward_immediate) {
      ret = gst_video_decoder_push_event (decoder, event);
    } else {
      GST_VIDEO_DECODER_STREAM_LOCK (decoder);
      decoder->priv->current_frame_events =
          g_list_prepend (decoder->priv->current_frame_events, event);
      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      ret = TRUE;
    }
  }

  return ret;

newseg_wrong_format:
  {
    GST_DEBUG_OBJECT (decoder, "received non TIME newsegment");
    gst_event_unref (event);
    /* SWALLOW EVENT */
    return TRUE;
  }
}

static gboolean
gst_video_decoder_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstVideoDecoder *decoder;
  GstVideoDecoderClass *decoder_class;
  gboolean ret = FALSE;

  decoder = GST_VIDEO_DECODER (parent);
  decoder_class = GST_VIDEO_DECODER_GET_CLASS (decoder);

  GST_DEBUG_OBJECT (decoder, "received event %d, %s", GST_EVENT_TYPE (event),
      GST_EVENT_TYPE_NAME (event));

  if (decoder_class->sink_event)
    ret = decoder_class->sink_event (decoder, event);

  return ret;
}

/* perform upstream byte <-> time conversion (duration, seeking)
 * if subclass allows and if enough data for moderately decent conversion */
static inline gboolean
gst_video_decoder_do_byte (GstVideoDecoder * dec)
{
  return dec->priv->do_estimate_rate && (dec->priv->bytes_out > 0)
      && (dec->priv->time > GST_SECOND);
}

static gboolean
gst_video_decoder_do_seek (GstVideoDecoder * dec, GstEvent * event)
{
  GstFormat format;
  GstSeekFlags flags;
  GstSeekType start_type, end_type;
  gdouble rate;
  gint64 start, start_time, end_time;
  GstSegment seek_segment;
  guint32 seqnum;

  gst_event_parse_seek (event, &rate, &format, &flags, &start_type,
      &start_time, &end_type, &end_time);

  /* we'll handle plain open-ended flushing seeks with the simple approach */
  if (rate != 1.0) {
    GST_DEBUG_OBJECT (dec, "unsupported seek: rate");
    return FALSE;
  }

  if (start_type != GST_SEEK_TYPE_SET) {
    GST_DEBUG_OBJECT (dec, "unsupported seek: start time");
    return FALSE;
  }

  if (end_type != GST_SEEK_TYPE_NONE ||
      (end_type == GST_SEEK_TYPE_SET && end_time != GST_CLOCK_TIME_NONE)) {
    GST_DEBUG_OBJECT (dec, "unsupported seek: end time");
    return FALSE;
  }

  if (!(flags & GST_SEEK_FLAG_FLUSH)) {
    GST_DEBUG_OBJECT (dec, "unsupported seek: not flushing");
    return FALSE;
  }

  memcpy (&seek_segment, &dec->output_segment, sizeof (seek_segment));
  gst_segment_do_seek (&seek_segment, rate, format, flags, start_type,
      start_time, end_type, end_time, NULL);
  start_time = seek_segment.position;

  if (!gst_pad_query_convert (dec->sinkpad, GST_FORMAT_TIME, start_time,
          GST_FORMAT_BYTES, &start)) {
    GST_DEBUG_OBJECT (dec, "conversion failed");
    return FALSE;
  }

  seqnum = gst_event_get_seqnum (event);
  event = gst_event_new_seek (1.0, GST_FORMAT_BYTES, flags,
      GST_SEEK_TYPE_SET, start, GST_SEEK_TYPE_NONE, -1);
  gst_event_set_seqnum (event, seqnum);

  GST_DEBUG_OBJECT (dec, "seeking to %" GST_TIME_FORMAT " at byte offset %"
      G_GINT64_FORMAT, GST_TIME_ARGS (start_time), start);

  return gst_pad_push_event (dec->sinkpad, event);
}

static gboolean
gst_video_decoder_src_event_default (GstVideoDecoder * decoder,
    GstEvent * event)
{
  GstVideoDecoderPrivate *priv;
  gboolean res = FALSE;

  priv = decoder->priv;

  GST_DEBUG_OBJECT (decoder,
      "received event %d, %s", GST_EVENT_TYPE (event),
      GST_EVENT_TYPE_NAME (event));

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_SEEK:
    {
      GstFormat format;
      gdouble rate;
      GstSeekFlags flags;
      GstSeekType start_type, stop_type;
      gint64 start, stop;
      gint64 tstart, tstop;
      guint32 seqnum;

      gst_event_parse_seek (event, &rate, &format, &flags, &start_type, &start,
          &stop_type, &stop);
      seqnum = gst_event_get_seqnum (event);

      /* upstream gets a chance first */
      if ((res = gst_pad_push_event (decoder->sinkpad, event)))
        break;

      /* if upstream fails for a time seek, maybe we can help if allowed */
      if (format == GST_FORMAT_TIME) {
        if (gst_video_decoder_do_byte (decoder))
          res = gst_video_decoder_do_seek (decoder, event);
        break;
      }

      /* ... though a non-time seek can be aided as well */
      /* First bring the requested format to time */
      if (!(res =
              gst_pad_query_convert (decoder->srcpad, format, start,
                  GST_FORMAT_TIME, &tstart)))
        goto convert_error;
      if (!(res =
              gst_pad_query_convert (decoder->srcpad, format, stop,
                  GST_FORMAT_TIME, &tstop)))
        goto convert_error;

      /* then seek with time on the peer */
      event = gst_event_new_seek (rate, GST_FORMAT_TIME,
          flags, start_type, tstart, stop_type, tstop);
      gst_event_set_seqnum (event, seqnum);

      res = gst_pad_push_event (decoder->sinkpad, event);
      break;
    }
    case GST_EVENT_QOS:
    {
      GstQOSType type;
      gdouble proportion;
      GstClockTimeDiff diff;
      GstClockTime timestamp;

      gst_event_parse_qos (event, &type, &proportion, &diff, &timestamp);

      GST_OBJECT_LOCK (decoder);
      priv->proportion = proportion;
      if (G_LIKELY (GST_CLOCK_TIME_IS_VALID (timestamp))) {
        if (G_UNLIKELY (diff > 0)) {
          priv->earliest_time = timestamp + 2 * diff + priv->qos_frame_duration;
        } else {
          priv->earliest_time = timestamp + diff;
        }
      } else {
        priv->earliest_time = GST_CLOCK_TIME_NONE;
      }
      GST_OBJECT_UNLOCK (decoder);

      GST_DEBUG_OBJECT (decoder,
          "got QoS %" GST_TIME_FORMAT ", %" G_GINT64_FORMAT ", %g",
          GST_TIME_ARGS (timestamp), diff, proportion);

      res = gst_pad_push_event (decoder->sinkpad, event);
      break;
    }
    default:
      res = gst_pad_push_event (decoder->sinkpad, event);
      break;
  }
done:
  return res;

convert_error:
  GST_DEBUG_OBJECT (decoder, "could not convert format");
  goto done;
}

static gboolean
gst_video_decoder_src_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  GstVideoDecoder *decoder;
  GstVideoDecoderClass *decoder_class;
  gboolean ret = FALSE;

  decoder = GST_VIDEO_DECODER (parent);
  decoder_class = GST_VIDEO_DECODER_GET_CLASS (decoder);

  GST_DEBUG_OBJECT (decoder, "received event %d, %s", GST_EVENT_TYPE (event),
      GST_EVENT_TYPE_NAME (event));

  if (decoder_class->src_event)
    ret = decoder_class->src_event (decoder, event);

  return ret;
}

static gboolean
gst_video_decoder_src_query_default (GstVideoDecoder * dec, GstQuery * query)
{
  GstPad *pad = GST_VIDEO_DECODER_SRC_PAD (dec);
  gboolean res = TRUE;

  GST_LOG_OBJECT (dec, "handling query: %" GST_PTR_FORMAT, query);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_POSITION:
    {
      GstFormat format;
      gint64 time, value;

      /* upstream gets a chance first */
      if ((res = gst_pad_peer_query (dec->sinkpad, query))) {
        GST_LOG_OBJECT (dec, "returning peer response");
        break;
      }

      /* we start from the last seen time */
      time = dec->priv->last_timestamp_out;
      /* correct for the segment values */
      time = gst_segment_to_stream_time (&dec->output_segment,
          GST_FORMAT_TIME, time);

      GST_LOG_OBJECT (dec,
          "query %p: our time: %" GST_TIME_FORMAT, query, GST_TIME_ARGS (time));

      /* and convert to the final format */
      gst_query_parse_position (query, &format, NULL);
      if (!(res = gst_pad_query_convert (pad, GST_FORMAT_TIME, time,
                  format, &value)))
        break;

      gst_query_set_position (query, format, value);

      GST_LOG_OBJECT (dec,
          "query %p: we return %" G_GINT64_FORMAT " (format %u)", query, value,
          format);
      break;
    }
    case GST_QUERY_DURATION:
    {
      GstFormat format;

      /* upstream in any case */
      if ((res = gst_pad_query_default (pad, GST_OBJECT (dec), query)))
        break;

      gst_query_parse_duration (query, &format, NULL);
      /* try answering TIME by converting from BYTE if subclass allows  */
      if (format == GST_FORMAT_TIME && gst_video_decoder_do_byte (dec)) {
        gint64 value;

        if (gst_pad_peer_query_duration (dec->sinkpad, GST_FORMAT_BYTES,
                &value)) {
          GST_LOG_OBJECT (dec, "upstream size %" G_GINT64_FORMAT, value);
          if (gst_pad_query_convert (dec->sinkpad,
                  GST_FORMAT_BYTES, value, GST_FORMAT_TIME, &value)) {
            gst_query_set_duration (query, GST_FORMAT_TIME, value);
            res = TRUE;
          }
        }
      }
      break;
    }
    case GST_QUERY_CONVERT:
    {
      GstFormat src_fmt, dest_fmt;
      gint64 src_val, dest_val;

      GST_DEBUG_OBJECT (dec, "convert query");

      gst_query_parse_convert (query, &src_fmt, &src_val, &dest_fmt, &dest_val);
      GST_OBJECT_LOCK (dec);
      if (dec->priv->output_state != NULL)
        res = gst_video_rawvideo_convert (dec->priv->output_state,
            src_fmt, src_val, &dest_fmt, &dest_val);
      else
        res = FALSE;
      GST_OBJECT_UNLOCK (dec);
      if (!res)
        goto error;
      gst_query_set_convert (query, src_fmt, src_val, dest_fmt, dest_val);
      break;
    }
    case GST_QUERY_LATENCY:
    {
      gboolean live;
      GstClockTime min_latency, max_latency;

      res = gst_pad_peer_query (dec->sinkpad, query);
      if (res) {
        gst_query_parse_latency (query, &live, &min_latency, &max_latency);
        GST_DEBUG_OBJECT (dec, "Peer qlatency: live %d, min %"
            GST_TIME_FORMAT " max %" GST_TIME_FORMAT, live,
            GST_TIME_ARGS (min_latency), GST_TIME_ARGS (max_latency));

        GST_OBJECT_LOCK (dec);
        min_latency += dec->priv->min_latency;
        if (dec->priv->max_latency == GST_CLOCK_TIME_NONE) {
          max_latency = GST_CLOCK_TIME_NONE;
        } else if (max_latency != GST_CLOCK_TIME_NONE) {
          max_latency += dec->priv->max_latency;
        }
        GST_OBJECT_UNLOCK (dec);

        gst_query_set_latency (query, live, min_latency, max_latency);
      }
    }
      break;
    default:
      res = gst_pad_query_default (pad, GST_OBJECT (dec), query);
  }
  return res;

error:
  GST_ERROR_OBJECT (dec, "query failed");
  return res;
}

static gboolean
gst_video_decoder_src_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstVideoDecoder *decoder;
  GstVideoDecoderClass *decoder_class;
  gboolean ret = FALSE;

  decoder = GST_VIDEO_DECODER (parent);
  decoder_class = GST_VIDEO_DECODER_GET_CLASS (decoder);

  GST_DEBUG_OBJECT (decoder, "received query %d, %s", GST_QUERY_TYPE (query),
      GST_QUERY_TYPE_NAME (query));

  if (decoder_class->src_query)
    ret = decoder_class->src_query (decoder, query);

  return ret;
}

static gboolean
gst_video_decoder_sink_query_default (GstVideoDecoder * decoder,
    GstQuery * query)
{
  GstPad *pad = GST_VIDEO_DECODER_SINK_PAD (decoder);
  GstVideoDecoderPrivate *priv;
  gboolean res = FALSE;

  priv = decoder->priv;

  GST_LOG_OBJECT (decoder, "handling query: %" GST_PTR_FORMAT, query);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_CONVERT:
    {
      GstFormat src_fmt, dest_fmt;
      gint64 src_val, dest_val;

      gst_query_parse_convert (query, &src_fmt, &src_val, &dest_fmt, &dest_val);
      res =
          gst_video_encoded_video_convert (priv->bytes_out, priv->time, src_fmt,
          src_val, &dest_fmt, &dest_val);
      if (!res)
        goto error;
      gst_query_set_convert (query, src_fmt, src_val, dest_fmt, dest_val);
      break;
    }
    case GST_QUERY_ALLOCATION:{
      GstVideoDecoderClass *klass = GST_VIDEO_DECODER_GET_CLASS (decoder);

      if (klass->propose_allocation)
        res = klass->propose_allocation (decoder, query);
      break;
    }
    default:
      res = gst_pad_query_default (pad, GST_OBJECT (decoder), query);
      break;
  }
done:

  return res;
error:
  GST_DEBUG_OBJECT (decoder, "query failed");
  goto done;

}

static gboolean
gst_video_decoder_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  GstVideoDecoder *decoder;
  GstVideoDecoderClass *decoder_class;
  gboolean ret = FALSE;

  decoder = GST_VIDEO_DECODER (parent);
  decoder_class = GST_VIDEO_DECODER_GET_CLASS (decoder);

  GST_DEBUG_OBJECT (decoder, "received query %d, %s", GST_QUERY_TYPE (query),
      GST_QUERY_TYPE_NAME (query));

  if (decoder_class->sink_query)
    ret = decoder_class->sink_query (decoder, query);

  return ret;
}

typedef struct _Timestamp Timestamp;
struct _Timestamp
{
  guint64 offset;
  GstClockTime pts;
  GstClockTime dts;
  GstClockTime duration;
};

static void
timestamp_free (Timestamp * ts)
{
  g_slice_free (Timestamp, ts);
}

static void
gst_video_decoder_add_timestamp (GstVideoDecoder * decoder, GstBuffer * buffer)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  Timestamp *ts;

  ts = g_slice_new (Timestamp);

  GST_LOG_OBJECT (decoder,
      "adding PTS %" GST_TIME_FORMAT " DTS %" GST_TIME_FORMAT
      " (offset:%" G_GUINT64_FORMAT ")",
      GST_TIME_ARGS (GST_BUFFER_PTS (buffer)),
      GST_TIME_ARGS (GST_BUFFER_DTS (buffer)), priv->input_offset);

  ts->offset = priv->input_offset;
  ts->pts = GST_BUFFER_PTS (buffer);
  ts->dts = GST_BUFFER_DTS (buffer);
  ts->duration = GST_BUFFER_DURATION (buffer);

  priv->timestamps = g_list_append (priv->timestamps, ts);
}

static void
gst_video_decoder_get_timestamp_at_offset (GstVideoDecoder *
    decoder, guint64 offset, GstClockTime * pts, GstClockTime * dts,
    GstClockTime * duration)
{
#ifndef GST_DISABLE_GST_DEBUG
  guint64 got_offset = 0;
#endif
  Timestamp *ts;
  GList *g;

  *pts = GST_CLOCK_TIME_NONE;
  *dts = GST_CLOCK_TIME_NONE;
  *duration = GST_CLOCK_TIME_NONE;

  g = decoder->priv->timestamps;
  while (g) {
    ts = g->data;
    if (ts->offset <= offset) {
#ifndef GST_DISABLE_GST_DEBUG
      got_offset = ts->offset;
#endif
      *pts = ts->pts;
      *dts = ts->dts;
      *duration = ts->duration;
      g = g->next;
      decoder->priv->timestamps = g_list_remove (decoder->priv->timestamps, ts);
      timestamp_free (ts);
    } else {
      break;
    }
  }

  GST_LOG_OBJECT (decoder,
      "got PTS %" GST_TIME_FORMAT " DTS %" GST_TIME_FORMAT " @ offs %"
      G_GUINT64_FORMAT " (wanted offset:%" G_GUINT64_FORMAT ")",
      GST_TIME_ARGS (*pts), GST_TIME_ARGS (*dts), got_offset, offset);
}

static void
gst_video_decoder_clear_queues (GstVideoDecoder * dec)
{
  GstVideoDecoderPrivate *priv = dec->priv;

  g_list_free_full (priv->output_queued,
      (GDestroyNotify) gst_mini_object_unref);
  priv->output_queued = NULL;

  g_list_free_full (priv->gather, (GDestroyNotify) gst_mini_object_unref);
  priv->gather = NULL;
  g_list_free_full (priv->decode, (GDestroyNotify) gst_video_codec_frame_unref);
  priv->decode = NULL;
  g_list_free_full (priv->parse, (GDestroyNotify) gst_mini_object_unref);
  priv->parse = NULL;
  g_list_free_full (priv->parse_gather,
      (GDestroyNotify) gst_video_codec_frame_unref);
  priv->parse_gather = NULL;
  g_list_free_full (priv->frames, (GDestroyNotify) gst_video_codec_frame_unref);
  priv->frames = NULL;
}

static void
gst_video_decoder_reset (GstVideoDecoder * decoder, gboolean full,
    gboolean flush_hard)
{
  GstVideoDecoderPrivate *priv = decoder->priv;

  GST_DEBUG_OBJECT (decoder, "reset full %d", full);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  if (full || flush_hard) {
    gst_segment_init (&decoder->input_segment, GST_FORMAT_UNDEFINED);
    gst_segment_init (&decoder->output_segment, GST_FORMAT_UNDEFINED);
    gst_video_decoder_clear_queues (decoder);

    if (priv->current_frame) {
      gst_video_codec_frame_unref (priv->current_frame);
      priv->current_frame = NULL;
    }

    g_list_free_full (priv->current_frame_events,
        (GDestroyNotify) gst_event_unref);
    priv->current_frame_events = NULL;
    g_list_free_full (priv->pending_events, (GDestroyNotify) gst_event_unref);
    priv->pending_events = NULL;

    priv->error_count = 0;
    priv->max_errors = GST_VIDEO_DECODER_MAX_ERRORS;
    priv->had_output_data = FALSE;
    priv->had_input_data = FALSE;

    GST_OBJECT_LOCK (decoder);
    priv->earliest_time = GST_CLOCK_TIME_NONE;
    priv->proportion = 0.5;
    GST_OBJECT_UNLOCK (decoder);
  }

  if (full) {
    if (priv->input_state)
      gst_video_codec_state_unref (priv->input_state);
    priv->input_state = NULL;
    GST_OBJECT_LOCK (decoder);
    if (priv->output_state)
      gst_video_codec_state_unref (priv->output_state);
    priv->output_state = NULL;

    priv->qos_frame_duration = 0;
    GST_OBJECT_UNLOCK (decoder);

    priv->min_latency = 0;
    priv->max_latency = 0;

    if (priv->tags)
      gst_tag_list_unref (priv->tags);
    priv->tags = NULL;
    priv->tags_changed = FALSE;
    priv->reordered_output = FALSE;

    priv->dropped = 0;
    priv->processed = 0;

    priv->decode_frame_number = 0;
    priv->base_picture_number = 0;

    if (priv->pool) {
      gst_buffer_pool_set_active (priv->pool, FALSE);
      gst_object_unref (priv->pool);
      priv->pool = NULL;
    }

    if (priv->allocator) {
      gst_object_unref (priv->allocator);
      priv->allocator = NULL;
    }
  }

  priv->discont = TRUE;

  priv->base_timestamp = GST_CLOCK_TIME_NONE;
  priv->last_timestamp_out = GST_CLOCK_TIME_NONE;
  priv->pts_delta = GST_CLOCK_TIME_NONE;

  priv->input_offset = 0;
  priv->frame_offset = 0;
  gst_adapter_clear (priv->input_adapter);
  gst_adapter_clear (priv->output_adapter);
  g_list_free_full (priv->timestamps, (GDestroyNotify) timestamp_free);
  priv->timestamps = NULL;

  priv->bytes_out = 0;
  priv->time = 0;

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
}

static GstFlowReturn
gst_video_decoder_chain_forward (GstVideoDecoder * decoder,
    GstBuffer * buf, gboolean at_eos)
{
  GstVideoDecoderPrivate *priv;
  GstVideoDecoderClass *klass;
  GstFlowReturn ret = GST_FLOW_OK;

  klass = GST_VIDEO_DECODER_GET_CLASS (decoder);
  priv = decoder->priv;

  g_return_val_if_fail (priv->packetized || klass->parse, GST_FLOW_ERROR);

  if (priv->current_frame == NULL)
    priv->current_frame = gst_video_decoder_new_frame (decoder);

  if (GST_BUFFER_PTS_IS_VALID (buf) && !priv->packetized) {
    gst_video_decoder_add_timestamp (decoder, buf);
  }
  priv->input_offset += gst_buffer_get_size (buf);

  if (priv->packetized) {
    if (!GST_BUFFER_FLAG_IS_SET (buf, GST_BUFFER_FLAG_DELTA_UNIT)) {
      GST_VIDEO_CODEC_FRAME_SET_SYNC_POINT (priv->current_frame);
    }

    priv->current_frame->input_buffer = buf;

    if (decoder->input_segment.rate < 0.0) {
      priv->parse_gather =
          g_list_prepend (priv->parse_gather, priv->current_frame);
    } else {
      ret = gst_video_decoder_decode_frame (decoder, priv->current_frame);
    }
    priv->current_frame = NULL;
  } else {
    gst_adapter_push (priv->input_adapter, buf);

    ret = gst_video_decoder_parse_available (decoder, at_eos, TRUE);
  }

  if (ret == GST_VIDEO_DECODER_FLOW_NEED_DATA)
    return GST_FLOW_OK;

  return ret;
}

static GstFlowReturn
gst_video_decoder_flush_decode (GstVideoDecoder * dec)
{
  GstVideoDecoderPrivate *priv = dec->priv;
  GstFlowReturn res = GST_FLOW_OK;
  GList *walk;

  GST_DEBUG_OBJECT (dec, "flushing buffers to decode");

  walk = priv->decode;
  while (walk) {
    GList *next;
    GstVideoCodecFrame *frame = (GstVideoCodecFrame *) (walk->data);

    GST_DEBUG_OBJECT (dec, "decoding frame %p buffer %p, PTS %" GST_TIME_FORMAT
        ", DTS %" GST_TIME_FORMAT, frame, frame->input_buffer,
        GST_TIME_ARGS (GST_BUFFER_PTS (frame->input_buffer)),
        GST_TIME_ARGS (GST_BUFFER_DTS (frame->input_buffer)));

    next = walk->next;

    priv->decode = g_list_delete_link (priv->decode, walk);

    /* decode buffer, resulting data prepended to queue */
    res = gst_video_decoder_decode_frame (dec, frame);
    if (res != GST_FLOW_OK)
      break;

    walk = next;
  }

  return res;
}

/* gst_video_decoder_flush_parse is called from the
 * chain_reverse() function when a buffer containing
 * a DISCONT - indicating that reverse playback
 * looped back to the next data block, and therefore
 * all available data should be fed through the
 * decoder and frames gathered for reversed output
 */
static GstFlowReturn
gst_video_decoder_flush_parse (GstVideoDecoder * dec, gboolean at_eos)
{
  GstVideoDecoderPrivate *priv = dec->priv;
  GstFlowReturn res = GST_FLOW_OK;
  GList *walk;
  GstVideoDecoderClass *decoder_class;

  decoder_class = GST_VIDEO_DECODER_GET_CLASS (dec);

  GST_DEBUG_OBJECT (dec, "flushing buffers to parsing");

  /* Reverse the gather list, and prepend it to the parse list,
   * then flush to parse whatever we can */
  priv->gather = g_list_reverse (priv->gather);
  priv->parse = g_list_concat (priv->gather, priv->parse);
  priv->gather = NULL;

  /* clear buffer and decoder state */
  gst_video_decoder_flush (dec, FALSE);

  walk = priv->parse;
  while (walk) {
    GstBuffer *buf = GST_BUFFER_CAST (walk->data);
    GList *next = walk->next;

    GST_DEBUG_OBJECT (dec, "parsing buffer %p, PTS %" GST_TIME_FORMAT
        ", DTS %" GST_TIME_FORMAT, buf, GST_TIME_ARGS (GST_BUFFER_PTS (buf)),
        GST_TIME_ARGS (GST_BUFFER_DTS (buf)));

    /* parse buffer, resulting frames prepended to parse_gather queue */
    gst_buffer_ref (buf);
    res = gst_video_decoder_chain_forward (dec, buf, at_eos);

    /* if we generated output, we can discard the buffer, else we
     * keep it in the queue */
    if (priv->parse_gather) {
      GST_DEBUG_OBJECT (dec, "parsed buffer to %p", priv->parse_gather->data);
      priv->parse = g_list_delete_link (priv->parse, walk);
      gst_buffer_unref (buf);
    } else {
      GST_DEBUG_OBJECT (dec, "buffer did not decode, keeping");
    }
    walk = next;
  }

  walk = priv->parse_gather;
  while (walk) {
    GstVideoCodecFrame *frame = (GstVideoCodecFrame *) (walk->data);
    GList *walk2;

    /* this is reverse playback, check if we need to apply some segment
     * to the output before decoding, as during decoding the segment.rate
     * must be used to determine if a buffer should be pushed or added to
     * the output list for reverse pushing.
     *
     * The new segment is not immediately pushed here because we must
     * wait for negotiation to happen before it can be pushed to avoid
     * pushing a segment before caps event. Negotiation only happens
     * when finish_frame is called.
     */
    for (walk2 = frame->events; walk2;) {
      GList *cur = walk2;
      GstEvent *event = walk2->data;

      walk2 = g_list_next (walk2);
      if (GST_EVENT_TYPE (event) <= GST_EVENT_SEGMENT) {

        if (GST_EVENT_TYPE (event) == GST_EVENT_SEGMENT) {
          GstSegment segment;

          GST_DEBUG_OBJECT (dec, "Segment at frame %p %" GST_TIME_FORMAT,
              frame, GST_TIME_ARGS (GST_BUFFER_PTS (frame->input_buffer)));
          gst_event_copy_segment (event, &segment);
          if (segment.format == GST_FORMAT_TIME) {
            dec->output_segment = segment;
          }
        }
        dec->priv->pending_events =
            g_list_append (dec->priv->pending_events, event);
        frame->events = g_list_delete_link (frame->events, cur);
      }
    }

    walk = walk->next;
  }

  /* now we can process frames. Start by moving each frame from the parse_gather
   * to the decode list, reverse the order as we go, and stopping when/if we
   * copy a keyframe. */
  GST_DEBUG_OBJECT (dec, "checking parsed frames for a keyframe to decode");
  walk = priv->parse_gather;
  while (walk) {
    GstVideoCodecFrame *frame = (GstVideoCodecFrame *) (walk->data);

    /* remove from the gather list */
    priv->parse_gather = g_list_remove_link (priv->parse_gather, walk);

    /* move it to the front of the decode queue */
    priv->decode = g_list_concat (walk, priv->decode);

    /* if we copied a keyframe, flush and decode the decode queue */
    if (GST_VIDEO_CODEC_FRAME_IS_SYNC_POINT (frame)) {
      GST_DEBUG_OBJECT (dec, "found keyframe %p with PTS %" GST_TIME_FORMAT
          ", DTS %" GST_TIME_FORMAT, frame,
          GST_TIME_ARGS (GST_BUFFER_PTS (frame->input_buffer)),
          GST_TIME_ARGS (GST_BUFFER_DTS (frame->input_buffer)));
      res = gst_video_decoder_flush_decode (dec);
      if (res != GST_FLOW_OK)
        goto done;
    }

    walk = priv->parse_gather;
  }

  /* We need to tell the subclass to drain now */
  GST_DEBUG_OBJECT (dec, "Finishing");
  if (decoder_class->finish)
    res = decoder_class->finish (dec);

  if (res != GST_FLOW_OK)
    goto done;

  /* now send queued data downstream */
  walk = priv->output_queued;
  while (walk) {
    GstBuffer *buf = GST_BUFFER_CAST (walk->data);

    if (G_LIKELY (res == GST_FLOW_OK)) {
      /* avoid stray DISCONT from forward processing,
       * which have no meaning in reverse pushing */
      GST_BUFFER_FLAG_UNSET (buf, GST_BUFFER_FLAG_DISCONT);

      /* Last chance to calculate a timestamp as we loop backwards
       * through the list */
      if (GST_BUFFER_TIMESTAMP (buf) != GST_CLOCK_TIME_NONE)
        priv->last_timestamp_out = GST_BUFFER_TIMESTAMP (buf);
      else if (priv->last_timestamp_out != GST_CLOCK_TIME_NONE &&
          GST_BUFFER_DURATION (buf) != GST_CLOCK_TIME_NONE) {
        GST_BUFFER_TIMESTAMP (buf) =
            priv->last_timestamp_out - GST_BUFFER_DURATION (buf);
        priv->last_timestamp_out = GST_BUFFER_TIMESTAMP (buf);
        GST_LOG_OBJECT (dec,
            "Calculated TS %" GST_TIME_FORMAT " working backwards",
            GST_TIME_ARGS (priv->last_timestamp_out));
      }

      res = gst_video_decoder_clip_and_push_buf (dec, buf);
    } else {
      gst_buffer_unref (buf);
    }

    priv->output_queued =
        g_list_delete_link (priv->output_queued, priv->output_queued);
    walk = priv->output_queued;
  }

done:
  return res;
}

static GstFlowReturn
gst_video_decoder_chain_reverse (GstVideoDecoder * dec, GstBuffer * buf)
{
  GstVideoDecoderPrivate *priv = dec->priv;
  GstFlowReturn result = GST_FLOW_OK;

  /* if we have a discont, move buffers to the decode list */
  if (!buf || GST_BUFFER_IS_DISCONT (buf)) {
    GST_DEBUG_OBJECT (dec, "received discont");

    /* parse and decode stuff in the gather and parse queues */
    result = gst_video_decoder_flush_parse (dec, FALSE);
  }

  if (G_LIKELY (buf)) {
    GST_DEBUG_OBJECT (dec, "gathering buffer %p of size %" G_GSIZE_FORMAT ", "
        "PTS %" GST_TIME_FORMAT ", DTS %" GST_TIME_FORMAT ", dur %"
        GST_TIME_FORMAT, buf, gst_buffer_get_size (buf),
        GST_TIME_ARGS (GST_BUFFER_PTS (buf)),
        GST_TIME_ARGS (GST_BUFFER_DTS (buf)),
        GST_TIME_ARGS (GST_BUFFER_DURATION (buf)));

    /* add buffer to gather queue */
    priv->gather = g_list_prepend (priv->gather, buf);
  }

  return result;
}

static GstFlowReturn
gst_video_decoder_chain (GstPad * pad, GstObject * parent, GstBuffer * buf)
{
  GstVideoDecoder *decoder;
  GstFlowReturn ret = GST_FLOW_OK;

  decoder = GST_VIDEO_DECODER (parent);

  if (G_UNLIKELY (decoder->priv->do_caps)) {
    GstCaps *caps = gst_pad_get_current_caps (decoder->sinkpad);
    if (caps) {
      if (!gst_video_decoder_setcaps (decoder, caps)) {
        gst_caps_unref (caps);
        goto not_negotiated;
      }
      gst_caps_unref (caps);
    }
    decoder->priv->do_caps = FALSE;
  }

  if (G_UNLIKELY (!decoder->priv->input_state && decoder->priv->needs_format))
    goto not_negotiated;

  GST_LOG_OBJECT (decoder,
      "chain PTS %" GST_TIME_FORMAT ", DTS %" GST_TIME_FORMAT " duration %"
      GST_TIME_FORMAT " size %" G_GSIZE_FORMAT,
      GST_TIME_ARGS (GST_BUFFER_PTS (buf)),
      GST_TIME_ARGS (GST_BUFFER_DTS (buf)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buf)), gst_buffer_get_size (buf));

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  /* NOTE:
   * requiring the pad to be negotiated makes it impossible to use
   * oggdemux or filesrc ! decoder */

  if (decoder->input_segment.format == GST_FORMAT_UNDEFINED) {
    GstEvent *event;
    GstSegment *segment = &decoder->input_segment;

    GST_WARNING_OBJECT (decoder,
        "Received buffer without a new-segment. "
        "Assuming timestamps start from 0.");

    gst_segment_init (segment, GST_FORMAT_TIME);

    event = gst_event_new_segment (segment);

    decoder->priv->current_frame_events =
        g_list_prepend (decoder->priv->current_frame_events, event);
  }

  decoder->priv->had_input_data = TRUE;

  if (decoder->input_segment.rate > 0.0)
    ret = gst_video_decoder_chain_forward (decoder, buf, FALSE);
  else
    ret = gst_video_decoder_chain_reverse (decoder, buf);

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
  return ret;

  /* ERRORS */
not_negotiated:
  {
    GST_ELEMENT_ERROR (decoder, CORE, NEGOTIATION, (NULL),
        ("decoder not initialized"));
    gst_buffer_unref (buf);
    return GST_FLOW_NOT_NEGOTIATED;
  }
}

static GstStateChangeReturn
gst_video_decoder_change_state (GstElement * element, GstStateChange transition)
{
  GstVideoDecoder *decoder;
  GstVideoDecoderClass *decoder_class;
  GstStateChangeReturn ret;

  decoder = GST_VIDEO_DECODER (element);
  decoder_class = GST_VIDEO_DECODER_GET_CLASS (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      /* open device/library if needed */
      if (decoder_class->open && !decoder_class->open (decoder))
        goto open_failed;
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      /* Initialize device/library if needed */
      if (decoder_class->start && !decoder_class->start (decoder))
        goto start_failed;
      GST_VIDEO_DECODER_STREAM_LOCK (decoder);
      gst_video_decoder_reset (decoder, TRUE, TRUE);
      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:{
      gboolean stopped = TRUE;

      GST_VIDEO_DECODER_STREAM_LOCK (decoder);
      gst_video_decoder_reset (decoder, TRUE, TRUE);
      GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

      if (decoder_class->stop) {
        stopped = decoder_class->stop (decoder);

        /* the subclass might have released frames and events from freed frames
         * are stored in the pending_events list */
        GST_VIDEO_DECODER_STREAM_LOCK (decoder);
        g_list_free_full (decoder->priv->pending_events, (GDestroyNotify)
            gst_event_unref);
        decoder->priv->pending_events = NULL;
        GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
      }

      if (!stopped)
        goto stop_failed;

      break;
    }
    case GST_STATE_CHANGE_READY_TO_NULL:
      /* close device/library if needed */
      if (decoder_class->close && !decoder_class->close (decoder))
        goto close_failed;
      break;
    default:
      break;
  }

  return ret;

  /* Errors */
open_failed:
  {
    GST_ELEMENT_ERROR (decoder, LIBRARY, INIT, (NULL),
        ("Failed to open decoder"));
    return GST_STATE_CHANGE_FAILURE;
  }

start_failed:
  {
    GST_ELEMENT_ERROR (decoder, LIBRARY, INIT, (NULL),
        ("Failed to start decoder"));
    return GST_STATE_CHANGE_FAILURE;
  }

stop_failed:
  {
    GST_ELEMENT_ERROR (decoder, LIBRARY, INIT, (NULL),
        ("Failed to stop decoder"));
    return GST_STATE_CHANGE_FAILURE;
  }

close_failed:
  {
    GST_ELEMENT_ERROR (decoder, LIBRARY, INIT, (NULL),
        ("Failed to close decoder"));
    return GST_STATE_CHANGE_FAILURE;
  }
}

static GstVideoCodecFrame *
gst_video_decoder_new_frame (GstVideoDecoder * decoder)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  GstVideoCodecFrame *frame;

  frame = g_slice_new0 (GstVideoCodecFrame);

  frame->ref_count = 1;

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  frame->system_frame_number = priv->system_frame_number;
  priv->system_frame_number++;
  frame->decode_frame_number = priv->decode_frame_number;
  priv->decode_frame_number++;

  frame->dts = GST_CLOCK_TIME_NONE;
  frame->pts = GST_CLOCK_TIME_NONE;
  frame->duration = GST_CLOCK_TIME_NONE;
  frame->events = priv->current_frame_events;
  priv->current_frame_events = NULL;

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  GST_LOG_OBJECT (decoder, "Created new frame %p (sfn:%d)",
      frame, frame->system_frame_number);

  return frame;
}

static void
gst_video_decoder_prepare_finish_frame (GstVideoDecoder *
    decoder, GstVideoCodecFrame * frame, gboolean dropping)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  GList *l, *events = NULL;
  gboolean sync;

#ifndef GST_DISABLE_GST_DEBUG
  GST_LOG_OBJECT (decoder, "n %d in %" G_GSIZE_FORMAT " out %" G_GSIZE_FORMAT,
      g_list_length (priv->frames),
      gst_adapter_available (priv->input_adapter),
      gst_adapter_available (priv->output_adapter));
#endif

  sync = GST_VIDEO_CODEC_FRAME_IS_SYNC_POINT (frame);

  GST_LOG_OBJECT (decoder,
      "finish frame %p (#%d) sync:%d PTS:%" GST_TIME_FORMAT " DTS:%"
      GST_TIME_FORMAT,
      frame, frame->system_frame_number,
      sync, GST_TIME_ARGS (frame->pts), GST_TIME_ARGS (frame->dts));

  /* Push all pending events that arrived before this frame */
  for (l = priv->frames; l; l = l->next) {
    GstVideoCodecFrame *tmp = l->data;

    if (tmp->events) {
      events = g_list_concat (events, tmp->events);
      tmp->events = NULL;
    }

    if (tmp == frame)
      break;
  }

  if (dropping || !decoder->priv->output_state) {
    /* Push before the next frame that is not dropped */
    decoder->priv->pending_events =
        g_list_concat (decoder->priv->pending_events, events);
  } else {
    for (l = g_list_last (decoder->priv->pending_events); l;
        l = g_list_previous (l)) {
      GST_LOG_OBJECT (decoder, "pushing %s event",
          GST_EVENT_TYPE_NAME (l->data));
      gst_video_decoder_push_event (decoder, l->data);
    }
    g_list_free (decoder->priv->pending_events);
    decoder->priv->pending_events = NULL;

    for (l = g_list_last (events); l; l = g_list_previous (l)) {
      GST_LOG_OBJECT (decoder, "pushing %s event",
          GST_EVENT_TYPE_NAME (l->data));
      gst_video_decoder_push_event (decoder, l->data);
    }
    g_list_free (events);
  }

  /* Check if the data should not be displayed. For example altref/invisible
   * frame in vp8. In this case we should not update the timestamps. */
  if (GST_VIDEO_CODEC_FRAME_IS_DECODE_ONLY (frame))
    return;

  /* If the frame is meant to be output but we don't have an output_buffer
   * we have a problem :) */
  if (G_UNLIKELY ((frame->output_buffer == NULL) && !dropping))
    goto no_output_buffer;

  if (GST_CLOCK_TIME_IS_VALID (frame->pts)) {
    if (frame->pts != priv->base_timestamp) {
      GST_DEBUG_OBJECT (decoder,
          "sync timestamp %" GST_TIME_FORMAT " diff %" GST_TIME_FORMAT,
          GST_TIME_ARGS (frame->pts),
          GST_TIME_ARGS (frame->pts - decoder->output_segment.start));
      priv->base_timestamp = frame->pts;
      priv->base_picture_number = frame->decode_frame_number;
    }
  }

  if (frame->duration == GST_CLOCK_TIME_NONE) {
    frame->duration = gst_video_decoder_get_frame_duration (decoder, frame);
    GST_LOG_OBJECT (decoder,
        "Guessing duration %" GST_TIME_FORMAT " for frame...",
        GST_TIME_ARGS (frame->duration));
  }

  /* PTS is expected montone ascending,
   * so a good guess is lowest unsent DTS */
  {
    GstClockTime min_ts = GST_CLOCK_TIME_NONE;
    GstVideoCodecFrame *oframe = NULL;
    gboolean seen_none = FALSE;

    /* some maintenance regardless */
    for (l = priv->frames; l; l = l->next) {
      GstVideoCodecFrame *tmp = l->data;

      if (!GST_CLOCK_TIME_IS_VALID (tmp->abidata.ABI.ts)) {
        seen_none = TRUE;
        continue;
      }

      if (!GST_CLOCK_TIME_IS_VALID (min_ts) || tmp->abidata.ABI.ts < min_ts) {
        min_ts = tmp->abidata.ABI.ts;
        oframe = tmp;
      }
    }
    /* save a ts if needed */
    if (oframe && oframe != frame) {
      oframe->abidata.ABI.ts = frame->abidata.ABI.ts;
    }

    /* and set if needed;
     * valid delta means we have reasonable DTS input */
    /* also, if we ended up reordered, means this approach is conflicting
     * with some sparse existing PTS, and so it does not work out */
    if (!priv->reordered_output &&
        !GST_CLOCK_TIME_IS_VALID (frame->pts) && !seen_none &&
        GST_CLOCK_TIME_IS_VALID (priv->pts_delta)) {
      frame->pts = min_ts + priv->pts_delta;
      GST_DEBUG_OBJECT (decoder,
          "no valid PTS, using oldest DTS %" GST_TIME_FORMAT,
          GST_TIME_ARGS (frame->pts));
    }

    /* some more maintenance, ts2 holds PTS */
    min_ts = GST_CLOCK_TIME_NONE;
    seen_none = FALSE;
    for (l = priv->frames; l; l = l->next) {
      GstVideoCodecFrame *tmp = l->data;

      if (!GST_CLOCK_TIME_IS_VALID (tmp->abidata.ABI.ts2)) {
        seen_none = TRUE;
        continue;
      }

      if (!GST_CLOCK_TIME_IS_VALID (min_ts) || tmp->abidata.ABI.ts2 < min_ts) {
        min_ts = tmp->abidata.ABI.ts2;
        oframe = tmp;
      }
    }
    /* save a ts if needed */
    if (oframe && oframe != frame) {
      oframe->abidata.ABI.ts2 = frame->abidata.ABI.ts2;
    }

    /* if we detected reordered output, then PTS are void,
     * however those were obtained; bogus input, subclass etc */
    if (priv->reordered_output && !seen_none) {
      GST_DEBUG_OBJECT (decoder, "invalidating PTS");
      frame->pts = GST_CLOCK_TIME_NONE;
    }

    if (!GST_CLOCK_TIME_IS_VALID (frame->pts) && !seen_none) {
      frame->pts = min_ts;
      GST_DEBUG_OBJECT (decoder,
          "no valid PTS, using oldest PTS %" GST_TIME_FORMAT,
          GST_TIME_ARGS (frame->pts));
    }
  }


  if (frame->pts == GST_CLOCK_TIME_NONE) {
    /* Last ditch timestamp guess: Just add the duration to the previous
     * frame. If it's the first frame, just use the segment start. */
    if (frame->duration != GST_CLOCK_TIME_NONE) {
      if (GST_CLOCK_TIME_IS_VALID (priv->last_timestamp_out))
        frame->pts = priv->last_timestamp_out + frame->duration;
      else
        frame->pts = decoder->output_segment.start;
      GST_LOG_OBJECT (decoder,
          "Guessing timestamp %" GST_TIME_FORMAT " for frame...",
          GST_TIME_ARGS (frame->pts));
    } else if (sync && frame->dts != GST_CLOCK_TIME_NONE) {
      frame->pts = frame->dts;
      GST_LOG_OBJECT (decoder,
          "Setting DTS as PTS %" GST_TIME_FORMAT " for frame...",
          GST_TIME_ARGS (frame->pts));
    }
  }

  if (GST_CLOCK_TIME_IS_VALID (priv->last_timestamp_out)) {
    if (frame->pts < priv->last_timestamp_out) {
      GST_WARNING_OBJECT (decoder,
          "decreasing timestamp (%" GST_TIME_FORMAT " < %"
          GST_TIME_FORMAT ")",
          GST_TIME_ARGS (frame->pts), GST_TIME_ARGS (priv->last_timestamp_out));
      priv->reordered_output = TRUE;
      /* make it a bit less weird downstream */
      frame->pts = priv->last_timestamp_out;
    }
  }

  if (GST_CLOCK_TIME_IS_VALID (frame->pts))
    priv->last_timestamp_out = frame->pts;

  return;

  /* ERRORS */
no_output_buffer:
  {
    GST_ERROR_OBJECT (decoder, "No buffer to output !");
  }
}

/**
 * gst_video_decoder_release_frame:
 * @dec: a #GstVideoDecoder
 * @frame: (transfer full): the #GstVideoCodecFrame to release
 *
 * Similar to gst_video_decoder_drop_frame(), but simply releases @frame
 * without any processing other than removing it from list of pending frames,
 * after which it is considered finished and released.
 *
 * Since: 1.2.2
 */
void
gst_video_decoder_release_frame (GstVideoDecoder * dec,
    GstVideoCodecFrame * frame)
{
  GList *link;

  /* unref once from the list */
  GST_VIDEO_DECODER_STREAM_LOCK (dec);
  link = g_list_find (dec->priv->frames, frame);
  if (link) {
    gst_video_codec_frame_unref (frame);
    dec->priv->frames = g_list_delete_link (dec->priv->frames, link);
  }
  if (frame->events) {
    dec->priv->pending_events =
        g_list_concat (dec->priv->pending_events, frame->events);
    frame->events = NULL;
  }
  GST_VIDEO_DECODER_STREAM_UNLOCK (dec);

  /* unref because this function takes ownership */
  gst_video_codec_frame_unref (frame);
}

/**
 * gst_video_decoder_drop_frame:
 * @dec: a #GstVideoDecoder
 * @frame: (transfer full): the #GstVideoCodecFrame to drop
 *
 * Similar to gst_video_decoder_finish_frame(), but drops @frame in any
 * case and posts a QoS message with the frame's details on the bus.
 * In any case, the frame is considered finished and released.
 *
 * Returns: a #GstFlowReturn, usually GST_FLOW_OK.
 */
GstFlowReturn
gst_video_decoder_drop_frame (GstVideoDecoder * dec, GstVideoCodecFrame * frame)
{
  GstClockTime stream_time, jitter, earliest_time, qostime, timestamp;
  GstSegment *segment;
  GstMessage *qos_msg;
  gdouble proportion;

  GST_LOG_OBJECT (dec, "drop frame %p", frame);

  GST_VIDEO_DECODER_STREAM_LOCK (dec);

  gst_video_decoder_prepare_finish_frame (dec, frame, TRUE);

  GST_DEBUG_OBJECT (dec, "dropping frame %" GST_TIME_FORMAT,
      GST_TIME_ARGS (frame->pts));

  dec->priv->dropped++;

  /* post QoS message */
  GST_OBJECT_LOCK (dec);
  proportion = dec->priv->proportion;
  earliest_time = dec->priv->earliest_time;
  GST_OBJECT_UNLOCK (dec);

  timestamp = frame->pts;
  segment = &dec->output_segment;
  if (G_UNLIKELY (segment->format == GST_FORMAT_UNDEFINED))
    segment = &dec->input_segment;
  stream_time =
      gst_segment_to_stream_time (segment, GST_FORMAT_TIME, timestamp);
  qostime = gst_segment_to_running_time (segment, GST_FORMAT_TIME, timestamp);
  jitter = GST_CLOCK_DIFF (qostime, earliest_time);
  qos_msg =
      gst_message_new_qos (GST_OBJECT_CAST (dec), FALSE, qostime, stream_time,
      timestamp, GST_CLOCK_TIME_NONE);
  gst_message_set_qos_values (qos_msg, jitter, proportion, 1000000);
  gst_message_set_qos_stats (qos_msg, GST_FORMAT_BUFFERS,
      dec->priv->processed, dec->priv->dropped);
  gst_element_post_message (GST_ELEMENT_CAST (dec), qos_msg);

  /* now free the frame */
  gst_video_decoder_release_frame (dec, frame);

  GST_VIDEO_DECODER_STREAM_UNLOCK (dec);

  return GST_FLOW_OK;
}

/**
 * gst_video_decoder_finish_frame:
 * @decoder: a #GstVideoDecoder
 * @frame: (transfer full): a decoded #GstVideoCodecFrame
 *
 * @frame should have a valid decoded data buffer, whose metadata fields
 * are then appropriately set according to frame data and pushed downstream.
 * If no output data is provided, @frame is considered skipped.
 * In any case, the frame is considered finished and released.
 *
 * After calling this function the output buffer of the frame is to be
 * considered read-only. This function will also change the metadata
 * of the buffer.
 *
 * Returns: a #GstFlowReturn resulting from sending data downstream
 */
GstFlowReturn
gst_video_decoder_finish_frame (GstVideoDecoder * decoder,
    GstVideoCodecFrame * frame)
{
  GstFlowReturn ret = GST_FLOW_OK;
  GstVideoDecoderPrivate *priv = decoder->priv;
  GstBuffer *output_buffer;
  gboolean needs_reconfigure = FALSE;

  GST_LOG_OBJECT (decoder, "finish frame %p", frame);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  needs_reconfigure = gst_pad_check_reconfigure (decoder->srcpad);
  if (G_UNLIKELY (priv->output_state_changed || (priv->output_state
              && needs_reconfigure))) {
    if (!gst_video_decoder_negotiate_unlocked (decoder)) {
      gst_pad_mark_reconfigure (decoder->srcpad);
      if (GST_PAD_IS_FLUSHING (decoder->srcpad))
        ret = GST_FLOW_FLUSHING;
      else
        ret = GST_FLOW_NOT_NEGOTIATED;
      goto done;
    }
  }

  gst_video_decoder_prepare_finish_frame (decoder, frame, FALSE);
  priv->processed++;

  if (priv->tags && priv->tags_changed) {
    gst_video_decoder_push_event (decoder,
        gst_event_new_tag (gst_tag_list_ref (priv->tags)));
    priv->tags_changed = FALSE;
  }

  /* no buffer data means this frame is skipped */
  if (!frame->output_buffer || GST_VIDEO_CODEC_FRAME_IS_DECODE_ONLY (frame)) {
    GST_DEBUG_OBJECT (decoder, "skipping frame %" GST_TIME_FORMAT,
        GST_TIME_ARGS (frame->pts));
    goto done;
  }

  output_buffer = frame->output_buffer;

  GST_BUFFER_FLAG_UNSET (output_buffer, GST_BUFFER_FLAG_DELTA_UNIT);

  /* set PTS and DTS to both the PTS for decoded frames */
  GST_BUFFER_PTS (output_buffer) = frame->pts;
  GST_BUFFER_DTS (output_buffer) = frame->pts;
  GST_BUFFER_DURATION (output_buffer) = frame->duration;

  GST_BUFFER_OFFSET (output_buffer) = GST_BUFFER_OFFSET_NONE;
  GST_BUFFER_OFFSET_END (output_buffer) = GST_BUFFER_OFFSET_NONE;

  if (priv->discont) {
    GST_BUFFER_FLAG_SET (output_buffer, GST_BUFFER_FLAG_DISCONT);
    priv->discont = FALSE;
  }

  /* Get an additional ref to the buffer, which is going to be pushed
   * downstream, the original ref is owned by the frame
   *
   * FIXME: clip_and_push_buf() changes buffer metadata but the buffer
   * might have a refcount > 1 */
  output_buffer = gst_buffer_ref (output_buffer);

  /* Release frame so the buffer is writable when we push it downstream
   * if possible, i.e. if the subclass does not hold additional references
   * to the frame
   */
  gst_video_decoder_release_frame (decoder, frame);
  frame = NULL;

  if (decoder->output_segment.rate < 0.0) {
    GST_LOG_OBJECT (decoder, "queued frame");
    priv->output_queued = g_list_prepend (priv->output_queued, output_buffer);
  } else {
    ret = gst_video_decoder_clip_and_push_buf (decoder, output_buffer);
  }

done:
  if (frame)
    gst_video_decoder_release_frame (decoder, frame);
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
  return ret;
}


/* With stream lock, takes the frame reference */
static GstFlowReturn
gst_video_decoder_clip_and_push_buf (GstVideoDecoder * decoder, GstBuffer * buf)
{
  GstFlowReturn ret = GST_FLOW_OK;
  GstVideoDecoderPrivate *priv = decoder->priv;
  guint64 start, stop;
  guint64 cstart, cstop;
  GstSegment *segment;
  GstClockTime duration;

  /* Check for clipping */
  start = GST_BUFFER_PTS (buf);
  duration = GST_BUFFER_DURATION (buf);

  /* store that we have valid decoded data */
  priv->had_output_data = TRUE;

  stop = GST_CLOCK_TIME_NONE;

  if (GST_CLOCK_TIME_IS_VALID (start) && GST_CLOCK_TIME_IS_VALID (duration)) {
    stop = start + duration;
  }

  segment = &decoder->output_segment;
  if (gst_segment_clip (segment, GST_FORMAT_TIME, start, stop, &cstart, &cstop)) {

    GST_BUFFER_PTS (buf) = cstart;

    if (stop != GST_CLOCK_TIME_NONE)
      GST_BUFFER_DURATION (buf) = cstop - cstart;

    GST_LOG_OBJECT (decoder,
        "accepting buffer inside segment: %" GST_TIME_FORMAT " %"
        GST_TIME_FORMAT " seg %" GST_TIME_FORMAT " to %" GST_TIME_FORMAT
        " time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (GST_BUFFER_PTS (buf)),
        GST_TIME_ARGS (GST_BUFFER_PTS (buf) +
            GST_BUFFER_DURATION (buf)),
        GST_TIME_ARGS (segment->start), GST_TIME_ARGS (segment->stop),
        GST_TIME_ARGS (segment->time));
  } else {
    GST_LOG_OBJECT (decoder,
        "dropping buffer outside segment: %" GST_TIME_FORMAT
        " %" GST_TIME_FORMAT
        " seg %" GST_TIME_FORMAT " to %" GST_TIME_FORMAT
        " time %" GST_TIME_FORMAT,
        GST_TIME_ARGS (start), GST_TIME_ARGS (stop),
        GST_TIME_ARGS (segment->start),
        GST_TIME_ARGS (segment->stop), GST_TIME_ARGS (segment->time));
    if (segment->rate >= 0) {
      if (GST_BUFFER_PTS (buf) >= segment->stop)
        ret = GST_FLOW_EOS;
    } else if (GST_BUFFER_PTS (buf) < segment->start) {
      ret = GST_FLOW_EOS;
    }
    gst_buffer_unref (buf);
    goto done;
  }

  /* update rate estimate */
  priv->bytes_out += gst_buffer_get_size (buf);
  if (GST_CLOCK_TIME_IS_VALID (duration)) {
    priv->time += duration;
  } else {
    /* FIXME : Use difference between current and previous outgoing
     * timestamp, and relate to difference between current and previous
     * bytes */
    /* better none than nothing valid */
    priv->time = GST_CLOCK_TIME_NONE;
  }

  GST_DEBUG_OBJECT (decoder, "pushing buffer %p of size %" G_GSIZE_FORMAT ", "
      "PTS %" GST_TIME_FORMAT ", dur %" GST_TIME_FORMAT, buf,
      gst_buffer_get_size (buf),
      GST_TIME_ARGS (GST_BUFFER_PTS (buf)),
      GST_TIME_ARGS (GST_BUFFER_DURATION (buf)));

  /* we got data, so note things are looking up again, reduce
   * the error count, if there is one */
  if (G_UNLIKELY (priv->error_count))
    priv->error_count = 0;

  ret = gst_pad_push (decoder->srcpad, buf);

done:
  return ret;
}

/**
 * gst_video_decoder_add_to_frame:
 * @decoder: a #GstVideoDecoder
 * @n_bytes: the number of bytes to add
 *
 * Removes next @n_bytes of input data and adds it to currently parsed frame.
 */
void
gst_video_decoder_add_to_frame (GstVideoDecoder * decoder, int n_bytes)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  GstBuffer *buf;

  GST_LOG_OBJECT (decoder, "add %d bytes to frame", n_bytes);

  if (n_bytes == 0)
    return;

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  if (gst_adapter_available (priv->output_adapter) == 0) {
    priv->frame_offset =
        priv->input_offset - gst_adapter_available (priv->input_adapter);
  }
  buf = gst_adapter_take_buffer (priv->input_adapter, n_bytes);

  gst_adapter_push (priv->output_adapter, buf);
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
}

/**
 * gst_video_decoder_get_pending_frame_size:
 * @decoder: a #GstVideoDecoder
 *
 * Returns the number of bytes previously added to the current frame
 * by calling gst_video_decoder_add_to_frame().
 *
 * Returns: The number of bytes pending for the current frame
 *
 * Since: 1.4
 */
gsize
gst_video_decoder_get_pending_frame_size (GstVideoDecoder * decoder)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  gsize ret;

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  ret = gst_adapter_available (priv->output_adapter);
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  GST_LOG_OBJECT (decoder, "Current pending frame has %" G_GSIZE_FORMAT "bytes",
      ret);

  return ret;
}

static guint64
gst_video_decoder_get_frame_duration (GstVideoDecoder * decoder,
    GstVideoCodecFrame * frame)
{
  GstVideoCodecState *state = decoder->priv->output_state;

  /* it's possible that we don't have a state yet when we are dropping the
   * initial buffers */
  if (state == NULL)
    return GST_CLOCK_TIME_NONE;

  if (state->info.fps_d == 0 || state->info.fps_n == 0) {
    return GST_CLOCK_TIME_NONE;
  }

  /* FIXME: For interlaced frames this needs to take into account
   * the number of valid fields in the frame
   */

  return gst_util_uint64_scale (GST_SECOND, state->info.fps_d,
      state->info.fps_n);
}

/**
 * gst_video_decoder_have_frame:
 * @decoder: a #GstVideoDecoder
 *
 * Gathers all data collected for currently parsed frame, gathers corresponding
 * metadata and passes it along for further processing, i.e. @handle_frame.
 *
 * Returns: a #GstFlowReturn
 */
GstFlowReturn
gst_video_decoder_have_frame (GstVideoDecoder * decoder)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  GstBuffer *buffer;
  int n_available;
  GstClockTime pts, dts, duration;
  GstFlowReturn ret = GST_FLOW_OK;

  GST_LOG_OBJECT (decoder, "have_frame");

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  n_available = gst_adapter_available (priv->output_adapter);
  if (n_available) {
    buffer = gst_adapter_take_buffer (priv->output_adapter, n_available);
  } else {
    buffer = gst_buffer_new_and_alloc (0);
  }

  priv->current_frame->input_buffer = buffer;

  gst_video_decoder_get_timestamp_at_offset (decoder,
      priv->frame_offset, &pts, &dts, &duration);

  GST_BUFFER_PTS (buffer) = pts;
  GST_BUFFER_DTS (buffer) = dts;
  GST_BUFFER_DURATION (buffer) = duration;

  GST_LOG_OBJECT (decoder, "collected frame size %d, "
      "PTS %" GST_TIME_FORMAT ", DTS %" GST_TIME_FORMAT ", dur %"
      GST_TIME_FORMAT, n_available, GST_TIME_ARGS (pts), GST_TIME_ARGS (dts),
      GST_TIME_ARGS (duration));

  /* In reverse playback, just capture and queue frames for later processing */
  if (decoder->output_segment.rate < 0.0) {
    priv->parse_gather =
        g_list_prepend (priv->parse_gather, priv->current_frame);
  } else {
    /* Otherwise, decode the frame, which gives away our ref */
    ret = gst_video_decoder_decode_frame (decoder, priv->current_frame);
  }
  /* Current frame is gone now, either way */
  priv->current_frame = NULL;

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return ret;
}

/* Pass the frame in priv->current_frame through the
 * handle_frame() callback for decoding and passing to gvd_finish_frame(), 
 * or dropping by passing to gvd_drop_frame() */
static GstFlowReturn
gst_video_decoder_decode_frame (GstVideoDecoder * decoder,
    GstVideoCodecFrame * frame)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  GstVideoDecoderClass *decoder_class;
  GstFlowReturn ret = GST_FLOW_OK;

  decoder_class = GST_VIDEO_DECODER_GET_CLASS (decoder);

  /* FIXME : This should only have to be checked once (either the subclass has an 
   * implementation, or it doesn't) */
  g_return_val_if_fail (decoder_class->handle_frame != NULL, GST_FLOW_ERROR);

  frame->distance_from_sync = priv->distance_from_sync;
  priv->distance_from_sync++;
  frame->pts = GST_BUFFER_PTS (frame->input_buffer);
  frame->dts = GST_BUFFER_DTS (frame->input_buffer);
  frame->duration = GST_BUFFER_DURATION (frame->input_buffer);

  /* For keyframes, PTS = DTS + constant_offset, usually 0 to 3 frame
   * durations. */
  /* FIXME upstream can be quite wrong about the keyframe aspect,
   * so we could be going off here as well,
   * maybe let subclass decide if it really is/was a keyframe */
  if (GST_VIDEO_CODEC_FRAME_IS_SYNC_POINT (frame) &&
      GST_CLOCK_TIME_IS_VALID (frame->pts)
      && GST_CLOCK_TIME_IS_VALID (frame->dts)) {
    /* just in case they are not equal as might ideally be,
     * e.g. quicktime has a (positive) delta approach */
    priv->pts_delta = frame->pts - frame->dts;
    GST_DEBUG_OBJECT (decoder, "PTS delta %d ms",
        (gint) (priv->pts_delta / GST_MSECOND));
  }

  frame->abidata.ABI.ts = frame->dts;
  frame->abidata.ABI.ts2 = frame->pts;

  GST_LOG_OBJECT (decoder, "PTS %" GST_TIME_FORMAT ", DTS %" GST_TIME_FORMAT,
      GST_TIME_ARGS (frame->pts), GST_TIME_ARGS (frame->dts));
  GST_LOG_OBJECT (decoder, "dist %d", frame->distance_from_sync);

  gst_video_codec_frame_ref (frame);
  priv->frames = g_list_append (priv->frames, frame);

  if (g_list_length (priv->frames) > 10) {
    GST_DEBUG_OBJECT (decoder, "decoder frame list getting long: %d frames,"
        "possible internal leaking?", g_list_length (priv->frames));
  }

  frame->deadline =
      gst_segment_to_running_time (&decoder->input_segment, GST_FORMAT_TIME,
      frame->pts);

  /* do something with frame */
  ret = decoder_class->handle_frame (decoder, frame);
  if (ret != GST_FLOW_OK)
    GST_DEBUG_OBJECT (decoder, "flow error %s", gst_flow_get_name (ret));

  /* the frame has either been added to parse_gather or sent to
     handle frame so there is no need to unref it */
  return ret;
}


/**
 * gst_video_decoder_get_output_state:
 * @decoder: a #GstVideoDecoder
 *
 * Get the #GstVideoCodecState currently describing the output stream.
 *
 * Returns: (transfer full): #GstVideoCodecState describing format of video data.
 */
GstVideoCodecState *
gst_video_decoder_get_output_state (GstVideoDecoder * decoder)
{
  GstVideoCodecState *state = NULL;

  GST_OBJECT_LOCK (decoder);
  if (decoder->priv->output_state)
    state = gst_video_codec_state_ref (decoder->priv->output_state);
  GST_OBJECT_UNLOCK (decoder);

  return state;
}

/**
 * gst_video_decoder_set_output_state:
 * @decoder: a #GstVideoDecoder
 * @fmt: a #GstVideoFormat
 * @width: The width in pixels
 * @height: The height in pixels
 * @reference: (allow-none) (transfer none): An optional reference #GstVideoCodecState
 *
 * Creates a new #GstVideoCodecState with the specified @fmt, @width and @height
 * as the output state for the decoder.
 * Any previously set output state on @decoder will be replaced by the newly
 * created one.
 *
 * If the subclass wishes to copy over existing fields (like pixel aspec ratio,
 * or framerate) from an existing #GstVideoCodecState, it can be provided as a
 * @reference.
 *
 * If the subclass wishes to override some fields from the output state (like
 * pixel-aspect-ratio or framerate) it can do so on the returned #GstVideoCodecState.
 *
 * The new output state will only take effect (set on pads and buffers) starting
 * from the next call to #gst_video_decoder_finish_frame().
 *
 * Returns: (transfer full): the newly configured output state.
 */
GstVideoCodecState *
gst_video_decoder_set_output_state (GstVideoDecoder * decoder,
    GstVideoFormat fmt, guint width, guint height,
    GstVideoCodecState * reference)
{
  GstVideoDecoderPrivate *priv = decoder->priv;
  GstVideoCodecState *state;

  GST_DEBUG_OBJECT (decoder, "fmt:%d, width:%d, height:%d, reference:%p",
      fmt, width, height, reference);

  /* Create the new output state */
  state = _new_output_state (fmt, width, height, reference);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  GST_OBJECT_LOCK (decoder);
  /* Replace existing output state by new one */
  if (priv->output_state)
    gst_video_codec_state_unref (priv->output_state);
  priv->output_state = gst_video_codec_state_ref (state);

  if (priv->output_state != NULL && priv->output_state->info.fps_n > 0) {
    priv->qos_frame_duration =
        gst_util_uint64_scale (GST_SECOND, priv->output_state->info.fps_d,
        priv->output_state->info.fps_n);
  } else {
    priv->qos_frame_duration = 0;
  }
  priv->output_state_changed = TRUE;
  GST_OBJECT_UNLOCK (decoder);

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return state;
}


/**
 * gst_video_decoder_get_oldest_frame:
 * @decoder: a #GstVideoDecoder
 *
 * Get the oldest pending unfinished #GstVideoCodecFrame
 *
 * Returns: (transfer full): oldest pending unfinished #GstVideoCodecFrame.
 */
GstVideoCodecFrame *
gst_video_decoder_get_oldest_frame (GstVideoDecoder * decoder)
{
  GstVideoCodecFrame *frame = NULL;

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  if (decoder->priv->frames)
    frame = gst_video_codec_frame_ref (decoder->priv->frames->data);
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return (GstVideoCodecFrame *) frame;
}

/**
 * gst_video_decoder_get_frame:
 * @decoder: a #GstVideoDecoder
 * @frame_number: system_frame_number of a frame
 *
 * Get a pending unfinished #GstVideoCodecFrame
 * 
 * Returns: (transfer full): pending unfinished #GstVideoCodecFrame identified by @frame_number.
 */
GstVideoCodecFrame *
gst_video_decoder_get_frame (GstVideoDecoder * decoder, int frame_number)
{
  GList *g;
  GstVideoCodecFrame *frame = NULL;

  GST_DEBUG_OBJECT (decoder, "frame_number : %d", frame_number);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  for (g = decoder->priv->frames; g; g = g->next) {
    GstVideoCodecFrame *tmp = g->data;

    if (tmp->system_frame_number == frame_number) {
      frame = gst_video_codec_frame_ref (tmp);
      break;
    }
  }
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return frame;
}

/**
 * gst_video_decoder_get_frames:
 * @decoder: a #GstVideoDecoder
 *
 * Get all pending unfinished #GstVideoCodecFrame
 * 
 * Returns: (transfer full) (element-type GstVideoCodecFrame): pending unfinished #GstVideoCodecFrame.
 */
GList *
gst_video_decoder_get_frames (GstVideoDecoder * decoder)
{
  GList *frames;

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  frames = g_list_copy (decoder->priv->frames);
  g_list_foreach (frames, (GFunc) gst_video_codec_frame_ref, NULL);
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return frames;
}

static gboolean
gst_video_decoder_decide_allocation_default (GstVideoDecoder * decoder,
    GstQuery * query)
{
  GstCaps *outcaps = NULL;
  GstBufferPool *pool = NULL;
  guint size, min, max;
  GstAllocator *allocator = NULL;
  GstAllocationParams params;
  GstStructure *config;
  gboolean update_pool, update_allocator;
  GstVideoInfo vinfo;

  gst_query_parse_allocation (query, &outcaps, NULL);
  gst_video_info_init (&vinfo);
  if (outcaps)
    gst_video_info_from_caps (&vinfo, outcaps);

  /* we got configuration from our peer or the decide_allocation method,
   * parse them */
  if (gst_query_get_n_allocation_params (query) > 0) {
    /* try the allocator */
    gst_query_parse_nth_allocation_param (query, 0, &allocator, &params);
    update_allocator = TRUE;
  } else {
    allocator = NULL;
    gst_allocation_params_init (&params);
    update_allocator = FALSE;
  }

  if (gst_query_get_n_allocation_pools (query) > 0) {
    gst_query_parse_nth_allocation_pool (query, 0, &pool, &size, &min, &max);
    size = MAX (size, vinfo.size);
    update_pool = TRUE;
  } else {
    pool = NULL;
    size = vinfo.size;
    min = max = 0;

    update_pool = FALSE;
  }

  if (pool == NULL) {
    /* no pool, we can make our own */
    GST_DEBUG_OBJECT (decoder, "no pool, making new pool");
    pool = gst_video_buffer_pool_new ();
  }

  /* now configure */
  config = gst_buffer_pool_get_config (pool);
  gst_buffer_pool_config_set_params (config, outcaps, size, min, max);
  gst_buffer_pool_config_set_allocator (config, allocator, &params);

  if (!gst_buffer_pool_set_config (pool, config)) {
    config = gst_buffer_pool_get_config (pool);

    /* If change are not acceptable, fallback to generic pool */
    if (!gst_buffer_pool_config_validate_params (config, outcaps, size, min,
            max)) {
      GST_DEBUG_OBJECT (decoder, "unsuported pool, making new pool");

      gst_object_unref (pool);
      pool = gst_video_buffer_pool_new ();
      gst_buffer_pool_config_set_params (config, outcaps, size, min, max);
      gst_buffer_pool_config_set_allocator (config, allocator, &params);
    }

    if (!gst_buffer_pool_set_config (pool, config))
      goto config_failed;
  }

  if (update_allocator)
    gst_query_set_nth_allocation_param (query, 0, allocator, &params);
  else
    gst_query_add_allocation_param (query, allocator, &params);
  if (allocator)
    gst_object_unref (allocator);

  if (update_pool)
    gst_query_set_nth_allocation_pool (query, 0, pool, size, min, max);
  else
    gst_query_add_allocation_pool (query, pool, size, min, max);

  if (pool)
    gst_object_unref (pool);

  return TRUE;

config_failed:
  GST_ELEMENT_ERROR (decoder, RESOURCE, SETTINGS,
      ("Failed to configure the buffer pool"),
      ("Configuration is most likely invalid, please report this issue."));
  return FALSE;
}

static gboolean
gst_video_decoder_propose_allocation_default (GstVideoDecoder * decoder,
    GstQuery * query)
{
  return TRUE;
}

static gboolean
gst_video_decoder_negotiate_pool (GstVideoDecoder * decoder, GstCaps * caps)
{
  GstVideoDecoderClass *klass;
  GstQuery *query = NULL;
  GstBufferPool *pool = NULL;
  GstAllocator *allocator;
  GstAllocationParams params;
  gboolean ret = TRUE;

  klass = GST_VIDEO_DECODER_GET_CLASS (decoder);

  query = gst_query_new_allocation (caps, TRUE);

  if (!gst_pad_peer_query (decoder->srcpad, query)) {
    GST_DEBUG_OBJECT (decoder, "didn't get downstream ALLOCATION hints");
  }

  g_assert (klass->decide_allocation != NULL);
  ret = klass->decide_allocation (decoder, query);

  GST_DEBUG_OBJECT (decoder, "ALLOCATION (%d) params: %" GST_PTR_FORMAT, ret,
      query);

  if (!ret)
    goto no_decide_allocation;

  /* we got configuration from our peer or the decide_allocation method,
   * parse them */
  if (gst_query_get_n_allocation_params (query) > 0) {
    gst_query_parse_nth_allocation_param (query, 0, &allocator, &params);
  } else {
    allocator = NULL;
    gst_allocation_params_init (&params);
  }

  if (gst_query_get_n_allocation_pools (query) > 0)
    gst_query_parse_nth_allocation_pool (query, 0, &pool, NULL, NULL, NULL);
  if (!pool) {
    if (allocator)
      gst_object_unref (allocator);
    ret = FALSE;
    goto no_decide_allocation;
  }

  if (decoder->priv->allocator)
    gst_object_unref (decoder->priv->allocator);
  decoder->priv->allocator = allocator;
  decoder->priv->params = params;

  if (decoder->priv->pool) {
    /* do not set the bufferpool to inactive here, it will be done
     * on its finalize function. As videodecoder do late renegotiation
     * it might happen that some element downstream is already using this
     * same bufferpool and deactivating it will make it fail.
     * Happens when a downstream element changes from passthrough to
     * non-passthrough and gets this same bufferpool to use */
    gst_object_unref (decoder->priv->pool);
  }
  decoder->priv->pool = pool;

  /* and activate */
  gst_buffer_pool_set_active (pool, TRUE);

done:
  if (query)
    gst_query_unref (query);

  return ret;

  /* Errors */
no_decide_allocation:
  {
    GST_WARNING_OBJECT (decoder, "Subclass failed to decide allocation");
    goto done;
  }
}

static gboolean
gst_video_decoder_negotiate_default (GstVideoDecoder * decoder)
{
  GstVideoCodecState *state = decoder->priv->output_state;
  gboolean ret = TRUE;
  GstVideoCodecFrame *frame;
  GstCaps *prevcaps;

  if (!state) {
    GST_DEBUG_OBJECT (decoder,
        "Trying to negotiate the pool with out setting the o/p format");
    ret = gst_video_decoder_negotiate_pool (decoder, NULL);
    goto done;
  }

  g_return_val_if_fail (GST_VIDEO_INFO_WIDTH (&state->info) != 0, FALSE);
  g_return_val_if_fail (GST_VIDEO_INFO_HEIGHT (&state->info) != 0, FALSE);

  GST_DEBUG_OBJECT (decoder, "output_state par %d/%d fps %d/%d",
      state->info.par_n, state->info.par_d,
      state->info.fps_n, state->info.fps_d);

  if (state->caps == NULL)
    state->caps = gst_video_info_to_caps (&state->info);

  GST_DEBUG_OBJECT (decoder, "setting caps %" GST_PTR_FORMAT, state->caps);

  /* Push all pending pre-caps events of the oldest frame before
   * setting caps */
  frame = decoder->priv->frames ? decoder->priv->frames->data : NULL;
  if (frame || decoder->priv->current_frame_events) {
    GList **events, *l;

    if (frame) {
      events = &frame->events;
    } else {
      events = &decoder->priv->current_frame_events;
    }

    for (l = g_list_last (*events); l;) {
      GstEvent *event = GST_EVENT (l->data);
      GList *tmp;

      if (GST_EVENT_TYPE (event) < GST_EVENT_CAPS) {
        gst_video_decoder_push_event (decoder, event);
        tmp = l;
        l = l->prev;
        *events = g_list_delete_link (*events, tmp);
      } else {
        l = l->prev;
      }
    }
  }

  prevcaps = gst_pad_get_current_caps (decoder->srcpad);
  if (!prevcaps || !gst_caps_is_equal (prevcaps, state->caps))
    ret = gst_pad_set_caps (decoder->srcpad, state->caps);
  else
    ret = TRUE;
  if (prevcaps)
    gst_caps_unref (prevcaps);

  if (!ret)
    goto done;
  decoder->priv->output_state_changed = FALSE;
  /* Negotiate pool */
  ret = gst_video_decoder_negotiate_pool (decoder, state->caps);

done:
  return ret;
}

static gboolean
gst_video_decoder_negotiate_unlocked (GstVideoDecoder * decoder)
{
  GstVideoDecoderClass *klass = GST_VIDEO_DECODER_GET_CLASS (decoder);
  gboolean ret = TRUE;

  if (G_LIKELY (klass->negotiate))
    ret = klass->negotiate (decoder);

  return ret;
}

/**
 * gst_video_decoder_negotiate:
 * @decoder: a #GstVideoDecoder
 *
 * Negotiate with downstream elements to currently configured #GstVideoCodecState.
 * Unmark GST_PAD_FLAG_NEED_RECONFIGURE in any case. But mark it again if
 * negotiate fails.
 *
 * Returns: #TRUE if the negotiation succeeded, else #FALSE.
 */
gboolean
gst_video_decoder_negotiate (GstVideoDecoder * decoder)
{
  GstVideoDecoderClass *klass;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_IS_VIDEO_DECODER (decoder), FALSE);

  klass = GST_VIDEO_DECODER_GET_CLASS (decoder);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  gst_pad_check_reconfigure (decoder->srcpad);
  if (klass->negotiate) {
    ret = klass->negotiate (decoder);
    if (!ret)
      gst_pad_mark_reconfigure (decoder->srcpad);
  }
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return ret;
}

/**
 * gst_video_decoder_allocate_output_buffer:
 * @decoder: a #GstVideoDecoder
 *
 * Helper function that allocates a buffer to hold a video frame for @decoder's
 * current #GstVideoCodecState.
 *
 * You should use gst_video_decoder_allocate_output_frame() instead of this
 * function, if possible at all.
 *
 * Returns: (transfer full): allocated buffer, or NULL if no buffer could be
 *     allocated (e.g. when downstream is flushing or shutting down)
 */
GstBuffer *
gst_video_decoder_allocate_output_buffer (GstVideoDecoder * decoder)
{
  GstFlowReturn flow;
  GstBuffer *buffer = NULL;
  gboolean needs_reconfigure = FALSE;

  GST_DEBUG ("alloc src buffer");

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  needs_reconfigure = gst_pad_check_reconfigure (decoder->srcpad);
  if (G_UNLIKELY (!decoder->priv->output_state
          || decoder->priv->output_state_changed || needs_reconfigure)) {
    if (!gst_video_decoder_negotiate_unlocked (decoder)) {
      if (decoder->priv->output_state) {
        GST_DEBUG_OBJECT (decoder, "Failed to negotiate, fallback allocation");
        gst_pad_mark_reconfigure (decoder->srcpad);
        goto fallback;
      } else {
        GST_DEBUG_OBJECT (decoder, "Failed to negotiate, output_buffer=NULL");
        goto failed_allocation;
      }
    }
  }

  flow = gst_buffer_pool_acquire_buffer (decoder->priv->pool, &buffer, NULL);

  if (flow != GST_FLOW_OK) {
    GST_INFO_OBJECT (decoder, "couldn't allocate output buffer, flow %s",
        gst_flow_get_name (flow));
    if (decoder->priv->output_state && decoder->priv->output_state->info.size)
      goto fallback;
    else
      goto failed_allocation;
  }
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return buffer;

fallback:
  GST_INFO_OBJECT (decoder,
      "Fallback allocation, creating new buffer which doesn't belongs to any buffer pool");
  buffer =
      gst_buffer_new_allocate (NULL, decoder->priv->output_state->info.size,
      NULL);

failed_allocation:
  GST_ERROR_OBJECT (decoder, "Failed to allocate the buffer..");
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return buffer;
}

/**
 * gst_video_decoder_allocate_output_frame:
 * @decoder: a #GstVideoDecoder
 * @frame: a #GstVideoCodecFrame
 *
 * Helper function that allocates a buffer to hold a video frame for @decoder's
 * current #GstVideoCodecState.  Subclass should already have configured video
 * state and set src pad caps.
 *
 * The buffer allocated here is owned by the frame and you should only
 * keep references to the frame, not the buffer.
 *
 * Returns: %GST_FLOW_OK if an output buffer could be allocated
 */
GstFlowReturn
gst_video_decoder_allocate_output_frame (GstVideoDecoder *
    decoder, GstVideoCodecFrame * frame)
{
  GstFlowReturn flow_ret;
  GstVideoCodecState *state;
  int num_bytes;
  gboolean needs_reconfigure = FALSE;

  g_return_val_if_fail (decoder->priv->output_state, GST_FLOW_NOT_NEGOTIATED);
  g_return_val_if_fail (frame->output_buffer == NULL, GST_FLOW_ERROR);

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);

  state = decoder->priv->output_state;
  if (state == NULL) {
    g_warning ("Output state should be set before allocating frame");
    goto error;
  }
  num_bytes = GST_VIDEO_INFO_SIZE (&state->info);
  if (num_bytes == 0) {
    g_warning ("Frame size should not be 0");
    goto error;
  }

  needs_reconfigure = gst_pad_check_reconfigure (decoder->srcpad);
  if (G_UNLIKELY (decoder->priv->output_state_changed || needs_reconfigure)) {
    if (!gst_video_decoder_negotiate_unlocked (decoder)) {
      GST_DEBUG_OBJECT (decoder, "Failed to negotiate, fallback allocation");
      gst_pad_mark_reconfigure (decoder->srcpad);
    }
  }

  GST_LOG_OBJECT (decoder, "alloc buffer size %d", num_bytes);

  flow_ret = gst_buffer_pool_acquire_buffer (decoder->priv->pool,
      &frame->output_buffer, NULL);

  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);

  return flow_ret;

error:
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
  return GST_FLOW_ERROR;
}

/**
 * gst_video_decoder_get_max_decode_time:
 * @decoder: a #GstVideoDecoder
 * @frame: a #GstVideoCodecFrame
 *
 * Determines maximum possible decoding time for @frame that will
 * allow it to decode and arrive in time (as determined by QoS events).
 * In particular, a negative result means decoding in time is no longer possible
 * and should therefore occur as soon/skippy as possible.
 *
 * Returns: max decoding time.
 */
GstClockTimeDiff
gst_video_decoder_get_max_decode_time (GstVideoDecoder *
    decoder, GstVideoCodecFrame * frame)
{
  GstClockTimeDiff deadline;
  GstClockTime earliest_time;

  GST_OBJECT_LOCK (decoder);
  earliest_time = decoder->priv->earliest_time;
  if (GST_CLOCK_TIME_IS_VALID (earliest_time)
      && GST_CLOCK_TIME_IS_VALID (frame->deadline))
    deadline = GST_CLOCK_DIFF (earliest_time, frame->deadline);
  else
    deadline = G_MAXINT64;

  GST_LOG_OBJECT (decoder, "earliest %" GST_TIME_FORMAT
      ", frame deadline %" GST_TIME_FORMAT ", deadline %" GST_TIME_FORMAT,
      GST_TIME_ARGS (earliest_time), GST_TIME_ARGS (frame->deadline),
      GST_TIME_ARGS (deadline));

  GST_OBJECT_UNLOCK (decoder);

  return deadline;
}

/**
 * gst_video_decoder_get_qos_proportion:
 * @decoder: a #GstVideoDecoder
 *     current QoS proportion, or %NULL
 *
 * Returns: The current QoS proportion.
 *
 * Since: 1.0.3
 */
gdouble
gst_video_decoder_get_qos_proportion (GstVideoDecoder * decoder)
{
  gdouble proportion;

  g_return_val_if_fail (GST_IS_VIDEO_DECODER (decoder), 1.0);

  GST_OBJECT_LOCK (decoder);
  proportion = decoder->priv->proportion;
  GST_OBJECT_UNLOCK (decoder);

  return proportion;
}

GstFlowReturn
_gst_video_decoder_error (GstVideoDecoder * dec, gint weight,
    GQuark domain, gint code, gchar * txt, gchar * dbg, const gchar * file,
    const gchar * function, gint line)
{
  if (txt)
    GST_WARNING_OBJECT (dec, "error: %s", txt);
  if (dbg)
    GST_WARNING_OBJECT (dec, "error: %s", dbg);
  dec->priv->error_count += weight;
  dec->priv->discont = TRUE;
  if (dec->priv->max_errors >= 0 &&
      dec->priv->error_count > dec->priv->max_errors) {
    gst_element_message_full (GST_ELEMENT (dec), GST_MESSAGE_ERROR,
        domain, code, txt, dbg, file, function, line);
    return GST_FLOW_ERROR;
  } else {
    g_free (txt);
    g_free (dbg);
    return GST_FLOW_OK;
  }
}

/**
 * gst_video_decoder_set_max_errors:
 * @dec: a #GstVideoDecoder
 * @num: max tolerated errors
 *
 * Sets numbers of tolerated decoder errors, where a tolerated one is then only
 * warned about, but more than tolerated will lead to fatal error.  You can set
 * -1 for never returning fatal errors. Default is set to
 * GST_VIDEO_DECODER_MAX_ERRORS.
 *
 * The '-1' option was added in 1.4
 */
void
gst_video_decoder_set_max_errors (GstVideoDecoder * dec, gint num)
{
  g_return_if_fail (GST_IS_VIDEO_DECODER (dec));

  dec->priv->max_errors = num;
}

/**
 * gst_video_decoder_get_max_errors:
 * @dec: a #GstVideoDecoder
 *
 * Returns: currently configured decoder tolerated error count.
 */
gint
gst_video_decoder_get_max_errors (GstVideoDecoder * dec)
{
  g_return_val_if_fail (GST_IS_VIDEO_DECODER (dec), 0);

  return dec->priv->max_errors;
}

/**
 * gst_video_decoder_set_needs_format:
 * @dec: a #GstVideoDecoder
 * @enabled: new state
 *
 * Configures decoder format needs.  If enabled, subclass needs to be
 * negotiated with format caps before it can process any data.  It will then
 * never be handed any data before it has been configured.
 * Otherwise, it might be handed data without having been configured and
 * is then expected being able to do so either by default
 * or based on the input data.
 *
 * Since: 1.4
 */
void
gst_video_decoder_set_needs_format (GstVideoDecoder * dec, gboolean enabled)
{
  g_return_if_fail (GST_IS_VIDEO_DECODER (dec));

  dec->priv->needs_format = enabled;
}

/**
 * gst_video_decoder_get_needs_format:
 * @dec: a #GstVideoDecoder
 *
 * Queries decoder required format handling.
 *
 * Returns: %TRUE if required format handling is enabled.
 *
 * Since: 1.4
 */
gboolean
gst_video_decoder_get_needs_format (GstVideoDecoder * dec)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_VIDEO_DECODER (dec), FALSE);

  result = dec->priv->needs_format;

  return result;
}

/**
 * gst_video_decoder_set_packetized:
 * @decoder: a #GstVideoDecoder
 * @packetized: whether the input data should be considered as packetized.
 *
 * Allows baseclass to consider input data as packetized or not. If the
 * input is packetized, then the @parse method will not be called.
 */
void
gst_video_decoder_set_packetized (GstVideoDecoder * decoder,
    gboolean packetized)
{
  decoder->priv->packetized = packetized;
}

/**
 * gst_video_decoder_get_packetized:
 * @decoder: a #GstVideoDecoder
 *
 * Queries whether input data is considered packetized or not by the
 * base class.
 *
 * Returns: TRUE if input data is considered packetized.
 */
gboolean
gst_video_decoder_get_packetized (GstVideoDecoder * decoder)
{
  return decoder->priv->packetized;
}

/**
 * gst_video_decoder_set_estimate_rate:
 * @dec: a #GstVideoDecoder
 * @enabled: whether to enable byte to time conversion
 *
 * Allows baseclass to perform byte to time estimated conversion.
 */
void
gst_video_decoder_set_estimate_rate (GstVideoDecoder * dec, gboolean enabled)
{
  g_return_if_fail (GST_IS_VIDEO_DECODER (dec));

  dec->priv->do_estimate_rate = enabled;
}

/**
 * gst_video_decoder_get_estimate_rate:
 * @dec: a #GstVideoDecoder
 *
 * Returns: currently configured byte to time conversion setting
 */
gboolean
gst_video_decoder_get_estimate_rate (GstVideoDecoder * dec)
{
  g_return_val_if_fail (GST_IS_VIDEO_DECODER (dec), 0);

  return dec->priv->do_estimate_rate;
}

/**
 * gst_video_decoder_set_latency:
 * @decoder: a #GstVideoDecoder
 * @min_latency: minimum latency
 * @max_latency: maximum latency
 *
 * Lets #GstVideoDecoder sub-classes tell the baseclass what the decoder
 * latency is. Will also post a LATENCY message on the bus so the pipeline
 * can reconfigure its global latency.
 */
void
gst_video_decoder_set_latency (GstVideoDecoder * decoder,
    GstClockTime min_latency, GstClockTime max_latency)
{
  g_return_if_fail (GST_CLOCK_TIME_IS_VALID (min_latency));
  g_return_if_fail (max_latency >= min_latency);

  GST_OBJECT_LOCK (decoder);
  decoder->priv->min_latency = min_latency;
  decoder->priv->max_latency = max_latency;
  GST_OBJECT_UNLOCK (decoder);

  gst_element_post_message (GST_ELEMENT_CAST (decoder),
      gst_message_new_latency (GST_OBJECT_CAST (decoder)));
}

/**
 * gst_video_decoder_get_latency:
 * @decoder: a #GstVideoDecoder
 * @min_latency: (out) (allow-none): address of variable in which to store the
 *     configured minimum latency, or %NULL
 * @max_latency: (out) (allow-none): address of variable in which to store the
 *     configured mximum latency, or %NULL
 *
 * Query the configured decoder latency. Results will be returned via
 * @min_latency and @max_latency.
 */
void
gst_video_decoder_get_latency (GstVideoDecoder * decoder,
    GstClockTime * min_latency, GstClockTime * max_latency)
{
  GST_OBJECT_LOCK (decoder);
  if (min_latency)
    *min_latency = decoder->priv->min_latency;
  if (max_latency)
    *max_latency = decoder->priv->max_latency;
  GST_OBJECT_UNLOCK (decoder);
}

/**
 * gst_video_decoder_merge_tags:
 * @decoder: a #GstVideoDecoder
 * @tags: a #GstTagList to merge
 * @mode: the #GstTagMergeMode to use
 *
 * Adds tags to so-called pending tags, which will be processed
 * before pushing out data downstream.
 *
 * Note that this is provided for convenience, and the subclass is
 * not required to use this and can still do tag handling on its own.
 *
 * MT safe.
 */
void
gst_video_decoder_merge_tags (GstVideoDecoder * decoder,
    const GstTagList * tags, GstTagMergeMode mode)
{
  GstTagList *otags;

  g_return_if_fail (GST_IS_VIDEO_DECODER (decoder));
  g_return_if_fail (tags == NULL || GST_IS_TAG_LIST (tags));

  GST_VIDEO_DECODER_STREAM_LOCK (decoder);
  if (tags)
    GST_DEBUG_OBJECT (decoder, "merging tags %" GST_PTR_FORMAT, tags);
  otags = decoder->priv->tags;
  decoder->priv->tags = gst_tag_list_merge (decoder->priv->tags, tags, mode);
  if (otags)
    gst_tag_list_unref (otags);
  decoder->priv->tags_changed = TRUE;
  GST_VIDEO_DECODER_STREAM_UNLOCK (decoder);
}

/**
 * gst_video_decoder_get_buffer_pool:
 * @decoder: a #GstVideoDecoder
 *
 * Returns: (transfer full): the instance of the #GstBufferPool used
 * by the decoder; free it after use it
 */
GstBufferPool *
gst_video_decoder_get_buffer_pool (GstVideoDecoder * decoder)
{
  g_return_val_if_fail (GST_IS_VIDEO_DECODER (decoder), NULL);

  if (decoder->priv->pool)
    return gst_object_ref (decoder->priv->pool);

  return NULL;
}

/**
 * gst_video_decoder_get_allocator:
 * @decoder: a #GstVideoDecoder
 * @allocator: (out) (allow-none) (transfer full): the #GstAllocator
 * used
 * @params: (out) (allow-none) (transfer full): the
 * #GstAllocatorParams of @allocator
 *
 * Lets #GstVideoDecoder sub-classes to know the memory @allocator
 * used by the base class and its @params.
 *
 * Unref the @allocator after use it.
 */
void
gst_video_decoder_get_allocator (GstVideoDecoder * decoder,
    GstAllocator ** allocator, GstAllocationParams * params)
{
  g_return_if_fail (GST_IS_VIDEO_DECODER (decoder));

  if (allocator)
    *allocator = decoder->priv->allocator ?
        gst_object_ref (decoder->priv->allocator) : NULL;

  if (params)
    *params = decoder->priv->params;
}
