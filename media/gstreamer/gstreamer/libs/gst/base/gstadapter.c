/* GStreamer
 * Copyright (C) 2004 Benjamin Otte <otte@gnome.org>
 *               2005 Wim Taymans <wim@fluendo.com>
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
 * SECTION:gstadapter
 * @short_description: adapts incoming data on a sink pad into chunks of N bytes
 *
 * This class is for elements that receive buffers in an undesired size.
 * While for example raw video contains one image per buffer, the same is not
 * true for a lot of other formats, especially those that come directly from
 * a file. So if you have undefined buffer sizes and require a specific size,
 * this object is for you.
 *
 * An adapter is created with gst_adapter_new(). It can be freed again with
 * g_object_unref().
 *
 * The theory of operation is like this: All buffers received are put
 * into the adapter using gst_adapter_push() and the data is then read back
 * in chunks of the desired size using gst_adapter_map()/gst_adapter_unmap()
 * and/or gst_adapter_copy(). After the data has been processed, it is freed
 * using gst_adapter_unmap().
 *
 * Other methods such as gst_adapter_take() and gst_adapter_take_buffer()
 * combine gst_adapter_map() and gst_adapter_unmap() in one method and are
 * potentially more convenient for some use cases.
 *
 * For example, a sink pad's chain function that needs to pass data to a library
 * in 512-byte chunks could be implemented like this:
 * |[
 * static GstFlowReturn
 * sink_pad_chain (GstPad *pad, GstObject *parent, GstBuffer *buffer)
 * {
 *   MyElement *this;
 *   GstAdapter *adapter;
 *   GstFlowReturn ret = GST_FLOW_OK;
 *
 *   this = MY_ELEMENT (parent);
 *
 *   adapter = this->adapter;
 *
 *   // put buffer into adapter
 *   gst_adapter_push (adapter, buffer);
 *
 *   // while we can read out 512 bytes, process them
 *   while (gst_adapter_available (adapter) >= 512 && ret == GST_FLOW_OK) {
 *     const guint8 *data = gst_adapter_map (adapter, 512);
 *     // use flowreturn as an error value
 *     ret = my_library_foo (data);
 *     gst_adapter_unmap (adapter);
 *     gst_adapter_flush (adapter, 512);
 *   }
 *   return ret;
 * }
 * ]|
 *
 * For another example, a simple element inside GStreamer that uses #GstAdapter
 * is the libvisual element.
 *
 * An element using #GstAdapter in its sink pad chain function should ensure that
 * when the FLUSH_STOP event is received, that any queued data is cleared using
 * gst_adapter_clear(). Data should also be cleared or processed on EOS and
 * when changing state from %GST_STATE_PAUSED to %GST_STATE_READY.
 *
 * Also check the GST_BUFFER_FLAG_DISCONT flag on the buffer. Some elements might
 * need to clear the adapter after a discontinuity.
 *
 * The adapter will keep track of the timestamps of the buffers
 * that were pushed. The last seen timestamp before the current position
 * can be queried with gst_adapter_prev_pts(). This function can
 * optionally return the number of bytes between the start of the buffer that
 * carried the timestamp and the current adapter position. The distance is
 * useful when dealing with, for example, raw audio samples because it allows
 * you to calculate the timestamp of the current adapter position by using the
 * last seen timestamp and the amount of bytes since.  Additionally, the
 * gst_adapter_prev_pts_at_offset() can be used to determine the last
 * seen timestamp at a particular offset in the adapter.
 *
 * A last thing to note is that while #GstAdapter is pretty optimized,
 * merging buffers still might be an operation that requires a malloc() and
 * memcpy() operation, and these operations are not the fastest. Because of
 * this, some functions like gst_adapter_available_fast() are provided to help
 * speed up such cases should you want to. To avoid repeated memory allocations,
 * gst_adapter_copy() can be used to copy data into a (statically allocated)
 * user provided buffer.
 *
 * #GstAdapter is not MT safe. All operations on an adapter must be serialized by
 * the caller. This is not normally a problem, however, as the normal use case
 * of #GstAdapter is inside one pad's chain function, in which case access is
 * serialized via the pad's STREAM_LOCK.
 *
 * Note that gst_adapter_push() takes ownership of the buffer passed. Use
 * gst_buffer_ref() before pushing it into the adapter if you still want to
 * access the buffer later. The adapter will never modify the data in the
 * buffer pushed in it.
 */

#include <gst/gst_private.h>
#include "gstadapter.h"
#include <string.h>

/* default size for the assembled data buffer */
#define DEFAULT_SIZE 4096

static void gst_adapter_flush_unchecked (GstAdapter * adapter, gsize flush);

GST_DEBUG_CATEGORY_STATIC (gst_adapter_debug);
#define GST_CAT_DEFAULT gst_adapter_debug

struct _GstAdapter
{
  GObject object;

  /*< private > */
  GSList *buflist;
  GSList *buflist_end;
  gsize size;
  gsize skip;

  /* we keep state of assembled pieces */
  gpointer assembled_data;
  gsize assembled_size;
  gsize assembled_len;

  GstClockTime pts;
  guint64 pts_distance;
  GstClockTime dts;
  guint64 dts_distance;

  gsize scan_offset;
  GSList *scan_entry;

  GstMapInfo info;
};

struct _GstAdapterClass
{
  GObjectClass parent_class;
};

#define _do_init \
  GST_DEBUG_CATEGORY_INIT (gst_adapter_debug, "adapter", 0, "object to splice and merge buffers to desired size")
#define gst_adapter_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstAdapter, gst_adapter, G_TYPE_OBJECT, _do_init);

static void gst_adapter_dispose (GObject * object);
static void gst_adapter_finalize (GObject * object);

