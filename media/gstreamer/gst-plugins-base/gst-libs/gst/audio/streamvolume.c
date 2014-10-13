/* GStreamer Mixer
 * Copyright (C) 2009 Sebastian Dröge <sebastian.droege@collabora.co.uk>
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
 * SECTION:gststreamvolume
 * @short_description: Interface for elements that provide a stream volume
 *
 * <refsect2>
 * <para>
 * This interface is implemented by elements that provide a stream volume. Examples for
 * such elements are #volume and #playbin.
 * </para>
 * <para>
 * Applications can use this interface to get or set the current stream volume. For this
 * the "volume" #GObject property can be used or the helper functions gst_stream_volume_set_volume()
 * and gst_stream_volume_get_volume(). This volume is always a linear factor, i.e. 0.0 is muted
 * 1.0 is 100%. For showing the volume in a GUI it might make sense to convert it to
 * a different format by using gst_stream_volume_convert_volume(). Volume sliders should usually
 * use a cubic volume.
 *
 * Separate from the volume the stream can also be muted by the "mute" #GObject property or
 * gst_stream_volume_set_mute() and gst_stream_volume_get_mute().
 * </para>
 * <para>
 * Elements that provide some kind of stream volume should implement the "volume" and
 * "mute" #GObject properties and handle setting and getting of them properly.
 * The volume property is defined to be a linear volume factor.
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "streamvolume.h"
#include <math.h>

static void
gst_stream_volume_class_init (GstStreamVolumeInterface * iface)
{
  g_object_interface_install_property (iface,
      g_param_spec_double ("volume",
          "Volume",
          "Linear volume factor, 1.0=100%",
          0.0, G_MAXDOUBLE, 1.0, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_interface_install_property (iface,
      g_param_spec_boolean ("mute",
          "Mute",
          "Mute the audio channel without changing the volume",
          FALSE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
}

GType
gst_stream_volume_get_type (void)
{
  static volatile gsize type = 0;
  if (g_once_init_enter (&type)) {
    GType tmp;
    static const GTypeInfo info = {
      sizeof (GstStreamVolumeInterface),
      NULL,                     /* base_init */
      NULL,                     /* base_finalize */
      (GClassInitFunc) gst_stream_volume_class_init,    /* class_init */
      NULL,                     /* class_finalize */
      NULL,                     /* class_data */
      0,
      0,                        /* n_preallocs */
      NULL                      /* instance_init */
    };
    tmp = g_type_register_static (G_TYPE_INTERFACE,
        "GstStreamVolume", &info, 0);
    g_type_interface_add_prerequisite (tmp, G_TYPE_OBJECT);

    g_once_init_leave (&type, tmp);
  }
  return type;
}

/**
 * gst_stream_volume_get_volume:
 * @volume: #GstStreamVolume that should be used
 * @format: #GstStreamVolumeFormat which should be returned
 *
 * Returns: The current stream volume as linear factor
 */
gdouble
gst_stream_volume_get_volume (GstStreamVolume * volume,
    GstStreamVolumeFormat format)
{
  gdouble val;

  g_return_val_if_fail (GST_IS_STREAM_VOLUME (volume), 1.0);

  g_object_get (volume, "volume", &val, NULL);
  if (format != GST_STREAM_VOLUME_FORMAT_LINEAR)
    val =
        gst_stream_volume_convert_volume (GST_STREAM_VOLUME_FORMAT_LINEAR,
        format, val);
  return val;
}

/**
 * gst_stream_volume_set_volume:
 * @volume: #GstStreamVolume that should be used
 * @format: #GstStreamVolumeFormat of @val
 * @val: Linear volume factor that should be set
 */
void
gst_stream_volume_set_volume (GstStreamVolume * volume,
    GstStreamVolumeFormat format, gdouble val)
{
  g_return_if_fail (GST_IS_STREAM_VOLUME (volume));

  if (format != GST_STREAM_VOLUME_FORMAT_LINEAR)
    val =
        gst_stream_volume_convert_volume (format,
        GST_STREAM_VOLUME_FORMAT_LINEAR, val);
  g_object_set (volume, "volume", val, NULL);
}

/**
 * gst_stream_volume_get_mute:
 * @volume: #GstStreamVolume that should be used
 *
 * Returns: Returns %TRUE if the stream is muted
 */
gboolean
gst_stream_volume_get_mute (GstStreamVolume * volume)
{
  gboolean val;

  g_return_val_if_fail (GST_IS_STREAM_VOLUME (volume), FALSE);

  g_object_get (volume, "mute", &val, NULL);
  return val;
}

/**
 * gst_stream_volume_set_mute:
 * @volume: #GstStreamVolume that should be used
 * @mute: Mute state that should be set
 */
void
gst_stream_volume_set_mute (GstStreamVolume * volume, gboolean mute)
{
  g_return_if_fail (GST_IS_STREAM_VOLUME (volume));

  g_object_set (volume, "mute", mute, NULL);
}

/**
 * gst_stream_volume_convert_volume:
 * @from: #GstStreamVolumeFormat to convert from
 * @to: #GstStreamVolumeFormat to convert to
 * @val: Volume in @from format that should be converted
 *
 * Returns: the converted volume
 */
gdouble
gst_stream_volume_convert_volume (GstStreamVolumeFormat from,
    GstStreamVolumeFormat to, gdouble val)
{
  switch (from) {
    case GST_STREAM_VOLUME_FORMAT_LINEAR:
      g_return_val_if_fail (val >= 0.0, 0.0);
      switch (to) {
        case GST_STREAM_VOLUME_FORMAT_LINEAR:
          return val;
        case GST_STREAM_VOLUME_FORMAT_CUBIC:
          return pow (val, 1 / 3.0);
        case GST_STREAM_VOLUME_FORMAT_DB:
          return 20.0 * log10 (val);
      }
      break;
    case GST_STREAM_VOLUME_FORMAT_CUBIC:
      g_return_val_if_fail (val >= 0.0, 0.0);
      switch (to) {
        case GST_STREAM_VOLUME_FORMAT_LINEAR:
          return val * val * val;
        case GST_STREAM_VOLUME_FORMAT_CUBIC:
          return val;
        case GST_STREAM_VOLUME_FORMAT_DB:
          return 3.0 * 20.0 * log10 (val);
      }
      break;
    case GST_STREAM_VOLUME_FORMAT_DB:
      switch (to) {
        case GST_STREAM_VOLUME_FORMAT_LINEAR:
          return pow (10.0, val / 20.0);
        case GST_STREAM_VOLUME_FORMAT_CUBIC:
          return pow (10.0, val / (3.0 * 20.0));
        case GST_STREAM_VOLUME_FORMAT_DB:
          return val;
      }
      break;
  }
  g_return_val_if_reached (0.0);
}
