/* Gstreamer
 * Copyright (C) <2011> Intel Corporation
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
 *
 * Some bits C-c,C-v'ed and s/4/3 from h264parse and videoparsers/h264parse.c:
 *    Copyright (C) <2010> Mark Nauwelaerts <mark.nauwelaerts@collabora.co.uk>
 *    Copyright (C) <2010> Collabora Multimedia
 *    Copyright (C) <2010> Nokia Corporation
 *
 *    (C) 2005 Michal Benes <michal.benes@itonis.tv>
 *    (C) 2008 Wim Taymans <wim.taymans@gmail.com>
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
 * Common code for NAL parsing from h264 and h265 parsers.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <gst/base/gstbytereader.h>
#include <gst/base/gstbitreader.h>
#include <string.h>

guint ceil_log2 (guint32 v);

typedef struct
{
  const guint8 *data;
  guint size;

  guint n_epb;                  /* Number of emulation prevention bytes */
  guint byte;                   /* Byte position */
  guint bits_in_cache;          /* bitpos in the cache of next bit */
  guint8 first_byte;
  guint64 cache;                /* cached bytes */
} NalReader;

void nal_reader_init (NalReader * nr, const guint8 * data, guint size);

gboolean nal_reader_read (NalReader * nr, guint nbits);
gboolean nal_reader_skip (NalReader * nr, guint nbits);
gboolean nal_reader_skip_long (NalReader * nr, guint nbits);
guint nal_reader_get_pos (const NalReader * nr);
guint nal_reader_get_remaining (const NalReader * nr);
guint nal_reader_get_epb_count (const NalReader * nr);

gboolean nal_reader_is_byte_aligned (NalReader * nr);
gboolean nal_reader_has_more_data (NalReader * nr);

#define NAL_READER_READ_BITS_H(bits) \
gboolean nal_reader_get_bits_uint##bits (NalReader *nr, guint##bits *val, guint nbits)

NAL_READER_READ_BITS_H (8);
NAL_READER_READ_BITS_H (16);
NAL_READER_READ_BITS_H (32);

#define NAL_READER_PEEK_BITS_H(bits) \
gboolean nal_reader_peek_bits_uint##bits (const NalReader *nr, guint##bits *val, guint nbits)

NAL_READER_PEEK_BITS_H (8);

gboolean nal_reader_get_ue (NalReader * nr, guint32 * val);
gboolean nal_reader_get_se (NalReader * nr, gint32 * val);

#define CHECK_ALLOWED(val, min, max) { \
  if (val < min || val > max) { \
    GST_WARNING ("value not in allowed range. value: %d, range %d-%d", \
                     val, min, max); \
    goto error; \
  } \
}

#define READ_UINT8(nr, val, nbits) { \
  if (!nal_reader_get_bits_uint8 (nr, &val, nbits)) { \
    GST_WARNING ("failed to read uint8, nbits: %d", nbits); \
    goto error; \
  } \
}

#define READ_UINT16(nr, val, nbits) { \
  if (!nal_reader_get_bits_uint16 (nr, &val, nbits)) { \
  GST_WARNING ("failed to read uint16, nbits: %d", nbits); \
    goto error; \
  } \
}

#define READ_UINT32(nr, val, nbits) { \
  if (!nal_reader_get_bits_uint32 (nr, &val, nbits)) { \
  GST_WARNING ("failed to read uint32, nbits: %d", nbits); \
    goto error; \
  } \
}

#define READ_UINT64(nr, val, nbits) { \
  if (!nal_reader_get_bits_uint64 (nr, &val, nbits)) { \
    GST_WARNING ("failed to read uint32, nbits: %d", nbits); \
    goto error; \
  } \
}

#define READ_UE(nr, val) { \
  if (!nal_reader_get_ue (nr, &val)) { \
    GST_WARNING ("failed to read UE"); \
    goto error; \
  } \
}

#define READ_UE_ALLOWED(nr, val, min, max) { \
  guint32 tmp; \
  READ_UE (nr, tmp); \
  CHECK_ALLOWED (tmp, min, max); \
  val = tmp; \
}

#define READ_SE(nr, val) { \
  if (!nal_reader_get_se (nr, &val)) { \
    GST_WARNING ("failed to read SE"); \
    goto error; \
  } \
}

#define READ_SE_ALLOWED(nr, val, min, max) { \
  gint32 tmp; \
  READ_SE (nr, tmp); \
  CHECK_ALLOWED (tmp, min, max); \
  val = tmp; \
}

gint scan_for_start_codes (const guint8 * data, guint size);
