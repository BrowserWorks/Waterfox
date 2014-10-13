/* GStreamer
 * Copyright (C) 2003 Benjamin Otte <in7y118@public.uni-hamburg.de>
 *
 * gsttagsetter.c: interface for tag setting on elements
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
 * SECTION:gsttagsetter
 * @short_description: Element interface that allows setting and retrieval
 *                     of media metadata
 *
 * Element interface that allows setting of media metadata.
 *
 * Elements that support changing a stream's metadata will implement this
 * interface. Examples of such elements are 'vorbisenc', 'theoraenc' and
 * 'id3v2mux'.
 * 
 * If you just want to retrieve metadata in your application then all you
 * need to do is watch for tag messages on your pipeline's bus. This
 * interface is only for setting metadata, not for extracting it. To set tags
 * from the application, find tagsetter elements and set tags using e.g.
 * gst_tag_setter_merge_tags() or gst_tag_setter_add_tags(). Also consider
 * setting the #GstTagMergeMode that is used for tag events that arrive at the
 * tagsetter element (default mode is to keep existing tags).
 * The application should do that before the element goes to %GST_STATE_PAUSED.
 * 
 * Elements implementing the #GstTagSetter interface often have to merge
 * any tags received from upstream and the tags set by the application via
 * the interface. This can be done like this:
 *
 * |[
 * GstTagMergeMode merge_mode;
 * const GstTagList *application_tags;
 * const GstTagList *event_tags;
 * GstTagSetter *tagsetter;
 * GstTagList *result;
 *  
 * tagsetter = GST_TAG_SETTER (element);
 *  
 * merge_mode = gst_tag_setter_get_tag_merge_mode (tagsetter);
 * application_tags = gst_tag_setter_get_tag_list (tagsetter);
 * event_tags = (const GstTagList *) element->event_tags;
 *  
 * GST_LOG_OBJECT (tagsetter, "merging tags, merge mode = %d", merge_mode);
 * GST_LOG_OBJECT (tagsetter, "event tags: %" GST_PTR_FORMAT, event_tags);
 * GST_LOG_OBJECT (tagsetter, "set   tags: %" GST_PTR_FORMAT, application_tags);
 *  
 * result = gst_tag_list_merge (application_tags, event_tags, merge_mode);
 *  
 * GST_LOG_OBJECT (tagsetter, "final tags: %" GST_PTR_FORMAT, result);
 * ]|
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gst_private.h"
#include "gsttagsetter.h"
#include <gobject/gvaluecollector.h>
#include <string.h>

static GQuark gst_tag_key;

typedef struct
{
  GstTagMergeMode mode;
  GstTagList *list;
  GMutex lock;
} GstTagData;

#define GST_TAG_DATA_LOCK(data) g_mutex_lock(&data->lock)
#define GST_TAG_DATA_UNLOCK(data) g_mutex_unlock(&data->lock)

G_DEFINE_INTERFACE_WITH_CODE (GstTagSetter, gst_tag_setter, GST_TYPE_ELEMENT,
    gst_tag_key = g_quark_from_static_string ("gst-tag-setter-data");
    );

static void
gst_tag_setter_default_init (GstTagSetterInterface * klass)
{
  /* nothing to do here, it's a dummy interface */
}

static void
gst_tag_data_free (gpointer p)
{
  GstTagData *data = (GstTagData *) p;

  if (data->list)
    gst_tag_list_unref (data->list);

  g_mutex_clear (&data->lock);

  g_slice_free (GstTagData, data);
}

static GstTagData *
gst_tag_setter_get_data (GstTagSetter * setter)
{
  GstTagData *data;

  data = g_object_get_qdata (G_OBJECT (setter), gst_tag_key);
  if (!data) {
    /* make sure no other thread is creating a GstTagData at the same time */
    static GMutex create_mutex; /* no initialisation required */

    g_mutex_lock (&create_mutex);

    data = g_object_get_qdata (G_OBJECT (setter), gst_tag_key);
    if (!data) {
      data = g_slice_new (GstTagData);
      g_mutex_init (&data->lock);
      data->list = NULL;
      data->mode = GST_TAG_MERGE_KEEP;
      g_object_set_qdata_full (G_OBJECT (setter), gst_tag_key, data,
          gst_tag_data_free);
    }

    g_mutex_unlock (&create_mutex);
  }

  return data;
}

/**
 * gst_tag_setter_reset_tags:
 * @setter: a #GstTagSetter
 *
 * Reset the internal taglist. Elements should call this from within the
 * state-change handler.
 */
void
gst_tag_setter_reset_tags (GstTagSetter * setter)
{
  GstTagData *data;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);
  if (data->list) {
    gst_tag_list_unref (data->list);
    data->list = NULL;
  }
  GST_TAG_DATA_UNLOCK (data);
}

/**
 * gst_tag_setter_merge_tags:
 * @setter: a #GstTagSetter
 * @list: a tag list to merge from
 * @mode: the mode to merge with
 *
 * Merges the given list into the setter's list using the given mode.
 */
void
gst_tag_setter_merge_tags (GstTagSetter * setter, const GstTagList * list,
    GstTagMergeMode mode)
{
  GstTagData *data;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));
  g_return_if_fail (GST_IS_TAG_LIST (list));

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);
  if (data->list == NULL) {
    if (mode != GST_TAG_MERGE_KEEP_ALL)
      data->list = gst_tag_list_copy (list);
  } else {
    gst_tag_list_insert (data->list, list, mode);
  }
  GST_TAG_DATA_UNLOCK (data);
}

