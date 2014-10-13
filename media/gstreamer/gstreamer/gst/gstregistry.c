/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 David A. Schleef <ds@schleef.org>
 *
 * gstregistry.c: handle registry
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
 * SECTION:gstregistry
 * @short_description: Abstract base class for management of #GstPlugin objects
 * @see_also: #GstPlugin, #GstPluginFeature
 *
 * One registry holds the metadata of a set of plugins.
 *
 * <emphasis role="bold">Design:</emphasis>
 *
 * The #GstRegistry object is a list of plugins and some functions for dealing
 * with them. Each #GstPlugin is matched 1-1 with a file on disk, and may or may
 * not be loaded at a given time.
 *
 * The primary source, at all times, of plugin information is each plugin file
 * itself. Thus, if an application wants information about a particular plugin,
 * or wants to search for a feature that satisfies given criteria, the primary
 * means of doing so is to load every plugin and look at the resulting
 * information that is gathered in the default registry. Clearly, this is a time
 * consuming process, so we cache information in the registry file. The format
 * and location of the cache file is internal to gstreamer.
 *
 * On startup, plugins are searched for in the plugin search path. The following
 * locations are checked in this order:
 * <itemizedlist>
 *   <listitem>
 *     <para>location from --gst-plugin-path commandline option.</para>
 *   </listitem>
 *   <listitem>
 *     <para>the GST_PLUGIN_PATH environment variable.</para>
 *   </listitem>
 *   <listitem>
 *     <para>the GST_PLUGIN_SYSTEM_PATH environment variable.</para>
 *   </listitem>
 *   <listitem>
 *     <para>default locations (if GST_PLUGIN_SYSTEM_PATH is not set). Those
 *       default locations are:
 *       <filename>$XDG_DATA_HOME/gstreamer-$GST_API_VERSION/plugins/</filename>
 *       and <filename>$prefix/libs/gstreamer-$GST_API_VERSION/</filename>.
 *       <ulink url="http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html">
 *       <filename>$XDG_DATA_HOME</filename></ulink> defaults to
 *       <filename>$HOME/.local/share</filename>.
 *     </para>
 *   </listitem>
 * </itemizedlist>
 * The registry cache file is loaded from
 * <filename>$XDG_CACHE_HOME/gstreamer-$GST_API_VERSION/registry-$ARCH.bin</filename>
 * (where
 * <ulink url="http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html">
 * <filename>$XDG_CACHE_HOME</filename></ulink> defaults to
 * <filename>$HOME/.cache</filename>) or the file listed in the GST_REGISTRY
 * env var. One reason to change the registry location is for testing.
 *
 * For each plugin that is found in the plugin search path, there could be 3
 * possibilities for cached information:
 * <itemizedlist>
 *   <listitem>
 *     <para>the cache may not contain information about a given file.</para>
 *   </listitem>
 *   <listitem>
 *     <para>the cache may have stale information.</para>
 *   </listitem>
 *   <listitem>
 *     <para>the cache may have current information.</para>
 *   </listitem>
 * </itemizedlist>
 *
 * In the first two cases, the plugin is loaded and the cache updated. In
 * addition to these cases, the cache may have entries for plugins that are not
 * relevant to the current process. These are marked as not available to the
 * current process. If the cache is updated for whatever reason, it is marked
 * dirty.
 *
 * A dirty cache is written out at the end of initialization. Each entry is
 * checked to make sure the information is minimally valid. If not, the entry is
 * simply dropped.
 *
 * <emphasis role="bold">Implementation notes:</emphasis>
 *
 * The "cache" and "registry" are different concepts and can represent
 * different sets of plugins. For various reasons, at init time, the cache is
 * stored in the default registry, and plugins not relevant to the current
 * process are marked with the %GST_PLUGIN_FLAG_CACHED bit. These plugins are
 * removed at the end of initialization.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include "gstconfig.h"
#include "gst_private.h"
#include <glib.h>
#include <sys/types.h>
#include <sys/stat.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <errno.h>
#include <stdio.h>
#include <string.h>

/* For g_stat () */
#include <glib/gstdio.h>

#include "gstinfo.h"
#include "gsterror.h"
#include "gstregistry.h"
#include "gstdeviceproviderfactory.h"

#include "gstpluginloader.h"

#include "gst-i18n-lib.h"

#include "gst.h"
#include "glib-compat-private.h"

#ifdef G_OS_WIN32
#include <windows.h>
extern HMODULE _priv_gst_dll_handle;
#endif

#define GST_CAT_DEFAULT GST_CAT_REGISTRY

struct _GstRegistryPrivate
{
  GList *plugins;
  GList *features;

#if 0
  GList *paths;
#endif

  int cache_file;

  /* hash to speedup _lookup_feature_locked() */
  GHashTable *feature_hash;
  /* hash to speedup _lookup */
  GHashTable *basename_hash;

  /* updated whenever the feature list changes */
  guint32 cookie;
  /* speedup for searching features */
  GList *element_factory_list;
  guint32 efl_cookie;
  GList *typefind_factory_list;
  guint32 tfl_cookie;
  GList *device_provider_factory_list;
  guint32 dmfl_cookie;
};

/* the one instance of the default registry and the mutex protecting the
 * variable. */
static GMutex _gst_registry_mutex;
static GstRegistry *_gst_registry_default = NULL;

/* defaults */
#define DEFAULT_FORK TRUE

/* control the behaviour of registry rebuild */
static gboolean _gst_enable_registry_fork = DEFAULT_FORK;
/* List of plugins that need preloading/reloading after scanning registry */
extern GSList *_priv_gst_preload_plugins;

#ifndef GST_DISABLE_REGISTRY
/*set to TRUE when registry needn't to be updated */
gboolean _priv_gst_disable_registry_update = FALSE;
extern GList *_priv_gst_plugin_paths;

/* Set to TRUE when the registry cache should be disabled */
gboolean _gst_disable_registry_cache = FALSE;

static gboolean __registry_reuse_plugin_scanner = TRUE;
#endif

/* Element signals and args */
enum
{
  PLUGIN_ADDED,
  FEATURE_ADDED,
  LAST_SIGNAL
};

static void gst_registry_finalize (GObject * object);

static guint gst_registry_signals[LAST_SIGNAL] = { 0 };

static GstPluginFeature *gst_registry_lookup_feature_locked (GstRegistry *
    registry, const char *name);
static GstPlugin *gst_registry_lookup_bn_locked (GstRegistry * registry,
    const char *basename);

#define gst_registry_parent_class parent_class
G_DEFINE_TYPE (GstRegistry, gst_registry, GST_TYPE_OBJECT);

static void
gst_registry_class_init (GstRegistryClass * klass)
{
  GObjectClass *gobject_class;

  gobject_class = (GObjectClass *) klass;

  g_type_class_add_private (klass, sizeof (GstRegistryPrivate));

  /**
   * GstRegistry::plugin-added:
   * @registry: the registry that emitted the signal
   * @plugin: the plugin that has been added
   *
   * Signals that a plugin has been added to the registry (possibly
   * replacing a previously-added one by the same name)
   */
  gst_registry_signals[PLUGIN_ADDED] =
      g_signal_new ("plugin-added", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 1, GST_TYPE_PLUGIN);

  /**
   * GstRegistry::feature-added:
   * @registry: the registry that emitted the signal
   * @feature: the feature that has been added
   *
   * Signals that a feature has been added to the registry (possibly
   * replacing a previously-added one by the same name)
   */
  gst_registry_signals[FEATURE_ADDED] =
      g_signal_new ("feature-added", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_generic,
      G_TYPE_NONE, 1, GST_TYPE_PLUGIN_FEATURE);

  gobject_class->finalize = gst_registry_finalize;
}

