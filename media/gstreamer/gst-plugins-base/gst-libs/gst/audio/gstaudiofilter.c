/* GStreamer audio filter base class
 * Copyright (C) <1999> Erik Walthinsen <omega@cse.ogi.edu>
 * Copyright (C) <2003> David Schleef <ds@schleef.org>
 * Copyright (C) <2007> Tim-Philipp Müller <tim centricular net>
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
 * SECTION:gstaudiofilter
 * @short_description: Base class for simple audio filters
 *
 * #GstAudioFilter is a #GstBaseTransform<!-- -->-derived base class for simple audio
 * filters, ie. those that output the same format that they get as input.
 *
 * #GstAudioFilter will parse the input format for you (with error checking)
 * before calling your setup function. Also, elements deriving from
 * #GstAudioFilter may use gst_audio_filter_class_add_pad_templates() from
 * their class_init function to easily configure the set of caps/formats that
 * the element is able to handle.
 *
 * Derived classes should override the #GstAudioFilterClass.setup() and
 * #GstBaseTransformClass.transform_ip() and/or
 * #GstBaseTransformClass.transform()
 * virtual functions in their class_init function.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstaudiofilter.h"

#include <string.h>

GST_DEBUG_CATEGORY_STATIC (audiofilter_dbg);
#define GST_CAT_DEFAULT audiofilter_dbg

static GstStateChangeReturn gst_audio_filter_change_state (GstElement * element,
    GstStateChange transition);
static gboolean gst_audio_filter_set_caps (GstBaseTransform * btrans,
    GstCaps * incaps, GstCaps * outcaps);
static gboolean gst_audio_filter_get_unit_size (GstBaseTransform * btrans,
    GstCaps * caps, gsize * size);

#define do_init G_STMT_START { \
    GST_DEBUG_CATEGORY_INIT (audiofilter_dbg, "audiofilter", 0, "audiofilter"); \
} G_STMT_END

G_DEFINE_ABSTRACT_TYPE_WITH_CODE (GstAudioFilter, gst_audio_filter,
    GST_TYPE_BASE_TRANSFORM, do_init);

static void
gst_audio_filter_class_init (GstAudioFilterClass * klass)
{
  GstBaseTransformClass *basetrans_class = (GstBaseTransformClass *) klass;
  GstElementClass *gstelement_class = (GstElementClass *) klass;

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_audio_filter_change_state);
  basetrans_class->set_caps = GST_DEBUG_FUNCPTR (gst_audio_filter_set_caps);
  basetrans_class->get_unit_size =
      GST_DEBUG_FUNCPTR (gst_audio_filter_get_unit_size);
}

static void
gst_audio_filter_init (GstAudioFilter * self)
{
  gst_audio_info_init (&self->info);
}

/* we override the state change vfunc here instead of GstBaseTransform's stop
 * vfunc, so GstAudioFilter-derived elements can override ::stop() for their
 * own purposes without having to worry about chaining up */
static GstStateChangeReturn
gst_audio_filter_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstAudioFilter *filter = GST_AUDIO_FILTER (element);

  ret =
      GST_ELEMENT_CLASS (gst_audio_filter_parent_class)->change_state (element,
      transition);
  if (ret == GST_STATE_CHANGE_FAILURE)
    return ret;

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
    case GST_STATE_CHANGE_READY_TO_NULL:
      gst_audio_info_init (&filter->info);
      break;
    default:
      break;
  }

  return ret;
}

static gboolean
gst_audio_filter_set_caps (GstBaseTransform * btrans, GstCaps * incaps,
    GstCaps * outcaps)
{
  GstAudioFilterClass *klass;
  GstAudioFilter *filter = GST_AUDIO_FILTER (btrans);
  GstAudioInfo info;
  gboolean ret = TRUE;

  GST_LOG_OBJECT (filter, "caps: %" GST_PTR_FORMAT, incaps);
  GST_LOG_OBJECT (filter, "info: %d", GST_AUDIO_FILTER_RATE (filter));

  if (!gst_audio_info_from_caps (&info, incaps))
    goto invalid_format;

  klass = GST_AUDIO_FILTER_GET_CLASS (filter);

  if (klass->setup)
    ret = klass->setup (filter, &info);

  if (ret) {
    filter->info = info;
    GST_LOG_OBJECT (filter, "configured caps: %" GST_PTR_FORMAT, incaps);
  }

  return ret;

  /* ERROR */
invalid_format:
  {
    GST_WARNING_OBJECT (filter, "couldn't parse %" GST_PTR_FORMAT, incaps);
    return FALSE;
  }
}

static gboolean
gst_audio_filter_get_unit_size (GstBaseTransform * btrans, GstCaps * caps,
    gsize * size)
{
  GstAudioInfo info;

  if (!gst_audio_info_from_caps (&info, caps))
    return FALSE;

  *size = GST_AUDIO_INFO_BPF (&info);

  return TRUE;
}

/**
 * gst_audio_filter_class_add_pad_templates:
 * @klass: an #GstAudioFilterClass
 * @allowed_caps: what formats the filter can handle, as #GstCaps
 *
 * Convenience function to add pad templates to this element class, with
 * @allowed_caps as the caps that can be handled.
 *
 * This function is usually used from within a GObject class_init function.
 */
void
gst_audio_filter_class_add_pad_templates (GstAudioFilterClass * klass,
    GstCaps * allowed_caps)
{
  GstElementClass *element_class = GST_ELEMENT_CLASS (klass);
  GstPadTemplate *pad_template;

  g_return_if_fail (GST_IS_AUDIO_FILTER_CLASS (klass));
  g_return_if_fail (GST_IS_CAPS (allowed_caps));

  pad_template = gst_pad_template_new ("src", GST_PAD_SRC, GST_PAD_ALWAYS,
      allowed_caps);
  gst_element_class_add_pad_template (element_class, pad_template);

  pad_template = gst_pad_template_new ("sink", GST_PAD_SINK, GST_PAD_ALWAYS,
      allowed_caps);
  gst_element_class_add_pad_template (element_class, pad_template);
}
