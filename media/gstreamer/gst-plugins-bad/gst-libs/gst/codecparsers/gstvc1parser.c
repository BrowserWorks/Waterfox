/* Gstreamer
 * Copyright (C) <2011> Intel
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
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
 * SECTION:gstvc1parser
 * @short_description: Convenience library for parsing vc1 video
 * bitstream.
 *
 * For more details about the structures, look at the
 * smpte specifications (S421m-2006.pdf).
 *
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gstvc1parser.h"
#include "parserutils.h"
#include <gst/base/gstbytereader.h>
#include <gst/base/gstbitreader.h>
#include <string.h>

#ifndef GST_DISABLE_GST_DEBUG

#define GST_CAT_DEFAULT ensure_debug_category()

static GstDebugCategory *
ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    gsize cat_done;

    cat_done = (gsize) _gst_debug_category_new ("codecparsers_vc1", 0,
        "VC1 codec parsing library");

    g_once_init_leave (&cat_gonce, cat_done);
  }

  return (GstDebugCategory *) cat_gonce;
}

#else

#define ensure_debug_category() /* NOOP */

#endif /* GST_DISABLE_GST_DEBUG */

static const guint8 vc1_pquant_table[3][32] = {
  {                             /* Implicit quantizer */
        0, 1, 2, 3, 4, 5, 6, 7, 8, 6, 7, 8, 9, 10, 11, 12,
      13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 29, 31},
  {                             /* Explicit quantizer, pquantizer uniform */
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
      16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31},
  {                             /* Explicit quantizer, pquantizer non-uniform */
        0, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
      14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 29, 31}
};

static const guint8 vc1_mvmode_table[2][5] = {
  /* Table 47: P Picture High rate (PQUANT <= 12) MVMODE code table */
  {
        GST_VC1_MVMODE_1MV,
        GST_VC1_MVMODE_MIXED_MV,
        GST_VC1_MVMODE_1MV_HPEL,
        GST_VC1_MVMODE_INTENSITY_COMP,
      GST_VC1_MVMODE_1MV_HPEL_BILINEAR},
  /* Table 46: P Picture Low rate (PQUANT > 12) MVMODE code table */
  {
        GST_VC1_MVMODE_1MV_HPEL_BILINEAR,
        GST_VC1_MVMODE_1MV,
        GST_VC1_MVMODE_1MV_HPEL,
        GST_VC1_MVMODE_INTENSITY_COMP,
      GST_VC1_MVMODE_MIXED_MV}
};

static const guint8 vc1_mvmode2_table[2][4] = {
  /* Table 50: P Picture High rate (PQUANT <= 12) MVMODE2 code table */
  {
        GST_VC1_MVMODE_1MV,
        GST_VC1_MVMODE_MIXED_MV,
        GST_VC1_MVMODE_1MV_HPEL,
      GST_VC1_MVMODE_1MV_HPEL_BILINEAR},
  /* Table 49: P Picture Low rate (PQUANT > 12) MVMODE2 code table */
  {
        GST_VC1_MVMODE_1MV_HPEL_BILINEAR,
        GST_VC1_MVMODE_1MV,
        GST_VC1_MVMODE_1MV_HPEL,
      GST_VC1_MVMODE_MIXED_MV}
};

/* Table 40: BFRACTION VLC Table */
static const VLCTable vc1_bfraction_vlc_table[] = {
  {GST_VC1_BFRACTION_BASIS / 2, 0x00, 3},
  {GST_VC1_BFRACTION_BASIS / 3, 0x01, 3},
  {(GST_VC1_BFRACTION_BASIS * 2) / 3, 0x02, 3},
  {GST_VC1_BFRACTION_BASIS / 4, 0x02, 3},
  {(GST_VC1_BFRACTION_BASIS * 3) / 4, 0x04, 3},
  {GST_VC1_BFRACTION_BASIS / 5, 0x05, 3},
  {(GST_VC1_BFRACTION_BASIS * 2) / 5, 0x06, 3},
  {(GST_VC1_BFRACTION_BASIS * 3) / 5, 0x70, 7},
  {(GST_VC1_BFRACTION_BASIS * 4) / 5, 0x71, 7},
  {GST_VC1_BFRACTION_BASIS / 6, 0x72, 7},
  {(GST_VC1_BFRACTION_BASIS * 5) / 6, 0x73, 7},
  {GST_VC1_BFRACTION_BASIS / 7, 0x74, 7},
  {(GST_VC1_BFRACTION_BASIS * 2) / 7, 0x75, 7},
  {(GST_VC1_BFRACTION_BASIS * 3) / 7, 0x76, 7},
  {(GST_VC1_BFRACTION_BASIS * 4) / 7, 0x77, 7},
  {(GST_VC1_BFRACTION_BASIS * 5) / 7, 0x78, 7},
  {(GST_VC1_BFRACTION_BASIS * 6) / 7, 0x79, 7},
  {GST_VC1_BFRACTION_BASIS / 8, 0x7a, 7},
  {(GST_VC1_BFRACTION_BASIS * 3) / 8, 0x7b, 7},
  {(GST_VC1_BFRACTION_BASIS * 5) / 8, 0x7c, 7},
  {(GST_VC1_BFRACTION_BASIS * 7) / 8, 0x7d, 7},
  {GST_VC1_BFRACTION_RESERVED, 0x7e, 7},
  {GST_VC1_BFRACTION_PTYPE_BI, 0x7f, 7}
};

/* Imode types */
enum
{
  IMODE_RAW,
  IMODE_NORM2,
  IMODE_DIFF2,
  IMODE_NORM6,
  IMODE_DIFF6,
  IMODE_ROWSKIP,
  IMODE_COLSKIP
};

/* Table 69: IMODE VLC Codetable */
static const VLCTable vc1_imode_vlc_table[] = {
  {IMODE_NORM2, 0x02, 2},
  {IMODE_NORM6, 0x03, 2},
  {IMODE_ROWSKIP, 0x02, 3},
  {IMODE_COLSKIP, 0x03, 3},
  {IMODE_DIFF2, 0x01, 3},
  {IMODE_DIFF6, 0x01, 4},
  {IMODE_RAW, 0x00, 4}
};

/* Table 80: Norm-2/Diff-2 Code Table */
static const VLCTable vc1_norm2_vlc_table[4] = {
  {0, 0, 1},
  {2, 4, 3},
  {1, 5, 3},
  {3, 3, 2}
};

/* Table 81: Code table for 3x2 and 2x3 tiles */
static const VLCTable vc1_norm6_vlc_table[64] = {
  {0, 1, 1},
  {1, 2, 4},
  {2, 3, 4},
  {3, 0, 8},
  {4, 4, 4},
  {5, 1, 8},
  {6, 2, 8},
  {7, (2 << 5) | 7, 10},
  {8, 5, 4},
  {9, 3, 8},
  {10, 4, 8},
  {11, (2 << 5) | 11, 10},
  {12, 5, 8},
  {13, (2 << 5) | 13, 10},
  {14, (2 << 5) | 14, 10},
  {15, (3 << 8) | 14, 13},
  {16, 6, 4},
  {17, 6, 8},
  {18, 7, 8},
  {19, (2 << 5) | 19, 10},
  {20, 8, 8},
  {21, (2 << 5) | 21, 10},
  {22, (2 << 5) | 22, 10},
  {23, (3 << 8) | 13, 13},
  {24, 9, 8},
  {25, (2 << 5) | 25, 10},
  {26, (2 << 5) | 26, 10},
  {27, (3 << 8) | 12, 13},
  {28, (2 << 5) | 28, 10},
  {29, (3 << 8) | 11, 13},
  {30, (3 << 8) | 10, 13},
  {31, (3 << 4) | 7, 9},
  {32, 7, 4},
  {33, 10, 8},
  {34, 11, 8},
  {35, (2 << 5) | 3, 10},
  {36, 12, 8},
  {37, (2 << 5) | 5, 10},
  {38, (2 << 5) | 6, 10},
  {39, (3 << 8) | 9, 13},
  {40, 13, 8},
  {41, (2 << 5) | 9, 10},
  {42, (2 << 5) | 10, 10},
  {43, (3 << 8) | 8, 13},
  {44, (2 << 5) | 12, 10},
  {45, (3 << 8) | 7, 13},
  {46, (3 << 8) | 6, 13},
  {47, (3 << 4) | 6, 9},
  {48, 14, 8},
  {49, (2 << 5) | 17, 10},
  {50, (2 << 5) | 18, 10},
  {51, (3 << 8) | 5, 13},
  {52, (2 << 5) | 20, 10},
  {53, (3 << 8) | 4, 13},
  {54, (3 << 8) | 3, 13},
  {55, (3 << 4) | 5, 9},
  {56, (2 << 5) | 24, 10},
  {57, (3 << 8) | 2, 13},
  {58, (3 << 8) | 1, 13},
  {59, (3 << 4) | 4, 9},
  {60, (3 << 8) | 0, 13},
  {61, (3 << 4) | 3, 9},
  {62, (3 << 4) | 2, 9},
  {63, (3 << 1) | 1, 6}
};

/* SMPTE 421M Table 7 */
typedef struct
{
  gint par_n, par_d;
} PAR;

static PAR aspect_ratios[] = {
  {0, 0},
  {1, 1},
  {12, 11},
  {10, 11},
  {16, 11},
  {40, 33},
  {24, 11},
  {20, 11},
  {32, 11},
  {80, 33},
  {18, 11},
  {15, 11},
  {64, 33},
  {160, 99},
  {0, 0},
  {0, 0}
};