static void
gst_registry_init (GstRegistry * registry)
{
  registry->priv =
      G_TYPE_INSTANCE_GET_PRIVATE (registry, GST_TYPE_REGISTRY,
      GstRegistryPrivate);
  registry->priv->feature_hash = g_hash_table_new (g_str_hash, g_str_equal);
  registry->priv->basename_hash = g_hash_table_new (g_str_hash, g_str_equal);
}

static void
gst_registry_finalize (GObject * object)
{
  GstRegistry *registry = GST_REGISTRY (object);
  GList *plugins, *p;
  GList *features, *f;

  plugins = registry->priv->plugins;
  registry->priv->plugins = NULL;

  GST_DEBUG_OBJECT (registry, "registry finalize");
  p = plugins;
  while (p) {
    GstPlugin *plugin = p->data;

    if (plugin) {
      GST_LOG_OBJECT (registry, "removing plugin %s",
          gst_plugin_get_name (plugin));
      gst_object_unref (plugin);
    }
    p = g_list_next (p);
  }
  g_list_free (plugins);

  features = registry->priv->features;
  registry->priv->features = NULL;

  f = features;
  while (f) {
    GstPluginFeature *feature = f->data;

    if (feature) {
      GST_LOG_OBJECT (registry, "removing feature %p (%s)", feature,
          GST_OBJECT_NAME (feature));
      gst_object_unparent (GST_OBJECT_CAST (feature));
    }
    f = g_list_next (f);
  }
  g_list_free (features);

  g_hash_table_destroy (registry->priv->feature_hash);
  registry->priv->feature_hash = NULL;
  g_hash_table_destroy (registry->priv->basename_hash);
  registry->priv->basename_hash = NULL;

  if (registry->priv->element_factory_list) {
    GST_DEBUG_OBJECT (registry, "Cleaning up cached element factory list");
    gst_plugin_feature_list_free (registry->priv->element_factory_list);
  }

  if (registry->priv->typefind_factory_list) {
    GST_DEBUG_OBJECT (registry, "Cleaning up cached typefind factory list");
    gst_plugin_feature_list_free (registry->priv->typefind_factory_list);
  }

  if (registry->priv->device_provider_factory_list) {
    GST_DEBUG_OBJECT (registry,
        "Cleaning up cached device provider factory list");
    gst_plugin_feature_list_free (registry->priv->device_provider_factory_list);
  }

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

/**
 * gst_registry_get:
 *
 * Retrieves the singleton plugin registry. The caller does not own a
 * reference on the registry, as it is alive as long as GStreamer is
 * initialized.
 *
 * Returns: (transfer none): the #GstRegistry.
 */
GstRegistry *
gst_registry_get (void)
{
  GstRegistry *registry;

  g_mutex_lock (&_gst_registry_mutex);
  if (G_UNLIKELY (!_gst_registry_default)) {
    _gst_registry_default = g_object_newv (GST_TYPE_REGISTRY, 0, NULL);
    gst_object_ref_sink (GST_OBJECT_CAST (_gst_registry_default));
  }
  registry = _gst_registry_default;
  g_mutex_unlock (&_gst_registry_mutex);

  return registry;
}

#if 0
/**
 * gst_registry_add_path:
 * @registry: the registry to add the path to
 * @path: the path to add to the registry
 *
 * Add the given path to the registry. The syntax of the
 * path is specific to the registry. If the path has already been
 * added, do nothing.
 */
void
gst_registry_add_path (GstRegistry * registry, const gchar * path)
{
  g_return_if_fail (GST_IS_REGISTRY (registry));
  g_return_if_fail (path != NULL);

  if (strlen (path) == 0)
    goto empty_path;

  GST_OBJECT_LOCK (registry);
  if (g_list_find_custom (registry->priv->paths, path, (GCompareFunc) strcmp))
    goto was_added;

  GST_INFO ("Adding plugin path: \"%s\"", path);
  registry->priv->paths =
      g_list_append (registry->priv->paths, g_strdup (path));
  GST_OBJECT_UNLOCK (registry);

  return;

empty_path:
  {
    GST_INFO ("Ignoring empty plugin path");
    return;
  }
was_added:
  {
    g_warning ("path %s already added to registry", path);
    GST_OBJECT_UNLOCK (registry);
    return;
  }
}

/**
 * gst_registry_get_path_list:
 * @registry: the registry to get the pathlist of
 *
 * Get the list of paths for the given registry.
 *
 * Returns: (transfer container) (element-type char*): A #GList of paths as
 *     strings. g_list_free after use.
 *
 * MT safe.
 */
GList *
gst_registry_get_path_list (GstRegistry * registry)
{
  GList *list;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);

  GST_OBJECT_LOCK (registry);
  /* We don't need to copy the strings, because they won't be deleted
   * as long as the GstRegistry is around */
  list = g_list_copy (registry->priv->paths);
  GST_OBJECT_UNLOCK (registry);

  return list;
}
#endif

/**
 * gst_registry_add_plugin:
 * @registry: the registry to add the plugin to
 * @plugin: (transfer full): the plugin to add
 *
 * Add the plugin to the registry. The plugin-added signal will be emitted.
 * This function will sink @plugin.
 *
 * Returns: %TRUE on success.
 *
 * MT safe.
 */
gboolean
gst_registry_add_plugin (GstRegistry * registry, GstPlugin * plugin)
{
  GstPlugin *existing_plugin;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), FALSE);
  g_return_val_if_fail (GST_IS_PLUGIN (plugin), FALSE);

  GST_OBJECT_LOCK (registry);
  if (G_LIKELY (plugin->basename)) {
    /* we have a basename, see if we find the plugin */
    existing_plugin =
        gst_registry_lookup_bn_locked (registry, plugin->basename);
    if (existing_plugin) {
      GST_DEBUG_OBJECT (registry,
          "Replacing existing plugin \"%s\" %p with new plugin %p for filename \"%s\"",
          GST_STR_NULL (existing_plugin->filename), existing_plugin, plugin,
          GST_STR_NULL (plugin->filename));
      /* If the new plugin is blacklisted and the existing one isn't cached, do not
       * accept if it's from a different location than the existing one */
      if (GST_OBJECT_FLAG_IS_SET (plugin, GST_PLUGIN_FLAG_BLACKLISTED) &&
          strcmp (plugin->filename, existing_plugin->filename)) {
        GST_WARNING_OBJECT (registry,
            "Not replacing plugin because new one (%s) is blacklisted but for a different location than existing one (%s)",
            plugin->filename, existing_plugin->filename);
        gst_object_unref (plugin);
        GST_OBJECT_UNLOCK (registry);
        return FALSE;
      }
      registry->priv->plugins =
          g_list_remove (registry->priv->plugins, existing_plugin);
      if (G_LIKELY (existing_plugin->basename))
        g_hash_table_remove (registry->priv->basename_hash,
            existing_plugin->basename);
      gst_object_unref (existing_plugin);
    }
  }

  GST_DEBUG_OBJECT (registry, "adding plugin %p for filename \"%s\"",
      plugin, GST_STR_NULL (plugin->filename));

  registry->priv->plugins = g_list_prepend (registry->priv->plugins, plugin);
  if (G_LIKELY (plugin->basename))
    g_hash_table_replace (registry->priv->basename_hash, plugin->basename,
        plugin);

  gst_object_ref_sink (plugin);
  GST_OBJECT_UNLOCK (registry);

  GST_LOG_OBJECT (registry, "emitting plugin-added for filename \"%s\"",
      GST_STR_NULL (plugin->filename));
  g_signal_emit (registry, gst_registry_signals[PLUGIN_ADDED], 0, plugin);

  return TRUE;
}

