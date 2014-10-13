/*
 * Image Scaling Functions
 * Copyright (c) 2011 David A. Schleef <ds@schleef.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
/*
 *
 * Modified Lanczos scaling algorithm
 * ==================================
 *
 * This algorithm was developed by the author.  The primary goals of
 * the algorithm are high-quality video downscaling for medium scale
 * factors (in the range of 1.3x to 5.0x) using methods that can be
 * converted to SIMD code.  Concerns with existing algorithms were
 * mainly related to either over-soft filtering (Lanczos) or aliasing
 * (bilinear or any other method with inadequate sampling).
 *
 * The problems with bilinear scaling are apparent when downscaling
 * more than a factor of 2.  For example, when downscaling by a factor
 * of 3, only two-thirds of the input pixels contribute to the output
 * pixels.  This is only considering scaling in one direction; after
 * scaling both vertically and horizontally in a 2-D image, fewer than
 * half of the input pixels contribute to the output, so it should not
 * be surprising that the output is suboptimal.
 *
 * The problems with Lanczos scaling are more subtle.  From a theoretical
 * perspective, Lanczos is an optimal algorithm for resampling equally-
 * spaced values.  This theoretical perspective is based on analysis
 * done in frequency space, thus, Lanczos works very well for audio
 * resampling, since the ear hears primarily in frequency space.  The
 * human visual system is sensitive primarily in the spatial domain,
 * therefore any resampling algorithm should take this into account.
 * This difference is immediately clear in the size of resampling
 * window or envelope that is chosen for resampling: for audio, an
 * envelope of a=64 is typical, in image scaling, the envelope is
 * usually a=2 or a=3.
 *
 * One result of the HVS being sensitive in the spatial domain (and
 * also probably due to oversampling capabilities of the retina and
 * visual cortex) is that it is less sensitive to the exact magnitude
 * of high-frequency visual signals than to the appropriate amount of
 * energy in the nearby frequency band.  A Lanczos kernel with a=2
 * or a=3 strongly decreases the amount of energy in the high frequency
 * bands.  The energy in this area can be increased by increasing a,
 * which brings in energy from different areas of the image (bad for
 * reasons mentioned above), or by oversampling the input data.  We
 * have chosen two methods for doing the latter.  Firstly, there is
 * a sharpness parameter, which increases the cutoff frequency of the
 * filter, aliasing higher frequency noise into the passband.  And
 * secondly, there is the sharpen parameter, which increases the
 * contribution of high-frequency (but in-band) components.
 *
 * An alternate explanation of the usefulness of a sharpening filter
 * is that many natural images have a roughly 1/f spectrum.  In order
 * for a downsampled image to look more "natural" when high frequencies
 * are removed, the frequencies in the pass band near the cutoff
 * frequency are amplified, causing the spectrum to be more roughly
 * 1/f.  I said "roughly", not "literally".
 *
 * This alternate explanation is useful for understanding the author's
 * secondary motivation for developing this algorithm, namely, as a
 * method of video compression.  Several recent techniques (such as
 * HTTP Live Streaming and SVC) use image scaling as a method to get
 * increased compression out of nominally non-scalable codecs such as
 * H.264.  For optimal quality, it is thusly important to consider
 * the scaler and encoder as a combined unit.  Tuning of the sharpness
 * and sharpen parameters was performed using the Toro encoder tuner,
 * where scaled and encoded video was compared to unscaled and encoded
 * video.  This tuning suggested values that were very close to the
 * values chosen by manual inspection of scaled images and video.
 *
 * The optimal values of sharpen and sharpness were slightly different
 * depending whether the comparison was still images or video.  Video
 * comparisons were more sensitive to aliasing, since the aliasing
 * artifacts tended to move or "crawl" around the video.  The default
 * values are for video; image scaling may prefer higher values.
 *
 * A number of related techniques were rejected for various reasons.
 * An early technique of selecting the sharpness factor locally based
 * on edge detection (in order to use a higher sharpness values without
 * the corresponding aliasing on edges) worked very well for still
 * images, but caused too much "crawling" on textures in video.  Also,
 * this method is slow, as it does not parallelize well.
 *
 * Non-separable techniques were rejected because the fastest would
 * have been at least 4x slower.
 *
 * It is infrequently appreciated that image scaling should ideally be
 * done in linear light space.  Converting to linear light space has
 * a similar effect to a sharpening filter.  This approach was not
 * taken because the added benefit is minor compared to the additional
 * computational cost.  Morever, the benefit is decreased by increasing
 * the strength of the sharpening filter.
 *
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "vs_scanline.h"
#include "vs_image.h"

#include "gstvideoscaleorc.h"
#include <gst/gst.h>
#include <math.h>

#define NEED_CLAMP(x,a,b) ((x) < (a) || (x) > (b))

#define ROUND_UP_2(x)  (((x)+1)&~1)
#define ROUND_UP_4(x)  (((x)+3)&~3)
#define ROUND_UP_8(x)  (((x)+7)&~7)

#define SRC_LINE(i) (scale->src->pixels + scale->src->stride * (i))

#define TMP_LINE_S16(i) ((gint16 *)scale->tmpdata + (i)*(scale->dest->width))
#define TMP_LINE_S32(i) ((gint32 *)scale->tmpdata + (i)*(scale->dest->width))
#define TMP_LINE_FLOAT(i) ((float *)scale->tmpdata + (i)*(scale->dest->width))
#define TMP_LINE_DOUBLE(i) ((double *)scale->tmpdata + (i)*(scale->dest->width))
#define TMP_LINE_S16_AYUV(i) ((gint16 *)scale->tmpdata + (i)*4*(scale->dest->width))
#define TMP_LINE_S32_AYUV(i) ((gint32 *)scale->tmpdata + (i)*4*(scale->dest->width))
#define TMP_LINE_FLOAT_AYUV(i) ((float *)scale->tmpdata + (i)*4*(scale->dest->width))
#define TMP_LINE_DOUBLE_AYUV(i) ((double *)scale->tmpdata + (i)*4*(scale->dest->width))

#define PTR_OFFSET(a,b) ((void *)((char *)(a) + (b)))

typedef void (*HorizResampleFunc) (void *dest, const gint32 * offsets,
    const void *taps, const void *src, int n_taps, int shift, int n);

typedef struct _Scale1D Scale1D;
struct _Scale1D
{
  int n;
  double offset;
  double scale;

  double fx;
  double ex;
  int dx;

  int n_taps;
  gint32 *offsets;
  void *taps;
};

typedef struct _Scale Scale;
struct _Scale
{
  const VSImage *dest;
  const VSImage *src;

  double sharpness;
  gboolean dither;

  void *tmpdata;

  HorizResampleFunc horiz_resample_func;

  Scale1D x_scale1d;
  Scale1D y_scale1d;
};

static void
vs_image_scale_lanczos_Y_int16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen);
static void vs_image_scale_lanczos_Y_int32 (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);
static void vs_image_scale_lanczos_Y_float (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);
static void vs_image_scale_lanczos_Y_double (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);
static void
vs_image_scale_lanczos_AYUV_int16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen);
static void vs_image_scale_lanczos_AYUV_int32 (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);
static void vs_image_scale_lanczos_AYUV_float (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);
static void vs_image_scale_lanczos_AYUV_double (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);
static void vs_image_scale_lanczos_AYUV64_double (const VSImage * dest,
    const VSImage * src, uint8_t * tmpbuf, double sharpness, gboolean dither,
    double a, double sharpen);

static double
sinc (double x)
{
  if (x == 0)
    return 1;
  return sin (G_PI * x) / (G_PI * x);
}

static double
envelope (double x)
{
  if (x <= -1 || x >= 1)
    return 0;
  return sinc (x);
}

static int
scale1d_get_n_taps (int src_size, int dest_size, double a, double sharpness)
{
  double scale;
  double fx;
  int dx;

  scale = src_size / (double) dest_size;
  if (scale > 1.0) {
    fx = (1.0 / scale) * sharpness;
  } else {
    fx = (1.0) * sharpness;
  }
  dx = ceil (a / fx);

  return 2 * dx;
}

static void
scale1d_cleanup (Scale1D * scale)
{
  g_free (scale->taps);
  g_free (scale->offsets);
}

/*
 * Calculates a set of taps for each destination element in double
 * format.  Each set of taps sums to 1.0.
 *
 */
