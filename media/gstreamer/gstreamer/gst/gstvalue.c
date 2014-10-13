/* GStreamer
 * Copyright (C) <2003> David A. Schleef <ds@schleef.org>
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
 * SECTION:gstvalue
 * @short_description: GValue implementations specific
 * to GStreamer
 *
 * GValue implementations specific to GStreamer.
 *
 * Note that operations on the same #GValue from multiple threads may lead to
 * undefined behaviour.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "gst_private.h"
#include "glib-compat-private.h"
#include <gst/gst.h>
#include <gobject/gvaluecollector.h>
#include "gstutils.h"

/* GstValueUnionFunc:
 * @dest: a #GValue for the result
 * @value1: a #GValue operand
 * @value2: a #GValue operand
 *
 * Used by gst_value_union() to perform unification for a specific #GValue
 * type. Register a new implementation with gst_value_register_union_func().
 *
 * Returns: %TRUE if a union was successful
 */
typedef gboolean (*GstValueUnionFunc) (GValue * dest,
    const GValue * value1, const GValue * value2);

/* GstValueIntersectFunc:
 * @dest: (out caller-allocates): a #GValue for the result
 * @value1: a #GValue operand
 * @value2: a #GValue operand
 *
 * Used by gst_value_intersect() to perform intersection for a specific #GValue
 * type. If the intersection is non-empty, the result is
 * placed in @dest and %TRUE is returned.  If the intersection is
 * empty, @dest is unmodified and %FALSE is returned.
 * Register a new implementation with gst_value_register_intersect_func().
 *
 * Returns: %TRUE if the values can intersect
 */
typedef gboolean (*GstValueIntersectFunc) (GValue * dest,
    const GValue * value1, const GValue * value2);

/* GstValueSubtractFunc:
 * @dest: (out caller-allocates): a #GValue for the result
 * @minuend: a #GValue operand
 * @subtrahend: a #GValue operand
 *
 * Used by gst_value_subtract() to perform subtraction for a specific #GValue
 * type. Register a new implementation with gst_value_register_subtract_func().
 *
 * Returns: %TRUE if the subtraction is not empty
 */
typedef gboolean (*GstValueSubtractFunc) (GValue * dest,
    const GValue * minuend, const GValue * subtrahend);

static void gst_value_register_union_func (GType type1,
    GType type2, GstValueUnionFunc func);
static void gst_value_register_intersect_func (GType type1,
    GType type2, GstValueIntersectFunc func);
static void gst_value_register_subtract_func (GType minuend_type,
    GType subtrahend_type, GstValueSubtractFunc func);

typedef struct _GstValueUnionInfo GstValueUnionInfo;
struct _GstValueUnionInfo
{
  GType type1;
  GType type2;
  GstValueUnionFunc func;
};

typedef struct _GstValueIntersectInfo GstValueIntersectInfo;
struct _GstValueIntersectInfo
{
  GType type1;
  GType type2;
  GstValueIntersectFunc func;
};

typedef struct _GstValueSubtractInfo GstValueSubtractInfo;
struct _GstValueSubtractInfo
{
  GType minuend;
  GType subtrahend;
  GstValueSubtractFunc func;
};

#define FUNDAMENTAL_TYPE_ID_MAX \
    (G_TYPE_FUNDAMENTAL_MAX >> G_TYPE_FUNDAMENTAL_SHIFT)
#define FUNDAMENTAL_TYPE_ID(type) \
    ((type) >> G_TYPE_FUNDAMENTAL_SHIFT)

#define VALUE_LIST_ARRAY(v) ((GArray *) (v)->data[0].v_pointer)
#define VALUE_LIST_SIZE(v) (VALUE_LIST_ARRAY(v)->len)
#define VALUE_LIST_GET_VALUE(v, index) ((const GValue *) &g_array_index (VALUE_LIST_ARRAY(v), GValue, (index)))

static GArray *gst_value_table;
static GHashTable *gst_value_hash;
static GstValueTable *gst_value_tables_fundamental[FUNDAMENTAL_TYPE_ID_MAX + 1];
static GArray *gst_value_union_funcs;
static GArray *gst_value_intersect_funcs;
static GArray *gst_value_subtract_funcs;

/* Forward declarations */
static gchar *gst_value_serialize_fraction (const GValue * value);

static GstValueCompareFunc gst_value_get_compare_func (const GValue * value1);
static gint gst_value_compare_with_func (const GValue * value1,
    const GValue * value2, GstValueCompareFunc compare);

static gchar *gst_string_wrap (const gchar * s);
static gchar *gst_string_take_and_wrap (gchar * s);
static gchar *gst_string_unwrap (const gchar * s);

static void gst_value_move (GValue * dest, GValue * src);
static void _gst_value_list_append_and_take_value (GValue * value,
    GValue * append_value);
static void _gst_value_array_append_and_take_value (GValue * value,
    GValue * append_value);

static inline GstValueTable *
gst_value_hash_lookup_type (GType type)
{
  if (G_LIKELY (G_TYPE_IS_FUNDAMENTAL (type)))
    return gst_value_tables_fundamental[FUNDAMENTAL_TYPE_ID (type)];
  else
    return g_hash_table_lookup (gst_value_hash, (gpointer) type);
}

static void
gst_value_hash_add_type (GType type, const GstValueTable * table)
{
  if (G_TYPE_IS_FUNDAMENTAL (type))
    gst_value_tables_fundamental[FUNDAMENTAL_TYPE_ID (type)] = (gpointer) table;

  g_hash_table_insert (gst_value_hash, (gpointer) type, (gpointer) table);
}

/********
 * list *
 ********/

/* two helper functions to serialize/stringify any type of list
 * regular lists are done with { }, arrays with < >
 */
static gchar *
gst_value_serialize_any_list (const GValue * value, const gchar * begin,
    const gchar * end)
{
  guint i;
  GArray *array = value->data[0].v_pointer;
  GString *s;
  GValue *v;
  gchar *s_val;
  guint alen = array->len;

  /* estimate minimum string length to minimise re-allocs in GString */
  s = g_string_sized_new (2 + (6 * alen) + 2);
  g_string_append (s, begin);
  for (i = 0; i < alen; i++) {
    v = &g_array_index (array, GValue, i);
    s_val = gst_value_serialize (v);
    if (s_val != NULL) {
      g_string_append (s, s_val);
      g_free (s_val);
      if (i < alen - 1) {
        g_string_append_len (s, ", ", 2);
      }
    } else {
      GST_WARNING ("Could not serialize list/array value of type '%s'",
          G_VALUE_TYPE_NAME (v));
    }
  }
  g_string_append (s, end);
  return g_string_free (s, FALSE);
}

static void
gst_value_transform_any_list_string (const GValue * src_value,
    GValue * dest_value, const gchar * begin, const gchar * end)
{
  GValue *list_value;
  GArray *array;
  GString *s;
  guint i;
  gchar *list_s;
  guint alen;

  array = src_value->data[0].v_pointer;
  alen = array->len;

  /* estimate minimum string length to minimise re-allocs in GString */
  s = g_string_sized_new (2 + (10 * alen) + 2);
  g_string_append (s, begin);
  for (i = 0; i < alen; i++) {
    list_value = &g_array_index (array, GValue, i);

    if (i != 0) {
      g_string_append_len (s, ", ", 2);
    }
    list_s = g_strdup_value_contents (list_value);
    g_string_append (s, list_s);
    g_free (list_s);
  }
  g_string_append (s, end);

  dest_value->data[0].v_pointer = g_string_free (s, FALSE);
}

/*
 * helper function to see if a type is fixed. Is used internally here and
 * there. Do not export, since it doesn't work for types where the content
 * decides the fixedness (e.g. GST_TYPE_ARRAY).
 */
static gboolean
gst_type_is_fixed (GType type)
{
  /* the basic int, string, double types */
  if (type <= G_TYPE_MAKE_FUNDAMENTAL (G_TYPE_RESERVED_GLIB_LAST)) {
    return TRUE;
  }
  /* our fundamental types that are certainly not fixed */
  if (type == GST_TYPE_INT_RANGE || type == GST_TYPE_DOUBLE_RANGE ||
      type == GST_TYPE_INT64_RANGE ||
      type == GST_TYPE_LIST || type == GST_TYPE_FRACTION_RANGE) {
    return FALSE;
  }
  /* other (boxed) types that are fixed */
  if (type == GST_TYPE_BUFFER) {
    return TRUE;
  }
  /* heavy checks */
  if (G_TYPE_IS_FUNDAMENTAL (type) || G_TYPE_FUNDAMENTAL (type) <=
      G_TYPE_MAKE_FUNDAMENTAL (G_TYPE_RESERVED_GLIB_LAST)) {
    return TRUE;
  }

  return FALSE;
}

/* GValue functions usable for both regular lists and arrays */
static void
gst_value_init_list_or_array (GValue * value)
{
  value->data[0].v_pointer = g_array_new (FALSE, TRUE, sizeof (GValue));
}

static GArray *
copy_garray_of_gstvalue (const GArray * src)
{
  GArray *dest;
  guint i, len;

  len = src->len;
  dest = g_array_sized_new (FALSE, TRUE, sizeof (GValue), len);
  g_array_set_size (dest, len);
  for (i = 0; i < len; i++) {
    gst_value_init_and_copy (&g_array_index (dest, GValue, i),
        &g_array_index (src, GValue, i));
  }

  return dest;
}

static void
gst_value_copy_list_or_array (const GValue * src_value, GValue * dest_value)
{
  dest_value->data[0].v_pointer =
      copy_garray_of_gstvalue ((GArray *) src_value->data[0].v_pointer);
}

static void
gst_value_free_list_or_array (GValue * value)
{
  guint i, len;
  GArray *src = (GArray *) value->data[0].v_pointer;
  len = src->len;

  if ((value->data[1].v_uint & G_VALUE_NOCOPY_CONTENTS) == 0) {
    for (i = 0; i < len; i++) {
      g_value_unset (&g_array_index (src, GValue, i));
    }
    g_array_free (src, TRUE);
  }
}

static gpointer
gst_value_list_or_array_peek_pointer (const GValue * value)
{
  return value->data[0].v_pointer;
}

static gchar *
gst_value_collect_list_or_array (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
    value->data[0].v_pointer = collect_values[0].v_pointer;
    value->data[1].v_uint = G_VALUE_NOCOPY_CONTENTS;
  } else {
    value->data[0].v_pointer =
        copy_garray_of_gstvalue ((GArray *) collect_values[0].v_pointer);
  }
  return NULL;
}

static gchar *
gst_value_lcopy_list_or_array (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  GArray **dest = collect_values[0].v_pointer;

  if (!dest)
    return g_strdup_printf ("value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));
  if (!value->data[0].v_pointer)
    return g_strdup_printf ("invalid value given for `%s'",
        G_VALUE_TYPE_NAME (value));
  if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
    *dest = (GArray *) value->data[0].v_pointer;
  } else {
    *dest = copy_garray_of_gstvalue ((GArray *) value->data[0].v_pointer);
  }
  return NULL;
}

static gboolean
gst_value_list_or_array_get_basic_type (const GValue * value, GType * type)
{
  if (G_UNLIKELY (value == NULL))
    return FALSE;

  if (GST_VALUE_HOLDS_LIST (value)) {
    if (VALUE_LIST_SIZE (value) == 0)
      return FALSE;
    return gst_value_list_or_array_get_basic_type (VALUE_LIST_GET_VALUE (value,
            0), type);
  }
  if (GST_VALUE_HOLDS_ARRAY (value)) {
    const GArray *array = (const GArray *) value->data[0].v_pointer;
    if (array->len == 0)
      return FALSE;
    return gst_value_list_or_array_get_basic_type (&g_array_index (array,
            GValue, 0), type);
  }

  *type = G_VALUE_TYPE (value);

  return TRUE;
}

#define IS_RANGE_COMPAT(type1,type2,t1,t2) \
  (((t1) == (type1) && (t2) == (type2)) || ((t2) == (type1) && (t1) == (type2)))

static gboolean
gst_value_list_or_array_are_compatible (const GValue * value1,
    const GValue * value2)
{
  GType basic_type1, basic_type2;

  /* empty or same type is OK */
  if (!gst_value_list_or_array_get_basic_type (value1, &basic_type1) ||
      !gst_value_list_or_array_get_basic_type (value2, &basic_type2) ||
      basic_type1 == basic_type2)
    return TRUE;

  /* ranges are distinct types for each bound type... */
  if (IS_RANGE_COMPAT (G_TYPE_INT, GST_TYPE_INT_RANGE, basic_type1,
          basic_type2))
    return TRUE;
  if (IS_RANGE_COMPAT (G_TYPE_INT64, GST_TYPE_INT64_RANGE, basic_type1,
          basic_type2))
    return TRUE;
  if (IS_RANGE_COMPAT (G_TYPE_DOUBLE, GST_TYPE_DOUBLE_RANGE, basic_type1,
          basic_type2))
    return TRUE;
  if (IS_RANGE_COMPAT (GST_TYPE_FRACTION, GST_TYPE_FRACTION_RANGE, basic_type1,
          basic_type2))
    return TRUE;

  return FALSE;
}

static inline void
_gst_value_list_append_and_take_value (GValue * value, GValue * append_value)
{
  g_array_append_vals ((GArray *) value->data[0].v_pointer, append_value, 1);
  memset (append_value, 0, sizeof (GValue));
}

/**
 * gst_value_list_append_and_take_value:
 * @value: a #GValue of type #GST_TYPE_LIST
 * @append_value: (transfer full): the value to append
 *
 * Appends @append_value to the GstValueList in @value.
 *
 * Since: 1.2
 */
void
gst_value_list_append_and_take_value (GValue * value, GValue * append_value)
{
  g_return_if_fail (GST_VALUE_HOLDS_LIST (value));
  g_return_if_fail (G_IS_VALUE (append_value));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value,
          append_value));

  _gst_value_list_append_and_take_value (value, append_value);
}

/**
 * gst_value_list_append_value:
 * @value: a #GValue of type #GST_TYPE_LIST
 * @append_value: (transfer none): the value to append
 *
 * Appends @append_value to the GstValueList in @value.
 */
void
gst_value_list_append_value (GValue * value, const GValue * append_value)
{
  GValue val = { 0, };

  g_return_if_fail (GST_VALUE_HOLDS_LIST (value));
  g_return_if_fail (G_IS_VALUE (append_value));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value,
          append_value));

  gst_value_init_and_copy (&val, append_value);
  g_array_append_vals ((GArray *) value->data[0].v_pointer, &val, 1);
}

/**
 * gst_value_list_prepend_value:
 * @value: a #GValue of type #GST_TYPE_LIST
 * @prepend_value: the value to prepend
 *
 * Prepends @prepend_value to the GstValueList in @value.
 */
void
gst_value_list_prepend_value (GValue * value, const GValue * prepend_value)
{
  GValue val = { 0, };

  g_return_if_fail (GST_VALUE_HOLDS_LIST (value));
  g_return_if_fail (G_IS_VALUE (prepend_value));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value,
          prepend_value));

  gst_value_init_and_copy (&val, prepend_value);
  g_array_prepend_vals ((GArray *) value->data[0].v_pointer, &val, 1);
}

/**
 * gst_value_list_concat:
 * @dest: (out caller-allocates): an uninitialized #GValue to take the result
 * @value1: a #GValue
 * @value2: a #GValue
 *
 * Concatenates copies of @value1 and @value2 into a list.  Values that are not
 * of type #GST_TYPE_LIST are treated as if they were lists of length 1.
 * @dest will be initialized to the type #GST_TYPE_LIST.
 */
void
gst_value_list_concat (GValue * dest, const GValue * value1,
    const GValue * value2)
{
  guint i, value1_length, value2_length;
  GArray *array;

  g_return_if_fail (dest != NULL);
  g_return_if_fail (G_VALUE_TYPE (dest) == 0);
  g_return_if_fail (G_IS_VALUE (value1));
  g_return_if_fail (G_IS_VALUE (value2));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value1, value2));

  value1_length =
      (GST_VALUE_HOLDS_LIST (value1) ? VALUE_LIST_SIZE (value1) : 1);
  value2_length =
      (GST_VALUE_HOLDS_LIST (value2) ? VALUE_LIST_SIZE (value2) : 1);
  g_value_init (dest, GST_TYPE_LIST);
  array = (GArray *) dest->data[0].v_pointer;
  g_array_set_size (array, value1_length + value2_length);

  if (GST_VALUE_HOLDS_LIST (value1)) {
    for (i = 0; i < value1_length; i++) {
      gst_value_init_and_copy (&g_array_index (array, GValue, i),
          VALUE_LIST_GET_VALUE (value1, i));
    }
  } else {
    gst_value_init_and_copy (&g_array_index (array, GValue, 0), value1);
  }

  if (GST_VALUE_HOLDS_LIST (value2)) {
    for (i = 0; i < value2_length; i++) {
      gst_value_init_and_copy (&g_array_index (array, GValue,
              i + value1_length), VALUE_LIST_GET_VALUE (value2, i));
    }
  } else {
    gst_value_init_and_copy (&g_array_index (array, GValue, value1_length),
        value2);
  }
}

/* same as gst_value_list_concat() but takes ownership of GValues */
static void
gst_value_list_concat_and_take_values (GValue * dest, GValue * val1,
    GValue * val2)
{
  guint i, val1_length, val2_length;
  gboolean val1_is_list;
  gboolean val2_is_list;
  GArray *array;

  g_assert (dest != NULL);
  g_assert (G_VALUE_TYPE (dest) == 0);
  g_assert (G_IS_VALUE (val1));
  g_assert (G_IS_VALUE (val2));
  g_assert (gst_value_list_or_array_are_compatible (val1, val2));

  val1_is_list = GST_VALUE_HOLDS_LIST (val1);
  val1_length = (val1_is_list ? VALUE_LIST_SIZE (val1) : 1);

  val2_is_list = GST_VALUE_HOLDS_LIST (val2);
  val2_length = (val2_is_list ? VALUE_LIST_SIZE (val2) : 1);

  g_value_init (dest, GST_TYPE_LIST);
  array = (GArray *) dest->data[0].v_pointer;
  g_array_set_size (array, val1_length + val2_length);

  if (val1_is_list) {
    for (i = 0; i < val1_length; i++) {
      g_array_index (array, GValue, i) = *VALUE_LIST_GET_VALUE (val1, i);
    }
    g_array_set_size (VALUE_LIST_ARRAY (val1), 0);
    g_value_unset (val1);
  } else {
    g_array_index (array, GValue, 0) = *val1;
    G_VALUE_TYPE (val1) = G_TYPE_INVALID;
  }

  if (val2_is_list) {
    for (i = 0; i < val2_length; i++) {
      const GValue *v2 = VALUE_LIST_GET_VALUE (val2, i);
      g_array_index (array, GValue, i + val1_length) = *v2;
    }
    g_array_set_size (VALUE_LIST_ARRAY (val2), 0);
    g_value_unset (val2);
  } else {
    g_array_index (array, GValue, val1_length) = *val2;
    G_VALUE_TYPE (val2) = G_TYPE_INVALID;
  }
}

/**
 * gst_value_list_merge:
 * @dest: (out caller-allocates): an uninitialized #GValue to take the result
 * @value1: a #GValue
 * @value2: a #GValue
 *
 * Merges copies of @value1 and @value2.  Values that are not
 * of type #GST_TYPE_LIST are treated as if they were lists of length 1.
 *
 * The result will be put into @dest and will either be a list that will not
 * contain any duplicates, or a non-list type (if @value1 and @value2
 * were equal).
 */
void
gst_value_list_merge (GValue * dest, const GValue * value1,
    const GValue * value2)
{
  guint i, j, k, value1_length, value2_length, skipped;
  const GValue *src;
  gboolean skip;
  GArray *array;

  g_return_if_fail (dest != NULL);
  g_return_if_fail (G_VALUE_TYPE (dest) == 0);
  g_return_if_fail (G_IS_VALUE (value1));
  g_return_if_fail (G_IS_VALUE (value2));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value1, value2));

  value1_length =
      (GST_VALUE_HOLDS_LIST (value1) ? VALUE_LIST_SIZE (value1) : 1);
  value2_length =
      (GST_VALUE_HOLDS_LIST (value2) ? VALUE_LIST_SIZE (value2) : 1);
  g_value_init (dest, GST_TYPE_LIST);
  array = (GArray *) dest->data[0].v_pointer;
  g_array_set_size (array, value1_length + value2_length);

  if (GST_VALUE_HOLDS_LIST (value1)) {
    for (i = 0; i < value1_length; i++) {
      gst_value_init_and_copy (&g_array_index (array, GValue, i),
          VALUE_LIST_GET_VALUE (value1, i));
    }
  } else {
    gst_value_init_and_copy (&g_array_index (array, GValue, 0), value1);
  }

  j = value1_length;
  skipped = 0;
  if (GST_VALUE_HOLDS_LIST (value2)) {
    for (i = 0; i < value2_length; i++) {
      skip = FALSE;
      src = VALUE_LIST_GET_VALUE (value2, i);
      for (k = 0; k < value1_length; k++) {
        if (gst_value_compare (&g_array_index (array, GValue, k),
                src) == GST_VALUE_EQUAL) {
          skip = TRUE;
          skipped++;
          break;
        }
      }
      if (!skip) {
        gst_value_init_and_copy (&g_array_index (array, GValue, j), src);
        j++;
      }
    }
  } else {
    skip = FALSE;
    for (k = 0; k < value1_length; k++) {
      if (gst_value_compare (&g_array_index (array, GValue, k),
              value2) == GST_VALUE_EQUAL) {
        skip = TRUE;
        skipped++;
        break;
      }
    }
    if (!skip) {
      gst_value_init_and_copy (&g_array_index (array, GValue, j), value2);
    }
  }
  if (skipped) {
    guint new_size = value1_length + (value2_length - skipped);

    if (new_size > 1) {
      /* shrink list */
      g_array_set_size (array, new_size);
    } else {
      GValue single_dest;

      /* size is 1, take single value in list and make it new dest */
      single_dest = g_array_index (array, GValue, 0);

      /* clean up old value allocations: must set array size to 0, because
       * allocated values are not inited meaning g_value_unset() will not
       * work on them */
      g_array_set_size (array, 0);
      g_value_unset (dest);

      /* the single value is our new result */
      *dest = single_dest;
    }
  }
}

/**
 * gst_value_list_get_size:
 * @value: a #GValue of type #GST_TYPE_LIST
 *
 * Gets the number of values contained in @value.
 *
 * Returns: the number of values
 */
guint
gst_value_list_get_size (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_LIST (value), 0);

  return ((GArray *) value->data[0].v_pointer)->len;
}

/**
 * gst_value_list_get_value:
 * @value: a #GValue of type #GST_TYPE_LIST
 * @index: index of value to get from the list
 *
 * Gets the value that is a member of the list contained in @value and
 * has the index @index.
 *
 * Returns: (transfer none): the value at the given index
 */
const GValue *
gst_value_list_get_value (const GValue * value, guint index)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_LIST (value), NULL);
  g_return_val_if_fail (index < VALUE_LIST_SIZE (value), NULL);

  return (const GValue *) &g_array_index ((GArray *) value->data[0].v_pointer,
      GValue, index);
}

/**
 * gst_value_array_append_value:
 * @value: a #GValue of type #GST_TYPE_ARRAY
 * @append_value: the value to append
 *
 * Appends @append_value to the GstValueArray in @value.
 */
void
gst_value_array_append_value (GValue * value, const GValue * append_value)
{
  GValue val = { 0, };

  g_return_if_fail (GST_VALUE_HOLDS_ARRAY (value));
  g_return_if_fail (G_IS_VALUE (append_value));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value,
          append_value));

  gst_value_init_and_copy (&val, append_value);
  g_array_append_vals ((GArray *) value->data[0].v_pointer, &val, 1);
}

static inline void
_gst_value_array_append_and_take_value (GValue * value, GValue * append_value)
{
  g_array_append_vals ((GArray *) value->data[0].v_pointer, append_value, 1);
  memset (append_value, 0, sizeof (GValue));
}

/**
 * gst_value_array_append_and_take_value:
 * @value: a #GValue of type #GST_TYPE_ARRAY
 * @append_value: (transfer full): the value to append
 *
 * Appends @append_value to the GstValueArray in @value.
 *
 * Since: 1.2
 */
void
gst_value_array_append_and_take_value (GValue * value, GValue * append_value)
{
  g_return_if_fail (GST_VALUE_HOLDS_ARRAY (value));
  g_return_if_fail (G_IS_VALUE (append_value));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value,
          append_value));

  _gst_value_array_append_and_take_value (value, append_value);
}