/* SMPTE 421M Table 8 */
static const guint framerates_n[] = {
  0,
  24 * 1000,
  25 * 1000,
  30 * 1000,
  50 * 1000,
  60 * 1000,
  48 * 1000,
  72 * 1000
};

/* SMPTE 421M Table 9 */
static const guint framerates_d[] = {
  0,
  1000,
  1001
};


static inline gboolean
decode_colskip (GstBitReader * br, guint8 * data, guint width, guint height,
    guint stride, guint invert)
{
  guint x, y;
  guint8 colskip, v;

  GST_DEBUG ("Parsing colskip");

  invert &= 1;
  for (x = 0; x < width; x++) {
    READ_UINT8 (br, colskip, 1);

    if (data) {
      if (colskip) {
        for (y = 0; y < height; y++) {
          READ_UINT8 (br, v, 1);
          data[y * stride] = v ^ invert;
        }
      } else {
        for (y = 0; y < height; y++)
          data[y * stride] = invert;
      }
      data++;
    } else if (colskip)
      SKIP (br, height);
  }

  return TRUE;

failed:
  GST_WARNING ("Failed to parse colskip");

  return FALSE;
}

static inline gboolean
decode_rowskip (GstBitReader * br, guint8 * data, guint width, guint height,
    guint stride, guint invert)
{
  guint x, y;
  guint8 rowskip, v;

  GST_DEBUG ("Parsing rowskip");

  invert &= 1;
  for (y = 0; y < height; y++) {
    READ_UINT8 (br, rowskip, 1);

    if (data) {
      if (!rowskip)
        memset (data, invert, width);
      else {
        for (x = 0; x < width; x++) {
          READ_UINT8 (br, v, 1);
          data[x] = v ^ invert;
        }
      }
      data += stride;
    } else if (rowskip)
      SKIP (br, width);
  }

  return TRUE;

failed:
  GST_WARNING ("Failed to parse rowskip");

  return FALSE;
}

static inline gint8
decode012 (GstBitReader * br)
{
  guint8 n;

  READ_UINT8 (br, n, 1);

  if (n == 0)
    return 0;

  READ_UINT8 (br, n, 1);

  return n + 1;

failed:
  GST_WARNING ("Could not decode 0 1 2 returning -1");

  return -1;
}

static inline guint
calculate_nb_pan_scan_win (GstVC1AdvancedSeqHdr * advseqhdr,
    GstVC1PicAdvanced * pic)
{
  if (advseqhdr->interlace && !advseqhdr->psf) {
    if (advseqhdr->pulldown)
      return pic->rff + 2;

    return 2;

  } else {
    if (advseqhdr->pulldown)
      return pic->rptfrm + 1;

    return 1;
  }
}

static gboolean
decode_refdist (GstBitReader * br, guint16 * value)
{
  guint16 tmp;
  gint i = 2;

  if (!gst_bit_reader_peek_bits_uint16 (br, &tmp, i))
    goto failed;

  if (tmp < 0x03) {
    READ_UINT16 (br, *value, i);

    return TRUE;
  }

  do {
    i++;

    if (!gst_bit_reader_peek_bits_uint16 (br, &tmp, i))
      goto failed;

    if (!(tmp >> i)) {
      READ_UINT16 (br, *value, i);

      return TRUE;
    }
  } while (i < 16);


failed:
  {
    GST_WARNING ("Could not decode end 0 returning");

    return FALSE;
  }
}

/*** bitplanes decoding ***/
static gboolean
bitplane_decoding (GstBitReader * br, guint8 * data,
    GstVC1SeqHdr * seqhdr, guint8 * is_raw)
{
  const guint width = seqhdr->mb_width;
  const guint height = seqhdr->mb_height;
  const guint stride = seqhdr->mb_stride;
  guint imode, invert, invert_mask;
  guint x, y, v, o;
  guint8 *pdata = data;

  *is_raw = FALSE;

  GET_BITS (br, 1, &invert);
  invert_mask = -invert;

  if (!decode_vlc (br, &imode, vc1_imode_vlc_table,
          G_N_ELEMENTS (vc1_imode_vlc_table)))
    goto failed;

  switch (imode) {
    case IMODE_RAW:

      GST_DEBUG ("Parsing IMODE_RAW");

      *is_raw = TRUE;
      return TRUE;

    case IMODE_DIFF2:
      invert_mask = 0;
      /* fall-through */
    case IMODE_NORM2:
      invert_mask &= 3;

      GST_DEBUG ("Parsing IMODE_DIFF2 or IMODE_NORM2 biplane");

      x = 0;
      o = (height * width) & 1;
      if (o) {
        GET_BITS (br, 1, &v);
        if (pdata) {
          *pdata++ = (v ^ invert_mask) & 1;
          if (++x == width) {
            x = 0;
            pdata += stride - width;
          }
        }
      }

      for (y = o; y < height * width; y += 2) {
        if (!decode_vlc (br, &v, vc1_norm2_vlc_table,
                G_N_ELEMENTS (vc1_norm2_vlc_table)))
          goto failed;
        if (pdata) {
          v ^= invert_mask;
          *pdata++ = v >> 1;
          if (++x == width) {
            x = 0;
            pdata += stride - width;
          }
          *pdata++ = v & 1;
          if (++x == width) {
            x = 0;
            pdata += stride - width;
          }
        }
      }
      break;

    case IMODE_DIFF6:
      invert_mask = 0;
      /* fall-through */
    case IMODE_NORM6:

      GST_DEBUG ("Parsing IMODE_DIFF6 or IMODE_NORM6 biplane");

      if (!(height % 3) && (width % 3)) {       /* decode 2x3 "vertical" tiles */
        for (y = 0; y < height; y += 3) {
          for (x = width & 1; x < width; x += 2) {
            if (!decode_vlc (br, &v, vc1_norm6_vlc_table,
                    G_N_ELEMENTS (vc1_norm6_vlc_table)))
              goto failed;

            if (pdata) {
              v ^= invert_mask;
              pdata[x + 0] = v & 1;
              pdata[x + 1] = (v >> 1) & 1;
              pdata[x + 0 + stride] = (v >> 2) & 1;
              pdata[x + 1 + stride] = (v >> 3) & 1;
              pdata[x + 0 + stride * 2] = (v >> 4) & 1;
              pdata[x + 1 + stride * 2] = (v >> 5) & 1;
            }
          }
          if (pdata)
            pdata += 3 * stride;
        }

        x = width & 1;
        y = 0;
      } else {                  /* decode 3x2 "horizontal" tiles */

        if (pdata)
          pdata += (height & 1) * stride;
        for (y = height & 1; y < height; y += 2) {
          for (x = width % 3; x < width; x += 3) {
            if (!decode_vlc (br, &v, vc1_norm6_vlc_table,
                    G_N_ELEMENTS (vc1_norm6_vlc_table)))
              goto failed;

            if (pdata) {
              v ^= invert_mask;
              pdata[x + 0] = v & 1;
              pdata[x + 1] = (v >> 1) & 1;
              pdata[x + 2] = (v >> 2) & 1;
              pdata[x + 0 + stride] = (v >> 3) & 1;
              pdata[x + 1 + stride] = (v >> 4) & 1;
              pdata[x + 2 + stride] = (v >> 5) & 1;
            }
          }
          if (pdata)
            pdata += 2 * stride;
        }

        x = width % 3;
        y = height & 1;
      }

      if (x) {
        if (data)
          pdata = data;
        if (!decode_colskip (br, pdata, x, height, stride, invert_mask))
          goto failed;
      }

      if (y) {
        if (data)
          pdata = data + x;
        if (!decode_rowskip (br, pdata, width - x, y, stride, invert_mask))
          goto failed;
      }
      break;
    case IMODE_ROWSKIP:

      GST_DEBUG ("Parsing IMODE_ROWSKIP biplane");

      if (!decode_rowskip (br, data, width, height, stride, invert_mask))
        goto failed;
      break;
    case IMODE_COLSKIP:

      GST_DEBUG ("Parsing IMODE_COLSKIP biplane");

      if (!decode_colskip (br, data, width, height, stride, invert_mask))
        goto failed;
      break;
  }

  if (!data)
    return TRUE;

  /* Applying diff operator */
  if (imode == IMODE_DIFF2 || imode == IMODE_DIFF6) {
    pdata = data;
    pdata[0] ^= invert;

    for (x = 1; x < width; x++)
      pdata[x] ^= pdata[x - 1];

    for (y = 1; y < height; y++) {
      pdata[stride] ^= pdata[0];

      for (x = 1; x < width; x++) {
        if (pdata[stride + x - 1] != pdata[x])
          pdata[stride + x] ^= invert;
        else
          pdata[stride + x] ^= pdata[stride + x - 1];
      }
      pdata += stride;
    }
  }

  return TRUE;

failed:
  GST_WARNING ("Failed to decode bitplane");

  return FALSE;
}

