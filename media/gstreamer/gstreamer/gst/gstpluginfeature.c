/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *
 * gstpluginfeature.c: Abstract base class for all plugin features
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
 * SECTION:gstpluginfeature
 * @short_description: Base class for contents of a GstPlugin
 * @see_also: #GstPlugin
 *
 * This is a base class for anything that can be added to a #GstPlugin.
 */

#include "gst_private.h"

#include "gstpluginfeature.h"
#include "gstplugin.h"
#include "gstregistry.h"
#include "gstinfo.h"

#include <stdio.h>
#include <string.h>

#define GST_CAT_DEFAULT GST_CAT_PLUGIN_LOADING

static void gst_plugin_feature_finalize (GObject * object);

/* static guint gst_plugin_feature_signals[LAST_SIGNAL] = { 0 }; */

G_DEFINE_ABSTRACT_TYPE (GstPluginFeature, gst_plugin_feature, GST_TYPE_OBJECT);

static void
gst_plugin_feature_class_init (GstPluginFeatureClass * klass)
{
  G_OBJECT_CLASS (klass)->finalize = gst_plugin_feature_finalize;
}

static void
gst_plugin_feature_init (GstPluginFeature * feature)
{
  /* do nothing, needed because of G_DEFINE_TYPE */
}

static void
gst_plugin_feature_finalize (GObject * object)
{
  GstPluginFeature *feature = GST_PLUGIN_FEATURE_CAST (object);

  GST_DEBUG ("finalizing feature %p: '%s'", feature, GST_OBJECT_NAME (feature));

  if (feature->plugin != NULL) {
    g_object_remove_weak_pointer ((GObject *) feature->plugin,
        (gpointer *) & feature->plugin);
  }

  G_OBJECT_CLASS (gst_plugin_feature_parent_class)->finalize (object);
}

/**
 * gst_plugin_feature_load:
 * @feature: (transfer none): the plugin feature to check
 *
 * Loads the plugin containing @feature if it's not already loaded. @feature is
 * unaffected; use the return value instead.
 *
 * Normally this function is used like this:
 * |[
 * GstPluginFeature *loaded_feature;
 *
 * loaded_feature = gst_plugin_feature_load (feature);
 * // presumably, we're no longer interested in the potentially-unloaded feature
 * gst_object_unref (feature);
 * feature = loaded_feature;
 * ]|
 *
 * Returns: (transfer full) (nullable): a reference to the loaded
 * feature, or %NULL on error
 */
GstPluginFeature *
gst_plugin_feature_load (GstPluginFeature * feature)
{
  GstPlugin *plugin;
  GstPluginFeature *real_feature;

  g_return_val_if_fail (feature != NULL, FALSE);
  g_return_val_if_fail (GST_IS_PLUGIN_FEATURE (feature), FALSE);

  GST_DEBUG ("loading plugin for feature %p; '%s'", feature,
      GST_OBJECT_NAME (feature));
  if (feature->loaded)
    return gst_object_ref (feature);

  GST_DEBUG ("loading plugin %s", feature->plugin_name);
  plugin = gst_plugin_load_by_name (feature->plugin_name);
  if (!plugin)
    goto load_failed;

  GST_DEBUG ("loaded plugin %s", feature->plugin_name);
  gst_object_unref (plugin);

  real_feature = gst_registry_lookup_feature (gst_registry_get (),
      GST_OBJECT_NAME (feature));

  if (real_feature == NULL)
    goto disappeared;
  else if (!real_feature->loaded)
    goto not_found;

  return real_feature;

  /* ERRORS */
load_failed:
  {
    GST_WARNING ("Failed to load plugin containing feature '%s'.",
        GST_OBJECT_NAME (feature));
    return NULL;
  }
disappeared:
  {
    GST_INFO
        ("Loaded plugin containing feature '%s', but feature disappeared.",
        GST_OBJECT_NAME (feature));
    return NULL;
  }
not_found:
  {
    GST_INFO ("Tried to load plugin containing feature '%s', but feature was "
        "not found.", GST_OBJECT_NAME (real_feature));
    return NULL;
  }
}

