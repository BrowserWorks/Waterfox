/* GStreamer
 * Copyright (C) <2011> Sebastian Dröge <sebastian.droege@collabora.co.uk>
 * Copyright (C) <2011> Vincent Penquerch <vincent.penquerch@collabora.co.uk>
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

#include "gstplaysinkconvertbin.h"

#include <gst/pbutils/pbutils.h>
#include <gst/gst-i18n-plugin.h>

GST_DEBUG_CATEGORY_STATIC (gst_play_sink_convert_bin_debug);
#define GST_CAT_DEFAULT gst_play_sink_convert_bin_debug

#define parent_class gst_play_sink_convert_bin_parent_class

static gboolean gst_play_sink_convert_bin_sink_setcaps (GstPlaySinkConvertBin *
    self, GstCaps * caps);

G_DEFINE_TYPE (GstPlaySinkConvertBin, gst_play_sink_convert_bin, GST_TYPE_BIN);

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static gboolean
is_raw_caps (GstCaps * caps, gboolean audio)
{
  gint i, n;
  GstStructure *s;
  const gchar *name;
  const gchar *prefix = audio ? "audio/x-raw" : "video/x-raw";

  n = gst_caps_get_size (caps);
  for (i = 0; i < n; i++) {
    s = gst_caps_get_structure (caps, i);
    name = gst_structure_get_name (s);
    if (g_str_equal (name, prefix))
      return TRUE;
  }

  return FALSE;
}

static void
gst_play_sink_convert_bin_post_missing_element_message (GstPlaySinkConvertBin *
    self, const gchar * name)
{
  GstMessage *msg;

  msg = gst_missing_element_message_new (GST_ELEMENT_CAST (self), name);
  gst_element_post_message (GST_ELEMENT_CAST (self), msg);
}

void
gst_play_sink_convert_bin_add_conversion_element (GstPlaySinkConvertBin * self,
    GstElement * el)
{
  self->conversion_elements = g_list_append (self->conversion_elements, el);
  gst_bin_add (GST_BIN (self), gst_object_ref (el));
}

GstElement *
gst_play_sink_convert_bin_add_conversion_element_factory (GstPlaySinkConvertBin
    * self, const char *factory, const char *name)
{
  GstElement *el;

  el = gst_element_factory_make (factory, name);
  if (el == NULL) {
    gst_play_sink_convert_bin_post_missing_element_message (self, factory);
    GST_ELEMENT_WARNING (self, CORE, MISSING_PLUGIN,
        (_("Missing element '%s' - check your GStreamer installation."),
            factory),
        (self->audio ? "audio rendering might fail" :
            "video rendering might fail"));
  } else {
    gst_play_sink_convert_bin_add_conversion_element (self, el);
  }
  return el;
}

void
gst_play_sink_convert_bin_add_identity (GstPlaySinkConvertBin * self)
{
  if (self->identity)
    return;

  self->identity = gst_element_factory_make ("identity", "identity");
  if (self->identity == NULL) {
    gst_play_sink_convert_bin_post_missing_element_message (self, "identity");
    GST_ELEMENT_WARNING (self, CORE, MISSING_PLUGIN,
        (_("Missing element '%s' - check your GStreamer installation."),
            "identity"), (self->audio ?
            "audio rendering might fail" : "video rendering might fail")

        );
  } else {
    g_object_set (self->identity, "silent", TRUE, "signal-handoffs", FALSE,
        NULL);
    gst_bin_add (GST_BIN_CAST (self), self->identity);
  }
}

static void
gst_play_sink_convert_bin_set_targets (GstPlaySinkConvertBin * self,
    gboolean passthrough)
{
  GstPad *pad;
  GstElement *head, *tail;

  GST_DEBUG_OBJECT (self, "Setting pad targets with passthrough %d",
      passthrough);
  if (self->conversion_elements == NULL || passthrough) {
    GST_DEBUG_OBJECT (self, "no conversion elements, using identity (%p) as "
        "head/tail", self->identity);
    if (!passthrough) {
      GST_WARNING_OBJECT (self,
          "Doing passthrough as no converter elements were added");
    }
    head = tail = self->identity;
  } else {
    head = GST_ELEMENT (g_list_first (self->conversion_elements)->data);
    tail = GST_ELEMENT (g_list_last (self->conversion_elements)->data);
    GST_DEBUG_OBJECT (self, "conversion elements in use, picking "
        "head:%s and tail:%s", GST_OBJECT_NAME (head), GST_OBJECT_NAME (tail));
  }

  g_return_if_fail (head != NULL);
  g_return_if_fail (tail != NULL);

  pad = gst_element_get_static_pad (head, "sink");
  GST_DEBUG_OBJECT (self, "Ghosting bin sink pad to %" GST_PTR_FORMAT, pad);
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->sinkpad), pad);
  gst_object_unref (pad);

  pad = gst_element_get_static_pad (tail, "src");
  GST_DEBUG_OBJECT (self, "Ghosting bin src pad to %" GST_PTR_FORMAT, pad);
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), pad);
  gst_object_unref (pad);
}

static void
gst_play_sink_convert_bin_remove_element (GstElement * element,
    GstPlaySinkConvertBin * self)
{
  gst_element_set_state (element, GST_STATE_NULL);
  gst_object_unref (element);
  gst_bin_remove (GST_BIN_CAST (self), element);
}

static void
gst_play_sink_convert_bin_on_element_added (GstElement * element,
    GstPlaySinkConvertBin * self)
{
  gst_element_sync_state_with_parent (element);
}

static GstPadProbeReturn
pad_blocked_cb (GstPad * pad, GstPadProbeInfo * info, gpointer user_data)
{
  GstPlaySinkConvertBin *self = user_data;
  GstPad *peer;
  GstCaps *caps;
  gboolean raw;

  if (GST_IS_EVENT (info->data) && !GST_EVENT_IS_SERIALIZED (info->data)) {
    GST_DEBUG_OBJECT (self, "Letting non-serialized event %s pass",
        GST_EVENT_TYPE_NAME (info->data));
    return GST_PAD_PROBE_PASS;
  }

  GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
  GST_DEBUG_OBJECT (self, "Pad blocked");

  /* There must be a peer at this point */
  peer = gst_pad_get_peer (self->sinkpad);
  caps = gst_pad_get_current_caps (peer);
  if (!caps)
    caps = gst_pad_query_caps (peer, NULL);
  gst_object_unref (peer);

  raw = is_raw_caps (caps, self->audio);
  GST_DEBUG_OBJECT (self, "Caps %" GST_PTR_FORMAT " are raw: %d", caps, raw);
  gst_caps_unref (caps);

  if (raw == self->raw)
    goto unblock;
  self->raw = raw;

  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->sinkpad), NULL);
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), NULL);

  if (raw) {
    GST_DEBUG_OBJECT (self, "Switching to raw conversion pipeline");

    if (self->conversion_elements)
      g_list_foreach (self->conversion_elements,
          (GFunc) gst_play_sink_convert_bin_on_element_added, self);
  } else {

    GST_DEBUG_OBJECT (self, "Switch to passthrough pipeline");

    gst_play_sink_convert_bin_on_element_added (self->identity, self);
  }

  gst_play_sink_convert_bin_set_targets (self, !raw);

