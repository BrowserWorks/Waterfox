/* GStreamer audio helper functions for IEC 61937 payloading
 * (c) 2011 Intel Corporation
 *     2011 Collabora Multimedia
 *     2011 Arun Raghavan <arun.raghavan@collabora.co.uk>
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
 * SECTION:gstaudioiec61937
 * @short_description: Utility functions for IEC 61937 payloading
 *
 * This module contains some helper functions for encapsulating various
 * audio formats in IEC 61937 headers and padding.
 *
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include <gst/audio/audio.h>
#include "gstaudioiec61937.h"

#define IEC61937_HEADER_SIZE      8
#define IEC61937_PAYLOAD_SIZE_AC3 (1536 * 4)
#define IEC61937_PAYLOAD_SIZE_EAC3 (6144 * 4)
#define IEC61937_PAYLOAD_SIZE_AAC (1024 * 4)

static gint
caps_get_int_field (const GstCaps * caps, const gchar * field)
{
  const GstStructure *st;
  gint ret = 0;

  st = gst_caps_get_structure (caps, 0);
  gst_structure_get_int (st, field, &ret);

  return ret;
}

static const gchar *
caps_get_string_field (const GstCaps * caps, const gchar * field)
{
  const GstStructure *st = gst_caps_get_structure (caps, 0);
  return gst_structure_get_string (st, field);
}

/**
 * gst_audio_iec61937_frame_size:
 * @spec: the ringbufer spec
 *
 * Calculated the size of the buffer expected by gst_audio_iec61937_payload() for
 * payloading type from @spec.
 *
 * Returns: the size or 0 if the given @type is not supported or cannot be
 * payloaded.
 */
guint
gst_audio_iec61937_frame_size (const GstAudioRingBufferSpec * spec)
{
  switch (spec->type) {
    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_AC3:
      return IEC61937_PAYLOAD_SIZE_AC3;

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_EAC3:
      /* Check that the parser supports /some/ alignment. Need to be less
       * strict about this at checking time since the alignment is dynamically
       * set at the moment. */
      if (caps_get_string_field (spec->caps, "alignment"))
        return IEC61937_PAYLOAD_SIZE_EAC3;
      else
        return 0;

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_DTS:
    {
      gint dts_frame_size = caps_get_int_field (spec->caps, "frame-size");
      gint iec_frame_size = caps_get_int_field (spec->caps, "block-size") * 4;

      /* Note: this will also (correctly) fail if either field is missing */
      if (iec_frame_size >= (dts_frame_size + IEC61937_HEADER_SIZE))
        return iec_frame_size;
      else
        return 0;
    }

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG:
    {
      int version, layer, channels, frames;

      version = caps_get_int_field (spec->caps, "mpegaudioversion");
      layer = caps_get_int_field (spec->caps, "layer");
      channels = caps_get_int_field (spec->caps, "channels");

      /* Bail out if we can't figure out either, if it's MPEG 2.5, or if it's
       * MP3 with multichannel audio */
      if (!version || !layer || version == 3 || channels > 2)
        return 0;

      if (version == 1 && layer == 1)
        frames = 384;
      else if (version == 2 && layer == 1 && spec->info.rate < 32000)
        frames = 768;
      else if (version == 2 && layer == 1 && spec->info.rate < 32000)
        frames = 2304;
      else
        frames = 1152;

      return frames * 4;
    }

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG2_AAC:
    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG4_AAC:
    {
      return IEC61937_PAYLOAD_SIZE_AAC;
    }

    default:
      return 0;
  }
}

/**
 * gst_audio_iec61937_payload:
 * @src: (array length=src_n): a buffer containing the data to payload
 * @src_n: size of @src in bytes
 * @dst: (array length=dst_n): the destination buffer to store the
 *       payloaded contents in. Should not overlap with @src
 * @dst_n: size of @dst in bytes
 * @spec: the ringbufer spec for @src
 * @endianness: the expected byte order of the payloaded data
 *
 * Payloads @src in the form specified by IEC 61937 for the type from @spec and
 * stores the result in @dst. @src must contain exactly one frame of data and
 * the frame is not checked for errors.
 *
 * Returns: transfer-full: %TRUE if the payloading was successful, %FALSE
 * otherwise.
 */
