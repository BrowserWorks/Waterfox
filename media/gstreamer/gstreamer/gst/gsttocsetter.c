/* GStreamer
 * Copyright (C) 2010, 2012 Alexander Saprykin <xelfium@gmail.com>
 *
 * gsttocsetter.c: interface for TOC setting on elements
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
 * SECTION:gsttocsetter
 * @short_description: Element interface that allows setting and retrieval
 *                     of the TOC
 *
 * Element interface that allows setting of the TOC.
 *
 * Elements that support some kind of chapters or editions (or tracks like in
 * the FLAC cue sheet) will implement this interface.
 * 
 * If you just want to retrieve the TOC in your application then all you
 * need to do is watch for TOC messages on your pipeline's bus (or you can
 * perform TOC query). This interface is only for setting TOC data, not for
 * extracting it. To set TOC from the application, find proper tocsetter element
 * and set TOC using gst_toc_setter_set_toc().
 * 
 * Elements implementing the #GstTocSetter interface can extend existing TOC
 * by getting extend UID for that (you can use gst_toc_find_entry() to retrieve it)
 * with any TOC entries received from downstream.
 */


#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gst_private.h"
#include "gsttocsetter.h"
#include <gobject/gvaluecollector.h>
#include <string.h>

static GQuark gst_toc_key;

G_DEFINE_INTERFACE_WITH_CODE (GstTocSetter, gst_toc_setter, GST_TYPE_ELEMENT,
    gst_toc_key = g_quark_from_static_string ("gst-toc-setter-data"););

static void
gst_toc_setter_default_init (GstTocSetterInterface * klass)
{
  /* nothing to do here, it's a dummy interface */
}

typedef struct
{
  GstToc *toc;
  GMutex lock;
} GstTocData;

static void
gst_toc_data_free (gpointer p)
{
  GstTocData *data = (GstTocData *) p;

  if (data->toc)
    gst_toc_unref (data->toc);

  g_mutex_clear (&data->lock);

  g_slice_free (GstTocData, data);
}

static GstTocData *
gst_toc_setter_get_data (GstTocSetter * setter)
{
  GstTocData *data;

  data = g_object_get_qdata (G_OBJECT (setter), gst_toc_key);
  if (!data) {
    static GMutex create_mutex;

    /* make sure no other thread is creating a GstTocData at the same time */
    g_mutex_lock (&create_mutex);
    data = g_object_get_qdata (G_OBJECT (setter), gst_toc_key);
    if (!data) {
      data = g_slice_new (GstTocData);
      g_mutex_init (&data->lock);
      data->toc = NULL;
      g_object_set_qdata_full (G_OBJECT (setter), gst_toc_key, data,
          gst_toc_data_free);
    }
    g_mutex_unlock (&create_mutex);
  }

  return data;
}

/**
 * gst_toc_setter_reset:
 * @setter: a #GstTocSetter.
 *
 * Reset the internal TOC. Elements should call this from within the
 * state-change handler.
 */
void
gst_toc_setter_reset (GstTocSetter * setter)
{
  g_return_if_fail (GST_IS_TOC_SETTER (setter));

  gst_toc_setter_set_toc (setter, NULL);
}

/**
 * gst_toc_setter_get_toc:
 * @setter: a #GstTocSetter.
 *
 * Return current TOC the setter uses. The TOC should not be
 * modified without making it writable first.
 *
 *
 * Returns: (transfer full) (nullable): TOC set, or %NULL. Unref with
 *     gst_toc_unref() when no longer needed
 */
GstToc *
gst_toc_setter_get_toc (GstTocSetter * setter)
{
  GstTocData *data;
  GstToc *ret = NULL;

  g_return_val_if_fail (GST_IS_TOC_SETTER (setter), NULL);

  data = gst_toc_setter_get_data (setter);
  g_mutex_lock (&data->lock);

  if (data->toc != NULL)
    ret = gst_toc_ref (data->toc);

  g_mutex_unlock (&data->lock);

  return ret;
}

/**
 * gst_toc_setter_set_toc:
 * @setter: a #GstTocSetter.
 * @toc: (allow-none): a #GstToc to set.
 *
 * Set the given TOC on the setter. Previously set TOC will be
 * unreffed before setting a new one.
 */
void
gst_toc_setter_set_toc (GstTocSetter * setter, GstToc * toc)
{
  GstTocData *data;

  g_return_if_fail (GST_IS_TOC_SETTER (setter));

  data = gst_toc_setter_get_data (setter);

  g_mutex_lock (&data->lock);

  if (data->toc != toc) {
    if (data->toc)
      gst_toc_unref (data->toc);

    data->toc = (toc) ? gst_toc_ref (toc) : NULL;
  }

  g_mutex_unlock (&data->lock);
}