static gboolean
parse_vopdquant (GstBitReader * br, GstVC1FrameHdr * framehdr, guint8 dquant)
{
  GstVC1VopDquant *vopdquant = &framehdr->vopdquant;

  GST_DEBUG ("Parsing vopdquant");

  vopdquant->dqbilevel = 0;

  if (dquant == 2) {
    vopdquant->dquantfrm = 0;

    READ_UINT8 (br, vopdquant->pqdiff, 3);

    if (vopdquant->pqdiff != 7)
      vopdquant->altpquant = framehdr->pquant + vopdquant->pqdiff + 1;
    else {
      READ_UINT8 (br, vopdquant->abspq, 5);
      vopdquant->altpquant = vopdquant->abspq;
    }
  } else {
    READ_UINT8 (br, vopdquant->dquantfrm, 1);
    GST_DEBUG (" %u DquantFrm %u", gst_bit_reader_get_pos (br),
        vopdquant->dquantfrm);

    if (vopdquant->dquantfrm) {
      READ_UINT8 (br, vopdquant->dqprofile, 2);

      switch (vopdquant->dqprofile) {
        case GST_VC1_DQPROFILE_SINGLE_EDGE:
        case GST_VC1_DQPROFILE_DOUBLE_EDGES:
          READ_UINT8 (br, vopdquant->dqbedge, 2);
          break;

        case GST_VC1_DQPROFILE_ALL_MBS:
          READ_UINT8 (br, vopdquant->dqbilevel, 1);
          break;
      }

      if (vopdquant->dqbilevel
          || vopdquant->dqprofile != GST_VC1_DQPROFILE_ALL_MBS) {
        {
          READ_UINT8 (br, vopdquant->pqdiff, 3);

          if (vopdquant->pqdiff != 7)
            vopdquant->altpquant = framehdr->pquant + vopdquant->pqdiff + 1;
          else {
            READ_UINT8 (br, vopdquant->abspq, 5);
            vopdquant->altpquant = vopdquant->abspq;
          }
        }
      }
    }
  }

  return TRUE;

failed:
  GST_WARNING ("Failed to parse vopdquant");

  return FALSE;
}

static inline gint
scan_for_start_codes (const guint8 * data, guint size)
{
  GstByteReader br;
  gst_byte_reader_init (&br, data, size);

  /* NALU not empty, so we can at least expect 1 (even 2) bytes following sc */
  return gst_byte_reader_masked_scan_uint32 (&br, 0xffffff00, 0x00000100,
      0, size);
}

static inline gint
get_unary (GstBitReader * br, gint stop, gint len)
{
  int i;
  guint8 current = 0xff;

  for (i = 0; i < len; i++) {
    current = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
    if (current == stop)
      return i;
  }

  return i;
}

static inline void
calculate_framerate_bitrate (guint8 frmrtq_postproc, guint8 bitrtq_postproc,
    guint * framerate, guint * bitrate)
{
  if (frmrtq_postproc == 0 && bitrtq_postproc == 31) {
    *framerate = 0;
    *bitrate = 0;
  } else if (frmrtq_postproc == 0 && bitrtq_postproc == 30) {
    *framerate = 2;
    *bitrate = 1952;
  } else if (frmrtq_postproc == 1 && bitrtq_postproc == 31) {
    *framerate = 6;
    *bitrate = 2016;
  } else {
    if (frmrtq_postproc == 7) {
      *framerate = 30;
    } else {
      *framerate = 2 + (frmrtq_postproc * 4);
    }
    if (bitrtq_postproc == 31) {
      *bitrate = 2016;
    } else {
      *bitrate = 32 + (bitrtq_postproc * 64);
    }
  }
}

static inline void
calculate_mb_size (GstVC1SeqHdr * seqhdr, guint width, guint height)
{
  seqhdr->mb_width = (width + 15) >> 4;
  seqhdr->mb_height = (height + 15) >> 4;
  seqhdr->mb_stride = seqhdr->mb_width + 1;
}

static GstVC1ParserResult
parse_hrd_param_flag (GstBitReader * br, GstVC1HrdParam * hrd_param)
{
  guint i;

  GST_DEBUG ("Parsing Hrd param flag");


  if (gst_bit_reader_get_remaining (br) < 13)
    goto failed;

  hrd_param->hrd_num_leaky_buckets =
      gst_bit_reader_get_bits_uint8_unchecked (br, 5);
  hrd_param->bit_rate_exponent =
      gst_bit_reader_get_bits_uint8_unchecked (br, 4);
  hrd_param->buffer_size_exponent =
      gst_bit_reader_get_bits_uint8_unchecked (br, 4);

  if (gst_bit_reader_get_remaining (br) <
      (32 * hrd_param->hrd_num_leaky_buckets))
    goto failed;

  for (i = 0; i < hrd_param->hrd_num_leaky_buckets; i++) {
    hrd_param->hrd_rate[i] = gst_bit_reader_get_bits_uint16_unchecked (br, 16);
    hrd_param->hrd_buffer[i] =
        gst_bit_reader_get_bits_uint16_unchecked (br, 16);
  }

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse hrd param flag");

  return GST_VC1_PARSER_ERROR;
}

static GstVC1ParserResult
parse_sequence_header_advanced (GstVC1SeqHdr * seqhdr, GstBitReader * br)
{
  GstVC1AdvancedSeqHdr *advanced = &seqhdr->advanced;
  guint8 tmp;

  GST_DEBUG ("Parsing sequence header in advanced mode");

  READ_UINT8 (br, tmp, 3);
  advanced->level = tmp;
  advanced->par_n = 0;
  advanced->par_d = 0;
  advanced->fps_n = 0;
  advanced->fps_d = 0;

  READ_UINT8 (br, advanced->colordiff_format, 2);
  READ_UINT8 (br, advanced->frmrtq_postproc, 3);
  READ_UINT8 (br, advanced->bitrtq_postproc, 5);

  calculate_framerate_bitrate (advanced->frmrtq_postproc,
      advanced->bitrtq_postproc, &advanced->framerate, &advanced->bitrate);

  GST_DEBUG ("level %u, colordiff_format %u , frmrtq_postproc %u,"
      " bitrtq_postproc %u", advanced->level, advanced->colordiff_format,
      advanced->frmrtq_postproc, advanced->bitrtq_postproc);

  if (gst_bit_reader_get_remaining (br) < 32)
    goto failed;

  advanced->postprocflag = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  advanced->max_coded_width = gst_bit_reader_get_bits_uint16_unchecked (br, 12);
  advanced->max_coded_height =
      gst_bit_reader_get_bits_uint16_unchecked (br, 12);
  advanced->max_coded_width = (advanced->max_coded_width + 1) << 1;
  advanced->max_coded_height = (advanced->max_coded_height + 1) << 1;
  calculate_mb_size (seqhdr, advanced->max_coded_width,
      advanced->max_coded_height);
  advanced->pulldown = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  advanced->interlace = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  advanced->tfcntrflag = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  advanced->finterpflag = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

  GST_DEBUG ("postprocflag %u, max_coded_width %u, max_coded_height %u,"
      "pulldown %u, interlace %u, tfcntrflag %u, finterpflag %u",
      advanced->postprocflag, advanced->max_coded_width,
      advanced->max_coded_height, advanced->pulldown,
      advanced->interlace, advanced->tfcntrflag, advanced->finterpflag);

  /* Skipping reserved bit */
  gst_bit_reader_skip_unchecked (br, 1);

  advanced->psf = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  advanced->display_ext = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  if (advanced->display_ext) {
    READ_UINT16 (br, advanced->disp_horiz_size, 14);
    READ_UINT16 (br, advanced->disp_vert_size, 14);

    advanced->disp_horiz_size++;
    advanced->disp_vert_size++;

    READ_UINT8 (br, advanced->aspect_ratio_flag, 1);

    if (advanced->aspect_ratio_flag) {
      READ_UINT8 (br, advanced->aspect_ratio, 4);

      if (advanced->aspect_ratio == 15) {
        /* Aspect Width (6.1.14.3.2) and Aspect Height (6.1.14.3.3)
         * syntax elements hold a binary encoding of sizes ranging
         * from 1 to 256 */
        READ_UINT8 (br, advanced->aspect_horiz_size, 8);
        READ_UINT8 (br, advanced->aspect_vert_size, 8);
        advanced->par_n = 1 + advanced->aspect_horiz_size;
        advanced->par_d = 1 + advanced->aspect_vert_size;
      } else {
        advanced->par_n = aspect_ratios[advanced->aspect_ratio].par_n;
        advanced->par_d = aspect_ratios[advanced->aspect_ratio].par_d;
      }
    }
    READ_UINT8 (br, advanced->framerate_flag, 1);
    if (advanced->framerate_flag) {
      READ_UINT8 (br, advanced->framerateind, 1);

      if (!advanced->framerateind) {
        READ_UINT8 (br, advanced->frameratenr, 8);
        READ_UINT8 (br, advanced->frameratedr, 4);
      } else {
        READ_UINT16 (br, advanced->framerateexp, 16);
      }
      if (advanced->frameratenr > 0 &&
          advanced->frameratenr < 8 &&
          advanced->frameratedr > 0 && advanced->frameratedr < 3) {
        advanced->fps_n = framerates_n[advanced->frameratenr];
        advanced->fps_d = framerates_d[advanced->frameratedr];
      } else {
        advanced->fps_n = advanced->framerateexp + 1;
        advanced->fps_d = 32;
      }
    }
    READ_UINT8 (br, advanced->color_format_flag, 1);

    if (advanced->color_format_flag) {
      if (gst_bit_reader_get_remaining (br) < 24)
        goto failed;

      advanced->color_prim = gst_bit_reader_get_bits_uint8_unchecked (br, 8);
      advanced->transfer_char = gst_bit_reader_get_bits_uint8_unchecked (br, 8);
      advanced->matrix_coef = gst_bit_reader_get_bits_uint8_unchecked (br, 8);
    }
  }
  READ_UINT8 (br, advanced->hrd_param_flag, 1);
  if (advanced->hrd_param_flag)
    return parse_hrd_param_flag (br, &advanced->hrd_param);

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse advanced headers");

  return GST_VC1_PARSER_ERROR;
}

