/* GStreamer
 * Copyright (C) 2005 David Schleef <ds@schleef.org>
 *
 * gstminiobject.h: Header for GstMiniObject
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
 * SECTION:gstminiobject
 * @short_description: Lightweight base class for the GStreamer object hierarchy
 *
 * #GstMiniObject is a simple structure that can be used to implement refcounted
 * types.
 *
 * Subclasses will include #GstMiniObject as the first member in their structure
 * and then call gst_mini_object_init() to initialize the #GstMiniObject fields.
 *
 * gst_mini_object_ref() and gst_mini_object_unref() increment and decrement the
 * refcount respectively. When the refcount of a mini-object reaches 0, the
 * dispose function is called first and when this returns %TRUE, the free
 * function of the miniobject is called.
 *
 * A copy can be made with gst_mini_object_copy().
 *
 * gst_mini_object_is_writable() will return %TRUE when the refcount of the
 * object is exactly 1, meaning the current caller has the only reference to the
 * object. gst_mini_object_make_writable() will return a writable version of the
 * object, which might be a new copy when the refcount was not 1.
 *
 * Opaque data can be associated with a #GstMiniObject with
 * gst_mini_object_set_qdata() and gst_mini_object_get_qdata(). The data is
 * meant to be specific to the particular object and is not automatically copied
 * with gst_mini_object_copy() or similar methods.
 *
 * A weak reference can be added and remove with gst_mini_object_weak_ref()
 * and gst_mini_object_weak_unref() respectively.
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gst/gst_private.h"
#include "gst/gstminiobject.h"
#include "gst/gstinfo.h"
#include <gobject/gvaluecollector.h>

#ifndef GST_DISABLE_TRACE
#include "gsttrace.h"
static GstAllocTrace *_gst_mini_object_trace;
#endif

/* Mutex used for weak referencing */
G_LOCK_DEFINE_STATIC (qdata_mutex);
static GQuark weak_ref_quark;

#define SHARE_ONE (1 << 16)
#define SHARE_TWO (2 << 16)
#define SHARE_MASK (~(SHARE_ONE - 1))
#define IS_SHARED(state) (state >= SHARE_TWO)
#define LOCK_ONE (GST_LOCK_FLAG_LAST)
#define FLAG_MASK (GST_LOCK_FLAG_LAST - 1)
#define LOCK_MASK ((SHARE_ONE - 1) - FLAG_MASK)
#define LOCK_FLAG_MASK (SHARE_ONE - 1)

typedef struct
{
  GQuark quark;
  GstMiniObjectNotify notify;
  gpointer data;
  GDestroyNotify destroy;
} GstQData;

#define QDATA(o,i)          ((GstQData *)(o)->qdata)[(i)]
#define QDATA_QUARK(o,i)    (QDATA(o,i).quark)
#define QDATA_NOTIFY(o,i)   (QDATA(o,i).notify)
#define QDATA_DATA(o,i)     (QDATA(o,i).data)
#define QDATA_DESTROY(o,i)  (QDATA(o,i).destroy)

void
_priv_gst_mini_object_initialize (void)
{
  weak_ref_quark = g_quark_from_static_string ("GstMiniObjectWeakRefQuark");

#ifndef GST_DISABLE_TRACE
  _gst_mini_object_trace = _gst_alloc_trace_register ("GstMiniObject", 0);
#endif
}

/**
 * gst_mini_object_init: (skip)
 * @mini_object: a #GstMiniObject
 * @flags: initial #GstMiniObjectFlags
 * @type: the #GType of the mini-object to create
 * @copy_func: (allow-none): the copy function, or %NULL
 * @dispose_func: (allow-none): the dispose function, or %NULL
 * @free_func: (allow-none): the free function or %NULL
 *
 * Initializes a mini-object with the desired type and copy/dispose/free
 * functions.
 */
