/* GStreamer
 * Copyright (C) 2004 Wim Taymans <wim@fluendo.com>
 * Copyright (C) 2011 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 *
 * gstiterator.h: Base class for iterating datastructures.
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
 * SECTION:gstiterator
 * @short_description: Object to retrieve multiple elements in a threadsafe
 * way.
 * @see_also: #GstElement, #GstBin
 *
 * A GstIterator is used to retrieve multiple objects from another object in
 * a threadsafe way.
 *
 * Various GStreamer objects provide access to their internal structures using
 * an iterator.
 *
 * In general, whenever calling a GstIterator function results in your code
 * receiving a refcounted object, the refcount for that object will have been
 * increased.  Your code is responsible for unreffing that object after use.
 *
 * The basic use pattern of an iterator is as follows:
 * |[
 *   GstIterator *it = _get_iterator(object);
 *   done = FALSE;
 *   while (!done) {
 *     switch (gst_iterator_next (it, &amp;item)) {
 *       case GST_ITERATOR_OK:
 *         ... use/change item here...
 *         g_value_reset (&amp;item);
 *         break;
 *       case GST_ITERATOR_RESYNC:
 *         ...rollback changes to items...
 *         gst_iterator_resync (it);
 *         break;
 *       case GST_ITERATOR_ERROR:
 *         ...wrong parameters were given...
 *         done = TRUE;
 *         break;
 *       case GST_ITERATOR_DONE:
 *         done = TRUE;
 *         break;
 *     }
 *   }
 *   g_value_unset (&amp;item);
 *   gst_iterator_free (it);
 * ]|
 */

#include "gst_private.h"
#include <gst/gstiterator.h>

/**
 * gst_iterator_copy:
 * @it: a #GstIterator
 *
 * Copy the iterator and its state.
 *
 * Returns: a new copy of @it.
 */
GstIterator *
gst_iterator_copy (const GstIterator * it)
{
  GstIterator *copy;

  copy = g_slice_copy (it->size, it);
  if (it->copy)
    it->copy (it, copy);

  return copy;
}

G_DEFINE_BOXED_TYPE (GstIterator, gst_iterator,
    (GBoxedCopyFunc) gst_iterator_copy, (GBoxedFreeFunc) gst_iterator_free);

static void
gst_iterator_init (GstIterator * it,
    guint size,
    GType type,
    GMutex * lock,
    guint32 * master_cookie,
    GstIteratorCopyFunction copy,
    GstIteratorNextFunction next,
    GstIteratorItemFunction item,
    GstIteratorResyncFunction resync, GstIteratorFreeFunction free)
{
  it->size = size;
  it->type = type;
  it->lock = lock;
  it->master_cookie = master_cookie;
  it->cookie = *master_cookie;
  it->copy = copy;
  it->next = next;
  it->item = item;
  it->resync = resync;
  it->free = free;
  it->pushed = NULL;
}

/**
 * gst_iterator_new: (skip)
 * @size: the size of the iterator structure
 * @type: #GType of children
 * @lock: pointer to a #GMutex.
 * @master_cookie: pointer to a guint32 that is changed when the items in the
 *    iterator changed.
 * @copy: copy function
 * @next: function to get next item
 * @item: function to call on each item retrieved
 * @resync: function to resync the iterator
 * @free: function to free the iterator
 *
 * Create a new iterator. This function is mainly used for objects
 * implementing the next/resync/free function to iterate a data structure.
 *
 * For each item retrieved, the @item function is called with the lock
 * held. The @free function is called when the iterator is freed.
 *
 * Returns: the new #GstIterator.
 *
 * MT safe.
 */