static void
gst_adapter_class_init (GstAdapterClass * klass)
{
  GObjectClass *object = G_OBJECT_CLASS (klass);

  object->dispose = gst_adapter_dispose;
  object->finalize = gst_adapter_finalize;
}

static void
gst_adapter_init (GstAdapter * adapter)
{
  adapter->assembled_data = g_malloc (DEFAULT_SIZE);
  adapter->assembled_size = DEFAULT_SIZE;
  adapter->pts = GST_CLOCK_TIME_NONE;
  adapter->pts_distance = 0;
  adapter->dts = GST_CLOCK_TIME_NONE;
  adapter->dts_distance = 0;
}

static void
gst_adapter_dispose (GObject * object)
{
  GstAdapter *adapter = GST_ADAPTER (object);

  gst_adapter_clear (adapter);

  GST_CALL_PARENT (G_OBJECT_CLASS, dispose, (object));
}

static void
gst_adapter_finalize (GObject * object)
{
  GstAdapter *adapter = GST_ADAPTER (object);

  g_free (adapter->assembled_data);

  GST_CALL_PARENT (G_OBJECT_CLASS, finalize, (object));
}

/**
 * gst_adapter_new:
 *
 * Creates a new #GstAdapter. Free with g_object_unref().
 *
 * Returns: (transfer full): a new #GstAdapter
 */
GstAdapter *
gst_adapter_new (void)
{
  return g_object_newv (GST_TYPE_ADAPTER, 0, NULL);
}

/**
 * gst_adapter_clear:
 * @adapter: a #GstAdapter
 *
 * Removes all buffers from @adapter.
 */
void
gst_adapter_clear (GstAdapter * adapter)
{
  g_return_if_fail (GST_IS_ADAPTER (adapter));

  if (adapter->info.memory)
    gst_adapter_unmap (adapter);

  g_slist_foreach (adapter->buflist, (GFunc) gst_mini_object_unref, NULL);
  g_slist_free (adapter->buflist);
  adapter->buflist = NULL;
  adapter->buflist_end = NULL;
  adapter->size = 0;
  adapter->skip = 0;
  adapter->assembled_len = 0;
  adapter->pts = GST_CLOCK_TIME_NONE;
  adapter->pts_distance = 0;
  adapter->dts = GST_CLOCK_TIME_NONE;
  adapter->dts_distance = 0;
  adapter->scan_offset = 0;
  adapter->scan_entry = NULL;
}

static inline void
update_timestamps (GstAdapter * adapter, GstBuffer * buf)
{
  GstClockTime pts, dts;

  pts = GST_BUFFER_PTS (buf);
  if (GST_CLOCK_TIME_IS_VALID (pts)) {
    GST_LOG_OBJECT (adapter, "new pts %" GST_TIME_FORMAT, GST_TIME_ARGS (pts));
    adapter->pts = pts;
    adapter->pts_distance = 0;
  }
  dts = GST_BUFFER_DTS (buf);
  if (GST_CLOCK_TIME_IS_VALID (dts)) {
    GST_LOG_OBJECT (adapter, "new dts %" GST_TIME_FORMAT, GST_TIME_ARGS (dts));
    adapter->dts = dts;
    adapter->dts_distance = 0;
  }
}

/* copy data into @dest, skipping @skip bytes from the head buffers */
static void
copy_into_unchecked (GstAdapter * adapter, guint8 * dest, gsize skip,
    gsize size)
{
  GSList *g;
  GstBuffer *buf;
  gsize bsize, csize;

  /* first step, do skipping */
  /* we might well be copying where we were scanning */
  if (adapter->scan_entry && (adapter->scan_offset <= skip)) {
    g = adapter->scan_entry;
    skip -= adapter->scan_offset;
  } else {
    g = adapter->buflist;
  }
  buf = g->data;
  bsize = gst_buffer_get_size (buf);
  while (G_UNLIKELY (skip >= bsize)) {
    skip -= bsize;
    g = g_slist_next (g);
    buf = g->data;
    bsize = gst_buffer_get_size (buf);
  }
  /* copy partial buffer */
  csize = MIN (bsize - skip, size);
  GST_DEBUG ("bsize %" G_GSIZE_FORMAT ", skip %" G_GSIZE_FORMAT ", csize %"
      G_GSIZE_FORMAT, bsize, skip, csize);
  GST_CAT_LOG_OBJECT (GST_CAT_PERFORMANCE, adapter, "extract %" G_GSIZE_FORMAT
      " bytes", csize);
  gst_buffer_extract (buf, skip, dest, csize);
  size -= csize;
  dest += csize;

  /* second step, copy remainder */
  while (size > 0) {
    g = g_slist_next (g);
    buf = g->data;
    bsize = gst_buffer_get_size (buf);
    if (G_LIKELY (bsize > 0)) {
      csize = MIN (bsize, size);
      GST_CAT_LOG_OBJECT (GST_CAT_PERFORMANCE, adapter,
          "extract %" G_GSIZE_FORMAT " bytes", csize);
      gst_buffer_extract (buf, 0, dest, csize);
      size -= csize;
      dest += csize;
    }
  }
}

/**
 * gst_adapter_push:
 * @adapter: a #GstAdapter
 * @buf: (transfer full): a #GstBuffer to add to queue in the adapter
 *
 * Adds the data from @buf to the data stored inside @adapter and takes
 * ownership of the buffer.
 */
