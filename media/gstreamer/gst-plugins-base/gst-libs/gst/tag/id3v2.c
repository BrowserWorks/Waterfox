/* -*- Mode: C; tab-width: 2; indent-tabs-mode: t; c-basic-offset: 2 -*- */
/* Copyright 2005 Jan Schmidt <thaytan@mad.scientist.com>
 * Copyright 2002,2003 Scott Wheeler <wheeler@kde.org> (portions from taglib)
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

#include <string.h>
#include <gst/tag/tag.h>

#include "id3v2.h"

#define HANDLE_INVALID_SYNCSAFE

static gboolean id3v2_frames_to_tag_list (ID3TagsWorking * work, guint size);

#ifndef GST_DISABLE_GST_DEBUG

#define GST_CAT_DEFAULT id3v2_ensure_debug_category()

GstDebugCategory *
id3v2_ensure_debug_category (void)
{
  static gsize cat_gonce = 0;

  if (g_once_init_enter (&cat_gonce)) {
    gsize cat;

    cat = (gsize) _gst_debug_category_new ("id3v2", 0, "ID3v2 tag parsing");

    g_once_init_leave (&cat_gonce, cat);
  }

  return (GstDebugCategory *) cat_gonce;
}

#endif /* GST_DISABLE_GST_DEBUG */

guint
id3v2_read_synch_uint (const guint8 * data, guint size)
{
  gint i;
  guint result = 0;
  gint invalid = 0;

  g_assert (size <= 4);

  size--;
  for (i = 0; i <= size; i++) {
    invalid |= data[i] & 0x80;
    result |= (data[i] & 0x7f) << ((size - i) * 7);
  }

#ifdef HANDLE_INVALID_SYNCSAFE
  if (invalid) {
    GST_WARNING ("Invalid synch-safe integer in ID3v2 frame "
        "- using the actual value instead");
    result = 0;
    for (i = 0; i <= size; i++) {
      result |= data[i] << ((size - i) * 8);
    }
  }
#endif
  return result;
}

/**
 * gst_tag_get_id3v2_tag_size:
 * @buffer: buffer holding ID3v2 tag (or at least the start of one)
 *
 * Determines size of an ID3v2 tag on buffer containing at least ID3v2 header,
 * i.e. at least #GST_TAG_ID3V2_HEADER_SIZE (10) bytes;
 *
 * Returns: Size of tag, or 0 if header is invalid or too small.
 */
guint
gst_tag_get_id3v2_tag_size (GstBuffer * buffer)
{
  GstMapInfo info;
  guint8 flags;
  guint result = 0;

  g_return_val_if_fail (buffer != NULL, 0);

  gst_buffer_map (buffer, &info, GST_MAP_READ);

  if (info.size < ID3V2_HDR_SIZE)
    goto too_small;

  /* Check for 'ID3' string at start of buffer */
  if (info.data[0] != 'I' || info.data[1] != 'D' || info.data[2] != '3')
    goto no_tag;

  /* Read the flags */
  flags = info.data[5];

  /* Read the size from the header */
  result = id3v2_read_synch_uint (info.data + 6, 4);
  if (result == 0)
    goto empty;

  result += ID3V2_HDR_SIZE;

  /* Expand the read size to include a footer if there is one */
  if ((flags & ID3V2_HDR_FLAG_FOOTER))
    result += 10;

  GST_DEBUG ("ID3v2 tag, size: %u bytes", result);

done:
  gst_buffer_unmap (buffer, &info);

  return result;

too_small:
  {
    GST_DEBUG ("size too small");
    goto done;
  }
no_tag:
  {
    GST_DEBUG ("No ID3v2 tag in data");
    goto done;
  }
empty:
  {
    GST_DEBUG ("Empty tag size");
    result = ID3V2_HDR_SIZE;
    goto done;
  }
}

guint8 *
id3v2_ununsync_data (const guint8 * unsync_data, guint32 * size)
{
  const guint8 *end;
  guint8 *out, *uu;
  guint out_size;

  uu = out = g_malloc (*size);

  for (end = unsync_data + *size; unsync_data < end - 1; ++unsync_data, ++uu) {
    *uu = *unsync_data;
    if (G_UNLIKELY (*unsync_data == 0xff && *(unsync_data + 1) == 0x00))
      ++unsync_data;
  }

  /* take care of last byte (if last two bytes weren't 0xff 0x00) */
  if (unsync_data < end) {
    *uu = *unsync_data;
    ++uu;
  }

  out_size = uu - out;
  GST_DEBUG ("size after un-unsyncing: %u (before: %u)", out_size, *size);

  *size = out_size;
  return out;
}

