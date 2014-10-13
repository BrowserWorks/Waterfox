/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wim.taymans@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstquery.c: GstQueryType registration and Query parsing/creation
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

/**
 * SECTION:gstquery
 * @short_description: Provide functions to create queries, and to set and parse
 *                     values in them.
 * @see_also: #GstPad, #GstElement
 *
 * Queries can be performed on pads (gst_pad_query()) and elements
 * (gst_element_query()). Please note that some queries might need a running
 * pipeline to work.
 *
 * Queries can be created using the gst_query_new_*() functions.
 * Query values can be set using gst_query_set_*(), and parsed using
 * gst_query_parse_*() helpers.
 *
 * The following example shows how to query the duration of a pipeline:
 * |[
 *   GstQuery *query;
 *   gboolean res;
 *   query = gst_query_new_duration (GST_FORMAT_TIME);
 *   res = gst_element_query (pipeline, query);
 *   if (res) {
 *     gint64 duration;
 *     gst_query_parse_duration (query, NULL, &amp;duration);
 *     g_print ("duration = %"GST_TIME_FORMAT, GST_TIME_ARGS (duration));
 *   } else {
 *     g_print ("duration query failed...");
 *   }
 *   gst_query_unref (query);
 * ]|
 */


#include "gst_private.h"
#include "gstinfo.h"
#include "gstquery.h"
#include "gstvalue.h"
#include "gstenumtypes.h"
#include "gstquark.h"
#include "gsturi.h"
#include "gstbufferpool.h"

GST_DEBUG_CATEGORY_STATIC (gst_query_debug);
#define GST_CAT_DEFAULT gst_query_debug

GType _gst_query_type = 0;

typedef struct
{
  GstQuery query;

  GstStructure *structure;
} GstQueryImpl;

#define GST_QUERY_STRUCTURE(q)  (((GstQueryImpl *)(q))->structure)


typedef struct
{
  const gint type;
  const gchar *name;
  GQuark quark;
} GstQueryQuarks;

static GstQueryQuarks query_quarks[] = {
  {GST_QUERY_UNKNOWN, "unknown", 0},
  {GST_QUERY_POSITION, "position", 0},
  {GST_QUERY_DURATION, "duration", 0},
  {GST_QUERY_LATENCY, "latency", 0},
  {GST_QUERY_JITTER, "jitter", 0},
  {GST_QUERY_RATE, "rate", 0},
  {GST_QUERY_SEEKING, "seeking", 0},
  {GST_QUERY_SEGMENT, "segment", 0},
  {GST_QUERY_CONVERT, "convert", 0},
  {GST_QUERY_FORMATS, "formats", 0},
  {GST_QUERY_BUFFERING, "buffering", 0},
  {GST_QUERY_CUSTOM, "custom", 0},
  {GST_QUERY_URI, "uri", 0},
  {GST_QUERY_ALLOCATION, "allocation", 0},
  {GST_QUERY_SCHEDULING, "scheduling", 0},
  {GST_QUERY_ACCEPT_CAPS, "accept-caps", 0},
  {GST_QUERY_CAPS, "caps", 0},
  {GST_QUERY_DRAIN, "drain", 0},
  {GST_QUERY_CONTEXT, "context", 0},

  {0, NULL, 0}
};

GST_DEFINE_MINI_OBJECT_TYPE (GstQuery, gst_query);

void
_priv_gst_query_initialize (void)
{
  gint i;

  _gst_query_type = gst_query_get_type ();

  GST_DEBUG_CATEGORY_INIT (gst_query_debug, "query", 0, "query system");

  for (i = 0; query_quarks[i].name; i++) {
    query_quarks[i].quark = g_quark_from_static_string (query_quarks[i].name);
  }
}

/**
 * gst_query_type_get_name:
 * @type: the query type
 *
 * Get a printable name for the given query type. Do not modify or free.
 *
 * Returns: a reference to the static name of the query.
 */
const gchar *
gst_query_type_get_name (GstQueryType type)
{
  gint i;

  for (i = 0; query_quarks[i].name; i++) {
    if (type == query_quarks[i].type)
      return query_quarks[i].name;
  }
  return "unknown";
}

/**
 * gst_query_type_to_quark:
 * @type: the query type
 *
 * Get the unique quark for the given query type.
 *
 * Returns: the quark associated with the query type
 */
GQuark
gst_query_type_to_quark (GstQueryType type)
{
  gint i;

  for (i = 0; query_quarks[i].name; i++) {
    if (type == query_quarks[i].type)
      return query_quarks[i].quark;
  }
  return 0;
}

/**
 * gst_query_type_get_flags:
 * @type: a #GstQueryType
 *
 * Gets the #GstQueryTypeFlags associated with @type.
 *
 * Returns: a #GstQueryTypeFlags.
 */
GstQueryTypeFlags
gst_query_type_get_flags (GstQueryType type)
{
  GstQueryTypeFlags ret;

  ret = type & ((1 << GST_QUERY_NUM_SHIFT) - 1);

  return ret;
}

static void
_gst_query_free (GstQuery * query)
{
  GstStructure *s;

  g_return_if_fail (query != NULL);

  s = GST_QUERY_STRUCTURE (query);
  if (s) {
    gst_structure_set_parent_refcount (s, NULL);
    gst_structure_free (s);
  }

  g_slice_free1 (sizeof (GstQueryImpl), query);
}

static GstQuery *
_gst_query_copy (GstQuery * query)
{
  GstQuery *copy;
  GstStructure *s;

  s = GST_QUERY_STRUCTURE (query);
  if (s) {
    s = gst_structure_copy (s);
  }
  copy = gst_query_new_custom (query->type, s);

  return copy;
}

/**
 * gst_query_new_position:
 * @format: the default #GstFormat for the new query
 *
 * Constructs a new query stream position query object. Use gst_query_unref()
 * when done with it. A position query is used to query the current position
 * of playback in the streams, in some format.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_position (GstFormat format)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_POSITION),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (CURRENT), G_TYPE_INT64, G_GINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_POSITION, structure);

  return query;
}

/**
 * gst_query_set_position:
 * @query: a #GstQuery with query type GST_QUERY_POSITION
 * @format: the requested #GstFormat
 * @cur: the position to set
 *
 * Answer a position query by setting the requested value in the given format.
 */
void
gst_query_set_position (GstQuery * query, GstFormat format, gint64 cur)
{
  GstStructure *s;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_POSITION);

  s = GST_QUERY_STRUCTURE (query);
  g_return_if_fail (format == g_value_get_enum (gst_structure_id_get_value (s,
              GST_QUARK (FORMAT))));

  gst_structure_id_set (s,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (CURRENT), G_TYPE_INT64, cur, NULL);
}

/**
 * gst_query_parse_position:
 * @query: a #GstQuery
 * @format: (out) (allow-none): the storage for the #GstFormat of the
 *     position values (may be %NULL)
 * @cur: (out) (allow-none): the storage for the current position (may be %NULL)
 *
 * Parse a position query, writing the format into @format, and the position
 * into @cur, if the respective parameters are non-%NULL.
 */
void
gst_query_parse_position (GstQuery * query, GstFormat * format, gint64 * cur)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_POSITION);

  structure = GST_QUERY_STRUCTURE (query);
  if (format)
    *format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (cur)
    *cur = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (CURRENT)));
}


/**
 * gst_query_new_duration:
 * @format: the #GstFormat for this duration query
 *
 * Constructs a new stream duration query object to query in the given format.
 * Use gst_query_unref() when done with it. A duration query will give the
 * total length of the stream.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_duration (GstFormat format)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_DURATION),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (DURATION), G_TYPE_INT64, G_GINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_DURATION, structure);

  return query;
}

/**
 * gst_query_set_duration:
 * @query: a #GstQuery
 * @format: the #GstFormat for the duration
 * @duration: the duration of the stream
 *
 * Answer a duration query by setting the requested value in the given format.
 */
void
gst_query_set_duration (GstQuery * query, GstFormat format, gint64 duration)
{
  GstStructure *s;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_DURATION);

  s = GST_QUERY_STRUCTURE (query);
  g_return_if_fail (format == g_value_get_enum (gst_structure_id_get_value (s,
              GST_QUARK (FORMAT))));
  gst_structure_id_set (s, GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (DURATION), G_TYPE_INT64, duration, NULL);
}

/**
 * gst_query_parse_duration:
 * @query: a #GstQuery
 * @format: (out) (allow-none): the storage for the #GstFormat of the duration
 *     value, or %NULL.
 * @duration: (out) (allow-none): the storage for the total duration, or %NULL.
 *
 * Parse a duration query answer. Write the format of the duration into @format,
 * and the value into @duration, if the respective variables are non-%NULL.
 */