static void
gst_registry_remove_features_for_plugin_unlocked (GstRegistry * registry,
    GstPlugin * plugin)
{
  GList *f;

  g_return_if_fail (GST_IS_REGISTRY (registry));
  g_return_if_fail (GST_IS_PLUGIN (plugin));

  /* Remove all features for this plugin */
  f = registry->priv->features;
  while (f != NULL) {
    GList *next = g_list_next (f);
    GstPluginFeature *feature = f->data;

    if (G_UNLIKELY (feature && feature->plugin == plugin)) {
      GST_DEBUG_OBJECT (registry, "removing feature %p (%s) for plugin %p (%s)",
          feature, gst_plugin_feature_get_name (feature), plugin,
          plugin->desc.name);

      registry->priv->features =
          g_list_delete_link (registry->priv->features, f);
      g_hash_table_remove (registry->priv->feature_hash,
          GST_OBJECT_NAME (feature));
      gst_object_unparent (GST_OBJECT_CAST (feature));
    }
    f = next;
  }
  registry->priv->cookie++;
}

/**
 * gst_registry_remove_plugin:
 * @registry: the registry to remove the plugin from
 * @plugin: (transfer none): the plugin to remove
 *
 * Remove the plugin from the registry.
 *
 * MT safe.
 */
void
gst_registry_remove_plugin (GstRegistry * registry, GstPlugin * plugin)
{
  g_return_if_fail (GST_IS_REGISTRY (registry));
  g_return_if_fail (GST_IS_PLUGIN (plugin));

  GST_DEBUG_OBJECT (registry, "removing plugin %p (%s)",
      plugin, gst_plugin_get_name (plugin));

  GST_OBJECT_LOCK (registry);
  registry->priv->plugins = g_list_remove (registry->priv->plugins, plugin);
  if (G_LIKELY (plugin->basename))
    g_hash_table_remove (registry->priv->basename_hash, plugin->basename);
  gst_registry_remove_features_for_plugin_unlocked (registry, plugin);
  GST_OBJECT_UNLOCK (registry);
  gst_object_unref (plugin);
}

/**
 * gst_registry_add_feature:
 * @registry: the registry to add the plugin to
 * @feature: (transfer full): the feature to add
 *
 * Add the feature to the registry. The feature-added signal will be emitted.
 * This function sinks @feature.
 *
 * Returns: %TRUE on success.
 *
 * MT safe.
 */
gboolean
gst_registry_add_feature (GstRegistry * registry, GstPluginFeature * feature)
{
  GstPluginFeature *existing_feature;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), FALSE);
  g_return_val_if_fail (GST_IS_PLUGIN_FEATURE (feature), FALSE);
  g_return_val_if_fail (GST_OBJECT_NAME (feature) != NULL, FALSE);
  g_return_val_if_fail (feature->plugin_name != NULL, FALSE);

  GST_OBJECT_LOCK (registry);
  existing_feature = gst_registry_lookup_feature_locked (registry,
      GST_OBJECT_NAME (feature));
  if (G_UNLIKELY (existing_feature)) {
    GST_DEBUG_OBJECT (registry, "replacing existing feature %p (%s)",
        existing_feature, GST_OBJECT_NAME (feature));
    /* Remove the existing feature from the list now, before we insert the new
     * one, but don't unref yet because the hash is still storing a reference to
     * it. */
    registry->priv->features =
        g_list_remove (registry->priv->features, existing_feature);
  }

  GST_DEBUG_OBJECT (registry, "adding feature %p (%s)", feature,
      GST_OBJECT_NAME (feature));

  registry->priv->features = g_list_prepend (registry->priv->features, feature);
  g_hash_table_replace (registry->priv->feature_hash, GST_OBJECT_NAME (feature),
      feature);

  if (G_UNLIKELY (existing_feature)) {
    /* We unref now. No need to remove the feature name from the hash table, it
     * got replaced by the new feature */
    gst_object_unparent (GST_OBJECT_CAST (existing_feature));
  }

  gst_object_set_parent (GST_OBJECT_CAST (feature), GST_OBJECT_CAST (registry));

  registry->priv->cookie++;
  GST_OBJECT_UNLOCK (registry);

  GST_LOG_OBJECT (registry, "emitting feature-added for %s",
      GST_OBJECT_NAME (feature));
  g_signal_emit (registry, gst_registry_signals[FEATURE_ADDED], 0, feature);

  return TRUE;
}

/**
 * gst_registry_remove_feature:
 * @registry: the registry to remove the feature from
 * @feature: (transfer none): the feature to remove
 *
 * Remove the feature from the registry.
 *
 * MT safe.
 */
void
gst_registry_remove_feature (GstRegistry * registry, GstPluginFeature * feature)
{
  g_return_if_fail (GST_IS_REGISTRY (registry));
  g_return_if_fail (GST_IS_PLUGIN_FEATURE (feature));

  GST_DEBUG_OBJECT (registry, "removing feature %p (%s)",
      feature, gst_plugin_feature_get_name (feature));

  GST_OBJECT_LOCK (registry);
  registry->priv->features = g_list_remove (registry->priv->features, feature);
  g_hash_table_remove (registry->priv->feature_hash, GST_OBJECT_NAME (feature));
  registry->priv->cookie++;
  GST_OBJECT_UNLOCK (registry);

  gst_object_unparent ((GstObject *) feature);
}

/**
 * gst_registry_plugin_filter:
 * @registry: registry to query
 * @filter: (scope call): the filter to use
 * @first: only return first match
 * @user_data: (closure): user data passed to the filter function
 *
 * Runs a filter against all plugins in the registry and returns a #GList with
 * the results. If the first flag is set, only the first match is
 * returned (as a list with a single object).
 * Every plugin is reffed; use gst_plugin_list_free() after use, which
 * will unref again.
 *
 * Returns: (transfer full) (element-type Gst.Plugin): a #GList of #GstPlugin.
 *     Use gst_plugin_list_free() after usage.
 *
 * MT safe.
 */
GList *
gst_registry_plugin_filter (GstRegistry * registry,
    GstPluginFilter filter, gboolean first, gpointer user_data)
{
  GList *list = NULL;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);

  GST_OBJECT_LOCK (registry);
  {
    const GList *walk;

    for (walk = registry->priv->plugins; walk != NULL; walk = walk->next) {
      GstPlugin *plugin = walk->data;

      if (filter == NULL || filter (plugin, user_data)) {
        list = g_list_prepend (list, gst_object_ref (plugin));

        if (first)
          break;
      }
    }
  }
  GST_OBJECT_UNLOCK (registry);

  return list;
}

typedef struct
{
  const gchar *name;
  GType type;
} GstTypeNameData;

static gboolean
gst_plugin_feature_type_name_filter (GstPluginFeature * feature,
    GstTypeNameData * data)
{
  g_assert (GST_IS_PLUGIN_FEATURE (feature));

  return ((data->type == 0 || data->type == G_OBJECT_TYPE (feature)) &&
      (data->name == NULL || !strcmp (data->name, GST_OBJECT_NAME (feature))));
}

/* returns TRUE if the list was changed
 *
 * Must be called with the object lock taken */
