/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gstelementfactory.c: GstElementFactory object, support routines
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
 * SECTION:gstelementfactory
 * @short_description: Create GstElements from a factory
 * @see_also: #GstElement, #GstPlugin, #GstPluginFeature, #GstPadTemplate.
 *
 * #GstElementFactory is used to create instances of elements. A
 * GstElementFactory can be added to a #GstPlugin as it is also a
 * #GstPluginFeature.
 *
 * Use the gst_element_factory_find() and gst_element_factory_create()
 * functions to create element instances or use gst_element_factory_make() as a
 * convenient shortcut.
 *
 * The following code example shows you how to create a GstFileSrc element.
 *
 * <example>
 * <title>Using an element factory</title>
 * <programlisting language="c">
 *   #include &lt;gst/gst.h&gt;
 *
 *   GstElement *src;
 *   GstElementFactory *srcfactory;
 *
 *   gst_init (&amp;argc, &amp;argv);
 *
 *   srcfactory = gst_element_factory_find ("filesrc");
 *   g_return_if_fail (srcfactory != NULL);
 *   src = gst_element_factory_create (srcfactory, "src");
 *   g_return_if_fail (src != NULL);
 *   ...
 * </programlisting>
 * </example>
 */

#include "gst_private.h"

#include "gstelement.h"
#include "gstelementmetadata.h"
#include "gstinfo.h"
#include "gsturi.h"
#include "gstregistry.h"
#include "gst.h"

#include "glib-compat-private.h"

GST_DEBUG_CATEGORY_STATIC (element_factory_debug);
#define GST_CAT_DEFAULT element_factory_debug

static void gst_element_factory_finalize (GObject * object);
static void gst_element_factory_cleanup (GstElementFactory * factory);

/* static guint gst_element_factory_signals[LAST_SIGNAL] = { 0 }; */

/* this is defined in gstelement.c */
extern GQuark __gst_elementclass_factory;

#define _do_init \
{ \
  GST_DEBUG_CATEGORY_INIT (element_factory_debug, "GST_ELEMENT_FACTORY", \
      GST_DEBUG_BOLD | GST_DEBUG_FG_WHITE | GST_DEBUG_BG_RED, \
      "element factories keep information about installed elements"); \
}

G_DEFINE_TYPE_WITH_CODE (GstElementFactory, gst_element_factory,
    GST_TYPE_PLUGIN_FEATURE, _do_init);

static void
gst_element_factory_class_init (GstElementFactoryClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  gobject_class->finalize = gst_element_factory_finalize;
}

static void
gst_element_factory_init (GstElementFactory * factory)
{
  factory->staticpadtemplates = NULL;
  factory->numpadtemplates = 0;

  factory->uri_type = GST_URI_UNKNOWN;
  factory->uri_protocols = NULL;

  factory->interfaces = NULL;
}

static void
gst_element_factory_finalize (GObject * object)
{
  GstElementFactory *factory = GST_ELEMENT_FACTORY (object);

  gst_element_factory_cleanup (factory);
  G_OBJECT_CLASS (gst_element_factory_parent_class)->finalize (object);
}

/**
 * gst_element_factory_find:
 * @name: name of factory to find
 *
 * Search for an element factory of the given name. Refs the returned
 * element factory; caller is responsible for unreffing.
 *
 * Returns: (transfer full) (nullable): #GstElementFactory if found,
 * %NULL otherwise
 */
GstElementFactory *
gst_element_factory_find (const gchar * name)
{
  GstPluginFeature *feature;

  g_return_val_if_fail (name != NULL, NULL);

  feature = gst_registry_find_feature (gst_registry_get (), name,
      GST_TYPE_ELEMENT_FACTORY);
  if (feature)
    return GST_ELEMENT_FACTORY (feature);

  /* this isn't an error, for instance when you query if an element factory is
   * present */
  GST_LOG ("no such element factory \"%s\"", name);
  return NULL;
}

