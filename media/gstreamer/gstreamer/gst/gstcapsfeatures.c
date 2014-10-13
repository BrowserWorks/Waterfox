/* GStreamer
 * Copyright (C) 2013 Collabora Ltd.
 *   Author: Sebastian Dröge <sebastian.droege@collabora.co.uk>
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
 * SECTION:gstcapsfeatures
 * @short_description: A set of features in caps 
 * @see_also: #GstCaps
 *
 * #GstCapsFeatures can optionally be set on a #GstCaps to add requirements
 * for additional features for a specific #GstStructure. Caps structures with
 * the same name but with a non-equal set of caps features are not compatible.
 * If a pad supports multiple sets of features it has to add multiple equal
 * structures with different feature sets to the caps.
 *
 * Empty #GstCapsFeatures are equivalent with the #GstCapsFeatures that only
 * contain #GST_CAPS_FEATURE_MEMORY_SYSTEM_MEMORY. ANY #GstCapsFeatures as
 * created by gst_caps_features_new_any() are equal to any other #GstCapsFeatures
 * and can be used to specify that any #GstCapsFeatures would be supported, e.g.
 * for elements that don't touch buffer memory. #GstCaps with ANY #GstCapsFeatures
 * are considered non-fixed and during negotiation some #GstCapsFeatures have
 * to be selected.
 *
 * Examples for caps features would be the requirement of a specific #GstMemory
 * types or the requirement of having a specific #GstMeta on the buffer. Features
 * are given as a string of the format "memory:GstMemoryTypeName" or
 * "meta:GstMetaAPIName".
 *
 * Since: 1.2
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include "gst_private.h"
#include "gstcapsfeatures.h"
#include <gst/gst.h>

GST_DEBUG_CATEGORY_STATIC (gst_caps_features_debug);
#define GST_CAT_DEFAULT gst_caps_features_debug

struct _GstCapsFeatures
{
  GType type;
  gint *parent_refcount;
  GArray *array;
  gboolean is_any;
};

GType _gst_caps_features_type = 0;
static gint static_caps_features_parent_refcount = G_MAXINT;
GstCapsFeatures *_gst_caps_features_any = NULL;
GstCapsFeatures *_gst_caps_features_memory_system_memory = NULL;
static GQuark _gst_caps_feature_memory_system_memory = 0;

G_DEFINE_BOXED_TYPE (GstCapsFeatures, gst_caps_features,
    gst_caps_features_copy, gst_caps_features_free);

#define IS_MUTABLE(features) \
    (!features->parent_refcount || \
     g_atomic_int_get (features->parent_refcount) == 1)

static void
gst_caps_features_transform_to_string (const GValue * src_value,
    GValue * dest_value);

void
_priv_gst_caps_features_initialize (void)
{
  GST_DEBUG_CATEGORY_INIT (gst_caps_features_debug, "caps-features", 0,
      "GstCapsFeatures debug");

  _gst_caps_features_type = gst_caps_features_get_type ();
  _gst_caps_feature_memory_system_memory =
      g_quark_from_static_string (GST_CAPS_FEATURE_MEMORY_SYSTEM_MEMORY);

  g_value_register_transform_func (_gst_caps_features_type, G_TYPE_STRING,
      gst_caps_features_transform_to_string);

  _gst_caps_features_any = gst_caps_features_new_any ();
  gst_caps_features_set_parent_refcount (_gst_caps_features_any,
      &static_caps_features_parent_refcount);
  _gst_caps_features_memory_system_memory =
      gst_caps_features_new_id (_gst_caps_feature_memory_system_memory, 0);
  gst_caps_features_set_parent_refcount
      (_gst_caps_features_memory_system_memory,
      &static_caps_features_parent_refcount);
}

gboolean
gst_is_caps_features (gconstpointer obj)
{
  const GstCapsFeatures *features = obj;

  return (obj != NULL && features->type == _gst_caps_features_type);
}

static gboolean
gst_caps_feature_name_is_valid (const gchar * feature)
{
#ifndef G_DISABLE_CHECKS
  while (TRUE) {
    if (g_ascii_isalpha (*feature))
      feature++;
    else if (*feature == ':')
      break;
    else
      return FALSE;
  }

  if (*feature != ':')
    return FALSE;

  feature++;
  if (*feature == '\0' || !g_ascii_isalpha (*feature))
    return FALSE;

  while (TRUE) {
    if (g_ascii_isalnum (*feature))
      feature++;
    else if (*feature == '\0')
      break;
    else
      return FALSE;
  }
#endif

  return TRUE;
}

/**
 * gst_caps_features_new_empty:
 *
 * Creates a new, empty #GstCapsFeatures.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new, empty #GstCapsFeatures
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_new_empty (void)
{
  GstCapsFeatures *features;

  features = g_slice_new (GstCapsFeatures);
  features->type = _gst_caps_features_type;
  features->parent_refcount = NULL;
  features->array = g_array_new (FALSE, FALSE, sizeof (GQuark));
  features->is_any = FALSE;

  GST_TRACE ("created caps features %p", features);

  return features;
}

/**
 * gst_caps_features_new_any:
 *
 * Creates a new, ANY #GstCapsFeatures. This will be equal
 * to any other #GstCapsFeatures but caps with these are
 * unfixed.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new, ANY #GstCapsFeatures
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_new_any (void)
{
  GstCapsFeatures *features;

  features = gst_caps_features_new_empty ();
  features->is_any = TRUE;

  return features;
}

/**
 * gst_caps_features_new:
 * @feature1: name of first feature to set
 * @...: additional features
 *
 * Creates a new #GstCapsFeatures with the given features.
 * The last argument must be %NULL.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new, empty #GstCapsFeatures
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_new (const gchar * feature1, ...)
{
  GstCapsFeatures *features;
  va_list varargs;

  g_return_val_if_fail (feature1 != NULL, NULL);

  va_start (varargs, feature1);
  features = gst_caps_features_new_valist (feature1, varargs);
  va_end (varargs);

  return features;
}

/**
 * gst_caps_features_new_valist:
 * @feature1: name of first feature to set
 * @varargs: variable argument list
 *
 * Creates a new #GstCapsFeatures with the given features.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new, empty #GstCapsFeatures
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_new_valist (const gchar * feature1, va_list varargs)
{
  GstCapsFeatures *features;

  g_return_val_if_fail (feature1 != NULL, NULL);

  features = gst_caps_features_new_empty ();

  while (feature1) {
    gst_caps_features_add (features, feature1);
    feature1 = va_arg (varargs, const gchar *);
  }

  return features;
}

/**
 * gst_caps_features_new_id:
 * @feature1: name of first feature to set
 * @...: additional features
 *
 * Creates a new #GstCapsFeatures with the given features.
 * The last argument must be 0.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new, empty #GstCapsFeatures
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_new_id (GQuark feature1, ...)
{
  GstCapsFeatures *features;
  va_list varargs;

  g_return_val_if_fail (feature1 != 0, NULL);

  va_start (varargs, feature1);
  features = gst_caps_features_new_id_valist (feature1, varargs);
  va_end (varargs);

  return features;
}

/**
 * gst_caps_features_new_id_valist:
 * @feature1: name of first feature to set
 * @varargs: variable argument list
 *
 * Creates a new #GstCapsFeatures with the given features.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new, empty #GstCapsFeatures
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_new_id_valist (GQuark feature1, va_list varargs)
{
  GstCapsFeatures *features;

  g_return_val_if_fail (feature1 != 0, NULL);

  features = gst_caps_features_new_empty ();

  while (feature1) {
    gst_caps_features_add_id (features, feature1);
    feature1 = va_arg (varargs, GQuark);
  }

  return features;
}

/**
 * gst_caps_features_set_parent_refcount:
 * @features: a #GstCapsFeatures
 * @refcount: (in): a pointer to the parent's refcount
 *
 * Sets the parent_refcount field of #GstCapsFeatures. This field is used to
 * determine whether a caps features is mutable or not. This function should only be
 * called by code implementing parent objects of #GstCapsFeatures, as described in
 * the MT Refcounting section of the design documents.
 *
 * Returns: %TRUE if the parent refcount could be set.
 *
 * Since: 1.2
 */