static gboolean
gst_registry_get_feature_list_or_create (GstRegistry * registry,
    GList ** previous, guint32 * cookie, GType type)
{
  gboolean res = FALSE;
  GstRegistryPrivate *priv = registry->priv;

  if (G_UNLIKELY (!*previous || priv->cookie != *cookie)) {
    GstTypeNameData data;
    const GList *walk;

    if (*previous) {
      gst_plugin_feature_list_free (*previous);
      *previous = NULL;
    }

    data.type = type;
    data.name = NULL;

    for (walk = registry->priv->features; walk != NULL; walk = walk->next) {
      GstPluginFeature *feature = walk->data;

      if (gst_plugin_feature_type_name_filter (feature, &data)) {
        *previous = g_list_prepend (*previous, gst_object_ref (feature));
      }
    }

    *cookie = priv->cookie;
    res = TRUE;
  }

  return res;
}

static gint
type_find_factory_rank_cmp (const GstPluginFeature * fac1,
    const GstPluginFeature * fac2)
{
  if (G_LIKELY (fac1->rank != fac2->rank))
    return fac2->rank - fac1->rank;

  /* to make the order in which things happen more deterministic,
   * sort by name when the ranks are the same. */
  return strcmp (GST_OBJECT_NAME (fac1), GST_OBJECT_NAME (fac2));
}

static GList *
gst_registry_get_element_factory_list (GstRegistry * registry)
{
  GList *list;

  GST_OBJECT_LOCK (registry);

  gst_registry_get_feature_list_or_create (registry,
      &registry->priv->element_factory_list, &registry->priv->efl_cookie,
      GST_TYPE_ELEMENT_FACTORY);

  /* Return reffed copy */
  list = gst_plugin_feature_list_copy (registry->priv->element_factory_list);

  GST_OBJECT_UNLOCK (registry);

  return list;
}

static GList *
gst_registry_get_typefind_factory_list (GstRegistry * registry)
{
  GList *list;

  GST_OBJECT_LOCK (registry);

  if (G_UNLIKELY (gst_registry_get_feature_list_or_create (registry,
              &registry->priv->typefind_factory_list,
              &registry->priv->tfl_cookie, GST_TYPE_TYPE_FIND_FACTORY)))
    registry->priv->typefind_factory_list =
        g_list_sort (registry->priv->typefind_factory_list,
        (GCompareFunc) type_find_factory_rank_cmp);

  /* Return reffed copy */
  list = gst_plugin_feature_list_copy (registry->priv->typefind_factory_list);

  GST_OBJECT_UNLOCK (registry);

  return list;
}


static GList *
gst_registry_get_device_provider_factory_list (GstRegistry * registry)
{
  GList *list;

  GST_OBJECT_LOCK (registry);

  gst_registry_get_feature_list_or_create (registry,
      &registry->priv->device_provider_factory_list,
      &registry->priv->dmfl_cookie, GST_TYPE_DEVICE_PROVIDER_FACTORY);

  /* Return reffed copy */
  list =
      gst_plugin_feature_list_copy (registry->
      priv->device_provider_factory_list);

  GST_OBJECT_UNLOCK (registry);

  return list;
}

/**
 * gst_registry_feature_filter:
 * @registry: registry to query
 * @filter: (scope call): the filter to use
 * @first: only return first match
 * @user_data: (closure): user data passed to the filter function
 *
 * Runs a filter against all features of the plugins in the registry
 * and returns a GList with the results.
 * If the first flag is set, only the first match is
 * returned (as a list with a single object).
 *
 * Returns: (transfer full) (element-type Gst.PluginFeature): a #GList of
 *     #GstPluginFeature. Use gst_plugin_feature_list_free() after usage.
 *
 * MT safe.
 */
GList *
gst_registry_feature_filter (GstRegistry * registry,
    GstPluginFeatureFilter filter, gboolean first, gpointer user_data)
{
  GList *list = NULL;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);

  GST_OBJECT_LOCK (registry);
  {
    const GList *walk;

    for (walk = registry->priv->features; walk != NULL; walk = walk->next) {
      GstPluginFeature *feature = walk->data;

      if (filter == NULL || filter (feature, user_data)) {
        list = g_list_prepend (list, gst_object_ref (feature));

        if (first)
          break;
      }
    }
  }
  GST_OBJECT_UNLOCK (registry);

  return list;
}

static gboolean
gst_registry_plugin_name_filter (GstPlugin * plugin, const gchar * name)
{
  return (plugin->desc.name && !strcmp (plugin->desc.name, name));
}

/**
 * gst_registry_find_plugin:
 * @registry: the registry to search
 * @name: the plugin name to find
 *
 * Find the plugin with the given name in the registry.
 * The plugin will be reffed; caller is responsible for unreffing.
 *
 * Returns: (transfer full) (nullable): the plugin with the given name
 *     or %NULL if the plugin was not found. gst_object_unref() after
 *     usage.
 *
 * MT safe.
 */
GstPlugin *
gst_registry_find_plugin (GstRegistry * registry, const gchar * name)
{
  GList *walk;
  GstPlugin *result = NULL;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);
  g_return_val_if_fail (name != NULL, NULL);

  walk = gst_registry_plugin_filter (registry,
      (GstPluginFilter) gst_registry_plugin_name_filter, TRUE, (gpointer) name);
  if (walk) {
    result = GST_PLUGIN_CAST (walk->data);

    gst_object_ref (result);
    gst_plugin_list_free (walk);
  }

  return result;
}

/**
 * gst_registry_find_feature:
 * @registry: the registry to search
 * @name: the pluginfeature name to find
 * @type: the pluginfeature type to find
 *
 * Find the pluginfeature with the given name and type in the registry.
 *
 * Returns: (transfer full) (nullable): the pluginfeature with the
 *     given name and type or %NULL if the plugin was not
 *     found. gst_object_unref() after usage.
 *
 * MT safe.
 */
GstPluginFeature *
gst_registry_find_feature (GstRegistry * registry, const gchar * name,
    GType type)
{
  GstPluginFeature *feature = NULL;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);
  g_return_val_if_fail (name != NULL, NULL);
  g_return_val_if_fail (g_type_is_a (type, GST_TYPE_PLUGIN_FEATURE), NULL);

  feature = gst_registry_lookup_feature (registry, name);
  if (feature && !g_type_is_a (G_TYPE_FROM_INSTANCE (feature), type)) {
    gst_object_unref (feature);
    feature = NULL;
  }

  return feature;
}

/**
 * gst_registry_get_feature_list:
 * @registry: a #GstRegistry
 * @type: a #GType.
 *
 * Retrieves a #GList of #GstPluginFeature of @type.
 *
 * Returns: (transfer full) (element-type Gst.PluginFeature): a #GList of
 *     #GstPluginFeature of @type. Use gst_plugin_feature_list_free() after use
 *
 * MT safe.
 */
GList *
gst_registry_get_feature_list (GstRegistry * registry, GType type)
{
  GstTypeNameData data;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);
  g_return_val_if_fail (g_type_is_a (type, GST_TYPE_PLUGIN_FEATURE), NULL);

  /* Speed up */
  if (type == GST_TYPE_ELEMENT_FACTORY)
    return gst_registry_get_element_factory_list (registry);
  else if (type == GST_TYPE_TYPE_FIND_FACTORY)
    return gst_registry_get_typefind_factory_list (registry);
  else if (type == GST_TYPE_DEVICE_PROVIDER_FACTORY)
    return gst_registry_get_device_provider_factory_list (registry);

  data.type = type;
  data.name = NULL;

  return gst_registry_feature_filter (registry,
      (GstPluginFeatureFilter) gst_plugin_feature_type_name_filter,
      FALSE, &data);
}