static void
gst_element_factory_cleanup (GstElementFactory * factory)
{
  GList *item;

  if (factory->metadata) {
    gst_structure_free ((GstStructure *) factory->metadata);
    factory->metadata = NULL;
  }
  if (factory->type) {
    factory->type = G_TYPE_INVALID;
  }

  for (item = factory->staticpadtemplates; item; item = item->next) {
    GstStaticPadTemplate *templ = item->data;

    gst_static_caps_cleanup (&templ->static_caps);
    g_slice_free (GstStaticPadTemplate, templ);
  }
  g_list_free (factory->staticpadtemplates);
  factory->staticpadtemplates = NULL;
  factory->numpadtemplates = 0;
  factory->uri_type = GST_URI_UNKNOWN;
  if (factory->uri_protocols) {
    g_strfreev (factory->uri_protocols);
    factory->uri_protocols = NULL;
  }

  g_list_free (factory->interfaces);
  factory->interfaces = NULL;
}

#define CHECK_METADATA_FIELD(klass, name, key)                                 \
  G_STMT_START {                                                               \
    const gchar *metafield = gst_element_class_get_metadata (klass, key);      \
    if (G_UNLIKELY (metafield == NULL || *metafield == '\0')) {                \
      g_warning ("Element factory metadata for '%s' has no valid %s field", name, key);    \
      goto detailserror;                                                       \
    } \
  } G_STMT_END;

/**
 * gst_element_register:
 * @plugin: (allow-none): #GstPlugin to register the element with, or %NULL for
 *     a static element.
 * @name: name of elements of this type
 * @rank: rank of element (higher rank means more importance when autoplugging)
 * @type: GType of element to register
 *
 * Create a new elementfactory capable of instantiating objects of the
 * @type and add the factory to @plugin.
 *
 * Returns: %TRUE, if the registering succeeded, %FALSE on error
 */
gboolean
gst_element_register (GstPlugin * plugin, const gchar * name, guint rank,
    GType type)
{
  GstPluginFeature *existing_feature;
  GstRegistry *registry;
  GstElementFactory *factory;
  GType *interfaces;
  guint n_interfaces, i;
  GstElementClass *klass;
  GList *item;

  g_return_val_if_fail (name != NULL, FALSE);
  g_return_val_if_fail (g_type_is_a (type, GST_TYPE_ELEMENT), FALSE);

  registry = gst_registry_get ();

  /* check if feature already exists, if it exists there is no need to update it
   * when the registry is getting updated, outdated plugins and all their
   * features are removed and readded.
   */
  existing_feature = gst_registry_lookup_feature (registry, name);
  if (existing_feature) {
    GST_DEBUG_OBJECT (registry, "update existing feature %p (%s)",
        existing_feature, name);
    factory = GST_ELEMENT_FACTORY_CAST (existing_feature);
    factory->type = type;
    existing_feature->loaded = TRUE;
    g_type_set_qdata (type, __gst_elementclass_factory, factory);
    gst_object_unref (existing_feature);
    return TRUE;
  }

  factory =
      GST_ELEMENT_FACTORY_CAST (g_object_newv (GST_TYPE_ELEMENT_FACTORY, 0,
          NULL));
  gst_plugin_feature_set_name (GST_PLUGIN_FEATURE_CAST (factory), name);
  GST_LOG_OBJECT (factory, "Created new elementfactory for type %s",
      g_type_name (type));

  /* provide info needed during class structure setup */
  g_type_set_qdata (type, __gst_elementclass_factory, factory);
  klass = GST_ELEMENT_CLASS (g_type_class_ref (type));

  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_LONGNAME);
  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_KLASS);
  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_DESCRIPTION);
  CHECK_METADATA_FIELD (klass, name, GST_ELEMENT_METADATA_AUTHOR);

  factory->type = type;
  factory->metadata = gst_structure_copy ((GstStructure *) klass->metadata);

  for (item = klass->padtemplates; item; item = item->next) {
    GstPadTemplate *templ = item->data;
    GstStaticPadTemplate *newt;
    gchar *caps_string = gst_caps_to_string (templ->caps);

    newt = g_slice_new (GstStaticPadTemplate);
    newt->name_template = g_intern_string (templ->name_template);
    newt->direction = templ->direction;
    newt->presence = templ->presence;
    newt->static_caps.caps = NULL;
    newt->static_caps.string = g_intern_string (caps_string);
    factory->staticpadtemplates =
        g_list_append (factory->staticpadtemplates, newt);

    g_free (caps_string);
  }
  factory->numpadtemplates = klass->numpadtemplates;

  /* special stuff for URI handling */
  if (g_type_is_a (type, GST_TYPE_URI_HANDLER)) {
    GstURIHandlerInterface *iface = (GstURIHandlerInterface *)
        g_type_interface_peek (klass, GST_TYPE_URI_HANDLER);

    if (!iface || !iface->get_type || !iface->get_protocols)
      goto urierror;
    if (iface->get_type)
      factory->uri_type = iface->get_type (factory->type);
    if (!GST_URI_TYPE_IS_VALID (factory->uri_type))
      goto urierror;
    if (iface->get_protocols) {
      const gchar *const *protocols;

      protocols = iface->get_protocols (factory->type);
      factory->uri_protocols = g_strdupv ((gchar **) protocols);
    }
    if (!factory->uri_protocols)
      goto urierror;
  }

  interfaces = g_type_interfaces (type, &n_interfaces);
  for (i = 0; i < n_interfaces; i++) {
    __gst_element_factory_add_interface (factory, g_type_name (interfaces[i]));
  }
  g_free (interfaces);

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
urierror:
  {
    GST_WARNING_OBJECT (factory, "error with uri handler!");
    gst_element_factory_cleanup (factory);
    return FALSE;
  }