/**
 * gst_plugin_feature_set_rank:
 * @feature: feature to rank
 * @rank: rank value - higher number means more priority rank
 *
 * Specifies a rank for a plugin feature, so that autoplugging uses
 * the most appropriate feature.
 */
void
gst_plugin_feature_set_rank (GstPluginFeature * feature, guint rank)
{
  g_return_if_fail (feature != NULL);
  g_return_if_fail (GST_IS_PLUGIN_FEATURE (feature));

  feature->rank = rank;
}

/**
 * gst_plugin_feature_get_rank:
 * @feature: a feature
 *
 * Gets the rank of a plugin feature.
 *
 * Returns: The rank of the feature
 */
guint
gst_plugin_feature_get_rank (GstPluginFeature * feature)
{
  g_return_val_if_fail (GST_IS_PLUGIN_FEATURE (feature), GST_RANK_NONE);

  return feature->rank;
}

/**
 * gst_plugin_feature_get_plugin:
 * @feature: a feature
 *
 * Get the plugin that provides this feature.
 *
 * Returns: (transfer full) (nullable): the plugin that provides this
 *     feature, or %NULL.  Unref with gst_object_unref() when no
 *     longer needed.
 */
GstPlugin *
gst_plugin_feature_get_plugin (GstPluginFeature * feature)
{
  g_return_val_if_fail (GST_IS_PLUGIN_FEATURE (feature), NULL);

  if (feature->plugin == NULL)
    return NULL;

  return (GstPlugin *) gst_object_ref (feature->plugin);
}

/**
 * gst_plugin_feature_get_plugin_name:
 * @feature: a feature
 *
 * Get the name of the plugin that provides this feature.
 *
 * Returns: (nullable): the name of the plugin that provides this
 *     feature, or %NULL if the feature is not associated with a
 *     plugin.
 *
 * Since: 1.2
 */
const gchar *
gst_plugin_feature_get_plugin_name (GstPluginFeature * feature)
{
  g_return_val_if_fail (GST_IS_PLUGIN_FEATURE (feature), NULL);

  if (feature->plugin == NULL)
    return NULL;

  return gst_plugin_get_name (feature->plugin);
}

/**
 * gst_plugin_feature_list_free:
 * @list: (transfer full) (element-type Gst.PluginFeature): list
 *     of #GstPluginFeature
 *
 * Unrefs each member of @list, then frees the list.
 */
void
gst_plugin_feature_list_free (GList * list)
{
  GList *g;

  for (g = list; g; g = g->next) {
    GstPluginFeature *feature = GST_PLUGIN_FEATURE_CAST (g->data);

    gst_object_unref (feature);
  }
  g_list_free (list);
}

/**
 * gst_plugin_feature_list_copy:
 * @list: (transfer none) (element-type Gst.PluginFeature): list
 *     of #GstPluginFeature
 *
 * Copies the list of features. Caller should call @gst_plugin_feature_list_free
 * when done with the list.
 *
 * Returns: (transfer full) (element-type Gst.PluginFeature): a copy of @list,
 *     with each feature's reference count incremented.
 */
GList *
gst_plugin_feature_list_copy (GList * list)
{
  GList *new_list = NULL;

  if (G_LIKELY (list)) {
    GList *last;

    new_list = g_list_alloc ();
    new_list->data = gst_object_ref (list->data);
    new_list->prev = NULL;
    last = new_list;
    list = list->next;
    while (list) {
      last->next = g_list_alloc ();
      last->next->prev = last;
      last = last->next;
      last->data = gst_object_ref (list->data);
      list = list->next;
    }
    last->next = NULL;
  }

  return new_list;
}

/**
 * gst_plugin_feature_list_debug:
 * @list: (transfer none) (element-type Gst.PluginFeature): a #GList of
 *     plugin features
 *
 * Debug the plugin feature names in @list.
 */
