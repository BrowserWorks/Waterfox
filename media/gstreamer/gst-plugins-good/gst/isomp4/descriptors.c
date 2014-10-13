/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2008 Thiago Sousa Santos <thiagoss@embedded.ufcg.edu.br>
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
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "descriptors.h"

/*
 * Some mp4 structures (descriptors) use a coding scheme for
 * representing its size.
 * It is grouped in bytes. The 1st bit set to 1 means we need another byte,
 * 0 otherwise. The remaining 7 bits are the useful values.
 *
 * The next set of functions handle those values
 */

/*
 * Gets an unsigned integer and packs it into a 'expandable size' format
 * (as used by mp4 descriptors)
 * @size: the integer to be parsed
 * @ptr: the array to place the result
 * @array_size: the size of ptr array
 */
static void
expandable_size_parse (guint64 size, guint8 * ptr, guint32 array_size)
{
  int index = 0;

  memset (ptr, 0, sizeof (array_size));
  while (size > 0 && index < array_size) {
    ptr[index++] = (size > 0x7F ? 0x80 : 0x0) | (size & 0x7F);
    size = size >> 7;
  }
}

/*
 * Gets how many positions in an array holding an 'expandable size'
 * are really used
 *
 * @ptr: the array with the 'expandable size'
 * @array_size: the size of ptr array
 *
 * Returns: the number of really used positions
 */
static guint64
expandable_size_get_length (guint8 * ptr, guint32 array_size)
{
  gboolean next = TRUE;
  guint32 index = 0;

  while (next && index < array_size) {
    next = (ptr[index] & 0x80);
    index++;
  }
  return index;
}

/*
 * Initializers below
 */

static void
desc_base_descriptor_init (BaseDescriptor * bd, guint8 tag, guint32 size)
{
  bd->tag = tag;
  expandable_size_parse (size, bd->size, 4);
}

static void
desc_dec_specific_info_init (DecoderSpecificInfoDescriptor * dsid)
{
  desc_base_descriptor_init (&dsid->base, DECODER_SPECIFIC_INFO_TAG, 0);
  dsid->length = 0;
  dsid->data = NULL;
}

DecoderSpecificInfoDescriptor *
desc_dec_specific_info_new (void)
{
  DecoderSpecificInfoDescriptor *desc =
      g_new0 (DecoderSpecificInfoDescriptor, 1);
  desc_dec_specific_info_init (desc);
  return desc;
}

static void
desc_dec_conf_desc_init (DecoderConfigDescriptor * dcd)
{
  desc_base_descriptor_init (&dcd->base, DECODER_CONFIG_DESC_TAG, 0);
  dcd->dec_specific_info = NULL;
}

static void
desc_sl_conf_desc_init (SLConfigDescriptor * sl)
{
  desc_base_descriptor_init (&sl->base, SL_CONFIG_DESC_TAG, 0);
  sl->predefined = 0x2;
}

void
desc_es_init (ESDescriptor * es)
{
  desc_base_descriptor_init (&es->base, ES_DESCRIPTOR_TAG, 0);

  es->id = 0;
  es->flags = 0;
  es->depends_on_es_id = 0;
  es->ocr_es_id = 0;
  es->url_length = 0;
  es->url_string = NULL;

  desc_dec_conf_desc_init (&es->dec_conf_desc);
  desc_sl_conf_desc_init (&es->sl_conf_desc);
}

ESDescriptor *
desc_es_descriptor_new (void)
{
  ESDescriptor *es = g_new0 (ESDescriptor, 1);

  desc_es_init (es);
  return es;
}

/*
 * Deinitializers/Destructors below
 */

static void
desc_base_descriptor_clear (BaseDescriptor * base)
{
}

void
desc_dec_specific_info_free (DecoderSpecificInfoDescriptor * dsid)
{
  desc_base_descriptor_clear (&dsid->base);
  if (dsid->data) {
    g_free (dsid->data);
    dsid->data = NULL;
  }
  g_free (dsid);
}

