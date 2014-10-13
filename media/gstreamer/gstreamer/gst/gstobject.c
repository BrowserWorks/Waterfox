/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstobject.c: Fundamental class used for all of GStreamer
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
 * SECTION:gstobject
 * @short_description: Base class for the GStreamer object hierarchy
 *
 * #GstObject provides a root for the object hierarchy tree filed in by the
 * GStreamer library.  It is currently a thin wrapper on top of
 * #GInitiallyUnowned. It is an abstract class that is not very usable on its own.
 *
 * #GstObject gives us basic refcounting, parenting functionality and locking.
 * Most of the functions are just extended for special GStreamer needs and can be
 * found under the same name in the base class of #GstObject which is #GObject
 * (e.g. g_object_ref() becomes gst_object_ref()).
 *
 * Since #GstObject derives from #GInitiallyUnowned, it also inherits the
 * floating reference. Be aware that functions such as gst_bin_add() and
 * gst_element_add_pad() take ownership of the floating reference.
 *
 * In contrast to #GObject instances, #GstObject adds a name property. The functions
 * gst_object_set_name() and gst_object_get_name() are used to set/get the name
 * of the object.
 *
 * <refsect2>
 * <title>controlled properties</title>
 * <para>
 * Controlled properties offers a lightweight way to adjust gobject properties
 * over stream-time. It works by using time-stamped value pairs that are queued
 * for element-properties. At run-time the elements continuously pull value
 * changes for the current stream-time.
 *
 * What needs to be changed in a #GstElement?
 * Very little - it is just two steps to make a plugin controllable!
 * <orderedlist>
 *   <listitem><para>
 *     mark gobject-properties paramspecs that make sense to be controlled,
 *     by GST_PARAM_CONTROLLABLE.
 *   </para></listitem>
 *   <listitem><para>
 *     when processing data (get, chain, loop function) at the beginning call
 *     gst_object_sync_values(element,timestamp).
 *     This will make the controller update all GObject properties that are
 *     under its control with the current values based on the timestamp.
 *   </para></listitem>
 * </orderedlist>
 *
 * What needs to be done in applications?
 * Again it's not a lot to change.
 * <orderedlist>
 *   <listitem><para>
 *     create a #GstControlSource.
 *     csource = gst_interpolation_control_source_new ();
 *     g_object_set (csource, "mode", GST_INTERPOLATION_MODE_LINEAR, NULL);
 *   </para></listitem>
 *   <listitem><para>
 *     Attach the #GstControlSource on the controller to a property.
 *     gst_object_add_control_binding (object, gst_direct_control_binding_new (object, "prop1", csource));
 *   </para></listitem>
 *   <listitem><para>
 *     Set the control values
 *     gst_timed_value_control_source_set ((GstTimedValueControlSource *)csource,0 * GST_SECOND, value1);
 *     gst_timed_value_control_source_set ((GstTimedValueControlSource *)csource,1 * GST_SECOND, value2);
 *   </para></listitem>
 *   <listitem><para>
 *     start your pipeline
 *   </para></listitem>
 * </orderedlist>
 * </para>
 * </refsect2>
 */

#include "gst_private.h"
#include "glib-compat-private.h"

#include "gstobject.h"
#include "gstclock.h"
#include "gstcontrolbinding.h"
#include "gstcontrolsource.h"
#include "gstinfo.h"
#include "gstparamspecs.h"
#include "gstutils.h"

#ifndef GST_DISABLE_TRACE
#include "gsttrace.h"
static GstAllocTrace *_gst_object_trace;
#endif

#define DEBUG_REFCOUNT

/* Object signals and args */
enum
{
  DEEP_NOTIFY,
  LAST_SIGNAL
};

enum
{
  PROP_0,
  PROP_NAME,
  PROP_PARENT,
  PROP_LAST
};

enum
{
  SO_OBJECT_LOADED,
  SO_LAST_SIGNAL
};

/* maps type name quark => count */
static GData *object_name_counts = NULL;

G_LOCK_DEFINE_STATIC (object_name_mutex);

static void gst_object_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_object_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

static void gst_object_dispatch_properties_changed (GObject * object,
    guint n_pspecs, GParamSpec ** pspecs);

static void gst_object_dispose (GObject * object);
static void gst_object_finalize (GObject * object);

static gboolean gst_object_set_name_default (GstObject * object);

static guint gst_object_signals[LAST_SIGNAL] = { 0 };

static GParamSpec *properties[PROP_LAST];

G_DEFINE_ABSTRACT_TYPE (GstObject, gst_object, G_TYPE_INITIALLY_UNOWNED);

