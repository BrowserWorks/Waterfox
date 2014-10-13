/* GStreamer
 *
 * Copyright (C) 2011 Stefan Sauer <ensonic@users.sf.net>
 *
 * gstargbcontrolbinding.c: Attachment for multiple control sources to gargb
 *                            properties
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
 * SECTION:gstargbcontrolbinding
 * @short_description: attachment for control sources to argb properties
 *
 * A value mapping object that attaches multiple control sources to a guint
 * gobject properties representing a color. A control value of 0.0 will turn the
 * color component off and a value of 1.0 will be the color level.
 */

#include <glib-object.h>
#include <gst/gst.h>

#include "gstargbcontrolbinding.h"

#include <gst/math-compat.h>

#define GST_CAT_DEFAULT control_binding_debug
GST_DEBUG_CATEGORY_STATIC (GST_CAT_DEFAULT);

static GObject *gst_argb_control_binding_constructor (GType type,
    guint n_construct_params, GObjectConstructParam * construct_params);
static void gst_argb_control_binding_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_argb_control_binding_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);
static void gst_argb_control_binding_dispose (GObject * object);
static void gst_argb_control_binding_finalize (GObject * object);

static gboolean gst_argb_control_binding_sync_values (GstControlBinding * _self,
    GstObject * object, GstClockTime timestamp, GstClockTime last_sync);
static GValue *gst_argb_control_binding_get_value (GstControlBinding * _self,
    GstClockTime timestamp);
static gboolean gst_argb_control_binding_get_value_array (GstControlBinding *
    _self, GstClockTime timestamp, GstClockTime interval, guint n_values,
    gpointer values);
static gboolean gst_argb_control_binding_get_g_value_array (GstControlBinding *
    _self, GstClockTime timestamp, GstClockTime interval, guint n_values,
    GValue * values);

#define _do_init \
  GST_DEBUG_CATEGORY_INIT (GST_CAT_DEFAULT, "gstargbcontrolbinding", 0, \
      "dynamic parameter control source attachment");

#define gst_argb_control_binding_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstARGBControlBinding, gst_argb_control_binding,
    GST_TYPE_CONTROL_BINDING, _do_init);

enum
{
  PROP_0,
  PROP_CS_A,
  PROP_CS_R,
  PROP_CS_G,
  PROP_CS_B,
  PROP_LAST
};

static GParamSpec *properties[PROP_LAST];

/* vmethods */

static void
gst_argb_control_binding_class_init (GstARGBControlBindingClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstControlBindingClass *control_binding_class =
      GST_CONTROL_BINDING_CLASS (klass);

  gobject_class->constructor = gst_argb_control_binding_constructor;
  gobject_class->set_property = gst_argb_control_binding_set_property;
  gobject_class->get_property = gst_argb_control_binding_get_property;
  gobject_class->dispose = gst_argb_control_binding_dispose;
  gobject_class->finalize = gst_argb_control_binding_finalize;

  control_binding_class->sync_values = gst_argb_control_binding_sync_values;
  control_binding_class->get_value = gst_argb_control_binding_get_value;
  control_binding_class->get_value_array =
      gst_argb_control_binding_get_value_array;
  control_binding_class->get_g_value_array =
      gst_argb_control_binding_get_g_value_array;

  properties[PROP_CS_A] =
      g_param_spec_object ("control-source-a", "ControlSource A",
      "The control source for the alpha color component",
      GST_TYPE_CONTROL_SOURCE,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS);

  properties[PROP_CS_R] =
      g_param_spec_object ("control-source-r", "ControlSource R",
      "The control source for the red color component",
      GST_TYPE_CONTROL_SOURCE,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS);

  properties[PROP_CS_G] =
      g_param_spec_object ("control-source-g", "ControlSource G",
      "The control source for the green color component",
      GST_TYPE_CONTROL_SOURCE,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS);

  properties[PROP_CS_B] =
      g_param_spec_object ("control-source-b", "ControlSource B",
      "The control source for the blue color component",
      GST_TYPE_CONTROL_SOURCE,
      G_PARAM_READWRITE | G_PARAM_CONSTRUCT | G_PARAM_STATIC_STRINGS);

  g_object_class_install_properties (gobject_class, PROP_LAST, properties);
}

