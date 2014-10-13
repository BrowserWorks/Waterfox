/* GStreamer
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2007-2008> Sebastian Dröge <sebastian.droege@collabora.co.uk>
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


#ifndef __AUDIO_RESAMPLE_H__
#define __AUDIO_RESAMPLE_H__

#include <gst/gst.h>
#include <gst/base/gstbasetransform.h>
#include <gst/audio/audio.h>

#include "speex_resampler_wrapper.h"

G_BEGIN_DECLS

#define GST_TYPE_AUDIO_RESAMPLE \
  (gst_audio_resample_get_type())
#define GST_AUDIO_RESAMPLE(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIO_RESAMPLE,GstAudioResample))
#define GST_AUDIO_RESAMPLE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIO_RESAMPLE,GstAudioResampleClass))
#define GST_IS_AUDIO_RESAMPLE(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIO_RESAMPLE))
#define GST_IS_AUDIO_RESAMPLE_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIO_RESAMPLE))

typedef struct _GstAudioResample GstAudioResample;
typedef struct _GstAudioResampleClass GstAudioResampleClass;

/**
 * GstAudioResample:
 *
 * Opaque data structure.
 */
struct _GstAudioResample {
  GstBaseTransform element;

  /* <private> */
  gboolean need_discont;

  GstClockTime t0;
  guint64 in_offset0;
  guint64 out_offset0;
  guint64 samples_in;
  guint64 samples_out;
  
  guint64 num_gap_samples;
  guint64 num_nongap_samples;

  GstAudioInfo in;
  GstAudioInfo out;

  /* properties */
  gint quality;

  /* state */
  gboolean fp;
  gint width;
  gint channels;
  gint inrate;
  gint outrate;

  SpeexResamplerSincFilterMode sinc_filter_mode;
  guint32 sinc_filter_auto_threshold;

  guint8 *tmp_in;
  guint tmp_in_size;

  guint8 *tmp_out;
  guint tmp_out_size;

  SpeexResamplerState *state;
  const SpeexResampleFuncs *funcs;
};

struct _GstAudioResampleClass {
  GstBaseTransformClass parent_class;
};

GType gst_audio_resample_get_type(void);

G_END_DECLS

#endif /* __AUDIO_RESAMPLE_H__ */
