/* GStreamer
 * Copyright (C) 2010 Wim Taymans <wim.taymans@gmail.com>
 *
 * gstbufferpool.c: GstBufferPool baseclass
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
 * SECTION:gstbufferpool
 * @short_description: Pool for buffers
 * @see_also: #GstBuffer
 *
 * A #GstBufferPool is an object that can be used to pre-allocate and recycle
 * buffers of the same size and with the same properties.
 *
 * A #GstBufferPool is created with gst_buffer_pool_new().
 *
 * Once a pool is created, it needs to be configured. A call to
 * gst_buffer_pool_get_config() returns the current configuration structure from
 * the pool. With gst_buffer_pool_config_set_params() and
 * gst_buffer_pool_config_set_allocator() the bufferpool parameters and
 * allocator can be configured. Other properties can be configured in the pool
 * depending on the pool implementation.
 *
 * A bufferpool can have extra options that can be enabled with
 * gst_buffer_pool_config_add_option(). The available options can be retrieved
 * with gst_buffer_pool_get_options(). Some options allow for additional
 * configuration properties to be set.
 *
 * After the configuration structure has been configured,
 * gst_buffer_pool_set_config() updates the configuration in the pool. This can
 * fail when the configuration structure is not accepted.
 *
 * After the a pool has been configured, it can be activated with
 * gst_buffer_pool_set_active(). This will preallocate the configured resources
 * in the pool.
 *
 * When the pool is active, gst_buffer_pool_acquire_buffer() can be used to
 * retrieve a buffer from the pool.
 *
 * Buffers allocated from a bufferpool will automatically be returned to the
 * pool with gst_buffer_pool_release_buffer() when their refcount drops to 0.
 *
 * The bufferpool can be deactivated again with gst_buffer_pool_set_active().
 * All further gst_buffer_pool_acquire_buffer() calls will return an error. When
 * all buffers are returned to the pool they will be freed.
 *
 * Use gst_object_unref() to release the reference to a bufferpool. If the
 * refcount of the pool reaches 0, the pool will be freed.
 */

#include "gst_private.h"
#include "glib-compat-private.h"

#include <errno.h>
#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif
#include <sys/types.h>

#include "gstatomicqueue.h"
#include "gstpoll.h"
#include "gstinfo.h"
#include "gstquark.h"
#include "gstvalue.h"

#include "gstbufferpool.h"

GST_DEBUG_CATEGORY_STATIC (gst_buffer_pool_debug);
#define GST_CAT_DEFAULT gst_buffer_pool_debug

#define GST_BUFFER_POOL_GET_PRIVATE(obj)  \
   (G_TYPE_INSTANCE_GET_PRIVATE ((obj), GST_TYPE_BUFFER_POOL, GstBufferPoolPrivate))

#define GST_BUFFER_POOL_LOCK(pool)   (g_rec_mutex_lock(&pool->priv->rec_lock))
#define GST_BUFFER_POOL_UNLOCK(pool) (g_rec_mutex_unlock(&pool->priv->rec_lock))

struct _GstBufferPoolPrivate
{
  GstAtomicQueue *queue;
  GstPoll *poll;

  GRecMutex rec_lock;

  gboolean started;
  gboolean active;
  gint outstanding;             /* number of buffers that are in use */

  gboolean configured;
  GstStructure *config;

  guint size;
  guint min_buffers;
  guint max_buffers;
  guint cur_buffers;
  GstAllocator *allocator;
  GstAllocationParams params;
};

static void gst_buffer_pool_finalize (GObject * object);

G_DEFINE_TYPE (GstBufferPool, gst_buffer_pool, GST_TYPE_OBJECT);

static gboolean default_start (GstBufferPool * pool);
static gboolean default_stop (GstBufferPool * pool);
static gboolean default_set_config (GstBufferPool * pool,
    GstStructure * config);
static GstFlowReturn default_alloc_buffer (GstBufferPool * pool,
    GstBuffer ** buffer, GstBufferPoolAcquireParams * params);
static GstFlowReturn default_acquire_buffer (GstBufferPool * pool,
    GstBuffer ** buffer, GstBufferPoolAcquireParams * params);
static void default_reset_buffer (GstBufferPool * pool, GstBuffer * buffer);
static void default_free_buffer (GstBufferPool * pool, GstBuffer * buffer);
static void default_release_buffer (GstBufferPool * pool, GstBuffer * buffer);

static void
gst_buffer_pool_class_init (GstBufferPoolClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;

  g_type_class_add_private (klass, sizeof (GstBufferPoolPrivate));

  gobject_class->finalize = gst_buffer_pool_finalize;

  klass->start = default_start;
  klass->stop = default_stop;
  klass->set_config = default_set_config;
  klass->acquire_buffer = default_acquire_buffer;
  klass->reset_buffer = default_reset_buffer;
  klass->alloc_buffer = default_alloc_buffer;
  klass->release_buffer = default_release_buffer;
  klass->free_buffer = default_free_buffer;

  GST_DEBUG_CATEGORY_INIT (gst_buffer_pool_debug, "bufferpool", 0,
      "bufferpool debug");
}