void
gst_adapter_push (GstAdapter * adapter, GstBuffer * buf)
{
  gsize size;

  g_return_if_fail (GST_IS_ADAPTER (adapter));
  g_return_if_fail (GST_IS_BUFFER (buf));

  size = gst_buffer_get_size (buf);
  adapter->size += size;

  /* Note: merging buffers at this point is premature. */
  if (G_UNLIKELY (adapter->buflist == NULL)) {
    GST_LOG_OBJECT (adapter, "pushing %p first %" G_GSIZE_FORMAT " bytes",
        buf, size);
    adapter->buflist = adapter->buflist_end = g_slist_append (NULL, buf);
    update_timestamps (adapter, buf);
  } else {
    /* Otherwise append to the end, and advance our end pointer */
    GST_LOG_OBJECT (adapter, "pushing %p %" G_GSIZE_FORMAT " bytes at end, "
        "size now %" G_GSIZE_FORMAT, buf, size, adapter->size);
    adapter->buflist_end = g_slist_append (adapter->buflist_end, buf);
    adapter->buflist_end = g_slist_next (adapter->buflist_end);
  }
}

#if 0
/* Internal method only. Tries to merge buffers at the head of the queue
 * to form a single larger buffer of size 'size'.
 *
 * Returns %TRUE if it managed to merge anything.
 */
static gboolean
gst_adapter_try_to_merge_up (GstAdapter * adapter, gsize size)
{
  GstBuffer *cur, *head;
  GSList *g;
  gboolean ret = FALSE;
  gsize hsize;

  g = adapter->buflist;
  if (g == NULL)
    return FALSE;

  head = g->data;

  hsize = gst_buffer_get_size (head);

  /* Remove skipped part from the buffer (otherwise the buffer might grow indefinitely) */
  head = gst_buffer_make_writable (head);
  gst_buffer_resize (head, adapter->skip, hsize - adapter->skip);
  hsize -= adapter->skip;
  adapter->skip = 0;
  g->data = head;

  g = g_slist_next (g);

  while (g != NULL && hsize < size) {
    cur = g->data;
    /* Merge the head buffer and the next in line */
    GST_LOG_OBJECT (adapter, "Merging buffers of size %" G_GSIZE_FORMAT " & %"
        G_GSIZE_FORMAT " in search of target %" G_GSIZE_FORMAT,
        hsize, gst_buffer_get_size (cur), size);

    head = gst_buffer_append (head, cur);
    hsize = gst_buffer_get_size (head);
    ret = TRUE;

    /* Delete the front list item, and store our new buffer in the 2nd list
     * item */
    adapter->buflist = g_slist_delete_link (adapter->buflist, adapter->buflist);
    g->data = head;

    /* invalidate scan position */
    adapter->scan_offset = 0;
    adapter->scan_entry = NULL;

    g = g_slist_next (g);
  }

  return ret;
}
#endif

/**
 * gst_adapter_map:
 * @adapter: a #GstAdapter
 * @size: the number of bytes to map/peek
 *
 * Gets the first @size bytes stored in the @adapter. The returned pointer is
 * valid until the next function is called on the adapter.
 *
 * Note that setting the returned pointer as the data of a #GstBuffer is
 * incorrect for general-purpose plugins. The reason is that if a downstream
 * element stores the buffer so that it has access to it outside of the bounds
 * of its chain function, the buffer will have an invalid data pointer after
 * your element flushes the bytes. In that case you should use
 * gst_adapter_take(), which returns a freshly-allocated buffer that you can set
 * as #GstBuffer memory or the potentially more performant
 * gst_adapter_take_buffer().
 *
 * Returns %NULL if @size bytes are not available.
 *
 * Returns: (transfer none) (array length=size) (element-type guint8) (nullable):
 *     a pointer to the first @size bytes of data, or %NULL
 */
gconstpointer
gst_adapter_map (GstAdapter * adapter, gsize size)
{
  GstBuffer *cur;
  gsize skip, csize;
  gsize toreuse, tocopy;
  guint8 *data;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), NULL);
  g_return_val_if_fail (size > 0, NULL);

  if (adapter->info.memory)
    gst_adapter_unmap (adapter);

  /* we don't have enough data, return NULL. This is unlikely
   * as one usually does an _available() first instead of peeking a
   * random size. */
  if (G_UNLIKELY (size > adapter->size))
    return NULL;

  /* we have enough assembled data, return it */
  if (adapter->assembled_len >= size)
    return adapter->assembled_data;

#if 0
  do {
#endif
    cur = adapter->buflist->data;
    skip = adapter->skip;

    csize = gst_buffer_get_size (cur);
    if (csize >= size + skip) {
      if (!gst_buffer_map (cur, &adapter->info, GST_MAP_READ))
        return FALSE;

      return (guint8 *) adapter->info.data + skip;
    }
    /* We may be able to efficiently merge buffers in our pool to
     * gather a big enough chunk to return it from the head buffer directly */
#if 0
  } while (gst_adapter_try_to_merge_up (adapter, size));
#endif

  /* see how much data we can reuse from the assembled memory and how much
   * we need to copy */
  toreuse = adapter->assembled_len;
  tocopy = size - toreuse;

  /* Gonna need to copy stuff out */
  if (G_UNLIKELY (adapter->assembled_size < size)) {
    adapter->assembled_size = (size / DEFAULT_SIZE + 1) * DEFAULT_SIZE;
    GST_DEBUG_OBJECT (adapter, "resizing internal buffer to %" G_GSIZE_FORMAT,
        adapter->assembled_size);
    if (toreuse == 0) {
      GST_CAT_DEBUG (GST_CAT_PERFORMANCE, "alloc new buffer");
      /* no g_realloc to avoid a memcpy that is not desired here since we are
       * not going to reuse any data here */
      g_free (adapter->assembled_data);
      adapter->assembled_data = g_malloc (adapter->assembled_size);
    } else {
      /* we are going to reuse all data, realloc then */
      GST_CAT_DEBUG (GST_CAT_PERFORMANCE, "reusing %" G_GSIZE_FORMAT " bytes",
          toreuse);
      adapter->assembled_data =
          g_realloc (adapter->assembled_data, adapter->assembled_size);
    }
  }
  GST_CAT_DEBUG (GST_CAT_PERFORMANCE, "copy remaining %" G_GSIZE_FORMAT
      " bytes from adapter", tocopy);
  data = adapter->assembled_data;
  copy_into_unchecked (adapter, data + toreuse, skip + toreuse, tocopy);
  adapter->assembled_len = size;

  return adapter->assembled_data;
}