/**
 * gst_value_array_prepend_value:
 * @value: a #GValue of type #GST_TYPE_ARRAY
 * @prepend_value: the value to prepend
 *
 * Prepends @prepend_value to the GstValueArray in @value.
 */
void
gst_value_array_prepend_value (GValue * value, const GValue * prepend_value)
{
  GValue val = { 0, };

  g_return_if_fail (GST_VALUE_HOLDS_ARRAY (value));
  g_return_if_fail (G_IS_VALUE (prepend_value));
  g_return_if_fail (gst_value_list_or_array_are_compatible (value,
          prepend_value));

  gst_value_init_and_copy (&val, prepend_value);
  g_array_prepend_vals ((GArray *) value->data[0].v_pointer, &val, 1);
}

/**
 * gst_value_array_get_size:
 * @value: a #GValue of type #GST_TYPE_ARRAY
 *
 * Gets the number of values contained in @value.
 *
 * Returns: the number of values
 */
guint
gst_value_array_get_size (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_ARRAY (value), 0);

  return ((GArray *) value->data[0].v_pointer)->len;
}

/**
 * gst_value_array_get_value:
 * @value: a #GValue of type #GST_TYPE_ARRAY
 * @index: index of value to get from the array
 *
 * Gets the value that is a member of the array contained in @value and
 * has the index @index.
 *
 * Returns: (transfer none): the value at the given index
 */
const GValue *
gst_value_array_get_value (const GValue * value, guint index)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_ARRAY (value), NULL);
  g_return_val_if_fail (index < gst_value_array_get_size (value), NULL);

  return (const GValue *) &g_array_index ((GArray *) value->data[0].v_pointer,
      GValue, index);
}

static void
gst_value_transform_list_string (const GValue * src_value, GValue * dest_value)
{
  gst_value_transform_any_list_string (src_value, dest_value, "{ ", " }");
}

static void
gst_value_transform_array_string (const GValue * src_value, GValue * dest_value)
{
  gst_value_transform_any_list_string (src_value, dest_value, "< ", " >");
}

/* Do an unordered compare of the contents of a list */
static gint
gst_value_compare_list (const GValue * value1, const GValue * value2)
{
  guint i, j;
  GArray *array1 = value1->data[0].v_pointer;
  GArray *array2 = value2->data[0].v_pointer;
  GValue *v1;
  GValue *v2;
  gint len, to_remove;
  guint8 *removed;
  GstValueCompareFunc compare;

  /* get length and do initial length check. */
  len = array1->len;
  if (len != array2->len)
    return GST_VALUE_UNORDERED;

  /* place to mark removed value indices of array2 */
  removed = g_newa (guint8, len);
  memset (removed, 0, len);
  to_remove = len;

  /* loop over array1, all items should be in array2. When we find an
   * item in array2, remove it from array2 by marking it as removed */
  for (i = 0; i < len; i++) {
    v1 = &g_array_index (array1, GValue, i);
    if ((compare = gst_value_get_compare_func (v1))) {
      for (j = 0; j < len; j++) {
        /* item is removed, we can skip it */
        if (removed[j])
          continue;
        v2 = &g_array_index (array2, GValue, j);
        if (gst_value_compare_with_func (v1, v2, compare) == GST_VALUE_EQUAL) {
          /* mark item as removed now that we found it in array2 and 
           * decrement the number of remaining items in array2. */
          removed[j] = 1;
          to_remove--;
          break;
        }
      }
      /* item in array1 and not in array2, UNORDERED */
      if (j == len)
        return GST_VALUE_UNORDERED;
    } else
      return GST_VALUE_UNORDERED;
  }
  /* if not all items were removed, array2 contained something not in array1 */
  if (to_remove != 0)
    return GST_VALUE_UNORDERED;

  /* arrays are equal */
  return GST_VALUE_EQUAL;
}

/* Perform an ordered comparison of the contents of an array */
static gint
gst_value_compare_array (const GValue * value1, const GValue * value2)
{
  guint i;
  GArray *array1 = value1->data[0].v_pointer;
  GArray *array2 = value2->data[0].v_pointer;
  guint len = array1->len;
  GValue *v1;
  GValue *v2;

  if (len != array2->len)
    return GST_VALUE_UNORDERED;

  for (i = 0; i < len; i++) {
    v1 = &g_array_index (array1, GValue, i);
    v2 = &g_array_index (array2, GValue, i);
    if (gst_value_compare (v1, v2) != GST_VALUE_EQUAL)
      return GST_VALUE_UNORDERED;
  }

  return GST_VALUE_EQUAL;
}

static gchar *
gst_value_serialize_list (const GValue * value)
{
  return gst_value_serialize_any_list (value, "{ ", " }");
}

static gboolean
gst_value_deserialize_list (GValue * dest, const gchar * s)
{
  g_warning ("gst_value_deserialize_list: unimplemented");
  return FALSE;
}

static gchar *
gst_value_serialize_array (const GValue * value)
{
  return gst_value_serialize_any_list (value, "< ", " >");
}

static gboolean
gst_value_deserialize_array (GValue * dest, const gchar * s)
{
  g_warning ("gst_value_deserialize_array: unimplemented");
  return FALSE;
}

/*************
 * int range *
 *
 * Values in the range are defined as any value greater or equal
 * to min*step, AND lesser or equal to max*step.
 * For step == 1, this falls back to the traditional range semantics.
 *
 * data[0] = (min << 32) | (max)
 * data[1] = step
 *
 *************/

#define INT_RANGE_MIN(v) ((gint) (((v)->data[0].v_uint64) >> 32))
#define INT_RANGE_MAX(v) ((gint) (((v)->data[0].v_uint64) & 0xffffffff))
#define INT_RANGE_STEP(v) ((v)->data[1].v_int)

static void
gst_value_init_int_range (GValue * value)
{
  G_STATIC_ASSERT (sizeof (gint) <= 2 * sizeof (guint64));

  value->data[0].v_uint64 = 0;
  value->data[1].v_int = 1;
}

static void
gst_value_copy_int_range (const GValue * src_value, GValue * dest_value)
{
  dest_value->data[0].v_uint64 = src_value->data[0].v_uint64;
  dest_value->data[1].v_int = src_value->data[1].v_int;
}

static gchar *
gst_value_collect_int_range (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  if (n_collect_values != 2)
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[0].v_int >= collect_values[1].v_int)
    return g_strdup_printf ("range start is not smaller than end for `%s'",
        G_VALUE_TYPE_NAME (value));

  gst_value_set_int_range_step (value, collect_values[0].v_int,
      collect_values[1].v_int, 1);

  return NULL;
}

static gchar *
gst_value_lcopy_int_range (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  guint32 *int_range_start = collect_values[0].v_pointer;
  guint32 *int_range_end = collect_values[1].v_pointer;

  if (!int_range_start)
    return g_strdup_printf ("start value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));
  if (!int_range_end)
    return g_strdup_printf ("end value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));

  *int_range_start = INT_RANGE_MIN (value);
  *int_range_end = INT_RANGE_MAX (value);

  return NULL;
}

/**
 * gst_value_set_int_range_step:
 * @value: a GValue initialized to GST_TYPE_INT_RANGE
 * @start: the start of the range
 * @end: the end of the range
 * @step: the step of the range
 *
 * Sets @value to the range specified by @start, @end and @step.
 */
void
gst_value_set_int_range_step (GValue * value, gint start, gint end, gint step)
{
  guint64 sstart, sstop;

  g_return_if_fail (GST_VALUE_HOLDS_INT_RANGE (value));
  g_return_if_fail (start < end);
  g_return_if_fail (step > 0);
  g_return_if_fail (start % step == 0);
  g_return_if_fail (end % step == 0);

  sstart = (guint) (start / step);
  sstop = (guint) (end / step);
  value->data[0].v_uint64 = (sstart << 32) | sstop;
  value->data[1].v_int = step;
}

/**
 * gst_value_set_int_range:
 * @value: a GValue initialized to GST_TYPE_INT_RANGE
 * @start: the start of the range
 * @end: the end of the range
 *
 * Sets @value to the range specified by @start and @end.
 */
void
gst_value_set_int_range (GValue * value, gint start, gint end)
{
  gst_value_set_int_range_step (value, start, end, 1);
}

/**
 * gst_value_get_int_range_min:
 * @value: a GValue initialized to GST_TYPE_INT_RANGE
 *
 * Gets the minimum of the range specified by @value.
 *
 * Returns: the minimum of the range
 */
gint
gst_value_get_int_range_min (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_INT_RANGE (value), 0);

  return INT_RANGE_MIN (value) * INT_RANGE_STEP (value);
}

/**
 * gst_value_get_int_range_max:
 * @value: a GValue initialized to GST_TYPE_INT_RANGE
 *
 * Gets the maximum of the range specified by @value.
 *
 * Returns: the maximum of the range
 */
gint
gst_value_get_int_range_max (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_INT_RANGE (value), 0);

  return INT_RANGE_MAX (value) * INT_RANGE_STEP (value);
}

/**
 * gst_value_get_int_range_step:
 * @value: a GValue initialized to GST_TYPE_INT_RANGE
 *
 * Gets the step of the range specified by @value.
 *
 * Returns: the step of the range
 */
gint
gst_value_get_int_range_step (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_INT_RANGE (value), 0);

  return INT_RANGE_STEP (value);
}

static void
gst_value_transform_int_range_string (const GValue * src_value,
    GValue * dest_value)
{
  if (INT_RANGE_STEP (src_value) == 1)
    dest_value->data[0].v_pointer = g_strdup_printf ("[%d,%d]",
        INT_RANGE_MIN (src_value), INT_RANGE_MAX (src_value));
  else
    dest_value->data[0].v_pointer = g_strdup_printf ("[%d,%d,%d]",
        INT_RANGE_MIN (src_value) * INT_RANGE_STEP (src_value),
        INT_RANGE_MAX (src_value) * INT_RANGE_STEP (src_value),
        INT_RANGE_STEP (src_value));
}

static gint
gst_value_compare_int_range (const GValue * value1, const GValue * value2)
{
  /* calculate the number of values in each range */
  gint n1 = INT_RANGE_MAX (value1) - INT_RANGE_MIN (value1) + 1;
  gint n2 = INT_RANGE_MAX (value2) - INT_RANGE_MIN (value2) + 1;

  /* they must be equal */
  if (n1 != n2)
    return GST_VALUE_UNORDERED;

  /* if empty, equal */
  if (n1 == 0)
    return GST_VALUE_EQUAL;

  /* if more than one value, then it is only equal if the step is equal
     and bounds lie on the same value */
  if (n1 > 1) {
    if (INT_RANGE_STEP (value1) == INT_RANGE_STEP (value2) &&
        INT_RANGE_MIN (value1) == INT_RANGE_MIN (value2) &&
        INT_RANGE_MAX (value1) == INT_RANGE_MAX (value2)) {
      return GST_VALUE_EQUAL;
    }
    return GST_VALUE_UNORDERED;
  } else {
    /* if just one, only if the value is equal */
    if (INT_RANGE_MIN (value1) == INT_RANGE_MIN (value2))
      return GST_VALUE_EQUAL;
    return GST_VALUE_UNORDERED;
  }
}

static gchar *
gst_value_serialize_int_range (const GValue * value)
{
  if (INT_RANGE_STEP (value) == 1)
    return g_strdup_printf ("[ %d, %d ]", INT_RANGE_MIN (value),
        INT_RANGE_MAX (value));
  else
    return g_strdup_printf ("[ %d, %d, %d ]",
        INT_RANGE_MIN (value) * INT_RANGE_STEP (value),
        INT_RANGE_MAX (value) * INT_RANGE_STEP (value), INT_RANGE_STEP (value));
}

static gboolean
gst_value_deserialize_int_range (GValue * dest, const gchar * s)
{
  g_warning ("unimplemented");
  return FALSE;
}

/***************
 * int64 range *
 *
 * Values in the range are defined as any value greater or equal
 * to min*step, AND lesser or equal to max*step.
 * For step == 1, this falls back to the traditional range semantics.
 ***************/

#define INT64_RANGE_MIN(v) (((gint64 *)((v)->data[0].v_pointer))[0])
#define INT64_RANGE_MAX(v) (((gint64 *)((v)->data[0].v_pointer))[1])
#define INT64_RANGE_STEP(v) (((gint64 *)((v)->data[0].v_pointer))[2])

static void
gst_value_init_int64_range (GValue * value)
{
  gint64 *vals = g_slice_alloc0 (3 * sizeof (gint64));
  value->data[0].v_pointer = vals;
  INT64_RANGE_MIN (value) = 0;
  INT64_RANGE_MAX (value) = 0;
  INT64_RANGE_STEP (value) = 1;
}

static void
gst_value_free_int64_range (GValue * value)
{
  g_return_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value));
  g_slice_free1 (3 * sizeof (gint64), value->data[0].v_pointer);
  value->data[0].v_pointer = NULL;
}

static void
gst_value_copy_int64_range (const GValue * src_value, GValue * dest_value)
{
  gint64 *vals = (gint64 *) dest_value->data[0].v_pointer;
  gint64 *src_vals = (gint64 *) src_value->data[0].v_pointer;

  if (vals == NULL) {
    gst_value_init_int64_range (dest_value);
  }

  if (src_vals != NULL) {
    INT64_RANGE_MIN (dest_value) = INT64_RANGE_MIN (src_value);
    INT64_RANGE_MAX (dest_value) = INT64_RANGE_MAX (src_value);
    INT64_RANGE_STEP (dest_value) = INT64_RANGE_STEP (src_value);
  }
}

static gchar *
gst_value_collect_int64_range (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  gint64 *vals = value->data[0].v_pointer;

  if (n_collect_values != 2)
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[0].v_int64 >= collect_values[1].v_int64)
    return g_strdup_printf ("range start is not smaller than end for `%s'",
        G_VALUE_TYPE_NAME (value));

  if (vals == NULL) {
    gst_value_init_int64_range (value);
  }

  gst_value_set_int64_range_step (value, collect_values[0].v_int64,
      collect_values[1].v_int64, 1);

  return NULL;
}

static gchar *
gst_value_lcopy_int64_range (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  guint64 *int_range_start = collect_values[0].v_pointer;
  guint64 *int_range_end = collect_values[1].v_pointer;
  guint64 *int_range_step = collect_values[2].v_pointer;
  gint64 *vals = (gint64 *) value->data[0].v_pointer;

  if (!int_range_start)
    return g_strdup_printf ("start value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));
  if (!int_range_end)
    return g_strdup_printf ("end value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));
  if (!int_range_step)
    return g_strdup_printf ("step value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));

  if (G_UNLIKELY (vals == NULL)) {
    return g_strdup_printf ("Uninitialised `%s' passed",
        G_VALUE_TYPE_NAME (value));
  }

  *int_range_start = INT64_RANGE_MIN (value);
  *int_range_end = INT64_RANGE_MAX (value);
  *int_range_step = INT64_RANGE_STEP (value);

  return NULL;
}

/**
 * gst_value_set_int64_range_step:
 * @value: a GValue initialized to GST_TYPE_INT64_RANGE
 * @start: the start of the range
 * @end: the end of the range
 * @step: the step of the range
 *
 * Sets @value to the range specified by @start, @end and @step.
 */
void
gst_value_set_int64_range_step (GValue * value, gint64 start, gint64 end,
    gint64 step)
{
  g_return_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value));
  g_return_if_fail (start < end);
  g_return_if_fail (step > 0);
  g_return_if_fail (start % step == 0);
  g_return_if_fail (end % step == 0);

  INT64_RANGE_MIN (value) = start / step;
  INT64_RANGE_MAX (value) = end / step;
  INT64_RANGE_STEP (value) = step;
}

/**
 * gst_value_set_int64_range:
 * @value: a GValue initialized to GST_TYPE_INT64_RANGE
 * @start: the start of the range
 * @end: the end of the range
 *
 * Sets @value to the range specified by @start and @end.
 */
void
gst_value_set_int64_range (GValue * value, gint64 start, gint64 end)
{
  gst_value_set_int64_range_step (value, start, end, 1);
}

/**
 * gst_value_get_int64_range_min:
 * @value: a GValue initialized to GST_TYPE_INT64_RANGE
 *
 * Gets the minimum of the range specified by @value.
 *
 * Returns: the minimum of the range
 */
gint64
gst_value_get_int64_range_min (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value), 0);

  return INT64_RANGE_MIN (value) * INT64_RANGE_STEP (value);
}

/**
 * gst_value_get_int64_range_max:
 * @value: a GValue initialized to GST_TYPE_INT64_RANGE
 *
 * Gets the maximum of the range specified by @value.
 *
 * Returns: the maximum of the range
 */
gint64
gst_value_get_int64_range_max (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value), 0);

  return INT64_RANGE_MAX (value) * INT64_RANGE_STEP (value);
}

/**
 * gst_value_get_int64_range_step:
 * @value: a GValue initialized to GST_TYPE_INT64_RANGE
 *
 * Gets the step of the range specified by @value.
 *
 * Returns: the step of the range
 */
gint64
gst_value_get_int64_range_step (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value), 0);

  return INT64_RANGE_STEP (value);
}

static void
gst_value_transform_int64_range_string (const GValue * src_value,
    GValue * dest_value)
{
  if (INT64_RANGE_STEP (src_value) == 1)
    dest_value->data[0].v_pointer =
        g_strdup_printf ("(gint64)[%" G_GINT64_FORMAT ",%" G_GINT64_FORMAT "]",
        INT64_RANGE_MIN (src_value), INT64_RANGE_MAX (src_value));
  else
    dest_value->data[0].v_pointer =
        g_strdup_printf ("(gint64)[%" G_GINT64_FORMAT ",%" G_GINT64_FORMAT
        ",%" G_GINT64_FORMAT "]",
        INT64_RANGE_MIN (src_value) * INT64_RANGE_STEP (src_value),
        INT64_RANGE_MAX (src_value) * INT64_RANGE_STEP (src_value),
        INT64_RANGE_STEP (src_value));
}

static gint
gst_value_compare_int64_range (const GValue * value1, const GValue * value2)
{
  /* calculate the number of values in each range */
  gint64 n1 = INT64_RANGE_MAX (value1) - INT64_RANGE_MIN (value1) + 1;
  gint64 n2 = INT64_RANGE_MAX (value2) - INT64_RANGE_MIN (value2) + 1;

  /* they must be equal */
  if (n1 != n2)
    return GST_VALUE_UNORDERED;

  /* if empty, equal */
  if (n1 == 0)
    return GST_VALUE_EQUAL;

  /* if more than one value, then it is only equal if the step is equal
     and bounds lie on the same value */
  if (n1 > 1) {
    if (INT64_RANGE_STEP (value1) == INT64_RANGE_STEP (value2) &&
        INT64_RANGE_MIN (value1) == INT64_RANGE_MIN (value2) &&
        INT64_RANGE_MAX (value1) == INT64_RANGE_MAX (value2)) {
      return GST_VALUE_EQUAL;
    }
    return GST_VALUE_UNORDERED;
  } else {
    /* if just one, only if the value is equal */
    if (INT64_RANGE_MIN (value1) == INT64_RANGE_MIN (value2))
      return GST_VALUE_EQUAL;
    return GST_VALUE_UNORDERED;
  }
}

static gchar *
gst_value_serialize_int64_range (const GValue * value)
{
  if (INT64_RANGE_STEP (value) == 1)
    return g_strdup_printf ("[ %" G_GINT64_FORMAT ", %" G_GINT64_FORMAT " ]",
        INT64_RANGE_MIN (value), INT64_RANGE_MAX (value));
  else
    return g_strdup_printf ("[ %" G_GINT64_FORMAT ", %" G_GINT64_FORMAT ", %"
        G_GINT64_FORMAT " ]",
        INT64_RANGE_MIN (value) * INT64_RANGE_STEP (value),
        INT64_RANGE_MAX (value) * INT64_RANGE_STEP (value),
        INT64_RANGE_STEP (value));
}

static gboolean
gst_value_deserialize_int64_range (GValue * dest, const gchar * s)
{
  g_warning ("unimplemented");
  return FALSE;
}

/****************
 * double range *
 ****************/

static void
gst_value_init_double_range (GValue * value)
{
  value->data[0].v_double = 0;
  value->data[1].v_double = 0;
}

static void
gst_value_copy_double_range (const GValue * src_value, GValue * dest_value)
{
  dest_value->data[0].v_double = src_value->data[0].v_double;
  dest_value->data[1].v_double = src_value->data[1].v_double;
}

static gchar *
gst_value_collect_double_range (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  if (n_collect_values != 2)
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[0].v_double >= collect_values[1].v_double)
    return g_strdup_printf ("range start is not smaller than end for `%s'",
        G_VALUE_TYPE_NAME (value));

  value->data[0].v_double = collect_values[0].v_double;
  value->data[1].v_double = collect_values[1].v_double;

  return NULL;
}

static gchar *
gst_value_lcopy_double_range (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  gdouble *double_range_start = collect_values[0].v_pointer;
  gdouble *double_range_end = collect_values[1].v_pointer;

  if (!double_range_start)
    return g_strdup_printf ("start value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));
  if (!double_range_end)
    return g_strdup_printf ("end value location for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));

  *double_range_start = value->data[0].v_double;
  *double_range_end = value->data[1].v_double;

  return NULL;
}

/**
 * gst_value_set_double_range:
 * @value: a GValue initialized to GST_TYPE_DOUBLE_RANGE
 * @start: the start of the range
 * @end: the end of the range
 *
 * Sets @value to the range specified by @start and @end.
 */
void
gst_value_set_double_range (GValue * value, gdouble start, gdouble end)
{
  g_return_if_fail (GST_VALUE_HOLDS_DOUBLE_RANGE (value));
  g_return_if_fail (start < end);

  value->data[0].v_double = start;
  value->data[1].v_double = end;
}

/**
 * gst_value_get_double_range_min:
 * @value: a GValue initialized to GST_TYPE_DOUBLE_RANGE
 *
 * Gets the minimum of the range specified by @value.
 *
 * Returns: the minimum of the range
 */
gdouble
gst_value_get_double_range_min (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_DOUBLE_RANGE (value), 0);

  return value->data[0].v_double;
}

/**
 * gst_value_get_double_range_max:
 * @value: a GValue initialized to GST_TYPE_DOUBLE_RANGE
 *
 * Gets the maximum of the range specified by @value.
 *
 * Returns: the maximum of the range
 */
gdouble
gst_value_get_double_range_max (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_DOUBLE_RANGE (value), 0);

  return value->data[1].v_double;
}

static void
gst_value_transform_double_range_string (const GValue * src_value,
    GValue * dest_value)
{
  gchar s1[G_ASCII_DTOSTR_BUF_SIZE], s2[G_ASCII_DTOSTR_BUF_SIZE];

  dest_value->data[0].v_pointer = g_strdup_printf ("[%s,%s]",
      g_ascii_dtostr (s1, G_ASCII_DTOSTR_BUF_SIZE,
          src_value->data[0].v_double),
      g_ascii_dtostr (s2, G_ASCII_DTOSTR_BUF_SIZE,
          src_value->data[1].v_double));
}

static gint
gst_value_compare_double_range (const GValue * value1, const GValue * value2)
{
  if (value2->data[0].v_double == value1->data[0].v_double &&
      value2->data[1].v_double == value1->data[1].v_double)
    return GST_VALUE_EQUAL;
  return GST_VALUE_UNORDERED;
}

static gchar *
gst_value_serialize_double_range (const GValue * value)
{
  gchar d1[G_ASCII_DTOSTR_BUF_SIZE];
  gchar d2[G_ASCII_DTOSTR_BUF_SIZE];

  g_ascii_dtostr (d1, G_ASCII_DTOSTR_BUF_SIZE, value->data[0].v_double);
  g_ascii_dtostr (d2, G_ASCII_DTOSTR_BUF_SIZE, value->data[1].v_double);
  return g_strdup_printf ("[ %s, %s ]", d1, d2);
}

static gboolean
gst_value_deserialize_double_range (GValue * dest, const gchar * s)
{
  g_warning ("unimplemented");
  return FALSE;
}

/****************
 * fraction range *
 ****************/

static void
gst_value_init_fraction_range (GValue * value)
{
  GValue *vals;
  GType ftype;

  ftype = GST_TYPE_FRACTION;

  value->data[0].v_pointer = vals = g_slice_alloc0 (2 * sizeof (GValue));
  g_value_init (&vals[0], ftype);
  g_value_init (&vals[1], ftype);
}