void
gst_query_parse_duration (GstQuery * query, GstFormat * format,
    gint64 * duration)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_DURATION);

  structure = GST_QUERY_STRUCTURE (query);
  if (format)
    *format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (duration)
    *duration = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (DURATION)));
}

/**
 * gst_query_new_latency:
 *
 * Constructs a new latency query object.
 * Use gst_query_unref() when done with it. A latency query is usually performed
 * by sinks to compensate for additional latency introduced by elements in the
 * pipeline.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a #GstQuery
 */
GstQuery *
gst_query_new_latency (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_LATENCY),
      GST_QUARK (LIVE), G_TYPE_BOOLEAN, FALSE,
      GST_QUARK (MIN_LATENCY), G_TYPE_UINT64, G_GUINT64_CONSTANT (0),
      GST_QUARK (MAX_LATENCY), G_TYPE_UINT64, G_GUINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_LATENCY, structure);

  return query;
}

/**
 * gst_query_set_latency:
 * @query: a #GstQuery
 * @live: if there is a live element upstream
 * @min_latency: the minimal latency of the upstream elements
 * @max_latency: the maximal latency of the upstream elements
 *
 * Answer a latency query by setting the requested values in the given format.
 */
void
gst_query_set_latency (GstQuery * query, gboolean live,
    GstClockTime min_latency, GstClockTime max_latency)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_LATENCY);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (LIVE), G_TYPE_BOOLEAN, live,
      GST_QUARK (MIN_LATENCY), G_TYPE_UINT64, min_latency,
      GST_QUARK (MAX_LATENCY), G_TYPE_UINT64, max_latency, NULL);
}

/**
 * gst_query_parse_latency:
 * @query: a #GstQuery
 * @live: (out) (allow-none): storage for live or %NULL
 * @min_latency: (out) (allow-none): the storage for the min latency or %NULL
 * @max_latency: (out) (allow-none): the storage for the max latency or %NULL
 *
 * Parse a latency query answer.
 */
void
gst_query_parse_latency (GstQuery * query, gboolean * live,
    GstClockTime * min_latency, GstClockTime * max_latency)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_LATENCY);

  structure = GST_QUERY_STRUCTURE (query);
  if (live)
    *live =
        g_value_get_boolean (gst_structure_id_get_value (structure,
            GST_QUARK (LIVE)));
  if (min_latency)
    *min_latency = g_value_get_uint64 (gst_structure_id_get_value (structure,
            GST_QUARK (MIN_LATENCY)));
  if (max_latency)
    *max_latency = g_value_get_uint64 (gst_structure_id_get_value (structure,
            GST_QUARK (MAX_LATENCY)));
}

/**
 * gst_query_new_convert:
 * @src_format: the source #GstFormat for the new query
 * @value: the value to convert
 * @dest_format: the target #GstFormat
 *
 * Constructs a new convert query object. Use gst_query_unref()
 * when done with it. A convert query is used to ask for a conversion between
 * one format and another.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a #GstQuery
 */
GstQuery *
gst_query_new_convert (GstFormat src_format, gint64 value,
    GstFormat dest_format)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_CONVERT),
      GST_QUARK (SRC_FORMAT), GST_TYPE_FORMAT, src_format,
      GST_QUARK (SRC_VALUE), G_TYPE_INT64, value,
      GST_QUARK (DEST_FORMAT), GST_TYPE_FORMAT, dest_format,
      GST_QUARK (DEST_VALUE), G_TYPE_INT64, G_GINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_CONVERT, structure);

  return query;
}

/**
 * gst_query_set_convert:
 * @query: a #GstQuery
 * @src_format: the source #GstFormat
 * @src_value: the source value
 * @dest_format: the destination #GstFormat
 * @dest_value: the destination value
 *
 * Answer a convert query by setting the requested values.
 */
void
gst_query_set_convert (GstQuery * query, GstFormat src_format, gint64 src_value,
    GstFormat dest_format, gint64 dest_value)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CONVERT);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (SRC_FORMAT), GST_TYPE_FORMAT, src_format,
      GST_QUARK (SRC_VALUE), G_TYPE_INT64, src_value,
      GST_QUARK (DEST_FORMAT), GST_TYPE_FORMAT, dest_format,
      GST_QUARK (DEST_VALUE), G_TYPE_INT64, dest_value, NULL);
}

/**
 * gst_query_parse_convert:
 * @query: a #GstQuery
 * @src_format: (out) (allow-none): the storage for the #GstFormat of the
 *     source value, or %NULL
 * @src_value: (out) (allow-none): the storage for the source value, or %NULL
 * @dest_format: (out) (allow-none): the storage for the #GstFormat of the
 *     destination value, or %NULL
 * @dest_value: (out) (allow-none): the storage for the destination value,
 *     or %NULL
 *
 * Parse a convert query answer. Any of @src_format, @src_value, @dest_format,
 * and @dest_value may be %NULL, in which case that value is omitted.
 */
void
gst_query_parse_convert (GstQuery * query, GstFormat * src_format,
    gint64 * src_value, GstFormat * dest_format, gint64 * dest_value)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CONVERT);

  structure = GST_QUERY_STRUCTURE (query);
  if (src_format)
    *src_format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (SRC_FORMAT)));
  if (src_value)
    *src_value = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (SRC_VALUE)));
  if (dest_format)
    *dest_format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (DEST_FORMAT)));
  if (dest_value)
    *dest_value = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (DEST_VALUE)));
}

/**
 * gst_query_new_segment:
 * @format: the #GstFormat for the new query
 *
 * Constructs a new segment query object. Use gst_query_unref()
 * when done with it. A segment query is used to discover information about the
 * currently configured segment for playback.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_segment (GstFormat format)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_SEGMENT),
      GST_QUARK (RATE), G_TYPE_DOUBLE, (gdouble) 0.0,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (START_VALUE), G_TYPE_INT64, G_GINT64_CONSTANT (-1),
      GST_QUARK (STOP_VALUE), G_TYPE_INT64, G_GINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_SEGMENT, structure);

  return query;
}

/**
 * gst_query_set_segment:
 * @query: a #GstQuery
 * @rate: the rate of the segment
 * @format: the #GstFormat of the segment values (@start_value and @stop_value)
 * @start_value: the start value
 * @stop_value: the stop value
 *
 * Answer a segment query by setting the requested values. The normal
 * playback segment of a pipeline is 0 to duration at the default rate of
 * 1.0. If a seek was performed on the pipeline to play a different
 * segment, this query will return the range specified in the last seek.
 *
 * @start_value and @stop_value will respectively contain the configured
 * playback range start and stop values expressed in @format.
 * The values are always between 0 and the duration of the media and
 * @start_value <= @stop_value. @rate will contain the playback rate. For
 * negative rates, playback will actually happen from @stop_value to
 * @start_value.
 */
void
gst_query_set_segment (GstQuery * query, gdouble rate, GstFormat format,
    gint64 start_value, gint64 stop_value)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SEGMENT);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (RATE), G_TYPE_DOUBLE, rate,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (START_VALUE), G_TYPE_INT64, start_value,
      GST_QUARK (STOP_VALUE), G_TYPE_INT64, stop_value, NULL);
}

/**
 * gst_query_parse_segment:
 * @query: a #GstQuery
 * @rate: (out) (allow-none): the storage for the rate of the segment, or %NULL
 * @format: (out) (allow-none): the storage for the #GstFormat of the values,
 *     or %NULL
 * @start_value: (out) (allow-none): the storage for the start value, or %NULL
 * @stop_value: (out) (allow-none): the storage for the stop value, or %NULL
 *
 * Parse a segment query answer. Any of @rate, @format, @start_value, and
 * @stop_value may be %NULL, which will cause this value to be omitted.
 *
 * See gst_query_set_segment() for an explanation of the function arguments.
 */
void
gst_query_parse_segment (GstQuery * query, gdouble * rate, GstFormat * format,
    gint64 * start_value, gint64 * stop_value)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SEGMENT);

  structure = GST_QUERY_STRUCTURE (query);
  if (rate)
    *rate = g_value_get_double (gst_structure_id_get_value (structure,
            GST_QUARK (RATE)));
  if (format)
    *format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (start_value)
    *start_value = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (START_VALUE)));
  if (stop_value)
    *stop_value = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (STOP_VALUE)));
}

