/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) 2000,2005 Wim Taymans <wim@fluendo.com>
 * Copyright (C) 2006      Tim-Philipp Müller <tim centricular net>
 *
 * gsttypefindhelper.c:
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
 * SECTION:gsttypefindhelper
 * @short_description: Utility functions for typefinding 
 *
 * Utility functions for elements doing typefinding:
 * gst_type_find_helper() does typefinding in pull mode, while
 * gst_type_find_helper_for_buffer() is useful for elements needing to do
 * typefinding in push mode from a chain function.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <stdlib.h>
#include <string.h>

#include "gsttypefindhelper.h"

/* ********************** typefinding in pull mode ************************ */

static void
helper_find_suggest (gpointer data, GstTypeFindProbability probability,
    GstCaps * caps);

typedef struct
{
  GstBuffer *buffer;
  GstMapInfo map;
} GstMappedBuffer;

typedef struct
{
  GSList *buffers;              /* buffer cache */
  guint64 size;
  guint64 last_offset;
  GstTypeFindHelperGetRangeFunction func;
  GstTypeFindProbability best_probability;
  GstCaps *caps;
  GstTypeFindFactory *factory;  /* for logging */
  GstObject *obj;               /* for logging */
  GstObject *parent;
} GstTypeFindHelper;

/*
 * helper_find_peek:
 * @data: helper data struct
 * @off: stream offset
 * @size: block size
 *
 * Get data pointer within a stream. Keeps a cache of read buffers (partly
 * for performance reasons, but mostly because pointers returned by us need
 * to stay valid until typefinding has finished)
 *
 * Returns: (nullable): address of the data or %NULL if buffer does not cover
 * the requested range.
 */
static const guint8 *
helper_find_peek (gpointer data, gint64 offset, guint size)
{
  GstTypeFindHelper *helper;
  GstBuffer *buffer;
  GstFlowReturn ret;
  GSList *insert_pos = NULL;
  gsize buf_size;
  guint64 buf_offset;
  GstMappedBuffer *bmap;
#if 0
  GstCaps *caps;
#endif

  helper = (GstTypeFindHelper *) data;

  GST_LOG_OBJECT (helper->obj, "'%s' called peek (%" G_GINT64_FORMAT
      ", %u)", GST_OBJECT_NAME (helper->factory), offset, size);

  if (size == 0)
    return NULL;

  if (offset < 0) {
    if (helper->size == -1 || helper->size < -offset)
      return NULL;

    offset += helper->size;
  }

  /* see if we have a matching buffer already in our list */
  if (size > 0 && offset <= helper->last_offset) {
    GSList *walk;

    for (walk = helper->buffers; walk; walk = walk->next) {
      GstMappedBuffer *bmp = (GstMappedBuffer *) walk->data;
      GstBuffer *buf = GST_BUFFER_CAST (bmp->buffer);

      buf_offset = GST_BUFFER_OFFSET (buf);
      buf_size = bmp->map.size;

      /* buffers are kept sorted by end offset (highest first) in the list, so
       * at this point we save the current position and stop searching if 
       * we're after the searched end offset */
      if (buf_offset <= offset) {
        if ((offset + size) < (buf_offset + buf_size)) {
          /* must already have been mapped before */
          return (guint8 *) bmp->map.data + (offset - buf_offset);
        }
      } else if (offset + size >= buf_offset + buf_size) {
        insert_pos = walk;
        break;
      }
    }
  }

  buffer = NULL;
  /* some typefinders go in 1 byte steps over 1k of data and request
   * small buffers. It is really inefficient to pull each time, and pulling
   * a larger chunk is almost free. Trying to pull a larger chunk at the end
   * of the file is also not a problem here, we'll just get a truncated buffer
   * in that case (and we'll have to double-check the size we actually get
   * anyway, see below) */
  ret =
      helper->func (helper->obj, helper->parent, offset, MAX (size, 4096),
      &buffer);

  if (ret != GST_FLOW_OK)
    goto error;

#if 0
  caps = GST_BUFFER_CAPS (buffer);

  if (caps && !gst_caps_is_empty (caps) && !gst_caps_is_any (caps)) {
    GST_DEBUG ("buffer has caps %" GST_PTR_FORMAT ", suggest max probability",
        caps);

    gst_caps_replace (&helper->caps, caps);
    helper->best_probability = GST_TYPE_FIND_MAXIMUM;

    gst_buffer_unref (buffer);
    return NULL;
  }
#endif

  /* getrange might silently return shortened buffers at the end of a file,
   * we must, however, always return either the full requested data or %NULL */
  buf_offset = GST_BUFFER_OFFSET (buffer);
  buf_size = gst_buffer_get_size (buffer);

  if ((buf_offset != -1 && buf_offset != offset) || buf_size < size) {
    GST_DEBUG ("dropping short buffer: %" G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT
        " instead of %" G_GUINT64_FORMAT "-%" G_GUINT64_FORMAT,
        buf_offset, buf_offset + buf_size - 1, offset, offset + size - 1);
    gst_buffer_unref (buffer);
    return NULL;
  }

  bmap = g_slice_new0 (GstMappedBuffer);

  if (!gst_buffer_map (buffer, &bmap->map, GST_MAP_READ))
    goto map_failed;

  bmap->buffer = buffer;

  if (insert_pos) {
    helper->buffers = g_slist_insert_before (helper->buffers, insert_pos, bmap);
  } else {
    /* if insert_pos is not set, our offset is bigger than the largest offset
     * we have so far; since we keep the list sorted with highest offsets
     * first, we need to prepend the buffer to the list */
    helper->last_offset = GST_BUFFER_OFFSET (buffer) + buf_size;
    helper->buffers = g_slist_prepend (helper->buffers, bmap);
  }

  return bmap->map.data;

error:
  {
    GST_INFO ("typefind function returned: %s", gst_flow_get_name (ret));
    return NULL;
  }
map_failed:
  {
    GST_ERROR ("map failed");
    gst_buffer_unref (buffer);
    g_slice_free (GstMappedBuffer, bmap);
    return NULL;
  }
}