static void
gst_value_free_fraction_range (GValue * value)
{
  GValue *vals = (GValue *) value->data[0].v_pointer;

  if (vals != NULL) {
    /* we know the two values contain fractions without internal allocs */
    /* g_value_unset (&vals[0]); */
    /* g_value_unset (&vals[1]); */
    g_slice_free1 (2 * sizeof (GValue), vals);
    value->data[0].v_pointer = NULL;
  }
}

static void
gst_value_copy_fraction_range (const GValue * src_value, GValue * dest_value)
{
  GValue *vals = (GValue *) dest_value->data[0].v_pointer;
  GValue *src_vals = (GValue *) src_value->data[0].v_pointer;

  if (vals == NULL) {
    gst_value_init_fraction_range (dest_value);
    vals = dest_value->data[0].v_pointer;
  }
  if (src_vals != NULL) {
    g_value_copy (&src_vals[0], &vals[0]);
    g_value_copy (&src_vals[1], &vals[1]);
  }
}

static gchar *
gst_value_collect_fraction_range (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  GValue *vals = (GValue *) value->data[0].v_pointer;

  if (n_collect_values != 4)
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[1].v_int == 0)
    return g_strdup_printf ("passed '0' as first denominator for `%s'",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[3].v_int == 0)
    return g_strdup_printf ("passed '0' as second denominator for `%s'",
        G_VALUE_TYPE_NAME (value));
  if (gst_util_fraction_compare (collect_values[0].v_int,
          collect_values[1].v_int, collect_values[2].v_int,
          collect_values[3].v_int) >= 0)
    return g_strdup_printf ("range start is not smaller than end for `%s'",
        G_VALUE_TYPE_NAME (value));

  if (vals == NULL) {
    gst_value_init_fraction_range (value);
    vals = value->data[0].v_pointer;
  }

  gst_value_set_fraction (&vals[0], collect_values[0].v_int,
      collect_values[1].v_int);
  gst_value_set_fraction (&vals[1], collect_values[2].v_int,
      collect_values[3].v_int);

  return NULL;
}

static gchar *
gst_value_lcopy_fraction_range (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  gint i;
  gint *dest_values[4];
  GValue *vals = (GValue *) value->data[0].v_pointer;

  if (G_UNLIKELY (n_collect_values != 4))
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));

  for (i = 0; i < 4; i++) {
    if (G_UNLIKELY (collect_values[i].v_pointer == NULL)) {
      return g_strdup_printf ("value location for `%s' passed as NULL",
          G_VALUE_TYPE_NAME (value));
    }
    dest_values[i] = collect_values[i].v_pointer;
  }

  if (G_UNLIKELY (vals == NULL)) {
    return g_strdup_printf ("Uninitialised `%s' passed",
        G_VALUE_TYPE_NAME (value));
  }

  dest_values[0][0] = gst_value_get_fraction_numerator (&vals[0]);
  dest_values[1][0] = gst_value_get_fraction_denominator (&vals[0]);
  dest_values[2][0] = gst_value_get_fraction_numerator (&vals[1]);
  dest_values[3][0] = gst_value_get_fraction_denominator (&vals[1]);
  return NULL;
}

/**
 * gst_value_set_fraction_range:
 * @value: a GValue initialized to GST_TYPE_FRACTION_RANGE
 * @start: the start of the range (a GST_TYPE_FRACTION GValue)
 * @end: the end of the range (a GST_TYPE_FRACTION GValue)
 *
 * Sets @value to the range specified by @start and @end.
 */
void
gst_value_set_fraction_range (GValue * value, const GValue * start,
    const GValue * end)
{
  GValue *vals;

  g_return_if_fail (GST_VALUE_HOLDS_FRACTION_RANGE (value));
  g_return_if_fail (GST_VALUE_HOLDS_FRACTION (start));
  g_return_if_fail (GST_VALUE_HOLDS_FRACTION (end));
  g_return_if_fail (gst_util_fraction_compare (start->data[0].v_int,
          start->data[1].v_int, end->data[0].v_int, end->data[1].v_int) < 0);

  vals = (GValue *) value->data[0].v_pointer;
  if (vals == NULL) {
    gst_value_init_fraction_range (value);
    vals = value->data[0].v_pointer;
  }
  g_value_copy (start, &vals[0]);
  g_value_copy (end, &vals[1]);
}

/**
 * gst_value_set_fraction_range_full:
 * @value: a GValue initialized to GST_TYPE_FRACTION_RANGE
 * @numerator_start: the numerator start of the range
 * @denominator_start: the denominator start of the range
 * @numerator_end: the numerator end of the range
 * @denominator_end: the denominator end of the range
 *
 * Sets @value to the range specified by @numerator_start/@denominator_start
 * and @numerator_end/@denominator_end.
 */
void
gst_value_set_fraction_range_full (GValue * value,
    gint numerator_start, gint denominator_start,
    gint numerator_end, gint denominator_end)
{
  GValue start = { 0 };
  GValue end = { 0 };

  g_return_if_fail (value != NULL);
  g_return_if_fail (denominator_start != 0);
  g_return_if_fail (denominator_end != 0);
  g_return_if_fail (gst_util_fraction_compare (numerator_start,
          denominator_start, numerator_end, denominator_end) < 0);

  g_value_init (&start, GST_TYPE_FRACTION);
  g_value_init (&end, GST_TYPE_FRACTION);

  gst_value_set_fraction (&start, numerator_start, denominator_start);
  gst_value_set_fraction (&end, numerator_end, denominator_end);
  gst_value_set_fraction_range (value, &start, &end);

  /* we know the two values contain fractions without internal allocs */
  /* g_value_unset (&start); */
  /* g_value_unset (&end);   */
}

/* FIXME 2.0: Don't leak the internal representation of fraction
 * ranges but instead return the numerator and denominator
 * separately.
 * This would allow to store fraction ranges as
 *  data[0] = (min_n << 32) | (min_d)
 *  data[1] = (max_n << 32) | (max_d)
 * without requiring an additional allocation for each value.
 */

/**
 * gst_value_get_fraction_range_min:
 * @value: a GValue initialized to GST_TYPE_FRACTION_RANGE
 *
 * Gets the minimum of the range specified by @value.
 *
 * Returns: the minimum of the range
 */
const GValue *
gst_value_get_fraction_range_min (const GValue * value)
{
  GValue *vals;

  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION_RANGE (value), NULL);

  vals = (GValue *) value->data[0].v_pointer;
  if (vals != NULL) {
    return &vals[0];
  }

  return NULL;
}

/**
 * gst_value_get_fraction_range_max:
 * @value: a GValue initialized to GST_TYPE_FRACTION_RANGE
 *
 * Gets the maximum of the range specified by @value.
 *
 * Returns: the maximum of the range
 */
const GValue *
gst_value_get_fraction_range_max (const GValue * value)
{
  GValue *vals;

  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION_RANGE (value), NULL);

  vals = (GValue *) value->data[0].v_pointer;
  if (vals != NULL) {
    return &vals[1];
  }

  return NULL;
}

static gchar *
gst_value_serialize_fraction_range (const GValue * value)
{
  GValue *vals = (GValue *) value->data[0].v_pointer;
  gchar *retval;

  if (vals == NULL) {
    retval = g_strdup ("[ 0/1, 0/1 ]");
  } else {
    gchar *start, *end;

    start = gst_value_serialize_fraction (&vals[0]);
    end = gst_value_serialize_fraction (&vals[1]);

    retval = g_strdup_printf ("[ %s, %s ]", start, end);
    g_free (start);
    g_free (end);
  }

  return retval;
}

static void
gst_value_transform_fraction_range_string (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_pointer =
      gst_value_serialize_fraction_range (src_value);
}

static gint
gst_value_compare_fraction_range (const GValue * value1, const GValue * value2)
{
  GValue *vals1, *vals2;
  GstValueCompareFunc compare;

  if (value2->data[0].v_pointer == value1->data[0].v_pointer)
    return GST_VALUE_EQUAL;     /* Only possible if both are NULL */

  if (value2->data[0].v_pointer == NULL || value1->data[0].v_pointer == NULL)
    return GST_VALUE_UNORDERED;

  vals1 = (GValue *) value1->data[0].v_pointer;
  vals2 = (GValue *) value2->data[0].v_pointer;
  if ((compare = gst_value_get_compare_func (&vals1[0]))) {
    if (gst_value_compare_with_func (&vals1[0], &vals2[0], compare) ==
        GST_VALUE_EQUAL &&
        gst_value_compare_with_func (&vals1[1], &vals2[1], compare) ==
        GST_VALUE_EQUAL)
      return GST_VALUE_EQUAL;
  }
  return GST_VALUE_UNORDERED;
}

static gboolean
gst_value_deserialize_fraction_range (GValue * dest, const gchar * s)
{
  g_warning ("unimplemented");
  return FALSE;
}

/***********
 * GstCaps *
 ***********/

/**
 * gst_value_set_caps:
 * @value: a GValue initialized to GST_TYPE_CAPS
 * @caps: (transfer none): the caps to set the value to
 *
 * Sets the contents of @value to @caps. A reference to the
 * provided @caps will be taken by the @value.
 */
void
gst_value_set_caps (GValue * value, const GstCaps * caps)
{
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (G_VALUE_TYPE (value) == GST_TYPE_CAPS);
  g_return_if_fail (caps == NULL || GST_IS_CAPS (caps));

  g_value_set_boxed (value, caps);
}

/**
 * gst_value_get_caps:
 * @value: a GValue initialized to GST_TYPE_CAPS
 *
 * Gets the contents of @value. The reference count of the returned
 * #GstCaps will not be modified, therefore the caller must take one
 * before getting rid of the @value.
 *
 * Returns: (transfer none): the contents of @value
 */
const GstCaps *
gst_value_get_caps (const GValue * value)
{
  g_return_val_if_fail (G_IS_VALUE (value), NULL);
  g_return_val_if_fail (G_VALUE_TYPE (value) == GST_TYPE_CAPS, NULL);

  return (GstCaps *) g_value_get_boxed (value);
}

static gint
gst_value_compare_caps (const GValue * value1, const GValue * value2)
{
  GstCaps *caps1 = GST_CAPS (gst_value_get_caps (value1));
  GstCaps *caps2 = GST_CAPS (gst_value_get_caps (value2));

  if (gst_caps_is_equal (caps1, caps2))
    return GST_VALUE_EQUAL;
  return GST_VALUE_UNORDERED;
}

static gchar *
gst_value_serialize_caps (const GValue * value)
{
  GstCaps *caps = g_value_get_boxed (value);
  return gst_string_take_and_wrap (gst_caps_to_string (caps));
}

static gboolean
gst_value_deserialize_caps (GValue * dest, const gchar * s)
{
  GstCaps *caps;

  if (*s != '"') {
    caps = gst_caps_from_string (s);
  } else {
    gchar *str = gst_string_unwrap (s);

    if (G_UNLIKELY (!str))
      return FALSE;

    caps = gst_caps_from_string (str);
    g_free (str);
  }

  if (caps) {
    g_value_take_boxed (dest, caps);
    return TRUE;
  }
  return FALSE;
}

/**************
 * GstSegment *
 **************/

static gchar *
gst_value_serialize_segment_internal (const GValue * value, gboolean escape)
{
  GstSegment *seg = g_value_get_boxed (value);
  gchar *t, *res;
  GstStructure *s;

  s = gst_structure_new ("GstSegment",
      "flags", GST_TYPE_SEGMENT_FLAGS, seg->flags,
      "rate", G_TYPE_DOUBLE, seg->rate,
      "applied-rate", G_TYPE_DOUBLE, seg->applied_rate,
      "format", GST_TYPE_FORMAT, seg->format,
      "base", G_TYPE_UINT64, seg->base,
      "offset", G_TYPE_UINT64, seg->offset,
      "start", G_TYPE_UINT64, seg->start,
      "stop", G_TYPE_UINT64, seg->stop,
      "time", G_TYPE_UINT64, seg->time,
      "position", G_TYPE_UINT64, seg->position,
      "duration", G_TYPE_UINT64, seg->duration, NULL);
  t = gst_structure_to_string (s);
  if (escape) {
    res = g_strdup_printf ("\"%s\"", t);
    g_free (t);
  } else {
    res = t;
  }
  gst_structure_free (s);

  return res;
}

static gchar *
gst_value_serialize_segment (const GValue * value)
{
  return gst_value_serialize_segment_internal (value, TRUE);
}

static gboolean
gst_value_deserialize_segment (GValue * dest, const gchar * s)
{
  GstStructure *str;
  GstSegment seg;
  gboolean res;

  str = gst_structure_from_string (s, NULL);
  if (str == NULL)
    return FALSE;

  res = gst_structure_get (str,
      "flags", GST_TYPE_SEGMENT_FLAGS, &seg.flags,
      "rate", G_TYPE_DOUBLE, &seg.rate,
      "applied-rate", G_TYPE_DOUBLE, &seg.applied_rate,
      "format", GST_TYPE_FORMAT, &seg.format,
      "base", G_TYPE_UINT64, &seg.base,
      "offset", G_TYPE_UINT64, &seg.offset,
      "start", G_TYPE_UINT64, &seg.start,
      "stop", G_TYPE_UINT64, &seg.stop,
      "time", G_TYPE_UINT64, &seg.time,
      "position", G_TYPE_UINT64, &seg.position,
      "duration", G_TYPE_UINT64, &seg.duration, NULL);
  gst_structure_free (str);

  if (res)
    g_value_set_boxed (dest, &seg);

  return res;
}

/****************
 * GstStructure *
 ****************/

/**
 * gst_value_set_structure:
 * @value: a GValue initialized to GST_TYPE_STRUCTURE
 * @structure: the structure to set the value to
 *
 * Sets the contents of @value to @structure.  The actual
 */
void
gst_value_set_structure (GValue * value, const GstStructure * structure)
{
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (G_VALUE_TYPE (value) == GST_TYPE_STRUCTURE);
  g_return_if_fail (structure == NULL || GST_IS_STRUCTURE (structure));

  g_value_set_boxed (value, structure);
}

/**
 * gst_value_get_structure:
 * @value: a GValue initialized to GST_TYPE_STRUCTURE
 *
 * Gets the contents of @value.
 *
 * Returns: (transfer none): the contents of @value
 */
const GstStructure *
gst_value_get_structure (const GValue * value)
{
  g_return_val_if_fail (G_IS_VALUE (value), NULL);
  g_return_val_if_fail (G_VALUE_TYPE (value) == GST_TYPE_STRUCTURE, NULL);

  return (GstStructure *) g_value_get_boxed (value);
}

static gchar *
gst_value_serialize_structure (const GValue * value)
{
  GstStructure *structure = g_value_get_boxed (value);

  return gst_string_take_and_wrap (gst_structure_to_string (structure));
}

static gboolean
gst_value_deserialize_structure (GValue * dest, const gchar * s)
{
  GstStructure *structure;

  if (*s != '"') {
    structure = gst_structure_from_string (s, NULL);
  } else {
    gchar *str = gst_string_unwrap (s);

    if (G_UNLIKELY (!str))
      return FALSE;

    structure = gst_structure_from_string (str, NULL);
    g_free (str);
  }

  if (G_LIKELY (structure)) {
    g_value_take_boxed (dest, structure);
    return TRUE;
  }
  return FALSE;
}

/*******************
 * GstCapsFeatures *
 *******************/

/**
 * gst_value_set_caps_features:
 * @value: a GValue initialized to GST_TYPE_CAPS_FEATURES
 * @features: the features to set the value to
 *
 * Sets the contents of @value to @features.
 */
void
gst_value_set_caps_features (GValue * value, const GstCapsFeatures * features)
{
  g_return_if_fail (G_IS_VALUE (value));
  g_return_if_fail (G_VALUE_TYPE (value) == GST_TYPE_CAPS_FEATURES);
  g_return_if_fail (features == NULL || GST_IS_CAPS_FEATURES (features));

  g_value_set_boxed (value, features);
}

/**
 * gst_value_get_caps_features:
 * @value: a GValue initialized to GST_TYPE_CAPS_FEATURES
 *
 * Gets the contents of @value.
 *
 * Returns: (transfer none): the contents of @value
 */
const GstCapsFeatures *
gst_value_get_caps_features (const GValue * value)
{
  g_return_val_if_fail (G_IS_VALUE (value), NULL);
  g_return_val_if_fail (G_VALUE_TYPE (value) == GST_TYPE_CAPS_FEATURES, NULL);

  return (GstCapsFeatures *) g_value_get_boxed (value);
}

static gchar *
gst_value_serialize_caps_features (const GValue * value)
{
  GstCapsFeatures *features = g_value_get_boxed (value);

  return gst_string_take_and_wrap (gst_caps_features_to_string (features));
}

static gboolean
gst_value_deserialize_caps_features (GValue * dest, const gchar * s)
{
  GstCapsFeatures *features;

  if (*s != '"') {
    features = gst_caps_features_from_string (s);
  } else {
    gchar *str = gst_string_unwrap (s);

    if (G_UNLIKELY (!str))
      return FALSE;

    features = gst_caps_features_from_string (str);
    g_free (str);
  }

  if (G_LIKELY (features)) {
    g_value_take_boxed (dest, features);
    return TRUE;
  }
  return FALSE;
}

/**************
 * GstTagList *
 **************/

static gboolean
gst_value_deserialize_tag_list (GValue * dest, const gchar * s)
{
  GstTagList *taglist;

  if (*s != '"') {
    taglist = gst_tag_list_new_from_string (s);
  } else {
    gchar *str = gst_string_unwrap (s);

    if (G_UNLIKELY (!str))
      return FALSE;

    taglist = gst_tag_list_new_from_string (str);
    g_free (str);
  }

  if (G_LIKELY (taglist != NULL)) {
    g_value_take_boxed (dest, taglist);
    return TRUE;
  }
  return FALSE;
}

static gchar *
gst_value_serialize_tag_list (const GValue * value)
{
  GstTagList *taglist = g_value_get_boxed (value);

  return gst_string_take_and_wrap (gst_tag_list_to_string (taglist));
}


/*************
 * GstBuffer *
 *************/

static gint
compare_buffer (GstBuffer * buf1, GstBuffer * buf2)
{
  gsize size1, size2;
  GstMapInfo info1, info2;
  gint result, mret;

  if (buf1 == buf2)
    return GST_VALUE_EQUAL;

  size1 = gst_buffer_get_size (buf1);
  size2 = gst_buffer_get_size (buf2);

  if (size1 != size2)
    return GST_VALUE_UNORDERED;

  if (size1 == 0)
    return GST_VALUE_EQUAL;

  if (!gst_buffer_map (buf1, &info1, GST_MAP_READ))
    return GST_VALUE_UNORDERED;

  if (!gst_buffer_map (buf2, &info2, GST_MAP_READ)) {
    gst_buffer_unmap (buf1, &info1);
    return GST_VALUE_UNORDERED;
  }

  mret = memcmp (info1.data, info2.data, info1.size);
  if (mret == 0)
    result = GST_VALUE_EQUAL;
  else if (mret < 0)
    result = GST_VALUE_LESS_THAN;
  else
    result = GST_VALUE_GREATER_THAN;

  gst_buffer_unmap (buf1, &info1);
  gst_buffer_unmap (buf2, &info2);

  return result;
}

static gint
gst_value_compare_buffer (const GValue * value1, const GValue * value2)
{
  GstBuffer *buf1 = gst_value_get_buffer (value1);
  GstBuffer *buf2 = gst_value_get_buffer (value2);

  return compare_buffer (buf1, buf2);
}

static gchar *
gst_value_serialize_buffer (const GValue * value)
{
  GstMapInfo info;
  guint8 *data;
  gint i;
  gchar *string;
  GstBuffer *buffer;

  buffer = gst_value_get_buffer (value);
  if (buffer == NULL)
    return NULL;

  if (!gst_buffer_map (buffer, &info, GST_MAP_READ))
    return NULL;

  data = info.data;

  string = g_malloc (info.size * 2 + 1);
  for (i = 0; i < info.size; i++) {
    sprintf (string + i * 2, "%02x", data[i]);
  }
  string[info.size * 2] = 0;

  gst_buffer_unmap (buffer, &info);

  return string;
}

static gboolean
gst_value_deserialize_buffer (GValue * dest, const gchar * s)
{
  GstBuffer *buffer;
  gint len;
  gchar ts[3];
  GstMapInfo info;
  guint8 *data;
  gint i;

  len = strlen (s);
  if (len & 1)
    goto wrong_length;

  buffer = gst_buffer_new_allocate (NULL, len / 2, NULL);
  if (!gst_buffer_map (buffer, &info, GST_MAP_WRITE))
    goto map_failed;
  data = info.data;

  for (i = 0; i < len / 2; i++) {
    if (!isxdigit ((int) s[i * 2]) || !isxdigit ((int) s[i * 2 + 1]))
      goto wrong_char;

    ts[0] = s[i * 2 + 0];
    ts[1] = s[i * 2 + 1];
    ts[2] = 0;

    data[i] = (guint8) strtoul (ts, NULL, 16);
  }
  gst_buffer_unmap (buffer, &info);

  gst_value_take_buffer (dest, buffer);

  return TRUE;

  /* ERRORS */
wrong_length:
  {
    return FALSE;
  }
map_failed:
  {
    return FALSE;
  }
wrong_char:
  {
    gst_buffer_unref (buffer);
    gst_buffer_unmap (buffer, &info);
    return FALSE;
  }
}

/*************
 * GstSample *
 *************/

/* This function is mostly used for comparing image/buffer tags in taglists */
static gint
gst_value_compare_sample (const GValue * value1, const GValue * value2)
{
  GstBuffer *buf1 = gst_sample_get_buffer (gst_value_get_sample (value1));
  GstBuffer *buf2 = gst_sample_get_buffer (gst_value_get_sample (value2));

  /* FIXME: should we take into account anything else such as caps? */
  return compare_buffer (buf1, buf2);
}

static gchar *
gst_value_serialize_sample (const GValue * value)
{
  const GstStructure *info_structure;
  GstSegment *segment;
  GstBuffer *buffer;
  GstCaps *caps;
  GstSample *sample;
  GValue val = { 0, };
  gchar *info_str, *caps_str, *tmp;
  gchar *buf_str, *seg_str, *s;

  sample = g_value_get_boxed (value);

  buffer = gst_sample_get_buffer (sample);
  if (buffer) {
    g_value_init (&val, GST_TYPE_BUFFER);
    g_value_set_boxed (&val, buffer);
    buf_str = gst_value_serialize_buffer (&val);
    g_value_unset (&val);
  } else {
    buf_str = g_strdup ("None");
  }

  caps = gst_sample_get_caps (sample);
  if (caps) {
    tmp = gst_caps_to_string (caps);
    caps_str = g_base64_encode ((guchar *) tmp, strlen (tmp) + 1);
    g_strdelimit (caps_str, "=", '_');
    g_free (tmp);
  } else {
    caps_str = g_strdup ("None");
  }

  segment = gst_sample_get_segment (sample);
  if (segment) {
    g_value_init (&val, GST_TYPE_SEGMENT);
    g_value_set_boxed (&val, segment);
    tmp = gst_value_serialize_segment_internal (&val, FALSE);
    seg_str = g_base64_encode ((guchar *) tmp, strlen (tmp) + 1);
    g_strdelimit (seg_str, "=", '_');
    g_free (tmp);
    g_value_unset (&val);
  } else {
    seg_str = g_strdup ("None");
  }

  info_structure = gst_sample_get_info (sample);
  if (info_structure) {
    tmp = gst_structure_to_string (info_structure);
    info_str = g_base64_encode ((guchar *) tmp, strlen (tmp) + 1);
    g_strdelimit (info_str, "=", '_');
    g_free (tmp);
  } else {
    info_str = g_strdup ("None");
  }

  s = g_strconcat (buf_str, ":", caps_str, ":", seg_str, ":", info_str, NULL);
  g_free (buf_str);
  g_free (caps_str);
  g_free (seg_str);
  g_free (info_str);

  return s;
}

