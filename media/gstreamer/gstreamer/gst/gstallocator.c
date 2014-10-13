/* GStreamer
 * Copyright (C) 2011 Wim Taymans <wim.taymans@gmail.be>
 *
 * gstallocator.c: memory block allocator
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
 * SECTION:gstallocator
 * @short_description: allocate memory blocks
 * @see_also: #GstMemory
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
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst_private.h"
#include "gstmemory.h"

GST_DEBUG_CATEGORY_STATIC (gst_allocator_debug);
#define GST_CAT_DEFAULT gst_allocator_debug

#define GST_ALLOCATOR_GET_PRIVATE(obj)  \
     (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_ALLOCATOR, GstAllocatorPrivate))

struct _GstAllocatorPrivate
{
  gpointer dummy;
};

#if defined(MEMORY_ALIGNMENT_MALLOC)
gsize gst_memory_alignment = 7;
#elif defined(MEMORY_ALIGNMENT_PAGESIZE)
/* we fill this in in the _init method */
gsize gst_memory_alignment = 0;
#elif defined(MEMORY_ALIGNMENT)
gsize gst_memory_alignment = MEMORY_ALIGNMENT - 1;
#else
#error "No memory alignment configured"
gsize gst_memory_alignment = 0;
#endif

/* the default allocator */
static GstAllocator *_default_allocator;

static GstAllocator *_sysmem_allocator;

/* registered allocators */
static GRWLock lock;
static GHashTable *allocators;

G_DEFINE_ABSTRACT_TYPE (GstAllocator, gst_allocator, GST_TYPE_OBJECT);

static void
gst_allocator_class_init (GstAllocatorClass * klass)
{
  g_type_class_add_private (klass, sizeof (GstAllocatorPrivate));

  GST_DEBUG_CATEGORY_INIT (gst_allocator_debug, "allocator", 0,
      "allocator debug");
}

static GstMemory *
_fallback_mem_copy (GstMemory * mem, gssize offset, gssize size)
{
  GstMemory *copy;
  GstMapInfo sinfo, dinfo;
  GstAllocationParams params = { 0, mem->align, 0, 0, };
  GstAllocator *allocator;

  if (!gst_memory_map (mem, &sinfo, GST_MAP_READ))
    return NULL;

  if (size == -1)
    size = sinfo.size > offset ? sinfo.size - offset : 0;

  /* use the same allocator as the memory we copy  */
  allocator = mem->allocator;
  if (GST_OBJECT_FLAG_IS_SET (allocator, GST_ALLOCATOR_FLAG_CUSTOM_ALLOC))
    allocator = NULL;
  copy = gst_allocator_alloc (allocator, size, &params);

  if (!gst_memory_map (copy, &dinfo, GST_MAP_WRITE)) {
    GST_CAT_WARNING (GST_CAT_MEMORY, "could not write map memory %p", copy);
    gst_allocator_free (mem->allocator, copy);
    gst_memory_unmap (mem, &sinfo);
    return NULL;
  }

  GST_CAT_DEBUG (GST_CAT_PERFORMANCE,
      "memcpy %" G_GSSIZE_FORMAT " memory %p -> %p", size, mem, copy);
  memcpy (dinfo.data, sinfo.data + offset, size);
  gst_memory_unmap (copy, &dinfo);
  gst_memory_unmap (mem, &sinfo);

  return copy;
}

static gboolean
_fallback_mem_is_span (GstMemory * mem1, GstMemory * mem2, gsize * offset)
{
  return FALSE;
}

static void
gst_allocator_init (GstAllocator * allocator)
{
  allocator->priv = GST_ALLOCATOR_GET_PRIVATE (allocator);

  allocator->mem_copy = _fallback_mem_copy;
  allocator->mem_is_span = _fallback_mem_is_span;
}

G_DEFINE_BOXED_TYPE (GstAllocationParams, gst_allocation_params,
    (GBoxedCopyFunc) gst_allocation_params_copy,
    (GBoxedFreeFunc) gst_allocation_params_free);

/**
 * gst_allocation_params_init:
 * @params: a #GstAllocationParams
 *
 * Initialize @params to its default values
 */
void
gst_allocation_params_init (GstAllocationParams * params)
{
  g_return_if_fail (params != NULL);

  memset (params, 0, sizeof (GstAllocationParams));
}

/**
 * gst_allocation_params_copy:
 * @params: (transfer none): a #GstAllocationParams
 *
 * Create a copy of @params.
 *
 * Free-function: gst_allocation_params_free
 *
 * Returns: (transfer full): a new ##GstAllocationParams, free with
 * gst_allocation_params_free().
 */
