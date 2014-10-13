/* GStreamer
 *
 * Copyright (C) 2011 Stefan Sauer <ensonic@users.sf.net>
 *
 * gstcontrolbinding.c: Attachment for control sources
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
 * SECTION:gstcontrolbinding
 * @short_description: attachment for control source sources
 *
 * A base class for value mapping objects that attaches control sources to gobject
 * properties. Such an object is taking one or more #GstControlSource instances,
 * combines them and maps the resulting value to the type and value range of the
 * bound property.
 */
/* FIXME(ensonic): should we make gst_object_add_control_binding() internal
 * - we create the control_binding for a certain object anyway
 * - we could call gst_object_add_control_binding() at the end of
 *   gst_control_binding_constructor()
 * - the weak-ref on object is not nice, as is the same as gst_object_parent()
 *   once the object is added to the parent
 *
 * - another option would be to defer what is done in _constructor to when
 *   the parent is set (need to listen to the signal then)
 *   then basically I could
 *   a) remove the obj arg and wait the binding to be added or
 *   b) add the binding from constructor, unref object there and make obj
 *      writeonly
 */

#include "gst_private.h"

#include <glib-object.h>
#include <gst/gst.h>

#include "gstcontrolbinding.h"

#include <math.h>

#define GST_CAT_DEFAULT control_binding_debug
GST_DEBUG_CATEGORY_STATIC (GST_CAT_DEFAULT);

#define _do_init \
  GST_DEBUG_CATEGORY_INIT (GST_CAT_DEFAULT, "gstcontrolbinding", 0, \
      "dynamic parameter control source attachment");

static GObject *gst_control_binding_constructor (GType type,
    guint n_construct_params, GObjectConstructParam * construct_params);
static void gst_control_binding_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_control_binding_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_control_binding_dispose (GObject * object);
static void gst_control_binding_finalize (GObject * object);

G_DEFINE_ABSTRACT_TYPE_WITH_CODE (GstControlBinding, gst_control_binding,
    GST_TYPE_OBJECT, _do_init);

enum
{
  PROP_0,
  PROP_OBJECT,
  PROP_NAME,
  PROP_LAST
};

static GParamSpec *properties[PROP_LAST];

static void
gst_control_binding_class_init (GstControlBindingClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  gobject_class->constructor = gst_control_binding_constructor;
  gobject_class->set_property = gst_control_binding_set_property;
  gobject_class->get_property = gst_control_binding_get_property;
  gobject_class->dispose = gst_control_binding_dispose;
  gobject_class->finalize = gst_control_binding_finalize;

  properties[PROP_OBJECT] =
      g_param_spec_object ("object", "Object",
      "The object of the property", GST_TYPE_OBJECT,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS);

  properties[PROP_NAME] =
      g_param_spec_string ("name", "Name", "The name of the property", NULL,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT_ONLY | G_PARAM_STATIC_STRINGS);


  g_object_class_install_properties (gobject_class, PROP_LAST, properties);
}

static void
gst_control_binding_init (GstControlBinding * binding)
{
}

static GObject *
gst_control_binding_constructor (GType type, guint n_construct_params,
    GObjectConstructParam * construct_params)
{
  GstControlBinding *binding;
  GParamSpec *pspec;

  binding =
      GST_CONTROL_BINDING (G_OBJECT_CLASS (gst_control_binding_parent_class)
      ->constructor (type, n_construct_params, construct_params));

  GST_INFO_OBJECT (binding->object, "trying to put property '%s' under control",
      binding->name);

  /* check if the object has a property of that name */
  if ((pspec =
          g_object_class_find_property (G_OBJECT_GET_CLASS (binding->object),
              binding->name))) {
    GST_DEBUG_OBJECT (binding->object, "  psec->flags : 0x%08x", pspec->flags);

    /* check if this param is witable && controlable && !construct-only */
    if ((pspec->flags & (G_PARAM_WRITABLE | GST_PARAM_CONTROLLABLE |
                G_PARAM_CONSTRUCT_ONLY)) ==
        (G_PARAM_WRITABLE | GST_PARAM_CONTROLLABLE)) {
      binding->pspec = pspec;
    } else {
      GST_WARNING_OBJECT (binding->object,
          "property '%s' on class '%s' needs to "
          "be writeable, controlable and not construct_only", binding->name,
          G_OBJECT_TYPE_NAME (binding->object));
    }
  } else {
    GST_WARNING_OBJECT (binding->object, "class '%s' has no property '%s'",
        G_OBJECT_TYPE_NAME (binding->object), binding->name);
  }
  return (GObject *) binding;
}