static void
gst_object_class_init (GstObjectClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

#ifndef GST_DISABLE_TRACE
  _gst_object_trace =
      _gst_alloc_trace_register (g_type_name (GST_TYPE_OBJECT), -2);
#endif

  gobject_class->set_property = gst_object_set_property;
  gobject_class->get_property = gst_object_get_property;

  properties[PROP_NAME] =
      g_param_spec_string ("name", "Name", "The name of the object", NULL,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS);

  /**
   * GstObject:parent:
   *
   * The parent of the object. Please note, that when changing the 'parent'
   * property, we don't emit #GObject::notify and #GstObject::deep-notify
   * signals due to locking issues. In some cases one can use
   * #GstBin::element-added or #GstBin::element-removed signals on the parent to
   * achieve a similar effect.
   */
  properties[PROP_PARENT] =
      g_param_spec_object ("parent", "Parent", "The parent of the object",
      GST_TYPE_OBJECT, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS);

  g_object_class_install_properties (gobject_class, PROP_LAST, properties);

  /**
   * GstObject::deep-notify:
   * @gstobject: a #GstObject
   * @prop_object: the object that originated the signal
   * @prop: the property that changed
   *
   * The deep notify signal is used to be notified of property changes. It is
   * typically attached to the toplevel bin to receive notifications from all
   * the elements contained in that bin.
   */
  gst_object_signals[DEEP_NOTIFY] =
      g_signal_new ("deep-notify", G_TYPE_FROM_CLASS (klass),
      G_SIGNAL_RUN_FIRST | G_SIGNAL_NO_RECURSE | G_SIGNAL_DETAILED |
      G_SIGNAL_NO_HOOKS, G_STRUCT_OFFSET (GstObjectClass, deep_notify), NULL,
      NULL, g_cclosure_marshal_generic, G_TYPE_NONE, 2, GST_TYPE_OBJECT,
      G_TYPE_PARAM);

  klass->path_string_separator = "/";

  /* see the comments at gst_object_dispatch_properties_changed */
  gobject_class->dispatch_properties_changed
      = GST_DEBUG_FUNCPTR (gst_object_dispatch_properties_changed);

  gobject_class->dispose = gst_object_dispose;
  gobject_class->finalize = gst_object_finalize;
}

static void
gst_object_init (GstObject * object)
{
  g_mutex_init (&object->lock);
  object->parent = NULL;
  object->name = NULL;
  GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "%p new", object);

#ifndef GST_DISABLE_TRACE
  _gst_alloc_trace_new (_gst_object_trace, object);
#endif

  object->flags = 0;

  object->control_rate = 100 * GST_MSECOND;
  object->last_sync = GST_CLOCK_TIME_NONE;
}

/**
 * gst_object_ref:
 * @object: (type Gst.Object): a #GstObject to reference
 *
 * Increments the reference count on @object. This function
 * does not take the lock on @object because it relies on
 * atomic refcounting.
 *
 * This object returns the input parameter to ease writing
 * constructs like :
 *  result = gst_object_ref (object->parent);
 *
 * Returns: (transfer full) (type Gst.Object): A pointer to @object
 */
gpointer
gst_object_ref (gpointer object)
{
  g_return_val_if_fail (object != NULL, NULL);

#ifdef DEBUG_REFCOUNT
  GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "%p ref %d->%d", object,
      ((GObject *) object)->ref_count, ((GObject *) object)->ref_count + 1);
#endif
  g_object_ref (object);

  return object;
}

/**
 * gst_object_unref:
 * @object: (type Gst.Object): a #GstObject to unreference
 *
 * Decrements the reference count on @object.  If reference count hits
 * zero, destroy @object. This function does not take the lock
 * on @object as it relies on atomic refcounting.
 *
 * The unref method should never be called with the LOCK held since
 * this might deadlock the dispose function.
 */
void
gst_object_unref (gpointer object)
{
  g_return_if_fail (object != NULL);
  g_return_if_fail (((GObject *) object)->ref_count > 0);

#ifdef DEBUG_REFCOUNT
  GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "%p unref %d->%d", object,
      ((GObject *) object)->ref_count, ((GObject *) object)->ref_count - 1);
#endif
  g_object_unref (object);
}

/**
 * gst_object_ref_sink: (skip)
 * @object: a #GstObject to sink
 *
 * Increase the reference count of @object, and possibly remove the floating
 * reference, if @object has a floating reference.
 *
 * In other words, if the object is floating, then this call "assumes ownership"
 * of the floating reference, converting it to a normal reference by clearing
 * the floating flag while leaving the reference count unchanged. If the object
 * is not floating, then this call adds a new normal reference increasing the
 * reference count by one.
 */
gpointer
gst_object_ref_sink (gpointer object)
{
  g_return_val_if_fail (object != NULL, NULL);

#ifdef DEBUG_REFCOUNT
  GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "%p ref_sink %d->%d",
      object, ((GObject *) object)->ref_count,
      ((GObject *) object)->ref_count + 1);
#endif
  return g_object_ref_sink (object);
}

/**
 * gst_object_replace:
 * @oldobj: (inout) (transfer full) (nullable): pointer to a place of
 *     a #GstObject to replace
 * @newobj: (transfer none) (allow-none): a new #GstObject
 *
 * Atomically modifies a pointer to point to a new object.
 * The reference count of @oldobj is decreased and the reference count of
 * @newobj is increased.
 *
 * Either @newobj and the value pointed to by @oldobj may be %NULL.
 *
 * Returns: %TRUE if @newobj was different from @oldobj
 */
