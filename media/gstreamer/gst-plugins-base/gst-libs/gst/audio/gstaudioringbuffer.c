/* GStreamer
 * Copyright (C) 2005 Wim Taymans <wim@fluendo.com>
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
 * SECTION:gstaudioringbuffer
 * @short_description: Base class for audio ringbuffer implementations
 * @see_also: #GstAudioBaseSink, #GstAudioSink
 *
 * <refsect2>
 * <para>
 * This object is the base class for audio ringbuffers used by the base
 * audio source and sink classes.
 * </para>
 * <para>
 * The ringbuffer abstracts a circular buffer of data. One reader and
 * one writer can operate on the data from different threads in a lockfree
 * manner. The base class is sufficiently flexible to be used as an
 * abstraction for DMA based ringbuffers as well as a pure software
 * implementations.
 * </para>
 * </refsect2>
 */

#include <string.h>

#include <gst/audio/audio.h>
#include "gstaudioringbuffer.h"

GST_DEBUG_CATEGORY_STATIC (gst_audio_ring_buffer_debug);
#define GST_CAT_DEFAULT gst_audio_ring_buffer_debug

static void gst_audio_ring_buffer_dispose (GObject * object);
static void gst_audio_ring_buffer_finalize (GObject * object);

static gboolean gst_audio_ring_buffer_pause_unlocked (GstAudioRingBuffer * buf);
static void default_clear_all (GstAudioRingBuffer * buf);
static guint default_commit (GstAudioRingBuffer * buf, guint64 * sample,
    guint8 * data, gint in_samples, gint out_samples, gint * accum);

/* ringbuffer abstract base class */
G_DEFINE_ABSTRACT_TYPE (GstAudioRingBuffer, gst_audio_ring_buffer,
    GST_TYPE_OBJECT);

static void
gst_audio_ring_buffer_class_init (GstAudioRingBufferClass * klass)
{
  GObjectClass *gobject_class;
  GstAudioRingBufferClass *gstaudioringbuffer_class;

  gobject_class = (GObjectClass *) klass;
  gstaudioringbuffer_class = (GstAudioRingBufferClass *) klass;

  GST_DEBUG_CATEGORY_INIT (gst_audio_ring_buffer_debug, "ringbuffer", 0,
      "ringbuffer class");

  gobject_class->dispose = gst_audio_ring_buffer_dispose;
  gobject_class->finalize = gst_audio_ring_buffer_finalize;

  gstaudioringbuffer_class->clear_all = GST_DEBUG_FUNCPTR (default_clear_all);
  gstaudioringbuffer_class->commit = GST_DEBUG_FUNCPTR (default_commit);
}

static void
gst_audio_ring_buffer_init (GstAudioRingBuffer * ringbuffer)
{
  ringbuffer->open = FALSE;
  ringbuffer->acquired = FALSE;
  ringbuffer->state = GST_AUDIO_RING_BUFFER_STATE_STOPPED;
  g_cond_init (&ringbuffer->cond);
  ringbuffer->waiting = 0;
  ringbuffer->empty_seg = NULL;
  ringbuffer->flushing = TRUE;
  ringbuffer->segbase = 0;
  ringbuffer->segdone = 0;
}

static void
gst_audio_ring_buffer_dispose (GObject * object)
{
  GstAudioRingBuffer *ringbuffer = GST_AUDIO_RING_BUFFER (object);

  gst_caps_replace (&ringbuffer->spec.caps, NULL);

  G_OBJECT_CLASS (gst_audio_ring_buffer_parent_class)->dispose (G_OBJECT
      (ringbuffer));
}

static void
gst_audio_ring_buffer_finalize (GObject * object)
{
  GstAudioRingBuffer *ringbuffer = GST_AUDIO_RING_BUFFER (object);

  g_cond_clear (&ringbuffer->cond);
  g_free (ringbuffer->empty_seg);

  G_OBJECT_CLASS (gst_audio_ring_buffer_parent_class)->finalize (G_OBJECT
      (ringbuffer));
}

#ifndef GST_DISABLE_GST_DEBUG
static const gchar *format_type_names[] = {
  "raw",
  "mu law",
  "a law",
  "ima adpcm",
  "mpeg",
  "gsm",
  "iec958",
  "ac3",
  "eac3",
  "dts",
  "aac mpeg2",
  "aac mpeg4"
};
#endif

/**
 * gst_audio_ring_buffer_debug_spec_caps:
 * @spec: the spec to debug
 *
 * Print debug info about the parsed caps in @spec to the debug log.
 */
void
gst_audio_ring_buffer_debug_spec_caps (GstAudioRingBufferSpec * spec)
{
#if 0
  gint i, bytes;
#endif

  GST_DEBUG ("spec caps: %p %" GST_PTR_FORMAT, spec->caps, spec->caps);
  GST_DEBUG ("parsed caps: type:         %d, '%s'", spec->type,
      format_type_names[spec->type]);
#if 0
  GST_DEBUG ("parsed caps: width:        %d", spec->width);
  GST_DEBUG ("parsed caps: sign:         %d", spec->sign);
  GST_DEBUG ("parsed caps: bigend:       %d", spec->bigend);
  GST_DEBUG ("parsed caps: rate:         %d", spec->rate);
  GST_DEBUG ("parsed caps: channels:     %d", spec->channels);
  GST_DEBUG ("parsed caps: sample bytes: %d", spec->bytes_per_sample);
  bytes = (spec->width >> 3) * spec->channels;
  for (i = 0; i < bytes; i++) {
    GST_DEBUG ("silence byte %d: %02x", i, spec->silence_sample[i]);
  }
#endif
}

/**
 * gst_audio_ring_buffer_debug_spec_buff:
 * @spec: the spec to debug
 *
 * Print debug info about the buffer sized in @spec to the debug log.
 */
void
gst_audio_ring_buffer_debug_spec_buff (GstAudioRingBufferSpec * spec)
{
  gint bpf = GST_AUDIO_INFO_BPF (&spec->info);

  GST_DEBUG ("acquire ringbuffer: buffer time: %" G_GINT64_FORMAT " usec",
      spec->buffer_time);
  GST_DEBUG ("acquire ringbuffer: latency time: %" G_GINT64_FORMAT " usec",
      spec->latency_time);
  GST_DEBUG ("acquire ringbuffer: total segments: %d", spec->segtotal);
  GST_DEBUG ("acquire ringbuffer: latency segments: %d", spec->seglatency);
  GST_DEBUG ("acquire ringbuffer: segment size: %d bytes = %d samples",
      spec->segsize, (bpf != 0) ? (spec->segsize / bpf) : -1);
  GST_DEBUG ("acquire ringbuffer: buffer size: %d bytes = %d samples",
      spec->segsize * spec->segtotal,
      (bpf != 0) ? (spec->segsize * spec->segtotal / bpf) : -1);
}

/**
 * gst_audio_ring_buffer_parse_caps:
 * @spec: a spec
 * @caps: a #GstCaps
 *
 * Parse @caps into @spec.
 *
 * Returns: TRUE if the caps could be parsed.
 */