void
gst_plugin_feature_list_debug (GList * list)
{
#ifndef GST_DISABLE_GST_DEBUG
  while (list) {
    GST_DEBUG ("%s",
        gst_plugin_feature_get_name ((GstPluginFeature *) list->data));
    list = list->next;
  }
#endif
}

/**
 * gst_plugin_feature_check_version:
 * @feature: a feature
 * @min_major: minimum required major version
 * @min_minor: minimum required minor version
 * @min_micro: minimum required micro version
 *
 * Checks whether the given plugin feature is at least
 *  the required version
 *
 * Returns: %TRUE if the plugin feature has at least
 *  the required version, otherwise %FALSE.
 */
gboolean
gst_plugin_feature_check_version (GstPluginFeature * feature,
    guint min_major, guint min_minor, guint min_micro)
{
  GstRegistry *registry;
  GstPlugin *plugin;
  gboolean ret = FALSE;

  g_return_val_if_fail (feature != NULL, FALSE);
  g_return_val_if_fail (GST_IS_PLUGIN_FEATURE (feature), FALSE);

  GST_DEBUG ("Looking up plugin '%s' containing plugin feature '%s'",
      feature->plugin_name, GST_OBJECT_NAME (feature));

  registry = gst_registry_get ();
  plugin = gst_registry_find_plugin (registry, feature->plugin_name);

  if (plugin) {
    const gchar *ver_str;
    guint major, minor, micro, nano;
    gint nscan;

    ver_str = gst_plugin_get_version (plugin);
    g_return_val_if_fail (ver_str != NULL, FALSE);

    nscan = sscanf (ver_str, "%u.%u.%u.%u", &major, &minor, &micro, &nano);
    GST_DEBUG ("version string '%s' parsed to %d values", ver_str, nscan);

    if (nscan >= 3) {
      if (major > min_major)
        ret = TRUE;
      else if (major < min_major)
        ret = FALSE;
      else if (minor > min_minor)
        ret = TRUE;
      else if (minor < min_minor)
        ret = FALSE;
      else if (micro > min_micro)
        ret = TRUE;
      /* micro is 1 smaller but we have a nano version, this is the upcoming
       * release of the requested version and we're ok then */
      else if (nscan == 4 && nano > 0 && (micro + 1 == min_micro))
        ret = TRUE;
      else
        ret = (micro == min_micro);

      GST_DEBUG ("Checking whether %u.%u.%u >= %u.%u.%u? %s", major, minor,
          micro, min_major, min_minor, min_micro, (ret) ? "yes" : "no");
    } else {
      GST_WARNING ("Could not parse version string '%s' of plugin '%s'",
          ver_str, feature->plugin_name);
    }

    gst_object_unref (plugin);
  } else {
    GST_DEBUG ("Could not find plugin '%s'", feature->plugin_name);
  }

  return ret;
}

/**
 * gst_plugin_feature_rank_compare_func:
 * @p1: a #GstPluginFeature
 * @p2: a #GstPluginFeature
 *
 * Compares the two given #GstPluginFeature instances. This function can be
 * used as a #GCompareFunc when sorting by rank and then by name.
 *
 * Returns: negative value if the rank of p1 > the rank of p2 or the ranks are
 * equal but the name of p1 comes before the name of p2; zero if the rank
 * and names are equal; positive value if the rank of p1 < the rank of p2 or the
 * ranks are equal but the name of p2 comes before the name of p1
 */
gint
gst_plugin_feature_rank_compare_func (gconstpointer p1, gconstpointer p2)
{
  GstPluginFeature *f1, *f2;
  gint diff;

  f1 = (GstPluginFeature *) p1;
  f2 = (GstPluginFeature *) p2;

  diff = f2->rank - f1->rank;
  if (diff != 0)
    return diff;

  diff = strcmp (GST_OBJECT_NAME (f1), GST_OBJECT_NAME (f2));

  return diff;
}