static void
gst_buffer_pool_init (GstBufferPool * pool)
{
  GstBufferPoolPrivate *priv;

  priv = pool->priv = GST_BUFFER_POOL_GET_PRIVATE (pool);

  g_rec_mutex_init (&priv->rec_lock);

  priv->poll = gst_poll_new_timer ();
  priv->queue = gst_atomic_queue_new (16);
  pool->flushing = 1;
  priv->active = FALSE;
  priv->configured = FALSE;
  priv->started = FALSE;
  priv->config = gst_structure_new_id_empty (GST_QUARK (BUFFER_POOL_CONFIG));
  gst_buffer_pool_config_set_params (priv->config, NULL, 0, 0, 0);
  priv->allocator = NULL;
  gst_allocation_params_init (&priv->params);
  gst_buffer_pool_config_set_allocator (priv->config, priv->allocator,
      &priv->params);
  /* 1 control write for flushing */
  gst_poll_write_control (priv->poll);
  /* 1 control write for marking that we are not waiting for poll */
  gst_poll_write_control (priv->poll);

  GST_DEBUG_OBJECT (pool, "created");
}

static void
gst_buffer_pool_finalize (GObject * object)
{
  GstBufferPool *pool;
  GstBufferPoolPrivate *priv;

  pool = GST_BUFFER_POOL_CAST (object);
  priv = pool->priv;

  GST_DEBUG_OBJECT (pool, "finalize");

  gst_buffer_pool_set_active (pool, FALSE);
  gst_atomic_queue_unref (priv->queue);
  gst_poll_free (priv->poll);
  gst_structure_free (priv->config);
  g_rec_mutex_clear (&priv->rec_lock);
  if (priv->allocator)
    gst_object_unref (priv->allocator);

  G_OBJECT_CLASS (gst_buffer_pool_parent_class)->finalize (object);
}

/**
 * gst_buffer_pool_new:
 *
 * Creates a new #GstBufferPool instance.
 *
 * Returns: (transfer floating): a new #GstBufferPool instance
 */
GstBufferPool *
gst_buffer_pool_new (void)
{
  GstBufferPool *result;

  result = g_object_newv (GST_TYPE_BUFFER_POOL, 0, NULL);
  GST_DEBUG_OBJECT (result, "created new buffer pool");

  return result;
}

static GstFlowReturn
default_alloc_buffer (GstBufferPool * pool, GstBuffer ** buffer,
    GstBufferPoolAcquireParams * params)
{
  GstBufferPoolPrivate *priv = pool->priv;

  *buffer =
      gst_buffer_new_allocate (priv->allocator, priv->size, &priv->params);

  if (!*buffer)
    return GST_FLOW_ERROR;

  return GST_FLOW_OK;
}

static gboolean
mark_meta_pooled (GstBuffer * buffer, GstMeta ** meta, gpointer user_data)
{
  GstBufferPool *pool = user_data;

  GST_DEBUG_OBJECT (pool, "marking meta %p as POOLED in buffer %p", *meta,
      buffer);
  GST_META_FLAG_SET (*meta, GST_META_FLAG_POOLED);
  GST_META_FLAG_SET (*meta, GST_META_FLAG_LOCKED);

  return TRUE;
}

static GstFlowReturn
do_alloc_buffer (GstBufferPool * pool, GstBuffer ** buffer,
    GstBufferPoolAcquireParams * params)
{
  GstBufferPoolPrivate *priv = pool->priv;
  GstFlowReturn result;
  gint cur_buffers, max_buffers;
  GstBufferPoolClass *pclass;

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  if (G_UNLIKELY (!pclass->alloc_buffer))
    goto no_function;

  max_buffers = priv->max_buffers;

  /* increment the allocation counter */
  cur_buffers = g_atomic_int_add (&priv->cur_buffers, 1);
  if (max_buffers && cur_buffers >= max_buffers)
    goto max_reached;

  result = pclass->alloc_buffer (pool, buffer, params);
  if (G_UNLIKELY (result != GST_FLOW_OK))
    goto alloc_failed;

  /* lock all metadata and mark as pooled, we want this to remain on
   * the buffer and we want to remove any other metadata that gets added
   * later */
  gst_buffer_foreach_meta (*buffer, mark_meta_pooled, pool);

  /* un-tag memory, this is how we expect the buffer when it is
   * released again */
  GST_BUFFER_FLAG_UNSET (*buffer, GST_BUFFER_FLAG_TAG_MEMORY);

  GST_LOG_OBJECT (pool, "allocated buffer %d/%d, %p", cur_buffers,
      max_buffers, *buffer);

  return result;

  /* ERRORS */
no_function:
  {
    GST_ERROR_OBJECT (pool, "no alloc function");
    return GST_FLOW_NOT_SUPPORTED;
  }
max_reached:
  {
    GST_DEBUG_OBJECT (pool, "max buffers reached");
    g_atomic_int_add (&priv->cur_buffers, -1);
    return GST_FLOW_EOS;
  }
alloc_failed:
  {
    GST_WARNING_OBJECT (pool, "alloc function failed");
    g_atomic_int_add (&priv->cur_buffers, -1);
    return result;
  }
}