/**
 * gst_tag_setter_add_tags:
 * @setter: a #GstTagSetter
 * @mode: the mode to use
 * @tag: tag to set
 * @...: more tag / value pairs to set
 *
 * Adds the given tag / value pairs on the setter using the given merge mode.
 * The list must be terminated with %NULL.
 */
void
gst_tag_setter_add_tags (GstTagSetter * setter, GstTagMergeMode mode,
    const gchar * tag, ...)
{
  va_list args;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  va_start (args, tag);
  gst_tag_setter_add_tag_valist (setter, mode, tag, args);
  va_end (args);
}

/**
 * gst_tag_setter_add_tag_values:
 * @setter: a #GstTagSetter
 * @mode: the mode to use
 * @tag: tag to set
 * @...: more tag / GValue pairs to set
 *
 * Adds the given tag / GValue pairs on the setter using the given merge mode.
 * The list must be terminated with %NULL.
 */
void
gst_tag_setter_add_tag_values (GstTagSetter * setter, GstTagMergeMode mode,
    const gchar * tag, ...)
{
  va_list args;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  va_start (args, tag);
  gst_tag_setter_add_tag_valist_values (setter, mode, tag, args);
  va_end (args);
}

/**
 * gst_tag_setter_add_tag_valist:
 * @setter: a #GstTagSetter
 * @mode: the mode to use
 * @tag: tag to set
 * @var_args: tag / value pairs to set
 *
 * Adds the given tag / value pairs on the setter using the given merge mode.
 * The list must be terminated with %NULL.
 */
void
gst_tag_setter_add_tag_valist (GstTagSetter * setter, GstTagMergeMode mode,
    const gchar * tag, va_list var_args)
{
  GstTagData *data;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);
  if (!data->list)
    data->list = gst_tag_list_new_empty ();

  gst_tag_list_add_valist (data->list, mode, tag, var_args);

  GST_TAG_DATA_UNLOCK (data);
}

/**
 * gst_tag_setter_add_tag_valist_values:
 * @setter: a #GstTagSetter
 * @mode: the mode to use
 * @tag: tag to set
 * @var_args: tag / GValue pairs to set
 *
 * Adds the given tag / GValue pairs on the setter using the given merge mode.
 * The list must be terminated with %NULL.
 */
void
gst_tag_setter_add_tag_valist_values (GstTagSetter * setter,
    GstTagMergeMode mode, const gchar * tag, va_list var_args)
{
  GstTagData *data;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);

  if (!data->list)
    data->list = gst_tag_list_new_empty ();

  gst_tag_list_add_valist_values (data->list, mode, tag, var_args);

  GST_TAG_DATA_UNLOCK (data);
}

/**
 * gst_tag_setter_add_tag_value:
 * @setter: a #GstTagSetter
 * @mode: the mode to use
 * @tag: tag to set
 * @value: GValue to set for the tag
 *
 * Adds the given tag / GValue pair on the setter using the given merge mode.
 */
void
gst_tag_setter_add_tag_value (GstTagSetter * setter,
    GstTagMergeMode mode, const gchar * tag, const GValue * value)
{
  GstTagData *data;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);

  if (!data->list)
    data->list = gst_tag_list_new_empty ();

  gst_tag_list_add_value (data->list, mode, tag, value);

  GST_TAG_DATA_UNLOCK (data);
}

/**
 * gst_tag_setter_get_tag_list:
 * @setter: a #GstTagSetter
 *
 * Returns the current list of tags the setter uses.  The list should not be
 * modified or freed.
 *
 * This function is not thread-safe.
 *
 * Returns: (transfer none) (nullable): a current snapshot of the
 *          taglist used in the setter or %NULL if none is used.
 */
const GstTagList *
gst_tag_setter_get_tag_list (GstTagSetter * setter)
{
  g_return_val_if_fail (GST_IS_TAG_SETTER (setter), NULL);

  return gst_tag_setter_get_data (setter)->list;
}

/**
 * gst_tag_setter_set_tag_merge_mode:
 * @setter: a #GstTagSetter
 * @mode: The mode with which tags are added
 *
 * Sets the given merge mode that is used for adding tags from events to tags
 * specified by this interface. The default is #GST_TAG_MERGE_KEEP, which keeps
 * the tags set with this interface and discards tags from events.
 */
void
gst_tag_setter_set_tag_merge_mode (GstTagSetter * setter, GstTagMergeMode mode)
{
  GstTagData *data;

  g_return_if_fail (GST_IS_TAG_SETTER (setter));
  g_return_if_fail (GST_TAG_MODE_IS_VALID (mode));

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);
  data->mode = mode;
  GST_TAG_DATA_UNLOCK (data);
}

/**
 * gst_tag_setter_get_tag_merge_mode:
 * @setter: a #GstTagSetter
 *
 * Queries the mode by which tags inside the setter are overwritten by tags
 * from events
 *
 * Returns: the merge mode used inside the element.
 */
GstTagMergeMode
gst_tag_setter_get_tag_merge_mode (GstTagSetter * setter)
{
  GstTagMergeMode mode;
  GstTagData *data;

  g_return_val_if_fail (GST_IS_TAG_SETTER (setter), GST_TAG_MERGE_UNDEFINED);

  data = gst_tag_setter_get_data (setter);

  GST_TAG_DATA_LOCK (data);
  mode = data->mode;
  GST_TAG_DATA_UNLOCK (data);

  return mode;
}
