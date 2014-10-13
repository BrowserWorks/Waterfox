/* GStreamer
 * Copyright (C) <2011> Sebastian Dröge <sebastian.droege@collabora.co.uk>
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstplaysinkvideoconvert.h"

#include <gst/pbutils/pbutils.h>
#include <gst/gst-i18n-plugin.h>

GST_DEBUG_CATEGORY_STATIC (gst_play_sink_video_convert_debug);
#define GST_CAT_DEFAULT gst_play_sink_video_convert_debug

#define parent_class gst_play_sink_video_convert_parent_class

G_DEFINE_TYPE (GstPlaySinkVideoConvert, gst_play_sink_video_convert,
    GST_TYPE_PLAY_SINK_CONVERT_BIN);

enum
{
  PROP_0,
  PROP_USE_CONVERTERS,
  PROP_USE_BALANCE,
};

static gboolean
gst_play_sink_video_convert_add_conversion_elements (GstPlaySinkVideoConvert *
    self)
{
  GstPlaySinkConvertBin *cbin = GST_PLAY_SINK_CONVERT_BIN (self);
  GstElement *el, *prev = NULL;

  g_assert (cbin->conversion_elements == NULL);

  GST_DEBUG_OBJECT (self,
      "Building video conversion with use-converters %d, use-balance %d",
      self->use_converters, self->use_balance);

  if (self->use_converters) {
    el = gst_play_sink_convert_bin_add_conversion_element_factory (cbin,
        COLORSPACE, "conv");
    if (el)
      prev = el;

    el = gst_play_sink_convert_bin_add_conversion_element_factory (cbin,
        "videoscale", "scale");
    if (el) {
      /* Add black borders if necessary to keep the DAR */
      g_object_set (el, "add-borders", TRUE, NULL);
      if (prev) {
        if (!gst_element_link_pads_full (prev, "src", el, "sink",
                GST_PAD_LINK_CHECK_TEMPLATE_CAPS))
          goto link_failed;
      }
      prev = el;
    }
  }

  if (self->use_balance && self->balance) {
    el = self->balance;
    gst_play_sink_convert_bin_add_conversion_element (cbin, el);
    if (prev) {
      if (!gst_element_link_pads_full (prev, "src", el, "sink",
              GST_PAD_LINK_CHECK_TEMPLATE_CAPS))
        goto link_failed;
    }
    prev = el;

    el = gst_play_sink_convert_bin_add_conversion_element_factory (cbin,
        COLORSPACE, "conv2");
    if (prev) {
      if (!gst_element_link_pads_full (prev, "src", el, "sink",
              GST_PAD_LINK_CHECK_TEMPLATE_CAPS))
        goto link_failed;
    }
    if (el)
      prev = el;
  }

  return TRUE;

link_failed:
  return FALSE;
}

static void
gst_play_sink_video_convert_finalize (GObject * object)
{
  GstPlaySinkVideoConvert *self = GST_PLAY_SINK_VIDEO_CONVERT_CAST (object);

  if (self->balance)
    gst_object_unref (self->balance);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_play_sink_video_convert_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstPlaySinkVideoConvert *self = GST_PLAY_SINK_VIDEO_CONVERT_CAST (object);
  gboolean v, changed = FALSE;

  GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
  switch (prop_id) {
    case PROP_USE_CONVERTERS:
      v = g_value_get_boolean (value);
      if (v != self->use_converters) {
        self->use_converters = v;
        changed = TRUE;
      }
      break;
    case PROP_USE_BALANCE:
      v = g_value_get_boolean (value);
      if (v != self->use_balance) {
        self->use_balance = v;
        changed = TRUE;
      }
      break;
    default:
      break;
  }

  if (changed) {
    GstPlaySinkConvertBin *cbin = GST_PLAY_SINK_CONVERT_BIN (self);
    GST_DEBUG_OBJECT (self, "Rebuilding converter bin");
    gst_play_sink_convert_bin_remove_elements (cbin);
    gst_play_sink_video_convert_add_conversion_elements (self);
    gst_play_sink_convert_bin_add_identity (cbin);
    gst_play_sink_convert_bin_cache_converter_caps (cbin);
  }
  GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);
}

static void
gst_play_sink_video_convert_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstPlaySinkVideoConvert *self = GST_PLAY_SINK_VIDEO_CONVERT_CAST (object);

  GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
  switch (prop_id) {
    case PROP_USE_CONVERTERS:
      g_value_set_boolean (value, self->use_converters);
      break;
    case PROP_USE_BALANCE:
      g_value_set_boolean (value, self->use_balance);
      break;
    default:
      break;
  }
  GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);
}

static void
gst_play_sink_video_convert_class_init (GstPlaySinkVideoConvertClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  GST_DEBUG_CATEGORY_INIT (gst_play_sink_video_convert_debug,
      "playsinkvideoconvert", 0, "play bin");

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;

  gobject_class->finalize = gst_play_sink_video_convert_finalize;
  gobject_class->set_property = gst_play_sink_video_convert_set_property;
  gobject_class->get_property = gst_play_sink_video_convert_get_property;

  g_object_class_install_property (gobject_class, PROP_USE_CONVERTERS,
      g_param_spec_boolean ("use-converters", "Use converters",
          "Whether to use conversion elements", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_USE_BALANCE,
      g_param_spec_boolean ("use-balance", "Use balance",
          "Whether to use a videobalance element", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_set_static_metadata (gstelement_class,
      "Player Sink Video Converter", "Video/Bin/Converter",
      "Convenience bin for video conversion",
      "Sebastian Dröge <sebastian.droege@collabora.co.uk>");
}

static void
gst_play_sink_video_convert_init (GstPlaySinkVideoConvert * self)
{
  GstPlaySinkConvertBin *cbin = GST_PLAY_SINK_CONVERT_BIN (self);
  cbin->audio = FALSE;

  /* FIXME: Only create this on demand but for now we need
   * it to always exist because of playsink's color balance
   * proxying logic.
   */
  self->balance = gst_element_factory_make ("videobalance", "videobalance");
  if (self->balance)
    gst_object_ref_sink (self->balance);

  gst_play_sink_video_convert_add_conversion_elements (self);
  gst_play_sink_convert_bin_cache_converter_caps (cbin);
}
