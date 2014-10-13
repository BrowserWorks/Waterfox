/* GStreamer RIFF I/O
 * Copyright (C) 2003 Ronald Bultje <rbultje@ronald.bitfreak.net>
 *
 * riff-read.c: RIFF input file parsing
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
#include <gst/gstutils.h>
#include <gst/tag/tag.h>

#include "riff-read.h"

GST_DEBUG_CATEGORY_EXTERN (riff_debug);
#define GST_CAT_DEFAULT riff_debug

/**
 * gst_riff_read_chunk:
 * @element: caller element (used for debugging).
 * @pad: pad to pull data from.
 * @offset: offset to pull from, incremented by this function.
 * @tag: fourcc of the chunk (returned by this function).
 * @chunk_data: buffer (returned by this function).
 *
 * Reads a single chunk of data. 'JUNK' chunks are skipped
 * automatically.
 *
 * Returns: flow status.
 */

GstFlowReturn
gst_riff_read_chunk (GstElement * element,
    GstPad * pad, guint64 * _offset, guint32 * tag, GstBuffer ** _chunk_data)
{
  GstBuffer *buf;
  GstFlowReturn res;
  GstMapInfo info;
  guint size;
  guint64 offset = *_offset;

  g_return_val_if_fail (element != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (pad != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (_offset != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (tag != NULL, GST_FLOW_ERROR);
  g_return_val_if_fail (_chunk_data != NULL, GST_FLOW_ERROR);

skip_junk:
  size = 8;
  buf = NULL;
  if ((res = gst_pad_pull_range (pad, offset, size, &buf)) != GST_FLOW_OK)
    return res;
  else if (gst_buffer_get_size (buf) < size)
    goto too_small;

  gst_buffer_map (buf, &info, GST_MAP_READ);
  *tag = GST_READ_UINT32_LE (info.data);
  size = GST_READ_UINT32_LE (info.data + 4);
  gst_buffer_unmap (buf, &info);
  gst_buffer_unref (buf);

  GST_DEBUG_OBJECT (element, "fourcc=%" GST_FOURCC_FORMAT ", size=%u",
      GST_FOURCC_ARGS (*tag), size);

  /* skip 'JUNK' chunks */
  if (*tag == GST_RIFF_TAG_JUNK || *tag == GST_RIFF_TAG_JUNQ) {
    size = GST_ROUND_UP_2 (size);
    *_offset += 8 + size;
    offset += 8 + size;
    GST_DEBUG_OBJECT (element, "skipping JUNK chunk");
    goto skip_junk;
  }

  buf = NULL;
  if ((res = gst_pad_pull_range (pad, offset + 8, size, &buf)) != GST_FLOW_OK)
    return res;
  else if (gst_buffer_get_size (buf) < size)
    goto too_small;

  *_chunk_data = buf;
  *_offset += 8 + GST_ROUND_UP_2 (size);

  return GST_FLOW_OK;

  /* ERRORS */
too_small:
  {
    /* short read, we return EOS to mark the EOS case */
    GST_DEBUG_OBJECT (element, "not enough data (available=%" G_GSIZE_FORMAT
        ", needed=%u)", gst_buffer_get_size (buf), size);
    gst_buffer_unref (buf);
    return GST_FLOW_EOS;
  }
}

/**
 * gst_riff_parse_chunk:
 * @element: caller element (used for debugging).
 * @buf: input buffer.
 * @offset: offset in the buffer in the caller. Is incremented
 *          by the read size by this function.
 * @fourcc: fourcc (returned by this function0 of the chunk.
 * @chunk_data: buffer (returned by the function) containing the
 *              chunk data, which may be NULL if chunksize == 0
 *
 * Reads a single chunk.
 *
 * Returns: FALSE on error, TRUE otherwise
 */
gboolean
gst_riff_parse_chunk (GstElement * element, GstBuffer * buf,
    guint * _offset, guint32 * _fourcc, GstBuffer ** chunk_data)
{
  guint size, bufsize;
  guint32 fourcc;
  guint8 *ptr;
  GstMapInfo info;
  guint offset = *_offset;

  g_return_val_if_fail (element != NULL, FALSE);
  g_return_val_if_fail (buf != NULL, FALSE);
  g_return_val_if_fail (_offset != NULL, FALSE);
  g_return_val_if_fail (_fourcc != NULL, FALSE);
  g_return_val_if_fail (chunk_data != NULL, FALSE);

  *chunk_data = NULL;
  *_fourcc = 0;

  bufsize = gst_buffer_get_size (buf);

  if (bufsize == offset)
    goto end_offset;

  if (bufsize < offset + 8)
    goto too_small;

  /* read header */
  gst_buffer_map (buf, &info, GST_MAP_READ);
  ptr = info.data + offset;
  fourcc = GST_READ_UINT32_LE (ptr);
  size = GST_READ_UINT32_LE (ptr + 4);
  gst_buffer_unmap (buf, &info);

  GST_DEBUG_OBJECT (element, "fourcc=%" GST_FOURCC_FORMAT ", size=%u",
      GST_FOURCC_ARGS (fourcc), size);

  /* be paranoid: size may be nonsensical value here, such as (guint) -1 */
  if (G_UNLIKELY (size > G_MAXINT))
    goto bogus_size;

  if (bufsize < size + 8 + offset) {
    GST_DEBUG_OBJECT (element,
        "Needed chunk data (%d) is more than available (%d), shortcutting",
        size, bufsize - 8 - offset);
    size = bufsize - 8 - offset;
  }

  if (size)
    *chunk_data =
        gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL, offset + 8, size);
  else
    *chunk_data = NULL;

  *_fourcc = fourcc;
  *_offset += 8 + GST_ROUND_UP_2 (size);

  return TRUE;

  /* ERRORS */
end_offset:
  {
    GST_DEBUG_OBJECT (element, "End of chunk (offset %d)", offset);
    return FALSE;
  }
too_small:
  {
    GST_DEBUG_OBJECT (element,
        "Failed to parse chunk header (offset %d, %d available, %d needed)",
        offset, bufsize, 8);
    return FALSE;
  }
bogus_size:
  {
    GST_ERROR_OBJECT (element, "Broken file: bogus chunk size %u", size);
    return FALSE;
  }
}

/**
 * gst_riff_parse_file_header:
 * @element: caller element (used for debugging/error).
 * @buf: input buffer from which the file header will be parsed,
 *       should be at least 12 bytes long.
 * @doctype: a fourcc (returned by this function) to indicate the
 *           type of document (according to the header).
 *
 * Reads the first few bytes from the provided buffer, checks
 * if this stream is a RIFF stream, and determines document type.
 * This function takes ownership of @buf so it should not be used anymore
 * after calling this function.
 *
 * Returns: FALSE if this is not a RIFF stream (in which case the
 * caller should error out; we already throw an error), or TRUE
 * if it is.
 */
gboolean
gst_riff_parse_file_header (GstElement * element,
    GstBuffer * buf, guint32 * doctype)
{
  GstMapInfo info;
  guint32 tag;

  g_return_val_if_fail (buf != NULL, FALSE);
  g_return_val_if_fail (doctype != NULL, FALSE);

  gst_buffer_map (buf, &info, GST_MAP_READ);
  if (info.size < 12)
    goto too_small;

  tag = GST_READ_UINT32_LE (info.data);
  if (tag != GST_RIFF_TAG_RIFF && tag != GST_RIFF_TAG_AVF0)
    goto not_riff;

  *doctype = GST_READ_UINT32_LE (info.data + 8);
  gst_buffer_unmap (buf, &info);

  gst_buffer_unref (buf);

  return TRUE;

  /* ERRORS */
too_small:
  {
    GST_ELEMENT_ERROR (element, STREAM, WRONG_TYPE, (NULL),
        ("Not enough data to parse RIFF header (%" G_GSIZE_FORMAT " available,"
            " %d needed)", info.size, 12));
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return FALSE;
  }
not_riff:
  {
    GST_ELEMENT_ERROR (element, STREAM, WRONG_TYPE, (NULL),
        ("Stream is no RIFF stream: 0x%" G_GINT32_MODIFIER "x", tag));
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return FALSE;
  }
}

/**
 * gst_riff_parse_strh:
 * @element: caller element (used for debugging/error).
 * @buf: input data to be used for parsing, stripped from header.
 * @strh: a pointer (returned by this function) to a filled-in
 *        strh structure. Caller should free it.
 *
 * Parses a strh structure from input data. Takes ownership of @buf.
 *
 * Returns: TRUE if parsing succeeded, otherwise FALSE. The stream
 *          should be skipped on error, but it is not fatal.
 */

gboolean
gst_riff_parse_strh (GstElement * element,
    GstBuffer * buf, gst_riff_strh ** _strh)
{
  gst_riff_strh *strh;
  GstMapInfo info;

  g_return_val_if_fail (buf != NULL, FALSE);
  g_return_val_if_fail (_strh != NULL, FALSE);

  gst_buffer_map (buf, &info, GST_MAP_READ);
  if (info.size < sizeof (gst_riff_strh))
    goto too_small;

  strh = g_memdup (info.data, info.size);
  gst_buffer_unmap (buf, &info);

  gst_buffer_unref (buf);

#if (G_BYTE_ORDER == G_BIG_ENDIAN)
  strh->type = GUINT32_FROM_LE (strh->type);
  strh->fcc_handler = GUINT32_FROM_LE (strh->fcc_handler);
  strh->flags = GUINT32_FROM_LE (strh->flags);
  strh->priority = GUINT32_FROM_LE (strh->priority);
  strh->init_frames = GUINT32_FROM_LE (strh->init_frames);
  strh->scale = GUINT32_FROM_LE (strh->scale);
  strh->rate = GUINT32_FROM_LE (strh->rate);
  strh->start = GUINT32_FROM_LE (strh->start);
  strh->length = GUINT32_FROM_LE (strh->length);
  strh->bufsize = GUINT32_FROM_LE (strh->bufsize);
  strh->quality = GUINT32_FROM_LE (strh->quality);
  strh->samplesize = GUINT32_FROM_LE (strh->samplesize);
#endif

  /* avoid divisions by zero */
  if (!strh->scale)
    strh->scale = 1;
  if (!strh->rate)
    strh->rate = 1;

  /* debug */
  GST_INFO_OBJECT (element, "strh tag found:");
  GST_INFO_OBJECT (element, " type        %" GST_FOURCC_FORMAT,
      GST_FOURCC_ARGS (strh->type));
  GST_INFO_OBJECT (element, " fcc_handler %" GST_FOURCC_FORMAT,
      GST_FOURCC_ARGS (strh->fcc_handler));
  GST_INFO_OBJECT (element, " flags       0x%08x", strh->flags);
  GST_INFO_OBJECT (element, " priority    %d", strh->priority);
  GST_INFO_OBJECT (element, " init_frames %d", strh->init_frames);
  GST_INFO_OBJECT (element, " scale       %d", strh->scale);
  GST_INFO_OBJECT (element, " rate        %d", strh->rate);
  GST_INFO_OBJECT (element, " start       %d", strh->start);
  GST_INFO_OBJECT (element, " length      %d", strh->length);
  GST_INFO_OBJECT (element, " bufsize     %d", strh->bufsize);
  GST_INFO_OBJECT (element, " quality     %d", strh->quality);
  GST_INFO_OBJECT (element, " samplesize  %d", strh->samplesize);

  *_strh = strh;

  return TRUE;

  /* ERRORS */
too_small:
  {
    GST_ERROR_OBJECT (element,
        "Too small strh (%" G_GSIZE_FORMAT " available, %d needed)",
        info.size, (int) sizeof (gst_riff_strh));
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return FALSE;
  }
}

/**
 * gst_riff_parse_strf_vids:
 * @element: caller element (used for debugging/error).
 * @buf: input data to be used for parsing, stripped from header.
 * @strf: a pointer (returned by this function) to a filled-in
 *        strf/vids structure. Caller should free it.
 * @data: a pointer (returned by this function) to a buffer
 *        containing extradata for this particular stream (e.g.
 *        palette, codec initialization data).
 *
 * Parses a video stream´s strf structure plus optionally some
 * extradata from input data. This function takes ownership of @buf.
 *
 * Returns: TRUE if parsing succeeded, otherwise FALSE. The stream
 *          should be skipped on error, but it is not fatal.
 */

gboolean
gst_riff_parse_strf_vids (GstElement * element,
    GstBuffer * buf, gst_riff_strf_vids ** _strf, GstBuffer ** data)
{
  gst_riff_strf_vids *strf;
  GstMapInfo info;

  g_return_val_if_fail (buf != NULL, FALSE);
  g_return_val_if_fail (_strf != NULL, FALSE);
  g_return_val_if_fail (data != NULL, FALSE);

  gst_buffer_map (buf, &info, GST_MAP_READ);
  if (info.size < sizeof (gst_riff_strf_vids))
    goto too_small;

  strf = g_memdup (info.data, info.size);
  gst_buffer_unmap (buf, &info);

#if (G_BYTE_ORDER == G_BIG_ENDIAN)
  strf->size = GUINT32_FROM_LE (strf->size);
  strf->width = GUINT32_FROM_LE (strf->width);
  strf->height = GUINT32_FROM_LE (strf->height);
  strf->planes = GUINT16_FROM_LE (strf->planes);
  strf->bit_cnt = GUINT16_FROM_LE (strf->bit_cnt);
  strf->compression = GUINT32_FROM_LE (strf->compression);
  strf->image_size = GUINT32_FROM_LE (strf->image_size);
  strf->xpels_meter = GUINT32_FROM_LE (strf->xpels_meter);
  strf->ypels_meter = GUINT32_FROM_LE (strf->ypels_meter);
  strf->num_colors = GUINT32_FROM_LE (strf->num_colors);
  strf->imp_colors = GUINT32_FROM_LE (strf->imp_colors);
#endif

  /* size checking */
  *data = NULL;
  if (strf->size > info.size) {
    GST_WARNING_OBJECT (element,
        "strf_vids header gave %d bytes data, only %" G_GSIZE_FORMAT
        " available", strf->size, info.size);
    strf->size = info.size;
  }
  if (sizeof (gst_riff_strf_vids) < info.size) {
    *data =
        gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL,
        sizeof (gst_riff_strf_vids), info.size - sizeof (gst_riff_strf_vids));
  }
  gst_buffer_unref (buf);

  /* debug */
  GST_INFO_OBJECT (element, "strf tag found in context vids:");
  GST_INFO_OBJECT (element, " size        %d", strf->size);
  GST_INFO_OBJECT (element, " width       %d", strf->width);
  GST_INFO_OBJECT (element, " height      %d", strf->height);
  GST_INFO_OBJECT (element, " planes      %d", strf->planes);
  GST_INFO_OBJECT (element, " bit_cnt     %d", strf->bit_cnt);
  GST_INFO_OBJECT (element, " compression %" GST_FOURCC_FORMAT,
      GST_FOURCC_ARGS (strf->compression));
  GST_INFO_OBJECT (element, " image_size  %d", strf->image_size);
  GST_INFO_OBJECT (element, " xpels_meter %d", strf->xpels_meter);
  GST_INFO_OBJECT (element, " ypels_meter %d", strf->ypels_meter);
  GST_INFO_OBJECT (element, " num_colors  %d", strf->num_colors);
  GST_INFO_OBJECT (element, " imp_colors  %d", strf->imp_colors);
  if (*data)
    GST_INFO_OBJECT (element, " %" G_GSIZE_FORMAT " bytes extradata",
        gst_buffer_get_size (*data));

  *_strf = strf;

  return TRUE;

  /* ERRORS */
too_small:
  {
    GST_ERROR_OBJECT (element,
        "Too small strf_vids (%" G_GSIZE_FORMAT " available, %d needed)",
        info.size, (int) sizeof (gst_riff_strf_vids));
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return FALSE;
  }
}

/**
 * gst_riff_parse_strf_auds:
 * @element: caller element (used for debugging/error).
 * @buf: input data to be used for parsing, stripped from header.
 * @strf: a pointer (returned by this function) to a filled-in
 *        strf/auds structure. Caller should free it.
 * @data: a pointer (returned by this function) to a buffer
 *        containing extradata for this particular stream (e.g.
 *        codec initialization data).
 *
 * Parses an audio stream´s strf structure plus optionally some
 * extradata from input data. This function takes ownership of @buf.
 * use.
 *
 * Returns: TRUE if parsing succeeded, otherwise FALSE. The stream
 *          should be skipped on error, but it is not fatal.
 */
gboolean
gst_riff_parse_strf_auds (GstElement * element,
    GstBuffer * buf, gst_riff_strf_auds ** _strf, GstBuffer ** data)
{
  gst_riff_strf_auds *strf;
  GstMapInfo info;

  g_return_val_if_fail (buf != NULL, FALSE);
  g_return_val_if_fail (_strf != NULL, FALSE);
  g_return_val_if_fail (data != NULL, FALSE);

  gst_buffer_map (buf, &info, GST_MAP_READ);
  if (info.size < sizeof (gst_riff_strf_auds))
    goto too_small;

  strf = g_memdup (info.data, info.size);

#if (G_BYTE_ORDER == G_BIG_ENDIAN)
  strf->format = GUINT16_FROM_LE (strf->format);
  strf->channels = GUINT16_FROM_LE (strf->channels);
  strf->rate = GUINT32_FROM_LE (strf->rate);
  strf->av_bps = GUINT32_FROM_LE (strf->av_bps);
  strf->blockalign = GUINT16_FROM_LE (strf->blockalign);
  strf->bits_per_sample = GUINT16_FROM_LE (strf->bits_per_sample);
#endif

  /* size checking */
  *data = NULL;
  if (info.size > sizeof (gst_riff_strf_auds) + 2) {
    gint len;

    len = GST_READ_UINT16_LE (&info.data[16]);
    if (len + 2 + sizeof (gst_riff_strf_auds) > info.size) {
      GST_WARNING_OBJECT (element,
          "Extradata indicated %d bytes, but only %" G_GSIZE_FORMAT
          " available", len, info.size - 2 - sizeof (gst_riff_strf_auds));
      len = info.size - 2 - sizeof (gst_riff_strf_auds);
    }
    if (len)
      *data = gst_buffer_copy_region (buf, GST_BUFFER_COPY_ALL,
          sizeof (gst_riff_strf_auds) + 2, len);
  }

  /* debug */
  GST_INFO_OBJECT (element, "strf tag found in context auds:");
  GST_INFO_OBJECT (element, " format      %d", strf->format);
  GST_INFO_OBJECT (element, " channels    %d", strf->channels);
  GST_INFO_OBJECT (element, " rate        %d", strf->rate);
  GST_INFO_OBJECT (element, " av_bps      %d", strf->av_bps);
  GST_INFO_OBJECT (element, " blockalign  %d", strf->blockalign);
  GST_INFO_OBJECT (element, " bits/sample %d", strf->bits_per_sample);
  if (*data)
    GST_INFO_OBJECT (element, " %" G_GSIZE_FORMAT " bytes extradata",
        gst_buffer_get_size (*data));

  gst_buffer_unmap (buf, &info);
  gst_buffer_unref (buf);

  *_strf = strf;

  return TRUE;

  /* ERROR */
too_small:
  {
    GST_ERROR_OBJECT (element,
        "Too small strf_auds (%" G_GSIZE_FORMAT " available"
        ", %" G_GSIZE_FORMAT " needed)", info.size,
        sizeof (gst_riff_strf_auds));
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return FALSE;
  }
}

/**
 * gst_riff_parse_strf_iavs:
 * @element: caller element (used for debugging/error).
 * @buf: input data to be used for parsing, stripped from header.
 * @strf: a pointer (returned by this function) to a filled-in
 *        strf/iavs structure. Caller should free it.
 * @data: a pointer (returned by this function) to a buffer
 *        containing extradata for this particular stream (e.g.
 *        codec initialization data).
 *
 * Parses a interleaved (also known as "complex")  stream´s strf
 * structure plus optionally some extradata from input data. This
 * function takes ownership of @buf.
 *
 * Returns: TRUE if parsing succeeded, otherwise FALSE.
 */

gboolean
gst_riff_parse_strf_iavs (GstElement * element,
    GstBuffer * buf, gst_riff_strf_iavs ** _strf, GstBuffer ** data)
{
  gst_riff_strf_iavs *strf;
  GstMapInfo info;

  g_return_val_if_fail (buf != NULL, FALSE);
  g_return_val_if_fail (_strf != NULL, FALSE);
  g_return_val_if_fail (data != NULL, FALSE);

  gst_buffer_map (buf, &info, GST_MAP_READ);
  if (info.size < sizeof (gst_riff_strf_iavs))
    goto too_small;

  strf = g_memdup (info.data, info.size);
  gst_buffer_unmap (buf, &info);

  gst_buffer_unref (buf);

#if (G_BYTE_ORDER == G_BIG_ENDIAN)
  strf->DVAAuxSrc = GUINT32_FROM_LE (strf->DVAAuxSrc);
  strf->DVAAuxCtl = GUINT32_FROM_LE (strf->DVAAuxCtl);
  strf->DVAAuxSrc1 = GUINT32_FROM_LE (strf->DVAAuxSrc1);
  strf->DVAAuxCtl1 = GUINT32_FROM_LE (strf->DVAAuxCtl1);
  strf->DVVAuxSrc = GUINT32_FROM_LE (strf->DVVAuxSrc);
  strf->DVVAuxCtl = GUINT32_FROM_LE (strf->DVVAuxCtl);
  strf->DVReserved1 = GUINT32_FROM_LE (strf->DVReserved1);
  strf->DVReserved2 = GUINT32_FROM_LE (strf->DVReserved2);
#endif

  /* debug */
  GST_INFO_OBJECT (element, "strf tag found in context iavs:");
  GST_INFO_OBJECT (element, " DVAAuxSrc   %08x", strf->DVAAuxSrc);
  GST_INFO_OBJECT (element, " DVAAuxCtl   %08x", strf->DVAAuxCtl);
  GST_INFO_OBJECT (element, " DVAAuxSrc1  %08x", strf->DVAAuxSrc1);
  GST_INFO_OBJECT (element, " DVAAuxCtl1  %08x", strf->DVAAuxCtl1);
  GST_INFO_OBJECT (element, " DVVAuxSrc   %08x", strf->DVVAuxSrc);
  GST_INFO_OBJECT (element, " DVVAuxCtl   %08x", strf->DVVAuxCtl);
  GST_INFO_OBJECT (element, " DVReserved1 %08x", strf->DVReserved1);
  GST_INFO_OBJECT (element, " DVReserved2 %08x", strf->DVReserved2);

  *_strf = strf;
  *data = NULL;

  return TRUE;

  /* ERRORS */
too_small:
  {
    GST_ERROR_OBJECT (element,
        "Too small strf_iavs (%" G_GSIZE_FORMAT "available"
        ", %" G_GSIZE_FORMAT " needed)", info.size,
        sizeof (gst_riff_strf_iavs));
    gst_buffer_unmap (buf, &info);
    gst_buffer_unref (buf);
    return FALSE;
  }
}

static void
parse_tag_value (GstElement * element, GstTagList * taglist, const gchar * type,
    guint8 * ptr, guint tsize)
{
  static const gchar *env_vars[] = { "GST_AVI_TAG_ENCODING",
    "GST_RIFF_TAG_ENCODING", "GST_TAG_ENCODING", NULL
  };
  GType tag_type;
  gchar *val;

  tag_type = gst_tag_get_type (type);
  val = gst_tag_freeform_string_to_utf8 ((gchar *) ptr, tsize, env_vars);

  if (val != NULL) {
    if (tag_type == G_TYPE_STRING) {
      gst_tag_list_add (taglist, GST_TAG_MERGE_APPEND, type, val, NULL);
    } else {
      GValue tag_val = { 0, };

      g_value_init (&tag_val, tag_type);
      if (gst_value_deserialize (&tag_val, val)) {
        gst_tag_list_add_value (taglist, GST_TAG_MERGE_APPEND, type, &tag_val);
      } else {
        GST_WARNING_OBJECT (element, "could not deserialize '%s' into a "
            "tag %s of type %s", val, type, g_type_name (tag_type));
      }
      g_value_unset (&tag_val);
    }
    g_free (val);
  } else {
    GST_WARNING_OBJECT (element, "could not extract %s tag", type);
  }
}

/**
 * gst_riff_parse_info:
 * @element: caller element (used for debugging/error).
 * @buf: input data to be used for parsing, stripped from header.
 * @taglist: a pointer to a taglist (returned by this function)
 *           containing information about this stream. May be
 *           NULL if no supported tags were found.
 *
 * Parses stream metadata from input data.
 */
void
gst_riff_parse_info (GstElement * element,
    GstBuffer * buf, GstTagList ** _taglist)
{
  GstMapInfo info;
  guint8 *ptr;
  gsize left;
  guint tsize;
  guint32 tag;
  const gchar *type;
  GstTagList *taglist;

  g_return_if_fail (_taglist != NULL);

  if (!buf) {
    *_taglist = NULL;
    return;
  }
  gst_buffer_map (buf, &info, GST_MAP_READ);

  taglist = gst_tag_list_new_empty ();

  ptr = info.data;
  left = info.size;

  while (left > 8) {
    tag = GST_READ_UINT32_LE (ptr);
    tsize = GST_READ_UINT32_LE (ptr + 4);

    GST_MEMDUMP_OBJECT (element, "tag chunk", ptr, MIN (tsize + 8, left));

    left -= 8;
    ptr += 8;

    GST_DEBUG ("tag %" GST_FOURCC_FORMAT ", size %u",
        GST_FOURCC_ARGS (tag), tsize);

    if (tsize > left) {
      GST_WARNING_OBJECT (element,
          "Tagsize %d is larger than available data %" G_GSIZE_FORMAT,
          tsize, left);
      tsize = left;
    }

    /* make uppercase */
    tag = tag & 0xDFDFDFDF;

    /* find out the type of metadata */
    switch (tag) {
      case GST_RIFF_INFO_IARL:
        type = GST_TAG_LOCATION;
        break;
      case GST_RIFF_INFO_IAAR:
        type = GST_TAG_ALBUM_ARTIST;
        break;
      case GST_RIFF_INFO_IART:
        type = GST_TAG_ARTIST;
        break;
      case GST_RIFF_INFO_ICMS:
        type = NULL;            /*"Commissioner"; */
        break;
      case GST_RIFF_INFO_ICMT:
        type = GST_TAG_COMMENT;
        break;
      case GST_RIFF_INFO_ICOP:
        type = GST_TAG_COPYRIGHT;
        break;
      case GST_RIFF_INFO_ICRD:
        type = GST_TAG_DATE_TIME;
        break;
      case GST_RIFF_INFO_ICRP:
        type = NULL;            /*"Cropped"; */
        break;
      case GST_RIFF_INFO_IDIM:
        type = NULL;            /*"Dimensions"; */
        break;
      case GST_RIFF_INFO_IDPI:
        type = NULL;            /*"Dots per Inch"; */
        break;
      case GST_RIFF_INFO_IENG:
        type = NULL;            /*"Engineer"; */
        break;
      case GST_RIFF_INFO_IGNR:
        type = GST_TAG_GENRE;
        break;
      case GST_RIFF_INFO_IKEY:
        type = GST_TAG_KEYWORDS;
        break;
      case GST_RIFF_INFO_ILGT:
        type = NULL;            /*"Lightness"; */
        break;
      case GST_RIFF_INFO_IMED:
        type = NULL;            /*"Medium"; */
        break;
      case GST_RIFF_INFO_INAM:
        type = GST_TAG_TITLE;
        break;
      case GST_RIFF_INFO_IPLT:
        type = NULL;            /*"Palette"; */
        break;
      case GST_RIFF_INFO_IPRD:
        type = GST_TAG_ALBUM;
        break;
      case GST_RIFF_INFO_ISBJ:
        type = GST_TAG_ALBUM_ARTIST;
        break;
      case GST_RIFF_INFO_ISFT:
        type = GST_TAG_ENCODER;
        break;
      case GST_RIFF_INFO_ISHP:
        type = NULL;            /*"Sharpness"; */
        break;
      case GST_RIFF_INFO_ISRC:
        type = GST_TAG_ISRC;
        break;
      case GST_RIFF_INFO_ISRF:
        type = NULL;            /*"Source Form"; */
        break;
      case GST_RIFF_INFO_ITCH:
        type = NULL;            /*"Technician"; */
        break;
      case GST_RIFF_INFO_ITRK:
        type = GST_TAG_TRACK_NUMBER;
        break;
      default:
        type = NULL;
        GST_WARNING_OBJECT (element,
            "Unknown INFO (metadata) tag entry %" GST_FOURCC_FORMAT,
            GST_FOURCC_ARGS (tag));
        break;
    }

    if (type != NULL && ptr[0] != '\0') {
      GST_DEBUG_OBJECT (element, "mapped tag %" GST_FOURCC_FORMAT " to tag %s",
          GST_FOURCC_ARGS (tag), type);

      parse_tag_value (element, taglist, type, ptr, tsize);
    }

    if (tsize & 1) {
      tsize++;
      if (tsize > left)
        tsize = left;
    }

    ptr += tsize;
    left -= tsize;
  }

  if (!gst_tag_list_is_empty (taglist)) {
    GST_INFO_OBJECT (element, "extracted tags: %" GST_PTR_FORMAT, taglist);
    *_taglist = taglist;
  } else {
    *_taglist = NULL;
    gst_tag_list_unref (taglist);
  }
  gst_buffer_unmap (buf, &info);

  return;
}
