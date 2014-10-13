/*
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
 * SECTION:element-subtitleoverlay
 *
 * #GstBin that auto-magically overlays a video stream with subtitles by
 * autoplugging the required elements.
 *
 * It supports raw, timestamped text, different textual subtitle formats and
 * DVD subpicture subtitles.
 *
 * <refsect2>
 * <title>Examples</title>
 * |[
 * gst-launch -v filesrc location=test.mkv ! matroskademux name=demux ! "video/x-h264" ! queue2 ! decodebin ! subtitleoverlay name=overlay ! videoconvert ! autovideosink  demux. ! "subpicture/x-dvd" ! queue2 ! overlay.
 * ]| This will play back the given Matroska file with h264 video and subpicture subtitles.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "gstsubtitleoverlay.h"

#include <gst/pbutils/missing-plugins.h>
#include <gst/video/video.h>
#include <string.h>

GST_DEBUG_CATEGORY_STATIC (subtitle_overlay_debug);
#define GST_CAT_DEFAULT subtitle_overlay_debug

#define IS_SUBTITLE_CHAIN_IGNORE_ERROR(flow) \
  G_UNLIKELY (flow == GST_FLOW_ERROR || flow == GST_FLOW_NOT_NEGOTIATED)

#define IS_VIDEO_CHAIN_IGNORE_ERROR(flow) \
  G_UNLIKELY (flow == GST_FLOW_ERROR)

static GstStaticPadTemplate srctemplate = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate video_sinktemplate =
GST_STATIC_PAD_TEMPLATE ("video_sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

static GstStaticPadTemplate subtitle_sinktemplate =
GST_STATIC_PAD_TEMPLATE ("subtitle_sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

enum
{
  PROP_0,
  PROP_SILENT,
  PROP_FONT_DESC,
  PROP_SUBTITLE_ENCODING
};

#define gst_subtitle_overlay_parent_class parent_class
G_DEFINE_TYPE (GstSubtitleOverlay, gst_subtitle_overlay, GST_TYPE_BIN);

static GQuark _subtitle_overlay_event_marker_id = 0;

static void
do_async_start (GstSubtitleOverlay * self)
{
  if (!self->do_async) {
    GstMessage *msg = gst_message_new_async_start (GST_OBJECT_CAST (self));

    GST_DEBUG_OBJECT (self, "Posting async-start");
    GST_BIN_CLASS (parent_class)->handle_message (GST_BIN_CAST (self), msg);
    self->do_async = TRUE;
  }
}

static void
do_async_done (GstSubtitleOverlay * self)
{
  if (self->do_async) {
    GstMessage *msg = gst_message_new_async_done (GST_OBJECT_CAST (self),
        GST_CLOCK_TIME_NONE);

    GST_DEBUG_OBJECT (self, "Posting async-done");
    GST_BIN_CLASS (parent_class)->handle_message (GST_BIN_CAST (self), msg);
    self->do_async = FALSE;
  }
}

static GstPadProbeReturn
_pad_blocked_cb (GstPad * pad, GstPadProbeInfo * info, gpointer user_data);

static void
block_video (GstSubtitleOverlay * self)
{
  if (self->video_block_id != 0)
    return;

  if (self->video_block_pad) {
    self->video_block_id =
        gst_pad_add_probe (self->video_block_pad,
        GST_PAD_PROBE_TYPE_BLOCK_DOWNSTREAM, _pad_blocked_cb, self, NULL);
  }
}

static void
unblock_video (GstSubtitleOverlay * self)
{
  if (self->video_block_id) {
    gst_pad_remove_probe (self->video_block_pad, self->video_block_id);
    self->video_sink_blocked = FALSE;
    self->video_block_id = 0;
  }
}

static void
block_subtitle (GstSubtitleOverlay * self)
{
  if (self->subtitle_block_id != 0)
    return;

  if (self->subtitle_block_pad) {
    self->subtitle_block_id =
        gst_pad_add_probe (self->subtitle_block_pad,
        GST_PAD_PROBE_TYPE_BLOCK_DOWNSTREAM, _pad_blocked_cb, self, NULL);
  }
}

static void
unblock_subtitle (GstSubtitleOverlay * self)
{
  if (self->subtitle_block_id) {
    gst_pad_remove_probe (self->subtitle_block_pad, self->subtitle_block_id);
    self->subtitle_sink_blocked = FALSE;
    self->subtitle_block_id = 0;
  }
}

static void
gst_subtitle_overlay_finalize (GObject * object)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (object);

  g_mutex_clear (&self->lock);
  g_mutex_clear (&self->factories_lock);

  if (self->factories)
    gst_plugin_feature_list_free (self->factories);
  self->factories = NULL;
  gst_caps_replace (&self->factory_caps, NULL);

  if (self->font_desc) {
    g_free (self->font_desc);
    self->font_desc = NULL;
  }

  if (self->encoding) {
    g_free (self->encoding);
    self->encoding = NULL;
  }

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static gboolean
_is_renderer (GstElementFactory * factory)
{
  const gchar *klass, *name;

  klass =
      gst_element_factory_get_metadata (factory, GST_ELEMENT_METADATA_KLASS);
  name = gst_plugin_feature_get_name (GST_PLUGIN_FEATURE_CAST (factory));

  if (klass != NULL) {
    if (strstr (klass, "Overlay/Subtitle") != NULL ||
        strstr (klass, "Overlay/SubPicture") != NULL)
      return TRUE;
    if (strcmp (name, "textoverlay") == 0)
      return TRUE;
  }
  return FALSE;
}

static gboolean
_is_parser (GstElementFactory * factory)
{
  const gchar *klass;

  klass =
      gst_element_factory_get_metadata (factory, GST_ELEMENT_METADATA_KLASS);

  if (klass != NULL && strstr (klass, "Parser/Subtitle") != NULL)
    return TRUE;
  return FALSE;
}

static const gchar *const _sub_pad_names[] = { "subpicture", "subpicture_sink",
  "text", "text_sink",
  "subtitle_sink", "subtitle"
};

static gboolean
_is_video_pad (GstPad * pad, gboolean * hw_accelerated)
{
  GstPad *peer = gst_pad_get_peer (pad);
  GstCaps *caps;
  gboolean ret = FALSE;
  const gchar *name;
  guint i;

  if (peer) {
    caps = gst_pad_get_current_caps (peer);
    if (!caps) {
      caps = gst_pad_query_caps (peer, NULL);
    }
    gst_object_unref (peer);
  } else {
    caps = gst_pad_query_caps (pad, NULL);
  }

  for (i = 0; i < gst_caps_get_size (caps) && ret == FALSE; i++) {
    name = gst_structure_get_name (gst_caps_get_structure (caps, i));
    if (g_str_equal (name, "video/x-raw")) {
      ret = TRUE;
      if (hw_accelerated)
        *hw_accelerated = FALSE;

    } else if (g_str_has_prefix (name, "video/x-surface")) {
      ret = TRUE;
      if (hw_accelerated)
        *hw_accelerated = TRUE;
    } else {

      ret = FALSE;
      if (hw_accelerated)
        *hw_accelerated = FALSE;
    }
  }

  gst_caps_unref (caps);

  return ret;
}

static GstCaps *
_get_sub_caps (GstElementFactory * factory)
{
  const GList *templates;
  GList *walk;
  gboolean is_parser = _is_parser (factory);

  templates = gst_element_factory_get_static_pad_templates (factory);
  for (walk = (GList *) templates; walk; walk = g_list_next (walk)) {
    GstStaticPadTemplate *templ = walk->data;

    if (templ->direction == GST_PAD_SINK && templ->presence == GST_PAD_ALWAYS) {
      gboolean found = FALSE;

      if (is_parser) {
        found = TRUE;
      } else {
        guint i;

        for (i = 0; i < G_N_ELEMENTS (_sub_pad_names); i++) {
          if (strcmp (templ->name_template, _sub_pad_names[i]) == 0) {
            found = TRUE;
            break;
          }
        }
      }
      if (found)
        return gst_static_caps_get (&templ->static_caps);
    }
  }
  return NULL;
}

static gboolean
_factory_filter (GstPluginFeature * feature, GstCaps ** subcaps)
{
  GstElementFactory *factory;
  guint rank;
  const gchar *name;
  const GList *templates;
  GList *walk;
  gboolean is_renderer;
  GstCaps *templ_caps = NULL;
  gboolean have_video_sink = FALSE;

  /* we only care about element factories */
  if (!GST_IS_ELEMENT_FACTORY (feature))
    return FALSE;

  factory = GST_ELEMENT_FACTORY_CAST (feature);

  /* only select elements with autoplugging rank or textoverlay */
  name = gst_plugin_feature_get_name (feature);
  rank = gst_plugin_feature_get_rank (feature);
  if (strcmp ("textoverlay", name) != 0 && rank < GST_RANK_MARGINAL)
    return FALSE;

  /* Check if it's a renderer or a parser */
  if (_is_renderer (factory)) {
    is_renderer = TRUE;
  } else if (_is_parser (factory)) {
    is_renderer = FALSE;
  } else {
    return FALSE;
  }

  /* Check if there's a video sink in case of a renderer */
  if (is_renderer) {
    templates = gst_element_factory_get_static_pad_templates (factory);
    for (walk = (GList *) templates; walk; walk = g_list_next (walk)) {
      GstStaticPadTemplate *templ = walk->data;

      /* we only care about the always-sink templates */
      if (templ->direction == GST_PAD_SINK && templ->presence == GST_PAD_ALWAYS) {
        if (strcmp (templ->name_template, "video") == 0 ||
            strcmp (templ->name_template, "video_sink") == 0) {
          have_video_sink = TRUE;
        }
      }
    }
  }
  templ_caps = _get_sub_caps (factory);

  if (is_renderer && have_video_sink && templ_caps) {
    GST_DEBUG ("Found renderer element %s (%s) with caps %" GST_PTR_FORMAT,
        gst_element_factory_get_metadata (factory,
            GST_ELEMENT_METADATA_LONGNAME),
        gst_plugin_feature_get_name (feature), templ_caps);
    *subcaps = gst_caps_merge (*subcaps, templ_caps);
    return TRUE;
  } else if (!is_renderer && !have_video_sink && templ_caps) {
    GST_DEBUG ("Found parser element %s (%s) with caps %" GST_PTR_FORMAT,
        gst_element_factory_get_metadata (factory,
            GST_ELEMENT_METADATA_LONGNAME),
        gst_plugin_feature_get_name (feature), templ_caps);
    *subcaps = gst_caps_merge (*subcaps, templ_caps);
    return TRUE;
  } else {
    if (templ_caps)
      gst_caps_unref (templ_caps);
    return FALSE;
  }
}