GstIterator *
gst_iterator_new (guint size,
    GType type,
    GMutex * lock,
    guint32 * master_cookie,
    GstIteratorCopyFunction copy,
    GstIteratorNextFunction next,
    GstIteratorItemFunction item,
    GstIteratorResyncFunction resync, GstIteratorFreeFunction free)
{
  GstIterator *result;

  g_return_val_if_fail (size >= sizeof (GstIterator), NULL);
  g_return_val_if_fail (g_type_qname (type) != 0, NULL);
  g_return_val_if_fail (master_cookie != NULL, NULL);
  g_return_val_if_fail (next != NULL, NULL);
  g_return_val_if_fail (resync != NULL, NULL);
  g_return_val_if_fail (free != NULL, NULL);

  result = g_slice_alloc0 (size);
  gst_iterator_init (result, size, type, lock, master_cookie, copy, next, item,
      resync, free);

  return result;
}

/*
 * list iterator
 */
typedef struct _GstListIterator
{
  GstIterator iterator;
  GObject *owner;
  GList **orig;
  GList *list;                  /* pointer in list */

  void (*set_value) (GValue * value, gpointer item);
} GstListIterator;

static void
gst_list_iterator_copy (const GstListIterator * it, GstListIterator * copy)
{
  if (copy->owner)
    g_object_ref (copy->owner);
}

static GstIteratorResult
gst_list_iterator_next (GstListIterator * it, GValue * elem)
{
  gpointer data;

  if (it->list == NULL)
    return GST_ITERATOR_DONE;

  data = it->list->data;
  it->list = g_list_next (it->list);

  it->set_value (elem, data);

  return GST_ITERATOR_OK;
}

static void
gst_list_iterator_resync (GstListIterator * it)
{
  it->list = *it->orig;
}

static void
gst_list_iterator_free (GstListIterator * it)
{
  if (it->owner)
    g_object_unref (it->owner);
}

/**
 * gst_iterator_new_list: (skip)
 * @type: #GType of elements
 * @lock: pointer to a #GMutex protecting the list.
 * @master_cookie: pointer to a guint32 that is incremented when the list
 *     is changed.
 * @list: pointer to the list
 * @owner: object owning the list
 * @item: function to call on each item retrieved
 *
 * Create a new iterator designed for iterating @list.
 *
 * The list you iterate is usually part of a data structure @owner and is
 * protected with @lock. 
 *
 * The iterator will use @lock to retrieve the next item of the list and it
 * will then call the @item function before releasing @lock again.
 *
 * When a concurrent update to the list is performed, usually by @owner while
 * holding @lock, @master_cookie will be updated. The iterator implementation
 * will notice the update of the cookie and will return %GST_ITERATOR_RESYNC to
 * the user of the iterator in the next call to gst_iterator_next().
 *
 * Returns: the new #GstIterator for @list.
 *
 * MT safe.
 */
GstIterator *
gst_iterator_new_list (GType type,
    GMutex * lock, guint32 * master_cookie, GList ** list, GObject * owner,
    GstIteratorItemFunction item)
{
  GstListIterator *result;
  gpointer set_value;

  if (g_type_is_a (type, G_TYPE_OBJECT)) {
    set_value = g_value_set_object;
  } else if (g_type_is_a (type, G_TYPE_BOXED)) {
    set_value = g_value_set_boxed;
  } else if (g_type_is_a (type, G_TYPE_POINTER)) {
    set_value = g_value_set_pointer;
  } else if (g_type_is_a (type, G_TYPE_STRING)) {
    set_value = g_value_set_string;
  } else {
    g_critical ("List iterators can only be created for lists containing "
        "instances of GObject, boxed types, pointer types and strings");
    return NULL;
  }

  /* no need to lock, nothing can change here */
  result = (GstListIterator *) gst_iterator_new (sizeof (GstListIterator),
      type,
      lock,
      master_cookie,
      (GstIteratorCopyFunction) gst_list_iterator_copy,
      (GstIteratorNextFunction) gst_list_iterator_next,
      (GstIteratorItemFunction) item,
      (GstIteratorResyncFunction) gst_list_iterator_resync,
      (GstIteratorFreeFunction) gst_list_iterator_free);

  result->owner = owner ? g_object_ref (owner) : NULL;
  result->orig = list;
  result->list = *list;
  result->set_value = set_value;

  return GST_ITERATOR (result);
}

