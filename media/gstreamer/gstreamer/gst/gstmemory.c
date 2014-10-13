/* GStreamer
 * Copyright (C) 2011 Wim Taymans <wim.taymans@gmail.be>
 *
 * gstmemory.c: memory block handling
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
 * SECTION:gstmemory
 * @short_description: refcounted wrapper for memory blocks
 * @see_also: #GstBuffer
 *
 * GstMemory is a lightweight refcounted object that wraps a region of memory.
 * They are typically used to manage the data of a #GstBuffer.
 *
 * A GstMemory object has an allocated region of memory of maxsize. The maximum
 * size does not change during the lifetime of the memory object. The memory
 * also has an offset and size property that specifies the valid range of memory
 * in the allocated region.
 *
 * Memory is usually created by allocators with a gst_allocator_alloc()
 * method call. When %NULL is used as the allocator, the default allocator will
 * be used.
 *
 * New allocators can be registered with gst_allocator_register().
 * Allocators are identified by name and can be retrieved with
 * gst_allocator_find(). gst_allocator_set_default() can be used to change the
 * default allocator.
 *
 * New memory can be created with gst_memory_new_wrapped() that wraps the memory
 * allocated elsewhere.
 *
 * Refcounting of the memory block is performed with gst_memory_ref() and
 * gst_memory_unref().
 *
 * The size of the memory can be retrieved and changed with
 * gst_memory_get_sizes() and gst_memory_resize() respectively.
 *
 * Getting access to the data of the memory is performed with gst_memory_map().
 * The call will return a pointer to offset bytes into the region of memory.
 * After the memory access is completed, gst_memory_unmap() should be called.
 *
 * Memory can be copied with gst_memory_copy(), which will return a writable
 * copy. gst_memory_share() will create a new memory block that shares the
 * memory with an existing memory block at a custom offset and with a custom
 * size.
 *
 * Memory can be efficiently merged when gst_memory_is_span() returns %TRUE.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"
#include "gstmemory.h"

GType _gst_memory_type = 0;
GST_DEFINE_MINI_OBJECT_TYPE (GstMemory, gst_memory);

static GstMemory *
_gst_memory_copy (GstMemory * mem)
{
  GST_CAT_DEBUG (GST_CAT_MEMORY, "copy memory %p", mem);
  return gst_memory_copy (mem, 0, -1);
}

static void
_gst_memory_free (GstMemory * mem)
{
  GstAllocator *allocator;

  GST_CAT_DEBUG (GST_CAT_MEMORY, "free memory %p", mem);

  if (mem->parent) {
    gst_memory_unlock (mem->parent, GST_LOCK_FLAG_EXCLUSIVE);
    gst_memory_unref (mem->parent);
  }

  allocator = mem->allocator;

  gst_allocator_free (allocator, mem);
  gst_object_unref (allocator);
}

/**
 * gst_memory_init: (skip)
 * @mem: a #GstMemory
 * @flags: #GstMemoryFlags
 * @allocator: the #GstAllocator
 * @parent: the parent of @mem
 * @maxsize: the total size of the memory
 * @align: the alignment of the memory
 * @offset: The offset in the memory
 * @size: the size of valid data in the memory

 * Initializes a newly allocated @mem with the given parameters. This function
 * will call gst_mini_object_init() with the default memory parameters.
 */
void
gst_memory_init (GstMemory * mem, GstMemoryFlags flags,
    GstAllocator * allocator, GstMemory * parent, gsize maxsize, gsize align,
    gsize offset, gsize size)
{
  gst_mini_object_init (GST_MINI_OBJECT_CAST (mem),
      flags | GST_MINI_OBJECT_FLAG_LOCKABLE, GST_TYPE_MEMORY,
      (GstMiniObjectCopyFunction) _gst_memory_copy, NULL,
      (GstMiniObjectFreeFunction) _gst_memory_free);

  mem->allocator = gst_object_ref (allocator);
  if (parent) {
    gst_memory_lock (parent, GST_LOCK_FLAG_EXCLUSIVE);
    gst_memory_ref (parent);
  }
  mem->parent = parent;
  mem->maxsize = maxsize;
  mem->align = align;
  mem->offset = offset;
  mem->size = size;

  GST_CAT_DEBUG (GST_CAT_MEMORY, "new memory %p, maxsize:%" G_GSIZE_FORMAT
      " offset:%" G_GSIZE_FORMAT " size:%" G_GSIZE_FORMAT, mem, maxsize,
      offset, size);
}