/*
 * helper_find_suggest:
 * @data: helper data struct
 * @probability: probability of the match
 * @caps: caps of the type
 *
 * If given @probability is higher, replace previously store caps.
 */
static void
helper_find_suggest (gpointer data, GstTypeFindProbability probability,
    GstCaps * caps)
{
  GstTypeFindHelper *helper = (GstTypeFindHelper *) data;

  GST_LOG_OBJECT (helper->obj,
      "'%s' called suggest (%u, %" GST_PTR_FORMAT ")",
      GST_OBJECT_NAME (helper->factory), probability, caps);

  if (probability > helper->best_probability) {
    gst_caps_replace (&helper->caps, caps);
    helper->best_probability = probability;
  }
}

static guint64
helper_find_get_length (gpointer data)
{
  GstTypeFindHelper *helper = (GstTypeFindHelper *) data;

  GST_LOG_OBJECT (helper->obj, "'%s' called get_length, returning %"
      G_GUINT64_FORMAT, GST_OBJECT_NAME (helper->factory), helper->size);

  return helper->size;
}

/**
 * gst_type_find_helper_get_range:
 * @obj: A #GstObject that will be passed as first argument to @func
 * @parent: (allow-none): the parent of @obj or %NULL
 * @func: (scope call): A generic #GstTypeFindHelperGetRangeFunction that will
 *        be used to access data at random offsets when doing the typefinding
 * @size: The length in bytes
 * @extension: extension of the media
 * @prob: (out) (allow-none): location to store the probability of the found
 *     caps, or %NULL
 *
 * Utility function to do pull-based typefinding. Unlike gst_type_find_helper()
 * however, this function will use the specified function @func to obtain the
 * data needed by the typefind functions, rather than operating on a given
 * source pad. This is useful mostly for elements like tag demuxers which
 * strip off data at the beginning and/or end of a file and want to typefind
 * the stripped data stream before adding their own source pad (the specified
 * callback can then call the upstream peer pad with offsets adjusted for the
 * tag size, for example).
 *
 * When @extension is not %NULL, this function will first try the typefind
 * functions for the given extension, which might speed up the typefinding
 * in many cases.
 *
 * Free-function: gst_caps_unref
 *
 * Returns: (transfer full) (nullable): the #GstCaps corresponding to the data
 *     stream.  Returns %NULL if no #GstCaps matches the data stream.
 */
