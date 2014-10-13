/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gstdeviceproviderfactory.c: GstDeviceProviderFactory object, support routines
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/**
 * SECTION:gstdeviceproviderfactory
 * @short_description: Create GstDeviceProviders from a factory
 * @see_also: #GstDeviceProvider, #GstPlugin, #GstPluginFeature, #GstPadTemplate.
 *
 * #GstDeviceProviderFactory is used to create instances of device providers. A
 * GstDeviceProviderfactory can be added to a #GstPlugin as it is also a
 * #GstPluginFeature.
 *
 * Use the gst_device_provider_factory_find() and
 * gst_device_provider_factory_get() functions to create device
 * provider instances or use gst_device_provider_factory_get_by_name() as a
 * convenient shortcut.
 *
 * Since: 1.4
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"

#include "gstdeviceproviderfactory.h"
#include "gst.h"

#include "glib-compat-private.h"

GST_DEBUG_CATEGORY_STATIC (device_provider_factory_debug);
#define GST_CAT_DEFAULT device_provider_factory_debug

static void gst_device_provider_factory_finalize (GObject * object);
static void gst_device_provider_factory_cleanup (GstDeviceProviderFactory *
    factory);

/* static guint gst_device_provider_factory_signals[LAST_SIGNAL] = { 0 }; */

/* this is defined in gstelement.c */
extern GQuark __gst_deviceproviderclass_factory;

#define _do_init \
{ \
  GST_DEBUG_CATEGORY_INIT (device_provider_factory_debug, "GST_DEVICE_PROVIDER_FACTORY", \
      GST_DEBUG_BOLD | GST_DEBUG_FG_WHITE | GST_DEBUG_BG_RED, \
      "device provider factories keep information about installed device providers"); \
}

G_DEFINE_TYPE_WITH_CODE (GstDeviceProviderFactory, gst_device_provider_factory,
    GST_TYPE_PLUGIN_FEATURE, _do_init);

static void
gst_device_provider_factory_class_init (GstDeviceProviderFactoryClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->finalize = gst_device_provider_factory_finalize;
}

static void
gst_device_provider_factory_init (GstDeviceProviderFactory * factory)
{
}

static void
gst_device_provider_factory_finalize (GObject * object)
{
  GstDeviceProviderFactory *factory = GST_DEVICE_PROVIDER_FACTORY (object);
  GstDeviceProvider *provider;

  gst_device_provider_factory_cleanup (factory);

  provider = g_atomic_pointer_get (&factory->provider);
  if (provider)
    gst_object_unref (provider);

  G_OBJECT_CLASS (gst_device_provider_factory_parent_class)->finalize (object);
}

/**
 * gst_device_provider_factory_find:
 * @name: name of factory to find
 *
 * Search for an device provider factory of the given name. Refs the returned
 * device provider factory; caller is responsible for unreffing.
 *
 * Returns: (transfer full) (nullable): #GstDeviceProviderFactory if
 * found, %NULL otherwise
 *
 * Since: 1.4
 */
GstDeviceProviderFactory *
gst_device_provider_factory_find (const gchar * name)
{
  GstPluginFeature *feature;

  g_return_val_if_fail (name != NULL, NULL);

  feature = gst_registry_find_feature (gst_registry_get (), name,
      GST_TYPE_DEVICE_PROVIDER_FACTORY);
  if (feature)
    return GST_DEVICE_PROVIDER_FACTORY (feature);

  /* this isn't an error, for instance when you query if an device provider factory is
   * present */
  GST_LOG ("no such device provider factory \"%s\"", name);

  return NULL;
}

static void
gst_device_provider_factory_cleanup (GstDeviceProviderFactory * factory)
{
  if (factory->metadata) {
    gst_structure_free ((GstStructure *) factory->metadata);
    factory->metadata = NULL;
  }
  if (factory->type) {
    factory->type = G_TYPE_INVALID;
  }
}

#define CHECK_METADATA_FIELD(klass, name, key)                                 \
  G_STMT_START {                                                               \
    const gchar *metafield = gst_device_provider_class_get_metadata (klass, key);      \
    if (G_UNLIKELY (metafield == NULL || *metafield == '\0')) {                \
      g_warning ("Device provider factory metadata for '%s' has no valid %s field", name, key);    \
      goto detailserror;                                                       \
    } \
  } G_STMT_END;