/* the default implementation for preallocating the buffers in the pool */
static gboolean
default_start (GstBufferPool * pool)
{
  guint i;
  GstBufferPoolPrivate *priv = pool->priv;
  GstBufferPoolClass *pclass;

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  /* we need to prealloc buffers */
  for (i = 0; i < priv->min_buffers; i++) {
    GstBuffer *buffer;

    if (do_alloc_buffer (pool, &buffer, NULL) != GST_FLOW_OK)
      goto alloc_failed;

    /* release to the queue, we call the vmethod directly, we don't need to do
     * the other refcount handling right now. */
    if (G_LIKELY (pclass->release_buffer))
      pclass->release_buffer (pool, buffer);
  }
  return TRUE;

  /* ERRORS */
alloc_failed:
  {
    GST_WARNING_OBJECT (pool, "failed to allocate buffer");
    return FALSE;
  }
}

/* must be called with the lock */
static gboolean
do_start (GstBufferPool * pool)
{
  GstBufferPoolPrivate *priv = pool->priv;

  if (!priv->started) {
    GstBufferPoolClass *pclass;

    pclass = GST_BUFFER_POOL_GET_CLASS (pool);

    GST_LOG_OBJECT (pool, "starting");
    /* start the pool, subclasses should allocate buffers and put them
     * in the queue */
    if (G_LIKELY (pclass->start)) {
      if (!pclass->start (pool))
        return FALSE;
    }
    priv->started = TRUE;
  }
  return TRUE;
}

static void
default_free_buffer (GstBufferPool * pool, GstBuffer * buffer)
{
  gst_buffer_unref (buffer);
}

static void
do_free_buffer (GstBufferPool * pool, GstBuffer * buffer)
{
  GstBufferPoolPrivate *priv;
  GstBufferPoolClass *pclass;

  priv = pool->priv;
  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  g_atomic_int_add (&priv->cur_buffers, -1);
  GST_LOG_OBJECT (pool, "freeing buffer %p (%u left)", buffer,
      priv->cur_buffers);

  if (G_LIKELY (pclass->free_buffer))
    pclass->free_buffer (pool, buffer);
}

/* must be called with the lock */
static gboolean
default_stop (GstBufferPool * pool)
{
  GstBufferPoolPrivate *priv = pool->priv;
  GstBuffer *buffer;

  /* clear the pool */
  while ((buffer = gst_atomic_queue_pop (priv->queue))) {
    gst_poll_read_control (priv->poll);
    do_free_buffer (pool, buffer);
  }
  return priv->cur_buffers == 0;
}

/* must be called with the lock */
static gboolean
do_stop (GstBufferPool * pool)
{
  GstBufferPoolPrivate *priv = pool->priv;

  if (priv->started) {
    GstBufferPoolClass *pclass;

    pclass = GST_BUFFER_POOL_GET_CLASS (pool);

    GST_LOG_OBJECT (pool, "stopping");
    if (G_LIKELY (pclass->stop)) {
      if (!pclass->stop (pool))
        return FALSE;
    }
    priv->started = FALSE;
  }
  return TRUE;
}

/* must be called with the lock */
static void
do_set_flushing (GstBufferPool * pool, gboolean flushing)
{
  GstBufferPoolPrivate *priv = pool->priv;
  GstBufferPoolClass *pclass;

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  if (GST_BUFFER_POOL_IS_FLUSHING (pool) == flushing)
    return;

  if (flushing) {
    g_atomic_int_set (&pool->flushing, 1);
    gst_poll_write_control (priv->poll);

    if (pclass->flush_start)
      pclass->flush_start (pool);
  } else {
    if (pclass->flush_stop)
      pclass->flush_stop (pool);

    gst_poll_read_control (priv->poll);
    g_atomic_int_set (&pool->flushing, 0);
  }
}

/**
 * gst_buffer_pool_set_active:
 * @pool: a #GstBufferPool
 * @active: the new active state
 *
 * Control the active state of @pool. When the pool is inactive, new calls to
 * gst_buffer_pool_acquire_buffer() will return with %GST_FLOW_FLUSHING.
 *
 * Activating the bufferpool will preallocate all resources in the pool based on
 * the configuration of the pool.
 *
 * Deactivating will free the resources again when there are no outstanding
 * buffers. When there are outstanding buffers, they will be freed as soon as
 * they are all returned to the pool.
 *
 * Returns: %FALSE when the pool was not configured or when preallocation of the
 * buffers failed.
 */
gboolean
gst_buffer_pool_set_active (GstBufferPool * pool, gboolean active)
{
  gboolean res = TRUE;
  GstBufferPoolPrivate *priv;

  g_return_val_if_fail (GST_IS_BUFFER_POOL (pool), FALSE);

  GST_LOG_OBJECT (pool, "active %d", active);

  priv = pool->priv;

  GST_BUFFER_POOL_LOCK (pool);
  /* just return if we are already in the right state */
  if (priv->active == active)
    goto was_ok;

  /* we need to be configured */
  if (!priv->configured)
    goto not_configured;

  if (active) {
    if (!do_start (pool))
      goto start_failed;

    /* flush_stop my release buffers, setting to active to avoid running
     * do_stop while activating the pool */
    priv->active = TRUE;

    /* unset the flushing state now */
    do_set_flushing (pool, FALSE);
  } else {
    gint outstanding;

    /* set to flushing first */
    do_set_flushing (pool, TRUE);

    /* when all buffers are in the pool, free them. Else they will be
     * freed when they are released */
    outstanding = g_atomic_int_get (&priv->outstanding);
    GST_LOG_OBJECT (pool, "outstanding buffers %d", outstanding);
    if (outstanding == 0) {
      if (!do_stop (pool))
        goto stop_failed;
    }

    priv->active = FALSE;
  }
  GST_BUFFER_POOL_UNLOCK (pool);

  return res;

was_ok:
  {
    GST_DEBUG_OBJECT (pool, "pool was in the right state");
    GST_BUFFER_POOL_UNLOCK (pool);
    return TRUE;
  }
not_configured:
  {
    GST_ERROR_OBJECT (pool, "pool was not configured");
    GST_BUFFER_POOL_UNLOCK (pool);
    return FALSE;
  }
start_failed:
  {
    GST_ERROR_OBJECT (pool, "start failed");
    GST_BUFFER_POOL_UNLOCK (pool);
    return FALSE;
  }
stop_failed:
  {
    GST_WARNING_OBJECT (pool, "stop failed");
    GST_BUFFER_POOL_UNLOCK (pool);
    return FALSE;
  }
}

