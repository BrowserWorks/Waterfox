/* Copyright 2005 Jan Schmidt <thaytan@mad.scientist.com>
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

#ifndef __ID3TAGS_H__
#define __ID3TAGS_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define ID3V2_MARK_SIZE 3
#define ID3V2_HDR_SIZE GST_TAG_ID3V2_HEADER_SIZE

/* From id3v2.c */
guint id3v2_read_synch_uint (const guint8 * data, guint size);

/* Things shared by id3tags.c and id3v2frames.c */
#define ID3V2_VERSION 0x0400
#define ID3V2_VER_MAJOR(v) ((v) >> 8)
#define ID3V2_VER_MINOR(v) ((v) & 0xff)
   
typedef struct {
  guint16 version;
  guint8 flags;
  guint32 size;
    
  guint8 *frame_data;
  guint32 frame_data_size;

  guint32 ext_hdr_size;
  guint8 ext_flag_bytes;
  guint8 *ext_flag_data;  
} ID3v2Header;

typedef struct {
  ID3v2Header hdr;
  
  GstBuffer *buffer;
  GstTagList *tags;

  /* Current frame decoding */
  guint cur_frame_size;
  gchar *frame_id;
  guint16 frame_flags;
  
  guint8 *parse_data;
  guint parse_size;
  
  /* To collect day/month from obsolete TDAT frame if it exists */
  guint pending_month;
  guint pending_day;
} ID3TagsWorking;

enum {
  ID3V2_HDR_FLAG_UNSYNC       = 0x80,
  ID3V2_HDR_FLAG_EXTHDR       = 0x40,
  ID3V2_HDR_FLAG_EXPERIMENTAL = 0x20,
  ID3V2_HDR_FLAG_FOOTER       = 0x10
};

enum {
  ID3V2_EXT_FLAG_UPDATE     = 0x80,
  ID3V2_EXT_FLAG_CRC        = 0x40,
  ID3V2_EXT_FLAG_RESTRICTED = 0x20
};

enum {
  ID3V2_FRAME_STATUS_FRAME_ALTER_PRESERVE  = 0x4000,
  ID3V2_FRAME_STATUS_FILE_ALTER_PRESERVE   = 0x2000,
  ID3V2_FRAME_STATUS_READONLY              = 0x1000,
  ID3V2_FRAME_FORMAT_GROUPING_ID           = 0x0040,
  ID3V2_FRAME_FORMAT_COMPRESSION           = 0x0008,
  ID3V2_FRAME_FORMAT_ENCRYPTION            = 0x0004,
  ID3V2_FRAME_FORMAT_UNSYNCHRONISATION     = 0x0002,
  ID3V2_FRAME_FORMAT_DATA_LENGTH_INDICATOR = 0x0001
};

#define ID3V2_3_FRAME_FLAGS_MASK              \
  (ID3V2_FRAME_STATUS_FRAME_ALTER_PRESERVE |  \
   ID3V2_FRAME_STATUS_FILE_ALTER_PRESERVE  |  \
   ID3V2_FRAME_STATUS_READONLY |              \
   ID3V2_FRAME_FORMAT_GROUPING_ID |           \
   ID3V2_FRAME_FORMAT_COMPRESSION |           \
   ID3V2_FRAME_FORMAT_ENCRYPTION)

/* FIXME 0.11: remove 'private' bit from GST_TAG_ID3V2_FRAME */
/**
 * GST_TAG_ID3V2_FRAME:
 *
 * Contains a single unprocessed ID3v2 frame. (buffer)
 *
 * (Not public API for now)
 */
#define GST_TAG_ID3V2_FRAME                  "private-id3v2-frame"

/* From id3v2frames.c */
gboolean id3v2_parse_frame (ID3TagsWorking *work);

guint8 * id3v2_ununsync_data (const guint8 * unsync_data, guint32 * size);

GstDebugCategory * id3v2_ensure_debug_category (void);

G_END_DECLS

#endif
