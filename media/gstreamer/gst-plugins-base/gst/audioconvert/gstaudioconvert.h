/* GStreamer
 * Copyright (C) 2005 Wim Taymans <wim at fluendo dot com>
 *
 * gstaudioconvert.h: Convert audio to different audio formats automatically
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

#ifndef __GST_AUDIO_CONVERT_H__
#define __GST_AUDIO_CONVERT_H__

#include <gst/gst.h>
#include <gst/base/gstbasetransform.h>
#include <gst/audio/audio.h>

#include "audioconvert.h"

#define GST_TYPE_AUDIO_CONVERT            (gst_audio_convert_get_type())
#define GST_AUDIO_CONVERT(obj)            (G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIO_CONVERT,GstAudioConvert))
#define GST_AUDIO_CONVERT_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIO_CONVERT,GstAudioConvertClass))
#define GST_IS_AUDIO_CONVERT(obj)         (G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIO_CONVERT))
#define GST_IS_AUDIO_CONVERT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIO_CONVERT))

typedef struct _GstAudioConvert GstAudioConvert;
typedef struct _GstAudioConvertClass GstAudioConvertClass;

/**
 * GstAudioConvert:
 *
 * The audioconvert object structure.
 */
struct _GstAudioConvert
{
  GstBaseTransform element;

  AudioConvertCtx ctx;

  GstAudioConvertDithering dither;
  GstAudioConvertNoiseShaping ns;
};

struct _GstAudioConvertClass
{
  GstBaseTransformClass parent_class;
};

#endif /* __GST_AUDIO_CONVERT_H__ */