/* Call with factories_lock! */
static gboolean
gst_subtitle_overlay_update_factory_list (GstSubtitleOverlay * self)
{
  GstRegistry *registry;
  guint cookie;

  registry = gst_registry_get ();
  cookie = gst_registry_get_feature_list_cookie (registry);
  if (!self->factories || self->factories_cookie != cookie) {
    GstCaps *subcaps;
    GList *factories;

    subcaps = gst_caps_new_empty ();

    factories = gst_registry_feature_filter (registry,
        (GstPluginFeatureFilter) _factory_filter, FALSE, &subcaps);
    GST_DEBUG_OBJECT (self, "Created factory caps: %" GST_PTR_FORMAT, subcaps);
    gst_caps_replace (&self->factory_caps, subcaps);
    gst_caps_unref (subcaps);
    if (self->factories)
      gst_plugin_feature_list_free (self->factories);
    self->factories = factories;
    self->factories_cookie = cookie;
  }

  return (self->factories != NULL);
}

G_LOCK_DEFINE_STATIC (_factory_caps);
static GstCaps *_factory_caps = NULL;
static guint32 _factory_caps_cookie = 0;

GstCaps *
gst_subtitle_overlay_create_factory_caps (void)
{
  GstRegistry *registry;
  GList *factories;
  GstCaps *subcaps = NULL;
  guint cookie;

  registry = gst_registry_get ();
  cookie = gst_registry_get_feature_list_cookie (registry);
  G_LOCK (_factory_caps);
  if (!_factory_caps || _factory_caps_cookie != cookie) {
    if (_factory_caps)
      gst_caps_unref (_factory_caps);
    _factory_caps = gst_caps_new_empty ();

    factories = gst_registry_feature_filter (registry,
        (GstPluginFeatureFilter) _factory_filter, FALSE, &_factory_caps);
    GST_DEBUG ("Created factory caps: %" GST_PTR_FORMAT, _factory_caps);
    gst_plugin_feature_list_free (factories);
    _factory_caps_cookie = cookie;
  }
  subcaps = gst_caps_ref (_factory_caps);
  G_UNLOCK (_factory_caps);

  return subcaps;
}

static gboolean
check_factory_for_caps (GstElementFactory * factory, const GstCaps * caps)
{
  GstCaps *fcaps = _get_sub_caps (factory);
  gboolean ret = (fcaps) ? gst_caps_is_subset (caps, fcaps) : FALSE;

  if (fcaps)
    gst_caps_unref (fcaps);

  if (ret)
    gst_object_ref (factory);
  return ret;
}

static GList *
gst_subtitle_overlay_get_factories_for_caps (const GList * list,
    const GstCaps * caps)
{
  const GList *walk = list;
  GList *result = NULL;

  while (walk) {
    GstElementFactory *factory = walk->data;

    walk = g_list_next (walk);

    if (check_factory_for_caps (factory, caps)) {
      result = g_list_prepend (result, factory);
    }
  }

  return result;
}

static gint
_sort_by_ranks (GstPluginFeature * f1, GstPluginFeature * f2)
{
  gint diff;
  const gchar *rname1, *rname2;

  diff = gst_plugin_feature_get_rank (f2) - gst_plugin_feature_get_rank (f1);
  if (diff != 0)
    return diff;

  /* If the ranks are the same sort by name to get deterministic results */
  rname1 = gst_plugin_feature_get_name (f1);
  rname2 = gst_plugin_feature_get_name (f2);

  diff = strcmp (rname1, rname2);

  return diff;
}

static GstPad *
_get_sub_pad (GstElement * element)
{
  GstPad *pad;
  guint i;

  for (i = 0; i < G_N_ELEMENTS (_sub_pad_names); i++) {
    pad = gst_element_get_static_pad (element, _sub_pad_names[i]);
    if (pad)
      return pad;
  }
  return NULL;
}

static GstPad *
_get_video_pad (GstElement * element)
{
  static const gchar *const pad_names[] = { "video", "video_sink" };
  GstPad *pad;
  guint i;

  for (i = 0; i < G_N_ELEMENTS (pad_names); i++) {
    pad = gst_element_get_static_pad (element, pad_names[i]);
    if (pad)
      return pad;
  }
  return NULL;
}

