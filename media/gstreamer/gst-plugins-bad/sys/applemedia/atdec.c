/* GStreamer
 * Copyright (C) 2013 Alessandro Decina <alessandro.d@gmail.com>
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
 * Free Software Foundation, Inc., 51 Franklin Street, Suite 500,
 * Boston, MA 02110-1335, USA.
 */
/**
 * SECTION:element-gstatdec
 *
 * AudioToolbox based decoder.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch -v filesrc location=file.mov ! qtdemux ! queue ! aacparse ! atdec ! autoaudiosink
 * ]|
 * Decode aac audio from a mov file
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/gst.h>
#include <gst/audio/gstaudiodecoder.h>
#include "atdec.h"

GST_DEBUG_CATEGORY_STATIC (gst_atdec_debug_category);
#define GST_CAT_DEFAULT gst_atdec_debug_category

static void gst_atdec_set_property (GObject * object,
    guint property_id, const GValue * value, GParamSpec * pspec);
static void gst_atdec_get_property (GObject * object,
    guint property_id, GValue * value, GParamSpec * pspec);
static void gst_atdec_finalize (GObject * object);

static gboolean gst_atdec_start (GstAudioDecoder * decoder);
static gboolean gst_atdec_stop (GstAudioDecoder * decoder);
static gboolean gst_atdec_set_format (GstAudioDecoder * decoder,
    GstCaps * caps);
static GstFlowReturn gst_atdec_handle_frame (GstAudioDecoder * decoder,
    GstBuffer * buffer);
static void gst_atdec_flush (GstAudioDecoder * decoder, gboolean hard);
static void gst_atdec_buffer_emptied (void *user_data,
    AudioQueueRef queue, AudioQueueBufferRef buffer);

enum
{
  PROP_0
};

static GstStaticPadTemplate gst_atdec_src_template =
    GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (GST_AUDIO_CAPS_MAKE ("S16LE") ", layout=interleaved;"
        GST_AUDIO_CAPS_MAKE ("F32LE") ", layout=interleaved")
    );

static GstStaticPadTemplate gst_atdec_sink_template =
    GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS ("audio/mpeg, mpegversion=4, framed=true, channels=[1,max];"
        "audio/mpeg, mpegversion=1, layer=[1, 3]")
    );

G_DEFINE_TYPE_WITH_CODE (GstATDec, gst_atdec, GST_TYPE_AUDIO_DECODER,
    GST_DEBUG_CATEGORY_INIT (gst_atdec_debug_category, "atdec", 0,
        "debug category for atdec element"));

static GstStaticCaps aac_caps = GST_STATIC_CAPS ("audio/mpeg, mpegversion=4");
static GstStaticCaps mp3_caps =
GST_STATIC_CAPS ("audio/mpeg, mpegversion=1, layer=[1, 3]");
static GstStaticCaps raw_caps = GST_STATIC_CAPS ("audio/x-raw");

static void
gst_atdec_class_init (GstATDecClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstAudioDecoderClass *audio_decoder_class = GST_AUDIO_DECODER_CLASS (klass);

  gst_element_class_add_pad_template (GST_ELEMENT_CLASS (klass),
      gst_static_pad_template_get (&gst_atdec_src_template));
  gst_element_class_add_pad_template (GST_ELEMENT_CLASS (klass),
      gst_static_pad_template_get (&gst_atdec_sink_template));

  gst_element_class_set_static_metadata (GST_ELEMENT_CLASS (klass),
      "AudioToolbox based audio decoder",
      "Codec/Decoder/Audio",
      "AudioToolbox based audio decoder",
      "Alessandro Decina <alessandro.d@gmail.com>");

  gobject_class->set_property = gst_atdec_set_property;
  gobject_class->get_property = gst_atdec_get_property;
  gobject_class->finalize = gst_atdec_finalize;
  audio_decoder_class->start = GST_DEBUG_FUNCPTR (gst_atdec_start);
  audio_decoder_class->stop = GST_DEBUG_FUNCPTR (gst_atdec_stop);
  audio_decoder_class->set_format = GST_DEBUG_FUNCPTR (gst_atdec_set_format);
  audio_decoder_class->handle_frame =
      GST_DEBUG_FUNCPTR (gst_atdec_handle_frame);
  audio_decoder_class->flush = GST_DEBUG_FUNCPTR (gst_atdec_flush);
}

static void
gst_atdec_init (GstATDec * atdec)
{
  gst_audio_decoder_set_needs_format (GST_AUDIO_DECODER (atdec), TRUE);
  atdec->queue = NULL;
}

void
gst_atdec_set_property (GObject * object, guint property_id,
    const GValue * value, GParamSpec * pspec)
{
  GstATDec *atdec = GST_ATDEC (object);

  GST_DEBUG_OBJECT (atdec, "set_property");

  switch (property_id) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
      break;
  }
}

void
gst_atdec_get_property (GObject * object, guint property_id,
    GValue * value, GParamSpec * pspec)
{
  GstATDec *atdec = GST_ATDEC (object);

  GST_DEBUG_OBJECT (atdec, "get_property");

  switch (property_id) {
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
      break;
  }
}

static void
gst_atdec_destroy_queue (GstATDec * atdec, gboolean drain)
{
  AudioQueueStop (atdec->queue, drain);
  AudioQueueDispose (atdec->queue, true);
  atdec->queue = NULL;
  atdec->output_position = 0;
  atdec->input_position = 0;
}

void
gst_atdec_finalize (GObject * object)
{
  GstATDec *atdec = GST_ATDEC (object);

  GST_DEBUG_OBJECT (atdec, "finalize");

  if (atdec->queue)
    gst_atdec_destroy_queue (atdec, FALSE);

  G_OBJECT_CLASS (gst_atdec_parent_class)->finalize (object);
}

static gboolean
gst_atdec_start (GstAudioDecoder * decoder)
{
  GstATDec *atdec = GST_ATDEC (decoder);

  GST_DEBUG_OBJECT (atdec, "start");
  atdec->output_position = 0;
  atdec->input_position = 0;

  return TRUE;
}

static gboolean
gst_atdec_stop (GstAudioDecoder * decoder)
{
  GstATDec *atdec = GST_ATDEC (decoder);

  gst_atdec_destroy_queue (atdec, FALSE);

  return TRUE;
}

static gboolean
can_intersect_static_caps (GstCaps * caps, GstStaticCaps * caps1)
{
  GstCaps *tmp;
  gboolean ret;

  tmp = gst_static_caps_get (caps1);
  ret = gst_caps_can_intersect (caps, tmp);
  gst_caps_unref (tmp);

  return ret;
}

static gboolean
gst_caps_to_at_format (GstCaps * caps, AudioStreamBasicDescription * format)
{
  int channels = 0;
  int rate = 0;
  GstStructure *structure;

  memset (format, 0, sizeof (AudioStreamBasicDescription));

  structure = gst_caps_get_structure (caps, 0);
  gst_structure_get_int (structure, "rate", &rate);
  gst_structure_get_int (structure, "channels", &channels);
  format->mSampleRate = rate;
  format->mChannelsPerFrame = channels;

  if (can_intersect_static_caps (caps, &aac_caps)) {
    format->mFormatID = kAudioFormatMPEG4AAC;
    format->mFramesPerPacket = 1024;
  } else if (can_intersect_static_caps (caps, &mp3_caps)) {
    gint layer, mpegaudioversion = 1;

    gst_structure_get_int (structure, "layer", &layer);
    gst_structure_get_int (structure, "mpegaudioversion", &mpegaudioversion);
    switch (layer) {
      case 1:
        format->mFormatID = kAudioFormatMPEGLayer1;
        format->mFramesPerPacket = 384;
        break;
      case 2:
        format->mFormatID = kAudioFormatMPEGLayer2;
        format->mFramesPerPacket = 1152;
        break;
      case 3:
        format->mFormatID = kAudioFormatMPEGLayer3;
        format->mFramesPerPacket = (mpegaudioversion == 1 ? 1152 : 576);
        break;
      default:
        g_warn_if_reached ();
        format->mFormatID = kAudioFormatMPEGLayer3;
        format->mFramesPerPacket = 1152;
        break;
    }
  } else if (can_intersect_static_caps (caps, &raw_caps)) {
    GstAudioFormat audio_format;
    const char *audio_format_str;

    format->mFormatID = kAudioFormatLinearPCM;
    format->mFramesPerPacket = 1;

    audio_format_str = gst_structure_get_string (structure, "format");
    if (!audio_format_str)
      audio_format_str = "S16LE";

    audio_format = gst_audio_format_from_string (audio_format_str);
    switch (audio_format) {
      case GST_AUDIO_FORMAT_S16LE:
        format->mFormatFlags =
            kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger;
        format->mBitsPerChannel = 16;
        format->mBytesPerPacket = format->mBytesPerFrame = 2 * channels;
        break;
      case GST_AUDIO_FORMAT_F32LE:
        format->mFormatFlags =
            kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsFloat;
        format->mBitsPerChannel = 32;
        format->mBytesPerPacket = format->mBytesPerFrame = 4 * channels;
        break;
      default:
        g_warn_if_reached ();
        break;
    }
  }

  return TRUE;
}

static gboolean
gst_atdec_set_format (GstAudioDecoder * decoder, GstCaps * caps)
{
  OSStatus status;
  AudioStreamBasicDescription input_format = { 0 };
  AudioStreamBasicDescription output_format = { 0 };
  GstAudioInfo output_info = { 0 };
  AudioChannelLayout output_layout = { 0 };
  GstCaps *output_caps;
  AudioTimeStamp timestamp = { 0 };
  AudioQueueBufferRef output_buffer;
  GstATDec *atdec = GST_ATDEC (decoder);

  GST_DEBUG_OBJECT (atdec, "set_format");

  if (atdec->queue)
    gst_atdec_destroy_queue (atdec, TRUE);

  /* configure input_format from caps */
  gst_caps_to_at_format (caps, &input_format);
  /* Remember the number of samples per frame */
  atdec->spf = input_format.mFramesPerPacket;

  /* negotiate output caps */
  output_caps = gst_pad_get_allowed_caps (GST_AUDIO_DECODER_SRC_PAD (atdec));
  if (!output_caps)
    output_caps =
        gst_pad_get_pad_template_caps (GST_AUDIO_DECODER_SRC_PAD (atdec));
  output_caps = gst_caps_fixate (output_caps);

  gst_caps_set_simple (output_caps,
      "rate", G_TYPE_INT, (int) input_format.mSampleRate,
      "channels", G_TYPE_INT, input_format.mChannelsPerFrame, NULL);

  /* configure output_format from caps */
  gst_caps_to_at_format (output_caps, &output_format);

  /* set the format we want to negotiate downstream */
  gst_audio_info_from_caps (&output_info, output_caps);
  gst_audio_info_set_format (&output_info,
      output_format.mFormatFlags & kLinearPCMFormatFlagIsSignedInteger ?
      GST_AUDIO_FORMAT_S16LE : GST_AUDIO_FORMAT_F32LE,
      output_format.mSampleRate, output_format.mChannelsPerFrame, NULL);
  gst_audio_decoder_set_output_format (decoder, &output_info);
  gst_caps_unref (output_caps);

  status = AudioQueueNewOutput (&input_format, gst_atdec_buffer_emptied,
      atdec, NULL, NULL, 0, &atdec->queue);
  if (status)
    goto create_queue_error;

  /* FIXME: figure out how to map this properly */
  if (output_format.mChannelsPerFrame == 1)
    output_layout.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
  else
    output_layout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;

  status = AudioQueueSetOfflineRenderFormat (atdec->queue,
      &output_format, &output_layout);
  if (status)
    goto set_format_error;

  status = AudioQueueStart (atdec->queue, NULL);
  if (status)
    goto start_error;

  timestamp.mFlags = kAudioTimeStampSampleTimeValid;
  timestamp.mSampleTime = 0;

  status =
      AudioQueueAllocateBuffer (atdec->queue, atdec->spf * output_info.bpf,
      &output_buffer);
  if (status)
    goto allocate_output_error;

  status = AudioQueueOfflineRender (atdec->queue, &timestamp, output_buffer, 0);
  if (status)
    goto offline_render_error;

  AudioQueueFreeBuffer (atdec->queue, output_buffer);

  return TRUE;