/**
 * gst_adapter_unmap:
 * @adapter: a #GstAdapter
 *
 * Releases the memory obtained with the last gst_adapter_map().
 */
void
gst_adapter_unmap (GstAdapter * adapter)
{
  g_return_if_fail (GST_IS_ADAPTER (adapter));

  if (adapter->info.memory) {
    GstBuffer *cur = adapter->buflist->data;
    GST_LOG_OBJECT (adapter, "unmap memory buffer %p", cur);
    gst_buffer_unmap (cur, &adapter->info);
    adapter->info.memory = NULL;
  }
}

/**
 * gst_adapter_copy: (skip)
 * @adapter: a #GstAdapter
 * @dest: (out caller-allocates) (array length=size) (element-type guint8):
 *     the memory to copy into
 * @offset: the bytes offset in the adapter to start from
 * @size: the number of bytes to copy
 *
 * Copies @size bytes of data starting at @offset out of the buffers
 * contained in #GstAdapter into an array @dest provided by the caller.
 *
 * The array @dest should be large enough to contain @size bytes.
 * The user should check that the adapter has (@offset + @size) bytes
 * available before calling this function.
 */
void
gst_adapter_copy (GstAdapter * adapter, gpointer dest, gsize offset, gsize size)
{
  g_return_if_fail (GST_IS_ADAPTER (adapter));
  g_return_if_fail (size > 0);
  g_return_if_fail (offset + size <= adapter->size);

  copy_into_unchecked (adapter, dest, offset + adapter->skip, size);
}

/**
 * gst_adapter_copy_bytes:
 * @adapter: a #GstAdapter
 * @offset: the bytes offset in the adapter to start from
 * @size: the number of bytes to copy
 *
 * Similar to gst_adapter_copy, but more suitable for language bindings. @size
 * bytes of data starting at @offset will be copied out of the buffers contained
 * in @adapter and into a new #GBytes structure which is returned. Depending on
 * the value of the @size argument an empty #GBytes structure may be returned.
 *
 * Returns: (transfer full): A new #GBytes structure containing the copied data.
 *
 * Rename to: gst_adapter_copy
 *
 * Since: 1.4
 */
GBytes *
gst_adapter_copy_bytes (GstAdapter * adapter, gsize offset, gsize size)
{
  gpointer data;
  data = g_malloc (size);
  gst_adapter_copy (adapter, data, offset, size);
  return g_bytes_new_take (data, size);
}

/*Flushes the first @flush bytes in the @adapter*/
static void
gst_adapter_flush_unchecked (GstAdapter * adapter, gsize flush)
{
  GstBuffer *cur;
  gsize size;
  GSList *g;

  GST_LOG_OBJECT (adapter, "flushing %" G_GSIZE_FORMAT " bytes", flush);

  if (adapter->info.memory)
    gst_adapter_unmap (adapter);

  /* clear state */
  adapter->size -= flush;
  adapter->assembled_len = 0;

  /* take skip into account */
  flush += adapter->skip;
  /* distance is always at least the amount of skipped bytes */
  adapter->pts_distance -= adapter->skip;
  adapter->dts_distance -= adapter->skip;

  g = adapter->buflist;
  cur = g->data;
  size = gst_buffer_get_size (cur);
  while (flush >= size) {
    /* can skip whole buffer */
    GST_LOG_OBJECT (adapter, "flushing out head buffer");
    adapter->pts_distance += size;
    adapter->dts_distance += size;
    flush -= size;

    gst_buffer_unref (cur);
    g = g_slist_delete_link (g, g);

    if (G_UNLIKELY (g == NULL)) {
      GST_LOG_OBJECT (adapter, "adapter empty now");
      adapter->buflist_end = NULL;
      break;
    }
    /* there is a new head buffer, update the timestamps */
    cur = g->data;
    update_timestamps (adapter, cur);
    size = gst_buffer_get_size (cur);
  }
  adapter->buflist = g;
  /* account for the remaining bytes */
  adapter->skip = flush;
  adapter->pts_distance += flush;
  adapter->dts_distance += flush;
  /* invalidate scan position */
  adapter->scan_offset = 0;
  adapter->scan_entry = NULL;
}

/**
 * gst_adapter_flush:
 * @adapter: a #GstAdapter
 * @flush: the number of bytes to flush
 *
 * Flushes the first @flush bytes in the @adapter. The caller must ensure that
 * at least this many bytes are available.
 *
 * See also: gst_adapter_map(), gst_adapter_unmap()
 */
void
gst_adapter_flush (GstAdapter * adapter, gsize flush)
{
  g_return_if_fail (GST_IS_ADAPTER (adapter));
  g_return_if_fail (flush <= adapter->size);

  /* flushing out 0 bytes will do nothing */
  if (G_UNLIKELY (flush == 0))
    return;

  gst_adapter_flush_unchecked (adapter, flush);
}

