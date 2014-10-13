/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) 2009 Tim-Philipp Müller <tim centricular net>
 * Copyright (C) <2009> STEricsson <benjamin.gaignard@stericsson.com>
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

#include "qtdemux_types.h"
#include "qtdemux_dump.h"
#include "fourcc.h"

#include "qtatomparser.h"

#include <string.h>

#define GET_UINT8(data)   gst_byte_reader_get_uint8_unchecked(data)
#define GET_UINT16(data)  gst_byte_reader_get_uint16_be_unchecked(data)
#define GET_UINT32(data)  gst_byte_reader_get_uint32_be_unchecked(data)
#define GET_UINT64(data)  gst_byte_reader_get_uint64_be_unchecked(data)
#define GET_FP32(data)   (gst_byte_reader_get_uint32_be_unchecked(data)/65536.0)
#define GET_FP16(data)   (gst_byte_reader_get_uint16_be_unchecked(data)/256.0)
#define GET_FOURCC(data)  qt_atom_parser_get_fourcc_unchecked(data)

gboolean
qtdemux_dump_mvhd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 version = 0;

  if (!qt_atom_parser_has_remaining (data, 100))
    return FALSE;

  version = GET_UINT32 (data);
  GST_LOG ("%*s  version/flags: %08x", depth, "", version);

  version = version >> 24;
  if (version == 0) {
    GST_LOG ("%*s  creation time: %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s  modify time:   %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s  time scale:    1/%u sec", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s  duration:      %u", depth, "", GET_UINT32 (data));
  } else if (version == 1) {
    GST_LOG ("%*s  creation time: %" G_GUINT64_FORMAT,
        depth, "", GET_UINT64 (data));
    GST_LOG ("%*s  modify time:   %" G_GUINT64_FORMAT,
        depth, "", GET_UINT64 (data));
    GST_LOG ("%*s  time scale:    1/%u sec", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s  duration:      %" G_GUINT64_FORMAT,
        depth, "", GET_UINT64 (data));
  } else
    return FALSE;

  GST_LOG ("%*s  pref. rate:    %g", depth, "", GET_FP32 (data));
  GST_LOG ("%*s  pref. volume:  %g", depth, "", GET_FP16 (data));
  gst_byte_reader_skip_unchecked (data, 46);
  GST_LOG ("%*s  preview time:  %u", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  preview dur.:  %u", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  poster time:   %u", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  select time:   %u", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  select dur.:   %u", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  current time:  %u", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  next track ID: %d", depth, "", GET_UINT32 (data));
  return TRUE;
}

gboolean
qtdemux_dump_tkhd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint64 duration, ctime, mtime;
  guint32 version = 0, track_id = 0, iwidth = 0, iheight = 0;
  guint16 layer = 0, alt_group = 0, ivol = 0;
  guint value_size;

  if (!gst_byte_reader_get_uint32_be (data, &version))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", version);

  value_size = ((version >> 24) == 1) ? sizeof (guint64) : sizeof (guint32);

  if (qt_atom_parser_get_offset (data, value_size, &ctime) &&
      qt_atom_parser_get_offset (data, value_size, &mtime) &&
      gst_byte_reader_get_uint32_be (data, &track_id) &&
      gst_byte_reader_skip (data, 4) &&
      qt_atom_parser_get_offset (data, value_size, &duration) &&
      gst_byte_reader_skip (data, 4) &&
      gst_byte_reader_get_uint16_be (data, &layer) &&
      gst_byte_reader_get_uint16_be (data, &alt_group) &&
      gst_byte_reader_skip (data, 4) &&
      gst_byte_reader_get_uint16_be (data, &ivol) &&
      gst_byte_reader_skip (data, 2 + (9 * 4)) &&
      gst_byte_reader_get_uint32_be (data, &iwidth) &&
      gst_byte_reader_get_uint32_be (data, &iheight)) {
    GST_LOG ("%*s  creation time: %" G_GUINT64_FORMAT, depth, "", ctime);
    GST_LOG ("%*s  modify time:   %" G_GUINT64_FORMAT, depth, "", mtime);
    GST_LOG ("%*s  track ID:      %u", depth, "", track_id);
    GST_LOG ("%*s  duration:      %" G_GUINT64_FORMAT, depth, "", duration);
    GST_LOG ("%*s  layer:         %u", depth, "", layer);
    GST_LOG ("%*s  alt group:     %u", depth, "", alt_group);
    GST_LOG ("%*s  volume:        %g", depth, "", ivol / 256.0);
    GST_LOG ("%*s  track width:   %g", depth, "", iwidth / 65536.0);
    GST_LOG ("%*s  track height:  %g", depth, "", iheight / 65536.0);
    return TRUE;
  }

  return FALSE;
}

