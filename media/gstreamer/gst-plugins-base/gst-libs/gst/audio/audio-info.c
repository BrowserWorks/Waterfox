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

#include <gst/gststructure.h>

/**
 * gst_audio_info_copy:
 * @info: a #GstAudioInfo
 *
 * Copy a GstAudioInfo structure.
 *
 * Returns: a new #GstAudioInfo. free with gst_audio_info_free.
 */
GstAudioInfo *
gst_audio_info_copy (const GstAudioInfo * info)
{
  return g_slice_dup (GstAudioInfo, info);
}

/**
 * gst_audio_info_free:
 * @info: a #GstAudioInfo
 *
 * Free a GstAudioInfo structure previously allocated with gst_audio_info_new()
 * or gst_audio_info_copy().
 */
void
gst_audio_info_free (GstAudioInfo * info)
{
  g_slice_free (GstAudioInfo, info);
}

G_DEFINE_BOXED_TYPE (GstAudioInfo, gst_audio_info,
    (GBoxedCopyFunc) gst_audio_info_copy, (GBoxedFreeFunc) gst_audio_info_free);

/**
 * gst_audio_info_new:
 *
 * Allocate a new #GstAudioInfo that is also initialized with
 * gst_audio_info_init().
 *
 * Returns: a new #GstAudioInfo. free with gst_audio_info_free().
 */
GstAudioInfo *
gst_audio_info_new (void)
{
  GstAudioInfo *info;

  info = g_slice_new (GstAudioInfo);
  gst_audio_info_init (info);

  return info;
}

/**
 * gst_audio_info_init:
 * @info: a #GstAudioInfo
 *
 * Initialize @info with default values.
 */
void
gst_audio_info_init (GstAudioInfo * info)
{
  g_return_if_fail (info != NULL);

  memset (info, 0, sizeof (GstAudioInfo));

  info->finfo = gst_audio_format_get_info (GST_AUDIO_FORMAT_UNKNOWN);
}

/**
 * gst_audio_info_set_format:
 * @info: a #GstAudioInfo
 * @format: the format
 * @rate: the samplerate
 * @channels: the number of channels
 * @position: the channel positions
 *
 * Set the default info for the audio info of @format and @rate and @channels.
 *
 * Note: This initializes @info first, no values are preserved.
 */
void
gst_audio_info_set_format (GstAudioInfo * info, GstAudioFormat format,
    gint rate, gint channels, const GstAudioChannelPosition * position)
{
  const GstAudioFormatInfo *finfo;
  gint i;

  g_return_if_fail (info != NULL);
  g_return_if_fail (format != GST_AUDIO_FORMAT_UNKNOWN);
  g_return_if_fail (channels <= 64 || position == NULL);

  gst_audio_info_init (info);

  finfo = gst_audio_format_get_info (format);

  info->flags = 0;
  info->layout = GST_AUDIO_LAYOUT_INTERLEAVED;
  info->finfo = finfo;
  info->rate = rate;
  info->channels = channels;
  info->bpf = (finfo->width * channels) / 8;

  memset (&info->position, 0xff, sizeof (info->position));

  if (!position && channels == 1) {
    info->position[0] = GST_AUDIO_CHANNEL_POSITION_MONO;
    return;
  } else if (!position && channels == 2) {
    info->position[0] = GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT;
    info->position[1] = GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT;
    return;
  } else {
    if (!position
        || !gst_audio_check_valid_channel_positions (position, channels,
            TRUE)) {
      if (position)
        g_warning ("Invalid channel positions");
    } else {
      memcpy (&info->position, position,
          info->channels * sizeof (info->position[0]));
      if (info->position[0] == GST_AUDIO_CHANNEL_POSITION_NONE)
        info->flags |= GST_AUDIO_FLAG_UNPOSITIONED;
      return;
    }
  }

  /* Otherwise a NONE layout */
  info->flags |= GST_AUDIO_FLAG_UNPOSITIONED;
  for (i = 0; i < MIN (64, channels); i++)
    info->position[i] = GST_AUDIO_CHANNEL_POSITION_NONE;
}