static gboolean
_create_element (GstSubtitleOverlay * self, GstElement ** element,
    const gchar * factory_name, GstElementFactory * factory,
    const gchar * element_name, gboolean mandatory)
{
  GstElement *elt;

  g_assert (!factory || !factory_name);

  if (factory_name) {
    elt = gst_element_factory_make (factory_name, element_name);
  } else {
    factory_name =
        gst_plugin_feature_get_name (GST_PLUGIN_FEATURE_CAST (factory));
    elt = gst_element_factory_create (factory, element_name);
  }

  if (G_UNLIKELY (!elt)) {
    if (!factory) {
      GstMessage *msg;

      msg =
          gst_missing_element_message_new (GST_ELEMENT_CAST (self),
          factory_name);
      gst_element_post_message (GST_ELEMENT_CAST (self), msg);

      if (mandatory)
        GST_ELEMENT_ERROR (self, CORE, MISSING_PLUGIN, (NULL),
            ("no '%s' plugin found", factory_name));
      else
        GST_ELEMENT_WARNING (self, CORE, MISSING_PLUGIN, (NULL),
            ("no '%s' plugin found", factory_name));
    } else {
      if (mandatory) {
        GST_ELEMENT_ERROR (self, CORE, FAILED, (NULL),
            ("can't instantiate '%s'", factory_name));
      } else {
        GST_ELEMENT_WARNING (self, CORE, FAILED, (NULL),
            ("can't instantiate '%s'", factory_name));
      }
    }

    return FALSE;
  }

  if (G_UNLIKELY (gst_element_set_state (elt,
              GST_STATE_READY) != GST_STATE_CHANGE_SUCCESS)) {
    gst_object_unref (elt);
    if (mandatory) {
      GST_ELEMENT_ERROR (self, CORE, STATE_CHANGE, (NULL),
          ("failed to set '%s' to READY", factory_name));
    } else {
      GST_WARNING_OBJECT (self, "Failed to set '%s' to READY", factory_name);
    }
    return FALSE;
  }

  if (G_UNLIKELY (!gst_bin_add (GST_BIN_CAST (self), gst_object_ref (elt)))) {
    gst_element_set_state (elt, GST_STATE_NULL);
    gst_object_unref (elt);
    if (mandatory) {
      GST_ELEMENT_ERROR (self, CORE, FAILED, (NULL),
          ("failed to add '%s' to subtitleoverlay", factory_name));
    } else {
      GST_WARNING_OBJECT (self, "Failed to add '%s' to subtitleoverlay",
          factory_name);
    }
    return FALSE;
  }

  gst_element_sync_state_with_parent (elt);
  *element = elt;
  return TRUE;
}

static void
_remove_element (GstSubtitleOverlay * self, GstElement ** element)
{
  if (*element) {
    gst_bin_remove (GST_BIN_CAST (self), *element);
    gst_element_set_state (*element, GST_STATE_NULL);
    gst_object_unref (*element);
    *element = NULL;
  }
}

static gboolean
_setup_passthrough (GstSubtitleOverlay * self)
{
  GstPad *src, *sink;
  GstElement *identity;

  GST_DEBUG_OBJECT (self, "Doing video passthrough");

  if (self->passthrough_identity) {
    GST_DEBUG_OBJECT (self, "Already in passthrough mode");
    goto out;
  }

  /* Unlink & destroy everything */
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), NULL);
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->video_sinkpad), NULL);
  gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->subtitle_sinkpad), NULL);
  self->silent_property = NULL;
  _remove_element (self, &self->post_colorspace);
  _remove_element (self, &self->overlay);
  _remove_element (self, &self->parser);
  _remove_element (self, &self->renderer);
  _remove_element (self, &self->pre_colorspace);
  _remove_element (self, &self->passthrough_identity);

  if (G_UNLIKELY (!_create_element (self, &self->passthrough_identity,
              "identity", NULL, "passthrough-identity", TRUE))) {
    return FALSE;
  }

  identity = self->passthrough_identity;
  g_object_set (G_OBJECT (identity), "silent", TRUE, "signal-handoffs", FALSE,
      NULL);

  /* Set src ghostpad target */
  src = gst_element_get_static_pad (self->passthrough_identity, "src");
  if (G_UNLIKELY (!src)) {
    GST_ELEMENT_ERROR (self, CORE, PAD, (NULL),
        ("Failed to get srcpad from identity"));
    return FALSE;
  }

  if (G_UNLIKELY (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad),
              src))) {
    GST_ELEMENT_ERROR (self, CORE, PAD, (NULL),
        ("Failed to set srcpad target"));
    gst_object_unref (src);
    return FALSE;
  }
  gst_object_unref (src);

  sink = gst_element_get_static_pad (self->passthrough_identity, "sink");
  if (G_UNLIKELY (!sink)) {
    GST_ELEMENT_ERROR (self, CORE, PAD, (NULL),
        ("Failed to get sinkpad from identity"));
    return FALSE;
  }

  /* Link sink ghostpads to identity */
  if (G_UNLIKELY (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST
              (self->video_sinkpad), sink))) {
    GST_ELEMENT_ERROR (self, CORE, PAD, (NULL),
        ("Failed to set video sinkpad target"));
    gst_object_unref (sink);
    return FALSE;
  }
  gst_object_unref (sink);

  GST_DEBUG_OBJECT (self, "Video passthrough setup successfully");

out:
  /* Unblock pads */
  unblock_video (self);
  unblock_subtitle (self);

  return TRUE;
}

/* Must be called with subtitleoverlay lock! */
static gboolean
_has_property_with_type (GObject * object, const gchar * property, GType type)
{
  GObjectClass *gobject_class;
  GParamSpec *pspec;

  gobject_class = G_OBJECT_GET_CLASS (object);
  pspec = g_object_class_find_property (gobject_class, property);
  return (pspec && pspec->value_type == type);
}

static void
gst_subtitle_overlay_set_fps (GstSubtitleOverlay * self)
{
  if (!self->parser || self->fps_d == 0)
    return;

  if (!_has_property_with_type (G_OBJECT (self->parser), "video-fps",
          GST_TYPE_FRACTION))
    return;

  GST_DEBUG_OBJECT (self, "Updating video-fps property in parser");
  g_object_set (self->parser, "video-fps", self->fps_n, self->fps_d, NULL);
}

static const gchar *
_get_silent_property (GstElement * element, gboolean * invert)
{
  static const struct
  {
    const gchar *name;
    gboolean invert;
  } properties[] = { {
  "silent", FALSE}, {
  "enable", TRUE}};
  guint i;

  for (i = 0; i < G_N_ELEMENTS (properties); i++) {
    if (_has_property_with_type (G_OBJECT (element), properties[i].name,
            G_TYPE_BOOLEAN)) {
      *invert = properties[i].invert;
      return properties[i].name;
    }
  }
  return NULL;
}

static gboolean
_setup_parser (GstSubtitleOverlay * self)
{
  GstPad *video_peer;

  /* Try to get the latest video framerate */
  video_peer = gst_pad_get_peer (self->video_sinkpad);
  if (video_peer) {
    GstCaps *video_caps;
    gint fps_n, fps_d;

    video_caps = gst_pad_get_current_caps (video_peer);
    if (!video_caps) {
      video_caps = gst_pad_query_caps (video_peer, NULL);
      if (!gst_caps_is_fixed (video_caps)) {
        gst_caps_unref (video_caps);
        video_caps = NULL;
      }
    }

    if (video_caps) {
      GstStructure *st = gst_caps_get_structure (video_caps, 0);
      if (gst_structure_get_fraction (st, "framerate", &fps_n, &fps_d)) {
        GST_DEBUG_OBJECT (self, "New video fps: %d/%d", fps_n, fps_d);
        self->fps_n = fps_n;
        self->fps_d = fps_d;
      }
    }

    if (video_caps)
      gst_caps_unref (video_caps);
    gst_object_unref (video_peer);
  }

  if (_has_property_with_type (G_OBJECT (self->parser), "subtitle-encoding",
          G_TYPE_STRING))
    g_object_set (self->parser, "subtitle-encoding", self->encoding, NULL);

  /* Try to set video fps on the parser */
  gst_subtitle_overlay_set_fps (self);


  return TRUE;
}

static gboolean
_setup_renderer (GstSubtitleOverlay * self, GstElement * renderer)
{
  GstElementFactory *factory = gst_element_get_factory (renderer);
  const gchar *name =
      gst_plugin_feature_get_name (GST_PLUGIN_FEATURE_CAST (factory));

  if (strcmp (name, "textoverlay") == 0) {
    /* Set some textoverlay specific properties */
    gst_util_set_object_arg (G_OBJECT (renderer), "halignment", "center");
    gst_util_set_object_arg (G_OBJECT (renderer), "valignment", "bottom");
    g_object_set (G_OBJECT (renderer), "wait-text", FALSE, NULL);
    if (self->font_desc)
      g_object_set (G_OBJECT (renderer), "font-desc", self->font_desc, NULL);
    self->silent_property = "silent";
    self->silent_property_invert = FALSE;
  } else {
    self->silent_property =
        _get_silent_property (renderer, &self->silent_property_invert);
    if (_has_property_with_type (G_OBJECT (renderer), "subtitle-encoding",
            G_TYPE_STRING))
      g_object_set (renderer, "subtitle-encoding", self->encoding, NULL);
    if (_has_property_with_type (G_OBJECT (renderer), "font-desc",
            G_TYPE_STRING))
      g_object_set (renderer, "font-desc", self->font_desc, NULL);
  }

  return TRUE;
}

