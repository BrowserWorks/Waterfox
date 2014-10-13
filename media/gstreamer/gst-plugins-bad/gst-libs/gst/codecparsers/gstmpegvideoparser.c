/* Gstreamer
 * Copyright (C) <2011> Intel Corporation
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
 *
 * From bad/sys/vdpau/mpeg/mpegutil.c:
 *   Copyright (C) <2007> Jan Schmidt <thaytan@mad.scientist.com>
 *   Copyright (C) <2009> Carl-Anton Ingmarsson <ca.ingmarsson@gmail.com>
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
 * SECTION:gstmpegvideoparser
 * @short_description: Convenience library for mpeg1 and 2 video
 * bitstream parsing.
 *
 * <refsect2>
 * <para>
 * Provides useful functions for mpeg videos bitstream parsing.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstmpegvideoparser.h"
#include "parserutils.h"

#include <string.h>
#include <gst/base/gstbitreader.h>
#include <gst/base/gstbytereader.h>

#define MARKER_BIT 0x1

/* default intra quant matrix, in zig-zag order */
static const guint8 default_intra_quantizer_matrix[64] = {
  8,
  16, 16,
  19, 16, 19,
  22, 22, 22, 22,
  22, 22, 26, 24, 26,
  27, 27, 27, 26, 26, 26,
  26, 27, 27, 27, 29, 29, 29,
  34, 34, 34, 29, 29, 29, 27, 27,
  29, 29, 32, 32, 34, 34, 37,
  38, 37, 35, 35, 34, 35,
  38, 38, 40, 40, 40,
  48, 48, 46, 46,
  56, 56, 58,
  69, 69,
  83
};

static const guint8 mpeg_zigzag_8x8[64] = {
  0, 1, 8, 16, 9, 2, 3, 10,
  17, 24, 32, 25, 18, 11, 4, 5,
  12, 19, 26, 33, 40, 48, 41, 34,
  27, 20, 13, 6, 7, 14, 21, 28,
  35, 42, 49, 56, 57, 50, 43, 36,
  29, 22, 15, 23, 30, 37, 44, 51,
  58, 59, 52, 45, 38, 31, 39, 46,
  53, 60, 61, 54, 47, 55, 62, 63
};

enum
{
  GST_MPEG_VIDEO_MACROBLOCK_ESCAPE = G_MAXUINT,
};

/* Table B-1: Variable length codes for macroblock_address_increment */
static const VLCTable mpeg2_mbaddr_vlc_table[] = {
  {1, 0x01, 1},
  {2, 0x03, 3},
  {3, 0x02, 3},
  {4, 0x03, 4},
  {5, 0x02, 4},
  {6, 0x03, 5},
  {7, 0x02, 5},
  {8, 0x07, 7},
  {9, 0x06, 7},
  {10, 0x0b, 8},
  {11, 0x0a, 8},
  {12, 0x09, 8},
  {13, 0x08, 8},
  {14, 0x07, 8},
  {15, 0x06, 8},
  {16, 0x17, 10},
  {17, 0x16, 10},
  {18, 0x15, 10},
  {19, 0x14, 10},
  {20, 0x13, 10},
  {21, 0x12, 10},
  {22, 0x23, 11},
  {23, 0x22, 11},
  {24, 0x21, 11},
  {25, 0x20, 11},
  {26, 0x1f, 11},
  {27, 0x1e, 11},
  {28, 0x1d, 11},
  {29, 0x1c, 11},
  {30, 0x1b, 11},
  {31, 0x1a, 11},
  {32, 0x19, 11},
  {33, 0x18, 11},
  {GST_MPEG_VIDEO_MACROBLOCK_ESCAPE, 0x08, 11}
};

GST_DEBUG_CATEGORY (mpegvideo_parser_debug);
#define GST_CAT_DEFAULT mpegvideo_parser_debug

#define INITIALIZE_DEBUG_CATEGORY \
  GST_DEBUG_CATEGORY_INIT (mpegvideo_parser_debug, "codecparsers_mpegvideo", \
      0, "Mpegvideo parser library");


/* Set the Pixel Aspect Ratio in our hdr from a ASR code in the data */
static void
set_par_from_asr_mpeg1 (GstMpegVideoSequenceHdr * seqhdr, guint8 asr_code)
{
  int ratios[16][2] = {
    {0, 0},                     /* 0, Invalid */
    {1, 1},                     /* 1, 1.0 */
    {10000, 6735},              /* 2, 0.6735 */
    {64, 45},                   /* 3, 0.7031 16:9 625 line */
    {10000, 7615},              /* 4, 0.7615 */
    {10000, 8055},              /* 5, 0.8055 */
    {32, 27},                   /* 6, 0.8437 */
    {10000, 8935},              /* 7, 0.8935 */
    {10000, 9375},              /* 8, 0.9375 */
    {10000, 9815},              /* 9, 0.9815 */
    {10000, 10255},             /* 10, 1.0255 */
    {10000, 10695},             /* 11, 1.0695 */
    {8, 9},                     /* 12, 1.125 */
    {10000, 11575},             /* 13, 1.1575 */
    {10000, 12015},             /* 14, 1.2015 */
    {0, 0},                     /* 15, invalid */
  };
  asr_code &= 0xf;

  seqhdr->par_w = ratios[asr_code][0];
  seqhdr->par_h = ratios[asr_code][1];
}