gboolean
gst_caps_features_set_parent_refcount (GstCapsFeatures * features,
    gint * refcount)
{
  g_return_val_if_fail (features != NULL, FALSE);

  /* if we have a parent_refcount already, we can only clear
   * if with a NULL refcount */
  if (features->parent_refcount) {
    if (refcount != NULL) {
      g_return_val_if_fail (refcount == NULL, FALSE);
      return FALSE;
    }
  } else {
    if (refcount == NULL) {
      g_return_val_if_fail (refcount != NULL, FALSE);
      return FALSE;
    }
  }

  features->parent_refcount = refcount;

  return TRUE;
}

/**
 * gst_caps_features_copy:
 * @features: a #GstCapsFeatures to duplicate
 *
 * Duplicates a #GstCapsFeatures and all its values.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full): a new #GstCapsFeatures.
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_copy (const GstCapsFeatures * features)
{
  GstCapsFeatures *copy;
  guint i, n;

  g_return_val_if_fail (features != NULL, NULL);

  copy = gst_caps_features_new_empty ();
  n = gst_caps_features_get_size (features);
  for (i = 0; i < n; i++)
    gst_caps_features_add_id (copy, gst_caps_features_get_nth_id (features, i));
  copy->is_any = features->is_any;

  return copy;
}

/**
 * gst_caps_features_free:
 * @features: (in) (transfer full): the #GstCapsFeatures to free
 *
 * Frees a #GstCapsFeatures and all its values. The caps features must not
 * have a parent when this function is called.
 *
 * Since: 1.2
 */