gboolean
gst_object_replace (GstObject ** oldobj, GstObject * newobj)
{
  GstObject *oldptr;

  g_return_val_if_fail (oldobj != NULL, FALSE);

#ifdef DEBUG_REFCOUNT
  GST_CAT_TRACE (GST_CAT_REFCOUNTING, "replace %p %s (%d) with %p %s (%d)",
      *oldobj, *oldobj ? GST_STR_NULL (GST_OBJECT_NAME (*oldobj)) : "(NONE)",
      *oldobj ? G_OBJECT (*oldobj)->ref_count : 0,
      newobj, newobj ? GST_STR_NULL (GST_OBJECT_NAME (newobj)) : "(NONE)",
      newobj ? G_OBJECT (newobj)->ref_count : 0);
#endif

  oldptr = g_atomic_pointer_get ((gpointer *) oldobj);

  if (G_UNLIKELY (oldptr == newobj))
    return FALSE;

  if (newobj)
    gst_object_ref (newobj);

  while (G_UNLIKELY (!g_atomic_pointer_compare_and_exchange ((gpointer *)
              oldobj, oldptr, newobj))) {
    oldptr = g_atomic_pointer_get ((gpointer *) oldobj);
    if (G_UNLIKELY (oldptr == newobj))
      break;
  }

  if (oldptr)
    gst_object_unref (oldptr);

  return oldptr != newobj;
}

/* dispose is called when the object has to release all links
 * to other objects */
static void
gst_object_dispose (GObject * object)
{
  GstObject *self = (GstObject *) object;
  GstObject *parent;

  GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "dispose");

  GST_OBJECT_LOCK (object);
  if ((parent = GST_OBJECT_PARENT (object)))
    goto have_parent;
  GST_OBJECT_PARENT (object) = NULL;
  GST_OBJECT_UNLOCK (object);

  if (self->control_bindings) {
    GList *node;

    for (node = self->control_bindings; node; node = g_list_next (node)) {
      gst_object_unparent (node->data);
    }
    g_list_free (self->control_bindings);
    self->control_bindings = NULL;
  }

  ((GObjectClass *) gst_object_parent_class)->dispose (object);

  return;

  /* ERRORS */
have_parent:
  {
    g_critical ("\nTrying to dispose object \"%s\", but it still has a "
        "parent \"%s\".\nYou need to let the parent manage the "
        "object instead of unreffing the object directly.\n",
        GST_OBJECT_NAME (object), GST_OBJECT_NAME (parent));
    GST_OBJECT_UNLOCK (object);
    /* ref the object again to revive it in this error case */
    gst_object_ref (object);
    return;
  }
}

/* finalize is called when the object has to free its resources */
static void
gst_object_finalize (GObject * object)
{
  GstObject *gstobject = GST_OBJECT_CAST (object);

  GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "finalize");

  g_signal_handlers_destroy (object);

  g_free (gstobject->name);
  g_mutex_clear (&gstobject->lock);

#ifndef GST_DISABLE_TRACE
  _gst_alloc_trace_free (_gst_object_trace, object);
#endif

  ((GObjectClass *) gst_object_parent_class)->finalize (object);
}

/* Changing a GObject property of a GstObject will result in "deep-notify"
 * signals being emitted by the object itself, as well as in each parent
 * object. This is so that an application can connect a listener to the
 * top-level bin to catch property-change notifications for all contained
 * elements.
 *
 * MT safe.
 */
static void
gst_object_dispatch_properties_changed (GObject * object,
    guint n_pspecs, GParamSpec ** pspecs)
{
  GstObject *gst_object, *parent, *old_parent;
  guint i;
#ifndef GST_DISABLE_GST_DEBUG
  gchar *name = NULL;
  const gchar *debug_name;
#endif

  /* do the standard dispatching */
  ((GObjectClass *)
      gst_object_parent_class)->dispatch_properties_changed (object, n_pspecs,
      pspecs);

  gst_object = GST_OBJECT_CAST (object);
#ifndef GST_DISABLE_GST_DEBUG
  if (G_UNLIKELY (_gst_debug_min >= GST_LEVEL_LOG)) {
    name = gst_object_get_name (gst_object);
    debug_name = GST_STR_NULL (name);
  } else
    debug_name = "";
#endif

  /* now let the parent dispatch those, too */
  parent = gst_object_get_parent (gst_object);
  while (parent) {
    for (i = 0; i < n_pspecs; i++) {
      GST_CAT_LOG_OBJECT (GST_CAT_PROPERTIES, parent,
          "deep notification from %s (%s)", debug_name, pspecs[i]->name);

      g_signal_emit (parent, gst_object_signals[DEEP_NOTIFY],
          g_quark_from_string (pspecs[i]->name), gst_object, pspecs[i]);
    }

    old_parent = parent;
    parent = gst_object_get_parent (old_parent);
    gst_object_unref (old_parent);
  }
#ifndef GST_DISABLE_GST_DEBUG
  g_free (name);
#endif
}

/**
 * gst_object_default_deep_notify:
 * @object: the #GObject that signalled the notify.
 * @orig: a #GstObject that initiated the notify.
 * @pspec: a #GParamSpec of the property.
 * @excluded_props: (array zero-terminated=1) (element-type gchar*) (allow-none):
 *     a set of user-specified properties to exclude or %NULL to show
 *     all changes.
 *
 * A default deep_notify signal callback for an object. The user data
 * should contain a pointer to an array of strings that should be excluded
 * from the notify. The default handler will print the new value of the property
 * using g_print.
 *
 * MT safe. This function grabs and releases @object's LOCK for getting its
 *          path string.
 */