gboolean
gst_audio_ring_buffer_parse_caps (GstAudioRingBufferSpec * spec, GstCaps * caps)
{
  const gchar *mimetype;
  GstStructure *structure;
  gint i;
  GstAudioInfo info;

  structure = gst_caps_get_structure (caps, 0);
  gst_audio_info_init (&info);

  /* we have to differentiate between int and float formats */
  mimetype = gst_structure_get_name (structure);

  if (g_str_equal (mimetype, "audio/x-raw")) {
    if (!gst_audio_info_from_caps (&info, caps))
      goto parse_error;

    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_RAW;
  } else if (g_str_equal (mimetype, "audio/x-alaw")) {
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate) &&
            gst_structure_get_int (structure, "channels", &info.channels)))
      goto parse_error;

    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_A_LAW;
    info.bpf = info.channels;
  } else if (g_str_equal (mimetype, "audio/x-mulaw")) {
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate) &&
            gst_structure_get_int (structure, "channels", &info.channels)))
      goto parse_error;

    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MU_LAW;
    info.bpf = info.channels;
  } else if (g_str_equal (mimetype, "audio/x-iec958")) {
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate)))
      goto parse_error;

    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_IEC958;
    info.bpf = 4;
  } else if (g_str_equal (mimetype, "audio/x-ac3")) {
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate)))
      goto parse_error;

    gst_structure_get_int (structure, "channels", &info.channels);
    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_AC3;
    info.bpf = 4;
  } else if (g_str_equal (mimetype, "audio/x-eac3")) {
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate)))
      goto parse_error;

    gst_structure_get_int (structure, "channels", &info.channels);
    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_EAC3;
    info.bpf = 16;
  } else if (g_str_equal (mimetype, "audio/x-dts")) {
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate)))
      goto parse_error;

    gst_structure_get_int (structure, "channels", &info.channels);
    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_DTS;
    info.bpf = 4;
  } else if (g_str_equal (mimetype, "audio/mpeg") &&
      gst_structure_get_int (structure, "mpegaudioversion", &i) &&
      (i == 1 || i == 2)) {
    /* Now we know this is MPEG-1 or MPEG-2 (non AAC) */
    /* extract the needed information from the cap */
    if (!(gst_structure_get_int (structure, "rate", &info.rate)))
      goto parse_error;

    gst_structure_get_int (structure, "channels", &info.channels);
    spec->type = GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG;
    info.bpf = 4;
  } else if (g_str_equal (mimetype, "audio/mpeg") &&
      gst_structure_get_int (structure, "mpegversion", &i) &&
      (i == 2 || i == 4) &&
      !g_strcmp0 (gst_structure_get_string (structure, "stream-format"),
          "adts")) {
    /* MPEG-2 AAC or MPEG-4 AAC */
    if (!(gst_structure_get_int (structure, "rate", &info.rate)))
      goto parse_error;

    gst_structure_get_int (structure, "channels", &info.channels);
    spec->type = (i == 2) ? GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG2_AAC :
        GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG4_AAC;
    info.bpf = 4;
  } else {
    goto parse_error;
  }

  gst_caps_replace (&spec->caps, caps);

  g_return_val_if_fail (spec->latency_time != 0, FALSE);

  /* calculate suggested segsize and segtotal. segsize should be one unit
   * of 'latency_time' samples, scaling for the fact that latency_time is
   * currently stored in microseconds (FIXME: in 0.11) */
  spec->segsize = gst_util_uint64_scale (info.rate * info.bpf,
      spec->latency_time, GST_SECOND / GST_USECOND);
  /* Round to an integer number of samples */
  spec->segsize -= spec->segsize % info.bpf;

  spec->segtotal = spec->buffer_time / spec->latency_time;
  /* leave the latency undefined now, implementations can change it but if it's
   * not changed, we assume the same value as segtotal */
  spec->seglatency = -1;

  spec->info = info;

  gst_audio_ring_buffer_debug_spec_caps (spec);
  gst_audio_ring_buffer_debug_spec_buff (spec);

  return TRUE;

  /* ERRORS */
parse_error:
  {
    GST_DEBUG ("could not parse caps");
    return FALSE;
  }
}

/**
 * gst_audio_ring_buffer_convert:
 * @buf: the #GstAudioRingBuffer
 * @src_fmt: the source format
 * @src_val: the source value
 * @dest_fmt: the destination format
 * @dest_val: a location to store the converted value
 *
 * Convert @src_val in @src_fmt to the equivalent value in @dest_fmt. The result
 * will be put in @dest_val.
 *
 * Returns: TRUE if the conversion succeeded.
 */
gboolean
gst_audio_ring_buffer_convert (GstAudioRingBuffer * buf,
    GstFormat src_fmt, gint64 src_val, GstFormat dest_fmt, gint64 * dest_val)
{
  gboolean res;

  GST_OBJECT_LOCK (buf);
  res =
      gst_audio_info_convert (&buf->spec.info, src_fmt, src_val, dest_fmt,
      dest_val);
  GST_OBJECT_UNLOCK (buf);

  return res;
}

/**
 * gst_audio_ring_buffer_set_callback:
 * @buf: the #GstAudioRingBuffer to set the callback on
 * @cb: (scope async): the callback to set
 * @user_data: user data passed to the callback
 *
 * Sets the given callback function on the buffer. This function
 * will be called every time a segment has been written to a device.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_set_callback (GstAudioRingBuffer * buf,
    GstAudioRingBufferCallback cb, gpointer user_data)
{
  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  GST_OBJECT_LOCK (buf);
  buf->callback = cb;
  buf->cb_data = user_data;
  GST_OBJECT_UNLOCK (buf);
}


/**
 * gst_audio_ring_buffer_open_device:
 * @buf: the #GstAudioRingBuffer
 *
 * Open the audio device associated with the ring buffer. Does not perform any
 * setup on the device. You must open the device before acquiring the ring
 * buffer.
 *
 * Returns: TRUE if the device could be opened, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_open_device (GstAudioRingBuffer * buf)
{
  gboolean res = TRUE;
  GstAudioRingBufferClass *rclass;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "opening device");

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (buf->open))
    goto was_opened;

  buf->open = TRUE;

  /* if this fails, something is wrong in this file */
  g_assert (!buf->acquired);

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->open_device))
    res = rclass->open_device (buf);

  if (G_UNLIKELY (!res))
    goto open_failed;

  GST_DEBUG_OBJECT (buf, "opened device");

done:
  GST_OBJECT_UNLOCK (buf);

  return res;

  /* ERRORS */
was_opened:
  {
    GST_DEBUG_OBJECT (buf, "Device for ring buffer already open");
    g_warning ("Device for ring buffer %p already open, fix your code", buf);
    res = TRUE;
    goto done;
  }
open_failed:
  {
    buf->open = FALSE;
    GST_DEBUG_OBJECT (buf, "failed opening device");
    goto done;
  }
}

/**
 * gst_audio_ring_buffer_close_device:
 * @buf: the #GstAudioRingBuffer
 *
 * Close the audio device associated with the ring buffer. The ring buffer
 * should already have been released via gst_audio_ring_buffer_release().
 *
 * Returns: TRUE if the device could be closed, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_close_device (GstAudioRingBuffer * buf)
{
  gboolean res = TRUE;
  GstAudioRingBufferClass *rclass;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "closing device");

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (!buf->open))
    goto was_closed;

  if (G_UNLIKELY (buf->acquired))
    goto was_acquired;

  buf->open = FALSE;

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->close_device))
    res = rclass->close_device (buf);

  if (G_UNLIKELY (!res))
    goto close_error;

  GST_DEBUG_OBJECT (buf, "closed device");

done:
  GST_OBJECT_UNLOCK (buf);

  return res;

  /* ERRORS */