static GstVC1ParserResult
parse_frame_header_advanced (GstBitReader * br, GstVC1FrameHdr * framehdr,
    GstVC1SeqHdr * seqhdr, GstVC1BitPlanes * bitplanes, gboolean field2)
{
  GstVC1AdvancedSeqHdr *advhdr = &seqhdr->advanced;
  GstVC1PicAdvanced *pic = &framehdr->pic.advanced;
  GstVC1EntryPointHdr *entrypthdr = &advhdr->entrypoint;
  guint8 mvmodeidx;

  GST_DEBUG ("Parsing Frame header advanced %u", advhdr->interlace);

  /* Set the conveninence fields */
  framehdr->profile = seqhdr->profile;
  framehdr->dquant = entrypthdr->dquant;

  if (advhdr->interlace) {
    gint8 fcm = decode012 (br);

    if (fcm < 0)
      goto failed;

    pic->fcm = (guint8) fcm;
  } else
    pic->fcm = GST_VC1_FRAME_PROGRESSIVE;

  if (pic->fcm == GST_VC1_FIELD_INTERLACE) {
    READ_UINT8 (br, pic->fptype, 3);
    if (field2) {
      switch (pic->fptype) {
        case 0x00:
        case 0x02:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_I;
          break;
        case 0x01:
        case 0x03:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_P;
          break;
        case 0x04:
        case 0x06:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_B;
          break;
        case 0x05:
        case 0x07:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_BI;
          break;
      }
    } else {
      switch (pic->fptype) {
        case 0x00:
        case 0x01:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_I;
          break;
        case 0x02:
        case 0x03:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_P;
          break;
        case 0x04:
        case 0x05:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_B;
          break;
        case 0x06:
        case 0x07:
          framehdr->ptype = GST_VC1_PICTURE_TYPE_BI;
          break;
      }
    }
  } else
    framehdr->ptype = (guint8) get_unary (br, 0, 4);

  if (advhdr->tfcntrflag) {
    READ_UINT8 (br, pic->tfcntr, 8);
    GST_DEBUG ("tfcntr %u", pic->tfcntr);
  }

  if (advhdr->pulldown) {
    if (!advhdr->interlace || advhdr->psf) {

      READ_UINT8 (br, pic->rptfrm, 2);
      GST_DEBUG ("rptfrm %u", pic->rptfrm);

    } else {

      READ_UINT8 (br, pic->tff, 1);
      READ_UINT8 (br, pic->rff, 1);
      GST_DEBUG ("tff %u, rff %u", pic->tff, pic->rff);
    }
  }

  if (entrypthdr->panscan_flag) {
    READ_UINT8 (br, pic->ps_present, 1);

    if (pic->ps_present) {
      guint i, nb_pan_scan_win = calculate_nb_pan_scan_win (advhdr, pic);

      if (gst_bit_reader_get_remaining (br) < 64 * nb_pan_scan_win)
        goto failed;

      for (i = 0; i < nb_pan_scan_win; i++) {
        pic->ps_hoffset = gst_bit_reader_get_bits_uint32_unchecked (br, 18);
        pic->ps_voffset = gst_bit_reader_get_bits_uint32_unchecked (br, 18);
        pic->ps_width = gst_bit_reader_get_bits_uint16_unchecked (br, 14);
        pic->ps_height = gst_bit_reader_get_bits_uint16_unchecked (br, 14);
      }
    }
  }

  if (framehdr->ptype == GST_VC1_PICTURE_TYPE_SKIPPED)
    return GST_VC1_PARSER_OK;

  READ_UINT8 (br, pic->rndctrl, 1);

  if (advhdr->interlace) {
    READ_UINT8 (br, pic->uvsamp, 1);
    GST_DEBUG ("uvsamp %u", pic->uvsamp);
    if (pic->fcm == GST_VC1_FIELD_INTERLACE && entrypthdr->refdist_flag &&
        pic->fptype < 4)
      decode_refdist (br, &pic->refdist);
    else
      pic->refdist = 0;
  }

  if (advhdr->finterpflag) {
    READ_UINT8 (br, framehdr->interpfrm, 1);
    GST_DEBUG ("interpfrm %u", framehdr->interpfrm);
  }

  if ((pic->fcm != GST_VC1_FIELD_INTERLACE &&
          framehdr->ptype == GST_VC1_PICTURE_TYPE_B) ||
      (pic->fcm == GST_VC1_FIELD_INTERLACE && (pic->fptype > 4))) {

    guint bfraction;

    if (!decode_vlc (br, &bfraction, vc1_bfraction_vlc_table,
            G_N_ELEMENTS (vc1_bfraction_vlc_table)))
      goto failed;

    pic->bfraction = bfraction;
    GST_DEBUG ("bfraction %u", pic->bfraction);

    if (pic->bfraction == GST_VC1_BFRACTION_PTYPE_BI) {
      framehdr->ptype = GST_VC1_PICTURE_TYPE_BI;
    }

  }

  READ_UINT8 (br, framehdr->pqindex, 5);
  if (!framehdr->pqindex)
    goto failed;

  /* compute pquant */
  if (entrypthdr->quantizer == GST_VC1_QUANTIZER_IMPLICITLY)
    framehdr->pquant = vc1_pquant_table[0][framehdr->pqindex];
  else
    framehdr->pquant = vc1_pquant_table[1][framehdr->pqindex];

  framehdr->pquantizer = 1;
  if (entrypthdr->quantizer == GST_VC1_QUANTIZER_IMPLICITLY)
    framehdr->pquantizer = framehdr->pqindex < 9;
  if (entrypthdr->quantizer == GST_VC1_QUANTIZER_NON_UNIFORM)
    framehdr->pquantizer = 0;

  if (framehdr->pqindex <= 8)
    READ_UINT8 (br, framehdr->halfqp, 1);
  else
    framehdr->halfqp = 0;

  if (entrypthdr->quantizer == GST_VC1_QUANTIZER_EXPLICITLY) {
    READ_UINT8 (br, framehdr->pquantizer, 1);
  }

  if (advhdr->postprocflag)
    READ_UINT8 (br, pic->postproc, 2);

  GST_DEBUG ("Parsing %u picture, pqindex %u, pquant %u pquantizer %u"
      "halfqp %u", framehdr->ptype, framehdr->pqindex, framehdr->pquant,
      framehdr->pquantizer, framehdr->halfqp);

  switch (framehdr->ptype) {
    case GST_VC1_PICTURE_TYPE_I:
    case GST_VC1_PICTURE_TYPE_BI:
      if (pic->fcm == GST_VC1_FRAME_INTERLACE) {
        if (!bitplane_decoding (br, bitplanes ? bitplanes->fieldtx : NULL,
                seqhdr, &pic->fieldtx))
          goto failed;
      }

      if (!bitplane_decoding (br, bitplanes ? bitplanes->acpred : NULL,
              seqhdr, &pic->acpred))
        goto failed;

      if (entrypthdr->overlap && framehdr->pquant <= 8) {
        pic->condover = decode012 (br);

        if (pic->condover == (guint8) - 1)
          goto failed;

        else if (pic->condover == GST_VC1_CONDOVER_SELECT) {
          if (!bitplane_decoding (br, bitplanes ? bitplanes->overflags : NULL,
                  seqhdr, &pic->overflags))
            goto failed;

          GST_DEBUG ("overflags %u", pic->overflags);
        }
      }

      framehdr->transacfrm = get_unary (br, 0, 2);
      pic->transacfrm2 = get_unary (br, 0, 2);
      READ_UINT8 (br, framehdr->transdctab, 1);

      if (framehdr->dquant)
        parse_vopdquant (br, framehdr, framehdr->dquant);

      GST_DEBUG
          ("acpred %u, condover %u, transacfrm %u, transacfrm2 %u, transdctab %u",
          pic->acpred, pic->condover, framehdr->transacfrm, pic->transacfrm2,
          framehdr->transdctab);
      break;

    case GST_VC1_PICTURE_TYPE_B:
      if (entrypthdr->extended_mv)
        pic->mvrange = get_unary (br, 0, 3);
      else
        pic->mvrange = 0;

      if (pic->fcm != GST_VC1_FRAME_PROGRESSIVE) {
        if (entrypthdr->extended_dmv)
          pic->dmvrange = get_unary (br, 0, 3);
      }

      if (pic->fcm == GST_VC1_FRAME_INTERLACE)
        READ_UINT8 (br, pic->intcomp, 1);
      else
        READ_UINT8 (br, pic->mvmode, 1);

      if (pic->fcm == GST_VC1_FIELD_INTERLACE) {

        if (!bitplane_decoding (br, bitplanes ? bitplanes->forwardmb : NULL,
                seqhdr, &pic->forwardmb))
          goto failed;

      } else {
        if (!bitplane_decoding (br, bitplanes ? bitplanes->directmb : NULL,
                seqhdr, &pic->directmb))
          goto failed;

        if (!bitplane_decoding (br, bitplanes ? bitplanes->skipmb : NULL,
                seqhdr, &pic->skipmb))
          goto failed;
      }

      if (pic->fcm != GST_VC1_FRAME_PROGRESSIVE) {
        if (gst_bit_reader_get_remaining (br) < 7)
          goto failed;

        pic->mbmodetab = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
        pic->imvtab = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
        pic->icbptab = gst_bit_reader_get_bits_uint8_unchecked (br, 3);

        if (pic->fcm == GST_VC1_FRAME_INTERLACE)
          READ_UINT8 (br, pic->mvbptab2, 2);

        if (pic->fcm == GST_VC1_FRAME_INTERLACE ||
            (pic->fcm == GST_VC1_FIELD_INTERLACE
                && pic->mvmode == GST_VC1_MVMODE_MIXED_MV))
          READ_UINT8 (br, pic->mvbptab4, 2);

      } else {
        READ_UINT8 (br, pic->mvtab, 2);
        READ_UINT8 (br, pic->cbptab, 2);
      }

      if (framehdr->dquant) {
        parse_vopdquant (br, framehdr, framehdr->dquant);
      }

      if (entrypthdr->vstransform) {
        READ_UINT8 (br, pic->ttmbf, 1);

        if (pic->ttmbf) {
          READ_UINT8 (br, pic->ttfrm, 2);
        }
      }

      framehdr->transacfrm = get_unary (br, 0, 2);
      READ_UINT8 (br, framehdr->transdctab, 1);

      GST_DEBUG ("transacfrm %u transdctab %u mvmode %u mvtab %u,"
          "cbptab %u directmb %u skipmb %u", framehdr->transacfrm,
          framehdr->transdctab, pic->mvmode, pic->mvtab, pic->cbptab,
          pic->directmb, pic->skipmb);

      break;
    case GST_VC1_PICTURE_TYPE_P:
      if (pic->fcm == GST_VC1_FIELD_INTERLACE) {
        READ_UINT8 (br, pic->numref, 1);

        if (pic->numref)
          READ_UINT8 (br, pic->reffield, 1);
      }

      if (entrypthdr->extended_mv)
        pic->mvrange = get_unary (br, 0, 3);
      else
        pic->mvrange = 0;

      if (pic->fcm != GST_VC1_FRAME_PROGRESSIVE) {
        if (entrypthdr->extended_dmv)
          pic->dmvrange = get_unary (br, 0, 3);
      }

      if (pic->fcm == GST_VC1_FRAME_INTERLACE) {
        READ_UINT8 (br, pic->mvswitch4, 1);
        READ_UINT8 (br, pic->intcomp, 1);

        if (pic->intcomp) {
          READ_UINT8 (br, pic->lumscale, 6);
          READ_UINT8 (br, pic->lumshift, 6);
        }
      } else {

        mvmodeidx = framehdr->pquant > 12;
        pic->mvmode = vc1_mvmode_table[mvmodeidx][get_unary (br, 1, 4)];

        if (pic->mvmode == GST_VC1_MVMODE_INTENSITY_COMP) {
          pic->mvmode2 = vc1_mvmode2_table[mvmodeidx][get_unary (br, 1, 3)];

          if (pic->fcm == GST_VC1_FIELD_INTERLACE)
            pic->intcompfield = decode012 (br);

          READ_UINT8 (br, pic->lumscale, 6);
          READ_UINT8 (br, pic->lumshift, 6);
          GST_DEBUG ("lumscale %u lumshift %u", pic->lumscale, pic->lumshift);

          if (pic->fcm == GST_VC1_FIELD_INTERLACE && pic->intcompfield) {
            READ_UINT8 (br, pic->lumscale2, 6);
            READ_UINT8 (br, pic->lumshift2, 6);
          }
        }

        if (pic->fcm == GST_VC1_FRAME_PROGRESSIVE) {
          if (pic->mvmode == GST_VC1_MVMODE_MIXED_MV ||
              (pic->mvmode == GST_VC1_MVMODE_INTENSITY_COMP &&
                  pic->mvmode2 == GST_VC1_MVMODE_MIXED_MV)) {

            if (!bitplane_decoding (br, bitplanes ? bitplanes->mvtypemb : NULL,
                    seqhdr, &pic->mvtypemb))
              goto failed;

            GST_DEBUG ("mvtypemb %u", pic->mvtypemb);
          }
        }
      }

      if (pic->fcm != GST_VC1_FIELD_INTERLACE) {
        if (!bitplane_decoding (br, bitplanes ? bitplanes->skipmb : NULL,
                seqhdr, &pic->skipmb))
          goto failed;
      }

      if (pic->fcm != GST_VC1_FRAME_PROGRESSIVE) {
        if (gst_bit_reader_get_remaining (br) < 7)
          goto failed;

        pic->mbmodetab = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
        pic->imvtab = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
        pic->icbptab = gst_bit_reader_get_bits_uint8_unchecked (br, 3);

        if (pic->fcm != GST_VC1_FIELD_INTERLACE) {
          READ_UINT8 (br, pic->mvbptab2, 2);

          if (pic->mvswitch4)
            READ_UINT8 (br, pic->mvbptab4, 2);

        } else if (pic->mvmode == GST_VC1_MVMODE_MIXED_MV)
          READ_UINT8 (br, pic->mvbptab4, 2);

      } else {
        if (gst_bit_reader_get_remaining (br) < 4)
          goto failed;
        pic->mvtab = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
        pic->cbptab = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
      }

      if (framehdr->dquant) {
        parse_vopdquant (br, framehdr, framehdr->dquant);
      }

      if (entrypthdr->vstransform) {
        READ_UINT8 (br, pic->ttmbf, 1);

        if (pic->ttmbf) {
          READ_UINT8 (br, pic->ttfrm, 2);
        }
      }

      framehdr->transacfrm = get_unary (br, 0, 2);
      READ_UINT8 (br, framehdr->transdctab, 1);

      GST_DEBUG ("transacfrm %u transdctab %u mvmode %u mvtab %u,"
          "cbptab %u skipmb %u", framehdr->transacfrm, framehdr->transdctab,
          pic->mvmode, pic->mvtab, pic->cbptab, pic->skipmb);

      break;

    default:
      goto failed;
      break;
  }

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse frame header");

  return GST_VC1_PARSER_ERROR;
}