/* subtitle_src==NULL means: use subtitle_sink ghostpad */
static gboolean
_link_renderer (GstSubtitleOverlay * self, GstElement * renderer,
    GstPad * subtitle_src)
{
  GstPad *sink, *src;
  gboolean is_video, is_hw;

  is_video = _is_video_pad (self->video_sinkpad, &is_hw);

  if (is_video) {
    gboolean render_is_hw;

    /* First check that renderer also supports the video format */
    sink = _get_video_pad (renderer);
    if (G_UNLIKELY (!sink)) {
      GST_WARNING_OBJECT (self, "Can't get video sink from renderer");
      return FALSE;
    }

    if (is_video != _is_video_pad (sink, &render_is_hw) ||
        is_hw != render_is_hw) {
      GST_DEBUG_OBJECT (self, "Renderer doesn't support %s video",
          is_hw ? "surface" : "raw");
      gst_object_unref (sink);
      return FALSE;
    }
    gst_object_unref (sink);

    if (!is_hw) {
      /* First link everything internally */
      if (G_UNLIKELY (!_create_element (self, &self->post_colorspace,
                  COLORSPACE, NULL, "post-colorspace", FALSE))) {
        return FALSE;
      }
      src = gst_element_get_static_pad (renderer, "src");
      if (G_UNLIKELY (!src)) {
        GST_WARNING_OBJECT (self, "Can't get src pad from renderer");
        return FALSE;
      }

      sink = gst_element_get_static_pad (self->post_colorspace, "sink");
      if (G_UNLIKELY (!sink)) {
        GST_WARNING_OBJECT (self, "Can't get sink pad from " COLORSPACE);
        gst_object_unref (src);
        return FALSE;
      }

      if (G_UNLIKELY (gst_pad_link (src, sink) != GST_PAD_LINK_OK)) {
        GST_WARNING_OBJECT (self, "Can't link renderer with " COLORSPACE);
        gst_object_unref (src);
        gst_object_unref (sink);
        return FALSE;
      }
      gst_object_unref (src);
      gst_object_unref (sink);

      if (G_UNLIKELY (!_create_element (self, &self->pre_colorspace,
                  COLORSPACE, NULL, "pre-colorspace", FALSE))) {
        return FALSE;
      }

      sink = _get_video_pad (renderer);
      if (G_UNLIKELY (!sink)) {
        GST_WARNING_OBJECT (self, "Can't get video sink from renderer");
        return FALSE;
      }

      src = gst_element_get_static_pad (self->pre_colorspace, "src");
      if (G_UNLIKELY (!src)) {
        GST_WARNING_OBJECT (self, "Can't get srcpad from " COLORSPACE);
        gst_object_unref (sink);
        return FALSE;
      }

      if (G_UNLIKELY (gst_pad_link (src, sink) != GST_PAD_LINK_OK)) {
        GST_WARNING_OBJECT (self, "Can't link " COLORSPACE " to renderer");
        gst_object_unref (src);
        gst_object_unref (sink);
        return FALSE;
      }
      gst_object_unref (src);
      gst_object_unref (sink);

      /* Set src ghostpad target */
      src = gst_element_get_static_pad (self->post_colorspace, "src");
      if (G_UNLIKELY (!src)) {
        GST_WARNING_OBJECT (self, "Can't get src pad from " COLORSPACE);
        return FALSE;
      }
    } else {
      /* Set src ghostpad target in the harware accelerated case */

      src = gst_element_get_static_pad (renderer, "src");
      if (G_UNLIKELY (!src)) {
        GST_WARNING_OBJECT (self, "Can't get src pad from renderer");
        return FALSE;
      }
    }
  } else {                      /* No video pad */
    GstCaps *allowed_caps, *video_caps = NULL;
    GstPad *video_peer;
    gboolean is_subset = FALSE;

    video_peer = gst_pad_get_peer (self->video_sinkpad);
    if (video_peer) {
      video_caps = gst_pad_get_current_caps (video_peer);
      if (!video_caps) {
        video_caps = gst_pad_query_caps (video_peer, NULL);
      }
      gst_object_unref (video_peer);
    }

    sink = _get_video_pad (renderer);
    if (G_UNLIKELY (!sink)) {
      GST_WARNING_OBJECT (self, "Can't get video sink from renderer");
      return FALSE;
    }
    allowed_caps = gst_pad_query_caps (sink, NULL);
    gst_object_unref (sink);

    if (allowed_caps && video_caps)
      is_subset = gst_caps_is_subset (video_caps, allowed_caps);

    if (allowed_caps)
      gst_caps_unref (allowed_caps);

    if (video_caps)
      gst_caps_unref (video_caps);

    if (G_UNLIKELY (!is_subset)) {
      GST_WARNING_OBJECT (self, "Renderer with custom caps is not "
          "compatible with video stream");
      return FALSE;
    }

    src = gst_element_get_static_pad (renderer, "src");
    if (G_UNLIKELY (!src)) {
      GST_WARNING_OBJECT (self, "Can't get src pad from renderer");
      return FALSE;
    }
  }

  if (G_UNLIKELY (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST
              (self->srcpad), src))) {
    GST_WARNING_OBJECT (self, "Can't set srcpad target");
    gst_object_unref (src);
    return FALSE;
  }
  gst_object_unref (src);

  /* Set the sink ghostpad targets */
  if (self->pre_colorspace) {
    sink = gst_element_get_static_pad (self->pre_colorspace, "sink");
    if (G_UNLIKELY (!sink)) {
      GST_WARNING_OBJECT (self, "Can't get sink pad from " COLORSPACE);
      return FALSE;
    }
  } else {
    sink = _get_video_pad (renderer);
    if (G_UNLIKELY (!sink)) {
      GST_WARNING_OBJECT (self, "Can't get sink pad from %" GST_PTR_FORMAT,
          renderer);
      return FALSE;
    }
  }

  if (G_UNLIKELY (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST
              (self->video_sinkpad), sink))) {
    GST_WARNING_OBJECT (self, "Can't set video sinkpad target");
    gst_object_unref (sink);
    return FALSE;
  }
  gst_object_unref (sink);

  sink = _get_sub_pad (renderer);
  if (G_UNLIKELY (!sink)) {
    GST_WARNING_OBJECT (self, "Failed to get subpad");
    return FALSE;
  }

  if (subtitle_src) {
    if (G_UNLIKELY (gst_pad_link (subtitle_src, sink) != GST_PAD_LINK_OK)) {
      GST_WARNING_OBJECT (self, "Failed to link subtitle srcpad with renderer");
      gst_object_unref (sink);
      return FALSE;
    }
  } else {
    if (G_UNLIKELY (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST
                (self->subtitle_sinkpad), sink))) {
      GST_WARNING_OBJECT (self, "Failed to set subtitle sink target");
      gst_object_unref (sink);
      return FALSE;
    }
  }
  gst_object_unref (sink);

  return TRUE;
}