was_closed:
  {
    GST_DEBUG_OBJECT (buf, "Device for ring buffer already closed");
    g_warning ("Device for ring buffer %p already closed, fix your code", buf);
    res = TRUE;
    goto done;
  }
was_acquired:
  {
    GST_DEBUG_OBJECT (buf, "Resources for ring buffer still acquired");
    g_critical ("Resources for ring buffer %p still acquired", buf);
    res = FALSE;
    goto done;
  }
close_error:
  {
    buf->open = TRUE;
    GST_DEBUG_OBJECT (buf, "error closing device");
    goto done;
  }
}

/**
 * gst_audio_ring_buffer_device_is_open:
 * @buf: the #GstAudioRingBuffer
 *
 * Checks the status of the device associated with the ring buffer.
 *
 * Returns: TRUE if the device was open, FALSE if it was closed.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_device_is_open (GstAudioRingBuffer * buf)
{
  gboolean res = TRUE;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_OBJECT_LOCK (buf);
  res = buf->open;
  GST_OBJECT_UNLOCK (buf);

  return res;
}

/**
 * gst_audio_ring_buffer_acquire:
 * @buf: the #GstAudioRingBuffer to acquire
 * @spec: the specs of the buffer
 *
 * Allocate the resources for the ringbuffer. This function fills
 * in the data pointer of the ring buffer with a valid #GstBuffer
 * to which samples can be written.
 *
 * Returns: TRUE if the device could be acquired, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_acquire (GstAudioRingBuffer * buf,
    GstAudioRingBufferSpec * spec)
{
  gboolean res = FALSE;
  GstAudioRingBufferClass *rclass;
  gint segsize, bpf, i;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "acquiring device %p", buf);

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (!buf->open))
    goto not_opened;

  if (G_UNLIKELY (buf->acquired))
    goto was_acquired;

  buf->acquired = TRUE;
  buf->need_reorder = FALSE;

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->acquire))
    res = rclass->acquire (buf, spec);

  /* Only reorder for raw audio */
  buf->need_reorder = (buf->need_reorder
      && buf->spec.type == GST_AUDIO_RING_BUFFER_FORMAT_TYPE_RAW);

  if (G_UNLIKELY (!res))
    goto acquire_failed;

  GST_INFO_OBJECT (buf, "Allocating an array for %d timestamps",
      spec->segtotal);
  buf->timestamps = g_slice_alloc0 (sizeof (GstClockTime) * spec->segtotal);
  /* initialize array with invalid timestamps */
  for (i = 0; i < spec->segtotal; i++) {
    buf->timestamps[i] = GST_CLOCK_TIME_NONE;
  }

  if (G_UNLIKELY ((bpf = buf->spec.info.bpf) == 0))
    goto invalid_bpf;

  /* if the seglatency was overwritten with something else than -1, use it, else
   * assume segtotal as the latency */
  if (buf->spec.seglatency == -1)
    buf->spec.seglatency = buf->spec.segtotal;

  segsize = buf->spec.segsize;

  buf->samples_per_seg = segsize / bpf;

  /* create an empty segment */
  g_free (buf->empty_seg);
  buf->empty_seg = g_malloc (segsize);

  if (buf->spec.type == GST_AUDIO_RING_BUFFER_FORMAT_TYPE_RAW) {
    gst_audio_format_fill_silence (buf->spec.info.finfo, buf->empty_seg,
        segsize);
  } else {
    /* FIXME, non-raw formats get 0 as the empty sample */
    memset (buf->empty_seg, 0, segsize);
  }
  GST_DEBUG_OBJECT (buf, "acquired device");

done:
  GST_OBJECT_UNLOCK (buf);

  return res;

  /* ERRORS */
not_opened:
  {
    GST_DEBUG_OBJECT (buf, "device not opened");
    g_critical ("Device for %p not opened", buf);
    res = FALSE;
    goto done;
  }
was_acquired:
  {
    res = TRUE;
    GST_DEBUG_OBJECT (buf, "device was acquired");
    goto done;
  }
acquire_failed:
  {
    buf->acquired = FALSE;
    GST_DEBUG_OBJECT (buf, "failed to acquire device");
    goto done;
  }
invalid_bpf:
  {
    g_warning
        ("invalid bytes_per_frame from acquire ringbuffer %p, fix the element",
        buf);
    buf->acquired = FALSE;
    res = FALSE;
    goto done;
  }
}

/**
 * gst_audio_ring_buffer_release:
 * @buf: the #GstAudioRingBuffer to release
 *
 * Free the resources of the ringbuffer.
 *
 * Returns: TRUE if the device could be released, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_release (GstAudioRingBuffer * buf)
{
  gboolean res = FALSE;
  GstAudioRingBufferClass *rclass;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "releasing device");

  gst_audio_ring_buffer_stop (buf);

  GST_OBJECT_LOCK (buf);

  if (G_LIKELY (buf->timestamps)) {
    GST_INFO_OBJECT (buf, "Freeing timestamp buffer, %d entries",
        buf->spec.segtotal);
    g_slice_free1 (sizeof (GstClockTime) * buf->spec.segtotal, buf->timestamps);
    buf->timestamps = NULL;
  }

  if (G_UNLIKELY (!buf->acquired))
    goto was_released;

  buf->acquired = FALSE;

  /* if this fails, something is wrong in this file */
  g_assert (buf->open == TRUE);

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->release))
    res = rclass->release (buf);

  /* signal any waiters */
  GST_DEBUG_OBJECT (buf, "signal waiter");
  GST_AUDIO_RING_BUFFER_SIGNAL (buf);

  if (G_UNLIKELY (!res))
    goto release_failed;

  g_atomic_int_set (&buf->segdone, 0);
  buf->segbase = 0;
  g_free (buf->empty_seg);
  buf->empty_seg = NULL;
  gst_caps_replace (&buf->spec.caps, NULL);
  gst_audio_info_init (&buf->spec.info);
  GST_DEBUG_OBJECT (buf, "released device");

done:
  GST_OBJECT_UNLOCK (buf);

  return res;

  /* ERRORS */
was_released:
  {
    res = TRUE;
    GST_DEBUG_OBJECT (buf, "device was released");
    goto done;
  }
release_failed:
  {
    buf->acquired = TRUE;
    GST_DEBUG_OBJECT (buf, "failed to release device");
    goto done;
  }
}

/**
 * gst_audio_ring_buffer_is_acquired:
 * @buf: the #GstAudioRingBuffer to check
 *
 * Check if the ringbuffer is acquired and ready to use.
 *
 * Returns: TRUE if the ringbuffer is acquired, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_is_acquired (GstAudioRingBuffer * buf)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_OBJECT_LOCK (buf);
  res = buf->acquired;
  GST_OBJECT_UNLOCK (buf);

  return res;
}

/**
 * gst_audio_ring_buffer_activate:
 * @buf: the #GstAudioRingBuffer to activate
 * @active: the new mode
 *
 * Activate @buf to start or stop pulling data.
 *
 * MT safe.
 *
 * Returns: TRUE if the device could be activated in the requested mode,
 * FALSE on error.
 */
