/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *               2000,2001,2002,2003,2004,2005 Wim Taymans <wim@fluendo.com>
 *               2007 Wim Taymans <wim.taymans@gmail.com>
 *
 * gsttee.c: Tee element, one in N out
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
 * SECTION:element-tee
 * @see_also: #GstIdentity
 *
 * Split data to multiple pads. Branching the data flow is useful when e.g.
 * capturing a video where the video is shown on the screen and also encoded and
 * written to a file. Another example is playing music and hooking up a
 * visualisation module.
 *
 * One needs to use separate queue elements (or a multiqueue) in each branch to
 * provide separate threads for each branch. Otherwise a blocked dataflow in one
 * branch would stall the other branches.
 *
 * <refsect2>
 * <title>Example launch line</title>
 * |[
 * gst-launch filesrc location=song.ogg ! decodebin ! tee name=t ! queue ! autoaudiosink t. ! queue ! audioconvert ! goom ! videoconvert ! autovideosink
 * ]| Play a song.ogg from local dir and render visualisations using the goom
 * element.
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "gsttee.h"
#include "gst/glib-compat-private.h"

#include <string.h>
#include <stdio.h>

static GstStaticPadTemplate sinktemplate = GST_STATIC_PAD_TEMPLATE ("sink",
    GST_PAD_SINK,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS_ANY);

GST_DEBUG_CATEGORY_STATIC (gst_tee_debug);
#define GST_CAT_DEFAULT gst_tee_debug

#define GST_TYPE_TEE_PULL_MODE (gst_tee_pull_mode_get_type())
static GType
gst_tee_pull_mode_get_type (void)
{
  static GType type = 0;
  static const GEnumValue data[] = {
    {GST_TEE_PULL_MODE_NEVER, "Never activate in pull mode", "never"},
    {GST_TEE_PULL_MODE_SINGLE, "Only one src pad can be active in pull mode",
        "single"},
    {0, NULL, NULL},
  };

  if (!type) {
    type = g_enum_register_static ("GstTeePullMode", data);
  }
  return type;
}

#define DEFAULT_PROP_NUM_SRC_PADS	0
#define DEFAULT_PROP_HAS_CHAIN		TRUE
#define DEFAULT_PROP_SILENT		TRUE
#define DEFAULT_PROP_LAST_MESSAGE	NULL
#define DEFAULT_PULL_MODE		GST_TEE_PULL_MODE_NEVER

enum
{
  PROP_0,
  PROP_NUM_SRC_PADS,
  PROP_HAS_CHAIN,
  PROP_SILENT,
  PROP_LAST_MESSAGE,
  PROP_PULL_MODE,
  PROP_ALLOC_PAD,
};

static GstStaticPadTemplate tee_src_template =
GST_STATIC_PAD_TEMPLATE ("src_%u",
    GST_PAD_SRC,
    GST_PAD_REQUEST,
    GST_STATIC_CAPS_ANY);

#define _do_init \
    GST_DEBUG_CATEGORY_INIT (gst_tee_debug, "tee", 0, "tee element");
#define gst_tee_parent_class parent_class
G_DEFINE_TYPE_WITH_CODE (GstTee, gst_tee, GST_TYPE_ELEMENT, _do_init);

static GParamSpec *pspec_last_message = NULL;
static GParamSpec *pspec_alloc_pad = NULL;

GType gst_tee_pad_get_type (void);

#define GST_TYPE_TEE_PAD \
  (gst_tee_pad_get_type())
#define GST_TEE_PAD(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_TYPE_TEE_PAD, GstTeePad))
#define GST_TEE_PAD_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_CAST ((klass), GST_TYPE_TEE_PAD, GstTeePadClass))
#define GST_IS_TEE_PAD(obj) \
  (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_TYPE_TEE_PAD))
#define GST_IS_TEE_PAD_CLASS(klass) \
  (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_TYPE_TEE_PAD))
#define GST_TEE_PAD_CAST(obj) \
  ((GstTeePad *)(obj))

typedef struct _GstTeePad GstTeePad;
typedef struct _GstTeePadClass GstTeePadClass;

struct _GstTeePad
{
  GstPad parent;

  guint index;
  gboolean pushed;
  GstFlowReturn result;
  gboolean removed;
};

struct _GstTeePadClass
{
  GstPadClass parent;
};

G_DEFINE_TYPE (GstTeePad, gst_tee_pad, GST_TYPE_PAD);

