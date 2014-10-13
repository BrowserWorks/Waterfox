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

#ifndef __DESCRIPTORS_H__
#define __DESCRIPTORS_H__

#include <glib.h>
#include <string.h>
#include "properties.h"

/*
 * Tags for descriptor (each kind is represented by a number, instead of fourcc as in atoms)
 */
#define OBJECT_DESC_TAG            0x01
#define INIT_OBJECT_DESC_TAG       0x02
#define ES_DESCRIPTOR_TAG          0x03
#define DECODER_CONFIG_DESC_TAG    0x04
#define DECODER_SPECIFIC_INFO_TAG  0x05
#define SL_CONFIG_DESC_TAG         0x06
#define ES_ID_INC_TAG              0x0E
#define MP4_INIT_OBJECT_DESC_TAG   0x10

#define ESDS_OBJECT_TYPE_MPEG1_P3       0x6B
#define ESDS_OBJECT_TYPE_MPEG2_P7_MAIN  0x66
#define ESDS_OBJECT_TYPE_MPEG4_P7_LC    0x67
#define ESDS_OBJECT_TYPE_MPEG4_P7_SSR   0x68
#define ESDS_OBJECT_TYPE_MPEG4_P2       0x20
#define ESDS_OBJECT_TYPE_MPEG4_P3       0x40

#define ESDS_STREAM_TYPE_VISUAL         0x04
#define ESDS_STREAM_TYPE_AUDIO          0x05


typedef struct _BaseDescriptor
{
  guint8 tag;
  /* the first bit of each byte indicates if the next byte should be used */
  guint8 size[4];
} BaseDescriptor;

typedef struct _SLConfigDescriptor
{
  BaseDescriptor base;

  guint8 predefined;              /* everything is supposed predefined */
} SLConfigDescriptor;

typedef struct _DecoderSpecificInfoDescriptor
{
  BaseDescriptor base;
  guint32 length;
  guint8 *data;
} DecoderSpecificInfoDescriptor;

typedef struct _DecoderConfigDescriptor {
  BaseDescriptor base;

  guint8 object_type;

  /* following are condensed into streamType:
   * bit(6) streamType;
   * bit(1) upStream;
   * const bit(1) reserved=1;
  */
  guint8 stream_type;

  guint8 buffer_size_DB[3];
  guint32 max_bitrate;
  guint32 avg_bitrate;

  DecoderSpecificInfoDescriptor *dec_specific_info;
} DecoderConfigDescriptor;

typedef struct _ESDescriptor
{
  BaseDescriptor base;

  guint16 id;

  /* flags contains the following:
   * bit(1) streamDependenceFlag;
   * bit(1) URL_Flag;
   * bit(1) OCRstreamFlag;
   * bit(5) streamPriority;
   */
  guint8 flags;

  guint16 depends_on_es_id;
  guint8 url_length;              /* only if URL_flag is set */
  guint8 *url_string;             /* size is url_length */

  guint16 ocr_es_id;              /* only if OCRstreamFlag is set */

  DecoderConfigDescriptor dec_conf_desc;
  SLConfigDescriptor sl_conf_desc;

  /* optional remainder of ESDescriptor is not used */
} ESDescriptor;

/* --- FUNCTIONS --- */
void    desc_es_init                               (ESDescriptor *es);
ESDescriptor *desc_es_descriptor_new               (void);
guint64 desc_es_descriptor_copy_data               (ESDescriptor *es, guint8 **buffer,
                                                    guint64 *size, guint64 *offset);
void    desc_es_descriptor_clear                   (ESDescriptor *es);

DecoderSpecificInfoDescriptor *desc_dec_specific_info_new(void);
void    desc_dec_specific_info_free                (DecoderSpecificInfoDescriptor *dsid);
void    desc_dec_specific_info_alloc_data          (DecoderSpecificInfoDescriptor *dsid,
                                                    guint32 size);

#endif /* __DESCRIPTORS_H__ */
