/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wim.taymans@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *                    2011 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstquery.h: GstQuery API declaration
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


#ifndef __GST_QUERY_H__
#define __GST_QUERY_H__

#include <glib.h>

#include <gst/gstiterator.h>
#include <gst/gstminiobject.h>
#include <gst/gststructure.h>
#include <gst/gstformat.h>
#include <gst/gstpad.h>
#include <gst/gstallocator.h>
#include <gst/gsttoc.h>
#include <gst/gstcontext.h>

G_BEGIN_DECLS

typedef struct _GstQuery GstQuery;

/**
 * GstQueryTypeFlags:
 * @GST_QUERY_TYPE_UPSTREAM:     Set if the query can travel upstream.
 * @GST_QUERY_TYPE_DOWNSTREAM:   Set if the query can travel downstream.
 * @GST_QUERY_TYPE_SERIALIZED:   Set if the query should be serialized with data
 *                               flow.
 *
 * #GstQueryTypeFlags indicate the aspects of the different #GstQueryType
 * values. You can get the type flags of a #GstQueryType with the
 * gst_query_type_get_flags() function.
 */
typedef enum {
  GST_QUERY_TYPE_UPSTREAM       = 1 << 0,
  GST_QUERY_TYPE_DOWNSTREAM     = 1 << 1,
  GST_QUERY_TYPE_SERIALIZED     = 1 << 2
} GstQueryTypeFlags;

/**
 * GST_QUERY_TYPE_BOTH:
 *
 * The same thing as #GST_QUERY_TYPE_UPSTREAM | #GST_QUERY_TYPE_DOWNSTREAM.
 */
#define GST_QUERY_TYPE_BOTH \
    (GST_QUERY_TYPE_UPSTREAM | GST_QUERY_TYPE_DOWNSTREAM)

#define GST_QUERY_NUM_SHIFT     (8)

/**
 * GST_QUERY_MAKE_TYPE:
 * @num: the query number to create
 * @flags: the query flags
 *
 * when making custom query types, use this macro with the num and
 * the given flags
 */
#define GST_QUERY_MAKE_TYPE(num,flags) \
    (((num) << GST_QUERY_NUM_SHIFT) | (flags))

#define FLAG(name) GST_QUERY_TYPE_##name


/**
 * GstQueryType:
 * @GST_QUERY_UNKNOWN: unknown query type
 * @GST_QUERY_POSITION: current position in stream
 * @GST_QUERY_DURATION: total duration of the stream
 * @GST_QUERY_LATENCY: latency of stream
 * @GST_QUERY_JITTER: current jitter of stream
 * @GST_QUERY_RATE: current rate of the stream
 * @GST_QUERY_SEEKING: seeking capabilities
 * @GST_QUERY_SEGMENT: segment start/stop positions
 * @GST_QUERY_CONVERT: convert values between formats
 * @GST_QUERY_FORMATS: query supported formats for convert
 * @GST_QUERY_BUFFERING: query available media for efficient seeking.
 * @GST_QUERY_CUSTOM: a custom application or element defined query.
 * @GST_QUERY_URI: query the URI of the source or sink.
 * @GST_QUERY_ALLOCATION: the buffer allocation properties
 * @GST_QUERY_SCHEDULING: the scheduling properties
 * @GST_QUERY_ACCEPT_CAPS: the accept caps query
 * @GST_QUERY_CAPS: the caps query
 * @GST_QUERY_DRAIN: wait till all serialized data is consumed downstream
 * @GST_QUERY_CONTEXT: query the pipeline-local context from
 *     downstream or upstream (since 1.2)
 *
 * Standard predefined Query types
 */
/* NOTE: don't forget to update the table in gstquery.c when changing
 * this enum */
