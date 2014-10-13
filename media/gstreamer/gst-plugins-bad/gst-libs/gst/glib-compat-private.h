/*
 * glib-compat.c
 * Functions copied from glib 2.10
 *
 * Copyright 2005 David Schleef <ds@schleef.org>
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

#ifndef __GLIB_COMPAT_PRIVATE_H__
#define __GLIB_COMPAT_PRIVATE_H__

#include <glib.h>

G_BEGIN_DECLS

#if !GLIB_CHECK_VERSION(2,25,0)

#if defined (_MSC_VER) && !defined(_WIN64)
typedef struct _stat32 GStatBuf;
#else
typedef struct stat GStatBuf;
#endif

#endif

#if GLIB_CHECK_VERSION(2,26,0)
#define GLIB_HAS_GDATETIME
#endif

/* See bug #651514 */
#if GLIB_CHECK_VERSION(2,29,5)
#define G_ATOMIC_POINTER_COMPARE_AND_EXCHANGE(a,b,c) \
    g_atomic_pointer_compare_and_exchange ((a),(b),(c))
#define G_ATOMIC_INT_COMPARE_AND_EXCHANGE(a,b,c) \
    g_atomic_int_compare_and_exchange ((a),(b),(c))
#else
#define G_ATOMIC_POINTER_COMPARE_AND_EXCHANGE(a,b,c) \
    g_atomic_pointer_compare_and_exchange ((volatile gpointer *)(a),(b),(c))
#define G_ATOMIC_INT_COMPARE_AND_EXCHANGE(a,b,c) \
    g_atomic_int_compare_and_exchange ((volatile int *)(a),(b),(c))
#endif

/* See bug #651514 */
#if GLIB_CHECK_VERSION(2,29,5)
#define G_ATOMIC_INT_ADD(a,b) g_atomic_int_add ((a),(b))
#else
#define G_ATOMIC_INT_ADD(a,b) g_atomic_int_exchange_and_add ((a),(b))
#endif

/* copies */

#if GLIB_CHECK_VERSION (2, 31, 0)
#define g_mutex_new gst_g_mutex_new
static inline GMutex *
gst_g_mutex_new (void)
{
  GMutex *mutex = g_slice_new (GMutex);
  g_mutex_init (mutex);
  return mutex;
}
#define g_mutex_free gst_g_mutex_free
static inline void
gst_g_mutex_free (GMutex *mutex)
{
  g_mutex_clear (mutex);
  g_slice_free (GMutex, mutex);
}
#define g_cond_new gst_g_cond_new
static inline GCond *
gst_g_cond_new (void)
{
  GCond *cond = g_slice_new (GCond);
  g_cond_init (cond);
  return cond;
}
#define g_cond_free gst_g_cond_free
static inline void
gst_g_cond_free (GCond *cond)
{
  g_cond_clear (cond);
  g_slice_free (GCond, cond);
}
#define g_cond_timed_wait gst_g_cond_timed_wait
static inline gboolean
gst_g_cond_timed_wait (GCond *cond, GMutex *mutex, GTimeVal *abs_time)
{
  gint64 end_time;

  if (abs_time == NULL) {
    g_cond_wait (cond, mutex);
    return TRUE;
  }

  end_time = abs_time->tv_sec;
  end_time *= 1000000;
  end_time += abs_time->tv_usec;

  /* would be nice if we had clock_rtoffset, but that didn't seem to
   * make it into the kernel yet...
   */
  /* if CLOCK_MONOTONIC is not defined then g_get_montonic_time() and
   * g_get_real_time() are returning the same clock and we'd add ~0
   */
  end_time += g_get_monotonic_time () - g_get_real_time ();
  return g_cond_wait_until (cond, mutex, end_time);
}
#endif /* GLIB_CHECK_VERSION (2, 31, 0) */

#if GLIB_CHECK_VERSION (2, 31, 0)
#define g_thread_create gst_g_thread_create
static inline GThread *
gst_g_thread_create (GThreadFunc func, gpointer data, gboolean joinable,
    GError **error)
{
  GThread *thread = g_thread_try_new ("gst-check", func, data, error);
  if (!joinable)
    g_thread_unref (thread);
  return thread;
}
#endif /* GLIB_CHECK_VERSION (2, 31, 0) */

/* adaptations */

G_END_DECLS

#endif