unblock:
  self->sink_proxypad_block_id = 0;
  GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);

  return GST_PAD_PROBE_REMOVE;
}

static gboolean
gst_play_sink_convert_bin_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstPlaySinkConvertBin *self = GST_PLAY_SINK_CONVERT_BIN (parent);
  gboolean ret;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      ret = gst_play_sink_convert_bin_sink_setcaps (self, caps);
      break;
    }
    default:
      break;
  }

  ret = gst_pad_event_default (pad, parent, gst_event_ref (event));

  gst_event_unref (event);

  return ret;
}

static void
block_proxypad (GstPlaySinkConvertBin * self)
{
  if (self->sink_proxypad_block_id == 0) {
    self->sink_proxypad_block_id =
        gst_pad_add_probe (self->sink_proxypad,
        GST_PAD_PROBE_TYPE_BLOCK_DOWNSTREAM, pad_blocked_cb, self, NULL);
  }
}

static void
unblock_proxypad (GstPlaySinkConvertBin * self)
{
  if (self->sink_proxypad_block_id != 0) {
    gst_pad_remove_probe (self->sink_proxypad, self->sink_proxypad_block_id);
    self->sink_proxypad_block_id = 0;
  }
}

static gboolean
gst_play_sink_convert_bin_sink_setcaps (GstPlaySinkConvertBin * self,
    GstCaps * caps)
{
  GstStructure *s;
  const gchar *name;
  gboolean reconfigure = FALSE;
  gboolean raw;

  GST_DEBUG_OBJECT (self, "setcaps");
  GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
  s = gst_caps_get_structure (caps, 0);
  name = gst_structure_get_name (s);

  if (self->audio) {
    raw = g_str_equal (name, "audio/x-raw");
  } else {
    raw = g_str_equal (name, "video/x-raw");
  }

  GST_DEBUG_OBJECT (self, "raw %d, self->raw %d, blocked %d",
      raw, self->raw, gst_pad_is_blocked (self->sink_proxypad));

  if (raw) {
    if (!gst_pad_is_blocked (self->sink_proxypad)) {
      GstPad *target = gst_ghost_pad_get_target (GST_GHOST_PAD (self->sinkpad));

      if (!self->raw || (target && !gst_pad_query_accept_caps (target, caps))) {
        if (!self->raw)
          GST_DEBUG_OBJECT (self, "Changing caps from non-raw to raw");
        else
          GST_DEBUG_OBJECT (self, "Changing caps in an incompatible way");

        reconfigure = TRUE;
        block_proxypad (self);
      }

      if (target)
        gst_object_unref (target);
    }
  } else {
    if (self->raw && !gst_pad_is_blocked (self->sink_proxypad)) {
      GST_DEBUG_OBJECT (self, "Changing caps from raw to non-raw");
      reconfigure = TRUE;
      block_proxypad (self);
    }
  }

  /* Otherwise the setcaps below fails */
  if (reconfigure) {
    gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->sinkpad), NULL);
    gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), NULL);
  }

  GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);

  GST_DEBUG_OBJECT (self, "Setting sink caps %" GST_PTR_FORMAT, caps);

  return TRUE;
}

