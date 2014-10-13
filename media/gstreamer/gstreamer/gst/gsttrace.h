/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gsttrace.h: Header for tracing functions (deprecated)
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


#ifndef __GST_TRACE_H__
#define __GST_TRACE_H__

#include <glib.h>

G_BEGIN_DECLS

/**
 * GstAllocTraceFlags:
 * @GST_ALLOC_TRACE_NONE: No tracing specified or desired.
 * @GST_ALLOC_TRACE_LIVE: Trace number of non-freed memory.
 * @GST_ALLOC_TRACE_MEM_LIVE: Trace pointers of unfreed memory.
 *
 * Flags indicating which tracing feature to enable.
 */
typedef enum {
  GST_ALLOC_TRACE_NONE      = 0,
  GST_ALLOC_TRACE_LIVE      = (1 << 0),
  GST_ALLOC_TRACE_MEM_LIVE  = (1 << 1)
} GstAllocTraceFlags;

typedef struct _GstAllocTrace   GstAllocTrace;

/**
 * GstAllocTrace:
 * @name: The name of the tracing object
 * @flags: Flags for this object
 * @offset: offset of the GType
 * @live: counter for live memory
 * @mem_live: list with pointers to unfreed memory
 *
 * The main tracing object
 */
struct _GstAllocTrace {
  gchar         *name;
  gint           flags;

  goffset        offset;
  gint           live;
  GSList        *mem_live;
};

#ifndef GST_DISABLE_TRACE

GST_EXPORT GMutex       _gst_trace_mutex;

void                    _priv_gst_alloc_trace_initialize (void);
void                    _priv_gst_alloc_trace_deinit     (void);
GstAllocTrace*          _priv_gst_alloc_trace_register   (const gchar *name, goffset offset);

void                    _priv_gst_alloc_trace_dump       (void);

#ifndef GST_DISABLE_ALLOC_TRACE
/**
 * gst_alloc_trace_register:
 * @name: The name of the tracer object
 *
 * Register a new alloc tracer with the given name
 */
#define _gst_alloc_trace_register(name,offset) _priv_gst_alloc_trace_register (name,offset)

#define _gst_alloc_trace_dump                  _priv_gst_alloc_trace_dump

/**
 * gst_alloc_trace_new:
 * @trace: The tracer to use
 * @mem: The memory allocated
 *
 * Use the tracer to trace a new memory allocation
 */
#define _gst_alloc_trace_new(trace, mem)           \
G_STMT_START {                                          \
  if (G_UNLIKELY ((trace)->flags)) {                    \
    g_mutex_lock (&_gst_trace_mutex);            \
    if ((trace)->flags & GST_ALLOC_TRACE_LIVE)          \
      (trace)->live++;                                  \
    if ((trace)->flags & GST_ALLOC_TRACE_MEM_LIVE)      \
      (trace)->mem_live =                               \
        g_slist_prepend ((trace)->mem_live, mem);       \
    g_mutex_unlock (&_gst_trace_mutex);          \
  }                                                     \
} G_STMT_END

/**
 * gst_alloc_trace_free:
 * @trace: The tracer to use
 * @mem: The memory that is freed
 *
 * Trace a memory free operation
 */
#define _gst_alloc_trace_free(trace, mem)                \
G_STMT_START {                                          \
  if (G_UNLIKELY ((trace)->flags)) {                    \
    g_mutex_lock (&_gst_trace_mutex);            \
    if ((trace)->flags & GST_ALLOC_TRACE_LIVE)          \
      (trace)->live--;                                  \
    if ((trace)->flags & GST_ALLOC_TRACE_MEM_LIVE)      \
      (trace)->mem_live =                               \
        g_slist_remove ((trace)->mem_live, mem);        \
    g_mutex_unlock (&_gst_trace_mutex);          \
  }                                                     \
} G_STMT_END

#else
#define _gst_alloc_trace_register(name) (NULL)
#define _gst_alloc_trace_new(trace, mem)
#define _gst_alloc_trace_free(trace, mem)
#define _gst_alloc_trace_dump()
#endif

#else /* GST_DISABLE_TRACE */

#define _gst_alloc_trace_register(name, offset)  (NULL)
#define _gst_alloc_trace_new(trace, mem)
#define _gst_alloc_trace_free(trace, mem)
#define _gst_alloc_trace_dump()

#endif /* GST_DISABLE_TRACE */

G_END_DECLS

#endif /* __GST_TRACE_H__ */
