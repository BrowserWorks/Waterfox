/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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

#ifndef __GST_QTDEMUX_TYPES_H__
#define __GST_QTDEMUX_TYPES_H__

#include <gst/gst.h>
#include <gst/base/gstbytereader.h>

#include "qtdemux.h"

G_BEGIN_DECLS

typedef gboolean (*QtDumpFunc) (GstQTDemux * qtdemux, GstByteReader * data,
    int depth);

typedef struct _QtNodeType QtNodeType;

#define QT_UINT32(a)  (GST_READ_UINT32_BE(a))
#define QT_UINT24(a)  (GST_READ_UINT32_BE(a) >> 8)
#define QT_UINT16(a)  (GST_READ_UINT16_BE(a))
#define QT_UINT8(a)   (GST_READ_UINT8(a))
#define QT_FP32(a)    ((GST_READ_UINT32_BE(a))/65536.0)
#define QT_SFP32(a)   (((gint)(GST_READ_UINT32_BE(a)))/65536.0)
#define QT_FP16(a)    ((GST_READ_UINT16_BE(a))/256.0)
#define QT_FOURCC(a)  (GST_READ_UINT32_LE(a))
#define QT_UINT64(a)  ((((guint64)QT_UINT32(a))<<32)|QT_UINT32(((guint8 *)a)+4))

typedef enum {
  QT_FLAG_NONE      = (0),
  QT_FLAG_CONTAINER = (1 << 0)
} QtFlags;

struct _QtNodeType {
  guint32      fourcc;
  const gchar *name;
  QtFlags      flags;
  QtDumpFunc   dump;
};

enum TfFlags
{
  TF_BASE_DATA_OFFSET         = 0x000001,   /* base-data-offset-present */
  TF_SAMPLE_DESCRIPTION_INDEX = 0x000002,   /* sample-description-index-present */
  TF_DEFAULT_SAMPLE_DURATION  = 0x000008,   /* default-sample-duration-present */
  TF_DEFAULT_SAMPLE_SIZE      = 0x000010,   /* default-sample-size-present */
  TF_DEFAULT_SAMPLE_FLAGS     = 0x000020,   /* default-sample-flags-present */
  TF_DURATION_IS_EMPTY        = 0x100000    /* duration-is-empty */
};

enum TrFlags
{
  TR_DATA_OFFSET              = 0x000001,   /* data-offset-present */
  TR_FIRST_SAMPLE_FLAGS       = 0x000004,   /* first-sample-flags-present */
  TR_SAMPLE_DURATION          = 0x000100,   /* sample-duration-present */
  TR_SAMPLE_SIZE              = 0x000200,   /* sample-size-present */
  TR_SAMPLE_FLAGS             = 0x000400,   /* sample-flags-present */
  TR_COMPOSITION_TIME_OFFSETS = 0x000800    /* sample-composition-time-offsets-presents */
};

const QtNodeType *qtdemux_type_get (guint32 fourcc);

G_END_DECLS

#endif /* __GST_QTDEMUX_TYPES_H__ */