static void
gst_argb_control_binding_init (GstARGBControlBinding * self)
{
}

static GObject *
gst_argb_control_binding_constructor (GType type, guint n_construct_params,
    GObjectConstructParam * construct_params)
{
  GstARGBControlBinding *self;

  self =
      GST_ARGB_CONTROL_BINDING (G_OBJECT_CLASS (parent_class)->constructor
      (type, n_construct_params, construct_params));

  if (GST_CONTROL_BINDING_PSPEC (self)) {
    if (!(G_PARAM_SPEC_VALUE_TYPE (GST_CONTROL_BINDING_PSPEC (self)) ==
            G_TYPE_UINT)) {
      GST_WARNING ("can't bind to paramspec type '%s'",
          G_PARAM_SPEC_TYPE_NAME (GST_CONTROL_BINDING_PSPEC (self)));
      GST_CONTROL_BINDING_PSPEC (self) = NULL;
    } else {
      g_value_init (&self->cur_value, G_TYPE_UINT);
    }
  }
  return (GObject *) self;
}

static void
gst_argb_control_binding_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (object);

  switch (prop_id) {
    case PROP_CS_A:
      gst_object_replace ((GstObject **) & self->cs_a,
          g_value_dup_object (value));
      break;
    case PROP_CS_R:
      gst_object_replace ((GstObject **) & self->cs_r,
          g_value_dup_object (value));
      break;
    case PROP_CS_G:
      gst_object_replace ((GstObject **) & self->cs_g,
          g_value_dup_object (value));
      break;
    case PROP_CS_B:
      gst_object_replace ((GstObject **) & self->cs_b,
          g_value_dup_object (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_argb_control_binding_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (object);

  switch (prop_id) {
    case PROP_CS_A:
      g_value_set_object (value, self->cs_a);
      break;
    case PROP_CS_R:
      g_value_set_object (value, self->cs_r);
      break;
    case PROP_CS_G:
      g_value_set_object (value, self->cs_g);
      break;
    case PROP_CS_B:
      g_value_set_object (value, self->cs_b);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_argb_control_binding_dispose (GObject * object)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (object);

  gst_object_replace ((GstObject **) & self->cs_a, NULL);
  gst_object_replace ((GstObject **) & self->cs_r, NULL);
  gst_object_replace ((GstObject **) & self->cs_g, NULL);
  gst_object_replace ((GstObject **) & self->cs_b, NULL);

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_argb_control_binding_finalize (GObject * object)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (object);

  g_value_unset (&self->cur_value);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
gst_argb_control_binding_sync_values (GstControlBinding * _self,
    GstObject * object, GstClockTime timestamp, GstClockTime last_sync)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (_self);
  gdouble src_val_a = 1.0, src_val_r = 0.0, src_val_g = 0.0, src_val_b = 0.0;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_IS_ARGB_CONTROL_BINDING (self), FALSE);
  g_return_val_if_fail (GST_CONTROL_BINDING_PSPEC (self), FALSE);

  GST_LOG_OBJECT (object, "property '%s' at ts=%" GST_TIME_FORMAT,
      _self->name, GST_TIME_ARGS (timestamp));

  if (self->cs_a)
    ret &= gst_control_source_get_value (self->cs_a, timestamp, &src_val_a);
  if (self->cs_r)
    ret &= gst_control_source_get_value (self->cs_r, timestamp, &src_val_r);
  if (self->cs_g)
    ret &= gst_control_source_get_value (self->cs_g, timestamp, &src_val_g);
  if (self->cs_b)
    ret &= gst_control_source_get_value (self->cs_b, timestamp, &src_val_b);
  if (G_LIKELY (ret)) {
    guint src_val = (((guint) (CLAMP (src_val_a, 0.0, 1.0) * 255)) << 24) |
        (((guint) (CLAMP (src_val_r, 0.0, 1.0) * 255)) << 16) |
        (((guint) (CLAMP (src_val_g, 0.0, 1.0) * 255)) << 8) |
        ((guint) (CLAMP (src_val_b, 0.0, 1.0) * 255));
    GST_LOG_OBJECT (object, "  new value 0x%08x", src_val);
    /* always set the value for first time, but then only if it changed
     * this should limit g_object_notify invocations.
     * FIXME: can we detect negative playback rates?
     */
    if ((timestamp < last_sync) || (src_val != self->last_value)) {
      GValue *dst_val = &self->cur_value;

      g_value_set_uint (dst_val, src_val);
      /* we can make this faster
       * http://bugzilla.gnome.org/show_bug.cgi?id=536939
       */
      g_object_set_property ((GObject *) object, _self->name, dst_val);
      self->last_value = src_val;
    }
  } else {
    GST_DEBUG_OBJECT (object, "no control value for param %s", _self->name);
  }
  return (ret);
}

static GValue *
gst_argb_control_binding_get_value (GstControlBinding * _self,
    GstClockTime timestamp)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (_self);
  GValue *dst_val = NULL;
  gdouble src_val_a = 1.0, src_val_r = 0.0, src_val_g = 0.0, src_val_b = 0.0;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_IS_ARGB_CONTROL_BINDING (self), NULL);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), NULL);
  g_return_val_if_fail (GST_CONTROL_BINDING_PSPEC (self), FALSE);

  /* get current value via control source */
  if (self->cs_a)
    ret &= gst_control_source_get_value (self->cs_a, timestamp, &src_val_a);
  if (self->cs_r)
    ret &= gst_control_source_get_value (self->cs_r, timestamp, &src_val_r);
  if (self->cs_g)
    ret &= gst_control_source_get_value (self->cs_g, timestamp, &src_val_g);
  if (self->cs_b)
    ret &= gst_control_source_get_value (self->cs_b, timestamp, &src_val_b);
  if (G_LIKELY (ret)) {
    guint src_val = (((guint) (CLAMP (src_val_a, 0.0, 1.0) * 255)) << 24) |
        (((guint) (CLAMP (src_val_r, 0.0, 1.0) * 255)) << 16) |
        (((guint) (CLAMP (src_val_g, 0.0, 1.0) * 255)) << 8) |
        ((guint) (CLAMP (src_val_b, 0.0, 1.0) * 255));
    dst_val = g_new0 (GValue, 1);
    g_value_init (dst_val, G_TYPE_UINT);
    g_value_set_uint (dst_val, src_val);
  } else {
    GST_LOG ("no control value for property %s at ts %" GST_TIME_FORMAT,
        _self->name, GST_TIME_ARGS (timestamp));
  }

  return dst_val;
}