#define GST_PLAY_SINK_CONVERT_BIN_FILTER_CAPS(filter,caps) G_STMT_START {     \
  if ((filter)) {                                                             \
    GstCaps *intersection =                                                   \
        gst_caps_intersect_full ((filter), (caps), GST_CAPS_INTERSECT_FIRST); \
    gst_caps_unref ((caps));                                                  \
    (caps) = intersection;                                                    \
  }                                                                           \
} G_STMT_END

static GstCaps *
gst_play_sink_convert_bin_getcaps (GstPad * pad, GstCaps * filter)
{
  GstPlaySinkConvertBin *self =
      GST_PLAY_SINK_CONVERT_BIN (gst_pad_get_parent (pad));
  GstCaps *ret;
  GstPad *otherpad, *peer;

  GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
  if (pad == self->srcpad) {
    otherpad = self->sinkpad;
  } else if (pad == self->sinkpad) {
    otherpad = self->srcpad;
  } else {
    GST_ERROR_OBJECT (pad, "Not one of our pads");
    otherpad = NULL;
  }

  if (otherpad) {
    peer = gst_pad_get_peer (otherpad);
    if (peer) {
      GstCaps *peer_caps;
      GstCaps *downstream_filter = NULL;

      /* Add all the caps that we can convert to to the filter caps,
       * otherwise downstream might just return EMPTY caps because
       * it doesn't handle the filter caps but we could still convert
       * to these caps */
      if (filter) {
        guint i, n;

        downstream_filter = gst_caps_new_empty ();

        /* Intersect raw video caps in the filter caps with the converter
         * caps. This makes sure that we don't accept raw video that we
         * can't handle, e.g. because of caps features */
        n = gst_caps_get_size (filter);
        for (i = 0; i < n; i++) {
          GstStructure *s;
          GstCaps *tmp, *tmp2;

          s = gst_structure_copy (gst_caps_get_structure (filter, i));
          if (gst_structure_has_name (s,
                  self->audio ? "audio/x-raw" : "video/x-raw")) {
            tmp = gst_caps_new_full (s, NULL);
            tmp2 = gst_caps_intersect (tmp, self->converter_caps);
            gst_caps_append (downstream_filter, tmp2);
            gst_caps_unref (tmp);
          } else {
            gst_caps_append_structure (downstream_filter, s);
          }
        }
        downstream_filter =
            gst_caps_merge (downstream_filter,
            gst_caps_ref (self->converter_caps));
      }

      peer_caps = gst_pad_query_caps (peer, downstream_filter);
      if (downstream_filter)
        gst_caps_unref (downstream_filter);
      gst_object_unref (peer);
      if (self->converter_caps && is_raw_caps (peer_caps, self->audio)) {
        GstCaps *converter_caps = gst_caps_ref (self->converter_caps);
        GstCapsFeatures *cf;
        GstStructure *s;
        guint i, n;

        ret = gst_caps_make_writable (peer_caps);

        /* Filter out ANY capsfeatures from the converter caps. We can't
         * convert to ANY capsfeatures, they are only there so that we
         * can passthrough whatever downstream can support... but we
         * definitely don't want to return them here
         */
        n = gst_caps_get_size (converter_caps);
        for (i = 0; i < n; i++) {
          s = gst_caps_get_structure (converter_caps, i);
          cf = gst_caps_get_features (converter_caps, i);

          if (cf && gst_caps_features_is_any (cf))
            continue;
          ret =
              gst_caps_merge_structure_full (ret, gst_structure_copy (s),
              (cf ? gst_caps_features_copy (cf) : NULL));
        }
        gst_caps_unref (converter_caps);
      } else {
        ret = peer_caps;
      }
    } else {
      ret = gst_caps_ref (self->converter_caps);
    }
    GST_PLAY_SINK_CONVERT_BIN_FILTER_CAPS (filter, ret);

  } else {
    ret = filter ? gst_caps_ref (filter) : gst_caps_new_any ();
  }
  GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);

  gst_object_unref (self);

  GST_DEBUG_OBJECT (pad, "Returning caps %" GST_PTR_FORMAT, ret);

  return ret;
}