static void
scale1d_calculate_taps (Scale1D * scale, int src_size, int dest_size,
    int n_taps, double a, double sharpness, double sharpen)
{
  int j;
  double *tap_array;
  gint32 *offsets;
  double scale_offset;
  double scale_increment;
  int dx;
  double fx;
  double ex;

  scale->scale = src_size / (double) dest_size;
  scale->offset = scale->scale / 2 - 0.5;

  if (scale->scale > 1.0) {
    scale->fx = (1.0 / scale->scale) * sharpness;
  } else {
    scale->fx = (1.0) * sharpness;
  }
  scale->ex = scale->fx / a;
  scale->dx = ceil (a / scale->fx);

  g_assert (n_taps >= 2 * scale->dx);
  scale->n_taps = n_taps;

  scale->taps = g_malloc (sizeof (double) * scale->n_taps * dest_size);
  scale->offsets = g_malloc (sizeof (gint32) * dest_size);
  tap_array = scale->taps;
  offsets = scale->offsets;

  scale_offset = scale->offset;
  scale_increment = scale->scale;
  dx = scale->dx;
  fx = scale->fx;
  ex = scale->ex;

  for (j = 0; j < dest_size; j++) {
    double x;
    int xi;
    int l;
    double weight;
    double *taps;

    x = scale_offset + scale_increment * j;
    x = CLAMP (x, 0, src_size);
    xi = ceil (x) - dx;

    offsets[j] = xi;
    weight = 0;
    taps = tap_array + j * n_taps;

    for (l = 0; l < n_taps; l++) {
      int xl = xi + l;
      taps[l] = sinc ((x - xl) * fx) * envelope ((x - xl) * ex);
      taps[l] -= sharpen * envelope ((x - xl) * ex);
      weight += taps[l];
    }
    g_assert (envelope ((x - (xi - 1)) * ex) == 0);
    g_assert (envelope ((x - (xi + n_taps)) * ex) == 0);
    for (l = 0; l < n_taps; l++) {
      taps[l] /= weight;
    }

    if (xi < 0) {
      int shift = -xi;

      for (l = 0; l < shift; l++) {
        taps[shift] += taps[l];
      }
      for (l = 0; l < n_taps - shift; l++) {
        taps[l] = taps[shift + l];
      }
      for (; l < n_taps; l++) {
        taps[l] = 0;
      }
      offsets[j] += shift;
    }

    if (xi > src_size - n_taps) {
      int shift = xi - (src_size - n_taps);

      for (l = 0; l < shift; l++) {
        taps[n_taps - shift - 1] += taps[n_taps - shift + l];
      }
      for (l = 0; l < n_taps - shift; l++) {
        taps[n_taps - 1 - l] = taps[n_taps - 1 - shift - l];
      }
      for (l = 0; l < shift; l++) {
        taps[l] = 0;
      }
      offsets[j] -= shift;
    }
  }
}

