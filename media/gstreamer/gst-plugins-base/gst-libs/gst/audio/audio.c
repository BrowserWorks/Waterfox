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
 * SECTION:gstaudio
 * @short_description: Support library for audio elements
 *
 * This library contains some helper functions for audio elements.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <string.h>

#include "audio.h"
#include "audio-enumtypes.h"

/**
 * gst_audio_buffer_clip:
 * @buffer: (transfer full): The buffer to clip.
 * @segment: Segment in %GST_FORMAT_TIME or %GST_FORMAT_DEFAULT to which
 *           the buffer should be clipped.
 * @rate: sample rate.
 * @bpf: size of one audio frame in bytes. This is the size of one sample
 * * channels.
 *
 * Clip the buffer to the given %GstSegment.
 *
 * After calling this function the caller does not own a reference to
 * @buffer anymore.
 *
 * Returns: (transfer full): %NULL if the buffer is completely outside the configured segment,
 * otherwise the clipped buffer is returned.
 *
 * If the buffer has no timestamp, it is assumed to be inside the segment and
 * is not clipped
 */
GstBuffer *
gst_audio_buffer_clip (GstBuffer * buffer, GstSegment * segment, gint rate,
    gint bpf)
{
  GstBuffer *ret;
  GstClockTime timestamp = GST_CLOCK_TIME_NONE, duration = GST_CLOCK_TIME_NONE;
  guint64 offset = GST_BUFFER_OFFSET_NONE, offset_end = GST_BUFFER_OFFSET_NONE;
  gsize trim, size, osize;
  gboolean change_duration = TRUE, change_offset = TRUE, change_offset_end =
      TRUE;

  g_return_val_if_fail (segment->format == GST_FORMAT_TIME ||
      segment->format == GST_FORMAT_DEFAULT, buffer);
  g_return_val_if_fail (GST_IS_BUFFER (buffer), NULL);

  if (!GST_BUFFER_TIMESTAMP_IS_VALID (buffer))
    /* No timestamp - assume the buffer is completely in the segment */
    return buffer;

  /* Get copies of the buffer metadata to change later.
   * Calculate the missing values for the calculations,
   * they won't be changed later though. */

  trim = 0;
  osize = size = gst_buffer_get_size (buffer);

  /* no data, nothing to clip */
  if (!size)
    return buffer;

  timestamp = GST_BUFFER_TIMESTAMP (buffer);
  GST_DEBUG ("timestamp %" GST_TIME_FORMAT, GST_TIME_ARGS (timestamp));
  if (GST_BUFFER_DURATION_IS_VALID (buffer)) {
    duration = GST_BUFFER_DURATION (buffer);
  } else {
    change_duration = FALSE;
    duration = gst_util_uint64_scale (size / bpf, GST_SECOND, rate);
  }

  if (GST_BUFFER_OFFSET_IS_VALID (buffer)) {
    offset = GST_BUFFER_OFFSET (buffer);
  } else {
    change_offset = FALSE;
    offset = 0;
  }

  if (GST_BUFFER_OFFSET_END_IS_VALID (buffer)) {
    offset_end = GST_BUFFER_OFFSET_END (buffer);
  } else {
    change_offset_end = FALSE;
    offset_end = offset + size / bpf;
  }

  if (segment->format == GST_FORMAT_TIME) {
    /* Handle clipping for GST_FORMAT_TIME */

    guint64 start, stop, cstart, cstop, diff;

    start = timestamp;
    stop = timestamp + duration;

    if (gst_segment_clip (segment, GST_FORMAT_TIME,
            start, stop, &cstart, &cstop)) {

      diff = cstart - start;
      if (diff > 0) {
        timestamp = cstart;

        if (change_duration)
          duration -= diff;

        diff = gst_util_uint64_scale (diff, rate, GST_SECOND);
        if (change_offset)
          offset += diff;
        trim += diff * bpf;
        size -= diff * bpf;
      }

      diff = stop - cstop;
      if (diff > 0) {
        /* duration is always valid if stop is valid */
        duration -= diff;

        diff = gst_util_uint64_scale (diff, rate, GST_SECOND);
        if (change_offset_end)
          offset_end -= diff;
        size -= diff * bpf;
      }
    } else {
      gst_buffer_unref (buffer);
      return NULL;
    }
  } else {
    /* Handle clipping for GST_FORMAT_DEFAULT */
    guint64 start, stop, cstart, cstop, diff;

    g_return_val_if_fail (GST_BUFFER_OFFSET_IS_VALID (buffer), buffer);

    start = offset;
    stop = offset_end;

    if (gst_segment_clip (segment, GST_FORMAT_DEFAULT,
            start, stop, &cstart, &cstop)) {

      diff = cstart - start;
      if (diff > 0) {
        offset = cstart;

        timestamp = gst_util_uint64_scale (cstart, GST_SECOND, rate);

        if (change_duration)
          duration -= gst_util_uint64_scale (diff, GST_SECOND, rate);

        trim += diff * bpf;
        size -= diff * bpf;
      }

      diff = stop - cstop;
      if (diff > 0) {
        offset_end = cstop;

        if (change_duration)
          duration -= gst_util_uint64_scale (diff, GST_SECOND, rate);

        size -= diff * bpf;
      }
    } else {
      gst_buffer_unref (buffer);
      return NULL;
    }
  }

  if (trim == 0 && size == osize) {
    ret = buffer;

    if (GST_BUFFER_TIMESTAMP (ret) != timestamp) {
      ret = gst_buffer_make_writable (ret);
      GST_BUFFER_TIMESTAMP (ret) = timestamp;
    }
    if (GST_BUFFER_DURATION (ret) != duration) {
      ret = gst_buffer_make_writable (ret);
      GST_BUFFER_DURATION (ret) = duration;
    }
  } else {
    /* Get a writable buffer and apply all changes */
    GST_DEBUG ("trim %" G_GSIZE_FORMAT " size %" G_GSIZE_FORMAT, trim, size);
    ret = gst_buffer_copy_region (buffer, GST_BUFFER_COPY_ALL, trim, size);
    gst_buffer_unref (buffer);

    GST_DEBUG ("timestamp %" GST_TIME_FORMAT, GST_TIME_ARGS (timestamp));
    GST_BUFFER_TIMESTAMP (ret) = timestamp;

    if (change_duration)
      GST_BUFFER_DURATION (ret) = duration;
    if (change_offset)
      GST_BUFFER_OFFSET (ret) = offset;
    if (change_offset_end)
      GST_BUFFER_OFFSET_END (ret) = offset_end;
  }
  return ret;
}
