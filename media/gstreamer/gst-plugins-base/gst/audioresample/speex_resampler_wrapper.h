/* GStreamer
 * Copyright (C) 2007-2008 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#ifndef __SPEEX_RESAMPLER_WRAPPER_H__
#define __SPEEX_RESAMPLER_WRAPPER_H__

#define SPEEX_RESAMPLER_QUALITY_MAX 10
#define SPEEX_RESAMPLER_QUALITY_MIN 0
#define SPEEX_RESAMPLER_QUALITY_DEFAULT 4
#define SPEEX_RESAMPLER_QUALITY_VOIP 3
#define SPEEX_RESAMPLER_QUALITY_DESKTOP 5

#define SPEEX_RESAMPLER_SINC_FILTER_DEFAULT SPEEX_RESAMPLER_SINC_FILTER_AUTO
#define SPEEX_RESAMPLER_SINC_FILTER_AUTO_THRESHOLD_DEFAULT (1 * 1048576)

enum
{
  RESAMPLER_ERR_SUCCESS = 0,
  RESAMPLER_ERR_ALLOC_FAILED = 1,
  RESAMPLER_ERR_BAD_STATE = 2,
  RESAMPLER_ERR_INVALID_ARG = 3,
  RESAMPLER_ERR_PTR_OVERLAP = 4,

  RESAMPLER_ERR_MAX_ERROR
};

typedef enum {
  SPEEX_RESAMPLER_SINC_FILTER_INTERPOLATED   = 0,
  SPEEX_RESAMPLER_SINC_FILTER_FULL           = 1,
  SPEEX_RESAMPLER_SINC_FILTER_AUTO           = 2
} SpeexResamplerSincFilterMode;

typedef struct SpeexResamplerState_ SpeexResamplerState;

typedef struct {
  SpeexResamplerState *(*init) (guint32 nb_channels,
    guint32 in_rate, guint32 out_rate, gint quality,
    SpeexResamplerSincFilterMode sinc_filter_mode,
    guint32 sinc_filter_auto_threshold, gint * err);
  void (*destroy) (SpeexResamplerState * st);
  int (*process) (SpeexResamplerState *
    st, const guint8 * in, guint32 * in_len, guint8 * out, guint32 * out_len);
  int (*set_rate) (SpeexResamplerState * st,
    guint32 in_rate, guint32 out_rate);
  void (*get_rate) (SpeexResamplerState * st,
    guint32 * in_rate, guint32 * out_rate);
  void (*get_ratio) (SpeexResamplerState * st,
    guint32 * ratio_num, guint32 * ratio_den);
  int (*get_input_latency) (SpeexResamplerState * st);
  int (*get_filt_len) (SpeexResamplerState * st);
  int (*get_sinc_filter_mode) (SpeexResamplerState * st);
  int (*set_quality) (SpeexResamplerState * st, gint quality);
  int (*reset_mem) (SpeexResamplerState * st);
  int (*skip_zeros) (SpeexResamplerState * st);
  const char * (*strerror) (gint err);
  unsigned int width;
} SpeexResampleFuncs;

SpeexResamplerState *resample_float_resampler_init (guint32 nb_channels,
    guint32 in_rate, guint32 out_rate, gint quality,
    SpeexResamplerSincFilterMode sinc_filter_mode,
    guint32 sinc_filter_auto_threshold, gint * err);
void resample_float_resampler_destroy (SpeexResamplerState * st);
int resample_float_resampler_process_interleaved_float (SpeexResamplerState *
    st, const guint8 * in, guint32 * in_len, guint8 * out, guint32 * out_len);
int resample_float_resampler_set_rate (SpeexResamplerState * st,
    guint32 in_rate, guint32 out_rate);
void resample_float_resampler_get_rate (SpeexResamplerState * st,
    guint32 * in_rate, guint32 * out_rate);
void resample_float_resampler_get_ratio (SpeexResamplerState * st,
    guint32 * ratio_num, guint32 * ratio_den);
int resample_float_resampler_get_input_latency (SpeexResamplerState * st);
int resample_float_resampler_get_filt_len (SpeexResamplerState * st);
int resample_float_resampler_get_sinc_filter_mode (SpeexResamplerState * st);
int resample_float_resampler_set_quality (SpeexResamplerState * st, gint quality);
int resample_float_resampler_reset_mem (SpeexResamplerState * st);
int resample_float_resampler_skip_zeros (SpeexResamplerState * st);
const char * resample_float_resampler_strerror (gint err);

static const SpeexResampleFuncs float_funcs =
{
  resample_float_resampler_init,
  resample_float_resampler_destroy,
  resample_float_resampler_process_interleaved_float,
  resample_float_resampler_set_rate,
  resample_float_resampler_get_rate,
  resample_float_resampler_get_ratio,
  resample_float_resampler_get_input_latency,
  resample_float_resampler_get_filt_len,
  resample_float_resampler_get_sinc_filter_mode,
  resample_float_resampler_set_quality,
  resample_float_resampler_reset_mem,
  resample_float_resampler_skip_zeros,
  resample_float_resampler_strerror,
  32
};

SpeexResamplerState *resample_double_resampler_init (guint32 nb_channels,
    guint32 in_rate, guint32 out_rate, gint quality,
    SpeexResamplerSincFilterMode sinc_filter_mode,
    guint32 sinc_filter_auto_threshold, gint * err);
void resample_double_resampler_destroy (SpeexResamplerState * st);
int resample_double_resampler_process_interleaved_float (SpeexResamplerState *
    st, const guint8 * in, guint32 * in_len, guint8 * out, guint32 * out_len);
int resample_double_resampler_set_rate (SpeexResamplerState * st,
    guint32 in_rate, guint32 out_rate);
void resample_double_resampler_get_rate (SpeexResamplerState * st,
    guint32 * in_rate, guint32 * out_rate);
void resample_double_resampler_get_ratio (SpeexResamplerState * st,
    guint32 * ratio_num, guint32 * ratio_den);
int resample_double_resampler_get_input_latency (SpeexResamplerState * st);
int resample_double_resampler_get_filt_len (SpeexResamplerState * st);
int resample_double_resampler_get_sinc_filter_mode (SpeexResamplerState * st);
int resample_double_resampler_set_quality (SpeexResamplerState * st, gint quality);
int resample_double_resampler_reset_mem (SpeexResamplerState * st);
int resample_double_resampler_skip_zeros (SpeexResamplerState * st);
const char * resample_double_resampler_strerror (gint err);

static const SpeexResampleFuncs double_funcs =
{
  resample_double_resampler_init,
  resample_double_resampler_destroy,
  resample_double_resampler_process_interleaved_float,
  resample_double_resampler_set_rate,
  resample_double_resampler_get_rate,
  resample_double_resampler_get_ratio,
  resample_double_resampler_get_input_latency,
  resample_double_resampler_get_filt_len,
  resample_double_resampler_get_sinc_filter_mode,
  resample_double_resampler_set_quality,
  resample_double_resampler_reset_mem,
  resample_double_resampler_skip_zeros,
  resample_double_resampler_strerror,
  64
};

SpeexResamplerState *resample_int_resampler_init (guint32 nb_channels,
    guint32 in_rate, guint32 out_rate, gint quality,
    SpeexResamplerSincFilterMode sinc_filter_mode,
    guint32 sinc_filter_auto_threshold, gint * err);
void resample_int_resampler_destroy (SpeexResamplerState * st);
int resample_int_resampler_process_interleaved_int (SpeexResamplerState *
    st, const guint8 * in, guint32 * in_len, guint8 * out, guint32 * out_len);
int resample_int_resampler_set_rate (SpeexResamplerState * st,
    guint32 in_rate, guint32 out_rate);
void resample_int_resampler_get_rate (SpeexResamplerState * st,
    guint32 * in_rate, guint32 * out_rate);
void resample_int_resampler_get_ratio (SpeexResamplerState * st,
    guint32 * ratio_num, guint32 * ratio_den);
int resample_int_resampler_get_input_latency (SpeexResamplerState * st);
int resample_int_resampler_get_filt_len (SpeexResamplerState * st);
int resample_int_resampler_get_sinc_filter_mode (SpeexResamplerState * st);
int resample_int_resampler_set_quality (SpeexResamplerState * st, gint quality);
int resample_int_resampler_reset_mem (SpeexResamplerState * st);
int resample_int_resampler_skip_zeros (SpeexResamplerState * st);
const char * resample_int_resampler_strerror (gint err);

static const SpeexResampleFuncs int_funcs =
{
  resample_int_resampler_init,
  resample_int_resampler_destroy,
  resample_int_resampler_process_interleaved_int,
  resample_int_resampler_set_rate,
  resample_int_resampler_get_rate,
  resample_int_resampler_get_ratio,
  resample_int_resampler_get_input_latency,
  resample_int_resampler_get_filt_len,
  resample_int_resampler_get_sinc_filter_mode,
  resample_int_resampler_set_quality,
  resample_int_resampler_reset_mem,
  resample_int_resampler_skip_zeros,
  resample_int_resampler_strerror,
  16
};

#endif /* __SPEEX_RESAMPLER_WRAPPER_H__ */
