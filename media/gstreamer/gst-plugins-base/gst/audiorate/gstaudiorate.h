/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
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

#ifndef __GST_AUDIO_RATE_H__
#define __GST_AUDIO_RATE_H__

#include <gst/gst.h>
#include <gst/audio/audio.h>

G_BEGIN_DECLS

#define GST_TYPE_AUDIO_RATE \
  (gst_audio_rate_get_type())
#define GST_AUDIO_RATE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIO_RATE,GstAudioRate))
#define GST_AUDIO_RATE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIO_RATE,GstAudioRate))
#define GST_IS_AUDIO_RATE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIO_RATE))
#define GST_IS_AUDIO_RATE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIO_RATE))

typedef struct _GstAudioRate GstAudioRate;
typedef struct _GstAudioRateClass GstAudioRateClass;

/**
 * GstAudioRate:
 *
 * Opaque data structure.
 */
struct _GstAudioRate
{
  GstElement element;

  GstPad *sinkpad, *srcpad;

  /* audio format */
  GstAudioInfo info;

  /* stats */
  guint64 in, out, add, drop;
  gboolean silent;
  guint64 tolerance;
  gboolean skip_to_first;

  /* audio state */
  guint64 next_offset;
  guint64 next_ts;

  gboolean discont;

  gboolean new_segment;
  /* we accept all formats on the sink */
  GstSegment sink_segment;
  /* we output TIME format on the src */
  GstSegment src_segment;
};

struct _GstAudioRateClass
{
  GstElementClass parent_class;
};

GType gst_audio_rate_get_type (void);

G_END_DECLS

#endif /* __GST_AUDIO_RATE_H__ */
