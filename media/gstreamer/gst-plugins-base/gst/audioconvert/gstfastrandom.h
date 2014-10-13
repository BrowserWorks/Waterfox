/* GStreamer
 * Copyright (C) 2008 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 *
 * gstfastrandom.h: Fast, bad PNRG
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

#include <glib.h>

#ifndef __GST_FAST_RANDOM__
#define __GST_FAST_RANDOM__

/* transform [0..2^32] -> [0..1] */
#define GST_RAND_DOUBLE_TRANSFORM 2.3283064365386962890625e-10

/* This is the base function, implementing a linear congruential generator
 * and returning a pseudo random number between 0 and 2^32 - 1.
 */
static inline guint32
gst_fast_random_uint32 (void)
{
  static guint32 state = 0xdeadbeef;

  return (state = state * 1103515245 + 12345);
}

static inline guint32
gst_fast_random_uint32_range (gint32 start, gint32 end)
{
  guint64 tmp = gst_fast_random_uint32 ();

  tmp = (tmp * (end - start)) / G_MAXUINT32 + start;

  return (guint32) tmp;
}

static inline gint32
gst_fast_random_int32 (void)
{
  return (gint32) gst_fast_random_uint32 ();
}

static inline gint32
gst_fast_random_int32_range (gint32 start, gint32 end)
{
  gint64 tmp = gst_fast_random_uint32 ();

  tmp = (tmp * (end - start)) / G_MAXUINT32 + start;

  return (gint32) tmp;
}

static inline gdouble
gst_fast_random_double (void)
{
  gdouble ret;

  ret = gst_fast_random_uint32 () * GST_RAND_DOUBLE_TRANSFORM;
  ret = (ret + gst_fast_random_uint32 ()) * GST_RAND_DOUBLE_TRANSFORM;

  if (ret >= 1.0)
    return gst_fast_random_double ();

  return ret;
}

static inline gdouble
gst_fast_random_double_range (gdouble start, gdouble end)
{
  return gst_fast_random_double () * (end - start) + start;
}

#undef GST_RAND_DOUBLE_TRANSFORM

#endif /* __GST_FAST_RANDOM__ */

