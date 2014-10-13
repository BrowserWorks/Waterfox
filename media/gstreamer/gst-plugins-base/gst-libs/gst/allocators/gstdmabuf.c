/* GStreamer dmabuf allocator
 * Copyright (C) 2013 Linaro SA
 * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for mordetails.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstdmabuf.h"

/**
 * SECTION:gstdmabuf
 * @short_description: Memory wrapper for Linux dmabuf memory
 * @see_also: #GstMemory
 *
 * Since: 1.2
 */

#ifdef HAVE_MMAP
#include <sys/mman.h>
#include <unistd.h>
#endif

/*
 * GstDmaBufMemory
 * @fd: the file descriptor associated this memory
 * @data: mmapped address
 * @mmapping_flags: mmapping flags
 * @mmap_count: mmapping counter
 * @lock: a mutex to make mmapping thread safe
 */
typedef struct
{
  GstMemory mem;

  gint fd;
  gpointer data;
  gint mmapping_flags;
  gint mmap_count;
  GMutex lock;
} GstDmaBufMemory;

GST_DEBUG_CATEGORY_STATIC (dmabuf_debug);
#define GST_CAT_DEFAULT dmabuf_debug

static void
gst_dmabuf_allocator_free (GstAllocator * allocator, GstMemory * gmem)
{
#ifdef HAVE_MMAP
  GstDmaBufMemory *mem = (GstDmaBufMemory *) gmem;

  if (mem->data) {
    g_warning (G_STRLOC ":%s: Freeing memory %p still mapped", G_STRFUNC, mem);
    munmap ((void *) mem->data, gmem->maxsize);
  }
  if (mem->fd >= 0 && gmem->parent == NULL)
    close (mem->fd);
  g_mutex_clear (&mem->lock);
  g_slice_free (GstDmaBufMemory, mem);
  GST_DEBUG ("%p: freed", mem);
#endif
}

static gpointer
gst_dmabuf_mem_map (GstMemory * gmem, gsize maxsize, GstMapFlags flags)
{
#ifdef HAVE_MMAP
  GstDmaBufMemory *mem = (GstDmaBufMemory *) gmem;
  gint prot;
  gpointer ret = NULL;

  if (gmem->parent)
    return gst_dmabuf_mem_map (gmem->parent, maxsize, flags);

  g_mutex_lock (&mem->lock);

  prot = flags & GST_MAP_READ ? PROT_READ : 0;
  prot |= flags & GST_MAP_WRITE ? PROT_WRITE : 0;

  /* do not mmap twice the buffer */
  if (mem->data) {
    /* only return address if mapping flags are a subset
     * of the previous flags */
    if ((mem->mmapping_flags & prot) == prot) {
      ret = mem->data;
      mem->mmap_count++;
    }

    goto out;
  }

  if (mem->fd != -1) {
    mem->data = mmap (0, gmem->maxsize, prot, MAP_SHARED, mem->fd, 0);
    if (mem->data == MAP_FAILED) {
      mem->data = NULL;
      GST_ERROR ("%p: fd %d: mmap failed: %s", mem, mem->fd,
          g_strerror (errno));
      goto out;
    }
  }

  GST_DEBUG ("%p: fd %d: mapped %p", mem, mem->fd, mem->data);

  if (mem->data) {
    mem->mmapping_flags = prot;
    mem->mmap_count++;
    ret = mem->data;
  }

out:
  g_mutex_unlock (&mem->lock);
  return ret;
#else /* !HAVE_MMAP */
  return FALSE;
#endif
}

static void
gst_dmabuf_mem_unmap (GstMemory * gmem)
{
#ifdef HAVE_MMAP
  GstDmaBufMemory *mem = (GstDmaBufMemory *) gmem;

  if (gmem->parent)
    return gst_dmabuf_mem_unmap (gmem->parent);

  g_mutex_lock (&mem->lock);

  if (mem->data && !(--mem->mmap_count)) {
    munmap ((void *) mem->data, gmem->maxsize);
    mem->data = NULL;
    mem->mmapping_flags = 0;
    GST_DEBUG ("%p: fd %d unmapped", mem, mem->fd);
  }
  g_mutex_unlock (&mem->lock);
#endif
}

static GstMemory *
gst_dmabuf_mem_share (GstMemory * gmem, gssize offset, gssize size)
{
#ifdef HAVE_MMAP
  GstDmaBufMemory *mem = (GstDmaBufMemory *) gmem;
  GstDmaBufMemory *sub;
  GstMemory *parent;

  GST_DEBUG ("%p: share %" G_GSSIZE_FORMAT " %" G_GSIZE_FORMAT, mem, offset,
      size);

  /* find the real parent */
  if ((parent = mem->mem.parent) == NULL)
    parent = (GstMemory *) mem;

  if (size == -1)
    size = gmem->maxsize - offset;

  sub = g_slice_new0 (GstDmaBufMemory);
  /* the shared memory is always readonly */
  gst_memory_init (GST_MEMORY_CAST (sub), GST_MINI_OBJECT_FLAGS (parent) |
      GST_MINI_OBJECT_FLAG_LOCK_READONLY, mem->mem.allocator, parent,
      mem->mem.maxsize, mem->mem.align, mem->mem.offset + offset, size);

  sub->fd = mem->fd;
  g_mutex_init (&sub->lock);

  return GST_MEMORY_CAST (sub);
#else /* !HAVE_MMAP */
  return NULL;
#endif
}