static void
gst_iterator_pop (GstIterator * it)
{
  if (it->pushed) {
    gst_iterator_free (it->pushed);
    it->pushed = NULL;
  }
}

/**
 * gst_iterator_next:
 * @it: The #GstIterator to iterate
 * @elem: (out caller-allocates): pointer to hold next element
 *
 * Get the next item from the iterator in @elem. 
 *
 * Only when this function returns %GST_ITERATOR_OK, @elem will contain a valid
 * value. @elem must have been initialized to the type of the iterator or
 * initialized to zeroes with g_value_unset(). The caller is responsible for
 * unsetting or resetting @elem with g_value_unset() or g_value_reset()
 * after usage.
 *
 * When this function returns %GST_ITERATOR_DONE, no more elements can be
 * retrieved from @it.
 *
 * A return value of %GST_ITERATOR_RESYNC indicates that the element list was
 * concurrently updated. The user of @it should call gst_iterator_resync() to
 * get the newly updated list. 
 *
 * A return value of %GST_ITERATOR_ERROR indicates an unrecoverable fatal error.
 *
 * Returns: The result of the iteration. Unset @elem after usage.
 *
 * MT safe.
 */
GstIteratorResult
gst_iterator_next (GstIterator * it, GValue * elem)
{
  GstIteratorResult result;

  g_return_val_if_fail (it != NULL, GST_ITERATOR_ERROR);
  g_return_val_if_fail (elem != NULL, GST_ITERATOR_ERROR);
  g_return_val_if_fail (G_VALUE_TYPE (elem) == G_TYPE_INVALID
      || G_VALUE_HOLDS (elem, it->type), GST_ITERATOR_ERROR);

  if (G_VALUE_TYPE (elem) == G_TYPE_INVALID)
    g_value_init (elem, it->type);

restart:
  if (it->pushed) {
    result = gst_iterator_next (it->pushed, elem);
    if (result == GST_ITERATOR_DONE) {
      /* we are done with this iterator, pop it and
       * fallthrough iterating the main iterator again. */
      gst_iterator_pop (it);
    } else {
      return result;
    }
  }

  if (G_LIKELY (it->lock))
    g_mutex_lock (it->lock);

  if (G_UNLIKELY (*it->master_cookie != it->cookie)) {
    result = GST_ITERATOR_RESYNC;
    goto done;
  }

  result = it->next (it, elem);
  if (result == GST_ITERATOR_OK && it->item) {
    GstIteratorItem itemres;

    itemres = it->item (it, elem);
    switch (itemres) {
      case GST_ITERATOR_ITEM_SKIP:
        if (G_LIKELY (it->lock))
          g_mutex_unlock (it->lock);
        g_value_reset (elem);
        goto restart;
      case GST_ITERATOR_ITEM_END:
        result = GST_ITERATOR_DONE;
        g_value_reset (elem);
        break;
      case GST_ITERATOR_ITEM_PASS:
        break;
    }
  }

done:
  if (G_LIKELY (it->lock))
    g_mutex_unlock (it->lock);

  return result;
}

/**
 * gst_iterator_resync:
 * @it: The #GstIterator to resync
 *
 * Resync the iterator. this function is mostly called
 * after gst_iterator_next() returned %GST_ITERATOR_RESYNC.
 *
 * When an iterator was pushed on @it, it will automatically be popped again
 * with this function.
 *
 * MT safe.
 */
void
gst_iterator_resync (GstIterator * it)
{
  g_return_if_fail (it != NULL);

  gst_iterator_pop (it);

  if (G_LIKELY (it->lock))
    g_mutex_lock (it->lock);
  it->resync (it);
  it->cookie = *it->master_cookie;
  if (G_LIKELY (it->lock))
    g_mutex_unlock (it->lock);
}

/**
 * gst_iterator_free:
 * @it: The #GstIterator to free
 *
 * Free the iterator.
 *
 * MT safe.
 */
