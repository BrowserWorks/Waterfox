/*
 * Orc - Oil Runtime Compiler
 * Copyright (c) 2003,2004 David A. Schleef <ds@schleef.org>
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

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <orc-test/orcprofile.h>
#include <orc/orcdebug.h>

#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif
#include <time.h>
#include <string.h>
#include <math.h>

/* not used because it requires a kernel patch */
/* #undef USE_CORTEX_A8_COUNTER */

/**
 * SECTION:orcprofile
 * @title:OrcProfile
 * @short_description:
 * Measuring the length of time needed to execute Orc functions.
 *
 */

/**
 * orc_profile_init:
 * @prof: the OrcProfile structure
 *
 * Initializes a profiling structure.
 */
void
orc_profile_init (OrcProfile *prof)
{
#if defined(__GNUC__) && defined(HAVE_ARM) && defined(USE_CORTEX_A8_COUNTER)
  unsigned int flags;

  __asm__ volatile ("mrc p15, 0, %0, c9, c12, 0" : "=r" (flags)); 
  flags |= 1;
  __asm__ volatile ("mcr p15, 0, %0, c9, c12, 0" :: "r" (flags)); 

  __asm__ volatile ("mcr p15, 0, %0, c9, c12, 2" :: "r"(1<<31)); 
  __asm__ __volatile__("  mcr p15, 0, %0, c9, c13, 0" :: "r" (0));

  __asm__ volatile ("mcr p15, 0, %0, c9, c12, 1" :: "r"(1<<31)); 
#endif
  memset(prof, 0, sizeof(OrcProfile));

  prof->min = -1;

}

/**
 * orc_profile_stop_handle:
 * @prof: the OrcProfile structure
 *
 * Handles post-processing of a single profiling run.
 *
 * FIXME: need more info
 */
void
orc_profile_stop_handle (OrcProfile *prof)
{
  int i;

  prof->last = prof->stop - prof->start;

  prof->total += prof->last;
  prof->n++;

  if (prof->last < prof->min) prof->min = prof->last;
  
  for(i=0;i<prof->hist_n;i++) {
    if (prof->last == prof->hist_time[i]) {
      prof->hist_count[i]++;
      break;
    }
  }
  if (i == prof->hist_n && prof->hist_n < ORC_PROFILE_HIST_LENGTH) {
    prof->hist_time[prof->hist_n] = prof->last;
    prof->hist_count[prof->hist_n] = 1;
    prof->hist_n++;
  }
}

/**
 * orc_profile_get_ave_std:
 * @prof: the OrcProfile structure
 * @ave_p: pointer to average
 * @std_p: pointer to standard deviation
 *
 * Calculates the average and standard deviation of a number of
 * profiling runs, and places the results in the locations
 * provided by @ave_p and @std_p.  Either @ave_p and @std_p may
 * be NULL, in which case the values will not be written.
 */
void
orc_profile_get_ave_std (OrcProfile *prof, double *ave_p, double *std_p)
{
  double ave;
  double std;
  int max_i;
  double off;
  double s;
  double s2;
  int i;
  int n;
  double x;

  do {
    s = s2 = 0;
    n = 0;
    max_i = -1;
    for(i=0;i<10;i++){
      x = prof->hist_time[i];
      s2 += x * x * prof->hist_count[i];
      s += x * prof->hist_count[i];
      n += prof->hist_count[i];
      if (prof->hist_count[i] > 0) {
        if (max_i == -1 || prof->hist_time[i] > prof->hist_time[max_i]) {
          max_i = i;
        }
      }
    }

    ave = s / n;
    std = sqrt (s2 - s * s / n + n*n) / (n-1);
    off = (prof->hist_time[max_i] - ave)/std;

    if (off > 4.0) {
      prof->hist_count[max_i] = 0;
    }
  } while (off > 4.0);

  if (ave_p) *ave_p = ave;
  if (std_p) *std_p = std;
}


static unsigned long
oil_profile_stamp_default (void)
{
#if defined(__GNUC__) && (defined(HAVE_I386) || defined(HAVE_AMD64))
  unsigned long ts;
  __asm__ __volatile__("rdtsc\n" : "=a" (ts) : : "edx");
  return ts;
#elif defined(__GNUC__) && defined(HAVE_ARM) && defined(USE_CORTEX_A8_COUNTER)
  unsigned int ts;
  /* __asm__ __volatile__("  mrc p14, 0, %0, c1, c0, 0 \n" : "=r" (ts)); */
  __asm__ __volatile__("  mrc p15, 0, %0, c9, c13, 0 \n" : "=r" (ts));
  return ts;
#elif defined(_MSC_VER) && defined(HAVE_I386)
  unsigned long ts;
  __asm push edx
  __asm __emit 0fh __asm __emit 031h
  __asm mov ts, eax
  __asm pop edx
#elif defined(HAVE_CLOCK_GETTIME) && defined(HAVE_MONOTONIC_CLOCK)
  struct timespec ts;
  clock_gettime (CLOCK_MONOTONIC, &ts);
  return 1000000000*ts.tv_sec + ts.tv_nsec;
#elif defined(HAVE_GETTIMEOFDAY)
  struct timeval tv;
  gettimeofday(&tv,NULL);
  return 1000000*(unsigned long)tv.tv_sec + (unsigned long)tv.tv_usec;
#else
  return 0;
#endif
}

static unsigned long (*_orc_profile_stamp)(void) = oil_profile_stamp_default;

/**
 * orc_profile_stamp:
 *
 * Creates a timestamp based on a CPU-specific high-frequency
 * counter, if available.
 *
 * Returns: a timestamp
 */
unsigned long
orc_profile_stamp (void)
{
  return _orc_profile_stamp();
}

void
_orc_profile_init (void)
{

}

