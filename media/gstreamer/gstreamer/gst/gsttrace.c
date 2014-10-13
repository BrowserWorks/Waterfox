/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gsttrace.c: Tracing functions (deprecated)
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
#include <stdio.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>

#if defined (_MSC_VER) && _MSC_VER >= 1400
# include <io.h>
#endif

#include "gst_private.h"
#include "gstinfo.h"

#include "gsttrace.h"

GMutex _gst_trace_mutex;

/* global flags */
static GstAllocTraceFlags _gst_trace_flags = GST_ALLOC_TRACE_NONE;

/* list of registered tracers */
static GList *_gst_alloc_tracers = NULL;

static void
_at_exit (void)
{
  if (_gst_trace_flags)
    _priv_gst_alloc_trace_dump ();
}

void
_priv_gst_alloc_trace_initialize (void)
{
  const gchar *trace;

  trace = g_getenv ("GST_TRACE");
  if (trace != NULL) {
    const GDebugKey keys[] = {
      {"live", GST_ALLOC_TRACE_LIVE},
      {"mem-live", GST_ALLOC_TRACE_MEM_LIVE},
    };
    _gst_trace_flags = g_parse_debug_string (trace, keys, G_N_ELEMENTS (keys));
    atexit (_at_exit);
  }

  g_mutex_init (&_gst_trace_mutex);
}

void
_priv_gst_alloc_trace_deinit (void)
{
  g_mutex_clear (&_gst_trace_mutex);
}

/**
 * _priv_gst_alloc_trace_register:
 * @name: the name of the new alloc trace object.
 * @offset: the offset in the object where a GType an be found. -1 when the
 * object has no gtype.
 *
 * Register an get a handle to a GstAllocTrace object that
 * can be used to trace memory allocations.
 *
 * Returns: A handle to a GstAllocTrace.
 */
GstAllocTrace *
_priv_gst_alloc_trace_register (const gchar * name, goffset offset)
{
  GstAllocTrace *trace;

  g_return_val_if_fail (name, NULL);

  trace = g_slice_new (GstAllocTrace);
  trace->name = g_strdup (name);
  trace->live = 0;
  trace->mem_live = NULL;
  trace->flags = _gst_trace_flags;
  trace->offset = offset;

  _gst_alloc_tracers = g_list_prepend (_gst_alloc_tracers, trace);

  return trace;
}

static gint
compare_func (GstAllocTrace * a, GstAllocTrace * b)
{
  return strcmp (a->name, b->name);
}

static GList *
gst_alloc_trace_list_sorted (void)
{
  GList *ret;

  ret = g_list_sort (g_list_copy (_gst_alloc_tracers),
      (GCompareFunc) compare_func);

  return ret;
}

static void
gst_alloc_trace_print (const GstAllocTrace * trace)
{
  GSList *mem_live;

  g_return_if_fail (trace != NULL);

  if (trace->flags & GST_ALLOC_TRACE_LIVE) {
    g_print ("%-22.22s : %d\n", trace->name, trace->live);
  } else {
    g_print ("%-22.22s : (no live count)\n", trace->name);
  }

  if (trace->flags & GST_ALLOC_TRACE_MEM_LIVE) {
    mem_live = trace->mem_live;

    while (mem_live) {
      gpointer data = mem_live->data;
      const gchar *type_name;
      gchar *extra = NULL;
      gint refcount = -1;

      if (trace->offset == -2) {
        if (G_IS_OBJECT (data)) {
          type_name = G_OBJECT_TYPE_NAME (data);
          refcount = G_OBJECT (data)->ref_count;
        } else
          type_name = "<invalid>";
      } else if (trace->offset == -1) {
        type_name = "<unknown>";
      } else {
        GType type;

        type = G_STRUCT_MEMBER (GType, data, trace->offset);
        type_name = g_type_name (type);

        if (type == GST_TYPE_CAPS) {
          extra = gst_caps_to_string (data);
        }
        refcount = GST_MINI_OBJECT_REFCOUNT_VALUE (data);
      }

      if (extra) {
        g_print ("  %-20.20s : (%d) %p (\"%s\")\n", type_name, refcount, data,
            extra);
        g_free (extra);
      } else
        g_print ("  %-20.20s : (%d) %p\n", type_name, refcount, data);

      mem_live = mem_live->next;
    }
  }
}

/**
 * _priv_gst_alloc_trace_dump:
 *
 * Print the status of all registered alloc trace objects.
 */
void
_priv_gst_alloc_trace_dump (void)
{
  GList *orig, *walk;

  orig = walk = gst_alloc_trace_list_sorted ();

  while (walk) {
    GstAllocTrace *trace = (GstAllocTrace *) walk->data;

    gst_alloc_trace_print (trace);

    walk = g_list_next (walk);
  }

  g_list_free (orig);
}