typedef enum {
  GST_QUERY_UNKNOWN      = GST_QUERY_MAKE_TYPE (0, 0),
  GST_QUERY_POSITION     = GST_QUERY_MAKE_TYPE (10, FLAG(BOTH)),
  GST_QUERY_DURATION     = GST_QUERY_MAKE_TYPE (20, FLAG(BOTH)),
  GST_QUERY_LATENCY      = GST_QUERY_MAKE_TYPE (30, FLAG(BOTH)),
  GST_QUERY_JITTER       = GST_QUERY_MAKE_TYPE (40, FLAG(BOTH)),
  GST_QUERY_RATE         = GST_QUERY_MAKE_TYPE (50, FLAG(BOTH)),
  GST_QUERY_SEEKING      = GST_QUERY_MAKE_TYPE (60, FLAG(BOTH)),
  GST_QUERY_SEGMENT      = GST_QUERY_MAKE_TYPE (70, FLAG(BOTH)),
  GST_QUERY_CONVERT      = GST_QUERY_MAKE_TYPE (80, FLAG(BOTH)),
  GST_QUERY_FORMATS      = GST_QUERY_MAKE_TYPE (90, FLAG(BOTH)),
  GST_QUERY_BUFFERING    = GST_QUERY_MAKE_TYPE (110, FLAG(BOTH)),
  GST_QUERY_CUSTOM       = GST_QUERY_MAKE_TYPE (120, FLAG(BOTH)),
  GST_QUERY_URI          = GST_QUERY_MAKE_TYPE (130, FLAG(BOTH)),
  GST_QUERY_ALLOCATION   = GST_QUERY_MAKE_TYPE (140, FLAG(DOWNSTREAM) | FLAG(SERIALIZED)),
  GST_QUERY_SCHEDULING   = GST_QUERY_MAKE_TYPE (150, FLAG(UPSTREAM)),
  GST_QUERY_ACCEPT_CAPS  = GST_QUERY_MAKE_TYPE (160, FLAG(BOTH)),
  GST_QUERY_CAPS         = GST_QUERY_MAKE_TYPE (170, FLAG(BOTH)),
  GST_QUERY_DRAIN        = GST_QUERY_MAKE_TYPE (180, FLAG(DOWNSTREAM) | FLAG(SERIALIZED)),
  GST_QUERY_CONTEXT      = GST_QUERY_MAKE_TYPE (190, FLAG(BOTH))
} GstQueryType;
#undef FLAG

GST_EXPORT GType _gst_query_type;

#define GST_TYPE_QUERY                         (_gst_query_type)
#define GST_IS_QUERY(obj)                      (GST_IS_MINI_OBJECT_TYPE (obj, GST_TYPE_QUERY))
#define GST_QUERY_CAST(obj)                    ((GstQuery*)(obj))
#define GST_QUERY(obj)                         (GST_QUERY_CAST(obj))

/**
 * GST_QUERY_TYPE:
 * @query: the query to query
 *
 * Get the #GstQueryType of the query.
 */
#define GST_QUERY_TYPE(query)  (((GstQuery*)(query))->type)

/**
 * GST_QUERY_TYPE_NAME:
 * @query: the query to query
 *
 * Get a constant string representation of the #GstQueryType of the query.
 */
#define GST_QUERY_TYPE_NAME(query) (gst_query_type_get_name(GST_QUERY_TYPE(query)))

/**
 * GST_QUERY_IS_UPSTREAM:
 * @ev: the query to query
 *
 * Check if an query can travel upstream.
 */
#define GST_QUERY_IS_UPSTREAM(ev)       !!(GST_QUERY_TYPE (ev) & GST_QUERY_TYPE_UPSTREAM)
/**
 * GST_QUERY_IS_DOWNSTREAM:
 * @ev: the query to query
 *
 * Check if an query can travel downstream.
 */
#define GST_QUERY_IS_DOWNSTREAM(ev)     !!(GST_QUERY_TYPE (ev) & GST_QUERY_TYPE_DOWNSTREAM)
/**
 * GST_QUERY_IS_SERIALIZED:
 * @ev: the query to query
 *
 * Check if an query is serialized with the data stream.
 */
#define GST_QUERY_IS_SERIALIZED(ev)     !!(GST_QUERY_TYPE (ev) & GST_QUERY_TYPE_SERIALIZED)


/**
 * GstQuery:
 * @mini_object: The parent #GstMiniObject type
 * @type: the #GstQueryType
 *
 * The #GstQuery structure.
 */
struct _GstQuery
{
  GstMiniObject mini_object;

  /*< public > *//* with COW */
  GstQueryType type;
};

const gchar*    gst_query_type_get_name        (GstQueryType type);
GQuark          gst_query_type_to_quark        (GstQueryType type);
GstQueryTypeFlags
                gst_query_type_get_flags       (GstQueryType type);


GType           gst_query_get_type             (void);

