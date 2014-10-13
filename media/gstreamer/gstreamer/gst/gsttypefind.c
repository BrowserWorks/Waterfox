/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gsttypefind.c: typefinding subsystem
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
 * SECTION:gsttypefind
 * @short_description: Stream type detection
 *
 * The following functions allow you to detect the media type of an unknown
 * stream.
 */

#include "gst_private.h"
#include "gstinfo.h"
#include "gsttypefind.h"
#include "gstregistry.h"
#include "gsttypefindfactory.h"

GST_DEBUG_CATEGORY_EXTERN (type_find_debug);
#define GST_CAT_DEFAULT type_find_debug

G_DEFINE_POINTER_TYPE (GstTypeFind, gst_type_find);

/**
 * gst_type_find_register:
 * @plugin: (allow-none): A #GstPlugin, or %NULL for a static typefind function
 * @name: The name for registering
 * @rank: The rank (or importance) of this typefind function
 * @func: The #GstTypeFindFunction to use
 * @extensions: (allow-none): Optional comma-separated list of extensions
 *     that could belong to this type
 * @possible_caps: Optionally the caps that could be returned when typefinding
 *                 succeeds
 * @data: Optional user data. This user data must be available until the plugin
 *        is unloaded.
 * @data_notify: a #GDestroyNotify that will be called on @data when the plugin
 *        is unloaded.
 *
 * Registers a new typefind function to be used for typefinding. After
 * registering this function will be available for typefinding.
 * This function is typically called during an element's plugin initialization.
 *
 * Returns: %TRUE on success, %FALSE otherwise
 */
gboolean
gst_type_find_register (GstPlugin * plugin, const gchar * name, guint rank,
    GstTypeFindFunction func, const gchar * extensions,
    GstCaps * possible_caps, gpointer data, GDestroyNotify data_notify)
{
  GstTypeFindFactory *factory;

  g_return_val_if_fail (name != NULL, FALSE);

  GST_INFO ("registering typefind function for %s", name);

  factory = g_object_newv (GST_TYPE_TYPE_FIND_FACTORY, 0, NULL);
  GST_DEBUG_OBJECT (factory, "using new typefind factory for %s", name);
  g_assert (GST_IS_TYPE_FIND_FACTORY (factory));

  gst_plugin_feature_set_name (GST_PLUGIN_FEATURE_CAST (factory), name);
  gst_plugin_feature_set_rank (GST_PLUGIN_FEATURE_CAST (factory), rank);

  if (factory->extensions) {
    g_strfreev (factory->extensions);
    factory->extensions = NULL;
  }
  if (extensions)
    factory->extensions = g_strsplit (extensions, ",", -1);

  gst_caps_replace (&factory->caps, possible_caps);
  factory->function = func;
  factory->user_data = data;
  factory->user_data_notify = data_notify;
  if (plugin && plugin->desc.name) {
    GST_PLUGIN_FEATURE_CAST (factory)->plugin_name = plugin->desc.name; /* interned string */
    GST_PLUGIN_FEATURE_CAST (factory)->plugin = plugin;
    g_object_add_weak_pointer ((GObject *) plugin,
        (gpointer *) & GST_PLUGIN_FEATURE_CAST (factory)->plugin);
  } else {
    GST_PLUGIN_FEATURE_CAST (factory)->plugin_name = "NULL";
    GST_PLUGIN_FEATURE_CAST (factory)->plugin = NULL;
  }
  GST_PLUGIN_FEATURE_CAST (factory)->loaded = TRUE;

  gst_registry_add_feature (gst_registry_get (),
      GST_PLUGIN_FEATURE_CAST (factory));

  return TRUE;
}

/*** typefind function interface **********************************************/

/**
 * gst_type_find_peek:
 * @find: The #GstTypeFind object the function was called with
 * @offset: The offset
 * @size: The number of bytes to return
 *
 * Returns the @size bytes of the stream to identify beginning at offset. If
 * offset is a positive number, the offset is relative to the beginning of the
 * stream, if offset is a negative number the offset is relative to the end of
 * the stream. The returned memory is valid until the typefinding function
 * returns and must not be freed.
 *
 * Returns: (transfer none) (array length=size) (nullable): the
 *     requested data, or %NULL if that data is not available.
 */
const guint8 *
gst_type_find_peek (GstTypeFind * find, gint64 offset, guint size)
{
  g_return_val_if_fail (find->peek != NULL, NULL);

  return find->peek (find->data, offset, size);
}

/**
 * gst_type_find_suggest:
 * @find: The #GstTypeFind object the function was called with
 * @probability: The probability in percent that the suggestion is right
 * @caps: The fixed #GstCaps to suggest
 *
 * If a #GstTypeFindFunction calls this function it suggests the caps with the
 * given probability. A #GstTypeFindFunction may supply different suggestions
 * in one call.
 * It is up to the caller of the #GstTypeFindFunction to interpret these values.
 */
void
gst_type_find_suggest (GstTypeFind * find, guint probability, GstCaps * caps)
{
  g_return_if_fail (find->suggest != NULL);
  g_return_if_fail (probability <= 100);
  g_return_if_fail (caps != NULL);
  g_return_if_fail (gst_caps_is_fixed (caps));

  find->suggest (find->data, probability, caps);
}

/**
 * gst_type_find_suggest_simple:
 * @find: The #GstTypeFind object the function was called with
 * @probability: The probability in percent that the suggestion is right
 * @media_type: the media type of the suggested caps
 * @fieldname: (allow-none): first field of the suggested caps, or %NULL
 * @...: additional arguments to the suggested caps in the same format as the
 *     arguments passed to gst_structure_new() (ie. triplets of field name,
 *     field GType and field value)
 *
 * If a #GstTypeFindFunction calls this function it suggests the caps with the
 * given probability. A #GstTypeFindFunction may supply different suggestions
 * in one call. It is up to the caller of the #GstTypeFindFunction to interpret
 * these values.
 *
 * This function is similar to gst_type_find_suggest(), only that instead of
 * passing a #GstCaps argument you can create the caps on the fly in the same
 * way as you can with gst_caps_new_simple().
 *
 * Make sure you terminate the list of arguments with a %NULL argument and that
 * the values passed have the correct type (in terms of width in bytes when
 * passed to the vararg function - this applies particularly to gdouble and
 * guint64 arguments).
 */
void
gst_type_find_suggest_simple (GstTypeFind * find, guint probability,
    const char *media_type, const char *fieldname, ...)
{
  GstStructure *structure;
  va_list var_args;
  GstCaps *caps;

  g_return_if_fail (find->suggest != NULL);
  g_return_if_fail (probability <= 100);
  g_return_if_fail (media_type != NULL);

  caps = gst_caps_new_empty ();

  va_start (var_args, fieldname);
  structure = gst_structure_new_valist (media_type, fieldname, var_args);
  va_end (var_args);

  gst_caps_append_structure (caps, structure);
  g_return_if_fail (gst_caps_is_fixed (caps));

  find->suggest (find->data, probability, caps);
  gst_caps_unref (caps);
}

/**
 * gst_type_find_get_length:
 * @find: The #GstTypeFind the function was called with
 *
 * Get the length of the data stream.
 *
 * Returns: The length of the data stream, or 0 if it is not available.
 */
guint64
gst_type_find_get_length (GstTypeFind * find)
{
  if (find->get_length == NULL)
    return 0;

  return find->get_length (find->data);
}