gboolean
gst_audio_ring_buffer_activate (GstAudioRingBuffer * buf, gboolean active)
{
  gboolean res = FALSE;
  GstAudioRingBufferClass *rclass;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "activate device");

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (active && !buf->acquired))
    goto not_acquired;

  if (G_UNLIKELY (buf->active == active))
    goto was_active;

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  /* if there is no activate function we assume it was started/released
   * in the acquire method */
  if (G_LIKELY (rclass->activate))
    res = rclass->activate (buf, active);
  else
    res = TRUE;

  if (G_UNLIKELY (!res))
    goto activate_failed;

  buf->active = active;

done:
  GST_OBJECT_UNLOCK (buf);

  return res;

  /* ERRORS */
not_acquired:
  {
    GST_DEBUG_OBJECT (buf, "device not acquired");
    g_critical ("Device for %p not acquired", buf);
    res = FALSE;
    goto done;
  }
was_active:
  {
    res = TRUE;
    GST_DEBUG_OBJECT (buf, "device was active in mode %d", active);
    goto done;
  }
activate_failed:
  {
    GST_DEBUG_OBJECT (buf, "failed to activate device");
    goto done;
  }
}

/**
 * gst_audio_ring_buffer_is_active:
 * @buf: the #GstAudioRingBuffer
 *
 * Check if @buf is activated.
 *
 * MT safe.
 *
 * Returns: TRUE if the device is active.
 */
gboolean
gst_audio_ring_buffer_is_active (GstAudioRingBuffer * buf)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_OBJECT_LOCK (buf);
  res = buf->active;
  GST_OBJECT_UNLOCK (buf);

  return res;
}


/**
 * gst_audio_ring_buffer_set_flushing:
 * @buf: the #GstAudioRingBuffer to flush
 * @flushing: the new mode
 *
 * Set the ringbuffer to flushing mode or normal mode.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_set_flushing (GstAudioRingBuffer * buf, gboolean flushing)
{
  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  GST_OBJECT_LOCK (buf);
  buf->flushing = flushing;

  if (flushing) {
    gst_audio_ring_buffer_pause_unlocked (buf);
  } else {
    gst_audio_ring_buffer_clear_all (buf);
  }
  GST_OBJECT_UNLOCK (buf);
}

/**
 * gst_audio_ring_buffer_is_flushing:
 * @buf: the #GstAudioRingBuffer
 *
 * Check if @buf is flushing.
 *
 * MT safe.
 *
 * Returns: TRUE if the device is flushing.
 */
gboolean
gst_audio_ring_buffer_is_flushing (GstAudioRingBuffer * buf)
{
  gboolean res;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), TRUE);

  GST_OBJECT_LOCK (buf);
  res = buf->flushing;
  GST_OBJECT_UNLOCK (buf);

  return res;
}

/**
 * gst_audio_ring_buffer_start:
 * @buf: the #GstAudioRingBuffer to start
 *
 * Start processing samples from the ringbuffer.
 *
 * Returns: TRUE if the device could be started, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_start (GstAudioRingBuffer * buf)
{
  gboolean res = FALSE;
  GstAudioRingBufferClass *rclass;
  gboolean resume = FALSE;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "starting ringbuffer");

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (buf->flushing))
    goto flushing;

  if (G_UNLIKELY (!buf->acquired))
    goto not_acquired;

  if (G_UNLIKELY (g_atomic_int_get (&buf->may_start) == FALSE))
    goto may_not_start;

  /* if stopped, set to started */
  res = g_atomic_int_compare_and_exchange (&buf->state,
      GST_AUDIO_RING_BUFFER_STATE_STOPPED, GST_AUDIO_RING_BUFFER_STATE_STARTED);

  if (!res) {
    GST_DEBUG_OBJECT (buf, "was not stopped, try paused");
    /* was not stopped, try from paused */
    res = g_atomic_int_compare_and_exchange (&buf->state,
        GST_AUDIO_RING_BUFFER_STATE_PAUSED,
        GST_AUDIO_RING_BUFFER_STATE_STARTED);
    if (!res) {
      /* was not paused either, must be started then */
      res = TRUE;
      GST_DEBUG_OBJECT (buf, "was not paused, must have been started");
      goto done;
    }
    resume = TRUE;
    GST_DEBUG_OBJECT (buf, "resuming");
  }

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (resume) {
    if (G_LIKELY (rclass->resume))
      res = rclass->resume (buf);
  } else {
    if (G_LIKELY (rclass->start))
      res = rclass->start (buf);
  }

  if (G_UNLIKELY (!res)) {
    buf->state = GST_AUDIO_RING_BUFFER_STATE_PAUSED;
    GST_DEBUG_OBJECT (buf, "failed to start");
  } else {
    GST_DEBUG_OBJECT (buf, "started");
  }

done:
  GST_OBJECT_UNLOCK (buf);

  return res;

flushing:
  {
    GST_DEBUG_OBJECT (buf, "we are flushing");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
not_acquired:
  {
    GST_DEBUG_OBJECT (buf, "we are not acquired");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
may_not_start:
  {
    GST_DEBUG_OBJECT (buf, "we may not start");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
}

static gboolean
gst_audio_ring_buffer_pause_unlocked (GstAudioRingBuffer * buf)
{
  gboolean res = FALSE;
  GstAudioRingBufferClass *rclass;

  GST_DEBUG_OBJECT (buf, "pausing ringbuffer");

  /* if started, set to paused */
  res = g_atomic_int_compare_and_exchange (&buf->state,
      GST_AUDIO_RING_BUFFER_STATE_STARTED, GST_AUDIO_RING_BUFFER_STATE_PAUSED);

  if (!res)
    goto not_started;

  /* signal any waiters */
  GST_DEBUG_OBJECT (buf, "signal waiter");
  GST_AUDIO_RING_BUFFER_SIGNAL (buf);

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->pause))
    res = rclass->pause (buf);

  if (G_UNLIKELY (!res)) {
    buf->state = GST_AUDIO_RING_BUFFER_STATE_STARTED;
    GST_DEBUG_OBJECT (buf, "failed to pause");
  } else {
    GST_DEBUG_OBJECT (buf, "paused");
  }

  return res;

not_started:
  {
    /* was not started */
    GST_DEBUG_OBJECT (buf, "was not started");
    return TRUE;
  }
}

