/* GStreamer TagXmpWriter
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
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
 * SECTION:gsttagxmpwriter
 * @short_description: Interface for elements that provide XMP serialization
 *
 * <refsect2>
 * <para>
 * This interface is implemented by elements that are able to do XMP serialization. Examples for
 * such elements are #jifmux and #qtmux.
 * </para>
 * <para>
 * Applications can use this interface to configure which XMP schemas should be used when serializing
 * tags into XMP. Schemas are represented by their names, a full list of the supported schemas can be
 * obtained from gst_tag_xmp_list_schemas(). By default, all schemas are used.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "xmpwriter.h"
#include <string.h>
#include <gst/tag/tag.h>

static GQuark tag_xmp_writer_key;

typedef struct
{
  GSList *schemas;
  GMutex lock;
} GstTagXmpWriterData;

#define GST_TAG_XMP_WRITER_DATA_LOCK(data) g_mutex_lock(&data->lock)
#define GST_TAG_XMP_WRITER_DATA_UNLOCK(data) g_mutex_unlock(&data->lock)

GType
gst_tag_xmp_writer_get_type (void)
{
  static volatile gsize xmp_config_type = 0;

  if (g_once_init_enter (&xmp_config_type)) {
    GType _type;
    static const GTypeInfo xmp_config_info = {
      sizeof (GstTagXmpWriterInterface),        /* class_size */
      NULL,                     /* base_init */
      NULL,                     /* base_finalize */
      NULL,
      NULL,                     /* class_finalize */
      NULL,                     /* class_data */
      0,
      0,
      NULL
    };

    _type = g_type_register_static (G_TYPE_INTERFACE, "GstTagXmpWriter",
        &xmp_config_info, 0);
    tag_xmp_writer_key = g_quark_from_static_string ("GST_TAG_XMP_WRITER");
    g_type_interface_add_prerequisite (_type, GST_TYPE_ELEMENT);

    g_once_init_leave (&xmp_config_type, _type);
  }

  return xmp_config_type;
}

static void
gst_tag_xmp_writer_data_add_schema_unlocked (GstTagXmpWriterData * data,
    const gchar * schema)
{
  if (!g_slist_find_custom (data->schemas, schema, (GCompareFunc) strcmp)) {
    data->schemas = g_slist_prepend (data->schemas, g_strdup (schema));
  }
}

static void
gst_tag_xmp_writer_data_add_all_schemas_unlocked (GstTagXmpWriterData * data)
{
  const gchar **schemas;
  gint i = 0;

  /* initialize it with all schemas */
  schemas = gst_tag_xmp_list_schemas ();
  while (schemas[i] != NULL) {
    gst_tag_xmp_writer_data_add_schema_unlocked (data, schemas[i]);
    i++;
  }
}


static void
gst_tag_xmp_writer_data_free (gpointer p)
{
  GstTagXmpWriterData *data = (GstTagXmpWriterData *) p;
  GSList *iter;

  if (data->schemas) {
    for (iter = data->schemas; iter; iter = g_slist_next (iter)) {
      g_free (iter->data);
    }
    g_slist_free (data->schemas);
  }
  g_mutex_clear (&data->lock);

  g_slice_free (GstTagXmpWriterData, data);
}

static GstTagXmpWriterData *
gst_tag_xmp_writer_get_data (GstTagXmpWriter * xmpconfig)
{
  GstTagXmpWriterData *data;

  data = g_object_get_qdata (G_OBJECT (xmpconfig), tag_xmp_writer_key);
  if (!data) {
    /* make sure no other thread is creating a GstTagData at the same time */
    static GMutex create_mutex; /* no initialisation required */

    g_mutex_lock (&create_mutex);

    data = g_object_get_qdata (G_OBJECT (xmpconfig), tag_xmp_writer_key);
    if (!data) {
      data = g_slice_new (GstTagXmpWriterData);

      g_mutex_init (&data->lock);
      data->schemas = NULL;
      gst_tag_xmp_writer_data_add_all_schemas_unlocked (data);

      g_object_set_qdata_full (G_OBJECT (xmpconfig), tag_xmp_writer_key, data,
          gst_tag_xmp_writer_data_free);
    }
    g_mutex_unlock (&create_mutex);
  }

  return data;
}

/**
 * gst_tag_xmp_writer_add_all_schemas:
 * @config: a #GstTagXmpWriter
 *
 * Adds all available XMP schemas to the configuration. Meaning that
 * all will be used.
 */
void
gst_tag_xmp_writer_add_all_schemas (GstTagXmpWriter * config)
{
  GstTagXmpWriterData *data;

  g_return_if_fail (GST_IS_TAG_XMP_WRITER (config));

  data = gst_tag_xmp_writer_get_data (config);

  GST_TAG_XMP_WRITER_DATA_LOCK (data);
  gst_tag_xmp_writer_data_add_all_schemas_unlocked (data);
  GST_TAG_XMP_WRITER_DATA_UNLOCK (data);
}