/**
 * gst_query_new_custom:
 * @type: the query type
 * @structure: (allow-none) (transfer full): a structure for the query
 *
 * Constructs a new custom query object. Use gst_query_unref()
 * when done with it.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_custom (GstQueryType type, GstStructure * structure)
{
  GstQueryImpl *query;

  query = g_slice_new0 (GstQueryImpl);

  GST_DEBUG ("creating new query %p %s", query, gst_query_type_get_name (type));

  if (structure) {
    /* structure must not have a parent */
    if (!gst_structure_set_parent_refcount (structure,
            &query->query.mini_object.refcount))
      goto had_parent;
  }

  gst_mini_object_init (GST_MINI_OBJECT_CAST (query), 0, _gst_query_type,
      (GstMiniObjectCopyFunction) _gst_query_copy, NULL,
      (GstMiniObjectFreeFunction) _gst_query_free);

  GST_QUERY_TYPE (query) = type;
  GST_QUERY_STRUCTURE (query) = structure;

  return GST_QUERY_CAST (query);

  /* ERRORS */
had_parent:
  {
    g_slice_free1 (sizeof (GstQueryImpl), query);
    g_warning ("structure is already owned by another object");
    return NULL;
  }
}

/**
 * gst_query_get_structure:
 * @query: a #GstQuery
 *
 * Get the structure of a query.
 *
 * Returns: (transfer none): the #GstStructure of the query. The structure is
 *     still owned by the query and will therefore be freed when the query
 *     is unreffed.
 */
const GstStructure *
gst_query_get_structure (GstQuery * query)
{
  g_return_val_if_fail (GST_IS_QUERY (query), NULL);

  return GST_QUERY_STRUCTURE (query);
}

/**
 * gst_query_writable_structure:
 * @query: a #GstQuery
 *
 * Get the structure of a query. This method should be called with a writable
 * @query so that the returned structure is guaranteed to be writable.
 *
 * Returns: (transfer none): the #GstStructure of the query. The structure is
 *     still owned by the query and will therefore be freed when the query
 *     is unreffed.
 */
GstStructure *
gst_query_writable_structure (GstQuery * query)
{
  g_return_val_if_fail (GST_IS_QUERY (query), NULL);
  g_return_val_if_fail (gst_query_is_writable (query), NULL);

  return GST_QUERY_STRUCTURE (query);
}

/**
 * gst_query_new_seeking:
 * @format: the default #GstFormat for the new query
 *
 * Constructs a new query object for querying seeking properties of
 * the stream.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_seeking (GstFormat format)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_SEEKING),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (SEEKABLE), G_TYPE_BOOLEAN, FALSE,
      GST_QUARK (SEGMENT_START), G_TYPE_INT64, G_GINT64_CONSTANT (-1),
      GST_QUARK (SEGMENT_END), G_TYPE_INT64, G_GINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_SEEKING, structure);

  return query;
}

/**
 * gst_query_set_seeking:
 * @query: a #GstQuery
 * @format: the format to set for the @segment_start and @segment_end values
 * @seekable: the seekable flag to set
 * @segment_start: the segment_start to set
 * @segment_end: the segment_end to set
 *
 * Set the seeking query result fields in @query.
 */
void
gst_query_set_seeking (GstQuery * query, GstFormat format,
    gboolean seekable, gint64 segment_start, gint64 segment_end)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SEEKING);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (SEEKABLE), G_TYPE_BOOLEAN, seekable,
      GST_QUARK (SEGMENT_START), G_TYPE_INT64, segment_start,
      GST_QUARK (SEGMENT_END), G_TYPE_INT64, segment_end, NULL);
}

/**
 * gst_query_parse_seeking:
 * @query: a GST_QUERY_SEEKING type query #GstQuery
 * @format: (out) (allow-none): the format to set for the @segment_start
 *     and @segment_end values, or %NULL
 * @seekable: (out) (allow-none): the seekable flag to set, or %NULL
 * @segment_start: (out) (allow-none): the segment_start to set, or %NULL
 * @segment_end: (out) (allow-none): the segment_end to set, or %NULL
 *
 * Parse a seeking query, writing the format into @format, and
 * other results into the passed parameters, if the respective parameters
 * are non-%NULL
 */
void
gst_query_parse_seeking (GstQuery * query, GstFormat * format,
    gboolean * seekable, gint64 * segment_start, gint64 * segment_end)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SEEKING);

  structure = GST_QUERY_STRUCTURE (query);
  if (format)
    *format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (seekable)
    *seekable = g_value_get_boolean (gst_structure_id_get_value (structure,
            GST_QUARK (SEEKABLE)));
  if (segment_start)
    *segment_start = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (SEGMENT_START)));
  if (segment_end)
    *segment_end = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (SEGMENT_END)));
}

static GArray *
ensure_array (GstStructure * s, GQuark quark, gsize element_size,
    GDestroyNotify clear_func)
{
  GArray *array;
  const GValue *value;

  value = gst_structure_id_get_value (s, quark);
  if (value) {
    array = (GArray *) g_value_get_boxed (value);
  } else {
    GValue new_array_val = { 0, };

    array = g_array_new (FALSE, TRUE, element_size);
    if (clear_func)
      g_array_set_clear_func (array, clear_func);

    g_value_init (&new_array_val, G_TYPE_ARRAY);
    g_value_take_boxed (&new_array_val, array);

    gst_structure_id_take_value (s, quark, &new_array_val);
  }
  return array;
}

/**
 * gst_query_new_formats:
 *
 * Constructs a new query object for querying formats of
 * the stream.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_formats (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id_empty (GST_QUARK (QUERY_FORMATS));
  query = gst_query_new_custom (GST_QUERY_FORMATS, structure);

  return query;
}

static void
gst_query_list_add_format (GValue * list, GstFormat format)
{
  GValue item = { 0, };

  g_value_init (&item, GST_TYPE_FORMAT);
  g_value_set_enum (&item, format);
  gst_value_list_append_value (list, &item);
  g_value_unset (&item);
}

/**
 * gst_query_set_formats:
 * @query: a #GstQuery
 * @n_formats: the number of formats to set.
 * @...: A number of @GstFormats equal to @n_formats.
 *
 * Set the formats query result fields in @query. The number of formats passed
 * must be equal to @n_formats.
 */
void
gst_query_set_formats (GstQuery * query, gint n_formats, ...)
{
  va_list ap;
  GValue list = { 0, };
  gint i;
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_FORMATS);
  g_return_if_fail (gst_query_is_writable (query));

  g_value_init (&list, GST_TYPE_LIST);

  va_start (ap, n_formats);
  for (i = 0; i < n_formats; i++) {
    gst_query_list_add_format (&list, va_arg (ap, GstFormat));
  }
  va_end (ap);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_set_value (structure, "formats", &list);

  g_value_unset (&list);

}

/**
 * gst_query_set_formatsv:
 * @query: a #GstQuery
 * @n_formats: the number of formats to set.
 * @formats: (in) (array length=n_formats): an array containing @n_formats
 *     @GstFormat values.
 *
 * Set the formats query result fields in @query. The number of formats passed
 * in the @formats array must be equal to @n_formats.
 */
void
gst_query_set_formatsv (GstQuery * query, gint n_formats,
    const GstFormat * formats)
{
  GValue list = { 0, };
  gint i;
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_FORMATS);
  g_return_if_fail (gst_query_is_writable (query));

  g_value_init (&list, GST_TYPE_LIST);
  for (i = 0; i < n_formats; i++) {
    gst_query_list_add_format (&list, formats[i]);
  }
  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_set_value (structure, "formats", &list);

  g_value_unset (&list);
}

/**
 * gst_query_parse_n_formats:
 * @query: a #GstQuery
 * @n_formats: (out) (allow-none): the number of formats in this query.
 *
 * Parse the number of formats in the formats @query.
 */
void
gst_query_parse_n_formats (GstQuery * query, guint * n_formats)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_FORMATS);

  if (n_formats) {
    const GValue *list;

    structure = GST_QUERY_STRUCTURE (query);
    list = gst_structure_get_value (structure, "formats");
    if (list == NULL)
      *n_formats = 0;
    else
      *n_formats = gst_value_list_get_size (list);
  }
}

/**
 * gst_query_parse_nth_format:
 * @query: a #GstQuery
 * @nth: (out): the nth format to retrieve.
 * @format: (out) (allow-none): a pointer to store the nth format
 *
 * Parse the format query and retrieve the @nth format from it into
 * @format. If the list contains less elements than @nth, @format will be
 * set to GST_FORMAT_UNDEFINED.
 */
void
gst_query_parse_nth_format (GstQuery * query, guint nth, GstFormat * format)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_FORMATS);

  if (format) {
    const GValue *list;

    structure = GST_QUERY_STRUCTURE (query);
    list = gst_structure_get_value (structure, "formats");
    if (list == NULL) {
      *format = GST_FORMAT_UNDEFINED;
    } else {
      if (nth < gst_value_list_get_size (list)) {
        *format =
            (GstFormat) g_value_get_enum (gst_value_list_get_value (list, nth));
      } else
        *format = GST_FORMAT_UNDEFINED;
    }
  }
}