detailserror:
  {
    gst_element_factory_cleanup (factory);
    return FALSE;
  }
}

/**
 * gst_element_factory_create:
 * @factory: factory to instantiate
 * @name: (allow-none): name of new element, or %NULL to automatically create
 *    a unique name
 *
 * Create a new element of the type defined by the given elementfactory.
 * It will be given the name supplied, since all elements require a name as
 * their first argument.
 *
 * Returns: (transfer floating) (nullable): new #GstElement or %NULL
 *     if the element couldn't be created
 */
GstElement *
gst_element_factory_create (GstElementFactory * factory, const gchar * name)
{
  GstElement *element;
  GstElementClass *oclass;
  GstElementFactory *newfactory;

  g_return_val_if_fail (factory != NULL, NULL);

  newfactory =
      GST_ELEMENT_FACTORY (gst_plugin_feature_load (GST_PLUGIN_FEATURE
          (factory)));

  if (newfactory == NULL)
    goto load_failed;

  factory = newfactory;

  if (name)
    GST_INFO ("creating element \"%s\" named \"%s\"",
        GST_OBJECT_NAME (factory), GST_STR_NULL (name));
  else
    GST_INFO ("creating element \"%s\"", GST_OBJECT_NAME (factory));

  if (factory->type == 0)
    goto no_type;

  /* create an instance of the element, cast so we don't assert on NULL
   * also set name as early as we can
   */
  if (name)
    element =
        GST_ELEMENT_CAST (g_object_new (factory->type, "name", name, NULL));
  else
    element = GST_ELEMENT_CAST (g_object_newv (factory->type, 0, NULL));
  if (G_UNLIKELY (element == NULL))
    goto no_element;

  /* fill in the pointer to the factory in the element class. The
   * class will not be unreffed currently.
   * Be thread safe as there might be 2 threads creating the first instance of
   * an element at the same moment
   */
  oclass = GST_ELEMENT_GET_CLASS (element);
  if (!g_atomic_pointer_compare_and_exchange (&oclass->elementfactory, NULL,
          factory))
    gst_object_unref (factory);

  GST_DEBUG ("created element \"%s\"", GST_OBJECT_NAME (factory));

  return element;

  /* ERRORS */
load_failed:
  {
    GST_WARNING_OBJECT (factory,
        "loading plugin containing feature %s returned NULL!", name);
    return NULL;
  }
no_type:
  {
    GST_WARNING_OBJECT (factory, "factory has no type");
    gst_object_unref (factory);
    return NULL;
  }
no_element:
  {
    GST_WARNING_OBJECT (factory, "could not create element");
    gst_object_unref (factory);
    return NULL;
  }
}

/**
 * gst_element_factory_make:
 * @factoryname: a named factory to instantiate
 * @name: (allow-none): name of new element, or %NULL to automatically create
 *    a unique name
 *
 * Create a new element of the type defined by the given element factory.
 * If name is %NULL, then the element will receive a guaranteed unique name,
 * consisting of the element factory name and a number.
 * If name is given, it will be given the name supplied.
 *
 * Returns: (transfer floating) (nullable): new #GstElement or %NULL
 * if unable to create element
 */