/**
 * gst_buffer_pool_is_active:
 * @pool: a #GstBufferPool
 *
 * Check if @pool is active. A pool can be activated with the
 * gst_buffer_pool_set_active() call.
 *
 * Returns: %TRUE when the pool is active.
 */
gboolean
gst_buffer_pool_is_active (GstBufferPool * pool)
{
  gboolean res;

  GST_BUFFER_POOL_LOCK (pool);
  res = pool->priv->active;
  GST_BUFFER_POOL_UNLOCK (pool);

  return res;
}

static gboolean
default_set_config (GstBufferPool * pool, GstStructure * config)
{
  GstBufferPoolPrivate *priv = pool->priv;
  GstCaps *caps;
  guint size, min_buffers, max_buffers;
  GstAllocator *allocator;
  GstAllocationParams params;

  /* parse the config and keep around */
  if (!gst_buffer_pool_config_get_params (config, &caps, &size, &min_buffers,
          &max_buffers))
    goto wrong_config;

  if (!gst_buffer_pool_config_get_allocator (config, &allocator, &params))
    goto wrong_config;

  GST_DEBUG_OBJECT (pool, "config %" GST_PTR_FORMAT, config);

  priv->size = size;
  priv->min_buffers = min_buffers;
  priv->max_buffers = max_buffers;
  priv->cur_buffers = 0;

  if (priv->allocator)
    gst_object_unref (priv->allocator);
  if ((priv->allocator = allocator))
    gst_object_ref (allocator);
  priv->params = params;

  return TRUE;

wrong_config:
  {
    GST_WARNING_OBJECT (pool, "invalid config %" GST_PTR_FORMAT, config);
    return FALSE;
  }
}

/**
 * gst_buffer_pool_set_config:
 * @pool: a #GstBufferPool
 * @config: (transfer full): a #GstStructure
 *
 * Set the configuration of the pool. If the pool is already configured, and
 * the configuration haven't change, this function will return %TRUE. If the
 * pool is active, this function will try deactivating it. Buffers allocated
 * form this pool must be returned or else this function will do nothing and
 * return %FALSE.
 *
 * @config is a #GstStructure that contains the configuration parameters for
 * the pool. A default and mandatory set of parameters can be configured with
 * gst_buffer_pool_config_set_params(), gst_buffer_pool_config_set_allocator()
 * and gst_buffer_pool_config_add_option().
 *
 * If the parameters in @config can not be set exactly, this function returns
 * %FALSE and will try to update as much state as possible. The new state can
 * then be retrieved and refined with gst_buffer_pool_get_config().
 *
 * This function takes ownership of @config.
 *
 * Returns: %TRUE when the configuration could be set.
 */
gboolean
gst_buffer_pool_set_config (GstBufferPool * pool, GstStructure * config)
{
  gboolean result;
  GstBufferPoolClass *pclass;
  GstBufferPoolPrivate *priv;

  g_return_val_if_fail (GST_IS_BUFFER_POOL (pool), FALSE);
  g_return_val_if_fail (config != NULL, FALSE);

  priv = pool->priv;

  GST_BUFFER_POOL_LOCK (pool);

  /* nothing to do if config is unchanged */
  if (priv->configured && gst_structure_is_equal (config, priv->config))
    goto config_unchanged;

  /* can't change the settings when active */
  if (priv->active) {
    GST_BUFFER_POOL_UNLOCK (pool);
    if (!gst_buffer_pool_set_active (pool, FALSE)) {
      GST_BUFFER_POOL_LOCK (pool);
      goto was_active;
    }
    GST_BUFFER_POOL_LOCK (pool);

    /* not likely but as we released the lock */
    if (priv->active)
      goto was_active;
  }

  /* we can't change when outstanding buffers */
  if (g_atomic_int_get (&priv->outstanding) != 0)
    goto have_outstanding;

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  /* set the new config */
  if (G_LIKELY (pclass->set_config))
    result = pclass->set_config (pool, config);
  else
    result = FALSE;

  /* save the config regardless of the result so user can read back the
   * modified config and evaluate if the changes are acceptable */
  if (priv->config)
    gst_structure_free (priv->config);
  priv->config = config;

  if (result) {
    /* now we are configured */
    priv->configured = TRUE;
  }
  GST_BUFFER_POOL_UNLOCK (pool);

  return result;

config_unchanged:
  {
    gst_structure_free (config);
    GST_BUFFER_POOL_UNLOCK (pool);
    return TRUE;
  }
  /* ERRORS */
was_active:
  {
    gst_structure_free (config);
    GST_WARNING_OBJECT (pool, "can't change config, we are active");
    GST_BUFFER_POOL_UNLOCK (pool);
    return FALSE;
  }
have_outstanding:
  {
    gst_structure_free (config);
    GST_WARNING_OBJECT (pool, "can't change config, have outstanding buffers");
    GST_BUFFER_POOL_UNLOCK (pool);
    return FALSE;
  }
}