void
gst_object_default_deep_notify (GObject * object, GstObject * orig,
    GParamSpec * pspec, gchar ** excluded_props)
{
  GValue value = { 0, };        /* the important thing is that value.type = 0 */
  gchar *str = NULL;
  gchar *name = NULL;

  if (pspec->flags & G_PARAM_READABLE) {
    /* let's not print these out for excluded properties... */
    while (excluded_props != NULL && *excluded_props != NULL) {
      if (strcmp (pspec->name, *excluded_props) == 0)
        return;
      excluded_props++;
    }
    g_value_init (&value, pspec->value_type);
    g_object_get_property (G_OBJECT (orig), pspec->name, &value);

    if (G_VALUE_HOLDS_STRING (&value))
      str = g_value_dup_string (&value);
    else
      str = gst_value_serialize (&value);
    name = gst_object_get_path_string (orig);
    g_print ("%s: %s = %s\n", name, pspec->name, str);
    g_free (name);
    g_free (str);
    g_value_unset (&value);
  } else {
    name = gst_object_get_path_string (orig);
    g_warning ("Parameter %s not readable in %s.", pspec->name, name);
    g_free (name);
  }
}

static gboolean
gst_object_set_name_default (GstObject * object)
{
  const gchar *type_name;
  gint count;
  gchar *name;
  GQuark q;
  guint i, l;

  /* to ensure guaranteed uniqueness across threads, only one thread
   * may ever assign a name */
  G_LOCK (object_name_mutex);

  if (!object_name_counts) {
    g_datalist_init (&object_name_counts);
  }

  q = g_type_qname (G_OBJECT_TYPE (object));
  count = GPOINTER_TO_INT (g_datalist_id_get_data (&object_name_counts, q));
  g_datalist_id_set_data (&object_name_counts, q, GINT_TO_POINTER (count + 1));

  G_UNLOCK (object_name_mutex);

  /* GstFooSink -> foosink<N> */
  type_name = g_quark_to_string (q);
  if (strncmp (type_name, "Gst", 3) == 0)
    type_name += 3;
  /* give the 20th "queue" element and the first "queue2" different names */
  l = strlen (type_name);
  if (l > 0 && g_ascii_isdigit (type_name[l - 1])) {
    name = g_strdup_printf ("%s-%d", type_name, count);
  } else {
    name = g_strdup_printf ("%s%d", type_name, count);
  }

  l = strlen (name);
  for (i = 0; i < l; i++)
    name[i] = g_ascii_tolower (name[i]);

  GST_OBJECT_LOCK (object);
  if (G_UNLIKELY (object->parent != NULL))
    goto had_parent;

  g_free (object->name);
  object->name = name;

  GST_OBJECT_UNLOCK (object);

  return TRUE;

had_parent:
  {
    g_free (name);
    GST_WARNING ("parented objects can't be renamed");
    GST_OBJECT_UNLOCK (object);
    return FALSE;
  }
}

/**
 * gst_object_set_name:
 * @object: a #GstObject
 * @name: (allow-none): new name of object
 *
 * Sets the name of @object, or gives @object a guaranteed unique
 * name (if @name is %NULL).
 * This function makes a copy of the provided name, so the caller
 * retains ownership of the name it sent.
 *
 * Returns: %TRUE if the name could be set. Since Objects that have
 * a parent cannot be renamed, this function returns %FALSE in those
 * cases.
 *
 * MT safe.  This function grabs and releases @object's LOCK.
 */
gboolean
gst_object_set_name (GstObject * object, const gchar * name)
{
  gboolean result;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);

  GST_OBJECT_LOCK (object);

  /* parented objects cannot be renamed */
  if (G_UNLIKELY (object->parent != NULL))
    goto had_parent;

  if (name != NULL) {
    g_free (object->name);
    object->name = g_strdup (name);
    GST_OBJECT_UNLOCK (object);
    result = TRUE;
  } else {
    GST_OBJECT_UNLOCK (object);
    result = gst_object_set_name_default (object);
  }
  /* FIXME-0.11: this misses a g_object_notify (object, "name"); unless called
   * from gst_object_set_property.
   * Ideally remove such custom setters (or make it static).
   */
  return result;

  /* error */
had_parent:
  {
    GST_WARNING ("parented objects can't be renamed");
    GST_OBJECT_UNLOCK (object);
    return FALSE;
  }
}

/**
 * gst_object_get_name:
 * @object: a #GstObject
 *
 * Returns a copy of the name of @object.
 * Caller should g_free() the return value after usage.
 * For a nameless object, this returns %NULL, which you can safely g_free()
 * as well.
 *
 * Free-function: g_free
 *
 * Returns: (transfer full) (nullable): the name of @object. g_free()
 * after usage.
 *
 * MT safe. This function grabs and releases @object's LOCK.
 */
gchar *
gst_object_get_name (GstObject * object)
{
  gchar *result = NULL;

  g_return_val_if_fail (GST_IS_OBJECT (object), NULL);

  GST_OBJECT_LOCK (object);
  result = g_strdup (object->name);
  GST_OBJECT_UNLOCK (object);

  return result;
}

/**
 * gst_object_set_parent:
 * @object: a #GstObject
 * @parent: new parent of object
 *
 * Sets the parent of @object to @parent. The object's reference count will
 * be incremented, and any floating reference will be removed (see gst_object_ref_sink()).
 *
 * Returns: %TRUE if @parent could be set or %FALSE when @object
 * already had a parent or @object and @parent are the same.
 *
 * MT safe. Grabs and releases @object's LOCK.
 */