/* internal function, nbytes should be flushed after calling this function */
static guint8 *
gst_adapter_take_internal (GstAdapter * adapter, gsize nbytes)
{
  guint8 *data;
  gsize toreuse, tocopy;

  /* see how much data we can reuse from the assembled memory and how much
   * we need to copy */
  toreuse = MIN (nbytes, adapter->assembled_len);
  tocopy = nbytes - toreuse;

  /* find memory to return */
  if (adapter->assembled_size >= nbytes && toreuse > 0) {
    /* we reuse already allocated memory but only when we're going to reuse
     * something from it because else we are worse than the malloc and copy
     * case below */
    GST_LOG_OBJECT (adapter, "reusing %" G_GSIZE_FORMAT " bytes of assembled"
        " data", toreuse);
    /* we have enough free space in the assembled array */
    data = adapter->assembled_data;
    /* flush after this function should set the assembled_size to 0 */
    adapter->assembled_data = g_malloc (adapter->assembled_size);
  } else {
    GST_LOG_OBJECT (adapter, "allocating %" G_GSIZE_FORMAT " bytes", nbytes);
    /* not enough bytes in the assembled array, just allocate new space */
    data = g_malloc (nbytes);
    /* reuse what we can from the already assembled data */
    if (toreuse) {
      GST_LOG_OBJECT (adapter, "reusing %" G_GSIZE_FORMAT " bytes", toreuse);
      GST_CAT_LOG_OBJECT (GST_CAT_PERFORMANCE, adapter,
          "memcpy %" G_GSIZE_FORMAT " bytes", toreuse);
      memcpy (data, adapter->assembled_data, toreuse);
    }
  }
  if (tocopy) {
    /* copy the remaining data */
    copy_into_unchecked (adapter, toreuse + data, toreuse + adapter->skip,
        tocopy);
  }
  return data;
}

/**
 * gst_adapter_take:
 * @adapter: a #GstAdapter
 * @nbytes: the number of bytes to take
 *
 * Returns a freshly allocated buffer containing the first @nbytes bytes of the
 * @adapter. The returned bytes will be flushed from the adapter.
 *
 * Caller owns returned value. g_free after usage.
 *
 * Free-function: g_free
 *
 * Returns: (transfer full) (array length=nbytes) (element-type guint8) (nullable):
 *     oven-fresh hot data, or %NULL if @nbytes bytes are not available
 */
gpointer
gst_adapter_take (GstAdapter * adapter, gsize nbytes)
{
  gpointer data;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), NULL);
  g_return_val_if_fail (nbytes > 0, NULL);

  /* we don't have enough data, return NULL. This is unlikely
   * as one usually does an _available() first instead of peeking a
   * random size. */
  if (G_UNLIKELY (nbytes > adapter->size))
    return NULL;

  data = gst_adapter_take_internal (adapter, nbytes);

  gst_adapter_flush_unchecked (adapter, nbytes);

  return data;
}

/**
 * gst_adapter_take_buffer_fast:
 * @adapter:  a #GstAdapter
 * @nbytes: the number of bytes to take
 *
 * Returns a #GstBuffer containing the first @nbytes of the @adapter.
 * The returned bytes will be flushed from the adapter.  This function
 * is potentially more performant than gst_adapter_take_buffer() since
 * it can reuse the memory in pushed buffers by subbuffering or
 * merging. Unlike gst_adapter_take_buffer(), the returned buffer may
 * be composed of multiple non-contiguous #GstMemory objects, no
 * copies are made.
 *
 * Note that no assumptions should be made as to whether certain buffer
 * flags such as the DISCONT flag are set on the returned buffer, or not.
 * The caller needs to explicitly set or unset flags that should be set or
 * unset.
 *
 * This function can return buffer up to the return value of
 * gst_adapter_available() without making copies if possible.
 *
 * Caller owns a reference to the returned buffer. gst_buffer_unref() after
 * usage.
 *
 * Free-function: gst_buffer_unref
 *
 * Returns: (transfer full) (nullable): a #GstBuffer containing the first
 *     @nbytes of the adapter, or %NULL if @nbytes bytes are not available.
 *     gst_buffer_unref() when no longer needed.
 *
 * Since: 1.2
 */

GstBuffer *
gst_adapter_take_buffer_fast (GstAdapter * adapter, gsize nbytes)
{
  GstBuffer *buffer = NULL;
  GstBuffer *cur;
  GSList *item;
  gsize skip;
  gsize left = nbytes;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), NULL);
  g_return_val_if_fail (nbytes > 0, NULL);

  GST_LOG_OBJECT (adapter, "taking buffer of %" G_GSIZE_FORMAT " bytes",
      nbytes);

  /* we don't have enough data, return NULL. This is unlikely
   * as one usually does an _available() first instead of grabbing a
   * random size. */
  if (G_UNLIKELY (nbytes > adapter->size))
    return NULL;

  skip = adapter->skip;
  cur = adapter->buflist->data;

  if (skip == 0 && gst_buffer_get_size (cur) == nbytes) {
    GST_LOG_OBJECT (adapter, "providing buffer of %" G_GSIZE_FORMAT " bytes"
        " as head buffer", nbytes);
    buffer = gst_buffer_ref (cur);
    goto done;
  }

  for (item = adapter->buflist; item && left > 0; item = item->next) {
    gsize size;

    cur = item->data;
    size = MIN (gst_buffer_get_size (cur) - skip, left);

    GST_LOG_OBJECT (adapter, "appending %" G_GSIZE_FORMAT " bytes"
        " via region copy", size);
    if (buffer)
      gst_buffer_copy_into (buffer, cur, GST_BUFFER_COPY_MEMORY, skip, size);
    else
      buffer = gst_buffer_copy_region (cur, GST_BUFFER_COPY_ALL, skip, size);
    skip = 0;
    left -= size;
  }

done:
  gst_adapter_flush_unchecked (adapter, nbytes);

  return buffer;
}