GstCaps *
gst_type_find_helper_get_range (GstObject * obj, GstObject * parent,
    GstTypeFindHelperGetRangeFunction func, guint64 size,
    const gchar * extension, GstTypeFindProbability * prob)
{
  GstTypeFindHelper helper;
  GstTypeFind find;
  GSList *walk;
  GList *l, *type_list;
  GstCaps *result = NULL;
  gint pos = 0;

  g_return_val_if_fail (GST_IS_OBJECT (obj), NULL);
  g_return_val_if_fail (func != NULL, NULL);

  helper.buffers = NULL;
  helper.size = size;
  helper.last_offset = 0;
  helper.func = func;
  helper.best_probability = GST_TYPE_FIND_NONE;
  helper.caps = NULL;
  helper.obj = obj;
  helper.parent = parent;

  find.data = &helper;
  find.peek = helper_find_peek;
  find.suggest = helper_find_suggest;

  if (size == 0 || size == (guint64) - 1) {
    find.get_length = NULL;
  } else {
    find.get_length = helper_find_get_length;
  }

  type_list = gst_type_find_factory_get_list ();

  /* move the typefinders for the extension first in the list. The idea is that
   * when one of them returns MAX we don't need to search further as there is a
   * very high chance we got the right type. */
  if (extension) {
    GList *next;

    GST_LOG_OBJECT (obj, "sorting typefind for extension %s to head",
        extension);

    for (l = type_list; l; l = next) {
      const gchar *const *ext;
      GstTypeFindFactory *factory;

      next = l->next;

      factory = GST_TYPE_FIND_FACTORY (l->data);

      ext = gst_type_find_factory_get_extensions (factory);
      if (ext == NULL)
        continue;

      GST_LOG_OBJECT (obj, "testing factory %s for extension %s",
          GST_OBJECT_NAME (factory), extension);

      while (*ext != NULL) {
        if (strcmp (*ext, extension) == 0) {
          /* found extension, move in front */
          GST_LOG_OBJECT (obj, "moving typefind for extension %s to head",
              extension);
          /* remove entry from list */
          type_list = g_list_delete_link (type_list, l);
          /* insert at the position */
          type_list = g_list_insert (type_list, factory, pos);
          /* next element will be inserted after this one */
          pos++;
          break;
        }
        ++ext;
      }
    }
  }

  for (l = type_list; l; l = l->next) {
    helper.factory = GST_TYPE_FIND_FACTORY (l->data);
    gst_type_find_factory_call_function (helper.factory, &find);
    if (helper.best_probability >= GST_TYPE_FIND_MAXIMUM)
      break;
  }
  gst_plugin_feature_list_free (type_list);

  for (walk = helper.buffers; walk; walk = walk->next) {
    GstMappedBuffer *bmap = (GstMappedBuffer *) walk->data;

    gst_buffer_unmap (bmap->buffer, &bmap->map);
    gst_buffer_unref (bmap->buffer);
    g_slice_free (GstMappedBuffer, bmap);
  }
  g_slist_free (helper.buffers);

  if (helper.best_probability > 0)
    result = helper.caps;

  if (prob)
    *prob = helper.best_probability;

  GST_LOG_OBJECT (obj, "Returning %" GST_PTR_FORMAT " (probability = %u)",
      result, (guint) helper.best_probability);

  return result;
}

/**
 * gst_type_find_helper:
 * @src: A source #GstPad
 * @size: The length in bytes
 *
 * Tries to find what type of data is flowing from the given source #GstPad.
 *
 * Free-function: gst_caps_unref
 *
 * Returns: (transfer full) (nullable): the #GstCaps corresponding to the data
 *     stream.  Returns %NULL if no #GstCaps matches the data stream.
 */

GstCaps *
gst_type_find_helper (GstPad * src, guint64 size)
{
  GstTypeFindHelperGetRangeFunction func;

  g_return_val_if_fail (GST_IS_OBJECT (src), NULL);
  g_return_val_if_fail (GST_PAD_GETRANGEFUNC (src) != NULL, NULL);

  func = (GstTypeFindHelperGetRangeFunction) (GST_PAD_GETRANGEFUNC (src));

  return gst_type_find_helper_get_range (GST_OBJECT (src),
      GST_OBJECT_PARENT (src), func, size, NULL, NULL);
}