static void
set_fps_from_code (GstMpegVideoSequenceHdr * seqhdr, guint8 fps_code)
{
  const gint framerates[][2] = {
    {30, 1}, {24000, 1001}, {24, 1}, {25, 1},
    {30000, 1001}, {30, 1}, {50, 1}, {60000, 1001},
    {60, 1}, {30, 1}
  };

  if (fps_code && fps_code < 10) {
    seqhdr->fps_n = framerates[fps_code][0];
    seqhdr->fps_d = framerates[fps_code][1];
  } else {
    GST_DEBUG ("unknown/invalid frame_rate_code %d", fps_code);
    /* Force a valid framerate */
    /* FIXME or should this be kept unknown ?? */
    seqhdr->fps_n = 30000;
    seqhdr->fps_d = 1001;
  }
}

/* @size and @offset are wrt current reader position */
static inline gint
scan_for_start_codes (const GstByteReader * reader, guint offset, guint size)
{
  const guint8 *data;
  guint i = 0;

  g_assert ((guint64) offset + size <= reader->size - reader->byte);

  /* we can't find the pattern with less than 4 bytes */
  if (G_UNLIKELY (size < 4))
    return -1;

  data = reader->data + reader->byte + offset;

  while (i <= (size - 4)) {
    if (data[i + 2] > 1) {
      i += 3;
    } else if (data[i + 1]) {
      i += 2;
    } else if (data[i] || data[i + 2] != 1) {
      i++;
    } else {
      break;
    }
  }

  if (i <= (size - 4))
    return offset + i;

  /* nothing found */
  return -1;
}

/****** API *******/

/**
 * gst_mpeg_video_parse:
 * @packet: a #GstMpegVideoPacket to fill with the data and offset of the
 *     next packet found
 * @data: The data to parse
 * @size: The size of @data
 * @offset: The offset from which to start parsing
 *
 * Parses the MPEG 1/2 video bitstream contained in @data, and returns the
 * offset, and if known also the size, in @packet. This function will scan
 * the data to find the next packet if needed.
 *
 * Returns: TRUE if a packet start code was found, otherwise FALSE.
 */
gboolean
gst_mpeg_video_parse (GstMpegVideoPacket * packet,
    const guint8 * data, gsize size, guint offset)
{
  gint off;
  GstByteReader br;

  INITIALIZE_DEBUG_CATEGORY;

  if (size <= offset) {
    GST_DEBUG ("Can't parse from offset %d, buffer is to small", offset);
    return FALSE;
  }

  size -= offset;
  gst_byte_reader_init (&br, &data[offset], size);

  off = scan_for_start_codes (&br, 0, size);

  if (off < 0) {
    GST_DEBUG ("No start code prefix in this buffer");
    return FALSE;
  }

  if (gst_byte_reader_skip (&br, off + 3) == FALSE)
    goto failed;

  if (gst_byte_reader_get_uint8 (&br, &packet->type) == FALSE)
    goto failed;

  packet->data = data;
  packet->offset = offset + off + 4;
  packet->size = -1;

  /* try to find end of packet */
  size -= off + 4;
  off = scan_for_start_codes (&br, 0, size);

  if (off > 0)
    packet->size = off;

  return TRUE;

failed:
  {
    GST_WARNING ("Failed to parse");
    return FALSE;
  }
}