/**
 * gst_registry_get_plugin_list:
 * @registry: the registry to search
 *
 * Get a copy of all plugins registered in the given registry. The refcount
 * of each element in the list in incremented.
 *
 * Returns: (transfer full) (element-type Gst.Plugin): a #GList of #GstPlugin.
 *     Use gst_plugin_list_free() after usage.
 *
 * MT safe.
 */
GList *
gst_registry_get_plugin_list (GstRegistry * registry)
{
  GList *list;
  GList *g;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);

  GST_OBJECT_LOCK (registry);
  list = g_list_copy (registry->priv->plugins);
  for (g = list; g; g = g->next) {
    gst_object_ref (GST_PLUGIN_CAST (g->data));
  }
  GST_OBJECT_UNLOCK (registry);

  return list;
}

static GstPluginFeature *
gst_registry_lookup_feature_locked (GstRegistry * registry, const char *name)
{
  return g_hash_table_lookup (registry->priv->feature_hash, name);
}

/**
 * gst_registry_lookup_feature:
 * @registry: a #GstRegistry
 * @name: a #GstPluginFeature name
 *
 * Find a #GstPluginFeature with @name in @registry.
 *
 * Returns: (transfer full): a #GstPluginFeature with its refcount incremented,
 *     use gst_object_unref() after usage.
 *
 * MT safe.
 */
GstPluginFeature *
gst_registry_lookup_feature (GstRegistry * registry, const char *name)
{
  GstPluginFeature *feature;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);
  g_return_val_if_fail (name != NULL, NULL);

  GST_OBJECT_LOCK (registry);
  feature = gst_registry_lookup_feature_locked (registry, name);
  if (feature)
    gst_object_ref (feature);
  GST_OBJECT_UNLOCK (registry);

  return feature;
}

static GstPlugin *
gst_registry_lookup_bn_locked (GstRegistry * registry, const char *basename)
{
  return g_hash_table_lookup (registry->priv->basename_hash, basename);
}

static GstPlugin *
gst_registry_lookup_bn (GstRegistry * registry, const char *basename)
{
  GstPlugin *plugin;

  GST_OBJECT_LOCK (registry);
  plugin = gst_registry_lookup_bn_locked (registry, basename);
  if (plugin)
    gst_object_ref (plugin);
  GST_OBJECT_UNLOCK (registry);

  return plugin;
}

/**
 * gst_registry_lookup:
 * @registry: the registry to look up in
 * @filename: the name of the file to look up
 *
 * Look up a plugin in the given registry with the given filename.
 * If found, plugin is reffed.
 *
 * Returns: (transfer full) (nullable): the #GstPlugin if found, or
 *     %NULL if not.  gst_object_unref() after usage.
 */
GstPlugin *
gst_registry_lookup (GstRegistry * registry, const char *filename)
{
  GstPlugin *plugin;
  gchar *basename;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);
  g_return_val_if_fail (filename != NULL, NULL);

  basename = g_path_get_basename (filename);
  if (G_UNLIKELY (basename == NULL))
    return NULL;

  plugin = gst_registry_lookup_bn (registry, basename);

  g_free (basename);

  return plugin;
}

typedef enum
{
  REGISTRY_SCAN_HELPER_NOT_STARTED = 0,
  REGISTRY_SCAN_HELPER_DISABLED,
  REGISTRY_SCAN_HELPER_RUNNING
} GstRegistryScanHelperState;

typedef struct
{
  GstRegistry *registry;
  GstRegistryScanHelperState helper_state;
  GstPluginLoader *helper;
  gboolean changed;
} GstRegistryScanContext;

static void
init_scan_context (GstRegistryScanContext * context, GstRegistry * registry)
{
  gboolean do_fork;

  context->registry = registry;

  /* see if forking is enabled and set up the scan helper state accordingly */
  do_fork = _gst_enable_registry_fork;
  if (do_fork) {
    const gchar *fork_env;

    /* forking enabled, see if it is disabled with an env var */
    if ((fork_env = g_getenv ("GST_REGISTRY_FORK"))) {
      /* fork enabled for any value different from "no" */
      do_fork = strcmp (fork_env, "no") != 0;
    }
  }

  if (do_fork)
    context->helper_state = REGISTRY_SCAN_HELPER_NOT_STARTED;
  else
    context->helper_state = REGISTRY_SCAN_HELPER_DISABLED;

  context->helper = NULL;
  context->changed = FALSE;
}

static void
clear_scan_context (GstRegistryScanContext * context)
{
  if (context->helper) {
    context->changed |= _priv_gst_plugin_loader_funcs.destroy (context->helper);
    context->helper = NULL;
  }
}

static gboolean
gst_registry_scan_plugin_file (GstRegistryScanContext * context,
    const gchar * filename, off_t file_size, time_t file_mtime)
{
  gboolean changed = FALSE;
  GstPlugin *newplugin = NULL;

#ifdef G_OS_WIN32
  /* Disable external plugin loader on Windows until it is ported properly. */
  context->helper_state = REGISTRY_SCAN_HELPER_DISABLED;
#endif


  /* Have a plugin to load - see if the scan-helper needs starting */
  if (context->helper_state == REGISTRY_SCAN_HELPER_NOT_STARTED) {
    GST_DEBUG ("Starting plugin scanner for file %s", filename);
    context->helper = _priv_gst_plugin_loader_funcs.create (context->registry);
    if (context->helper != NULL)
      context->helper_state = REGISTRY_SCAN_HELPER_RUNNING;
    else {
      GST_WARNING ("Failed starting plugin scanner. Scanning in-process");
      context->helper_state = REGISTRY_SCAN_HELPER_DISABLED;
    }
  }

  if (context->helper_state == REGISTRY_SCAN_HELPER_RUNNING) {
    GST_DEBUG ("Using scan-helper to load plugin %s", filename);
    if (!_priv_gst_plugin_loader_funcs.load (context->helper,
            filename, file_size, file_mtime)) {
      g_warning ("External plugin loader failed. This most likely means that "
          "the plugin loader helper binary was not found or could not be run. "
          "You might need to set the GST_PLUGIN_SCANNER environment variable "
          "if your setup is unusual. This should normally not be required "
          "though.");
      context->helper_state = REGISTRY_SCAN_HELPER_DISABLED;
    }
  }

  /* Check if the helper is disabled (or just got disabled above) */
  if (context->helper_state == REGISTRY_SCAN_HELPER_DISABLED) {
    /* Load plugin the old fashioned way... */

    /* We don't use a GError here because a failure to load some shared
     * objects as plugins is normal (particularly in the uninstalled case)
     */
    newplugin = gst_plugin_load_file (filename, NULL);
  }

  if (newplugin) {
    GST_DEBUG_OBJECT (context->registry, "marking new plugin %p as registered",
        newplugin);
    newplugin->registered = TRUE;
    gst_object_unref (newplugin);
    changed = TRUE;
  }
#ifndef GST_DISABLE_REGISTRY
  if (!__registry_reuse_plugin_scanner) {
    clear_scan_context (context);
    context->helper_state = REGISTRY_SCAN_HELPER_NOT_STARTED;
  }
#endif

  return changed;
}