void
gst_mini_object_init (GstMiniObject * mini_object, guint flags, GType type,
    GstMiniObjectCopyFunction copy_func,
    GstMiniObjectDisposeFunction dispose_func,
    GstMiniObjectFreeFunction free_func)
{
  mini_object->type = type;
  mini_object->refcount = 1;
  mini_object->lockstate = 0;
  mini_object->flags = flags;

  mini_object->copy = copy_func;
  mini_object->dispose = dispose_func;
  mini_object->free = free_func;

  mini_object->n_qdata = 0;
  mini_object->qdata = NULL;

#ifndef GST_DISABLE_TRACE
  _gst_alloc_trace_new (_gst_mini_object_trace, mini_object);
#endif
}

/**
 * gst_mini_object_copy:
 * @mini_object: the mini-object to copy
 *
 * Creates a copy of the mini-object.
 *
 * MT safe
 *
 * Returns: (transfer full): the new mini-object.
 */
GstMiniObject *
gst_mini_object_copy (const GstMiniObject * mini_object)
{
  GstMiniObject *copy;

  g_return_val_if_fail (mini_object != NULL, NULL);

  if (mini_object->copy)
    copy = mini_object->copy (mini_object);
  else
    copy = NULL;

  return copy;
}

/**
 * gst_mini_object_lock:
 * @object: the mini-object to lock
 * @flags: #GstLockFlags
 *
 * Lock the mini-object with the specified access mode in @flags.
 *
 * Returns: %TRUE if @object could be locked.
 */
gboolean
gst_mini_object_lock (GstMiniObject * object, GstLockFlags flags)
{
  gint access_mode, state, newstate;

  g_return_val_if_fail (object != NULL, FALSE);
  g_return_val_if_fail (GST_MINI_OBJECT_IS_LOCKABLE (object), FALSE);

  if (G_UNLIKELY (object->flags & GST_MINI_OBJECT_FLAG_LOCK_READONLY &&
          flags & GST_LOCK_FLAG_WRITE))
    return FALSE;

  do {
    access_mode = flags & FLAG_MASK;
    newstate = state = g_atomic_int_get (&object->lockstate);

    GST_CAT_TRACE (GST_CAT_LOCKING, "lock %p: state %08x, access_mode %d",
        object, state, access_mode);

    if (access_mode & GST_LOCK_FLAG_EXCLUSIVE) {
      /* shared ref */
      newstate += SHARE_ONE;
      access_mode &= ~GST_LOCK_FLAG_EXCLUSIVE;
    }

    if (access_mode) {
      /* shared counter > 1 and write access is not allowed */
      if (access_mode & GST_LOCK_FLAG_WRITE && IS_SHARED (state))
        goto lock_failed;

      if ((state & LOCK_FLAG_MASK) == 0) {
        /* nothing mapped, set access_mode */
        newstate |= access_mode;
      } else {
        /* access_mode must match */
        if ((state & access_mode) != access_mode)
          goto lock_failed;
      }
      /* increase refcount */
      newstate += LOCK_ONE;
    }
  } while (!g_atomic_int_compare_and_exchange (&object->lockstate, state,
          newstate));

  return TRUE;

lock_failed:
  {
    GST_CAT_DEBUG (GST_CAT_LOCKING,
        "lock failed %p: state %08x, access_mode %d", object, state,
        access_mode);
    return FALSE;
  }
}

/**
 * gst_mini_object_unlock:
 * @object: the mini-object to unlock
 * @flags: #GstLockFlags
 *
 * Unlock the mini-object with the specified access mode in @flags.
 */
void
gst_mini_object_unlock (GstMiniObject * object, GstLockFlags flags)
{
  gint access_mode, state, newstate;

  g_return_if_fail (object != NULL);
  g_return_if_fail (GST_MINI_OBJECT_IS_LOCKABLE (object));

  do {
    access_mode = flags & FLAG_MASK;
    newstate = state = g_atomic_int_get (&object->lockstate);

    GST_CAT_TRACE (GST_CAT_LOCKING, "unlock %p: state %08x, access_mode %d",
        object, state, access_mode);

    if (access_mode & GST_LOCK_FLAG_EXCLUSIVE) {
      /* shared counter */
      g_return_if_fail (state >= SHARE_ONE);
      newstate -= SHARE_ONE;
      access_mode &= ~GST_LOCK_FLAG_EXCLUSIVE;
    }

    if (access_mode) {
      g_return_if_fail ((state & access_mode) == access_mode);
      /* decrease the refcount */
      newstate -= LOCK_ONE;
      /* last refcount, unset access_mode */
      if ((newstate & LOCK_FLAG_MASK) == access_mode)
        newstate &= ~LOCK_FLAG_MASK;
    }
  } while (!g_atomic_int_compare_and_exchange (&object->lockstate, state,
          newstate));
}

