/* GStreamer
 *
 * Copyright (C) 2007,2009 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 *               2011 Stefan Sauer <ensonic@users.sf.net>
 *
 * gsttriggercontrolsource.c: Control source that provides some values at time-
 *                            stamps
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
 * SECTION:gsttriggercontrolsource
 * @short_description: interpolation control source
 *
 * #GstTriggerControlSource is a #GstControlSource, that returns values from user-given
 * control points. It allows for a tolerance on the time-stamps.
 *
 * To use #GstTriggerControlSource get a new instance by calling
 * gst_trigger_control_source_new(), bind it to a #GParamSpec and set some
 * control points by calling gst_timed_value_control_source_set().
 *
 * All functions are MT-safe.
 */

#include <glib-object.h>
#include <gst/gst.h>

#include "gsttriggercontrolsource.h"
#include "gst/glib-compat-private.h"
#include "gst/math-compat.h"

#define GST_CAT_DEFAULT controller_debug
GST_DEBUG_CATEGORY_STATIC (GST_CAT_DEFAULT);

struct _GstTriggerControlSourcePrivate
{
  gint64 tolerance;
};

/* control point accessors */

/*  returns the default value of the property, except for times with specific values */
/*  needed for one-shot events, such as notes and triggers */

static inline gdouble
_interpolate_trigger (GstTimedValueControlSource * self, GSequenceIter * iter,
    GstClockTime timestamp)
{
  GstControlPoint *cp;
  gint64 tolerance = ((GstTriggerControlSource *) self)->priv->tolerance;
  gboolean found = FALSE;

  cp = g_sequence_get (iter);
  if (GST_CLOCK_DIFF (cp->timestamp, timestamp) <= tolerance) {
    found = TRUE;
  } else {
    if ((iter = g_sequence_iter_next (iter)) && !g_sequence_iter_is_end (iter)) {
      cp = g_sequence_get (iter);
      if (GST_CLOCK_DIFF (timestamp, cp->timestamp) <= tolerance) {
        found = TRUE;
      }
    }
  }
  if (found) {
    return cp->value;
  }
  return NAN;
}

static gboolean
interpolate_trigger_get (GstTimedValueControlSource * self,
    GstClockTime timestamp, gdouble * value)
{
  gboolean ret = FALSE;
  GSequenceIter *iter;

  g_mutex_lock (&self->lock);

  iter =
      gst_timed_value_control_source_find_control_point_iter (self, timestamp);
  if (iter) {
    *value = _interpolate_trigger (self, iter, timestamp);
    if (!isnan (*value))
      ret = TRUE;
  }
  g_mutex_unlock (&self->lock);
  return ret;
}

static gboolean
interpolate_trigger_get_value_array (GstTimedValueControlSource * self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gdouble * values)
{
  gboolean ret = FALSE;
  guint i;
  GstClockTime ts = timestamp;
  GstClockTime next_ts = 0;
  gdouble val;
  GSequenceIter *iter1 = NULL, *iter2 = NULL;
  gboolean triggered = FALSE;

  g_mutex_lock (&self->lock);
  for (i = 0; i < n_values; i++) {
    val = NAN;
    if (ts >= next_ts) {
      iter1 = gst_timed_value_control_source_find_control_point_iter (self, ts);
      if (!iter1) {
        if (G_LIKELY (self->values))
          iter2 = g_sequence_get_begin_iter (self->values);
        else
          iter2 = NULL;
      } else {
        iter2 = g_sequence_iter_next (iter1);
      }

      if (iter2 && !g_sequence_iter_is_end (iter2)) {
        GstControlPoint *cp;

        cp = g_sequence_get (iter2);
        next_ts = cp->timestamp;
      } else {
        next_ts = GST_CLOCK_TIME_NONE;
      }

      if (iter1) {
        val = _interpolate_trigger (self, iter1, ts);
        if (!isnan (val))
          ret = TRUE;
      } else {
        g_mutex_unlock (&self->lock);
        return FALSE;
      }
      triggered = TRUE;
    } else if (triggered) {
      if (iter1) {
        val = _interpolate_trigger (self, iter1, ts);
        if (!isnan (val))
          ret = TRUE;
      } else {
        g_mutex_unlock (&self->lock);
        return FALSE;
      }
      triggered = FALSE;
    }
    *values = val;
    ts += interval;
    values++;
  }
  g_mutex_unlock (&self->lock);
  return ret;
}

enum
{
  PROP_TOLERANCE = 1,
};

#define _do_init \
  GST_DEBUG_CATEGORY_INIT (GST_CAT_DEFAULT, "trigger control source", 0, \
    "timeline value trigger control source")

G_DEFINE_TYPE_WITH_CODE (GstTriggerControlSource, gst_trigger_control_source,
    GST_TYPE_TIMED_VALUE_CONTROL_SOURCE, _do_init);

/**
 * gst_trigger_control_source_new:
 *
 * This returns a new, unbound #GstTriggerControlSource.
 *
 * Returns: (transfer full): a new, unbound #GstTriggerControlSource.
 */
GstControlSource *
gst_trigger_control_source_new (void)
{
  return g_object_newv (GST_TYPE_TRIGGER_CONTROL_SOURCE, 0, NULL);
}

static void
gst_trigger_control_source_init (GstTriggerControlSource * self)
{
  GstControlSource *csource = (GstControlSource *) self;

  self->priv =
      G_TYPE_INSTANCE_GET_PRIVATE (self, GST_TYPE_TRIGGER_CONTROL_SOURCE,
      GstTriggerControlSourcePrivate);

  csource->get_value = (GstControlSourceGetValue) interpolate_trigger_get;
  csource->get_value_array = (GstControlSourceGetValueArray)
      interpolate_trigger_get_value_array;
}

static void
gst_trigger_control_source_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstTriggerControlSource *self = GST_TRIGGER_CONTROL_SOURCE (object);

  switch (prop_id) {
    case PROP_TOLERANCE:
      GST_TIMED_VALUE_CONTROL_SOURCE_LOCK (self);
      self->priv->tolerance = g_value_get_int64 (value);
      GST_TIMED_VALUE_CONTROL_SOURCE_UNLOCK (self);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_trigger_control_source_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstTriggerControlSource *self = GST_TRIGGER_CONTROL_SOURCE (object);

  switch (prop_id) {
    case PROP_TOLERANCE:
      g_value_set_int64 (value, self->priv->tolerance);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_trigger_control_source_class_init (GstTriggerControlSourceClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  g_type_class_add_private (klass, sizeof (GstTriggerControlSourcePrivate));

  gobject_class->set_property = gst_trigger_control_source_set_property;
  gobject_class->get_property = gst_trigger_control_source_get_property;

  g_object_class_install_property (gobject_class, PROP_TOLERANCE,
      g_param_spec_int64 ("tolerance", "Tolerance",
          "Amount of ns a control time can be off to still trigger",
          0, G_MAXINT64, 0, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

}