static gboolean
gst_argb_control_binding_get_value_array (GstControlBinding * _self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gpointer values_)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (_self);
  gint i;
  gdouble *src_val_a = NULL, *src_val_r = NULL, *src_val_g = NULL, *src_val_b =
      NULL;
  guint *values = (guint *) values_;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_IS_ARGB_CONTROL_BINDING (self), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (interval), FALSE);
  g_return_val_if_fail (values, FALSE);
  g_return_val_if_fail (GST_CONTROL_BINDING_PSPEC (self), FALSE);

  if (self->cs_a) {
    src_val_a = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_a, timestamp,
        interval, n_values, src_val_a);
  }
  if (self->cs_r) {
    src_val_r = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_r, timestamp,
        interval, n_values, src_val_r);
  }
  if (self->cs_g) {
    src_val_g = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_g, timestamp,
        interval, n_values, src_val_g);
  }
  if (self->cs_b) {
    src_val_b = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_b, timestamp,
        interval, n_values, src_val_b);
  }
  if (G_LIKELY (ret)) {
    for (i = 0; i < n_values; i++) {
      gdouble a = 1.0, r = 0.0, g = 0.0, b = 0.0;
      if (src_val_a && !isnan (src_val_a[i]))
        a = src_val_a[i];
      if (src_val_r && !isnan (src_val_r[i]))
        r = src_val_r[i];
      if (src_val_g && !isnan (src_val_g[i]))
        g = src_val_g[i];
      if (src_val_b && !isnan (src_val_b[i]))
        b = src_val_b[i];
      values[i] = (((guint) (CLAMP (a, 0.0, 1.0) * 255)) << 24) |
          (((guint) (CLAMP (r, 0.0, 1.0) * 255)) << 16) |
          (((guint) (CLAMP (g, 0.0, 1.0) * 255)) << 8) |
          ((guint) (CLAMP (b, 0.0, 1.0) * 255));
    }
  } else {
    GST_LOG ("failed to get control value for property %s at ts %"
        GST_TIME_FORMAT, _self->name, GST_TIME_ARGS (timestamp));
  }
  g_free (src_val_a);
  g_free (src_val_r);
  g_free (src_val_g);
  g_free (src_val_b);
  return ret;
}