/**
 * gst_mini_object_is_writable:
 * @mini_object: the mini-object to check
 *
 * If @mini_object has the LOCKABLE flag set, check if the current EXCLUSIVE
 * lock on @object is the only one, this means that changes to the object will
 * not be visible to any other object.
 *
 * If the LOCKABLE flag is not set, check if the refcount of @mini_object is
 * exactly 1, meaning that no other reference exists to the object and that the
 * object is therefore writable.
 *
 * Modification of a mini-object should only be done after verifying that it
 * is writable.
 *
 * Returns: %TRUE if the object is writable.
 */
gboolean
gst_mini_object_is_writable (const GstMiniObject * mini_object)
{
  gboolean result;

  g_return_val_if_fail (mini_object != NULL, FALSE);

  if (GST_MINI_OBJECT_IS_LOCKABLE (mini_object)) {
    result = !IS_SHARED (g_atomic_int_get (&mini_object->lockstate));
  } else {
    result = (GST_MINI_OBJECT_REFCOUNT_VALUE (mini_object) == 1);
  }
  return result;
}

/**
 * gst_mini_object_make_writable:
 * @mini_object: (transfer full): the mini-object to make writable
 *
 * Checks if a mini-object is writable.  If not, a writable copy is made and
 * returned.  This gives away the reference to the original mini object,
 * and returns a reference to the new object.
 *
 * MT safe
 *
 * Returns: (transfer full): a mini-object (possibly the same pointer) that
 *     is writable.
 */
GstMiniObject *
gst_mini_object_make_writable (GstMiniObject * mini_object)
{
  GstMiniObject *ret;

  g_return_val_if_fail (mini_object != NULL, NULL);

  if (gst_mini_object_is_writable (mini_object)) {
    ret = mini_object;
  } else {
    ret = gst_mini_object_copy (mini_object);
    GST_CAT_DEBUG (GST_CAT_PERFORMANCE, "copy %s miniobject %p -> %p",
        g_type_name (GST_MINI_OBJECT_TYPE (mini_object)), mini_object, ret);
    gst_mini_object_unref (mini_object);
  }

  return ret;
}

/**
 * gst_mini_object_ref:
 * @mini_object: the mini-object
 *
 * Increase the reference count of the mini-object.
 *
 * Note that the refcount affects the writability
 * of @mini-object, see gst_mini_object_is_writable(). It is
 * important to note that keeping additional references to
 * GstMiniObject instances can potentially increase the number
 * of memcpy operations in a pipeline, especially if the miniobject
 * is a #GstBuffer.
 *
 * Returns: (transfer full): the mini-object.
 */
GstMiniObject *
gst_mini_object_ref (GstMiniObject * mini_object)
{
  g_return_val_if_fail (mini_object != NULL, NULL);
  /* we can't assert that the refcount > 0 since the _free functions
   * increments the refcount from 0 to 1 again to allow resurecting
   * the object
   g_return_val_if_fail (mini_object->refcount > 0, NULL);
   */

  GST_CAT_TRACE (GST_CAT_REFCOUNTING, "%p ref %d->%d", mini_object,
      GST_MINI_OBJECT_REFCOUNT_VALUE (mini_object),
      GST_MINI_OBJECT_REFCOUNT_VALUE (mini_object) + 1);

  g_atomic_int_inc (&mini_object->refcount);

  return mini_object;
}

static gint
find_notify (GstMiniObject * object, GQuark quark, gboolean match_notify,
    GstMiniObjectNotify notify, gpointer data)
{
  guint i;

  for (i = 0; i < object->n_qdata; i++) {
    if (QDATA_QUARK (object, i) == quark) {
      /* check if we need to match the callback too */
      if (!match_notify || (QDATA_NOTIFY (object, i) == notify &&
              QDATA_DATA (object, i) == data))
        return i;
    }
  }
  return -1;
}