/**
 * gst_query_new_buffering:
 * @format: the default #GstFormat for the new query
 *
 * Constructs a new query object for querying the buffering status of
 * a stream.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_buffering (GstFormat format)
{
  GstQuery *query;
  GstStructure *structure;

  /* by default, we configure the answer as no buffering with a 100% buffering
   * progress */
  structure = gst_structure_new_id (GST_QUARK (QUERY_BUFFERING),
      GST_QUARK (BUSY), G_TYPE_BOOLEAN, FALSE,
      GST_QUARK (BUFFER_PERCENT), G_TYPE_INT, 100,
      GST_QUARK (BUFFERING_MODE), GST_TYPE_BUFFERING_MODE, GST_BUFFERING_STREAM,
      GST_QUARK (AVG_IN_RATE), G_TYPE_INT, -1,
      GST_QUARK (AVG_OUT_RATE), G_TYPE_INT, -1,
      GST_QUARK (BUFFERING_LEFT), G_TYPE_INT64, G_GINT64_CONSTANT (0),
      GST_QUARK (ESTIMATED_TOTAL), G_TYPE_INT64, G_GINT64_CONSTANT (-1),
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (START_VALUE), G_TYPE_INT64, G_GINT64_CONSTANT (-1),
      GST_QUARK (STOP_VALUE), G_TYPE_INT64, G_GINT64_CONSTANT (-1), NULL);

  query = gst_query_new_custom (GST_QUERY_BUFFERING, structure);

  return query;
}

/**
 * gst_query_set_buffering_percent:
 * @query: A valid #GstQuery of type GST_QUERY_BUFFERING.
 * @busy: if buffering is busy
 * @percent: a buffering percent
 *
 * Set the percentage of buffered data. This is a value between 0 and 100.
 * The @busy indicator is %TRUE when the buffering is in progress.
 */
void
gst_query_set_buffering_percent (GstQuery * query, gboolean busy, gint percent)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING);
  g_return_if_fail (gst_query_is_writable (query));
  g_return_if_fail (percent >= 0 && percent <= 100);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (BUSY), G_TYPE_BOOLEAN, busy,
      GST_QUARK (BUFFER_PERCENT), G_TYPE_INT, percent, NULL);
}

/**
 * gst_query_parse_buffering_percent:
 * @query: A valid #GstQuery of type GST_QUERY_BUFFERING.
 * @busy: (out) (allow-none): if buffering is busy, or %NULL
 * @percent: (out) (allow-none): a buffering percent, or %NULL
 *
 * Get the percentage of buffered data. This is a value between 0 and 100.
 * The @busy indicator is %TRUE when the buffering is in progress.
 */
void
gst_query_parse_buffering_percent (GstQuery * query, gboolean * busy,
    gint * percent)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING);

  structure = GST_QUERY_STRUCTURE (query);
  if (busy)
    *busy = g_value_get_boolean (gst_structure_id_get_value (structure,
            GST_QUARK (BUSY)));
  if (percent)
    *percent = g_value_get_int (gst_structure_id_get_value (structure,
            GST_QUARK (BUFFER_PERCENT)));
}

/**
 * gst_query_set_buffering_stats:
 * @query: A valid #GstQuery of type GST_QUERY_BUFFERING.
 * @mode: a buffering mode
 * @avg_in: the average input rate
 * @avg_out: the average output rate
 * @buffering_left: amount of buffering time left in milliseconds
 *
 * Configures the buffering stats values in @query.
 */
void
gst_query_set_buffering_stats (GstQuery * query, GstBufferingMode mode,
    gint avg_in, gint avg_out, gint64 buffering_left)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (BUFFERING_MODE), GST_TYPE_BUFFERING_MODE, mode,
      GST_QUARK (AVG_IN_RATE), G_TYPE_INT, avg_in,
      GST_QUARK (AVG_OUT_RATE), G_TYPE_INT, avg_out,
      GST_QUARK (BUFFERING_LEFT), G_TYPE_INT64, buffering_left, NULL);
}

/**
 * gst_query_parse_buffering_stats:
 * @query: A valid #GstQuery of type GST_QUERY_BUFFERING.
 * @mode: (out) (allow-none): a buffering mode, or %NULL
 * @avg_in: (out) (allow-none): the average input rate, or %NULL
 * @avg_out: (out) (allow-none): the average output rat, or %NULL
 * @buffering_left: (out) (allow-none): amount of buffering time left in
 *     milliseconds, or %NULL
 *
 * Extracts the buffering stats values from @query.
 */
void
gst_query_parse_buffering_stats (GstQuery * query,
    GstBufferingMode * mode, gint * avg_in, gint * avg_out,
    gint64 * buffering_left)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING);

  structure = GST_QUERY_STRUCTURE (query);
  if (mode)
    *mode = (GstBufferingMode)
        g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (BUFFERING_MODE)));
  if (avg_in)
    *avg_in = g_value_get_int (gst_structure_id_get_value (structure,
            GST_QUARK (AVG_IN_RATE)));
  if (avg_out)
    *avg_out = g_value_get_int (gst_structure_id_get_value (structure,
            GST_QUARK (AVG_OUT_RATE)));
  if (buffering_left)
    *buffering_left =
        g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (BUFFERING_LEFT)));
}

/**
 * gst_query_set_buffering_range:
 * @query: a #GstQuery
 * @format: the format to set for the @start and @stop values
 * @start: the start to set
 * @stop: the stop to set
 * @estimated_total: estimated total amount of download time remaining in
 *     milliseconds
 *
 * Set the available query result fields in @query.
 */
void
gst_query_set_buffering_range (GstQuery * query, GstFormat format,
    gint64 start, gint64 stop, gint64 estimated_total)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (FORMAT), GST_TYPE_FORMAT, format,
      GST_QUARK (START_VALUE), G_TYPE_INT64, start,
      GST_QUARK (STOP_VALUE), G_TYPE_INT64, stop,
      GST_QUARK (ESTIMATED_TOTAL), G_TYPE_INT64, estimated_total, NULL);
}

/**
 * gst_query_parse_buffering_range:
 * @query: a GST_QUERY_BUFFERING type query #GstQuery
 * @format: (out) (allow-none): the format to set for the @segment_start
 *     and @segment_end values, or %NULL
 * @start: (out) (allow-none): the start to set, or %NULL
 * @stop: (out) (allow-none): the stop to set, or %NULL
 * @estimated_total: (out) (allow-none): estimated total amount of download
 *     time remaining in milliseconds, or %NULL
 *
 * Parse an available query, writing the format into @format, and
 * other results into the passed parameters, if the respective parameters
 * are non-%NULL
 */
void
gst_query_parse_buffering_range (GstQuery * query, GstFormat * format,
    gint64 * start, gint64 * stop, gint64 * estimated_total)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING);

  structure = GST_QUERY_STRUCTURE (query);
  if (format)
    *format =
        (GstFormat) g_value_get_enum (gst_structure_id_get_value (structure,
            GST_QUARK (FORMAT)));
  if (start)
    *start = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (START_VALUE)));
  if (stop)
    *stop = g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (STOP_VALUE)));
  if (estimated_total)
    *estimated_total =
        g_value_get_int64 (gst_structure_id_get_value (structure,
            GST_QUARK (ESTIMATED_TOTAL)));
}

/* GstQueryBufferingRange: internal struct for GArray */
typedef struct
{
  gint64 start;
  gint64 stop;
} GstQueryBufferingRange;

/**
 * gst_query_add_buffering_range:
 * @query: a GST_QUERY_BUFFERING type query #GstQuery
 * @start: start position of the range
 * @stop: stop position of the range
 *
 * Set the buffering-ranges array field in @query. The current last
 * start position of the array should be inferior to @start.
 *
 * Returns: a #gboolean indicating if the range was added or not.
 */
gboolean
gst_query_add_buffering_range (GstQuery * query, gint64 start, gint64 stop)
{
  GstQueryBufferingRange range;
  GstStructure *structure;
  GArray *array;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING, FALSE);
  g_return_val_if_fail (gst_query_is_writable (query), FALSE);

  if (G_UNLIKELY (start >= stop))
    return FALSE;

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (BUFFERING_RANGES),
      sizeof (GstQueryBufferingRange), NULL);

  if (array->len > 1) {
    GstQueryBufferingRange *last;

    last = &g_array_index (array, GstQueryBufferingRange, array->len - 1);

    if (G_UNLIKELY (start <= last->start))
      return FALSE;
  }

  range.start = start;
  range.stop = stop;
  g_array_append_val (array, range);

  return TRUE;
}