gboolean
gst_object_set_parent (GstObject * object, GstObject * parent)
{
  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);
  g_return_val_if_fail (GST_IS_OBJECT (parent), FALSE);
  g_return_val_if_fail (object != parent, FALSE);

  GST_CAT_DEBUG_OBJECT (GST_CAT_REFCOUNTING, object,
      "set parent (ref and sink)");

  GST_OBJECT_LOCK (object);
  if (G_UNLIKELY (object->parent != NULL))
    goto had_parent;

  object->parent = parent;
  gst_object_ref_sink (object);
  GST_OBJECT_UNLOCK (object);

  /* FIXME-2.0: this does not work, the deep notify takes the lock from the
   * parent object and deadlocks when the parent holds its lock when calling
   * this function (like _element_add_pad()), we need to use a GRecMutex
   * for locking the parent instead.
   */
  /* g_object_notify_by_pspec ((GObject *)object, properties[PROP_PARENT]); */

  return TRUE;

  /* ERROR handling */
had_parent:
  {
    GST_CAT_DEBUG_OBJECT (GST_CAT_REFCOUNTING, object,
        "set parent failed, object already had a parent");
    GST_OBJECT_UNLOCK (object);
    return FALSE;
  }
}

/**
 * gst_object_get_parent:
 * @object: a #GstObject
 *
 * Returns the parent of @object. This function increases the refcount
 * of the parent object so you should gst_object_unref() it after usage.
 *
 * Returns: (transfer full) (nullable): parent of @object, this can be
 *   %NULL if @object has no parent. unref after usage.
 *
 * MT safe. Grabs and releases @object's LOCK.
 */
GstObject *
gst_object_get_parent (GstObject * object)
{
  GstObject *result = NULL;

  g_return_val_if_fail (GST_IS_OBJECT (object), NULL);

  GST_OBJECT_LOCK (object);
  result = object->parent;
  if (G_LIKELY (result))
    gst_object_ref (result);
  GST_OBJECT_UNLOCK (object);

  return result;
}

/**
 * gst_object_unparent:
 * @object: a #GstObject to unparent
 *
 * Clear the parent of @object, removing the associated reference.
 * This function decreases the refcount of @object.
 *
 * MT safe. Grabs and releases @object's lock.
 */
void
gst_object_unparent (GstObject * object)
{
  GstObject *parent;

  g_return_if_fail (GST_IS_OBJECT (object));

  GST_OBJECT_LOCK (object);
  parent = object->parent;

  if (G_LIKELY (parent != NULL)) {
    GST_CAT_TRACE_OBJECT (GST_CAT_REFCOUNTING, object, "unparent");
    object->parent = NULL;
    GST_OBJECT_UNLOCK (object);

    /* g_object_notify_by_pspec ((GObject *)object, properties[PROP_PARENT]); */

    gst_object_unref (object);
  } else {
    GST_OBJECT_UNLOCK (object);
  }
}

/**
 * gst_object_has_ancestor:
 * @object: a #GstObject to check
 * @ancestor: a #GstObject to check as ancestor
 *
 * Check if @object has an ancestor @ancestor somewhere up in
 * the hierarchy. One can e.g. check if a #GstElement is inside a #GstPipeline.
 *
 * Returns: %TRUE if @ancestor is an ancestor of @object.
 *
 * MT safe. Grabs and releases @object's locks.
 */
gboolean
gst_object_has_ancestor (GstObject * object, GstObject * ancestor)
{
  GstObject *parent, *tmp;

  if (!ancestor || !object)
    return FALSE;

  parent = gst_object_ref (object);
  do {
    if (parent == ancestor) {
      gst_object_unref (parent);
      return TRUE;
    }

    tmp = gst_object_get_parent (parent);
    gst_object_unref (parent);
    parent = tmp;
  } while (parent);

  return FALSE;
}

/**
 * gst_object_check_uniqueness:
 * @list: (transfer none) (element-type Gst.Object): a list of #GstObject to
 *      check through
 * @name: the name to search for
 *
 * Checks to see if there is any object named @name in @list. This function
 * does not do any locking of any kind. You might want to protect the
 * provided list with the lock of the owner of the list. This function
 * will lock each #GstObject in the list to compare the name, so be
 * careful when passing a list with a locked object.
 *
 * Returns: %TRUE if a #GstObject named @name does not appear in @list,
 * %FALSE if it does.
 *
 * MT safe. Grabs and releases the LOCK of each object in the list.
 */
gboolean
gst_object_check_uniqueness (GList * list, const gchar * name)
{
  gboolean result = TRUE;

  g_return_val_if_fail (name != NULL, FALSE);

  for (; list; list = g_list_next (list)) {
    GstObject *child;
    gboolean eq;

    child = GST_OBJECT_CAST (list->data);

    GST_OBJECT_LOCK (child);
    eq = strcmp (GST_OBJECT_NAME (child), name) == 0;
    GST_OBJECT_UNLOCK (child);

    if (G_UNLIKELY (eq)) {
      result = FALSE;
      break;
    }
  }
  return result;
}