/**
 * gst_buffer_pool_get_config:
 * @pool: a #GstBufferPool
 *
 * Get a copy of the current configuration of the pool. This configuration
 * can either be modified and used for the gst_buffer_pool_set_config() call
 * or it must be freed after usage.
 *
 * Returns: (transfer full): a copy of the current configuration of @pool. use
 * gst_structure_free() after usage or gst_buffer_pool_set_config().
 */
GstStructure *
gst_buffer_pool_get_config (GstBufferPool * pool)
{
  GstStructure *result;

  g_return_val_if_fail (GST_IS_BUFFER_POOL (pool), NULL);

  GST_BUFFER_POOL_LOCK (pool);
  result = gst_structure_copy (pool->priv->config);
  GST_BUFFER_POOL_UNLOCK (pool);

  return result;
}

static const gchar *empty_option[] = { NULL };

/**
 * gst_buffer_pool_get_options:
 * @pool: a #GstBufferPool
 *
 * Get a %NULL terminated array of string with supported bufferpool options for
 * @pool. An option would typically be enabled with
 * gst_buffer_pool_config_add_option().
 *
 * Returns: (array zero-terminated=1) (transfer none): a %NULL terminated array
 *          of strings.
 */
const gchar **
gst_buffer_pool_get_options (GstBufferPool * pool)
{
  GstBufferPoolClass *pclass;
  const gchar **result;

  g_return_val_if_fail (GST_IS_BUFFER_POOL (pool), NULL);

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  if (G_LIKELY (pclass->get_options)) {
    if ((result = pclass->get_options (pool)) == NULL)
      goto invalid_result;
  } else
    result = empty_option;

  return result;

  /* ERROR */
invalid_result:
  {
    g_warning ("bufferpool subclass returned NULL options");
    return empty_option;
  }
}

/**
 * gst_buffer_pool_has_option:
 * @pool: a #GstBufferPool
 * @option: an option
 *
 * Check if the bufferpool supports @option.
 *
 * Returns: %TRUE if the buffer pool contains @option.
 */
gboolean
gst_buffer_pool_has_option (GstBufferPool * pool, const gchar * option)
{
  guint i;
  const gchar **options;

  g_return_val_if_fail (GST_IS_BUFFER_POOL (pool), FALSE);
  g_return_val_if_fail (option != NULL, FALSE);

  options = gst_buffer_pool_get_options (pool);

  for (i = 0; options[i]; i++) {
    if (g_str_equal (options[i], option))
      return TRUE;
  }
  return FALSE;
}

/**
 * gst_buffer_pool_config_set_params:
 * @config: a #GstBufferPool configuration
 * @caps: caps for the buffers
 * @size: the size of each buffer, not including prefix and padding
 * @min_buffers: the minimum amount of buffers to allocate.
 * @max_buffers: the maximum amount of buffers to allocate or 0 for unlimited.
 *
 * Configure @config with the given parameters.
 */
void
gst_buffer_pool_config_set_params (GstStructure * config, GstCaps * caps,
    guint size, guint min_buffers, guint max_buffers)
{
  g_return_if_fail (config != NULL);
  g_return_if_fail (max_buffers == 0 || min_buffers <= max_buffers);
  g_return_if_fail (caps == NULL || gst_caps_is_fixed (caps));

  gst_structure_id_set (config,
      GST_QUARK (CAPS), GST_TYPE_CAPS, caps,
      GST_QUARK (SIZE), G_TYPE_UINT, size,
      GST_QUARK (MIN_BUFFERS), G_TYPE_UINT, min_buffers,
      GST_QUARK (MAX_BUFFERS), G_TYPE_UINT, max_buffers, NULL);
}

/**
 * gst_buffer_pool_config_set_allocator:
 * @config: a #GstBufferPool configuration
 * @allocator: (allow-none): a #GstAllocator
 * @params: (allow-none): #GstAllocationParams
 *
 * Set the @allocator and @params on @config.
 *
 * One of @allocator and @params can be %NULL, but not both. When @allocator
 * is %NULL, the default allocator of the pool will use the values in @param
 * to perform its allocation. When @param is %NULL, the pool will use the
 * provided @allocator with its default #GstAllocationParams.
 *
 * A call to gst_buffer_pool_set_config() can update the allocator and params
 * with the values that it is able to do. Some pools are, for example, not able
 * to operate with different allocators or cannot allocate with the values
 * specified in @params. Use gst_buffer_pool_get_config() to get the currently
 * used values.
 */
void
gst_buffer_pool_config_set_allocator (GstStructure * config,
    GstAllocator * allocator, const GstAllocationParams * params)
{
  g_return_if_fail (config != NULL);
  g_return_if_fail (allocator != NULL || params != NULL);

  gst_structure_id_set (config,
      GST_QUARK (ALLOCATOR), GST_TYPE_ALLOCATOR, allocator,
      GST_QUARK (PARAMS), GST_TYPE_ALLOCATION_PARAMS, params, NULL);
}