/*
 * Calculates a set of taps for each destination element in float
 * format.  Each set of taps sums to 1.0.
 */
static void
scale1d_calculate_taps_float (Scale1D * scale, int src_size, int dest_size,
    int n_taps, double a, double sharpness, double sharpen)
{
  double *taps_d;
  float *taps_f;
  int j;

  scale1d_calculate_taps (scale, src_size, dest_size, n_taps, a, sharpness,
      sharpen);

  taps_d = scale->taps;
  taps_f = g_malloc (sizeof (float) * scale->n_taps * dest_size);

  for (j = 0; j < dest_size * n_taps; j++) {
    taps_f[j] = taps_d[j];
  }

  g_free (taps_d);
  scale->taps = taps_f;
}

/*
 * Calculates a set of taps for each destination element in gint32
 * format.  Each set of taps sums to (very nearly) (1<<shift).  A
 * typical value for shift is 10 to 15, so that applying the taps to
 * uint8 values and summing will fit in a (signed) int32.
 */
static void
scale1d_calculate_taps_int32 (Scale1D * scale, int src_size, int dest_size,
    int n_taps, double a, double sharpness, double sharpen, int shift)
{
  double *taps_d;
  gint32 *taps_i;
  int i;
  int j;
  double multiplier;

  scale1d_calculate_taps (scale, src_size, dest_size, n_taps, a, sharpness,
      sharpen);

  taps_d = scale->taps;
  taps_i = g_malloc (sizeof (gint32) * scale->n_taps * dest_size);

  multiplier = (1 << shift);

  for (j = 0; j < dest_size; j++) {
    for (i = 0; i < n_taps; i++) {
      taps_i[j * n_taps + i] =
          floor (0.5 + taps_d[j * n_taps + i] * multiplier);
    }
  }

  g_free (taps_d);
  scale->taps = taps_i;
}

/*
 * Calculates a set of taps for each destination element in gint16
 * format.  Each set of taps sums to (1<<shift).  A typical value
 * for shift is 7, so that applying the taps to uint8 values and
 * summing will fit in a (signed) int16.
 */
static void
scale1d_calculate_taps_int16 (Scale1D * scale, int src_size, int dest_size,
    int n_taps, double a, double sharpness, double sharpen, int shift)
{
  double *taps_d;
  gint16 *taps_i;
  int i;
  int j;
  double multiplier;

  scale1d_calculate_taps (scale, src_size, dest_size, n_taps, a, sharpness,
      sharpen);

  taps_d = scale->taps;
  taps_i = g_malloc (sizeof (gint16) * scale->n_taps * dest_size);

  multiplier = (1 << shift);

  /* Various methods for converting floating point taps to integer.
   * The dB values are the SSIM value between scaling an image via
   * the floating point pathway vs. the integer pathway using the
   * given code to generate the taps.  Only one image was tested,
   * scaling from 1920x1080 to 640x360.  Several variations of the
   * methods were also tested, with nothing appearing useful.  */
#if 0
  /* Standard round to integer.  This causes bad DC errors. */
  /* 44.588 dB */
  for (j = 0; j < dest_size; j++) {
    for (i = 0; i < n_taps; i++) {
      taps_i[j * n_taps + i] =
          floor (0.5 + taps_d[j * n_taps + i] * multiplier);
    }
  }
#endif
#if 0
  /* Dithering via error propogation.  Works pretty well, but
   * really we want to propogate errors across rows, which would
   * mean having several sets of tap arrays.  Possible, but more work,
   * and it may not even be better. */
  /* 57.0961 dB */
  {
    double err = 0;
    for (j = 0; j < dest_size; j++) {
      for (i = 0; i < n_taps; i++) {
        err += taps_d[j * n_taps + i] * multiplier;
        taps_i[j * n_taps + i] = floor (err);
        err -= floor (err);
      }
    }
  }
#endif
#if 1
  /* Round to integer, but with an adjustable bias that we use to
   * eliminate the DC error.  This search method is a bit crude, and
   * could perhaps be improved somewhat. */
  /* 60.4851 dB */
  for (j = 0; j < dest_size; j++) {
    int k;
    for (k = 0; k < 100; k++) {
      int sum = 0;
      double offset;

      offset = k * 0.01;
      for (i = 0; i < n_taps; i++) {
        taps_i[j * n_taps + i] =
            floor (offset + taps_d[j * n_taps + i] * multiplier);
        sum += taps_i[j * n_taps + i];
      }

      if (sum >= (1 << shift))
        break;
    }
  }
#endif
#if 0
  /* Round to integer, but adjust the multiplier.  The search method is
   * wrong a lot, but was sufficient enough to calculate dB error. */
  /* 58.6517 dB */
  for (j = 0; j < dest_size; j++) {
    int k;
    int sum = 0;
    for (k = 0; k < 200; k++) {
      sum = 0;

      multiplier = (1 << shift) - 1.0 + k * 0.01;
      for (i = 0; i < n_taps; i++) {
        taps_i[j * n_taps + i] =
            floor (0.5 + taps_d[j * n_taps + i] * multiplier);
        sum += taps_i[j * n_taps + i];
      }

      if (sum >= (1 << shift))
        break;
    }
    if (sum != (1 << shift)) {
      GST_ERROR ("%g %d", multiplier, sum);
    }
  }
#endif
#if 0
  /* Round to integer, but subtract the error from the largest tap */
  /* 58.3677 dB */
  for (j = 0; j < dest_size; j++) {
    int err = -multiplier;
    for (i = 0; i < n_taps; i++) {
      taps_i[j * n_taps + i] =
          floor (0.5 + taps_d[j * n_taps + i] * multiplier);
      err += taps_i[j * n_taps + i];
    }
    if (taps_i[j * n_taps + (n_taps / 2 - 1)] >
        taps_i[j * n_taps + (n_taps / 2)]) {
      taps_i[j * n_taps + (n_taps / 2 - 1)] -= err;
    } else {
      taps_i[j * n_taps + (n_taps / 2)] -= err;
    }
  }
#endif

  g_free (taps_d);
  scale->taps = taps_i;
}


