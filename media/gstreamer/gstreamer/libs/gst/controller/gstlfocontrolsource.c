/* GStreamer
 *
 * Copyright (C) 2007,2010 Sebastian Dröge <sebastian.droege@collabora.co.uk>
 *
 * gstlfocontrolsource.c: Control source that provides some periodic waveforms
 *                        as control values.
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
 * SECTION:gstlfocontrolsource
 * @short_description: LFO control source
 *
 * #GstLFOControlSource is a #GstControlSource, that provides several periodic
 * waveforms as control values.
 *
 * To use #GstLFOControlSource get a new instance by calling
 * gst_lfo_control_source_new(), bind it to a #GParamSpec and set the relevant
 * properties.
 *
 * All functions are MT-safe.
 */

#include <float.h>

#include <glib-object.h>
#include <gst/gst.h>
#include <gst/gstcontrolsource.h>

#include "gstlfocontrolsource.h"

#include "gst/glib-compat-private.h"

#include <gst/math-compat.h>

#define GST_CAT_DEFAULT controller_debug
GST_DEBUG_CATEGORY_STATIC (GST_CAT_DEFAULT);

struct _GstLFOControlSourcePrivate
{
  GstLFOWaveform waveform;
  gdouble frequency;
  GstClockTime period;
  GstClockTime timeshift;
  gdouble amplitude;
  gdouble offset;
};

/* FIXME: as % in C is not the modulo operator we need here for
 * negative numbers implement our own. Are there better ways? */
static inline GstClockTime
_calculate_pos (GstClockTime timestamp, GstClockTime timeshift,
    GstClockTime period)
{
  while (timestamp < timeshift)
    timestamp += period;

  timestamp -= timeshift;

  return timestamp % period;
}

static inline gdouble
_sine_get (GstLFOControlSource * self, gdouble amp, gdouble off,
    GstClockTime timeshift, GstClockTime period, gdouble frequency,
    GstClockTime timestamp)
{
  gdouble pos =
      gst_guint64_to_gdouble (_calculate_pos (timestamp, timeshift, period));
  gdouble ret;

  ret = sin (2.0 * M_PI * (frequency / GST_SECOND) * pos);
  ret *= amp;
  ret += off;

  return ret;
}

static gboolean
waveform_sine_get (GstLFOControlSource * self, GstClockTime timestamp,
    gdouble * value)
{
  GstLFOControlSourcePrivate *priv = self->priv;

  gst_object_sync_values (GST_OBJECT (self), timestamp);
  g_mutex_lock (&self->lock);
  *value = _sine_get (self, priv->amplitude, priv->offset, priv->timeshift,
      priv->period, priv->frequency, timestamp);
  g_mutex_unlock (&self->lock);
  return TRUE;
}

static gboolean
waveform_sine_get_value_array (GstLFOControlSource * self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gdouble * values)
{
  GstLFOControlSourcePrivate *priv = self->priv;
  guint i;
  GstClockTime ts = timestamp;

  for (i = 0; i < n_values; i++) {
    gst_object_sync_values (GST_OBJECT (self), ts);
    g_mutex_lock (&self->lock);
    *values = _sine_get (self, priv->amplitude, priv->offset, priv->timeshift,
        priv->period, priv->frequency, ts);
    g_mutex_unlock (&self->lock);
    ts += interval;
    values++;
  }
  return TRUE;
}


static inline gdouble
_square_get (GstLFOControlSource * self, gdouble amp, gdouble off,
    GstClockTime timeshift, GstClockTime period, gdouble frequency,
    GstClockTime timestamp)
{
  GstClockTime pos = _calculate_pos (timestamp, timeshift, period);
  gdouble ret;

  if (pos >= period / 2)
    ret = amp;
  else
    ret = -amp;
  ret += off;

  return ret;
}