/**
 * gst_buffer_pool_config_add_option:
 * @config: a #GstBufferPool configuration
 * @option: an option to add
 *
 * Enabled the option in @config. This will instruct the @bufferpool to enable
 * the specified option on the buffers that it allocates.
 *
 * The supported options by @pool can be retrieved with gst_buffer_pool_get_options().
 */
void
gst_buffer_pool_config_add_option (GstStructure * config, const gchar * option)
{
  const GValue *value;
  GValue option_value = { 0, };
  guint i, len;

  g_return_if_fail (config != NULL);

  value = gst_structure_id_get_value (config, GST_QUARK (OPTIONS));
  if (value) {
    len = gst_value_array_get_size (value);
    for (i = 0; i < len; ++i) {
      const GValue *nth_val = gst_value_array_get_value (value, i);

      if (g_str_equal (option, g_value_get_string (nth_val)))
        return;
    }
  } else {
    GValue new_array_val = { 0, };

    g_value_init (&new_array_val, GST_TYPE_ARRAY);
    gst_structure_id_take_value (config, GST_QUARK (OPTIONS), &new_array_val);
    value = gst_structure_id_get_value (config, GST_QUARK (OPTIONS));
  }
  g_value_init (&option_value, G_TYPE_STRING);
  g_value_set_string (&option_value, option);
  gst_value_array_append_and_take_value ((GValue *) value, &option_value);
}

/**
 * gst_buffer_pool_config_n_options:
 * @config: a #GstBufferPool configuration
 *
 * Retrieve the number of values currently stored in the options array of the
 * @config structure.
 *
 * Returns: the options array size as a #guint.
 */
guint
gst_buffer_pool_config_n_options (GstStructure * config)
{
  const GValue *value;
  guint size = 0;

  g_return_val_if_fail (config != NULL, 0);

  value = gst_structure_id_get_value (config, GST_QUARK (OPTIONS));
  if (value) {
    size = gst_value_array_get_size (value);
  }
  return size;
}

/**
 * gst_buffer_pool_config_get_option:
 * @config: a #GstBufferPool configuration
 * @index: position in the option array to read
 *
 * Parse an available @config and get the option at @index of the options API
 * array.
 *
 * Returns: a #gchar of the option at @index.
 */
const gchar *
gst_buffer_pool_config_get_option (GstStructure * config, guint index)
{
  const GValue *value;
  const gchar *ret = NULL;

  g_return_val_if_fail (config != NULL, 0);

  value = gst_structure_id_get_value (config, GST_QUARK (OPTIONS));
  if (value) {
    const GValue *option_value;

    option_value = gst_value_array_get_value (value, index);
    if (option_value)
      ret = g_value_get_string (option_value);
  }
  return ret;
}

/**
 * gst_buffer_pool_config_has_option:
 * @config: a #GstBufferPool configuration
 * @option: an option
 *
 * Check if @config contains @option.
 *
 * Returns: %TRUE if the options array contains @option.
 */
gboolean
gst_buffer_pool_config_has_option (GstStructure * config, const gchar * option)
{
  const GValue *value;
  guint i, len;

  g_return_val_if_fail (config != NULL, 0);

  value = gst_structure_id_get_value (config, GST_QUARK (OPTIONS));
  if (value) {
    len = gst_value_array_get_size (value);
    for (i = 0; i < len; ++i) {
      const GValue *nth_val = gst_value_array_get_value (value, i);

      if (g_str_equal (option, g_value_get_string (nth_val)))
        return TRUE;
    }
  }
  return FALSE;
}

/**
 * gst_buffer_pool_config_get_params:
 * @config: (transfer none): a #GstBufferPool configuration
 * @caps: (out) (transfer none) (allow-none): the caps of buffers
 * @size: (out) (allow-none): the size of each buffer, not including prefix and padding
 * @min_buffers: (out) (allow-none): the minimum amount of buffers to allocate.
 * @max_buffers: (out) (allow-none): the maximum amount of buffers to allocate or 0 for unlimited.
 *
 * Get the configuration values from @config.
 *
 * Returns: %TRUE if all parameters could be fetched.
 */
gboolean
gst_buffer_pool_config_get_params (GstStructure * config, GstCaps ** caps,
    guint * size, guint * min_buffers, guint * max_buffers)
{
  g_return_val_if_fail (config != NULL, FALSE);

  if (caps) {
    *caps = g_value_get_boxed (gst_structure_id_get_value (config,
            GST_QUARK (CAPS)));
  }
  return gst_structure_id_get (config,
      GST_QUARK (SIZE), G_TYPE_UINT, size,
      GST_QUARK (MIN_BUFFERS), G_TYPE_UINT, min_buffers,
      GST_QUARK (MAX_BUFFERS), G_TYPE_UINT, max_buffers, NULL);
}

/**
 * gst_buffer_pool_config_get_allocator:
 * @config: (transfer none): a #GstBufferPool configuration
 * @allocator: (transfer none): a #GstAllocator
 * @params: #GstAllocationParams
 *
 * Get the @allocator and @params from @config.
 *
 * Returns: %TRUE, if the values are set. 
 */