GstElement *
gst_element_factory_make (const gchar * factoryname, const gchar * name)
{
  GstElementFactory *factory;
  GstElement *element;

  g_return_val_if_fail (factoryname != NULL, NULL);
  g_return_val_if_fail (gst_is_initialized (), NULL);

  GST_LOG ("gstelementfactory: make \"%s\" \"%s\"",
      factoryname, GST_STR_NULL (name));

  factory = gst_element_factory_find (factoryname);
  if (factory == NULL)
    goto no_factory;

  GST_LOG_OBJECT (factory, "found factory %p", factory);
  element = gst_element_factory_create (factory, name);
  if (element == NULL)
    goto create_failed;

  gst_object_unref (factory);
  return element;

  /* ERRORS */
no_factory:
  {
    GST_INFO ("no such element factory \"%s\"!", factoryname);
    return NULL;
  }
create_failed:
  {
    GST_INFO_OBJECT (factory, "couldn't create instance!");
    gst_object_unref (factory);
    return NULL;
  }
}

void
__gst_element_factory_add_static_pad_template (GstElementFactory * factory,
    GstStaticPadTemplate * templ)
{
  g_return_if_fail (factory != NULL);
  g_return_if_fail (templ != NULL);

  factory->staticpadtemplates =
      g_list_append (factory->staticpadtemplates, templ);
  factory->numpadtemplates++;
}

/**
 * gst_element_factory_get_element_type:
 * @factory: factory to get managed #GType from
 *
 * Get the #GType for elements managed by this factory. The type can
 * only be retrieved if the element factory is loaded, which can be
 * assured with gst_plugin_feature_load().
 *
 * Returns: the #GType for elements managed by this factory or 0 if
 * the factory is not loaded.
 */
GType
gst_element_factory_get_element_type (GstElementFactory * factory)
{
  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), 0);

  return factory->type;
}

/**
 * gst_element_factory_get_metadata:
 * @factory: a #GstElementFactory
 * @key: a key
 *
 * Get the metadata on @factory with @key.
 *
 * Returns: (nullable): the metadata with @key on @factory or %NULL
 * when there was no metadata with the given @key.
 */
const gchar *
gst_element_factory_get_metadata (GstElementFactory * factory,
    const gchar * key)
{
  return gst_structure_get_string ((GstStructure *) factory->metadata, key);
}

/**
 * gst_element_factory_get_metadata_keys:
 * @factory: a #GstElementFactory
 *
 * Get the available keys for the metadata on @factory.
 *
 * Returns: (transfer full) (element-type utf8) (array zero-terminated=1) (nullable):
 * a %NULL-terminated array of key strings, or %NULL when there is no
 * metadata. Free with g_strfreev() when no longer needed.
 */
gchar **
gst_element_factory_get_metadata_keys (GstElementFactory * factory)
{
  GstStructure *metadata;
  gchar **arr;
  gint i, num;

  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), NULL);

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
 * gst_element_factory_get_num_pad_templates:
 * @factory: a #GstElementFactory
 *
 * Gets the number of pad_templates in this factory.
 *
 * Returns: the number of pad_templates
 */
guint
gst_element_factory_get_num_pad_templates (GstElementFactory * factory)
{
  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), 0);

  return factory->numpadtemplates;
}

/**
 * __gst_element_factory_add_interface:
 * @elementfactory: The elementfactory to add the interface to
 * @interfacename: Name of the interface
 *
 * Adds the given interfacename to the list of implemented interfaces of the
 * element.
 */
void
__gst_element_factory_add_interface (GstElementFactory * elementfactory,
    const gchar * interfacename)
{
  g_return_if_fail (GST_IS_ELEMENT_FACTORY (elementfactory));
  g_return_if_fail (interfacename != NULL);
  g_return_if_fail (interfacename[0] != '\0');  /* no empty string */

  elementfactory->interfaces =
      g_list_prepend (elementfactory->interfaces,
      (gpointer) g_intern_string (interfacename));
}

/**
 * gst_element_factory_get_static_pad_templates:
 * @factory: a #GstElementFactory
 *
 * Gets the #GList of #GstStaticPadTemplate for this factory.
 *
 * Returns: (transfer none) (element-type Gst.StaticPadTemplate): the
 *     static pad templates
 */
const GList *
gst_element_factory_get_static_pad_templates (GstElementFactory * factory)
{
  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), NULL);

  return factory->staticpadtemplates;
}