static GstPadProbeReturn
_pad_blocked_cb (GstPad * pad, GstPadProbeInfo * info, gpointer user_data)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY_CAST (user_data);
  GstCaps *subcaps;
  GList *l, *factories = NULL;

  if (GST_IS_EVENT (info->data) && !GST_EVENT_IS_SERIALIZED (info->data)) {
    GST_DEBUG_OBJECT (pad, "Letting non-serialized event %s pass",
        GST_EVENT_TYPE_NAME (info->data));
    return GST_PAD_PROBE_PASS;
  }

  GST_DEBUG_OBJECT (pad, "Pad blocked");

  GST_SUBTITLE_OVERLAY_LOCK (self);
  if (pad == self->video_block_pad)
    self->video_sink_blocked = TRUE;
  else if (pad == self->subtitle_block_pad)
    self->subtitle_sink_blocked = TRUE;

  /* Now either both or the video sink are blocked */

  /* Get current subtitle caps */
  subcaps = self->subcaps;
  if (!subcaps) {
    GstPad *peer;

    peer = gst_pad_get_peer (self->subtitle_sinkpad);
    if (peer) {
      subcaps = gst_pad_get_current_caps (peer);
      if (!subcaps) {
        subcaps = gst_pad_query_caps (peer, NULL);
        if (!gst_caps_is_fixed (subcaps)) {
          gst_caps_unref (subcaps);
          subcaps = NULL;
        }
      }
      gst_object_unref (peer);
    }
    gst_caps_replace (&self->subcaps, subcaps);
    if (subcaps)
      gst_caps_unref (subcaps);
  }
  GST_DEBUG_OBJECT (self, "Current subtitle caps: %" GST_PTR_FORMAT, subcaps);

  /* If there are no subcaps but the subtitle sink is blocked upstream
   * must behave wrong as there are no fixed caps set for the first
   * buffer or in-order event */
  if (G_UNLIKELY (!subcaps && self->subtitle_sink_blocked)) {
    GST_ELEMENT_WARNING (self, CORE, NEGOTIATION, (NULL),
        ("Subtitle sink is blocked but we have no subtitle caps"));
    subcaps = NULL;
  }

  if (self->subtitle_error || (self->silent && !self->silent_property)) {
    _setup_passthrough (self);
    do_async_done (self);
    goto out;
  }

  /* Now do something with the caps */
  if (subcaps && !self->subtitle_flush) {
    GstPad *target =
        gst_ghost_pad_get_target (GST_GHOST_PAD_CAST (self->subtitle_sinkpad));

    if (target && gst_pad_query_accept_caps (target, subcaps)) {
      GST_DEBUG_OBJECT (pad, "Target accepts caps");

      gst_object_unref (target);

      /* Unblock pads */
      unblock_video (self);
      unblock_subtitle (self);
      goto out;
    } else if (target) {
      gst_object_unref (target);
    }
  }

  if (self->subtitle_sink_blocked && !self->video_sink_blocked) {
    GST_DEBUG_OBJECT (self, "Subtitle sink blocked but video not blocked");
    block_video (self);
    goto out;
  }

  self->subtitle_flush = FALSE;

  /* Find our factories */
  g_mutex_lock (&self->factories_lock);
  gst_subtitle_overlay_update_factory_list (self);
  if (subcaps) {
    factories =
        gst_subtitle_overlay_get_factories_for_caps (self->factories, subcaps);
    if (!factories) {
      GstMessage *msg;

      msg = gst_missing_decoder_message_new (GST_ELEMENT_CAST (self), subcaps);
      gst_element_post_message (GST_ELEMENT_CAST (self), msg);
      GST_ELEMENT_WARNING (self, CORE, MISSING_PLUGIN, (NULL),
          ("no suitable subtitle plugin found"));
      subcaps = NULL;
      self->subtitle_error = TRUE;
    }
  }
  g_mutex_unlock (&self->factories_lock);

  if (!subcaps) {
    _setup_passthrough (self);
    do_async_done (self);
    goto out;
  }

  /* Now the interesting parts are done: subtitle overlaying! */

  /* Sort the factories by rank */
  factories = g_list_sort (factories, (GCompareFunc) _sort_by_ranks);

  for (l = factories; l; l = l->next) {
    GstElementFactory *factory = l->data;
    gboolean is_renderer = _is_renderer (factory);
    GstPad *sink, *src;

    /* Unlink & destroy everything */

    gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), NULL);
    gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->video_sinkpad), NULL);
    gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->subtitle_sinkpad),
        NULL);
    self->silent_property = NULL;
    _remove_element (self, &self->post_colorspace);
    _remove_element (self, &self->overlay);
    _remove_element (self, &self->parser);
    _remove_element (self, &self->renderer);
    _remove_element (self, &self->pre_colorspace);
    _remove_element (self, &self->passthrough_identity);

    GST_DEBUG_OBJECT (self, "Trying factory '%s'",
        GST_STR_NULL (gst_plugin_feature_get_name (GST_PLUGIN_FEATURE_CAST
                (factory))));

    if (G_UNLIKELY ((is_renderer
                && !_create_element (self, &self->renderer, NULL, factory,
                    "renderer", FALSE)) || (!is_renderer
                && !_create_element (self, &self->parser, NULL, factory,
                    "parser", FALSE))))
      continue;

    if (!is_renderer) {
      GstCaps *parser_caps;
      GList *overlay_factories, *k;

      if (!_setup_parser (self))
        continue;

      /* Find our factories */
      src = gst_element_get_static_pad (self->parser, "src");
      parser_caps = gst_pad_query_caps (src, NULL);
      gst_object_unref (src);

      g_assert (parser_caps != NULL);

      g_mutex_lock (&self->factories_lock);
      gst_subtitle_overlay_update_factory_list (self);
      GST_DEBUG_OBJECT (self,
          "Searching overlay factories for caps %" GST_PTR_FORMAT, parser_caps);
      overlay_factories =
          gst_subtitle_overlay_get_factories_for_caps (self->factories,
          parser_caps);
      g_mutex_unlock (&self->factories_lock);

      if (!overlay_factories) {
        GST_WARNING_OBJECT (self,
            "Found no suitable overlay factories for caps %" GST_PTR_FORMAT,
            parser_caps);
        gst_caps_unref (parser_caps);
        continue;
      }
      gst_caps_unref (parser_caps);

      /* Sort the factories by rank */
      overlay_factories =
          g_list_sort (overlay_factories, (GCompareFunc) _sort_by_ranks);

      for (k = overlay_factories; k; k = k->next) {
        GstElementFactory *overlay_factory = k->data;

        GST_DEBUG_OBJECT (self, "Trying overlay factory '%s'",
            GST_STR_NULL (gst_plugin_feature_get_name (GST_PLUGIN_FEATURE_CAST
                    (overlay_factory))));

        /* Try this factory and link it, otherwise unlink everything
         * again and remove the overlay. Up to this point only the
         * parser was instantiated and setup, nothing was linked
         */

        gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), NULL);
        gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->video_sinkpad),
            NULL);
        gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->subtitle_sinkpad),
            NULL);
        self->silent_property = NULL;
        _remove_element (self, &self->post_colorspace);
        _remove_element (self, &self->overlay);
        _remove_element (self, &self->pre_colorspace);

        if (!_create_element (self, &self->overlay, NULL, overlay_factory,
                "overlay", FALSE)) {
          GST_DEBUG_OBJECT (self, "Could not create element");
          continue;
        }

        if (!_setup_renderer (self, self->overlay)) {
          GST_DEBUG_OBJECT (self, "Could not setup element");
          continue;
        }

        src = gst_element_get_static_pad (self->parser, "src");
        if (!_link_renderer (self, self->overlay, src)) {
          GST_DEBUG_OBJECT (self, "Could not link element");
          gst_object_unref (src);
          continue;
        }
        gst_object_unref (src);

        /* Everything done here, go out of loop */
        GST_DEBUG_OBJECT (self, "%s is a suitable element",
            GST_STR_NULL (gst_plugin_feature_get_name (GST_PLUGIN_FEATURE_CAST
                    (overlay_factory))));
        break;
      }

      if (overlay_factories)
        gst_plugin_feature_list_free (overlay_factories);

      if (G_UNLIKELY (k == NULL)) {
        GST_WARNING_OBJECT (self, "Failed to find usable overlay factory");
        continue;
      }

      /* Now link subtitle sinkpad of the bin and the parser */
      sink = gst_element_get_static_pad (self->parser, "sink");
      if (!gst_ghost_pad_set_target (GST_GHOST_PAD_CAST
              (self->subtitle_sinkpad), sink)) {
        gst_object_unref (sink);
        continue;
      }
      gst_object_unref (sink);

      /* Everything done here, go out of loop */
      break;
    } else {
      /* Is renderer factory */

      if (!_setup_renderer (self, self->renderer))
        continue;

      /* subtitle_src==NULL means: use subtitle_sink ghostpad */
      if (!_link_renderer (self, self->renderer, NULL))
        continue;

      /* Everything done here, go out of loop */
      break;
    }
  }

  if (G_UNLIKELY (l == NULL)) {
    GST_ELEMENT_WARNING (self, CORE, FAILED, (NULL),
        ("Failed to find any usable factories"));
    self->subtitle_error = TRUE;
    _setup_passthrough (self);
    do_async_done (self);
    goto out;
  }

  GST_DEBUG_OBJECT (self, "Everything worked, unblocking pads");
  unblock_video (self);
  unblock_subtitle (self);
  do_async_done (self);