/**
 * gst_tag_list_from_id3v2_tag:
 * @buffer: buffer to convert
 *
 * Creates a new tag list that contains the information parsed out of a
 * ID3 tag.
 *
 * Returns: A new #GstTagList with all tags that could be extracted from the
 *          given vorbiscomment buffer or NULL on error.
 */
GstTagList *
gst_tag_list_from_id3v2_tag (GstBuffer * buffer)
{
  GstMapInfo info;
  guint8 *uu_data = NULL;
  guint read_size;
  ID3TagsWorking work;
  guint8 flags;
  guint16 version;

  read_size = gst_tag_get_id3v2_tag_size (buffer);

  /* Ignore tag if it has no frames attached, but skip the header then */
  if (read_size < ID3V2_HDR_SIZE)
    return NULL;

  gst_buffer_map (buffer, &info, GST_MAP_READ);

  /* Read the version */
  version = GST_READ_UINT16_BE (info.data + 3);

  /* Read the flags */
  flags = info.data[5];

  /* Validate the version. At the moment, we only support up to 2.4.0 */
  if (ID3V2_VER_MAJOR (version) > 4 || ID3V2_VER_MINOR (version) > 0)
    goto wrong_version;

  GST_DEBUG ("ID3v2 header flags: %s %s %s %s",
      (flags & ID3V2_HDR_FLAG_UNSYNC) ? "UNSYNC" : "",
      (flags & ID3V2_HDR_FLAG_EXTHDR) ? "EXTENDED_HEADER" : "",
      (flags & ID3V2_HDR_FLAG_EXPERIMENTAL) ? "EXPERIMENTAL" : "",
      (flags & ID3V2_HDR_FLAG_FOOTER) ? "FOOTER" : "");

  /* This shouldn't really happen! Caller should have checked first */
  if (info.size < read_size)
    goto not_enough_data;

  GST_DEBUG ("Reading ID3v2 tag with revision 2.%d.%d of size %u", version >> 8,
      version & 0xff, read_size);

  GST_MEMDUMP ("ID3v2 tag", info.data, read_size);

  memset (&work, 0, sizeof (ID3TagsWorking));
  work.buffer = buffer;
  work.hdr.version = version;
  work.hdr.size = read_size;
  work.hdr.flags = flags;
  work.hdr.frame_data = info.data + ID3V2_HDR_SIZE;
  if (flags & ID3V2_HDR_FLAG_FOOTER)
    work.hdr.frame_data_size = read_size - ID3V2_HDR_SIZE - 10;
  else
    work.hdr.frame_data_size = read_size - ID3V2_HDR_SIZE;

  /* in v2.3 the frame sizes are not syncsafe, so the entire tag had to be
   * unsynced. In v2.4 the frame sizes are syncsafe so it's just the frame
   * data that needs un-unsyncing, but not the frame headers. */
  if ((flags & ID3V2_HDR_FLAG_UNSYNC) != 0 && ID3V2_VER_MAJOR (version) <= 3) {
    GST_DEBUG ("Un-unsyncing entire tag");
    uu_data = id3v2_ununsync_data (work.hdr.frame_data,
        &work.hdr.frame_data_size);
    work.hdr.frame_data = uu_data;
    GST_MEMDUMP ("ID3v2 tag (un-unsyced)", uu_data, work.hdr.frame_data_size);
  }

  id3v2_frames_to_tag_list (&work, work.hdr.frame_data_size);

  g_free (uu_data);

  gst_buffer_unmap (buffer, &info);

  return work.tags;

  /* ERRORS */
wrong_version:
  {
    GST_WARNING ("ID3v2 tag is from revision 2.%d.%d, "
        "but decoder only supports 2.%d.%d. Ignoring as per spec.",
        version >> 8, version & 0xff, ID3V2_VERSION >> 8, ID3V2_VERSION & 0xff);
    gst_buffer_unmap (buffer, &info);
    return NULL;
  }
not_enough_data:
  {
    GST_DEBUG
        ("Found ID3v2 tag with revision 2.%d.%d - need %u more bytes to read",
        version >> 8, version & 0xff, (guint) (read_size - info.size));
    gst_buffer_unmap (buffer, &info);
    return NULL;
  }
}