static GstVC1ParserResult
parse_frame_header (GstBitReader * br, GstVC1FrameHdr * framehdr,
    GstVC1SeqHdr * seqhdr, GstVC1BitPlanes * bitplanes)
{
  guint8 mvmodeidx, tmp;
  GstVC1PicSimpleMain *pic = &framehdr->pic.simple;
  GstVC1SeqStructC *structc = &seqhdr->struct_c;

  GST_DEBUG ("Parsing frame header in simple or main mode");

  /* Set the conveninence fields */
  framehdr->profile = seqhdr->profile;
  framehdr->dquant = structc->dquant;

  framehdr->interpfrm = 0;
  if (structc->finterpflag)
    READ_UINT8 (br, framehdr->interpfrm, 1);

  READ_UINT8 (br, pic->frmcnt, 2);

  pic->rangeredfrm = 0;
  if (structc->rangered) {
    READ_UINT8 (br, pic->rangeredfrm, 1);
  }

  /*  Figuring out the picture type */
  READ_UINT8 (br, tmp, 1);
  framehdr->ptype = tmp;

  if (structc->maxbframes) {
    if (!framehdr->ptype) {
      READ_UINT8 (br, tmp, 1);

      if (tmp)
        framehdr->ptype = GST_VC1_PICTURE_TYPE_I;
      else
        framehdr->ptype = GST_VC1_PICTURE_TYPE_B;

    } else
      framehdr->ptype = GST_VC1_PICTURE_TYPE_P;

  } else {
    if (framehdr->ptype)
      framehdr->ptype = GST_VC1_PICTURE_TYPE_P;
    else
      framehdr->ptype = GST_VC1_PICTURE_TYPE_I;
  }


  if (framehdr->ptype == GST_VC1_PICTURE_TYPE_B) {
    guint bfraction;
    if (!decode_vlc (br, &bfraction, vc1_bfraction_vlc_table,
            G_N_ELEMENTS (vc1_bfraction_vlc_table)))
      goto failed;

    pic->bfraction = bfraction;
    GST_DEBUG ("bfraction %d", pic->bfraction);

    if (pic->bfraction == GST_VC1_BFRACTION_PTYPE_BI) {
      framehdr->ptype = GST_VC1_PICTURE_TYPE_BI;
    }
  }

  if (framehdr->ptype == GST_VC1_PICTURE_TYPE_I ||
      framehdr->ptype == GST_VC1_PICTURE_TYPE_BI)
    READ_UINT8 (br, pic->bf, 7);

  READ_UINT8 (br, framehdr->pqindex, 5);
  if (!framehdr->pqindex)
    return GST_VC1_PARSER_ERROR;

  GST_DEBUG ("pqindex %u", framehdr->pqindex);

  /* compute pquant */
  if (structc->quantizer == GST_VC1_QUANTIZER_IMPLICITLY)
    framehdr->pquant = vc1_pquant_table[0][framehdr->pqindex];
  else
    framehdr->pquant = vc1_pquant_table[1][framehdr->pqindex];

  GST_DEBUG ("pquant %u", framehdr->pquant);

  if (framehdr->pqindex <= 8)
    READ_UINT8 (br, framehdr->halfqp, 1);
  else
    framehdr->halfqp = 0;

  /* Set pquantizer */
  framehdr->pquantizer = 1;
  if (structc->quantizer == GST_VC1_QUANTIZER_IMPLICITLY)
    framehdr->pquantizer = framehdr->pqindex < 9;
  else if (structc->quantizer == GST_VC1_QUANTIZER_NON_UNIFORM)
    framehdr->pquantizer = 0;

  if (structc->quantizer == GST_VC1_QUANTIZER_EXPLICITLY)
    READ_UINT8 (br, framehdr->pquantizer, 1);

  if (structc->extended_mv == 1) {
    pic->mvrange = get_unary (br, 0, 3);
    GST_DEBUG ("mvrange %u", pic->mvrange);
  }

  if (structc->multires && (framehdr->ptype == GST_VC1_PICTURE_TYPE_P ||
          framehdr->ptype == GST_VC1_PICTURE_TYPE_I)) {
    READ_UINT8 (br, pic->respic, 2);
    GST_DEBUG ("Respic %u", pic->respic);
  }

  GST_DEBUG ("Parsing %u Frame, pquantizer %u, halfqp %u, rangeredfrm %u, "
      "interpfrm %u", framehdr->ptype, framehdr->pquantizer, framehdr->halfqp,
      pic->rangeredfrm, framehdr->interpfrm);

  switch (framehdr->ptype) {
    case GST_VC1_PICTURE_TYPE_I:
    case GST_VC1_PICTURE_TYPE_BI:
      framehdr->transacfrm = get_unary (br, 0, 2);
      pic->transacfrm2 = get_unary (br, 0, 2);
      READ_UINT8 (br, framehdr->transdctab, 1);

      GST_DEBUG ("transacfrm %u, transacfrm2 %u, transdctab %u",
          framehdr->transacfrm, pic->transacfrm2, framehdr->transdctab);
      break;

    case GST_VC1_PICTURE_TYPE_P:
      mvmodeidx = framehdr->pquant > 12;
      pic->mvmode = vc1_mvmode_table[mvmodeidx][get_unary (br, 1, 4)];

      if (pic->mvmode == GST_VC1_MVMODE_INTENSITY_COMP) {
        pic->mvmode2 = vc1_mvmode2_table[mvmodeidx][get_unary (br, 1, 3)];
        READ_UINT8 (br, pic->lumscale, 6);
        READ_UINT8 (br, pic->lumshift, 6);
        GST_DEBUG ("lumscale %u lumshift %u", pic->lumscale, pic->lumshift);
      }

      if (pic->mvmode == GST_VC1_MVMODE_MIXED_MV ||
          (pic->mvmode == GST_VC1_MVMODE_INTENSITY_COMP &&
              pic->mvmode2 == GST_VC1_MVMODE_MIXED_MV)) {
        if (!bitplane_decoding (br, bitplanes ? bitplanes->mvtypemb : NULL,
                seqhdr, &pic->mvtypemb))
          goto failed;
        GST_DEBUG ("mvtypemb %u", pic->mvtypemb);
      }
      if (!bitplane_decoding (br, bitplanes ? bitplanes->skipmb : NULL,
              seqhdr, &pic->skipmb))
        goto failed;

      READ_UINT8 (br, pic->mvtab, 2);
      READ_UINT8 (br, pic->cbptab, 2);

      if (framehdr->dquant) {
        parse_vopdquant (br, framehdr, framehdr->dquant);
      }

      if (structc->vstransform) {
        READ_UINT8 (br, pic->ttmbf, 1);
        GST_DEBUG ("ttmbf %u", pic->ttmbf);

        if (pic->ttmbf) {
          READ_UINT8 (br, pic->ttfrm, 2);
          GST_DEBUG ("ttfrm %u", pic->ttfrm);
        }
      }

      framehdr->transacfrm = get_unary (br, 0, 2);
      READ_UINT8 (br, framehdr->transdctab, 1);

      GST_DEBUG ("transacfrm %u transdctab %u mvmode %u mvtab %u,"
          "cbptab %u skipmb %u", framehdr->transacfrm, framehdr->transdctab,
          pic->mvmode, pic->mvtab, pic->cbptab, pic->skipmb);
      break;

    case GST_VC1_PICTURE_TYPE_B:
      READ_UINT8 (br, pic->mvmode, 1);
      if (!bitplane_decoding (br, bitplanes ? bitplanes->directmb : NULL,
              seqhdr, &pic->directmb))
        goto failed;

      if (!bitplane_decoding (br, bitplanes ? bitplanes->skipmb : NULL,
              seqhdr, &pic->skipmb))
        goto failed;

      READ_UINT8 (br, pic->mvtab, 2);
      READ_UINT8 (br, pic->cbptab, 2);

      if (framehdr->dquant)
        parse_vopdquant (br, framehdr, framehdr->dquant);

      if (structc->vstransform) {
        READ_UINT8 (br, pic->ttmbf, 1);

        if (pic->ttmbf) {
          READ_UINT8 (br, pic->ttfrm, 2);
        }
      }

      framehdr->transacfrm = get_unary (br, 0, 2);
      READ_UINT8 (br, framehdr->transdctab, 1);

      GST_DEBUG ("transacfrm %u transdctab %u mvmode %u mvtab %u,"
          "cbptab %u directmb %u skipmb %u", framehdr->transacfrm,
          framehdr->transdctab, pic->mvmode, pic->mvtab, pic->cbptab,
          pic->directmb, pic->skipmb);

      break;

    default:
      goto failed;
      break;
  }

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse Simple picture header");

  return GST_VC1_PARSER_ERROR;
}