/**
 * gst_query_get_n_buffering_ranges:
 * @query: a GST_QUERY_BUFFERING type query #GstQuery
 *
 * Retrieve the number of values currently stored in the
 * buffered-ranges array of the query's structure.
 *
 * Returns: the range array size as a #guint.
 */
guint
gst_query_get_n_buffering_ranges (GstQuery * query)
{
  GstStructure *structure;
  GArray *array;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING, 0);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (BUFFERING_RANGES),
      sizeof (GstQueryBufferingRange), NULL);

  return array->len;
}


/**
 * gst_query_parse_nth_buffering_range:
 * @query: a GST_QUERY_BUFFERING type query #GstQuery
 * @index: position in the buffered-ranges array to read
 * @start: (out) (allow-none): the start position to set, or %NULL
 * @stop: (out) (allow-none): the stop position to set, or %NULL
 *
 * Parse an available query and get the start and stop values stored
 * at the @index of the buffered ranges array.
 *
 * Returns: a #gboolean indicating if the parsing succeeded.
 */
gboolean
gst_query_parse_nth_buffering_range (GstQuery * query, guint index,
    gint64 * start, gint64 * stop)
{
  GstQueryBufferingRange *range;
  GstStructure *structure;
  GArray *array;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_BUFFERING, FALSE);

  structure = GST_QUERY_STRUCTURE (query);

  array = ensure_array (structure, GST_QUARK (BUFFERING_RANGES),
      sizeof (GstQueryBufferingRange), NULL);
  g_return_val_if_fail (index < array->len, FALSE);

  range = &g_array_index (array, GstQueryBufferingRange, index);

  if (start)
    *start = range->start;
  if (stop)
    *stop = range->stop;

  return TRUE;
}


/**
 * gst_query_new_uri:
 *
 * Constructs a new query URI query object. Use gst_query_unref()
 * when done with it. An URI query is used to query the current URI
 * that is used by the source or sink.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_uri (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_URI),
      GST_QUARK (URI), G_TYPE_STRING, NULL, NULL);

  query = gst_query_new_custom (GST_QUERY_URI, structure);

  return query;
}

/**
 * gst_query_set_uri:
 * @query: a #GstQuery with query type GST_QUERY_URI
 * @uri: the URI to set
 *
 * Answer a URI query by setting the requested URI.
 */
void
gst_query_set_uri (GstQuery * query, const gchar * uri)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_URI);
  g_return_if_fail (gst_query_is_writable (query));
  g_return_if_fail (gst_uri_is_valid (uri));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure, GST_QUARK (URI), G_TYPE_STRING, uri, NULL);
}

/**
 * gst_query_parse_uri:
 * @query: a #GstQuery
 * @uri: (out) (transfer full) (allow-none): the storage for the current URI
 *     (may be %NULL)
 *
 * Parse an URI query, writing the URI into @uri as a newly
 * allocated string, if the respective parameters are non-%NULL.
 * Free the string with g_free() after usage.
 */
void
gst_query_parse_uri (GstQuery * query, gchar ** uri)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_URI);

  structure = GST_QUERY_STRUCTURE (query);
  if (uri)
    *uri = g_value_dup_string (gst_structure_id_get_value (structure,
            GST_QUARK (URI)));
}

/**
 * gst_query_set_uri_redirection:
 * @query: a #GstQuery with query type GST_QUERY_URI
 * @uri: the URI to set
 *
 * Answer a URI query by setting the requested URI redirection.
 *
 * Since: 1.2
 */
void
gst_query_set_uri_redirection (GstQuery * query, const gchar * uri)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_URI);
  g_return_if_fail (gst_query_is_writable (query));
  g_return_if_fail (gst_uri_is_valid (uri));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure, GST_QUARK (URI_REDIRECTION),
      G_TYPE_STRING, uri, NULL);
}

/**
 * gst_query_parse_uri_redirection:
 * @query: a #GstQuery
 * @uri: (out) (transfer full) (allow-none): the storage for the redirect URI
 *     (may be %NULL)
 *
 * Parse an URI query, writing the URI into @uri as a newly
 * allocated string, if the respective parameters are non-%NULL.
 * Free the string with g_free() after usage.
 *
 * Since: 1.2
 */
void
gst_query_parse_uri_redirection (GstQuery * query, gchar ** uri)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_URI);

  structure = GST_QUERY_STRUCTURE (query);
  if (uri) {
    if (!gst_structure_id_get (structure, GST_QUARK (URI_REDIRECTION),
            G_TYPE_STRING, uri, NULL))
      *uri = NULL;
  }
}

/**
 * gst_query_set_uri_redirection_permanent:
 * @query: a #GstQuery with query type %GST_QUERY_URI
 * @permanent: whether the redirect is permanent or not
 *
 * Answer a URI query by setting the requested URI redirection
 * to permanent or not.
 *
 * Since: 1.4
 */
void
gst_query_set_uri_redirection_permanent (GstQuery * query, gboolean permanent)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_URI);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure, GST_QUARK (URI_REDIRECTION_PERMANENT),
      G_TYPE_BOOLEAN, permanent, NULL);
}

/**
 * gst_query_parse_uri_redirection_permanent:
 * @query: a #GstQuery
 * @permanent: (out) (allow-none): if the URI redirection is permanent
 *     (may be %NULL)
 *
 * Parse an URI query, and set @permanent to %TRUE if there is a redirection
 * and it should be considered permanent. If a redirection is permanent,
 * applications should update their internal storage of the URI, otherwise
 * they should make all future requests to the original URI.
 *
 * Since: 1.4
 */
void
gst_query_parse_uri_redirection_permanent (GstQuery * query,
    gboolean * permanent)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_URI);

  structure = GST_QUERY_STRUCTURE (query);
  if (permanent) {
    if (!gst_structure_id_get (structure, GST_QUARK (URI_REDIRECTION_PERMANENT),
            G_TYPE_BOOLEAN, permanent, NULL))
      *permanent = FALSE;
  }
}

/**
 * gst_query_new_allocation:
 * @caps: the negotiated caps
 * @need_pool: return a pool
 *
 * Constructs a new query object for querying the allocation properties.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_allocation (GstCaps * caps, gboolean need_pool)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_ALLOCATION),
      GST_QUARK (CAPS), GST_TYPE_CAPS, caps,
      GST_QUARK (NEED_POOL), G_TYPE_BOOLEAN, need_pool, NULL);

  query = gst_query_new_custom (GST_QUERY_ALLOCATION, structure);

  return query;
}

/**
 * gst_query_parse_allocation:
 * @query: a #GstQuery
 * @caps: (out) (transfer none) (allow-none): The #GstCaps
 * @need_pool: (out) (allow-none): Whether a #GstBufferPool is needed
 *
 * Parse an allocation query, writing the requested caps in @caps and
 * whether a pool is needed in @need_pool, if the respective parameters
 * are non-%NULL.
 */
void
gst_query_parse_allocation (GstQuery * query, GstCaps ** caps,
    gboolean * need_pool)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);

  structure = GST_QUERY_STRUCTURE (query);
  if (caps) {
    *caps = g_value_get_boxed (gst_structure_id_get_value (structure,
            GST_QUARK (CAPS)));
  }
  gst_structure_id_get (structure,
      GST_QUARK (NEED_POOL), G_TYPE_BOOLEAN, need_pool, NULL);
}

typedef struct
{
  GstBufferPool *pool;
  guint size;
  guint min_buffers;
  guint max_buffers;
} AllocationPool;

static void
allocation_pool_free (AllocationPool * ap)
{
  if (ap->pool)
    gst_object_unref (ap->pool);
}

/**
 * gst_query_add_allocation_pool:
 * @query: A valid #GstQuery of type GST_QUERY_ALLOCATION.
 * @pool: the #GstBufferPool
 * @size: the size
 * @min_buffers: the min buffers
 * @max_buffers: the max buffers
 *
 * Set the pool parameters in @query.
 */
void
gst_query_add_allocation_pool (GstQuery * query, GstBufferPool * pool,
    guint size, guint min_buffers, guint max_buffers)
{
  GArray *array;
  GstStructure *structure;
  AllocationPool ap;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);
  g_return_if_fail (gst_query_is_writable (query));
  g_return_if_fail (size != 0);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (POOL),
      sizeof (AllocationPool), (GDestroyNotify) allocation_pool_free);

  if ((ap.pool = pool))
    gst_object_ref (pool);
  ap.size = size;
  ap.min_buffers = min_buffers;
  ap.max_buffers = max_buffers;

  g_array_append_val (array, ap);
}


/**
 * gst_query_get_n_allocation_pools:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 *
 * Retrieve the number of values currently stored in the
 * pool array of the query's structure.
 *
 * Returns: the pool array size as a #guint.
 */