static void
desc_dec_conf_desc_clear (DecoderConfigDescriptor * dec)
{
  desc_base_descriptor_clear (&dec->base);
  if (dec->dec_specific_info) {
    desc_dec_specific_info_free (dec->dec_specific_info);
  }
}

static void
desc_sl_config_descriptor_clear (SLConfigDescriptor * sl)
{
  desc_base_descriptor_clear (&sl->base);
}

void
desc_es_descriptor_clear (ESDescriptor * es)
{
  desc_base_descriptor_clear (&es->base);
  if (es->url_string) {
    g_free (es->url_string);
    es->url_string = NULL;
  }
  desc_dec_conf_desc_clear (&es->dec_conf_desc);
  desc_sl_config_descriptor_clear (&es->sl_conf_desc);
}

/*
 * Size handling functions below
 */

void
desc_dec_specific_info_alloc_data (DecoderSpecificInfoDescriptor * dsid,
    guint32 size)
{
  if (dsid->data) {
    g_free (dsid->data);
  }
  dsid->data = g_new0 (guint8, size);
  dsid->length = size;
}

static void
desc_base_descriptor_set_size (BaseDescriptor * bd, guint32 size)
{
  expandable_size_parse (size, bd->size, 4);
}

static guint64
desc_base_descriptor_get_size (BaseDescriptor * bd)
{
  guint64 size = 0;

  size += sizeof (guint8);
  size += expandable_size_get_length (bd->size, 4) * sizeof (guint8);
  return size;
}

static guint64
desc_sl_config_descriptor_get_size (SLConfigDescriptor * sl_desc)
{
  guint64 size = 0;
  guint64 extra_size = 0;

  size += desc_base_descriptor_get_size (&sl_desc->base);
  /* predefined */
  extra_size += sizeof (guint8);

  desc_base_descriptor_set_size (&sl_desc->base, extra_size);

  return size + extra_size;
}

static guint64
desc_dec_specific_info_get_size (DecoderSpecificInfoDescriptor * dsid)
{
  guint64 size = 0;
  guint64 extra_size = 0;

  size += desc_base_descriptor_get_size (&dsid->base);
  extra_size += sizeof (guint8) * dsid->length;
  desc_base_descriptor_set_size (&dsid->base, extra_size);
  return size + extra_size;
}

static guint64
desc_dec_config_descriptor_get_size (DecoderConfigDescriptor * dec_desc)
{
  guint64 size = 0;
  guint64 extra_size = 0;

  size += desc_base_descriptor_get_size (&dec_desc->base);
  /* object type */
  extra_size += sizeof (guint8);
  /* stream type */
  extra_size += sizeof (guint8);
  /* buffer size */
  extra_size += sizeof (guint8) * 3;
  /* max bitrate */
  extra_size += sizeof (guint32);
  /* avg bitrate */
  extra_size += sizeof (guint32);
  if (dec_desc->dec_specific_info) {
    extra_size += desc_dec_specific_info_get_size (dec_desc->dec_specific_info);
  }

  desc_base_descriptor_set_size (&dec_desc->base, extra_size);
  return size + extra_size;
}

static guint64
desc_es_descriptor_get_size (ESDescriptor * es)
{
  guint64 size = 0;
  guint64 extra_size = 0;

  size += desc_base_descriptor_get_size (&es->base);
  /* id */
  extra_size += sizeof (guint16);
  /* flags */
  extra_size += sizeof (guint8);
  /* depends_on_es_id */
  if (es->flags & 0x80) {
    extra_size += sizeof (guint16);
  }
  if (es->flags & 0x40) {
    /* url_length */
    extra_size += sizeof (guint8);
    /* url */
    extra_size += sizeof (gchar) * es->url_length;
  }
  if (es->flags & 0x20) {
    /* ocr_es_id */
    extra_size += sizeof (guint16);
  }

  extra_size += desc_dec_config_descriptor_get_size (&es->dec_conf_desc);
  extra_size += desc_sl_config_descriptor_get_size (&es->sl_conf_desc);

  desc_base_descriptor_set_size (&es->base, extra_size);

  return size + extra_size;
}