create_queue_error:
  GST_ELEMENT_ERROR (atdec, STREAM, FORMAT, (NULL),
      ("AudioQueueNewOutput returned error: %d", (gint) status));
  return FALSE;

set_format_error:
  GST_ELEMENT_ERROR (atdec, STREAM, FORMAT, (NULL),
      ("AudioQueueSetOfflineRenderFormat returned error: %d", (gint) status));
  gst_atdec_destroy_queue (atdec, FALSE);
  return FALSE;

start_error:
  GST_ELEMENT_ERROR (atdec, STREAM, FORMAT, (NULL),
      ("AudioQueueStart returned error: %d", (gint) status));
  gst_atdec_destroy_queue (atdec, FALSE);
  return FALSE;

allocate_output_error:
  GST_ELEMENT_ERROR (atdec, STREAM, FORMAT, (NULL),
      ("AudioQueueAllocateBuffer returned error: %d", (gint) status));
  gst_atdec_destroy_queue (atdec, FALSE);
  return FALSE;

offline_render_error:
  GST_ELEMENT_ERROR (atdec, STREAM, FORMAT, (NULL),
      ("AudioQueueOfflineRender returned error: %d", (gint) status));
  AudioQueueFreeBuffer (atdec->queue, output_buffer);
  gst_atdec_destroy_queue (atdec, FALSE);
  return FALSE;
}