static gboolean
gst_play_sink_convert_bin_acceptcaps (GstPad * pad, GstCaps * caps)
{
  GstCaps *allowed_caps;
  gboolean ret;

  allowed_caps = gst_pad_query_caps (pad, NULL);
  ret = gst_caps_is_subset (caps, allowed_caps);
  gst_caps_unref (allowed_caps);

  return ret;
}

static gboolean
gst_play_sink_convert_bin_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  gboolean res = FALSE;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_ACCEPT_CAPS:
    {
      GstCaps *caps;

      gst_query_parse_accept_caps (query, &caps);
      gst_query_set_accept_caps_result (query,
          gst_play_sink_convert_bin_acceptcaps (pad, caps));
      res = TRUE;
      break;
    }
    case GST_QUERY_CAPS:
    {
      GstCaps *filter, *caps;

      gst_query_parse_caps (query, &filter);
      caps = gst_play_sink_convert_bin_getcaps (pad, filter);
      gst_query_set_caps_result (query, caps);
      gst_caps_unref (caps);
      res = TRUE;
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }
  return res;
}

void
gst_play_sink_convert_bin_remove_elements (GstPlaySinkConvertBin * self)
{
  if (self->conversion_elements) {
    g_list_foreach (self->conversion_elements,
        (GFunc) gst_play_sink_convert_bin_remove_element, self);
    g_list_free (self->conversion_elements);
    self->conversion_elements = NULL;
  }
  if (self->converter_caps) {
    gst_caps_unref (self->converter_caps);
    self->converter_caps = NULL;
  }
}