static gboolean
waveform_square_get (GstLFOControlSource * self, GstClockTime timestamp,
    gdouble * value)
{
  GstLFOControlSourcePrivate *priv = self->priv;

  gst_object_sync_values (GST_OBJECT (self), timestamp);
  g_mutex_lock (&self->lock);
  *value = _square_get (self, priv->amplitude, priv->offset, priv->timeshift,
      priv->period, priv->frequency, timestamp);
  g_mutex_unlock (&self->lock);
  return TRUE;
}

static gboolean
waveform_square_get_value_array (GstLFOControlSource * self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gdouble * values)
{
  GstLFOControlSourcePrivate *priv = self->priv;
  guint i;
  GstClockTime ts = timestamp;

  for (i = 0; i < n_values; i++) {
    gst_object_sync_values (GST_OBJECT (self), ts);
    g_mutex_lock (&self->lock);
    *values = _square_get (self, priv->amplitude, priv->offset, priv->timeshift,
        priv->period, priv->frequency, ts);
    g_mutex_unlock (&self->lock);
    ts += interval;
    values++;
  }
  return TRUE;
}

static inline gdouble
_saw_get (GstLFOControlSource * self, gdouble amp, gdouble off,
    GstClockTime timeshift, GstClockTime period, gdouble frequency,
    GstClockTime timestamp)
{
  gdouble pos =
      gst_guint64_to_gdouble (_calculate_pos (timestamp, timeshift, period));
  gdouble per = gst_guint64_to_gdouble (period);
  gdouble ret;

  ret = -((pos - per / 2.0) * ((2.0 * amp) / per));
  ret += off;

  return ret;
}

static gboolean
waveform_saw_get (GstLFOControlSource * self, GstClockTime timestamp,
    gdouble * value)
{
  GstLFOControlSourcePrivate *priv = self->priv;

  gst_object_sync_values (GST_OBJECT (self), timestamp);
  g_mutex_lock (&self->lock);
  *value = _saw_get (self, priv->amplitude, priv->offset, priv->timeshift,
      priv->period, priv->frequency, timestamp);
  g_mutex_unlock (&self->lock);
  return TRUE;
}

static gboolean
waveform_saw_get_value_array (GstLFOControlSource * self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gdouble * values)
{
  GstLFOControlSourcePrivate *priv = self->priv;
  guint i;
  GstClockTime ts = timestamp;

  for (i = 0; i < n_values; i++) {
    gst_object_sync_values (GST_OBJECT (self), ts);
    g_mutex_lock (&self->lock);
    *values = _saw_get (self, priv->amplitude, priv->offset, priv->timeshift,
        priv->period, priv->frequency, ts);
    g_mutex_unlock (&self->lock);
    ts += interval;
    values++;
  }
  return TRUE;
}

static inline gdouble
_rsaw_get (GstLFOControlSource * self, gdouble amp, gdouble off,
    GstClockTime timeshift, GstClockTime period, gdouble frequency,
    GstClockTime timestamp)
{
  gdouble pos =
      gst_guint64_to_gdouble (_calculate_pos (timestamp, timeshift, period));
  gdouble per = gst_guint64_to_gdouble (period);
  gdouble ret;

  ret = (pos - per / 2.0) * ((2.0 * amp) / per);
  ret += off;

  return ret;
}

static gboolean
waveform_rsaw_get (GstLFOControlSource * self, GstClockTime timestamp,
    gdouble * value)
{
  GstLFOControlSourcePrivate *priv = self->priv;

  gst_object_sync_values (GST_OBJECT (self), timestamp);
  g_mutex_lock (&self->lock);
  *value = _rsaw_get (self, priv->amplitude, priv->offset, priv->timeshift,
      priv->period, priv->frequency, timestamp);
  g_mutex_unlock (&self->lock);
  return TRUE;
}