static guint
id3v2_frame_hdr_size (guint id3v2ver)
{
  /* ID3v2 < 2.3.0 only had 6 byte header */
  switch (ID3V2_VER_MAJOR (id3v2ver)) {
    case 0:
    case 1:
    case 2:
      return 6;
    case 3:
    case 4:
    default:
      return 10;
  }
}

static const gchar obsolete_frame_ids[][5] = {
  {"CRM"}, {"EQU"}, {"LNK"}, {"RVA"}, {"TIM"}, {"TSI"}, /* From 2.2 */
  {"EQUA"}, {"RVAD"}, {"TIME"}, {"TRDA"}, {"TSIZ"}      /* From 2.3 */
};

static const struct ID3v2FrameIDConvert
{
  const gchar orig[5];
  const gchar new[5];
} frame_id_conversions[] = {
  /* 2.3.x frames */
  {
  "TORY", "TDOR"}, {
  "TYER", "TDRC"},
      /* 2.2.x frames */
  {
  "BUF", "RBUF"}, {
  "CNT", "PCNT"}, {
  "COM", "COMM"}, {
  "CRA", "AENC"}, {
  "ETC", "ETCO"}, {
  "GEO", "GEOB"}, {
  "IPL", "TIPL"}, {
  "MCI", "MCDI"}, {
  "MLL", "MLLT"}, {
  "PIC", "APIC"}, {
  "POP", "POPM"}, {
  "REV", "RVRB"}, {
  "SLT", "SYLT"}, {
  "STC", "SYTC"}, {
  "TAL", "TALB"}, {
  "TBP", "TBPM"}, {
  "TCM", "TCOM"}, {
  "TCO", "TCON"}, {
  "TCR", "TCOP"}, {
  "TDA", "TDAT"}, {             /* obsolete, but we need to parse it anyway */
  "TDY", "TDLY"}, {
  "TEN", "TENC"}, {
  "TFT", "TFLT"}, {
  "TKE", "TKEY"}, {
  "TLA", "TLAN"}, {
  "TLE", "TLEN"}, {
  "TMT", "TMED"}, {
  "TOA", "TOAL"}, {
  "TOF", "TOFN"}, {
  "TOL", "TOLY"}, {
  "TOR", "TDOR"}, {
  "TOT", "TOAL"}, {
  "TP1", "TPE1"}, {
  "TP2", "TPE2"}, {
  "TP3", "TPE3"}, {
  "TP4", "TPE4"}, {
  "TPA", "TPOS"}, {
  "TPB", "TPUB"}, {
  "TRC", "TSRC"}, {
  "TRD", "TDRC"}, {
  "TRK", "TRCK"}, {
  "TSS", "TSSE"}, {
  "TT1", "TIT1"}, {
  "TT2", "TIT2"}, {
  "TT3", "TIT3"}, {
  "TXT", "TOLY"}, {
  "TXX", "TXXX"}, {
  "TYE", "TDRC"}, {
  "UFI", "UFID"}, {
  "ULT", "USLT"}, {
  "WAF", "WOAF"}, {
  "WAR", "WOAR"}, {
  "WAS", "WOAS"}, {
  "WCM", "WCOM"}, {
  "WCP", "WCOP"}, {
  "WPB", "WPUB"}, {
  "WXX", "WXXX"}
};

static gboolean
convert_fid_to_v240 (gchar * frame_id)
{
  gint i;

  for (i = 0; i < G_N_ELEMENTS (obsolete_frame_ids); ++i) {
    if (strncmp (frame_id, obsolete_frame_ids[i], 5) == 0)
      return TRUE;
  }

  for (i = 0; i < G_N_ELEMENTS (frame_id_conversions); ++i) {
    if (strncmp (frame_id, frame_id_conversions[i].orig, 5) == 0) {
      strcpy (frame_id, frame_id_conversions[i].new);
      return FALSE;
    }
  }
  return FALSE;
}