GstAllocationParams *
gst_allocation_params_copy (const GstAllocationParams * params)
{
  GstAllocationParams *result = NULL;

  if (params) {
    result =
        (GstAllocationParams *) g_slice_copy (sizeof (GstAllocationParams),
        params);
  }
  return result;
}

/**
 * gst_allocation_params_free:
 * @params: (in) (transfer full): a #GstAllocationParams
 *
 * Free @params
 */
void
gst_allocation_params_free (GstAllocationParams * params)
{
  g_slice_free (GstAllocationParams, params);
}

/**
 * gst_allocator_register:
 * @name: the name of the allocator
 * @allocator: (transfer full): #GstAllocator
 *
 * Registers the memory @allocator with @name. This function takes ownership of
 * @allocator.
 */
void
gst_allocator_register (const gchar * name, GstAllocator * allocator)
{
  g_return_if_fail (name != NULL);
  g_return_if_fail (allocator != NULL);

  GST_CAT_DEBUG (GST_CAT_MEMORY, "registering allocator %p with name \"%s\"",
      allocator, name);

  g_rw_lock_writer_lock (&lock);
  g_hash_table_insert (allocators, (gpointer) name, (gpointer) allocator);
  g_rw_lock_writer_unlock (&lock);
}

/**
 * gst_allocator_find:
 * @name: (allow-none): the name of the allocator
 *
 * Find a previously registered allocator with @name. When @name is %NULL, the
 * default allocator will be returned.
 *
 * Returns: (transfer full) (nullable): a #GstAllocator or %NULL when
 * the allocator with @name was not registered. Use gst_object_unref()
 * to release the allocator after usage.
 */
GstAllocator *
gst_allocator_find (const gchar * name)
{
  GstAllocator *allocator;

  g_rw_lock_reader_lock (&lock);
  if (name) {
    allocator = g_hash_table_lookup (allocators, (gconstpointer) name);
  } else {
    allocator = _default_allocator;
  }
  if (allocator)
    gst_object_ref (allocator);
  g_rw_lock_reader_unlock (&lock);

  return allocator;
}

/**
 * gst_allocator_set_default:
 * @allocator: (transfer full): a #GstAllocator
 *
 * Set the default allocator. This function takes ownership of @allocator.
 */
void
gst_allocator_set_default (GstAllocator * allocator)
{
  GstAllocator *old;

  g_return_if_fail (GST_IS_ALLOCATOR (allocator));

  g_rw_lock_writer_lock (&lock);
  old = _default_allocator;
  _default_allocator = allocator;
  g_rw_lock_writer_unlock (&lock);

  if (old)
    gst_object_unref (old);
}

/**
 * gst_allocator_alloc:
 * @allocator: (transfer none) (allow-none): a #GstAllocator to use
 * @size: size of the visible memory area
 * @params: (transfer none) (allow-none): optional parameters
 *
 * Use @allocator to allocate a new memory block with memory that is at least
 * @size big.
 *
 * The optional @params can specify the prefix and padding for the memory. If
 * %NULL is passed, no flags, no extra prefix/padding and a default alignment is
 * used.
 *
 * The prefix/padding will be filled with 0 if flags contains
 * #GST_MEMORY_FLAG_ZERO_PREFIXED and #GST_MEMORY_FLAG_ZERO_PADDED respectively.
 *
 * When @allocator is %NULL, the default allocator will be used.
 *
 * The alignment in @params is given as a bitmask so that @align + 1 equals
 * the amount of bytes to align to. For example, to align to 8 bytes,
 * use an alignment of 7.
 *
 * Returns: (transfer full): a new #GstMemory.
 */
GstMemory *
gst_allocator_alloc (GstAllocator * allocator, gsize size,
    GstAllocationParams * params)
{
  GstMemory *mem;
  static GstAllocationParams defparams = { 0, 0, 0, 0, };
  GstAllocatorClass *aclass;

  if (params) {
    g_return_val_if_fail (((params->align + 1) & params->align) == 0, NULL);
  } else {
    params = &defparams;
  }

  if (allocator == NULL)
    allocator = _default_allocator;

  aclass = GST_ALLOCATOR_GET_CLASS (allocator);
  if (aclass->alloc)
    mem = aclass->alloc (allocator, size, params);
  else
    mem = NULL;

  return mem;
}

/**
 * gst_allocator_free:
 * @allocator: (transfer none): a #GstAllocator to use
 * @memory: (transfer full): the memory to free
 *
 * Free @memory that was previously allocated with gst_allocator_alloc().
 */
void
gst_allocator_free (GstAllocator * allocator, GstMemory * memory)
{
  GstAllocatorClass *aclass;

  g_return_if_fail (GST_IS_ALLOCATOR (allocator));
  g_return_if_fail (memory != NULL);
  g_return_if_fail (memory->allocator == allocator);

  aclass = GST_ALLOCATOR_GET_CLASS (allocator);
  if (aclass->free)
    aclass->free (allocator, memory);
}