static gboolean
is_blacklisted_hidden_directory (const gchar * dirent)
{
  if (G_LIKELY (dirent[0] != '.'))
    return FALSE;

  /* skip the .debug directory, these contain elf files that are not
   * useful or worse, can crash dlopen () */
  if (strcmp (dirent, ".debug") == 0)
    return TRUE;

  /* can also skip .git and .deps dirs, those won't contain useful files.
   * This speeds up scanning a bit in uninstalled setups. */
  if (strcmp (dirent, ".git") == 0 || strcmp (dirent, ".deps") == 0)
    return TRUE;

  return FALSE;
}

static gboolean
gst_registry_scan_path_level (GstRegistryScanContext * context,
    const gchar * path, int level)
{
  GDir *dir;
  const gchar *dirent;
  gchar *filename;
  GstPlugin *plugin;
  gboolean changed = FALSE;

  dir = g_dir_open (path, 0, NULL);
  if (!dir)
    return FALSE;

  while ((dirent = g_dir_read_name (dir))) {
    GStatBuf file_status;

    filename = g_build_filename (path, dirent, NULL);
    if (g_stat (filename, &file_status) < 0) {
      /* Plugin will be removed from cache after the scan completes if it
       * is still marked 'cached' */
      g_free (filename);
      continue;
    }

    if (file_status.st_mode & S_IFDIR) {
      if (G_UNLIKELY (is_blacklisted_hidden_directory (dirent))) {
        GST_TRACE_OBJECT (context->registry, "ignoring %s directory", dirent);
        g_free (filename);
        continue;
      }
      /* FIXME 0.11: Don't recurse into directories, this behaviour
       * is inconsistent with other PATH environment variables
       */
      if (level > 0) {
        GST_LOG_OBJECT (context->registry, "recursing into directory %s",
            filename);
        changed |= gst_registry_scan_path_level (context, filename, level - 1);
      } else {
        GST_LOG_OBJECT (context->registry, "not recursing into directory %s, "
            "recursion level too deep", filename);
      }
      g_free (filename);
      continue;
    }
    if (!(file_status.st_mode & S_IFREG)) {
      GST_TRACE_OBJECT (context->registry, "%s is not a regular file, ignoring",
          filename);
      g_free (filename);
      continue;
    }
    if (!g_str_has_suffix (dirent, G_MODULE_SUFFIX)
#ifdef GST_EXTRA_MODULE_SUFFIX
        && !g_str_has_suffix (dirent, GST_EXTRA_MODULE_SUFFIX)
#endif
        ) {
      GST_TRACE_OBJECT (context->registry,
          "extension is not recognized as module file, ignoring file %s",
          filename);
      g_free (filename);
      continue;
    }

    GST_LOG_OBJECT (context->registry, "file %s looks like a possible module",
        filename);

    /* try to avoid unnecessary plugin-move pain */
    if (g_str_has_prefix (dirent, "libgstvalve") ||
        g_str_has_prefix (dirent, "libgstselector")) {
      GST_WARNING_OBJECT (context->registry, "ignoring old plugin %s which "
          "has been merged into the corelements plugin", filename);
      /* Plugin will be removed from cache after the scan completes if it
       * is still marked 'cached' */
      g_free (filename);
      continue;
    }

    /* plug-ins are considered unique by basename; if the given name
     * was already seen by the registry, we ignore it */
    plugin = gst_registry_lookup_bn (context->registry, dirent);
    if (plugin) {
      gboolean env_vars_changed, deps_changed = FALSE;

      if (plugin->registered) {
        GST_DEBUG_OBJECT (context->registry,
            "plugin already registered from path \"%s\"",
            GST_STR_NULL (plugin->filename));
        g_free (filename);
        gst_object_unref (plugin);
        continue;
      }

      env_vars_changed = _priv_plugin_deps_env_vars_changed (plugin);

      /* If a file with a certain basename is seen on a different path,
       * update the plugin to ensure the registry cache will reflect up
       * to date information */

      if (plugin->file_mtime == file_status.st_mtime &&
          plugin->file_size == file_status.st_size && !env_vars_changed &&
          !(deps_changed = _priv_plugin_deps_files_changed (plugin)) &&
          !strcmp (plugin->filename, filename)) {
        GST_LOG_OBJECT (context->registry, "file %s cached", filename);
        GST_OBJECT_FLAG_UNSET (plugin, GST_PLUGIN_FLAG_CACHED);
        GST_LOG_OBJECT (context->registry,
            "marking plugin %p as registered as %s", plugin, filename);
        plugin->registered = TRUE;
      } else {
        GST_INFO_OBJECT (context->registry, "cached info for %s is stale",
            filename);
        GST_DEBUG_OBJECT (context->registry, "mtime %" G_GINT64_FORMAT " != %"
            G_GINT64_FORMAT " or size %" G_GINT64_FORMAT " != %"
            G_GINT64_FORMAT " or external dependency env_vars changed: %d or"
            " external dependencies changed: %d or old path %s != new path %s",
            (gint64) plugin->file_mtime, (gint64) file_status.st_mtime,
            (gint64) plugin->file_size, (gint64) file_status.st_size,
            env_vars_changed, deps_changed, plugin->filename, filename);
        gst_registry_remove_plugin (context->registry, plugin);
        changed |= gst_registry_scan_plugin_file (context, filename,
            file_status.st_size, file_status.st_mtime);
      }
      gst_object_unref (plugin);

    } else {
      GST_DEBUG_OBJECT (context->registry, "file %s not yet in registry",
          filename);
      changed |= gst_registry_scan_plugin_file (context, filename,
          file_status.st_size, file_status.st_mtime);
    }

    g_free (filename);
  }

  g_dir_close (dir);

  return changed;
}

static gboolean
gst_registry_scan_path_internal (GstRegistryScanContext * context,
    const gchar * path)
{
  gboolean changed;

  GST_DEBUG_OBJECT (context->registry, "scanning path %s", path);
  changed = gst_registry_scan_path_level (context, path, 10);

  GST_DEBUG_OBJECT (context->registry, "registry changed in path %s: %d", path,
      changed);
  return changed;
}

/**
 * gst_registry_scan_path:
 * @registry: the registry to add found plugins to
 * @path: the path to scan
 *
 * Scan the given path for plugins to add to the registry. The syntax of the
 * path is specific to the registry.
 *
 * Returns: %TRUE if registry changed
 */
gboolean
gst_registry_scan_path (GstRegistry * registry, const gchar * path)
{
  GstRegistryScanContext context;
  gboolean result;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), FALSE);
  g_return_val_if_fail (path != NULL, FALSE);

  init_scan_context (&context, registry);

  result = gst_registry_scan_path_internal (&context, path);

  clear_scan_context (&context);
  result |= context.changed;

  return result;
}

static gboolean
_gst_plugin_feature_filter_plugin_name (GstPluginFeature * feature,
    gpointer user_data)
{
  return (strcmp (feature->plugin_name, (gchar *) user_data) == 0);
}

/**
 * gst_registry_get_feature_list_by_plugin:
 * @registry: a #GstRegistry.
 * @name: a plugin name.
 *
 * Retrieves a #GList of features of the plugin with name @name.
 *
 * Returns: (transfer full) (element-type Gst.PluginFeature): a #GList of
 *     #GstPluginFeature. Use gst_plugin_feature_list_free() after usage.
 */
GList *
gst_registry_get_feature_list_by_plugin (GstRegistry * registry,
    const gchar * name)
{
  g_return_val_if_fail (GST_IS_REGISTRY (registry), NULL);
  g_return_val_if_fail (name != NULL, NULL);

  return gst_registry_feature_filter (registry,
      _gst_plugin_feature_filter_plugin_name, FALSE, (gpointer) name);
}