/**
 * gst_mpeg_video_packet_parse_sequence_header:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @seqhdr: (out): The #GstMpegVideoSequenceHdr structure to fill
 *
 * Parses the @seqhdr MPEG Video Sequence Header structure members
 * from video @packet
 *
 * Returns: %TRUE if the seqhdr could be parsed correctly, %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_sequence_header (const GstMpegVideoPacket * packet,
    GstMpegVideoSequenceHdr * seqhdr)
{
  GstBitReader br;
  guint8 bits;
  guint8 load_intra_flag, load_non_intra_flag;

  g_return_val_if_fail (seqhdr != NULL, FALSE);

  if (packet->size < 8)
    return FALSE;

  INITIALIZE_DEBUG_CATEGORY;

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  /* Setting the height/width codes */
  READ_UINT16 (&br, seqhdr->width, 12);
  READ_UINT16 (&br, seqhdr->height, 12);

  READ_UINT8 (&br, seqhdr->aspect_ratio_info, 4);
  /* Interpret PAR according to MPEG-1. Needs to be reinterpreted
   * later, if a sequence_display extension is seen */
  set_par_from_asr_mpeg1 (seqhdr, seqhdr->aspect_ratio_info);

  READ_UINT8 (&br, seqhdr->frame_rate_code, 4);
  set_fps_from_code (seqhdr, seqhdr->frame_rate_code);

  READ_UINT32 (&br, seqhdr->bitrate_value, 18);
  if (seqhdr->bitrate_value == 0x3ffff) {
    /* VBR stream */
    seqhdr->bitrate = 0;
  } else {
    /* Value in header is in units of 400 bps */
    seqhdr->bitrate = seqhdr->bitrate_value * 400;
  }

  READ_UINT8 (&br, bits, 1);
  if (bits != MARKER_BIT)
    goto failed;

  /* VBV buffer size */
  READ_UINT16 (&br, seqhdr->vbv_buffer_size_value, 10);

  /* constrained_parameters_flag */
  READ_UINT8 (&br, seqhdr->constrained_parameters_flag, 1);

  /* load_intra_quantiser_matrix */
  READ_UINT8 (&br, load_intra_flag, 1);
  if (load_intra_flag) {
    gint i;
    for (i = 0; i < 64; i++)
      READ_UINT8 (&br, seqhdr->intra_quantizer_matrix[i], 8);
  } else
    memcpy (seqhdr->intra_quantizer_matrix, default_intra_quantizer_matrix, 64);

  /* non intra quantizer matrix */
  READ_UINT8 (&br, load_non_intra_flag, 1);
  if (load_non_intra_flag) {
    gint i;
    for (i = 0; i < 64; i++)
      READ_UINT8 (&br, seqhdr->non_intra_quantizer_matrix[i], 8);
  } else
    memset (seqhdr->non_intra_quantizer_matrix, 16, 64);

  /* dump some info */
  GST_LOG ("width x height: %d x %d", seqhdr->width, seqhdr->height);
  GST_LOG ("fps: %d/%d", seqhdr->fps_n, seqhdr->fps_d);
  GST_LOG ("par: %d/%d", seqhdr->par_w, seqhdr->par_h);
  GST_LOG ("bitrate: %d", seqhdr->bitrate);

  return TRUE;

  /* ERRORS */
failed:
  {
    GST_WARNING ("Failed to parse sequence header");
    /* clear out stuff */
    memset (seqhdr, 0, sizeof (*seqhdr));
    return FALSE;
  }
}

/**
 * gst_mpeg_video_packet_parse_sequence_extension:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @seqext: (out): The #GstMpegVideoSequenceExt structure to fill
 *
 * Parses the @seqext MPEG Video Sequence Extension structure members
 * from video @packet
 *
 * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_sequence_extension (const GstMpegVideoPacket *
    packet, GstMpegVideoSequenceExt * seqext)
{
  GstBitReader br;

  g_return_val_if_fail (seqext != NULL, FALSE);

  if (packet->size < 6) {
    GST_DEBUG ("not enough bytes to parse the extension");
    return FALSE;
  }

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
      GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE) {
    GST_DEBUG ("Not parsing a sequence extension");
    return FALSE;
  }

  /* skip profile and level escape bit */
  gst_bit_reader_skip_unchecked (&br, 1);

  seqext->profile = gst_bit_reader_get_bits_uint8_unchecked (&br, 3);
  seqext->level = gst_bit_reader_get_bits_uint8_unchecked (&br, 4);

  /* progressive */
  seqext->progressive = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);

  /* chroma format */
  seqext->chroma_format = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);

  /* resolution extension */
  seqext->horiz_size_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
  seqext->vert_size_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);

  seqext->bitrate_ext = gst_bit_reader_get_bits_uint16_unchecked (&br, 12);

  /* skip marker bits */
  gst_bit_reader_skip_unchecked (&br, 1);

  seqext->vbv_buffer_size_extension =
      gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
  seqext->low_delay = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);

  /* framerate extension */
  seqext->fps_n_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
  seqext->fps_d_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);

  return TRUE;
}

/**
 * gst_mpeg_video_packet_parse_sequence_display_extension:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @seqdisplayext: (out): The #GstMpegVideoSequenceDisplayExt
 *   structure to fill
 *
 * Parses the @seqext MPEG Video Sequence Display Extension structure
 * members from video @packet
 *
 * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_sequence_display_extension (const GstMpegVideoPacket
    * packet, GstMpegVideoSequenceDisplayExt * seqdisplayext)
{
  GstBitReader br;

  g_return_val_if_fail (seqdisplayext != NULL, FALSE);

  if (packet->size < 5) {
    GST_DEBUG ("not enough bytes to parse the extension");
    return FALSE;
  }

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
      GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY) {
    GST_DEBUG ("Not parsing a sequence display extension");
    return FALSE;
  }

  seqdisplayext->video_format =
      gst_bit_reader_get_bits_uint8_unchecked (&br, 3);
  seqdisplayext->colour_description_flag =
      gst_bit_reader_get_bits_uint8_unchecked (&br, 1);

  if (seqdisplayext->colour_description_flag) {
    seqdisplayext->colour_primaries =
        gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
    seqdisplayext->transfer_characteristics =
        gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
    seqdisplayext->matrix_coefficients =
        gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
  }

  if (gst_bit_reader_get_remaining (&br) < 29) {
    GST_DEBUG ("Not enough remaining bytes to parse the extension");
    return FALSE;
  }

  seqdisplayext->display_horizontal_size =
      gst_bit_reader_get_bits_uint16_unchecked (&br, 14);
  /* skip marker bit */
  gst_bit_reader_skip_unchecked (&br, 1);
  seqdisplayext->display_vertical_size =
      gst_bit_reader_get_bits_uint16_unchecked (&br, 14);

  return TRUE;
}