/**
 * gst_audio_ring_buffer_pause:
 * @buf: the #GstAudioRingBuffer to pause
 *
 * Pause processing samples from the ringbuffer.
 *
 * Returns: TRUE if the device could be paused, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_pause (GstAudioRingBuffer * buf)
{
  gboolean res = FALSE;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (buf->flushing))
    goto flushing;

  if (G_UNLIKELY (!buf->acquired))
    goto not_acquired;

  res = gst_audio_ring_buffer_pause_unlocked (buf);
  GST_OBJECT_UNLOCK (buf);

  return res;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (buf, "we are flushing");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
not_acquired:
  {
    GST_DEBUG_OBJECT (buf, "not acquired");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
}

/**
 * gst_audio_ring_buffer_stop:
 * @buf: the #GstAudioRingBuffer to stop
 *
 * Stop processing samples from the ringbuffer.
 *
 * Returns: TRUE if the device could be stopped, FALSE on error.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_stop (GstAudioRingBuffer * buf)
{
  gboolean res = FALSE;
  GstAudioRingBufferClass *rclass;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  GST_DEBUG_OBJECT (buf, "stopping");

  GST_OBJECT_LOCK (buf);

  /* if started, set to stopped */
  res = g_atomic_int_compare_and_exchange (&buf->state,
      GST_AUDIO_RING_BUFFER_STATE_STARTED, GST_AUDIO_RING_BUFFER_STATE_STOPPED);

  if (!res) {
    GST_DEBUG_OBJECT (buf, "was not started, try paused");
    /* was not started, try from paused */
    res = g_atomic_int_compare_and_exchange (&buf->state,
        GST_AUDIO_RING_BUFFER_STATE_PAUSED,
        GST_AUDIO_RING_BUFFER_STATE_STOPPED);
    if (!res) {
      /* was not paused either, must have been stopped then */
      res = TRUE;
      GST_DEBUG_OBJECT (buf, "was not paused, must have been stopped");
      goto done;
    }
  }

  /* signal any waiters */
  GST_DEBUG_OBJECT (buf, "signal waiter");
  GST_AUDIO_RING_BUFFER_SIGNAL (buf);

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->stop))
    res = rclass->stop (buf);

  if (G_UNLIKELY (!res)) {
    buf->state = GST_AUDIO_RING_BUFFER_STATE_STARTED;
    GST_DEBUG_OBJECT (buf, "failed to stop");
  } else {
    GST_DEBUG_OBJECT (buf, "stopped");
  }
done:
  GST_OBJECT_UNLOCK (buf);

  return res;
}

/**
 * gst_audio_ring_buffer_delay:
 * @buf: the #GstAudioRingBuffer to query
 *
 * Get the number of samples queued in the audio device. This is
 * usually less than the segment size but can be bigger when the
 * implementation uses another internal buffer between the audio
 * device.
 *
 * For playback ringbuffers this is the amount of samples transfered from the
 * ringbuffer to the device but still not played.
 *
 * For capture ringbuffers this is the amount of samples in the device that are
 * not yet transfered to the ringbuffer.
 *
 * Returns: The number of samples queued in the audio device.
 *
 * MT safe.
 */
guint
gst_audio_ring_buffer_delay (GstAudioRingBuffer * buf)
{
  GstAudioRingBufferClass *rclass;
  guint res;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), 0);

  /* buffer must be acquired */
  if (G_UNLIKELY (!gst_audio_ring_buffer_is_acquired (buf)))
    goto not_acquired;

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);
  if (G_LIKELY (rclass->delay))
    res = rclass->delay (buf);
  else
    res = 0;

  return res;

not_acquired:
  {
    GST_DEBUG_OBJECT (buf, "not acquired");
    return 0;
  }
}

/**
 * gst_audio_ring_buffer_samples_done:
 * @buf: the #GstAudioRingBuffer to query
 *
 * Get the number of samples that were processed by the ringbuffer
 * since it was last started. This does not include the number of samples not
 * yet processed (see gst_audio_ring_buffer_delay()).
 *
 * Returns: The number of samples processed by the ringbuffer.
 *
 * MT safe.
 */
guint64
gst_audio_ring_buffer_samples_done (GstAudioRingBuffer * buf)
{
  gint segdone;
  guint64 samples;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), 0);

  /* get the amount of segments we processed */
  segdone = g_atomic_int_get (&buf->segdone);

  /* convert to samples */
  samples = ((guint64) segdone) * buf->samples_per_seg;

  return samples;
}

/**
 * gst_audio_ring_buffer_set_sample:
 * @buf: the #GstAudioRingBuffer to use
 * @sample: the sample number to set
 *
 * Make sure that the next sample written to the device is
 * accounted for as being the @sample sample written to the
 * device. This value will be used in reporting the current
 * sample position of the ringbuffer.
 *
 * This function will also clear the buffer with silence.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_set_sample (GstAudioRingBuffer * buf, guint64 sample)
{
  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  if (sample == -1)
    sample = 0;

  if (G_UNLIKELY (buf->samples_per_seg == 0))
    return;

  /* FIXME, we assume the ringbuffer can restart at a random
   * position, round down to the beginning and keep track of
   * offset when calculating the processed samples. */
  buf->segbase = buf->segdone - sample / buf->samples_per_seg;

  gst_audio_ring_buffer_clear_all (buf);

  GST_DEBUG_OBJECT (buf, "set sample to %" G_GUINT64_FORMAT ", segbase %d",
      sample, buf->segbase);
}

static void
default_clear_all (GstAudioRingBuffer * buf)
{
  gint i;

  /* not fatal, we just are not negotiated yet */
  if (G_UNLIKELY (buf->spec.segtotal <= 0))
    return;

  GST_DEBUG_OBJECT (buf, "clear all segments");

  for (i = 0; i < buf->spec.segtotal; i++) {
    gst_audio_ring_buffer_clear (buf, i);
  }
}

/**
 * gst_audio_ring_buffer_clear_all:
 * @buf: the #GstAudioRingBuffer to clear
 *
 * Fill the ringbuffer with silence.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_clear_all (GstAudioRingBuffer * buf)
{
  GstAudioRingBufferClass *rclass;

  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);

  if (G_LIKELY (rclass->clear_all))
    rclass->clear_all (buf);
}


static gboolean
wait_segment (GstAudioRingBuffer * buf)
{
  gint segments;
  gboolean wait = TRUE;

  /* buffer must be started now or we deadlock since nobody is reading */
  if (G_UNLIKELY (g_atomic_int_get (&buf->state) !=
          GST_AUDIO_RING_BUFFER_STATE_STARTED)) {
    /* see if we are allowed to start it */
    if (G_UNLIKELY (g_atomic_int_get (&buf->may_start) == FALSE))
      goto no_start;

    GST_DEBUG_OBJECT (buf, "start!");
    segments = g_atomic_int_get (&buf->segdone);
    gst_audio_ring_buffer_start (buf);

    /* After starting, the writer may have wrote segments already and then we
     * don't need to wait anymore */
    if (G_LIKELY (g_atomic_int_get (&buf->segdone) != segments))
      wait = FALSE;
  }

  /* take lock first, then update our waiting flag */
  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (buf->flushing))
    goto flushing;

  if (G_UNLIKELY (g_atomic_int_get (&buf->state) !=
          GST_AUDIO_RING_BUFFER_STATE_STARTED))
    goto not_started;

  if (G_LIKELY (wait)) {
    if (g_atomic_int_compare_and_exchange (&buf->waiting, 0, 1)) {
      GST_DEBUG_OBJECT (buf, "waiting..");
      GST_AUDIO_RING_BUFFER_WAIT (buf);

      if (G_UNLIKELY (buf->flushing))
        goto flushing;

      if (G_UNLIKELY (g_atomic_int_get (&buf->state) !=
              GST_AUDIO_RING_BUFFER_STATE_STARTED))
        goto not_started;
    }
  }
  GST_OBJECT_UNLOCK (buf);

  return TRUE;

  /* ERROR */