/* Unref and delete the default registry */
void
_priv_gst_registry_cleanup (void)
{
  GstRegistry *registry;

  g_mutex_lock (&_gst_registry_mutex);
  if ((registry = _gst_registry_default) != NULL) {
    _gst_registry_default = NULL;
  }
  g_mutex_unlock (&_gst_registry_mutex);

  /* unref outside of the lock because we can. */
  if (registry)
    gst_object_unref (registry);
}

/**
 * gst_registry_check_feature_version:
 * @registry: a #GstRegistry
 * @feature_name: the name of the feature (e.g. "oggdemux")
 * @min_major: the minimum major version number
 * @min_minor: the minimum minor version number
 * @min_micro: the minimum micro version number
 *
 * Checks whether a plugin feature by the given name exists in
 * @registry and whether its version is at least the
 * version required.
 *
 * Returns: %TRUE if the feature could be found and the version is
 * the same as the required version or newer, and %FALSE otherwise.
 */
gboolean
gst_registry_check_feature_version (GstRegistry * registry,
    const gchar * feature_name, guint min_major, guint min_minor,
    guint min_micro)
{
  GstPluginFeature *feature;
  gboolean ret = FALSE;

  g_return_val_if_fail (feature_name != NULL, FALSE);

  GST_DEBUG ("Looking up plugin feature '%s'", feature_name);

  feature = gst_registry_lookup_feature (registry, feature_name);
  if (feature) {
    ret = gst_plugin_feature_check_version (feature, min_major, min_minor,
        min_micro);
    gst_object_unref (feature);
  } else {
    GST_DEBUG ("Could not find plugin feature '%s'", feature_name);
  }

  return ret;
}

static void
load_plugin_func (gpointer data, gpointer user_data)
{
  GstPlugin *plugin;
  const gchar *filename;
  GError *err = NULL;

  filename = (const gchar *) data;
  GST_DEBUG ("Pre-loading plugin %s", filename);

  plugin = gst_plugin_load_file (filename, &err);

  if (plugin) {
    GST_INFO ("Loaded plugin: \"%s\"", filename);

    gst_registry_add_plugin (gst_registry_get (), plugin);
  } else {
    if (err) {
      /* Report error to user, and free error */
      GST_ERROR ("Failed to load plugin: %s", err->message);
      g_error_free (err);
    } else {
      GST_WARNING ("Failed to load plugin: \"%s\"", filename);
    }
  }
}

#ifndef GST_DISABLE_REGISTRY
/* Unref all plugins marked 'cached', to clear old plugins that no
 * longer exist. Returns %TRUE if any plugins were removed */
static gboolean
gst_registry_remove_cache_plugins (GstRegistry * registry)
{
  GList *g;
  GList *g_next;
  GstPlugin *plugin;
  gboolean changed = FALSE;

  g_return_val_if_fail (GST_IS_REGISTRY (registry), FALSE);

  GST_OBJECT_LOCK (registry);

  GST_DEBUG_OBJECT (registry, "removing cached plugins");
  g = registry->priv->plugins;
  while (g) {
    g_next = g->next;
    plugin = g->data;
    if (GST_OBJECT_FLAG_IS_SET (plugin, GST_PLUGIN_FLAG_CACHED)) {
      GST_DEBUG_OBJECT (registry, "removing cached plugin \"%s\"",
          GST_STR_NULL (plugin->filename));
      registry->priv->plugins = g_list_delete_link (registry->priv->plugins, g);
      if (G_LIKELY (plugin->basename))
        g_hash_table_remove (registry->priv->basename_hash, plugin->basename);
      gst_registry_remove_features_for_plugin_unlocked (registry, plugin);
      gst_object_unref (plugin);
      changed = TRUE;
    }
    g = g_next;
  }

  GST_OBJECT_UNLOCK (registry);

  return changed;
}

typedef enum
{
  REGISTRY_SCAN_AND_UPDATE_FAILURE = 0,
  REGISTRY_SCAN_AND_UPDATE_SUCCESS_NOT_CHANGED,
  REGISTRY_SCAN_AND_UPDATE_SUCCESS_UPDATED
} GstRegistryScanAndUpdateResult;

/*
 * scan_and_update_registry:
 * @default_registry: the #GstRegistry
 * @registry_file: registry filename
 * @write_changes: write registry if it has changed?
 *
 * Scans for registry changes and eventually updates the registry cache.
 *
 * Return: %REGISTRY_SCAN_AND_UPDATE_FAILURE if the registry could not scanned
 *         or updated, %REGISTRY_SCAN_AND_UPDATE_SUCCESS_NOT_CHANGED if the
 *         registry is clean and %REGISTRY_SCAN_AND_UPDATE_SUCCESS_UPDATED if
 *         it has been updated and the cache needs to be re-read.
 */
static GstRegistryScanAndUpdateResult
scan_and_update_registry (GstRegistry * default_registry,
    const gchar * registry_file, gboolean write_changes, GError ** error)
{
  const gchar *plugin_path;
  gboolean changed = FALSE;
  GList *l;
  GstRegistryScanContext context;

  GST_INFO ("Validating plugins from registry cache: %s", registry_file);

  init_scan_context (&context, default_registry);

  /* It sounds tempting to just compare the mtime of directories with the mtime
   * of the registry cache, but it does not work. It would not catch updated
   * plugins, which might bring more or less features.
   */

  /* scan paths specified via --gst-plugin-path */
  GST_DEBUG ("scanning paths added via --gst-plugin-path");
  for (l = _priv_gst_plugin_paths; l != NULL; l = l->next) {
    GST_INFO ("Scanning plugin path: \"%s\"", (gchar *) l->data);
    changed |= gst_registry_scan_path_internal (&context, (gchar *) l->data);
  }
  /* keep plugin_paths around in case a re-scan is forced later on */

  /* GST_PLUGIN_PATH specifies a list of directories to scan for
   * additional plugins.  These take precedence over the system plugins */
  plugin_path = g_getenv ("GST_PLUGIN_PATH_1_0");
  if (plugin_path == NULL)
    plugin_path = g_getenv ("GST_PLUGIN_PATH");
  if (plugin_path) {
    char **list;
    int i;

    GST_DEBUG ("GST_PLUGIN_PATH set to %s", plugin_path);
    list = g_strsplit (plugin_path, G_SEARCHPATH_SEPARATOR_S, 0);
    for (i = 0; list[i]; i++) {
      changed |= gst_registry_scan_path_internal (&context, list[i]);
    }
    g_strfreev (list);
  } else {
    GST_DEBUG ("GST_PLUGIN_PATH not set");
  }

  /* GST_PLUGIN_SYSTEM_PATH specifies a list of plugins that are always
   * loaded by default.  If not set, this defaults to the system-installed
   * path, and the plugins installed in the user's home directory */
  plugin_path = g_getenv ("GST_PLUGIN_SYSTEM_PATH_1_0");
  if (plugin_path == NULL)
    plugin_path = g_getenv ("GST_PLUGIN_SYSTEM_PATH");
  if (plugin_path == NULL) {
    char *home_plugins;

    GST_DEBUG ("GST_PLUGIN_SYSTEM_PATH not set");

    /* plugins in the user's home directory take precedence over
     * system-installed ones */
    home_plugins = g_build_filename (g_get_user_data_dir (),
        "gstreamer-" GST_API_VERSION, "plugins", NULL);

    GST_DEBUG ("scanning home plugins %s", home_plugins);
    changed |= gst_registry_scan_path_internal (&context, home_plugins);
    g_free (home_plugins);

    /* add the main (installed) library path */

#ifdef G_OS_WIN32
    {
      char *base_dir;
      char *dir;

      base_dir =
          g_win32_get_package_installation_directory_of_module
          (_priv_gst_dll_handle);

      dir = g_build_filename (base_dir,
#ifdef _DEBUG
          "debug"
#endif
          "lib", "gstreamer-" GST_API_VERSION, NULL);
      GST_DEBUG ("scanning DLL dir %s", dir);

      changed |= gst_registry_scan_path_internal (&context, dir);

      g_free (dir);
      g_free (base_dir);
    }
#else
    GST_DEBUG ("scanning main plugins %s", PLUGINDIR);
    changed |= gst_registry_scan_path_internal (&context, PLUGINDIR);
#endif
  } else {
    gchar **list;
    gint i;

    GST_DEBUG ("GST_PLUGIN_SYSTEM_PATH set to %s", plugin_path);
    list = g_strsplit (plugin_path, G_SEARCHPATH_SEPARATOR_S, 0);
    for (i = 0; list[i]; i++) {
      changed |= gst_registry_scan_path_internal (&context, list[i]);
    }
    g_strfreev (list);
  }

  clear_scan_context (&context);
  changed |= context.changed;

  /* Remove cached plugins so stale info is cleared. */
  changed |= gst_registry_remove_cache_plugins (default_registry);

  if (!changed) {
    GST_INFO ("Registry cache has not changed");
    return REGISTRY_SCAN_AND_UPDATE_SUCCESS_NOT_CHANGED;
  }

  if (!write_changes) {
    GST_INFO ("Registry cache changed, but writing is disabled. Not writing.");
    return REGISTRY_SCAN_AND_UPDATE_FAILURE;
  }

  GST_INFO ("Registry cache changed. Writing new registry cache");
  if (!priv_gst_registry_binary_write_cache (default_registry,
          default_registry->priv->plugins, registry_file)) {
    g_set_error (error, GST_CORE_ERROR, GST_CORE_ERROR_FAILED,
        _("Error writing registry cache to %s: %s"),
        registry_file, g_strerror (errno));
    return REGISTRY_SCAN_AND_UPDATE_FAILURE;
  }

  GST_INFO ("Registry cache written successfully");
  return REGISTRY_SCAN_AND_UPDATE_SUCCESS_UPDATED;
}