void
gst_caps_features_free (GstCapsFeatures * features)
{
  g_return_if_fail (features != NULL);
  g_return_if_fail (features->parent_refcount == NULL);

  g_array_free (features->array, TRUE);
#ifdef USE_POISONING
  memset (features, 0xff, sizeof (GstCapsFeatures));
#endif
  GST_TRACE ("free caps features %p", features);

  g_slice_free (GstCapsFeatures, features);
}

/**
 * gst_caps_features_to_string:
 * @features: a #GstCapsFeatures
 *
 * Converts @features to a human-readable string representation.
 *
 * For debugging purposes its easier to do something like this:
 * |[
 * GST_LOG ("features is %" GST_PTR_FORMAT, features);
 * ]|
 * This prints the features in human readable form.
 *
 * Free-function: g_free
 *
 * Returns: (transfer full): a pointer to string allocated by g_malloc().
 *     g_free() after usage.
 *
 * Since: 1.2
 */
gchar *
gst_caps_features_to_string (const GstCapsFeatures * features)
{
  GString *s;

  g_return_val_if_fail (features != NULL, NULL);

  s = g_string_sized_new (FEATURES_ESTIMATED_STRING_LEN (features));

  priv_gst_caps_features_append_to_gstring (features, s);

  return g_string_free (s, FALSE);
}

void
priv_gst_caps_features_append_to_gstring (const GstCapsFeatures * features,
    GString * s)
{
  guint i, n;

  g_return_if_fail (features != NULL);

  if (features->array->len == 0 && features->is_any) {
    g_string_append (s, "ANY");
    return;
  }

  n = features->array->len;
  for (i = 0; i < n; i++) {
    GQuark *quark = &g_array_index (features->array, GQuark, i);

    g_string_append (s, g_quark_to_string (*quark));
    if (i + 1 < n)
      g_string_append (s, ", ");
  }
}

/**
 * gst_caps_features_from_string:
 * @features: a string representation of a #GstCapsFeatures.
 *
 * Creates a #GstCapsFeatures from a string representation.
 *
 * Free-function: gst_caps_features_free
 *
 * Returns: (transfer full) (nullable): a new #GstCapsFeatures or
 *     %NULL when the string could not be parsed. Free with
 *     gst_caps_features_free() after use.
 *
 * Since: 1.2
 */
GstCapsFeatures *
gst_caps_features_from_string (const gchar * features)
{
  GstCapsFeatures *ret;
  gboolean escape = FALSE;
  const gchar *features_orig = features;
  const gchar *feature;

  ret = gst_caps_features_new_empty ();

  if (!features || *features == '\0')
    return ret;

  if (strcmp (features, "ANY") == 0) {
    ret->is_any = TRUE;
    return ret;
  }

  /* Skip trailing spaces */
  while (*features == ' ')
    features++;

  feature = features;
  while (TRUE) {
    gchar c = *features;

    if (c == '\\') {
      escape = TRUE;
      features++;
      continue;
    } else if ((!escape && c == ',') || c == '\0') {
      guint len = features - feature + 1;
      gchar *tmp;
      gchar *p;

      if (len == 1) {
        g_warning ("Failed deserialize caps features '%s'", features_orig);
        gst_caps_features_free (ret);
        return NULL;
      }

      tmp = g_malloc (len);
      memcpy (tmp, feature, len - 1);
      tmp[len - 1] = '\0';

      p = tmp + len - 1;
      while (*p == ' ') {
        *p = '\0';
        p--;
      }

      if (strstr (tmp, " ") != NULL || *tmp == '\0') {
        g_free (tmp);
        g_warning ("Failed deserialize caps features '%s'", features_orig);
        gst_caps_features_free (ret);
        return NULL;
      }

      gst_caps_features_add (ret, tmp);
      g_free (tmp);

      if (c == '\0')
        break;

      /* Skip to the next value */
      features++;
      while (*features == ' ')
        features++;
      feature = features;
    } else {
      escape = FALSE;
      features++;
    }
  }

  return ret;
}