static gboolean
waveform_rsaw_get_value_array (GstLFOControlSource * self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gdouble * values)
{
  GstLFOControlSourcePrivate *priv = self->priv;
  guint i;
  GstClockTime ts = timestamp;

  for (i = 0; i < n_values; i++) {
    gst_object_sync_values (GST_OBJECT (self), ts);
    g_mutex_lock (&self->lock);
    *values = _rsaw_get (self, priv->amplitude, priv->offset, priv->timeshift,
        priv->period, priv->frequency, ts);
    g_mutex_unlock (&self->lock);
    ts += interval;
    values++;
  }
  return TRUE;
}


static inline gdouble
_triangle_get (GstLFOControlSource * self, gdouble amp, gdouble off,
    GstClockTime timeshift, GstClockTime period, gdouble frequency,
    GstClockTime timestamp)
{
  gdouble pos =
      gst_guint64_to_gdouble (_calculate_pos (timestamp, timeshift, period));
  gdouble per = gst_guint64_to_gdouble (period);
  gdouble ret;

  if (pos <= 0.25 * per)
    /* 1st quarter */
    ret = pos * ((4.0 * amp) / per);
  else if (pos <= 0.75 * per)
    /* 2nd & 3rd quarter */
    ret = -(pos - per / 2.0) * ((4.0 * amp) / per);
  else
    /* 4th quarter */
    ret = -(per - pos) * ((4.0 * amp) / per);

  ret += off;

  return ret;
}

static gboolean
waveform_triangle_get (GstLFOControlSource * self, GstClockTime timestamp,
    gdouble * value)
{
  GstLFOControlSourcePrivate *priv = self->priv;

  gst_object_sync_values (GST_OBJECT (self), timestamp);
  g_mutex_lock (&self->lock);
  *value = _triangle_get (self, priv->amplitude, priv->offset, priv->timeshift,
      priv->period, priv->frequency, timestamp);
  g_mutex_unlock (&self->lock);
  return TRUE;
}

static gboolean
waveform_triangle_get_value_array (GstLFOControlSource * self,
    GstClockTime timestamp, GstClockTime interval, guint n_values,
    gdouble * values)
{
  GstLFOControlSourcePrivate *priv = self->priv;
  guint i;
  GstClockTime ts = timestamp;

  for (i = 0; i < n_values; i++) {
    gst_object_sync_values (GST_OBJECT (self), ts);
    g_mutex_lock (&self->lock);
    *values =
        _triangle_get (self, priv->amplitude, priv->offset, priv->timeshift,
        priv->period, priv->frequency, ts);
    g_mutex_unlock (&self->lock);
    ts += interval;
    values++;
  }
  return TRUE;
}

static struct
{
  GstControlSourceGetValue get;
  GstControlSourceGetValueArray get_value_array;
} waveforms[] = {
  {
  (GstControlSourceGetValue) waveform_sine_get,
        (GstControlSourceGetValueArray) waveform_sine_get_value_array}, {
  (GstControlSourceGetValue) waveform_square_get,
        (GstControlSourceGetValueArray) waveform_square_get_value_array}, {
  (GstControlSourceGetValue) waveform_saw_get,
        (GstControlSourceGetValueArray) waveform_saw_get_value_array}, {
  (GstControlSourceGetValue) waveform_rsaw_get,
        (GstControlSourceGetValueArray) waveform_rsaw_get_value_array}, {
  (GstControlSourceGetValue) waveform_triangle_get,
        (GstControlSourceGetValueArray) waveform_triangle_get_value_array}
};

static const guint num_waveforms = G_N_ELEMENTS (waveforms);

enum
{
  PROP_WAVEFORM = 1,
  PROP_FREQUENCY,
  PROP_TIMESHIFT,
  PROP_AMPLITUDE,
  PROP_OFFSET
};

