/* GStreamer
 * Copyright (C) 2009 Wim Taymans <wim.taymans@gmail.com>
 *
 * gsttaskpool.c: Pool for streaming threads
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
 * SECTION:gsttaskpool
 * @short_description: Pool of GStreamer streaming threads
 * @see_also: #GstTask, #GstPad
 *
 * This object provides an abstraction for creating threads. The default
 * implementation uses a regular GThreadPool to start tasks.
 *
 * Subclasses can be made to create custom threads.
 */

#include "gst_private.h"

#include "gstinfo.h"
#include "gsttaskpool.h"

GST_DEBUG_CATEGORY_STATIC (taskpool_debug);
#define GST_CAT_DEFAULT (taskpool_debug)

#ifndef GST_DISABLE_GST_DEBUG
static void gst_task_pool_finalize (GObject * object);
#endif

#define _do_init \
{ \
  GST_DEBUG_CATEGORY_INIT (taskpool_debug, "taskpool", 0, "Thread pool"); \
}

G_DEFINE_TYPE_WITH_CODE (GstTaskPool, gst_task_pool, GST_TYPE_OBJECT, _do_init);

typedef struct
{
  GstTaskPoolFunction func;
  gpointer user_data;
} TaskData;

static void
default_func (TaskData * tdata, GstTaskPool * pool)
{
  GstTaskPoolFunction func;
  gpointer user_data;

  func = tdata->func;
  user_data = tdata->user_data;
  g_slice_free (TaskData, tdata);

  func (user_data);
}

static void
default_prepare (GstTaskPool * pool, GError ** error)
{
  GST_OBJECT_LOCK (pool);
  pool->pool = g_thread_pool_new ((GFunc) default_func, pool, -1, FALSE, NULL);
  GST_OBJECT_UNLOCK (pool);
}

static void
default_cleanup (GstTaskPool * pool)
{
  GST_OBJECT_LOCK (pool);
  if (pool->pool) {
    /* Shut down all the threads, we still process the ones scheduled
     * because the unref happens in the thread function.
     * Also wait for currently running ones to finish. */
    g_thread_pool_free (pool->pool, FALSE, TRUE);
    pool->pool = NULL;
  }
  GST_OBJECT_UNLOCK (pool);
}

static gpointer
default_push (GstTaskPool * pool, GstTaskPoolFunction func,
    gpointer user_data, GError ** error)
{
  TaskData *tdata;

  tdata = g_slice_new (TaskData);
  tdata->func = func;
  tdata->user_data = user_data;

  GST_OBJECT_LOCK (pool);
  if (pool->pool)
    g_thread_pool_push (pool->pool, tdata, error);
  else {
    g_slice_free (TaskData, tdata);
  }
  GST_OBJECT_UNLOCK (pool);

  return NULL;
}

static void
default_join (GstTaskPool * pool, gpointer id)
{
  /* we do nothing here, we can't join from the pools */
}

static void
gst_task_pool_class_init (GstTaskPoolClass * klass)
{
  GObjectClass *gobject_class;
  GstTaskPoolClass *gsttaskpool_class;

  gobject_class = (GObjectClass *) klass;
  gsttaskpool_class = (GstTaskPoolClass *) klass;

#ifndef GST_DISABLE_GST_DEBUG
  gobject_class->finalize = gst_task_pool_finalize;
#endif

  gsttaskpool_class->prepare = default_prepare;
  gsttaskpool_class->cleanup = default_cleanup;
  gsttaskpool_class->push = default_push;
  gsttaskpool_class->join = default_join;
}

static void
gst_task_pool_init (GstTaskPool * pool)
{
  /* clear floating flag */
  gst_object_ref_sink (pool);
}

#ifndef GST_DISABLE_GST_DEBUG
static void
gst_task_pool_finalize (GObject * object)
{
  GST_DEBUG ("taskpool %p finalize", object);

  G_OBJECT_CLASS (gst_task_pool_parent_class)->finalize (object);
}
#endif
/**
 * gst_task_pool_new:
 *
 * Create a new default task pool. The default task pool will use a regular
 * GThreadPool for threads.
 *
 * Returns: (transfer full): a new #GstTaskPool. gst_object_unref() after usage.
 */
GstTaskPool *
gst_task_pool_new (void)
{
  GstTaskPool *pool;

  pool = g_object_newv (GST_TYPE_TASK_POOL, 0, NULL);

  return pool;
}

/**
 * gst_task_pool_prepare:
 * @pool: a #GstTaskPool
 * @error: an error return location
 *
 * Prepare the taskpool for accepting gst_task_pool_push() operations.
 *
 * MT safe.
 */
void
gst_task_pool_prepare (GstTaskPool * pool, GError ** error)
{
  GstTaskPoolClass *klass;

  g_return_if_fail (GST_IS_TASK_POOL (pool));

  klass = GST_TASK_POOL_GET_CLASS (pool);

  if (klass->prepare)
    klass->prepare (pool, error);
}

/**
 * gst_task_pool_cleanup:
 * @pool: a #GstTaskPool
 *
 * Wait for all tasks to be stopped. This is mainly used internally
 * to ensure proper cleanup of internal data structures in test suites.
 *
 * MT safe.
 */
void
gst_task_pool_cleanup (GstTaskPool * pool)
{
  GstTaskPoolClass *klass;

  g_return_if_fail (GST_IS_TASK_POOL (pool));

  klass = GST_TASK_POOL_GET_CLASS (pool);

  if (klass->cleanup)
    klass->cleanup (pool);
}

/**
 * gst_task_pool_push:
 * @pool: a #GstTaskPool
 * @func: (scope async): the function to call
 * @user_data: (closure): data to pass to @func
 * @error: return location for an error
 *
 * Start the execution of a new thread from @pool.
 *
 * Returns: (transfer none) (nullable): a pointer that should be used
 * for the gst_task_pool_join function. This pointer can be %NULL, you
 * must check @error to detect errors.
 */
gpointer
gst_task_pool_push (GstTaskPool * pool, GstTaskPoolFunction func,
    gpointer user_data, GError ** error)
{
  GstTaskPoolClass *klass;

  g_return_val_if_fail (GST_IS_TASK_POOL (pool), NULL);

  klass = GST_TASK_POOL_GET_CLASS (pool);

  if (klass->push == NULL)
    goto not_supported;

  return klass->push (pool, func, user_data, error);

  /* ERRORS */
not_supported:
  {
    g_warning ("pushing tasks on pool %p is not supported", pool);
    return NULL;
  }
}

/**
 * gst_task_pool_join:
 * @pool: a #GstTaskPool
 * @id: the id
 *
 * Join a task and/or return it to the pool. @id is the id obtained from 
 * gst_task_pool_push().
 */
void
gst_task_pool_join (GstTaskPool * pool, gpointer id)
{
  GstTaskPoolClass *klass;

  g_return_if_fail (GST_IS_TASK_POOL (pool));

  klass = GST_TASK_POOL_GET_CLASS (pool);

  if (klass->join)
    klass->join (pool, id);
}