void
gst_iterator_free (GstIterator * it)
{
  g_return_if_fail (it != NULL);

  gst_iterator_pop (it);

  it->free (it);

  g_slice_free1 (it->size, it);
}

/**
 * gst_iterator_push:
 * @it: The #GstIterator to use
 * @other: The #GstIterator to push
 *
 * Pushes @other iterator onto @it. All calls performed on @it are
 * forwarded to @other. If @other returns %GST_ITERATOR_DONE, it is
 * popped again and calls are handled by @it again.
 *
 * This function is mainly used by objects implementing the iterator
 * next function to recurse into substructures.
 *
 * When gst_iterator_resync() is called on @it, @other will automatically be
 * popped.
 *
 * MT safe.
 */
void
gst_iterator_push (GstIterator * it, GstIterator * other)
{
  g_return_if_fail (it != NULL);
  g_return_if_fail (other != NULL);

  it->pushed = other;
}

typedef struct _GstIteratorFilter
{
  GstIterator iterator;
  GstIterator *slave;

  GMutex *master_lock;
  GCompareFunc func;
  GValue user_data;
  gboolean have_user_data;
} GstIteratorFilter;

static GstIteratorResult
filter_next (GstIteratorFilter * it, GValue * elem)
{
  GstIteratorResult result = GST_ITERATOR_ERROR;
  gboolean done = FALSE;
  GValue item = { 0, };

  while (G_LIKELY (!done)) {
    result = gst_iterator_next (it->slave, &item);
    switch (result) {
      case GST_ITERATOR_OK:
        if (G_LIKELY (it->master_lock))
          g_mutex_unlock (it->master_lock);
        if (it->func (&item, &it->user_data) == 0) {
          g_value_copy (&item, elem);
          done = TRUE;
        }
        g_value_reset (&item);
        if (G_LIKELY (it->master_lock))
          g_mutex_lock (it->master_lock);
        break;
      case GST_ITERATOR_RESYNC:
      case GST_ITERATOR_DONE:
        done = TRUE;
        break;
      default:
        g_assert_not_reached ();
        break;
    }
  }
  g_value_unset (&item);
  return result;
}

static void
filter_copy (const GstIteratorFilter * it, GstIteratorFilter * copy)
{
  copy->slave = gst_iterator_copy (it->slave);
  copy->master_lock = copy->slave->lock ? copy->slave->lock : it->master_lock;
  copy->slave->lock = NULL;

  if (it->have_user_data) {
    memset (&copy->user_data, 0, sizeof (copy->user_data));
    g_value_init (&copy->user_data, G_VALUE_TYPE (&it->user_data));
    g_value_copy (&it->user_data, &copy->user_data);
  }
}

static void
filter_resync (GstIteratorFilter * it)
{
  gst_iterator_resync (it->slave);
}

static void
filter_free (GstIteratorFilter * it)
{
  if (it->have_user_data)
    g_value_unset (&it->user_data);
  gst_iterator_free (it->slave);
}

/**
 * gst_iterator_filter:
 * @it: The #GstIterator to filter
 * @func: (scope call): the compare function to select elements
 * @user_data: (closure): user data passed to the compare function
 *
 * Create a new iterator from an existing iterator. The new iterator
 * will only return those elements that match the given compare function @func.
 * The first parameter that is passed to @func is the #GValue of the current
 * iterator element and the second parameter is @user_data. @func should
 * return 0 for elements that should be included in the filtered iterator.
 *
 * When this iterator is freed, @it will also be freed.
 *
 * Returns: (transfer full): a new #GstIterator.
 *
 * MT safe.
 */