static void
gst_play_sink_convert_bin_dispose (GObject * object)
{
  GstPlaySinkConvertBin *self = GST_PLAY_SINK_CONVERT_BIN_CAST (object);

  gst_play_sink_convert_bin_remove_elements (self);

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_play_sink_convert_bin_finalize (GObject * object)
{
  GstPlaySinkConvertBin *self = GST_PLAY_SINK_CONVERT_BIN_CAST (object);

  gst_object_unref (self->sink_proxypad);
  g_mutex_clear (&self->lock);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

void
gst_play_sink_convert_bin_cache_converter_caps (GstPlaySinkConvertBin * self)
{
  GstElement *head;
  GstPad *pad;

  if (self->converter_caps) {
    gst_caps_unref (self->converter_caps);
    self->converter_caps = NULL;
  }

  if (!self->conversion_elements) {
    GST_INFO_OBJECT (self, "No conversion elements");
    return;
  }

  head = GST_ELEMENT (g_list_first (self->conversion_elements)->data);
  pad = gst_element_get_static_pad (head, "sink");
  if (!pad) {
    GST_WARNING_OBJECT (self, "No sink pad found");
    return;
  }

  self->converter_caps = gst_pad_query_caps (pad, NULL);
  GST_INFO_OBJECT (self, "Converter caps: %" GST_PTR_FORMAT,
      self->converter_caps);

  gst_object_unref (pad);
}

static GstStateChangeReturn
gst_play_sink_convert_bin_change_state (GstElement * element,
    GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstPlaySinkConvertBin *self = GST_PLAY_SINK_CONVERT_BIN_CAST (element);

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
      unblock_proxypad (self);
      GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
      gst_play_sink_convert_bin_set_targets (self, TRUE);
      self->raw = FALSE;
      GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
  if (ret == GST_STATE_CHANGE_FAILURE)
    return ret;

  switch (transition) {
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
      gst_play_sink_convert_bin_set_targets (self, TRUE);
      self->raw = FALSE;
      GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_PLAY_SINK_CONVERT_BIN_LOCK (self);
      unblock_proxypad (self);
      GST_PLAY_SINK_CONVERT_BIN_UNLOCK (self);
      break;
    default:
      break;
  }

  return ret;
}

static void
gst_play_sink_convert_bin_class_init (GstPlaySinkConvertBinClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  GST_DEBUG_CATEGORY_INIT (gst_play_sink_convert_bin_debug,
      "playsinkconvertbin", 0, "play bin");

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;

  gobject_class->dispose = gst_play_sink_convert_bin_dispose;
  gobject_class->finalize = gst_play_sink_convert_bin_finalize;

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&srctemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));
  gst_element_class_set_static_metadata (gstelement_class,
      "Player Sink Converter Bin", "Bin/Converter",
      "Convenience bin for audio/video conversion",
      "Sebastian Dröge <sebastian.droege@collabora.co.uk>");

  gstelement_class->change_state =
      GST_DEBUG_FUNCPTR (gst_play_sink_convert_bin_change_state);
}

static void
gst_play_sink_convert_bin_init (GstPlaySinkConvertBin * self)
{
  GstPadTemplate *templ;

  g_mutex_init (&self->lock);

  templ = gst_static_pad_template_get (&sinktemplate);
  self->sinkpad = gst_ghost_pad_new_no_target_from_template ("sink", templ);
  gst_pad_set_event_function (self->sinkpad,
      GST_DEBUG_FUNCPTR (gst_play_sink_convert_bin_sink_event));
  gst_pad_set_query_function (self->sinkpad,
      GST_DEBUG_FUNCPTR (gst_play_sink_convert_bin_query));

  self->sink_proxypad =
      GST_PAD_CAST (gst_proxy_pad_get_internal (GST_PROXY_PAD (self->sinkpad)));

  gst_element_add_pad (GST_ELEMENT_CAST (self), self->sinkpad);
  gst_object_unref (templ);

  templ = gst_static_pad_template_get (&srctemplate);
  self->srcpad = gst_ghost_pad_new_no_target_from_template ("src", templ);
  gst_pad_set_query_function (self->srcpad,
      GST_DEBUG_FUNCPTR (gst_play_sink_convert_bin_query));
  gst_element_add_pad (GST_ELEMENT_CAST (self), self->srcpad);
  gst_object_unref (templ);

  gst_play_sink_convert_bin_add_identity (self);
}