/* add unknown or unhandled ID3v2 frames to the taglist as binary blobs */
static void
id3v2_add_id3v2_frame_blob_to_taglist (ID3TagsWorking * work, guint size)
{
  GstBuffer *blob;
  GstSample *sample;
  guint8 *frame_data;
#if 0
  GstCaps *caps;
  gchar *media_type;
#endif
  guint frame_size, header_size;
  guint i;

  switch (ID3V2_VER_MAJOR (work->hdr.version)) {
    case 1:
    case 2:
      header_size = 3 + 3;
      break;
    case 3:
    case 4:
      header_size = 4 + 4 + 2;
      break;
    default:
      g_return_if_reached ();
  }

  frame_data = work->hdr.frame_data - header_size;
  frame_size = size + header_size;

  blob = gst_buffer_new_and_alloc (frame_size);
  gst_buffer_fill (blob, 0, frame_data, frame_size);

  sample = gst_sample_new (blob, NULL, NULL, NULL);
  gst_buffer_unref (blob);

  /* Sanitize frame id */
  for (i = 0; i < 4; i++) {
    if (!g_ascii_isalnum (frame_data[i]))
      frame_data[i] = '_';
  }

#if 0
  media_type = g_strdup_printf ("application/x-gst-id3v2-%c%c%c%c-frame",
      g_ascii_tolower (frame_data[0]), g_ascii_tolower (frame_data[1]),
      g_ascii_tolower (frame_data[2]), g_ascii_tolower (frame_data[3]));
  caps = gst_caps_new_simple (media_type, "version", G_TYPE_INT,
      (gint) ID3V2_VER_MAJOR (work->hdr.version), NULL);
  gst_buffer_set_caps (blob, caps);
  gst_caps_unref (caps);
  g_free (media_type);
#endif

  /* gst_util_dump_mem (GST_BUFFER_DATA (blob), GST_BUFFER_SIZE (blob)); */

  gst_tag_list_add (work->tags, GST_TAG_MERGE_APPEND,
      GST_TAG_ID3V2_FRAME, sample, NULL);
  gst_sample_unref (sample);
}