/**
 * gst_adapter_take_buffer:
 * @adapter: a #GstAdapter
 * @nbytes: the number of bytes to take
 *
 * Returns a #GstBuffer containing the first @nbytes bytes of the
 * @adapter. The returned bytes will be flushed from the adapter.
 * This function is potentially more performant than
 * gst_adapter_take() since it can reuse the memory in pushed buffers
 * by subbuffering or merging. This function will always return a
 * buffer with a single memory region.
 *
 * Note that no assumptions should be made as to whether certain buffer
 * flags such as the DISCONT flag are set on the returned buffer, or not.
 * The caller needs to explicitly set or unset flags that should be set or
 * unset.
 *
 * Caller owns a reference to the returned buffer. gst_buffer_unref() after
 * usage.
 *
 * Free-function: gst_buffer_unref
 *
 * Returns: (transfer full) (nullable): a #GstBuffer containing the first
 *     @nbytes of the adapter, or %NULL if @nbytes bytes are not available.
 *     gst_buffer_unref() when no longer needed.
 */
GstBuffer *
gst_adapter_take_buffer (GstAdapter * adapter, gsize nbytes)
{
  GstBuffer *buffer;
  GstBuffer *cur;
  gsize hsize, skip;
  guint8 *data;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), NULL);
  g_return_val_if_fail (nbytes > 0, NULL);

  GST_LOG_OBJECT (adapter, "taking buffer of %" G_GSIZE_FORMAT " bytes",
      nbytes);

  /* we don't have enough data, return NULL. This is unlikely
   * as one usually does an _available() first instead of grabbing a
   * random size. */
  if (G_UNLIKELY (nbytes > adapter->size))
    return NULL;

  cur = adapter->buflist->data;
  skip = adapter->skip;
  hsize = gst_buffer_get_size (cur);

  /* our head buffer has enough data left, return it */
  if (skip == 0 && hsize == nbytes) {
    GST_LOG_OBJECT (adapter, "providing buffer of %" G_GSIZE_FORMAT " bytes"
        " as head buffer", nbytes);
    buffer = gst_buffer_ref (cur);
    goto done;
  } else if (hsize >= nbytes + skip) {
    GST_LOG_OBJECT (adapter, "providing buffer of %" G_GSIZE_FORMAT " bytes"
        " via region copy", nbytes);
    buffer = gst_buffer_copy_region (cur, GST_BUFFER_COPY_ALL, skip, nbytes);
    goto done;
  }
#if 0
  if (gst_adapter_try_to_merge_up (adapter, nbytes)) {
    /* Merged something, let's try again for sub-buffering */
    cur = adapter->buflist->data;
    skip = adapter->skip;
    if (gst_buffer_get_size (cur) >= nbytes + skip) {
      GST_LOG_OBJECT (adapter, "providing buffer of %" G_GSIZE_FORMAT " bytes"
          " via sub-buffer", nbytes);
      buffer = gst_buffer_copy_region (cur, GST_BUFFER_COPY_ALL, skip, nbytes);
      goto done;
    }
  }
#endif

  data = gst_adapter_take_internal (adapter, nbytes);

  buffer = gst_buffer_new_wrapped (data, nbytes);

done:
  gst_adapter_flush_unchecked (adapter, nbytes);

  return buffer;
}

/**
 * gst_adapter_take_list:
 * @adapter: a #GstAdapter
 * @nbytes: the number of bytes to take
 *
 * Returns a #GList of buffers containing the first @nbytes bytes of the
 * @adapter. The returned bytes will be flushed from the adapter.
 * When the caller can deal with individual buffers, this function is more
 * performant because no memory should be copied.
 *
 * Caller owns returned list and contained buffers. gst_buffer_unref() each
 * buffer in the list before freeing the list after usage.
 *
 * Returns: (element-type Gst.Buffer) (transfer full) (nullable): a #GList of
 *     buffers containing the first @nbytes of the adapter, or %NULL if @nbytes
 *     bytes are not available
 */
GList *
gst_adapter_take_list (GstAdapter * adapter, gsize nbytes)
{
  GQueue queue = G_QUEUE_INIT;
  GstBuffer *cur;
  gsize hsize, skip;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), NULL);
  g_return_val_if_fail (nbytes <= adapter->size, NULL);

  GST_LOG_OBJECT (adapter, "taking %" G_GSIZE_FORMAT " bytes", nbytes);

  while (nbytes > 0) {
    cur = adapter->buflist->data;
    skip = adapter->skip;
    hsize = MIN (nbytes, gst_buffer_get_size (cur) - skip);

    cur = gst_adapter_take_buffer (adapter, hsize);

    g_queue_push_tail (&queue, cur);

    nbytes -= hsize;
  }
  return queue.head;
}

/**
 * gst_adapter_available:
 * @adapter: a #GstAdapter
 *
 * Gets the maximum amount of bytes available, that is it returns the maximum
 * value that can be supplied to gst_adapter_map() without that function
 * returning %NULL.
 *
 * Returns: number of bytes available in @adapter
 */
gsize
gst_adapter_available (GstAdapter * adapter)
{
  g_return_val_if_fail (GST_IS_ADAPTER (adapter), 0);

  return adapter->size;
}

/**
 * gst_adapter_available_fast:
 * @adapter: a #GstAdapter
 *
 * Gets the maximum number of bytes that are immediately available without
 * requiring any expensive operations (like copying the data into a
 * temporary buffer).
 *
 * Returns: number of bytes that are available in @adapter without expensive
 * operations
 */
gsize
gst_adapter_available_fast (GstAdapter * adapter)
{
  GstBuffer *cur;
  gsize size;
  GSList *g;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), 0);

  /* no data */
  if (adapter->size == 0)
    return 0;

  /* some stuff we already assembled */
  if (adapter->assembled_len)
    return adapter->assembled_len;

  /* take the first non-zero buffer */
  g = adapter->buflist;
  while (TRUE) {
    cur = g->data;
    size = gst_buffer_get_size (cur);
    if (size != 0)
      break;
    g = g_slist_next (g);
  }

  /* we can quickly get the (remaining) data of the first buffer */
  return size - adapter->skip;
}