GstIterator *
gst_iterator_filter (GstIterator * it, GCompareFunc func,
    const GValue * user_data)
{
  GstIteratorFilter *result;

  g_return_val_if_fail (it != NULL, NULL);
  g_return_val_if_fail (func != NULL, NULL);

  result = (GstIteratorFilter *) gst_iterator_new (sizeof (GstIteratorFilter),
      it->type, it->lock, it->master_cookie,
      (GstIteratorCopyFunction) filter_copy,
      (GstIteratorNextFunction) filter_next,
      (GstIteratorItemFunction) NULL,
      (GstIteratorResyncFunction) filter_resync,
      (GstIteratorFreeFunction) filter_free);

  result->master_lock = it->lock;
  it->lock = NULL;
  result->func = func;
  if (user_data) {
    g_value_init (&result->user_data, G_VALUE_TYPE (user_data));
    g_value_copy (user_data, &result->user_data);
    result->have_user_data = TRUE;
  } else {
    result->have_user_data = FALSE;
  }
  result->slave = it;

  return GST_ITERATOR (result);
}

/**
 * gst_iterator_fold:
 * @it: The #GstIterator to fold over
 * @func: (scope call): the fold function
 * @ret: the seed value passed to the fold function
 * @user_data: (closure): user data passed to the fold function
 *
 * Folds @func over the elements of @iter. That is to say, @func will be called
 * as @func (object, @ret, @user_data) for each object in @it. The normal use
 * of this procedure is to accumulate the results of operating on the objects in
 * @ret.
 *
 * This procedure can be used (and is used internally) to implement the
 * gst_iterator_foreach() and gst_iterator_find_custom() operations.
 *
 * The fold will proceed as long as @func returns %TRUE. When the iterator has no
 * more arguments, %GST_ITERATOR_DONE will be returned. If @func returns %FALSE,
 * the fold will stop, and %GST_ITERATOR_OK will be returned. Errors or resyncs
 * will cause fold to return %GST_ITERATOR_ERROR or %GST_ITERATOR_RESYNC as
 * appropriate.
 *
 * The iterator will not be freed.
 *
 * Returns: A #GstIteratorResult, as described above.
 *
 * MT safe.
 */
GstIteratorResult
gst_iterator_fold (GstIterator * it, GstIteratorFoldFunction func,
    GValue * ret, gpointer user_data)
{
  GValue item = { 0, };
  GstIteratorResult result;

  while (1) {
    result = gst_iterator_next (it, &item);
    switch (result) {
      case GST_ITERATOR_OK:
        if (!func (&item, ret, user_data))
          goto fold_done;

        g_value_reset (&item);
        break;
      case GST_ITERATOR_RESYNC:
      case GST_ITERATOR_ERROR:
        goto fold_done;
      case GST_ITERATOR_DONE:
        goto fold_done;
    }
  }

fold_done:
  g_value_unset (&item);

  return result;
}

typedef struct
{
  GstIteratorForeachFunction func;
  gpointer user_data;
} ForeachFoldData;

static gboolean
foreach_fold_func (const GValue * item, GValue * unused, ForeachFoldData * data)
{
  data->func (item, data->user_data);
  return TRUE;
}

/**
 * gst_iterator_foreach:
 * @it: The #GstIterator to iterate
 * @func: (scope call): the function to call for each element.
 * @user_data: (closure): user data passed to the function
 *
 * Iterate over all element of @it and call the given function @func for
 * each element.
 *
 * Returns: the result call to gst_iterator_fold(). The iterator will not be
 * freed.
 *
 * MT safe.
 */
GstIteratorResult
gst_iterator_foreach (GstIterator * it, GstIteratorForeachFunction func,
    gpointer user_data)
{
  ForeachFoldData data;

  data.func = func;
  data.user_data = user_data;

  return gst_iterator_fold (it, (GstIteratorFoldFunction) foreach_fold_func,
      NULL, &data);
}

typedef struct
{
  GCompareFunc func;
  gpointer user_data;
  gboolean found;
} FindCustomFoldData;

static gboolean
find_custom_fold_func (const GValue * item, GValue * ret,
    FindCustomFoldData * data)
{
  if (data->func (item, data->user_data) == 0) {
    data->found = TRUE;
    g_value_copy (item, ret);
    return FALSE;
  } else {
    return TRUE;
  }
}

