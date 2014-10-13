/* GStreamer
 * Copyright (C) <2007> Sebastian Dröge <slomo@circular-chaos.org>
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
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif


#include <glib.h>
#include <math.h>

#include "_kiss_fft_guts_f32.h"
#include "kiss_fftr_f32.h"
#include "gstfft.h"
#include "gstfftf32.h"

/**
 * SECTION:gstfftf32
 * @short_description: FFT functions for 32 bit float samples
 *
 * #GstFFTF32 provides a FFT implementation and related functions for
 * 32 bit float samples. To use this call gst_fft_f32_new() for
 * allocating a #GstFFTF32 instance with the appropriate parameters and
 * then call gst_fft_f32_fft() or gst_fft_f32_inverse_fft() to perform the
 * FFT or inverse FFT on a buffer of samples.
 *
 * After use free the #GstFFTF32 instance with gst_fft_f32_free().
 *
 * For the best performance use gst_fft_next_fast_length() to get a
 * number that is entirely a product of 2, 3 and 5 and use this as the
 * @len parameter for gst_fft_f32_new().
 *
 * The @len parameter specifies the number of samples in the time domain that
 * will be processed or generated. The number of samples in the frequency domain
 * is @len/2 + 1. To get n samples in the frequency domain use 2*n - 2 as @len.
 *
 * Before performing the FFT on time domain data it usually makes sense
 * to apply a window function to it. For this gst_fft_f32_window() can comfortably
 * be used.
 *
 * Be aware, that you can't simply run gst_fft_f32_inverse_fft() on the
 * resulting frequency data of gst_fft_f32_fft() to get the original data back.
 * The relation between them is iFFT (FFT (x)) = x * nfft where nfft is the
 * length of the FFT. This also has to be taken into account when calculation
 * the magnitude of the frequency data.
 *
 */

struct _GstFFTF32
{
  void *cfg;
  gboolean inverse;
  gint len;
};

/**
 * gst_fft_f32_new:
 * @len: Length of the FFT in the time domain
 * @inverse: %TRUE if the #GstFFTF32 instance should be used for the inverse FFT
 *
 * This returns a new #GstFFTF32 instance with the given parameters. It makes
 * sense to keep one instance for several calls for speed reasons.
 *
 * @len must be even and to get the best performance a product of
 * 2, 3 and 5. To get the next number with this characteristics use
 * gst_fft_next_fast_length().
 *
 * Returns: a new #GstFFTF32 instance.
 */
GstFFTF32 *
gst_fft_f32_new (gint len, gboolean inverse)
{
  GstFFTF32 *self;
  gsize subsize = 0, memneeded;

  g_return_val_if_fail (len > 0, NULL);
  g_return_val_if_fail (len % 2 == 0, NULL);

  kiss_fftr_f32_alloc (len, (inverse) ? 1 : 0, NULL, &subsize);
  memneeded = ALIGN_STRUCT (sizeof (GstFFTF32)) + subsize;

  self = (GstFFTF32 *) g_malloc0 (memneeded);

  self->cfg = (((guint8 *) self) + ALIGN_STRUCT (sizeof (GstFFTF32)));
  self->cfg = kiss_fftr_f32_alloc (len, (inverse) ? 1 : 0, self->cfg, &subsize);
  g_assert (self->cfg);

  self->inverse = inverse;
  self->len = len;

  return self;
}

/**
 * gst_fft_f32_fft:
 * @self: #GstFFTF32 instance for this call
 * @timedata: Buffer of the samples in the time domain
 * @freqdata: Target buffer for the samples in the frequency domain
 *
 * This performs the FFT on @timedata and puts the result in @freqdata.
 *
 * @timedata must have as many samples as specified with the @len parameter while
 * allocating the #GstFFTF32 instance with gst_fft_f32_new().
 *
 * @freqdata must be large enough to hold @len/2 + 1 #GstFFTF32Complex frequency
 * domain samples.
 *
 */
void
gst_fft_f32_fft (GstFFTF32 * self, const gfloat * timedata,
    GstFFTF32Complex * freqdata)
{
  g_return_if_fail (self);
  g_return_if_fail (!self->inverse);
  g_return_if_fail (timedata);
  g_return_if_fail (freqdata);

  kiss_fftr_f32 (self->cfg, timedata, (kiss_fft_f32_cpx *) freqdata);
}

/**
 * gst_fft_f32_inverse_fft:
 * @self: #GstFFTF32 instance for this call
 * @freqdata: Buffer of the samples in the frequency domain
 * @timedata: Target buffer for the samples in the time domain
 *
 * This performs the inverse FFT on @freqdata and puts the result in @timedata.
 *
 * @freqdata must have @len/2 + 1 samples, where @len is the parameter specified
 * while allocating the #GstFFTF32 instance with gst_fft_f32_new().
 *
 * @timedata must be large enough to hold @len time domain samples.
 *
 */
void
gst_fft_f32_inverse_fft (GstFFTF32 * self, const GstFFTF32Complex * freqdata,
    gfloat * timedata)
{
  g_return_if_fail (self);
  g_return_if_fail (self->inverse);
  g_return_if_fail (timedata);
  g_return_if_fail (freqdata);

  kiss_fftri_f32 (self->cfg, (kiss_fft_f32_cpx *) freqdata, timedata);
}

/**
 * gst_fft_f32_free:
 * @self: #GstFFTF32 instance for this call
 *
 * This frees the memory allocated for @self.
 *
 */
void
gst_fft_f32_free (GstFFTF32 * self)
{
  g_free (self);
}

/**
 * gst_fft_f32_window:
 * @self: #GstFFTF32 instance for this call
 * @timedata: Time domain samples
 * @window: Window function to apply
 *
 * This calls the window function @window on the @timedata sample buffer.
 *
 */
void
gst_fft_f32_window (GstFFTF32 * self, gfloat * timedata, GstFFTWindow window)
{
  gint i, len;

  g_return_if_fail (self);
  g_return_if_fail (timedata);

  len = self->len;

  switch (window) {
    case GST_FFT_WINDOW_RECTANGULAR:
      /* do nothing */
      break;
    case GST_FFT_WINDOW_HAMMING:
      for (i = 0; i < len; i++)
        timedata[i] *= (0.53836 - 0.46164 * cos (2.0 * G_PI * i / len));
      break;
    case GST_FFT_WINDOW_HANN:
      for (i = 0; i < len; i++)
        timedata[i] *= (0.5 - 0.5 * cos (2.0 * G_PI * i / len));
      break;
    case GST_FFT_WINDOW_BARTLETT:
      for (i = 0; i < len; i++)
        timedata[i] *= (1.0 - fabs ((2.0 * i - len) / len));
      break;
    case GST_FFT_WINDOW_BLACKMAN:
      for (i = 0; i < len; i++)
        timedata[i] *= (0.42 - 0.5 * cos ((2.0 * i) / len) +
            0.08 * cos ((4.0 * i) / len));
      break;
    default:
      g_assert_not_reached ();
      break;
  }
}