gboolean
qtdemux_dump_elst (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4 + 4 + 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    track dur:     %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s    media time:    %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s    media rate:    %g", depth, "", GET_FP32 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_mdhd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 version = 0;
  guint64 duration, ctime, mtime;
  guint32 time_scale = 0;
  guint16 language = 0, quality = 0;
  guint value_size;

  if (!gst_byte_reader_get_uint32_be (data, &version))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", version);

  value_size = ((version >> 24) == 1) ? sizeof (guint64) : sizeof (guint32);

  if (qt_atom_parser_get_offset (data, value_size, &ctime) &&
      qt_atom_parser_get_offset (data, value_size, &mtime) &&
      gst_byte_reader_get_uint32_be (data, &time_scale) &&
      qt_atom_parser_get_offset (data, value_size, &duration) &&
      gst_byte_reader_get_uint16_be (data, &language) &&
      gst_byte_reader_get_uint16_be (data, &quality)) {
    GST_LOG ("%*s  creation time: %" G_GUINT64_FORMAT, depth, "", ctime);
    GST_LOG ("%*s  modify time:   %" G_GUINT64_FORMAT, depth, "", mtime);
    GST_LOG ("%*s  time scale:    1/%u sec", depth, "", time_scale);
    GST_LOG ("%*s  duration:      %" G_GUINT64_FORMAT, depth, "", duration);
    GST_LOG ("%*s  language:      %u", depth, "", language);
    GST_LOG ("%*s  quality:       %u", depth, "", quality);
    return TRUE;
  }

  return FALSE;
}

gboolean
qtdemux_dump_hdlr (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 version, type, subtype, manufacturer;
  const gchar *name;

  if (!qt_atom_parser_has_remaining (data, 4 + 4 + 4 + 4 + 4 + 4 + 1))
    return FALSE;

  version = GET_UINT32 (data);
  type = GET_FOURCC (data);
  subtype = GET_FOURCC (data);
  manufacturer = GET_FOURCC (data);

  GST_LOG ("%*s  version/flags: %08x", depth, "", version);
  GST_LOG ("%*s  type:          %" GST_FOURCC_FORMAT, depth, "",
      GST_FOURCC_ARGS (type));
  GST_LOG ("%*s  subtype:       %" GST_FOURCC_FORMAT, depth, "",
      GST_FOURCC_ARGS (subtype));
  GST_LOG ("%*s  manufacturer:  %" GST_FOURCC_FORMAT, depth, "",
      GST_FOURCC_ARGS (manufacturer));
  GST_LOG ("%*s  flags:         %08x", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  flags mask:    %08x", depth, "", GET_UINT32 (data));

  /* quicktime uses pascal string, mp4 zero-terminated string */
  if (gst_byte_reader_peek_string (data, &name)) {
    GST_LOG ("%*s  name:          %s", depth, "", name);
  } else {
    gchar buf[256];
    guint len;

    len = gst_byte_reader_get_uint8_unchecked (data);
    if (qt_atom_parser_has_remaining (data, len)) {
      memcpy (buf, gst_byte_reader_peek_data_unchecked (data), len);
      buf[len] = '\0';
      GST_LOG ("%*s  name:          %s", depth, "", buf);
    }
  }
  return TRUE;
}

gboolean
qtdemux_dump_vmhd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  if (!qt_atom_parser_has_remaining (data, 4 + 4))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  mode/color:    %08x", depth, "", GET_UINT32 (data));
  return TRUE;
}

gboolean
qtdemux_dump_dref (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %u", depth, "", num_entries);
  for (i = 0; i < num_entries; i++) {
    guint32 size = 0, fourcc;

    if (!gst_byte_reader_get_uint32_be (data, &size) ||
        !qt_atom_parser_get_fourcc (data, &fourcc) || size < 8 ||
        !gst_byte_reader_skip (data, size - 8))
      return FALSE;

    GST_LOG ("%*s    size:          %u", depth, "", size);
    GST_LOG ("%*s    type:          %" GST_FOURCC_FORMAT, depth, "",
        GST_FOURCC_ARGS (fourcc));
  }
  return TRUE;
}