GType
gst_lfo_waveform_get_type (void)
{
  static gsize gtype = 0;
  static const GEnumValue values[] = {
    {GST_LFO_WAVEFORM_SINE, "GST_LFO_WAVEFORM_SINE",
        "sine"},
    {GST_LFO_WAVEFORM_SQUARE, "GST_LFO_WAVEFORM_SQUARE",
        "square"},
    {GST_LFO_WAVEFORM_SAW, "GST_LFO_WAVEFORM_SAW",
        "saw"},
    {GST_LFO_WAVEFORM_REVERSE_SAW, "GST_LFO_WAVEFORM_REVERSE_SAW",
        "reverse-saw"},
    {GST_LFO_WAVEFORM_TRIANGLE, "GST_LFO_WAVEFORM_TRIANGLE",
        "triangle"},
    {0, NULL, NULL}
  };

  if (g_once_init_enter (&gtype)) {
    GType tmp = g_enum_register_static ("GstLFOWaveform", values);
    g_once_init_leave (&gtype, tmp);
  }

  return (GType) gtype;
}

#define _do_init \
  GST_DEBUG_CATEGORY_INIT (GST_CAT_DEFAULT, "lfo control source", 0, "low frequency oscillator control source")

#define gst_lfo_control_source_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstLFOControlSource, gst_lfo_control_source,
    GST_TYPE_CONTROL_SOURCE, _do_init);

static void
gst_lfo_control_source_reset (GstLFOControlSource * self)
{
  GstControlSource *csource = GST_CONTROL_SOURCE (self);

  csource->get_value = NULL;
  csource->get_value_array = NULL;
}

/**
 * gst_lfo_control_source_new:
 *
 * This returns a new, unbound #GstLFOControlSource.
 *
 * Returns: (transfer full): a new, unbound #GstLFOControlSource.
 */
GstControlSource *
gst_lfo_control_source_new (void)
{
  return g_object_newv (GST_TYPE_LFO_CONTROL_SOURCE, 0, NULL);
}

static gboolean
gst_lfo_control_source_set_waveform (GstLFOControlSource * self,
    GstLFOWaveform waveform)
{
  GstControlSource *csource = GST_CONTROL_SOURCE (self);

  if (waveform >= num_waveforms || (int) waveform < 0) {
    GST_WARNING ("waveform %d invalid or not implemented yet", waveform);
    return FALSE;
  }

  csource->get_value = waveforms[waveform].get;
  csource->get_value_array = waveforms[waveform].get_value_array;

  self->priv->waveform = waveform;

  return TRUE;
}

static void
gst_lfo_control_source_init (GstLFOControlSource * self)
{
  self->priv =
      G_TYPE_INSTANCE_GET_PRIVATE (self, GST_TYPE_LFO_CONTROL_SOURCE,
      GstLFOControlSourcePrivate);
  self->priv->waveform = gst_lfo_control_source_set_waveform (self,
      GST_LFO_WAVEFORM_SINE);
  self->priv->frequency = 1.0;
  self->priv->amplitude = 1.0;
  self->priv->period = GST_SECOND / self->priv->frequency;
  self->priv->timeshift = 0;

  g_mutex_init (&self->lock);
}

static void
gst_lfo_control_source_finalize (GObject * obj)
{
  GstLFOControlSource *self = GST_LFO_CONTROL_SOURCE (obj);

  gst_lfo_control_source_reset (self);
  g_mutex_clear (&self->lock);

  G_OBJECT_CLASS (parent_class)->finalize (obj);
}