/* default memory implementation */
typedef struct
{
  GstMemory mem;

  gsize slice_size;
  guint8 *data;

  gpointer user_data;
  GDestroyNotify notify;
} GstMemorySystem;

typedef struct
{
  GstAllocator parent;
} GstAllocatorSysmem;

typedef struct
{
  GstAllocatorClass parent_class;
} GstAllocatorSysmemClass;

GType gst_allocator_sysmem_get_type (void);
G_DEFINE_TYPE (GstAllocatorSysmem, gst_allocator_sysmem, GST_TYPE_ALLOCATOR);

/* initialize the fields */
static inline void
_sysmem_init (GstMemorySystem * mem, GstMemoryFlags flags,
    GstMemory * parent, gsize slice_size,
    gpointer data, gsize maxsize, gsize align, gsize offset, gsize size,
    gpointer user_data, GDestroyNotify notify)
{
  gst_memory_init (GST_MEMORY_CAST (mem),
      flags, _sysmem_allocator, parent, maxsize, align, offset, size);

  mem->slice_size = slice_size;
  mem->data = data;
  mem->user_data = user_data;
  mem->notify = notify;
}

/* create a new memory block that manages the given memory */
static inline GstMemorySystem *
_sysmem_new (GstMemoryFlags flags,
    GstMemory * parent, gpointer data, gsize maxsize, gsize align, gsize offset,
    gsize size, gpointer user_data, GDestroyNotify notify)
{
  GstMemorySystem *mem;
  gsize slice_size;

  slice_size = sizeof (GstMemorySystem);

  mem = g_slice_alloc (slice_size);
  _sysmem_init (mem, flags, parent, slice_size,
      data, maxsize, align, offset, size, user_data, notify);

  return mem;
}

/* allocate the memory and structure in one block */
static GstMemorySystem *
_sysmem_new_block (GstMemoryFlags flags,
    gsize maxsize, gsize align, gsize offset, gsize size)
{
  GstMemorySystem *mem;
  gsize aoffset, slice_size, padding;
  guint8 *data;

  /* ensure configured alignment */
  align |= gst_memory_alignment;
  /* allocate more to compensate for alignment */
  maxsize += align;
  /* alloc header and data in one block */
  slice_size = sizeof (GstMemorySystem) + maxsize;

  mem = g_slice_alloc (slice_size);
  if (mem == NULL)
    return NULL;

  data = (guint8 *) mem + sizeof (GstMemorySystem);

  /* do alignment */
  if ((aoffset = ((guintptr) data & align))) {
    aoffset = (align + 1) - aoffset;
    data += aoffset;
    maxsize -= aoffset;
  }

  if (offset && (flags & GST_MEMORY_FLAG_ZERO_PREFIXED))
    memset (data, 0, offset);

  padding = maxsize - (offset + size);
  if (padding && (flags & GST_MEMORY_FLAG_ZERO_PADDED))
    memset (data + offset + size, 0, padding);

  _sysmem_init (mem, flags, NULL, slice_size, data, maxsize,
      align, offset, size, NULL, NULL);

  return mem;
}

static gpointer
_sysmem_map (GstMemorySystem * mem, gsize maxsize, GstMapFlags flags)
{
  return mem->data;
}

static gboolean
_sysmem_unmap (GstMemorySystem * mem)
{
  return TRUE;
}

static GstMemorySystem *
_sysmem_copy (GstMemorySystem * mem, gssize offset, gsize size)
{
  GstMemorySystem *copy;

  if (size == -1)
    size = mem->mem.size > offset ? mem->mem.size - offset : 0;

  copy = _sysmem_new_block (0, size, mem->mem.align, 0, size);
  GST_CAT_DEBUG (GST_CAT_PERFORMANCE,
      "memcpy %" G_GSIZE_FORMAT " memory %p -> %p", size, mem, copy);
  memcpy (copy->data, mem->data + mem->mem.offset + offset, size);

  return copy;
}

static GstMemorySystem *
_sysmem_share (GstMemorySystem * mem, gssize offset, gsize size)
{
  GstMemorySystem *sub;
  GstMemory *parent;

  /* find the real parent */
  if ((parent = mem->mem.parent) == NULL)
    parent = (GstMemory *) mem;

  if (size == -1)
    size = mem->mem.size - offset;

  /* the shared memory is always readonly */
  sub =
      _sysmem_new (GST_MINI_OBJECT_FLAGS (parent) |
      GST_MINI_OBJECT_FLAG_LOCK_READONLY, parent, mem->data, mem->mem.maxsize,
      mem->mem.align, mem->mem.offset + offset, size, NULL, NULL);

  return sub;
}