out:
  if (factories)
    gst_plugin_feature_list_free (factories);
  GST_SUBTITLE_OVERLAY_UNLOCK (self);

  return GST_PAD_PROBE_OK;
}

static GstStateChangeReturn
gst_subtitle_overlay_change_state (GstElement * element,
    GstStateChange transition)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (element);
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      GST_DEBUG_OBJECT (self, "State change NULL->READY");
      g_mutex_lock (&self->factories_lock);
      if (G_UNLIKELY (!gst_subtitle_overlay_update_factory_list (self))) {
        g_mutex_unlock (&self->factories_lock);
        return GST_STATE_CHANGE_FAILURE;
      }
      g_mutex_unlock (&self->factories_lock);

      GST_SUBTITLE_OVERLAY_LOCK (self);
      /* Set the internal pads to blocking */
      block_video (self);
      block_subtitle (self);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
      break;
    case GST_STATE_CHANGE_READY_TO_PAUSED:
      GST_DEBUG_OBJECT (self, "State change READY->PAUSED");

      self->fps_n = self->fps_d = 0;

      self->subtitle_flush = FALSE;
      self->subtitle_error = FALSE;

      self->downstream_chain_error = FALSE;

      do_async_start (self);
      ret = GST_STATE_CHANGE_ASYNC;

      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      GST_DEBUG_OBJECT (self, "State change PAUSED->PLAYING");
    default:
      break;
  }

  {
    GstStateChangeReturn bret;

    bret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
    GST_DEBUG_OBJECT (self, "Base class state changed returned: %d", bret);
    if (G_UNLIKELY (bret == GST_STATE_CHANGE_FAILURE))
      return ret;
    else if (bret == GST_STATE_CHANGE_ASYNC)
      ret = bret;
    else if (G_UNLIKELY (bret == GST_STATE_CHANGE_NO_PREROLL)) {
      do_async_done (self);
      ret = bret;
    }
  }

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      GST_DEBUG_OBJECT (self, "State change PLAYING->PAUSED");
      break;
    case GST_STATE_CHANGE_PAUSED_TO_READY:
      GST_DEBUG_OBJECT (self, "State change PAUSED->READY");

      /* Set the pads back to blocking state */
      GST_SUBTITLE_OVERLAY_LOCK (self);
      block_video (self);
      block_subtitle (self);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);

      do_async_done (self);

      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      GST_DEBUG_OBJECT (self, "State change READY->NULL");

      GST_SUBTITLE_OVERLAY_LOCK (self);
      gst_caps_replace (&self->subcaps, NULL);

      /* Unlink ghost pads */
      gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->srcpad), NULL);
      gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->video_sinkpad), NULL);
      gst_ghost_pad_set_target (GST_GHOST_PAD_CAST (self->subtitle_sinkpad),
          NULL);

      /* Unblock pads */
      unblock_video (self);
      unblock_subtitle (self);

      /* Remove elements */
      self->silent_property = NULL;
      _remove_element (self, &self->post_colorspace);
      _remove_element (self, &self->overlay);
      _remove_element (self, &self->parser);
      _remove_element (self, &self->renderer);
      _remove_element (self, &self->pre_colorspace);
      _remove_element (self, &self->passthrough_identity);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);

      break;
    default:
      break;
  }

  return ret;
}

static void
gst_subtitle_overlay_handle_message (GstBin * bin, GstMessage * message)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY_CAST (bin);

  if (GST_MESSAGE_TYPE (message) == GST_MESSAGE_ERROR) {
    GstObject *src = GST_MESSAGE_SRC (message);

    /* Convert error messages from the subtitle pipeline to
     * warnings and switch to passthrough mode */
    if (src && (
            (self->overlay
                && gst_object_has_ancestor (src,
                    GST_OBJECT_CAST (self->overlay))) || (self->parser
                && gst_object_has_ancestor (src,
                    GST_OBJECT_CAST (self->parser))) || (self->renderer
                && gst_object_has_ancestor (src,
                    GST_OBJECT_CAST (self->renderer))))) {
      GError *err = NULL;
      gchar *debug = NULL;
      GstMessage *wmsg;

      gst_message_parse_error (message, &err, &debug);
      GST_DEBUG_OBJECT (self,
          "Got error message from subtitle element %s: %s (%s)",
          GST_MESSAGE_SRC_NAME (message), GST_STR_NULL (err->message),
          GST_STR_NULL (debug));

      wmsg = gst_message_new_warning (src, err, debug);
      gst_message_unref (message);
      g_error_free (err);
      g_free (debug);
      message = wmsg;

      GST_SUBTITLE_OVERLAY_LOCK (self);
      self->subtitle_error = TRUE;

      block_subtitle (self);
      block_video (self);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
    }
  }

  GST_BIN_CLASS (parent_class)->handle_message (bin, message);
}

static void
gst_subtitle_overlay_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY_CAST (object);

  switch (prop_id) {
    case PROP_SILENT:
      g_value_set_boolean (value, self->silent);
      break;
    case PROP_FONT_DESC:
      GST_SUBTITLE_OVERLAY_LOCK (self);
      g_value_set_string (value, self->font_desc);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
      break;
    case PROP_SUBTITLE_ENCODING:
      GST_SUBTITLE_OVERLAY_LOCK (self);
      g_value_set_string (value, self->encoding);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_subtitle_overlay_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY_CAST (object);

  switch (prop_id) {
    case PROP_SILENT:
      GST_SUBTITLE_OVERLAY_LOCK (self);
      self->silent = g_value_get_boolean (value);
      if (self->silent_property) {
        gboolean silent = self->silent;

        if (self->silent_property_invert)
          silent = !silent;

        if (self->overlay)
          g_object_set (self->overlay, self->silent_property, silent, NULL);
        else if (self->renderer)
          g_object_set (self->renderer, self->silent_property, silent, NULL);
      } else {
        block_subtitle (self);
        block_video (self);
      }
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
      break;
    case PROP_FONT_DESC:
      GST_SUBTITLE_OVERLAY_LOCK (self);
      g_free (self->font_desc);
      self->font_desc = g_value_dup_string (value);
      if (self->overlay
          && _has_property_with_type (G_OBJECT (self->overlay), "font-desc",
              G_TYPE_STRING))
        g_object_set (self->overlay, "font-desc", self->font_desc, NULL);
      else if (self->renderer
          && _has_property_with_type (G_OBJECT (self->renderer), "font-desc",
              G_TYPE_STRING))
        g_object_set (self->renderer, "font-desc", self->font_desc, NULL);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
      break;
    case PROP_SUBTITLE_ENCODING:
      GST_SUBTITLE_OVERLAY_LOCK (self);
      g_free (self->encoding);
      self->encoding = g_value_dup_string (value);
      if (self->renderer
          && _has_property_with_type (G_OBJECT (self->renderer),
              "subtitle-encoding", G_TYPE_STRING))
        g_object_set (self->renderer, "subtitle-encoding", self->encoding,
            NULL);
      if (self->parser
          && _has_property_with_type (G_OBJECT (self->parser),
              "subtitle-encoding", G_TYPE_STRING))
        g_object_set (self->parser, "subtitle-encoding", self->encoding, NULL);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_subtitle_overlay_class_init (GstSubtitleOverlayClass * klass)
{
  GObjectClass *gobject_class = (GObjectClass *) klass;
  GstElementClass *element_class = (GstElementClass *) klass;
  GstBinClass *bin_class = (GstBinClass *) klass;

  gobject_class->finalize = gst_subtitle_overlay_finalize;
  gobject_class->set_property = gst_subtitle_overlay_set_property;
  gobject_class->get_property = gst_subtitle_overlay_get_property;

  g_object_class_install_property (gobject_class, PROP_SILENT,
      g_param_spec_boolean ("silent",
          "Silent",
          "Whether to show subtitles", FALSE,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_FONT_DESC,
      g_param_spec_string ("font-desc",
          "Subtitle font description",
          "Pango font description of font "
          "to be used for subtitle rendering", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SUBTITLE_ENCODING,
      g_param_spec_string ("subtitle-encoding", "subtitle encoding",
          "Encoding to assume if input subtitles are not in UTF-8 encoding. "
          "If not set, the GST_SUBTITLE_ENCODING environment variable will "
          "be checked for an encoding to use. If that is not set either, "
          "ISO-8859-15 will be assumed.", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&srctemplate));

  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&video_sinktemplate));
  gst_element_class_add_pad_template (element_class,
      gst_static_pad_template_get (&subtitle_sinktemplate));

  gst_element_class_set_static_metadata (element_class, "Subtitle Overlay",
      "Video/Overlay/Subtitle",
      "Overlays a video stream with subtitles",
      "Sebastian Dröge <sebastian.droege@collabora.co.uk>");

  element_class->change_state =
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_change_state);

  bin_class->handle_message =
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_handle_message);
}