/**
 * gst_element_factory_get_uri_type:
 * @factory: a #GstElementFactory
 *
 * Gets the type of URIs the element supports or #GST_URI_UNKNOWN if none.
 *
 * Returns: type of URIs this element supports
 */
GstURIType
gst_element_factory_get_uri_type (GstElementFactory * factory)
{
  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), GST_URI_UNKNOWN);

  return factory->uri_type;
}

/**
 * gst_element_factory_get_uri_protocols:
 * @factory: a #GstElementFactory
 *
 * Gets a %NULL-terminated array of protocols this element supports or %NULL if
 * no protocols are supported. You may not change the contents of the returned
 * array, as it is still owned by the element factory. Use g_strdupv() to
 * make a copy of the protocol string array if you need to.
 *
 * Returns: (transfer none) (array zero-terminated=1): the supported protocols
 *     or %NULL
 */
const gchar *const *
gst_element_factory_get_uri_protocols (GstElementFactory * factory)
{
  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), NULL);

  return (const gchar * const *) factory->uri_protocols;
}

/**
 * gst_element_factory_has_interface:
 * @factory: a #GstElementFactory
 * @interfacename: an interface name
 *
 * Check if @factory implements the interface with name @interfacename.
 *
 * Returns: %TRUE when @factory implement the interface.
 */
gboolean
gst_element_factory_has_interface (GstElementFactory * factory,
    const gchar * interfacename)
{
  GList *walk;

  g_return_val_if_fail (GST_IS_ELEMENT_FACTORY (factory), FALSE);

  for (walk = factory->interfaces; walk; walk = g_list_next (walk)) {
    gchar *iname = (gchar *) walk->data;

    if (!strcmp (iname, interfacename))
      return TRUE;
  }
  return FALSE;
}


typedef struct
{
  GstElementFactoryListType type;
  GstRank minrank;
} FilterData;


/**
 * gst_element_factory_list_is_type:
 * @factory: a #GstElementFactory
 * @type: a #GstElementFactoryListType
 *
 * Check if @factory is of the given types.
 *
 * Returns: %TRUE if @factory is of @type.
 */
gboolean
gst_element_factory_list_is_type (GstElementFactory * factory,
    GstElementFactoryListType type)
{
  gboolean res = FALSE;
  const gchar *klass;

  klass =
      gst_element_factory_get_metadata (factory, GST_ELEMENT_METADATA_KLASS);

  if (klass == NULL) {
    GST_ERROR_OBJECT (factory, "element factory is missing klass identifiers");
    return res;
  }

  /* Filter by element type first, as soon as it matches
   * one type, we skip all other tests */
  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_SINK))
    res = (strstr (klass, "Sink") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_SRC))
    res = (strstr (klass, "Source") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_DECODER))
    res = (strstr (klass, "Decoder") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_ENCODER))
    res = (strstr (klass, "Encoder") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_MUXER))
    res = (strstr (klass, "Muxer") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_DEMUXER))
    res = (strstr (klass, "Demux") != NULL);

  /* FIXME : We're actually parsing two Classes here... */
  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_PARSER))
    res = ((strstr (klass, "Parser") != NULL)
        && (strstr (klass, "Codec") != NULL));

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_DEPAYLOADER))
    res = (strstr (klass, "Depayloader") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_PAYLOADER))
    res = (strstr (klass, "Payloader") != NULL);

  if (!res && (type & GST_ELEMENT_FACTORY_TYPE_FORMATTER))
    res = (strstr (klass, "Formatter") != NULL);

  /* Filter by media type now, we only test if it
   * matched any of the types above or only checking the media
   * type was requested. */
  if ((res || !(type & (GST_ELEMENT_FACTORY_TYPE_MAX_ELEMENTS - 1)))
      && (type & (GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO |
              GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO |
              GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE |
              GST_ELEMENT_FACTORY_TYPE_MEDIA_SUBTITLE |
              GST_ELEMENT_FACTORY_TYPE_MEDIA_METADATA)))
    res = ((type & GST_ELEMENT_FACTORY_TYPE_MEDIA_AUDIO)
        && (strstr (klass, "Audio") != NULL))
        || ((type & GST_ELEMENT_FACTORY_TYPE_MEDIA_VIDEO)
        && (strstr (klass, "Video") != NULL))
        || ((type & GST_ELEMENT_FACTORY_TYPE_MEDIA_IMAGE)
        && (strstr (klass, "Image") != NULL)) ||
        ((type & GST_ELEMENT_FACTORY_TYPE_MEDIA_SUBTITLE)
        && (strstr (klass, "Subtitle") != NULL)) ||
        ((type & GST_ELEMENT_FACTORY_TYPE_MEDIA_METADATA)
        && (strstr (klass, "Metadata") != NULL));

  return res;
}