static gboolean
qtdemux_dump_stsd_avc1 (GstQTDemux * qtdemux, GstByteReader * data, guint size,
    int depth)
{
  guint32 fourcc;

  /* Size of avc1 = 78 bytes */
  if (size < (6 + 2 + 4 + 4 + 4 + 4 + 2 + 2 + 4 + 4 + 4 + 2 + 1 + 31 + 2 + 2))
    return FALSE;

  gst_byte_reader_skip_unchecked (data, 6);
  GST_LOG_OBJECT (qtdemux, "%*s    data reference:%d", depth, "",
      GET_UINT16 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    version/rev.:  %08x", depth, "",
      GET_UINT32 (data));
  fourcc = GET_FOURCC (data);
  GST_LOG_OBJECT (qtdemux, "%*s    vendor:        %" GST_FOURCC_FORMAT, depth,
      "", GST_FOURCC_ARGS (fourcc));
  GST_LOG_OBJECT (qtdemux, "%*s    temporal qual: %u", depth, "",
      GET_UINT32 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    spatial qual:  %u", depth, "",
      GET_UINT32 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    width:         %u", depth, "",
      GET_UINT16 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    height:        %u", depth, "",
      GET_UINT16 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    horiz. resol:  %g", depth, "",
      GET_FP32 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    vert. resol.:  %g", depth, "",
      GET_FP32 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    data size:     %u", depth, "",
      GET_UINT32 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    frame count:   %u", depth, "",
      GET_UINT16 (data));
  /* something is not right with this, it's supposed to be a string but it's
   * not apparently, so just skip this for now */
  gst_byte_reader_skip_unchecked (data, 1 + 31);
  GST_LOG_OBJECT (qtdemux, "%*s    compressor:    (skipped)", depth, "");
  GST_LOG_OBJECT (qtdemux, "%*s    depth:         %u", depth, "",
      GET_UINT16 (data));
  GST_LOG_OBJECT (qtdemux, "%*s    color table ID:%u", depth, "",
      GET_UINT16 (data));

  return TRUE;
}

gboolean
qtdemux_dump_stsd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  for (i = 0; i < num_entries; i++) {
    GstByteReader sub;
    guint32 size, remain;
    guint32 fourcc;

    if (!gst_byte_reader_get_uint32_be (data, &size) ||
        !qt_atom_parser_get_fourcc (data, &fourcc))
      return FALSE;

    GST_LOG_OBJECT (qtdemux, "%*s    size:          %u", depth, "", size);
    GST_LOG_OBJECT (qtdemux, "%*s    type:          %" GST_FOURCC_FORMAT, depth,
        "", GST_FOURCC_ARGS (fourcc));

    remain = gst_byte_reader_get_remaining (data);
    /* Size includes the 8 bytes we just read: len & fourcc, then 8 bytes
     * version, flags, entries_count */
    if (size > remain + 8) {
      GST_LOG_OBJECT (qtdemux,
          "Not enough data left for this atom (have %u need %u)", remain, size);
      return FALSE;
    }

    qt_atom_parser_peek_sub (data, 0, size, &sub);
    switch (fourcc) {
      case FOURCC_avc1:
        if (!qtdemux_dump_stsd_avc1 (qtdemux, &sub, size, depth + 1))
          return FALSE;
        break;
      case FOURCC_mp4s:
        if (!gst_byte_reader_get_uint32_be (&sub, &ver_flags) ||
            !gst_byte_reader_get_uint32_be (&sub, &num_entries))
          return FALSE;
        if (!qtdemux_dump_unknown (qtdemux, &sub, depth + 1))
          return FALSE;
        break;
      default:
        /* Unknown stsd data, dump the bytes */
        if (!qtdemux_dump_unknown (qtdemux, &sub, depth + 1))
          return FALSE;
        break;
    }

    if (!gst_byte_reader_skip (data, size - (4 + 4)))
      return FALSE;
  }
  return TRUE;
}

gboolean
qtdemux_dump_stts (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4 + 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    count:         %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s    duration:      %u", depth, "", GET_UINT32 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_stps (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    sample:        %u", depth, "", GET_UINT32 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_stss (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    sample:        %u", depth, "", GET_UINT32 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_stsc (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4 + 4 + 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    first chunk:   %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s    sample per ch: %u", depth, "", GET_UINT32 (data));
    GST_LOG ("%*s    sample desc id:%08x", depth, "", GET_UINT32 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_stsz (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, sample_size = 0, num_entries = 0;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &sample_size))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  sample size:   %d", depth, "", sample_size);

  if (sample_size == 0) {
    if (!gst_byte_reader_get_uint32_be (data, &num_entries))
      return FALSE;

    GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);
#if 0
    if (!qt_atom_parser_has_chunks (data, num_entries, 4))
      return FALSE;
    for (i = 0; i < num_entries; i++) {
      GST_LOG ("%*s    sample size:   %u", depth, "", GET_UINT32 (data));
    }
#endif
  }
  return TRUE;
}