static void
gst_object_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstObject *gstobject;

  gstobject = GST_OBJECT_CAST (object);

  switch (prop_id) {
    case PROP_NAME:
      gst_object_set_name (gstobject, g_value_get_string (value));
      break;
    case PROP_PARENT:
      gst_object_set_parent (gstobject, g_value_get_object (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_object_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstObject *gstobject;

  gstobject = GST_OBJECT_CAST (object);

  switch (prop_id) {
    case PROP_NAME:
      g_value_take_string (value, gst_object_get_name (gstobject));
      break;
    case PROP_PARENT:
      g_value_take_object (value, gst_object_get_parent (gstobject));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/**
 * gst_object_get_path_string:
 * @object: a #GstObject
 *
 * Generates a string describing the path of @object in
 * the object hierarchy. Only useful (or used) for debugging.
 *
 * Free-function: g_free
 *
 * Returns: (transfer full): a string describing the path of @object. You must
 *          g_free() the string after usage.
 *
 * MT safe. Grabs and releases the #GstObject's LOCK for all objects
 *          in the hierarchy.
 */
gchar *
gst_object_get_path_string (GstObject * object)
{
  GSList *parentage;
  GSList *parents;
  void *parent;
  gchar *prevpath, *path;
  const gchar *typename;
  gchar *component;
  const gchar *separator;

  /* ref object before adding to list */
  gst_object_ref (object);
  parentage = g_slist_prepend (NULL, object);

  path = g_strdup ("");

  /* first walk the object hierarchy to build a list of the parents,
   * be careful here with refcounting. */
  do {
    if (GST_IS_OBJECT (object)) {
      parent = gst_object_get_parent (object);
      /* add parents to list, refcount remains increased while
       * we handle the object */
      if (parent)
        parentage = g_slist_prepend (parentage, parent);
    } else {
      break;
    }
    object = parent;
  } while (object != NULL);

  /* then walk the parent list and print them out. we need to
   * decrease the refcounting on each element after we handled
   * it. */
  for (parents = parentage; parents; parents = g_slist_next (parents)) {
    if (G_IS_OBJECT (parents->data)) {
      typename = G_OBJECT_TYPE_NAME (parents->data);
    } else {
      typename = NULL;
    }
    if (GST_IS_OBJECT (parents->data)) {
      GstObject *item = GST_OBJECT_CAST (parents->data);
      GstObjectClass *oclass = GST_OBJECT_GET_CLASS (item);
      gchar *objname = gst_object_get_name (item);

      component = g_strdup_printf ("%s:%s", typename, objname);
      separator = oclass->path_string_separator;
      /* and unref now */
      gst_object_unref (item);
      g_free (objname);
    } else {
      if (typename) {
        component = g_strdup_printf ("%s:%p", typename, parents->data);
      } else {
        component = g_strdup_printf ("%p", parents->data);
      }
      separator = "/";
    }

    prevpath = path;
    path = g_strjoin (separator, prevpath, component, NULL);
    g_free (prevpath);
    g_free (component);
  }

  g_slist_free (parentage);

  return path;
}

/* controller helper functions */

/*
 * gst_object_find_control_binding:
 * @self: the gobject to search for a property in
 * @name: the gobject property name to look for
 *
 * Searches the list of properties under control.
 *
 * Returns: (nullable): a #GstControlBinding or %NULL if the property
 * is not being controlled.
 */
static GstControlBinding *
gst_object_find_control_binding (GstObject * self, const gchar * name)
{
  GstControlBinding *binding;
  GList *node;

  for (node = self->control_bindings; node; node = g_list_next (node)) {
    binding = node->data;
    /* FIXME: eventually use GQuark to speed it up */
    if (!strcmp (binding->name, name)) {
      GST_DEBUG_OBJECT (self, "found control binding for property '%s'", name);
      return binding;
    }
  }
  GST_DEBUG_OBJECT (self, "controller does not manage property '%s'", name);

  return NULL;
}

/* controller functions */

/**
 * gst_object_suggest_next_sync:
 * @object: the object that has controlled properties
 *
 * Returns a suggestion for timestamps where buffers should be split
 * to get best controller results.
 *
 * Returns: Returns the suggested timestamp or %GST_CLOCK_TIME_NONE
 * if no control-rate was set.
 */
GstClockTime
gst_object_suggest_next_sync (GstObject * object)
{
  GstClockTime ret;

  g_return_val_if_fail (GST_IS_OBJECT (object), GST_CLOCK_TIME_NONE);
  g_return_val_if_fail (object->control_rate != GST_CLOCK_TIME_NONE,
      GST_CLOCK_TIME_NONE);

  GST_OBJECT_LOCK (object);

  /* TODO: Implement more logic, depending on interpolation mode and control
   * points
   * FIXME: we need playback direction
   */
  ret = object->last_sync + object->control_rate;

  GST_OBJECT_UNLOCK (object);

  return ret;
}

/**
 * gst_object_sync_values:
 * @object: the object that has controlled properties
 * @timestamp: the time that should be processed
 *
 * Sets the properties of the object, according to the #GstControlSources that
 * (maybe) handle them and for the given timestamp.
 *
 * If this function fails, it is most likely the application developers fault.
 * Most probably the control sources are not setup correctly.
 *
 * Returns: %TRUE if the controller values could be applied to the object
 * properties, %FALSE otherwise
 */
gboolean
gst_object_sync_values (GstObject * object, GstClockTime timestamp)
{
  GList *node;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);

  GST_LOG_OBJECT (object, "sync_values");
  if (!object->control_bindings)
    return TRUE;

  /* FIXME: this deadlocks */
  /* GST_OBJECT_LOCK (object); */
  g_object_freeze_notify ((GObject *) object);
  for (node = object->control_bindings; node; node = g_list_next (node)) {
    ret &= gst_control_binding_sync_values ((GstControlBinding *) node->data,
        object, timestamp, object->last_sync);
  }
  object->last_sync = timestamp;
  g_object_thaw_notify ((GObject *) object);
  /* GST_OBJECT_UNLOCK (object); */

  return ret;
}


/**
 * gst_object_has_active_control_bindings:
 * @object: the object that has controlled properties
 *
 * Check if the @object has an active controlled properties.
 *
 * Returns: %TRUE if the object has active controlled properties
 */
gboolean
gst_object_has_active_control_bindings (GstObject * object)
{
  gboolean res = FALSE;
  GList *node;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);

  GST_OBJECT_LOCK (object);
  for (node = object->control_bindings; node; node = g_list_next (node)) {
    res |= !gst_control_binding_is_disabled ((GstControlBinding *) node->data);
  }
  GST_OBJECT_UNLOCK (object);
  return res;
}

/**
 * gst_object_set_control_bindings_disabled:
 * @object: the object that has controlled properties
 * @disabled: boolean that specifies whether to disable the controller
 * or not.
 *
 * This function is used to disable all controlled properties of the @object for
 * some time, i.e. gst_object_sync_values() will do nothing.
 */
void
gst_object_set_control_bindings_disabled (GstObject * object, gboolean disabled)
{
  GList *node;

  g_return_if_fail (GST_IS_OBJECT (object));

  GST_OBJECT_LOCK (object);
  for (node = object->control_bindings; node; node = g_list_next (node)) {
    gst_control_binding_set_disabled ((GstControlBinding *) node->data,
        disabled);
  }
  GST_OBJECT_UNLOCK (object);
}

/**
 * gst_object_set_control_binding_disabled:
 * @object: the object that has controlled properties
 * @property_name: property to disable
 * @disabled: boolean that specifies whether to disable the controller
 * or not.
 *
 * This function is used to disable the control bindings on a property for
 * some time, i.e. gst_object_sync_values() will do nothing for the
 * property.
 */
void
gst_object_set_control_binding_disabled (GstObject * object,
    const gchar * property_name, gboolean disabled)
{
  GstControlBinding *binding;

  g_return_if_fail (GST_IS_OBJECT (object));
  g_return_if_fail (property_name);

  GST_OBJECT_LOCK (object);
  if ((binding = gst_object_find_control_binding (object, property_name))) {
    gst_control_binding_set_disabled (binding, disabled);
  }
  GST_OBJECT_UNLOCK (object);
}


/**
 * gst_object_add_control_binding:
 * @object: the controller object
 * @binding: (transfer full): the #GstControlBinding that should be used
 *
 * Attach the #GstControlBinding to the object. If there already was a
 * #GstControlBinding for this property it will be replaced.
 *
 * The @object will take ownership of the @binding.
 *
 * Returns: %FALSE if the given @binding has not been setup for this object or
 * has been setup for a non suitable property, %TRUE otherwise.
 */
gboolean
gst_object_add_control_binding (GstObject * object, GstControlBinding * binding)
{
  GstControlBinding *old;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);
  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), FALSE);
  g_return_val_if_fail (binding->pspec, FALSE);

  GST_OBJECT_LOCK (object);
  if ((old = gst_object_find_control_binding (object, binding->name))) {
    GST_DEBUG_OBJECT (object, "controlled property %s removed", old->name);
    object->control_bindings = g_list_remove (object->control_bindings, old);
    gst_object_unparent (GST_OBJECT_CAST (old));
  }
  object->control_bindings = g_list_prepend (object->control_bindings, binding);
  gst_object_set_parent (GST_OBJECT_CAST (binding), object);
  GST_DEBUG_OBJECT (object, "controlled property %s added", binding->name);
  GST_OBJECT_UNLOCK (object);

  return TRUE;
}