/* refcounting */
/**
 * gst_query_ref:
 * @q: a #GstQuery to increase the refcount of.
 *
 * Increases the refcount of the given query by one.
 *
 * Returns: @q
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC GstQuery * gst_query_ref (GstQuery * q);
#endif

static inline GstQuery *
gst_query_ref (GstQuery * q)
{
  return GST_QUERY_CAST (gst_mini_object_ref (GST_MINI_OBJECT_CAST (q)));
}

/**
 * gst_query_unref:
 * @q: a #GstQuery to decrease the refcount of.
 *
 * Decreases the refcount of the query. If the refcount reaches 0, the query
 * will be freed.
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC void gst_query_unref (GstQuery * q);
#endif

static inline void
gst_query_unref (GstQuery * q)
{
  gst_mini_object_unref (GST_MINI_OBJECT_CAST (q));
}

/* copy query */
/**
 * gst_query_copy:
 * @q: a #GstQuery to copy.
 *
 * Copies the given query using the copy function of the parent #GstStructure.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new copy of @q.
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC GstQuery * gst_query_copy (const GstQuery * q);
#endif

static inline GstQuery *
gst_query_copy (const GstQuery * q)
{
  return GST_QUERY_CAST (gst_mini_object_copy (GST_MINI_OBJECT_CONST_CAST (q)));
}

/**
 * gst_query_is_writable:
 * @q: a #GstQuery
 *
 * Tests if you can safely write data into a query's structure.
 */
#define         gst_query_is_writable(q)     gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (q))
/**
 * gst_query_make_writable:
 * @q: (transfer full): a #GstQuery to make writable
 *
 * Makes a writable query from the given query.
 *
 * Returns: (transfer full): a new writable query (possibly same as @q)
 */
#define         gst_query_make_writable(q)      GST_QUERY_CAST (gst_mini_object_make_writable (GST_MINI_OBJECT_CAST (q)))
/**
 * gst_query_replace:
 * @old_query: (inout) (transfer full) (nullable): pointer to a pointer to a
 *     #GstQuery to be replaced.
 * @new_query: (allow-none) (transfer none): pointer to a #GstQuery that will
 *     replace the query pointed to by @old_query.
 *
 * Modifies a pointer to a #GstQuery to point to a different #GstQuery. The
 * modification is done atomically (so this is useful for ensuring thread safety
 * in some cases), and the reference counts are updated appropriately (the old
 * query is unreffed, the new one is reffed).
 *
 * Either @new_query or the #GstQuery pointed to by @old_query may be %NULL.
 *
 * Returns: %TRUE if @new_query was different from @old_query
 */
#ifdef _FOOL_GTK_DOC_
G_INLINE_FUNC gboolean gst_query_replace (GstQuery **old_query, GstQuery *new_query);
#endif

static inline gboolean
gst_query_replace (GstQuery **old_query, GstQuery *new_query)
{
  return gst_mini_object_replace ((GstMiniObject **) old_query, (GstMiniObject *) new_query);
}

/* application specific query */
GstQuery *      gst_query_new_custom            (GstQueryType type, GstStructure *structure) G_GNUC_MALLOC;
const GstStructure *
                gst_query_get_structure         (GstQuery *query);
GstStructure *  gst_query_writable_structure    (GstQuery *query);

/* position query */
GstQuery*       gst_query_new_position          (GstFormat format) G_GNUC_MALLOC;
void            gst_query_set_position          (GstQuery *query, GstFormat format, gint64 cur);
void            gst_query_parse_position        (GstQuery *query, GstFormat *format, gint64 *cur);

/* duration query */
GstQuery*       gst_query_new_duration          (GstFormat format) G_GNUC_MALLOC;
void            gst_query_set_duration          (GstQuery *query, GstFormat format, gint64 duration);
void            gst_query_parse_duration        (GstQuery *query, GstFormat *format, gint64 *duration);

/* latency query */
GstQuery*       gst_query_new_latency           (void) G_GNUC_MALLOC;
void            gst_query_set_latency           (GstQuery *query, gboolean live, GstClockTime min_latency,
                                                 GstClockTime max_latency);
void            gst_query_parse_latency         (GstQuery *query, gboolean *live, GstClockTime *min_latency,
                                                 GstClockTime *max_latency);

/* convert query */
GstQuery*       gst_query_new_convert           (GstFormat src_format, gint64 value, GstFormat dest_format) G_GNUC_MALLOC;
void            gst_query_set_convert           (GstQuery *query, GstFormat src_format, gint64 src_value,
                                                 GstFormat dest_format, gint64 dest_value);
void            gst_query_parse_convert         (GstQuery *query, GstFormat *src_format, gint64 *src_value,
                                                 GstFormat *dest_format, gint64 *dest_value);