void
vs_image_scale_lanczos_Y (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, int submethod,
    double a, double sharpen)
{
  switch (submethod) {
    case 0:
    default:
      vs_image_scale_lanczos_Y_int16 (dest, src, tmpbuf, sharpness, dither, a,
          sharpen);
      break;
    case 1:
      vs_image_scale_lanczos_Y_int32 (dest, src, tmpbuf, sharpness, dither, a,
          sharpen);
      break;
    case 2:
      vs_image_scale_lanczos_Y_float (dest, src, tmpbuf, sharpness, dither, a,
          sharpen);
      break;
    case 3:
      vs_image_scale_lanczos_Y_double (dest, src, tmpbuf, sharpness, dither, a,
          sharpen);
      break;
  }
}

void
vs_image_scale_lanczos_AYUV (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, int submethod,
    double a, double sharpen)
{
  switch (submethod) {
    case 0:
    default:
      vs_image_scale_lanczos_AYUV_int16 (dest, src, tmpbuf, sharpness, dither,
          a, sharpen);
      break;
    case 1:
      vs_image_scale_lanczos_AYUV_int32 (dest, src, tmpbuf, sharpness, dither,
          a, sharpen);
      break;
    case 2:
      vs_image_scale_lanczos_AYUV_float (dest, src, tmpbuf, sharpness, dither,
          a, sharpen);
      break;
    case 3:
      vs_image_scale_lanczos_AYUV_double (dest, src, tmpbuf, sharpness, dither,
          a, sharpen);
      break;
  }
}

void
vs_image_scale_lanczos_AYUV64 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, int submethod,
    double a, double sharpen)
{
  vs_image_scale_lanczos_AYUV64_double (dest, src, tmpbuf, sharpness, dither,
      a, sharpen);
}



#define RESAMPLE_HORIZ_FLOAT(function, dest_type, tap_type, src_type, _n_taps) \
static void \
function (dest_type *dest, const gint32 *offsets, \
    const tap_type *taps, const src_type *src, int n_taps, int shift, int n) \
{ \
  int i; \
  int k; \
  dest_type sum; \
  const src_type *srcline; \
  const tap_type *tapsline; \
  for (i = 0; i < n; i++) { \
    srcline = src + offsets[i]; \
    tapsline = taps + i * _n_taps; \
    sum = 0; \
    for (k = 0; k < _n_taps; k++) { \
      sum += srcline[k] * tapsline[k]; \
    } \
    dest[i] = sum; \
  } \
}

#define RESAMPLE_HORIZ(function, dest_type, tap_type, src_type, _n_taps, _shift) \
static void \
function (dest_type *dest, const gint32 *offsets, \
    const tap_type *taps, const src_type *src, int n_taps, int shift, int n) \
{ \
  int i; \
  int k; \
  dest_type sum; \
  const src_type *srcline; \
  const tap_type *tapsline; \
  int offset; \
  if (_shift > 0) offset = (1<<_shift)>>1; \
  else offset = 0; \
  for (i = 0; i < n; i++) { \
    srcline = src + offsets[i]; \
    tapsline = taps + i * _n_taps; \
    sum = 0; \
    for (k = 0; k < _n_taps; k++) { \
      sum += srcline[k] * tapsline[k]; \
    } \
    dest[i] = (sum + offset) >> _shift; \
  } \
}

#define RESAMPLE_HORIZ_AYUV_FLOAT(function, dest_type, tap_type, src_type, _n_taps) \
static void \
function (dest_type *dest, const gint32 *offsets, \
    const tap_type *taps, const src_type *src, int n_taps, int shift, int n) \
{ \
  int i; \
  int k; \
  dest_type sum1; \
  dest_type sum2; \
  dest_type sum3; \
  dest_type sum4; \
  const src_type *srcline; \
  const tap_type *tapsline; \
  for (i = 0; i < n; i++) { \
    srcline = src + 4*offsets[i]; \
    tapsline = taps + i * _n_taps; \
    sum1 = 0; \
    sum2 = 0; \
    sum3 = 0; \
    sum4 = 0; \
    for (k = 0; k < _n_taps; k++) { \
      sum1 += srcline[k*4+0] * tapsline[k]; \
      sum2 += srcline[k*4+1] * tapsline[k]; \
      sum3 += srcline[k*4+2] * tapsline[k]; \
      sum4 += srcline[k*4+3] * tapsline[k]; \
    } \
    dest[i*4+0] = sum1; \
    dest[i*4+1] = sum2; \
    dest[i*4+2] = sum3; \
    dest[i*4+3] = sum4; \
  } \
}

