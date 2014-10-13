/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2006> Nokia Corporation, Stefan Kost <stefan.kost@nokia.com>.
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


#ifndef __GST_WAVPARSE_H__
#define __GST_WAVPARSE_H__


#include <gst/gst.h>
#include "gst/riff/riff-ids.h"
#include "gst/riff/riff-read.h"
#include <gst/base/gstadapter.h>

G_BEGIN_DECLS

#define GST_TYPE_WAVPARSE \
  (gst_wavparse_get_type())
#define GST_WAVPARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_WAVPARSE,GstWavParse))
#define GST_WAVPARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_WAVPARSE,GstWavParseClass))
#define GST_IS_WAVPARSE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_WAVPARSE))
#define GST_IS_WAVPARSE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_WAVPARSE))

typedef enum {
  GST_WAVPARSE_START,
  GST_WAVPARSE_HEADER,
  GST_WAVPARSE_DATA
} GstWavParseState;

typedef struct _GstWavParse GstWavParse;
typedef struct _GstWavParseClass GstWavParseClass;

/**
 * GstWavParse:
 *
 * Opaque data structure.
 */
struct _GstWavParse {
  GstElement parent;

  /* pads */
  GstPad *sinkpad,*srcpad;

  /* for delayed source pad creation for when
   * we have the first chunk of data and know
   * the format for sure */
  GstCaps     *caps;
  GstTagList  *tags;
  GstToc      *toc;
  GList       *cues;
  GList       *labls;
  GList       *notes;
  GstEvent    *start_segment;

  /* WAVE decoding state */
  GstWavParseState state;
  gboolean abort_buffering;

  /* format of audio, see defines below */
  gint format;

  /* useful audio data */
  guint16 depth;
  guint32 rate;
  guint16 channels;
  guint16 blockalign;
  guint16 width;
  guint32 av_bps;
  guint32 fact;

  /* real bps used or 0 when no bitrate is known */
  guint32 bps;
  gboolean vbr;

  guint bytes_per_sample;
  guint max_buf_size;

  /* position in data part */
  guint64	offset;
  guint64	end_offset;
  guint64 	dataleft;
  /* offset/length of data part */
  guint64 	datastart;
  guint64 	datasize;
  /* duration in time */
  guint64 	duration;

  /* pending seek */
  GstEvent *seek_event;

  /* For streaming */
  GstAdapter *adapter;
  gboolean got_fmt;
  gboolean streaming;

  /* configured segment, start/stop expressed in time or bytes */
  GstSegment segment;

  /* for late pad configuration */
  gboolean first;
  /* discont after seek */
  gboolean discont;

  gboolean ignore_length;
};

struct _GstWavParseClass {
  GstElementClass parent_class;
};

GType gst_wavparse_get_type(void);

G_END_DECLS

#endif /* __GST_WAVPARSE_H__ */