static void
gst_tee_pad_class_init (GstTeePadClass * klass)
{
}

static void
gst_tee_pad_reset (GstTeePad * pad)
{
  pad->pushed = FALSE;
  pad->result = GST_FLOW_NOT_LINKED;
  pad->removed = FALSE;
}

static void
gst_tee_pad_init (GstTeePad * pad)
{
  gst_tee_pad_reset (pad);
}

static GstPad *gst_tee_request_new_pad (GstElement * element,
    GstPadTemplate * temp, const gchar * unused, const GstCaps * caps);
static void gst_tee_release_pad (GstElement * element, GstPad * pad);

static void gst_tee_finalize (GObject * object);
static void gst_tee_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static void gst_tee_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_tee_dispose (GObject * object);

static GstFlowReturn gst_tee_chain (GstPad * pad, GstObject * parent,
    GstBuffer * buffer);
static GstFlowReturn gst_tee_chain_list (GstPad * pad, GstObject * parent,
    GstBufferList * list);
static gboolean gst_tee_sink_event (GstPad * pad, GstObject * parent,
    GstEvent * event);
static gboolean gst_tee_sink_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gboolean gst_tee_sink_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);
static gboolean gst_tee_src_query (GstPad * pad, GstObject * parent,
    GstQuery * query);
static gboolean gst_tee_src_activate_mode (GstPad * pad, GstObject * parent,
    GstPadMode mode, gboolean active);
static GstFlowReturn gst_tee_src_get_range (GstPad * pad, GstObject * parent,
    guint64 offset, guint length, GstBuffer ** buf);

static void
gst_tee_dispose (GObject * object)
{
  GList *item;

restart:
  for (item = GST_ELEMENT_PADS (object); item; item = g_list_next (item)) {
    GstPad *pad = GST_PAD (item->data);
    if (GST_PAD_IS_SRC (pad)) {
      gst_element_release_request_pad (GST_ELEMENT (object), pad);
      goto restart;
    }
  }

  G_OBJECT_CLASS (parent_class)->dispose (object);
}