static gboolean
gst_value_deserialize_sample (GValue * dest, const gchar * s)
{
  GValue bval = G_VALUE_INIT, sval = G_VALUE_INIT;
  GstStructure *info;
  GstSample *sample;
  GstCaps *caps;
  gboolean ret = FALSE;
  gchar **fields;
  gsize outlen;
  gint len;

  GST_TRACE ("deserialize '%s'", s);

  fields = g_strsplit (s, ":", -1);
  len = g_strv_length (fields);
  if (len != 4)
    goto wrong_length;

  g_value_init (&bval, GST_TYPE_BUFFER);
  g_value_init (&sval, GST_TYPE_SEGMENT);

  if (!gst_value_deserialize_buffer (&bval, fields[0]))
    goto fail;

  if (strcmp (fields[1], "None") != 0) {
    g_strdelimit (fields[1], "_", '=');
    g_base64_decode_inplace (fields[1], &outlen);
    GST_TRACE ("caps    : %s", fields[1]);
    caps = gst_caps_from_string (fields[1]);
    if (caps == NULL)
      goto fail;
  } else {
    caps = NULL;
  }

  if (strcmp (fields[2], "None") != 0) {
    g_strdelimit (fields[2], "_", '=');
    g_base64_decode_inplace (fields[2], &outlen);
    GST_TRACE ("segment : %s", fields[2]);
    if (!gst_value_deserialize_segment (&sval, fields[2]))
      goto fail;
  }

  if (strcmp (fields[3], "None") != 0) {
    g_strdelimit (fields[3], "_", '=');
    g_base64_decode_inplace (fields[3], &outlen);
    GST_TRACE ("info    : %s", fields[3]);
    info = gst_structure_from_string (fields[3], NULL);
    if (info == NULL)
      goto fail;
  } else {
    info = NULL;
  }

  sample = gst_sample_new (gst_value_get_buffer (&bval), caps,
      g_value_get_boxed (&sval), info);

  g_value_take_boxed (dest, sample);

  if (caps)
    gst_caps_unref (caps);

  ret = TRUE;

fail:

  g_value_unset (&bval);
  g_value_unset (&sval);

wrong_length:

  g_strfreev (fields);

  return ret;
}

/***********
 * boolean *
 ***********/

static gint
gst_value_compare_boolean (const GValue * value1, const GValue * value2)
{
  if ((value1->data[0].v_int != 0) == (value2->data[0].v_int != 0))
    return GST_VALUE_EQUAL;
  return GST_VALUE_UNORDERED;
}

static gchar *
gst_value_serialize_boolean (const GValue * value)
{
  if (value->data[0].v_int) {
    return g_strdup ("true");
  }
  return g_strdup ("false");
}

static gboolean
gst_value_deserialize_boolean (GValue * dest, const gchar * s)
{
  gboolean ret = FALSE;

  if (g_ascii_strcasecmp (s, "true") == 0 ||
      g_ascii_strcasecmp (s, "yes") == 0 ||
      g_ascii_strcasecmp (s, "t") == 0 || strcmp (s, "1") == 0) {
    g_value_set_boolean (dest, TRUE);
    ret = TRUE;
  } else if (g_ascii_strcasecmp (s, "false") == 0 ||
      g_ascii_strcasecmp (s, "no") == 0 ||
      g_ascii_strcasecmp (s, "f") == 0 || strcmp (s, "0") == 0) {
    g_value_set_boolean (dest, FALSE);
    ret = TRUE;
  }

  return ret;
}

#define CREATE_SERIALIZATION_START(_type,_macro)                        \
static gint                                                             \
gst_value_compare_ ## _type                                             \
(const GValue * value1, const GValue * value2)                          \
{                                                                       \
  g ## _type val1 = g_value_get_ ## _type (value1);                     \
  g ## _type val2 = g_value_get_ ## _type (value2);                     \
  if (val1 > val2)                                                      \
    return GST_VALUE_GREATER_THAN;                                      \
  if (val1 < val2)                                                      \
    return GST_VALUE_LESS_THAN;                                         \
  return GST_VALUE_EQUAL;                                               \
}                                                                       \
                                                                        \
static gchar *                                                          \
gst_value_serialize_ ## _type (const GValue * value)                    \
{                                                                       \
  GValue val = { 0, };                                                  \
  g_value_init (&val, G_TYPE_STRING);                                   \
  if (!g_value_transform (value, &val))                                 \
    g_assert_not_reached ();                                            \
  /* NO_COPY_MADNESS!!! */                                              \
  return (char *) g_value_get_string (&val);                            \
}

/* deserialize the given s into to as a gint64.
 * check if the result is actually storeable in the given size number of
 * bytes.
 */
static gboolean
gst_value_deserialize_int_helper (gint64 * to, const gchar * s,
    gint64 min, gint64 max, gint size)
{
  gboolean ret = FALSE;
  gchar *end;
  guint64 mask = ~0;

  errno = 0;
  *to = g_ascii_strtoull (s, &end, 0);
  /* a range error is a definitive no-no */
  if (errno == ERANGE) {
    return FALSE;
  }

  if (*end == 0) {
    ret = TRUE;
  } else {
    if (g_ascii_strcasecmp (s, "little_endian") == 0) {
      *to = G_LITTLE_ENDIAN;
      ret = TRUE;
    } else if (g_ascii_strcasecmp (s, "big_endian") == 0) {
      *to = G_BIG_ENDIAN;
      ret = TRUE;
    } else if (g_ascii_strcasecmp (s, "byte_order") == 0) {
      *to = G_BYTE_ORDER;
      ret = TRUE;
    } else if (g_ascii_strcasecmp (s, "min") == 0) {
      *to = min;
      ret = TRUE;
    } else if (g_ascii_strcasecmp (s, "max") == 0) {
      *to = max;
      ret = TRUE;
    }
  }
  if (ret) {
    /* by definition, a gint64 fits into a gint64; so ignore those */
    if (size != sizeof (mask)) {
      if (*to >= 0) {
        /* for positive numbers, we create a mask of 1's outside of the range
         * and 0's inside the range.  An and will thus keep only 1 bits
         * outside of the range */
        mask <<= (size * 8);
        if ((mask & *to) != 0) {
          ret = FALSE;
        }
      } else {
        /* for negative numbers, we do a 2's complement version */
        mask <<= ((size * 8) - 1);
        if ((mask & *to) != mask) {
          ret = FALSE;
        }
      }
    }
  }
  return ret;
}

#define CREATE_SERIALIZATION(_type,_macro)                              \
CREATE_SERIALIZATION_START(_type,_macro)                                \
                                                                        \
static gboolean                                                         \
gst_value_deserialize_ ## _type (GValue * dest, const gchar *s)         \
{                                                                       \
  gint64 x;                                                             \
                                                                        \
  if (gst_value_deserialize_int_helper (&x, s, G_MIN ## _macro,         \
      G_MAX ## _macro, sizeof (g ## _type))) {                          \
    g_value_set_ ## _type (dest, /*(g ## _type)*/ x);                   \
    return TRUE;                                                        \
  } else {                                                              \
    return FALSE;                                                       \
  }                                                                     \
}

#define CREATE_USERIALIZATION(_type,_macro)                             \
CREATE_SERIALIZATION_START(_type,_macro)                                \
                                                                        \
static gboolean                                                         \
gst_value_deserialize_ ## _type (GValue * dest, const gchar *s)         \
{                                                                       \
  gint64 x;                                                             \
  gchar *end;                                                           \
  gboolean ret = FALSE;                                                 \
                                                                        \
  errno = 0;                                                            \
  x = g_ascii_strtoull (s, &end, 0);                                    \
  /* a range error is a definitive no-no */                             \
  if (errno == ERANGE) {                                                \
    return FALSE;                                                       \
  }                                                                     \
  /* the cast ensures the range check later on makes sense */           \
  x = (g ## _type) x;                                                   \
  if (*end == 0) {                                                      \
    ret = TRUE;                                                         \
  } else {                                                              \
    if (g_ascii_strcasecmp (s, "little_endian") == 0) {                 \
      x = G_LITTLE_ENDIAN;                                              \
      ret = TRUE;                                                       \
    } else if (g_ascii_strcasecmp (s, "big_endian") == 0) {             \
      x = G_BIG_ENDIAN;                                                 \
      ret = TRUE;                                                       \
    } else if (g_ascii_strcasecmp (s, "byte_order") == 0) {             \
      x = G_BYTE_ORDER;                                                 \
      ret = TRUE;                                                       \
    } else if (g_ascii_strcasecmp (s, "min") == 0) {                    \
      x = 0;                                                            \
      ret = TRUE;                                                       \
    } else if (g_ascii_strcasecmp (s, "max") == 0) {                    \
      x = G_MAX ## _macro;                                              \
      ret = TRUE;                                                       \
    }                                                                   \
  }                                                                     \
  if (ret) {                                                            \
    if (x > G_MAX ## _macro) {                                          \
      ret = FALSE;                                                      \
    } else {                                                            \
      g_value_set_ ## _type (dest, x);                                  \
    }                                                                   \
  }                                                                     \
  return ret;                                                           \
}

#define REGISTER_SERIALIZATION(_gtype, _type)                           \
G_STMT_START {                                                          \
  static const GstValueTable gst_value = {                              \
    _gtype,                                                             \
    gst_value_compare_ ## _type,                                        \
    gst_value_serialize_ ## _type,                                      \
    gst_value_deserialize_ ## _type,                                    \
  };                                                                    \
                                                                        \
  gst_value_register (&gst_value);                                      \
} G_STMT_END

CREATE_SERIALIZATION (int, INT);
CREATE_SERIALIZATION (int64, INT64);
CREATE_SERIALIZATION (long, LONG);

CREATE_USERIALIZATION (uint, UINT);
CREATE_USERIALIZATION (uint64, UINT64);
CREATE_USERIALIZATION (ulong, ULONG);

/* FIXME 0.11: remove this again, plugins shouldn't have uchar properties */
#ifndef G_MAXUCHAR
#define G_MAXUCHAR 255
#endif
CREATE_USERIALIZATION (uchar, UCHAR);

/**********
 * double *
 **********/
static gint
gst_value_compare_double (const GValue * value1, const GValue * value2)
{
  if (value1->data[0].v_double > value2->data[0].v_double)
    return GST_VALUE_GREATER_THAN;
  if (value1->data[0].v_double < value2->data[0].v_double)
    return GST_VALUE_LESS_THAN;
  if (value1->data[0].v_double == value2->data[0].v_double)
    return GST_VALUE_EQUAL;
  return GST_VALUE_UNORDERED;
}

static gchar *
gst_value_serialize_double (const GValue * value)
{
  gchar d[G_ASCII_DTOSTR_BUF_SIZE];

  g_ascii_dtostr (d, G_ASCII_DTOSTR_BUF_SIZE, value->data[0].v_double);
  return g_strdup (d);
}

static gboolean
gst_value_deserialize_double (GValue * dest, const gchar * s)
{
  gdouble x;
  gboolean ret = FALSE;
  gchar *end;

  x = g_ascii_strtod (s, &end);
  if (*end == 0) {
    ret = TRUE;
  } else {
    if (g_ascii_strcasecmp (s, "min") == 0) {
      x = -G_MAXDOUBLE;
      ret = TRUE;
    } else if (g_ascii_strcasecmp (s, "max") == 0) {
      x = G_MAXDOUBLE;
      ret = TRUE;
    }
  }
  if (ret) {
    g_value_set_double (dest, x);
  }
  return ret;
}

/*********
 * float *
 *********/

static gint
gst_value_compare_float (const GValue * value1, const GValue * value2)
{
  if (value1->data[0].v_float > value2->data[0].v_float)
    return GST_VALUE_GREATER_THAN;
  if (value1->data[0].v_float < value2->data[0].v_float)
    return GST_VALUE_LESS_THAN;
  if (value1->data[0].v_float == value2->data[0].v_float)
    return GST_VALUE_EQUAL;
  return GST_VALUE_UNORDERED;
}

static gchar *
gst_value_serialize_float (const GValue * value)
{
  gchar d[G_ASCII_DTOSTR_BUF_SIZE];

  g_ascii_dtostr (d, G_ASCII_DTOSTR_BUF_SIZE, value->data[0].v_float);
  return g_strdup (d);
}

static gboolean
gst_value_deserialize_float (GValue * dest, const gchar * s)
{
  gdouble x;
  gboolean ret = FALSE;
  gchar *end;

  x = g_ascii_strtod (s, &end);
  if (*end == 0) {
    ret = TRUE;
  } else {
    if (g_ascii_strcasecmp (s, "min") == 0) {
      x = -G_MAXFLOAT;
      ret = TRUE;
    } else if (g_ascii_strcasecmp (s, "max") == 0) {
      x = G_MAXFLOAT;
      ret = TRUE;
    }
  }
  if (x > G_MAXFLOAT || x < -G_MAXFLOAT)
    ret = FALSE;
  if (ret) {
    g_value_set_float (dest, (float) x);
  }
  return ret;
}

/**********
 * string *
 **********/

static gint
gst_value_compare_string (const GValue * value1, const GValue * value2)
{
  if (G_UNLIKELY (!value1->data[0].v_pointer || !value2->data[0].v_pointer)) {
    /* if only one is NULL, no match - otherwise both NULL == EQUAL */
    if (value1->data[0].v_pointer != value2->data[0].v_pointer)
      return GST_VALUE_UNORDERED;
  } else {
    gint x = strcmp (value1->data[0].v_pointer, value2->data[0].v_pointer);

    if (x < 0)
      return GST_VALUE_LESS_THAN;
    if (x > 0)
      return GST_VALUE_GREATER_THAN;
  }

  return GST_VALUE_EQUAL;
}

static gint
gst_string_measure_wrapping (const gchar * s)
{
  gint len;
  gboolean wrap = FALSE;

  if (G_UNLIKELY (s == NULL))
    return -1;

  /* Special case: the actual string NULL needs wrapping */
  if (G_UNLIKELY (strcmp (s, "NULL") == 0))
    return 4;

  len = 0;
  while (*s) {
    if (GST_ASCII_IS_STRING (*s)) {
      len++;
    } else if (*s < 0x20 || *s >= 0x7f) {
      wrap = TRUE;
      len += 4;
    } else {
      wrap = TRUE;
      len += 2;
    }
    s++;
  }

  /* Wrap the string if we found something that needs
   * wrapping, or the empty string (len == 0) */
  return (wrap || len == 0) ? len : -1;
}

static gchar *
gst_string_wrap_inner (const gchar * s, gint len)
{
  gchar *d, *e;

  e = d = g_malloc (len + 3);

  *e++ = '\"';
  while (*s) {
    if (GST_ASCII_IS_STRING (*s)) {
      *e++ = *s++;
    } else if (*s < 0x20 || *s >= 0x7f) {
      *e++ = '\\';
      *e++ = '0' + ((*(guchar *) s) >> 6);
      *e++ = '0' + (((*s) >> 3) & 0x7);
      *e++ = '0' + ((*s++) & 0x7);
    } else {
      *e++ = '\\';
      *e++ = *s++;
    }
  }
  *e++ = '\"';
  *e = 0;

  g_assert (e - d <= len + 3);
  return d;
}

/* Do string wrapping/escaping */
static gchar *
gst_string_wrap (const gchar * s)
{
  gint len = gst_string_measure_wrapping (s);

  if (G_LIKELY (len < 0))
    return g_strdup (s);

  return gst_string_wrap_inner (s, len);
}

/* Same as above, but take ownership of the string */
static gchar *
gst_string_take_and_wrap (gchar * s)
{
  gchar *out;
  gint len = gst_string_measure_wrapping (s);

  if (G_LIKELY (len < 0))
    return s;

  out = gst_string_wrap_inner (s, len);
  g_free (s);

  return out;
}

/*
 * This function takes a string delimited with double quotes (")
 * and unescapes any \xxx octal numbers.
 *
 * If sequences of \y are found where y is not in the range of
 * 0->3, y is copied unescaped.
 *
 * If \xyy is found where x is an octal number but y is not, an
 * error is encountered and %NULL is returned.
 *
 * the input string must be \0 terminated.
 */
static gchar *
gst_string_unwrap (const gchar * s)
{
  gchar *ret;
  gchar *read, *write;

  /* NULL string returns NULL */
  if (s == NULL)
    return NULL;

  /* strings not starting with " are invalid */
  if (*s != '"')
    return NULL;

  /* make copy of original string to hold the result. This
   * string will always be smaller than the original */
  ret = g_strdup (s);
  read = ret;
  write = ret;

  /* need to move to the next position as we parsed the " */
  read++;

  while (*read) {
    if (GST_ASCII_IS_STRING (*read)) {
      /* normal chars are just copied */
      *write++ = *read++;
    } else if (*read == '"') {
      /* quote marks end of string */
      break;
    } else if (*read == '\\') {
      /* got an escape char, move to next position to read a tripplet
       * of octal numbers */
      read++;
      /* is the next char a possible first octal number? */
      if (*read >= '0' && *read <= '3') {
        /* parse other 2 numbers, if one of them is not in the range of
         * an octal number, we error. We also catch the case where a zero
         * byte is found here. */
        if (read[1] < '0' || read[1] > '7' || read[2] < '0' || read[2] > '7')
          goto beach;

        /* now convert the octal number to a byte again. */
        *write++ = ((read[0] - '0') << 6) +
            ((read[1] - '0') << 3) + (read[2] - '0');

        read += 3;
      } else {
        /* if we run into a \0 here, we definitely won't get a quote later */
        if (*read == 0)
          goto beach;

        /* else copy \X sequence */
        *write++ = *read++;
      }
    } else {
      /* weird character, error */
      goto beach;
    }
  }
  /* if the string is not ending in " and zero terminated, we error */
  if (*read != '"' || read[1] != '\0')
    goto beach;

  /* null terminate result string and return */
  *write = '\0';
  return ret;

beach:
  g_free (ret);
  return NULL;
}

static gchar *
gst_value_serialize_string (const GValue * value)
{
  return gst_string_wrap (value->data[0].v_pointer);
}

static gboolean
gst_value_deserialize_string (GValue * dest, const gchar * s)
{
  if (G_UNLIKELY (strcmp (s, "NULL") == 0)) {
    g_value_set_string (dest, NULL);
    return TRUE;
  } else if (G_LIKELY (*s != '"')) {
    if (!g_utf8_validate (s, -1, NULL))
      return FALSE;
    g_value_set_string (dest, s);
    return TRUE;
  } else {
    gchar *str = gst_string_unwrap (s);
    if (G_UNLIKELY (!str))
      return FALSE;
    g_value_take_string (dest, str);
  }

  return TRUE;
}

/********
 * enum *
 ********/

static gint
gst_value_compare_enum (const GValue * value1, const GValue * value2)
{
  GEnumValue *en1, *en2;
  GEnumClass *klass1 = (GEnumClass *) g_type_class_ref (G_VALUE_TYPE (value1));
  GEnumClass *klass2 = (GEnumClass *) g_type_class_ref (G_VALUE_TYPE (value2));

  g_return_val_if_fail (klass1, GST_VALUE_UNORDERED);
  g_return_val_if_fail (klass2, GST_VALUE_UNORDERED);
  en1 = g_enum_get_value (klass1, g_value_get_enum (value1));
  en2 = g_enum_get_value (klass2, g_value_get_enum (value2));
  g_type_class_unref (klass1);
  g_type_class_unref (klass2);
  g_return_val_if_fail (en1, GST_VALUE_UNORDERED);
  g_return_val_if_fail (en2, GST_VALUE_UNORDERED);
  if (en1->value < en2->value)
    return GST_VALUE_LESS_THAN;
  if (en1->value > en2->value)
    return GST_VALUE_GREATER_THAN;

  return GST_VALUE_EQUAL;
}

static gchar *
gst_value_serialize_enum (const GValue * value)
{
  GEnumValue *en;
  GEnumClass *klass = (GEnumClass *) g_type_class_ref (G_VALUE_TYPE (value));

  g_return_val_if_fail (klass, NULL);
  en = g_enum_get_value (klass, g_value_get_enum (value));
  g_type_class_unref (klass);

  /* might be one of the custom formats registered later */
  if (G_UNLIKELY (en == NULL && G_VALUE_TYPE (value) == GST_TYPE_FORMAT)) {
    const GstFormatDefinition *format_def;

    format_def = gst_format_get_details ((GstFormat) g_value_get_enum (value));
    g_return_val_if_fail (format_def != NULL, NULL);
    return g_strdup (format_def->description);
  }

  g_return_val_if_fail (en, NULL);
  return g_strdup (en->value_name);
}

static gint
gst_value_deserialize_enum_iter_cmp (const GValue * format_def_value,
    const gchar * s)
{
  const GstFormatDefinition *format_def =
      g_value_get_pointer (format_def_value);

  if (g_ascii_strcasecmp (s, format_def->nick) == 0)
    return 0;

  return g_ascii_strcasecmp (s, format_def->description);
}

static gboolean
gst_value_deserialize_enum (GValue * dest, const gchar * s)
{
  GEnumValue *en;
  gchar *endptr = NULL;
  GEnumClass *klass = (GEnumClass *) g_type_class_ref (G_VALUE_TYPE (dest));

  g_return_val_if_fail (klass, FALSE);
  if (!(en = g_enum_get_value_by_name (klass, s))) {
    if (!(en = g_enum_get_value_by_nick (klass, s))) {
      gint i = strtol (s, &endptr, 0);

      if (endptr && *endptr == '\0') {
        en = g_enum_get_value (klass, i);
      }
    }
  }
  g_type_class_unref (klass);

  /* might be one of the custom formats registered later */
  if (G_UNLIKELY (en == NULL && G_VALUE_TYPE (dest) == GST_TYPE_FORMAT)) {
    GValue res = { 0, };
    const GstFormatDefinition *format_def;
    GstIterator *iter;
    gboolean found;

    iter = gst_format_iterate_definitions ();

    found = gst_iterator_find_custom (iter,
        (GCompareFunc) gst_value_deserialize_enum_iter_cmp, &res, (gpointer) s);

    if (found) {
      format_def = g_value_get_pointer (&res);
      g_return_val_if_fail (format_def != NULL, FALSE);
      g_value_set_enum (dest, (gint) format_def->value);
      g_value_unset (&res);
    }
    gst_iterator_free (iter);
    return found;
  }

  /* enum name/nick not found */
  if (en == NULL)
    return FALSE;

  g_value_set_enum (dest, en->value);
  return TRUE;
}

/********
 * flags *
 ********/

/* we just compare the value here */
static gint
gst_value_compare_flags (const GValue * value1, const GValue * value2)
{
  guint fl1, fl2;
  GFlagsClass *klass1 =
      (GFlagsClass *) g_type_class_ref (G_VALUE_TYPE (value1));
  GFlagsClass *klass2 =
      (GFlagsClass *) g_type_class_ref (G_VALUE_TYPE (value2));

  g_return_val_if_fail (klass1, GST_VALUE_UNORDERED);
  g_return_val_if_fail (klass2, GST_VALUE_UNORDERED);
  fl1 = g_value_get_flags (value1);
  fl2 = g_value_get_flags (value2);
  g_type_class_unref (klass1);
  g_type_class_unref (klass2);
  if (fl1 < fl2)
    return GST_VALUE_LESS_THAN;
  if (fl1 > fl2)
    return GST_VALUE_GREATER_THAN;

  return GST_VALUE_EQUAL;
}

/* the different flags are serialized separated with a + */
static gchar *
gst_value_serialize_flags (const GValue * value)
{
  guint flags;
  GFlagsValue *fl;
  GFlagsClass *klass = (GFlagsClass *) g_type_class_ref (G_VALUE_TYPE (value));
  gchar *result, *tmp;
  gboolean first = TRUE;

  g_return_val_if_fail (klass, NULL);

  flags = g_value_get_flags (value);

  /* if no flags are set, try to serialize to the _NONE string */
  if (!flags) {
    fl = g_flags_get_first_value (klass, flags);
    if (fl)
      return g_strdup (fl->value_name);
    else
      return g_strdup ("0");
  }

  /* some flags are set, so serialize one by one */
  result = g_strdup ("");
  while (flags) {
    fl = g_flags_get_first_value (klass, flags);
    if (fl != NULL) {
      tmp = g_strconcat (result, (first ? "" : "+"), fl->value_name, NULL);
      g_free (result);
      result = tmp;
      first = FALSE;

      /* clear flag */
      flags &= ~fl->value;
    }
  }
  g_type_class_unref (klass);

  return result;
}

static gboolean
gst_value_deserialize_flags (GValue * dest, const gchar * s)
{
  GFlagsValue *fl;
  gchar *endptr = NULL;
  GFlagsClass *klass = (GFlagsClass *) g_type_class_ref (G_VALUE_TYPE (dest));
  gchar **split;
  guint flags;
  gint i;

  g_return_val_if_fail (klass, FALSE);

  /* split into parts delimited with + */
  split = g_strsplit (s, "+", 0);

  flags = 0;
  i = 0;
  /* loop over each part */
  while (split[i]) {
    if (!(fl = g_flags_get_value_by_name (klass, split[i]))) {
      if (!(fl = g_flags_get_value_by_nick (klass, split[i]))) {
        gint val = strtol (split[i], &endptr, 0);

        /* just or numeric value */
        if (endptr && *endptr == '\0') {
          flags |= val;
        }
      }
    }
    if (fl) {
      flags |= fl->value;
    }
    i++;
  }
  g_strfreev (split);
  g_type_class_unref (klass);
  g_value_set_flags (dest, flags);

  return TRUE;
}

/****************
 * subset *
 ****************/

static gboolean
gst_value_is_subset_int_range_int_range (const GValue * value1,
    const GValue * value2)
{
  gint gcd;

  g_return_val_if_fail (GST_VALUE_HOLDS_INT_RANGE (value1), FALSE);
  g_return_val_if_fail (GST_VALUE_HOLDS_INT_RANGE (value2), FALSE);

  if (INT_RANGE_MIN (value1) * INT_RANGE_STEP (value1) <
      INT_RANGE_MIN (value2) * INT_RANGE_STEP (value2))
    return FALSE;
  if (INT_RANGE_MAX (value1) * INT_RANGE_STEP (value1) >
      INT_RANGE_MAX (value2) * INT_RANGE_STEP (value2))
    return FALSE;

  if (INT_RANGE_MIN (value2) == INT_RANGE_MAX (value2)) {
    if ((INT_RANGE_MIN (value2) * INT_RANGE_STEP (value2)) %
        INT_RANGE_STEP (value1))
      return FALSE;
    return TRUE;
  }

  gcd =
      gst_util_greatest_common_divisor (INT_RANGE_STEP (value1),
      INT_RANGE_STEP (value2));
  if (gcd != MIN (INT_RANGE_STEP (value1), INT_RANGE_STEP (value2)))
    return FALSE;

  return TRUE;
}

static gboolean
gst_value_is_subset_int64_range_int64_range (const GValue * value1,
    const GValue * value2)
{
  gint64 gcd;

  g_return_val_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value1), FALSE);
  g_return_val_if_fail (GST_VALUE_HOLDS_INT64_RANGE (value2), FALSE);

  if (INT64_RANGE_MIN (value1) < INT64_RANGE_MIN (value2))
    return FALSE;
  if (INT64_RANGE_MAX (value1) > INT64_RANGE_MAX (value2))
    return FALSE;

  if (INT64_RANGE_MIN (value2) == INT64_RANGE_MAX (value2)) {
    if ((INT64_RANGE_MIN (value2) * INT64_RANGE_STEP (value2)) %
        INT64_RANGE_STEP (value1))
      return FALSE;
    return TRUE;
  }

  gcd =
      gst_util_greatest_common_divisor_int64 (INT64_RANGE_STEP (value1),
      INT64_RANGE_STEP (value2));
  if (gcd != MIN (INT64_RANGE_STEP (value1), INT64_RANGE_STEP (value2)))
    return FALSE;

  return TRUE;
}