guint
gst_query_get_n_allocation_pools (GstQuery * query)
{
  GArray *array;
  GstStructure *structure;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION, 0);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (POOL),
      sizeof (AllocationPool), (GDestroyNotify) allocation_pool_free);

  return array->len;
}

/**
 * gst_query_parse_nth_allocation_pool:
 * @query: A valid #GstQuery of type GST_QUERY_ALLOCATION.
 * @index: index to parse
 * @pool: (out) (allow-none) (transfer full): the #GstBufferPool
 * @size: (out) (allow-none): the size
 * @min_buffers: (out) (allow-none): the min buffers
 * @max_buffers: (out) (allow-none): the max buffers
 *
 * Get the pool parameters in @query.
 *
 * Unref @pool with gst_object_unref() when it's not needed any more.
 */
void
gst_query_parse_nth_allocation_pool (GstQuery * query, guint index,
    GstBufferPool ** pool, guint * size, guint * min_buffers,
    guint * max_buffers)
{
  GArray *array;
  GstStructure *structure;
  AllocationPool *ap;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (POOL),
      sizeof (AllocationPool), (GDestroyNotify) allocation_pool_free);
  g_return_if_fail (index < array->len);

  ap = &g_array_index (array, AllocationPool, index);

  if (pool)
    if ((*pool = ap->pool))
      gst_object_ref (*pool);
  if (size)
    *size = ap->size;
  if (min_buffers)
    *min_buffers = ap->min_buffers;
  if (max_buffers)
    *max_buffers = ap->max_buffers;
}

/**
 * gst_query_set_nth_allocation_pool:
 * @index: index to modify
 * @query: A valid #GstQuery of type GST_QUERY_ALLOCATION.
 * @pool: the #GstBufferPool
 * @size: the size
 * @min_buffers: the min buffers
 * @max_buffers: the max buffers
 *
 * Set the pool parameters in @query.
 */
void
gst_query_set_nth_allocation_pool (GstQuery * query, guint index,
    GstBufferPool * pool, guint size, guint min_buffers, guint max_buffers)
{
  GArray *array;
  GstStructure *structure;
  AllocationPool *oldap, ap;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (POOL),
      sizeof (AllocationPool), (GDestroyNotify) allocation_pool_free);
  g_return_if_fail (index < array->len);

  oldap = &g_array_index (array, AllocationPool, index);
  allocation_pool_free (oldap);

  if ((ap.pool = pool))
    gst_object_ref (pool);
  ap.size = size;
  ap.min_buffers = min_buffers;
  ap.max_buffers = max_buffers;
  g_array_index (array, AllocationPool, index) = ap;
}

/**
 * gst_query_remove_nth_allocation_pool:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @index: position in the allocation pool array to remove
 *
 * Remove the allocation pool at @index of the allocation pool array.
 *
 * Since: 1.2
 */
void
gst_query_remove_nth_allocation_pool (GstQuery * query, guint index)
{
  GArray *array;
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (POOL), sizeof (AllocationPool),
      (GDestroyNotify) allocation_pool_free);
  g_return_if_fail (index < array->len);

  g_array_remove_index (array, index);
}

typedef struct
{
  GType api;
  GstStructure *params;
} AllocationMeta;

static void
allocation_meta_free (AllocationMeta * am)
{
  if (am->params)
    gst_structure_free (am->params);
}

/**
 * gst_query_add_allocation_meta:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @api: the metadata API
 * @params: (transfer none) (allow-none): API specific parameters
 *
 * Add @api with @params as one of the supported metadata API to @query.
 */
void
gst_query_add_allocation_meta (GstQuery * query, GType api,
    const GstStructure * params)
{
  GArray *array;
  GstStructure *structure;
  AllocationMeta am;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);
  g_return_if_fail (api != 0);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (META), sizeof (AllocationMeta),
      (GDestroyNotify) allocation_meta_free);

  am.api = api;
  am.params = (params ? gst_structure_copy (params) : NULL);

  g_array_append_val (array, am);
}

/**
 * gst_query_get_n_allocation_metas:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 *
 * Retrieve the number of values currently stored in the
 * meta API array of the query's structure.
 *
 * Returns: the metadata API array size as a #guint.
 */
guint
gst_query_get_n_allocation_metas (GstQuery * query)
{
  GArray *array;
  GstStructure *structure;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION, 0);

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (META), sizeof (AllocationMeta),
      (GDestroyNotify) allocation_meta_free);

  return array->len;
}

/**
 * gst_query_parse_nth_allocation_meta:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @index: position in the metadata API array to read
 * @params: (out) (transfer none) (allow-none): API specific flags
 *
 * Parse an available query and get the metadata API
 * at @index of the metadata API array.
 *
 * Returns: a #GType of the metadata API at @index.
 */
GType
gst_query_parse_nth_allocation_meta (GstQuery * query, guint index,
    const GstStructure ** params)
{
  GArray *array;
  GstStructure *structure;
  AllocationMeta *am;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION, 0);

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (META), sizeof (AllocationMeta),
      (GDestroyNotify) allocation_meta_free);

  g_return_val_if_fail (index < array->len, 0);

  am = &g_array_index (array, AllocationMeta, index);

  if (params)
    *params = am->params;

  return am->api;
}

/**
 * gst_query_remove_nth_allocation_meta:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @index: position in the metadata API array to remove
 *
 * Remove the metadata API at @index of the metadata API array.
 */
void
gst_query_remove_nth_allocation_meta (GstQuery * query, guint index)
{
  GArray *array;
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (META), sizeof (AllocationMeta),
      (GDestroyNotify) allocation_meta_free);
  g_return_if_fail (index < array->len);

  g_array_remove_index (array, index);
}

/**
 * gst_query_find_allocation_meta:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @api: the metadata API
 * @index: (out) (transfer none) (allow-none): the index
 *
 * Check if @query has metadata @api set. When this function returns %TRUE,
 * @index will contain the index where the requested API and the flags can be
 * found.
 *
 * Returns: %TRUE when @api is in the list of metadata.
 */
gboolean
gst_query_find_allocation_meta (GstQuery * query, GType api, guint * index)
{
  GArray *array;
  GstStructure *structure;
  guint i, len;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION, FALSE);
  g_return_val_if_fail (api != 0, FALSE);

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (META), sizeof (AllocationMeta),
      (GDestroyNotify) allocation_meta_free);

  len = array->len;
  for (i = 0; i < len; i++) {
    AllocationMeta *am = &g_array_index (array, AllocationMeta, i);
    if (am->api == api) {
      if (index)
        *index = i;
      return TRUE;
    }
  }
  return FALSE;
}

typedef struct
{
  GstAllocator *allocator;
  GstAllocationParams params;
} AllocationParam;

static void
allocation_param_free (AllocationParam * ap)
{
  if (ap->allocator)
    gst_object_unref (ap->allocator);
}

/**
 * gst_query_add_allocation_param:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @allocator: (transfer none) (allow-none): the memory allocator
 * @params: (transfer none) (allow-none): a #GstAllocationParams
 *
 * Add @allocator and its @params as a supported memory allocator.
 */
void
gst_query_add_allocation_param (GstQuery * query, GstAllocator * allocator,
    const GstAllocationParams * params)
{
  GArray *array;
  GstStructure *structure;
  AllocationParam ap;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);
  g_return_if_fail (gst_query_is_writable (query));
  g_return_if_fail (allocator != NULL || params != NULL);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (ALLOCATOR),
      sizeof (AllocationParam), (GDestroyNotify) allocation_param_free);

  if ((ap.allocator = allocator))
    gst_object_ref (allocator);
  if (params)
    ap.params = *params;
  else
    gst_allocation_params_init (&ap.params);

  g_array_append_val (array, ap);
}

/**
 * gst_query_get_n_allocation_params:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 *
 * Retrieve the number of values currently stored in the
 * allocator params array of the query's structure.
 *
 * If no memory allocator is specified, the downstream element can handle
 * the default memory allocator. The first memory allocator in the query
 * should be generic and allow mapping to system memory, all following
 * allocators should be ordered by preference with the preferred one first.
 *
 * Returns: the allocator array size as a #guint.
 */
guint
gst_query_get_n_allocation_params (GstQuery * query)
{
  GArray *array;
  GstStructure *structure;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION, 0);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (ALLOCATOR),
      sizeof (AllocationParam), (GDestroyNotify) allocation_param_free);

  return array->len;
}

/**
 * gst_query_parse_nth_allocation_param:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @index: position in the allocator array to read
 * @allocator: (out) (transfer full) (allow-none): variable to hold the result
 * @params: (out) (allow-none): parameters for the allocator
 *
 * Parse an available query and get the allocator and its params
 * at @index of the allocator array.
 */