/**
 * gst_device_provider_register:
 * @plugin: (allow-none): #GstPlugin to register the device provider with, or %NULL for
 *     a static device provider.
 * @name: name of device providers of this type
 * @rank: rank of device provider (higher rank means more importance when autoplugging)
 * @type: GType of device provider to register
 *
 * Create a new device providerfactory capable of instantiating objects of the
 * @type and add the factory to @plugin.
 *
 * Returns: %TRUE, if the registering succeeded, %FALSE on error
 *
 * Since: 1.4
 */
gboolean
gst_device_provider_register (GstPlugin * plugin, const gchar * name,
    guint rank, GType type)
{
  GstPluginFeature *existing_feature;
  GstRegistry *registry;
  GstDeviceProviderFactory *factory;
  GstDeviceProviderClass *klass;

  g_return_val_if_fail (name != NULL, FALSE);
  g_return_val_if_fail (g_type_is_a (type, GST_TYPE_DEVICE_PROVIDER), FALSE);

  registry = gst_registry_get ();

  /* check if feature already exists, if it exists there is no need to update it
   * when the registry is getting updated, outdated plugins and all their
   * features are removed and readded.
   */
  existing_feature = gst_registry_lookup_feature (registry, name);
  if (existing_feature) {
    GST_DEBUG_OBJECT (registry, "update existing feature %p (%s)",
        existing_feature, name);
    factory = GST_DEVICE_PROVIDER_FACTORY_CAST (existing_feature);
    factory->type = type;
    existing_feature->loaded = TRUE;
    g_type_set_qdata (type, __gst_deviceproviderclass_factory, factory);
    gst_object_unref (existing_feature);
    return TRUE;
  }

  factory =
      GST_DEVICE_PROVIDER_FACTORY_CAST (g_object_newv
      (GST_TYPE_DEVICE_PROVIDER_FACTORY, 0, NULL));
  gst_plugin_feature_set_name (GST_PLUGIN_FEATURE_CAST (factory), name);
  GST_LOG_OBJECT (factory, "Created new device providerfactory for type %s",
      g_type_name (type));

  /* provide info needed during class structure setup */
  g_type_set_qdata (type, __gst_deviceproviderclass_factory, factory);
  klass = GST_DEVICE_PROVIDER_CLASS (g_type_class_ref (type));

  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_LONGNAME);
  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_KLASS);
  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_DESCRIPTION);
  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_AUTHOR);

  factory->type = type;
  factory->metadata = gst_structure_copy ((GstStructure *) klass->metadata);

  if (plugin && plugin->desc.name) {
    GST_PLUGIN_FEATURE_CAST (factory)->plugin_name = plugin->desc.name;
    GST_PLUGIN_FEATURE_CAST (factory)->plugin = plugin;
    g_object_add_weak_pointer ((GObject *) plugin,
        (gpointer *) & GST_PLUGIN_FEATURE_CAST (factory)->plugin);
  } else {
    GST_PLUGIN_FEATURE_CAST (factory)->plugin_name = "NULL";
    GST_PLUGIN_FEATURE_CAST (factory)->plugin = NULL;
  }
  gst_plugin_feature_set_rank (GST_PLUGIN_FEATURE_CAST (factory), rank);
  GST_PLUGIN_FEATURE_CAST (factory)->loaded = TRUE;

  gst_registry_add_feature (registry, GST_PLUGIN_FEATURE_CAST (factory));

  return TRUE;

  /* ERRORS */
detailserror:
  {
    gst_device_provider_factory_cleanup (factory);
    return FALSE;
  }
}

/**
 * gst_device_provider_factory_get:
 * @factory: factory to instantiate
 *
 * Returns the device provider of the type defined by the given device
 * providerfactory.
 *
 * Returns: (transfer full) (nullable): the #GstDeviceProvider or %NULL
 * if the device provider couldn't be created
 *
 * Since: 1.4
 */