/**
 * gst_adapter_prev_pts:
 * @adapter: a #GstAdapter
 * @distance: (out) (allow-none): pointer to location for distance, or %NULL
 *
 * Get the pts that was before the current byte in the adapter. When
 * @distance is given, the amount of bytes between the pts and the current
 * position is returned.
 *
 * The pts is reset to GST_CLOCK_TIME_NONE and the distance is set to 0 when
 * the adapter is first created or when it is cleared. This also means that before
 * the first byte with a pts is removed from the adapter, the pts
 * and distance returned are GST_CLOCK_TIME_NONE and 0 respectively.
 *
 * Returns: The previously seen pts.
 */
GstClockTime
gst_adapter_prev_pts (GstAdapter * adapter, guint64 * distance)
{
  g_return_val_if_fail (GST_IS_ADAPTER (adapter), GST_CLOCK_TIME_NONE);

  if (distance)
    *distance = adapter->pts_distance;

  return adapter->pts;
}

/**
 * gst_adapter_prev_dts:
 * @adapter: a #GstAdapter
 * @distance: (out) (allow-none): pointer to location for distance, or %NULL
 *
 * Get the dts that was before the current byte in the adapter. When
 * @distance is given, the amount of bytes between the dts and the current
 * position is returned.
 *
 * The dts is reset to GST_CLOCK_TIME_NONE and the distance is set to 0 when
 * the adapter is first created or when it is cleared. This also means that before
 * the first byte with a dts is removed from the adapter, the dts
 * and distance returned are GST_CLOCK_TIME_NONE and 0 respectively.
 *
 * Returns: The previously seen dts.
 */
GstClockTime
gst_adapter_prev_dts (GstAdapter * adapter, guint64 * distance)
{
  g_return_val_if_fail (GST_IS_ADAPTER (adapter), GST_CLOCK_TIME_NONE);

  if (distance)
    *distance = adapter->dts_distance;

  return adapter->dts;
}

/**
 * gst_adapter_prev_pts_at_offset:
 * @adapter: a #GstAdapter
 * @offset: the offset in the adapter at which to get timestamp
 * @distance: (out) (allow-none): pointer to location for distance, or %NULL
 *
 * Get the pts that was before the byte at offset @offset in the adapter. When
 * @distance is given, the amount of bytes between the pts and the current
 * position is returned.
 *
 * The pts is reset to GST_CLOCK_TIME_NONE and the distance is set to 0 when
 * the adapter is first created or when it is cleared. This also means that before
 * the first byte with a pts is removed from the adapter, the pts
 * and distance returned are GST_CLOCK_TIME_NONE and 0 respectively.
 *
 * Since: 1.2
 * Returns: The previously seen pts at given offset.
 */
GstClockTime
gst_adapter_prev_pts_at_offset (GstAdapter * adapter, gsize offset,
    guint64 * distance)
{
  GstBuffer *cur;
  GSList *g;
  gsize read_offset = 0;
  GstClockTime pts = adapter->pts;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), GST_CLOCK_TIME_NONE);

  g = adapter->buflist;

  while (g && read_offset < offset + adapter->skip) {
    cur = g->data;

    read_offset += gst_buffer_get_size (cur);
    if (GST_CLOCK_TIME_IS_VALID (GST_BUFFER_PTS (cur))) {
      pts = GST_BUFFER_PTS (cur);
    }

    g = g_slist_next (g);
  }

  if (distance)
    *distance = adapter->dts_distance + offset;

  return pts;
}

/**
 * gst_adapter_prev_dts_at_offset:
 * @adapter: a #GstAdapter
 * @offset: the offset in the adapter at which to get timestamp
 * @distance: (out) (allow-none): pointer to location for distance, or %NULL
 *
 * Get the dts that was before the byte at offset @offset in the adapter. When
 * @distance is given, the amount of bytes between the dts and the current
 * position is returned.
 *
 * The dts is reset to GST_CLOCK_TIME_NONE and the distance is set to 0 when
 * the adapter is first created or when it is cleared. This also means that before
 * the first byte with a dts is removed from the adapter, the dts
 * and distance returned are GST_CLOCK_TIME_NONE and 0 respectively.
 *
 * Since: 1.2
 * Returns: The previously seen dts at given offset.
 */
GstClockTime
gst_adapter_prev_dts_at_offset (GstAdapter * adapter, gsize offset,
    guint64 * distance)
{
  GstBuffer *cur;
  GSList *g;
  gsize read_offset = 0;
  GstClockTime dts = adapter->dts;

  g_return_val_if_fail (GST_IS_ADAPTER (adapter), GST_CLOCK_TIME_NONE);

  g = adapter->buflist;

  while (g && read_offset < offset + adapter->skip) {
    cur = g->data;

    read_offset += gst_buffer_get_size (cur);
    if (GST_CLOCK_TIME_IS_VALID (GST_BUFFER_DTS (cur))) {
      dts = GST_BUFFER_DTS (cur);
    }

    g = g_slist_next (g);
  }

  if (distance)
    *distance = adapter->dts_distance + offset;

  return dts;
}

