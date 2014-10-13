/* GStreamer
 * Copyright (C) 2013 Alessandro Decina <alessandro.d@gmail.com>
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

#ifndef _GST_ATDEC_H_
#define _GST_ATDEC_H_

#include <gst/audio/gstaudiodecoder.h>
#include <AudioToolbox/AudioToolbox.h>

G_BEGIN_DECLS

#define GST_TYPE_ATDEC   (gst_atdec_get_type())
#define GST_ATDEC(obj)   (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_ATDEC,GstATDec))
#define GST_ATDEC_CLASS(klass)   (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_ATDEC,GstATDecClass))
#define GST_IS_ATDEC(obj)   (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_ATDEC))
#define GST_IS_ATDEC_CLASS(obj)   (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_ATDEC))

typedef struct _GstATDec GstATDec;
typedef struct _GstATDecClass GstATDecClass;

struct _GstATDec
{
  GstAudioDecoder decoder;
  AudioQueueRef queue;
  gint spf;
  guint64 input_position, output_position;
};

struct _GstATDecClass
{
  GstAudioDecoderClass decoder_class;
};

GType gst_atdec_get_type (void);

G_END_DECLS

#endif