/**
 * gst_mpeg_video_packet_parse_sequence_scalable_extension:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @seqscaleext: (out): The #GstMpegVideoSequenceScalableExt structure to fill
 *
 * Parses the @seqscaleext MPEG Video Sequence Scalable Extension structure
 * members from video @packet
 *
 * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
    gst_mpeg_video_packet_parse_sequence_scalable_extension
    (const GstMpegVideoPacket * packet,
    GstMpegVideoSequenceScalableExt * seqscaleext) {
  GstBitReader br;

  g_return_val_if_fail (seqscaleext != NULL, FALSE);

  if (packet->size < 2) {
    GST_DEBUG ("not enough bytes to parse the extension");
    return FALSE;
  }

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
      GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE) {
    GST_DEBUG ("Not parsing a sequence scalable extension");
    return FALSE;
  }

  READ_UINT8 (&br, seqscaleext->scalable_mode, 2);
  READ_UINT8 (&br, seqscaleext->layer_id, 4);

  if (seqscaleext->scalable_mode == GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SPATIAL) {
    READ_UINT16 (&br, seqscaleext->lower_layer_prediction_horizontal_size, 14);

    SKIP (&br, 1);

    READ_UINT16 (&br, seqscaleext->lower_layer_prediction_vertical_size, 14);

    READ_UINT8 (&br, seqscaleext->horizontal_subsampling_factor_m, 5);
    READ_UINT8 (&br, seqscaleext->horizontal_subsampling_factor_n, 5);
    READ_UINT8 (&br, seqscaleext->vertical_subsampling_factor_m, 5);
    READ_UINT8 (&br, seqscaleext->vertical_subsampling_factor_n, 5);
  }

  if (seqscaleext->scalable_mode == GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_TEMPORAL) {
    READ_UINT8 (&br, seqscaleext->picture_mux_enable, 1);
    if (seqscaleext->picture_mux_enable)
      READ_UINT8 (&br, seqscaleext->mux_to_progressive_sequence, 1);
    READ_UINT8 (&br, seqscaleext->picture_mux_order, 3);
    READ_UINT8 (&br, seqscaleext->picture_mux_factor, 3);
  }

  return TRUE;

failed:
  GST_WARNING ("error parsing \"Sequence Scalable Extension\"");
  return FALSE;
}

gboolean
gst_mpeg_video_finalise_mpeg2_sequence_header (GstMpegVideoSequenceHdr * seqhdr,
    GstMpegVideoSequenceExt * seqext,
    GstMpegVideoSequenceDisplayExt * displayext)
{
  guint32 w;
  guint32 h;

  if (seqext) {
    seqhdr->fps_n = seqhdr->fps_n * (seqext->fps_n_ext + 1);
    seqhdr->fps_d = seqhdr->fps_d * (seqext->fps_d_ext + 1);
    /* Extend width and height to 14 bits by adding the extension bits */
    seqhdr->width |= (seqext->horiz_size_ext << 12);
    seqhdr->height |= (seqext->vert_size_ext << 12);
    seqhdr->bitrate += (seqext->bitrate_ext << 18) * 400;
  }

  w = seqhdr->width;
  h = seqhdr->height;
  if (displayext) {
    /* Use the display size for calculating PAR when display ext present.
     * But we are handling this like what DVD players are doing. Which means,
     * ignore the display extension values if they are greater than the width/height
     * values provided by seqhdr and calculate the PAR based on the seqhdr values. */
    if (displayext->display_horizontal_size < w)
      w = displayext->display_horizontal_size;
    if (displayext->display_vertical_size < h)
      h = displayext->display_vertical_size;
  }

  /* Pixel_width = DAR_width * display_vertical_size */
  /* Pixel_height = DAR_height * display_horizontal_size */
  switch (seqhdr->aspect_ratio_info) {
    case 0x01:                 /* Square pixels */
      seqhdr->par_w = seqhdr->par_h = 1;
      break;
    case 0x02:                 /* 3:4 DAR = 4:3 pixels */
      seqhdr->par_w = 4 * h;
      seqhdr->par_h = 3 * w;
      break;
    case 0x03:                 /* 9:16 DAR */
      seqhdr->par_w = 16 * h;
      seqhdr->par_h = 9 * w;
      break;
    case 0x04:                 /* 1:2.21 DAR */
      seqhdr->par_w = 221 * h;
      seqhdr->par_h = 100 * w;
      break;
    default:
      GST_DEBUG ("unknown/invalid aspect_ratio_information %d",
          seqhdr->aspect_ratio_info);
      break;
  }

  return TRUE;
}