/**
 * gst_object_get_control_binding:
 * @object: the object
 * @property_name: name of the property
 *
 * Gets the corresponding #GstControlBinding for the property. This should be
 * unreferenced again after use.
 *
 * Returns: (transfer full) (nullable): the #GstControlBinding for
 * @property_name or %NULL if the property is not controlled.
 */
GstControlBinding *
gst_object_get_control_binding (GstObject * object, const gchar * property_name)
{
  GstControlBinding *binding;

  g_return_val_if_fail (GST_IS_OBJECT (object), NULL);
  g_return_val_if_fail (property_name, NULL);

  GST_OBJECT_LOCK (object);
  if ((binding = gst_object_find_control_binding (object, property_name))) {
    gst_object_ref (binding);
  }
  GST_OBJECT_UNLOCK (object);

  return binding;
}

/**
 * gst_object_remove_control_binding:
 * @object: the object
 * @binding: the binding
 *
 * Removes the corresponding #GstControlBinding. If it was the
 * last ref of the binding, it will be disposed.  
 *
 * Returns: %TRUE if the binding could be removed.
 */
gboolean
gst_object_remove_control_binding (GstObject * object,
    GstControlBinding * binding)
{
  GList *node;
  gboolean ret = FALSE;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);
  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), FALSE);

  GST_OBJECT_LOCK (object);
  if ((node = g_list_find (object->control_bindings, binding))) {
    GST_DEBUG_OBJECT (object, "controlled property %s removed", binding->name);
    object->control_bindings =
        g_list_delete_link (object->control_bindings, node);
    gst_object_unparent (GST_OBJECT_CAST (binding));
    ret = TRUE;
  }
  GST_OBJECT_UNLOCK (object);

  return ret;
}