static GstVC1ParserResult
parse_sequence_header_struct_a (GstBitReader * br, GstVC1SeqStructA * structa)
{
  if (gst_bit_reader_get_remaining (br) < 64) {
    GST_WARNING ("Failed to parse struct A");

    return GST_VC1_PARSER_ERROR;
  }

  structa->vert_size = gst_bit_reader_get_bits_uint32_unchecked (br, 32);
  structa->horiz_size = gst_bit_reader_get_bits_uint32_unchecked (br, 32);

  return GST_VC1_PARSER_OK;
}

static GstVC1ParserResult
parse_sequence_header_struct_b (GstBitReader * br, GstVC1SeqStructB * structb)
{
  if (gst_bit_reader_get_remaining (br) < 96) {
    GST_WARNING ("Failed to parse sequence header");

    return GST_VC1_PARSER_ERROR;
  }

  structb->level = gst_bit_reader_get_bits_uint8_unchecked (br, 3);
  structb->cbr = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

  /* res4 */
  gst_bit_reader_skip_unchecked (br, 4);

  structb->hrd_buffer = gst_bit_reader_get_bits_uint32_unchecked (br, 24);
  structb->hrd_rate = gst_bit_reader_get_bits_uint32_unchecked (br, 32);
  structb->framerate = gst_bit_reader_get_bits_uint32_unchecked (br, 32);

  return GST_VC1_PARSER_OK;
}

static GstVC1ParserResult
parse_sequence_header_struct_c (GstBitReader * br, GstVC1SeqStructC * structc)
{
  guint8 old_interlaced_mode, tmp;

  READ_UINT8 (br, tmp, 2);
  structc->profile = tmp;

  if (structc->profile == GST_VC1_PROFILE_ADVANCED)
    return GST_VC1_PARSER_OK;

  GST_DEBUG ("Parsing sequence header in simple or main mode");

  if (gst_bit_reader_get_remaining (br) < 29)
    goto failed;

  /* Reserved bits */
  old_interlaced_mode = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  if (old_interlaced_mode)
    GST_WARNING ("Old interlaced mode used");

  structc->wmvp = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  if (structc->wmvp)
    GST_DEBUG ("WMVP mode");

  structc->frmrtq_postproc = gst_bit_reader_get_bits_uint8_unchecked (br, 3);
  structc->bitrtq_postproc = gst_bit_reader_get_bits_uint8_unchecked (br, 5);
  structc->loop_filter = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

  calculate_framerate_bitrate (structc->frmrtq_postproc,
      structc->bitrtq_postproc, &structc->framerate, &structc->bitrate);

  /* Skipping reserved3 bit */
  gst_bit_reader_skip_unchecked (br, 1);

  structc->multires = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

  /* Skipping reserved4 bit */
  gst_bit_reader_skip_unchecked (br, 1);

  structc->fastuvmc = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  structc->extended_mv = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  structc->dquant = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
  structc->vstransform = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

  /* Skipping reserved5 bit */
  gst_bit_reader_skip_unchecked (br, 1);

  structc->overlap = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  structc->syncmarker = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  structc->rangered = gst_bit_reader_get_bits_uint8_unchecked (br, 1);
  structc->maxbframes = gst_bit_reader_get_bits_uint8_unchecked (br, 3);
  structc->quantizer = gst_bit_reader_get_bits_uint8_unchecked (br, 2);
  structc->finterpflag = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

  GST_DEBUG ("frmrtq_postproc %u, bitrtq_postproc %u, loop_filter %u, "
      "multires %u, fastuvmc %u, extended_mv %u, dquant %u, vstransform %u, "
      "overlap %u, syncmarker %u, rangered %u, maxbframes %u, quantizer %u, "
      "finterpflag %u", structc->frmrtq_postproc, structc->bitrtq_postproc,
      structc->loop_filter, structc->multires, structc->fastuvmc,
      structc->extended_mv, structc->dquant, structc->vstransform,
      structc->overlap, structc->syncmarker, structc->rangered,
      structc->maxbframes, structc->quantizer, structc->finterpflag);

  if (structc->wmvp) {
    if (gst_bit_reader_get_remaining (br) < 29)
      goto failed;

    structc->coded_width = gst_bit_reader_get_bits_uint16_unchecked (br, 11);
    structc->coded_height = gst_bit_reader_get_bits_uint16_unchecked (br, 11);
    structc->framerate = gst_bit_reader_get_bits_uint8_unchecked (br, 5);
    gst_bit_reader_skip_unchecked (br, 1);
    structc->slice_code = gst_bit_reader_get_bits_uint8_unchecked (br, 1);

    GST_DEBUG ("coded_width %u, coded_height %u, framerate %u slice_code %u",
        structc->coded_width, structc->coded_height, structc->framerate,
        structc->slice_code);
  }

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to struct C");

  return GST_VC1_PARSER_ERROR;
}

