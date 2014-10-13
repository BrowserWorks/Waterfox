/* GStreamer
 * Copyright (C) 2004 Ronald Bultje <rbultje@ronald.bitfreak.net>
 *
 * audioconvert.h: audio format conversion library
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

#ifndef __AUDIO_CONVERT_H__
#define __AUDIO_CONVERT_H__

#include <gst/gst.h>
#include <gst/audio/audio.h>

GST_DEBUG_CATEGORY_EXTERN (audio_convert_debug);
#define GST_CAT_DEFAULT (audio_convert_debug)

/**
 * GstAudioConvertDithering:
 * @DITHER_NONE: No dithering
 * @DITHER_RPDF: Rectangular dithering
 * @DITHER_TPDF: Triangular dithering (default)
 * @DITHER_TPDF_HF: High frequency triangular dithering
 *
 * Set of available dithering methods when converting audio.
 */
typedef enum
{
  DITHER_NONE = 0,
  DITHER_RPDF,
  DITHER_TPDF,
  DITHER_TPDF_HF
} GstAudioConvertDithering;

/**
 * GstAudioConvertNoiseShaping:
 * @NOISE_SHAPING_NONE: No noise shaping (default)
 * @NOISE_SHAPING_ERROR_FEEDBACK: Error feedback
 * @NOISE_SHAPING_SIMPLE: Simple 2-pole noise shaping
 * @NOISE_SHAPING_MEDIUM: Medium 5-pole noise shaping
 * @NOISE_SHAPING_HIGH: High 8-pole noise shaping
 *
 * Set of available noise shaping methods
 */
typedef enum
{
  NOISE_SHAPING_NONE = 0,
  NOISE_SHAPING_ERROR_FEEDBACK,
  NOISE_SHAPING_SIMPLE,
  NOISE_SHAPING_MEDIUM,
  NOISE_SHAPING_HIGH
} GstAudioConvertNoiseShaping;

typedef struct _AudioConvertCtx AudioConvertCtx;
#if 0
typedef struct _AudioConvertFmt AudioConvertFmt;

struct _AudioConvertFmt
{
  /* general caps */
  gboolean is_int;
  gint endianness;
  gint width;
  gint rate;
  gint channels;
  GstAudioChannelPosition *pos;
  gboolean unpositioned_layout;

  /* int audio caps */
  gboolean sign;
  gint depth;

  gint unit_size;
};
#endif

typedef void (*AudioConvertUnpack) (gpointer src, gpointer dst, gint scale,
    gint count);
typedef void (*AudioConvertPack) (gpointer src, gpointer dst, gint scale,
    gint count);

typedef void (*AudioConvertMix) (AudioConvertCtx *, gpointer, gpointer, gint);
typedef void (*AudioConvertQuantize) (AudioConvertCtx * ctx, gpointer src,
    gpointer dst, gint count);

struct _AudioConvertCtx
{
  GstAudioInfo in;
  GstAudioInfo out;

  AudioConvertUnpack unpack;
  AudioConvertPack pack;

  /* channel conversion matrix, m[in_channels][out_channels].
   * If identity matrix, passthrough applies. */
  gfloat **matrix;
  /* temp storage for channelmix */
  gpointer tmp;

  gboolean in_default;
  gboolean mix_passthrough;
  gboolean out_default;

  gpointer tmpbuf;
  gint tmpbufsize;

  gint in_scale;
  gint out_scale;

  AudioConvertMix channel_mix;

  AudioConvertQuantize quantize;

  GstAudioConvertDithering dither;
  GstAudioConvertNoiseShaping ns;
  /* last random number generated per channel for hifreq TPDF dither */
  gpointer last_random;
  /* contains the past quantization errors, error[out_channels][count] */
  gdouble *error_buf;
};

gboolean audio_convert_prepare_context (AudioConvertCtx * ctx,
    GstAudioInfo * in, GstAudioInfo * out,
    GstAudioConvertDithering dither, GstAudioConvertNoiseShaping ns);
gboolean audio_convert_get_sizes (AudioConvertCtx * ctx, gint samples,
    gint * srcsize, gint * dstsize);

gboolean audio_convert_clean_context (AudioConvertCtx * ctx);

gboolean audio_convert_convert (AudioConvertCtx * ctx, gpointer src,
    gpointer dst, gint samples, gboolean src_writable);

#endif /* __AUDIO_CONVERT_H__ */