/**
 * gst_mpeg_video_packet_parse_quant_matrix_extension:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @quant: (out): The #GstMpegVideoQuantMatrixExt structure to fill
 *
 * Parses the @quant MPEG Video Quantization Matrix Extension
 * structure members from video @packet
 *
 * Returns: %TRUE if the quant matrix extension could be parsed correctly,
 * %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_quant_matrix_extension (const GstMpegVideoPacket *
    packet, GstMpegVideoQuantMatrixExt * quant)
{
  guint8 i;
  GstBitReader br;

  g_return_val_if_fail (quant != NULL, FALSE);

  if (packet->size < 1) {
    GST_DEBUG ("not enough bytes to parse the extension");
    return FALSE;
  }

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
      GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX) {
    GST_DEBUG ("Not parsing a quant matrix extension");
    return FALSE;
  }

  READ_UINT8 (&br, quant->load_intra_quantiser_matrix, 1);
  if (quant->load_intra_quantiser_matrix) {
    for (i = 0; i < 64; i++) {
      READ_UINT8 (&br, quant->intra_quantiser_matrix[i], 8);
    }
  }

  READ_UINT8 (&br, quant->load_non_intra_quantiser_matrix, 1);
  if (quant->load_non_intra_quantiser_matrix) {
    for (i = 0; i < 64; i++) {
      READ_UINT8 (&br, quant->non_intra_quantiser_matrix[i], 8);
    }
  }

  READ_UINT8 (&br, quant->load_chroma_intra_quantiser_matrix, 1);
  if (quant->load_chroma_intra_quantiser_matrix) {
    for (i = 0; i < 64; i++) {
      READ_UINT8 (&br, quant->chroma_intra_quantiser_matrix[i], 8);
    }
  }

  READ_UINT8 (&br, quant->load_chroma_non_intra_quantiser_matrix, 1);
  if (quant->load_chroma_non_intra_quantiser_matrix) {
    for (i = 0; i < 64; i++) {
      READ_UINT8 (&br, quant->chroma_non_intra_quantiser_matrix[i], 8);
    }
  }

  return TRUE;

failed:
  GST_WARNING ("error parsing \"Quant Matrix Extension\"");
  return FALSE;
}

/**
 * gst_mpeg_video_packet_parse_picture_extension:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @ext: (out): The #GstMpegVideoPictureExt structure to fill
 *
 * Parse the @ext MPEG Video Picture Extension structure members from
 * video @packet
 *
 * Returns: %TRUE if the picture extension could be parsed correctly,
 * %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_picture_extension (const GstMpegVideoPacket *
    packet, GstMpegVideoPictureExt * ext)
{
  GstBitReader br;

  g_return_val_if_fail (ext != NULL, FALSE);

  if (packet->size < 5)
    return FALSE;

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
      GST_MPEG_VIDEO_PACKET_EXT_PICTURE) {
    GST_DEBUG ("Extension is not a picture extension");
    return FALSE;
  }

  /* f_code */
  READ_UINT8 (&br, ext->f_code[0][0], 4);
  READ_UINT8 (&br, ext->f_code[0][1], 4);
  READ_UINT8 (&br, ext->f_code[1][0], 4);
  READ_UINT8 (&br, ext->f_code[1][1], 4);

  /* intra DC precision */
  READ_UINT8 (&br, ext->intra_dc_precision, 2);

  /* picture structure */
  READ_UINT8 (&br, ext->picture_structure, 2);

  /* top field first */
  READ_UINT8 (&br, ext->top_field_first, 1);

  /* frame pred frame dct */
  READ_UINT8 (&br, ext->frame_pred_frame_dct, 1);

  /* concealment motion vectors */
  READ_UINT8 (&br, ext->concealment_motion_vectors, 1);

  /* q scale type */
  READ_UINT8 (&br, ext->q_scale_type, 1);

  /* intra vlc format */
  READ_UINT8 (&br, ext->intra_vlc_format, 1);

  /* alternate scan */
  READ_UINT8 (&br, ext->alternate_scan, 1);

  /* repeat first field */
  READ_UINT8 (&br, ext->repeat_first_field, 1);

  /* chroma_420_type */
  READ_UINT8 (&br, ext->chroma_420_type, 1);

  /* progressive_frame */
  READ_UINT8 (&br, ext->progressive_frame, 1);

  /* composite display */
  READ_UINT8 (&br, ext->composite_display, 1);

  if (ext->composite_display) {

    /* v axis */
    READ_UINT8 (&br, ext->v_axis, 1);

    /* field sequence */
    READ_UINT8 (&br, ext->field_sequence, 3);

    /* sub carrier */
    READ_UINT8 (&br, ext->sub_carrier, 1);

    /* burst amplitude */
    READ_UINT8 (&br, ext->burst_amplitude, 7);

    /* sub_carrier phase */
    READ_UINT8 (&br, ext->sub_carrier_phase, 8);
  }

  return TRUE;