/**
 * gst_memory_is_type:
 * @mem: a #GstMemory
 * @mem_type: a memory type
 *
 * Check if @mem if allocated with an allocator for @mem_type.
 *
 * Returns: %TRUE if @mem was allocated from an allocator for @mem_type.
 *
 * Since: 1.2
 */
gboolean
gst_memory_is_type (GstMemory * mem, const gchar * mem_type)
{
  g_return_val_if_fail (mem != NULL, FALSE);
  g_return_val_if_fail (mem->allocator != NULL, FALSE);
  g_return_val_if_fail (mem_type != NULL, FALSE);

  return (g_strcmp0 (mem->allocator->mem_type, mem_type) == 0);
}

/**
 * gst_memory_get_sizes:
 * @mem: a #GstMemory
 * @offset: pointer to offset
 * @maxsize: pointer to maxsize
 *
 * Get the current @size, @offset and @maxsize of @mem.
 *
 * Returns: the current sizes of @mem
 */
gsize
gst_memory_get_sizes (GstMemory * mem, gsize * offset, gsize * maxsize)
{
  g_return_val_if_fail (mem != NULL, 0);

  if (offset)
    *offset = mem->offset;
  if (maxsize)
    *maxsize = mem->maxsize;

  return mem->size;
}

/**
 * gst_memory_resize:
 * @mem: a #GstMemory
 * @offset: a new offset
 * @size: a new size
 *
 * Resize the memory region. @mem should be writable and offset + size should be
 * less than the maxsize of @mem.
 *
 * #GST_MEMORY_FLAG_ZERO_PREFIXED and #GST_MEMORY_FLAG_ZERO_PADDED will be
 * cleared when offset or padding is increased respectively.
 */
void
gst_memory_resize (GstMemory * mem, gssize offset, gsize size)
{
  g_return_if_fail (mem != NULL);
  g_return_if_fail (offset >= 0 || mem->offset >= -offset);
  g_return_if_fail (size + mem->offset + offset <= mem->maxsize);

  /* if we increase the prefix, we can't guarantee it is still 0 filled */
  if ((offset > 0) && GST_MEMORY_IS_ZERO_PREFIXED (mem))
    GST_MEMORY_FLAG_UNSET (mem, GST_MEMORY_FLAG_ZERO_PREFIXED);

  /* if we increase the padding, we can't guarantee it is still 0 filled */
  if ((offset + size < mem->size) && GST_MEMORY_IS_ZERO_PADDED (mem))
    GST_MEMORY_FLAG_UNSET (mem, GST_MEMORY_FLAG_ZERO_PADDED);

  mem->offset += offset;
  mem->size = size;
}

/**
 * gst_memory_make_mapped:
 * @mem: (transfer full): a #GstMemory
 * @info: (out): pointer for info
 * @flags: mapping flags
 *
 * Create a #GstMemory object that is mapped with @flags. If @mem is mappable
 * with @flags, this function returns the mapped @mem directly. Otherwise a
 * mapped copy of @mem is returned.
 *
 * This function takes ownership of old @mem and returns a reference to a new
 * #GstMemory.
 *
 * Returns: (transfer full) (nullable): a #GstMemory object mapped
 * with @flags or %NULL when a mapping is not possible.
 */
GstMemory *
gst_memory_make_mapped (GstMemory * mem, GstMapInfo * info, GstMapFlags flags)
{
  GstMemory *result;

  if (gst_memory_map (mem, info, flags)) {
    result = mem;
  } else {
    result = gst_memory_copy (mem, 0, -1);
    gst_memory_unref (mem);

    if (result == NULL)
      goto cannot_copy;

    if (!gst_memory_map (result, info, flags))
      goto cannot_map;
  }
  return result;

  /* ERRORS */
cannot_copy:
  {
    GST_CAT_DEBUG (GST_CAT_MEMORY, "cannot copy memory %p", mem);
    return NULL;
  }
cannot_map:
  {
    GST_CAT_DEBUG (GST_CAT_MEMORY, "cannot map memory %p with flags %d", mem,
        flags);
    gst_memory_unref (result);
    return NULL;
  }
}

/**
 * gst_memory_map:
 * @mem: a #GstMemory
 * @info: (out): pointer for info
 * @flags: mapping flags
 *
 * Fill @info with the pointer and sizes of the memory in @mem that can be
 * accessed according to @flags.
 *
 * This function can return %FALSE for various reasons:
 * - the memory backed by @mem is not accessible with the given @flags.
 * - the memory was already mapped with a different mapping.
 *
 * @info and its contents remain valid for as long as @mem is valid and
 * until gst_memory_unmap() is called.
 *
 * For each gst_memory_map() call, a corresponding gst_memory_unmap() call
 * should be done.
 *
 * Returns: %TRUE if the map operation was successful.
 */