gboolean
gst_buffer_pool_config_get_allocator (GstStructure * config,
    GstAllocator ** allocator, GstAllocationParams * params)
{
  g_return_val_if_fail (config != NULL, FALSE);

  if (allocator)
    *allocator = g_value_get_object (gst_structure_id_get_value (config,
            GST_QUARK (ALLOCATOR)));
  if (params) {
    GstAllocationParams *p;

    p = g_value_get_boxed (gst_structure_id_get_value (config,
            GST_QUARK (PARAMS)));
    if (p) {
      *params = *p;
    } else {
      gst_allocation_params_init (params);
    }
  }
  return TRUE;
}

/**
 * gst_buffer_pool_config_validate_params:
 * @config: (transfer none): a #GstBufferPool configuration
 * @caps: (transfer none): the excepted caps of buffers
 * @size: the expected size of each buffer, not including prefix and padding
 * @min_buffers: the expected minimum amount of buffers to allocate.
 * @max_buffers: the expect maximum amount of buffers to allocate or 0 for unlimited.
 *
 * Validate that changes made to @config are still valid in the context of the
 * expected parameters. This function is a helper that can be used to validate
 * changes made by a pool to a config when gst_buffer_pool_set_config()
 * returns %FALSE. This expects that @caps and @size haven't changed, and that
 * @min_buffers aren't lower then what we initially expected. This does not check
 * if options or allocator parameters.
 *
 * Since: 1.4
 *
 * Returns: %TRUE, if the parameters are valid in this context.
 */
gboolean
gst_buffer_pool_config_validate_params (GstStructure * config, GstCaps * caps,
    guint size, guint min_buffers, G_GNUC_UNUSED guint max_buffers)
{
  GstCaps *newcaps;
  guint newsize, newmin;
  gboolean ret = FALSE;

  g_return_val_if_fail (config != NULL, FALSE);

  gst_buffer_pool_config_get_params (config, &newcaps, &newsize, &newmin, NULL);

  if (gst_caps_is_equal (caps, newcaps) && (size == newsize)
      && (newmin >= min_buffers))
    ret = TRUE;

  return ret;
}

static GstFlowReturn
default_acquire_buffer (GstBufferPool * pool, GstBuffer ** buffer,
    GstBufferPoolAcquireParams * params)
{
  GstFlowReturn result;
  GstBufferPoolPrivate *priv = pool->priv;

  while (TRUE) {
    if (G_UNLIKELY (GST_BUFFER_POOL_IS_FLUSHING (pool)))
      goto flushing;

    /* try to get a buffer from the queue */
    *buffer = gst_atomic_queue_pop (priv->queue);
    if (G_LIKELY (*buffer)) {
      gst_poll_read_control (priv->poll);
      result = GST_FLOW_OK;
      GST_LOG_OBJECT (pool, "acquired buffer %p", *buffer);
      break;
    }

    /* no buffer, try to allocate some more */
    GST_LOG_OBJECT (pool, "no buffer, trying to allocate");
    result = do_alloc_buffer (pool, buffer, NULL);
    if (G_LIKELY (result == GST_FLOW_OK))
      /* we have a buffer, return it */
      break;

    if (G_UNLIKELY (result != GST_FLOW_EOS))
      /* something went wrong, return error */
      break;

    /* check if we need to wait */
    if (params && (params->flags & GST_BUFFER_POOL_ACQUIRE_FLAG_DONTWAIT)) {
      GST_LOG_OBJECT (pool, "no more buffers");
      break;
    }

    /* now we release the control socket, we wait for a buffer release or
     * flushing */
    gst_poll_read_control (pool->priv->poll);
    GST_LOG_OBJECT (pool, "waiting for free buffers or flushing");
    gst_poll_wait (priv->poll, GST_CLOCK_TIME_NONE);
    gst_poll_write_control (pool->priv->poll);
  }

  return result;

  /* ERRORS */
flushing:
  {
    GST_DEBUG_OBJECT (pool, "we are flushing");
    return GST_FLOW_FLUSHING;
  }
}

static inline void
dec_outstanding (GstBufferPool * pool)
{
  if (g_atomic_int_dec_and_test (&pool->priv->outstanding)) {
    /* all buffers are returned to the pool, see if we need to free them */
    if (GST_BUFFER_POOL_IS_FLUSHING (pool)) {
      /* take the lock so that set_active is not run concurrently */
      GST_BUFFER_POOL_LOCK (pool);
      /* now that we have the lock, check if we have been de-activated with
       * outstanding buffers */
      if (!pool->priv->active)
        do_stop (pool);

      GST_BUFFER_POOL_UNLOCK (pool);
    }
  }
}

static gboolean
remove_meta_unpooled (GstBuffer * buffer, GstMeta ** meta, gpointer user_data)
{
  if (!GST_META_FLAG_IS_SET (*meta, GST_META_FLAG_POOLED)) {
    GST_META_FLAG_UNSET (*meta, GST_META_FLAG_LOCKED);
    *meta = NULL;
  }
  return TRUE;
}