static void
gst_control_binding_dispose (GObject * object)
{
  GstControlBinding *self = GST_CONTROL_BINDING (object);

  /* we did not took a reference */
  g_object_remove_weak_pointer ((GObject *) self->object,
      (gpointer *) & self->object);
  self->object = NULL;

  ((GObjectClass *) gst_control_binding_parent_class)->dispose (object);
}

static void
gst_control_binding_finalize (GObject * object)
{
  GstControlBinding *self = GST_CONTROL_BINDING (object);

  g_free (self->name);

  ((GObjectClass *) gst_control_binding_parent_class)->finalize (object);
}

static void
gst_control_binding_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstControlBinding *self = GST_CONTROL_BINDING (object);

  switch (prop_id) {
    case PROP_OBJECT:
      /* do not ref to avoid a ref cycle */
      self->object = g_value_get_object (value);
      g_object_add_weak_pointer ((GObject *) self->object,
          (gpointer *) & self->object);
      break;
    case PROP_NAME:
      self->name = g_value_dup_string (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_control_binding_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstControlBinding *self = GST_CONTROL_BINDING (object);

  switch (prop_id) {
    case PROP_OBJECT:
      g_value_set_object (value, self->object);
      break;
    case PROP_NAME:
      g_value_set_string (value, self->name);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

/* functions */

/**
 * gst_control_binding_sync_values:
 * @binding: the control binding
 * @object: the object that has controlled properties
 * @timestamp: the time that should be processed
 * @last_sync: the last time this was called
 *
 * Sets the property of the @object, according to the #GstControlSources that
 * handle them and for the given timestamp.
 *
 * If this function fails, it is most likely the application developers fault.
 * Most probably the control sources are not setup correctly.
 *
 * Returns: %TRUE if the controller value could be applied to the object
 * property, %FALSE otherwise
 */
gboolean
gst_control_binding_sync_values (GstControlBinding * binding,
    GstObject * object, GstClockTime timestamp, GstClockTime last_sync)
{
  GstControlBindingClass *klass;
  gboolean ret = FALSE;

  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), FALSE);

  if (binding->disabled)
    return TRUE;

  klass = GST_CONTROL_BINDING_GET_CLASS (binding);

  if (G_LIKELY (klass->sync_values != NULL)) {
    ret = klass->sync_values (binding, object, timestamp, last_sync);
  } else {
    GST_WARNING_OBJECT (binding, "missing sync_values implementation");
  }
  return ret;
}

/**
 * gst_control_binding_get_value:
 * @binding: the control binding
 * @timestamp: the time the control-change should be read from
 *
 * Gets the value for the given controlled property at the requested time.
 *
 * Returns: (nullable): the GValue of the property at the given time,
 * or %NULL if the property isn't controlled.
 */
GValue *
gst_control_binding_get_value (GstControlBinding * binding,
    GstClockTime timestamp)
{
  GstControlBindingClass *klass;
  GValue *ret = NULL;

  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), NULL);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), NULL);

  klass = GST_CONTROL_BINDING_GET_CLASS (binding);

  if (G_LIKELY (klass->get_value != NULL)) {
    ret = klass->get_value (binding, timestamp);
  } else {
    GST_WARNING_OBJECT (binding, "missing get_value implementation");
  }
  return ret;
}

/**
 * gst_control_binding_get_value_array: (skip)
 * @binding: the control binding
 * @timestamp: the time that should be processed
 * @interval: the time spacing between subsequent values
 * @n_values: the number of values
 * @values: (array length=n_values): array to put control-values in
 *
 * Gets a number of values for the given controlled property starting at the
 * requested time. The array @values need to hold enough space for @n_values of
 * the same type as the objects property's type.
 *
 * This function is useful if one wants to e.g. draw a graph of the control
 * curve or apply a control curve sample by sample.
 *
 * The values are unboxed and ready to be used. The similar function 
 * gst_control_binding_get_g_value_array() returns the array as #GValues and is
 * more suitable for bindings.
 *
 * Returns: %TRUE if the given array could be filled, %FALSE otherwise
 */
