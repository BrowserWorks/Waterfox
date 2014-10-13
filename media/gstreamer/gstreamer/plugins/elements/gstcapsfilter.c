/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2000 Wim Taymans <wtay@chello.be>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *                    2005 David Schleef <ds@schleef.org>
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
 * SECTION:element-capsfilter
 *
 * The element does not modify data as such, but can enforce limitations on the
 * data format.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch videotestsrc ! video/x-raw,format=GRAY8 ! videoconvert ! autovideosink
 * ]| Limits acceptable video from videotestsrc to be grayscale.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "../../gst/gst-i18n-lib.h"
#include "gstcapsfilter.h"

enum
{
  PROP_0,
  PROP_FILTER_CAPS
};


static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);


GST_DEBUG_CATEGORY_STATIC (gst_capsfilter_debug);
#define GST_CAT_DEFAULT gst_capsfilter_debug

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_capsfilter_debug, "capsfilter", 0, \
    "capsfilter element");
#define gst_capsfilter_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstCapsFilter, gst_capsfilter, GST_TYPE_BASE_TRANSFORM,
    _do_init);


static void gst_capsfilter_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_capsfilter_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_capsfilter_dispose (GObject * object);

static GstCaps *gst_capsfilter_transform_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter);
static gboolean gst_capsfilter_accept_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps);
static GstFlowReturn gst_capsfilter_transform_ip (GstBaseTransform * base,
    GstBuffer * buf);
static GstFlowReturn gst_capsfilter_prepare_buf (GstBaseTransform * trans,
    GstBuffer * input, GstBuffer ** buf);
static gboolean gst_capsfilter_sink_event (GstBaseTransform * trans,
    GstEvent * event);
static gboolean gst_capsfilter_stop (GstBaseTransform * trans);