failed:
  GST_WARNING ("error parsing \"Picture Coding Extension\"");
  return FALSE;

}

/**
 * gst_mpeg_video_packet_parse_picture_header:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @pichdr: (out): The #GstMpegVideoPictureHdr structure to fill
 *
 * Parsers the @pichdr MPEG Video Picture Header structure members
 * from video @packet
 *
 * Returns: %TRUE if the picture sequence could be parsed correctly, %FALSE
 * otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_picture_header (const GstMpegVideoPacket * packet,
    GstMpegVideoPictureHdr * hdr)
{
  GstBitReader br;

  if (packet->size < 4)
    goto failed;

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  /* temperal sequence number */
  if (!gst_bit_reader_get_bits_uint16 (&br, &hdr->tsn, 10))
    goto failed;


  /* frame type */
  if (!gst_bit_reader_get_bits_uint8 (&br, (guint8 *) & hdr->pic_type, 3))
    goto failed;


  if (hdr->pic_type == 0 || hdr->pic_type > 4)
    goto bad_pic_type;          /* Corrupted picture packet */

  /* skip VBV delay */
  if (!gst_bit_reader_skip (&br, 16))
    goto failed;

  if (hdr->pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_P
      || hdr->pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_B) {

    READ_UINT8 (&br, hdr->full_pel_forward_vector, 1);

    READ_UINT8 (&br, hdr->f_code[0][0], 3);
    hdr->f_code[0][1] = hdr->f_code[0][0];
  } else {
    hdr->full_pel_forward_vector = 0;
    hdr->f_code[0][0] = hdr->f_code[0][1] = 0;
  }

  if (hdr->pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_B) {
    READ_UINT8 (&br, hdr->full_pel_backward_vector, 1);

    READ_UINT8 (&br, hdr->f_code[1][0], 3);
    hdr->f_code[1][1] = hdr->f_code[1][0];
  } else {
    hdr->full_pel_backward_vector = 0;
    hdr->f_code[1][0] = hdr->f_code[1][1] = 0;
  }

  return TRUE;

bad_pic_type:
  {
    GST_WARNING ("Unsupported picture type : %d", hdr->pic_type);
    return FALSE;
  }

failed:
  {
    GST_WARNING ("Not enough data to parse picture header");
    return FALSE;
  }
}

/**
 * gst_mpeg_video_packet_parse_gop:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @gop: (out): The #GstMpegVideoGop structure to fill
 *
 * Parses the @gop MPEG Video Group of Picture structure members from
 * video @packet
 *
 * Returns: %TRUE if the gop could be parsed correctly, %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_gop (const GstMpegVideoPacket * packet,
    GstMpegVideoGop * gop)
{
  GstBitReader br;

  g_return_val_if_fail (gop != NULL, FALSE);

  if (packet->size < 4)
    return FALSE;

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  READ_UINT8 (&br, gop->drop_frame_flag, 1);

  READ_UINT8 (&br, gop->hour, 5);

  READ_UINT8 (&br, gop->minute, 6);

  /* skip unused bit */
  if (!gst_bit_reader_skip (&br, 1))
    return FALSE;

  READ_UINT8 (&br, gop->second, 6);

  READ_UINT8 (&br, gop->frame, 6);

  READ_UINT8 (&br, gop->closed_gop, 1);

  READ_UINT8 (&br, gop->broken_link, 1);

  return TRUE;

failed:
  GST_WARNING ("error parsing \"GOP\"");
  return FALSE;
}

/**
 * gst_mpeg_video_packet_parse_slice_header:
 * @packet: The #GstMpegVideoPacket that carries the data
 * @slice_hdr: (out): The #GstMpegVideoSliceHdr structure to fill
 * @seqhdr: The #GstMpegVideoSequenceHdr header
 * @seqscaleext: The #GstMpegVideoSequenceScalableExt header
 *
 * Parses the @GstMpegVideoSliceHdr  structure members from @data
 *
 * Returns: %TRUE if the slice could be parsed correctly, %FALSE otherwize.
 *
 * Since: 1.2
 */