/**
 * gst_value_is_subset:
 * @value1: a #GValue
 * @value2: a #GValue
 *
 * Check that @value1 is a subset of @value2.
 *
 * Return: %TRUE is @value1 is a subset of @value2
 */
gboolean
gst_value_is_subset (const GValue * value1, const GValue * value2)
{
  /* special case for int/int64 ranges, since we cannot compute
     the difference for those when they have different steps,
     and it's actually a lot simpler to compute whether a range
     is a subset of another. */
  if (GST_VALUE_HOLDS_INT_RANGE (value1) && GST_VALUE_HOLDS_INT_RANGE (value2)) {
    return gst_value_is_subset_int_range_int_range (value1, value2);
  } else if (GST_VALUE_HOLDS_INT64_RANGE (value1)
      && GST_VALUE_HOLDS_INT64_RANGE (value2)) {
    return gst_value_is_subset_int64_range_int64_range (value1, value2);
  }

  /*
   * 1 - [1,2] = empty
   * -> !subset
   *
   * [1,2] - 1 = 2
   *  -> 1 - [1,2] = empty
   *  -> subset
   *
   * [1,3] - [1,2] = 3
   * -> [1,2] - [1,3] = empty
   * -> subset
   *
   * {1,2} - {1,3} = 2
   * -> {1,3} - {1,2} = 3
   * -> !subset
   *
   *  First caps subtraction needs to return a non-empty set, second
   *  subtractions needs to give en empty set.
   *  Both substractions are switched below, as it's faster that way.
   */
  if (!gst_value_subtract (NULL, value1, value2)) {
    if (gst_value_subtract (NULL, value2, value1)) {
      return TRUE;
    }
  }
  return FALSE;
}

/*********
 * union *
 *********/

static gboolean
gst_value_union_int_int_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  gint v = src1->data[0].v_int;

  /* check if it's already in the range */
  if (INT_RANGE_MIN (src2) * INT_RANGE_STEP (src2) <= v &&
      INT_RANGE_MAX (src2) * INT_RANGE_STEP (src2) >= v &&
      v % INT_RANGE_STEP (src2) == 0) {
    if (dest)
      gst_value_init_and_copy (dest, src2);
    return TRUE;
  }

  /* check if it extends the range */
  if (v == (INT_RANGE_MIN (src2) - 1) * INT_RANGE_STEP (src2)) {
    if (dest) {
      guint64 new_min =
          (guint) ((INT_RANGE_MIN (src2) - 1) * INT_RANGE_STEP (src2));
      guint64 new_max = (guint) (INT_RANGE_MAX (src2) * INT_RANGE_STEP (src2));

      gst_value_init_and_copy (dest, src2);
      dest->data[0].v_uint64 = (new_min << 32) | (new_max);
    }
    return TRUE;
  }
  if (v == (INT_RANGE_MAX (src2) + 1) * INT_RANGE_STEP (src2)) {
    if (dest) {
      guint64 new_min = (guint) (INT_RANGE_MIN (src2) * INT_RANGE_STEP (src2));
      guint64 new_max =
          (guint) ((INT_RANGE_MAX (src2) + 1) * INT_RANGE_STEP (src2));

      gst_value_init_and_copy (dest, src2);
      dest->data[0].v_uint64 = (new_min << 32) | (new_max);
    }
    return TRUE;
  }

  return FALSE;
}

static gboolean
gst_value_union_int_range_int_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  /* We can union in several special cases:
     1 - one is a subset of another
     2 - same step and not disjoint
     3 - different step, at least one with one value which matches a 'next' or 'previous'
     - anything else ?
   */

  /* 1 - subset */
  if (gst_value_is_subset_int_range_int_range (src1, src2)) {
    if (dest)
      gst_value_init_and_copy (dest, src2);
    return TRUE;
  }
  if (gst_value_is_subset_int_range_int_range (src2, src1)) {
    if (dest)
      gst_value_init_and_copy (dest, src1);
    return TRUE;
  }

  /* 2 - same step and not disjoint */
  if (INT_RANGE_STEP (src1) == INT_RANGE_STEP (src2)) {
    if ((INT_RANGE_MIN (src1) <= INT_RANGE_MAX (src2) + 1 &&
            INT_RANGE_MAX (src1) >= INT_RANGE_MIN (src2) - 1) ||
        (INT_RANGE_MIN (src2) <= INT_RANGE_MAX (src1) + 1 &&
            INT_RANGE_MAX (src2) >= INT_RANGE_MIN (src1) - 1)) {
      if (dest) {
        gint step = INT_RANGE_STEP (src1);
        gint min = step * MIN (INT_RANGE_MIN (src1), INT_RANGE_MIN (src2));
        gint max = step * MAX (INT_RANGE_MAX (src1), INT_RANGE_MAX (src2));
        g_value_init (dest, GST_TYPE_INT_RANGE);
        gst_value_set_int_range_step (dest, min, max, step);
      }
      return TRUE;
    }
  }

  /* 3 - single value matches next or previous */
  if (INT_RANGE_STEP (src1) != INT_RANGE_STEP (src2)) {
    gint n1 = INT_RANGE_MAX (src1) - INT_RANGE_MIN (src1) + 1;
    gint n2 = INT_RANGE_MAX (src2) - INT_RANGE_MIN (src2) + 1;
    if (n1 == 1 || n2 == 1) {
      const GValue *range_value = NULL;
      gint scalar = 0;
      if (n1 == 1) {
        range_value = src2;
        scalar = INT_RANGE_MIN (src1) * INT_RANGE_STEP (src1);
      } else if (n2 == 1) {
        range_value = src1;
        scalar = INT_RANGE_MIN (src2) * INT_RANGE_STEP (src2);
      }

      if (scalar ==
          (INT_RANGE_MIN (range_value) - 1) * INT_RANGE_STEP (range_value)) {
        if (dest) {
          guint64 new_min = (guint)
              ((INT_RANGE_MIN (range_value) -
                  1) * INT_RANGE_STEP (range_value));
          guint64 new_max = (guint)
              (INT_RANGE_MAX (range_value) * INT_RANGE_STEP (range_value));

          gst_value_init_and_copy (dest, range_value);
          dest->data[0].v_uint64 = (new_min << 32) | (new_max);
        }
        return TRUE;
      } else if (scalar ==
          (INT_RANGE_MAX (range_value) + 1) * INT_RANGE_STEP (range_value)) {
        if (dest) {
          guint64 new_min = (guint)
              (INT_RANGE_MIN (range_value) * INT_RANGE_STEP (range_value));
          guint64 new_max = (guint)
              ((INT_RANGE_MAX (range_value) +
                  1) * INT_RANGE_STEP (range_value));
          gst_value_init_and_copy (dest, range_value);
          dest->data[0].v_uint64 = (new_min << 32) | (new_max);
        }
        return TRUE;
      }
    }
  }

  /* If we get there, we did not find a way to make a union that can be
     represented with our simplistic model. */
  return FALSE;
}

/****************
 * intersection *
 ****************/

static gboolean
gst_value_intersect_int_int_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  if (INT_RANGE_MIN (src2) * INT_RANGE_STEP (src2) <= src1->data[0].v_int &&
      INT_RANGE_MAX (src2) * INT_RANGE_STEP (src2) >= src1->data[0].v_int &&
      src1->data[0].v_int % INT_RANGE_STEP (src2) == 0) {
    if (dest)
      gst_value_init_and_copy (dest, src1);
    return TRUE;
  }

  return FALSE;
}

static gboolean
gst_value_intersect_int_range_int_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  gint min;
  gint max;
  gint step;

  step =
      INT_RANGE_STEP (src1) /
      gst_util_greatest_common_divisor (INT_RANGE_STEP (src1),
      INT_RANGE_STEP (src2));
  if (G_MAXINT32 / INT_RANGE_STEP (src2) < step)
    return FALSE;
  step *= INT_RANGE_STEP (src2);

  min =
      MAX (INT_RANGE_MIN (src1) * INT_RANGE_STEP (src1),
      INT_RANGE_MIN (src2) * INT_RANGE_STEP (src2));
  min = (min + step - 1) / step * step;
  max =
      MIN (INT_RANGE_MAX (src1) * INT_RANGE_STEP (src1),
      INT_RANGE_MAX (src2) * INT_RANGE_STEP (src2));
  max = max / step * step;

  if (min < max) {
    if (dest) {
      g_value_init (dest, GST_TYPE_INT_RANGE);
      gst_value_set_int_range_step (dest, min, max, step);
    }
    return TRUE;
  }
  if (min == max) {
    if (dest) {
      g_value_init (dest, G_TYPE_INT);
      g_value_set_int (dest, min);
    }
    return TRUE;
  }

  return FALSE;
}

#define INT64_RANGE_MIN_VAL(v) (INT64_RANGE_MIN (v) * INT64_RANGE_STEP (v))
#define INT64_RANGE_MAX_VAL(v) (INT64_RANGE_MAX (v) * INT64_RANGE_STEP (v))

static gboolean
gst_value_intersect_int64_int64_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  if (INT64_RANGE_MIN_VAL (src2) <= src1->data[0].v_int64 &&
      INT64_RANGE_MAX_VAL (src2) >= src1->data[0].v_int64 &&
      src1->data[0].v_int64 % INT64_RANGE_STEP (src2) == 0) {
    if (dest)
      gst_value_init_and_copy (dest, src1);
    return TRUE;
  }

  return FALSE;
}

static gboolean
gst_value_intersect_int64_range_int64_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  gint64 min;
  gint64 max;
  gint64 step;

  step =
      INT64_RANGE_STEP (src1) /
      gst_util_greatest_common_divisor_int64 (INT64_RANGE_STEP (src1),
      INT64_RANGE_STEP (src2));
  if (G_MAXINT64 / INT64_RANGE_STEP (src2) < step)
    return FALSE;
  step *= INT64_RANGE_STEP (src2);

  min =
      MAX (INT64_RANGE_MIN (src1) * INT64_RANGE_STEP (src1),
      INT64_RANGE_MIN (src2) * INT64_RANGE_STEP (src2));
  min = (min + step - 1) / step * step;
  max =
      MIN (INT64_RANGE_MAX (src1) * INT64_RANGE_STEP (src1),
      INT64_RANGE_MAX (src2) * INT64_RANGE_STEP (src2));
  max = max / step * step;

  if (min < max) {
    if (dest) {
      g_value_init (dest, GST_TYPE_INT64_RANGE);
      gst_value_set_int64_range_step (dest, min, max, step);
    }
    return TRUE;
  }
  if (min == max) {
    if (dest) {
      g_value_init (dest, G_TYPE_INT64);
      g_value_set_int64 (dest, min);
    }
    return TRUE;
  }

  return FALSE;
}

static gboolean
gst_value_intersect_double_double_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  if (src2->data[0].v_double <= src1->data[0].v_double &&
      src2->data[1].v_double >= src1->data[0].v_double) {
    if (dest)
      gst_value_init_and_copy (dest, src1);
    return TRUE;
  }

  return FALSE;
}

static gboolean
gst_value_intersect_double_range_double_range (GValue * dest,
    const GValue * src1, const GValue * src2)
{
  gdouble min;
  gdouble max;

  min = MAX (src1->data[0].v_double, src2->data[0].v_double);
  max = MIN (src1->data[1].v_double, src2->data[1].v_double);

  if (min < max) {
    if (dest) {
      g_value_init (dest, GST_TYPE_DOUBLE_RANGE);
      gst_value_set_double_range (dest, min, max);
    }
    return TRUE;
  }
  if (min == max) {
    if (dest) {
      g_value_init (dest, G_TYPE_DOUBLE);
      g_value_set_int (dest, (int) min);
    }
    return TRUE;
  }

  return FALSE;
}

static gboolean
gst_value_intersect_list (GValue * dest, const GValue * value1,
    const GValue * value2)
{
  guint i, size;
  GValue intersection = { 0, };
  gboolean ret = FALSE;

  size = VALUE_LIST_SIZE (value1);
  for (i = 0; i < size; i++) {
    const GValue *cur = VALUE_LIST_GET_VALUE (value1, i);

    /* quicker version when we don't need the resulting set */
    if (!dest) {
      if (gst_value_intersect (NULL, cur, value2)) {
        ret = TRUE;
        break;
      }
      continue;
    }

    if (gst_value_intersect (&intersection, cur, value2)) {
      /* append value */
      if (!ret) {
        gst_value_move (dest, &intersection);
        ret = TRUE;
      } else if (GST_VALUE_HOLDS_LIST (dest)) {
        _gst_value_list_append_and_take_value (dest, &intersection);
      } else {
        GValue temp;

        gst_value_move (&temp, dest);
        gst_value_list_merge (dest, &temp, &intersection);
        g_value_unset (&temp);
        g_value_unset (&intersection);
      }
    }
  }

  return ret;
}

static gboolean
gst_value_intersect_array (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  guint size;
  guint n;
  GValue val = { 0 };

  /* only works on similar-sized arrays */
  size = gst_value_array_get_size (src1);
  if (size != gst_value_array_get_size (src2))
    return FALSE;

  /* quicker value when we don't need the resulting set */
  if (!dest) {
    for (n = 0; n < size; n++) {
      if (!gst_value_intersect (NULL, gst_value_array_get_value (src1, n),
              gst_value_array_get_value (src2, n))) {
        return FALSE;
      }
    }
    return TRUE;
  }

  g_value_init (dest, GST_TYPE_ARRAY);

  for (n = 0; n < size; n++) {
    if (!gst_value_intersect (&val, gst_value_array_get_value (src1, n),
            gst_value_array_get_value (src2, n))) {
      g_value_unset (dest);
      return FALSE;
    }
    _gst_value_array_append_and_take_value (dest, &val);
  }

  return TRUE;
}

static gboolean
gst_value_intersect_fraction_fraction_range (GValue * dest, const GValue * src1,
    const GValue * src2)
{
  gint res1, res2;
  GValue *vals;
  GstValueCompareFunc compare;

  vals = src2->data[0].v_pointer;

  if (vals == NULL)
    return FALSE;

  if ((compare = gst_value_get_compare_func (src1))) {
    res1 = gst_value_compare_with_func (&vals[0], src1, compare);
    res2 = gst_value_compare_with_func (&vals[1], src1, compare);

    if ((res1 == GST_VALUE_EQUAL || res1 == GST_VALUE_LESS_THAN) &&
        (res2 == GST_VALUE_EQUAL || res2 == GST_VALUE_GREATER_THAN)) {
      if (dest)
        gst_value_init_and_copy (dest, src1);
      return TRUE;
    }
  }

  return FALSE;
}

static gboolean
gst_value_intersect_fraction_range_fraction_range (GValue * dest,
    const GValue * src1, const GValue * src2)
{
  GValue *min;
  GValue *max;
  gint res;
  GValue *vals1, *vals2;
  GstValueCompareFunc compare;

  vals1 = src1->data[0].v_pointer;
  vals2 = src2->data[0].v_pointer;
  g_return_val_if_fail (vals1 != NULL && vals2 != NULL, FALSE);

  if ((compare = gst_value_get_compare_func (&vals1[0]))) {
    /* min = MAX (src1.start, src2.start) */
    res = gst_value_compare_with_func (&vals1[0], &vals2[0], compare);
    g_return_val_if_fail (res != GST_VALUE_UNORDERED, FALSE);
    if (res == GST_VALUE_LESS_THAN)
      min = &vals2[0];          /* Take the max of the 2 */
    else
      min = &vals1[0];

    /* max = MIN (src1.end, src2.end) */
    res = gst_value_compare_with_func (&vals1[1], &vals2[1], compare);
    g_return_val_if_fail (res != GST_VALUE_UNORDERED, FALSE);
    if (res == GST_VALUE_GREATER_THAN)
      max = &vals2[1];          /* Take the min of the 2 */
    else
      max = &vals1[1];

    res = gst_value_compare_with_func (min, max, compare);
    g_return_val_if_fail (res != GST_VALUE_UNORDERED, FALSE);
    if (res == GST_VALUE_LESS_THAN) {
      if (dest) {
        g_value_init (dest, GST_TYPE_FRACTION_RANGE);
        vals1 = dest->data[0].v_pointer;
        g_value_copy (min, &vals1[0]);
        g_value_copy (max, &vals1[1]);
      }
      return TRUE;
    }
    if (res == GST_VALUE_EQUAL) {
      if (dest)
        gst_value_init_and_copy (dest, min);
      return TRUE;
    }
  }

  return FALSE;
}

/***************
 * subtraction *
 ***************/

static gboolean
gst_value_subtract_int_int_range (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gint min = gst_value_get_int_range_min (subtrahend);
  gint max = gst_value_get_int_range_max (subtrahend);
  gint step = gst_value_get_int_range_step (subtrahend);
  gint val = g_value_get_int (minuend);

  if (step == 0)
    return FALSE;

  /* subtracting a range from an int only works if the int is not in the
   * range */
  if (val < min || val > max || val % step) {
    /* and the result is the int */
    if (dest)
      gst_value_init_and_copy (dest, minuend);
    return TRUE;
  }
  return FALSE;
}

/* creates a new int range based on input values.
 */
static gboolean
gst_value_create_new_range (GValue * dest, gint min1, gint max1, gint min2,
    gint max2, gint step)
{
  GValue v1 = { 0, };
  GValue v2 = { 0, };
  GValue *pv1, *pv2;            /* yeah, hungarian! */

  g_return_val_if_fail (step > 0, FALSE);
  g_return_val_if_fail (min1 % step == 0, FALSE);
  g_return_val_if_fail (max1 % step == 0, FALSE);
  g_return_val_if_fail (min2 % step == 0, FALSE);
  g_return_val_if_fail (max2 % step == 0, FALSE);

  if (min1 <= max1 && min2 <= max2) {
    pv1 = &v1;
    pv2 = &v2;
  } else if (min1 <= max1) {
    pv1 = dest;
    pv2 = NULL;
  } else if (min2 <= max2) {
    pv1 = NULL;
    pv2 = dest;
  } else {
    return FALSE;
  }

  if (!dest)
    return TRUE;

  if (min1 < max1) {
    g_value_init (pv1, GST_TYPE_INT_RANGE);
    gst_value_set_int_range_step (pv1, min1, max1, step);
  } else if (min1 == max1) {
    g_value_init (pv1, G_TYPE_INT);
    g_value_set_int (pv1, min1);
  }
  if (min2 < max2) {
    g_value_init (pv2, GST_TYPE_INT_RANGE);
    gst_value_set_int_range_step (pv2, min2, max2, step);
  } else if (min2 == max2) {
    g_value_init (pv2, G_TYPE_INT);
    g_value_set_int (pv2, min2);
  }

  if (min1 <= max1 && min2 <= max2) {
    gst_value_list_concat_and_take_values (dest, pv1, pv2);
  }
  return TRUE;
}

static gboolean
gst_value_subtract_int_range_int (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gint min = gst_value_get_int_range_min (minuend);
  gint max = gst_value_get_int_range_max (minuend);
  gint step = gst_value_get_int_range_step (minuend);
  gint val = g_value_get_int (subtrahend);

  g_return_val_if_fail (min < max, FALSE);

  if (step == 0)
    return FALSE;

  /* value is outside of the range, return range unchanged */
  if (val < min || val > max || val % step) {
    if (dest)
      gst_value_init_and_copy (dest, minuend);
    return TRUE;
  } else {
    /* max must be MAXINT too as val <= max */
    if (val >= G_MAXINT - step + 1) {
      max -= step;
      val -= step;
    }
    /* min must be MININT too as val >= max */
    if (val <= G_MININT + step - 1) {
      min += step;
      val += step;
    }
    if (dest)
      gst_value_create_new_range (dest, min, val - step, val + step, max, step);
  }
  return TRUE;
}

static gboolean
gst_value_subtract_int_range_int_range (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gint min1 = gst_value_get_int_range_min (minuend);
  gint max1 = gst_value_get_int_range_max (minuend);
  gint step1 = gst_value_get_int_range_step (minuend);
  gint min2 = gst_value_get_int_range_min (subtrahend);
  gint max2 = gst_value_get_int_range_max (subtrahend);
  gint step2 = gst_value_get_int_range_step (subtrahend);
  gint step;

  if (step1 != step2) {
    /* ENOIMPL */
    g_assert (FALSE);
    return FALSE;
  }
  step = step1;

  if (step == 0)
    return FALSE;

  if (max2 >= max1 && min2 <= min1) {
    return FALSE;
  } else if (max2 >= max1) {
    return gst_value_create_new_range (dest, min1, MIN (min2 - step, max1),
        step, 0, step);
  } else if (min2 <= min1) {
    return gst_value_create_new_range (dest, MAX (max2 + step, min1), max1,
        step, 0, step);
  } else {
    return gst_value_create_new_range (dest, min1, MIN (min2 - step, max1),
        MAX (max2 + step, min1), max1, step);
  }
}

static gboolean
gst_value_subtract_int64_int64_range (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gint64 min = gst_value_get_int64_range_min (subtrahend);
  gint64 max = gst_value_get_int64_range_max (subtrahend);
  gint64 step = gst_value_get_int64_range_step (subtrahend);
  gint64 val = g_value_get_int64 (minuend);

  if (step == 0)
    return FALSE;
  /* subtracting a range from an int64 only works if the int64 is not in the
   * range */
  if (val < min || val > max || val % step) {
    /* and the result is the int64 */
    if (dest)
      gst_value_init_and_copy (dest, minuend);
    return TRUE;
  }
  return FALSE;
}

/* creates a new int64 range based on input values.
 */