/**
 * gst_audio_info_from_caps:
 * @info: a #GstAudioInfo
 * @caps: a #GstCaps
 *
 * Parse @caps and update @info.
 *
 * Returns: TRUE if @caps could be parsed
 */
gboolean
gst_audio_info_from_caps (GstAudioInfo * info, const GstCaps * caps)
{
  GstStructure *str;
  const gchar *s;
  GstAudioFormat format;
  gint rate, channels;
  guint64 channel_mask;
  gint i;
  GstAudioChannelPosition position[64];
  GstAudioFlags flags;
  GstAudioLayout layout;

  g_return_val_if_fail (info != NULL, FALSE);
  g_return_val_if_fail (caps != NULL, FALSE);
  g_return_val_if_fail (gst_caps_is_fixed (caps), FALSE);

  GST_DEBUG ("parsing caps %" GST_PTR_FORMAT, caps);

  flags = 0;

  str = gst_caps_get_structure (caps, 0);

  if (!gst_structure_has_name (str, "audio/x-raw"))
    goto wrong_name;

  if (!(s = gst_structure_get_string (str, "format")))
    goto no_format;

  format = gst_audio_format_from_string (s);
  if (format == GST_AUDIO_FORMAT_UNKNOWN)
    goto unknown_format;

  if (!(s = gst_structure_get_string (str, "layout")))
    goto no_layout;
  if (g_str_equal (s, "interleaved"))
    layout = GST_AUDIO_LAYOUT_INTERLEAVED;
  else if (g_str_equal (s, "non-interleaved"))
    layout = GST_AUDIO_LAYOUT_NON_INTERLEAVED;
  else
    goto unknown_layout;

  if (!gst_structure_get_int (str, "rate", &rate))
    goto no_rate;
  if (!gst_structure_get_int (str, "channels", &channels))
    goto no_channels;

  if (!gst_structure_get (str, "channel-mask", GST_TYPE_BITMASK, &channel_mask,
          NULL) || (channel_mask == 0 && channels == 1)) {
    if (channels == 1) {
      position[0] = GST_AUDIO_CHANNEL_POSITION_MONO;
    } else if (channels == 2) {
      position[0] = GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT;
      position[1] = GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT;
    } else {
      goto no_channel_mask;
    }
  } else if (channel_mask == 0) {
    flags |= GST_AUDIO_FLAG_UNPOSITIONED;
    for (i = 0; i < MIN (64, channels); i++)
      position[i] = GST_AUDIO_CHANNEL_POSITION_NONE;
  } else {
    if (!gst_audio_channel_positions_from_mask (channels, channel_mask,
            position))
      goto invalid_channel_mask;
  }

  gst_audio_info_set_format (info, format, rate, channels,
      (channels > 64) ? NULL : position);

  info->flags = flags;
  info->layout = layout;

  return TRUE;

  /* ERROR */
wrong_name:
  {
    GST_ERROR ("wrong name, expected audio/x-raw");
    return FALSE;
  }
no_format:
  {
    GST_ERROR ("no format given");
    return FALSE;
  }
unknown_format:
  {
    GST_ERROR ("unknown format given");
    return FALSE;
  }
no_layout:
  {
    GST_ERROR ("no layout given");
    return FALSE;
  }
unknown_layout:
  {
    GST_ERROR ("unknown layout given");
    return FALSE;
  }
no_rate:
  {
    GST_ERROR ("no rate property given");
    return FALSE;
  }
no_channels:
  {
    GST_ERROR ("no channels property given");
    return FALSE;
  }
no_channel_mask:
  {
    GST_ERROR ("no channel-mask property given");
    return FALSE;
  }
invalid_channel_mask:
  {
    GST_ERROR ("Invalid channel mask 0x%016" G_GINT64_MODIFIER
        "x for %d channels", channel_mask, channels);
    return FALSE;
  }
}