static void
remove_notify (GstMiniObject * object, gint index)
{
  /* remove item */
  if (--object->n_qdata == 0) {
    /* we don't shrink but free when everything is gone */
    g_free (object->qdata);
    object->qdata = NULL;
  } else if (index != object->n_qdata)
    QDATA (object, index) = QDATA (object, object->n_qdata);
}

static void
set_notify (GstMiniObject * object, gint index, GQuark quark,
    GstMiniObjectNotify notify, gpointer data, GDestroyNotify destroy)
{
  if (index == -1) {
    /* add item */
    index = object->n_qdata++;
    object->qdata =
        g_realloc (object->qdata, sizeof (GstQData) * object->n_qdata);
  }
  QDATA_QUARK (object, index) = quark;
  QDATA_NOTIFY (object, index) = notify;
  QDATA_DATA (object, index) = data;
  QDATA_DESTROY (object, index) = destroy;
}

static void
call_finalize_notify (GstMiniObject * obj)
{
  guint i;

  for (i = 0; i < obj->n_qdata; i++) {
    if (QDATA_QUARK (obj, i) == weak_ref_quark)
      QDATA_NOTIFY (obj, i) (QDATA_DATA (obj, i), obj);
    if (QDATA_DESTROY (obj, i))
      QDATA_DESTROY (obj, i) (QDATA_DATA (obj, i));
  }
}

/**
 * gst_mini_object_unref:
 * @mini_object: the mini-object
 *
 * Decreases the reference count of the mini-object, possibly freeing
 * the mini-object.
 */
void
gst_mini_object_unref (GstMiniObject * mini_object)
{
  g_return_if_fail (mini_object != NULL);

  GST_CAT_TRACE (GST_CAT_REFCOUNTING, "%p unref %d->%d",
      mini_object,
      GST_MINI_OBJECT_REFCOUNT_VALUE (mini_object),
      GST_MINI_OBJECT_REFCOUNT_VALUE (mini_object) - 1);

  g_return_if_fail (mini_object->refcount > 0);

  if (G_UNLIKELY (g_atomic_int_dec_and_test (&mini_object->refcount))) {
    gboolean do_free;

    if (mini_object->dispose)
      do_free = mini_object->dispose (mini_object);
    else
      do_free = TRUE;

    /* if the subclass recycled the object (and returned FALSE) we don't
     * want to free the instance anymore */
    if (G_LIKELY (do_free)) {
      /* there should be no outstanding locks */
      g_return_if_fail ((g_atomic_int_get (&mini_object->lockstate) & LOCK_MASK)
          < 4);

      if (mini_object->n_qdata) {
        call_finalize_notify (mini_object);
        g_free (mini_object->qdata);
      }
#ifndef GST_DISABLE_TRACE
      _gst_alloc_trace_free (_gst_mini_object_trace, mini_object);
#endif
      if (mini_object->free)
        mini_object->free (mini_object);
    }
  }
}

/**
 * gst_mini_object_replace:
 * @olddata: (inout) (transfer full) (nullable): pointer to a pointer to a
 *     mini-object to be replaced
 * @newdata: (allow-none): pointer to new mini-object
 *
 * Atomically modifies a pointer to point to a new mini-object.
 * The reference count of @olddata is decreased and the reference count of
 * @newdata is increased.
 *
 * Either @newdata and the value pointed to by @olddata may be %NULL.
 *
 * Returns: %TRUE if @newdata was different from @olddata
 */
gboolean
gst_mini_object_replace (GstMiniObject ** olddata, GstMiniObject * newdata)
{
  GstMiniObject *olddata_val;

  g_return_val_if_fail (olddata != NULL, FALSE);

  GST_CAT_TRACE (GST_CAT_REFCOUNTING, "replace %p (%d) with %p (%d)",
      *olddata, *olddata ? (*olddata)->refcount : 0,
      newdata, newdata ? newdata->refcount : 0);

  olddata_val = g_atomic_pointer_get ((gpointer *) olddata);

  if (G_UNLIKELY (olddata_val == newdata))
    return FALSE;

  if (newdata)
    gst_mini_object_ref (newdata);

  while (G_UNLIKELY (!g_atomic_pointer_compare_and_exchange ((gpointer *)
              olddata, olddata_val, newdata))) {
    olddata_val = g_atomic_pointer_get ((gpointer *) olddata);
    if (G_UNLIKELY (olddata_val == newdata))
      break;
  }

  if (olddata_val)
    gst_mini_object_unref (olddata_val);

  return olddata_val != newdata;
}

