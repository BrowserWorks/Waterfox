/* Copyright (C) 2007-2008 Jean-Marc Valin
 * Copyright (C) 2008 Thorvald Natvig
 */
/**
   @file resample_sse.h
   @brief Resampler functions (SSE version)
*/
/*
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:
   
   - Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
   
   - Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
   
   - Neither the name of the Xiph.org Foundation nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.
   
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef HAVE_XMMINTRIN_H
#include <xmmintrin.h>
#endif

#define OVERRIDE_INNER_PRODUCT_SINGLE
static inline float inner_product_single(const float *a, const float *b, unsigned int len)
{
   int i = 0;
   float ret = 0;
   __m128 sum = _mm_setzero_ps();

   if (len > 7)
   {
      for (;i<len-7;i+=8)
      {
         sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(a+i), _mm_loadu_ps(b+i)));
         sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(a+i+4), _mm_loadu_ps(b+i+4)));
      }
      sum = _mm_add_ps(sum, _mm_movehl_ps(sum, sum));
      sum = _mm_add_ss(sum, _mm_shuffle_ps(sum, sum, 0x55));
      _mm_store_ss(&ret, sum);
   }

   for (; i < len; i++)
     ret += a[i] * b[i];

   return ret;
}

#define OVERRIDE_INTERPOLATE_PRODUCT_SINGLE
static inline float interpolate_product_single(const float *a, const float *b, unsigned int len, const spx_uint32_t oversample, float *frac) {
  int i = 0;
  float ret = 0;
  __m128 sum = _mm_setzero_ps();
  __m128 f = _mm_loadu_ps(frac);

  if (len > 1)
  {
     for(;i<len-1;i+=2)
     {
        sum = _mm_add_ps(sum, _mm_mul_ps(_mm_load1_ps(a+i), _mm_loadu_ps(b+i*oversample)));
        sum = _mm_add_ps(sum, _mm_mul_ps(_mm_load1_ps(a+i+1), _mm_loadu_ps(b+(i+1)*oversample)));
     }

     sum = _mm_mul_ps(f, sum);
     sum = _mm_add_ps(sum, _mm_movehl_ps(sum, sum));
     sum = _mm_add_ss(sum, _mm_shuffle_ps(sum, sum, 0x55));
     _mm_store_ss(&ret, sum);
  }

  if (i == len-1)
    ret += a[i] * (frac[0]*b[i*oversample] + frac[1]*b[i*oversample + 1] + frac[2]*b[i*oversample + 2] + frac[3]*b[i*oversample + 3]);

  return ret;
}

#ifdef _USE_SSE2
#ifdef HAVE_EMMINTRIN_H
#include <emmintrin.h>
#endif
#define OVERRIDE_INNER_PRODUCT_DOUBLE

#ifdef DOUBLE_PRECISION
static inline double inner_product_double(const double *a, const double *b, unsigned int len)
{
   int i = 0;
   double ret = 0;
   __m128d sum = _mm_setzero_pd();

   if (len > 3)
   {
      for (;i<len-3;i+=4)
      {
         sum = _mm_add_pd(sum, _mm_mul_pd(_mm_loadu_pd(a+i), _mm_loadu_pd(b+i)));
         sum = _mm_add_pd(sum, _mm_mul_pd(_mm_loadu_pd(a+i+2), _mm_loadu_pd(b+i+2)));
      }
      sum = _mm_add_sd(sum, _mm_unpackhi_pd(sum, sum));
      _mm_store_sd(&ret, sum);
   }

   for (; i < len; i++)
     ret += a[i] * b[i];

   return ret;
}
#else
static inline double inner_product_double(const float *a, const float *b, unsigned int len)
{
   int i = 0;
   double ret = 0;
   __m128d sum = _mm_setzero_pd();
   __m128 t;

   if (len > 7)
   {
      for (;i<len-7;i+=8)
      {
         t = _mm_mul_ps(_mm_loadu_ps(a+i), _mm_loadu_ps(b+i));
         sum = _mm_add_pd(sum, _mm_cvtps_pd(t));
         sum = _mm_add_pd(sum, _mm_cvtps_pd(_mm_movehl_ps(t, t)));

         t = _mm_mul_ps(_mm_loadu_ps(a+i+4), _mm_loadu_ps(b+i+4));
         sum = _mm_add_pd(sum, _mm_cvtps_pd(t));
         sum = _mm_add_pd(sum, _mm_cvtps_pd(_mm_movehl_ps(t, t)));
      }
      sum = _mm_add_sd(sum, _mm_unpackhi_pd(sum, sum));
      _mm_store_sd(&ret, sum);
   }

   for (; i < len; i++)
     ret += a[i] * b[i];

   return ret;
}
#endif


#define OVERRIDE_INTERPOLATE_PRODUCT_DOUBLE

#ifdef DOUBLE_PRECISION
static inline double interpolate_product_double(const double *a, const double *b, unsigned int len, const spx_uint32_t oversample, double *frac) {
  int i = 0;
  double ret = 0;
  __m128d sum;
  __m128d sum1 = _mm_setzero_pd();
  __m128d sum2 = _mm_setzero_pd();
  __m128d f1 = _mm_loadu_pd(frac);
  __m128d f2 = _mm_loadu_pd(frac+2);
  __m128d t;
  
  if (len > 1)
  {
     for(;i<len-1;i+=2)
     {
       t = _mm_mul_pd(_mm_load1_pd(a+i), _mm_loadu_pd(b+i*oversample));
       sum1 = _mm_add_pd(sum1, t);
       sum2 = _mm_add_pd(sum2, _mm_unpackhi_pd(t, t));

       t = _mm_mul_pd(_mm_load1_pd(a+i+1), _mm_loadu_pd(b+(i+1)*oversample));
       sum1 = _mm_add_pd(sum1, t);
       sum2 = _mm_add_pd(sum2, _mm_unpackhi_pd(t, t));
     }
     sum1 = _mm_mul_pd(f1, sum1);
     sum2 = _mm_mul_pd(f2, sum2);
     sum = _mm_add_pd(sum1, sum2);
     sum = _mm_add_sd(sum, _mm_unpackhi_pd(sum, sum));
     _mm_store_sd(&ret, sum);
  }

  if (i == len-1)
    ret += a[i] * (frac[0]*b[i*oversample] + frac[1]*b[i*oversample + 1] + frac[2]*b[i*oversample + 2] + frac[3]*b[i*oversample + 3]);

  return ret;
}
#else
static inline double interpolate_product_double(const float *a, const float *b, unsigned int len, const spx_uint32_t oversample, float *frac) {
  int i = 0;
  double ret = 0;
  __m128d sum;
  __m128d sum1 = _mm_setzero_pd();
  __m128d sum2 = _mm_setzero_pd();
  __m128 f = _mm_loadu_ps(frac);
  __m128d f1 = _mm_cvtps_pd(f);
  __m128d f2 = _mm_cvtps_pd(_mm_movehl_ps(f,f));
  __m128 t;

  if (len > 1)
  {
     for(;i<len-1;i+=2)
     {
        t = _mm_mul_ps(_mm_load1_ps(a+i), _mm_loadu_ps(b+i*oversample));
        sum1 = _mm_add_pd(sum1, _mm_cvtps_pd(t));
        sum2 = _mm_add_pd(sum2, _mm_cvtps_pd(_mm_movehl_ps(t, t)));

        t = _mm_mul_ps(_mm_load1_ps(a+i+1), _mm_loadu_ps(b+(i+1)*oversample));
        sum1 = _mm_add_pd(sum1, _mm_cvtps_pd(t));
        sum2 = _mm_add_pd(sum2, _mm_cvtps_pd(_mm_movehl_ps(t, t)));
     }
     sum1 = _mm_mul_pd(f1, sum1);
     sum2 = _mm_mul_pd(f2, sum2);
     sum = _mm_add_pd(sum1, sum2);
     sum = _mm_add_sd(sum, _mm_unpackhi_pd(sum, sum));
     _mm_store_sd(&ret, sum);
  }

  if (i == len-1)
    ret += a[i] * (frac[0]*b[i*oversample] + frac[1]*b[i*oversample + 1] + frac[2]*b[i*oversample + 2] + frac[3]*b[i*oversample + 3]);

  return ret;
}
#endif

#endif