static void
gst_tee_finalize (GObject * object)
{
  GstTee *tee;

  tee = GST_TEE (object);

  g_hash_table_unref (tee->pad_indexes);

  g_free (tee->last_message);

  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_tee_class_init (GstTeeClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = G_OBJECT_CLASS (klass);
  gstelement_class = GST_ELEMENT_CLASS (klass);

  gobject_class->finalize = gst_tee_finalize;
  gobject_class->set_property = gst_tee_set_property;
  gobject_class->get_property = gst_tee_get_property;
  gobject_class->dispose = gst_tee_dispose;

  g_object_class_install_property (gobject_class, PROP_NUM_SRC_PADS,
      g_param_spec_int ("num-src-pads", "Num Src Pads",
          "The number of source pads", 0, G_MAXINT, DEFAULT_PROP_NUM_SRC_PADS,
          G_PARAM_READABLE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_HAS_CHAIN,
      g_param_spec_boolean ("has-chain", "Has Chain",
          "If the element can operate in push mode", DEFAULT_PROP_HAS_CHAIN,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_SILENT,
      g_param_spec_boolean ("silent", "Silent",
          "Don't produce last_message events", DEFAULT_PROP_SILENT,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  pspec_last_message = g_param_spec_string ("last-message", "Last Message",
      "The message describing current status", DEFAULT_PROP_LAST_MESSAGE,
      G_PARAM_READABLE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (gobject_class, PROP_LAST_MESSAGE,
      pspec_last_message);
  g_object_class_install_property (gobject_class, PROP_PULL_MODE,
      g_param_spec_enum ("pull-mode", "Pull mode",
          "Behavior of tee in pull mode", GST_TYPE_TEE_PULL_MODE,
          DEFAULT_PULL_MODE,
          G_PARAM_CONSTRUCT | G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  pspec_alloc_pad = g_param_spec_object ("alloc-pad", "Allocation Src Pad",
      "The pad ALLOCATION queries will be proxied to (unused)", GST_TYPE_PAD,
      G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS);
  g_object_class_install_property (gobject_class, PROP_ALLOC_PAD,
      pspec_alloc_pad);

  gst_element_class_set_static_metadata (gstelement_class,
      "Tee pipe fitting",
      "Generic",
      "1-to-N pipe fitting",
      "Erik Walthinsen <omega@cse.ogi.edu>, " "Wim Taymans <wim@fluendo.com>");
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&sinktemplate));
  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&tee_src_template));

  gstelement_class->request_new_pad =
      GST_DEBUG_FUNCPTR (gst_tee_request_new_pad);
  gstelement_class->release_pad = GST_DEBUG_FUNCPTR (gst_tee_release_pad);
}

static void
gst_tee_init (GstTee * tee)
{
  tee->sinkpad = gst_pad_new_from_static_template (&sinktemplate, "sink");
  tee->sink_mode = GST_PAD_MODE_NONE;

  gst_pad_set_event_function (tee->sinkpad,
      GST_DEBUG_FUNCPTR (gst_tee_sink_event));
  gst_pad_set_query_function (tee->sinkpad,
      GST_DEBUG_FUNCPTR (gst_tee_sink_query));
  gst_pad_set_activatemode_function (tee->sinkpad,
      GST_DEBUG_FUNCPTR (gst_tee_sink_activate_mode));
  gst_pad_set_chain_function (tee->sinkpad, GST_DEBUG_FUNCPTR (gst_tee_chain));
  gst_pad_set_chain_list_function (tee->sinkpad,
      GST_DEBUG_FUNCPTR (gst_tee_chain_list));
  GST_OBJECT_FLAG_SET (tee->sinkpad, GST_PAD_FLAG_PROXY_CAPS);
  gst_element_add_pad (GST_ELEMENT (tee), tee->sinkpad);

  tee->pad_indexes = g_hash_table_new (NULL, NULL);

  tee->last_message = NULL;
}

static void
gst_tee_notify_alloc_pad (GstTee * tee)
{
  g_object_notify_by_pspec ((GObject *) tee, pspec_alloc_pad);
}

static gboolean
forward_sticky_events (GstPad * pad, GstEvent ** event, gpointer user_data)
{
  GstPad *srcpad = GST_PAD_CAST (user_data);
  GstFlowReturn ret;

  ret = gst_pad_store_sticky_event (srcpad, *event);
  if (ret != GST_FLOW_OK) {
    GST_DEBUG_OBJECT (srcpad, "storing sticky event %p (%s) failed: %s", *event,
        GST_EVENT_TYPE_NAME (*event), gst_flow_get_name (ret));
  }

  return TRUE;
}

static GstPad *
gst_tee_request_new_pad (GstElement * element, GstPadTemplate * templ,
    const gchar * name_templ, const GstCaps * caps)
{
  gchar *name;
  GstPad *srcpad;
  GstTee *tee;
  GstPadMode mode;
  gboolean res;
  guint index = 0;

  tee = GST_TEE (element);

  GST_DEBUG_OBJECT (tee, "requesting pad");

  GST_OBJECT_LOCK (tee);

  if (name_templ) {
    sscanf (name_templ, "src_%u", &index);
    GST_LOG_OBJECT (element, "name: %s (index %d)", name_templ, index);
    if (g_hash_table_contains (tee->pad_indexes, GUINT_TO_POINTER (index))) {
      GST_ERROR_OBJECT (element, "pad name %s is not unique", name_templ);
      GST_OBJECT_UNLOCK (tee);
      return NULL;
    }
    if (index >= tee->next_pad_index)
      tee->next_pad_index = index + 1;
  } else {
    index = tee->next_pad_index;

    while (g_hash_table_contains (tee->pad_indexes, GUINT_TO_POINTER (index)))
      index++;

    tee->next_pad_index = index + 1;
  }

  g_hash_table_insert (tee->pad_indexes, GUINT_TO_POINTER (index), NULL);

  name = g_strdup_printf ("src_%u", index);

  srcpad = GST_PAD_CAST (g_object_new (GST_TYPE_TEE_PAD,
          "name", name, "direction", templ->direction, "template", templ,
          NULL));
  GST_TEE_PAD_CAST (srcpad)->index = index;
  g_free (name);

  mode = tee->sink_mode;

  GST_OBJECT_UNLOCK (tee);

  switch (mode) {
    case GST_PAD_MODE_PULL:
      /* we already have a src pad in pull mode, and our pull mode can only be
         SINGLE, so fall through to activate this new pad in push mode */
    case GST_PAD_MODE_PUSH:
      res = gst_pad_activate_mode (srcpad, GST_PAD_MODE_PUSH, TRUE);
      break;
    default:
      res = TRUE;
      break;
  }

  if (!res)
    goto activate_failed;

  gst_pad_set_activatemode_function (srcpad,
      GST_DEBUG_FUNCPTR (gst_tee_src_activate_mode));
  gst_pad_set_query_function (srcpad, GST_DEBUG_FUNCPTR (gst_tee_src_query));
  gst_pad_set_getrange_function (srcpad,
      GST_DEBUG_FUNCPTR (gst_tee_src_get_range));
  /* Forward sticky events to the new srcpad */
  gst_pad_sticky_events_foreach (tee->sinkpad, forward_sticky_events, srcpad);
  GST_OBJECT_FLAG_SET (srcpad, GST_PAD_FLAG_PROXY_CAPS);
  gst_element_add_pad (GST_ELEMENT_CAST (tee), srcpad);

  return srcpad;

  /* ERRORS */
activate_failed:
  {
    gboolean changed = FALSE;

    GST_OBJECT_LOCK (tee);
    GST_DEBUG_OBJECT (tee, "warning failed to activate request pad");
    if (tee->allocpad == srcpad) {
      tee->allocpad = NULL;
      changed = TRUE;
    }
    GST_OBJECT_UNLOCK (tee);
    gst_object_unref (srcpad);
    if (changed) {
      gst_tee_notify_alloc_pad (tee);
    }
    return NULL;
  }
}

static void
gst_tee_release_pad (GstElement * element, GstPad * pad)
{
  GstTee *tee;
  gboolean changed = FALSE;
  guint index;

  tee = GST_TEE (element);

  GST_DEBUG_OBJECT (tee, "releasing pad");

  GST_OBJECT_LOCK (tee);
  index = GST_TEE_PAD_CAST (pad)->index;
  /* mark the pad as removed so that future pad_alloc fails with NOT_LINKED. */
  GST_TEE_PAD_CAST (pad)->removed = TRUE;
  if (tee->allocpad == pad) {
    tee->allocpad = NULL;
    changed = TRUE;
  }
  GST_OBJECT_UNLOCK (tee);

  gst_object_ref (pad);
  gst_element_remove_pad (GST_ELEMENT_CAST (tee), pad);

  gst_pad_set_active (pad, FALSE);

  gst_object_unref (pad);

  if (changed) {
    gst_tee_notify_alloc_pad (tee);
  }

  GST_OBJECT_LOCK (tee);
  g_hash_table_remove (tee->pad_indexes, GUINT_TO_POINTER (index));
  GST_OBJECT_UNLOCK (tee);
}

static void
gst_tee_set_property (GObject * object, guint prop_id, const GValue * value,
    GParamSpec * pspec)
{
  GstTee *tee = GST_TEE (object);

  GST_OBJECT_LOCK (tee);
  switch (prop_id) {
    case PROP_HAS_CHAIN:
      tee->has_chain = g_value_get_boolean (value);
      break;
    case PROP_SILENT:
      tee->silent = g_value_get_boolean (value);
      break;
    case PROP_PULL_MODE:
      tee->pull_mode = (GstTeePullMode) g_value_get_enum (value);
      break;
    case PROP_ALLOC_PAD:
    {
      GstPad *pad = g_value_get_object (value);
      GST_OBJECT_LOCK (pad);
      if (GST_OBJECT_PARENT (pad) == GST_OBJECT_CAST (object))
        tee->allocpad = pad;
      else
        GST_WARNING_OBJECT (object, "Tried to set alloc pad %s which"
            " is not my pad", GST_OBJECT_NAME (pad));
      GST_OBJECT_UNLOCK (pad);
      break;
    }
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  GST_OBJECT_UNLOCK (tee);
}

static void
gst_tee_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstTee *tee = GST_TEE (object);

  GST_OBJECT_LOCK (tee);
  switch (prop_id) {
    case PROP_NUM_SRC_PADS:
      g_value_set_int (value, GST_ELEMENT (tee)->numsrcpads);
      break;
    case PROP_HAS_CHAIN:
      g_value_set_boolean (value, tee->has_chain);
      break;
    case PROP_SILENT:
      g_value_set_boolean (value, tee->silent);
      break;
    case PROP_LAST_MESSAGE:
      g_value_set_string (value, tee->last_message);
      break;
    case PROP_PULL_MODE:
      g_value_set_enum (value, tee->pull_mode);
      break;
    case PROP_ALLOC_PAD:
      g_value_set_object (value, tee->allocpad);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  GST_OBJECT_UNLOCK (tee);
}

static gboolean
gst_tee_sink_event (GstPad * pad, GstObject * parent, GstEvent * event)
{
  gboolean res;

  switch (GST_EVENT_TYPE (event)) {
    default:
      res = gst_pad_event_default (pad, parent, event);
      break;
  }

  return res;
}

static gboolean
gst_tee_sink_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  gboolean res;

  switch (GST_QUERY_TYPE (query)) {
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }
  return res;
}

static void
gst_tee_do_message (GstTee * tee, GstPad * pad, gpointer data, gboolean is_list)
{
  GST_OBJECT_LOCK (tee);
  g_free (tee->last_message);
  if (is_list) {
    tee->last_message =
        g_strdup_printf ("chain-list   ******* (%s:%s)t %p",
        GST_DEBUG_PAD_NAME (pad), data);
  } else {
    tee->last_message =
        g_strdup_printf ("chain        ******* (%s:%s)t (%" G_GSIZE_FORMAT
        " bytes, %" G_GUINT64_FORMAT ") %p", GST_DEBUG_PAD_NAME (pad),
        gst_buffer_get_size (data), GST_BUFFER_TIMESTAMP (data), data);
  }
  GST_OBJECT_UNLOCK (tee);

  g_object_notify_by_pspec ((GObject *) tee, pspec_last_message);
}

static GstFlowReturn
gst_tee_do_push (GstTee * tee, GstPad * pad, gpointer data, gboolean is_list)
{
  GstFlowReturn res;

  /* Push */
  if (pad == tee->pull_pad) {
    /* don't push on the pad we're pulling from */
    res = GST_FLOW_OK;
  } else if (is_list) {
    res =
        gst_pad_push_list (pad,
        gst_buffer_list_ref (GST_BUFFER_LIST_CAST (data)));
  } else {
    res = gst_pad_push (pad, gst_buffer_ref (GST_BUFFER_CAST (data)));
  }
  return res;
}

static void
clear_pads (GstPad * pad, GstTee * tee)
{
  GST_TEE_PAD_CAST (pad)->pushed = FALSE;
  GST_TEE_PAD_CAST (pad)->result = GST_FLOW_NOT_LINKED;
}

static GstFlowReturn
gst_tee_handle_data (GstTee * tee, gpointer data, gboolean is_list)
{
  GList *pads;
  guint32 cookie;
  GstFlowReturn ret, cret;

  if (G_UNLIKELY (!tee->silent))
    gst_tee_do_message (tee, tee->sinkpad, data, is_list);

  GST_OBJECT_LOCK (tee);
  pads = GST_ELEMENT_CAST (tee)->srcpads;

  /* special case for zero pads */
  if (G_UNLIKELY (!pads))
    goto no_pads;

  /* special case for just one pad that avoids reffing the buffer */
  if (!pads->next) {
    GstPad *pad = GST_PAD_CAST (pads->data);

    /* Keep another ref around, a pad probe
     * might release and destroy the pad */
    gst_object_ref (pad);
    GST_OBJECT_UNLOCK (tee);

    if (pad == tee->pull_pad) {
      ret = GST_FLOW_OK;
    } else if (is_list) {
      ret = gst_pad_push_list (pad, GST_BUFFER_LIST_CAST (data));
    } else {
      ret = gst_pad_push (pad, GST_BUFFER_CAST (data));
    }

    gst_object_unref (pad);

    return ret;
  }

  /* mark all pads as 'not pushed on yet' */
  g_list_foreach (pads, (GFunc) clear_pads, tee);

restart:
  cret = GST_FLOW_NOT_LINKED;
  pads = GST_ELEMENT_CAST (tee)->srcpads;
  cookie = GST_ELEMENT_CAST (tee)->pads_cookie;

  while (pads) {
    GstPad *pad;

    pad = GST_PAD_CAST (pads->data);

    if (G_LIKELY (!GST_TEE_PAD_CAST (pad)->pushed)) {
      /* not yet pushed, release lock and start pushing */
      gst_object_ref (pad);
      GST_OBJECT_UNLOCK (tee);

      GST_LOG_OBJECT (pad, "Starting to push %s %p",
          is_list ? "list" : "buffer", data);

      ret = gst_tee_do_push (tee, pad, data, is_list);

      GST_LOG_OBJECT (pad, "Pushing item %p yielded result %s", data,
          gst_flow_get_name (ret));

      GST_OBJECT_LOCK (tee);
      /* keep track of which pad we pushed and the result value */
      GST_TEE_PAD_CAST (pad)->pushed = TRUE;
      GST_TEE_PAD_CAST (pad)->result = ret;
      gst_object_unref (pad);
    } else {
      /* already pushed, use previous return value */
      ret = GST_TEE_PAD_CAST (pad)->result;
      GST_LOG_OBJECT (pad, "pad already pushed with %s",
          gst_flow_get_name (ret));
    }

    /* before we go combining the return value, check if the pad list is still
     * the same. It could be possible that the pad we just pushed was removed
     * and the return value it not valid anymore */
    if (G_UNLIKELY (GST_ELEMENT_CAST (tee)->pads_cookie != cookie)) {
      GST_LOG_OBJECT (pad, "pad list changed");
      /* the list of pads changed, restart iteration. Pads that we already
       * pushed on and are still in the new list, will not be pushed on
       * again. */
      goto restart;
    }

    /* stop pushing more buffers when we have a fatal error */
    if (G_UNLIKELY (ret != GST_FLOW_OK && ret != GST_FLOW_NOT_LINKED))
      goto error;

    /* keep all other return values, overwriting the previous one. */
    if (G_LIKELY (ret != GST_FLOW_NOT_LINKED)) {
      GST_LOG_OBJECT (pad, "Replacing ret val %d with %d", cret, ret);
      cret = ret;
    }
    pads = g_list_next (pads);
  }
  GST_OBJECT_UNLOCK (tee);

  gst_mini_object_unref (GST_MINI_OBJECT_CAST (data));

  /* no need to unset gvalue */
  return cret;

  /* ERRORS */
no_pads:
  {
    GST_DEBUG_OBJECT (tee, "there are no pads, return not-linked");
    ret = GST_FLOW_NOT_LINKED;
    goto error;
  }
error:
  {
    GST_DEBUG_OBJECT (tee, "received error %s", gst_flow_get_name (ret));
    GST_OBJECT_UNLOCK (tee);
    gst_mini_object_unref (GST_MINI_OBJECT_CAST (data));
    return ret;
  }
}

static GstFlowReturn
gst_tee_chain (GstPad * pad, GstObject * parent, GstBuffer * buffer)
{
  GstFlowReturn res;
  GstTee *tee;

  tee = GST_TEE_CAST (parent);

  GST_DEBUG_OBJECT (tee, "received buffer %p", buffer);

  res = gst_tee_handle_data (tee, buffer, FALSE);

  GST_DEBUG_OBJECT (tee, "handled buffer %s", gst_flow_get_name (res));

  return res;
}

static GstFlowReturn
gst_tee_chain_list (GstPad * pad, GstObject * parent, GstBufferList * list)
{
  GstFlowReturn res;
  GstTee *tee;

  tee = GST_TEE_CAST (parent);

  GST_DEBUG_OBJECT (tee, "received list %p", list);

  res = gst_tee_handle_data (tee, list, TRUE);

  GST_DEBUG_OBJECT (tee, "handled list %s", gst_flow_get_name (res));

  return res;
}

static gboolean
gst_tee_sink_activate_mode (GstPad * pad, GstObject * parent, GstPadMode mode,
    gboolean active)
{
  gboolean res;
  GstTee *tee;

  tee = GST_TEE (parent);

  switch (mode) {
    case GST_PAD_MODE_PUSH:
    {
      GST_OBJECT_LOCK (tee);
      tee->sink_mode = active ? mode : GST_PAD_MODE_NONE;

      if (active && !tee->has_chain)
        goto no_chain;
      GST_OBJECT_UNLOCK (tee);
      res = TRUE;
      break;
    }
    default:
      res = FALSE;
      break;
  }
  return res;

  /* ERRORS */
no_chain:
  {
    GST_OBJECT_UNLOCK (tee);
    GST_INFO_OBJECT (tee,
        "Tee cannot operate in push mode with has-chain==FALSE");
    return FALSE;
  }
}

static gboolean
gst_tee_src_activate_mode (GstPad * pad, GstObject * parent, GstPadMode mode,
    gboolean active)
{
  GstTee *tee;
  gboolean res;
  GstPad *sinkpad;

  tee = GST_TEE (parent);

  switch (mode) {
    case GST_PAD_MODE_PULL:
    {
      GST_OBJECT_LOCK (tee);

      if (tee->pull_mode == GST_TEE_PULL_MODE_NEVER)
        goto cannot_pull;

      if (tee->pull_mode == GST_TEE_PULL_MODE_SINGLE && active && tee->pull_pad)
        goto cannot_pull_multiple_srcs;

      sinkpad = gst_object_ref (tee->sinkpad);

      GST_OBJECT_UNLOCK (tee);

      res = gst_pad_activate_mode (sinkpad, GST_PAD_MODE_PULL, active);
      gst_object_unref (sinkpad);

      if (!res)
        goto sink_activate_failed;

      GST_OBJECT_LOCK (tee);
      if (active) {
        if (tee->pull_mode == GST_TEE_PULL_MODE_SINGLE)
          tee->pull_pad = pad;
      } else {
        if (pad == tee->pull_pad)
          tee->pull_pad = NULL;
      }
      tee->sink_mode = (active ? GST_PAD_MODE_PULL : GST_PAD_MODE_NONE);
      GST_OBJECT_UNLOCK (tee);
      break;
    }
    default:
      res = TRUE;
      break;
  }

  return res;

  /* ERRORS */
cannot_pull:
  {
    GST_OBJECT_UNLOCK (tee);
    GST_INFO_OBJECT (tee, "Cannot activate in pull mode, pull-mode "
        "set to NEVER");
    return FALSE;
  }
cannot_pull_multiple_srcs:
  {
    GST_OBJECT_UNLOCK (tee);
    GST_INFO_OBJECT (tee, "Cannot activate multiple src pads in pull mode, "
        "pull-mode set to SINGLE");
    return FALSE;
  }
sink_activate_failed:
  {
    GST_INFO_OBJECT (tee, "Failed to %sactivate sink pad in pull mode",
        active ? "" : "de");
    return FALSE;
  }
}

static gboolean
gst_tee_src_query (GstPad * pad, GstObject * parent, GstQuery * query)
{
  GstTee *tee;
  gboolean res;
  GstPad *sinkpad;

  tee = GST_TEE (parent);

  switch (GST_QUERY_TYPE (query)) {
    case GST_QUERY_SCHEDULING:
    {
      gboolean pull_mode;

      GST_OBJECT_LOCK (tee);
      pull_mode = TRUE;
      if (tee->pull_mode == GST_TEE_PULL_MODE_NEVER) {
        GST_INFO_OBJECT (tee, "Cannot activate in pull mode, pull-mode "
            "set to NEVER");
        pull_mode = FALSE;
      } else if (tee->pull_mode == GST_TEE_PULL_MODE_SINGLE && tee->pull_pad) {
        GST_INFO_OBJECT (tee, "Cannot activate multiple src pads in pull mode, "
            "pull-mode set to SINGLE");
        pull_mode = FALSE;
      }

      sinkpad = gst_object_ref (tee->sinkpad);
      GST_OBJECT_UNLOCK (tee);

      if (pull_mode) {
        /* ask peer if we can operate in pull mode */
        res = gst_pad_peer_query (sinkpad, query);
      } else {
        res = TRUE;
      }
      gst_object_unref (sinkpad);
      break;
    }
    default:
      res = gst_pad_query_default (pad, parent, query);
      break;
  }

  return res;
}

static void
gst_tee_push_eos (const GValue * vpad, GstTee * tee)
{
  GstPad *pad = g_value_get_object (vpad);

  if (pad != tee->pull_pad)
    gst_pad_push_event (pad, gst_event_new_eos ());
}

static void
gst_tee_pull_eos (GstTee * tee)
{
  GstIterator *iter;

  iter = gst_element_iterate_src_pads (GST_ELEMENT (tee));
  gst_iterator_foreach (iter, (GstIteratorForeachFunction) gst_tee_push_eos,
      tee);
  gst_iterator_free (iter);
}

static GstFlowReturn
gst_tee_src_get_range (GstPad * pad, GstObject * parent, guint64 offset,
    guint length, GstBuffer ** buf)
{
  GstTee *tee;
  GstFlowReturn ret;

  tee = GST_TEE (parent);

  ret = gst_pad_pull_range (tee->sinkpad, offset, length, buf);

  if (ret == GST_FLOW_OK)
    ret = gst_tee_handle_data (tee, gst_buffer_ref (*buf), FALSE);
  else if (ret == GST_FLOW_EOS)
    gst_tee_pull_eos (tee);

  return ret;
}