static void
gst_lfo_control_source_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstLFOControlSource *self = GST_LFO_CONTROL_SOURCE (object);

  switch (prop_id) {
    case PROP_WAVEFORM:
      g_mutex_lock (&self->lock);
      gst_lfo_control_source_set_waveform (self,
          (GstLFOWaveform) g_value_get_enum (value));
      g_mutex_unlock (&self->lock);
      break;
    case PROP_FREQUENCY:{
      gdouble frequency = g_value_get_double (value);

      g_return_if_fail (((GstClockTime) (GST_SECOND / frequency)) != 0);

      g_mutex_lock (&self->lock);
      self->priv->frequency = frequency;
      self->priv->period = GST_SECOND / frequency;
      g_mutex_unlock (&self->lock);
      break;
    }
    case PROP_TIMESHIFT:
      g_mutex_lock (&self->lock);
      self->priv->timeshift = g_value_get_uint64 (value);
      g_mutex_unlock (&self->lock);
      break;
    case PROP_AMPLITUDE:
      g_mutex_lock (&self->lock);
      self->priv->amplitude = g_value_get_double (value);
      g_mutex_unlock (&self->lock);
      break;
    case PROP_OFFSET:
      g_mutex_lock (&self->lock);
      self->priv->offset = g_value_get_double (value);
      g_mutex_unlock (&self->lock);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_lfo_control_source_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstLFOControlSource *self = GST_LFO_CONTROL_SOURCE (object);

  switch (prop_id) {
    case PROP_WAVEFORM:
      g_value_set_enum (value, self->priv->waveform);
      break;
    case PROP_FREQUENCY:
      g_value_set_double (value, self->priv->frequency);
      break;
    case PROP_TIMESHIFT:
      g_value_set_uint64 (value, self->priv->timeshift);
      break;
    case PROP_AMPLITUDE:
      g_value_set_double (value, self->priv->amplitude);
      break;
    case PROP_OFFSET:
      g_value_set_double (value, self->priv->offset);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_lfo_control_source_class_init (GstLFOControlSourceClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);

  g_type_class_add_private (klass, sizeof (GstLFOControlSourcePrivate));

  gobject_class->finalize = gst_lfo_control_source_finalize;
  gobject_class->set_property = gst_lfo_control_source_set_property;
  gobject_class->get_property = gst_lfo_control_source_get_property;

  /**
   * GstLFOControlSource:waveform:
   *
   * Specifies the waveform that should be used for this #GstLFOControlSource.
   */
  g_object_class_install_property (gobject_class, PROP_WAVEFORM,
      g_param_spec_enum ("waveform", "Waveform", "Waveform",
          GST_TYPE_LFO_WAVEFORM, GST_LFO_WAVEFORM_SINE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  /**
   * GstLFOControlSource:frequency:
   *
   * Specifies the frequency that should be used for the waveform
   * of this #GstLFOControlSource. It should be large enough
   * so that the period is longer than one nanosecond.
   */
  g_object_class_install_property (gobject_class, PROP_FREQUENCY,
      g_param_spec_double ("frequency", "Frequency",
          "Frequency of the waveform", DBL_MIN, G_MAXDOUBLE, 1.0,
          G_PARAM_READWRITE | GST_PARAM_CONTROLLABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstLFOControlSource:timeshift:
   *
   * Specifies the timeshift to the right that should be used for the waveform
   * of this #GstLFOControlSource in nanoseconds.
   *
   * To get a n nanosecond shift to the left use
   * "(GST_SECOND / frequency) - n".
   *
   */
  g_object_class_install_property (gobject_class, PROP_TIMESHIFT,
      g_param_spec_uint64 ("timeshift", "Timeshift",
          "Timeshift of the waveform to the right", 0, G_MAXUINT64, 0,
          G_PARAM_READWRITE | GST_PARAM_CONTROLLABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstLFOControlSource:amplitude:
   *
   * Specifies the amplitude for the waveform of this #GstLFOControlSource.
   */
  g_object_class_install_property (gobject_class, PROP_AMPLITUDE,
      g_param_spec_double ("amplitude", "Amplitude",
          "Amplitude of the waveform", 0.0, 1.0, 1.0,
          G_PARAM_READWRITE | GST_PARAM_CONTROLLABLE | G_PARAM_STATIC_STRINGS));

  /**
   * GstLFOControlSource:offset:
   *
   * Specifies the value offset for the waveform of this #GstLFOControlSource.
   */
  g_object_class_install_property (gobject_class, PROP_OFFSET,
      g_param_spec_double ("offset", "Offset", "Offset of the waveform",
          0.0, 1.0, 1.0,
          G_PARAM_READWRITE | GST_PARAM_CONTROLLABLE | G_PARAM_STATIC_STRINGS));
}