static gboolean
ensure_current_registry (GError ** error)
{
  gchar *registry_file;
  GstRegistry *default_registry;
  gboolean ret = TRUE;
  gboolean do_update = TRUE;
  gboolean have_cache = TRUE;

  default_registry = gst_registry_get ();

  registry_file = g_strdup (g_getenv ("GST_REGISTRY_1_0"));
  if (registry_file == NULL)
    registry_file = g_strdup (g_getenv ("GST_REGISTRY"));
  if (registry_file == NULL) {
    registry_file = g_build_filename (g_get_user_cache_dir (),
        "gstreamer-" GST_API_VERSION, "registry." TARGET_CPU ".bin", NULL);
  }

  if (!_gst_disable_registry_cache) {
    GST_INFO ("reading registry cache: %s", registry_file);
    have_cache = priv_gst_registry_binary_read_cache (default_registry,
        registry_file);
    /* Only ever read the registry cache once, then disable it for
     * subsequent updates during the program lifetime */
    _gst_disable_registry_cache = TRUE;
  }

  if (have_cache) {
    do_update = !_priv_gst_disable_registry_update;
    if (do_update) {
      const gchar *update_env;

      if ((update_env = g_getenv ("GST_REGISTRY_UPDATE"))) {
        /* do update for any value different from "no" */
        do_update = (strcmp (update_env, "no") != 0);
      }
    }
  }

  if (do_update) {
    const gchar *reuse_env;

    if ((reuse_env = g_getenv ("GST_REGISTRY_REUSE_PLUGIN_SCANNER"))) {
      /* do reuse for any value different from "no" */
      __registry_reuse_plugin_scanner = (strcmp (reuse_env, "no") != 0);
    }
    /* now check registry */
    GST_DEBUG ("Updating registry cache");
    scan_and_update_registry (default_registry, registry_file, TRUE, error);
  } else {
    GST_DEBUG ("Not updating registry cache (disabled)");
  }

  g_free (registry_file);
  GST_INFO ("registry reading and updating done, result = %d", ret);

  return ret;
}
#endif /* GST_DISABLE_REGISTRY */

/**
 * gst_registry_fork_is_enabled:
 *
 * By default GStreamer will perform scanning and rebuilding of the
 * registry file using a helper child process.
 *
 * Applications might want to disable this behaviour with the
 * gst_registry_fork_set_enabled() function, in which case new plugins
 * are scanned (and loaded) into the application process.
 *
 * Returns: %TRUE if GStreamer will use the child helper process when
 * rebuilding the registry.
 */
gboolean
gst_registry_fork_is_enabled (void)
{
  return _gst_enable_registry_fork;
}

/**
 * gst_registry_fork_set_enabled:
 * @enabled: whether rebuilding the registry can use a temporary child helper process.
 *
 * Applications might want to disable/enable spawning of a child helper process
 * when rebuilding the registry. See gst_registry_fork_is_enabled() for more
 * information.
 */
void
gst_registry_fork_set_enabled (gboolean enabled)
{
  _gst_enable_registry_fork = enabled;
}

/**
 * gst_update_registry:
 *
 * Forces GStreamer to re-scan its plugin paths and update the default
 * plugin registry.
 *
 * Applications will almost never need to call this function, it is only
 * useful if the application knows new plugins have been installed (or old
 * ones removed) since the start of the application (or, to be precise, the
 * first call to gst_init()) and the application wants to make use of any
 * newly-installed plugins without restarting the application.
 *
 * Applications should assume that the registry update is neither atomic nor
 * thread-safe and should therefore not have any dynamic pipelines running
 * (including the playbin and decodebin elements) and should also not create
 * any elements or access the GStreamer registry while the update is in
 * progress.
 *
 * Note that this function may block for a significant amount of time.
 *
 * Returns: %TRUE if the registry has been updated successfully (does not
 *          imply that there were changes), otherwise %FALSE.
 */
gboolean
gst_update_registry (void)
{
  gboolean res;

#ifndef GST_DISABLE_REGISTRY
  GError *err = NULL;

  res = ensure_current_registry (&err);
  if (err) {
    GST_WARNING ("registry update failed: %s", err->message);
    g_error_free (err);
  } else {
    GST_LOG ("registry update succeeded");
  }

#else
  GST_WARNING ("registry update failed: %s", "registry disabled");
  res = TRUE;
#endif /* GST_DISABLE_REGISTRY */

  if (_priv_gst_preload_plugins) {
    GST_DEBUG ("Preloading indicated plugins...");
    g_slist_foreach (_priv_gst_preload_plugins, load_plugin_func, NULL);
  }

  return res;
}

/**
 * gst_registry_get_feature_list_cookie:
 * @registry: the registry
 *
 * Returns the registry's feature list cookie. This changes
 * every time a feature is added or removed from the registry.
 *
 * Returns: the feature list cookie.
 */
guint32
gst_registry_get_feature_list_cookie (GstRegistry * registry)
{
  g_return_val_if_fail (GST_IS_REGISTRY (registry), 0);

  return registry->priv->cookie;
}