/**
 * gst_object_get_value:
 * @object: the object that has controlled properties
 * @property_name: the name of the property to get
 * @timestamp: the time the control-change should be read from
 *
 * Gets the value for the given controlled property at the requested time.
 *
 * Returns: (nullable): the GValue of the property at the given time,
 * or %NULL if the property isn't controlled.
 */
GValue *
gst_object_get_value (GstObject * object, const gchar * property_name,
    GstClockTime timestamp)
{
  GstControlBinding *binding;
  GValue *val = NULL;

  g_return_val_if_fail (GST_IS_OBJECT (object), NULL);
  g_return_val_if_fail (property_name, NULL);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), NULL);

  GST_OBJECT_LOCK (object);
  if ((binding = gst_object_find_control_binding (object, property_name))) {
    val = gst_control_binding_get_value (binding, timestamp);
  }
  GST_OBJECT_UNLOCK (object);

  return val;
}

/**
 * gst_object_get_value_array:
 * @object: the object that has controlled properties
 * @property_name: the name of the property to get
 * @timestamp: the time that should be processed
 * @interval: the time spacing between subsequent values
 * @n_values: the number of values
 * @values: array to put control-values in
 *
 * Gets a number of values for the given controlled property starting at the
 * requested time. The array @values need to hold enough space for @n_values of
 * the same type as the objects property's type.
 *
 * This function is useful if one wants to e.g. draw a graph of the control
 * curve or apply a control curve sample by sample.
 *
 * The values are unboxed and ready to be used. The similar function 
 * gst_object_get_g_value_array() returns the array as #GValues and is
 * better suites for bindings.
 *
 * Returns: %TRUE if the given array could be filled, %FALSE otherwise
 */
gboolean
gst_object_get_value_array (GstObject * object, const gchar * property_name,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gpointer values)
{
  gboolean res = FALSE;
  GstControlBinding *binding;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);
  g_return_val_if_fail (property_name, FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (interval), FALSE);
  g_return_val_if_fail (values, FALSE);

  GST_OBJECT_LOCK (object);
  if ((binding = gst_object_find_control_binding (object, property_name))) {
    res = gst_control_binding_get_value_array (binding, timestamp, interval,
        n_values, values);
  }
  GST_OBJECT_UNLOCK (object);
  return res;
}

/**
 * gst_object_get_g_value_array:
 * @object: the object that has controlled properties
 * @property_name: the name of the property to get
 * @timestamp: the time that should be processed
 * @interval: the time spacing between subsequent values
 * @n_values: the number of values
 * @values: array to put control-values in
 *
 * Gets a number of #GValues for the given controlled property starting at the
 * requested time. The array @values need to hold enough space for @n_values of
 * #GValue.
 *
 * This function is useful if one wants to e.g. draw a graph of the control
 * curve or apply a control curve sample by sample.
 *
 * Returns: %TRUE if the given array could be filled, %FALSE otherwise
 */
gboolean
gst_object_get_g_value_array (GstObject * object, const gchar * property_name,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    GValue * values)
{
  gboolean res = FALSE;
  GstControlBinding *binding;

  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);
  g_return_val_if_fail (property_name, FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (interval), FALSE);
  g_return_val_if_fail (values, FALSE);

  GST_OBJECT_LOCK (object);
  if ((binding = gst_object_find_control_binding (object, property_name))) {
    res = gst_control_binding_get_g_value_array (binding, timestamp, interval,
        n_values, values);
  }
  GST_OBJECT_UNLOCK (object);
  return res;
}


/**
 * gst_object_get_control_rate:
 * @object: the object that has controlled properties
 *
 * Obtain the control-rate for this @object. Audio processing #GstElement
 * objects will use this rate to sub-divide their processing loop and call
 * gst_object_sync_values() inbetween. The length of the processing segment
 * should be up to @control-rate nanoseconds.
 *
 * If the @object is not under property control, this will return
 * %GST_CLOCK_TIME_NONE. This allows the element to avoid the sub-dividing.
 *
 * The control-rate is not expected to change if the element is in
 * %GST_STATE_PAUSED or %GST_STATE_PLAYING.
 *
 * Returns: the control rate in nanoseconds
 */
GstClockTime
gst_object_get_control_rate (GstObject * object)
{
  g_return_val_if_fail (GST_IS_OBJECT (object), FALSE);

  return object->control_rate;
}

/**
 * gst_object_set_control_rate:
 * @object: the object that has controlled properties
 * @control_rate: the new control-rate in nanoseconds.
 *
 * Change the control-rate for this @object. Audio processing #GstElement
 * objects will use this rate to sub-divide their processing loop and call
 * gst_object_sync_values() inbetween. The length of the processing segment
 * should be up to @control-rate nanoseconds.
 *
 * The control-rate should not change if the element is in %GST_STATE_PAUSED or
 * %GST_STATE_PLAYING.
 */
void
gst_object_set_control_rate (GstObject * object, GstClockTime control_rate)
{
  g_return_if_fail (GST_IS_OBJECT (object));

  object->control_rate = control_rate;
}