static void
gst_atdec_buffer_emptied (void *user_data, AudioQueueRef queue,
    AudioQueueBufferRef buffer)
{
  AudioQueueFreeBuffer (queue, buffer);
}

static GstFlowReturn
gst_atdec_offline_render (GstATDec * atdec, GstAudioInfo * audio_info)
{
  OSStatus status;
  AudioTimeStamp timestamp = { 0 };
  AudioQueueBufferRef output_buffer;
  GstFlowReturn flow_ret = GST_FLOW_OK;
  GstBuffer *out;
  guint out_frames;

  /* figure out how many frames we need to pull out of the queue */
  out_frames = atdec->input_position - atdec->output_position;
  if (out_frames > atdec->spf)
    out_frames = atdec->spf;
  status = AudioQueueAllocateBuffer (atdec->queue, out_frames * audio_info->bpf,
      &output_buffer);
  if (status)
    goto allocate_output_failed;

  /* pull the frames */
  timestamp.mFlags = kAudioTimeStampSampleTimeValid;
  timestamp.mSampleTime = atdec->output_position;
  status =
      AudioQueueOfflineRender (atdec->queue, &timestamp, output_buffer,
      out_frames);
  if (status)
    goto offline_render_failed;

  if (output_buffer->mAudioDataByteSize) {
    if (output_buffer->mAudioDataByteSize % audio_info->bpf != 0)
      goto invalid_buffer_size;

    GST_DEBUG_OBJECT (atdec,
        "Got output buffer of size %u at position %" G_GUINT64_FORMAT,
        output_buffer->mAudioDataByteSize, atdec->output_position);
    atdec->output_position +=
        output_buffer->mAudioDataByteSize / audio_info->bpf;

    out =
        gst_audio_decoder_allocate_output_buffer (GST_AUDIO_DECODER (atdec),
        output_buffer->mAudioDataByteSize);

    gst_buffer_fill (out, 0, output_buffer->mAudioData,
        output_buffer->mAudioDataByteSize);

    flow_ret =
        gst_audio_decoder_finish_frame (GST_AUDIO_DECODER (atdec), out, 1);
    GST_DEBUG_OBJECT (atdec, "Finished buffer: %s",
        gst_flow_get_name (flow_ret));
  } else {
    GST_DEBUG_OBJECT (atdec, "Got empty output buffer");
    flow_ret = GST_FLOW_CUSTOM_SUCCESS;
  }

  AudioQueueFreeBuffer (atdec->queue, output_buffer);

  return flow_ret;

allocate_output_failed:
  {
    GST_ELEMENT_ERROR (atdec, STREAM, DECODE, (NULL),
        ("AudioQueueAllocateBuffer returned error: %d", (gint) status));
    return GST_FLOW_ERROR;
  }

offline_render_failed:
  {
    AudioQueueFreeBuffer (atdec->queue, output_buffer);

    GST_AUDIO_DECODER_ERROR (atdec, 1, STREAM, DECODE, (NULL),
        ("AudioQueueOfflineRender returned error: %d", (gint) status),
        flow_ret);

    return flow_ret;
  }

invalid_buffer_size:
  {
    GST_AUDIO_DECODER_ERROR (atdec, 1, STREAM, DECODE, (NULL),
        ("AudioQueueOfflineRender returned invalid buffer size: %u (bpf %d)",
            output_buffer->mAudioDataByteSize, audio_info->bpf), flow_ret);

    AudioQueueFreeBuffer (atdec->queue, output_buffer);

    return flow_ret;
  }
}