static void
gst_capsfilter_class_init (GstCapsFilterClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseTransformClass *trans_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gobject_class->set_property = gst_capsfilter_set_property;
  gobject_class->get_property = gst_capsfilter_get_property;
  gobject_class->dispose = gst_capsfilter_dispose;

  g_object_class_install_property (gobject_class, PROP_FILTER_CAPS,
      g_param_spec_boxed ("caps", _("Filter caps"),
          _("Restrict the possible allowed capabilities (NULL means ANY). "
              "Setting this property takes a reference to the supplied GstCaps "
              "object."), GST_TYPE_CAPS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gstelement_class = GST_ELEMENT_CLASS (klass);
  gst_element_class_set_static_metadata (gstelement_class,
      "CapsFilter",
      "Generic",
      "Pass data without modification, limiting formats",
      "David Schleef <ds@schleef.org>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));

  trans_class = GST_BASE_TRANSFORM_CLASS (klass);
  trans_class->transform_caps =
      GST_DEBUG_FUNCPTR (gst_capsfilter_transform_caps);
  trans_class->transform_ip = GST_DEBUG_FUNCPTR (gst_capsfilter_transform_ip);
  trans_class->accept_caps = GST_DEBUG_FUNCPTR (gst_capsfilter_accept_caps);
  trans_class->prepare_output_buffer =
      GST_DEBUG_FUNCPTR (gst_capsfilter_prepare_buf);
  trans_class->sink_event = GST_DEBUG_FUNCPTR (gst_capsfilter_sink_event);
  trans_class->stop = GST_DEBUG_FUNCPTR (gst_capsfilter_stop);
}

static void
gst_capsfilter_init (GstCapsFilter * filter)
{
  GstBaseTransform *trans = GST_BASE_TRANSFORM (filter);
  gst_base_transform_set_gap_aware (trans, TRUE);
  gst_base_transform_set_prefer_passthrough (trans, FALSE);
  filter->filter_caps = gst_caps_new_any ();
}

static void
gst_capsfilter_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstCapsFilter *capsfilter = GST_CAPSFILTER (object);

  switch (prop_id) {
    case PROP_FILTER_CAPS:{
      GstCaps *new_caps;
      GstCaps *old_caps;
      const GstCaps *new_caps_val = gst_value_get_caps (value);

      if (new_caps_val == NULL) {
        new_caps = gst_caps_new_any ();
      } else {
        new_caps = (GstCaps *) new_caps_val;
        gst_caps_ref (new_caps);
      }

      GST_OBJECT_LOCK (capsfilter);
      old_caps = capsfilter->filter_caps;
      capsfilter->filter_caps = new_caps;
      GST_OBJECT_UNLOCK (capsfilter);

      gst_caps_unref (old_caps);

      GST_DEBUG_OBJECT (capsfilter, "set new caps %" GST_PTR_FORMAT, new_caps);

      gst_base_transform_reconfigure_sink (GST_BASE_TRANSFORM (object));
      break;
    }
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_capsfilter_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstCapsFilter *capsfilter = GST_CAPSFILTER (object);

  switch (prop_id) {
    case PROP_FILTER_CAPS:
      GST_OBJECT_LOCK (capsfilter);
      gst_value_set_caps (value, capsfilter->filter_caps);
      GST_OBJECT_UNLOCK (capsfilter);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_capsfilter_dispose (GObject * object)
{
  GstCapsFilter *filter = GST_CAPSFILTER (object);

  gst_caps_replace (&filter->filter_caps, NULL);
  g_list_free_full (filter->pending_events, (GDestroyNotify) gst_event_unref);
  filter->pending_events = NULL;

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static GstCaps *
gst_capsfilter_transform_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps, GstCaps * filter)
{
  GstCapsFilter *capsfilter = GST_CAPSFILTER (base);
  GstCaps *ret, *filter_caps, *tmp;

  GST_OBJECT_LOCK (capsfilter);
  filter_caps = gst_caps_ref (capsfilter->filter_caps);
  GST_OBJECT_UNLOCK (capsfilter);

  if (filter) {
    tmp =
        gst_caps_intersect_full (filter, filter_caps, GST_CAPS_INTERSECT_FIRST);
    gst_caps_unref (filter_caps);
    filter_caps = tmp;
  }

  ret = gst_caps_intersect_full (filter_caps, caps, GST_CAPS_INTERSECT_FIRST);

  GST_DEBUG_OBJECT (capsfilter, "input:     %" GST_PTR_FORMAT, caps);
  GST_DEBUG_OBJECT (capsfilter, "filter:    %" GST_PTR_FORMAT, filter);
  GST_DEBUG_OBJECT (capsfilter, "caps filter:    %" GST_PTR_FORMAT,
      filter_caps);
  GST_DEBUG_OBJECT (capsfilter, "intersect: %" GST_PTR_FORMAT, ret);

  gst_caps_unref (filter_caps);

  return ret;
}

static gboolean
gst_capsfilter_accept_caps (GstBaseTransform * base,
    GstPadDirection direction, GstCaps * caps)
{
  GstCapsFilter *capsfilter = GST_CAPSFILTER (base);
  GstCaps *filter_caps;
  gboolean ret;

  GST_OBJECT_LOCK (capsfilter);
  filter_caps = gst_caps_ref (capsfilter->filter_caps);
  GST_OBJECT_UNLOCK (capsfilter);

  ret = gst_caps_can_intersect (caps, filter_caps);
  GST_DEBUG_OBJECT (capsfilter, "can intersect: %d", ret);
  if (ret) {
    /* if we can intersect, see if the other end also accepts */
    if (direction == GST_PAD_SRC)
      ret =
          gst_pad_peer_query_accept_caps (GST_BASE_TRANSFORM_SINK_PAD (base),
          caps);
    else
      ret =
          gst_pad_peer_query_accept_caps (GST_BASE_TRANSFORM_SRC_PAD (base),
          caps);
    GST_DEBUG_OBJECT (capsfilter, "peer accept: %d", ret);
  }

  gst_caps_unref (filter_caps);

  return ret;
}

static GstFlowReturn
gst_capsfilter_transform_ip (GstBaseTransform * base, GstBuffer * buf)
{
  /* No actual work here. It's all done in the prepare output buffer
   * func. */
  return GST_FLOW_OK;
}

static void
gst_capsfilter_push_pending_events (GstCapsFilter * filter, GList * events)
{
  GList *l;

  for (l = g_list_last (events); l; l = l->prev) {
    GST_LOG_OBJECT (filter, "Forwarding %s event",
        GST_EVENT_TYPE_NAME (l->data));
    GST_BASE_TRANSFORM_CLASS (parent_class)->sink_event (GST_BASE_TRANSFORM_CAST
        (filter), l->data);
  }
  g_list_free (events);
}

/* Ouput buffer preparation ... if the buffer has no caps, and our allowed
 * output caps is fixed, then send the caps downstream, making sure caps are
 * sent before segment event.
 *
 * This ensures that caps event is sent if we can, so that pipelines like:
 *   gst-launch filesrc location=rawsamples.raw !
 *       audio/x-raw,format=S16LE,rate=48000,channels=2 ! alsasink
 * will work.
 */
static GstFlowReturn
gst_capsfilter_prepare_buf (GstBaseTransform * trans, GstBuffer * input,
    GstBuffer ** buf)
{
  GstFlowReturn ret = GST_FLOW_OK;
  GstCapsFilter *filter = GST_CAPSFILTER (trans);

  /* always return the input as output buffer */
  *buf = input;

  if (GST_PAD_MODE (trans->srcpad) == GST_PAD_MODE_PUSH
      && !gst_pad_has_current_caps (trans->sinkpad)) {

    /* No caps. See if the output pad only supports fixed caps */
    GstCaps *out_caps;
    GList *pending_events = filter->pending_events;

    GST_LOG_OBJECT (trans, "Input pad does not have caps");

    filter->pending_events = NULL;

    out_caps = gst_pad_get_current_caps (trans->srcpad);
    if (out_caps == NULL) {
      out_caps = gst_pad_get_allowed_caps (trans->srcpad);
      g_return_val_if_fail (out_caps != NULL, GST_FLOW_ERROR);
    }

    out_caps = gst_caps_simplify (out_caps);

    if (gst_caps_is_fixed (out_caps) && !gst_caps_is_empty (out_caps)) {
      GST_DEBUG_OBJECT (trans, "Have fixed output caps %"
          GST_PTR_FORMAT " to apply to srcpad", out_caps);

      if (!gst_pad_has_current_caps (trans->srcpad)) {
        if (gst_pad_set_caps (trans->srcpad, out_caps)) {
          if (pending_events) {
            gst_capsfilter_push_pending_events (filter, pending_events);
            pending_events = NULL;
          }
        } else {
          ret = GST_FLOW_NOT_NEGOTIATED;
        }
      }

      g_list_free_full (pending_events, (GDestroyNotify) gst_event_unref);
      gst_caps_unref (out_caps);
    } else {
      gchar *caps_str = gst_caps_to_string (out_caps);

      GST_DEBUG_OBJECT (trans, "Cannot choose caps. Have unfixed output caps %"
          GST_PTR_FORMAT, out_caps);
      gst_caps_unref (out_caps);

      GST_ELEMENT_ERROR (trans, STREAM, FORMAT,
          ("Filter caps do not completely specify the output format"),
          ("Output caps are unfixed: %s", caps_str));

      g_free (caps_str);
      g_list_free_full (pending_events, (GDestroyNotify) gst_event_unref);

      ret = GST_FLOW_ERROR;
    }
  } else if (G_UNLIKELY (filter->pending_events)) {
    GList *events = filter->pending_events;

    filter->pending_events = NULL;

    /* push pending events before a buffer */
    gst_capsfilter_push_pending_events (filter, events);
  }

  return ret;
}

/* Queue the segment event if there was no caps event */
static gboolean
gst_capsfilter_sink_event (GstBaseTransform * trans, GstEvent * event)
{
  GstCapsFilter *filter = GST_CAPSFILTER (trans);

  if (GST_EVENT_TYPE (event) == GST_EVENT_FLUSH_STOP) {
    GList *l;

    for (l = filter->pending_events; l; l = l->next) {
      if (GST_EVENT_TYPE (l->data) == GST_EVENT_SEGMENT) {
        gst_event_unref (l->data);
        filter->pending_events = g_list_delete_link (filter->pending_events, l);
        break;
      }
    }
  }

  if (!GST_EVENT_IS_STICKY (event)
      || GST_EVENT_TYPE (event) <= GST_EVENT_CAPS)
    goto done;

  /* If we get EOS before any buffers, just push all pending events */
  if (GST_EVENT_TYPE (event) == GST_EVENT_EOS) {
    GList *l;

    for (l = g_list_last (filter->pending_events); l; l = l->prev) {
      GST_LOG_OBJECT (trans, "Forwarding %s event",
          GST_EVENT_TYPE_NAME (l->data));
      GST_BASE_TRANSFORM_CLASS (parent_class)->sink_event (trans, l->data);
    }
    g_list_free (filter->pending_events);
    filter->pending_events = NULL;
  } else if (!gst_pad_has_current_caps (trans->sinkpad)) {
    GST_LOG_OBJECT (trans, "Got %s event before caps, queueing",
        GST_EVENT_TYPE_NAME (event));

    filter->pending_events = g_list_prepend (filter->pending_events, event);

    return TRUE;
  }

done:

  GST_LOG_OBJECT (trans, "Forwarding %s event", GST_EVENT_TYPE_NAME (event));
  return GST_BASE_TRANSFORM_CLASS (parent_class)->sink_event (trans, event);
}

static gboolean
gst_capsfilter_stop (GstBaseTransform * trans)
{
  GstCapsFilter *filter = GST_CAPSFILTER (trans);

  g_list_free_full (filter->pending_events, (GDestroyNotify) gst_event_unref);
  filter->pending_events = NULL;

  return TRUE;
}