static gboolean
element_filter (GstPluginFeature * feature, FilterData * data)
{
  gboolean res;

  /* we only care about element factories */
  if (G_UNLIKELY (!GST_IS_ELEMENT_FACTORY (feature)))
    return FALSE;

  res = (gst_plugin_feature_get_rank (feature) >= data->minrank) &&
      gst_element_factory_list_is_type (GST_ELEMENT_FACTORY_CAST (feature),
      data->type);

  return res;
}

/**
 * gst_element_factory_list_get_elements:
 * @type: a #GstElementFactoryListType
 * @minrank: Minimum rank
 *
 * Get a list of factories that match the given @type. Only elements
 * with a rank greater or equal to @minrank will be returned.
 * The list of factories is returned by decreasing rank.
 *
 * Returns: (transfer full) (element-type Gst.ElementFactory): a #GList of
 *     #GstElementFactory elements. Use gst_plugin_feature_list_free() after
 *     usage.
 */
GList *
gst_element_factory_list_get_elements (GstElementFactoryListType type,
    GstRank minrank)
{
  GList *result;
  FilterData data;

  /* prepare type */
  data.type = type;
  data.minrank = minrank;

  /* get the feature list using the filter */
  result = gst_registry_feature_filter (gst_registry_get (),
      (GstPluginFeatureFilter) element_filter, FALSE, &data);

  /* sort on rank and name */
  result = g_list_sort (result, gst_plugin_feature_rank_compare_func);

  return result;
}

/**
 * gst_element_factory_list_filter:
 * @list: (transfer none) (element-type Gst.ElementFactory): a #GList of
 *     #GstElementFactory to filter
 * @caps: a #GstCaps
 * @direction: a #GstPadDirection to filter on
 * @subsetonly: whether to filter on caps subsets or not.
 *
 * Filter out all the elementfactories in @list that can handle @caps in
 * the given direction.
 *
 * If @subsetonly is %TRUE, then only the elements whose pads templates
 * are a complete superset of @caps will be returned. Else any element
 * whose pad templates caps can intersect with @caps will be returned.
 *
 * Returns: (transfer full) (element-type Gst.ElementFactory): a #GList of
 *     #GstElementFactory elements that match the given requisites.
 *     Use #gst_plugin_feature_list_free after usage.
 */
GList *
gst_element_factory_list_filter (GList * list,
    const GstCaps * caps, GstPadDirection direction, gboolean subsetonly)
{
  GQueue results = G_QUEUE_INIT;

  GST_DEBUG ("finding factories");

  /* loop over all the factories */
  for (; list; list = list->next) {
    GstElementFactory *factory;
    const GList *templates;
    GList *walk;

    factory = (GstElementFactory *) list->data;

    GST_DEBUG ("Trying %s",
        gst_plugin_feature_get_name ((GstPluginFeature *) factory));

    /* get the templates from the element factory */
    templates = gst_element_factory_get_static_pad_templates (factory);
    for (walk = (GList *) templates; walk; walk = g_list_next (walk)) {
      GstStaticPadTemplate *templ = walk->data;

      /* we only care about the sink templates */
      if (templ->direction == direction) {
        GstCaps *tmpl_caps;

        /* try to intersect the caps with the caps of the template */
        tmpl_caps = gst_static_caps_get (&templ->static_caps);

        /* FIXME, intersect is not the right method, we ideally want to check
         * for a subset here */

        /* check if the intersection is empty */
        if ((subsetonly && gst_caps_is_subset (caps, tmpl_caps)) ||
            (!subsetonly && gst_caps_can_intersect (caps, tmpl_caps))) {
          /* non empty intersection, we can use this element */
          g_queue_push_tail (&results, gst_object_ref (factory));
          gst_caps_unref (tmpl_caps);
          break;
        }
        gst_caps_unref (tmpl_caps);
      }
    }
  }
  return results.head;
}