/* ********************** typefinding for buffers ************************* */

typedef struct
{
  const guint8 *data;           /* buffer data */
  gsize size;
  GstTypeFindProbability best_probability;
  GstCaps *caps;
  GstTypeFindFactory *factory;  /* for logging */
  GstObject *obj;               /* for logging */
} GstTypeFindBufHelper;

/*
 * buf_helper_find_peek:
 * @data: helper data struct
 * @off: stream offset
 * @size: block size
 *
 * Get data pointer within a buffer.
 *
 * Returns: (nullable): address inside the buffer or %NULL if buffer does not
 * cover the requested range.
 */
static const guint8 *
buf_helper_find_peek (gpointer data, gint64 off, guint size)
{
  GstTypeFindBufHelper *helper;

  helper = (GstTypeFindBufHelper *) data;
  GST_LOG_OBJECT (helper->obj, "'%s' called peek (%" G_GINT64_FORMAT ", %u)",
      GST_OBJECT_NAME (helper->factory), off, size);

  if (size == 0)
    return NULL;

  if (off < 0) {
    GST_LOG_OBJECT (helper->obj, "'%s' wanted to peek at end; not supported",
        GST_OBJECT_NAME (helper->factory));
    return NULL;
  }

  if ((off + size) <= helper->size)
    return helper->data + off;

  return NULL;
}

/*
 * buf_helper_find_suggest:
 * @data: helper data struct
 * @probability: probability of the match
 * @caps: caps of the type
 *
 * If given @probability is higher, replace previously store caps.
 */
static void
buf_helper_find_suggest (gpointer data, GstTypeFindProbability probability,
    GstCaps * caps)
{
  GstTypeFindBufHelper *helper = (GstTypeFindBufHelper *) data;

  GST_LOG_OBJECT (helper->obj,
      "'%s' called suggest (%u, %" GST_PTR_FORMAT ")",
      GST_OBJECT_NAME (helper->factory), probability, caps);

  /* Note: not >= as we call typefinders in order of rank, highest first */
  if (probability > helper->best_probability) {
    gst_caps_replace (&helper->caps, caps);
    helper->best_probability = probability;
  }
}

/**
 * gst_type_find_helper_for_data:
 * @obj: (allow-none): object doing the typefinding, or %NULL (used for logging)
 * @data: (in) (transfer none): a pointer with data to typefind
 * @size: (in) (transfer none): the size of @data
 * @prob: (out) (allow-none): location to store the probability of the found
 *     caps, or %NULL
 *
 * Tries to find what type of data is contained in the given @data, the
 * assumption being that the data represents the beginning of the stream or
 * file.
 *
 * All available typefinders will be called on the data in order of rank. If
 * a typefinding function returns a probability of %GST_TYPE_FIND_MAXIMUM,
 * typefinding is stopped immediately and the found caps will be returned
 * right away. Otherwise, all available typefind functions will the tried,
 * and the caps with the highest probability will be returned, or %NULL if
 * the content of @data could not be identified.
 *
 * Free-function: gst_caps_unref
 *
 * Returns: (transfer full) (nullable): the #GstCaps corresponding to the data,
 *     or %NULL if no type could be found. The caller should free the caps
 *     returned with gst_caps_unref().
 */
GstCaps *
gst_type_find_helper_for_data (GstObject * obj, const guint8 * data, gsize size,
    GstTypeFindProbability * prob)
{
  GstTypeFindBufHelper helper;
  GstTypeFind find;
  GList *l, *type_list;
  GstCaps *result = NULL;

  g_return_val_if_fail (data != NULL, NULL);

  helper.data = data;
  helper.size = size;
  helper.best_probability = GST_TYPE_FIND_NONE;
  helper.caps = NULL;
  helper.obj = obj;

  if (helper.data == NULL || helper.size == 0)
    return NULL;

  find.data = &helper;
  find.peek = buf_helper_find_peek;
  find.suggest = buf_helper_find_suggest;
  find.get_length = NULL;

  type_list = gst_type_find_factory_get_list ();

  for (l = type_list; l; l = l->next) {
    helper.factory = GST_TYPE_FIND_FACTORY (l->data);
    gst_type_find_factory_call_function (helper.factory, &find);
    if (helper.best_probability >= GST_TYPE_FIND_MAXIMUM)
      break;
  }
  gst_plugin_feature_list_free (type_list);

  if (helper.best_probability > 0)
    result = helper.caps;

  if (prob)
    *prob = helper.best_probability;

  GST_LOG_OBJECT (obj, "Returning %" GST_PTR_FORMAT " (probability = %u)",
      result, (guint) helper.best_probability);

  return result;
}