static gboolean
_sysmem_is_span (GstMemorySystem * mem1, GstMemorySystem * mem2, gsize * offset)
{

  if (offset) {
    GstMemorySystem *parent;

    parent = (GstMemorySystem *) mem1->mem.parent;

    *offset = mem1->mem.offset - parent->mem.offset;
  }

  /* and memory is contiguous */
  return mem1->data + mem1->mem.offset + mem1->mem.size ==
      mem2->data + mem2->mem.offset;
}

static GstMemory *
default_alloc (GstAllocator * allocator, gsize size,
    GstAllocationParams * params)
{
  gsize maxsize = size + params->prefix + params->padding;

  return (GstMemory *) _sysmem_new_block (params->flags,
      maxsize, params->align, params->prefix, size);
}

static void
default_free (GstAllocator * allocator, GstMemory * mem)
{
  GstMemorySystem *dmem = (GstMemorySystem *) mem;
  gsize slice_size;

  if (dmem->notify)
    dmem->notify (dmem->user_data);

  slice_size = dmem->slice_size;

#ifdef USE_POISONING
  /* just poison the structs, not all the data */
  memset (mem, 0xff, sizeof (GstMemorySystem));
#endif

  g_slice_free1 (slice_size, mem);
}

static void
gst_allocator_sysmem_finalize (GObject * obj)
{
  g_warning ("The default memory allocator was freed!");
}

static void
gst_allocator_sysmem_class_init (GstAllocatorSysmemClass * klass)
{
  GObjectClass *gobject_class;
  GstAllocatorClass *allocator_class;

  gobject_class = (GObjectClass *) klass;
  allocator_class = (GstAllocatorClass *) klass;

  gobject_class->finalize = gst_allocator_sysmem_finalize;

  allocator_class->alloc = default_alloc;
  allocator_class->free = default_free;
}

static void
gst_allocator_sysmem_init (GstAllocatorSysmem * allocator)
{
  GstAllocator *alloc = GST_ALLOCATOR_CAST (allocator);

  GST_CAT_DEBUG (GST_CAT_MEMORY, "init allocator %p", allocator);

  alloc->mem_type = GST_ALLOCATOR_SYSMEM;
  alloc->mem_map = (GstMemoryMapFunction) _sysmem_map;
  alloc->mem_unmap = (GstMemoryUnmapFunction) _sysmem_unmap;
  alloc->mem_copy = (GstMemoryCopyFunction) _sysmem_copy;
  alloc->mem_share = (GstMemoryShareFunction) _sysmem_share;
  alloc->mem_is_span = (GstMemoryIsSpanFunction) _sysmem_is_span;
}

void
_priv_gst_allocator_initialize (void)
{
  g_rw_lock_init (&lock);
  allocators = g_hash_table_new (g_str_hash, g_str_equal);

#ifdef HAVE_GETPAGESIZE
#ifdef MEMORY_ALIGNMENT_PAGESIZE
  gst_memory_alignment = getpagesize () - 1;
#endif
#endif

  GST_CAT_DEBUG (GST_CAT_MEMORY, "memory alignment: %" G_GSIZE_FORMAT,
      gst_memory_alignment);

  _sysmem_allocator = g_object_new (gst_allocator_sysmem_get_type (), NULL);

  gst_allocator_register (GST_ALLOCATOR_SYSMEM,
      gst_object_ref (_sysmem_allocator));

  _default_allocator = gst_object_ref (_sysmem_allocator);
}

/**
 * gst_memory_new_wrapped:
 * @flags: #GstMemoryFlags
 * @data: (array length=size) (element-type guint8) (transfer none): data to
 *   wrap
 * @maxsize: allocated size of @data
 * @offset: offset in @data
 * @size: size of valid data
 * @user_data: (allow-none): user_data
 * @notify: (allow-none) (scope async) (closure user_data): called with @user_data when the memory is freed
 *
 * Allocate a new memory block that wraps the given @data.
 *
 * The prefix/padding must be filled with 0 if @flags contains
 * #GST_MEMORY_FLAG_ZERO_PREFIXED and #GST_MEMORY_FLAG_ZERO_PADDED respectively.
 *
 * Returns: (transfer full): a new #GstMemory.
 */
GstMemory *
gst_memory_new_wrapped (GstMemoryFlags flags, gpointer data,
    gsize maxsize, gsize offset, gsize size, gpointer user_data,
    GDestroyNotify notify)
{
  GstMemorySystem *mem;

  g_return_val_if_fail (data != NULL, NULL);
  g_return_val_if_fail (offset + size <= maxsize, NULL);

  mem =
      _sysmem_new (flags, NULL, data, maxsize, 0, offset, size, user_data,
      notify);

  return (GstMemory *) mem;
}