not_started:
  {
    g_atomic_int_compare_and_exchange (&buf->waiting, 1, 0);
    GST_DEBUG_OBJECT (buf, "stopped processing");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
flushing:
  {
    g_atomic_int_compare_and_exchange (&buf->waiting, 1, 0);
    GST_DEBUG_OBJECT (buf, "flushing");
    GST_OBJECT_UNLOCK (buf);
    return FALSE;
  }
no_start:
  {
    GST_DEBUG_OBJECT (buf, "not allowed to start");
    return FALSE;
  }
}



#define REORDER_SAMPLE(d, s, l)                 \
G_STMT_START {                                  \
  gint i;                                       \
  for (i = 0; i < channels; i++) {              \
    memcpy (d + reorder_map[i] * bps, s + i * bps, bps); \
  }                                             \
} G_STMT_END

#define REORDER_SAMPLES(d, s, len)              \
G_STMT_START {                                  \
  gint i, len_ = len / bpf;                     \
  guint8 *d_ = d, *s_ = s;                      \
  for (i = 0; i < len_; i++) {                  \
    REORDER_SAMPLE(d_, s_, bpf);                \
    d_ += bpf;                                  \
    s_ += bpf;                                  \
  }                                             \
} G_STMT_END

#define FWD_SAMPLES(s,se,d,de,F)         	\
G_STMT_START {					\
  /* no rate conversion */			\
  guint towrite = MIN (se + bpf - s, de - d);	\
  /* simple copy */				\
  if (!skip)					\
    F (d, s, towrite);			        \
  in_samples -= towrite / bpf;			\
  out_samples -= towrite / bpf;			\
  s += towrite;					\
  GST_DEBUG ("copy %u bytes", towrite);		\
} G_STMT_END

/* in_samples >= out_samples, rate > 1.0 */
#define FWD_UP_SAMPLES(s,se,d,de,F) 	 	\
G_STMT_START {					\
  guint8 *sb = s, *db = d;			\
  while (s <= se && d < de) {			\
    if (!skip)					\
      F (d, s, bpf);	       	        	\
    s += bpf;					\
    *accum += outr;				\
    if ((*accum << 1) >= inr) {			\
      *accum -= inr;				\
      d += bpf;					\
    }						\
  }						\
  in_samples -= (s - sb)/bpf;			\
  out_samples -= (d - db)/bpf;			\
  GST_DEBUG ("fwd_up end %d/%d",*accum,*toprocess);	\
} G_STMT_END

/* out_samples > in_samples, for rates smaller than 1.0 */
#define FWD_DOWN_SAMPLES(s,se,d,de,F) 	 	\
G_STMT_START {					\
  guint8 *sb = s, *db = d;			\
  while (s <= se && d < de) {			\
    if (!skip)					\
      F (d, s, bpf);	              		\
    d += bpf;					\
    *accum += inr;				\
    if ((*accum << 1) >= outr) {		\
      *accum -= outr;				\
      s += bpf;					\
    }						\
  }						\
  in_samples -= (s - sb)/bpf;			\
  out_samples -= (d - db)/bpf;			\
  GST_DEBUG ("fwd_down end %d/%d",*accum,*toprocess);	\
} G_STMT_END

#define REV_UP_SAMPLES(s,se,d,de,F) 	 	\
G_STMT_START {					\
  guint8 *sb = se, *db = d;			\
  while (s <= se && d < de) {			\
    if (!skip)					\
      F (d, se, bpf);                  		\
    se -= bpf;					\
    *accum += outr;				\
    while (d < de && (*accum << 1) >= inr) {	\
      *accum -= inr;				\
      d += bpf;					\
    }						\
  }						\
  in_samples -= (sb - se)/bpf;			\
  out_samples -= (d - db)/bpf;			\
  GST_DEBUG ("rev_up end %d/%d",*accum,*toprocess);	\
} G_STMT_END

#define REV_DOWN_SAMPLES(s,se,d,de,F) 	 	\
G_STMT_START {					\
  guint8 *sb = se, *db = d;			\
  while (s <= se && d < de) {			\
    if (!skip)					\
      F (d, se, bpf);        			\
    d += bpf;					\
    *accum += inr;				\
    while (s <= se && (*accum << 1) >= outr) {	\
      *accum -= outr;				\
      se -= bpf;				\
    }						\
  }						\
  in_samples -= (sb - se)/bpf;			\
  out_samples -= (d - db)/bpf;			\
  GST_DEBUG ("rev_down end %d/%d",*accum,*toprocess);	\
} G_STMT_END

static guint
default_commit (GstAudioRingBuffer * buf, guint64 * sample,
    guint8 * data, gint in_samples, gint out_samples, gint * accum)
{
  gint segdone;
  gint segsize, segtotal, channels, bps, bpf, sps;
  guint8 *dest, *data_end;
  gint writeseg, sampleoff;
  gint *toprocess;
  gint inr, outr;
  gboolean reverse;
  gboolean need_reorder;

  g_return_val_if_fail (buf->memory != NULL, -1);
  g_return_val_if_fail (data != NULL, -1);

  need_reorder = buf->need_reorder;

  channels = buf->spec.info.channels;
  dest = buf->memory;
  segsize = buf->spec.segsize;
  segtotal = buf->spec.segtotal;
  bpf = buf->spec.info.bpf;
  bps = bpf / channels;
  sps = buf->samples_per_seg;

  reverse = out_samples < 0;
  out_samples = ABS (out_samples);

  if (in_samples >= out_samples)
    toprocess = &in_samples;
  else
    toprocess = &out_samples;

  inr = in_samples - 1;
  outr = out_samples - 1;

  /* data_end points to the last sample we have to write, not past it. This is
   * needed to properly handle reverse playback: it points to the last sample. */
  data_end = data + (bpf * inr);

  /* figure out the segment and the offset inside the segment where
   * the first sample should be written. */
  writeseg = *sample / sps;
  sampleoff = (*sample % sps) * bpf;

  GST_DEBUG_OBJECT (buf, "write %d : %d", in_samples, out_samples);

  /* write out all samples */
  while (*toprocess > 0) {
    gint avail;
    guint8 *d, *d_end;
    gint ws;
    gboolean skip;

    while (TRUE) {
      gint diff;

      /* get the currently processed segment */
      segdone = g_atomic_int_get (&buf->segdone) - buf->segbase;

      /* see how far away it is from the write segment */
      diff = writeseg - segdone;

      GST_DEBUG_OBJECT (buf,
          "pointer at %d, write to %d-%d, diff %d, segtotal %d, segsize %d, base %d",
          segdone, writeseg, sampleoff, diff, segtotal, segsize, buf->segbase);

      /* segment too far ahead, writer too slow, we need to drop, hopefully UNLIKELY */
      if (G_UNLIKELY (diff < 0)) {
        /* we need to drop one segment at a time, pretend we wrote a segment. */
        skip = TRUE;
        break;
      }

      /* write segment is within writable range, we can break the loop and
       * start writing the data. */
      if (diff < segtotal) {
        skip = FALSE;
        break;
      }

      /* else we need to wait for the segment to become writable. */
      if (!wait_segment (buf))
        goto not_started;
    }

    /* we can write now */
    ws = writeseg % segtotal;
    avail = MIN (segsize - sampleoff, bpf * out_samples);

    d = dest + (ws * segsize) + sampleoff;
    d_end = d + avail;
    *sample += avail / bpf;

    GST_DEBUG_OBJECT (buf, "write @%p seg %d, sps %d, off %d, avail %d",
        dest + ws * segsize, ws, sps, sampleoff, avail);

    if (need_reorder) {
      gint *reorder_map = buf->channel_reorder_map;

      if (G_LIKELY (inr == outr && !reverse)) {
        /* no rate conversion, simply copy samples */
        FWD_SAMPLES (data, data_end, d, d_end, REORDER_SAMPLES);
      } else if (!reverse) {
        if (inr >= outr)
          /* forward speed up */
          FWD_UP_SAMPLES (data, data_end, d, d_end, REORDER_SAMPLE);
        else
          /* forward slow down */
          FWD_DOWN_SAMPLES (data, data_end, d, d_end, REORDER_SAMPLE);
      } else {
        if (inr >= outr)
          /* reverse speed up */
          REV_UP_SAMPLES (data, data_end, d, d_end, REORDER_SAMPLE);
        else
          /* reverse slow down */
          REV_DOWN_SAMPLES (data, data_end, d, d_end, REORDER_SAMPLE);
      }
    } else {
      if (G_LIKELY (inr == outr && !reverse)) {
        /* no rate conversion, simply copy samples */
        FWD_SAMPLES (data, data_end, d, d_end, memcpy);
      } else if (!reverse) {
        if (inr >= outr)
          /* forward speed up */
          FWD_UP_SAMPLES (data, data_end, d, d_end, memcpy);
        else
          /* forward slow down */
          FWD_DOWN_SAMPLES (data, data_end, d, d_end, memcpy);
      } else {
        if (inr >= outr)
          /* reverse speed up */
          REV_UP_SAMPLES (data, data_end, d, d_end, memcpy);
        else
          /* reverse slow down */
          REV_DOWN_SAMPLES (data, data_end, d, d_end, memcpy);
      }
    }

    /* for the next iteration we write to the next segment at the beginning. */
    writeseg++;
    sampleoff = 0;
  }
  /* we consumed all samples here */
  data = data_end + bpf;

done:
  return inr - ((data_end - data) / bpf);

  /* ERRORS */
not_started:
  {
    GST_DEBUG_OBJECT (buf, "stopped processing");
    goto done;
  }
}