/**** API ****/
/**
 * gst_vc1_identify_next_bdu:
 * @data: The data to parse
 * @size: the size of @data
 * @bdu: (out): The #GstVC1BDU where to store parsed bdu headers
 *
 * Parses @data and fills @bdu fields
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_identify_next_bdu (const guint8 * data, gsize size, GstVC1BDU * bdu)
{
  gint off1, off2;

  g_return_val_if_fail (bdu != NULL, GST_VC1_PARSER_ERROR);

  if (size < 4) {
    GST_DEBUG ("Can't parse, buffer has too small size %" G_GSIZE_FORMAT, size);
    return GST_VC1_PARSER_ERROR;
  }

  off1 = scan_for_start_codes (data, size);

  if (off1 < 0) {
    GST_DEBUG ("No start code prefix in this buffer");
    return GST_VC1_PARSER_NO_BDU;
  }

  bdu->sc_offset = off1;

  bdu->offset = off1 + 4;
  bdu->data = (guint8 *) data;
  bdu->type = (GstVC1StartCode) (data[bdu->offset - 1]);

  if (bdu->type == GST_VC1_END_OF_SEQ) {
    GST_DEBUG ("End-of-Seq BDU found");
    bdu->size = 0;
    return GST_VC1_PARSER_OK;
  }

  off2 = scan_for_start_codes (data + bdu->offset, size - bdu->offset);
  if (off2 < 0) {
    GST_DEBUG ("Bdu start %d, No end found", bdu->offset);

    return GST_VC1_PARSER_NO_BDU_END;
  }

  if (off2 > 0 && data[bdu->offset + off2 - 1] == 00)
    off2--;

  bdu->size = off2;

  GST_DEBUG ("Complete bdu found. Off: %d, Size: %d", bdu->offset, bdu->size);
  return GST_VC1_PARSER_OK;
}

/**
 * gst_vc1_parse_sequence_layer:
 * @data: The data to parse
 * @size: the size of @data
 * @seqlayer: The #GstVC1SeqLayer to set.
 *
 * Parses @data, and fills @seqlayer fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_sequence_layer (const guint8 * data, gsize size,
    GstVC1SeqLayer * seqlayer)
{
  guint32 tmp;
  GstBitReader br = GST_BIT_READER_INIT (data, size);

  g_return_val_if_fail (seqlayer != NULL, GST_VC1_PARSER_ERROR);

  READ_UINT32 (&br, tmp, 8);
  if (tmp != 0xC5)
    goto failed;

  READ_UINT32 (&br, seqlayer->numframes, 24);

  READ_UINT32 (&br, tmp, 32);
  if (tmp != 0x04)
    goto failed;

  if (parse_sequence_header_struct_c (&br, &seqlayer->struct_c) ==
      GST_VC1_PARSER_ERROR)
    goto failed;

  if (parse_sequence_header_struct_a (&br, &seqlayer->struct_a) ==
      GST_VC1_PARSER_ERROR)
    goto failed;

  READ_UINT32 (&br, tmp, 32);
  if (tmp != 0x0C)
    goto failed;

  if (parse_sequence_header_struct_b (&br, &seqlayer->struct_b) ==
      GST_VC1_PARSER_ERROR)
    goto failed;

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse sequence layer");

  return GST_VC1_PARSER_ERROR;
}

/**
 * gst_vc1_parse_sequence_header_struct_a:
 * @data: The data to parse
 * @size: the size of @data
 * @structa: The #GstVC1SeqStructA to set.
 *
 * Parses @data, and fills @structa fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_sequence_header_struct_a (const guint8 * data,
    gsize size, GstVC1SeqStructA * structa)
{
  GstBitReader br = GST_BIT_READER_INIT (data, size);

  g_return_val_if_fail (structa != NULL, GST_VC1_PARSER_ERROR);

  return parse_sequence_header_struct_a (&br, structa);
}

/**
 * gst_vc1_parse_sequence_header_struct_b:
 * @data: The data to parse
 * @size: the size of @data
 * @structb: The #GstVC1SeqStructB to set.
 *
 * Parses @data, and fills @structb fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_sequence_header_struct_b (const guint8 * data,
    gsize size, GstVC1SeqStructB * structb)
{
  GstBitReader br = GST_BIT_READER_INIT (data, size);

  g_return_val_if_fail (structb != NULL, GST_VC1_PARSER_ERROR);

  return parse_sequence_header_struct_b (&br, structb);
}

/**
 * gst_vc1_parse_sequence_header_struct_c:
 * @data: The data to parse
 * @size: the size of @data
 * @structc: The #GstVC1SeqStructC to set.
 *
 * Parses @data, and fills @structc fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_sequence_header_struct_c (const guint8 * data, gsize size,
    GstVC1SeqStructC * structc)
{
  GstBitReader br = GST_BIT_READER_INIT (data, size);

  g_return_val_if_fail (structc != NULL, GST_VC1_PARSER_ERROR);

  return parse_sequence_header_struct_c (&br, structc);
}

/**
* gst_vc1_parse_sequence_header:
* @data: The data to parse
* @size: the size of @data
* @seqhdr: The #GstVC1SeqHdr to set.
 *
 * Parses @data, and fills @seqhdr fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_sequence_header (const guint8 * data, gsize size,
    GstVC1SeqHdr * seqhdr)
{
  GstBitReader br = GST_BIT_READER_INIT (data, size);

  g_return_val_if_fail (seqhdr != NULL, GST_VC1_PARSER_ERROR);

  if (parse_sequence_header_struct_c (&br, &seqhdr->struct_c) ==
      GST_VC1_PARSER_ERROR)
    goto failed;

  /*  Convenience field */
  seqhdr->profile = seqhdr->struct_c.profile;

  if (seqhdr->profile == GST_VC1_PROFILE_ADVANCED)
    return parse_sequence_header_advanced (seqhdr, &br);

  /* Compute MB height and width */
  calculate_mb_size (seqhdr, seqhdr->struct_c.coded_width,
      seqhdr->struct_c.coded_height);

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse sequence header");

  return GST_VC1_PARSER_ERROR;
}

/**
 * gst_vc1_parse_entry_point_header:
 * @data: The data to parse
 * @size: the size of @data
 * @entrypoint: (out): The #GstVC1EntryPointHdr to set.
 * @seqhdr: The #GstVC1SeqHdr currently being parsed
 *
 * Parses @data, and sets @entrypoint fields.
 *
 * Returns: a #GstVC1EntryPointHdr
 */
GstVC1ParserResult
gst_vc1_parse_entry_point_header (const guint8 * data, gsize size,
    GstVC1EntryPointHdr * entrypoint, GstVC1SeqHdr * seqhdr)
{
  GstBitReader br;
  guint8 i;
  GstVC1AdvancedSeqHdr *advanced = &seqhdr->advanced;

  g_return_val_if_fail (entrypoint != NULL, GST_VC1_PARSER_ERROR);

  gst_bit_reader_init (&br, data, size);

  if (gst_bit_reader_get_remaining (&br) < 13)
    goto failed;

  entrypoint->broken_link = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->closed_entry = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->panscan_flag = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->refdist_flag = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->loopfilter = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->fastuvmc = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->extended_mv = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->dquant = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
  entrypoint->vstransform = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->overlap = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  entrypoint->quantizer = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);

  if (advanced->hrd_param_flag) {
    if (seqhdr->advanced.hrd_param.hrd_num_leaky_buckets >
        MAX_HRD_NUM_LEAKY_BUCKETS) {
      GST_WARNING
          ("hrd_num_leaky_buckets (%d) > MAX_HRD_NUM_LEAKY_BUCKETS (%d)",
          seqhdr->advanced.hrd_param.hrd_num_leaky_buckets,
          MAX_HRD_NUM_LEAKY_BUCKETS);
      goto failed;
    }
    for (i = 0; i < seqhdr->advanced.hrd_param.hrd_num_leaky_buckets; i++)
      READ_UINT8 (&br, entrypoint->hrd_full[i], 8);
  }

  READ_UINT8 (&br, entrypoint->coded_size_flag, 1);
  if (entrypoint->coded_size_flag) {
    READ_UINT16 (&br, entrypoint->coded_width, 12);
    READ_UINT16 (&br, entrypoint->coded_height, 12);
    entrypoint->coded_height = (entrypoint->coded_height + 1) << 1;
    entrypoint->coded_width = (entrypoint->coded_width + 1) << 1;
    calculate_mb_size (seqhdr, entrypoint->coded_width,
        entrypoint->coded_height);
  }

  if (entrypoint->extended_mv)
    READ_UINT8 (&br, entrypoint->extended_dmv, 1);

  READ_UINT8 (&br, entrypoint->range_mapy_flag, 1);
  if (entrypoint->range_mapy_flag)
    READ_UINT8 (&br, entrypoint->range_mapy, 3);

  READ_UINT8 (&br, entrypoint->range_mapuv_flag, 1);
  if (entrypoint->range_mapy_flag)
    READ_UINT8 (&br, entrypoint->range_mapuv, 3);

  advanced->entrypoint = *entrypoint;

  return GST_VC1_PARSER_OK;