static GstFlowReturn
gst_subtitle_overlay_src_proxy_chain (GstPad * proxypad, GstObject * parent,
    GstBuffer * buffer)
{
  GstPad *ghostpad;
  GstSubtitleOverlay *self;
  GstFlowReturn ret;

  ghostpad = GST_PAD_CAST (parent);
  if (G_UNLIKELY (!ghostpad)) {
    gst_buffer_unref (buffer);
    return GST_FLOW_ERROR;
  }
  self = GST_SUBTITLE_OVERLAY_CAST (gst_pad_get_parent (ghostpad));
  if (G_UNLIKELY (!self || self->srcpad != ghostpad)) {
    gst_buffer_unref (buffer);
    gst_object_unref (ghostpad);
    return GST_FLOW_ERROR;
  }

  ret = gst_proxy_pad_chain_default (proxypad, parent, buffer);

  if (IS_VIDEO_CHAIN_IGNORE_ERROR (ret)) {
    GST_ERROR_OBJECT (self, "Downstream chain error: %s",
        gst_flow_get_name (ret));
    self->downstream_chain_error = TRUE;
  }

  gst_object_unref (self);

  return ret;
}

static gboolean
gst_subtitle_overlay_src_proxy_event (GstPad * proxypad, GstObject * parent,
    GstEvent * event)
{
  GstPad *ghostpad = NULL;
  GstSubtitleOverlay *self = NULL;
  gboolean ret = FALSE;
  const GstStructure *s;

  ghostpad = GST_PAD_CAST (parent);
  if (G_UNLIKELY (!ghostpad))
    goto out;
  self = GST_SUBTITLE_OVERLAY_CAST (gst_pad_get_parent (ghostpad));
  if (G_UNLIKELY (!self || self->srcpad != ghostpad))
    goto out;

  s = gst_event_get_structure (event);
  if (s && gst_structure_id_has_field (s, _subtitle_overlay_event_marker_id)) {
    GST_DEBUG_OBJECT (ghostpad,
        "Dropping event with marker: %" GST_PTR_FORMAT,
        gst_event_get_structure (event));
    gst_event_unref (event);
    event = NULL;
    ret = TRUE;
  } else {
    ret = gst_pad_event_default (proxypad, parent, event);
    event = NULL;
  }

out:
  if (event)
    gst_event_unref (event);
  if (self)
    gst_object_unref (self);

  return ret;
}

static gboolean
gst_subtitle_overlay_video_sink_setcaps (GstSubtitleOverlay * self,
    GstCaps * caps)
{
  GstPad *target;
  gboolean ret = TRUE;
  GstVideoInfo info;

  GST_DEBUG_OBJECT (self, "Setting caps: %" GST_PTR_FORMAT, caps);

  if (!gst_video_info_from_caps (&info, caps)) {
    GST_ERROR_OBJECT (self, "Failed to parse caps");
    ret = FALSE;
    GST_SUBTITLE_OVERLAY_UNLOCK (self);
    goto out;
  }

  target = gst_ghost_pad_get_target (GST_GHOST_PAD_CAST (self->video_sinkpad));

  GST_SUBTITLE_OVERLAY_LOCK (self);

  if (!target || !gst_pad_query_accept_caps (target, caps)) {
    GST_DEBUG_OBJECT (target, "Target did not accept caps -- reconfiguring");

    block_subtitle (self);
    block_video (self);
  }

  if (self->fps_n != info.fps_n || self->fps_d != info.fps_d) {
    GST_DEBUG_OBJECT (self, "New video fps: %d/%d", info.fps_n, info.fps_d);
    self->fps_n = info.fps_n;
    self->fps_d = info.fps_d;
    gst_subtitle_overlay_set_fps (self);
  }
  GST_SUBTITLE_OVERLAY_UNLOCK (self);

  if (target)
    gst_object_unref (target);

out:

  return ret;
}

static gboolean
gst_subtitle_overlay_video_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (parent);
  gboolean ret;

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      ret = gst_subtitle_overlay_video_sink_setcaps (self, caps);
      if (!ret)
        goto done;
      break;
    }
    default:
      break;
  }

  ret = gst_pad_event_default (pad, parent, gst_event_ref (event));

done:
  gst_event_unref (event);

  return ret;
}

static GstFlowReturn
gst_subtitle_overlay_video_sink_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (parent);
  GstFlowReturn ret = gst_proxy_pad_chain_default (pad, parent, buffer);

  if (G_UNLIKELY (self->downstream_chain_error) || self->passthrough_identity) {
    return ret;
  } else if (IS_VIDEO_CHAIN_IGNORE_ERROR (ret)) {
    GST_DEBUG_OBJECT (self, "Subtitle renderer produced chain error: %s",
        gst_flow_get_name (ret));
    GST_SUBTITLE_OVERLAY_LOCK (self);
    self->subtitle_error = TRUE;
    block_subtitle (self);
    block_video (self);
    GST_SUBTITLE_OVERLAY_UNLOCK (self);

    return GST_FLOW_OK;
  }

  return ret;
}

static GstFlowReturn
gst_subtitle_overlay_subtitle_sink_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (parent);

  if (self->subtitle_error) {
    gst_buffer_unref (buffer);
    return GST_FLOW_OK;
  } else {
    GstFlowReturn ret = gst_proxy_pad_chain_default (pad, parent, buffer);

    if (IS_SUBTITLE_CHAIN_IGNORE_ERROR (ret)) {
      GST_DEBUG_OBJECT (self, "Subtitle chain error: %s",
          gst_flow_get_name (ret));
      GST_SUBTITLE_OVERLAY_LOCK (self);
      self->subtitle_error = TRUE;
      block_subtitle (self);
      block_video (self);
      GST_SUBTITLE_OVERLAY_UNLOCK (self);

      return GST_FLOW_OK;
    }

    return ret;
  }
}

static GstCaps *
gst_subtitle_overlay_subtitle_sink_getcaps (GstPad * pad, GstCaps * filter)
{
  GstCaps *ret;

  if (filter)
    ret = gst_caps_ref (filter);
  else
    ret = gst_caps_new_any ();

  return ret;
}

static gboolean
gst_subtitle_overlay_subtitle_sink_setcaps (GstSubtitleOverlay * self,
    GstCaps * caps)
{
  gboolean ret = TRUE;
  GstPad *target = NULL;;

  GST_DEBUG_OBJECT (self, "Setting caps: %" GST_PTR_FORMAT, caps);

  target =
      gst_ghost_pad_get_target (GST_GHOST_PAD_CAST (self->subtitle_sinkpad));

  GST_SUBTITLE_OVERLAY_LOCK (self);
  gst_caps_replace (&self->subcaps, caps);

  if (target && gst_pad_query_accept_caps (target, caps)) {
    GST_DEBUG_OBJECT (self, "Target accepts caps");
    GST_SUBTITLE_OVERLAY_UNLOCK (self);
    goto out;
  }

  GST_DEBUG_OBJECT (self, "Target did not accept caps");

  self->subtitle_error = FALSE;
  block_subtitle (self);
  block_video (self);
  GST_SUBTITLE_OVERLAY_UNLOCK (self);

out:
  if (target)
    gst_object_unref (target);

  return ret;
}