/**
 * gst_tag_xmp_writer_add_schema:
 * @config: a #GstTagXmpWriter
 * @schema: the schema to be added
 *
 * Adds @schema to the list schemas
 */
void
gst_tag_xmp_writer_add_schema (GstTagXmpWriter * config, const gchar * schema)
{
  GstTagXmpWriterData *data;

  g_return_if_fail (GST_IS_TAG_XMP_WRITER (config));

  data = gst_tag_xmp_writer_get_data (config);

  GST_TAG_XMP_WRITER_DATA_LOCK (data);
  gst_tag_xmp_writer_data_add_schema_unlocked (data, schema);
  GST_TAG_XMP_WRITER_DATA_UNLOCK (data);
}

/**
 * gst_tag_xmp_writer_has_schema:
 * @config: a #GstTagXmpWriter
 * @schema: the schema to test
 *
 * Checks if @schema is going to be used
 *
 * Returns: %TRUE if it is going to be used
 */
gboolean
gst_tag_xmp_writer_has_schema (GstTagXmpWriter * config, const gchar * schema)
{
  GstTagXmpWriterData *data;
  gboolean ret = FALSE;
  GSList *iter;

  g_return_val_if_fail (GST_IS_TAG_XMP_WRITER (config), FALSE);

  data = gst_tag_xmp_writer_get_data (config);

  GST_TAG_XMP_WRITER_DATA_LOCK (data);
  for (iter = data->schemas; iter; iter = g_slist_next (iter)) {
    if (strcmp ((const gchar *) iter->data, schema) == 0) {
      ret = TRUE;
      break;
    }
  }
  GST_TAG_XMP_WRITER_DATA_UNLOCK (data);

  return ret;
}

/**
 * gst_tag_xmp_writer_remove_schema:
 * @config: a #GstTagXmpWriter
 * @schema: the schema to remove
 *
 * Removes a schema from the list of schemas to use. Nothing is done if
 * the schema wasn't in the list
 */
void
gst_tag_xmp_writer_remove_schema (GstTagXmpWriter * config,
    const gchar * schema)
{
  GstTagXmpWriterData *data;
  GSList *iter = NULL;

  g_return_if_fail (GST_IS_TAG_XMP_WRITER (config));

  data = gst_tag_xmp_writer_get_data (config);

  GST_TAG_XMP_WRITER_DATA_LOCK (data);
  for (iter = data->schemas; iter; iter = g_slist_next (iter)) {
    if (strcmp ((const gchar *) iter->data, schema) == 0) {
      g_free (iter->data);
      data->schemas = g_slist_delete_link (data->schemas, iter);
      break;
    }
  }
  GST_TAG_XMP_WRITER_DATA_UNLOCK (data);
}

/**
 * gst_tag_xmp_writer_remove_all_schemas:
 * @config: a #GstTagXmpWriter
 *
 * Removes all schemas from the list of schemas to use. Meaning that no
 * XMP will be generated.
 */
void
gst_tag_xmp_writer_remove_all_schemas (GstTagXmpWriter * config)
{
  GstTagXmpWriterData *data;
  GSList *iter;

  g_return_if_fail (GST_IS_TAG_XMP_WRITER (config));

  data = gst_tag_xmp_writer_get_data (config);

  GST_TAG_XMP_WRITER_DATA_LOCK (data);
  if (data->schemas) {
    for (iter = data->schemas; iter; iter = g_slist_next (iter)) {
      g_free (iter->data);
    }
    g_slist_free (data->schemas);
  }
  data->schemas = NULL;
  GST_TAG_XMP_WRITER_DATA_UNLOCK (data);
}

GstBuffer *
gst_tag_xmp_writer_tag_list_to_xmp_buffer (GstTagXmpWriter * config,
    const GstTagList * taglist, gboolean read_only)
{
  GstTagXmpWriterData *data;
  GstBuffer *buf = NULL;
  gint i = 0;
  GSList *iter;

  g_return_val_if_fail (GST_IS_TAG_XMP_WRITER (config), NULL);

  data = gst_tag_xmp_writer_get_data (config);

  GST_TAG_XMP_WRITER_DATA_LOCK (data);
  if (data->schemas) {
    gchar **array = g_new0 (gchar *, g_slist_length (data->schemas) + 1);
    if (array) {
      for (iter = data->schemas; iter; iter = g_slist_next (iter)) {
        array[i++] = (gchar *) iter->data;
      }
      buf = gst_tag_list_to_xmp_buffer (taglist, read_only,
          (const gchar **) array);
      g_free (array);
    }
  }
  GST_TAG_XMP_WRITER_DATA_UNLOCK (data);

  return buf;
}
