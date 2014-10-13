/* GStreamer
 * Copyright (C) 2008 David Schleef <ds@schleef.org>
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gst/video/video.h>
#include "gstvideoutils.h"

#include <string.h>

G_DEFINE_BOXED_TYPE (GstVideoCodecFrame, gst_video_codec_frame,
    (GBoxedCopyFunc) gst_video_codec_frame_ref,
    (GBoxedFreeFunc) gst_video_codec_frame_unref);

static void
_gst_video_codec_frame_free (GstVideoCodecFrame * frame)
{
  g_return_if_fail (frame != NULL);

  GST_DEBUG ("free frame %p", frame);

  if (frame->input_buffer) {
    gst_buffer_unref (frame->input_buffer);
  }

  if (frame->output_buffer) {
    gst_buffer_unref (frame->output_buffer);
  }

  g_list_free_full (frame->events, (GDestroyNotify) gst_event_unref);
  frame->events = NULL;

  if (frame->user_data_destroy_notify)
    frame->user_data_destroy_notify (frame->user_data);

  g_slice_free (GstVideoCodecFrame, frame);
}

/**
 * gst_video_codec_frame_set_user_data:
 * @frame: a #GstVideoCodecFrame
 * @user_data: private data
 * @notify: (closure user_data): a #GDestroyNotify
 *
 * Sets @user_data on the frame and the #GDestroyNotify that will be called when
 * the frame is freed. Allows to attach private data by the subclass to frames.
 *
 * If a @user_data was previously set, then the previous set @notify will be called
 * before the @user_data is replaced.
 */
void
gst_video_codec_frame_set_user_data (GstVideoCodecFrame * frame,
    gpointer user_data, GDestroyNotify notify)
{
  if (frame->user_data_destroy_notify)
    frame->user_data_destroy_notify (frame->user_data);

  frame->user_data = user_data;
  frame->user_data_destroy_notify = notify;
}

/**
 * gst_video_codec_frame_get_user_data:
 * @frame: a #GstVideoCodecFrame
 *
 * Gets private data set on the frame by the subclass via
 * gst_video_codec_frame_set_user_data() previously.
 *
 * Returns: (transfer none): The previously set user_data
 */
gpointer
gst_video_codec_frame_get_user_data (GstVideoCodecFrame * frame)
{
  return frame->user_data;
}

/**
 * gst_video_codec_frame_ref:
 * @frame: a #GstVideoCodecFrame
 *
 * Increases the refcount of the given frame by one.
 *
 * Returns: @buf
 */
GstVideoCodecFrame *
gst_video_codec_frame_ref (GstVideoCodecFrame * frame)
{
  g_return_val_if_fail (frame != NULL, NULL);

  GST_TRACE ("%p ref %d->%d", frame, frame->ref_count, frame->ref_count + 1);

  g_atomic_int_inc (&frame->ref_count);

  return frame;
}

/**
 * gst_video_codec_frame_unref:
 * @frame: a #GstVideoCodecFrame
 *
 * Decreases the refcount of the frame. If the refcount reaches 0, the frame
 * will be freed.
 */
void
gst_video_codec_frame_unref (GstVideoCodecFrame * frame)
{
  g_return_if_fail (frame != NULL);
  g_return_if_fail (frame->ref_count > 0);

  GST_TRACE ("%p unref %d->%d", frame, frame->ref_count, frame->ref_count - 1);

  if (g_atomic_int_dec_and_test (&frame->ref_count)) {
    _gst_video_codec_frame_free (frame);
  }
}


/**
 * gst_video_codec_state_ref:
 * @state: a #GstVideoCodecState
 *
 * Increases the refcount of the given state by one.
 *
 * Returns: @buf
 */
GstVideoCodecState *
gst_video_codec_state_ref (GstVideoCodecState * state)
{
  g_return_val_if_fail (state != NULL, NULL);

  GST_TRACE ("%p ref %d->%d", state, state->ref_count, state->ref_count + 1);

  g_atomic_int_inc (&state->ref_count);

  return state;
}

static void
_gst_video_codec_state_free (GstVideoCodecState * state)
{
  GST_DEBUG ("free state %p", state);

  if (state->caps)
    gst_caps_unref (state->caps);
  if (state->codec_data)
    gst_buffer_unref (state->codec_data);
  g_slice_free (GstVideoCodecState, state);
}

/**
 * gst_video_codec_state_unref:
 * @state: a #GstVideoCodecState
 *
 * Decreases the refcount of the state. If the refcount reaches 0, the state
 * will be freed.
 */
void
gst_video_codec_state_unref (GstVideoCodecState * state)
{
  g_return_if_fail (state != NULL);
  g_return_if_fail (state->ref_count > 0);

  GST_TRACE ("%p unref %d->%d", state, state->ref_count, state->ref_count - 1);

  if (g_atomic_int_dec_and_test (&state->ref_count)) {
    _gst_video_codec_state_free (state);
  }
}

G_DEFINE_BOXED_TYPE (GstVideoCodecState, gst_video_codec_state,
    (GBoxedCopyFunc) gst_video_codec_state_ref,
    (GBoxedFreeFunc) gst_video_codec_state_unref);