/**
 * gst_type_find_helper_for_buffer:
 * @obj: (allow-none): object doing the typefinding, or %NULL (used for logging)
 * @buf: (in) (transfer none): a #GstBuffer with data to typefind
 * @prob: (out) (allow-none): location to store the probability of the found
 *     caps, or %NULL
 *
 * Tries to find what type of data is contained in the given #GstBuffer, the
 * assumption being that the buffer represents the beginning of the stream or
 * file.
 *
 * All available typefinders will be called on the data in order of rank. If
 * a typefinding function returns a probability of %GST_TYPE_FIND_MAXIMUM,
 * typefinding is stopped immediately and the found caps will be returned
 * right away. Otherwise, all available typefind functions will the tried,
 * and the caps with the highest probability will be returned, or %NULL if
 * the content of the buffer could not be identified.
 *
 * Free-function: gst_caps_unref
 *
 * Returns: (transfer full) (nullable): the #GstCaps corresponding to the data,
 *     or %NULL if no type could be found. The caller should free the caps
 *     returned with gst_caps_unref().
 */
GstCaps *
gst_type_find_helper_for_buffer (GstObject * obj, GstBuffer * buf,
    GstTypeFindProbability * prob)
{
  GstCaps *result;
  GstMapInfo info;

  g_return_val_if_fail (buf != NULL, NULL);
  g_return_val_if_fail (GST_IS_BUFFER (buf), NULL);
  g_return_val_if_fail (GST_BUFFER_OFFSET (buf) == 0 ||
      GST_BUFFER_OFFSET (buf) == GST_BUFFER_OFFSET_NONE, NULL);

  if (!gst_buffer_map (buf, &info, GST_MAP_READ))
    return NULL;
  result = gst_type_find_helper_for_data (obj, info.data, info.size, prob);
  gst_buffer_unmap (buf, &info);

  return result;
}

/**
 * gst_type_find_helper_for_extension:
 * @obj: (allow-none): object doing the typefinding, or %NULL (used for logging)
 * @extension: an extension
 *
 * Tries to find the best #GstCaps associated with @extension.
 *
 * All available typefinders will be checked against the extension in order
 * of rank. The caps of the first typefinder that can handle @extension will be
 * returned.
 *
 * Free-function: gst_caps_unref
 *
 * Returns: (transfer full) (nullable): the #GstCaps corresponding to
 *     @extension, or %NULL if no type could be found. The caller should free
 *     the caps returned with gst_caps_unref().
 */
GstCaps *
gst_type_find_helper_for_extension (GstObject * obj, const gchar * extension)
{
  GList *l, *type_list;
  GstCaps *result = NULL;

  g_return_val_if_fail (extension != NULL, NULL);

  GST_LOG_OBJECT (obj, "finding caps for extension %s", extension);

  type_list = gst_type_find_factory_get_list ();

  for (l = type_list; l; l = g_list_next (l)) {
    GstTypeFindFactory *factory;
    const gchar *const *ext;

    factory = GST_TYPE_FIND_FACTORY (l->data);

    /* we only want to check those factories without a function */
    if (gst_type_find_factory_has_function (factory))
      continue;

    /* get the extension that this typefind factory can handle */
    ext = gst_type_find_factory_get_extensions (factory);
    if (ext == NULL)
      continue;

    /* there are extension, see if one of them matches the requested
     * extension */
    while (*ext != NULL) {
      if (strcmp (*ext, extension) == 0) {
        /* we found a matching extension, take the caps */
        if ((result = gst_type_find_factory_get_caps (factory))) {
          gst_caps_ref (result);
          goto done;
        }
      }
      ++ext;
    }
  }
done:
  gst_plugin_feature_list_free (type_list);

  GST_LOG_OBJECT (obj, "Returning %" GST_PTR_FORMAT, result);

  return result;
}