static GstFlowReturn
gst_atdec_handle_frame (GstAudioDecoder * decoder, GstBuffer * buffer)
{
  OSStatus status;
  AudioStreamPacketDescription packet;
  AudioQueueBufferRef input_buffer;
  GstAudioInfo *audio_info;
  int size;
  GstFlowReturn flow_ret = GST_FLOW_OK;
  GstATDec *atdec = GST_ATDEC (decoder);

  audio_info = gst_audio_decoder_get_audio_info (decoder);

  if (buffer == NULL) {
    GST_DEBUG_OBJECT (atdec, "Draining");
    AudioQueueFlush (atdec->queue);

    while (atdec->input_position > atdec->output_position
        && flow_ret == GST_FLOW_OK) {
      flow_ret = gst_atdec_offline_render (atdec, audio_info);
    }

    if (flow_ret == GST_FLOW_CUSTOM_SUCCESS)
      flow_ret = GST_FLOW_OK;

    return flow_ret;
  }

  /* copy the input buffer into an AudioQueueBuffer */
  size = gst_buffer_get_size (buffer);
  GST_DEBUG_OBJECT (atdec,
      "Handling buffer of size %u at timestamp %" GST_TIME_FORMAT, (guint) size,
      GST_TIME_ARGS (GST_BUFFER_TIMESTAMP (buffer)));
  status = AudioQueueAllocateBuffer (atdec->queue, size, &input_buffer);
  if (status)
    goto allocate_input_failed;
  gst_buffer_extract (buffer, 0, input_buffer->mAudioData, size);
  input_buffer->mAudioDataByteSize = size;

  /* assume framed input */
  packet.mStartOffset = 0;
  packet.mVariableFramesInPacket = 1;
  packet.mDataByteSize = size;

  /* enqueue the buffer. It will get free'd once the gst_atdec_buffer_emptied
   * callback is called
   */
  status = AudioQueueEnqueueBuffer (atdec->queue, input_buffer, 1, &packet);
  if (status)
    goto enqueue_buffer_failed;

  atdec->input_position += atdec->spf;

  flow_ret = gst_atdec_offline_render (atdec, audio_info);
  if (flow_ret == GST_FLOW_CUSTOM_SUCCESS)
    flow_ret = GST_FLOW_OK;

  return flow_ret;

allocate_input_failed:
  {
    GST_ELEMENT_ERROR (atdec, STREAM, DECODE, (NULL),
        ("AudioQueueAllocateBuffer returned error: %d", (gint) status));
    return GST_FLOW_ERROR;
  }

enqueue_buffer_failed:
  {
    GST_AUDIO_DECODER_ERROR (atdec, 1, STREAM, DECODE, (NULL),
        ("AudioQueueEnqueueBuffer returned error: %d", (gint) status),
        flow_ret);
    return flow_ret;
  }
}

static void
gst_atdec_flush (GstAudioDecoder * decoder, gboolean hard)
{
  GstATDec *atdec = GST_ATDEC (decoder);

  GST_DEBUG_OBJECT (atdec, "Flushing");
  AudioQueueReset (atdec->queue);
  atdec->output_position = 0;
  atdec->input_position = 0;
}