/**
 * gst_mini_object_steal:
 * @olddata: (inout) (transfer full): pointer to a pointer to a mini-object to
 *     be stolen
 *
 * Replace the current #GstMiniObject pointer to by @olddata with %NULL and
 * return the old value.
 *
 * Returns: the #GstMiniObject at @oldata
 */
GstMiniObject *
gst_mini_object_steal (GstMiniObject ** olddata)
{
  GstMiniObject *olddata_val;

  g_return_val_if_fail (olddata != NULL, NULL);

  GST_CAT_TRACE (GST_CAT_REFCOUNTING, "steal %p (%d)",
      *olddata, *olddata ? (*olddata)->refcount : 0);

  do {
    olddata_val = g_atomic_pointer_get ((gpointer *) olddata);
    if (olddata_val == NULL)
      break;
  } while (G_UNLIKELY (!g_atomic_pointer_compare_and_exchange ((gpointer *)
              olddata, olddata_val, NULL)));

  return olddata_val;
}

/**
 * gst_mini_object_take:
 * @olddata: (inout) (transfer full): pointer to a pointer to a mini-object to
 *     be replaced
 * @newdata: pointer to new mini-object
 *
 * Modifies a pointer to point to a new mini-object. The modification
 * is done atomically. This version is similar to gst_mini_object_replace()
 * except that it does not increase the refcount of @newdata and thus
 * takes ownership of @newdata.
 *
 * Either @newdata and the value pointed to by @olddata may be %NULL.
 *
 * Returns: %TRUE if @newdata was different from @olddata
 */
gboolean
gst_mini_object_take (GstMiniObject ** olddata, GstMiniObject * newdata)
{
  GstMiniObject *olddata_val;

  g_return_val_if_fail (olddata != NULL, FALSE);

  GST_CAT_TRACE (GST_CAT_REFCOUNTING, "take %p (%d) with %p (%d)",
      *olddata, *olddata ? (*olddata)->refcount : 0,
      newdata, newdata ? newdata->refcount : 0);

  do {
    olddata_val = g_atomic_pointer_get ((gpointer *) olddata);
    if (G_UNLIKELY (olddata_val == newdata))
      break;
  } while (G_UNLIKELY (!g_atomic_pointer_compare_and_exchange ((gpointer *)
              olddata, olddata_val, newdata)));

  if (olddata_val)
    gst_mini_object_unref (olddata_val);

  return olddata_val != newdata;
}

/**
 * gst_mini_object_weak_ref: (skip)
 * @object: #GstMiniObject to reference weakly
 * @notify: callback to invoke before the mini object is freed
 * @data: extra data to pass to notify
 *
 * Adds a weak reference callback to a mini object. Weak references are
 * used for notification when a mini object is finalized. They are called
 * "weak references" because they allow you to safely hold a pointer
 * to the mini object without calling gst_mini_object_ref()
 * (gst_mini_object_ref() adds a strong reference, that is, forces the object
 * to stay alive).
 */
void
gst_mini_object_weak_ref (GstMiniObject * object,
    GstMiniObjectNotify notify, gpointer data)
{
  g_return_if_fail (object != NULL);
  g_return_if_fail (notify != NULL);
  g_return_if_fail (GST_MINI_OBJECT_REFCOUNT_VALUE (object) >= 1);

  G_LOCK (qdata_mutex);
  set_notify (object, -1, weak_ref_quark, notify, data, NULL);
  G_UNLOCK (qdata_mutex);
}

/**
 * gst_mini_object_weak_unref: (skip)
 * @object: #GstMiniObject to remove a weak reference from
 * @notify: callback to search for
 * @data: data to search for
 *
 * Removes a weak reference callback from a mini object.
 */