gboolean
gst_audio_iec61937_payload (const guint8 * src, guint src_n, guint8 * dst,
    guint dst_n, const GstAudioRingBufferSpec * spec, gint endianness)
{
  guint i, tmp;
#if G_BYTE_ORDER == G_BIG_ENDIAN
  guint8 zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, six = 6,
      seven = 7;
#else
  /* We need to send the data byte-swapped */
  guint8 zero = 1, one = 0, two = 3, three = 2, four = 5, five = 4, six = 7,
      seven = 6;
#endif

  g_return_val_if_fail (src != NULL, FALSE);
  g_return_val_if_fail (dst != NULL, FALSE);
  g_return_val_if_fail (src != dst, FALSE);
  g_return_val_if_fail (dst_n >= gst_audio_iec61937_frame_size (spec), FALSE);

  if (dst_n < src_n + IEC61937_HEADER_SIZE)
    return FALSE;

  /* Pa, Pb */
  dst[zero] = 0xF8;
  dst[one] = 0x72;
  dst[two] = 0x4E;
  dst[three] = 0x1F;

  switch (spec->type) {
    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_AC3:
    {
      g_return_val_if_fail (src_n >= 6, FALSE);

      /* Pc: bit 13-15 - stream number (0)
       *     bit 11-12 - reserved (0)
       *     bit  8-10 - bsmod from AC3 frame */
      dst[four] = src[5] & 0x7;
      /* Pc: bit    7  - error bit (0)
       *     bit  5-6  - subdata type (0)
       *     bit  0-4  - data type (1) */
      dst[five] = 1;
      /* Pd: bit 15-0  - frame size in bits */
      tmp = src_n * 8;
      dst[six] = (guint8) (tmp >> 8);
      dst[seven] = (guint8) (tmp & 0xff);

      break;
    }

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_EAC3:
    {
      if (g_str_equal (caps_get_string_field (spec->caps, "alignment"),
              "iec61937"))
        return FALSE;

      /* Pc: bit 13-15 - stream number (0)
       *     bit 11-12 - reserved (0)
       *     bit  8-10 - bsmod from E-AC3 frame if present */
      /* FIXME: this works, but nicer if we can put in the actual bsmod */
      dst[four] = 0;
      /* Pc: bit    7  - error bit (0)
       *     bit  5-6  - subdata type (0)
       *     bit  0-4  - data type (21) */
      dst[five] = 21;
      /* Pd: bit 15-0  - frame size in bytes */
      dst[six] = ((guint16) src_n) >> 8;
      dst[seven] = ((guint16) src_n) & 0xff;

      break;
    }

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_DTS:
    {
      int blocksize = caps_get_int_field (spec->caps, "block-size");

      g_return_val_if_fail (src_n != 0, FALSE);

      if (blocksize == 0)
        return FALSE;

      /* Pc: bit 13-15 - stream number (0)
       *     bit 11-12 - reserved (0)
       *     bit  8-10 - for DTS type I-III (0) */
      dst[four] = 0;
      /* Pc: bit    7  - error bit (0)
       *     bit  5-6  - reserved (0)
       *     bit  0-4  - data type (11 = type I, 12 = type II,
       *                            13 = type III) */
      dst[five] = 11 + (blocksize / 1024);
      /* Pd: bit 15-0  - frame size, in bits (for type I-III) */
      tmp = src_n * 8;
      dst[six] = ((guint16) tmp) >> 8;
      dst[seven] = ((guint16) tmp) & 0xff;
      break;
    }

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG:
    {
      int version, layer;

      version = caps_get_int_field (spec->caps, "mpegaudioversion");
      layer = caps_get_int_field (spec->caps, "layer");

      g_return_val_if_fail (version > 0 && layer > 0, FALSE);

      /* NOTE: multichannel audio (MPEG-2) is not supported */

      /* Pc: bit 13-15 - stream number (0)
       *     bit 11-12 - reserved (0)
       *     bit  9-10 - 0 - no dynamic range control
       *               - 2 - dynamic range control exists
       *               - 1,3 - reserved
       *     bit    8  - Normal (0) or Karaoke (1) mode */
      dst[four] = 0;
      /* Pc: bit    7  - error bit (0)
       *     bit  5-6  - reserved (0)
       *     bit  0-4  - data type (04 = MPEG 1, Layer 1
       *                            05 = MPEG 1, Layer 2, 3 / MPEG 2, w/o ext.
       *                            06 = MPEG 2, with extension
       *                            08 - MPEG 2 LSF, Layer 1
       *                            09 - MPEG 2 LSF, Layer 2
       *                            10 - MPEG 2 LSF, Layer 3 */
      if (version == 1 && layer == 1)
        dst[five] = 0x04;
      else if ((version == 1 && (layer == 2 || layer == 3)) ||
          (version == 2 && spec->info.rate >= 32000))
        dst[five] = 0x05;
      else if (version == 2 && layer == 1 && spec->info.rate < 32000)
        dst[five] = 0x08;
      else if (version == 2 && layer == 2 && spec->info.rate < 32000)
        dst[five] = 0x09;
      else if (version == 2 && layer == 3 && spec->info.rate < 32000)
        dst[five] = 0x0A;
      else
        g_return_val_if_reached (FALSE);
      /* Pd: bit 15-0  - frame size in bits */
      dst[six] = ((guint16) src_n * 8) >> 8;
      dst[seven] = ((guint16) src_n * 8) & 0xff;

      break;
    }

    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG2_AAC:
      /* HACK. disguising MPEG4 AAC as MPEG2 AAC seems to work. */
      /* TODO: set the right Pc,Pd for MPEG4 in accordance with IEC61937-6 */
    case GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG4_AAC:
    {
      int num_rd_blks;

      g_return_val_if_fail (src_n >= 7, FALSE);
      num_rd_blks = (src[6] & 0x03) + 1;

      /* Pc: bit 13-15 - stream number (0)
       *     bit 11-12 - reserved (0)
       *     bit  8-10 - reserved? (0) */
      dst[four] = 0;
      /* Pc: bit    7  - error bit (0)
       *     bit  5-6  - reserved (0)
       *     bit  0-4  - data type (07 = MPEG2 AAC ADTS
       *                            19 = MPEG2 AAC ADTS half-rate LSF
       *                            51 = MPEG2 AAC ADTS quater-rate LSF */
      if (num_rd_blks == 1)
        dst[five] = 0x07;
      else if (num_rd_blks == 2)
        dst[five] = 0x13;
      else if (num_rd_blks == 4)
        dst[five] = 0x33;
      else
        g_return_val_if_reached (FALSE);

      /* Pd: bit 15-0  - frame size in bits */
      tmp = GST_ROUND_UP_2 (src_n) * 8;
      dst[six] = (guint8) (tmp >> 8);
      dst[seven] = (guint8) (tmp & 0xff);
      break;
    }

    default:
      return FALSE;
  }

  /* Copy the payload */
  i = 8;

  if (G_BYTE_ORDER == endianness) {
    memcpy (dst + i, src, src_n);
  } else {
    /* Byte-swapped again */
    /* FIXME: orc-ify this */
    for (tmp = 1; tmp < src_n; tmp += 2) {
      dst[i + tmp - 1] = src[tmp];
      dst[i + tmp] = src[tmp - 1];
    }
    /* Do we have 1 byte remaining? */
    if (src_n % 2) {
      dst[i + src_n - 1] = 0;
      dst[i + src_n] = src[src_n - 1];
      i++;
    }
  }

  i += src_n;

  /* Zero the rest */
  memset (dst + i, 0, dst_n - i);

  return TRUE;
}