static gboolean
gst_value_create_new_int64_range (GValue * dest, gint64 min1, gint64 max1,
    gint64 min2, gint64 max2, gint64 step)
{
  GValue v1 = { 0, };
  GValue v2 = { 0, };
  GValue *pv1, *pv2;            /* yeah, hungarian! */

  g_return_val_if_fail (step > 0, FALSE);
  g_return_val_if_fail (min1 % step == 0, FALSE);
  g_return_val_if_fail (max1 % step == 0, FALSE);
  g_return_val_if_fail (min2 % step == 0, FALSE);
  g_return_val_if_fail (max2 % step == 0, FALSE);

  if (min1 <= max1 && min2 <= max2) {
    pv1 = &v1;
    pv2 = &v2;
  } else if (min1 <= max1) {
    pv1 = dest;
    pv2 = NULL;
  } else if (min2 <= max2) {
    pv1 = NULL;
    pv2 = dest;
  } else {
    return FALSE;
  }

  if (!dest)
    return TRUE;

  if (min1 < max1) {
    g_value_init (pv1, GST_TYPE_INT64_RANGE);
    gst_value_set_int64_range_step (pv1, min1, max1, step);
  } else if (min1 == max1) {
    g_value_init (pv1, G_TYPE_INT64);
    g_value_set_int64 (pv1, min1);
  }
  if (min2 < max2) {
    g_value_init (pv2, GST_TYPE_INT64_RANGE);
    gst_value_set_int64_range_step (pv2, min2, max2, step);
  } else if (min2 == max2) {
    g_value_init (pv2, G_TYPE_INT64);
    g_value_set_int64 (pv2, min2);
  }

  if (min1 <= max1 && min2 <= max2) {
    gst_value_list_concat_and_take_values (dest, pv1, pv2);
  }
  return TRUE;
}

static gboolean
gst_value_subtract_int64_range_int64 (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gint64 min = gst_value_get_int64_range_min (minuend);
  gint64 max = gst_value_get_int64_range_max (minuend);
  gint64 step = gst_value_get_int64_range_step (minuend);
  gint64 val = g_value_get_int64 (subtrahend);

  g_return_val_if_fail (min < max, FALSE);

  if (step == 0)
    return FALSE;

  /* value is outside of the range, return range unchanged */
  if (val < min || val > max || val % step) {
    if (dest)
      gst_value_init_and_copy (dest, minuend);
    return TRUE;
  } else {
    /* max must be MAXINT64 too as val <= max */
    if (val >= G_MAXINT64 - step + 1) {
      max -= step;
      val -= step;
    }
    /* min must be MININT64 too as val >= max */
    if (val <= G_MININT64 + step - 1) {
      min += step;
      val += step;
    }
    if (dest)
      gst_value_create_new_int64_range (dest, min, val - step, val + step, max,
          step);
  }
  return TRUE;
}

static gboolean
gst_value_subtract_int64_range_int64_range (GValue * dest,
    const GValue * minuend, const GValue * subtrahend)
{
  gint64 min1 = gst_value_get_int64_range_min (minuend);
  gint64 max1 = gst_value_get_int64_range_max (minuend);
  gint64 step1 = gst_value_get_int64_range_step (minuend);
  gint64 min2 = gst_value_get_int64_range_min (subtrahend);
  gint64 max2 = gst_value_get_int64_range_max (subtrahend);
  gint64 step2 = gst_value_get_int64_range_step (subtrahend);
  gint64 step;

  if (step1 != step2) {
    /* ENOIMPL */
    g_assert (FALSE);
    return FALSE;
  }

  if (step1 == 0)
    return FALSE;

  step = step1;

  if (max2 >= max1 && min2 <= min1) {
    return FALSE;
  } else if (max2 >= max1) {
    return gst_value_create_new_int64_range (dest, min1, MIN (min2 - step,
            max1), step, 0, step);
  } else if (min2 <= min1) {
    return gst_value_create_new_int64_range (dest, MAX (max2 + step, min1),
        max1, step, 0, step);
  } else {
    return gst_value_create_new_int64_range (dest, min1, MIN (min2 - step,
            max1), MAX (max2 + step, min1), max1, step);
  }
}

static gboolean
gst_value_subtract_double_double_range (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gdouble min = gst_value_get_double_range_min (subtrahend);
  gdouble max = gst_value_get_double_range_max (subtrahend);
  gdouble val = g_value_get_double (minuend);

  if (val < min || val > max) {
    if (dest)
      gst_value_init_and_copy (dest, minuend);
    return TRUE;
  }
  return FALSE;
}

static gboolean
gst_value_subtract_double_range_double (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  /* since we don't have open ranges, we cannot create a hole in
   * a double range. We return the original range */
  if (dest)
    gst_value_init_and_copy (dest, minuend);
  return TRUE;
}

static gboolean
gst_value_subtract_double_range_double_range (GValue * dest,
    const GValue * minuend, const GValue * subtrahend)
{
  /* since we don't have open ranges, we have to approximate */
  /* done like with ints */
  gdouble min1 = gst_value_get_double_range_min (minuend);
  gdouble max2 = gst_value_get_double_range_max (minuend);
  gdouble max1 = MIN (gst_value_get_double_range_min (subtrahend), max2);
  gdouble min2 = MAX (gst_value_get_double_range_max (subtrahend), min1);
  GValue v1 = { 0, };
  GValue v2 = { 0, };
  GValue *pv1, *pv2;            /* yeah, hungarian! */

  if (min1 < max1 && min2 < max2) {
    pv1 = &v1;
    pv2 = &v2;
  } else if (min1 < max1) {
    pv1 = dest;
    pv2 = NULL;
  } else if (min2 < max2) {
    pv1 = NULL;
    pv2 = dest;
  } else {
    return FALSE;
  }

  if (!dest)
    return TRUE;

  if (min1 < max1) {
    g_value_init (pv1, GST_TYPE_DOUBLE_RANGE);
    gst_value_set_double_range (pv1, min1, max1);
  }
  if (min2 < max2) {
    g_value_init (pv2, GST_TYPE_DOUBLE_RANGE);
    gst_value_set_double_range (pv2, min2, max2);
  }

  if (min1 < max1 && min2 < max2) {
    gst_value_list_concat_and_take_values (dest, pv1, pv2);
  }
  return TRUE;
}

static gboolean
gst_value_subtract_from_list (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  guint i, size;
  GValue subtraction = { 0, };
  gboolean ret = FALSE;

  size = VALUE_LIST_SIZE (minuend);
  for (i = 0; i < size; i++) {
    const GValue *cur = VALUE_LIST_GET_VALUE (minuend, i);

    /* quicker version when we can discard the result */
    if (!dest) {
      if (gst_value_subtract (NULL, cur, subtrahend)) {
        ret = TRUE;
        break;
      }
      continue;
    }

    if (gst_value_subtract (&subtraction, cur, subtrahend)) {
      if (!ret) {
        gst_value_move (dest, &subtraction);
        ret = TRUE;
      } else if (G_VALUE_TYPE (dest) == GST_TYPE_LIST
          && G_VALUE_TYPE (&subtraction) != GST_TYPE_LIST) {
        _gst_value_list_append_and_take_value (dest, &subtraction);
      } else {
        GValue temp;

        gst_value_move (&temp, dest);
        gst_value_list_concat_and_take_values (dest, &temp, &subtraction);
      }
    }
  }
  return ret;
}

static gboolean
gst_value_subtract_list (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  guint i, size;
  GValue data[2] = { {0,}, {0,} };
  GValue *subtraction = &data[0], *result = &data[1];

  gst_value_init_and_copy (result, minuend);
  size = VALUE_LIST_SIZE (subtrahend);
  for (i = 0; i < size; i++) {
    const GValue *cur = VALUE_LIST_GET_VALUE (subtrahend, i);

    if (gst_value_subtract (subtraction, result, cur)) {
      GValue *temp = result;

      result = subtraction;
      subtraction = temp;
      g_value_unset (subtraction);
    } else {
      g_value_unset (result);
      return FALSE;
    }
  }
  if (dest) {
    gst_value_move (dest, result);
  } else {
    g_value_unset (result);
  }
  return TRUE;
}

static gboolean
gst_value_subtract_fraction_fraction_range (GValue * dest,
    const GValue * minuend, const GValue * subtrahend)
{
  const GValue *min = gst_value_get_fraction_range_min (subtrahend);
  const GValue *max = gst_value_get_fraction_range_max (subtrahend);
  GstValueCompareFunc compare;

  if ((compare = gst_value_get_compare_func (minuend))) {
    /* subtracting a range from an fraction only works if the fraction
     * is not in the range */
    if (gst_value_compare_with_func (minuend, min, compare) ==
        GST_VALUE_LESS_THAN ||
        gst_value_compare_with_func (minuend, max, compare) ==
        GST_VALUE_GREATER_THAN) {
      /* and the result is the value */
      if (dest)
        gst_value_init_and_copy (dest, minuend);
      return TRUE;
    }
  }
  return FALSE;
}

static gboolean
gst_value_subtract_fraction_range_fraction (GValue * dest,
    const GValue * minuend, const GValue * subtrahend)
{
  /* since we don't have open ranges, we cannot create a hole in
   * a range. We return the original range */
  if (dest)
    gst_value_init_and_copy (dest, minuend);
  return TRUE;
}

static gboolean
gst_value_subtract_fraction_range_fraction_range (GValue * dest,
    const GValue * minuend, const GValue * subtrahend)
{
  /* since we don't have open ranges, we have to approximate */
  /* done like with ints and doubles. Creates a list of 2 fraction ranges */
  const GValue *min1 = gst_value_get_fraction_range_min (minuend);
  const GValue *max2 = gst_value_get_fraction_range_max (minuend);
  const GValue *max1 = gst_value_get_fraction_range_min (subtrahend);
  const GValue *min2 = gst_value_get_fraction_range_max (subtrahend);
  gint cmp1, cmp2;
  GValue v1 = { 0, };
  GValue v2 = { 0, };
  GValue *pv1, *pv2;            /* yeah, hungarian! */
  GstValueCompareFunc compare;

  g_return_val_if_fail (min1 != NULL && max1 != NULL, FALSE);
  g_return_val_if_fail (min2 != NULL && max2 != NULL, FALSE);

  compare = gst_value_get_compare_func (min1);
  g_return_val_if_fail (compare, FALSE);

  cmp1 = gst_value_compare_with_func (max2, max1, compare);
  g_return_val_if_fail (cmp1 != GST_VALUE_UNORDERED, FALSE);
  if (cmp1 == GST_VALUE_LESS_THAN)
    max1 = max2;
  cmp1 = gst_value_compare_with_func (min1, min2, compare);
  g_return_val_if_fail (cmp1 != GST_VALUE_UNORDERED, FALSE);
  if (cmp1 == GST_VALUE_GREATER_THAN)
    min2 = min1;

  cmp1 = gst_value_compare_with_func (min1, max1, compare);
  cmp2 = gst_value_compare_with_func (min2, max2, compare);

  if (cmp1 == GST_VALUE_LESS_THAN && cmp2 == GST_VALUE_LESS_THAN) {
    pv1 = &v1;
    pv2 = &v2;
  } else if (cmp1 == GST_VALUE_LESS_THAN) {
    pv1 = dest;
    pv2 = NULL;
  } else if (cmp2 == GST_VALUE_LESS_THAN) {
    pv1 = NULL;
    pv2 = dest;
  } else {
    return FALSE;
  }

  if (!dest)
    return TRUE;

  if (cmp1 == GST_VALUE_LESS_THAN) {
    g_value_init (pv1, GST_TYPE_FRACTION_RANGE);
    gst_value_set_fraction_range (pv1, min1, max1);
  }
  if (cmp2 == GST_VALUE_LESS_THAN) {
    g_value_init (pv2, GST_TYPE_FRACTION_RANGE);
    gst_value_set_fraction_range (pv2, min2, max2);
  }

  if (cmp1 == GST_VALUE_LESS_THAN && cmp2 == GST_VALUE_LESS_THAN) {
    gst_value_list_concat_and_take_values (dest, pv1, pv2);
  }
  return TRUE;
}


/**************
 * comparison *
 **************/

/*
 * gst_value_get_compare_func:
 * @value1: a value to get the compare function for
 *
 * Determines the compare function to be used with values of the same type as
 * @value1. The function can be given to gst_value_compare_with_func().
 *
 * Returns: A #GstValueCompareFunc value
 */
static GstValueCompareFunc
gst_value_get_compare_func (const GValue * value1)
{
  GstValueTable *table, *best = NULL;
  guint i;
  GType type1;

  type1 = G_VALUE_TYPE (value1);

  /* this is a fast check */
  best = gst_value_hash_lookup_type (type1);

  /* slower checks */
  if (G_UNLIKELY (!best || !best->compare)) {
    guint len = gst_value_table->len;

    best = NULL;
    for (i = 0; i < len; i++) {
      table = &g_array_index (gst_value_table, GstValueTable, i);
      if (table->compare && g_type_is_a (type1, table->type)) {
        if (!best || g_type_is_a (table->type, best->type))
          best = table;
      }
    }
  }
  if (G_LIKELY (best))
    return best->compare;

  return NULL;
}

static inline gboolean
gst_value_can_compare_unchecked (const GValue * value1, const GValue * value2)
{
  if (G_VALUE_TYPE (value1) != G_VALUE_TYPE (value2))
    return FALSE;

  return gst_value_get_compare_func (value1) != NULL;
}

/**
 * gst_value_can_compare:
 * @value1: a value to compare
 * @value2: another value to compare
 *
 * Determines if @value1 and @value2 can be compared.
 *
 * Returns: %TRUE if the values can be compared
 */
gboolean
gst_value_can_compare (const GValue * value1, const GValue * value2)
{
  g_return_val_if_fail (G_IS_VALUE (value1), FALSE);
  g_return_val_if_fail (G_IS_VALUE (value2), FALSE);

  return gst_value_can_compare_unchecked (value1, value2);
}