gboolean
gst_mpeg_video_packet_parse_slice_header (const GstMpegVideoPacket * packet,
    GstMpegVideoSliceHdr * slice_hdr, GstMpegVideoSequenceHdr * seqhdr,
    GstMpegVideoSequenceScalableExt * seqscaleext)
{
  GstBitReader br;
  guint height;
  guint mb_inc;
  guint8 bits, extra_bits;
  guint8 vertical_position, vertical_position_extension = 0;

  g_return_val_if_fail (seqhdr != NULL, FALSE);

  if (packet->size < 1)
    return FALSE;

  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);

  if (packet->type < GST_MPEG_VIDEO_PACKET_SLICE_MIN ||
      packet->type > GST_MPEG_VIDEO_PACKET_SLICE_MAX) {
    GST_DEBUG ("Not parsing a slice");
    return FALSE;
  }
  vertical_position = packet->type - GST_MPEG_VIDEO_PACKET_SLICE_MIN;

  height = seqhdr->height;
  if (height > 2800)
    READ_UINT8 (&br, vertical_position_extension, 3);

  if (seqscaleext)
    if (seqscaleext->scalable_mode ==
        GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_DATA_PARTITIONING)
      READ_UINT8 (&br, slice_hdr->priority_breakpoint, 7);

  READ_UINT8 (&br, slice_hdr->quantiser_scale_code, 5);

  READ_UINT8 (&br, extra_bits, 1);
  if (!extra_bits)
    slice_hdr->intra_slice = 0;
  else {
    READ_UINT8 (&br, slice_hdr->intra_slice, 1);
    SKIP (&br, 1);
    READ_UINT8 (&br, slice_hdr->slice_picture_id, 6);

    READ_UINT8 (&br, bits, 1);
    while (bits) {
      READ_UINT8 (&br, extra_bits, 8);
      READ_UINT8 (&br, bits, 1);
    }
  }

  slice_hdr->header_size = gst_bit_reader_get_pos (&br);

  if (height > 2800)
    slice_hdr->mb_row = (vertical_position_extension << 7) + vertical_position;
  else
    slice_hdr->mb_row = vertical_position;

  slice_hdr->mb_column = -1;
  do {
    if (!decode_vlc (&br, &mb_inc, mpeg2_mbaddr_vlc_table,
            G_N_ELEMENTS (mpeg2_mbaddr_vlc_table))) {
      GST_WARNING ("failed to decode first macroblock_address_increment");
      goto failed;
    }
    slice_hdr->mb_column +=
        mb_inc == GST_MPEG_VIDEO_MACROBLOCK_ESCAPE ? 33 : mb_inc;
  } while (mb_inc == GST_MPEG_VIDEO_MACROBLOCK_ESCAPE);

  return TRUE;

failed:
  GST_WARNING ("error parsing \"Slice\"");
  return FALSE;
}

/**
 * gst_mpeg_video_quant_matrix_get_raster_from_zigzag:
 * @out_quant: (out): The resulting quantization matrix
 * @quant: The source quantization matrix
 *
 * Converts quantization matrix @quant from zigzag scan order to
 * raster scan order and store the resulting factors into @out_quant.
 *
 * Note: it is an error to pass the same table in both @quant and
 * @out_quant arguments.
 *
 * Since: 1.2
 */
void
gst_mpeg_video_quant_matrix_get_raster_from_zigzag (guint8 out_quant[64],
    const guint8 quant[64])
{
  guint i;

  g_return_if_fail (out_quant != quant);

  for (i = 0; i < 64; i++)
    out_quant[mpeg_zigzag_8x8[i]] = quant[i];
}

/**
 * gst_mpeg_video_quant_matrix_get_zigzag_from_raster:
 * @out_quant: (out): The resulting quantization matrix
 * @quant: The source quantization matrix
 *
 * Converts quantization matrix @quant from raster scan order to
 * zigzag scan order and store the resulting factors into @out_quant.
 *
 * Note: it is an error to pass the same table in both @quant and
 * @out_quant arguments.
 *
 * Since: 1.2
 */
void
gst_mpeg_video_quant_matrix_get_zigzag_from_raster (guint8 out_quant[64],
    const guint8 quant[64])
{
  guint i;

  g_return_if_fail (out_quant != quant);

  for (i = 0; i < 64; i++)
    out_quant[i] = quant[mpeg_zigzag_8x8[i]];
}

/****** Deprecated API *******/