/**
 * gst_adapter_masked_scan_uint32_peek:
 * @adapter: a #GstAdapter
 * @mask: mask to apply to data before matching against @pattern
 * @pattern: pattern to match (after mask is applied)
 * @offset: offset into the adapter data from which to start scanning, returns
 *          the last scanned position.
 * @size: number of bytes to scan from offset
 * @value: (out) (allow-none): pointer to uint32 to return matching data
 *
 * Scan for pattern @pattern with applied mask @mask in the adapter data,
 * starting from offset @offset.  If a match is found, the value that matched
 * is returned through @value, otherwise @value is left untouched.
 *
 * The bytes in @pattern and @mask are interpreted left-to-right, regardless
 * of endianness.  All four bytes of the pattern must be present in the
 * adapter for it to match, even if the first or last bytes are masked out.
 *
 * It is an error to call this function without making sure that there is
 * enough data (offset+size bytes) in the adapter.
 *
 * Returns: offset of the first match, or -1 if no match was found.
 */
gssize
gst_adapter_masked_scan_uint32_peek (GstAdapter * adapter, guint32 mask,
    guint32 pattern, gsize offset, gsize size, guint32 * value)
{
  GSList *g;
  gsize skip, bsize, i;
  guint32 state;
  GstMapInfo info;
  guint8 *bdata;
  GstBuffer *buf;

  g_return_val_if_fail (size > 0, -1);
  g_return_val_if_fail (offset + size <= adapter->size, -1);
  g_return_val_if_fail (((~mask) & pattern) == 0, -1);

  /* we can't find the pattern with less than 4 bytes */
  if (G_UNLIKELY (size < 4))
    return -1;

  skip = offset + adapter->skip;

  /* first step, do skipping and position on the first buffer */
  /* optimistically assume scanning continues sequentially */
  if (adapter->scan_entry && (adapter->scan_offset <= skip)) {
    g = adapter->scan_entry;
    skip -= adapter->scan_offset;
  } else {
    g = adapter->buflist;
    adapter->scan_offset = 0;
    adapter->scan_entry = NULL;
  }
  buf = g->data;
  bsize = gst_buffer_get_size (buf);
  while (G_UNLIKELY (skip >= bsize)) {
    skip -= bsize;
    g = g_slist_next (g);
    adapter->scan_offset += bsize;
    adapter->scan_entry = g;
    buf = g->data;
    bsize = gst_buffer_get_size (buf);
  }
  /* get the data now */
  if (!gst_buffer_map (buf, &info, GST_MAP_READ))
    return -1;

  bdata = (guint8 *) info.data + skip;
  bsize = info.size - skip;
  skip = 0;

  /* set the state to something that does not match */
  state = ~pattern;

  /* now find data */
  do {
    bsize = MIN (bsize, size);
    for (i = 0; i < bsize; i++) {
      state = ((state << 8) | bdata[i]);
      if (G_UNLIKELY ((state & mask) == pattern)) {
        /* we have a match but we need to have skipped at
         * least 4 bytes to fill the state. */
        if (G_LIKELY (skip + i >= 3)) {
          if (G_LIKELY (value))
            *value = state;
          gst_buffer_unmap (buf, &info);
          return offset + skip + i - 3;
        }
      }
    }
    size -= bsize;
    if (size == 0)
      break;

    /* nothing found yet, go to next buffer */
    skip += bsize;
    g = g_slist_next (g);
    adapter->scan_offset += info.size;
    adapter->scan_entry = g;
    gst_buffer_unmap (buf, &info);
    buf = g->data;

    if (!gst_buffer_map (buf, &info, GST_MAP_READ))
      return -1;

    bsize = info.size;
    bdata = info.data;
  } while (TRUE);

  gst_buffer_unmap (buf, &info);

  /* nothing found */
  return -1;
}

/**
 * gst_adapter_masked_scan_uint32:
 * @adapter: a #GstAdapter
 * @mask: mask to apply to data before matching against @pattern
 * @pattern: pattern to match (after mask is applied)
 * @offset: offset into the adapter data from which to start scanning, returns
 *          the last scanned position.
 * @size: number of bytes to scan from offset
 *
 * Scan for pattern @pattern with applied mask @mask in the adapter data,
 * starting from offset @offset.
 *
 * The bytes in @pattern and @mask are interpreted left-to-right, regardless
 * of endianness.  All four bytes of the pattern must be present in the
 * adapter for it to match, even if the first or last bytes are masked out.
 *
 * It is an error to call this function without making sure that there is
 * enough data (offset+size bytes) in the adapter.
 *
 * This function calls gst_adapter_masked_scan_uint32_peek() passing %NULL
 * for value.
 *
 * Returns: offset of the first match, or -1 if no match was found.
 *
 * Example:
 * <programlisting>
 * // Assume the adapter contains 0x00 0x01 0x02 ... 0xfe 0xff
 *
 * gst_adapter_masked_scan_uint32 (adapter, 0xffffffff, 0x00010203, 0, 256);
 * // -> returns 0
 * gst_adapter_masked_scan_uint32 (adapter, 0xffffffff, 0x00010203, 1, 255);
 * // -> returns -1
 * gst_adapter_masked_scan_uint32 (adapter, 0xffffffff, 0x01020304, 1, 255);
 * // -> returns 1
 * gst_adapter_masked_scan_uint32 (adapter, 0xffff, 0x0001, 0, 256);
 * // -> returns -1
 * gst_adapter_masked_scan_uint32 (adapter, 0xffff, 0x0203, 0, 256);
 * // -> returns 0
 * gst_adapter_masked_scan_uint32 (adapter, 0xffff0000, 0x02030000, 0, 256);
 * // -> returns 2
 * gst_adapter_masked_scan_uint32 (adapter, 0xffff0000, 0x02030000, 0, 4);
 * // -> returns -1
 * </programlisting>
 */
gssize
gst_adapter_masked_scan_uint32 (GstAdapter * adapter, guint32 mask,
    guint32 pattern, gsize offset, gsize size)
{
  return gst_adapter_masked_scan_uint32_peek (adapter, mask, pattern, offset,
      size, NULL);
}