gboolean
qtdemux_dump_stco (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    chunk offset:  %u", depth, "", GET_UINT32 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_ctts (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i, count, offset;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 4 + 4))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    count = GET_UINT32 (data);
    offset = GET_UINT32 (data);
    GST_LOG ("%*s    sample count :%8d offset: %8d", depth, "", count, offset);
  }
  return TRUE;
}

gboolean
qtdemux_dump_co64 (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 ver_flags = 0, num_entries = 0, i;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags) ||
      !gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);
  GST_LOG ("%*s  n entries:     %d", depth, "", num_entries);

  if (!qt_atom_parser_has_chunks (data, num_entries, 8))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    GST_LOG ("%*s    chunk offset:  %" G_GUINT64_FORMAT, depth, "",
        GET_UINT64 (data));
  }
  return TRUE;
}

gboolean
qtdemux_dump_dcom (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  if (!qt_atom_parser_has_remaining (data, 4))
    return FALSE;

  GST_LOG ("%*s  compression type: %" GST_FOURCC_FORMAT, depth, "",
      GST_FOURCC_ARGS (GET_FOURCC (data)));
  return TRUE;
}

gboolean
qtdemux_dump_cmvd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  if (!qt_atom_parser_has_remaining (data, 4))
    return FALSE;

  GST_LOG ("%*s  length: %d", depth, "", GET_UINT32 (data));
  return TRUE;
}

gboolean
qtdemux_dump_mfro (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  if (!qt_atom_parser_has_remaining (data, 4))
    return FALSE;

  GST_LOG ("%*s  size: %d", depth, "", GET_UINT32 (data));
  return TRUE;
}

gboolean
qtdemux_dump_tfra (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint64 time = 0, moof_offset = 0;
  guint32 len = 0, num_entries = 0, ver_flags = 0, track_id = 0, i;
  guint value_size, traf_size, trun_size, sample_size;

  if (!gst_byte_reader_get_uint32_be (data, &ver_flags))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", ver_flags);

  if (!gst_byte_reader_get_uint32_be (data, &track_id) ||
      gst_byte_reader_get_uint32_be (data, &len) ||
      gst_byte_reader_get_uint32_be (data, &num_entries))
    return FALSE;

  GST_LOG ("%*s  track ID:      %u", depth, "", track_id);
  GST_LOG ("%*s  length:        0x%x", depth, "", len);
  GST_LOG ("%*s  n entries:     %u", depth, "", num_entries);

  value_size = ((ver_flags >> 24) == 1) ? sizeof (guint64) : sizeof (guint32);
  sample_size = (len & 3) + 1;
  trun_size = ((len & 12) >> 2) + 1;
  traf_size = ((len & 48) >> 4) + 1;

  if (!qt_atom_parser_has_chunks (data, num_entries,
          value_size + value_size + traf_size + trun_size + sample_size))
    return FALSE;

  for (i = 0; i < num_entries; i++) {
    qt_atom_parser_get_offset (data, value_size, &time);
    qt_atom_parser_get_offset (data, value_size, &moof_offset);
    GST_LOG ("%*s    time:          %" G_GUINT64_FORMAT, depth, "", time);
    GST_LOG ("%*s    moof_offset:   %" G_GUINT64_FORMAT,
        depth, "", moof_offset);
    GST_LOG ("%*s    traf_number:   %u", depth, "",
        qt_atom_parser_get_uint_with_size_unchecked (data, traf_size));
    GST_LOG ("%*s    trun_number:   %u", depth, "",
        qt_atom_parser_get_uint_with_size_unchecked (data, trun_size));
    GST_LOG ("%*s    sample_number: %u", depth, "",
        qt_atom_parser_get_uint_with_size_unchecked (data, sample_size));
  }

  return TRUE;
}