/**
 * gst_caps_features_get_size:
 * @features: a #GstCapsFeatures.
 *
 * Returns the number of features in @features.
 *
 * Returns: The number of features in @features.
 *
 * Since: 1.2
 */
guint
gst_caps_features_get_size (const GstCapsFeatures * features)
{
  g_return_val_if_fail (features != NULL, 0);

  return features->array->len;
}

/**
 * gst_caps_features_get_nth:
 * @features: a #GstCapsFeatures.
 * @i: index of the feature
 *
 * Returns the @i-th feature of @features.
 *
 * Returns: The @i-th feature of @features.
 *
 * Since: 1.2
 */
const gchar *
gst_caps_features_get_nth (const GstCapsFeatures * features, guint i)
{
  const gchar *feature;
  GQuark quark;

  g_return_val_if_fail (features != NULL, NULL);

  quark = gst_caps_features_get_nth_id (features, i);
  if (!quark)
    return NULL;

  feature = g_quark_to_string (quark);
  return feature;
}

/**
 * gst_caps_features_get_nth_id:
 * @features: a #GstCapsFeatures.
 * @i: index of the feature
 *
 * Returns the @i-th feature of @features.
 *
 * Returns: The @i-th feature of @features.
 *
 * Since: 1.2
 */
GQuark
gst_caps_features_get_nth_id (const GstCapsFeatures * features, guint i)
{
  GQuark *quark;

  g_return_val_if_fail (features != NULL, 0);
  g_return_val_if_fail (i < features->array->len, 0);

  quark = &g_array_index (features->array, GQuark, i);

  return *quark;
}

/**
 * gst_caps_features_contains:
 * @features: a #GstCapsFeatures.
 * @feature: a feature
 *
 * Check if @features contains @feature.
 *
 * Returns: %TRUE if @features contains @feature.
 *
 * Since: 1.2
 */
gboolean
gst_caps_features_contains (const GstCapsFeatures * features,
    const gchar * feature)
{
  g_return_val_if_fail (features != NULL, FALSE);
  g_return_val_if_fail (feature != NULL, FALSE);

  return gst_caps_features_contains_id (features,
      g_quark_from_string (feature));
}

/**
 * gst_caps_features_contains_id:
 * @features: a #GstCapsFeatures.
 * @feature: a feature
 *
 * Check if @features contains @feature.
 *
 * Returns: %TRUE if @features contains @feature.
 *
 * Since: 1.2
 */
gboolean
gst_caps_features_contains_id (const GstCapsFeatures * features, GQuark feature)
{
  guint i, n;

  g_return_val_if_fail (features != NULL, FALSE);
  g_return_val_if_fail (feature != 0, FALSE);

  if (features->is_any)
    return TRUE;

  n = features->array->len;
  if (n == 0)
    return feature == _gst_caps_feature_memory_system_memory;

  for (i = 0; i < n; i++) {
    if (gst_caps_features_get_nth_id (features, i) == feature)
      return TRUE;
  }

  return FALSE;
}

/**
 * gst_caps_features_is_equal:
 * @features1: a #GstCapsFeatures.
 * @features2: a #GstCapsFeatures.
 *
 * Check if @features1 and @features2 are equal.
 *
 * Returns: %TRUE if @features1 and @features2 are equal.
 *
 * Since: 1.2
 */