static void
default_reset_buffer (GstBufferPool * pool, GstBuffer * buffer)
{
  GST_BUFFER_FLAGS (buffer) &= GST_BUFFER_FLAG_TAG_MEMORY;

  GST_BUFFER_PTS (buffer) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_DTS (buffer) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_DURATION (buffer) = GST_CLOCK_TIME_NONE;
  GST_BUFFER_OFFSET (buffer) = GST_BUFFER_OFFSET_NONE;
  GST_BUFFER_OFFSET_END (buffer) = GST_BUFFER_OFFSET_NONE;

  /* remove all metadata without the POOLED flag */
  gst_buffer_foreach_meta (buffer, remove_meta_unpooled, pool);
}

/**
 * gst_buffer_pool_acquire_buffer:
 * @pool: a #GstBufferPool
 * @buffer: (out): a location for a #GstBuffer
 * @params: (transfer none) (allow-none): parameters.
 *
 * Acquire a buffer from @pool. @buffer should point to a memory location that
 * can hold a pointer to the new buffer.
 *
 * @params can be %NULL or contain optional parameters to influence the
 * allocation.
 *
 * Returns: a #GstFlowReturn such as %GST_FLOW_FLUSHING when the pool is
 * inactive.
 */
GstFlowReturn
gst_buffer_pool_acquire_buffer (GstBufferPool * pool, GstBuffer ** buffer,
    GstBufferPoolAcquireParams * params)
{
  GstBufferPoolClass *pclass;
  GstFlowReturn result;

  g_return_val_if_fail (GST_IS_BUFFER_POOL (pool), GST_FLOW_ERROR);
  g_return_val_if_fail (buffer != NULL, GST_FLOW_ERROR);

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  /* assume we'll have one more outstanding buffer we need to do that so
   * that concurrent set_active doesn't clear the buffers */
  g_atomic_int_inc (&pool->priv->outstanding);

  if (G_LIKELY (pclass->acquire_buffer))
    result = pclass->acquire_buffer (pool, buffer, params);
  else
    result = GST_FLOW_NOT_SUPPORTED;

  if (G_LIKELY (result == GST_FLOW_OK)) {
    /* all buffers from the pool point to the pool and have the refcount of the
     * pool incremented */
    (*buffer)->pool = gst_object_ref (pool);
  } else {
    dec_outstanding (pool);
  }

  return result;
}

static void
default_release_buffer (GstBufferPool * pool, GstBuffer * buffer)
{
  GST_LOG_OBJECT (pool, "released buffer %p %d", buffer,
      GST_MINI_OBJECT_FLAGS (buffer));

  /* memory should be untouched */
  if (GST_BUFFER_FLAG_IS_SET (buffer, GST_BUFFER_FLAG_TAG_MEMORY))
    goto discard;

  /* size should have been reset. This is not a catch all, pool with
   * size requirement per memory should do their own check. */
  if (gst_buffer_get_size (buffer) != pool->priv->size)
    goto discard;

  /* all memory should be exclusive to this buffer (and thus be writable) */
  if (!gst_buffer_is_all_memory_writable (buffer))
    goto discard;

  /* keep it around in our queue */
  gst_atomic_queue_push (pool->priv->queue, buffer);
  gst_poll_write_control (pool->priv->poll);

  return;

discard:
  {
    do_free_buffer (pool, buffer);
    return;
  }
}

/**
 * gst_buffer_pool_release_buffer:
 * @pool: a #GstBufferPool
 * @buffer: (transfer full): a #GstBuffer
 *
 * Release @buffer to @pool. @buffer should have previously been allocated from
 * @pool with gst_buffer_pool_acquire_buffer().
 *
 * This function is usually called automatically when the last ref on @buffer
 * disappears.
 */
void
gst_buffer_pool_release_buffer (GstBufferPool * pool, GstBuffer * buffer)
{
  GstBufferPoolClass *pclass;

  g_return_if_fail (GST_IS_BUFFER_POOL (pool));
  g_return_if_fail (buffer != NULL);

  /* check that the buffer is ours, all buffers returned to the pool have the
   * pool member set to NULL and the pool refcount decreased */
  if (!g_atomic_pointer_compare_and_exchange (&buffer->pool, pool, NULL))
    return;

  pclass = GST_BUFFER_POOL_GET_CLASS (pool);

  /* reset the buffer when needed */
  if (G_LIKELY (pclass->reset_buffer))
    pclass->reset_buffer (pool, buffer);

  if (G_LIKELY (pclass->release_buffer))
    pclass->release_buffer (pool, buffer);

  dec_outstanding (pool);

  /* decrease the refcount that the buffer had to us */
  gst_object_unref (pool);
}

/**
 * gst_buffer_pool_set_flushing:
 * @pool: a #GstBufferPool
 * @flushing: whether to start or stop flushing
 *
 * Enable or disable the flushing state of a @pool without freeing or
 * allocating buffers.
 *
 * Since: 1.4
 */
void
gst_buffer_pool_set_flushing (GstBufferPool * pool, gboolean flushing)
{
  GstBufferPoolPrivate *priv;

  g_return_if_fail (GST_IS_BUFFER_POOL (pool));

  GST_LOG_OBJECT (pool, "flushing %d", flushing);

  priv = pool->priv;

  GST_BUFFER_POOL_LOCK (pool);

  if (!priv->active) {
    GST_WARNING_OBJECT (pool, "can't change flushing state of inactive pool");
    goto done;
  }

  do_set_flushing (pool, flushing);

done:
  GST_BUFFER_POOL_UNLOCK (pool);
}