static gboolean
id3v2_frames_to_tag_list (ID3TagsWorking * work, guint size)
{
  guint frame_hdr_size;

  /* Extended header if present */
  if (work->hdr.flags & ID3V2_HDR_FLAG_EXTHDR) {
    work->hdr.ext_hdr_size = id3v2_read_synch_uint (work->hdr.frame_data, 4);
    if (work->hdr.ext_hdr_size < 6 ||
        (work->hdr.ext_hdr_size) > work->hdr.frame_data_size) {
      GST_DEBUG ("Invalid extended header. Broken tag");
      return FALSE;
    }
    work->hdr.ext_flag_bytes = work->hdr.frame_data[4];
    if (5 + work->hdr.ext_flag_bytes > work->hdr.frame_data_size) {
      GST_DEBUG
          ("Tag claims extended header, but doesn't have enough bytes. Broken tag");
      return FALSE;
    }

    work->hdr.ext_flag_data = work->hdr.frame_data + 5;
    work->hdr.frame_data += work->hdr.ext_hdr_size;
    work->hdr.frame_data_size -= work->hdr.ext_hdr_size;
  }

  frame_hdr_size = id3v2_frame_hdr_size (work->hdr.version);
  if (work->hdr.frame_data_size <= frame_hdr_size) {
    GST_DEBUG ("Tag has no data frames. Broken tag");
    return FALSE;               /* Must have at least one frame */
  }

  work->tags = gst_tag_list_new_empty ();

  while (work->hdr.frame_data_size > frame_hdr_size) {
    guint frame_size = 0;
    gchar frame_id[5] = "";
    guint16 frame_flags = 0x0;
    gboolean obsolete_id = FALSE;
    gboolean read_synch_size = TRUE;
    guint i;

    /* Read the header */
    switch (ID3V2_VER_MAJOR (work->hdr.version)) {
      case 0:
      case 1:
      case 2:
        frame_id[0] = work->hdr.frame_data[0];
        frame_id[1] = work->hdr.frame_data[1];
        frame_id[2] = work->hdr.frame_data[2];
        frame_id[3] = 0;
        frame_id[4] = 0;
        obsolete_id = convert_fid_to_v240 (frame_id);

        /* 3 byte non-synchsafe size */
        frame_size = work->hdr.frame_data[3] << 16 |
            work->hdr.frame_data[4] << 8 | work->hdr.frame_data[5];
        frame_flags = 0;
        break;
      case 3:
        read_synch_size = FALSE;        /* 2.3 frame size is not synch-safe */
      case 4:
      default:
        frame_id[0] = work->hdr.frame_data[0];
        frame_id[1] = work->hdr.frame_data[1];
        frame_id[2] = work->hdr.frame_data[2];
        frame_id[3] = work->hdr.frame_data[3];
        frame_id[4] = 0;
        if (read_synch_size)
          frame_size = id3v2_read_synch_uint (work->hdr.frame_data + 4, 4);
        else
          frame_size = GST_READ_UINT32_BE (work->hdr.frame_data + 4);

        frame_flags = GST_READ_UINT16_BE (work->hdr.frame_data + 8);

        if (ID3V2_VER_MAJOR (work->hdr.version) == 3) {
          frame_flags &= ID3V2_3_FRAME_FLAGS_MASK;
          obsolete_id = convert_fid_to_v240 (frame_id);
          if (obsolete_id)
            GST_DEBUG ("Ignoring v2.3 frame %s", frame_id);
        }
        break;
    }

    work->hdr.frame_data += frame_hdr_size;
    work->hdr.frame_data_size -= frame_hdr_size;

    if (frame_size > work->hdr.frame_data_size || strcmp (frame_id, "") == 0)
      break;                    /* No more frames to read */

    /* Sanitize frame id */
    switch (ID3V2_VER_MAJOR (work->hdr.version)) {
      case 0:
      case 1:
      case 2:
        for (i = 0; i < 3; i++) {
          if (!g_ascii_isalnum (frame_id[i]))
            frame_id[i] = '_';
        }
        break;
      default:
        for (i = 0; i < 4; i++) {
          if (!g_ascii_isalnum (frame_id[i]))
            frame_id[i] = '_';
        }
    }
#if 1
#if 0
    GST_LOG
        ("Frame @ %ld (0x%02lx) id %s size %u, next=%ld (0x%02lx) obsolete=%d",
        (glong) (work->hdr.frame_data - start),
        (glong) (work->hdr.frame_data - start), frame_id, frame_size,
        (glong) (work->hdr.frame_data + frame_hdr_size + frame_size - start),
        (glong) (work->hdr.frame_data + frame_hdr_size + frame_size - start),
        obsolete_id);
#endif
#define flag_string(flag,str) \
        ((frame_flags & (flag)) ? (str) : "")
    GST_LOG ("Frame header flags: 0x%04x %s %s %s %s %s %s %s", frame_flags,
        flag_string (ID3V2_FRAME_STATUS_FRAME_ALTER_PRESERVE, "ALTER_PRESERVE"),
        flag_string (ID3V2_FRAME_STATUS_READONLY, "READONLY"),
        flag_string (ID3V2_FRAME_FORMAT_GROUPING_ID, "GROUPING_ID"),
        flag_string (ID3V2_FRAME_FORMAT_COMPRESSION, "COMPRESSION"),
        flag_string (ID3V2_FRAME_FORMAT_ENCRYPTION, "ENCRYPTION"),
        flag_string (ID3V2_FRAME_FORMAT_UNSYNCHRONISATION, "UNSYNC"),
        flag_string (ID3V2_FRAME_FORMAT_DATA_LENGTH_INDICATOR, "LENGTH_IND"));
#undef flag_str
#endif

    if (!obsolete_id) {
      /* Now, read, decompress etc the contents of the frame
       * into a TagList entry */
      work->cur_frame_size = frame_size;
      work->frame_id = frame_id;
      work->frame_flags = frame_flags;

      if (id3v2_parse_frame (work)) {
        GST_LOG ("Extracted frame with id %s", frame_id);
      } else {
        GST_LOG ("Failed to extract frame with id %s", frame_id);
        id3v2_add_id3v2_frame_blob_to_taglist (work, frame_size);
      }
    }
    work->hdr.frame_data += frame_size;
    work->hdr.frame_data_size -= frame_size;
  }

  if (gst_tag_list_n_tags (work->tags) == 0) {
    GST_DEBUG ("Could not extract any frames from tag. Broken or empty tag");
    gst_tag_list_unref (work->tags);
    work->tags = NULL;
    return FALSE;
  }

  /* Set day/month now if they were in a separate (obsolete) TDAT frame */
  /* FIXME: we could extract the time as well now */
  if (work->pending_day != 0 && work->pending_month != 0) {
    GstDateTime *dt = NULL;

    if (gst_tag_list_get_date_time (work->tags, GST_TAG_DATE_TIME, &dt)) {
      GstDateTime *dt2;

      /* GstDateTime is immutable, so create new one and replace old one */
      dt2 = gst_date_time_new_ymd (gst_date_time_get_year (dt),
          work->pending_month, work->pending_day);
      gst_tag_list_add (work->tags, GST_TAG_MERGE_REPLACE, GST_TAG_DATE_TIME,
          dt2, NULL);
      gst_date_time_unref (dt2);
      gst_date_time_unref (dt);
    }
  }

  return TRUE;
}
