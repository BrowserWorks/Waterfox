/* GStreamer
 * Copyright (C) 2010 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstbufferpool.h: Header for GstBufferPool object
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


#ifndef __GST_BUFFER_POOL_H__
#define __GST_BUFFER_POOL_H__

#include <gst/gstminiobject.h>
#include <gst/gstpad.h>
#include <gst/gstbuffer.h>

G_BEGIN_DECLS

typedef struct _GstBufferPoolPrivate GstBufferPoolPrivate;
typedef struct _GstBufferPoolClass GstBufferPoolClass;

#define GST_TYPE_BUFFER_POOL                 (gst_buffer_pool_get_type())
#define GST_IS_BUFFER_POOL(obj)              (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_BUFFER_POOL))
#define GST_IS_BUFFER_POOL_CLASS(klass)      (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_BUFFER_POOL))
#define GST_BUFFER_POOL_GET_CLASS(obj)       (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_BUFFER_POOL, GstBufferPoolClass))
#define GST_BUFFER_POOL(obj)                 (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_BUFFER_POOL, GstBufferPool))
#define GST_BUFFER_POOL_CLASS(klass)         (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_BUFFER_POOL, GstBufferPoolClass))
#define GST_BUFFER_POOL_CAST(obj)            ((GstBufferPool *)(obj))

/**
 * GstBufferPoolAcquireFlags:
 * @GST_BUFFER_POOL_ACQUIRE_FLAG_NONE: no flags
 * @GST_BUFFER_POOL_ACQUIRE_FLAG_KEY_UNIT: buffer is keyframe
 * @GST_BUFFER_POOL_ACQUIRE_FLAG_DONTWAIT: when the bufferpool is empty, acquire_buffer
 * will by default block until a buffer is released into the pool again. Setting
 * this flag makes acquire_buffer return #GST_FLOW_EOS instead of blocking.
 * @GST_BUFFER_POOL_ACQUIRE_FLAG_DISCONT: buffer is discont
 * @GST_BUFFER_POOL_ACQUIRE_FLAG_LAST: last flag, subclasses can use private flags
 *    starting from this value.
 *
 * Additional flags to control the allocation of a buffer
 */
typedef enum {
  GST_BUFFER_POOL_ACQUIRE_FLAG_NONE     = 0,
  GST_BUFFER_POOL_ACQUIRE_FLAG_KEY_UNIT = (1 << 0),
  GST_BUFFER_POOL_ACQUIRE_FLAG_DONTWAIT = (1 << 1),
  GST_BUFFER_POOL_ACQUIRE_FLAG_DISCONT  = (1 << 2),
  GST_BUFFER_POOL_ACQUIRE_FLAG_LAST     = (1 << 16),
} GstBufferPoolAcquireFlags;

typedef struct _GstBufferPoolAcquireParams GstBufferPoolAcquireParams;

/**
 * GstBufferPoolAcquireParams:
 * @format: the format of @start and @stop
 * @start: the start position
 * @stop: the stop position
 * @flags: additional flags
 *
 * Parameters passed to the gst_buffer_pool_acquire_buffer() function to control the
 * allocation of the buffer.
 *
 * The default implementation ignores the @start and @stop members but other
 * implementations can use this extra information to decide what buffer to
 * return.
 */
struct _GstBufferPoolAcquireParams {
  GstFormat                 format;
  gint64                    start;
  gint64                    stop;
  GstBufferPoolAcquireFlags flags;

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING];
};

/**
 * GST_BUFFER_POOL_IS_FLUSHING:
 * @pool: a GstBufferPool
 *
 * Check if the bufferpool is flushing. Subclasses might want to check the
 * state of the pool in the acquire function.
 */
#define GST_BUFFER_POOL_IS_FLUSHING(pool)  (g_atomic_int_get (&pool->flushing))

/**
 * GstBufferPool:
 *
 * The structure of a #GstBufferPool. Use the associated macros to access the public
 * variables.
 */
struct _GstBufferPool {
  GstObject            object;

  /*< protected >*/
  gint                 flushing;

  /*< private >*/
  GstBufferPoolPrivate *priv;

  gpointer _gst_reserved[GST_PADDING];
};