gboolean
gst_caps_features_is_equal (const GstCapsFeatures * features1,
    const GstCapsFeatures * features2)
{
  guint i, n;

  g_return_val_if_fail (features1 != NULL, FALSE);
  g_return_val_if_fail (features2 != NULL, FALSE);

  if (features1->is_any || features2->is_any)
    return TRUE;

  /* Check for the sysmem==empty case */
  if (features1->array->len == 0 && features2->array->len == 0)
    return TRUE;
  if (features1->array->len == 0 && features2->array->len == 1
      && gst_caps_features_contains_id (features2,
          _gst_caps_feature_memory_system_memory))
    return TRUE;
  if (features2->array->len == 0 && features1->array->len == 1
      && gst_caps_features_contains_id (features1,
          _gst_caps_feature_memory_system_memory))
    return TRUE;

  if (features1->array->len != features2->array->len)
    return FALSE;

  n = features1->array->len;
  for (i = 0; i < n; i++)
    if (!gst_caps_features_contains_id (features2,
            gst_caps_features_get_nth_id (features1, i)))
      return FALSE;

  return TRUE;
}

/**
 * gst_caps_features_is_any:
 * @features: a #GstCapsFeatures.
 *
 * Check if @features is %GST_CAPS_FEATURES_ANY.
 *
 * Returns: %TRUE if @features is %GST_CAPS_FEATURES_ANY.
 *
 * Since: 1.2
 */
gboolean
gst_caps_features_is_any (const GstCapsFeatures * features)
{
  g_return_val_if_fail (features != NULL, FALSE);

  return features->is_any;
}

/**
 * gst_caps_features_add:
 * @features: a #GstCapsFeatures.
 * @feature: a feature.
 *
 * Adds @feature to @features.
 *
 * Since: 1.2
 */
void
gst_caps_features_add (GstCapsFeatures * features, const gchar * feature)
{
  g_return_if_fail (features != NULL);
  g_return_if_fail (IS_MUTABLE (features));
  g_return_if_fail (feature != NULL);
  g_return_if_fail (!features->is_any);

  gst_caps_features_add_id (features, g_quark_from_string (feature));
}

/**
 * gst_caps_features_add_id:
 * @features: a #GstCapsFeatures.
 * @feature: a feature.
 *
 * Adds @feature to @features.
 *
 * Since: 1.2
 */
void
gst_caps_features_add_id (GstCapsFeatures * features, GQuark feature)
{
  g_return_if_fail (features != NULL);
  g_return_if_fail (IS_MUTABLE (features));
  g_return_if_fail (feature != 0);
  g_return_if_fail (!features->is_any);

  if (!gst_caps_feature_name_is_valid (g_quark_to_string (feature))) {
    g_warning ("Invalid caps feature name: %s", g_quark_to_string (feature));
    return;
  }

  /* If features is empty it will contain sysmem, however
   * we want to add it explicitely if it is tried to be
   * added as first features
   */
  if (features->array->len > 0
      && gst_caps_features_contains_id (features, feature))
    return;

  g_array_append_val (features->array, feature);
}

/**
 * gst_caps_features_remove:
 * @features: a #GstCapsFeatures.
 * @feature: a feature.
 *
 * Removes @feature from @features.
 *
 * Since: 1.2
 */
void
gst_caps_features_remove (GstCapsFeatures * features, const gchar * feature)
{
  g_return_if_fail (features != NULL);
  g_return_if_fail (IS_MUTABLE (features));
  g_return_if_fail (feature != NULL);

  gst_caps_features_remove_id (features, g_quark_from_string (feature));
}

/**
 * gst_caps_features_remove_id:
 * @features: a #GstCapsFeatures.
 * @feature: a feature.
 *
 * Removes @feature from @features.
 *
 * Since: 1.2
 */
void
gst_caps_features_remove_id (GstCapsFeatures * features, GQuark feature)
{
  guint i, n;

  g_return_if_fail (features != NULL);
  g_return_if_fail (IS_MUTABLE (features));
  g_return_if_fail (feature != 0);

  n = features->array->len;
  for (i = 0; i < n; i++) {
    GQuark quark = gst_caps_features_get_nth_id (features, i);

    if (quark == feature) {
      g_array_remove_index_fast (features->array, i);
      return;
    }
  }
}

static void
gst_caps_features_transform_to_string (const GValue * src_value,
    GValue * dest_value)
{
  g_return_if_fail (src_value != NULL);
  g_return_if_fail (dest_value != NULL);

  dest_value->data[0].v_pointer =
      gst_caps_features_to_string (src_value->data[0].v_pointer);
}