void
gst_query_parse_nth_allocation_param (GstQuery * query, guint index,
    GstAllocator ** allocator, GstAllocationParams * params)
{
  GArray *array;
  GstStructure *structure;
  AllocationParam *ap;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (ALLOCATOR),
      sizeof (AllocationParam), (GDestroyNotify) allocation_param_free);
  g_return_if_fail (index < array->len);

  ap = &g_array_index (array, AllocationParam, index);

  if (allocator)
    if ((*allocator = ap->allocator))
      gst_object_ref (*allocator);
  if (params)
    *params = ap->params;
}

/**
 * gst_query_set_nth_allocation_param:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @index: position in the allocator array to set
 * @allocator: (transfer none) (allow-none): new allocator to set
 * @params: (transfer none) (allow-none): parameters for the allocator
 *
 * Parse an available query and get the allocator and its params
 * at @index of the allocator array.
 */
void
gst_query_set_nth_allocation_param (GstQuery * query, guint index,
    GstAllocator * allocator, const GstAllocationParams * params)
{
  GArray *array;
  GstStructure *structure;
  AllocationParam *old, ap;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);

  structure = GST_QUERY_STRUCTURE (query);
  array = ensure_array (structure, GST_QUARK (ALLOCATOR),
      sizeof (AllocationParam), (GDestroyNotify) allocation_param_free);
  g_return_if_fail (index < array->len);

  old = &g_array_index (array, AllocationParam, index);
  allocation_param_free (old);

  if ((ap.allocator = allocator))
    gst_object_ref (allocator);
  if (params)
    ap.params = *params;
  else
    gst_allocation_params_init (&ap.params);

  g_array_index (array, AllocationParam, index) = ap;
}

/**
 * gst_query_remove_nth_allocation_param:
 * @query: a GST_QUERY_ALLOCATION type query #GstQuery
 * @index: position in the allocation param array to remove
 *
 * Remove the allocation param at @index of the allocation param array.
 *
 * Since: 1.2
 */
void
gst_query_remove_nth_allocation_param (GstQuery * query, guint index)
{
  GArray *array;
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ALLOCATION);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (ALLOCATOR), sizeof (AllocationParam),
      (GDestroyNotify) allocation_param_free);
  g_return_if_fail (index < array->len);

  g_array_remove_index (array, index);
}

/**
 * gst_query_new_scheduling:
 *
 * Constructs a new query object for querying the scheduling properties.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_scheduling (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_SCHEDULING),
      GST_QUARK (FLAGS), GST_TYPE_SCHEDULING_FLAGS, 0,
      GST_QUARK (MINSIZE), G_TYPE_INT, 1,
      GST_QUARK (MAXSIZE), G_TYPE_INT, -1,
      GST_QUARK (ALIGN), G_TYPE_INT, 0, NULL);
  query = gst_query_new_custom (GST_QUERY_SCHEDULING, structure);

  return query;
}

/**
 * gst_query_set_scheduling:
 * @query: A valid #GstQuery of type GST_QUERY_SCHEDULING.
 * @flags: #GstSchedulingFlags
 * @minsize: the suggested minimum size of pull requests
 * @maxsize: the suggested maximum size of pull requests
 * @align: the suggested alignment of pull requests
 *
 * Set the scheduling properties.
 */
void
gst_query_set_scheduling (GstQuery * query, GstSchedulingFlags flags,
    gint minsize, gint maxsize, gint align)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (FLAGS), GST_TYPE_SCHEDULING_FLAGS, flags,
      GST_QUARK (MINSIZE), G_TYPE_INT, minsize,
      GST_QUARK (MAXSIZE), G_TYPE_INT, maxsize,
      GST_QUARK (ALIGN), G_TYPE_INT, align, NULL);
}

/**
 * gst_query_parse_scheduling:
 * @query: A valid #GstQuery of type GST_QUERY_SCHEDULING.
 * @flags: (out) (allow-none): #GstSchedulingFlags
 * @minsize: (out) (allow-none): the suggested minimum size of pull requests
 * @maxsize: (out) (allow-none): the suggested maximum size of pull requests:
 * @align: (out) (allow-none): the suggested alignment of pull requests
 *
 * Set the scheduling properties.
 */
void
gst_query_parse_scheduling (GstQuery * query, GstSchedulingFlags * flags,
    gint * minsize, gint * maxsize, gint * align)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_get (structure,
      GST_QUARK (FLAGS), GST_TYPE_SCHEDULING_FLAGS, flags,
      GST_QUARK (MINSIZE), G_TYPE_INT, minsize,
      GST_QUARK (MAXSIZE), G_TYPE_INT, maxsize,
      GST_QUARK (ALIGN), G_TYPE_INT, align, NULL);
}

/**
 * gst_query_add_scheduling_mode:
 * @query: a GST_QUERY_SCHEDULING type query #GstQuery
 * @mode: a #GstPadMode
 *
 * Add @mode as one of the supported scheduling modes to @query.
 */
void
gst_query_add_scheduling_mode (GstQuery * query, GstPadMode mode)
{
  GstStructure *structure;
  GArray *array;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (MODES), sizeof (GstPadMode), NULL);

  g_array_append_val (array, mode);
}

/**
 * gst_query_get_n_scheduling_modes:
 * @query: a GST_QUERY_SCHEDULING type query #GstQuery
 *
 * Retrieve the number of values currently stored in the
 * scheduling mode array of the query's structure.
 *
 * Returns: the scheduling mode array size as a #guint.
 */
guint
gst_query_get_n_scheduling_modes (GstQuery * query)
{
  GArray *array;
  GstStructure *structure;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING, 0);

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (MODES), sizeof (GstPadMode), NULL);

  return array->len;
}

/**
 * gst_query_parse_nth_scheduling_mode:
 * @query: a GST_QUERY_SCHEDULING type query #GstQuery
 * @index: position in the scheduling modes array to read
 *
 * Parse an available query and get the scheduling mode
 * at @index of the scheduling modes array.
 *
 * Returns: a #GstPadMode of the scheduling mode at @index.
 */
GstPadMode
gst_query_parse_nth_scheduling_mode (GstQuery * query, guint index)
{
  GstStructure *structure;
  GArray *array;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING,
      GST_PAD_MODE_NONE);

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (MODES), sizeof (GstPadMode), NULL);
  g_return_val_if_fail (index < array->len, GST_PAD_MODE_NONE);

  return g_array_index (array, GstPadMode, index);
}

/**
 * gst_query_has_scheduling_mode:
 * @query: a GST_QUERY_SCHEDULING type query #GstQuery
 * @mode: the scheduling mode
 *
 * Check if @query has scheduling mode set.
 *
 * <note>
 *   <para>
 *     When checking if upstream supports pull mode, it is usually not
 *     enough to just check for GST_PAD_MODE_PULL with this function, you
 *     also want to check whether the scheduling flags returned by
 *     gst_query_parse_scheduling() have the seeking flag set (meaning
 *     random access is supported, not only sequential pulls).
 *   </para>
 * </note>
 *
 * Returns: %TRUE when @mode is in the list of scheduling modes.
 */
gboolean
gst_query_has_scheduling_mode (GstQuery * query, GstPadMode mode)
{
  GstStructure *structure;
  GArray *array;
  guint i, len;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING, FALSE);

  structure = GST_QUERY_STRUCTURE (query);
  array =
      ensure_array (structure, GST_QUARK (MODES), sizeof (GstPadMode), NULL);

  len = array->len;
  for (i = 0; i < len; i++) {
    if (mode == g_array_index (array, GstPadMode, i))
      return TRUE;
  }
  return FALSE;
}

/**
 * gst_query_has_scheduling_mode_with_flags:
 * @query: a GST_QUERY_SCHEDULING type query #GstQuery
 * @mode: the scheduling mode
 * @flags: #GstSchedulingFlags
 *
 * Check if @query has scheduling mode set and @flags is set in
 * query scheduling flags.
 *
 * Returns: %TRUE when @mode is in the list of scheduling modes
 *    and @flags are compatible with query flags.
 */
gboolean
gst_query_has_scheduling_mode_with_flags (GstQuery * query, GstPadMode mode,
    GstSchedulingFlags flags)
{
  GstSchedulingFlags sched_flags;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_SCHEDULING, FALSE);

  gst_query_parse_scheduling (query, &sched_flags, NULL, NULL, NULL);

  return ((flags & sched_flags) == flags) &&
      gst_query_has_scheduling_mode (query, mode);
}