/**
 * gst_audio_ring_buffer_commit:
 * @buf: the #GstAudioRingBuffer to commit
 * @sample: the sample position of the data
 * @data: the data to commit
 * @in_samples: the number of samples in the data to commit
 * @out_samples: the number of samples to write to the ringbuffer
 * @accum: accumulator for rate conversion.
 *
 * Commit @in_samples samples pointed to by @data to the ringbuffer @buf.
 *
 * @in_samples and @out_samples define the rate conversion to perform on the
 * samples in @data. For negative rates, @out_samples must be negative and
 * @in_samples positive.
 *
 * When @out_samples is positive, the first sample will be written at position @sample
 * in the ringbuffer. When @out_samples is negative, the last sample will be written to
 * @sample in reverse order.
 *
 * @out_samples does not need to be a multiple of the segment size of the ringbuffer
 * although it is recommended for optimal performance.
 *
 * @accum will hold a temporary accumulator used in rate conversion and should be
 * set to 0 when this function is first called. In case the commit operation is
 * interrupted, one can resume the processing by passing the previously returned
 * @accum value back to this function.
 *
 * MT safe.
 *
 * Returns: The number of samples written to the ringbuffer or -1 on error. The
 * number of samples written can be less than @out_samples when @buf was interrupted
 * with a flush or stop.
 */
guint
gst_audio_ring_buffer_commit (GstAudioRingBuffer * buf, guint64 * sample,
    guint8 * data, gint in_samples, gint out_samples, gint * accum)
{
  GstAudioRingBufferClass *rclass;
  guint res = -1;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), -1);

  if (G_UNLIKELY (in_samples == 0 || out_samples == 0))
    return in_samples;

  rclass = GST_AUDIO_RING_BUFFER_GET_CLASS (buf);

  if (G_LIKELY (rclass->commit))
    res = rclass->commit (buf, sample, data, in_samples, out_samples, accum);

  return res;
}

/**
 * gst_audio_ring_buffer_read:
 * @buf: the #GstAudioRingBuffer to read from
 * @sample: the sample position of the data
 * @data: where the data should be read
 * @len: the number of samples in data to read
 * @timestamp: where the timestamp is returned
 *
 * Read @len samples from the ringbuffer into the memory pointed
 * to by @data.
 * The first sample should be read from position @sample in
 * the ringbuffer.
 *
 * @len should not be a multiple of the segment size of the ringbuffer
 * although it is recommended.
 *
 * @timestamp will return the timestamp associated with the data returned.
 *
 * Returns: The number of samples read from the ringbuffer or -1 on
 * error.
 *
 * MT safe.
 */
guint
gst_audio_ring_buffer_read (GstAudioRingBuffer * buf, guint64 sample,
    guint8 * data, guint len, GstClockTime * timestamp)
{
  gint segdone;
  gint segsize, segtotal, channels, bps, bpf, sps, readseg = 0;
  guint8 *dest;
  guint to_read;
  gboolean need_reorder;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), -1);
  g_return_val_if_fail (buf->memory != NULL, -1);
  g_return_val_if_fail (data != NULL, -1);

  need_reorder = buf->need_reorder;
  dest = buf->memory;
  segsize = buf->spec.segsize;
  segtotal = buf->spec.segtotal;
  channels = buf->spec.info.channels;
  bpf = buf->spec.info.bpf;
  bps = bpf / channels;
  sps = buf->samples_per_seg;

  to_read = len;
  /* read enough samples */
  while (to_read > 0) {
    gint sampleslen;
    gint sampleoff;

    /* figure out the segment and the offset inside the segment where
     * the sample should be read from. */
    readseg = sample / sps;
    sampleoff = (sample % sps);

    while (TRUE) {
      gint diff;

      /* get the currently processed segment */
      segdone = g_atomic_int_get (&buf->segdone) - buf->segbase;

      /* see how far away it is from the read segment, normally segdone (where
       * the hardware is writing) is bigger than readseg (where software is
       * reading) */
      diff = segdone - readseg;

      GST_DEBUG
          ("pointer at %d, sample %" G_GUINT64_FORMAT
          ", read from %d-%d, to_read %d, diff %d, segtotal %d, segsize %d",
          segdone, sample, readseg, sampleoff, to_read, diff, segtotal,
          segsize);

      /* segment too far ahead, reader too slow */
      if (G_UNLIKELY (diff >= segtotal)) {
        /* pretend we read an empty segment. */
        sampleslen = MIN (sps, to_read);
        memcpy (data, buf->empty_seg, sampleslen * bpf);
        goto next;
      }

      /* read segment is within readable range, we can break the loop and
       * start reading the data. */
      if (diff > 0)
        break;

      /* else we need to wait for the segment to become readable. */
      if (!wait_segment (buf))
        goto not_started;
    }

    /* we can read now */
    readseg = readseg % segtotal;
    sampleslen = MIN (sps - sampleoff, to_read);

    GST_DEBUG_OBJECT (buf, "read @%p seg %d, off %d, sampleslen %d",
        dest + readseg * segsize, readseg, sampleoff, sampleslen);

    if (need_reorder) {
      guint8 *ptr = dest + (readseg * segsize) + (sampleoff * bpf);
      gint i, j;
      gint *reorder_map = buf->channel_reorder_map;

      /* Reorder from device order to GStreamer order */
      for (i = 0; i < sampleslen; i++) {
        for (j = 0; j < channels; j++) {
          memcpy (data + reorder_map[j] * bps, ptr + j * bps, bps);
        }
        ptr += bpf;
      }
    } else {
      memcpy (data, dest + (readseg * segsize) + (sampleoff * bpf),
          (sampleslen * bpf));
    }

  next:
    to_read -= sampleslen;
    sample += sampleslen;
    data += sampleslen * bpf;
  }

  if (buf->timestamps && timestamp) {
    *timestamp = buf->timestamps[readseg % segtotal];
    GST_INFO_OBJECT (buf, "Retrieved timestamp %" GST_TIME_FORMAT
        " @ %d", GST_TIME_ARGS (*timestamp), readseg % segtotal);
  }

  return len - to_read;

  /* ERRORS */