#define RESAMPLE_HORIZ_AYUV(function, dest_type, tap_type, src_type, _n_taps, _shift) \
static void \
function (dest_type *dest, const gint32 *offsets, \
    const tap_type *taps, const src_type *src, int n_taps, int shift, int n) \
{ \
  int i; \
  int k; \
  dest_type sum1; \
  dest_type sum2; \
  dest_type sum3; \
  dest_type sum4; \
  const src_type *srcline; \
  const tap_type *tapsline; \
  int offset; \
  if (_shift > 0) offset = (1<<_shift)>>1; \
  else offset = 0; \
  for (i = 0; i < n; i++) { \
    srcline = src + 4*offsets[i]; \
    tapsline = taps + i * _n_taps; \
    sum1 = 0; \
    sum2 = 0; \
    sum3 = 0; \
    sum4 = 0; \
    for (k = 0; k < _n_taps; k++) { \
      sum1 += srcline[k*4+0] * tapsline[k]; \
      sum2 += srcline[k*4+1] * tapsline[k]; \
      sum3 += srcline[k*4+2] * tapsline[k]; \
      sum4 += srcline[k*4+3] * tapsline[k]; \
    } \
    dest[i*4+0] = (sum1 + offset) >> _shift; \
    dest[i*4+1] = (sum2 + offset) >> _shift; \
    dest[i*4+2] = (sum3 + offset) >> _shift; \
    dest[i*4+3] = (sum4 + offset) >> _shift; \
  } \
}

/* *INDENT-OFF* */
RESAMPLE_HORIZ_FLOAT (resample_horiz_double_u8_generic, double, double,
    guint8, n_taps)
RESAMPLE_HORIZ_FLOAT (resample_horiz_float_u8_generic, float, float,
    guint8, n_taps)
RESAMPLE_HORIZ_AYUV_FLOAT (resample_horiz_double_ayuv_generic, double, double,
    guint8, n_taps)
RESAMPLE_HORIZ_AYUV_FLOAT (resample_horiz_float_ayuv_generic, float, float,
    guint8, n_taps)

RESAMPLE_HORIZ_AYUV_FLOAT (resample_horiz_double_ayuv_generic_s16, double, double,
    guint16, n_taps)

RESAMPLE_HORIZ (resample_horiz_int32_int32_u8_generic, gint32, gint32,
    guint8, n_taps, shift)
RESAMPLE_HORIZ (resample_horiz_int16_int16_u8_generic, gint16, gint16,
    guint8, n_taps, shift)
RESAMPLE_HORIZ_AYUV (resample_horiz_int32_int32_ayuv_generic, gint32, gint32,
    guint8, n_taps, shift)
RESAMPLE_HORIZ_AYUV (resample_horiz_int16_int16_ayuv_generic, gint16, gint16,
    guint8, n_taps, shift)

/* Candidates for orcification */
RESAMPLE_HORIZ (resample_horiz_int32_int32_u8_taps16_shift0, gint32, gint32,
    guint8, 16, 0)
RESAMPLE_HORIZ (resample_horiz_int32_int32_u8_taps12_shift0, gint32, gint32,
    guint8, 12, 0)
RESAMPLE_HORIZ (resample_horiz_int32_int32_u8_taps8_shift0, gint32, gint32,
    guint8, 8, 0)
RESAMPLE_HORIZ (resample_horiz_int32_int32_u8_taps4_shift0, gint32, gint32,
    guint8, 4, 0)
RESAMPLE_HORIZ (resample_horiz_int16_int16_u8_taps16_shift0, gint16, gint16,
    guint8, 16, 0)
RESAMPLE_HORIZ (resample_horiz_int16_int16_u8_taps12_shift0, gint16, gint16,
    guint8, 12, 0)
RESAMPLE_HORIZ (resample_horiz_int16_int16_u8_taps8_shift0, gint16, gint16,
    guint8, 8, 0)
RESAMPLE_HORIZ (resample_horiz_int16_int16_u8_taps4_shift0, gint16, gint16,
    guint8, 4, 0)

RESAMPLE_HORIZ_AYUV (resample_horiz_int32_int32_ayuv_taps16_shift0, gint32, gint32,
    guint8, 16, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int32_int32_ayuv_taps12_shift0, gint32, gint32,
    guint8, 12, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int32_int32_ayuv_taps8_shift0, gint32, gint32,
    guint8, 8, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int32_int32_ayuv_taps4_shift0, gint32, gint32,
    guint8, 4, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int16_int16_ayuv_taps16_shift0, gint16, gint16,
    guint8, 16, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int16_int16_ayuv_taps12_shift0, gint16, gint16,
    guint8, 12, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int16_int16_ayuv_taps8_shift0, gint16, gint16,
    guint8, 8, 0)
RESAMPLE_HORIZ_AYUV (resample_horiz_int16_int16_ayuv_taps4_shift0, gint16, gint16,
    guint8, 4, 0)
/* *INDENT-ON* */

#define RESAMPLE_VERT(function, tap_type, src_type, _n_taps, _shift) \
static void \
function (guint8 *dest, \
    const tap_type *taps, const src_type *src, int stride, int n_taps, \
    int shift, int n) \
{ \
  int i; \
  int l; \
  gint32 sum_y; \
  gint32 offset = (1<<_shift) >> 1; \
  for (i = 0; i < n; i++) { \
    sum_y = 0; \
    for (l = 0; l < n_taps; l++) { \
      const src_type *line = PTR_OFFSET(src, stride * l); \
      sum_y += line[i] * taps[l]; \
    } \
    dest[i] = CLAMP ((sum_y + offset) >> _shift, 0, 255); \
  } \
}