static gboolean
desc_es_descriptor_check_stream_dependency (ESDescriptor * es)
{
  return es->flags & 0x80;
}

static gboolean
desc_es_descriptor_check_url_flag (ESDescriptor * es)
{
  return es->flags & 0x40;
}

static gboolean
desc_es_descriptor_check_ocr (ESDescriptor * es)
{
  return es->flags & 0x20;
}

/* Copy/Serializations Functions below */

static guint64
desc_base_descriptor_copy_data (BaseDescriptor * desc, guint8 ** buffer,
    guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;

  prop_copy_uint8 (desc->tag, buffer, size, offset);
  prop_copy_uint8_array (desc->size, expandable_size_get_length (desc->size, 4),
      buffer, size, offset);
  return original_offset - *offset;
}

static guint64
desc_sl_config_descriptor_copy_data (SLConfigDescriptor * desc,
    guint8 ** buffer, guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;

  if (!desc_base_descriptor_copy_data (&desc->base, buffer, size, offset)) {
    return 0;
  }
  /* predefined attribute */
  prop_copy_uint8 (desc->predefined, buffer, size, offset);

  return *offset - original_offset;
}

static guint64
desc_dec_specific_info_copy_data (DecoderSpecificInfoDescriptor * desc,
    guint8 ** buffer, guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;

  if (!desc_base_descriptor_copy_data (&desc->base, buffer, size, offset)) {
    return 0;
  }
  prop_copy_uint8_array (desc->data, desc->length, buffer, size, offset);

  return *offset - original_offset;
}

static guint64
desc_dec_config_descriptor_copy_data (DecoderConfigDescriptor * desc,
    guint8 ** buffer, guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;

  if (!desc_base_descriptor_copy_data (&desc->base, buffer, size, offset)) {
    return 0;
  }

  prop_copy_uint8 (desc->object_type, buffer, size, offset);

  prop_copy_uint8 (desc->stream_type, buffer, size, offset);
  prop_copy_uint8_array (desc->buffer_size_DB, 3, buffer, size, offset);

  prop_copy_uint32 (desc->max_bitrate, buffer, size, offset);
  prop_copy_uint32 (desc->avg_bitrate, buffer, size, offset);

  if (desc->dec_specific_info) {
    if (!desc_dec_specific_info_copy_data (desc->dec_specific_info, buffer,
            size, offset)) {
      return 0;
    }
  }

  return *offset - original_offset;
}

guint64
desc_es_descriptor_copy_data (ESDescriptor * desc, guint8 ** buffer,
    guint64 * size, guint64 * offset)
{
  guint64 original_offset = *offset;

  /* must call this twice to have size fields of all contained descriptors set
   * correctly, and to have the size of the size fields taken into account */
  desc_es_descriptor_get_size (desc);
  desc_es_descriptor_get_size (desc);

  if (!desc_base_descriptor_copy_data (&desc->base, buffer, size, offset)) {
    return 0;
  }
  /* id and flags */
  prop_copy_uint16 (desc->id, buffer, size, offset);
  prop_copy_uint8 (desc->flags, buffer, size, offset);

  if (desc_es_descriptor_check_stream_dependency (desc)) {
    prop_copy_uint16 (desc->depends_on_es_id, buffer, size, offset);
  }

  if (desc_es_descriptor_check_url_flag (desc)) {
    prop_copy_size_string (desc->url_string, desc->url_length, buffer, size,
        offset);
  }

  if (desc_es_descriptor_check_ocr (desc)) {
    prop_copy_uint16 (desc->ocr_es_id, buffer, size, offset);
  }

  if (!desc_dec_config_descriptor_copy_data (&desc->dec_conf_desc, buffer, size,
          offset)) {
    return 0;
  }

  if (!desc_sl_config_descriptor_copy_data (&desc->sl_conf_desc, buffer, size,
          offset)) {
    return 0;
  }

  return *offset - original_offset;
}