not_started:
  {
    GST_DEBUG_OBJECT (buf, "stopped processing");
    return len - to_read;
  }
}

/**
 * gst_audio_ring_buffer_prepare_read:
 * @buf: the #GstAudioRingBuffer to read from
 * @segment: the segment to read
 * @readptr: the pointer to the memory where samples can be read
 * @len: the number of bytes to read
 *
 * Returns a pointer to memory where the data from segment @segment
 * can be found. This function is mostly used by subclasses.
 *
 * Returns: FALSE if the buffer is not started.
 *
 * MT safe.
 */
gboolean
gst_audio_ring_buffer_prepare_read (GstAudioRingBuffer * buf, gint * segment,
    guint8 ** readptr, gint * len)
{
  guint8 *data;
  gint segdone;

  g_return_val_if_fail (GST_IS_AUDIO_RING_BUFFER (buf), FALSE);

  if (buf->callback == NULL) {
    /* push mode, fail when nothing is started */
    if (g_atomic_int_get (&buf->state) != GST_AUDIO_RING_BUFFER_STATE_STARTED)
      return FALSE;
  }

  g_return_val_if_fail (buf->memory != NULL, FALSE);
  g_return_val_if_fail (segment != NULL, FALSE);
  g_return_val_if_fail (readptr != NULL, FALSE);
  g_return_val_if_fail (len != NULL, FALSE);

  data = buf->memory;

  /* get the position of the pointer */
  segdone = g_atomic_int_get (&buf->segdone);

  *segment = segdone % buf->spec.segtotal;
  *len = buf->spec.segsize;
  *readptr = data + *segment * *len;

  GST_LOG ("prepare read from segment %d (real %d) @%p",
      *segment, segdone, *readptr);

  /* callback to fill the memory with data, for pull based
   * scheduling. */
  if (buf->callback)
    buf->callback (buf, *readptr, *len, buf->cb_data);

  return TRUE;
}

/**
 * gst_audio_ring_buffer_advance:
 * @buf: the #GstAudioRingBuffer to advance
 * @advance: the number of segments written
 *
 * Subclasses should call this function to notify the fact that
 * @advance segments are now processed by the device.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_advance (GstAudioRingBuffer * buf, guint advance)
{
  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  /* update counter */
  g_atomic_int_add (&buf->segdone, advance);

  /* the lock is already taken when the waiting flag is set,
   * we grab the lock as well to make sure the waiter is actually
   * waiting for the signal */
  if (g_atomic_int_compare_and_exchange (&buf->waiting, 1, 0)) {
    GST_OBJECT_LOCK (buf);
    GST_DEBUG_OBJECT (buf, "signal waiter");
    GST_AUDIO_RING_BUFFER_SIGNAL (buf);
    GST_OBJECT_UNLOCK (buf);
  }
}

/**
 * gst_audio_ring_buffer_clear:
 * @buf: the #GstAudioRingBuffer to clear
 * @segment: the segment to clear
 *
 * Clear the given segment of the buffer with silence samples.
 * This function is used by subclasses.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_clear (GstAudioRingBuffer * buf, gint segment)
{
  guint8 *data;

  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  /* no data means it's already cleared */
  if (G_UNLIKELY (buf->memory == NULL))
    return;

  /* no empty_seg means it's not opened */
  if (G_UNLIKELY (buf->empty_seg == NULL))
    return;

  segment %= buf->spec.segtotal;

  data = buf->memory;
  data += segment * buf->spec.segsize;

  GST_LOG ("clear segment %d @%p", segment, data);

  memcpy (data, buf->empty_seg, buf->spec.segsize);
}

/**
 * gst_audio_ring_buffer_may_start:
 * @buf: the #GstAudioRingBuffer
 * @allowed: the new value
 *
 * Tell the ringbuffer that it is allowed to start playback when
 * the ringbuffer is filled with samples.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_may_start (GstAudioRingBuffer * buf, gboolean allowed)
{
  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  GST_LOG_OBJECT (buf, "may start: %d", allowed);
  g_atomic_int_set (&buf->may_start, allowed);
}

/**
 * gst_audio_ring_buffer_set_channel_positions:
 * @buf: the #GstAudioRingBuffer
 * @position: the device channel positions
 *
 * Tell the ringbuffer about the device's channel positions. This must
 * be called in when the ringbuffer is acquired.
 */
void
gst_audio_ring_buffer_set_channel_positions (GstAudioRingBuffer * buf,
    const GstAudioChannelPosition * position)
{
  const GstAudioChannelPosition *to;
  gint channels;
  gint i;

  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));
  g_return_if_fail (buf->acquired);

  channels = buf->spec.info.channels;
  to = buf->spec.info.position;

  if (memcmp (position, to, channels * sizeof (to[0])) == 0)
    return;

  buf->need_reorder = FALSE;
  if (!gst_audio_get_channel_reorder_map (channels, position, to,
          buf->channel_reorder_map))
    g_return_if_reached ();

  for (i = 0; i < channels; i++) {
    if (buf->channel_reorder_map[i] != i) {
      buf->need_reorder = TRUE;
      break;
    }
  }
}

/**
 * gst_ring_buffer_set_timestamp:
 * @buf: the #GstRingBuffer
 * @readseg: the current data segment
 * @timestamp: The new timestamp of the buffer.
 *
 * Set a new timestamp on the buffer.
 *
 * MT safe.
 */
void
gst_audio_ring_buffer_set_timestamp (GstAudioRingBuffer * buf, gint readseg,
    GstClockTime timestamp)
{
  g_return_if_fail (GST_IS_AUDIO_RING_BUFFER (buf));

  GST_INFO_OBJECT (buf, "Storing timestamp %" GST_TIME_FORMAT
      " @ %d", GST_TIME_ARGS (timestamp), readseg);

  GST_OBJECT_LOCK (buf);
  if (G_UNLIKELY (!buf->acquired))
    goto not_acquired;

  buf->timestamps[readseg] = timestamp;

done:
  GST_OBJECT_UNLOCK (buf);
  return;

not_acquired:
  {
    GST_DEBUG_OBJECT (buf, "we are not acquired");
    goto done;
  }
}