static gboolean
gst_argb_control_binding_get_g_value_array (GstControlBinding * _self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    GValue * values)
{
  GstARGBControlBinding *self = GST_ARGB_CONTROL_BINDING (_self);
  gint i;
  gdouble *src_val_a = NULL, *src_val_r = NULL, *src_val_g = NULL, *src_val_b =
      NULL;
  guint src_val;
  gboolean ret = TRUE;

  g_return_val_if_fail (GST_IS_ARGB_CONTROL_BINDING (self), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (timestamp), FALSE);
  g_return_val_if_fail (GST_CLOCK_TIME_IS_VALID (interval), FALSE);
  g_return_val_if_fail (values, FALSE);
  g_return_val_if_fail (GST_CONTROL_BINDING_PSPEC (self), FALSE);

  if (self->cs_a) {
    src_val_a = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_a, timestamp,
        interval, n_values, src_val_a);
  }
  if (self->cs_r) {
    src_val_r = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_r, timestamp,
        interval, n_values, src_val_r);
  }
  if (self->cs_g) {
    src_val_g = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_g, timestamp,
        interval, n_values, src_val_g);
  }
  if (self->cs_b) {
    src_val_b = g_new0 (gdouble, n_values);
    ret &= gst_control_source_get_value_array (self->cs_b, timestamp,
        interval, n_values, src_val_b);
  }
  if (G_LIKELY (ret)) {
    for (i = 0; i < n_values; i++) {
      gdouble a = 1.0, r = 0.0, g = 0.0, b = 0.0;
      if (src_val_a && !isnan (src_val_a[i]))
        a = src_val_a[i];
      if (src_val_r && !isnan (src_val_r[i]))
        r = src_val_r[i];
      if (src_val_g && !isnan (src_val_g[i]))
        g = src_val_g[i];
      if (src_val_b && !isnan (src_val_b[i]))
        b = src_val_b[i];
      src_val = (((guint) (CLAMP (a, 0.0, 1.0) * 255)) << 24) |
          (((guint) (CLAMP (r, 0.0, 1.0) * 255)) << 16) |
          (((guint) (CLAMP (g, 0.0, 1.0) * 255)) << 8) |
          ((guint) (CLAMP (b, 0.0, 1.0) * 255));
      g_value_init (&values[i], G_TYPE_UINT);
      g_value_set_uint (&values[i], src_val);
    }
  } else {
    GST_LOG ("failed to get control value for property %s at ts %"
        GST_TIME_FORMAT, _self->name, GST_TIME_ARGS (timestamp));
  }
  g_free (src_val_a);
  g_free (src_val_r);
  g_free (src_val_g);
  g_free (src_val_b);
  return ret;
}

/* functions */

/**
 * gst_argb_control_binding_new:
 * @object: the object of the property
 * @property_name: the property-name to attach the control source
 * @cs_a: the control source for the alpha channel
 * @cs_r: the control source for the red channel
 * @cs_g: the control source for the green channel
 * @cs_b: the control source for the blue channel
 *
 * Create a new control-binding that attaches the given #GstControlSource to the
 * #GObject property.
 *
 * Returns: (transfer floating): the new #GstARGBControlBinding
 */
GstControlBinding *
gst_argb_control_binding_new (GstObject * object, const gchar * property_name,
    GstControlSource * cs_a, GstControlSource * cs_r, GstControlSource * cs_g,
    GstControlSource * cs_b)
{
  return (GstControlBinding *) g_object_new (GST_TYPE_ARGB_CONTROL_BINDING,
      "object", object, "name", property_name,
      "control-source-a", cs_a,
      "control-source-r", cs_r,
      "control-source-g", cs_g, "control-source-b", cs_b, NULL);
}

/* functions */