GstDeviceProvider *
gst_device_provider_factory_get (GstDeviceProviderFactory * factory)
{
  GstDeviceProvider *device_provider;
  GstDeviceProviderClass *oclass;
  GstDeviceProviderFactory *newfactory;

  g_return_val_if_fail (factory != NULL, NULL);

  newfactory =
      GST_DEVICE_PROVIDER_FACTORY (gst_plugin_feature_load (GST_PLUGIN_FEATURE
          (factory)));

  if (newfactory == NULL)
    goto load_failed;

  factory = newfactory;

  GST_INFO ("getting device provider \"%s\"", GST_OBJECT_NAME (factory));

  if (factory->type == 0)
    goto no_type;

  device_provider = g_atomic_pointer_get (&newfactory->provider);
  if (device_provider)
    return gst_object_ref (device_provider);

  /* create an instance of the device provider, cast so we don't assert on NULL
   * also set name as early as we can
   */
  device_provider = GST_DEVICE_PROVIDER_CAST (g_object_newv (factory->type, 0,
          NULL));
  if (G_UNLIKELY (device_provider == NULL))
    goto no_device_provider;

  /* fill in the pointer to the factory in the device provider class. The
   * class will not be unreffed currently.
   * Be thread safe as there might be 2 threads creating the first instance of
   * an device provider at the same moment
   */
  oclass = GST_DEVICE_PROVIDER_GET_CLASS (device_provider);
  if (!g_atomic_pointer_compare_and_exchange (&oclass->factory, NULL, factory))
    gst_object_unref (factory);

  gst_object_ref_sink (device_provider);

  /* We use an atomic to make sure we don't create two in parallel */
  if (!g_atomic_pointer_compare_and_exchange (&newfactory->provider, NULL,
          device_provider)) {
    gst_object_unref (device_provider);

    device_provider = g_atomic_pointer_get (&newfactory->provider);
  }

  GST_DEBUG ("created device provider \"%s\"", GST_OBJECT_NAME (factory));

  return gst_object_ref (device_provider);

  /* ERRORS */
load_failed:
  {
    GST_WARNING_OBJECT (factory,
        "loading plugin containing feature %s returned NULL!",
        GST_OBJECT_NAME (factory));
    return NULL;
  }
no_type:
  {
    GST_WARNING_OBJECT (factory, "factory has no type");
    gst_object_unref (factory);
    return NULL;
  }
no_device_provider:
  {
    GST_WARNING_OBJECT (factory, "could not create device provider");
    gst_object_unref (factory);
    return NULL;
  }
}

/**
 * gst_device_provider_factory_get_by_name:
 * @factoryname: a named factory to instantiate
 *
 * Returns the device provider of the type defined by the given device
 * provider factory.
 *
 * Returns: (transfer full) (nullable): a #GstDeviceProvider or %NULL
 * if unable to create device provider
 *
 * Since: 1.4
 */
GstDeviceProvider *
gst_device_provider_factory_get_by_name (const gchar * factoryname)
{
  GstDeviceProviderFactory *factory;
  GstDeviceProvider *device_provider;

  g_return_val_if_fail (factoryname != NULL, NULL);
  g_return_val_if_fail (gst_is_initialized (), NULL);

  GST_LOG ("gstdeviceproviderfactory: get_by_name \"%s\"", factoryname);

  factory = gst_device_provider_factory_find (factoryname);
  if (factory == NULL)
    goto no_factory;

  GST_LOG_OBJECT (factory, "found factory %p", factory);
  device_provider = gst_device_provider_factory_get (factory);
  if (device_provider == NULL)
    goto create_failed;

  gst_object_unref (factory);
  return device_provider;

  /* ERRORS */
no_factory:
  {
    GST_INFO ("no such device provider factory \"%s\"!", factoryname);
    return NULL;
  }
create_failed:
  {
    GST_INFO_OBJECT (factory, "couldn't create instance!");
    gst_object_unref (factory);
    return NULL;
  }
}

/**
 * gst_device_provider_factory_get_device_provider_type:
 * @factory: factory to get managed #GType from
 *
 * Get the #GType for device providers managed by this factory. The type can
 * only be retrieved if the device provider factory is loaded, which can be
 * assured with gst_plugin_feature_load().
 *
 * Returns: the #GType for device providers managed by this factory.
 *
 * Since: 1.4
 */
GType
gst_device_provider_factory_get_device_provider_type (GstDeviceProviderFactory *
    factory)
{
  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER_FACTORY (factory),
      G_TYPE_INVALID);

  return factory->type;
}

/**
 * gst_device_provider_factory_get_metadata:
 * @factory: a #GstDeviceProviderFactory
 * @key: a key
 *
 * Get the metadata on @factory with @key.
 *
 * Returns: (nullable): the metadata with @key on @factory or %NULL
 * when there was no metadata with the given @key.
 *
 * Since: 1.4
 */
const gchar *
gst_device_provider_factory_get_metadata (GstDeviceProviderFactory * factory,
    const gchar * key)
{
  return gst_structure_get_string ((GstStructure *) factory->metadata, key);
}