gboolean
qtdemux_dump_tfhd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 flags = 0, n = 0, track_id = 0;
  guint64 base_data_offset = 0;

  if (!gst_byte_reader_skip (data, 1) ||
      !gst_byte_reader_get_uint24_be (data, &flags))
    return FALSE;
  GST_LOG ("%*s  flags: %08x", depth, "", flags);

  if (!gst_byte_reader_get_uint32_be (data, &track_id))
    return FALSE;
  GST_LOG ("%*s  track_id: %u", depth, "", track_id);

  if (flags & TF_BASE_DATA_OFFSET) {
    if (!gst_byte_reader_get_uint64_be (data, &base_data_offset))
      return FALSE;
    GST_LOG ("%*s    base-data-offset: %" G_GUINT64_FORMAT,
        depth, "", base_data_offset);
  }

  if (flags & TF_SAMPLE_DESCRIPTION_INDEX) {
    if (!gst_byte_reader_get_uint32_be (data, &n))
      return FALSE;
    GST_LOG ("%*s    sample-description-index: %u", depth, "", n);
  }

  if (flags & TF_DEFAULT_SAMPLE_DURATION) {
    if (!gst_byte_reader_get_uint32_be (data, &n))
      return FALSE;
    GST_LOG ("%*s    default-sample-duration:  %u", depth, "", n);
  }

  if (flags & TF_DEFAULT_SAMPLE_SIZE) {
    if (!gst_byte_reader_get_uint32_be (data, &n))
      return FALSE;
    GST_LOG ("%*s    default-sample-size:  %u", depth, "", n);
  }

  if (flags & TF_DEFAULT_SAMPLE_FLAGS) {
    if (!gst_byte_reader_get_uint32_be (data, &n))
      return FALSE;
    GST_LOG ("%*s    default-sample-flags:  %u", depth, "", n);
  }

  GST_LOG ("%*s    duration-is-empty:     %s", depth, "",
      flags & TF_DURATION_IS_EMPTY ? "yes" : "no");

  return TRUE;
}

gboolean
qtdemux_dump_trun (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 flags = 0, samples_count = 0, data_offset = 0, first_sample_flags = 0;
  guint32 sample_duration = 0, sample_size = 0, sample_flags =
      0, composition_time_offsets = 0;
  int i = 0;

  if (!gst_byte_reader_skip (data, 1) ||
      !gst_byte_reader_get_uint24_be (data, &flags))
    return FALSE;

  GST_LOG ("%*s  flags: %08x", depth, "", flags);

  if (!gst_byte_reader_get_uint32_be (data, &samples_count))
    return FALSE;
  GST_LOG ("%*s  samples_count: %u", depth, "", samples_count);

  if (flags & TR_DATA_OFFSET) {
    if (!gst_byte_reader_get_uint32_be (data, &data_offset))
      return FALSE;
    GST_LOG ("%*s    data-offset: %u", depth, "", data_offset);
  }

  if (flags & TR_FIRST_SAMPLE_FLAGS) {
    if (!gst_byte_reader_get_uint32_be (data, &first_sample_flags))
      return FALSE;
    GST_LOG ("%*s    first-sample-flags: %u", depth, "", first_sample_flags);
  }

  for (i = 0; i < samples_count; i++) {
    if (flags & TR_SAMPLE_DURATION) {
      if (!gst_byte_reader_get_uint32_be (data, &sample_duration))
        return FALSE;
      GST_LOG ("%*s    sample-duration:  %u", depth, "", sample_duration);
    }

    if (flags & TR_SAMPLE_SIZE) {
      if (!gst_byte_reader_get_uint32_be (data, &sample_size))
        return FALSE;
      GST_LOG ("%*s    sample-size:  %u", depth, "", sample_size);
    }

    if (flags & TR_SAMPLE_FLAGS) {
      if (!gst_byte_reader_get_uint32_be (data, &sample_flags))
        return FALSE;
      GST_LOG ("%*s    sample-flags:  %u", depth, "", sample_flags);
    }

    if (flags & TR_COMPOSITION_TIME_OFFSETS) {
      if (!gst_byte_reader_get_uint32_be (data, &composition_time_offsets))
        return FALSE;
      GST_LOG ("%*s    composition_time_offsets:  %u", depth, "",
          composition_time_offsets);
    }
  }

  return TRUE;
}

gboolean
qtdemux_dump_trex (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  if (!qt_atom_parser_has_remaining (data, 4 + 4 + 4 + 4 + 4 + 4))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  track ID:      %08x", depth, "", GET_UINT32 (data));
  GST_LOG ("%*s  default sample desc. index: %08x", depth, "",
      GET_UINT32 (data));
  GST_LOG ("%*s  default sample duration:    %08x", depth, "",
      GET_UINT32 (data));
  GST_LOG ("%*s  default sample size:        %08x", depth, "",
      GET_UINT32 (data));
  GST_LOG ("%*s  default sample flags:       %08x", depth, "",
      GET_UINT32 (data));

  return TRUE;
}