typedef struct
{
  GstAllocator parent;
} GstDmaBufAllocator;

typedef struct
{
  GstAllocatorClass parent_class;
} GstDmaBufAllocatorClass;

GType dmabuf_mem_allocator_get_type (void);
G_DEFINE_TYPE (GstDmaBufAllocator, dmabuf_mem_allocator, GST_TYPE_ALLOCATOR);

#define GST_TYPE_DMABUF_ALLOCATOR   (dmabuf_mem_allocator_get_type())
#define GST_IS_DMABUF_ALLOCATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_DMABUF_ALLOCATOR))

static void
dmabuf_mem_allocator_class_init (GstDmaBufAllocatorClass * klass)
{
  GstAllocatorClass *allocator_class;

  allocator_class = (GstAllocatorClass *) klass;

  allocator_class->alloc = NULL;
  allocator_class->free = gst_dmabuf_allocator_free;
}

static void
dmabuf_mem_allocator_init (GstDmaBufAllocator * allocator)
{
  GstAllocator *alloc = GST_ALLOCATOR_CAST (allocator);

  alloc->mem_type = GST_ALLOCATOR_DMABUF;
  alloc->mem_map = gst_dmabuf_mem_map;
  alloc->mem_unmap = gst_dmabuf_mem_unmap;
  alloc->mem_share = gst_dmabuf_mem_share;
  /* Use the default, fallback copy function */

  GST_OBJECT_FLAG_SET (allocator, GST_ALLOCATOR_FLAG_CUSTOM_ALLOC);
}

/**
 * gst_dmabuf_allocator_new:
 *
 * Return a new dmabuf allocator.
 *
 * Returns: (transfer full): a new dmabuf allocator, or NULL if the allocator
 *    isn't available. Use gst_object_unref() to release the allocator after
 *    usage
 *
 * Since: 1.2
 */
GstAllocator *
gst_dmabuf_allocator_new (void)
{
  GST_DEBUG_CATEGORY_INIT (dmabuf_debug, "dmabuf", 0, "dmabuf memory");

  return g_object_new (GST_TYPE_DMABUF_ALLOCATOR, NULL);
}

/**
 * gst_dmabuf_allocator_alloc:
 * @allocator: (allow-none): allocator to be used for this memory
 * @fd: dmabuf file descriptor
 * @size: memory size
 *
 * Return a %GstMemory that wraps a dmabuf file descriptor.
 *
 * Returns: (transfer full): a GstMemory based on @allocator.
 * When the buffer will be released dmabuf allocator will close the @fd.
 * The memory is only mmapped on gst_buffer_mmap() request.
 *
 * Since: 1.2
 */
GstMemory *
gst_dmabuf_allocator_alloc (GstAllocator * allocator, gint fd, gsize size)
{
#ifdef HAVE_MMAP
  GstDmaBufMemory *mem;

  if (!GST_IS_DMABUF_ALLOCATOR (allocator)) {
    GST_WARNING ("it isn't the correct allocator for dmabuf");
    return NULL;
  }

  GST_DEBUG ("alloc from allocator %p", allocator);

  mem = g_slice_new0 (GstDmaBufMemory);

  gst_memory_init (GST_MEMORY_CAST (mem), 0, allocator, NULL, size, 0, 0, size);

  mem->fd = fd;
  g_mutex_init (&mem->lock);

  GST_DEBUG ("%p: fd: %d size %" G_GSIZE_FORMAT, mem, mem->fd,
      mem->mem.maxsize);

  return (GstMemory *) mem;
#else /* !HAVE_MMAP */
  return NULL;
#endif
}

/**
 * gst_dmabuf_memory_get_fd:
 * @mem: the memory to get the file descriptor
 *
 * Return the file descriptor associated with @mem.
 *
 * Returns: the file descriptor associated with the memory, or -1
 *
 * Since: 1.2
 */
gint
gst_dmabuf_memory_get_fd (GstMemory * mem)
{
  GstDmaBufMemory *dbmem = (GstDmaBufMemory *) mem;

  g_return_val_if_fail (gst_is_dmabuf_memory (mem), -1);

  return dbmem->fd;
}

/**
 * gst_is_dmabuf_memory:
 * @mem: the memory to be check
 *
 * Check if @mem is dmabuf memory.
 *
 * Returns: %TRUE if @mem is dmabuf memory, otherwise %FALSE
 *
 * Since: 1.2
 */
gboolean
gst_is_dmabuf_memory (GstMemory * mem)
{
  return gst_memory_is_type (mem, GST_ALLOCATOR_DMABUF);
}