/* segment query */
GstQuery*       gst_query_new_segment           (GstFormat format) G_GNUC_MALLOC;
void            gst_query_set_segment           (GstQuery *query, gdouble rate, GstFormat format,
                                                 gint64 start_value, gint64 stop_value);
void            gst_query_parse_segment         (GstQuery *query, gdouble *rate, GstFormat *format,
                                                 gint64 *start_value, gint64 *stop_value);

/* seeking query */
GstQuery*       gst_query_new_seeking           (GstFormat format) G_GNUC_MALLOC;
void            gst_query_set_seeking           (GstQuery *query, GstFormat format,
                                                 gboolean seekable,
                                                 gint64 segment_start,
                                                 gint64 segment_end);
void            gst_query_parse_seeking         (GstQuery *query, GstFormat *format,
                                                 gboolean *seekable,
                                                 gint64 *segment_start,
                                                 gint64 *segment_end);
/* formats query */
GstQuery*       gst_query_new_formats           (void) G_GNUC_MALLOC;
void            gst_query_set_formats           (GstQuery *query, gint n_formats, ...);
void            gst_query_set_formatsv          (GstQuery *query, gint n_formats, const GstFormat *formats);
void            gst_query_parse_n_formats       (GstQuery *query, guint *n_formats);
void            gst_query_parse_nth_format      (GstQuery *query, guint nth, GstFormat *format);

/* buffering query */
/**
 * GstBufferingMode:
 * @GST_BUFFERING_STREAM: a small amount of data is buffered
 * @GST_BUFFERING_DOWNLOAD: the stream is being downloaded
 * @GST_BUFFERING_TIMESHIFT: the stream is being downloaded in a ringbuffer
 * @GST_BUFFERING_LIVE: the stream is a live stream
 *
 * The different types of buffering methods.
 */
typedef enum {
  GST_BUFFERING_STREAM,
  GST_BUFFERING_DOWNLOAD,
  GST_BUFFERING_TIMESHIFT,
  GST_BUFFERING_LIVE
} GstBufferingMode;

GstQuery*       gst_query_new_buffering           (GstFormat format) G_GNUC_MALLOC;
void            gst_query_set_buffering_percent   (GstQuery *query, gboolean busy, gint percent);
void            gst_query_parse_buffering_percent (GstQuery *query, gboolean *busy, gint *percent);

void            gst_query_set_buffering_stats     (GstQuery *query, GstBufferingMode mode,
                                                   gint avg_in, gint avg_out,
                                                   gint64 buffering_left);
void            gst_query_parse_buffering_stats    (GstQuery *query, GstBufferingMode *mode,
                                                   gint *avg_in, gint *avg_out,
                                                   gint64 *buffering_left);

void            gst_query_set_buffering_range     (GstQuery *query, GstFormat format,
                                                   gint64 start, gint64 stop,
                                                   gint64 estimated_total);
void            gst_query_parse_buffering_range   (GstQuery *query, GstFormat *format,
                                                   gint64 *start, gint64 *stop,
                                                   gint64 *estimated_total);

gboolean        gst_query_add_buffering_range       (GstQuery *query,
                                                     gint64 start, gint64 stop);
guint           gst_query_get_n_buffering_ranges    (GstQuery *query);
gboolean        gst_query_parse_nth_buffering_range (GstQuery *query,
                                                     guint index, gint64 *start,
                                                     gint64 *stop);

/* URI query */
GstQuery *      gst_query_new_uri                    (void) G_GNUC_MALLOC;
void            gst_query_parse_uri                  (GstQuery *query, gchar **uri);
void            gst_query_set_uri                    (GstQuery *query, const gchar *uri);
void            gst_query_parse_uri_redirection      (GstQuery *query, gchar **uri);
void            gst_query_set_uri_redirection        (GstQuery *query, const gchar *uri);
void            gst_query_parse_uri_redirection_permanent (GstQuery *query, gboolean * permanent);
void            gst_query_set_uri_redirection_permanent (GstQuery *query, gboolean permanent);

/* allocation query */
GstQuery *      gst_query_new_allocation             (GstCaps *caps, gboolean need_pool) G_GNUC_MALLOC;
void            gst_query_parse_allocation           (GstQuery *query, GstCaps **caps, gboolean *need_pool);

/* pools */
void            gst_query_add_allocation_pool        (GstQuery *query, GstBufferPool *pool,
                                                      guint size, guint min_buffers,
                                                      guint max_buffers);
guint           gst_query_get_n_allocation_pools     (GstQuery *query);
void            gst_query_parse_nth_allocation_pool  (GstQuery *query, guint index,
                                                      GstBufferPool **pool,
                                                      guint *size, guint *min_buffers,
                                                      guint *max_buffers);