/**
 * gst_iterator_find_custom:
 * @it: The #GstIterator to iterate
 * @func: (scope call): the compare function to use
 * @elem: (out): pointer to a #GValue where to store the result
 * @user_data: (closure): user data passed to the compare function
 *
 * Find the first element in @it that matches the compare function @func.
 * @func should return 0 when the element is found. The first parameter
 * to @func will be the current element of the iterator and the
 * second parameter will be @user_data.
 * The result will be stored in @elem if a result is found.
 *
 * The iterator will not be freed.
 *
 * This function will return %FALSE if an error happened to the iterator
 * or if the element wasn't found.
 *
 * Returns: Returns %TRUE if the element was found, else %FALSE.
 *
 * MT safe.
 */
gboolean
gst_iterator_find_custom (GstIterator * it, GCompareFunc func,
    GValue * elem, gpointer user_data)
{
  GstIteratorResult res;
  FindCustomFoldData data;

  g_return_val_if_fail (G_VALUE_TYPE (elem) == G_TYPE_INVALID
      || G_VALUE_HOLDS (elem, it->type), GST_ITERATOR_ERROR);

  if (G_VALUE_TYPE (elem) == G_TYPE_INVALID)
    g_value_init (elem, it->type);

  data.func = func;
  data.user_data = user_data;
  data.found = FALSE;

  do {
    res =
        gst_iterator_fold (it, (GstIteratorFoldFunction) find_custom_fold_func,
        elem, &data);
    if (res == GST_ITERATOR_RESYNC)
      gst_iterator_resync (it);
  } while (res == GST_ITERATOR_RESYNC);

  if (!data.found)
    g_value_unset (elem);

  return data.found;
}

typedef struct
{
  GstIterator parent;
  GValue object;
  gboolean visited;
  gboolean empty;
} GstSingleObjectIterator;

static guint32 _single_object_dummy_cookie = 0;

static void
gst_single_object_iterator_copy (const GstSingleObjectIterator * it,
    GstSingleObjectIterator * copy)
{
  if (!it->empty) {
    memset (&copy->object, 0, sizeof (copy->object));
    g_value_init (&copy->object, it->parent.type);
    g_value_copy (&it->object, &copy->object);
  }
}

static GstIteratorResult
gst_single_object_iterator_next (GstSingleObjectIterator * it, GValue * result)
{
  if (it->visited || it->empty)
    return GST_ITERATOR_DONE;

  g_value_copy (&it->object, result);
  it->visited = TRUE;

  return GST_ITERATOR_OK;
}

static void
gst_single_object_iterator_resync (GstSingleObjectIterator * it)
{
  it->visited = FALSE;
}

static void
gst_single_object_iterator_free (GstSingleObjectIterator * it)
{
  if (!it->empty)
    g_value_unset (&it->object);
}

/**
 * gst_iterator_new_single:
 * @type: #GType of the passed object
 * @object: object that this iterator should return
 *
 * This #GstIterator is a convenient iterator for the common
 * case where a #GstIterator needs to be returned but only
 * a single object has to be considered. This happens often
 * for the #GstPadIterIntLinkFunction.
 *
 * Returns: the new #GstIterator for @object.
 */
GstIterator *
gst_iterator_new_single (GType type, const GValue * object)
{
  GstSingleObjectIterator *result;

  result = (GstSingleObjectIterator *)
      gst_iterator_new (sizeof (GstSingleObjectIterator),
      type, NULL, &_single_object_dummy_cookie,
      (GstIteratorCopyFunction) gst_single_object_iterator_copy,
      (GstIteratorNextFunction) gst_single_object_iterator_next,
      (GstIteratorItemFunction) NULL,
      (GstIteratorResyncFunction) gst_single_object_iterator_resync,
      (GstIteratorFreeFunction) gst_single_object_iterator_free);

  if (object) {
    g_value_init (&result->object, type);
    g_value_copy (object, &result->object);
    result->empty = FALSE;
  } else {
    result->empty = TRUE;
  }
  result->visited = FALSE;

  return GST_ITERATOR (result);
}