failed:
  GST_WARNING ("Failed to parse entry point header");

  return GST_VC1_PARSER_ERROR;
}

/**
 * gst_vc1_parse_frame_layer:
 * @data: The data to parse
 * @size: the size of @data
 * @framelayer: The #GstVC1FrameLayer to fill.
 *
 * Parses @data, and fills @framelayer fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_frame_layer (const guint8 * data, gsize size,
    GstVC1FrameLayer * framelayer)
{
  GstBitReader br = GST_BIT_READER_INIT (data, size);

  if (gst_bit_reader_get_remaining (&br) < 64) {
    GST_WARNING ("Could not parse frame layer");

    return GST_VC1_PARSER_ERROR;
  }

  /* set default values */
  framelayer->skiped_p_frame = 0;

  framelayer->key = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
  gst_bit_reader_skip_unchecked (&br, 7);

  framelayer->framesize = gst_bit_reader_get_bits_uint32_unchecked (&br, 24);

  if (framelayer->framesize == 0 || framelayer->framesize == 1)
    framelayer->skiped_p_frame = 1;

  /* compute  next_framelayer_offset */
  framelayer->next_framelayer_offset = framelayer->framesize + 8;

  framelayer->timestamp = gst_bit_reader_get_bits_uint32_unchecked (&br, 32);

  return GST_VC1_PARSER_OK;
}

/**
 * gst_vc1_parse_frame_header:
 * @data: The data to parse
 * @size: the size of @data
 * @framehdr: The #GstVC1FrameHdr to fill.
 * @seqhdr: The #GstVC1SeqHdr currently being parsed
 * @bitplanes: The #GstVC1BitPlanes to store bitplanes in or %NULL
 *
 * Parses @data, and fills @entrypoint fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_frame_header (const guint8 * data, gsize size,
    GstVC1FrameHdr * framehdr, GstVC1SeqHdr * seqhdr,
    GstVC1BitPlanes * bitplanes)
{
  GstBitReader br;
  GstVC1ParserResult result;

  gst_bit_reader_init (&br, data, size);

  if (seqhdr->profile == GST_VC1_PROFILE_ADVANCED)
    result = parse_frame_header_advanced (&br, framehdr, seqhdr, bitplanes,
        FALSE);
  else
    result = parse_frame_header (&br, framehdr, seqhdr, bitplanes);

  framehdr->header_size = gst_bit_reader_get_pos (&br);
  return result;
}

/**
 * gst_vc1_parse_field_header:
 * @data: The data to parse
 * @size: the size of @data
 * @fieldhdr: The #GstVC1FrameHdr to fill.
 * @seqhdr: The #GstVC1SeqHdr currently being parsed
 * @bitplanes: The #GstVC1BitPlanes to store bitplanes in or %NULL
 *
 * Parses @data, and fills @fieldhdr fields.
 *
 * Returns: a #GstVC1ParserResult
 */
GstVC1ParserResult
gst_vc1_parse_field_header (const guint8 * data, gsize size,
    GstVC1FrameHdr * fieldhdr, GstVC1SeqHdr * seqhdr,
    GstVC1BitPlanes * bitplanes)
{
  GstBitReader br;
  GstVC1ParserResult result;

  gst_bit_reader_init (&br, data, size);

  result = parse_frame_header_advanced (&br, fieldhdr, seqhdr, bitplanes, TRUE);

  return result;
}

/**
 * gst_vc1_parse_slice_header:
 * @data: The data to parse
 * @size: The size of @data
 * @slicehdr: The #GstVC1SliceHdr to fill
 * @seqhdr: The #GstVC1SeqHdr that was previously parsed
 *
 * Parses @data, and fills @slicehdr fields.
 *
 * Returns: a #GstVC1ParserResult
 *
 * Since: 1.2
 */
GstVC1ParserResult
gst_vc1_parse_slice_header (const guint8 * data, gsize size,
    GstVC1SliceHdr * slicehdr, GstVC1SeqHdr * seqhdr)
{
  GstBitReader br;
  GstVC1FrameHdr framehdr;
  GstVC1ParserResult result;
  guint8 pic_header_flag;

  GST_DEBUG ("Parsing slice header");

  if (seqhdr->profile != GST_VC1_PROFILE_ADVANCED)
    return GST_VC1_PARSER_BROKEN_DATA;

  gst_bit_reader_init (&br, data, size);

  READ_UINT16 (&br, slicehdr->slice_addr, 9);
  READ_UINT8 (&br, pic_header_flag, 1);
  if (pic_header_flag)
    result = parse_frame_header_advanced (&br, &framehdr, seqhdr, NULL, FALSE);
  else
    result = GST_VC1_PARSER_OK;

  slicehdr->header_size = gst_bit_reader_get_pos (&br);
  return result;

failed:
  GST_WARNING ("Failed to parse slice header");
  return GST_VC1_PARSER_ERROR;
}

/**
 * gst_vc1_bitplanes_new:
 *
 * Creates a new #GstVC1BitPlanes. It should be freed with
 * gst_vc1_bitplanes_free() after use.
 *
 * Returns: a new #GstVC1BitPlanes
 */
GstVC1BitPlanes *
gst_vc1_bitplanes_new (void)
{
  return g_slice_new0 (GstVC1BitPlanes);
}

/**
 * gst_vc1_bitplane_free:
 * @bitplanes: the #GstVC1BitPlanes to free
 *
 * Frees @bitplanes.
 */
void
gst_vc1_bitplanes_free (GstVC1BitPlanes * bitplanes)
{
  gst_vc1_bitplanes_free_1 (bitplanes);
  g_slice_free (GstVC1BitPlanes, bitplanes);
}

/**
 * gst_vc1_bitplane_free_1:
 * @bitplanes: The #GstVC1BitPlanes to free
 *
 * Frees @bitplanes fields.
 */
void
gst_vc1_bitplanes_free_1 (GstVC1BitPlanes * bitplanes)
{
  g_free (bitplanes->acpred);
  g_free (bitplanes->fieldtx);
  g_free (bitplanes->overflags);
  g_free (bitplanes->mvtypemb);
  g_free (bitplanes->skipmb);
  g_free (bitplanes->directmb);
  g_free (bitplanes->forwardmb);
}

/**
 * gst_vc1_bitplanes_ensure_size:
 * @bitplanes: The #GstVC1BitPlanes to reset
 * @seqhdr: The #GstVC1SeqHdr from which to set @bitplanes
 *
 * Fills the @bitplanes structure from @seqhdr, this function
 * should be called after #gst_vc1_parse_sequence_header if
 * in simple or main mode, or after #gst_vc1_parse_entry_point_header
 * if in advanced mode.
 *
 * Returns: %TRUE if everything went fine, %FALSE otherwize
 */
gboolean
gst_vc1_bitplanes_ensure_size (GstVC1BitPlanes * bitplanes,
    GstVC1SeqHdr * seqhdr)
{
  g_return_val_if_fail (bitplanes != NULL, FALSE);
  g_return_val_if_fail (seqhdr != NULL, FALSE);

  if (bitplanes->size) {
    bitplanes->size = seqhdr->mb_height * seqhdr->mb_stride;
    bitplanes->acpred =
        g_realloc_n (bitplanes->acpred, bitplanes->size, sizeof (guint8));
    bitplanes->fieldtx =
        g_realloc_n (bitplanes->fieldtx, bitplanes->size, sizeof (guint8));
    bitplanes->overflags =
        g_realloc_n (bitplanes->overflags, bitplanes->size, sizeof (guint8));
    bitplanes->mvtypemb =
        g_realloc_n (bitplanes->mvtypemb, bitplanes->size, sizeof (guint8));
    bitplanes->skipmb =
        g_realloc_n (bitplanes->skipmb, bitplanes->size, sizeof (guint8));
    bitplanes->directmb =
        g_realloc_n (bitplanes->directmb, bitplanes->size, sizeof (guint8));
    bitplanes->forwardmb =
        g_realloc_n (bitplanes->forwardmb, bitplanes->size, sizeof (guint8));
  } else {
    bitplanes->size = seqhdr->mb_height * seqhdr->mb_stride;
    bitplanes->acpred = g_malloc0 (bitplanes->size * sizeof (guint8));
    bitplanes->fieldtx = g_malloc0 (bitplanes->size * sizeof (guint8));
    bitplanes->overflags = g_malloc0 (bitplanes->size * sizeof (guint8));
    bitplanes->mvtypemb = g_malloc0 (bitplanes->size * sizeof (guint8));
    bitplanes->skipmb = g_malloc0 (bitplanes->size * sizeof (guint8));
    bitplanes->directmb = g_malloc0 (bitplanes->size * sizeof (guint8));
    bitplanes->forwardmb = g_malloc0 (bitplanes->size * sizeof (guint8));
  }

  return TRUE;
}