void            gst_query_set_nth_allocation_pool    (GstQuery *query, guint index,
                                                      GstBufferPool *pool,
                                                      guint size, guint min_buffers,
                                                      guint max_buffers);
void            gst_query_remove_nth_allocation_pool (GstQuery *query, guint index);

/* allocators */
void            gst_query_add_allocation_param       (GstQuery *query, GstAllocator *allocator,
                                                      const GstAllocationParams *params);
guint           gst_query_get_n_allocation_params    (GstQuery *query);
void            gst_query_parse_nth_allocation_param (GstQuery *query, guint index,
                                                      GstAllocator **allocator,
                                                      GstAllocationParams *params);
void            gst_query_set_nth_allocation_param   (GstQuery *query, guint index,
                                                      GstAllocator *allocator,
                                                      const GstAllocationParams *params);
void            gst_query_remove_nth_allocation_param (GstQuery *query, guint index);

/* metadata */
void            gst_query_add_allocation_meta        (GstQuery *query, GType api, const GstStructure *params);
guint           gst_query_get_n_allocation_metas     (GstQuery *query);
GType           gst_query_parse_nth_allocation_meta  (GstQuery *query, guint index,
                                                      const GstStructure **params);
void            gst_query_remove_nth_allocation_meta (GstQuery *query, guint index);
gboolean        gst_query_find_allocation_meta       (GstQuery *query, GType api, guint *index);


/* scheduling query */
/**
 * GstSchedulingFlags:
 * @GST_SCHEDULING_FLAG_SEEKABLE: if seeking is possible
 * @GST_SCHEDULING_FLAG_SEQUENTIAL: if sequential access is recommended
 * @GST_SCHEDULING_FLAG_BANDWIDTH_LIMITED: if bandwidth is limited and buffering possible (since 1.2)
 *
 * The different scheduling flags.
 */
typedef enum {
  GST_SCHEDULING_FLAG_SEEKABLE          = (1 << 0),
  GST_SCHEDULING_FLAG_SEQUENTIAL        = (1 << 1),
  GST_SCHEDULING_FLAG_BANDWIDTH_LIMITED = (1 << 2)
} GstSchedulingFlags;

GstQuery *      gst_query_new_scheduling          (void) G_GNUC_MALLOC;

void            gst_query_set_scheduling          (GstQuery *query, GstSchedulingFlags flags,
                                                   gint minsize, gint maxsize, gint align);
void            gst_query_parse_scheduling        (GstQuery *query, GstSchedulingFlags *flags,
                                                   gint *minsize, gint *maxsize, gint *align);

void            gst_query_add_scheduling_mode       (GstQuery *query, GstPadMode mode);
guint           gst_query_get_n_scheduling_modes    (GstQuery *query);
GstPadMode      gst_query_parse_nth_scheduling_mode (GstQuery *query, guint index);
gboolean        gst_query_has_scheduling_mode       (GstQuery *query, GstPadMode mode);
gboolean        gst_query_has_scheduling_mode_with_flags (GstQuery * query, GstPadMode mode,
                                                    GstSchedulingFlags flags);

/* accept-caps query */
GstQuery *      gst_query_new_accept_caps          (GstCaps *caps) G_GNUC_MALLOC;
void            gst_query_parse_accept_caps        (GstQuery *query, GstCaps **caps);
void            gst_query_set_accept_caps_result   (GstQuery *query, gboolean result);
void            gst_query_parse_accept_caps_result (GstQuery *query, gboolean *result);

/* caps query */
GstQuery *      gst_query_new_caps                 (GstCaps *filter) G_GNUC_MALLOC;
void            gst_query_parse_caps               (GstQuery *query, GstCaps **filter);

void            gst_query_set_caps_result          (GstQuery *query, GstCaps *caps);
void            gst_query_parse_caps_result        (GstQuery *query, GstCaps **caps);

/* drain query */
GstQuery *      gst_query_new_drain                (void) G_GNUC_MALLOC;

/* context query */
GstQuery *      gst_query_new_context              (const gchar * context_type) G_GNUC_MALLOC;
gboolean        gst_query_parse_context_type       (GstQuery * query, const gchar ** context_type);
void            gst_query_set_context              (GstQuery *query, GstContext *context);
void            gst_query_parse_context            (GstQuery *query, GstContext **context);

G_END_DECLS

#endif /* __GST_QUERY_H__ */