/**
 * gst_device_provider_factory_get_metadata_keys:
 * @factory: a #GstDeviceProviderFactory
 *
 * Get the available keys for the metadata on @factory.
 *
 * Returns: (transfer full) (element-type utf8) (array zero-terminated=1) (nullable):
 * a %NULL-terminated array of key strings, or %NULL when there is no
 * metadata. Free with g_strfreev() when no longer needed.
 *
 * Since: 1.4
 */
gchar **
gst_device_provider_factory_get_metadata_keys (GstDeviceProviderFactory *
    factory)
{
  GstStructure *metadata;
  gchar **arr;
  gint i, num;

  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER_FACTORY (factory), NULL);

  metadata = (GstStructure *) factory->metadata;
  if (metadata == NULL)
    return NULL;

  num = gst_structure_n_fields (metadata);
  if (num == 0)
    return NULL;

  arr = g_new (gchar *, num + 1);
  for (i = 0; i < num; ++i) {
    arr[i] = g_strdup (gst_structure_nth_field_name (metadata, i));
  }
  arr[i] = NULL;
  return arr;
}

/**
 * gst_device_provider_factory_has_classesv:
 * @factory: a #GstDeviceProviderFactory
 * @classes: (array zero-terminated=1) (allow-none): a %NULL terminated array
 *   of classes to match, only match if all classes are matched
 *
 * Check if @factory matches all of the given classes
 *
 * Returns: %TRUE if @factory matches.
 *
 * Since: 1.4
 */
gboolean
gst_device_provider_factory_has_classesv (GstDeviceProviderFactory * factory,
    gchar ** classes)
{
  const gchar *klass;

  g_return_val_if_fail (GST_IS_DEVICE_PROVIDER_FACTORY (factory), FALSE);

  klass = gst_device_provider_factory_get_metadata (factory,
      GST_ELEMENT_METADATA_KLASS);

  if (klass == NULL) {
    GST_ERROR_OBJECT (factory,
        "device provider factory is missing klass identifiers");
    return FALSE;
  }

  for (; classes != NULL && classes[0] != NULL; classes++) {
    const gchar *found;
    guint len;

    if (classes[0] == '\0')
      continue;

    found = strstr (klass, classes[0]);

    if (!found)
      return FALSE;
    if (found != klass && *(found - 1) != '/')
      return FALSE;

    len = strlen (classes[0]);
    if (found[len] != 0 && found[len] != '/')
      return FALSE;
  }

  return TRUE;
}

/**
 * gst_device_provider_factory_has_classes:
 * @factory: a #GstDeviceProviderFactory
 * @classes: (allow-none): a "/" separate list of classes to match, only match
 *     if all classes are matched
 *
 * Check if @factory matches all of the given @classes
 *
 * Returns: %TRUE if @factory matches or if @classes is %NULL.
 *
 * Since: 1.4
 */
gboolean
gst_device_provider_factory_has_classes (GstDeviceProviderFactory * factory,
    const gchar * classes)
{
  gchar **classesv;
  gboolean res;

  if (classes == NULL)
    return TRUE;

  classesv = g_strsplit (classes, "/", 0);

  res = gst_device_provider_factory_has_classesv (factory, classesv);

  g_strfreev (classesv);

  return res;
}

static gboolean
device_provider_filter (GstPluginFeature * feature, GstRank * minrank)
{
  /* we only care about device provider factories */
  if (G_UNLIKELY (!GST_IS_DEVICE_PROVIDER_FACTORY (feature)))
    return FALSE;

  return (gst_plugin_feature_get_rank (feature) >= *minrank);
}

/**
 * gst_device_provider_factory_list_get_device_providers:
 * @minrank: Minimum rank
 *
 * Get a list of factories with a rank greater or equal to @minrank.
 * The list of factories is returned by decreasing rank.
 *
 * Returns: (transfer full) (element-type Gst.DeviceProviderFactory):
 * a #GList of #GstDeviceProviderFactory device providers. Use
 * gst_plugin_feature_list_free() after usage.
 *
 * Since: 1.4
 */
GList *
gst_device_provider_factory_list_get_device_providers (GstRank minrank)
{
  GList *result;

  /* get the feature list using the filter */
  result = gst_registry_feature_filter (gst_registry_get (),
      (GstPluginFeatureFilter) device_provider_filter, FALSE, &minrank);

  /* sort on rank and name */
  result = g_list_sort (result, gst_plugin_feature_rank_compare_func);

  return result;
}