gboolean
qtdemux_dump_mehd (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 version = 0;
  guint64 fragment_duration;
  guint value_size;

  if (!gst_byte_reader_get_uint32_be (data, &version))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", version);

  value_size = ((version >> 24) == 1) ? sizeof (guint64) : sizeof (guint32);
  if (qt_atom_parser_get_offset (data, value_size, &fragment_duration)) {
    GST_LOG ("%*s  fragment duration: %" G_GUINT64_FORMAT,
        depth, "", fragment_duration);
    return TRUE;
  }

  return FALSE;
}

gboolean
qtdemux_dump_tfdt (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 version = 0;
  guint64 decode_time;
  guint value_size;

  if (!gst_byte_reader_get_uint32_be (data, &version))
    return FALSE;

  GST_LOG ("%*s  version/flags: %08x", depth, "", version);

  value_size = ((version >> 24) == 1) ? sizeof (guint64) : sizeof (guint32);
  if (qt_atom_parser_get_offset (data, value_size, &decode_time)) {
    GST_LOG ("%*s  Track fragment decode time: %" G_GUINT64_FORMAT,
        depth, "", decode_time);
    return TRUE;
  }

  return FALSE;
}

gboolean
qtdemux_dump_sdtp (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  guint32 version;
  guint8 val;
  guint i = 1;

  version = GET_UINT32 (data);
  GST_LOG ("%*s  version/flags: %08x", depth, "", version);

  /* the sample_count is specified in the stsz or stz2 box.
   * the information for a sample is stored in a single byte,
   * so we read until there are no remaining bytes */
  while (qt_atom_parser_has_remaining (data, 1)) {
    val = GET_UINT8 (data);
    GST_LOG ("%*s     sample number: %d", depth, "", i);
    GST_LOG ("%*s     sample_depends_on: %d", depth, "",
        ((guint16) (val)) & 0x3);
    GST_LOG ("%*s     sample_is_depended_on: %d", depth, "",
        ((guint16) (val >> 2)) & 0x3);
    GST_LOG ("%*s     sample_has_redundancy: %d", depth, "",
        ((guint16) (val >> 4)) & 0x3);
    GST_LOG ("%*s     early display: %d", depth, "",
        ((guint16) (val >> 6)) & 0x1);
    ++i;
  }
  return TRUE;
}

gboolean
qtdemux_dump_unknown (GstQTDemux * qtdemux, GstByteReader * data, int depth)
{
  int len;

  len = gst_byte_reader_get_remaining (data);
  GST_LOG ("%*s  length: %d", depth, "", len);

  GST_MEMDUMP_OBJECT (qtdemux, "unknown atom data",
      gst_byte_reader_peek_data_unchecked (data), len);
  return TRUE;
}

static gboolean
qtdemux_node_dump_foreach (GNode * node, gpointer qtdemux)
{
  GstByteReader parser;
  guint8 *buffer = (guint8 *) node->data;       /* FIXME: move to byte reader */
  guint32 node_length;
  guint32 fourcc;
  const QtNodeType *type;
  int depth;

  node_length = GST_READ_UINT32_BE (buffer);
  fourcc = GST_READ_UINT32_LE (buffer + 4);

  g_warn_if_fail (node_length >= 8);

  gst_byte_reader_init (&parser, buffer + 8, node_length - 8);

  type = qtdemux_type_get (fourcc);

  depth = (g_node_depth (node) - 1) * 2;
  GST_LOG ("%*s'%" GST_FOURCC_FORMAT "', [%d], %s",
      depth, "", GST_FOURCC_ARGS (fourcc), node_length, type->name);

  if (type->dump) {
    gboolean ret;

    ret = type->dump (GST_QTDEMUX_CAST (qtdemux), &parser, depth);

    if (!ret) {
      GST_WARNING ("%*s  not enough data parsing atom %" GST_FOURCC_FORMAT,
          depth, "", GST_FOURCC_ARGS (fourcc));
    }
  }

  return FALSE;
}

gboolean
qtdemux_node_dump (GstQTDemux * qtdemux, GNode * node)
{
  if (_gst_debug_min < GST_LEVEL_LOG)
    return TRUE;

  g_node_traverse (node, G_PRE_ORDER, G_TRAVERSE_ALL, -1,
      qtdemux_node_dump_foreach, qtdemux);
  return TRUE;
}