gboolean
gst_memory_map (GstMemory * mem, GstMapInfo * info, GstMapFlags flags)
{
  g_return_val_if_fail (mem != NULL, FALSE);
  g_return_val_if_fail (info != NULL, FALSE);

  if (!gst_memory_lock (mem, (GstLockFlags) flags))
    goto lock_failed;

  info->data = mem->allocator->mem_map (mem, mem->maxsize, flags);

  if (G_UNLIKELY (info->data == NULL))
    goto error;

  info->memory = mem;
  info->flags = flags;
  info->size = mem->size;
  info->maxsize = mem->maxsize - mem->offset;
  info->data = info->data + mem->offset;

  return TRUE;

  /* ERRORS */
lock_failed:
  {
    GST_CAT_DEBUG (GST_CAT_MEMORY, "mem %p: lock %d failed", mem, flags);
    memset (info, 0, sizeof (GstMapInfo));
    return FALSE;
  }
error:
  {
    /* something went wrong, restore the orginal state again */
    GST_CAT_ERROR (GST_CAT_MEMORY, "mem %p: subclass map failed", mem);
    gst_memory_unlock (mem, (GstLockFlags) flags);
    memset (info, 0, sizeof (GstMapInfo));
    return FALSE;
  }
}

/**
 * gst_memory_unmap:
 * @mem: a #GstMemory
 * @info: a #GstMapInfo
 *
 * Release the memory obtained with gst_memory_map()
 */
void
gst_memory_unmap (GstMemory * mem, GstMapInfo * info)
{
  g_return_if_fail (mem != NULL);
  g_return_if_fail (info != NULL);
  g_return_if_fail (info->memory == mem);

  mem->allocator->mem_unmap (mem);
  gst_memory_unlock (mem, (GstLockFlags) info->flags);
}

/**
 * gst_memory_copy:
 * @mem: a #GstMemory
 * @offset: an offset to copy
 * @size: size to copy or -1 to copy all bytes from offset
 *
 * Return a copy of @size bytes from @mem starting from @offset. This copy is
 * guaranteed to be writable. @size can be set to -1 to return a copy all bytes
 * from @offset.
 *
 * Returns: a new #GstMemory.
 */
GstMemory *
gst_memory_copy (GstMemory * mem, gssize offset, gssize size)
{
  GstMemory *copy;

  g_return_val_if_fail (mem != NULL, NULL);

  copy = mem->allocator->mem_copy (mem, offset, size);

  return copy;
}

/**
 * gst_memory_share:
 * @mem: a #GstMemory
 * @offset: an offset to share
 * @size: size to share or -1 to share bytes from offset
 *
 * Return a shared copy of @size bytes from @mem starting from @offset. No
 * memory copy is performed and the memory region is simply shared. The result
 * is guaranteed to be not-writable. @size can be set to -1 to return a share
 * all bytes from @offset.
 *
 * Returns: a new #GstMemory.
 */
GstMemory *
gst_memory_share (GstMemory * mem, gssize offset, gssize size)
{
  GstMemory *shared;

  g_return_val_if_fail (mem != NULL, NULL);
  g_return_val_if_fail (!GST_MEMORY_FLAG_IS_SET (mem, GST_MEMORY_FLAG_NO_SHARE),
      NULL);

  shared = mem->allocator->mem_share (mem, offset, size);

  return shared;
}

/**
 * gst_memory_is_span:
 * @mem1: a #GstMemory
 * @mem2: a #GstMemory
 * @offset: a pointer to a result offset
 *
 * Check if @mem1 and mem2 share the memory with a common parent memory object
 * and that the memory is contiguous.
 *
 * If this is the case, the memory of @mem1 and @mem2 can be merged
 * efficiently by performing gst_memory_share() on the parent object from
 * the returned @offset.
 *
 * Returns: %TRUE if the memory is contiguous and of a common parent.
 */
gboolean
gst_memory_is_span (GstMemory * mem1, GstMemory * mem2, gsize * offset)
{
  g_return_val_if_fail (mem1 != NULL, FALSE);
  g_return_val_if_fail (mem2 != NULL, FALSE);

  /* need to have the same allocators */
  if (mem1->allocator != mem2->allocator)
    return FALSE;

  /* need to have the same parent */
  if (mem1->parent == NULL || mem1->parent != mem2->parent)
    return FALSE;

  /* and memory is contiguous */
  if (!mem1->allocator->mem_is_span (mem1, mem2, offset))
    return FALSE;

  return TRUE;
}

void
_priv_gst_memory_initialize (void)
{
  _gst_memory_type = gst_memory_get_type ();
}