#define RESAMPLE_VERT_DITHER(function, tap_type, src_type, _n_taps, _shift) \
static void \
function (guint8 *dest, \
    const tap_type *taps, const src_type *src, int stride, int n_taps, \
    int shift, int n) \
{ \
  int i; \
  int l; \
  gint32 sum_y; \
  gint32 err_y = 0; \
  gint32 mask = (1<<_shift) - 1; \
  for (i = 0; i < n; i++) { \
    sum_y = 0; \
    for (l = 0; l < n_taps; l++) { \
      const src_type *line = PTR_OFFSET(src, stride * l); \
      sum_y += line[i] * taps[l]; \
    } \
    err_y += sum_y; \
    dest[i] = CLAMP (err_y >> _shift, 0, 255); \
    err_y &= mask; \
  } \
}

/* *INDENT-OFF* */
RESAMPLE_VERT (resample_vert_int32_generic, gint32, gint32, n_taps, shift)
RESAMPLE_VERT_DITHER (resample_vert_dither_int32_generic, gint32, gint32,
    n_taps, shift)
RESAMPLE_VERT (resample_vert_int16_generic, gint16, gint16, n_taps, shift);
RESAMPLE_VERT_DITHER (resample_vert_dither_int16_generic, gint16, gint16,
    n_taps, shift)
/* *INDENT-ON* */

#define RESAMPLE_VERT_FLOAT(function, dest_type, clamp, tap_type, src_type, _n_taps, _shift) \
static void \
function (dest_type *dest, \
    const tap_type *taps, const src_type *src, int stride, int n_taps, \
    int shift, int n) \
{ \
  int i; \
  int l; \
  src_type sum_y; \
  for (i = 0; i < n; i++) { \
    sum_y = 0; \
    for (l = 0; l < n_taps; l++) { \
      const src_type *line = PTR_OFFSET(src, stride * l); \
      sum_y += line[i] * taps[l]; \
    } \
    dest[i] = CLAMP (floor(0.5 + sum_y), 0, clamp); \
  } \
}

#define RESAMPLE_VERT_FLOAT_DITHER(function, dest_type, clamp, tap_type, src_type, _n_taps, _shift) \
static void \
function (dest_type *dest, \
    const tap_type *taps, const src_type *src, int stride, int n_taps, \
    int shift, int n) \
{ \
  int i; \
  int l; \
  src_type sum_y; \
  src_type err_y = 0; \
  for (i = 0; i < n; i++) { \
    sum_y = 0; \
    for (l = 0; l < n_taps; l++) { \
      const src_type *line = PTR_OFFSET(src, stride * l); \
      sum_y += line[i] * taps[l]; \
    } \
    err_y += sum_y; \
    dest[i] = CLAMP (floor (err_y), 0, clamp); \
    err_y -= floor (err_y); \
  } \
}

/* *INDENT-OFF* */
RESAMPLE_VERT_FLOAT (resample_vert_double_generic, guint8, 255, double, double, n_taps,
    shift)
RESAMPLE_VERT_FLOAT_DITHER (resample_vert_dither_double_generic, guint8, 255, double, double,
    n_taps, shift)

RESAMPLE_VERT_FLOAT (resample_vert_double_generic_u16, guint16, 65535, double, double, n_taps,
    shift)
RESAMPLE_VERT_FLOAT_DITHER (resample_vert_dither_double_generic_u16, guint16, 65535, double, double,
    n_taps, shift)

RESAMPLE_VERT_FLOAT (resample_vert_float_generic, guint8, 255, float, float, n_taps, shift)
RESAMPLE_VERT_FLOAT_DITHER (resample_vert_dither_float_generic, guint8, 255, float, float,
    n_taps, shift)
/* *INDENT-ON* */

#define S16_SHIFT1 7
#define S16_SHIFT2 7
#define S16_MIDSHIFT 0
#define S16_POSTSHIFT (S16_SHIFT1+S16_SHIFT2-S16_MIDSHIFT)

static void
vs_scale_lanczos_Y_int16 (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    gint16 *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_S16 (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, S16_MIDSHIFT, scale->dest->width);
      tmp_yi++;
    }

    taps = (gint16 *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_int16_generic (destline,
          taps, TMP_LINE_S16 (scale->y_scale1d.offsets[j]),
          sizeof (gint16) * scale->dest->width, scale->y_scale1d.n_taps,
          S16_POSTSHIFT, scale->dest->width);
    } else {
      resample_vert_int16_generic (destline,
          taps, TMP_LINE_S16 (scale->y_scale1d.offsets[j]),
          sizeof (gint16) * scale->dest->width, scale->y_scale1d.n_taps,
          S16_POSTSHIFT, scale->dest->width);
    }
  }
}

void
vs_image_scale_lanczos_Y_int16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  n_taps = ROUND_UP_4 (n_taps);
  scale1d_calculate_taps_int16 (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen, S16_SHIFT1);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps_int16 (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen, S16_SHIFT2);

  scale->dither = dither;

  switch (scale->x_scale1d.n_taps) {
    case 4:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_u8_taps4_shift0;
      break;
    case 8:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_u8_taps8_shift0;
      break;
    case 12:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_u8_taps12_shift0;
      break;
    case 16:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_u8_taps16_shift0;
      break;
    default:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_u8_generic;
      break;
  }

  scale->tmpdata =
      g_malloc (sizeof (gint16) * scale->dest->width * scale->src->height);

  vs_scale_lanczos_Y_int16 (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}


#define S32_SHIFT1 11
#define S32_SHIFT2 11
#define S32_MIDSHIFT 0
#define S32_POSTSHIFT (S32_SHIFT1+S32_SHIFT2-S32_MIDSHIFT)