/**
 * gst_audio_info_to_caps:
 * @info: a #GstAudioInfo
 *
 * Convert the values of @info into a #GstCaps.
 *
 * Returns: (transfer full): the new #GstCaps containing the
 *          info of @info.
 */
GstCaps *
gst_audio_info_to_caps (const GstAudioInfo * info)
{
  GstCaps *caps;
  const gchar *format;
  const gchar *layout;
  GstAudioFlags flags;

  g_return_val_if_fail (info != NULL, NULL);
  g_return_val_if_fail (info->finfo != NULL, NULL);
  g_return_val_if_fail (info->finfo->format != GST_AUDIO_FORMAT_UNKNOWN, NULL);

  format = gst_audio_format_to_string (info->finfo->format);
  g_return_val_if_fail (format != NULL, NULL);

  if (info->layout == GST_AUDIO_LAYOUT_INTERLEAVED)
    layout = "interleaved";
  else if (info->layout == GST_AUDIO_LAYOUT_NON_INTERLEAVED)
    layout = "non-interleaved";
  else
    g_return_val_if_reached (NULL);

  flags = info->flags;
  if ((flags & GST_AUDIO_FLAG_UNPOSITIONED) && info->channels > 1
      && info->position[0] != GST_AUDIO_CHANNEL_POSITION_NONE) {
    flags &= ~GST_AUDIO_FLAG_UNPOSITIONED;
    g_warning ("Unpositioned audio channel position flag set but "
        "channel positions present");
  } else if (!(flags & GST_AUDIO_FLAG_UNPOSITIONED) && info->channels > 1
      && info->position[0] == GST_AUDIO_CHANNEL_POSITION_NONE) {
    flags |= GST_AUDIO_FLAG_UNPOSITIONED;
    g_warning ("Unpositioned audio channel position flag not set "
        "but no channel positions present");
  }

  caps = gst_caps_new_simple ("audio/x-raw",
      "format", G_TYPE_STRING, format,
      "layout", G_TYPE_STRING, layout,
      "rate", G_TYPE_INT, info->rate,
      "channels", G_TYPE_INT, info->channels, NULL);

  if (info->channels > 1
      || info->position[0] != GST_AUDIO_CHANNEL_POSITION_MONO) {
    guint64 channel_mask = 0;

    if ((flags & GST_AUDIO_FLAG_UNPOSITIONED)) {
      channel_mask = 0;
    } else {
      if (!gst_audio_channel_positions_to_mask (info->position, info->channels,
              TRUE, &channel_mask))
        goto invalid_channel_positions;
    }

    if (info->channels == 1
        && info->position[0] == GST_AUDIO_CHANNEL_POSITION_MONO) {
      /* Default mono special case */
    } else {
      gst_caps_set_simple (caps, "channel-mask", GST_TYPE_BITMASK, channel_mask,
          NULL);
    }
  }

  return caps;

invalid_channel_positions:
  {
    GST_ERROR ("Invalid channel positions");
    gst_caps_unref (caps);
    return NULL;
  }
}

/**
 * gst_audio_info_convert:
 * @info: a #GstAudioInfo
 * @src_fmt: #GstFormat of the @src_val
 * @src_val: value to convert
 * @dest_fmt: #GstFormat of the @dest_val
 * @dest_val: pointer to destination value
 *
 * Converts among various #GstFormat types.  This function handles
 * GST_FORMAT_BYTES, GST_FORMAT_TIME, and GST_FORMAT_DEFAULT.  For
 * raw audio, GST_FORMAT_DEFAULT corresponds to audio frames.  This
 * function can be used to handle pad queries of the type GST_QUERY_CONVERT.
 *
 * Returns: TRUE if the conversion was successful.
 */
