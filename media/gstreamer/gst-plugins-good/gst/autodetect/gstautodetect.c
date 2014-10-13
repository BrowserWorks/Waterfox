/* GStreamer
 * (c) 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
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

#include <stdio.h>
#include <string.h>

#include <gst/gst.h>

#include "gstautodetect.h"
#include "gstautoaudiosink.h"
#include "gstautoaudiosrc.h"
#include "gstautovideosink.h"
#include "gstautovideosrc.h"

GST_DEBUG_CATEGORY (autodetect_debug);

#define DEFAULT_SYNC                TRUE

/* Properties */
enum
{
  PROP_0,
  PROP_CAPS,
  PROP_SYNC,
};

static GstStateChangeReturn gst_auto_detect_change_state (GstElement * element,
    GstStateChange transition);
static void gst_auto_detect_constructed (GObject * object);
static void gst_auto_detect_dispose (GObject * self);
static void gst_auto_detect_clear_kid (GstAutoDetect * self);
static void gst_auto_detect_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_auto_detect_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);

#define gst_auto_detect_parent_class parent_class
G_DEFINE_ABSTRACT_TYPE (GstAutoDetect, gst_auto_detect, GST_TYPE_BIN);

static void
gst_auto_detect_class_init (GstAutoDetectClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *eklass;

  gobject_class = G_OBJECT_CLASS (klass);
  eklass = GST_ELEMENT_CLASS (klass);

  gobject_class->constructed = gst_auto_detect_constructed;
  gobject_class->dispose = gst_auto_detect_dispose;
  gobject_class->set_property = gst_auto_detect_set_property;
  gobject_class->get_property = gst_auto_detect_get_property;

  eklass->change_state = GST_DEBUG_FUNCPTR (gst_auto_detect_change_state);

  /**
   * GstAutoDetect:filter-caps:
   *
   * This property will filter out candidate sinks that can handle the specified
   * caps. By default only elements that support uncompressed data are selected.
   *
   * This property can only be set before the element goes to the READY state.
   */
  g_object_class_install_property (gobject_class, PROP_CAPS,
      g_param_spec_boxed ("filter-caps", "Filter caps",
          "Filter sink candidates using these caps.", GST_TYPE_CAPS,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  g_object_class_install_property (gobject_class, PROP_SYNC,
      g_param_spec_boolean ("sync", "Sync",
          "Sync on the clock", DEFAULT_SYNC,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
}

static void
gst_auto_detect_dispose (GObject * object)
{
  GstAutoDetect *self = GST_AUTO_DETECT (object);

  gst_auto_detect_clear_kid (self);

  if (self->filter_caps)
    gst_caps_unref (self->filter_caps);
  self->filter_caps = NULL;

  G_OBJECT_CLASS (parent_class)->dispose ((GObject *) self);
}

static void
gst_auto_detect_clear_kid (GstAutoDetect * self)
{
  if (self->kid) {
    gst_element_set_state (self->kid, GST_STATE_NULL);
    gst_bin_remove (GST_BIN (self), self->kid);
    self->kid = NULL;
    /* Don't lose the element type flag */
    GST_OBJECT_FLAG_SET (self, self->flag);
  }
}

static GstElement *
gst_auto_detect_create_fake_element_default (GstAutoDetect * self)
{
  GstElement *fake;
  gchar dummy_factory[10], dummy_name[20];

  sprintf (dummy_factory, "fake%s", self->type_klass_lc);
  sprintf (dummy_name, "fake-%s-%s", self->media_klass_lc, self->type_klass_lc);
  fake = gst_element_factory_make (dummy_factory, dummy_name);
  g_object_set (fake, "sync", self->sync, NULL);

  return fake;
}

static GstElement *
gst_auto_detect_create_fake_element (GstAutoDetect * self)
{
  GstAutoDetectClass *klass = GST_AUTO_DETECT_GET_CLASS (self);
  GstElement *fake;

  if (klass->create_fake_element)
    fake = klass->create_fake_element (self);
  else
    fake = gst_auto_detect_create_fake_element_default (self);

  return fake;
}

static gboolean
gst_auto_detect_attach_ghost_pad (GstAutoDetect * self)
{
  GstPad *target = gst_element_get_static_pad (self->kid, self->type_klass_lc);
  gboolean res = gst_ghost_pad_set_target (GST_GHOST_PAD (self->pad), target);
  gst_object_unref (target);

  return res;
}

/* Hack to make initial linking work; ideally, this'd work even when
 * no target has been assigned to the ghostpad yet. */
static void
gst_auto_detect_reset (GstAutoDetect * self)
{
  gst_auto_detect_clear_kid (self);

  /* placeholder element */
  self->kid = gst_auto_detect_create_fake_element (self);
  gst_bin_add (GST_BIN (self), self->kid);

  gst_auto_detect_attach_ghost_pad (self);
}

static GstStaticCaps raw_audio_caps = GST_STATIC_CAPS ("audio/x-raw");
static GstStaticCaps raw_video_caps = GST_STATIC_CAPS ("video/x-raw");

static void
gst_auto_detect_init (GstAutoDetect * self)
{
  self->sync = DEFAULT_SYNC;
}

static void
gst_auto_detect_constructed (GObject * object)
{
  GstAutoDetect *self = GST_AUTO_DETECT (object);
  gboolean is_audio;

  if (G_OBJECT_CLASS (parent_class)->constructed)
    G_OBJECT_CLASS (parent_class)->constructed (object);

  is_audio = !g_strcmp0 (self->media_klass, "Audio");
  self->type_klass = (self->flag == GST_ELEMENT_FLAG_SINK) ? "Sink" : "Source";
  self->type_klass_lc = (self->flag == GST_ELEMENT_FLAG_SINK) ? "sink" : "src";
  self->media_klass_lc = is_audio ? "audio" : "video";
  /* set the default raw caps */
  self->filter_caps = gst_static_caps_get (is_audio ? &raw_audio_caps :
      &raw_video_caps);

  self->pad = gst_ghost_pad_new_no_target (self->type_klass_lc,
      (self->flag == GST_ELEMENT_FLAG_SINK) ? GST_PAD_SINK : GST_PAD_SRC);
  gst_element_add_pad (GST_ELEMENT (self), self->pad);

  gst_auto_detect_reset (self);

  /* mark element type */
  GST_OBJECT_FLAG_SET (self, self->flag);
}

static gboolean
gst_auto_detect_factory_filter (GstPluginFeature * feature, gpointer data)
{
  GstAutoDetect *self = (GstAutoDetect *) data;
  guint rank;
  const gchar *klass;

  /* we only care about element factories */
  if (!GST_IS_ELEMENT_FACTORY (feature))
    return FALSE;

  /* audio sinks */
  klass = gst_element_factory_get_metadata (GST_ELEMENT_FACTORY (feature),
      GST_ELEMENT_METADATA_KLASS);
  if (!(strstr (klass, self->type_klass) && strstr (klass, self->media_klass)))
    return FALSE;

  /* only select elements with autoplugging rank */
  rank = gst_plugin_feature_get_rank (feature);
  if (rank < GST_RANK_MARGINAL)
    return FALSE;

  return TRUE;
}

static GstElement *
create_element_with_pretty_name (GstAutoDetect * self,
    GstElementFactory * factory)
{
  GstElement *element;
  gchar *name, *marker;

  marker = g_strdup (GST_OBJECT_NAME (factory));
  if (g_str_has_suffix (marker, self->type_klass_lc))
    marker[strlen (marker) - 4] = '\0';
  if (g_str_has_prefix (marker, "gst"))
    memmove (marker, marker + 3, strlen (marker + 3) + 1);
  name = g_strdup_printf ("%s-actual-%s-%s", GST_OBJECT_NAME (self),
      self->type_klass_lc, marker);
  g_free (marker);

  element = gst_element_factory_create (factory, name);
  g_free (name);

  return element;
}

static GstElement *
gst_auto_detect_find_best (GstAutoDetect * self)
{
  GList *list, *item;
  GstElement *choice = NULL;
  GstMessage *message = NULL;
  GSList *errors = NULL;
  GstBus *bus = gst_bus_new ();
  GstPad *el_pad = NULL;
  GstCaps *el_caps = NULL;
  gboolean no_match = TRUE;

  /* We don't treat sound server sinks special. Our policy is that sound
   * server sinks that have a rank must not auto-spawn a daemon under any
   * circumstances, so there's nothing for us to worry about here */
  list = gst_registry_feature_filter (gst_registry_get (),
      (GstPluginFeatureFilter) gst_auto_detect_factory_filter, FALSE, self);
  list =
      g_list_sort (list, (GCompareFunc) gst_plugin_feature_rank_compare_func);

  GST_LOG_OBJECT (self, "Trying to find usable %s elements ...",
      self->media_klass_lc);

  for (item = list; item != NULL; item = item->next) {
    GstElementFactory *f = GST_ELEMENT_FACTORY (item->data);
    GstElement *el;

    if ((el = create_element_with_pretty_name (self, f))) {
      GstStateChangeReturn ret;

      GST_DEBUG_OBJECT (self, "Testing %s", GST_OBJECT_NAME (f));

      /* If autodetect has been provided with filter caps,
       * accept only elements that match with the filter caps */
      if (self->filter_caps) {
        el_pad = gst_element_get_static_pad (el, self->type_klass_lc);
        el_caps = gst_pad_query_caps (el_pad, NULL);
        gst_object_unref (el_pad);
        GST_DEBUG_OBJECT (self,
            "Checking caps: %" GST_PTR_FORMAT " vs. %" GST_PTR_FORMAT,
            self->filter_caps, el_caps);
        no_match = !gst_caps_can_intersect (self->filter_caps, el_caps);
        gst_caps_unref (el_caps);

        if (no_match) {
          GST_DEBUG_OBJECT (self, "Incompatible caps");
          gst_object_unref (el);
          continue;
        } else {
          GST_DEBUG_OBJECT (self, "Found compatible caps");
        }
      }

      gst_element_set_bus (el, bus);
      ret = gst_element_set_state (el, GST_STATE_READY);
      if (ret == GST_STATE_CHANGE_SUCCESS) {
        GST_DEBUG_OBJECT (self, "This worked!");
        choice = el;
        break;
      }

      /* collect all error messages */
      while ((message = gst_bus_pop_filtered (bus, GST_MESSAGE_ERROR))) {
        GST_DEBUG_OBJECT (self, "error message %" GST_PTR_FORMAT, message);
        errors = g_slist_append (errors, message);
      }

      gst_element_set_state (el, GST_STATE_NULL);
      gst_object_unref (el);
    }
  }

  GST_DEBUG_OBJECT (self, "done trying");
  if (!choice) {
    /* We post a warning and plug a fake-element. This is convenient for running
     * tests without requiring hardware src/sinks. */
    if (errors) {
      GError *err = NULL;
      gchar *dbg = NULL;

      /* FIXME: we forward the first message for now; but later on it might make
       * sense to forward all so that apps can actually analyse them. */
      gst_message_parse_error (GST_MESSAGE (errors->data), &err, &dbg);
      gst_element_post_message (GST_ELEMENT_CAST (self),
          gst_message_new_warning (GST_OBJECT_CAST (self), err, dbg));
      g_error_free (err);
      g_free (dbg);
    } else {
      /* send warning message to application and use a fakesrc */
      GST_ELEMENT_WARNING (self, RESOURCE, NOT_FOUND, (NULL),
          ("Failed to find a usable %s %s", self->media_klass_lc,
              self->type_klass_lc));
    }
    choice = gst_auto_detect_create_fake_element (self);
    gst_element_set_state (choice, GST_STATE_READY);
  }
  gst_object_unref (bus);
  gst_plugin_feature_list_free (list);
  g_slist_foreach (errors, (GFunc) gst_mini_object_unref, NULL);
  g_slist_free (errors);

  return choice;
}

static gboolean
gst_auto_detect_detect (GstAutoDetect * self)
{
  GstElement *kid;
  GstAutoDetectClass *klass = GST_AUTO_DETECT_GET_CLASS (self);

  gst_auto_detect_clear_kid (self);

  /* find element */
  GST_DEBUG_OBJECT (self, "Creating new kid");
  if (!(kid = gst_auto_detect_find_best (self)))
    goto no_sink;

  self->has_sync =
      g_object_class_find_property (G_OBJECT_GET_CLASS (kid), "sync") != NULL;
  if (self->has_sync)
    g_object_set (G_OBJECT (kid), "sync", self->sync, NULL);
  if (klass->configure) {
    klass->configure (self, kid);
  }

  self->kid = kid;
  /* Ensure the child is brought up to the right state to match the parent.
   * Although it's currently always in READY and we're always doing NULL->READY.
   */
  if (GST_STATE (self->kid) < GST_STATE (self))
    gst_element_set_state (self->kid, GST_STATE (self));

  gst_bin_add (GST_BIN (self), kid);

  /* attach ghost pad */
  GST_DEBUG_OBJECT (self, "Re-assigning ghostpad");
  if (!gst_auto_detect_attach_ghost_pad (self))
    goto target_failed;

  GST_DEBUG_OBJECT (self, "done changing auto %s %s", self->media_klass_lc,
      self->type_klass_lc);

  return TRUE;

  /* ERRORS */
no_sink:
  {
    GST_ELEMENT_ERROR (self, LIBRARY, INIT, (NULL),
        ("Failed to find a supported audio sink"));
    return FALSE;
  }
target_failed:
  {
    GST_ELEMENT_ERROR (self, LIBRARY, INIT, (NULL),
        ("Failed to set target pad"));
    return FALSE;
  }
}

static GstStateChangeReturn
gst_auto_detect_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
  GstAutoDetect *sink = GST_AUTO_DETECT (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      if (!gst_auto_detect_detect (sink))
        return GST_STATE_CHANGE_FAILURE;
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);
  if (ret == GST_STATE_CHANGE_FAILURE)
    return ret;

  switch (transition) {
    case GST_STATE_CHANGE_READY_TO_NULL:
      gst_auto_detect_reset (sink);
      break;
    default:
      break;
  }

  return ret;
}

static void
gst_auto_detect_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstAutoDetect *self = GST_AUTO_DETECT (object);

  switch (prop_id) {
    case PROP_CAPS:
      if (self->filter_caps)
        gst_caps_unref (self->filter_caps);
      self->filter_caps = gst_caps_copy (gst_value_get_caps (value));
      break;
    case PROP_SYNC:
      self->sync = g_value_get_boolean (value);
      if (self->kid && self->has_sync)
        g_object_set_property (G_OBJECT (self->kid), pspec->name, value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_auto_detect_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec)
{
  GstAutoDetect *self = GST_AUTO_DETECT (object);

  switch (prop_id) {
    case PROP_CAPS:
      gst_value_set_caps (value, self->filter_caps);
      break;
    case PROP_SYNC:
      g_value_set_boolean (value, self->sync);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static gboolean
plugin_init (GstPlugin * plugin)
{
  GST_DEBUG_CATEGORY_INIT (autodetect_debug, "autodetect", 0,
      "Autodetection audio/video output wrapper elements");

  return gst_element_register (plugin, "autovideosink",
      GST_RANK_NONE, GST_TYPE_AUTO_VIDEO_SINK) &&
      gst_element_register (plugin, "autovideosrc",
      GST_RANK_NONE, GST_TYPE_AUTO_VIDEO_SRC) &&
      gst_element_register (plugin, "autoaudiosink",
      GST_RANK_NONE, GST_TYPE_AUTO_AUDIO_SINK) &&
      gst_element_register (plugin, "autoaudiosrc",
      GST_RANK_NONE, GST_TYPE_AUTO_AUDIO_SRC);
}

GST_PLUGIN_DEFINE (GST_VERSION_MAJOR,
    GST_VERSION_MINOR,
    autodetect,
    "Plugin contains auto-detection plugins for video/audio in- and outputs",
    plugin_init, VERSION, GST_LICENSE, GST_PACKAGE_NAME, GST_PACKAGE_ORIGIN)