void
gst_mini_object_weak_unref (GstMiniObject * object,
    GstMiniObjectNotify notify, gpointer data)
{
  gint i;

  g_return_if_fail (object != NULL);
  g_return_if_fail (notify != NULL);

  G_LOCK (qdata_mutex);
  if ((i = find_notify (object, weak_ref_quark, TRUE, notify, data)) != -1) {
    remove_notify (object, i);
  } else {
    g_warning ("%s: couldn't find weak ref %p(%p)", G_STRFUNC, notify, data);
  }
  G_UNLOCK (qdata_mutex);
}

/**
 * gst_mini_object_set_qdata:
 * @object: a #GstMiniObject
 * @quark: A #GQuark, naming the user data pointer
 * @data: An opaque user data pointer
 * @destroy: Function to invoke with @data as argument, when @data
 *           needs to be freed
 *
 * This sets an opaque, named pointer on a miniobject.
 * The name is specified through a #GQuark (retrieved e.g. via
 * g_quark_from_static_string()), and the pointer
 * can be gotten back from the @object with gst_mini_object_get_qdata()
 * until the @object is disposed.
 * Setting a previously set user data pointer, overrides (frees)
 * the old pointer set, using %NULL as pointer essentially
 * removes the data stored.
 *
 * @destroy may be specified which is called with @data as argument
 * when the @object is disposed, or the data is being overwritten by
 * a call to gst_mini_object_set_qdata() with the same @quark.
 */
void
gst_mini_object_set_qdata (GstMiniObject * object, GQuark quark,
    gpointer data, GDestroyNotify destroy)
{
  gint i;
  gpointer old_data = NULL;
  GDestroyNotify old_notify = NULL;

  g_return_if_fail (object != NULL);
  g_return_if_fail (quark > 0);

  G_LOCK (qdata_mutex);
  if ((i = find_notify (object, quark, FALSE, NULL, NULL)) != -1) {

    old_data = QDATA_DATA (object, i);
    old_notify = QDATA_DESTROY (object, i);

    if (data == NULL)
      remove_notify (object, i);
  }
  if (data != NULL)
    set_notify (object, i, quark, NULL, data, destroy);
  G_UNLOCK (qdata_mutex);

  if (old_notify)
    old_notify (old_data);
}

/**
 * gst_mini_object_get_qdata:
 * @object: The GstMiniObject to get a stored user data pointer from
 * @quark: A #GQuark, naming the user data pointer
 *
 * This function gets back user data pointers stored via
 * gst_mini_object_set_qdata().
 *
 * Returns: (transfer none) (nullable): The user data pointer set, or
 * %NULL
 */
gpointer
gst_mini_object_get_qdata (GstMiniObject * object, GQuark quark)
{
  guint i;
  gpointer result;

  g_return_val_if_fail (object != NULL, NULL);
  g_return_val_if_fail (quark > 0, NULL);

  G_LOCK (qdata_mutex);
  if ((i = find_notify (object, quark, FALSE, NULL, NULL)) != -1)
    result = QDATA_DATA (object, i);
  else
    result = NULL;
  G_UNLOCK (qdata_mutex);

  return result;
}

/**
 * gst_mini_object_steal_qdata:
 * @object: The GstMiniObject to get a stored user data pointer from
 * @quark: A #GQuark, naming the user data pointer
 *
 * This function gets back user data pointers stored via gst_mini_object_set_qdata()
 * and removes the data from @object without invoking its destroy() function (if
 * any was set).
 *
 * Returns: (transfer full) (nullable): The user data pointer set, or
 * %NULL
 */
gpointer
gst_mini_object_steal_qdata (GstMiniObject * object, GQuark quark)
{
  guint i;
  gpointer result;

  g_return_val_if_fail (object != NULL, NULL);
  g_return_val_if_fail (quark > 0, NULL);

  G_LOCK (qdata_mutex);
  if ((i = find_notify (object, quark, FALSE, NULL, NULL)) != -1) {
    result = QDATA_DATA (object, i);
    remove_notify (object, i);
  } else {
    result = NULL;
  }
  G_UNLOCK (qdata_mutex);

  return result;
}