/**
 * gst_query_new_accept_caps:
 * @caps: a fixed #GstCaps
 *
 * Constructs a new query object for querying if @caps are accepted.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_accept_caps (GstCaps * caps)
{
  GstQuery *query;
  GstStructure *structure;

  g_return_val_if_fail (gst_caps_is_fixed (caps), NULL);

  structure = gst_structure_new_id (GST_QUARK (QUERY_ACCEPT_CAPS),
      GST_QUARK (CAPS), GST_TYPE_CAPS, caps,
      GST_QUARK (RESULT), G_TYPE_BOOLEAN, FALSE, NULL);
  query = gst_query_new_custom (GST_QUERY_ACCEPT_CAPS, structure);

  return query;
}

/**
 * gst_query_parse_accept_caps:
 * @query: The query to parse
 * @caps: (out) (transfer none): A pointer to the caps
 *
 * Get the caps from @query. The caps remains valid as long as @query remains
 * valid.
 */
void
gst_query_parse_accept_caps (GstQuery * query, GstCaps ** caps)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ACCEPT_CAPS);
  g_return_if_fail (caps != NULL);

  structure = GST_QUERY_STRUCTURE (query);
  *caps = g_value_get_boxed (gst_structure_id_get_value (structure,
          GST_QUARK (CAPS)));
}

/**
 * gst_query_set_accept_caps_result:
 * @query: a GST_QUERY_ACCEPT_CAPS type query #GstQuery
 * @result: the result to set
 *
 * Set @result as the result for the @query.
 */
void
gst_query_set_accept_caps_result (GstQuery * query, gboolean result)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ACCEPT_CAPS);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure,
      GST_QUARK (RESULT), G_TYPE_BOOLEAN, result, NULL);
}

/**
 * gst_query_parse_accept_caps_result:
 * @query: a GST_QUERY_ACCEPT_CAPS type query #GstQuery
 * @result: location for the result
 *
 * Parse the result from @query and store in @result.
 */
void
gst_query_parse_accept_caps_result (GstQuery * query, gboolean * result)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_ACCEPT_CAPS);

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_get (structure,
      GST_QUARK (RESULT), G_TYPE_BOOLEAN, result, NULL);
}

/**
 * gst_query_new_caps:
 * @filter: a filter
 *
 * Constructs a new query object for querying the caps.
 *
 * The CAPS query should return the allowable caps for a pad in the context
 * of the element's state, its link to other elements, and the devices or files
 * it has opened. These caps must be a subset of the pad template caps. In the
 * NULL state with no links, the CAPS query should ideally return the same caps
 * as the pad template. In rare circumstances, an object property can affect
 * the caps returned by the CAPS query, but this is discouraged.
 *
 * For most filters, the caps returned by CAPS query is directly affected by the
 * allowed caps on other pads. For demuxers and decoders, the caps returned by
 * the srcpad's getcaps function is directly related to the stream data. Again,
 * the CAPS query should return the most specific caps it reasonably can, since this
 * helps with autoplugging.
 *
 * The @filter is used to restrict the result caps, only the caps matching
 * @filter should be returned from the CAPS query. Specifying a filter might
 * greatly reduce the amount of processing an element needs to do.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_caps (GstCaps * filter)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id (GST_QUARK (QUERY_CAPS),
      GST_QUARK (FILTER), GST_TYPE_CAPS, filter,
      GST_QUARK (CAPS), GST_TYPE_CAPS, NULL, NULL);
  query = gst_query_new_custom (GST_QUERY_CAPS, structure);

  return query;
}

/**
 * gst_query_parse_caps:
 * @query: The query to parse
 * @filter: (out) (transfer none): A pointer to the caps filter
 *
 * Get the filter from the caps @query. The caps remains valid as long as
 * @query remains valid.
 */
void
gst_query_parse_caps (GstQuery * query, GstCaps ** filter)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CAPS);
  g_return_if_fail (filter != NULL);

  structure = GST_QUERY_STRUCTURE (query);
  *filter = g_value_get_boxed (gst_structure_id_get_value (structure,
          GST_QUARK (FILTER)));
}

/**
 * gst_query_set_caps_result:
 * @query: The query to use
 * @caps: (in): A pointer to the caps
 *
 * Set the @caps result in @query.
 */
void
gst_query_set_caps_result (GstQuery * query, GstCaps * caps)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CAPS);
  g_return_if_fail (gst_query_is_writable (query));

  structure = GST_QUERY_STRUCTURE (query);
  gst_structure_id_set (structure, GST_QUARK (CAPS), GST_TYPE_CAPS, caps, NULL);
}

/**
 * gst_query_parse_caps_result:
 * @query: The query to parse
 * @caps: (out) (transfer none): A pointer to the caps
 *
 * Get the caps result from @query. The caps remains valid as long as
 * @query remains valid.
 */
void
gst_query_parse_caps_result (GstQuery * query, GstCaps ** caps)
{
  GstStructure *structure;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CAPS);
  g_return_if_fail (caps != NULL);

  structure = GST_QUERY_STRUCTURE (query);
  *caps = g_value_get_boxed (gst_structure_id_get_value (structure,
          GST_QUARK (CAPS)));
}

#if 0
void
gst_query_intersect_caps_result (GstQuery * query, GstCaps * filter,
    GstCapsIntersectMode mode)
{
  GstCaps *res, *caps = NULL;

  gst_query_parse_caps_result (query, &caps);
  res = gst_caps_intersect_full (filter, caps, GST_CAPS_INTERSECT_FIRST);
  gst_query_set_caps_result (query, res);
  gst_caps_unref (res);
}
#endif

/**
 * gst_query_new_drain:
 *
 * Constructs a new query object for querying the drain state.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 */
GstQuery *
gst_query_new_drain (void)
{
  GstQuery *query;
  GstStructure *structure;

  structure = gst_structure_new_id_empty (GST_QUARK (QUERY_DRAIN));
  query = gst_query_new_custom (GST_QUERY_DRAIN, structure);

  return query;
}

/**
 * gst_query_new_context:
 * @context_type: Context type to query
 *
 * Constructs a new query object for querying the pipeline-local context.
 *
 * Free-function: gst_query_unref
 *
 * Returns: (transfer full): a new #GstQuery
 *
 * Since: 1.2
 */
GstQuery *
gst_query_new_context (const gchar * context_type)
{
  GstQuery *query;
  GstStructure *structure;

  g_return_val_if_fail (context_type != NULL, NULL);

  structure = gst_structure_new_id (GST_QUARK (QUERY_CONTEXT),
      GST_QUARK (CONTEXT_TYPE), G_TYPE_STRING, context_type, NULL);
  query = gst_query_new_custom (GST_QUERY_CONTEXT, structure);

  return query;
}

/**
 * gst_query_set_context:
 * @query: a #GstQuery with query type GST_QUERY_CONTEXT
 * @context: the requested #GstContext
 *
 * Answer a context query by setting the requested context.
 *
 * Since: 1.2
 */
void
gst_query_set_context (GstQuery * query, GstContext * context)
{
  GstStructure *s;
  const gchar *context_type;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CONTEXT);

  gst_query_parse_context_type (query, &context_type);
  g_return_if_fail (strcmp (gst_context_get_context_type (context),
          context_type) == 0);

  s = GST_QUERY_STRUCTURE (query);

  gst_structure_id_set (s,
      GST_QUARK (CONTEXT), GST_TYPE_CONTEXT, context, NULL);
}

/**
 * gst_query_parse_context:
 * @query: The query to parse
 * @context: (out) (transfer none): A pointer to store the #GstContext
 *
 * Get the context from the context @query. The context remains valid as long as
 * @query remains valid.
 *
 * Since: 1.2
 */
void
gst_query_parse_context (GstQuery * query, GstContext ** context)
{
  GstStructure *structure;
  const GValue *v;

  g_return_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CONTEXT);
  g_return_if_fail (context != NULL);

  structure = GST_QUERY_STRUCTURE (query);
  v = gst_structure_id_get_value (structure, GST_QUARK (CONTEXT));
  if (v)
    *context = g_value_get_boxed (v);
  else
    *context = NULL;
}

/**
 * gst_query_parse_context_type:
 * @query: a GST_QUERY_CONTEXT type query
 * @context_type: (out) (transfer none) (allow-none): the context type, or %NULL
 *
 * Parse a context type from an existing GST_QUERY_CONTEXT query.
 *
 * Returns: a #gboolean indicating if the parsing succeeded.
 *
 * Since: 1.2
 */
gboolean
gst_query_parse_context_type (GstQuery * query, const gchar ** context_type)
{
  GstStructure *structure;
  const GValue *value;

  g_return_val_if_fail (GST_QUERY_TYPE (query) == GST_QUERY_CONTEXT, FALSE);

  structure = GST_QUERY_STRUCTURE (query);

  if (context_type) {
    value = gst_structure_id_get_value (structure, GST_QUARK (CONTEXT_TYPE));
    *context_type = g_value_get_string (value);
  }

  return TRUE;
}