static gboolean
gst_value_list_equals_range (const GValue * list, const GValue * value)
{
  const GValue *first;
  guint list_size, n;

  g_assert (G_IS_VALUE (list));
  g_assert (G_IS_VALUE (value));
  g_assert (GST_VALUE_HOLDS_LIST (list));

  /* TODO: compare against an empty list ? No type though... */
  list_size = VALUE_LIST_SIZE (list);
  if (list_size == 0)
    return FALSE;

  /* compare the basic types - they have to match */
  first = VALUE_LIST_GET_VALUE (list, 0);
#define CHECK_TYPES(type,prefix) \
  (prefix##_VALUE_HOLDS_##type(first) && GST_VALUE_HOLDS_##type##_RANGE (value))
  if (CHECK_TYPES (INT, G)) {
    const gint rmin = gst_value_get_int_range_min (value);
    const gint rmax = gst_value_get_int_range_max (value);
    const gint rstep = gst_value_get_int_range_step (value);
    if (rstep == 0)
      return FALSE;
    /* note: this will overflow for min 0 and max INT_MAX, but this
       would only be equal to a list of INT_MAX elements, which seems
       very unlikely */
    if (list_size != rmax / rstep - rmin / rstep + 1)
      return FALSE;
    for (n = 0; n < list_size; ++n) {
      gint v = g_value_get_int (VALUE_LIST_GET_VALUE (list, n));
      if (v < rmin || v > rmax || v % rstep) {
        return FALSE;
      }
    }
    return TRUE;
  } else if (CHECK_TYPES (INT64, G)) {
    const gint64 rmin = gst_value_get_int64_range_min (value);
    const gint64 rmax = gst_value_get_int64_range_max (value);
    const gint64 rstep = gst_value_get_int64_range_step (value);
    GST_DEBUG ("List/range of int64s");
    if (rstep == 0)
      return FALSE;
    if (list_size != rmax / rstep - rmin / rstep + 1)
      return FALSE;
    for (n = 0; n < list_size; ++n) {
      gint64 v = g_value_get_int64 (VALUE_LIST_GET_VALUE (list, n));
      if (v < rmin || v > rmax || v % rstep)
        return FALSE;
    }
    return TRUE;
  }
#undef CHECK_TYPES

  /* other combinations don't make sense for equality */
  return FALSE;
}

/* "Pure" variant of gst_value_compare which is guaranteed to
 * not have list arguments and therefore does basic comparisions
 */
static inline gint
_gst_value_compare_nolist (const GValue * value1, const GValue * value2)
{
  GstValueCompareFunc compare;

  if (G_VALUE_TYPE (value1) != G_VALUE_TYPE (value2))
    return GST_VALUE_UNORDERED;

  compare = gst_value_get_compare_func (value1);
  if (compare) {
    return compare (value1, value2);
  }

  g_critical ("unable to compare values of type %s\n",
      g_type_name (G_VALUE_TYPE (value1)));
  return GST_VALUE_UNORDERED;
}

/**
 * gst_value_compare:
 * @value1: a value to compare
 * @value2: another value to compare
 *
 * Compares @value1 and @value2.  If @value1 and @value2 cannot be
 * compared, the function returns GST_VALUE_UNORDERED.  Otherwise,
 * if @value1 is greater than @value2, GST_VALUE_GREATER_THAN is returned.
 * If @value1 is less than @value2, GST_VALUE_LESS_THAN is returned.
 * If the values are equal, GST_VALUE_EQUAL is returned.
 *
 * Returns: comparison result
 */
gint
gst_value_compare (const GValue * value1, const GValue * value2)
{
  gboolean value1_is_list;
  gboolean value2_is_list;

  g_return_val_if_fail (G_IS_VALUE (value1), GST_VALUE_LESS_THAN);
  g_return_val_if_fail (G_IS_VALUE (value2), GST_VALUE_GREATER_THAN);

  value1_is_list = G_VALUE_TYPE (value1) == GST_TYPE_LIST;
  value2_is_list = G_VALUE_TYPE (value2) == GST_TYPE_LIST;

  /* Special cases: lists and scalar values ("{ 1 }" and "1" are equal),
     as well as lists and ranges ("{ 1, 2 }" and "[ 1, 2 ]" are equal) */
  if (value1_is_list && !value2_is_list) {
    gint i, n, ret;

    if (gst_value_list_equals_range (value1, value2)) {
      return GST_VALUE_EQUAL;
    }

    n = gst_value_list_get_size (value1);
    if (n == 0)
      return GST_VALUE_UNORDERED;

    for (i = 0; i < n; i++) {
      const GValue *elt;

      elt = gst_value_list_get_value (value1, i);
      ret = gst_value_compare (elt, value2);
      if (ret != GST_VALUE_EQUAL && n == 1)
        return ret;
      else if (ret != GST_VALUE_EQUAL)
        return GST_VALUE_UNORDERED;
    }

    return GST_VALUE_EQUAL;
  } else if (value2_is_list && !value1_is_list) {
    gint i, n, ret;

    if (gst_value_list_equals_range (value2, value1)) {
      return GST_VALUE_EQUAL;
    }

    n = gst_value_list_get_size (value2);
    if (n == 0)
      return GST_VALUE_UNORDERED;

    for (i = 0; i < n; i++) {
      const GValue *elt;

      elt = gst_value_list_get_value (value2, i);
      ret = gst_value_compare (elt, value1);
      if (ret != GST_VALUE_EQUAL && n == 1)
        return ret;
      else if (ret != GST_VALUE_EQUAL)
        return GST_VALUE_UNORDERED;
    }

    return GST_VALUE_EQUAL;
  }

  /* And now handle the generic case */
  return _gst_value_compare_nolist (value1, value2);
}

/*
 * gst_value_compare_with_func:
 * @value1: a value to compare
 * @value2: another value to compare
 * @compare: compare function
 *
 * Compares @value1 and @value2 using the @compare function. Works like
 * gst_value_compare() but allows to save time determining the compare function
 * a multiple times. 
 *
 * Returns: comparison result
 */
static gint
gst_value_compare_with_func (const GValue * value1, const GValue * value2,
    GstValueCompareFunc compare)
{
  g_assert (compare);

  if (G_VALUE_TYPE (value1) != G_VALUE_TYPE (value2))
    return GST_VALUE_UNORDERED;

  return compare (value1, value2);
}

/* union */

/**
 * gst_value_can_union:
 * @value1: a value to union
 * @value2: another value to union
 *
 * Determines if @value1 and @value2 can be non-trivially unioned.
 * Any two values can be trivially unioned by adding both of them
 * to a GstValueList.  However, certain types have the possibility
 * to be unioned in a simpler way.  For example, an integer range
 * and an integer can be unioned if the integer is a subset of the
 * integer range.  If there is the possibility that two values can
 * be unioned, this function returns %TRUE.
 *
 * Returns: %TRUE if there is a function allowing the two values to
 * be unioned.
 */
gboolean
gst_value_can_union (const GValue * value1, const GValue * value2)
{
  GstValueUnionInfo *union_info;
  guint i, len;

  g_return_val_if_fail (G_IS_VALUE (value1), FALSE);
  g_return_val_if_fail (G_IS_VALUE (value2), FALSE);

  len = gst_value_union_funcs->len;

  for (i = 0; i < len; i++) {
    union_info = &g_array_index (gst_value_union_funcs, GstValueUnionInfo, i);
    if (union_info->type1 == G_VALUE_TYPE (value1) &&
        union_info->type2 == G_VALUE_TYPE (value2))
      return TRUE;
    if (union_info->type1 == G_VALUE_TYPE (value2) &&
        union_info->type2 == G_VALUE_TYPE (value1))
      return TRUE;
  }

  return FALSE;
}

/**
 * gst_value_union:
 * @dest: (out caller-allocates): the destination value
 * @value1: a value to union
 * @value2: another value to union
 *
 * Creates a GValue corresponding to the union of @value1 and @value2.
 *
 * Returns: %TRUE if the union succeeded.
 */
gboolean
gst_value_union (GValue * dest, const GValue * value1, const GValue * value2)
{
  const GstValueUnionInfo *union_info;
  guint i, len;
  GType type1, type2;

  g_return_val_if_fail (dest != NULL, FALSE);
  g_return_val_if_fail (G_IS_VALUE (value1), FALSE);
  g_return_val_if_fail (G_IS_VALUE (value2), FALSE);
  g_return_val_if_fail (gst_value_list_or_array_are_compatible (value1, value2),
      FALSE);

  len = gst_value_union_funcs->len;
  type1 = G_VALUE_TYPE (value1);
  type2 = G_VALUE_TYPE (value2);

  for (i = 0; i < len; i++) {
    union_info = &g_array_index (gst_value_union_funcs, GstValueUnionInfo, i);
    if (union_info->type1 == type1 && union_info->type2 == type2) {
      return union_info->func (dest, value1, value2);
    }
    if (union_info->type1 == type2 && union_info->type2 == type1) {
      return union_info->func (dest, value2, value1);
    }
  }

  gst_value_list_concat (dest, value1, value2);
  return TRUE;
}

/* gst_value_register_union_func: (skip)
 * @type1: a type to union
 * @type2: another type to union
 * @func: a function that implements creating a union between the two types
 *
 * Registers a union function that can create a union between #GValue items
 * of the type @type1 and @type2.
 *
 * Union functions should be registered at startup before any pipelines are
 * started, as gst_value_register_union_func() is not thread-safe and cannot
 * be used at the same time as gst_value_union() or gst_value_can_union().
 */
static void
gst_value_register_union_func (GType type1, GType type2, GstValueUnionFunc func)
{
  GstValueUnionInfo union_info;

  union_info.type1 = type1;
  union_info.type2 = type2;
  union_info.func = func;

  g_array_append_val (gst_value_union_funcs, union_info);
}

/* intersection */

/**
 * gst_value_can_intersect:
 * @value1: a value to intersect
 * @value2: another value to intersect
 *
 * Determines if intersecting two values will produce a valid result.
 * Two values will produce a valid intersection if they have the same
 * type.
 *
 * Returns: %TRUE if the values can intersect
 */
gboolean
gst_value_can_intersect (const GValue * value1, const GValue * value2)
{
  GstValueIntersectInfo *intersect_info;
  guint i, len;
  GType type1, type2;

  g_return_val_if_fail (G_IS_VALUE (value1), FALSE);
  g_return_val_if_fail (G_IS_VALUE (value2), FALSE);

  type1 = G_VALUE_TYPE (value1);
  type2 = G_VALUE_TYPE (value2);

  /* practically all GstValue types have a compare function (_can_compare=TRUE)
   * GstStructure and GstCaps have not, but are intersectable */
  if (type1 == type2)
    return TRUE;

  /* special cases */
  if (type1 == GST_TYPE_LIST || type2 == GST_TYPE_LIST)
    return TRUE;

  /* check registered intersect functions */
  len = gst_value_intersect_funcs->len;
  for (i = 0; i < len; i++) {
    intersect_info = &g_array_index (gst_value_intersect_funcs,
        GstValueIntersectInfo, i);
    if ((intersect_info->type1 == type1 && intersect_info->type2 == type2) ||
        (intersect_info->type1 == type2 && intersect_info->type2 == type1))
      return TRUE;
  }

  return gst_value_can_compare_unchecked (value1, value2);
}

/**
 * gst_value_intersect:
 * @dest: (out caller-allocates) (transfer full) (allow-none):
 *   a uninitialized #GValue that will hold the calculated
 *   intersection value. May be %NULL if the resulting set if not
 *   needed.
 * @value1: a value to intersect
 * @value2: another value to intersect
 *
 * Calculates the intersection of two values.  If the values have
 * a non-empty intersection, the value representing the intersection
 * is placed in @dest, unless %NULL.  If the intersection is non-empty,
 * @dest is not modified.
 *
 * Returns: %TRUE if the intersection is non-empty
 */
gboolean
gst_value_intersect (GValue * dest, const GValue * value1,
    const GValue * value2)
{
  GstValueIntersectInfo *intersect_info;
  guint i, len;
  GType type1, type2;

  g_return_val_if_fail (G_IS_VALUE (value1), FALSE);
  g_return_val_if_fail (G_IS_VALUE (value2), FALSE);

  type1 = G_VALUE_TYPE (value1);
  type2 = G_VALUE_TYPE (value2);

  /* special cases first */
  if (type1 == GST_TYPE_LIST)
    return gst_value_intersect_list (dest, value1, value2);
  if (type2 == GST_TYPE_LIST)
    return gst_value_intersect_list (dest, value2, value1);

  if (_gst_value_compare_nolist (value1, value2) == GST_VALUE_EQUAL) {
    if (dest)
      gst_value_init_and_copy (dest, value1);
    return TRUE;
  }

  len = gst_value_intersect_funcs->len;
  for (i = 0; i < len; i++) {
    intersect_info = &g_array_index (gst_value_intersect_funcs,
        GstValueIntersectInfo, i);
    if (intersect_info->type1 == type1 && intersect_info->type2 == type2) {
      return intersect_info->func (dest, value1, value2);
    }
    if (intersect_info->type1 == type2 && intersect_info->type2 == type1) {
      return intersect_info->func (dest, value2, value1);
    }
  }
  return FALSE;
}



/* gst_value_register_intersect_func: (skip)
 * @type1: the first type to intersect
 * @type2: the second type to intersect
 * @func: the intersection function
 *
 * Registers a function that is called to calculate the intersection
 * of the values having the types @type1 and @type2.
 *
 * Intersect functions should be registered at startup before any pipelines are
 * started, as gst_value_register_intersect_func() is not thread-safe and
 * cannot be used at the same time as gst_value_intersect() or
 * gst_value_can_intersect().
 */
static void
gst_value_register_intersect_func (GType type1, GType type2,
    GstValueIntersectFunc func)
{
  GstValueIntersectInfo intersect_info;

  intersect_info.type1 = type1;
  intersect_info.type2 = type2;
  intersect_info.func = func;

  g_array_append_val (gst_value_intersect_funcs, intersect_info);
}


/* subtraction */

/**
 * gst_value_subtract:
 * @dest: (out caller-allocates) (allow-none): the destination value
 *     for the result if the subtraction is not empty. May be %NULL,
 *     in which case the resulting set will not be computed, which can
 *     give a fair speedup.
 * @minuend: the value to subtract from
 * @subtrahend: the value to subtract
 *
 * Subtracts @subtrahend from @minuend and stores the result in @dest.
 * Note that this means subtraction as in sets, not as in mathematics.
 *
 * Returns: %TRUE if the subtraction is not empty
 */
gboolean
gst_value_subtract (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  GstValueSubtractInfo *info;
  guint i, len;
  GType mtype, stype;

  g_return_val_if_fail (G_IS_VALUE (minuend), FALSE);
  g_return_val_if_fail (G_IS_VALUE (subtrahend), FALSE);

  mtype = G_VALUE_TYPE (minuend);
  stype = G_VALUE_TYPE (subtrahend);

  /* special cases first */
  if (mtype == GST_TYPE_LIST)
    return gst_value_subtract_from_list (dest, minuend, subtrahend);
  if (stype == GST_TYPE_LIST)
    return gst_value_subtract_list (dest, minuend, subtrahend);

  len = gst_value_subtract_funcs->len;
  for (i = 0; i < len; i++) {
    info = &g_array_index (gst_value_subtract_funcs, GstValueSubtractInfo, i);
    if (info->minuend == mtype && info->subtrahend == stype) {
      return info->func (dest, minuend, subtrahend);
    }
  }

  if (_gst_value_compare_nolist (minuend, subtrahend) != GST_VALUE_EQUAL) {
    if (dest)
      gst_value_init_and_copy (dest, minuend);
    return TRUE;
  }

  return FALSE;
}

#if 0
gboolean
gst_value_subtract (GValue * dest, const GValue * minuend,
    const GValue * subtrahend)
{
  gboolean ret = gst_value_subtract2 (dest, minuend, subtrahend);

  g_printerr ("\"%s\"  -  \"%s\"  =  \"%s\"\n", gst_value_serialize (minuend),
      gst_value_serialize (subtrahend),
      ret ? gst_value_serialize (dest) : "---");
  return ret;
}
#endif

/**
 * gst_value_can_subtract:
 * @minuend: the value to subtract from
 * @subtrahend: the value to subtract
 *
 * Checks if it's possible to subtract @subtrahend from @minuend.
 *
 * Returns: %TRUE if a subtraction is possible
 */
gboolean
gst_value_can_subtract (const GValue * minuend, const GValue * subtrahend)
{
  GstValueSubtractInfo *info;
  guint i, len;
  GType mtype, stype;

  g_return_val_if_fail (G_IS_VALUE (minuend), FALSE);
  g_return_val_if_fail (G_IS_VALUE (subtrahend), FALSE);

  mtype = G_VALUE_TYPE (minuend);
  stype = G_VALUE_TYPE (subtrahend);

  /* special cases */
  if (mtype == GST_TYPE_LIST || stype == GST_TYPE_LIST)
    return TRUE;

  len = gst_value_subtract_funcs->len;
  for (i = 0; i < len; i++) {
    info = &g_array_index (gst_value_subtract_funcs, GstValueSubtractInfo, i);
    if (info->minuend == mtype && info->subtrahend == stype)
      return TRUE;
  }

  return gst_value_can_compare_unchecked (minuend, subtrahend);
}

/* gst_value_register_subtract_func: (skip)
 * @minuend_type: type of the minuend
 * @subtrahend_type: type of the subtrahend
 * @func: function to use
 *
 * Registers @func as a function capable of subtracting the values of
 * @subtrahend_type from values of @minuend_type.
 *
 * Subtract functions should be registered at startup before any pipelines are
 * started, as gst_value_register_subtract_func() is not thread-safe and
 * cannot be used at the same time as gst_value_subtract().
 */
static void
gst_value_register_subtract_func (GType minuend_type, GType subtrahend_type,
    GstValueSubtractFunc func)
{
  GstValueSubtractInfo info;

  g_return_if_fail (!gst_type_is_fixed (minuend_type)
      || !gst_type_is_fixed (subtrahend_type));

  info.minuend = minuend_type;
  info.subtrahend = subtrahend_type;
  info.func = func;

  g_array_append_val (gst_value_subtract_funcs, info);
}

/**
 * gst_value_register:
 * @table: structure containing functions to register
 *
 * Registers functions to perform calculations on #GValue items of a given
 * type. Each type can only be added once.
 */
void
gst_value_register (const GstValueTable * table)
{
  GstValueTable *found;

  g_return_if_fail (table != NULL);

  g_array_append_val (gst_value_table, *table);

  found = gst_value_hash_lookup_type (table->type);
  if (found)
    g_warning ("adding type %s multiple times", g_type_name (table->type));

  /* FIXME: we're not really doing the const justice, we assume the table is
   * static */
  gst_value_hash_add_type (table->type, table);
}

/**
 * gst_value_init_and_copy:
 * @dest: (out caller-allocates): the target value
 * @src: the source value
 *
 * Initialises the target value to be of the same type as source and then copies
 * the contents from source to target.
 */
void
gst_value_init_and_copy (GValue * dest, const GValue * src)
{
  g_return_if_fail (G_IS_VALUE (src));
  g_return_if_fail (dest != NULL);

  g_value_init (dest, G_VALUE_TYPE (src));
  g_value_copy (src, dest);
}

/* move src into dest and clear src */
static void
gst_value_move (GValue * dest, GValue * src)
{
  g_assert (G_IS_VALUE (src));
  g_assert (dest != NULL);

  *dest = *src;
  memset (src, 0, sizeof (GValue));
}

/**
 * gst_value_serialize:
 * @value: a #GValue to serialize
 *
 * tries to transform the given @value into a string representation that allows
 * getting back this string later on using gst_value_deserialize().
 *
 * Free-function: g_free
 *
 * Returns: (transfer full) (nullable): the serialization for @value
 * or %NULL if none exists
 */
gchar *
gst_value_serialize (const GValue * value)
{
  guint i, len;
  GValue s_val = { 0 };
  GstValueTable *table, *best;
  gchar *s;
  GType type;

  g_return_val_if_fail (G_IS_VALUE (value), NULL);

  type = G_VALUE_TYPE (value);

  best = gst_value_hash_lookup_type (type);

  if (G_UNLIKELY (!best || !best->serialize)) {
    len = gst_value_table->len;
    best = NULL;
    for (i = 0; i < len; i++) {
      table = &g_array_index (gst_value_table, GstValueTable, i);
      if (table->serialize && g_type_is_a (type, table->type)) {
        if (!best || g_type_is_a (table->type, best->type))
          best = table;
      }
    }
  }
  if (G_LIKELY (best))
    return best->serialize (value);

  g_value_init (&s_val, G_TYPE_STRING);
  if (g_value_transform (value, &s_val)) {
    s = gst_string_wrap (g_value_get_string (&s_val));
  } else {
    s = NULL;
  }
  g_value_unset (&s_val);

  return s;
}

/**
 * gst_value_deserialize:
 * @dest: (out caller-allocates): #GValue to fill with contents of
 *     deserialization
 * @src: string to deserialize
 *
 * Tries to deserialize a string into the type specified by the given GValue.
 * If the operation succeeds, %TRUE is returned, %FALSE otherwise.
 *
 * Returns: %TRUE on success
 */
gboolean
gst_value_deserialize (GValue * dest, const gchar * src)
{
  GstValueTable *table, *best;
  guint i, len;
  GType type;

  g_return_val_if_fail (src != NULL, FALSE);
  g_return_val_if_fail (G_IS_VALUE (dest), FALSE);

  type = G_VALUE_TYPE (dest);

  best = gst_value_hash_lookup_type (type);
  if (G_UNLIKELY (!best || !best->deserialize)) {
    len = gst_value_table->len;
    best = NULL;
    for (i = 0; i < len; i++) {
      table = &g_array_index (gst_value_table, GstValueTable, i);
      if (table->deserialize && g_type_is_a (type, table->type)) {
        if (!best || g_type_is_a (table->type, best->type))
          best = table;
      }
    }
  }
  if (G_LIKELY (best))
    return best->deserialize (dest, src);

  return FALSE;
}

/**
 * gst_value_is_fixed:
 * @value: the #GValue to check
 *
 * Tests if the given GValue, if available in a GstStructure (or any other
 * container) contains a "fixed" (which means: one value) or an "unfixed"
 * (which means: multiple possible values, such as data lists or data
 * ranges) value.
 *
 * Returns: true if the value is "fixed".
 */

gboolean
gst_value_is_fixed (const GValue * value)
{
  GType type;

  g_return_val_if_fail (G_IS_VALUE (value), FALSE);

  type = G_VALUE_TYPE (value);

  /* the most common types are just basic plain glib types */
  if (type <= G_TYPE_MAKE_FUNDAMENTAL (G_TYPE_RESERVED_GLIB_LAST)) {
    return TRUE;
  }

  if (type == GST_TYPE_ARRAY) {
    gint size, n;
    const GValue *kid;

    /* check recursively */
    size = gst_value_array_get_size (value);
    for (n = 0; n < size; n++) {
      kid = gst_value_array_get_value (value, n);
      if (!gst_value_is_fixed (kid))
        return FALSE;
    }
    return TRUE;
  }
  return gst_type_is_fixed (type);
}

/**
 * gst_value_fixate:
 * @dest: the #GValue destination
 * @src: the #GValue to fixate
 *
 * Fixate @src into a new value @dest.
 * For ranges, the first element is taken. For lists and arrays, the
 * first item is fixated and returned.
 * If @src is already fixed, this function returns %FALSE.
 *
 * Returns: %TRUE if @dest contains a fixated version of @src.
 */
gboolean
gst_value_fixate (GValue * dest, const GValue * src)
{
  g_return_val_if_fail (G_IS_VALUE (src), FALSE);
  g_return_val_if_fail (dest != NULL, FALSE);

  if (G_VALUE_TYPE (src) == GST_TYPE_INT_RANGE) {
    g_value_init (dest, G_TYPE_INT);
    g_value_set_int (dest, gst_value_get_int_range_min (src));
  } else if (G_VALUE_TYPE (src) == GST_TYPE_DOUBLE_RANGE) {
    g_value_init (dest, G_TYPE_DOUBLE);
    g_value_set_double (dest, gst_value_get_double_range_min (src));
  } else if (G_VALUE_TYPE (src) == GST_TYPE_FRACTION_RANGE) {
    gst_value_init_and_copy (dest, gst_value_get_fraction_range_min (src));
  } else if (G_VALUE_TYPE (src) == GST_TYPE_LIST) {
    GValue temp = { 0 };

    /* list could be empty */
    if (gst_value_list_get_size (src) <= 0)
      return FALSE;

    gst_value_init_and_copy (&temp, gst_value_list_get_value (src, 0));

    if (!gst_value_fixate (dest, &temp)) {
      gst_value_move (dest, &temp);
    } else {
      g_value_unset (&temp);
    }
  } else if (G_VALUE_TYPE (src) == GST_TYPE_ARRAY) {
    gboolean res = FALSE;
    guint n, len;

    len = gst_value_array_get_size (src);
    g_value_init (dest, GST_TYPE_ARRAY);
    for (n = 0; n < len; n++) {
      GValue kid = { 0 };
      const GValue *orig_kid = gst_value_array_get_value (src, n);

      if (!gst_value_fixate (&kid, orig_kid))
        gst_value_init_and_copy (&kid, orig_kid);
      else
        res = TRUE;
      _gst_value_array_append_and_take_value (dest, &kid);
    }

    if (!res)
      g_value_unset (dest);

    return res;
  } else {
    return FALSE;
  }
  return TRUE;
}


/************
 * fraction *
 ************/

/* helper functions */
static void
gst_value_init_fraction (GValue * value)
{
  value->data[0].v_int = 0;
  value->data[1].v_int = 1;
}

static void
gst_value_copy_fraction (const GValue * src_value, GValue * dest_value)
{
  dest_value->data[0].v_int = src_value->data[0].v_int;
  dest_value->data[1].v_int = src_value->data[1].v_int;
}

static gchar *
gst_value_collect_fraction (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  if (n_collect_values != 2)
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[1].v_int == 0)
    return g_strdup_printf ("passed '0' as denominator for `%s'",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[0].v_int < -G_MAXINT)
    return
        g_strdup_printf
        ("passed value smaller than -G_MAXINT as numerator for `%s'",
        G_VALUE_TYPE_NAME (value));
  if (collect_values[1].v_int < -G_MAXINT)
    return
        g_strdup_printf
        ("passed value smaller than -G_MAXINT as denominator for `%s'",
        G_VALUE_TYPE_NAME (value));

  gst_value_set_fraction (value,
      collect_values[0].v_int, collect_values[1].v_int);

  return NULL;
}

static gchar *
gst_value_lcopy_fraction (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  gint *numerator = collect_values[0].v_pointer;
  gint *denominator = collect_values[1].v_pointer;

  if (!numerator)
    return g_strdup_printf ("numerator for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));
  if (!denominator)
    return g_strdup_printf ("denominator for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));

  *numerator = value->data[0].v_int;
  *denominator = value->data[1].v_int;

  return NULL;
}

/**
 * gst_value_set_fraction:
 * @value: a GValue initialized to #GST_TYPE_FRACTION
 * @numerator: the numerator of the fraction
 * @denominator: the denominator of the fraction
 *
 * Sets @value to the fraction specified by @numerator over @denominator.
 * The fraction gets reduced to the smallest numerator and denominator,
 * and if necessary the sign is moved to the numerator.
 */
void
gst_value_set_fraction (GValue * value, gint numerator, gint denominator)
{
  gint gcd = 0;

  g_return_if_fail (GST_VALUE_HOLDS_FRACTION (value));
  g_return_if_fail (denominator != 0);
  g_return_if_fail (denominator >= -G_MAXINT);
  g_return_if_fail (numerator >= -G_MAXINT);

  /* normalize sign */
  if (denominator < 0) {
    numerator = -numerator;
    denominator = -denominator;
  }

  /* check for reduction */
  gcd = gst_util_greatest_common_divisor (numerator, denominator);
  if (gcd) {
    numerator /= gcd;
    denominator /= gcd;
  }

  g_assert (denominator > 0);

  value->data[0].v_int = numerator;
  value->data[1].v_int = denominator;
}

/**
 * gst_value_get_fraction_numerator:
 * @value: a GValue initialized to #GST_TYPE_FRACTION
 *
 * Gets the numerator of the fraction specified by @value.
 *
 * Returns: the numerator of the fraction.
 */
gint
gst_value_get_fraction_numerator (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION (value), 0);

  return value->data[0].v_int;
}

/**
 * gst_value_get_fraction_denominator:
 * @value: a GValue initialized to #GST_TYPE_FRACTION
 *
 * Gets the denominator of the fraction specified by @value.
 *
 * Returns: the denominator of the fraction.
 */
gint
gst_value_get_fraction_denominator (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION (value), 1);

  return value->data[1].v_int;
}

/**
 * gst_value_fraction_multiply:
 * @product: a GValue initialized to #GST_TYPE_FRACTION
 * @factor1: a GValue initialized to #GST_TYPE_FRACTION
 * @factor2: a GValue initialized to #GST_TYPE_FRACTION
 *
 * Multiplies the two #GValue items containing a #GST_TYPE_FRACTION and sets
 * @product to the product of the two fractions.
 *
 * Returns: %FALSE in case of an error (like integer overflow), %TRUE otherwise.
 */
gboolean
gst_value_fraction_multiply (GValue * product, const GValue * factor1,
    const GValue * factor2)
{
  gint n1, n2, d1, d2;
  gint res_n, res_d;

  g_return_val_if_fail (product != NULL, FALSE);
  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION (factor1), FALSE);
  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION (factor2), FALSE);

  n1 = factor1->data[0].v_int;
  n2 = factor2->data[0].v_int;
  d1 = factor1->data[1].v_int;
  d2 = factor2->data[1].v_int;

  if (!gst_util_fraction_multiply (n1, d1, n2, d2, &res_n, &res_d))
    return FALSE;

  gst_value_set_fraction (product, res_n, res_d);

  return TRUE;
}

/**
 * gst_value_fraction_subtract:
 * @dest: a GValue initialized to #GST_TYPE_FRACTION
 * @minuend: a GValue initialized to #GST_TYPE_FRACTION
 * @subtrahend: a GValue initialized to #GST_TYPE_FRACTION
 *
 * Subtracts the @subtrahend from the @minuend and sets @dest to the result.
 *
 * Returns: %FALSE in case of an error (like integer overflow), %TRUE otherwise.
 */
gboolean
gst_value_fraction_subtract (GValue * dest,
    const GValue * minuend, const GValue * subtrahend)
{
  gint n1, n2, d1, d2;
  gint res_n, res_d;

  g_return_val_if_fail (dest != NULL, FALSE);
  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION (minuend), FALSE);
  g_return_val_if_fail (GST_VALUE_HOLDS_FRACTION (subtrahend), FALSE);

  n1 = minuend->data[0].v_int;
  n2 = subtrahend->data[0].v_int;
  d1 = minuend->data[1].v_int;
  d2 = subtrahend->data[1].v_int;

  if (!gst_util_fraction_add (n1, d1, -n2, d2, &res_n, &res_d))
    return FALSE;
  gst_value_set_fraction (dest, res_n, res_d);

  return TRUE;
}

static gchar *
gst_value_serialize_fraction (const GValue * value)
{
  gint32 numerator = value->data[0].v_int;
  gint32 denominator = value->data[1].v_int;
  gboolean positive = TRUE;

  /* get the sign and make components absolute */
  if (numerator < 0) {
    numerator = -numerator;
    positive = !positive;
  }
  if (denominator < 0) {
    denominator = -denominator;
    positive = !positive;
  }

  return g_strdup_printf ("%s%d/%d",
      positive ? "" : "-", numerator, denominator);
}

static gboolean
gst_value_deserialize_fraction (GValue * dest, const gchar * s)
{
  gint num, den;
  gint num_chars;

  if (G_UNLIKELY (s == NULL))
    return FALSE;

  if (G_UNLIKELY (dest == NULL || !GST_VALUE_HOLDS_FRACTION (dest)))
    return FALSE;

  if (sscanf (s, "%d/%d%n", &num, &den, &num_chars) >= 2) {
    if (s[num_chars] != 0)
      return FALSE;
    if (den == 0)
      return FALSE;

    gst_value_set_fraction (dest, num, den);
    return TRUE;
  } else if (g_ascii_strcasecmp (s, "1/max") == 0) {
    gst_value_set_fraction (dest, 1, G_MAXINT);
    return TRUE;
  } else if (sscanf (s, "%d%n", &num, &num_chars) >= 1) {
    if (s[num_chars] != 0)
      return FALSE;
    gst_value_set_fraction (dest, num, 1);
    return TRUE;
  } else if (g_ascii_strcasecmp (s, "min") == 0) {
    gst_value_set_fraction (dest, -G_MAXINT, 1);
    return TRUE;
  } else if (g_ascii_strcasecmp (s, "max") == 0) {
    gst_value_set_fraction (dest, G_MAXINT, 1);
    return TRUE;
  }

  return FALSE;
}

static void
gst_value_transform_fraction_string (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_pointer = gst_value_serialize_fraction (src_value);
}

static void
gst_value_transform_string_fraction (const GValue * src_value,
    GValue * dest_value)
{
  if (!gst_value_deserialize_fraction (dest_value,
          src_value->data[0].v_pointer))
    /* If the deserialize fails, ensure we leave the fraction in a
     * valid, if incorrect, state */
    gst_value_set_fraction (dest_value, 0, 1);
}

static void
gst_value_transform_double_fraction (const GValue * src_value,
    GValue * dest_value)
{
  gdouble src = g_value_get_double (src_value);
  gint n, d;

  gst_util_double_to_fraction (src, &n, &d);
  gst_value_set_fraction (dest_value, n, d);
}

static void
gst_value_transform_float_fraction (const GValue * src_value,
    GValue * dest_value)
{
  gfloat src = g_value_get_float (src_value);
  gint n, d;

  gst_util_double_to_fraction (src, &n, &d);
  gst_value_set_fraction (dest_value, n, d);
}

static void
gst_value_transform_fraction_double (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_double = ((double) src_value->data[0].v_int) /
      ((double) src_value->data[1].v_int);
}

static void
gst_value_transform_fraction_float (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_float = ((float) src_value->data[0].v_int) /
      ((float) src_value->data[1].v_int);
}

static gint
gst_value_compare_fraction (const GValue * value1, const GValue * value2)
{
  gint n1, n2;
  gint d1, d2;
  gint ret;

  n1 = value1->data[0].v_int;
  n2 = value2->data[0].v_int;
  d1 = value1->data[1].v_int;
  d2 = value2->data[1].v_int;

  /* fractions are reduced when set, so we can quickly see if they're equal */
  if (n1 == n2 && d1 == d2)
    return GST_VALUE_EQUAL;

  if (d1 == 0 && d2 == 0)
    return GST_VALUE_UNORDERED;
  else if (d1 == 0)
    return GST_VALUE_GREATER_THAN;
  else if (d2 == 0)
    return GST_VALUE_LESS_THAN;

  ret = gst_util_fraction_compare (n1, d1, n2, d2);
  if (ret == -1)
    return GST_VALUE_LESS_THAN;
  else if (ret == 1)
    return GST_VALUE_GREATER_THAN;

  /* Equality can't happen here because we check for that
   * first already */
  g_return_val_if_reached (GST_VALUE_UNORDERED);
}

/*********
 * GDate *
 *********/