/**
 * gst_mpeg_video_parse_sequence_header:
 * @seqhdr: (out): The #GstMpegVideoSequenceHdr structure to fill
 * @data: The data from which to parse the sequence header
 * @size: The size of @data
 * @offset: The offset in byte from which to start parsing @data
 *
 * Parses the @seqhdr Mpeg Video Sequence Header structure members from @data
 *
 * Returns: %TRUE if the seqhdr could be parsed correctly, %FALSE otherwize.
 *
 * Deprecated: Use gst_mpeg_video_packet_parse_sequence_header() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_sequence_header (GstMpegVideoSequenceHdr * seqhdr,
    const guint8 * data, gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_sequence_header (GstMpegVideoSequenceHdr * seqhdr,
    const guint8 * data, gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_SEQUENCE;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_sequence_header (&packet, seqhdr);
}
#endif

/**
 * gst_mpeg_video_parse_sequence_extension:
 * @seqext: (out): The #GstMpegVideoSequenceExt structure to fill
 * @data: The data from which to parse the sequence extension
 * @size: The size of @data
 * @offset: The offset in byte from which to start parsing @data
 *
 * Parses the @seqext Mpeg Video Sequence Extension structure members from @data
 *
 * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
 *
 * Deprecated: Use gst_mpeg_video_packet_parse_sequence_extension() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_sequence_extension (GstMpegVideoSequenceExt * seqext,
    const guint8 * data, gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_sequence_extension (GstMpegVideoSequenceExt * seqext,
    const guint8 * data, gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_sequence_extension (&packet, seqext);
}
#endif

#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_sequence_display_extension (GstMpegVideoSequenceDisplayExt
    * seqdisplayext, const guint8 * data, gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_sequence_display_extension (GstMpegVideoSequenceDisplayExt
    * seqdisplayext, const guint8 * data, gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_sequence_display_extension (&packet,
      seqdisplayext);
}
#endif

/**
 * gst_mpeg_video_parse_quant_matrix_extension:
 * @quant: (out): The #GstMpegVideoQuantMatrixExt structure to fill
 * @data: The data from which to parse the Quantization Matrix extension
 * @size: The size of @data
 * @offset: The offset in byte from which to start the parsing
 *
 * Parses the @quant Mpeg Video Quant Matrix Extension structure members from
 * @data
 *
 * Returns: %TRUE if the quant matrix extension could be parsed correctly,
 * %FALSE otherwize.
 *
 * Deprecated: Use gst_mpeg_video_packet_parse_quant_matrix_extension() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_quant_matrix_extension (GstMpegVideoQuantMatrixExt * quant,
    const guint8 * data, gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_quant_matrix_extension (GstMpegVideoQuantMatrixExt * quant,
    const guint8 * data, gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_quant_matrix_extension (&packet, quant);
}
#endif

/**
 * gst_mpeg_video_parse_picture_header:
 * @hdr: (out): The #GstMpegVideoPictureHdr structure to fill
 * @data: The data from which to parse the picture header
 * @size: The size of @data
 * @offset: The offset in byte from which to start the parsing
 *
 * Parsers the @hdr Mpeg Video Picture Header structure members from @data
 *
 * Returns: %TRUE if the picture sequence could be parsed correctly, %FALSE
 * otherwize.
 *
 * Deprecated: Use gst_mpeg_video_packet_parse_picture_header() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_picture_header (GstMpegVideoPictureHdr * hdr,
    const guint8 * data, gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_picture_header (GstMpegVideoPictureHdr * hdr,
    const guint8 * data, gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_PICTURE;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_picture_header (&packet, hdr);
}
#endif

/**
 * gst_mpeg_video_parse_picture_extension:
 * @ext: (out): The #GstMpegVideoPictureExt structure to fill
 * @data: The data from which to parse the picture extension
 * @size: The size of @data
 * @offset: The offset in byte from which to start the parsing
 *
 * Parse the @ext Mpeg Video Picture Extension structure members from @data
 *
 * Returns: %TRUE if the picture extension could be parsed correctly,
 * %FALSE otherwize.
 *
 * Deprecated: Use gst_mpeg_video_packet_parse_picture_extension() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_picture_extension (GstMpegVideoPictureExt * ext,
    const guint8 * data, gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_picture_extension (GstMpegVideoPictureExt * ext,
    const guint8 * data, gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_picture_extension (&packet, ext);
}
#endif

/**
 * gst_mpeg_video_parse_gop:
 * @gop: (out): The #GstMpegVideoGop structure to fill
 * @data: The data from which to parse the gop
 * @size: The size of @data
 * @offset: The offset in byte from which to start the parsing
 *
 * Parses the @gop Mpeg Video Group of Picture structure members from @data
 *
 * Returns: %TRUE if the gop could be parsed correctly, %FALSE otherwize.
 *
 * Deprecated: Use gst_mpeg_video_packet_parse_gop() instead.
 */
#ifndef GST_REMOVE_DEPRECATED
#ifdef GST_DISABLE_DEPRECATED
gboolean
gst_mpeg_video_parse_gop (GstMpegVideoGop * gop, const guint8 * data,
    gsize size, guint offset);
#endif
gboolean
gst_mpeg_video_parse_gop (GstMpegVideoGop * gop, const guint8 * data,
    gsize size, guint offset)
{
  GstMpegVideoPacket packet;

  packet.data = data;
  packet.type = GST_MPEG_VIDEO_PACKET_GOP;
  packet.offset = offset;
  packet.size = size - offset;
  return gst_mpeg_video_packet_parse_gop (&packet, gop);
}
#endif