static GstPadLinkReturn
gst_subtitle_overlay_subtitle_sink_link (GstPad * pad, GstObject * parent,
    GstPad * peer)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (parent);
  GstCaps *caps;

  GST_DEBUG_OBJECT (pad, "Linking pad to peer %" GST_PTR_FORMAT, peer);

  caps = gst_pad_get_current_caps (peer);
  if (!caps) {
    caps = gst_pad_query_caps (peer, NULL);
    if (!gst_caps_is_fixed (caps)) {
      gst_caps_unref (caps);
      caps = NULL;
    }
  }

  if (caps) {
    GST_SUBTITLE_OVERLAY_LOCK (self);
    GST_DEBUG_OBJECT (pad, "Have fixed peer caps: %" GST_PTR_FORMAT, caps);
    gst_caps_replace (&self->subcaps, caps);

    self->subtitle_error = FALSE;

    block_subtitle (self);
    block_video (self);
    GST_SUBTITLE_OVERLAY_UNLOCK (self);
    gst_caps_unref (caps);
  }

  return GST_PAD_LINK_OK;
}

static void
gst_subtitle_overlay_subtitle_sink_unlink (GstPad * pad, GstObject * parent)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (parent);

  /* FIXME: Can't use gst_pad_get_parent() here because this is called with
   * the object lock from state changes
   */

  GST_DEBUG_OBJECT (pad, "Pad unlinking");
  gst_caps_replace (&self->subcaps, NULL);

  GST_SUBTITLE_OVERLAY_LOCK (self);
  self->subtitle_error = FALSE;

  block_subtitle (self);
  block_video (self);
  GST_SUBTITLE_OVERLAY_UNLOCK (self);
}

static gboolean
gst_subtitle_overlay_subtitle_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event)
{
  GstSubtitleOverlay *self = GST_SUBTITLE_OVERLAY (parent);
  gboolean ret;

  GST_DEBUG_OBJECT (pad, "Got event %" GST_PTR_FORMAT, event);

  if (GST_EVENT_TYPE (event) == GST_EVENT_CUSTOM_DOWNSTREAM_OOB &&
      gst_event_has_name (event, "playsink-custom-subtitle-flush")) {
    GST_DEBUG_OBJECT (pad, "Custom subtitle flush event");
    GST_SUBTITLE_OVERLAY_LOCK (self);
    self->subtitle_flush = TRUE;
    self->subtitle_error = FALSE;
    block_subtitle (self);
    block_video (self);
    GST_SUBTITLE_OVERLAY_UNLOCK (self);

    gst_event_unref (event);
    event = NULL;
    ret = TRUE;
    goto out;
  }

  switch (GST_EVENT_TYPE (event)) {
    case GST_EVENT_CAPS:
    {
      GstCaps *caps;

      gst_event_parse_caps (event, &caps);
      ret = gst_subtitle_overlay_subtitle_sink_setcaps (self, caps);
      if (!ret)
        goto out;
      break;
    }
    case GST_EVENT_FLUSH_STOP:
    case GST_EVENT_FLUSH_START:
    case GST_EVENT_SEGMENT:
    case GST_EVENT_EOS:
    {
      GstStructure *structure;

      /* Add our event marker to make sure no events from here go ever outside
       * the element, they're only interesting for our internal elements */
      event = GST_EVENT_CAST (gst_event_make_writable (event));
      structure = gst_event_writable_structure (event);

      gst_structure_id_set (structure, _subtitle_overlay_event_marker_id,
          G_TYPE_BOOLEAN, TRUE, NULL);
      break;
    }
    default:
      break;
  }

  ret = gst_pad_event_default (pad, parent, gst_event_ref (event));

  gst_event_unref (event);

out:
  return ret;
}

static gboolean
gst_subtitle_overlay_subtitle_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query)
{
  gboolean ret;

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_ACCEPT_CAPS:
    {
      gst_query_set_accept_caps_result (query, TRUE);
      ret = TRUE;
      break;
    }
    case GST_QUERY_CAPS:
    {
      GstCaps *filter, *caps;

      gst_query_parse_caps (query, &filter);
      caps = gst_subtitle_overlay_subtitle_sink_getcaps (pad, filter);
      gst_query_set_caps_result (query, caps);
      gst_caps_unref (caps);
      ret = TRUE;
      break;
    }
    default:
      ret = gst_pad_query_default (pad, parent, query);
      break;
  }

  return ret;
}

static void
gst_subtitle_overlay_init (GstSubtitleOverlay * self)
{
  GstPadTemplate *templ;
  GstPad *proxypad = NULL;

  g_mutex_init (&self->lock);
  g_mutex_init (&self->factories_lock);

  templ = gst_static_pad_template_get (&srctemplate);
  self->srcpad = gst_ghost_pad_new_no_target_from_template ("src", templ);
  gst_object_unref (templ);

  proxypad =
      GST_PAD_CAST (gst_proxy_pad_get_internal (GST_PROXY_PAD (self->srcpad)));
  gst_pad_set_event_function (proxypad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_src_proxy_event));
  gst_pad_set_chain_function (proxypad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_src_proxy_chain));
  gst_object_unref (proxypad);

  gst_element_add_pad (GST_ELEMENT_CAST (self), self->srcpad);

  templ = gst_static_pad_template_get (&video_sinktemplate);
  self->video_sinkpad =
      gst_ghost_pad_new_no_target_from_template ("video_sink", templ);
  gst_object_unref (templ);
  gst_pad_set_event_function (self->video_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_video_sink_event));
  gst_pad_set_chain_function (self->video_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_video_sink_chain));

  proxypad =
      GST_PAD_CAST (gst_proxy_pad_get_internal (GST_PROXY_PAD
          (self->video_sinkpad)));
  self->video_block_pad = proxypad;
  gst_object_unref (proxypad);
  gst_element_add_pad (GST_ELEMENT_CAST (self), self->video_sinkpad);

  templ = gst_static_pad_template_get (&subtitle_sinktemplate);
  self->subtitle_sinkpad =
      gst_ghost_pad_new_no_target_from_template ("subtitle_sink", templ);
  gst_object_unref (templ);
  gst_pad_set_link_function (self->subtitle_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_subtitle_sink_link));
  gst_pad_set_unlink_function (self->subtitle_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_subtitle_sink_unlink));
  gst_pad_set_event_function (self->subtitle_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_subtitle_sink_event));
  gst_pad_set_query_function (self->subtitle_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_subtitle_sink_query));
  gst_pad_set_chain_function (self->subtitle_sinkpad,
      GST_DEBUG_FUNCPTR (gst_subtitle_overlay_subtitle_sink_chain));

  proxypad =
      GST_PAD_CAST (gst_proxy_pad_get_internal (GST_PROXY_PAD
          (self->subtitle_sinkpad)));
  self->subtitle_block_pad = proxypad;
  gst_object_unref (proxypad);

  gst_element_add_pad (GST_ELEMENT_CAST (self), self->subtitle_sinkpad);

  self->fps_n = 0;
  self->fps_d = 0;
}

gboolean
gst_subtitle_overlay_plugin_init (GstPlugin * plugin)
{
  GST_DEBUG_CATEGORY_INIT (subtitle_overlay_debug, "subtitleoverlay", 0,
      "Subtitle Overlay");

  _subtitle_overlay_event_marker_id =
      g_quark_from_static_string ("gst-subtitle-overlay-event-marker");

  return gst_element_register (plugin, "subtitleoverlay", GST_RANK_NONE,
      GST_TYPE_SUBTITLE_OVERLAY);
}