static gint
gst_value_compare_date (const GValue * value1, const GValue * value2)
{
  const GDate *date1 = (const GDate *) g_value_get_boxed (value1);
  const GDate *date2 = (const GDate *) g_value_get_boxed (value2);
  guint32 j1, j2;

  if (date1 == date2)
    return GST_VALUE_EQUAL;

  if ((date1 == NULL || !g_date_valid (date1))
      && (date2 != NULL && g_date_valid (date2))) {
    return GST_VALUE_LESS_THAN;
  }

  if ((date2 == NULL || !g_date_valid (date2))
      && (date1 != NULL && g_date_valid (date1))) {
    return GST_VALUE_GREATER_THAN;
  }

  if (date1 == NULL || date2 == NULL || !g_date_valid (date1)
      || !g_date_valid (date2)) {
    return GST_VALUE_UNORDERED;
  }

  j1 = g_date_get_julian (date1);
  j2 = g_date_get_julian (date2);

  if (j1 == j2)
    return GST_VALUE_EQUAL;
  else if (j1 < j2)
    return GST_VALUE_LESS_THAN;
  else
    return GST_VALUE_GREATER_THAN;
}

static gchar *
gst_value_serialize_date (const GValue * val)
{
  const GDate *date = (const GDate *) g_value_get_boxed (val);

  if (date == NULL || !g_date_valid (date))
    return g_strdup ("9999-99-99");

  return g_strdup_printf ("%04u-%02u-%02u", g_date_get_year (date),
      g_date_get_month (date), g_date_get_day (date));
}

static gboolean
gst_value_deserialize_date (GValue * dest, const gchar * s)
{
  guint year, month, day;

  if (!s || sscanf (s, "%04u-%02u-%02u", &year, &month, &day) != 3)
    return FALSE;

  if (!g_date_valid_dmy (day, month, year))
    return FALSE;

  g_value_take_boxed (dest, g_date_new_dmy (day, month, year));
  return TRUE;
}

/*************
 * GstDateTime *
 *************/

static gint
gst_value_compare_date_time (const GValue * value1, const GValue * value2)
{
  const GstDateTime *date1 = (const GstDateTime *) g_value_get_boxed (value1);
  const GstDateTime *date2 = (const GstDateTime *) g_value_get_boxed (value2);

  if (date1 == date2)
    return GST_VALUE_EQUAL;

  if ((date1 == NULL) && (date2 != NULL)) {
    return GST_VALUE_LESS_THAN;
  }
  if ((date2 == NULL) && (date1 != NULL)) {
    return GST_VALUE_LESS_THAN;
  }

  /* returns GST_VALUE_* */
  return __gst_date_time_compare (date1, date2);
}

static gchar *
gst_value_serialize_date_time (const GValue * val)
{
  GstDateTime *date = (GstDateTime *) g_value_get_boxed (val);

  if (date == NULL)
    return g_strdup ("null");

  return __gst_date_time_serialize (date, TRUE);
}

static gboolean
gst_value_deserialize_date_time (GValue * dest, const gchar * s)
{
  GstDateTime *datetime;

  if (!s || strcmp (s, "null") == 0) {
    return FALSE;
  }

  datetime = gst_date_time_new_from_iso8601_string (s);
  if (datetime != NULL) {
    g_value_take_boxed (dest, datetime);
    return TRUE;
  }
  GST_WARNING ("Failed to deserialize date time string '%s'", s);
  return FALSE;
}

static void
gst_value_transform_date_string (const GValue * src_value, GValue * dest_value)
{
  dest_value->data[0].v_pointer = gst_value_serialize_date (src_value);
}

static void
gst_value_transform_string_date (const GValue * src_value, GValue * dest_value)
{
  gst_value_deserialize_date (dest_value, src_value->data[0].v_pointer);
}


/************
 * bitmask *
 ************/

/* helper functions */
static void
gst_value_init_bitmask (GValue * value)
{
  value->data[0].v_uint64 = 0;
}

static void
gst_value_copy_bitmask (const GValue * src_value, GValue * dest_value)
{
  dest_value->data[0].v_uint64 = src_value->data[0].v_uint64;
}

static gchar *
gst_value_collect_bitmask (GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  if (n_collect_values != 1)
    return g_strdup_printf ("not enough value locations for `%s' passed",
        G_VALUE_TYPE_NAME (value));

  gst_value_set_bitmask (value, (guint64) collect_values[0].v_int64);

  return NULL;
}

static gchar *
gst_value_lcopy_bitmask (const GValue * value, guint n_collect_values,
    GTypeCValue * collect_values, guint collect_flags)
{
  guint64 *bitmask = collect_values[0].v_pointer;

  if (!bitmask)
    return g_strdup_printf ("value for `%s' passed as NULL",
        G_VALUE_TYPE_NAME (value));

  *bitmask = value->data[0].v_uint64;

  return NULL;
}

/**
 * gst_value_set_bitmask:
 * @value: a GValue initialized to #GST_TYPE_BITMASK
 * @bitmask: the bitmask
 *
 * Sets @value to the bitmask specified by @bitmask.
 */
void
gst_value_set_bitmask (GValue * value, guint64 bitmask)
{
  g_return_if_fail (GST_VALUE_HOLDS_BITMASK (value));

  value->data[0].v_uint64 = bitmask;
}

/**
 * gst_value_get_bitmask:
 * @value: a GValue initialized to #GST_TYPE_BITMASK
 *
 * Gets the bitmask specified by @value.
 *
 * Returns: the bitmask.
 */
guint64
gst_value_get_bitmask (const GValue * value)
{
  g_return_val_if_fail (GST_VALUE_HOLDS_BITMASK (value), 0);

  return value->data[0].v_uint64;
}

static gchar *
gst_value_serialize_bitmask (const GValue * value)
{
  guint64 bitmask = value->data[0].v_uint64;

  return g_strdup_printf ("0x%016" G_GINT64_MODIFIER "x", bitmask);
}

static gboolean
gst_value_deserialize_bitmask (GValue * dest, const gchar * s)
{
  gchar *endptr = NULL;
  guint64 val;

  if (G_UNLIKELY (s == NULL))
    return FALSE;

  if (G_UNLIKELY (dest == NULL || !GST_VALUE_HOLDS_BITMASK (dest)))
    return FALSE;

  val = g_ascii_strtoull (s, &endptr, 16);
  if (val == G_MAXUINT64 && (errno == ERANGE || errno == EINVAL))
    return FALSE;
  if (val == 0 && endptr == s)
    return FALSE;

  gst_value_set_bitmask (dest, val);

  return TRUE;
}

static void
gst_value_transform_bitmask_string (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_pointer = gst_value_serialize_bitmask (src_value);
}

static void
gst_value_transform_string_bitmask (const GValue * src_value,
    GValue * dest_value)
{
  if (!gst_value_deserialize_bitmask (dest_value, src_value->data[0].v_pointer))
    gst_value_set_bitmask (dest_value, 0);
}

static void
gst_value_transform_uint64_bitmask (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_uint64 = src_value->data[0].v_uint64;
}

static void
gst_value_transform_bitmask_uint64 (const GValue * src_value,
    GValue * dest_value)
{
  dest_value->data[0].v_uint64 = src_value->data[0].v_uint64;
}

static gint
gst_value_compare_bitmask (const GValue * value1, const GValue * value2)
{
  guint64 v1, v2;

  v1 = value1->data[0].v_uint64;
  v2 = value2->data[0].v_uint64;

  if (v1 == v2)
    return GST_VALUE_EQUAL;

  return GST_VALUE_UNORDERED;
}


/***********************
 * GstAllocationParams *
 ***********************/
static gint
gst_value_compare_allocation_params (const GValue * value1,
    const GValue * value2)
{
  GstAllocationParams *v1, *v2;

  v1 = value1->data[0].v_pointer;
  v2 = value2->data[0].v_pointer;

  if (v1 == NULL && v1 == v2)
    return GST_VALUE_EQUAL;

  if (v1 == NULL || v2 == NULL)
    return GST_VALUE_UNORDERED;

  if (v1->flags == v2->flags && v1->align == v2->align &&
      v1->prefix == v2->prefix && v1->padding == v2->padding)
    return GST_VALUE_EQUAL;

  return GST_VALUE_UNORDERED;
}


/************
 * GObject *
 ************/

static gint
gst_value_compare_object (const GValue * value1, const GValue * value2)
{
  gpointer v1, v2;

  v1 = value1->data[0].v_pointer;
  v2 = value2->data[0].v_pointer;

  if (v1 == v2)
    return GST_VALUE_EQUAL;

  return GST_VALUE_UNORDERED;
}

static void
gst_value_transform_object_string (const GValue * src_value,
    GValue * dest_value)
{
  GstObject *obj;
  gchar *str;

  obj = g_value_get_object (src_value);
  if (obj) {
    str =
        g_strdup_printf ("(%s) %s", G_OBJECT_TYPE_NAME (obj),
        GST_OBJECT_NAME (obj));
  } else {
    str = g_strdup ("NULL");
  }

  dest_value->data[0].v_pointer = str;
}

static GTypeInfo _info = {
  0,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  0,
  0,
  NULL,
  NULL,
};

static GTypeFundamentalInfo _finfo = {
  0
};

#define FUNC_VALUE_GET_TYPE(type, name)                         \
GType _gst_ ## type ## _type = 0;                               \
                                                                \
GType gst_ ## type ## _get_type (void)                          \
{                                                               \
  static volatile GType gst_ ## type ## _type = 0;              \
                                                                \
  if (g_once_init_enter (&gst_ ## type ## _type)) {             \
    GType _type;                                                \
    _info.value_table = & _gst_ ## type ## _value_table;        \
    _type = g_type_register_fundamental (                       \
        g_type_fundamental_next (),                             \
        name, &_info, &_finfo, 0);                              \
    _gst_ ## type ## _type = _type;                              \
    g_once_init_leave(&gst_ ## type ## _type, _type);           \
  }                                                             \
                                                                \
  return gst_ ## type ## _type;                                 \
}

static const GTypeValueTable _gst_int_range_value_table = {
  gst_value_init_int_range,
  NULL,
  gst_value_copy_int_range,
  NULL,
  (char *) "ii",
  gst_value_collect_int_range,
  (char *) "pp",
  gst_value_lcopy_int_range
};

FUNC_VALUE_GET_TYPE (int_range, "GstIntRange");

static const GTypeValueTable _gst_int64_range_value_table = {
  gst_value_init_int64_range,
  gst_value_free_int64_range,
  gst_value_copy_int64_range,
  NULL,
  (char *) "qq",
  gst_value_collect_int64_range,
  (char *) "pp",
  gst_value_lcopy_int64_range
};

FUNC_VALUE_GET_TYPE (int64_range, "GstInt64Range");

static const GTypeValueTable _gst_double_range_value_table = {
  gst_value_init_double_range,
  NULL,
  gst_value_copy_double_range,
  NULL,
  (char *) "dd",
  gst_value_collect_double_range,
  (char *) "pp",
  gst_value_lcopy_double_range
};

FUNC_VALUE_GET_TYPE (double_range, "GstDoubleRange");

static const GTypeValueTable _gst_fraction_range_value_table = {
  gst_value_init_fraction_range,
  gst_value_free_fraction_range,
  gst_value_copy_fraction_range,
  NULL,
  (char *) "iiii",
  gst_value_collect_fraction_range,
  (char *) "pppp",
  gst_value_lcopy_fraction_range
};

FUNC_VALUE_GET_TYPE (fraction_range, "GstFractionRange");

static const GTypeValueTable _gst_value_list_value_table = {
  gst_value_init_list_or_array,
  gst_value_free_list_or_array,
  gst_value_copy_list_or_array,
  gst_value_list_or_array_peek_pointer,
  (char *) "p",
  gst_value_collect_list_or_array,
  (char *) "p",
  gst_value_lcopy_list_or_array
};

FUNC_VALUE_GET_TYPE (value_list, "GstValueList");

static const GTypeValueTable _gst_value_array_value_table = {
  gst_value_init_list_or_array,
  gst_value_free_list_or_array,
  gst_value_copy_list_or_array,
  gst_value_list_or_array_peek_pointer,
  (char *) "p",
  gst_value_collect_list_or_array,
  (char *) "p",
  gst_value_lcopy_list_or_array
};

FUNC_VALUE_GET_TYPE (value_array, "GstValueArray");

static const GTypeValueTable _gst_fraction_value_table = {
  gst_value_init_fraction,
  NULL,
  gst_value_copy_fraction,
  NULL,
  (char *) "ii",
  gst_value_collect_fraction,
  (char *) "pp",
  gst_value_lcopy_fraction
};

FUNC_VALUE_GET_TYPE (fraction, "GstFraction");

static const GTypeValueTable _gst_bitmask_value_table = {
  gst_value_init_bitmask,
  NULL,
  gst_value_copy_bitmask,
  NULL,
  (char *) "q",
  gst_value_collect_bitmask,
  (char *) "p",
  gst_value_lcopy_bitmask
};

FUNC_VALUE_GET_TYPE (bitmask, "GstBitmask");

GType
gst_g_thread_get_type (void)
{
#if GLIB_CHECK_VERSION(2,35,3)
  return G_TYPE_THREAD;
#else
  static volatile gsize type_id = 0;

  if (g_once_init_enter (&type_id)) {
    GType tmp =
        g_boxed_type_register_static (g_intern_static_string ("GstGThread"),
        (GBoxedCopyFunc) g_thread_ref,
        (GBoxedFreeFunc) g_thread_unref);
    g_once_init_leave (&type_id, tmp);
  }

  return type_id;
#endif
}

void
_priv_gst_value_initialize (void)
{
  gst_value_table = g_array_new (FALSE, FALSE, sizeof (GstValueTable));
  gst_value_hash = g_hash_table_new (NULL, NULL);
  gst_value_union_funcs = g_array_new (FALSE, FALSE,
      sizeof (GstValueUnionInfo));
  gst_value_intersect_funcs = g_array_new (FALSE, FALSE,
      sizeof (GstValueIntersectInfo));
  gst_value_subtract_funcs = g_array_new (FALSE, FALSE,
      sizeof (GstValueSubtractInfo));

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_int_range,
      gst_value_serialize_int_range,
      gst_value_deserialize_int_range,
    };

    gst_value.type = gst_int_range_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_int64_range,
      gst_value_serialize_int64_range,
      gst_value_deserialize_int64_range,
    };

    gst_value.type = gst_int64_range_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_double_range,
      gst_value_serialize_double_range,
      gst_value_deserialize_double_range,
    };

    gst_value.type = gst_double_range_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_fraction_range,
      gst_value_serialize_fraction_range,
      gst_value_deserialize_fraction_range,
    };

    gst_value.type = gst_fraction_range_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_list,
      gst_value_serialize_list,
      gst_value_deserialize_list,
    };

    gst_value.type = gst_value_list_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_array,
      gst_value_serialize_array,
      gst_value_deserialize_array,
    };

    gst_value.type = gst_value_array_get_type ();
    gst_value_register (&gst_value);
  }

  {
#if 0
    static const GTypeValueTable value_table = {
      gst_value_init_buffer,
      NULL,
      gst_value_copy_buffer,
      NULL,
      "i",
      NULL,                     /*gst_value_collect_buffer, */
      "p",
      NULL                      /*gst_value_lcopy_buffer */
    };
#endif
    static GstValueTable gst_value = {
      0,
      gst_value_compare_buffer,
      gst_value_serialize_buffer,
      gst_value_deserialize_buffer,
    };

    gst_value.type = GST_TYPE_BUFFER;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_sample,
      gst_value_serialize_sample,
      gst_value_deserialize_sample,
    };

    gst_value.type = GST_TYPE_SAMPLE;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_fraction,
      gst_value_serialize_fraction,
      gst_value_deserialize_fraction,
    };

    gst_value.type = gst_fraction_get_type ();
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_caps,
      gst_value_serialize_caps,
      gst_value_deserialize_caps,
    };

    gst_value.type = GST_TYPE_CAPS;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      NULL,
      gst_value_serialize_segment,
      gst_value_deserialize_segment,
    };

    gst_value.type = GST_TYPE_SEGMENT;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      NULL,
      gst_value_serialize_structure,
      gst_value_deserialize_structure,
    };

    gst_value.type = GST_TYPE_STRUCTURE;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      NULL,
      gst_value_serialize_caps_features,
      gst_value_deserialize_caps_features,
    };

    gst_value.type = GST_TYPE_CAPS_FEATURES;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      NULL,
      gst_value_serialize_tag_list,
      gst_value_deserialize_tag_list,
    };

    gst_value.type = GST_TYPE_TAG_LIST;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_date,
      gst_value_serialize_date,
      gst_value_deserialize_date,
    };

    gst_value.type = G_TYPE_DATE;
    gst_value_register (&gst_value);
  }
  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_date_time,
      gst_value_serialize_date_time,
      gst_value_deserialize_date_time,
    };

    gst_value.type = gst_date_time_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_bitmask,
      gst_value_serialize_bitmask,
      gst_value_deserialize_bitmask,
    };

    gst_value.type = gst_bitmask_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_allocation_params,
      NULL,
      NULL,
    };

    gst_value.type = gst_allocation_params_get_type ();
    gst_value_register (&gst_value);
  }

  {
    static GstValueTable gst_value = {
      0,
      gst_value_compare_object,
      NULL,
      NULL,
    };

    gst_value.type = G_TYPE_OBJECT;
    gst_value_register (&gst_value);
  }

  REGISTER_SERIALIZATION (G_TYPE_DOUBLE, double);
  REGISTER_SERIALIZATION (G_TYPE_FLOAT, float);

  REGISTER_SERIALIZATION (G_TYPE_STRING, string);
  REGISTER_SERIALIZATION (G_TYPE_BOOLEAN, boolean);
  REGISTER_SERIALIZATION (G_TYPE_ENUM, enum);

  REGISTER_SERIALIZATION (G_TYPE_FLAGS, flags);

  REGISTER_SERIALIZATION (G_TYPE_INT, int);

  REGISTER_SERIALIZATION (G_TYPE_INT64, int64);
  REGISTER_SERIALIZATION (G_TYPE_LONG, long);

  REGISTER_SERIALIZATION (G_TYPE_UINT, uint);
  REGISTER_SERIALIZATION (G_TYPE_UINT64, uint64);
  REGISTER_SERIALIZATION (G_TYPE_ULONG, ulong);

  REGISTER_SERIALIZATION (G_TYPE_UCHAR, uchar);

  g_value_register_transform_func (GST_TYPE_INT_RANGE, G_TYPE_STRING,
      gst_value_transform_int_range_string);
  g_value_register_transform_func (GST_TYPE_INT64_RANGE, G_TYPE_STRING,
      gst_value_transform_int64_range_string);
  g_value_register_transform_func (GST_TYPE_DOUBLE_RANGE, G_TYPE_STRING,
      gst_value_transform_double_range_string);
  g_value_register_transform_func (GST_TYPE_FRACTION_RANGE, G_TYPE_STRING,
      gst_value_transform_fraction_range_string);
  g_value_register_transform_func (GST_TYPE_LIST, G_TYPE_STRING,
      gst_value_transform_list_string);
  g_value_register_transform_func (GST_TYPE_ARRAY, G_TYPE_STRING,
      gst_value_transform_array_string);
  g_value_register_transform_func (GST_TYPE_FRACTION, G_TYPE_STRING,
      gst_value_transform_fraction_string);
  g_value_register_transform_func (G_TYPE_STRING, GST_TYPE_FRACTION,
      gst_value_transform_string_fraction);
  g_value_register_transform_func (GST_TYPE_FRACTION, G_TYPE_DOUBLE,
      gst_value_transform_fraction_double);
  g_value_register_transform_func (GST_TYPE_FRACTION, G_TYPE_FLOAT,
      gst_value_transform_fraction_float);
  g_value_register_transform_func (G_TYPE_DOUBLE, GST_TYPE_FRACTION,
      gst_value_transform_double_fraction);
  g_value_register_transform_func (G_TYPE_FLOAT, GST_TYPE_FRACTION,
      gst_value_transform_float_fraction);
  g_value_register_transform_func (G_TYPE_DATE, G_TYPE_STRING,
      gst_value_transform_date_string);
  g_value_register_transform_func (G_TYPE_STRING, G_TYPE_DATE,
      gst_value_transform_string_date);
  g_value_register_transform_func (GST_TYPE_OBJECT, G_TYPE_STRING,
      gst_value_transform_object_string);
  g_value_register_transform_func (GST_TYPE_BITMASK, G_TYPE_UINT64,
      gst_value_transform_bitmask_uint64);
  g_value_register_transform_func (GST_TYPE_BITMASK, G_TYPE_STRING,
      gst_value_transform_bitmask_string);
  g_value_register_transform_func (G_TYPE_UINT64, GST_TYPE_BITMASK,
      gst_value_transform_uint64_bitmask);
  g_value_register_transform_func (G_TYPE_STRING, GST_TYPE_BITMASK,
      gst_value_transform_string_bitmask);

  gst_value_register_intersect_func (G_TYPE_INT, GST_TYPE_INT_RANGE,
      gst_value_intersect_int_int_range);
  gst_value_register_intersect_func (GST_TYPE_INT_RANGE, GST_TYPE_INT_RANGE,
      gst_value_intersect_int_range_int_range);
  gst_value_register_intersect_func (G_TYPE_INT64, GST_TYPE_INT64_RANGE,
      gst_value_intersect_int64_int64_range);
  gst_value_register_intersect_func (GST_TYPE_INT64_RANGE, GST_TYPE_INT64_RANGE,
      gst_value_intersect_int64_range_int64_range);
  gst_value_register_intersect_func (G_TYPE_DOUBLE, GST_TYPE_DOUBLE_RANGE,
      gst_value_intersect_double_double_range);
  gst_value_register_intersect_func (GST_TYPE_DOUBLE_RANGE,
      GST_TYPE_DOUBLE_RANGE, gst_value_intersect_double_range_double_range);
  gst_value_register_intersect_func (GST_TYPE_ARRAY,
      GST_TYPE_ARRAY, gst_value_intersect_array);
  gst_value_register_intersect_func (GST_TYPE_FRACTION, GST_TYPE_FRACTION_RANGE,
      gst_value_intersect_fraction_fraction_range);
  gst_value_register_intersect_func (GST_TYPE_FRACTION_RANGE,
      GST_TYPE_FRACTION_RANGE,
      gst_value_intersect_fraction_range_fraction_range);

  gst_value_register_subtract_func (G_TYPE_INT, GST_TYPE_INT_RANGE,
      gst_value_subtract_int_int_range);
  gst_value_register_subtract_func (GST_TYPE_INT_RANGE, G_TYPE_INT,
      gst_value_subtract_int_range_int);
  gst_value_register_subtract_func (GST_TYPE_INT_RANGE, GST_TYPE_INT_RANGE,
      gst_value_subtract_int_range_int_range);
  gst_value_register_subtract_func (G_TYPE_INT64, GST_TYPE_INT64_RANGE,
      gst_value_subtract_int64_int64_range);
  gst_value_register_subtract_func (GST_TYPE_INT64_RANGE, G_TYPE_INT64,
      gst_value_subtract_int64_range_int64);
  gst_value_register_subtract_func (GST_TYPE_INT64_RANGE, GST_TYPE_INT64_RANGE,
      gst_value_subtract_int64_range_int64_range);
  gst_value_register_subtract_func (G_TYPE_DOUBLE, GST_TYPE_DOUBLE_RANGE,
      gst_value_subtract_double_double_range);
  gst_value_register_subtract_func (GST_TYPE_DOUBLE_RANGE, G_TYPE_DOUBLE,
      gst_value_subtract_double_range_double);
  gst_value_register_subtract_func (GST_TYPE_DOUBLE_RANGE,
      GST_TYPE_DOUBLE_RANGE, gst_value_subtract_double_range_double_range);
  gst_value_register_subtract_func (GST_TYPE_FRACTION, GST_TYPE_FRACTION_RANGE,
      gst_value_subtract_fraction_fraction_range);
  gst_value_register_subtract_func (GST_TYPE_FRACTION_RANGE, GST_TYPE_FRACTION,
      gst_value_subtract_fraction_range_fraction);
  gst_value_register_subtract_func (GST_TYPE_FRACTION_RANGE,
      GST_TYPE_FRACTION_RANGE,
      gst_value_subtract_fraction_range_fraction_range);

  /* see bug #317246, #64994, #65041 */
  {
    volatile GType date_type = G_TYPE_DATE;

    g_type_name (date_type);
  }

  gst_value_register_union_func (G_TYPE_INT, GST_TYPE_INT_RANGE,
      gst_value_union_int_int_range);
  gst_value_register_union_func (GST_TYPE_INT_RANGE, GST_TYPE_INT_RANGE,
      gst_value_union_int_range_int_range);

#if 0
  /* Implement these if needed */
  gst_value_register_union_func (GST_TYPE_FRACTION, GST_TYPE_FRACTION_RANGE,
      gst_value_union_fraction_fraction_range);
  gst_value_register_union_func (GST_TYPE_FRACTION_RANGE,
      GST_TYPE_FRACTION_RANGE, gst_value_union_fraction_range_fraction_range);
#endif
}