/**
 * GstBufferPoolClass:
 * @object_class:  Object parent class
 * @get_options: get a list of options supported by this pool
 * @set_config: apply the bufferpool configuration. The default configuration
 *              will parse the default config parameters
 * @start: start the bufferpool. The default implementation will preallocate
 *         min-buffers buffers and put them in the queue
 * @stop: stop the bufferpool. the default implementation will free the
 *        preallocated buffers. This function is called when all the buffers are
 *        returned to the pool.
 * @acquire_buffer: get a new buffer from the pool. The default implementation
 *        will take a buffer from the queue and optionally wait for a buffer to
 *        be released when there are no buffers available.
 * @alloc_buffer: allocate a buffer. the default implementation allocates
 *        buffers from the configured memory allocator and with the configured
 *        parameters. All metadata that is present on the allocated buffer will
 *        be marked as #GST_META_FLAG_POOLED and #GST_META_FLAG_LOCKED and will
 *        not be removed from the buffer in @reset_buffer. The buffer should
 *        have the GST_BUFFER_FLAG_TAG_MEMORY cleared.
 * @reset_buffer: reset the buffer to its state when it was freshly allocated.
 *        The default implementation will clear the flags, timestamps and
 *        will remove the metadata without the #GST_META_FLAG_POOLED flag (even
 *        the metadata with #GST_META_FLAG_LOCKED). If the
 *        #GST_BUFFER_FLAG_TAG_MEMORY was set, this function can also try to
 *        restore the memory and clear the #GST_BUFFER_FLAG_TAG_MEMORY again.
 * @release_buffer: release a buffer back in the pool. The default
 *        implementation will put the buffer back in the queue and notify any
 *        blocking acquire_buffer calls when the #GST_BUFFER_FLAG_TAG_MEMORY
 *        is not set on the buffer. If #GST_BUFFER_FLAG_TAG_MEMORY is set, the 
 *        buffer will be freed with @free_buffer.
 * @free_buffer: free a buffer. The default implementation unrefs the buffer.
 * @flush_start: enter the flushing state. Since: 1.4
 * @flush_stop: leave the flushign state. Since: 1.4
 *
 * The GstBufferPool class.
 */
struct _GstBufferPoolClass {
  GstObjectClass    object_class;

  /*< public >*/
  const gchar ** (*get_options)    (GstBufferPool *pool);
  gboolean       (*set_config)     (GstBufferPool *pool, GstStructure *config);

  gboolean       (*start)          (GstBufferPool *pool);
  gboolean       (*stop)           (GstBufferPool *pool);

  GstFlowReturn  (*acquire_buffer) (GstBufferPool *pool, GstBuffer **buffer,
                                    GstBufferPoolAcquireParams *params);
  GstFlowReturn  (*alloc_buffer)   (GstBufferPool *pool, GstBuffer **buffer,
                                    GstBufferPoolAcquireParams *params);
  void           (*reset_buffer)   (GstBufferPool *pool, GstBuffer *buffer);
  void           (*release_buffer) (GstBufferPool *pool, GstBuffer *buffer);
  void           (*free_buffer)    (GstBufferPool *pool, GstBuffer *buffer);
  void           (*flush_start)    (GstBufferPool *pool);
  void           (*flush_stop)     (GstBufferPool *pool);

  /*< private >*/
  gpointer _gst_reserved[GST_PADDING - 2];
};

GType       gst_buffer_pool_get_type (void);

/* allocation */
GstBufferPool *  gst_buffer_pool_new  (void);

/* state management */
gboolean         gst_buffer_pool_set_active      (GstBufferPool *pool, gboolean active);
gboolean         gst_buffer_pool_is_active       (GstBufferPool *pool);

gboolean         gst_buffer_pool_set_config      (GstBufferPool *pool, GstStructure *config);
GstStructure *   gst_buffer_pool_get_config      (GstBufferPool *pool);

const gchar **   gst_buffer_pool_get_options     (GstBufferPool *pool);
gboolean         gst_buffer_pool_has_option      (GstBufferPool *pool, const gchar *option);

void             gst_buffer_pool_set_flushing    (GstBufferPool *pool, gboolean flushing);

/* helpers for configuring the config structure */
void             gst_buffer_pool_config_set_params    (GstStructure *config, GstCaps *caps,
                                                       guint size, guint min_buffers, guint max_buffers);
gboolean         gst_buffer_pool_config_get_params    (GstStructure *config, GstCaps **caps,
                                                       guint *size, guint *min_buffers, guint *max_buffers);
void             gst_buffer_pool_config_set_allocator (GstStructure *config, GstAllocator *allocator,
                                                       const GstAllocationParams *params);
gboolean         gst_buffer_pool_config_get_allocator (GstStructure *config, GstAllocator **allocator,
                                                       GstAllocationParams *params);

/* options */
guint            gst_buffer_pool_config_n_options   (GstStructure *config);
void             gst_buffer_pool_config_add_option  (GstStructure *config, const gchar *option);
const gchar *    gst_buffer_pool_config_get_option  (GstStructure *config, guint index);
gboolean         gst_buffer_pool_config_has_option  (GstStructure *config, const gchar *option);
gboolean         gst_buffer_pool_config_validate_params (GstStructure *config, GstCaps *caps,
                                                         guint size, guint min_buffers, guint max_buffers);

/* buffer management */
GstFlowReturn    gst_buffer_pool_acquire_buffer  (GstBufferPool *pool, GstBuffer **buffer,
                                                  GstBufferPoolAcquireParams *params);
void             gst_buffer_pool_release_buffer  (GstBufferPool *pool, GstBuffer *buffer);

G_END_DECLS

#endif /* __GST_BUFFER_POOL_H__ */