gboolean
gst_control_binding_get_value_array (GstControlBinding * binding,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gpointer values)
{
  GstControlBindingClass *klass;
  gboolean ret = FALSE;

  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (interval), FALSE);
  g_return_val_if_fail (values, FALSE);

  klass = GST_CONTROL_BINDING_GET_CLASS (binding);

  if (G_LIKELY (klass->get_value_array != NULL)) {
    ret =
        klass->get_value_array (binding, timestamp, interval, n_values, values);
  } else {
    GST_WARNING_OBJECT (binding, "missing get_value_array implementation");
  }
  return ret;
}

#define CONVERT_ARRAY(type,TYPE) \
{ \
  g##type *v = g_new (g##type,n_values); \
  ret = gst_control_binding_get_value_array (binding, timestamp, interval, \
      n_values, v); \
  if (ret) { \
    for (i = 0; i < n_values; i++) { \
      g_value_init (&values[i], G_TYPE_##TYPE); \
      g_value_set_##type (&values[i], v[i]); \
    } \
  } \
  g_free (v); \
}

/**
 * gst_control_binding_get_g_value_array:
 * @binding: the control binding
 * @timestamp: the time that should be processed
 * @interval: the time spacing between subsequent values
 * @n_values: the number of values
 * @values: (array length=n_values): array to put control-values in
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
gst_control_binding_get_g_value_array (GstControlBinding * binding,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    GValue * values)
{
  GstControlBindingClass *klass;
  gboolean ret = FALSE;

  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (interval), FALSE);
  g_return_val_if_fail (values, FALSE);

  klass = GST_CONTROL_BINDING_GET_CLASS (binding);

  if (G_LIKELY (klass->get_g_value_array != NULL)) {
    ret =
        klass->get_g_value_array (binding, timestamp, interval, n_values,
        values);
  } else {
    guint i;
    GType type, base;

    base = type = G_PARAM_SPEC_VALUE_TYPE (GST_CONTROL_BINDING_PSPEC (binding));
    while ((type = g_type_parent (type)))
      base = type;

    GST_INFO_OBJECT (binding, "missing get_g_value_array implementation, we're "
        "emulating it");
    switch (base) {
      case G_TYPE_INT:
        CONVERT_ARRAY (int, INT);
        break;
      case G_TYPE_UINT:
        CONVERT_ARRAY (uint, UINT);
        break;
      case G_TYPE_LONG:
        CONVERT_ARRAY (long, LONG);
        break;
      case G_TYPE_ULONG:
        CONVERT_ARRAY (ulong, ULONG);
        break;
      case G_TYPE_INT64:
        CONVERT_ARRAY (int64, INT64);
        break;
      case G_TYPE_UINT64:
        CONVERT_ARRAY (uint64, UINT64);
        break;
      case G_TYPE_FLOAT:
        CONVERT_ARRAY (float, FLOAT);
        break;
      case G_TYPE_DOUBLE:
        CONVERT_ARRAY (double, DOUBLE);
        break;
      case G_TYPE_BOOLEAN:
        CONVERT_ARRAY (boolean, BOOLEAN);
        break;
      case G_TYPE_ENUM:
      {
        gint *v = g_new (gint, n_values);
        ret = gst_control_binding_get_value_array (binding, timestamp, interval,
            n_values, v);
        if (ret) {
          for (i = 0; i < n_values; i++) {
            g_value_init (&values[i], type);
            g_value_set_enum (&values[i], v[i]);
          }
        }
        g_free (v);
      }
        break;
      default:
        GST_WARNING ("incomplete implementation for paramspec type '%s'",
            G_PARAM_SPEC_TYPE_NAME (GST_CONTROL_BINDING_PSPEC (binding)));
        GST_CONTROL_BINDING_PSPEC (binding) = NULL;
        break;
    }
  }
  return ret;
}

/**
 * gst_control_binding_set_disabled:
 * @binding: the control binding
 * @disabled: boolean that specifies whether to disable the controller
 * or not.
 *
 * This function is used to disable a control binding for some time, i.e.
 * gst_object_sync_values() will do nothing.
 */
void
gst_control_binding_set_disabled (GstControlBinding * binding,
    gboolean disabled)
{
  g_return_if_fail (GST_IS_CONTROL_BINDING (binding));
  binding->disabled = disabled;
}

/**
 * gst_control_binding_is_disabled:
 * @binding: the control binding
 *
 * Check if the control binding is disabled.
 *
 * Returns: %TRUE if the binding is inactive
 */
gboolean
gst_control_binding_is_disabled (GstControlBinding * binding)
{
  g_return_val_if_fail (GST_IS_CONTROL_BINDING (binding), TRUE);
  return (binding->disabled == TRUE);
}