gboolean
gst_audio_info_convert (const GstAudioInfo * info,
    GstFormat src_fmt, gint64 src_val, GstFormat dest_fmt, gint64 * dest_val)
{
  gboolean res = TRUE;
  gint bpf, rate;

  GST_DEBUG ("converting value %" G_GINT64_FORMAT " from %s (%d) to %s (%d)",
      src_val, gst_format_get_name (src_fmt), src_fmt,
      gst_format_get_name (dest_fmt), dest_fmt);

  if (src_fmt == dest_fmt || src_val == -1) {
    *dest_val = src_val;
    goto done;
  }

  /* get important info */
  bpf = GST_AUDIO_INFO_BPF (info);
  rate = GST_AUDIO_INFO_RATE (info);

  if (bpf == 0 || rate == 0) {
    GST_DEBUG ("no rate or bpf configured");
    res = FALSE;
    goto done;
  }

  switch (src_fmt) {
    case GST_FORMAT_BYTES:
      switch (dest_fmt) {
        case GST_FORMAT_TIME:
          *dest_val = GST_FRAMES_TO_CLOCK_TIME (src_val / bpf, rate);
          break;
        case GST_FORMAT_DEFAULT:
          *dest_val = src_val / bpf;
          break;
        default:
          res = FALSE;
          break;
      }
      break;
    case GST_FORMAT_DEFAULT:
      switch (dest_fmt) {
        case GST_FORMAT_TIME:
          *dest_val = GST_FRAMES_TO_CLOCK_TIME (src_val, rate);
          break;
        case GST_FORMAT_BYTES:
          *dest_val = src_val * bpf;
          break;
        default:
          res = FALSE;
          break;
      }
      break;
    case GST_FORMAT_TIME:
      switch (dest_fmt) {
        case GST_FORMAT_DEFAULT:
          *dest_val = GST_CLOCK_TIME_TO_FRAMES (src_val, rate);
          break;
        case GST_FORMAT_BYTES:
          *dest_val = GST_CLOCK_TIME_TO_FRAMES (src_val, rate);
          *dest_val *= bpf;
          break;
        default:
          res = FALSE;
          break;
      }
      break;
    default:
      res = FALSE;
      break;
  }
done:

  GST_DEBUG ("ret=%d result %" G_GINT64_FORMAT, res, res ? *dest_val : -1);

  return res;
}

/**
 * gst_audio_info_is_equal:
 * @info: a #GstAudioInfo
 * @other: a #GstAudioInfo
 *
 * Compares two #GstAudioInfo and returns whether they are equal or not
 *
 * Returns: %TRUE if @info and @other are equal, else %FALSE.
 *
 * Since: 1.2
 *
 */
gboolean
gst_audio_info_is_equal (const GstAudioInfo * info, const GstAudioInfo * other)
{
  if (info == other)
    return TRUE;
  if (info->finfo == NULL || other->finfo == NULL)
    return FALSE;
  if (GST_AUDIO_INFO_FORMAT (info) != GST_AUDIO_INFO_FORMAT (other))
    return FALSE;
  if (GST_AUDIO_INFO_FLAGS (info) != GST_AUDIO_INFO_FLAGS (other))
    return FALSE;
  if (GST_AUDIO_INFO_LAYOUT (info) != GST_AUDIO_INFO_LAYOUT (other))
    return FALSE;
  if (GST_AUDIO_INFO_RATE (info) != GST_AUDIO_INFO_RATE (other))
    return FALSE;
  if (GST_AUDIO_INFO_CHANNELS (info) != GST_AUDIO_INFO_CHANNELS (other))
    return FALSE;
  if (GST_AUDIO_INFO_CHANNELS (info) > 64)
    return TRUE;
  if (memcmp (info->position, other->position,
          GST_AUDIO_INFO_CHANNELS (info) * sizeof (GstAudioChannelPosition)) !=
      0)
    return FALSE;

  return TRUE;
}