static void
vs_scale_lanczos_Y_int32 (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    gint32 *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_S32 (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, S32_MIDSHIFT, scale->dest->width);
      tmp_yi++;
    }

    taps = (gint32 *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_int32_generic (destline,
          taps, TMP_LINE_S32 (scale->y_scale1d.offsets[j]),
          sizeof (gint32) * scale->dest->width,
          scale->y_scale1d.n_taps, S32_POSTSHIFT, scale->dest->width);
    } else {
      resample_vert_int32_generic (destline,
          taps, TMP_LINE_S32 (scale->y_scale1d.offsets[j]),
          sizeof (gint32) * scale->dest->width,
          scale->y_scale1d.n_taps, S32_POSTSHIFT, scale->dest->width);
    }
  }
}

void
vs_image_scale_lanczos_Y_int32 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  n_taps = ROUND_UP_4 (n_taps);
  scale1d_calculate_taps_int32 (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen, S32_SHIFT1);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps_int32 (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen, S32_SHIFT2);

  scale->dither = dither;

  switch (scale->x_scale1d.n_taps) {
    case 4:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_u8_taps4_shift0;
      break;
    case 8:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_u8_taps8_shift0;
      break;
    case 12:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_u8_taps12_shift0;
      break;
    case 16:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_u8_taps16_shift0;
      break;
    default:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_u8_generic;
      break;
  }

  scale->tmpdata =
      g_malloc (sizeof (int32_t) * scale->dest->width * scale->src->height);

  vs_scale_lanczos_Y_int32 (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}

static void
vs_scale_lanczos_Y_double (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    double *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_DOUBLE (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, 0, scale->dest->width);
      tmp_yi++;
    }

    taps = (double *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_double_generic (destline,
          taps, TMP_LINE_DOUBLE (scale->y_scale1d.offsets[j]),
          sizeof (double) * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width);
    } else {
      resample_vert_double_generic (destline,
          taps, TMP_LINE_DOUBLE (scale->y_scale1d.offsets[j]),
          sizeof (double) * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width);
    }
  }
}

void
vs_image_scale_lanczos_Y_double (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  scale1d_calculate_taps (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen);

  scale->dither = dither;

  scale->horiz_resample_func =
      (HorizResampleFunc) resample_horiz_double_u8_generic;

  scale->tmpdata =
      g_malloc (sizeof (double) * scale->dest->width * scale->src->height);

  vs_scale_lanczos_Y_double (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}

static void
vs_scale_lanczos_Y_float (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    float *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_FLOAT (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, 0, scale->dest->width);
      tmp_yi++;
    }

    taps = (float *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_float_generic (destline,
          taps, TMP_LINE_FLOAT (scale->y_scale1d.offsets[j]),
          sizeof (float) * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width);
    } else {
      resample_vert_float_generic (destline,
          taps, TMP_LINE_FLOAT (scale->y_scale1d.offsets[j]),
          sizeof (float) * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width);
    }
  }
}

void
vs_image_scale_lanczos_Y_float (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  scale1d_calculate_taps_float (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps_float (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen);

  scale->dither = dither;

  scale->horiz_resample_func =
      (HorizResampleFunc) resample_horiz_float_u8_generic;

  scale->tmpdata =
      g_malloc (sizeof (float) * scale->dest->width * scale->src->height);

  vs_scale_lanczos_Y_float (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}





static void
vs_scale_lanczos_AYUV_int16 (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    gint16 *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_S16_AYUV (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, S16_MIDSHIFT, scale->dest->width);
      tmp_yi++;
    }

    taps = (gint16 *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_int16_generic (destline,
          taps, TMP_LINE_S16_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (gint16) * 4 * scale->dest->width,
          scale->y_scale1d.n_taps, S16_POSTSHIFT, scale->dest->width * 4);
    } else {
      resample_vert_int16_generic (destline,
          taps, TMP_LINE_S16_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (gint16) * 4 * scale->dest->width,
          scale->y_scale1d.n_taps, S16_POSTSHIFT, scale->dest->width * 4);
    }
  }
}

void
vs_image_scale_lanczos_AYUV_int16 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  n_taps = ROUND_UP_4 (n_taps);
  scale1d_calculate_taps_int16 (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen, S16_SHIFT1);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps_int16 (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen, S16_SHIFT2);

  scale->dither = dither;

  switch (scale->x_scale1d.n_taps) {
    case 4:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_ayuv_taps4_shift0;
      break;
    case 8:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_ayuv_taps8_shift0;
      break;
    case 12:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_ayuv_taps12_shift0;
      break;
    case 16:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_ayuv_taps16_shift0;
      break;
    default:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int16_int16_ayuv_generic;
      break;
  }

  scale->tmpdata =
      g_malloc (sizeof (gint16) * scale->dest->width * scale->src->height * 4);

  vs_scale_lanczos_AYUV_int16 (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}


static void
vs_scale_lanczos_AYUV_int32 (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    gint32 *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_S32_AYUV (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, S32_MIDSHIFT, scale->dest->width);
      tmp_yi++;
    }

    taps = (gint32 *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_int32_generic (destline,
          taps, TMP_LINE_S32_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (gint32) * 4 * scale->dest->width, scale->y_scale1d.n_taps,
          S32_POSTSHIFT, scale->dest->width * 4);
    } else {
      resample_vert_int32_generic (destline,
          taps, TMP_LINE_S32_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (gint32) * 4 * scale->dest->width, scale->y_scale1d.n_taps,
          S32_POSTSHIFT, scale->dest->width * 4);
    }
  }
}

void
vs_image_scale_lanczos_AYUV_int32 (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  n_taps = ROUND_UP_4 (n_taps);
  scale1d_calculate_taps_int32 (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen, S32_SHIFT1);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps_int32 (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen, S32_SHIFT2);

  scale->dither = dither;

  switch (scale->x_scale1d.n_taps) {
    case 4:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_ayuv_taps4_shift0;
      break;
    case 8:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_ayuv_taps8_shift0;
      break;
    case 12:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_ayuv_taps12_shift0;
      break;
    case 16:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_ayuv_taps16_shift0;
      break;
    default:
      scale->horiz_resample_func =
          (HorizResampleFunc) resample_horiz_int32_int32_ayuv_generic;
      break;
  }

  scale->tmpdata =
      g_malloc (sizeof (int32_t) * scale->dest->width * scale->src->height * 4);

  vs_scale_lanczos_AYUV_int32 (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}

static void
vs_scale_lanczos_AYUV_double (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    double *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_DOUBLE_AYUV (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, 0, scale->dest->width);
      tmp_yi++;
    }

    taps = (double *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_double_generic (destline,
          taps, TMP_LINE_DOUBLE_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (double) * 4 * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width * 4);
    } else {
      resample_vert_double_generic (destline,
          taps, TMP_LINE_DOUBLE_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (double) * 4 * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width * 4);
    }
  }
}

void
vs_image_scale_lanczos_AYUV_double (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  scale1d_calculate_taps (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen);

  scale->dither = dither;

  scale->horiz_resample_func =
      (HorizResampleFunc) resample_horiz_double_ayuv_generic;

  scale->tmpdata =
      g_malloc (sizeof (double) * scale->dest->width * scale->src->height * 4);

  vs_scale_lanczos_AYUV_double (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}

static void
vs_scale_lanczos_AYUV_float (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint8 *destline;
    float *taps;

    destline = scale->dest->pixels + scale->dest->stride * j;

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_FLOAT_AYUV (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, 0, scale->dest->width);
      tmp_yi++;
    }

    taps = (float *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_float_generic (destline,
          taps, TMP_LINE_FLOAT_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (float) * 4 * scale->dest->width, scale->y_scale1d.n_taps, 0,
          scale->dest->width * 4);
    } else {
      resample_vert_float_generic (destline,
          taps, TMP_LINE_FLOAT_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (float) * 4 * scale->dest->width, scale->y_scale1d.n_taps, 0,
          scale->dest->width * 4);
    }
  }
}

void
vs_image_scale_lanczos_AYUV_float (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  scale1d_calculate_taps_float (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps_float (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen);

  scale->dither = dither;

  scale->horiz_resample_func =
      (HorizResampleFunc) resample_horiz_float_ayuv_generic;

  scale->tmpdata =
      g_malloc (sizeof (float) * scale->dest->width * scale->src->height * 4);

  vs_scale_lanczos_AYUV_float (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}

static void
vs_scale_lanczos_AYUV64_double (Scale * scale)
{
  int j;
  int yi;
  int tmp_yi;

  tmp_yi = 0;

  for (j = 0; j < scale->dest->height; j++) {
    guint16 *destline;
    double *taps;

    destline = (guint16 *) (scale->dest->pixels + scale->dest->stride * j);

    yi = scale->y_scale1d.offsets[j];

    while (tmp_yi < yi + scale->y_scale1d.n_taps) {
      scale->horiz_resample_func (TMP_LINE_DOUBLE_AYUV (tmp_yi),
          scale->x_scale1d.offsets, scale->x_scale1d.taps, SRC_LINE (tmp_yi),
          scale->x_scale1d.n_taps, 0, scale->dest->width);
      tmp_yi++;
    }

    taps = (double *) scale->y_scale1d.taps + j * scale->y_scale1d.n_taps;
    if (scale->dither) {
      resample_vert_dither_double_generic_u16 (destline,
          taps, TMP_LINE_DOUBLE_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (double) * 4 * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width * 4);
    } else {
      resample_vert_double_generic_u16 (destline,
          taps, TMP_LINE_DOUBLE_AYUV (scale->y_scale1d.offsets[j]),
          sizeof (double) * 4 * scale->dest->width,
          scale->y_scale1d.n_taps, 0, scale->dest->width * 4);
    }
  }
}

void
vs_image_scale_lanczos_AYUV64_double (const VSImage * dest, const VSImage * src,
    uint8_t * tmpbuf, double sharpness, gboolean dither, double a,
    double sharpen)
{
  Scale s = { 0 };
  Scale *scale = &s;
  int n_taps;

  scale->dest = dest;
  scale->src = src;

  n_taps = scale1d_get_n_taps (src->width, dest->width, a, sharpness);
  scale1d_calculate_taps (&scale->x_scale1d,
      src->width, dest->width, n_taps, a, sharpness, sharpen);

  n_taps = scale1d_get_n_taps (src->height, dest->height, a, sharpness);
  scale1d_calculate_taps (&scale->y_scale1d,
      src->height, dest->height, n_taps, a, sharpness, sharpen);

  scale->dither = dither;

  scale->horiz_resample_func =
      (HorizResampleFunc) resample_horiz_double_ayuv_generic_s16;

  scale->tmpdata =
      g_malloc (sizeof (double) * scale->dest->width * scale->src->height * 4);

  vs_scale_lanczos_AYUV64_double (scale);

  scale1d_cleanup (&scale->x_scale1d);
  scale1d_cleanup (&scale->y_scale1d);
  g_free (scale->tmpdata);
}
